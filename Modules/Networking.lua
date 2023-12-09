---@type AddonName, Addon
local _, Addon = ...;
local LibDeflate = LibStub("LibDeflate");
local LibSerialize = LibStub("LibSerialize");
local Utils = Addon:GetModule("Utils");
---@class Networking: AceModule, AceEvent-3.0, AceComm-3.0, AceTimer-3.0
local Networking = Addon:NewModule("Networking", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0");
local L = Addon.L;

---@enum MessageID
local MessageID = {
	Version = 1,
};

---@enum (key) Channels
local Channels = {
  RAID = true,
  PARTY = true,
  INSTANCE_CHAT = true,
  GUILD = true,
};

local SEND_VERSION_GUILD = 0x01;
local SEND_VERSION_GROUP = 0x02;
local SEND_VERSION_INSTANCE = 0x04;

function Networking:OnInitialize()
  self.flags = CreateFromMixins(FlagsMixin);
  self.flags:OnLoad();
  self.commPrefix = "SBV";
  self.playerName = UnitName("player");
  self.playerVersion = Utils:VersionToNumber(Utils:GetMetadata("Version"));
  self.suggestUpdate = true;
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
  if self.flags:IsSet(SEND_VERSION_GUILD) then
    self:Send("GUILD", MessageID.Version, self.playerVersion);
  end
  if self.flags:IsSet(SEND_VERSION_GROUP) then
    self:Send("RAID", MessageID.Version, self.playerVersion);
  end
  if self.flags:IsSet(SEND_VERSION_INSTANCE) then
    self:Send("INSTANCE_CHAT", MessageID.Version, self.playerVersion);
  end

  self.flags:ClearAll();
end

---@param channel Channels
---@param messageID MessageID
---@param ... unknown
function Networking:Send(channel, messageID, ...)
	local serialized = LibSerialize:Serialize(messageID, {...});
  local compressed = LibDeflate:CompressDeflate(serialized);
  local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed);

  self:SendCommMessage(self.commPrefix, encoded, channel);
end

---@param _ string
---@param encoded string
---@param channel Channels
---@param sender string
function Networking:OnCommReceived(_, encoded, channel, sender)
  if not Channels[channel] or sender == self.playerName then
    return
  end
  local decoded = LibDeflate:DecodeForWoWAddonChannel(encoded);
  if not decoded then
    return
  end
  local decompressed = LibDeflate:DecompressDeflate(decoded);
  if not decompressed then
    return
  end
  ---@type boolean, MessageID|string, table?
  local success, id, data = LibSerialize:Deserialize(decompressed);
  if not success then return end

  ---@cast id -string
  ---@cast data -nil

  if id == MessageID.Version then
    ---@type number
    local otherVersion = unpack(data);

    if self.playerVersion < otherVersion and self.suggestUpdate then
      Utils:PrintAddonMessage(L.UPDATE_NOTICE);
      self.suggestUpdate = false;
    end
  end
end
