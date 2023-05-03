local AddonName, Addon = ...;
local Module = Addon:NewModule("Utils");
local AceGUI = LibStub("AceGUI-3.0");

Module.ADDON_NOTE = "From Scambuster-Venoxis";

Module.RACE_TO_FACTION = {
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

Module.REPORT_TEMPLATE = [[
[%d] = {
  name = "%s",
  guid = "%s",
  class = "%s",
  faction = "%s",
  description = "%s",
  url = "%s",
  category = "%s",
  level = %d,
},]];

local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata;

function Module:GetAddonInfo(prop)
  return GetAddOnMetadata(AddonName, ("%s-%s"):format(prop, GetLocale())) or GetAddOnMetadata(AddonName, prop);
end

function Module:PrepareFriendInfo(info)
  local guid = assert(info.guid);
  local className, class, raceName, race, _, name, server = GetPlayerInfoByGUID(guid);
  local faction = self.RACE_TO_FACTION[race];
  local factionName = FACTION_LABELS_FROM_STRING[faction];
  local realm = server ~= "" and server or GetRealmName();
  local level = info.level and info.level > 0 or 0;

  if info.notes == self.ADDON_NOTE then
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

function Module:FetchPlayerInfo(name, callback)
  local info = C_FriendList.GetFriendInfo(name);

  if info then
    callback(self:PrepareFriendInfo(info));
    return;
  end

  C_FriendList.AddFriend(name, self.ADDON_NOTE);

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

function Module:FormatReportByPlayerInfo(index, info)
  return self.REPORT_TEMPLATE:format(
    index,
    info.name,
    info.guid,
    info.class,
    info.faction,
    "",
    "",
    "",
    3
  );
end

function Module:FormatReportByCase(index, case)
  return self.REPORT_TEMPLATE:format(
    index,
    case.name,
    case.guid,
    case.class,
    case.faction,
    case.description,
    case.url,
    case.category,
    case.level
  );
end

function Module:OpenTextInEditWindow(text)
  local frame = AceGUI:Create("Frame");

  frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end);
  frame:SetTitle("Scambuster-Venoxis");
  frame:SetStatusText("Use CTRL+C to copy data");
  frame:SetLayout("Flow");
  frame:SetWidth(320);
  frame:SetHeight(250);

  local editbox = AceGUI:Create("MultiLineEditBox");

  editbox:SetFullWidth(true);
  editbox:SetFullHeight(true);
  editbox:DisableButton(true);
  editbox:SetText(text);

  editbox:HighlightText();
  editbox:SetFocus();

  frame:AddChild(editbox);
end