local AddonName, Addon = ...;
local AceLocale = LibStub("AceLocale-3.0");
local Commands = Addon:NewModule("Commands", "AceConsole-3.0");
local Blocklist = Addon:GetModule("Blocklist");
local Utils = Addon:GetModule("Utils");
local Config = Addon:GetModule("Config");
local L = AceLocale:GetLocale(AddonName);

function Commands:OnEnable()
  self:RegisterChatCommand("venoxis", "ChatCommand");
end

function Commands:OnDisable()
  self:UnregisterChatCommand("venoxis");
end

function Commands:ChatCommand(input)
  local arg1, arg2 = self:GetArgs(input, 2);

  if arg1 == "config" then
    Config:OpenOptionsFrame();
  elseif arg1 == "print" then
    self:ReportPlayer(arg2, "chat");
  elseif arg1 == "report" then
    self:ReportPlayer(arg2, "dialog");
  elseif arg1 == "dump" then
    if arg2 and arg2 ~= "" then
      self:DumpEntry(arg2);
    else
      self:DumpEntries(Blocklist.Entries);
    end
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
  Utils:Print(L["PLAYER_NOT_FOUND_REASON_5"]);
end

function Commands:PrintCommands()
  Utils:PrintAddonMessage(L["AVAILABLE_COMMANDS"]);
  Utils:PrintCommand("/venoxis print", L["PRINT_COMMAND_1"]);
  Utils:PrintCommand("/venoxis print <name>", L["PRINT_COMMAND_2"]);
  Utils:PrintCommand("/venoxis report", L["REPORT_COMMAND_1"]);
  Utils:PrintCommand("/venoxis report <name>", L["REPORT_COMMAND_2"]);
  Utils:PrintCommand("/venoxis check", L["CHECK_COMMAND"]);
  Utils:PrintCommand("/venoxis about", L["ABOUT_COMMAND"]);
end

function Commands:ReportPlayer(name, output)
  if name and name ~= "" then
    Utils:FetchGUIDInfoByName(name, function(info)
      if not info then
        self:PrintPlayerNotFoundInfo(name);
        return;
      end

      if output == "chat" then
        Utils:PrintMultiline(Utils:FormatPlayerInfo(info));
      elseif output == "dialog" then
        Utils:CreateCopyDialog(Utils:FormatPlayerInfo(info));
      end
    end);
  elseif UnitIsPlayer("target") then
    local playerGUID = UnitGUID("target");
    local playerName = UnitName("target");

    Utils:FetchGUIDInfo(playerGUID, function(info)
      if not info then
        self:PrintPlayerNotFoundInfo(playerName);
        return;
      end

      if output == "chat" then
        Utils:PrintMultiline(Utils:FormatPlayerInfo(info));
      elseif output == "dialog" then
        Utils:CreateCopyDialog(Utils:FormatPlayerInfo(info));
      end
    end);
  else
    Utils:PrintAddonMessage(L["ENTER_PLAYER_NAME"]);
  end
end

function Commands:DumpEntry(name)
  Utils:FetchGUIDInfoByName(name, function(info)
    if info then
      Utils:CreateCopyDialog(Utils:FormatPlayerEntry(info, #Blocklist.Entries + 1), 480, 320);
    else
      self:PrintPlayerNotFoundInfo(name);
    end
  end);
end

function Commands:DumpEntries(entries)
  local output = {};
  local index = 1;

  for _, entry in pairs(entries) do
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

  Utils:CreateCopyDialog(table.concat(output, "\n"), 800, 600);
end

function Commands:CheckEntries(entries)
  local guids = {};
  local players = {};

  for _, entry in pairs(entries) do
    if entry.players then
      for _, player in pairs(entry.players) do
        if not players[player.guid] then
          players[player.guid] = {
            names = {},
            race = player.race,
            class = player.class,
            faction = player.faction,
          };
        end

        tInsertUnique(players[player.guid].names, player.name);

        if player.aliases and #player.aliases > 0 then
          for _, alias in pairs(player.aliases) do
            tInsertUnique(players[player.guid].names, alias);
          end
        end

        tInsertUnique(guids, player.guid);
      end
    elseif entry.name then
      if not players[entry.guid] then
        players[entry.guid] = {
          names = {},
          race = entry.race,
          class = entry.class,
          faction = entry.faction,
        };
      end

      tInsertUnique(players[entry.guid].names, entry.name);

      if entry.aliases and #entry.aliases > 0 then
        for _, alias in pairs(entry.aliases) do
          tInsertUnique(players[entry.guid].names, alias);
        end
      end

      tInsertUnique(guids, entry.guid);
    end
  end

  local length = #guids;
  local index = 1;
  local results = {};

  Utils:PrintAddonMessage(L["CHECK_STARTED"], length, length * 2);

  C_Timer.NewTicker(2, function()
    local guid = guids[index];
    local player = players[guid];
    local playerIndex = index;

    Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], guid, index, length)));

    Utils:FetchGUIDInfo(guid, function(info)
      if info and player then
        local nameChanged = not tContains(player.names, info.name);
        local raceChanged = player.race ~= info.race;
        local classChanged = player.class ~= info.class;
        local factionChanged = player.faction ~= info.faction;

        if nameChanged or raceChanged or classChanged or factionChanged then
          Utils:Print(Utils:SuccessText(format(L["CHANGE_FOUND"], info.guid)));
          tinsert(results, format("[%s]", info.guid));

          if nameChanged then
            local changed = format(L["CHANGED_VALUE"], info.name, table.concat(player.names, ", "));

            tinsert(results, format("%s: %s", L["NAME_CHANGE"], changed));
            Utils:PrintKeyValue(L["NAME_CHANGE"], changed);
          end
          if raceChanged then
            local changed = format(L["CHANGED_VALUE"], info.race, player.race);

            tinsert(results, format("%s: %s", L["RACE_CHANGE"], changed));
            Utils:PrintKeyValue(L["RACE_CHANGE"], changed);
          end
          if classChanged then
            local changed = format(L["CHANGED_VALUE"], info.class, player.class);

            tinsert(results, format("%s: %s", L["CLASS_CHANGE"], changed));
            Utils:PrintKeyValue(L["CLASS_CHANGE"], changed);
          end
          if factionChanged then
            local changed = format(L["CHANGED_VALUE"], info.faction, player.faction);

            tinsert(results, format("%s: %s", L["FACTION_CHANGE"], changed));
            Utils:PrintKeyValue(L["FACTION_CHANGE"], changed);
          end

          tinsert(results, "");
        end
      else
        Utils:PrintWarning(format(L["UNKNOWN_GUID"], guid));
      end

      if playerIndex == length then
        Utils:PrintAddonMessage(L["CHECK_FINISHED"], length);

        if #results > 0 then
          Utils:CreateCopyDialog(table.concat(results, "\n"), 640, 480);
        end
      end
    end);

    index = index + 1;
  end, length);
end
