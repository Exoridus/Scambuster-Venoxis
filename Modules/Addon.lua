local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local AceLocale = LibStub("AceLocale-3.0");
local L = AceLocale:GetLocale(AddonName);
local GetRealmName = GetRealmName;
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata;

Addon = AceAddon:NewAddon(Addon, AddonName);

function Addon:OnInitialize()
  if GetRealmName() ~= "Venoxis" then
    self:Disable();
  end
end

function Addon:OnEnable()
  local Blocklist = self:GetModule("Blocklist");

  AceAddon:GetAddon("Scambuster"):register_case_data({
    name = L["BLOCKLIST_NAME"],
    provider = L["BLOCKLIST_PROVIDER"],
    description = L["BLOCKLIST_DESCRIPTION"],
    url = GetAddOnMetadata(AddonName, "X-Website"),
    realm_data = {
      ["Venoxis"] = Blocklist.Entries,
    },
  });
end
