local AddonName, Addon = ...;
local AceDB = LibStub("AceDB-3.0");
---@class Config : AceModule
local Config = Addon:NewModule("Config");
local setmetatable = setmetatable;
local OpenToCategory = Settings.OpenToCategory;
local RegisterProxySetting = Settings.RegisterProxySetting;
local CreateCheckBox = Settings.CreateCheckBox;
local RegisterAddOnCategory = Settings.RegisterAddOnCategory;
local RegisterVerticalLayoutCategory = Settings.RegisterVerticalLayoutCategory;
local Boolean = Settings.VarType.Boolean;

Config.defaults = {
  profile = {
    overrideScambuster = true,
    enableGUIDMatching = true, -- require_guid_match false
    disableAllMatching = true, -- match_all_incidents true
    extendAlertLockout = true, -- alert_lockout_seconds 900
    enableSystemAlerts = true, -- use_system_alert true
    disableGroupAlerts = true, -- use_group_chat_alert true
  },
};

function Config:OnInitialize()
  self.db = AceDB:New("ScambusterVenoxisDB", self.defaults, true);

  self.opts = setmetatable({}, {
    __index = self.db.profile,
    __newindex = self.db.profile,
  });
end

function Config:OnEnable()
  local category = RegisterVerticalLayoutCategory(AddonName);

  local overrideScambusterSetting = RegisterProxySetting(category, "overrideScambuster", self.opts, Boolean, "Scambuster überschreiben (empfohlen)");
  local overrideScambusterInitializer = CreateCheckBox(category, overrideScambusterSetting);

  local function IsModifiable()
    return overrideScambusterSetting:GetValue();
  end

  local enableGUIDMatchingSetting = RegisterProxySetting(category, "enableGUIDMatching", self.opts, Boolean, "GUID Matching aktivieren");
  local enableGUIDMatchingInitializer = CreateCheckBox(category, enableGUIDMatchingSetting);
  enableGUIDMatchingInitializer:SetParentInitializer(overrideScambusterInitializer, IsModifiable);

  local disableAllMatchingSetting = RegisterProxySetting(category, "disableAllMatching", self.opts, Boolean, "Name Matching deaktivieren");
  local disableAllMatchingInitializer = CreateCheckBox(category, disableAllMatchingSetting);
  disableAllMatchingInitializer:SetParentInitializer(overrideScambusterInitializer, IsModifiable);

  local extendAlertLockoutSetting = RegisterProxySetting(category, "extendAlertLockout", self.opts, Boolean, "Alert Lockout verlängern");
  local extendAlertLockoutInitializer = CreateCheckBox(category, extendAlertLockoutSetting);
  extendAlertLockoutInitializer:SetParentInitializer(overrideScambusterInitializer, IsModifiable);

  local enableSystemAlertsSetting = RegisterProxySetting(category, "enableSystemAlerts", self.opts, Boolean, "System Messages aktivieren");
  local enableSystemAlertsInitializer = CreateCheckBox(category, enableSystemAlertsSetting);
  enableSystemAlertsInitializer:SetParentInitializer(overrideScambusterInitializer, IsModifiable);

  local disableGroupAlertsSetting = RegisterProxySetting(category, "disableGroupAlerts", self.opts, Boolean, "Gruppen/Raidchat deaktivieren");
  local disableGroupAlertsInitializer = CreateCheckBox(category, disableGroupAlertsSetting);
  disableGroupAlertsInitializer:SetParentInitializer(overrideScambusterInitializer, IsModifiable);

  RegisterAddOnCategory(category);
end

function Config:OpenOptionsFrame()
  OpenToCategory(AddonName);
end
