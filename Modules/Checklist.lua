--======================================================================================--
-- List of player names that returned empty results when fetching for their char info.  --
-- Those characters were renamed / transferred / deleted before their GUIDs were saved. --
--======================================================================================--
local _, Addon = ...;
local Checklist = Addon:NewModule("Checklist");
local Utils = Addon:GetModule("Utils");

local CHECKLIST = {
  [1] = {
    name = "Diggernick",
    guid = "",
    class = "",
    faction = "Horde",
    description = "Rollt gern ohne zu Zahlen",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/976906725380722688",
    category = "trade",
    level = 3,
  },
  [2] = {
    name = "Dirtyrouge",
    guid = "",
    class = "ROGUE",
    faction = "Horde",
    description = "Lootdrama / spricht kein Deutsch / versucht zu scammen",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/960870173500399618",
    category = "gdkp",
    level = 3,
  },
  [3] = {
    name = "Dreamyx",
    guid = "",
    class = "SHAMAN",
    faction = "Horde",
    description = "ZA GDKP Orga: Will loot behalten statt diss aber nicht zahlen. Geht off vorm Endboss mitm Pot",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/972439422299693076",
    category = "gdkp",
    level = 3,
  },
  [4] = {
    name = "Fikky",
    guid = "",
    class = "",
    faction = "Horde",
    description = "Blacklisted sich selbst: Verkauft ZA Bär für 2K und fügt es nicht dem GDKP Pot hinzu.",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/1009841223105785947",
    category = "gdkp",
    level = 3,
  },
  [5] = {
    name = "Greves",
    guid = "",
    class = "",
    faction = "Horde",
    description = "ZA GDKP Orga: Will loot behalten statt diss aber nicht zahlen.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/972466166641619034",
    category = "gdkp",
    level = 3,
  },
  [6] = {
    name = "Hoibedere",
    guid = "",
    class = "PALADIN",
    faction = "Horde",
    description = "Gönnt sich als ZA alle Splitter Greens und Hexerstecken",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/978261580716331038",
    category = "raid",
    level = 3,
  },
  [7] = {
    name = "Javoor",
    guid = "",
    class = "DRUID",
    faction = "Horde",
    description = "Rollt gern ohne zu Zahlen",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/997262970960760983",
    category = "trade",
    level = 3,
  },
  [8] = {
    name = "Niemandmc",
    guid = "",
    class = "WARRIOR",
    faction = "Horde",
    description = "Ninjat weil PM vergessen wurde und verkauft die Tokens",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/989319177368113152",
    category = "raid",
    level = 3,
  },
  [9] = {
    name = "PPQOR",
    guid = "",
    class = "",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "",
    category = "dungeon",
    level = 3,
  },
  [10] = {
    name = "Rôôz",
    guid = "",
    class = "WARRIOR",
    faction = "Horde",
    description = "Geht als Buyer mit und hat kein Gold - beleidigt dann nach Aufforderung zu kaufen.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/989901518922743868",
    category = "gdkp",
    level = 3,
  },
  [11] = {
    name = "Thilon",
    guid = "",
    class = "PALADIN",
    faction = "Horde",
    description = "Lockt Betrayer aber gibt diese Info nicht an nachträglich in den Raid geladene Spieler weiter. Nachzügler setzt Betrayer auf Prio1 - erhält trotzdem keine Info / Betrayer ist droppt und wurde an Stahlklang-Gildenmember vergeben",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1057476414938546236",
    category = "raid",
    level = 3,
  },
  [12] = {
    name = "Vibecheckk",
    guid = "",
    class = "SHAMAN",
    faction = "Horde",
    description = "Lockt rnd Items ohne Vorabinfo",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/982634146717401138",
    category = "raid",
    level = 3,
  },
  [13] = {
    name = "Würfelbotqt",
    guid = "",
    class = "WARRIOR",
    faction = "Horde",
    description = "Geht mit 116k Gold offline und verteilt keinen Cut / GDKP Betrüger / hat Namen in Handwerkerr geändert",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/1068898422259732531",
    category = "gdkp",
    level = 3,
    aliases = {"Handwerkerr"},
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