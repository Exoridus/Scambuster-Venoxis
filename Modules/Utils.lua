local AddonName, Addon = ...;
local AceGUI = LibStub("AceGUI-3.0");
local AceLocale = LibStub("AceLocale-3.0");
local Utils = Addon:NewModule("Utils");
local L = AceLocale:GetLocale(AddonName);
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata;
local locale = GetLocale();

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

local LIST_ENTRY = [[
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

local LIST_ENTRY_ALIAS = '\n    aliases = { "%s" },';

local GROUP_ENTRY = [[
  [%d] = {
    description = "%s",
    url = "%s",
    category = "%s",
    level = %d,
    players = {
%s
    },
  },]];

local PLAYER_ENTRY = [[
      [%d] = {
        name = "%s",
        guid = "%s",
        class = "%s",
        faction = "%s",%s
      },]];

local PLAYER_ENTRY_ALIAS = '\n        aliases = { "%s" },';

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

local CHAT_FILTER = function(self, _, msg, ...)
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
  local chatMessage = tostring(message);

  if select('#', ...) > 0 then
    chatFrame:AddMessage(format(chatMessage, ...));
  else
    chatFrame:AddMessage(chatMessage);
  end
end

function Utils:PrintAddonMessage(message, ...)
  local chatPrefix = self:WrapColor(AddonName, "FF33FF99");
  local chatMessage = tostring(message);

  if select('#', ...) > 0 then
    self:Print("%s: %s", chatPrefix, format(chatMessage, ...));
  else
    self:Print("%s: %s", chatPrefix, chatMessage);
  end
end

function Utils:PrintCommand(slashCommand, description)
  local slash, action, args = strtrim(slashCommand):match("^(%/%a+)%s*(%a*)%s*(.*)$");
  local command = self:WrapColor(format("%s %s", slash, action), "FFFFFF33");

  if strlen(args) > 0 then
    self:Print("%s %s - %s", command, self:WrapColor(args, "FF33FF33"), description);
  else
    self:Print("%s - %s", command, description);
  end
end

function Utils:PrintTitle(title)
  self:Print(self:WrapColor("[%s]", "FF33FFFF"), title);
end

function Utils:PrintKeyValue(key, value)
  self:Print("%s %s", self:WrapColor(format("%s:", key), "FFFFFF33"), value);
end

function Utils:PrintWarning(message)
  self:Print("%s %s", self:WrapColor(L["CAUTION"], "FFFF9933"), message);
end

function Utils:CreateCopyDialog(text, width, height)
  local frame = AceGUI:Create("Frame");

  frame:SetCallback("OnClose", function(widget)
    AceGUI:Release(widget)
  end);
  frame:SetTitle(AddonName);
  frame:SetStatusText(L["COPY_SHORTCUT_INFO"]);
  frame:SetLayout("Flow");
  frame:SetWidth(width or 320);
  frame:SetHeight(height or 250);

  local editbox = AceGUI:Create("MultiLineEditBox");

  editbox:SetFullWidth(true);
  editbox:SetFullHeight(true);
  editbox:DisableButton(true);
  editbox:SetText(text);

  editbox:HighlightText();
  editbox:SetFocus();

  frame:AddChild(editbox);
end

function Utils:FetchPlayerInfo(name, callback)
  self:AddChatFilter();

  self:FetchFriendInfo(name, function(info)
    if info then
      if info.notes == L["FRIENDS_LIST_NOTE"] then
        C_FriendList.RemoveFriend(name);
      end

      self:RemoveChatFilter();
      self:FetchGUIDInfo(info.guid, callback);
    else
      callback(nil);
    end
  end);
end

function Utils:GetGUIDInfo(guid)
  local className, class, raceName, race, _, name, server = GetPlayerInfoByGUID(guid);

  if name and race and class then
    local faction = RACE_TO_FACTION[race];
    local factionName = FACTION_LABELS_FROM_STRING[faction];
    local realm = server ~= "" and server or GetRealmName();

    if realm ~= "Venoxis" then
      self:PrintWarning(format(L["GUID_FROM_ANOTHER_REALM"], realm));
    end

    return {
      guid = guid,
      name = name,
      className = className,
      class = class,
      raceName = raceName,
      race = race,
      faction = faction,
      factionName = factionName,
      realm = realm,
    };
  end
end

function Utils:FetchGUIDInfo(guid, callback)
  local info = self:GetGUIDInfo(guid);

  if info then
    callback(info);
    return;
  end

  local ticks, maxTicks = 0, 4;
  local ticker;

  ticker = C_Timer.NewTicker(0.5, function()
    ticks = ticks + 1;
    info = self:GetGUIDInfo(guid);

    if info or ticks == maxTicks then
      ticker:Cancel();
      callback(info or nil);
    end
  end, maxTicks);
end

function Utils:FetchFriendInfo(name, callback)
  local info = C_FriendList.GetFriendInfo(name);

  if info then
    callback(info);
    return;
  end

  local ticks, maxTicks = 0, 4;
  local ticker;

  C_FriendList.AddFriend(name, L["FRIENDS_LIST_NOTE"]);

  ticker = C_Timer.NewTicker(0.5, function()
    ticks = ticks + 1;
    info = C_FriendList.GetFriendInfo(name);

    if info or ticks == maxTicks then
      ticker:Cancel();
      callback(info or nil);
    end
  end, maxTicks);
end

function Utils:GetPlayerInfoProps(info)
  local props = {};

  tinsert(props, { key = NAME, value = info.name });
  tinsert(props, { key = "GUID", value = info.guid });
  tinsert(props, { key = RACE, value = info.raceName });
  tinsert(props, { key = CLASS, value = self:ClassColor(info.className, info.class) });
  tinsert(props, { key = FACTION, value = self:FactionColor(info.factionName, info.faction) });

  return props;
end

function Utils:FormatAliases(entry, template)
  if type(entry.aliases) ~= "table" or #entry.aliases == 0 then
    return "";
  end

  return format(template, table.concat(entry.aliases, '", "'));
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
        self:FormatAliases(player, PLAYER_ENTRY_ALIAS)
      ));
    end

    return GROUP_ENTRY:format(
      index,
      entry.description,
      entry.url,
      entry.category,
      entry.level,
      table.concat(players, '\n')
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

function Utils:WrapColor(text, color)
  return WrapTextInColorCode(tostring(text), assert(color));
end

function Utils:ClassColor(text, className)
  return GetClassColorObj(className):WrapTextInColorCode(text);
end

function Utils:FactionColor(text, factionName)
  return GetFactionColor(factionName):WrapTextInColorCode(text);
end

function Utils:GetMetadata(prop)
  return GetAddOnMetadata(AddonName, format("%s-%s", prop, locale)) or GetAddOnMetadata(AddonName, prop);
end
