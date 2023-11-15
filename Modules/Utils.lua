local AddonName, Addon = ...;
local AceGUI = LibStub("AceGUI-3.0");
local AceLocale = LibStub("AceLocale-3.0");
---@class Utils : AceModule
local Utils = Addon:NewModule("Utils");
local L = AceLocale:GetLocale(AddonName);
local type, select, ipairs, assert, tostring, tconcat, fmod = type, select, ipairs, assert, tostring, table.concat, math.fmod;
local strsplit, strtrim, strlower, strmatch, gmatch, gsub, format, tinsert, unpack = strsplit, strtrim, strlower, strmatch, gmatch, gsub, format, tinsert, unpack;
local GetPlayerInfoByGUID = GetPlayerInfoByGUID;
local GetRealmName = GetRealmName;
local RunNextFrame = RunNextFrame;
local GetValuesArray = GetValuesArray;
local GetFactionColor = GetFactionColor;
local GetClassColorObj = GetClassColorObj;
local WrapTextInColorCode = WrapTextInColorCode;
local MuteSoundFile = MuteSoundFile;
local UnmuteSoundFile = UnmuteSoundFile;
local ContainsMessageGroup = ChatFrame_ContainsMessageGroup;
local AddMessageEventFilter = ChatFrame_AddMessageEventFilter;
local RemoveMessageEventFilter = ChatFrame_RemoveMessageEventFilter;
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

local CODE_FONT_PATH = "Interface\\Addons\\WeakAuras\\Media\\Fonts\\FiraMono-Medium.ttf";

local VERSION_PATTERN = "(%d+)%.(%d+)%.(%d+)";

local VERSION_FORMAT = "%d.%d.%d";

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
    self:SanitizePattern(ERR_FRIEND_ADDED_S),
    self:SanitizePattern(ERR_FRIEND_REMOVED_S),
    self:SanitizePattern(ERR_FRIEND_NOT_FOUND),
    self:SanitizePattern(ERR_FRIEND_ALREADY_S),
    self:SanitizePattern(ERR_FRIEND_OFFLINE_S),
    self:SanitizePattern(ERR_FRIEND_ONLINE_SS),
  };

  self.notificationsFilter = function(chatFrame, _, msg, ...)
    if ContainsMessageGroup(chatFrame, "SYSTEM") then
      for _, pattern in ipairs(notifications) do
        if strmatch(msg, pattern) then
          return true;
        end
      end
    end

    return false, msg, ...;
  end

  self.notificationLocks = 0;
  self.cachedMetadata = {};
  self.playerInfos = {};
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
  self:Print("%s %s", self:CautionText(L.CAUTION), message);
end

function Utils:PrintAddonVersion()
  self:PrintAddonMessage(format("v%s", self:GetMetadata("Version")));
end

function Utils:PrintPlayerNotFound(name)
  self:PrintAddonMessage(L.PLAYER_NOT_FOUND_TITLE, name);
  self:PrintMultiline(L.PLAYER_NOT_FOUND_REASONS);
end

function Utils:PrintSlashCommands()
  self:PrintAddonMessage(L.AVAILABLE_COMMANDS);
  self:PrintCommand("/venoxis print", L.PRINT_COMMAND_1);
  self:PrintCommand("/venoxis print Name [Name2 Name3...]", L.PRINT_COMMAND_2);
  self:PrintCommand("/venoxis report", L.REPORT_COMMAND_1);
  self:PrintCommand("/venoxis report Name [Name2 Name3...]", L.REPORT_COMMAND_2);
  self:PrintCommand("/venoxis config", L.CONFIG_COMMAND_1);
  self:PrintCommand("/venoxis config [settings|profiles|about]", L.CONFIG_COMMAND_2);
  self:PrintCommand("/venoxis version", L.VERSION_COMMAND);
end

function Utils:PrintCommand(input, description)
  local slash, command, args = strsplit(" ", strtrim(input), 3);
  local params = {
    self:SystemText(slash),
    self:SpecialText(command),
    self:DescriptionText(format("- %s", description)),
  };

  if type(args) == "string" or args:len() > 0 then
    tinsert(params, 3, self:ArgsText(args));
  end

  self:Print(tconcat(params, " "));
end

function Utils:CreateCopyDialog(text, width, height, isCode)
  local frameWidget = AceGUI:Create("Frame") --[[@as AceGUIFrame]];

  frameWidget:SetTitle(AddonName);
  frameWidget:SetStatusText(L.COPY_SHORTCUT_INFO);
  frameWidget:SetLayout("Flow");
  frameWidget:SetWidth(width or 400);
  frameWidget:SetHeight(height or 200);
  frameWidget:EnableResize(false);
  frameWidget:SetCallback("OnClose", function(widget)
    widget:Release();
  end);

  local editBoxWidget = AceGUI:Create("MultiLineEditBox") --[[@as AceGUIMultiLineEditBox]];
  local editBox = editBoxWidget.editBox --[[@as EditBox]];
  local selectEditBoxText = function()
    editBoxWidget:SetFocus();
    editBoxWidget:HighlightText();
    editBoxWidget:SetCursorPosition(editBox:GetNumLetters());
  end

  editBoxWidget:SetFullWidth(true);
  editBoxWidget:SetFullHeight(true);
  editBoxWidget:DisableButton(true);
  editBoxWidget:SetLabel(nil);
  editBoxWidget:SetText(text);
  editBoxWidget:SetCallback("OnTextChanged", function(widget)
    widget:SetText(text);
    selectEditBoxText();
  end);

  editBox:HookScript("OnKeyUp", selectEditBoxText);
  editBox:HookScript("OnMouseUp", selectEditBoxText);
  editBox:HookScript("OnCursorChanged", selectEditBoxText);
  editBox:HookScript("OnEscapePressed", function()
    frameWidget:Hide();
  end);

  if isCode then
    editBox:SetFont(CODE_FONT_PATH, 12, "");
  end

  frameWidget:AddChild(editBoxWidget);

  RunNextFrame(selectEditBoxText);
end

function Utils:GetPlayerInfo(guid)
  if not guid then
    return;
  end

  if not self.playerInfos[guid] then
    local className, class, raceName, race, _, name, realm = GetPlayerInfoByGUID(guid);
    local factionInfo = GetFactionInfo(RaceList[race]);

    if name and race and class and factionInfo then
      self.playerInfos[guid] = {
        guid = guid,
        name = name,
        className = className,
        class = class,
        raceName = raceName,
        race = race,
        faction = factionInfo.groupTag,
        factionName = factionInfo.name,
        realm = (realm ~= "" and realm) or GetRealmName(),
      };
    end
  end

  return self.playerInfos[guid];
end

function Utils:FetchPlayerInfoByGUID(guid, callback)
  if not guid then
    callback(nil);
    return;
  end

  local info = self:GetPlayerInfo(guid);

  if info then
    callback(info);
    return;
  end

  local ticks, maxTicks = 0, 4;
  local ticker;

  ticker = NewTicker(0.5, function()
    ticks = ticks + 1;
    info = self:GetPlayerInfo(guid);

    if info or ticks == maxTicks then
      ticker:Cancel();
      callback(info or nil);
    end
  end, maxTicks);
end

function Utils:CleanupFriendList()
  local pattern = self:SanitizePattern(AddonName);

  for i = C_FriendList.GetNumFriends(), 1, -1 do
    local info = C_FriendList.GetFriendInfoByIndex(i);

    if info and info.notes and strmatch(info.notes, pattern) then
      RemoveFriend(info.name);
    end
  end
end

function Utils:FetchPlayerInfoByName(name, callback)
  self:FetchGUIDByName(name, function(guid)
    self:FetchPlayerInfoByGUID(guid, callback);
  end);
end

function Utils:FetchGUIDByName(name, callback)
  local info = GetFriendInfo(name);

  if info and strmatch(info.notes, self:SanitizePattern(AddonName)) then
    RemoveFriend(name);
  end

  if info then
    callback(info.guid);
    return;
  end

  local ticks, maxTicks = 0, 4;
  local ticker;

  AddFriend(name, AddonName);

  ticker = NewTicker(0.5, function()
    ticks = ticks + 1;
    info = GetFriendInfo(name);

    if info and strmatch(info.notes, self:SanitizePattern(AddonName)) then
      RemoveFriend(name);
    end

    if info or ticks == maxTicks then
      ticker:Cancel();
      callback(info and info.guid);
    end
  end, maxTicks);
end

function Utils:FormatPlayerInfo(info)
  return tconcat({
    self:SystemText(format("%s: %s", L.NAME, self:PlainText(info.name))),
    self:SystemText(format("%s: %s", L.GUID, self:PlainText(info.guid))),
    self:SystemText(format("%s: %s", L.RACE, self:PlainText(info.raceName))),
    self:SystemText(format("%s: %s", L.CLASS, self:ClassColor(info.className, info.class))),
    self:SystemText(format("%s: %s", L.FACTION, self:FactionColor(info.factionName, info.faction))),
  }, "\n");
end

function Utils:FormatPlayerEntry(info, index)
  if info and index then
    return LIST_ENTRY:format(index, info.name, info.guid, info.class, info.faction, "", "", "", 3, "");
  end
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
  if self.notificationLocks == 0 then
    AddMessageEventFilter("CHAT_MSG_SYSTEM", self.notificationsFilter);
    MuteSoundFile(NOTIFICATIONS_SOUND_FILE);
  end

  self.notificationLocks = self.notificationLocks + 1;
end

function Utils:EnableNotifications()
  if self.notificationLocks == 1 then
    RemoveMessageEventFilter("CHAT_MSG_SYSTEM", self.notificationsFilter);
    UnmuteSoundFile(NOTIFICATIONS_SOUND_FILE);
  end

  self.notificationLocks = max(self.notificationLocks - 1, 0);
end

function Utils:CreateEntryByInfo(...)
  local length = select("#", ...);

  if length == 0 then
    return;
  end

  local entry = {
    description = "",
    url = "",
    category = "",
    level = 3,
  };

  local players = {};

  for i = 1, length do
    local info = select(i, ...);

    tinsert(players, {
      name = info.name,
      guid = info.guid,
      class = info.class,
      faction = info.faction,
    });
  end

  if #players > 1 then
    return MergeTable(entry, { players = players });
  end

  return MergeTable(entry, players[1]);
end

function Utils:GetUniquePlayers(entries)
  local players = {};

  for _, entry in ipairs(entries) do
    if entry.players and #entry.players > 0 then
      for _, player in ipairs(entry.players) do
        if not players[player.guid] then
          players[player.guid] = {
            guid = player.guid,
            name = player.name,
            class = player.class,
            faction = player.faction,
          };
        elseif players[player.guid].name ~= player.name then
          self:PrintWarning(format(L.FOUND_NAME_COLLISION, player.guid, players[player.guid].name, player.name));
        end
      end
    elseif entry.name then
      if not players[entry.guid] then
        players[entry.guid] = {
          guid = entry.guid,
          name = entry.name,
          class = entry.class,
          faction = entry.faction,
        };
      elseif players[entry.guid].name ~= entry.name then
        self:PrintWarning(format(L.FOUND_NAME_COLLISION, entry.guid, players[entry.guid].name, entry.name));
      end
    end
  end

  return GetValuesArray(players);
end

function Utils:VersionToNumber(version)
  local major, minor, patch = version:match(VERSION_PATTERN);

  return floor((major or 0) * 1e6 + (minor or 0) * 1e3 + (patch or 0));
end

function Utils:GetVersionString(version)
  local major = floor(version / (10 ^ 4));
  local minor = floor(version % (10 ^ 4) / (10 ^ 2));
  local patch = version % (10 ^ 2);

  return format(VERSION_FORMAT, major, minor, patch);
end

function Utils:GetMetadata(key)
  local metadata = self.cachedMetadata[key];

  if not metadata then
    metadata = GetAddOnMetadata(AddonName, key);
    self.cachedMetadata[key] = metadata;
  end

  return metadata;
end

function Utils:GetHash(str)
  local counter = 1;
  local len = strlen(str);

  for i = 1, len, 3 do
    counter = fmod(counter * 8161, 4294967279) + (strbyte(str, i) * 16776193) + ((strbyte(str, i + 1) or (len - i + 256)) * 8372226) + ((strbyte(str, i + 2) or (len - i + 256)) * 3932164);
  end

  return fmod(counter, 4294967291);
end

function Utils:GetCommandArgs(input)
  local args = {};

  for match in gmatch(input, "[^%s%p]+") do
    if type(match) == "string" and match:len() > 0 then
      tinsert(args, strlower(match));
    end
  end

  return unpack(args);
end

local cachedPatterns = {}
function Utils:SanitizePattern(pattern)
  if not cachedPatterns[pattern] then
    local result = pattern;
    result = gsub(result, "([%+%-%*%(%)%?%[%]%^%.])", "%%%1");
    result = gsub(result, "%d%$", "");
    result = gsub(result, "(%%%a)", "(%1+)");
    result = gsub(result, "%%s%+", ".+");
    cachedPatterns[pattern] = result;
  end

  return cachedPatterns[pattern];
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
