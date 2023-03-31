---@type string, AddonTable
local _, t = ...;

---@type ProviderTable
local provider_table = {
    name = t.my_name,
    provider = t.my_provider,
    description = t.my_description,
    url = t.my_url,
    realm_data = {
        [t.my_realm] = t.case_table
    }
};

---@type AceAddon
local AceAddon = LibStub("AceAddon-3.0");

---@type Scambuster
local Scambuster = AceAddon:GetAddon("Scambuster");

Scambuster:register_case_data(provider_table);
