local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local AceConfig = LibStub("AceConfig-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");
local AceDB = LibStub("AceDB-3.0");
local AceLocale = LibStub("AceLocale-3.0");
local Config = Addon:NewModule("Config", "LibAboutPanel-2.0");
local Utils = Addon:GetModule("Utils");
local Scambuster = AceAddon:GetAddon("Scambuster");
local L = AceLocale:GetLocale(AddonName);
local GetCategory = Settings.GetCategory;
local OpenToCategory = Settings.OpenToCategory;

Config.defaults = {
  profile = {
    showGUIDDialog = true,
  },
};

function Config:OnInitialize()
  self.db = AceDB:New("ScambusterVenoxisDB", self.defaults, true);

  self.opts = setmetatable({}, {
    __index = self.db.profile,
    __newindex = self.db.profile,
  });

  AceConfig:RegisterOptionsTable(AddonName, self:AboutOptionsTable(AddonName));
  AceConfigDialog:AddToBlizOptions(AddonName, AddonName);

  if self.opts.showGUIDDialog == true and Scambuster.db.profile.require_guid_match == false then
    self:ShowGUIDMatchingDialog();
  end
end

function Config:ShowGUIDMatchingDialog()
  StaticPopup_Show("SCAMBUSTER_GUID_MATCHING_DIALOG", nil, nil, {
    callback = function(button)
      self.opts.showGUIDDialog = false;

      if button == 1 then
        Scambuster.db.profile.require_guid_match = true;
        Utils:PrintAddonMessage(L["GUID_MATCHING_ENABLED"]);
      end
    end
  });
end

function Config:OpenOptionsFrame(categoryName)
  local category = GetCategory(AddonName);

  if category and category:HasSubcategories() then
    category.expanded = true;

    if type(categoryName) == "string" then
      for _, subcategory in ipairs(category:GetSubcategories()) do
        if strupper(subcategory:GetName()) == strupper(categoryName) then
          OpenToCategory(subcategory:GetID());
        end
      end
    end
  end

  OpenToCategory(AddonName);
end

StaticPopupDialogs["SCAMBUSTER_GUID_MATCHING_DIALOG"] = {
  text = L["TURN_ON_GUID_MATCHING"],
  subText = L["GUID_MATCHING_DESCRIPTION"],
  button1 = ACTIVATE,
  button2 = IGNORE,
  OnButton1 = function(_, data)
    data.callback(1)
  end,
  OnButton2 = function(_, data)
    data.callback(2)
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = false,
  noCancelOnReuse = true,
  notClosableByLogout = true,
  enterClicksFirstButton = true,
  interruptCinematic = true,
  preferredIndex = 3,
};
