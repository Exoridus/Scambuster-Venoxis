local AddonName, Addon = ...;
local AceLocale = LibStub("AceLocale-3.0");
local SlashCommands = Addon:NewModule("SlashCommands", "AceConsole-3.0");
local Blocklist = Addon:GetModule("Blocklist");
local Utils = Addon:GetModule("Utils");
local Config = Addon:GetModule("Config");
local L = AceLocale:GetLocale(AddonName);

function SlashCommands:OnInitialize()
  self:RegisterChatCommand("venoxis", "OnChatCommand");
end

function SlashCommands:OnChatCommand(input)
  local arg1, arg2, arg3 = self:GetArgs(input, 3);

  if arg1 == "config" then
    return self:RunConfigCommand();
  elseif arg1 == "print" and arg2 then
    return self:RunPrintCommand(arg2);
  elseif arg1 == "report" and arg2 then
    return self:RunReportCommand(arg2, arg3);
  elseif arg1 == "search" and arg2 then
    return self:RunSearchCommand(arg2);
  elseif arg1 == "dump" then
    return self:RunDumpCommand();
  elseif arg1 == "check" then
    return self:RunCheckCommand();
  else
    return self:PrintCommands();
  end
end

function SlashCommands:PrintCommands()
  Utils:PrintAddonMessage(L["AVAILABLE_COMMANDS"]);
  Utils:PrintCommand("/venoxis print <name>", L["PRINT_COMMAND"]);
  Utils:PrintCommand("/venoxis report <name>", L["REPORT_COMMAND"]);
  Utils:PrintCommand("/venoxis search <name>", L["SEARCH_COMMAND"]);
  Utils:PrintCommand("/venoxis config", L["CONFIG_COMMAND"]);
end

function SlashCommands:RunConfigCommand()
  Config:OpenOptionsFrame();
end

function SlashCommands:RunPrintCommand(name)
  Utils:AddChatFilter();

  Utils:FetchPlayerInfo(name, function(info)
    if info then
      Utils:PrintPlayerInfo(info);
    else
      Utils:PrintPlayerNotFoundInfo(name);
    end

    Utils:RemoveChatFilter();
  end);
end

function SlashCommands:RunReportCommand(name, index)
  if type(index) == "string" then
    index = tonumber(index);
  end

  if type(index) ~= "number" then
    index = #Blocklist.Entries + 1;
  end

  Utils:AddChatFilter();

  Utils:FetchPlayerInfo(name, function(info)
    if info then
      Utils:ReportPlayerInfo(info, index);
    else
      Utils:PrintPlayerNotFoundInfo(name);
    end

    Utils:RemoveChatFilter();
  end);
end

function SlashCommands:RunSearchCommand(name)
  local blocklist = Utils:GetEntriesByPlayerName(Blocklist.Entries, name);

  if (#blocklist) == 0 then
    Utils:PrintAddonMessage(L["NO_BLOCKLIST_ENTRIES"], name);
    return;
  end

  if #blocklist > 0 then
    Utils:PrintAddonMessage(L["FOUND_BLOCKLIST_ENTRIES"], #blocklist, name);

    for index, entry in ipairs(blocklist) do
      Utils:PrintTitle(format("Entry %d", index));
      Utils:PrintKeyValue(DESCRIPTION, entry.description);
      Utils:PrintKeyValue("URL", entry.url);
    end
  end
end

function SlashCommands:RunDumpCommand()
  local output = {};
  local index = 1;

  sort(Blocklist.Entries, function(a, b)
    return (a.name or a.players[1].name) < (b.name or b.players[1].name);
  end);

  tinsert(output, "Blocklist.Entries = {");

  for _, entry in ipairs(Blocklist.Entries) do
    tinsert(output, Utils:FormatListItemEntry(index, entry));
    index = index + 1;
  end

  tinsert(output, "};");

  Utils:CreateCopyDialog(table.concat(output, "\n"), 800, 480);
end

function SlashCommands:RunCheckCommand()
  local guids = {};
  local players = {};

  for _, entry in pairs(Blocklist.Entries) do
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
        Utils:PrintAddonMessage(L["CHECK_FINISHED"], 0);
      end
    end);

    index = index + 1;
  end, length);
end