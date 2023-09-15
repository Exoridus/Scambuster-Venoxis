local AddonName, Addon = ...;
local AceLocale = LibStub("AceLocale-3.0");
local Commands = Addon:NewModule("Commands", "AceConsole-3.0");
local Blocklist = Addon:GetModule("Blocklist");
local Utils = Addon:GetModule("Utils");
local Config = Addon:GetModule("Config");
local L = AceLocale:GetLocale(AddonName);

function Commands:OnEnable()
  self:RegisterChatCommand("venoxis", "ChatCommand");
  self:RegisterChatCommand("v", "ChatCommand");
end

function Commands:OnDisable()
  self:UnregisterChatCommand("venoxis");
  self:UnregisterChatCommand("v");
end

function Commands:ChatCommand(input)
  local command, index = self:GetArgs(input);
  local args = Utils:GetCommandArgs(input, index);

  if command == "about" then
    Config:OpenOptionsFrame();
  elseif command == "print" then
    self:ReportPlayers(args, "chat");
  elseif command == "report" then
    self:ReportPlayers(args, "dialog");
  elseif command == "dump" then
    if #args > 0 then
      self:DumpPlayers(args);
    else
      self:DumpBlocklist();
    end
  elseif command == "check" then
    self:CheckChanged();
  elseif command == "ignored" then
    self:CheckIgnored();
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
  Utils:PrintCommand("/venoxis print Name", L["PRINT_COMMAND_2"]);
  Utils:PrintCommand("/venoxis report", L["REPORT_COMMAND_1"]);
  Utils:PrintCommand("/venoxis report Name", L["REPORT_COMMAND_2"]);
  Utils:PrintCommand("/venoxis check", L["CHECK_COMMAND"]);
  Utils:PrintCommand("/venoxis about", L["ABOUT_COMMAND"]);
end

function Commands:ReportPlayers(names, output)
  if #names > 0 then
    local name = names[1];

    Utils:FetchGUIDInfoByName(name, function(info)
      if not info then
        self:PrintPlayerNotFoundInfo(name);
      elseif output == "chat" then
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
      elseif output == "chat" then
        Utils:PrintMultiline(Utils:FormatPlayerInfo(info));
      elseif output == "dialog" then
        Utils:CreateCopyDialog(Utils:FormatPlayerInfo(info));
      end
    end);
  else
    Utils:PrintAddonMessage(L["ENTER_PLAYER_NAME"]);
  end
end

function Commands:DumpPlayers(names)
  local name = names[1];

  Utils:FetchGUIDInfoByName(name, function(info)
    if info then
      Utils:CreateCopyDialog(Utils:FormatPlayerEntry(info, #Blocklist.Entries + 1), 480, 320);
    else
      self:PrintPlayerNotFoundInfo(name);
    end
  end);
end

function Commands:DumpBlocklist()
  local entries = Blocklist.Entries;
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

function Commands:CheckChanged()
  local entries = Blocklist.Entries;
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

  C_Timer.NewTicker(2, function()
    local guid = guids[index];
    local player = players[guid];
    local playerIndex = index;

    Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], guid, index, length)));

    Utils:FetchGUIDInfo(guid, function(info)
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
          Utils:CreateCopyDialog(table.concat(output, "\n"), 640, 480);
        end
      end
    end);

    index = index + 1;
  end, length);
end

function Commands:GetFailedNames(names, callback)
  local guids = GetKeysArray(names);
  local length = #guids;
  local index = 1;
  local failed = {};

  Utils:AddChatFilter();

  C_Timer.NewTicker(2, function()
    local guid = guids[index];
    local player = names[guid];
    local playerIndex = index;

    Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], player, index, length)));

    Utils:FetchFriendInfo(player, function(info)
      if not info then
        tinsert(failed, { guid, player });
      end

      if playerIndex == length then
        Utils:RemoveChatFilter();
        callback(failed);
      end
    end);

    index = index + 1;
  end, length);
end

function Commands:CheckIgnored()
  local entries = Blocklist.Entries;
  local names = {};
  local playerFaction = UnitFactionGroup("player");

  for _, entry in ipairs(entries) do
    if entry.players then
      for _, player in pairs(entry.players) do
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

  self:GetFailedNames(names, function(failed)
    if #failed == 0 then
      Utils:PrintAddonMessage("Finished search with no found ignores.");
      return;
    end

    local length = #failed;
    local index = 1;
    local ignores = 0;
    local output = {};

    C_Timer.NewTicker(2, function()
      local guid, name = unpack(failed[index]);
      local playerIndex = index;

      Utils:Print(Utils:SystemText(format(L["CHECK_PROGRESS"], guid, index, length)));

      Utils:FetchGUIDInfo(guid, function(info)
        if info and info.name == name then
          if #output > 0 then
            tinsert(output, "");
          end

          ignores = ignores + 1;
          Utils:PrintTitle(format("Player %s (%s) is ignoring you.", name, guid));
          tinsert(output, format("[%s]", guid));
          tinsert(output, format("%d. %s (%s)", ignores, name, guid));
          tinsert(output, format("%d. %s (%s)", ignores, name, guid));
        end

        if playerIndex == length then
          Utils:PrintAddonMessage(format("Finished search with %d found ignores.", ignores));

          if #output > 0 then
            Utils:CreateCopyDialog(table.concat(output, "\n"), 640, 480);
          end
        end
      end);

      index = index + 1;
    end, length);
  end);
end
