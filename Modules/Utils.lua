---@type AddonName, Addon
local AddonName, Addon = ...;
local AceGUI = LibStub("AceGUI-3.0");
---@class Utils : AceModule
---@field notificationsFilter fun(chatFrame: table, event: string, msg: string, ...: any): boolean, ...
---@field notificationLocks integer
---@field cachedMetadata table<string, string>
---@field cachedPatterns table<string, string>
---@field playerInfos table<string, table>
local Utils = Addon:NewModule("Utils");
local L = Addon.L;
local type, select, ipairs, assert, tostring, tconcat = type, select, ipairs, assert, tostring, table.concat;
local strmatch, gmatch, gsub, format, tinsert = strmatch, gmatch, gsub, format, tinsert;
local GetPlayerInfoByGUID = GetPlayerInfoByGUID;
local GetRealmName = GetRealmName;
local RunNextFrame = RunNextFrame;
local GetFactionColor = GetFactionColor;
local GetClassColorObj = GetClassColorObj;
local WrapTextInColorCode = WrapTextInColorCode;
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
  self.notificationLocks = 0;
  self.cachedMetadata = {};
  self.cachedPatterns = {};
  self.playerInfos = {};
end

function Utils:OnEnable()
  self.notifications = {
    self:SanitizePattern(ERR_FRIEND_ADDED_S),
    self:SanitizePattern(ERR_FRIEND_REMOVED_S),
    self:SanitizePattern(ERR_FRIEND_NOT_FOUND),
    self:SanitizePattern(ERR_FRIEND_ALREADY_S),
    self:SanitizePattern(ERR_FRIEND_OFFLINE_S),
    self:SanitizePattern(ERR_FRIEND_ONLINE_SS),
  };

  self.notificationsFilter = function(chatFrame, _, msg, ...)
    if ContainsMessageGroup(chatFrame, "SYSTEM") then
      for _, pattern in ipairs(self.notifications) do
        if strmatch(msg, pattern) then
          return true;
        end
      end
    end

    return false, msg, ...;
  end
end

function Utils:OnDisable()
  self:EnableNotifications();
end

---@param message string
---@param ... any
function Utils:Print(message, ...)
  local chatFrame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME;
  local chatMessage = tostring(message);

  if select("#", ...) > 0 then
    chatFrame:AddMessage(format(chatMessage, ...));
  else
    chatFrame:AddMessage(chatMessage);
  end
end

---@param ... string|string[]
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
      self:Print(line);
    end
  end
end

---@param message string
---@param ...? string|number
function Utils:PrintAddonMessage(message, ...)
  local chatPrefix = self:AddonText(AddonName);
  local chatMessage = tostring(message);

  if select("#", ...) > 0 then
    self:Print("%s: %s", chatPrefix, format(chatMessage, ...));
  else
    self:Print("%s: %s", chatPrefix, chatMessage);
  end
end

---@param message string
---@param ...? string|number
function Utils:PrintWarning(message, ...)
  local chatMessage = tostring(message);

  if select("#", ...) > 0 then
    chatMessage = format(chatMessage, ...);
  end

  self:Print(self:WarningText(chatMessage));
end

---@param message string
---@param ...? string|number
function Utils:PrintStatus(message, ...)
  local chatMessage = tostring(message);

  if select("#", ...) > 0 then
    chatMessage = format(chatMessage, ...);
  end

  self:Print(self:SystemText(chatMessage));
end

---@param text string
---@param width? integer
---@param height? integer
function Utils:CreateCopyDialog(text, width, height)
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
    editBoxWidget:SetCursorPosition(editBox:GetNumLetters() or 0);
  end

  editBoxWidget:SetFullWidth(true);
  editBoxWidget:SetFullHeight(true);
  editBoxWidget:DisableButton(true);
  editBoxWidget:SetLabel("");
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

  frameWidget:AddChild(editBoxWidget);

  RunNextFrame(selectEditBoxText);
end

---@param players Scambuster.PlayerInfo[]
---@param callback fun(failed: Scambuster.PlayerInfo[])
function Utils:GetFailedNames(players, callback)
  local length = #players;
  local index = 1;
  local failed = {};

  self:DisableNotifications();

  NewTicker(2, function()
    local player = players[index];
    local playerIndex = index;

    if index % 10 == 0 then
      self:PrintStatus(L.CHECK_PROGRESS, index, length);
    end

    self:FetchGUIDByName(player.name, function(info)
      if not info then
        tinsert(failed, player);
      end

      if playerIndex == length then
        self:EnableNotifications();
        callback(failed);
      end
    end);

    index = index + 1;
  end, length);
end

---@param guid string
---@return table?
function Utils:GetPlayerInfo(guid)
  if not guid then
    return;
  end

  if not self.playerInfos[guid] then
    local className, class, raceName, race, _, name, realm = GetPlayerInfoByGUID(guid);
    local factionInfo = race and RaceList[race] and GetFactionInfo(RaceList[race]);

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

---@param guid string
---@param callback fun(info: table?)
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

---@param name string
---@param callback fun(info: table?)
function Utils:FetchPlayerInfoByName(name, callback)
  self:DisableNotifications();

  self:FetchGUIDByName(name, function(guid)
    Utils:EnableNotifications();

    self:FetchPlayerInfoByGUID(guid, callback);
  end);
end

---@param name string
---@param callback fun(guid: string?)
function Utils:FetchGUIDByName(name, callback)
  if name == UnitName("player") then
    callback(UnitGUID("player"));
    return;
  end

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

---@param info Scambuster.PlayerInfo
---@param index integer
---@return string?
function Utils:FormatPlayerEntry(info, index)
  if info and index then
    return LIST_ENTRY:format(index, info.name, info.guid, info.class, info.faction, "", "", "", 3, "");
  end
end

---@param entry Scambuster.PlayerInfo
---@param template string
---@return string
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

---@param index integer
---@param entry Scambuster.Entry
---@return string
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

  ---@cast entry -Scambuster.GroupEntry

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

---@param version string
---@return number
function Utils:VersionToNumber(version)
  local major, minor, patch = version:match("(%d+)%.(%d+)%.(%d+)");

  return floor((major or 0) * 1e6 + (minor or 0) * 1e3 + (patch or 0));
end

---@param version number
---@return string
function Utils:NumberToVersion(version)
  local major, minor, patch = version / 1e6, version % 1e6 / 1e3, version % 1e3;

  return format("%i.%i.%i", major, minor, patch);
end

---@param key string
---@param localized boolean?
---@return string
function Utils:GetMetadata(key, localized)
  if localized == true then
    return self:GetMetadata(format("%s-%s", key, GetLocale())) or self:GetMetadata(key);
  end

  local metadata = self.cachedMetadata[key];

  if not metadata then
    metadata = GetAddOnMetadata(AddonName, key);
    self.cachedMetadata[key] = metadata;
  end

  return metadata;
end

---@param pattern string
---@return string
function Utils:SanitizePattern(pattern)
  local cached = self.cachedPatterns[pattern];

  if not cached then
    cached = pattern;
    cached = gsub(cached, "([%+%-%*%(%)%?%[%]%^%.])", "%%%1");
    cached = gsub(cached, "%d%$", "");
    cached = gsub(cached, "(%%%a)", "(%1+)");
    cached = gsub(cached, "%%s%+", ".+");
    self.cachedPatterns[pattern] = cached;
  end

  return cached;
end

---@param str string
---@return string[]
function Utils:SplitList(str)
  local list = {};

  for item in gmatch(str, "([^%p%s]+)") do
    tinsert(list, item);
  end

  return list;
end

---@param text string
---@param color string
---@return string
function Utils:WrapColor(text, color)
  return WrapTextInColorCode(tostring(text), assert(color));
end

---@param text string
---@param className string
---@return string
function Utils:ClassColor(text, className)
  return GetClassColorObj(className):WrapTextInColorCode(text);
end

---@param text string
---@param factionName string
---@return string
function Utils:FactionColor(text, factionName)
  return GetFactionColor(factionName):WrapTextInColorCode(text);
end

---@param text string
---@return string
function Utils:SystemText(text)
  return self:WrapColor(text, "FFFFFF33");
end

---@param text string
---@return string
function Utils:WarningText(text)
  return self:WrapColor(text, "FFFF9933");
end

---@param text string
---@return string
function Utils:SpecialText(text)
  return self:WrapColor(text, "FF33FFFF");
end

---@param text string
---@return string
function Utils:DescriptionText(text)
  return self:WrapColor(text, "FFEFEFEF");
end

---@param text string
---@return string
function Utils:AddonText(text)
  return self:WrapColor(text, "FF33FF99");
end
