local AddonName, Addon = ...;
local LibDeflate = LibStub("LibDeflate");
local LibSerialize = LibStub("LibSerialize");
local AceLocale = LibStub("AceLocale-3.0");
local Utils = Addon:GetModule("Utils") --[[@as Utils]];
local Networking = Addon:NewModule("Networking", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0");
---@type AddonLocale
local L = AceLocale:GetLocale(AddonName);

---@enum MessageTypes
local MessageTypes = {
	Version = 1,
};

---@enum (key) Channels
local Channels = {
  RAID = true,
  PARTY = true,
  INSTANCE_CHAT = true,
  GUILD = true,
};

---@enum Flags
local SEND_VERSION_GUILD = 0x01;
local SEND_VERSION_GROUP = 0x02;
local SEND_VERSION_INSTANCE = 0x04;

function Networking:OnInitialize()
  self.flags = CreateFlags();
  self.commPrefix = "SBV";
  self.playerName = UnitName("player");
  self.playerVersion = Utils:VersionToNumber(Utils:GetMetadata("Version"));
  self.suggestUpdate = true;
  self.debug = false;
end

function Networking:OnEnable()
  self:RegisterComm(self.commPrefix);
  self:RegisterEvent("PLAYER_LOGIN");
  self:RegisterEvent("GROUP_FORMED");
  self:ScheduleRepeatingTimer("TimerFeedback", 10);
end

function Networking:PLAYER_LOGIN()
  if IsInGuild() then
    self.flags:Set(SEND_VERSION_GUILD);
  end
  if IsInGroup(LE_PARTY_CATEGORY_HOME) then
    self.flags:Set(SEND_VERSION_GROUP);
  end
  if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
    self.flags:Set(SEND_VERSION_INSTANCE);
  end
end

---@param category integer
function Networking:GROUP_FORMED(_, category)
  if category == LE_PARTY_CATEGORY_HOME then
    self.flags:Set(SEND_VERSION_GROUP);
  elseif category == LE_PARTY_CATEGORY_INSTANCE then
    self.flags:Set(SEND_VERSION_INSTANCE);
  end
end

function Networking:TimerFeedback()
  if self.debug then
    print("TimerFeedback", format("0x%X", self.flags:GetFlags()));
  end
  if self.flags:IsSet(SEND_VERSION_GUILD) then
    self:SendMessage("GUILD", MessageTypes.Version, self.playerVersion);
  end
  if self.flags:IsSet(SEND_VERSION_GROUP) then
    self:SendMessage("RAID", MessageTypes.Version, self.playerVersion);
  end
  if self.flags:IsSet(SEND_VERSION_INSTANCE) then
    self:SendMessage("INSTANCE_CHAT", MessageTypes.Version, self.playerVersion);
  end

  self.flags:ClearAll();
end

---@param channel Channels
---@param messageType MessageTypes
---@param ... any
function Networking:SendMessage(channel, messageType, ...)
	local serialized = LibSerialize:Serialize(messageType, {...});
  local compressed = LibDeflate:CompressDeflate(serialized);
  local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed);

  if self.debug then
    DevTools_Dump("SendCommMessage", { channel, messageType, ... });
  end

  self:SendCommMessage(self.commPrefix, encoded, channel);
end

---@param _ string
---@param encoded string
---@param channel Channels
---@param sender string
function Networking:OnCommReceived(_, encoded, channel, sender)
  if not Channels[channel] or sender == self.playerName then return end
  local decoded = LibDeflate:DecodeForWoWAddonChannel(encoded);
  if not decoded then return end
  local decompressed = LibDeflate:DecompressDeflate(decoded);
  if not decompressed then return end
  local success, comm, data = LibSerialize:Deserialize(decompressed);
  if not (success and MessageTypes[comm]) then return end

  if self.debug then
    DevTools_Dump("OnCommReceived", { channel, sender, comm, data });
  end

  if comm == MessageTypes.Version then
    local otherVersion = unpack(data);

    if self.playerVersion < otherVersion and self.suggestUpdate then
      Utils:PrintAddonMessage(L.NEW_VERSION_AVAILABLE);
      Utils:PrintAddonMessage(L.PLEASE_UPDATE_ASAP);
      self.suggestUpdate = false;
    end
  end
end
