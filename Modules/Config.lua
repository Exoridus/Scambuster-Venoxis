local AddonName, Addon = ...;
local AceAddon = LibStub("AceAddon-3.0");
local AceConfig = LibStub("AceConfig-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");
local AceDB = LibStub("AceDB-3.0");
local AceDBOptions = LibStub("AceDBOptions-3.0");
local Utils = Addon:GetModule("Utils") --[[@as Utils]];
---@class Config : AceModule
local Config = Addon:NewModule("Config");
local L = Addon.L;

Config.defaults = {
  profile = {
    settings = {
      welcomeMessage = true,
      debugMode = false,
    },
    overrides = {
      overrideScambuster = true,
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

function Config.GetArg(info)
  return info.arg;
end

function Config.GetOption(info)
  return Config.db.profile[info[#info - 1]][info[#info]];
end

function Config.SetOption(info, value)
  Config.db.profile[info[#info - 1]][info[#info]] = value;
end

function Config.NoOp()
  -- Intentionally left empty
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
  local Scambuster = AceAddon:GetAddon("Scambuster") --[[@as Scambuster]];

  Scambuster.db.RegisterCallback(self, "OnProfileChanged", "OnScambusterChanged");
  Scambuster.db.RegisterCallback(self, "OnProfileCopied", "OnScambusterChanged");
  Scambuster.db.RegisterCallback(self, "OnProfileReset", "OnScambusterChanged");

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

function Config:OnScambusterChanged(...)
  DevTools_Dump("OnScambusterChanged");
  DevTools_Dump({ ... });
end

function Config:ApplyOverrides()
end

function Config:OpenOptionsFrame()
  AceConfigDialog:Open(AddonName);
end

function Config:SetupAbout()
  local options = {
    type = "group",
    name = L["About"],
    args = {
      Head = {
        type = "header",
        name = Utils:GetMetadata("Title"),
        order = 1,
        disabled = true,
        dialogControl = "SFX-Header",
      },
      Desc = {
        type = "description",
        name = Utils:GetMetadata("Notes"),
        order = 2,
        fontSize = "medium",
      },
      Info = {
        type = "group",
        name = "",
        order = 3,
        inline = true,
        get = self.GetArg,
        set = self.NoOp,
        args = {
          Version = {
            type = "input",
            name = L["Version"],
            arg = Utils:GetMetadata("Version"),
            order = 1,
            disabled = true,
            dialogControl = "SFX-Info",
          },
          Revision = {
            type = "input",
            name = L["Revision"],
            arg = Utils:GetMetadata("X-Revision"),
            order = 2,
            disabled = true,
            dialogControl = "SFX-Info",
          },
          Date = {
            type = "input",
            name = L["Date"],
            arg = Utils:GetMetadata("X-Date"),
            order = 3,
            disabled = true,
            dialogControl = "SFX-Info",
          },
          Author = {
            type = "input",
            name = L["Author"],
            arg = Utils:GetMetadata("Author"),
            order = 4,
            disabled = true,
            dialogControl = "SFX-Info",
          },
          Credits = {
            type = "input",
            name = L["Credits"],
            arg = Utils:GetMetadata("X-Credits"),
            order = 5,
            disabled = true,
            dialogControl = "SFX-Info",
          },
          License = {
            type = "input",
            name = L["License"],
            arg = Utils:GetMetadata("X-License"),
            order = 6,
            disabled = true,
            dialogControl = "SFX-Info",
          },
          Localizations = {
            type = "input",
            name = L["Localizations"],
            arg = Utils:GetMetadata("X-Localizations"),
            order = 7,
            disabled = true,
            dialogControl = "SFX-Info",
          },
          Category = {
            type = "input",
            name = L["Category"],
            arg = Utils:GetMetadata("X-Category"),
            order = 8,
            disabled = true,
            dialogControl = "SFX-Info",
          },
          Discord = {
            type = "input",
            name = L["Discord"],
            arg = Utils:GetMetadata("X-Discord"),
            order = 9,
            dialogControl = "SFX-Info-URL",
          },
          Website = {
            type = "input",
            name = L["Website"],
            arg = Utils:GetMetadata("X-Website"),
            order = 10,
            dialogControl = "SFX-Info-URL",
          },
          Feedback = {
            type = "input",
            name = L["Feedback"],
            arg = Utils:GetMetadata("X-Feedback"),
            order = 11,
            dialogControl = "SFX-Info-URL",
          },
          Donate = {
            type = "input",
            name = L["Donate"],
            arg = Utils:GetMetadata("X-Donate"),
            order = 12,
            dialogControl = "SFX-Info-URL",
          },
        },
      },
    },
  };

  self.options.args.about = options;

  AceConfigDialog:AddToBlizOptions(AddonName, AddonName, nil, "about");
end

function Config:SetupSettings()
  local options = {
    type = "group",
    name = L["Settings"],
    get = self.GetOption,
    set = self.SetOption,
    args = {
      h1 = {
        type = "header",
        name = L["Settings"],
        order = 0,
        disabled = true,
        dialogControl = "SFX-Header",
      },
      d1 = {
        type = "description",
        name = L["This section will allow you to adjust settings that affect working with Masque's API."],
        order = 1,
        fontSize = "medium",
      },
      welcomeMessage = {
        type = "toggle",
        name = L["Welcome Message"],
        order = 2.1,
      },
      debugMode = {
        type = "toggle",
        name = L["Debug Mode"],
        order = 2.2,
      },
      d2 = {
        type = "description",
        name = " ",
        order = 3,
      },
      purge = {
        type = "execute",
        name = L["Clean Database"],
        desc = L["Click to purge the settings of all unused add-ons and groups."],
        func = function(i)
          DevTools_Dump("Purge " .. i)
        end,
        order = -1,
        confirm = true,
        confirmText = L["This action cannot be undone. Continue?"],
      },
    },
  };

  self.options.args.settings = options;

  AceConfigDialog:AddToBlizOptions(AddonName, L["Settings"], AddonName, "settings");
end

function Config:SetupOverrides()
  local options = {
    type = "group",
    name = L["Overrides"],
    get = self.GetOption,
    set = self.SetOption,
    args = {
      h1 = {
        type = "header",
        name = L["Overrides"],
        order = 1,
        disabled = true,
        dialogControl = "SFX-Header",
      },
      d1 = {
        type = "description",
        name = L["Overrides Desc"],
        order = 1.1,
        fontSize = "medium",
      },
      overrideScambuster = {
        type = "toggle",
        order = 1.2,
        name = L["Override Scambuster"],
      },
      h2 = {
        type = "header",
        name = ">>>"..L["Overrides"],
        order = 2,
        dialogControl = "SFX-Header",
      },
      enableGUIDMatching = {
        type = "toggle",
        order = 2.1,
        name = L["GUID Matching"],
      },
      disableAllMatching = {
        type = "toggle",
        order = 2.2,
        name = L["Name Matching"],
      },
      extendAlertLockout = {
        type = "toggle",
        order = 2.3,
        name = L["Alert Lockout"],
      },
      disableGroupAlerts = {
        type = "toggle",
        order = 2.4,
        name = L["Group/Raid chat"],
      },
    },
  };

  self.options.args.overrides = options;

  AceConfigDialog:AddToBlizOptions(AddonName, L["Overrides"], AddonName, "overrides");
end

function Config:SetupProfiles()
  local options = AceDBOptions:GetOptionsTable(self.db);

  options.name = L["Profiles"];
  options.order = -1;

  for _, arg in pairs(options.args) do
    if arg and arg.type == "description" then
      arg.fontSize = "medium";
    end
  end

  self.options.args.profiles = options;

  AceConfigDialog:AddToBlizOptions(AddonName, L["Profiles"], AddonName, "profiles");
end
