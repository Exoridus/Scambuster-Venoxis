local Addon = select(2, ...);
local SlashCommands = Addon:NewModule("SlashCommands", "AceConsole-3.0");
local Blocklist = Addon:GetModule("Blocklist");
local Checklist = Addon:GetModule("Checklist");
local Utils = Addon:GetModule("Utils");

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

function SlashCommands:PrintInfo(text, ...)
  local chatFrame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME;

  if select('#', ...) > 0 then
    self:Printf(chatFrame, text, ...);
  else
    self:Print(chatFrame, text);
  end
end

function SlashCommands:PrintHelp()
  self:PrintInfo("/venoxis print NAME (prints character data into your current chat frame)");
  self:PrintInfo("/venoxis report NAME (prints character data as a lua compatible blocklist entry)");
  self:PrintInfo("/venoxis search NAME (searches blocklist entries for matching player names)");
  self:PrintInfo("/venoxis check (searches checklist entries for existing players)");
end

function SlashCommands:PrintPlayerNotFoundInfo(name)
  self:PrintInfo("Failed requesting GUID for \"%s\". Possible reasons:", name);
  self:PrintInfo("1. The character name is misspelled and contains typos.");
  self:PrintInfo("2. The character is on the opposite faction as you.");
  self:PrintInfo("3. The character was renamed, deleted or transferred.");
  self:PrintInfo("4. Your friends list is full and cannot add more players.");
end

function SlashCommands:PrintPlayerInfoInChat(info)
  if info.realm ~= GetRealmName() then
    self:PrintInfo("CAUTION: GUID matches player from another realm (%s).", info.realm);
  end

  self:PrintInfo("%s: %s", NAME, info.name);
  self:PrintInfo("GUID: %s", info.guid);
  if info.level > 0 then
    self:PrintInfo("%s: %s", LEVEL, info.level);
  end
  self:PrintInfo("%s: %s", RACE, info.raceName);
  self:PrintInfo("%s: %s", CLASS, WrapTextInColor(info.className, GetClassColorObj(info.class)));
  self:PrintInfo("%s: %s", FACTION, WrapTextInColor(info.factionName, GetFactionColor(info.faction)));
end

function SlashCommands:PrintPlayerInfoInEditWindow(info)
  if info.realm ~= GetRealmName() then
    self:PrintInfo("CAUTION: GUID matches player from another realm (%s).", info.realm);
  end

  local reportText = Utils:FormatReportByPlayerInfo(Blocklist.GetCount() + 1, info);

  Utils:OpenTextInEditWindow(reportText);
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
    self:PrintInfo("No entries found on player %s", name);
    return;
  end

  self:PrintInfo("Found %d entries on player %s:", #list, name);

  for i, v in ipairs(list) do
    self:PrintInfo("Case #%d: %s", i, v);
  end
end

function SlashCommands:CheckCommand()
  local length = Checklist.GetCount();
  local index = 1;

  C_Timer.NewTicker(3, function()
    local item = Checklist.GetItem(index);

    Utils:FetchPlayerInfo(item.name, function(info)
      if info then
        self:PrintInfo("Found checklist player %s on index %d:", info.name, index);
        for k, v in pairs(item) do
          self:PrintInfo("%s: %s", k, v);
        end
        self:PrintInfo("Fetched player info:");
        self:PrintPlayerInfoInChat(info);
      end
    end);

    if index > length then
      self:PrintInfo("Checklist finished.");
    end

    index = index + 1;
  end, length);
end

function SlashCommands:DumpBlocklistCommand()
  local names = Blocklist.GetSortedNames();
  local lines = {};

  for index, name in ipairs(names) do
    tinsert(lines, Utils:FormatReportByCase(index, Blocklist.GetItemByName(name)))
  end;

  Utils:OpenTextInEditWindow(table.concat(lines, "\n"));
end

function SlashCommands:DumpChecklistCommand()
  local names = Checklist.GetSortedNames();
  local lines = {};

  for index, name in ipairs(names) do
    tinsert(lines, Utils:FormatReportByCase(index, Checklist.GetItemByName(name)))
  end;

  Utils:OpenTextInEditWindow(table.concat(lines, "\n"));
end