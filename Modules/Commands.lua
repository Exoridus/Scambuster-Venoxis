local AddonName, Addon = ...;
local AceLocale = LibStub("AceLocale-3.0");
local Commands = Addon:NewModule("Commands", "AceConsole-3.0");
local Blocklist = Addon:GetModule("Blocklist");
local Utils = Addon:GetModule("Utils");
local Config = Addon:GetModule("Config");
local L = AceLocale:GetLocale(AddonName);

function Commands:OnEnable()
  self:RegisterChatCommand("venoxis", "ChatCommand");
  self:RegisterChatCommand("sbv", "ChatCommand");
  self:RegisterChatCommand("sv", "ChatCommand");
end

function Commands:OnDisable()
  self:UnregisterChatCommand("venoxis");
  self:UnregisterChatCommand("sbv");
  self:UnregisterChatCommand("sv");
end

function Commands:ChatCommand(input)
  local arg1, arg2 = self:GetArgs(input, 2);

  if arg1 == "config" then
    Config:OpenOptionsFrame();
  elseif arg1 == "print" then
    self:PrintPlayer(arg2);
  elseif arg1 == "report" then
    self:ReportPlayer(arg2);
  elseif arg1 == "dump" then
    self:DumpEntries(Blocklist.Entries);
  elseif arg1 == "check" then
    self:CheckEntries(Blocklist.Entries);
  else
    self:PrintCommands();
  end
end

function Commands:PrintPlayerNotFoundInfo(name)
  Utils:PrintAddonMessage(L["PLAYER_NOT_FOUND_TITLE"], name);
  Utils:Print(L["PLAYER_NOT_FOUND_REASON_1"]);
  Utils:Print(L["PLAYER_NOT_FOUND_REASON_2"]);
  Utils:Print(L["PLAYER_NOT_FOUND_REASON_3"]);
  Utils:Print(L["PLAYER_NOT_FOUND_REASON_4"]);
end

function Commands:PrintCommands()
  Utils:PrintAddonMessage(L["AVAILABLE_COMMANDS"]);
  Utils:PrintCommand("/venoxis print", L["PRINT_COMMAND_1"]);
  Utils:PrintCommand("/venoxis print <name>", L["PRINT_COMMAND_2"]);
  Utils:PrintCommand("/venoxis report", L["REPORT_COMMAND_1"]);
  Utils:PrintCommand("/venoxis report <name>", L["REPORT_COMMAND_2"]);
  Utils:PrintCommand("/venoxis config", L["CONFIG_COMMAND"]);
end

function Commands:PrintPlayer(name)
  if (name == nil or name == "" or name == "target") and UnitIsPlayer("target") then
    name = UnitName("target");
  end

  if not name then
    Utils:PrintAddonMessage(L["ENTER_PLAYER_NAME"])
    return;
  end

  Utils:FetchPlayerInfo(name, function(info)
    if info then
      for _, prop in ipairs(Utils:GetPlayerInfoProps(info)) do
        Utils:PrintKeyValue(prop.key, prop.value);
      end
    else
      self:PrintPlayerNotFoundInfo(name);
    end
  end);
end

function Commands:ReportPlayer(name)
  if (name == nil or name == "" or name == "target") and UnitIsPlayer("target") then
    name = UnitName("target");
  end

  if not name then
    Utils:PrintAddonMessage(L["ENTER_PLAYER_NAME"])
    return;
  end

  Utils:FetchPlayerInfo(name, function(info)
    if info then
      local lines = {};

      for _, prop in ipairs(Utils:GetPlayerInfoProps(info)) do
        tinsert(lines, format("%s: %s", prop.key, prop.value));
      end

      Utils:CreateCopyDialog(table.concat(lines, "\n"), 640, 480);
    else
      self:PrintPlayerNotFoundInfo(name);
    end
  end);
end

function Commands:DumpEntries(entries)
  local output = {};
  local index = 1;

  sort(entries, function(a, b)
    return (a.name or a.players[1].name) < (b.name or b.players[1].name);
  end);

  tinsert(output, "Blocklist.Entries = {");

  for _, entry in ipairs(entries) do
    tinsert(output, Utils:FormatListItemEntry(index, entry));
    index = index + 1;
  end

  tinsert(output, "};");

  Utils:CreateCopyDialog(table.concat(output, "\n"), 800, 480);
end

function Commands:CheckEntries(entries)
  local guids = {};
  local players = {};

  for _, entry in pairs(entries) do
    if entry.players then
      for _, player in pairs(entry.players) do
        players[player.guid] = {
          names = player.aliases or {},
          class = player.class,
          faction = player.faction,
        };

        tInsertUnique(guids, player.guid);
        tInsertUnique(players[player.guid].names, player.name);
      end
    elseif entry.name then
      players[entry.guid] = {
        names = entry.aliases or {},
        class = entry.class,
        faction = entry.faction,
      };

      tInsertUnique(guids, entry.guid);
      tInsertUnique(players[entry.guid].names, entry.name);
    end
  end

  local length = #guids;
  local index = 1;

  C_Timer.NewTicker(2, function()
    local guid = guids[index];
    local player = players[guid];
    local playerIndex = index;

    Utils:FetchGUIDInfo(guid, function(info)
      if info and player then
        Utils:PrintTitle(format(L["CHECK_CHECKING_GUID"], tostring(info.guid)));

        if not tContains(player.names, info.name) then
          Utils:PrintTitle(L["CHECK_NAME_CHANGED"]);
          Utils:PrintKeyValue(NAME, info.name);
          Utils:PrintKeyValue(PREVIOUS, table.concat(player.names, ", "));
        end
        if player.class ~= info.class then
          Utils:PrintTitle(L["CHECK_CLASS_CHANGED"]);
          Utils:PrintKeyValue(CLASS, info.class);
          Utils:PrintKeyValue(PREVIOUS, player.class);
        end
        if player.faction ~= info.faction then
          Utils:PrintTitle(L["CHECK_FACTION_CHANGED"]);
          Utils:PrintKeyValue(FACTION, info.faction);
          Utils:PrintKeyValue(PREVIOUS, player.faction);
        end
      else
        Utils:PrintTitle(format(L["CHECK_UNKNOWN_GUID"], guid));
      end

      if playerIndex == length then
        Utils:PrintAddonMessage(L["CHECK_FINISHED"]);
      end
    end);

    index = index + 1;
  end, length);
end