local AddonName, Addon = ...;
local AceLocale = LibStub("AceLocale-3.0");
local SlashCommands = Addon:NewModule("SlashCommands", "AceConsole-3.0");
local Blocklist = Addon:GetModule("Blocklist");
local Checklist = Addon:GetModule("Checklist");
local Utils = Addon:GetModule("Utils");
local Config = Addon:GetModule("Config");
local L = AceLocale:GetLocale(AddonName);

function SlashCommands:OnInitialize()
  self:RegisterChatCommand("venoxis", "OnChatCommand");
end

function SlashCommands:OnChatCommand(input)
  local arg1, arg2 = self:GetArgs(input, 2);

  if arg1 == "config" then
    return self:RunConfigCommand();
  elseif arg1 == "print" and arg2 then
    return self:RunPrintCommand(arg2);
  elseif arg1 == "report" and arg2 then
    return self:RunReportCommand(arg2);
  elseif arg1 == "search" and arg2 then
    return self:RunSearchCommand(arg2);
  elseif arg1 == "dump" then
    return self:RunDumpCommand(arg2);
  elseif arg1 == "check" then
    return self:RunCheckCommand(arg2);
  else
    return self:PrintCommands();
  end
end

function SlashCommands:PrintCommands()
  Utils:PrintAddonMessage(L["AVAILABLE_COMMANDS"]);
  Utils:PrintCommand("/venoxis print <name>", L["PRINT_COMMAND"]);
  Utils:PrintCommand("/venoxis report <name>", L["REPORT_COMMAND"]);
  Utils:PrintCommand("/venoxis search <name>", L["SEARCH_COMMAND"]);
  Utils:PrintCommand("/venoxis dump [blocklist|checklist]", L["DUMP_COMMAND"]);
  Utils:PrintCommand("/venoxis config", L["CONFIG_COMMAND"]);
end

function SlashCommands:RunConfigCommand()
  Config:OpenOptionsFrame();
end

function SlashCommands:RunPrintCommand(name)
  Utils:AddChatFilter();

  Utils:FetchPlayerInfo(name, function(info)
    if info then
      Utils:PrintPlayerInfoInChat(info);
    else
      Utils:PrintPlayerNotFoundInfo(name);
    end

    Utils:RemoveChatFilter();
  end);
end

function SlashCommands:RunReportCommand(name)
  Utils:AddChatFilter();

  Utils:FetchPlayerInfo(name, function(info)
    if info then
      Utils:OpenPlayerInfoReportWindow(info);
    else
      Utils:PrintPlayerNotFoundInfo(name);
    end

    Utils:RemoveChatFilter();
  end);
end

function SlashCommands:RunSearchCommand(name)
  local blocklist = Utils:GetEntriesByPlayerName(Blocklist.GetEntries(), name, true);
  local checklist = Utils:GetEntriesByPlayerName(Checklist.GetEntries(), name, true);

  if (#blocklist + #checklist) == 0 then
    Utils:PrintAddonMessage(L["NO_BLOCKLIST_ENTRIES"], name);
    return;
  end

  if #blocklist > 0 then
    Utils:PrintAddonMessage(L["FOUND_BLOCKLIST_ENTRIES"], #blocklist, name);

    for index, entry in ipairs(blocklist) do
      Utils:PrintTitle(format("Entry %d", index));
      Utils:PrintKeyValue("Description", entry.description);
      Utils:PrintKeyValue("URL", entry.url);
    end
  end

  if #checklist > 0 then
    Utils:PrintAddonMessage(L["FOUND_CHECKLIST_ENTRIES"], name);

    for index, entry in ipairs(checklist) do
      Utils:PrintTitle(format("Entry %d", index));
      Utils:PrintKeyValue("Description", entry.description);
      Utils:PrintKeyValue("URL", entry.url);
    end
  end
end

function SlashCommands:RunDumpCommand(list)
  local search = ("^%s"):format(strtrim(tostring(list)):lower());

  if ("blocklist"):match(search) then
    Utils:DumpList(Blocklist);
  elseif ("checklist"):match(search) then
    Utils:DumpList(Checklist);
  else
    self:PrintCommands();
  end
end

function SlashCommands:RunCheckCommand()
  local length = Checklist.GetCount();
  local index = 1;
  local matches = 0;

  Utils:AddChatFilter();
  Utils:PrintAddonMessage(L["CHECKLIST_SEARCH_STARTED"], length * 3);

  C_Timer.NewTicker(3, function()
    local item = Checklist.GetEntry(index);
    local playerIndex = index;
    local playerName = item.name;

    Utils:Print(L["CHECKLIST_CHECK_PLAYER"], playerName);

    Utils:FetchPlayerInfo(playerName, function(info)
      if info then
        Utils:PrintTitle(format(L["CHECKLIST_NEW_MATCH"], playerName, playerIndex));
        Utils:PrintPlayerInfoInChat(info);
        matches = matches + 1;
      else
        Utils:Print(L["CHECKLIST_NO_MATCH"], playerName);
      end

      if playerIndex == length then
        Utils:PrintAddonMessage(L["CHECKLIST_SEARCH_FINISHED"], matches);
        Utils:RemoveChatFilter();
      end
    end);

    index = index + 1;
  end, length);
end