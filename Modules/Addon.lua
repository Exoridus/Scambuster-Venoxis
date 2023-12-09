---@type AddonName, Addon
local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local Scambuster = AceAddon:GetAddon("Scambuster");
---@type AddonLocale
local L = LibStub("AceLocale-3.0"):GetLocale(AddonName);

---@class Addon: AceAddon
Addon = AceAddon:NewAddon(Addon, AddonName);
Addon.L = L;

Scambuster.defaults.profile.require_guid_match = true;
Scambuster.defaults.profile.match_all_incidents = false;
Scambuster.defaults.profile.use_group_chat_alert = false;
Scambuster.defaults.profile.alert_lockout_seconds = 10000;

function Addon:OnInitialize()
  Scambuster.RegisterCallback(self, "SCAMBUSTER_LIST_CONSTRUCTION", "RegisterProvider");
end

function Addon:RegisterProvider()
  local Utils = self:GetModule("Utils");
  local Blocklist = self:GetModule("Blocklist");

  Scambuster:register_case_data({
    name = "Venoxis Discord Blocklist",
    provider = Utils:GetMetadata("X-Discord"),
    description = Utils:GetMetadata("Notes", true),
    url = Utils:GetMetadata("X-Discord"),
    realm_data = { Venoxis = Blocklist.Entries },
  });
end
