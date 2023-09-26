local AddonName, Addon = ...;
local AceGUI = LibStub("AceGUI-3.0");
local AceLocale = LibStub("AceLocale-3.0");
local Utils = Addon:NewModule("Utils");
local L = AceLocale:GetLocale(AddonName);
local type, select, ipairs, assert, tostring, tonumber, tconcat = type, select, ipairs, assert, tostring, tonumber, table.concat;
local strsplit, strlen, strmatch, gmatch, format, tinsert = strsplit, strlen, strmatch, gmatch, format, tinsert;
local ChatFrame_ContainsMessageGroup = ChatFrame_ContainsMessageGroup;
local GetPlayerInfoByGUID = GetPlayerInfoByGUID;
local GetRealmName = GetRealmName;
local RunNextFrame = RunNextFrame;
local NewTicker = C_Timer.NewTicker;
local AddFriend = C_FriendList.AddFriend;
local RemoveFriend = C_FriendList.RemoveFriend;
local GetFriendInfo = C_FriendList.GetFriendInfo;
local GetFactionInfo = C_CreatureInfo.GetFactionInfo;
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata;

local LIST_ENTRY = [[
  [%d] = {
    name = %q,
    guid = %q,
    class = %q,
    faction = %q,
    description = %q,
    url = %q,
    category = %q,
    level = %d,%s
  },]];

local LIST_ENTRY_ALIAS = "\n    aliases = { %s },";

local GROUP_ENTRY = [[
  [%d] = {
    description = %q,
    url = %q,
    category = %q,
    level = %d,
    players = {
%s
    },
  },]];

local PLAYER_ENTRY = [[
      [%d] = {
        name = %q,
        guid = %q,
        class = %q,
        faction = %q,%s
      },]];

local PLAYER_ENTRY_ALIASES = "\n        aliases = { %s },";

local NOTIFICATIONS_SOUND_FILE = "Sound/Interface/FriendJoin.ogg";

local RaceList = {
  Human = 1,
  Orc = 2,
  Dwarf = 3,
  NightElf = 4,
  Scourge = 5,
  Tauren = 6,
  Gnome = 7,
  Troll = 8,
  Goblin = 9,
  BloodElf = 10,
  Draenei = 11,
  Worgen = 22,
  Pandaren = 24,
};

function Utils:OnInitialize()
  local notifications = {
    self:EscapePattern(ERR_FRIEND_ADDED_S),
    self:EscapePattern(ERR_FRIEND_REMOVED_S),
    self:EscapePattern(ERR_FRIEND_NOT_FOUND),
    self:EscapePattern(ERR_FRIEND_ALREADY_S),
    self:EscapePattern(ERR_FRIEND_OFFLINE_S),
    self:EscapePattern(ERR_FRIEND_ONLINE_SS),
  };

  self.notificationsFilter = function(chatFrame, _, msg, ...)
    if ChatFrame_ContainsMessageGroup(chatFrame, "SYSTEM") then
      for _, pattern in ipairs(notifications) do
        if strmatch(msg, pattern) then
          return true;
        end
      end
    end

    return false, msg, ...;
  end

  self.notificationsDisabled = false;
end

function Utils:OnDisable()
  self:EnableNotifications();
end

function Utils:Print(message, ...)
  local chatFrame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME;
  local chatMessage = tostring(message);

  if select("#", ...) > 0 then
    chatFrame:AddMessage(format(chatMessage, ...));
  else
    chatFrame:AddMessage(chatMessage);
  end
end

function Utils:PrintMultiline(...)
  local length = select("#", ...);

  for i = 1, length do
    local message = select(i, ...);

    if type(message) == "table" then
      message = tconcat(message, "\n");
    elseif type(message) ~= "string" then
      message = tostring(message);
    end

    for line in gmatch(message, "[^\n]+") do
      Utils:Print(line);
    end
  end
end

function Utils:PrintAddonMessage(message, ...)
  local chatPrefix = self:AddonText(AddonName);
  local chatMessage = tostring(message);

  if select("#", ...) > 0 then
    self:Print("%s: %s", chatPrefix, format(chatMessage, ...));
  else
    self:Print("%s: %s", chatPrefix, chatMessage);
  end
end

function Utils:PrintTitle(title)
  self:Print(self:SpecialText("[%s]"), title);
end

function Utils:PrintKeyValue(key, value)
  self:Print("%s %s", self:SystemText(format("%s:", key)), value);
end

function Utils:PrintWarning(message)
  self:Print("%s %s", self:CautionText(L["CAUTION"]), message);
end

function Utils:PrintAddonVersion()
  local major, minor, patch = self:GetVersionParts(self:GetAddOnMetadata("Version"));
  local version = format("v%d.%d.%d", major, minor, patch);

  self:PrintAddonMessage(self:SuccessText(version));
end

function Utils:PrintPlayerNotFound(name)
  self:PrintAddonMessage(L["PLAYER_NOT_FOUND_TITLE"], name);
  self:PrintMultiline(L["PLAYER_NOT_FOUND_REASONS"]);
end

function Utils:PrintSlashCommands()
  self:PrintAddonMessage(L["AVAILABLE_COMMANDS"]);
  self:PrintCommand("/venoxis print", L["PRINT_COMMAND_1"]);
  self:PrintCommand("/venoxis print Name [Name2 Name3...]", L["PRINT_COMMAND_2"]);
  self:PrintCommand("/venoxis report", L["REPORT_COMMAND_1"]);
  self:PrintCommand("/venoxis report Name [Name2 Name3...]", L["REPORT_COMMAND_2"]);
  self:PrintCommand("/venoxis config", L["CONFIG_COMMAND_1"]);
  self:PrintCommand("/venoxis config [settings|profiles|about]", L["CONFIG_COMMAND_2"]);
  self:PrintCommand("/venoxis version", L["VERSION_COMMAND"]);
end

function Utils:PrintCommand(input, description)
  local slash, command, args = strsplit(" ", strtrim(input), 3);
  local params = {
    self:SystemText(slash),
    self:SpecialText(command),
    self:DescriptionText(format("- %s", description)),
  };

  if type(args) == "string" or strlen(args) > 0 then
    tinsert(params, 3, self:ArgsText(args));
  end

  self:Print(tconcat(params, " "));
end

function Utils:CreateCopyDialog(text, width, height)
  local frame = AceGUI:Create("Frame");

  frame:SetTitle(AddonName);
  frame:SetStatusText(L["COPY_SHORTCUT_INFO"]);
  frame:SetLayout("Flow");
  frame:SetWidth(width or 400);
  frame:SetHeight(height or 200);
  frame:EnableResize(false);
  frame:SetCallback("OnClose", function(widget)
    widget:Release();
  end);

  local editbox = AceGUI:Create("MultiLineEditBox");

  editbox:SetFullWidth(true);
  editbox:SetFullHeight(true);
  editbox:DisableButton(true);
  editbox:SetLabel(nil);
  editbox:SetText(text);
  editbox:SetCallback("OnTextChanged", function(widget)
    widget:SetText(text);
  end);

  frame:AddChild(editbox);

  RunNextFrame(function()
    editbox:HighlightText();
    editbox:SetFocus();
  end);
end

function Utils:GetGUIDInfo(guid)
  local className, class, raceName, race, _, name, server = GetPlayerInfoByGUID(guid);

  if not (name or race or class) then
    return;
  end

  local factionInfo = GetFactionInfo(RaceList[race]);
  local realm = (server ~= "" and server) or GetRealmName();

  return {
    guid = guid,
    name = name,
    className = className,
    class = class,
    raceName = raceName,
    race = race,
    faction = factionInfo.groupTag,
    factionName = factionInfo.name,
    realm = realm,
  };
end

function Utils:FetchGUIDInfo(guid, callback)
  local info = self:GetGUIDInfo(guid);

  if info then
    callback(info);
    return;
  end

  local ticks, maxTicks = 0, 4;
  local ticker;

  ticker = NewTicker(0.5, function()
    ticks = ticks + 1;
    info = self:GetGUIDInfo(guid);

    if info or ticks == maxTicks then
      ticker:Cancel();
      callback(info or nil);
    end
  end, maxTicks);
end

function Utils:FetchFriendInfo(name, callback)
  local info = GetFriendInfo(name);

  if info and info.notes == L["FRIENDS_LIST_NOTE"] then
    RemoveFriend(name);
  end

  if info then
    callback(info);
    return;
  end

  local ticks, maxTicks = 0, 4;
  local ticker;

  AddFriend(name, L["FRIENDS_LIST_NOTE"]);

  ticker = NewTicker(0.5, function()
    ticks = ticks + 1;
    info = GetFriendInfo(name);

    if info and info.notes == L["FRIENDS_LIST_NOTE"] then
      RemoveFriend(name);
    end

    if info or ticks == maxTicks then
      ticker:Cancel();
      callback(info or nil);
    end
  end, maxTicks);
end

function Utils:FetchGUIDInfoByName(name, callback)
  self:FetchFriendInfo(name, function(info)
    if info then
      self:FetchGUIDInfo(info.guid, callback);
    else
      callback(nil);
    end
  end);
end

function Utils:FormatPlayerInfo(info)
  return tconcat({
    self:SystemText(format("%s: %s", L["NAME"], self:PlainText(info.name))),
    self:SystemText(format("%s: %s", L["GUID"], self:PlainText(info.guid))),
    self:SystemText(format("%s: %s", L["RACE"], self:PlainText(info.raceName))),
    self:SystemText(format("%s: %s", L["CLASS"], self:ClassColor(info.className, info.class))),
    self:SystemText(format("%s: %s", L["FACTION"], self:FactionColor(info.factionName, info.faction))),
  }, "\n");
end

function Utils:FormatPlayerEntry(info, index)
  if not info or not index then
    return "";
  end

  return LIST_ENTRY:format(index, info.name, info.guid, info.class, info.faction, "", "", "", 3, "");
end

function Utils:FormatAliases(entry, template)
  if not entry or type(entry.aliases) ~= "table" or #entry.aliases == 0 then
    return "";
  end

  local escaped = {};

  for _, alias in ipairs(entry.aliases) do
    tinsert(escaped, format("%q", alias))
  end

  return format(template, tconcat(escaped, ", "));
end

function Utils:FormatListItemEntry(index, entry)
  if entry.players then
    local players = {};

    for i, player in ipairs(entry.players) do
      tinsert(players, PLAYER_ENTRY:format(
        i,
        player.name,
        player.guid,
        player.class,
        player.faction,
        self:FormatAliases(player, PLAYER_ENTRY_ALIASES)
      ));
    end

    return GROUP_ENTRY:format(
      index,
      entry.description,
      entry.url,
      entry.category,
      entry.level,
      tconcat(players, "\n")
    );
  end

  return LIST_ENTRY:format(
    index,
    entry.name,
    entry.guid,
    entry.class,
    entry.faction,
    entry.description,
    entry.url,
    entry.category,
    entry.level,
    self:FormatAliases(entry, LIST_ENTRY_ALIAS)
  );
end

function Utils:DisableNotifications()
  if not self.notificationsDisabled then
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", self.notificationsFilter);
    MuteSoundFile(NOTIFICATIONS_SOUND_FILE);
    self.notificationsDisabled = true;
  end
end

function Utils:EnableNotifications()
  if self.notificationsDisabled then
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", self.notificationsFilter);
    UnmuteSoundFile(NOTIFICATIONS_SOUND_FILE);
    self.notificationsDisabled = false;
  end
end

function Utils:GetAddOnMetadata(prop)
  return GetAddOnMetadata(AddonName, prop);
end

function Utils:GetVersionParts(version)
  local major, minor, patch = strmatch(version, "(%d+)%.(%d+)%.(%d+)");

  return unpack({
    major and tonumber(major) or 0,
    minor and tonumber(minor) or 0,
    patch and tonumber(patch) or 0,
  });
end

function Utils:GetCommandArgs(input)
  local args = {};

  for match in gmatch(input, "[^%s%p]+") do
    if type(match) == "string" and strlen(match) > 0 then
      tinsert(args, strlower(match));
    end
  end

  return unpack(args);
end

function Utils:EscapePattern(str)
  return str:gsub("[().+%-*?%%[^$]", "%%%1"):gsub("%%%%s", "(.+)");
end

function Utils:WrapColor(text, color)
  return WrapTextInColorCode(tostring(text), assert(color));
end

function Utils:ClassColor(text, className)
  return GetClassColorObj(className):WrapTextInColorCode(text);
end

function Utils:FactionColor(text, factionName)
  return GetFactionColor(factionName):WrapTextInColorCode(text);
end

function Utils:PlainText(text)
  return self:WrapColor(text, "FFFFFFFF");
end

function Utils:SystemText(text)
  return self:WrapColor(text, "FFFFFF33");
end

function Utils:CautionText(text)
  return self:WrapColor(text, "FFFF9933");
end

function Utils:SuccessText(text)
  return self:WrapColor(text, "FF33FF33");
end

function Utils:SpecialText(text)
  return self:WrapColor(text, "FF33FFFF");
end

function Utils:ArgsText(text)
  return self:WrapColor(text, "FFFF33FF");
end

function Utils:DescriptionText(text)
  return self:WrapColor(text, "FFEFEFEF");
end

function Utils:AddonText(text)
  return self:WrapColor(text, "FF33FF99");
end
