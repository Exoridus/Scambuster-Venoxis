local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local Scambuster = AceAddon:GetAddon("Scambuster");

Addon = AceAddon:NewAddon(Addon, AddonName);

function Addon:OnInitialize()
  Scambuster.RegisterCallback(self, "SCAMBUSTER_LIST_CONSTRUCTION", "RegisterProvider");
end

function Addon:RegisterProvider()
  local Provider = Addon:GetModule("Provider");
  local Blocklist = Addon:GetModule("Blocklist");

  Scambuster:register_case_data({
    name = Provider.GetName(),
    provider = Provider.GetProvider(),
    description = Provider.GetDescription(),
    url = Provider.GetUrl(),
    realm_data = {
      [Provider.GetRealm()] = Blocklist.GetList(),
    }
  });
end