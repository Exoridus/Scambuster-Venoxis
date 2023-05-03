--======================================================================================--
-- Provider specific information describing the scope and community behind this list.   --
--======================================================================================--
local Addon = select(2, ...);
local Provider = Addon:NewModule("Provider");
local Blocklist = Addon:GetModule("Blocklist");
local Utils = Addon:GetModule("Utils");
local SB = LibStub("AceAddon-3.0"):GetAddon("Scambuster");

local PROVIDER_DATA = {
  Name = "Venoxis Discord Blocklist",
  Provider = "Venoxis Discord",
  Realm = "Venoxis",
  Description = Utils:GetAddonInfo("Notes"),
  Url = Utils:GetAddonInfo("X-Website"),
}

function Provider:OnInitialize()
  SB.RegisterCallback(self, "SCAMBUSTER_LIST_CONSTRUCTION", "RegisterProvider");
end

function Provider:RegisterProvider()
  SB:register_case_data({
    name = PROVIDER_DATA.Name,
    provider = PROVIDER_DATA.Provider,
    description = PROVIDER_DATA.Description,
    url = PROVIDER_DATA.Url,
    realm_data = {
      [PROVIDER_DATA.Realm] = Blocklist.GetList(),
    }
  });
end