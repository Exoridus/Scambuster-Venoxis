local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local Scambuster = AceAddon:GetAddon("Scambuster") --[[@as Scambuster]];
local L = LibStub("AceLocale-3.0"):GetLocale(AddonName) --[[@as AddonLocale]];

---@class Addon : AceAddon
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
  local Utils = self:GetModule("Utils") --[[@as Utils]];
  local Blocklist = self:GetModule("Blocklist") --[[@as Blocklist]];

  Scambuster:register_case_data({
    name = L.BLOCKLIST_NAME,
    provider = L.BLOCKLIST_PROVIDER,
    description = L.BLOCKLIST_DESCRIPTION,
    url = Utils:GetMetadata("X-Discord"),
    realm_data = { Venoxis = Blocklist.Entries },
  });
end
