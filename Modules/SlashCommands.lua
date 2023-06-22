local _, Addon = ...;
local SlashCommands = Addon:NewModule("SlashCommands", "AceConsole-3.0");
local Blocklist = Addon:GetModule("Blocklist");
local Checklist = Addon:GetModule("Checklist");
local Utils = Addon:GetModule("Utils");

local offset = 0;

function SlashCommands:OnInitialize()
  self:RegisterChatCommand("venoxis", "OnChatCommand");
end

function SlashCommands:OnChatCommand(input)
  local action, param = self:GetArgs(input, 2);

  if action == "check"then
    self:CheckCommand();
  elseif action == "dump_blocklist"then
    self:DumpBlocklistCommand();
  elseif action == "dump_checklist"then
    self:DumpChecklistCommand();
  elseif action == "print" and param then
    self:PrintCommand(param);
  elseif action == "report" and param then
    self:ReportCommand(param);
  elseif action == "search" and param then
    self:SearchCommand(param);
  else
    self:PrintHelp();
  end
end

function SlashCommands:PrintHelp()
  Utils:PrintInfo("/venoxis print NAME (prints character data into your current chat frame)");
  Utils:PrintInfo("/venoxis report NAME (prints character data as a lua compatible blocklist entry)");
  Utils:PrintInfo("/venoxis search NAME (searches blocklist entries for matching player names)");
  Utils:PrintInfo("/venoxis check (searches checklist entries for existing players)");
end

function SlashCommands:PrintPlayerNotFoundInfo(name)
  Utils:PrintInfo("Failed requesting GUID for \"%s\". Possible reasons:", name);
  Utils:PrintInfo("1. The character name is misspelled and contains typos.");
  Utils:PrintInfo("2. The character is on the opposite faction as you.");
  Utils:PrintInfo("3. The character was renamed, deleted or transferred.");
  Utils:PrintInfo("4. Your friends list is full and cannot add more players.");
end

function SlashCommands:PrintPlayerInfoInChat(info)
  if info.realm ~= "Venoxis" then
    Utils:PrintInfo("CAUTION: GUID matches player from another realm (%s).", info.realm);
  end

  Utils:PrintInfo("%s: %s", NAME, info.name);
  Utils:PrintInfo("GUID: %s", info.guid);
  if info.level > 0 then
    Utils:PrintInfo("%s: %s", LEVEL, info.level);
  end
  Utils:PrintInfo("%s: %s", RACE, info.raceName);
  Utils:PrintInfo("%s: %s", CLASS, WrapTextInColor(info.className, GetClassColorObj(info.class)));
  Utils:PrintInfo("%s: %s", FACTION, WrapTextInColor(info.factionName, GetFactionColor(info.faction)));
end

function SlashCommands:PrintPlayerInfoInEditWindow(info)
  if info.realm ~= "Venoxis" then
    Utils:PrintInfo("CAUTION: GUID matches player from another realm (%s).", info.realm);
  end

  offset = offset + 1;

  local caseText = Utils:FormatReportByPlayerInfo(Blocklist.GetCount() + offset, info);

  Utils:OpenTextInEditWindow(caseText, 320, 250);
end

function SlashCommands:PrintCommand(name)
  Utils:FetchPlayerInfo(name, function(info)
    if info then
      self:PrintPlayerInfoInChat(info);
    else
      self:PrintPlayerNotFoundInfo(name);
    end
  end);
end

function SlashCommands:ReportCommand(name)
  Utils:FetchPlayerInfo(name, function(info)
    if info then
      self:PrintPlayerInfoInEditWindow(info);
    else
      self:PrintPlayerNotFoundInfo(name);
    end
  end);
end

function SlashCommands:SearchCommand(name)
  local list = Blocklist.FindPlayerCases(name);

  if #list == 0 then
    Utils:PrintInfo("No entries found on player %s", name);
    return;
  end

  Utils:PrintInfo("Found %d entries on player %s:", #list, name);

  for i, v in ipairs(list) do
    Utils:PrintInfo("Case #%d: %s", i, v);
  end
end

function SlashCommands:CheckCommand()
  local length = Checklist.GetCount();
  local index = 1;

  C_Timer.NewTicker(3, function()
    local item = Checklist.GetItem(index);

    Utils:FetchPlayerInfo(item.name, function(info)
      if info then
        Utils:PrintInfo("Found checklist player %s on index %d:", info.name, index);
        for k, v in pairs(item) do
          Utils:PrintInfo("%s: %s", k, v);
        end
        Utils:PrintInfo("Fetched player info:");
        self:PrintPlayerInfoInChat(info);
      end
    end);

    if index > length then
      Utils:PrintInfo("Checklist finished.");
    end

    index = index + 1;
  end, length);
end

function SlashCommands:DumpBlocklistCommand()
  Utils:DumpSortedList(Blocklist);
end

function SlashCommands:DumpChecklistCommand()
  Utils:DumpSortedList(Checklist);
end