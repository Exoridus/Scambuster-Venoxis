local AddonName, Addon = ...;
local AceLocale = LibStub("AceLocale-3.0");
local Utils = Addon:GetModule("Utils");
local Config = Addon:GetModule("Config");
local Blocklist = Addon:GetModule("Blocklist");
local Commands = Addon:NewModule("Commands", "AceConsole-3.0");
local L = AceLocale:GetLocale(AddonName);
local select, ipairs, tconcat = select, ipairs, table.concat;
local format, unpack, tinsert = format, unpack, tinsert;
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

    Utils:FetchPlayerInfoByName(name, function(info)
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

    Utils:FetchPlayerInfoByGUID(playerGUID, function(info)
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

  tinsert(output, "Blocklist.Entries = {");

  for i, entry in ipairs(entries) do
    tinsert(output, Utils:FormatListItemEntry(i, entry));
  end

  tinsert(output, "};");

  Utils:CreateCopyDialog(tconcat(output, "\n"), 800, 600, true);
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

    if index == 1 or index == length or index % 10 == 0 then
      Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], guid, index, length)));
    end

    Utils:FetchPlayerInfoByGUID(guid, function(info)
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
    local playerName = names[guid];
    local playerIndex = index;

    Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], playerName, index, length)));

    Utils:FetchGUIDByName(playerName, function(info)
      if not info then
        tinsert(failed, { guid, playerName });
      end

      if playerIndex == length then
        Utils:EnableNotifications();
        callback(failed);
      end
    end);

    index = index + 1;
  end, length);
end

local function checkBannedEntries(entries)
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
      Utils:PrintAddonMessage(L["NO_BANNED_ENTRIES"]);
      return;
    end

    local length = #failed;
    local index = 1;
    local banned = 0;
    local output = {};

    NewTicker(2, function()
      local guid, name = unpack(failed[index]);
      local playerIndex = index;

      Utils:FetchPlayerInfoByGUID(guid, function(info)
        if info and info.guid == guid then
          banned = banned + 1;
          Utils:PrintTitle(format(L["PLAYER_WAS_BANNED"], name, guid));
          tinsert(output, format("%2d. %s (%s)", banned, name, guid));
        end

        if playerIndex == length then
          Utils:PrintAddonMessage(L["CHECK_FINISHED"], length);

          if #output > 0 then
            Utils:CreateCopyDialog(tconcat(output, "\n"), 480, 320, true);
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
  elseif command == "banned" then
    return checkBannedEntries(Blocklist.Entries);
  elseif command == "version" then
    Utils:PrintAddonVersion();
  else
    Utils:PrintSlashCommands();
  end
end
