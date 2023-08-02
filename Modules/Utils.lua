local AddonName, Addon = ...;
local AceGUI = LibStub("AceGUI-3.0");
local AceLocale = LibStub("AceLocale-3.0");
local Utils = Addon:NewModule("Utils");
local L = AceLocale:GetLocale(AddonName);

local RACE_TO_FACTION = {
  Orc = "Horde",
  Scourge = "Horde",
  Tauren = "Horde",
  Troll = "Horde",
  BloodElf = "Horde",
  BloodElf = "Horde",
  Human = "Alliance",
  Dwarf = "Alliance",
  NightElf = "Alliance",
  Draenei = "Alliance",
  Gnome = "Alliance",
};

local PLAYER_INFO_ENTRY = [[
{
  name = "%s",
  guid = "%s",
  class = "%s",
  faction = "%s",
  description = "",
  url = "",
  category = "",
  level = 3,
},]];

local LIST_ITEM_ENTRY = [[
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

local ALIAS_PROP = '\n  aliases = { "%s" },';
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
  self:Print("%s %s", self:WrapColor(format("%s: ", key), "FFFFFF33"), value);
end

function Utils:PrintWarning(message)
  self:Print("%s %s", self:WrapColor(L["CAUTION"], "FFFF9933"), message);
end

function Utils:PrepareFriendInfo(info)
  local guid = assert(info.guid);
  local className, class, raceName, race, _, name, server = GetPlayerInfoByGUID(guid);
  local faction = RACE_TO_FACTION[race];
  local factionName = FACTION_LABELS_FROM_STRING[faction];
  local realm = server ~= "" and server or GetRealmName();
  local level = type(info.level) == "number" and info.level or 0;

  if realm and realm ~= "Venoxis" then
    self:PrintWarning(format(L["GUID_FROM_ANOTHER_REALM"], realm));
  end

  if info.notes == L["FRIENDS_LIST_NOTE"] then
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

  C_FriendList.AddFriend(name, L["FRIENDS_LIST_NOTE"]);

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

function Utils:FormatPlayerInfoEntries(info)
  local result = {};

  tinsert(result, { key = NAME, value = info.name });
  tinsert(result, { key = "GUID", value = info.guid });

  if info.level > 0 then
    tinsert(result, { key = LEVEL, value = info.level });
  end

  tinsert(result, { key = RACE, value = info.raceName });
  tinsert(result, { key = CLASS, value = self:ClassColor(info.className, info.class) });
  tinsert(result, { key = FACTION, value = self:FactionColor(info.factionName, info.faction) });

  return result;
end

function Utils:FormatPlayerInfoEntry(info)
  return format(PLAYER_INFO_ENTRY,
    info.name,
    info.guid,
    info.class,
    info.faction
  );
end

function Utils:FormatListItemEntry(index, entry)
  return format(LIST_ITEM_ENTRY,
    index,
    entry.name,
    entry.guid,
    entry.class,
    entry.faction,
    entry.description,
    entry.url,
    entry.category,
    entry.level,
    (entry.aliases and #entry.aliases > 0) and format(ALIAS_PROP, table.concat(entry.aliases, '", "')) or ""
  );
end

function Utils:OpenTextInEditWindow(text, width, height)
  local frame = AceGUI:Create("Frame");

  frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end);
  frame:SetTitle(AddonName);
  frame:SetStatusText(L["COPY_SHORTCUT_INFO"]);
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

function Utils:PrintPlayerInfoInChat(info)
  local entries = self:FormatPlayerInfoEntries(info);

  for _, entry in ipairs(entries) do
    self:PrintKeyValue(entry.key, entry.value);
  end
end

function Utils:OpenPlayerInfoReportWindow(info)
  self:OpenTextInEditWindow(self:FormatPlayerInfoEntry(info), 320, 250);
end

function Utils:PrintPlayerNotFoundInfo(name)
  self:PrintAddonMessage(L["PLAYER_NOT_FOUND_TITLE"], name);
  self:Print(L["PLAYER_NOT_FOUND_REASON_1"]);
  self:Print(L["PLAYER_NOT_FOUND_REASON_2"]);
  self:Print(L["PLAYER_NOT_FOUND_REASON_3"]);
  self:Print(L["PLAYER_NOT_FOUND_REASON_4"]);
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

function Utils:GetSortedPlayerNames(entries)
  local names = {};

  for _, entry in pairs(entries) do
    tInsertUnique(names, entry.name);
  end

  table.sort(names);

  return names;
end

function Utils:NormaliseName(name)
  if type(name) ~= "string" then
    return;
  end

  local normalized = strtrim(strlower(name));

  if strlen(normalized) < 2 then
    return;
  end

  return normalized;
end

function Utils:IsPlayerNameInEntry(entry, playerName, includeAliases)
  local name = self:NormaliseName(playerName);

  if type(entry) ~= "table" or type(name) ~= "string" then
    return false;
  end

  if self:NormaliseName(entry.name) == name then
    return true;
  end

  if type(includeAliases) ~= "boolean" then
    includeAliases = true;
  end

  if includeAliases == true and type(entry.aliases) == "table" then
    for _, alias in pairs(entry.aliases) do
      if self:NormaliseName(alias) == name then
        return true;
      end
    end
  end

  return false;
end

function Utils:GetEntriesByPlayerName(entries, playerName, includeAliases)
  local result = {};

  for _, entry in pairs(entries) do
    if self:IsPlayerNameInEntry(entry, playerName, includeAliases) then
      tinsert(result, entry);
    end
  end

  return result;
end

function Utils:DumpList(List)
  local entries = List.GetEntries();
  local result = {};
  local index = 1;

  for _, name in ipairs(List.GetPlayerNames()) do
    for _, entry in ipairs(self:GetEntriesByPlayerName(entries, name, false)) do
      tinsert(result, self:FormatListItemEntry(index, entry));
      index = index + 1;
    end
  end

  self:OpenTextInEditWindow(table.concat(result, "\n"), 320, 250);
end

function Utils:WrapColor(text, color)
  return WrapTextInColorCode(tostring(text), assert(color));
end

function Utils:ClassColor(text, className)
  return self:WrapColor(text, RAID_CLASS_COLORS[className].colorStr);
end

function Utils:FactionColor(text, faction)
  return self:WrapColor(text, GetFactionColor(faction):GenerateHexColor());
end