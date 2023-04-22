local ns = select(2, ...);
local AceAddon = LibStub("AceAddon-3.0");
local AceGUI = LibStub("AceGUI-3.0");
local Addon = AceAddon:NewAddon("Scambuster-Venoxis", "AceConsole-3.0");
local raceToFaction = {
  Human = "Alliance",
  Dwarf = "Alliance",
  NightElf = "Alliance",
  Draenei = "Alliance",
  Gnome = "Alliance",
  Orc = "Horde",
  Scourge = "Horde",
  Tauren = "Horde",
  Troll = "Horde",
  BloodElf = "Horde",
};
local infoTemplate = [[
{
  name = "%s",
  guid = "%s",
  class = "%s",
  faction = "%s",
  description = "",
  url = "",
  category = "",
  level = 3,
}]];

function Addon:OnInitialize()
  self:RegisterChatCommand("venoxis", "SlashCommand");
end

function Addon:SlashCommand(input)
  local action, param = self:GetArgs(input, 2);

  if not action or action == "help" then
    self:PrintInfo("/venoxis help (triggers this help text)");
    self:PrintInfo("/venoxis print NAME (prints player info inside the chat)");
    self:PrintInfo("/venoxis info NAME (prints player info in copy & paste window)");
    self:PrintInfo("/venoxis check NAME (check if player was found on blocklist)");
    return;
  end

  if not param then
    self:PrintInfo("Please provide a name to check against.");
  elseif action == "info" then
    self:showPlayerInfo(param);
  elseif action == "print" then
    self:printPlayerInfo(param);
  elseif action == "check" then
    self:printPlayerCases(param);
  end
end

function Addon:PrintInfo(text, ...)
  if select('#', ...) > 0 then
    self:Printf(SELECTED_CHAT_FRAME, text, ...);
  else
    self:Print(SELECTED_CHAT_FRAME, text);
  end
end

function Addon:PrintNameNotFoundInfo(name)
  self:PrintInfo("Failed requesting GUID for \"%s\". Possible reasons:", name);
  self:PrintInfo("1. The character name is misspelled and contains typos.");
  self:PrintInfo("2. The character is on the opposite faction as you.");
  self:PrintInfo("3. The character was renamed, deleted or transferred.");
  self:PrintInfo("4. Your friendlist has no free slots left which is required.");
end

function Addon:fetchGUID(name, callback)
  local info = C_FriendList.GetFriendInfo(name);

  if info then
    callback(info.guid);
    return;
  end

  local numFriends = C_FriendList.GetNumFriends();

  C_FriendList.AddFriend(name, "From Scambuster-Venoxis");

  C_Timer.After(1, function ()
    local info = C_FriendList.GetFriendInfo(name);

    callback(info and info.guid);

    if C_FriendList.GetNumFriends() == (numFriends + 1) then
      C_FriendList.RemoveFriend(name);
    end
  end);
end

function Addon:showCopyTextFrame(text)
  local frame = AceGUI:Create("Frame")

  frame:SetTitle("Scambuster Copy Entry")
  frame:SetStatusText("Use CTRL+C to copy data")
  frame:SetLayout("Flow")
  frame:SetWidth(320)
  frame:SetHeight(250)
  frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)

  local editbox = AceGUI:Create("MultiLineEditBox")

  editbox:SetText(text)
  editbox:SetFullWidth(true)
  editbox:SetFullHeight(true)
  editbox:DisableButton(true)
  editbox:HighlightText()

  frame:AddChild(editbox)
end

function Addon:printPlayerInfo(name)
  self:fetchGUID(name, function(guid)
    if guid then
      local _, class, _, race = GetPlayerInfoByGUID(guid);
      self:PrintInfo("name: %s", name);
      self:PrintInfo("guid: %s", guid);
      self:PrintInfo("class: %s", class);
      self:PrintInfo("faction: %s", raceToFaction[race]);
    else
      self:PrintNameNotFoundInfo(name);
    end
  end);
end

function Addon:showPlayerInfo(name)
  self:fetchGUID(name, function(guid)
    if guid then
      local _, class, _, race = GetPlayerInfoByGUID(guid);
      self:showCopyTextFrame(infoTemplate:format(name, guid, class, raceToFaction[race]));
    else
      self:PrintNameNotFoundInfo(name);
    end
  end);
end

function Addon:includesName(case, name)
  return (type(case.name) == "string" and case.name == name) or (type(case.aliases) == "table" and tContains(case.aliases, name));
end

function Addon:printPlayerCases(name)
  if not name then
    self:PrintInfo("Please provide a name to check against.");
    return;
  end

  local indices = {};

  for i,v in ipairs(ns.blocklist) do
    if type(v.players) == "table" then
      for _,p in pairs(v.players) do
        if self:includesName(p, name) then
          table.insert(indices, i);
          break;
        end
      end
    elseif self:includesName(v, name) then
      table.insert(indices, i);
    end
  end

  if #indices > 0 then
    self:PrintInfo("Found %d entries on player %s: %s", #indices, name, indices:concat(", "));
  else
    self:PrintInfo("No entries found on player %s", name);
  end
end