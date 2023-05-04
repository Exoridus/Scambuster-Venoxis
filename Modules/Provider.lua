--======================================================================================--
-- Provider specific information describing the scope and community behind this list.   --
--======================================================================================--
local Addon = select(2, ...);
local Provider = Addon:NewModule("Provider");

local PROVIDER_NAME = "Venoxis Discord Blocklist";
local PROVIDER_PROVIDER = "Venoxis Discord";
local PROVIDER_REALM = "Venoxis";
local PROVIDER_DESCRIPTION = "Scambuster database of scammers and inappropriate players on Venoxis";
local PROVIDER_URL = "https://discord.gg/NGtvvQYnmP";

function Provider.GetName()
  return PROVIDER_NAME;
end

function Provider.GetProvider()
  return PROVIDER_PROVIDER;
end

function Provider.GetRealm()
  return PROVIDER_REALM;
end

function Provider.GetDescription()
  return PROVIDER_DESCRIPTION
end

function Provider.GetUrl()
  return PROVIDER_URL;
end