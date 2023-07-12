local _, Addon = ...;
local AceDB = LibStub("AceDB-3.0");
local Config = Addon:NewModule("Config");

local defaults = {
  global = {
    debugMode = false,
  }
};

function Config:OnInitialize()
  self.db = AceDB:New("ScambusterVenoxisDB", defaults);
end

function Config:DebugMode(param)
  if type(param) == "boolean" then
    self.db.global.debugMode = param;
  end

  return self.db.global.debugMode;
end