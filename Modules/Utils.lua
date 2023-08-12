local AddonName, Addon = ...;
local AceGUI = LibStub("AceGUI-3.0");
local AceLocale = LibStub("AceLocale-3.0");
local Utils = Addon:NewModule("Utils");
local L = AceLocale:GetLocale(AddonName);
local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata

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

local ALIAS_PROP = '\n    aliases = { "%s" },';

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
local CHAT_FILTER = function (self, _, msg, ...)
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

function Utils:CreateCopyDialog(text, width, height)
  local frame = AceGUI:Create("Frame");

  frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end);
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

    info = C_FriendList.GetFriendInfo(name);

    if info then
      ticker:Cancel();
      callback(self:PrepareFriendInfo(info));
    elseif ticks == maxTicks then
      callback(nil);
    end
  end, maxTicks);
end

function Utils:GetGUIDInfo(guid)
  local _, class, _, race, _, name = GetPlayerInfoByGUID(guid);
  local faction = RACE_TO_FACTION[race];

  if name and class and faction then
    return {
      guid = guid,
      name = name,
      class = class,
      faction = faction,
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

    if info then
      ticker:Cancel();
      callback(info);
    elseif ticks == maxTicks then
      callback(nil);
    end
  end, maxTicks);
end

function Utils:GetPlayerInfoProps(info)
  local props = {};

  tinsert(props, { key = NAME, value = info.name });
  tinsert(props, { key = "GUID", value = info.guid });

  if info.level > 0 then
    tinsert(props, { key = LEVEL, value = info.level });
  end

  tinsert(props, { key = RACE, value = info.raceName });
  tinsert(props, { key = CLASS, value = self:ClassColor(info.className, info.class) });
  tinsert(props, { key = FACTION, value = self:FactionColor(info.factionName, info.faction) });

  return props;
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
        (player.aliases and #player.aliases > 0) and PLAYER_ENTRY_ALIAS:format(table.concat(player.aliases, '", "')) or ""
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
    (entry.aliases and #entry.aliases > 0) and ALIAS_PROP:format(table.concat(entry.aliases, '", "')) or ""
  );
end

function Utils:PrintPlayerInfo(info)
  for _, prop in ipairs(self:GetPlayerInfoProps(info)) do
    self:PrintKeyValue(prop.key, prop.value);
  end
end

function Utils:ReportPlayerInfo(info, index)
  self:CreateCopyDialog(self:FormatListItemEntry(index, {
    name = info.name,
    guid = info.guid,
    class = info.className,
    faction = info.factionName,
    description = "",
    url = "",
    category = "",
    level = 3,
  }));
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

function Utils:IsPlayerNameInEntry(entry, playerName)
  local name = self:NormaliseName(playerName);

  if type(entry) ~= "table" or type(name) ~= "string" then
    return false;
  end

  if entry.players then
    for _, player in pairs(entry.players) do
      if self:IsPlayerNameInEntry(player, name) then
        return true;
      end
    end
    return;
  end

  if self:NormaliseName(entry.name) == name then
    return true;
  end

  if type(entry.aliases) == "table" then
    for _, alias in pairs(entry.aliases) do
      if self:NormaliseName(alias) == name then
        return true;
      end
    end
  end

  return false;
end

function Utils:GetEntriesByPlayerName(entries, playerName)
  local result = {};

  for _, entry in pairs(entries) do
    if self:IsPlayerNameInEntry(entry, playerName) then
      tinsert(result, entry);
    end
  end

  return result;
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
  return GetAddOnMetadata(prop..format("-%s", GetLocale())) or GetAddOnMetadata(prop);
end
