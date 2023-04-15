local n, ns = ...;
local AceAddon = LibStub("AceAddon-3.0");
local Addon = AceAddon:GetAddon(n);
local Module = Addon:NewModule("Provider", "AceConsole-3.0");
---@type Scambuster
local SB = AceAddon:GetAddon("Scambuster");

function Module:OnInitialize()
  self.name = "Venoxis Discord Blocklist";
  self.provider = "Venoxis Discord";
  self.description = "A list of scammers curated by the venoxis discord community.";
  self.realm = "Venoxis";
  self.url = "https://discord.gg/NGtvvQYnmP";
  self.blocklist = ns.blocklist;

  SB.RegisterCallback(self, "SCAMBUSTER_LIST_CONSTRUCTION", "RegisterProviderData");
end

function Module:RegisterProviderData()
  SB:register_case_data({
    name = self.name,
    provider = self.provider,
    description = self.description,
    url = self.url,
    realm_data = {
      [self.realm] = self.blocklist,
    }
  });
end