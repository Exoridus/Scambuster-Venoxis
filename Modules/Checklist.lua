--======================================================================================--
-- List of player names that returned empty results when fetching for their char info.  --
-- Those characters were renamed / transferred / deleted before their GUIDs were saved. --
--======================================================================================--
local _, Addon = ...;
local Checklist = Addon:NewModule("Checklist");
local Utils = Addon:GetModule("Utils");

local CHECKLIST = {
  [1] = {
    name = "Niemandmc",
    guid = "",
    class = "WARRIOR",
    faction = "Horde",
    description = "Ninjat weil PM vergessen wurde und verkauft die Tokens",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/989319177368113152",
    category = "raid",
    level = 3,
  },
  [2] = {
    name = "PPQOR",
    guid = "",
    class = "",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "",
    category = "dungeon",
    level = 3,
  },
};

function Checklist.GetEntries()
  return CHECKLIST;
end

function Checklist.GetCount()
  return #CHECKLIST;
end

function Checklist.GetEntry(index)
  return CHECKLIST[index];
end

function Checklist.GetPlayerNames()
  return Utils:GetSortedPlayerNames(CHECKLIST);
end