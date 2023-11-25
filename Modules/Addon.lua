local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local AceLocale = LibStub("AceLocale-3.0");
---@type AddonLocale
local L = AceLocale:GetLocale(AddonName);

---@class Addon : AceAddon
Addon = AceAddon:NewAddon(Addon, AddonName);

function Addon:OnInitialize()
  if GetRealmName() ~= "Venoxis" then
    self:SetEnabledState(false);
  end
end

function Addon:OnEnable()
  local Utils = self:GetModule("Utils") --[[@as Utils]];
  local Blocklist = self:GetModule("Blocklist") --[[@as Blocklist]];
  local Scambuster = AceAddon:GetAddon("Scambuster") --[[@as Scambuster]];

  Scambuster:register_case_data({
    name = L.BLOCKLIST_NAME,
    provider = L.BLOCKLIST_PROVIDER,
    description = L.BLOCKLIST_DESCRIPTION,
    url = Utils:GetMetadata("X-Discord"),
    realm_data = { ["Venoxis"] = Blocklist.Entries },
  });
end
