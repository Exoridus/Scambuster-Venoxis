---@type AddonName, Addon
local _, Addon = ...;
local Utils = Addon:GetModule("Utils");
local Config = Addon:GetModule("Config");
local Blocklist = Addon:GetModule("Blocklist");
---@class Commands : AceModule, AceConsole-3.0
local Commands = Addon:NewModule("Commands", "AceConsole-3.0");
local L = Addon.L;
local select, ipairs, tconcat = select, ipairs, table.concat;
local format, tinsert = format, tinsert;
local UnitFactionGroup = UnitFactionGroup;
local UnitIsPlayer = UnitIsPlayer;

function Commands:OnInitialize()
  self.slashCommands = { "v", "sbv", "venoxis" };
  self.checkInProgress = false;
end

function Commands:OnEnable()
  for _, command in ipairs(self.slashCommands) do
    self:RegisterChatCommand(command, "OnSlashCommand");
  end
end

function Commands:OnDisable()
  for _, command in ipairs(self.slashCommands) do
    self:UnregisterChatCommand(command);
  end
end

function Commands:OnSlashCommand(input)
  local args = {};

  for match in gmatch(input, "[^%s%p]+") do
    if strlen(match or "") > 0 then
      tinsert(args, strlower(match));
    end
  end

  self:RunSlashCommand(unpack(args));
end

function Commands:RunSlashCommand(command, ...)
  if command == "config" then
    return Config:ToggleOptionsFrame();
  elseif command == "print" then
    return self:ReportPlayers("print", ...);
  elseif command == "report" then
    return self:ReportPlayers("report", ...);
  elseif command == "dump" then
    if select("#", ...) > 0 then
      return self:ReportPlayers("dump", ...);
    else
      return self:DumpEntries();
    end
  elseif command == "check" then
    return self:CheckChangedEntries();
  elseif command == "banned" then
    return self:CheckBannedEntries();
  elseif command == "version" then
    return self:PrintAddonVersion();
  else
    return self:PrintSlashCommands();
  end
end

function Commands:PrintAddonVersion()
  Utils:PrintAddonMessage(format("v%s", Utils:GetMetadata("Version")));
end

function Commands:PrintSlashCommands()
  Utils:PrintAddonMessage(L.AVAILABLE_COMMANDS);
  Utils:PrintMultiline(L.COMMANDS);
end

---@param type "print"|"report"|"dump"
---@param ... string
function Commands:ReportPlayers(type, ...)
  local name = (...) or (UnitIsPlayer("target") and UnitName("target")) or "";

  if not name or name == "" then
    Utils:PrintAddonMessage(L.ENTER_PLAYER_NAME);
    return;
  end

  Utils:FetchPlayerInfoByName(name, function(info)
    if not info then
      Utils:PrintMultiline(L.PLAYER_NOT_FOUND, name);
    elseif type == "dump" then
      Utils:CreateCopyDialog(format(L.PLAYER_ENTRY, info.name, info.guid, info.class, info.faction), 480, 320);
    else
      Utils:CreateCopyDialog(format(
        L.PLAYER_REPORT,
        info.name,
        info.guid,
        info.raceName,
        Utils:ClassColor(info.className, info.class),
        Utils:FactionColor(info.factionName, info.faction)
      ));
    end
  end);
end

function Commands:CheckChangedEntries()
  if self.checkInProgress then
    return;
  end
  self.checkInProgress = true;
  local players = Blocklist:GetUniquePlayers();
  local length = #players;
  local index = 1;
  local output = {};

  Utils:PrintStatus(L.CHECK_STARTED, length, length * 2);

  C_Timer.NewTicker(2, function()
    local player = players[index];
    local playerIndex = index;

    if index % 10 == 0 then
      Utils:PrintStatus(L.CHECK_PROGRESS, index, length);
    end

    Utils:FetchPlayerInfoByGUID(player.guid, function(info)
      if info then
        if player.name ~= info.name then
          if #output > 0 then
            tinsert(output, "");
          end
          tinsert(output, format("[%s]", info.guid));
          tinsert(output, format(L.NAME_CHANGE_COMPARE, player.name, info.name));
        end
      else
        Utils:PrintWarning(L.UNKNOWN_GUID, player.guid);
      end

      if playerIndex == length then
        Utils:PrintStatus(L.CHECK_FINISHED, length);
        self.checkInProgress = false;

        if #output > 0 then
          Utils:CreateCopyDialog(tconcat(output, "\n"));
        end
      end
    end);

    index = index + 1;
  end, length);
end

function Commands:CheckBannedEntries()
  if self.checkInProgress then
    return;
  end
  self.checkInProgress = true;
  local faction = UnitFactionGroup("player");
  local players = Blocklist:GetUniquePlayersByPredicate(function(player) return player.faction == faction end);
  local numEntries = #players;

  Utils:GetFailedNames(players, function(failed)
    if #failed == 0 then
      Utils:PrintStatus(L.NO_BANNED_ENTRIES);
      return;
    end

    local length = #failed;
    local index = 1;
    local banned = {};

    C_Timer.NewTicker(2, function()
      local player = failed[index];
      local playerIndex = index;

      Utils:FetchPlayerInfoByGUID(player.guid, function(info)
        if info then
          tinsert(banned, format(L.BANNED_ENTRY, #banned + 1, info.name, info.guid));
        end

        if playerIndex == length then
          Utils:PrintStatus(L.CHECK_FINISHED, numEntries);
          self.checkInProgress = false;

          if #banned > 0 then
            Utils:CreateCopyDialog(tconcat(banned, "\n"), 480, 320);
          end
        end
      end);

      index = index + 1;
    end, length);
  end);
end

function Commands:DumpEntries()
  local output = {};

  tinsert(output, "Blocklist.Entries = {");

  for i, entry in ipairs(Blocklist.Entries) do
    tinsert(output, Utils:FormatListItemEntry(i, entry));
  end

  tinsert(output, "};");

  Utils:CreateCopyDialog(tconcat(output, "\n"), 800, 600);
end
