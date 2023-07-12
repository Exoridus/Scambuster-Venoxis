local _, Addon = ...;
local SlashCommands = Addon:NewModule("SlashCommands", "AceConsole-3.0");
local Blocklist = Addon:GetModule("Blocklist");
local Checklist = Addon:GetModule("Checklist");
local Utils = Addon:GetModule("Utils");
local Color = Addon:GetModule("Color");
local Config = Addon:GetModule("Config");

function SlashCommands:OnInitialize()
  self:RegisterChatCommand("venoxis", "OnChatCommand");
end

function SlashCommands:OnChatCommand(input)
  local arg1, arg2, arg3 = self:GetArgs(input, 3);

  if arg1 == "print" and arg2 then
    return self:PrintCommand(arg2);
  elseif arg1 == "report" and arg2 then
    return self:ReportCommand(arg2, arg3);
  elseif arg1 == "search" and arg2 then
    return self:SearchCommand(arg2);
  elseif arg1 == "debug" then
    return self:DebugCommand(arg2);
  elseif arg1 == "dump" then
    return self:DumpCommand(arg2);
  elseif arg1 == "check" then
    return self:CheckCommand();
  else
    return self:PrintHelp();
  end
end

function SlashCommands:PrintHelp()
  Utils:Print("/venoxis help (prints this help text)");
  Utils:Print("/venoxis print NAME (prints character data into your current chat frame)");
  Utils:Print("/venoxis report NAME (prints character data as a lua compatible blocklist entry)");
  Utils:Print("/venoxis search NAME (searches blocklist entries for matching player names)");

  if Config:DebugMode() then
    Utils:Print("/venoxis debug [on|off] (prints the current debug mode or sets it to on/off)");
    Utils:Print("/venoxis dump [blocklist|checklist] (dumps the list entries sorted by player names)");
    Utils:Print("/venoxis check (searches checklist entries for existing players)");
  end
end

function SlashCommands:PrintPlayerNotFoundInfo(name)
  Utils:Print("Failed requesting GUID for \"%s\". Possible reasons:", name);
  Utils:Print("1. The character name is misspelled and contains typos.");
  Utils:Print("2. The character is on the opposite faction as you.");
  Utils:Print("3. The character was renamed, deleted or transferred.");
  Utils:Print("4. Your friends list is full and cannot add more players.");
end

function SlashCommands:PrintPlayerInfoInChat(info)
  if info.realm ~= "Venoxis" then
    Utils:Print("CAUTION: GUID matches player from another realm (%s).", info.realm);
  end

  Utils:Print("%s: %s", NAME, info.name);
  Utils:Print("GUID: %s", info.guid);

  if info.level > 0 then
    Utils:Print("%s: %s", LEVEL, info.level);
  end

  Utils:Print("%s: %s", RACE, info.raceName);
  Utils:Print("%s: %s", CLASS, Color:Class(info.className, info.class));
  Utils:Print("%s: %s", FACTION, Color:Faction(info.factionName, info.faction));
end

function SlashCommands:PrintPlayerInfoInEditWindow(info, index)
  if info.realm ~= "Venoxis" then
    Utils:Print("CAUTION: GUID matches player from another realm (%s).", info.realm);
  end

  if type(index) == "string" then
    index = tonumber(index);
  end

  if type(index) ~= "number" then
    index = Blocklist.GetCount() + 1;
  end

  Utils:OpenTextInEditWindow(Utils:FormatReportByPlayerInfo(index, info), 320, 250);
end

function SlashCommands:PrintCommand(name)
  Utils:AddChatFilter();

  Utils:FetchPlayerInfo(name, function(info)
    if info then
      self:PrintPlayerInfoInChat(info);
    else
      self:PrintPlayerNotFoundInfo(name);
    end

    Utils:RemoveChatFilter();
  end);
end

function SlashCommands:ReportCommand(name, index)
  Utils:AddChatFilter();

  Utils:FetchPlayerInfo(name, function(info)
    if info then
      self:PrintPlayerInfoInEditWindow(info, index);
    else
      self:PrintPlayerNotFoundInfo(name);
    end

    Utils:RemoveChatFilter();
  end);
end

function SlashCommands:SearchCommand(name)
  local list = Blocklist.FindPlayerCases(name);

  if #list == 0 then
    Utils:Print("No entries found on player %s", name);
    return;
  end

  Utils:Print("Found %d entries on player %s:", #list, name);

  for i, v in ipairs(list) do
    Utils:Print("Case #%d: %s", i, v);
  end
end

function SlashCommands:DebugCommand(state)
  if type(state) == "string" then
    if state == "toggle" then
      state = (not Config:DebugMode());
    else
      state = Utils:ParseBoolean(state);
    end
  end

  if type(state) == "boolean" then
    Config:DebugMode(state);
  end

  Utils:Print("Debug mode is now %s.", Config:DebugMode() and Color:Success("ENABLED") or Color:Error("DISABLED"));
end

function SlashCommands:CheckCommand()
  local length = Checklist.GetCount();
  local index = 1;

  Utils:AddChatFilter();

  C_Timer.NewTicker(3, function()
    local item = Checklist.GetEntry(index);
    local playerIndex = index;
    local playerName = item.name;

    Utils:PrintDebug("Checking player %s on index %d:", playerName, playerIndex);

    Utils:FetchPlayerInfo(playerName, function(info)
      if info then
        Utils:Print("Found player %s on index %d:", info.name, playerIndex);
        self:PrintPlayerInfoInChat(info);
      else
        Utils:PrintDebug("Player %s could not be found.", playerName, playerIndex);
      end

      if playerIndex == length then
        Utils:Print("Checklist finished.");
        Utils:RemoveChatFilter();
      end
    end);

    index = index + 1;
  end, length);
end

local BLOCKLIST_NAMES = { "b", "block", "blocklist" };
local CHECKLIST_NAMES = { "c", "check", "checklist" };

function SlashCommands:DumpCommand(list)
  if tContains(BLOCKLIST_NAMES, tostring(list):lower()) then
    Utils:DumpSortedList(Blocklist);
  elseif tContains(CHECKLIST_NAMES, tostring(list):lower()) then
    Utils:DumpSortedList(Checklist);
  else
    Utils:PrintHelp();
  end
end