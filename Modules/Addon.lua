local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local AceLocale = LibStub("AceLocale-3.0");
local Scambuster = AceAddon:GetAddon("Scambuster") --[[@as Scambuster]];
---@type AddonLocale
local L = AceLocale:GetLocale(AddonName);

---@class Addon : AceAddon
Addon = AceAddon:NewAddon(Addon, AddonName);

function Addon:OnInitialize()
  if GetRealmName() == "Venoxis" then
    Scambuster.RegisterCallback(self, "SCAMBUSTER_LIST_CONSTRUCTION", "RegisterProvider");
  elseif self:IsEnabled() then
    self:SetEnabledState(false);
  end
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
