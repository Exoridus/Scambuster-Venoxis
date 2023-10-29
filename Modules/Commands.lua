local AddonName, Addon = ...;
local AceLocale = LibStub("AceLocale-3.0");
local Utils = Addon:GetModule("Utils");
local Config = Addon:GetModule("Config");
local Blocklist = Addon:GetModule("Blocklist");
local Commands = Addon:NewModule("Commands", "AceConsole-3.0");
local L = AceLocale:GetLocale(AddonName);
local select, ipairs, tconcat = select, ipairs, table.concat;
local format, tinsert = format, tinsert;
local UnitFactionGroup = UnitFactionGroup;
local UnitIsPlayer = UnitIsPlayer;
local UnitGUID = UnitGUID;
local UnitName = UnitName;
local GetValuesArray = GetValuesArray;
local NewTicker = C_Timer.NewTicker;
local NAME_CHANGE_COMPARE = "Alter Name: %s|nNeuer Name: %s";

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
  local players = Utils:GetUniquePlayers(entries);
  local length = #players;
  local index = 1;
  local output = {};

  Utils:PrintAddonMessage(L["CHECK_STARTED"], length, length * 2);

  NewTicker(2, function()
    local player = players[index];
    local playerIndex = index;

    if index % 10 == 0 then
      Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], index, length)));
    end

    Utils:FetchPlayerInfoByGUID(player.guid, function(info)
      if info then
        if player.name ~= info.name then
          if #output > 0 then
            tinsert(output, "");
          end
          tinsert(output, format("[%s]", info.guid));
          tinsert(output, format(NAME_CHANGE_COMPARE, player.name, info.name));
        end
      else
        Utils:PrintWarning(format(L["UNKNOWN_GUID"], player.guid));
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

local function getFailedNames(players, callback)
  local length = #players;
  local index = 1;
  local failed = {};

  Utils:DisableNotifications();

  Utils:CleanupFriendList();

  NewTicker(2, function()
    local player = players[index];
    local playerIndex = index;

    if index % 10 == 0 then
      Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], index, length)));
    end

    Utils:FetchGUIDByName(player.name, function(info)
      if not info then
        tinsert(failed, player);
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
  local function FilterPredicate(player)
    return player.faction == playerFaction;
  end
  local players = tFilter(Utils:GetUniquePlayers(entries), FilterPredicate, true);
  local numEntries = #players;

  getFailedNames(players, function(failed)
    if #failed == 0 then
      Utils:PrintAddonMessage(L["NO_BANNED_ENTRIES"]);
      return;
    end

    local length = #failed;
    local index = 1;
    local banned = {};

    NewTicker(2, function()
      local player = failed[index];
      local playerIndex = index;

      Utils:FetchPlayerInfoByGUID(player.guid, function(info)
        if info then
          tinsert(banned, format(L["BANNED_ENTRY"], #banned + 1, info.name, info.guid));
        end

        if playerIndex == length then
          Utils:PrintAddonMessage(L["CHECK_FINISHED"], numEntries);

          if #banned > 0 then
            Utils:CreateCopyDialog(tconcat(banned, "\n"), 480, 320, true);
          end
        end
      end);

      index = index + 1;
    end, length);
  end);
end

local SLASH_COMMANDS = { "venoxis", "v", "sbv" };

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
