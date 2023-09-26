local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local AceLocale = LibStub("AceLocale-3.0");
local Scambuster = AceAddon:GetAddon("Scambuster");
local L = AceLocale:GetLocale(AddonName);

Addon = AceAddon:NewAddon(Addon, AddonName);

function Addon:OnInitialize()
  if GetRealmName() == "Venoxis" then
    Scambuster.RegisterCallback(self, "SCAMBUSTER_LIST_CONSTRUCTION", "RegisterProvider");
  elseif Addon:IsEnabled() then
    Addon:Disable();
  end
end

function Addon:RegisterProvider()
  local Utils = Addon:GetModule("Utils");
  local Blocklist = Addon:GetModule("Blocklist");

  Scambuster:register_case_data({
    name = L["BLOCKLIST_NAME"],
    provider = L["BLOCKLIST_PROVIDER"],
    description = L["BLOCKLIST_DESCRIPTION"],
    url = Utils:GetAddOnMetadata("X-Website"),
    realm_data = {
      ["Venoxis"] = Blocklist.Entries,
    }
  });
end
