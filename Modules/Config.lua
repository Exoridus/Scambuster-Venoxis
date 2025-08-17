---@type AddonName, Addon
local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local AceConfig = LibStub("AceConfig-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");
local AceDB = LibStub("AceDB-3.0");
local AceDBOptions = LibStub("AceDBOptions-3.0");
local Utils = Addon:GetModule("Utils");
---@class Config : AceModule
---@field db AceDBObject-3.0
---@field defaults table
---@field options table
---@field opts table
local Config = Addon:NewModule("Config");
local L = Addon.L;

Config.defaults = {
  profile = {
    settings = {
      welcomeMessage = true,
      debugMode = false,
    },
    overrides = {
      enableGUIDMatching = true, -- require_guid_match false
      disableAllMatching = true, -- match_all_incidents true
      extendAlertLockout = true, -- alert_lockout_seconds 900
      disableGroupAlerts = true, -- use_group_chat_alert true
    },
  },
};

Config.options = {
  type = "group",
  name = AddonName,
  desc = AddonName,
  args = {},
};

---@param info table
---@return table?
function Config.GetArg(info)
  return info.arg;
end

---@param info table
---@return any
function Config.GetOption(info)
  ---@diagnostic disable-next-line: no-unknown
  local parent = info[#info - 1];
  ---@diagnostic disable-next-line: no-unknown
  local option = info[#info];
  print("GetOption", parent, option, #info);
  DevTools_Dump(info);
  DevTools_Dump(Config.db.profile[parent][option]);
  return Config.db.profile[parent][option];
end

---@param info table
---@param value any
function Config.SetOption(info, value)
  ---@diagnostic disable-next-line: no-unknown
  local parent = info[#info - 1];
  ---@diagnostic disable-next-line: no-unknown
  local option = info[#info];
  print("SetOption", parent, option, value, #info);
  DevTools_Dump(info);
  DevTools_Dump(Config.db.profile[parent][option]);
  ---@diagnostic disable-next-line: no-unknown
  Config.db.profile[parent][option] = value;
end

function Config:OnInitialize()
  self.db = AceDB:New("ScambusterVenoxisDB", self.defaults, true);
  self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged");
  self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged");
  self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged");

  self.opts = setmetatable({}, {
    __index = self.db.profile,
    __newindex = self.db.profile,
  });

  AceConfig:RegisterOptionsTable(AddonName, self.options);

  self:SetupAbout();
  self:SetupSettings();
  self:SetupOverrides();
  self:SetupProfiles();
end

function Config:OnEnable()
  local Scambuster = AceAddon:GetAddon("Scambuster");

  Scambuster.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged");
  Scambuster.db.RegisterCallback(self, "OnProfileCopied", "OnProfileCopied");
  Scambuster.db.RegisterCallback(self, "OnProfileReset", "OnProfileReset");

  if not self.opts.overrides.overrideScambuster then
    return;
  end

  if self.opts.overrides.enableGUIDMatching then
    Scambuster.db.profile.require_guid_match = true;
  end

  if self.opts.overrides.disableAllMatching then
    Scambuster.db.profile.match_all_incidents = false;
  end

  if self.opts.overrides.extendAlertLockout then
    Scambuster.db.profile.alert_lockout_seconds = 10000;
  end

  if self.opts.overrides.disableGroupAlerts then
    Scambuster.db.profile.use_group_chat_alert = false;
  end
end

function Config:OnProfileChanged(...)
  DevTools_Dump("OnProfileChanged");
  DevTools_Dump({ ... });
end

function Config:OnProfileCopied(...)
  DevTools_Dump("OnProfileCopied");
  DevTools_Dump({ ... });
end

function Config:OnProfileReset(...)
  DevTools_Dump("OnProfileReset");
  DevTools_Dump({ ... });
end

function Config:ApplyOverrides()
end

function Config:ToggleOptionsFrame()
  AceConfigDialog:Open(AddonName);
end

function Config:SetupAbout()
  local options = {
    type = "group",
    name = L.ABOUT,
    inline = true,
    get = self.GetArg,
    set = nop,
    args = {
      Version = {
        type = "input",
        name = L.VERSION,
        arg = Utils:GetMetadata("Version"),
        order = 1,
        disabled = true,
        dialogControl = "SFX-Info",
      },
      Revision = {
        type = "input",
        name = L.REVISION,
        arg = Utils:GetMetadata("X-Revision"),
        order = 2,
        disabled = true,
        dialogControl = "SFX-Info",
      },
      Date = {
        type = "input",
        name = L.DATE,
        arg = Utils:GetMetadata("X-Date"),
        order = 3,
        disabled = true,
        dialogControl = "SFX-Info",
      },
      Author = {
        type = "input",
        name = L.AUTHOR,
        arg = Utils:GetMetadata("Author"),
        order = 4,
        disabled = true,
        dialogControl = "SFX-Info",
      },
      Credits = {
        type = "input",
        name = L.CREDITS,
        arg = Utils:GetMetadata("X-Credits"),
        order = 5,
        disabled = true,
        dialogControl = "SFX-Info",
      },
      License = {
        type = "input",
        name = L.LICENSE,
        arg = Utils:GetMetadata("X-License"),
        order = 6,
        disabled = true,
        dialogControl = "SFX-Info",
      },
      Localizations = {
        type = "input",
        name = L.LOCALIZATIONS,
        arg = Utils:GetMetadata("X-Localizations"),
        order = 7,
        disabled = true,
        dialogControl = "SFX-Info",
      },
      Category = {
        type = "input",
        name = L.CATEGORY,
        arg = Utils:GetMetadata("X-Category"),
        order = 8,
        disabled = true,
        dialogControl = "SFX-Info",
      },
      Discord = {
        type = "input",
        name = L.DISCORD,
        arg = Utils:GetMetadata("X-Discord"),
        order = 9,
        dialogControl = "SFX-Info-URL",
      },
      Website = {
        type = "input",
        name = L.WEBSITE,
        arg = Utils:GetMetadata("X-Website"),
        order = 10,
        dialogControl = "SFX-Info-URL",
      },
      Feedback = {
        type = "input",
        name = L.FEEDBACK,
        arg = Utils:GetMetadata("X-Feedback"),
        order = 11,
        dialogControl = "SFX-Info-URL",
      },
      Donate = {
        type = "input",
        name = L.DONATE,
        arg = Utils:GetMetadata("X-Donate"),
        order = 12,
        dialogControl = "SFX-Info-URL",
      },
    },
  };

  self.options.args.about = options;

  AceConfigDialog:AddToBlizOptions(AddonName, AddonName, nil, "about");
end

function Config:SetupSettings()
  local options = {
    type = "group",
    name = L.SETTINGS,
    get = self.GetOption,
    set = self.SetOption,
    args = {
      h1 = {
        type = "header",
        name = L.SETTINGS_HEAD,
        order = 0,
        disabled = true,
        dialogControl = "SFX-Header",
      },
      d1 = {
        type = "description",
        name = L.SETTINGS_DESC,
        order = 1,
        fontSize = "medium",
      },
      welcomeMessage = {
        type = "toggle",
        name = L.WELCOME_MESSAGE,
        order = 2.1,
      },
      debugMode = {
        type = "toggle",
        name = L.DEBUG_MODE,
        order = 2.2,
      },
      d2 = {
        type = "description",
        name = " ",
        order = 3,
      },
      purge = {
        type = "execute",
        name = L.PURGE_DATABASE,
        desc = L.PURGE_DATABASE_DESC,
        func = function(i)
          DevTools_Dump("Purge " .. i)
        end,
        order = -1,
        confirm = true,
        confirmText = L.PURGE_DATABASE_CONFIRM,
      },
    },
  };

  self.options.args.settings = options;

  AceConfigDialog:AddToBlizOptions(AddonName, L.SETTINGS, AddonName, "settings");
end

function Config:SetupOverrides()
  local options = {
    type = "group",
    name = L.OVERRIDES,
    get = self.GetOption,
    set = self.SetOption,
    args = {
      h1 = {
        type = "header",
        name = L.OVERRIDES,
        order = 1,
        disabled = true,
        dialogControl = "SFX-Header",
      },
      d1 = {
        type = "description",
        name = L.OVERRIDES_DESC,
        order = 1.1,
        fontSize = "medium",
      },
      h2 = {
        type = "header",
        name = ">>>"..L.OVERRIDES,
        order = 2,
        dialogControl = "SFX-Header",
      },
      enableGUIDMatching = {
        type = "toggle",
        order = 2.1,
        name = L.REQUIRE_GUID_MATCH,
      },
      disableAllMatching = {
        type = "toggle",
        order = 2.2,
        name = L.MATCH_ALL_INCIDENTS,
      },
      extendAlertLockout = {
        type = "toggle",
        order = 2.3,
        name = L.ALERT_LOCKOUT_SECONDS,
      },
      disableGroupAlerts = {
        type = "toggle",
        order = 2.4,
        name = L.USE_GROUP_CHAT_ALERT,
      },
    },
  };

  --local category, layout = Settings.RegisterVerticalLayoutCategory("Overrides");
  --
  --local setting = Settings.RegisterAddOnSetting(category, L.REQUIRE_GUID_MATCH, "enableGUIDMatching", type(defaultValue), true);
  --
  --Settings.CreateCheckBox(category, setting)
  --Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
  --
  --Settings.RegisterAddOnCategory(category)

  self.options.args.overrides = options;

  AceConfigDialog:AddToBlizOptions(AddonName, L.OVERRIDES, AddonName, "overrides");
end

function Config:SetupProfiles()
  local options = AceDBOptions:GetOptionsTable(self.db);

  options.name = L.PROFILES;
  options.order = -1;

  --[[
  for _, arg in pairs(options.args) do
    if arg and arg.type == "description" then
      arg.fontSize = "medium";
    end
  end
  ]]--

  self.options.args.profiles = options;

  AceConfigDialog:AddToBlizOptions(AddonName, L.PROFILES, AddonName, "profiles");
end
