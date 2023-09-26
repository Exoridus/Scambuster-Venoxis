local AddonName, Addon = ...;
local AceLocale = LibStub("AceLocale-3.0");
local Commands = Addon:NewModule("Commands", "AceConsole-3.0");
local Blocklist = Addon:GetModule("Blocklist");
local Utils = Addon:GetModule("Utils");
local Config = Addon:GetModule("Config");
local L = AceLocale:GetLocale(AddonName);
local select, ipairs, tconcat = select, ipairs, table.concat;
local strlower, format, unpack, sort, tinsert = strlower, format, unpack, sort, tinsert;
local UnitFactionGroup = UnitFactionGroup;
local UnitIsPlayer = UnitIsPlayer;
local UnitGUID = UnitGUID;
local UnitName = UnitName;
local GetKeysArray = GetKeysArray;
local NewTicker = C_Timer.NewTicker;

local function reportPlayers(type, ...)
  if select("#", ...) > 0 then
    local name = select(1, ...);

    Utils:DisableNotifications();

    Utils:FetchGUIDInfoByName(name, function(info)
      if not info then
        Utils:PrintPlayerNotFound(name);
      elseif type == "print" then
        Utils:PrintMultiline(Utils:FormatPlayerInfo(info));
      elseif type == "report" then
        Utils:CreateCopyDialog(Utils:FormatPlayerInfo(info));
      elseif type == "dump" then
        Utils:CreateCopyDialog(Utils:FormatPlayerEntry(info, #Blocklist.Entries + 1), 480, 320);
      end

      Utils:EnableNotifications();
    end);
  elseif UnitIsPlayer("target") then
    local playerGUID = UnitGUID("target");
    local playerName = UnitName("target");

    Utils:FetchGUIDInfo(playerGUID, function(info)
      if not info then
        Utils:PrintPlayerNotFound(playerName);
      elseif type == "print" then
        Utils:PrintMultiline(Utils:FormatPlayerInfo(info));
      elseif type == "report" then
        Utils:CreateCopyDialog(Utils:FormatPlayerInfo(info));
      elseif type == "dump" then
        Utils:CreateCopyDialog(Utils:FormatPlayerEntry(info, #Blocklist.Entries + 1), 480, 320);
      end
    end);
  else
    Utils:PrintAddonMessage(L["ENTER_PLAYER_NAME"]);
  end
end

local function dumpEntries(entries)
  local output = {};
  local index = 1;

  for _, entry in ipairs(entries) do
    if entry.players and #entry.players > 0 then
      sort(entry.players, function(a, b)
        return a.name < b.name;
      end)
    end
  end

  sort(entries, function(a, b)
    local nameA = a.name or (a.players and a.players[1].name);
    local nameB = b.name or (b.players and b.players[1].name);

    if nameA and nameB then
      return strlower(nameA) < strlower(nameB);
    end

    return not nameA;
  end);

  tinsert(output, "Blocklist.Entries = {");

  for _, entry in ipairs(entries) do
    tinsert(output, Utils:FormatListItemEntry(index, entry));
    index = index + 1;
  end

  tinsert(output, "};");

  Utils:CreateCopyDialog(tconcat(output, "\n"), 800, 600);
end

local function checkChangedEntries(entries)
  local players = {};

  for _, entry in ipairs(entries) do
    if entry.players and #entry.players > 0 then
      for _, player in ipairs(entry.players) do
        if not players[player.guid] then
          players[player.guid] = {
            name = player.name,
            class = player.class,
            faction = player.faction,
          };
        elseif players[player.guid].name ~= player.name then
          Utils:PrintWarning(format(L["FOUND_NAME_COLLISION"], player.guid, players[player.guid].name, player.name));
        end
      end
    elseif entry.name then
      if not players[entry.guid] then
        players[entry.guid] = {
          name = entry.name,
          class = entry.class,
          faction = entry.faction,
        };
      elseif players[entry.guid].name ~= entry.name then
        Utils:PrintWarning(format(L["FOUND_NAME_COLLISION"], entry.guid, players[entry.guid].name, entry.name));
      end
    end
  end

  local guids = GetKeysArray(players);
  local length = #guids;
  local index = 1;
  local output = {};

  Utils:PrintAddonMessage(L["CHECK_STARTED"], length, length * 2);

  NewTicker(2, function()
    local guid = guids[index];
    local player = players[guid];
    local playerIndex = index;

    Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], guid, index, length)));

    Utils:FetchGUIDInfo(guid, function(info)
      if info and player then
        local nameChanged = player.name ~= info.name;
        local classChanged = player.class ~= info.class;
        local factionChanged = player.faction ~= info.faction;
        local changeDetected = nameChanged or classChanged or factionChanged;

        if changeDetected then
          if #output > 0 then
            tinsert(output, "");
          end

          Utils:Print(Utils:SuccessText(format(L["CHANGE_FOUND"], info.guid)));
          tinsert(output, format("[%s]", info.guid));
        end

        if nameChanged then
          local changed = format(L["CHANGED_VALUE"], info.name, player.name);

          tinsert(output, format("%s: %s", L["NAME_CHANGE"], changed));
          Utils:PrintKeyValue(L["NAME_CHANGE"], changed);
        end

        if classChanged then
          local changed = format(L["CHANGED_VALUE"], info.class, player.class);

          tinsert(output, format("%s: %s", L["CLASS_CHANGE"], changed));
          Utils:PrintKeyValue(L["CLASS_CHANGE"], changed);
        end

        if factionChanged then
          local changed = format(L["CHANGED_VALUE"], info.faction, player.faction);

          tinsert(output, format("%s: %s", L["FACTION_CHANGE"], changed));
          Utils:PrintKeyValue(L["FACTION_CHANGE"], changed);
        end
      else
        Utils:PrintWarning(format(L["UNKNOWN_GUID"], guid));
      end

      if playerIndex == length then
        Utils:PrintAddonMessage(L["CHECK_FINISHED"], length);

        if #output > 0 then
          Utils:CreateCopyDialog(tconcat(output, "\n"));
        end
      end
    end);

    index = index + 1;
  end, length);
end

local function getFailedNames(names, callback)
  local guids = GetKeysArray(names);
  local length = #guids;
  local index = 1;
  local failed = {};

  Utils:DisableNotifications();

  NewTicker(2, function()
    local guid = guids[index];
    local player = names[guid];
    local playerIndex = index;

    Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], player, index, length)));

    Utils:FetchFriendInfo(player, function(info)
      if not info then
        tinsert(failed, { guid, player });
      end

      if playerIndex == length then
        Utils:EnableNotifications();
        callback(failed);
      end
    end);

    index = index + 1;
  end, length);
end

local function checkIgnoredEntries(entries)
  local playerFaction = UnitFactionGroup("player");
  local names = {};

  for _, entry in ipairs(entries) do
    if entry.players then
      for _, player in ipairs(entry.players) do
        if player.faction == playerFaction then
          if not names[player.guid] then
            names[player.guid] = player.name;
          elseif names[player.guid] ~= player.name then
            Utils:PrintWarning(format(L["FOUND_NAME_COLLISION"], player.guid, names[player.guid], player.name));
          end
        end
      end
    elseif entry.name and entry.faction == playerFaction then
      if not names[entry.guid] then
        names[entry.guid] = entry.name;
      elseif names[entry.guid] ~= entry.name then
        Utils:PrintWarning(format(L["FOUND_NAME_COLLISION"], entry.guid, names[entry.guid], entry.name));
      end
    end
  end

  getFailedNames(names, function(failed)
    if #failed == 0 then
      Utils:PrintAddonMessage("Finished search with no found ignores.");
      return;
    end

    local length = #failed;
    local index = 1;
    local ignores = 0;
    local output = {};

    NewTicker(2, function()
      local guid, name = unpack(failed[index]);
      local playerIndex = index;

      Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], guid, index, length)));

      Utils:FetchGUIDInfo(guid, function(info)
        if info and info.name == name then
          if #output > 0 then
            tinsert(output, "");
          end

          ignores = ignores + 1;
          Utils:PrintTitle(format("Player %s (%s) is ignoring you.", name, guid));
          tinsert(output, format("[%s]", guid));
          tinsert(output, format("%d. %s (%s)", ignores, name, guid));
          tinsert(output, format("%d. %s (%s)", ignores, name, guid));
        end

        if playerIndex == length then
          Utils:PrintAddonMessage(format("Finished search with %d found ignores.", ignores));

          if #output > 0 then
            Utils:CreateCopyDialog(tconcat(output, "\n"), 640, 480);
          end
        end
      end);

      index = index + 1;
    end, length);
  end);
end

local SLASH_COMMANDS = { "venoxis", "v", "scambuster-venoxis", "sbv" };

function Commands:OnEnable()
  for _, command in ipairs(SLASH_COMMANDS) do
    self:RegisterChatCommand(command, "OnSlashCommand");
  end
end

function Commands:OnDisable()
  for _, command in ipairs(SLASH_COMMANDS) do
    self:UnregisterChatCommand(command);
  end
end

function Commands:OnSlashCommand(input)
  self:RunSlashCommand(Utils:GetCommandArgs(input));
end

function Commands:RunSlashCommand(command, ...)
  if command == "config" then
    Config:OpenOptionsFrame(...);
  elseif command == "print" then
    return reportPlayers("print", ...);
  elseif command == "report" then
    return reportPlayers("report", ...);
  elseif command == "dump" then
    if select("#", ...) > 0 then
      return reportPlayers("dump", ...);
    else
      return dumpEntries(Blocklist.Entries);
    end
  elseif command == "check" then
    return checkChangedEntries(Blocklist.Entries);
  elseif command == "ignored" then
    return checkIgnoredEntries(Blocklist.Entries);
  elseif command == "version" then
    Utils:PrintAddonVersion();
  else
    Utils:PrintSlashCommands();
  end
end
