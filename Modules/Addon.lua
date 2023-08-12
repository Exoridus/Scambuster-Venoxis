local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local Scambuster = AceAddon:GetAddon("Scambuster");

Addon = AceAddon:NewAddon(Addon, AddonName);

function Addon:OnInitialize()
  Scambuster.RegisterCallback(self, "SCAMBUSTER_LIST_CONSTRUCTION", "RegisterProvider");
end

function Addon:RegisterProvider()
  local Utils = Addon:GetModule("Utils");
  local Blocklist = Addon:GetModule("Blocklist");

  Scambuster:register_case_data({
    name = "Venoxis Discord Blocklist",
    provider = Utils:GetMetadata("X-Credits"),
    description = Utils:GetMetadata("Notes"),
    url = Utils:GetMetadata("X-Website"),
    realm_data = {
      [Utils:GetMetadata("X-LoadOn-Realm")] = Blocklist.Entries,
    }
  });
end