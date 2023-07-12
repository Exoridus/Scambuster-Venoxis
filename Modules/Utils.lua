local AddonName, Addon = ...;
local AceGUI = LibStub("AceGUI-3.0");
local Utils = Addon:NewModule("Utils");
local Color = Addon:GetModule("Color");
local Config = Addon:GetModule("Config");

local RACE_TO_FACTION = {
  Orc = "Horde",
  Scourge = "Horde",
  Tauren = "Horde",
  Troll = "Horde",
  BloodElf = "Horde",
  Human = "Alliance",
  Dwarf = "Alliance",
  NightElf = "Alliance",
  Draenei = "Alliance",
  Gnome = "Alliance",
};

local EMPTY_CASE = [[
[%d] = {
  name = "%s",
  guid = "%s",
  class = "%s",
  faction = "%s",
  description = "",
  url = "",
  category = "",
  level = 3,
},]];

local EXISTING_CASE = [[
[%d] = {
  name = "%s",
  guid = "%s",
  class = "%s",
  faction = "%s",
  description = "%s",
  url = "%s",
  category = "%s",
  level = %d,%s
},]];

local ALIAS_PROP = '\n  aliases = {"%s"},';
local ENABLED_STATES = { "on", "enabled", "true", "1", "enable" };
local DISABLED_STATES = { "off", "disabled", "false", "0", "disable" };
local FRIENDS_LIST_NOTE = ("From %s"):format(AddonName);
local FRIENDS_LIST_SOUND = "Sound/Interface/FriendJoin.ogg";
local CHAT_FILTER_ACTIVE = false;
local CHAT_FILTER_PATTERNS = {
  ERR_FRIEND_ADDED_S:gsub("%.", "%%."):gsub("%%s", ".+"),
  ERR_FRIEND_REMOVED_S:gsub("%.", "%%."):gsub("%%s", ".+"),
  ERR_FRIEND_NOT_FOUND:gsub("%.", "%%."):gsub("%%s", ".+"),
  ERR_FRIEND_ALREADY_S:gsub("%.", "%%."):gsub("%%s", ".+"),
  ERR_FRIEND_OFFLINE_S:gsub("%.", "%%."):gsub("%%s", ".+"),
  ERR_FRIEND_ONLINE_SS:gsub("|Hplayer:%%s|h%[%%s%]|h", "|Hplayer:.+|h%%[.+%%]|h"),
};
local CHAT_FILTER = function (self, event, msg, ...)
  if ChatFrame_ContainsMessageGroup(self, "SYSTEM") then
    for _, pattern in pairs(CHAT_FILTER_PATTERNS) do
      if msg:find(pattern) then
        return true;
      end
    end
  end

  return false, msg, ...;
end

function Utils:Print(message, ...)
  local chatFrame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME;
  local chatPrefix = Color:Prefix(AddonName);
  local chatMessage = tostring(message);

  if select('#', ...) > 0 then
    chatMessage = chatMessage:format(...);
  end

  chatFrame:AddMessage(("%s: %s"):format(chatPrefix, chatMessage));
end

function Utils:PrintDebug(message, ...)
  if Config:DebugMode() == true then
    return self:Print(message, ...);
  end
end

function Utils:PrepareFriendInfo(info)
  local guid = assert(info.guid);
  local className, class, raceName, race, _, name, server = GetPlayerInfoByGUID(guid);
  local faction = RACE_TO_FACTION[race];
  local factionName = FACTION_LABELS_FROM_STRING[faction];
  local realm = server ~= "" and server or GetRealmName();
  local level = type(info.level) == "number" and info.level or 0;

  if info.notes == FRIENDS_LIST_NOTE then
    C_FriendList.RemoveFriend(name);
  end

  return {
    name = name,
    guid = guid,
    level = level,
    class = class,
    className = className,
    race = race,
    raceName = raceName,
    faction = faction,
    factionName = factionName,
    realm = realm,
  };
end

function Utils:FetchPlayerInfo(name, callback)
  local info = C_FriendList.GetFriendInfo(name);

  if info then
    callback(self:PrepareFriendInfo(info));
    return;
  end

  C_FriendList.AddFriend(name, FRIENDS_LIST_NOTE);

  local ticks, maxTicks = 0, 8;
  local ticker;

  ticker = C_Timer.NewTicker(0.25, function()
    ticks = ticks + 1;

    local info = C_FriendList.GetFriendInfo(name);

    if info then
      ticker:Cancel();
      callback(self:PrepareFriendInfo(info));
    elseif ticks == maxTicks then
      callback(nil);
    end
  end, maxTicks);
end

function Utils:FormatReportByPlayerInfo(index, info)
  return EMPTY_CASE:format(index, info.name, info.guid, info.class, info.faction);
end

function Utils:FormatReportByCase(index, case)
  return EXISTING_CASE:format(
    index,
    case.name,
    case.guid,
    case.class,
    case.faction,
    case.description,
    case.url,
    case.category,
    case.level,
    case.aliases and ALIAS_PROP:format(table.concat(case.aliases, '", "')) or ""
  );
end

function Utils:OpenTextInEditWindow(text, width, height)
  local frame = AceGUI:Create("Frame");

  frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end);
  frame:SetTitle("Scambuster-Venoxis");
  frame:SetStatusText("Use CTRL+C to copy data");
  frame:SetLayout("Flow");
  frame:SetWidth(width);
  frame:SetHeight(height);

  local editbox = AceGUI:Create("MultiLineEditBox");

  editbox:SetFullWidth(true);
  editbox:SetFullHeight(true);
  editbox:DisableButton(true);
  editbox:SetText(text);

  editbox:HighlightText();
  editbox:SetFocus();

  frame:AddChild(editbox);
end

function Utils:DumpSortedList(List)
  local tmp = {};

  for index, name in ipairs(List.GetSortedNames()) do
    table.insert(tmp, self:FormatReportByCase(index, List.GetEntryByName(name)))
  end;

  self:OpenTextInEditWindow(table.concat(tmp, "\n"), 320, 250);
end

function Utils:IsNameInEntry(entry, name)
  return (type(entry.name) == "string" and entry.name == name)
    or (type(entry.aliases) == "table" and tContains(entry.aliases, name));
end

function Utils:ParseBoolean(param)
  if tContains(ENABLED_STATES, tostring(param):lower()) then
    return true;
  elseif tContains(DISABLED_STATES, tostring(param):lower()) then
    return false;
  else
    return nil;
  end
end

function Utils:AddChatFilter()
  if not CHAT_FILTER_ACTIVE then
    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", CHAT_FILTER);
    MuteSoundFile(FRIENDS_LIST_SOUND);
    CHAT_FILTER_ACTIVE = true;
  end
end

function Utils:RemoveChatFilter()
  if CHAT_FILTER_ACTIVE then
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", CHAT_FILTER);
    UnmuteSoundFile(FRIENDS_LIST_SOUND);
    CHAT_FILTER_ACTIVE = false;
  end
end