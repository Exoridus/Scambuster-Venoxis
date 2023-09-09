--=====================================================================================--
-- Venoxis Discord blocklist based on the official google sheet blocklist viewable at: --
-- https://docs.google.com/spreadsheets/d/1IKAr8A4P0-LhkXqMxizvgYy1E2gph_00M_O0r3rDGkY --
--=====================================================================================--
local _, Addon = ...;
local Blocklist = Addon:NewModule("Blocklist");

Blocklist.Entries = {
  [1] = {
    name = "Alcyona",
    guid = "Player-4477-03C5CE1A",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/984066550950662194",
    category = "trade",
    level = 3,
  },
  [2] = {
    name = "Alle",
    guid = "Player-4477-046C5B97",
    race = "Orc",
    class = "DEATHKNIGHT",
    faction = "Horde",
    description = "Veranstaltet als Gilde BT Prio Runs und scamt hart bei der Lootvergabe (Randoms dürfen nur auf ihre Prios rollen aber Gilde darf auf alles Bieten und Prios überschreiben.",
    url = "https://docs.google.com/spreadsheets/d/1IKAr8A4P0-LhkXqMxizvgYy1E2gph_00M_O0r3rDGkY/edit",
    category = "raid",
    level = 3,
  },
  [3] = {
    name = "Allfredo",
    guid = "Player-4477-0515E3AC",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Öffnet PDK25 GDKP und verschwindet dann mit 106k Gold offline nachdem er fuck you in den Chat schreibt",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1149064882738704444",
    category = "gdkp",
    level = 3,
  },
  [4] = {
    name = "Alonewoolf",
    guid = "Player-4477-045EA655",
    race = "Tauren",
    class = "DRUID",
    faction = "Horde",
    description = "Stellt im 5er vor dem Endboss den PM ein und Ninjat fast alles / bisher 3 Meldungen zu diesem Spieler",
    url = "https://discord.com/channels/613060619738021890/1029711210918191154/1073129858361737276",
    category = "dungeon",
    level = 3,
  },
  [5] = {
    name = "Amaluca",
    guid = "Player-4477-03AEE3AE",
    race = "Scourge",
    class = "PRIEST",
    faction = "Horde",
    description = "Vergibt zuerst sein Item falsch und behält sich dann einen Token aus Frust ein, der ihm nicht gehört",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1086865128026275930",
    category = "raid",
    level = 3,
  },
  [6] = {
    name = "Arbeitslos",
    guid = "Player-4477-01B8DFEE",
    race = "Scourge",
    class = "ROGUE",
    faction = "Horde",
    description = "Bekommt vom RL ein Item falsch zugewiesen und geht nach der Aufforderung dieses zu traden direkt offline",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1078668551566671962",
    category = "trade",
    level = 3,
  },
  [7] = {
    name = "Arcturuz",
    guid = "Player-4477-03B6C66D",
    race = "Orc",
    class = "SHAMAN",
    faction = "Horde",
    description = "Bekommt eine Waffe unabsichtlich falsch getradet und geht sofort damit offline",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1042597576882528296",
    category = "trade",
    level = 3,
  },
  [8] = {
    description = "Plündert gern mal die Gildenbank",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1094685096780513331",
    category = "trade",
    level = 3,
    players = {
      [1] = {
        name = "Autoritä",
        guid = "Player-4477-049EDE13",
        race = "Scourge",
        class = "ROGUE",
        faction = "Horde",
      },
      [2] = {
        name = "Jondeepfreez",
        guid = "Player-4477-0464DE81",
        race = "Scourge",
        class = "MAGE",
        faction = "Horde",
      },
    },
  },
  [9] = {
    description = "Scamt Prio1 Item und vergibt es an ein Gildenmitglied",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/1062805295056818266",
    category = "raid",
    level = 3,
    players = {
      [1] = {
        name = "Boomboompøw",
        guid = "Player-4477-04C424C5",
        race = "Orc",
        class = "HUNTER",
        faction = "Horde",
      },
      [2] = {
        name = "Nøxic",
        guid = "Player-4477-03355A2D",
        race = "Troll",
        class = "PRIEST",
        faction = "Horde",
      },
    },
  },
  [10] = {
    name = "Brodyrich",
    guid = "Player-4477-04CA7FA9",
    race = "Orc",
    class = "DEATHKNIGHT",
    faction = "Horde",
    description = "Geht mit 75k vom Gdkp offline und kickt alle vom DC-Server / Dc-Tag = Gigawizard#8360",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/1059169678292942878",
    category = "gdkp",
    level = 3,
  },
  [11] = {
    name = "Builder",
    guid = "Player-4477-037D513B",
    race = "Scourge",
    class = "ROGUE",
    faction = "Horde",
    description = "Würfelt in HC+ 5 Mann auf alles Bedarf weil er behauptet verzauberer zu sein und es für Splitter dissen will",
    url = "https://discord.com/channels/613060619738021890/1029711210918191154/1077230883871924325",
    category = "dungeon",
    level = 3,
  },
  [12] = {
    description = "Plündert gern mal die Gildenbank",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1036332378873942187",
    category = "trade",
    level = 3,
    players = {
      [1] = {
        name = "Buyvet",
        guid = "Player-4477-03B5135F",
        race = "BloodElf",
        class = "PALADIN",
        faction = "Horde",
      },
      [2] = {
        name = "Dejox",
        guid = "Player-4477-043A6C38",
        race = "Scourge",
        class = "ROGUE",
        faction = "Horde",
      },
      [3] = {
        name = "Dkgoesbrbr",
        guid = "Player-4477-047A2CE0",
        race = "Orc",
        class = "DEATHKNIGHT",
        faction = "Horde",
      },
      [4] = {
        name = "Itsmebiatch",
        guid = "Player-4477-03B19976",
        race = "Scourge",
        class = "MAGE",
        faction = "Horde",
        aliases = { "Ungeiimpfter" },
      },
    },
  },
  [13] = {
    description = "Steckt sich nach PrioRun den Drachen und die Beutetasche aus Obsi 3D 10er ein obwohl er es nicht auf Prio hatte",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1084141800903684136",
    category = "raid",
    level = 3,
    players = {
      [1] = {
        name = "Convexyz",
        guid = "Player-4477-04F4059E",
        race = "BloodElf",
        class = "ROGUE",
        faction = "Horde",
      },
      [2] = {
        name = "Xevnoc",
        guid = "Player-4477-04D80016",
        race = "Troll",
        class = "PRIEST",
        faction = "Horde",
      },
    },
  },
  [14] = {
    name = "Cradran",
    guid = "Player-4477-04F82F8F",
    race = "Orc",
    class = "WARLOCK",
    faction = "Horde",
    description = "Rollt gern ohne zu Zahlen",
    url = "https://docs.google.com/spreadsheets/d/1IKAr8A4P0-LhkXqMxizvgYy1E2gph_00M_O0r3rDGkY/edit",
    category = "trade",
    level = 3,
  },
  [15] = {
    name = "Cruzitô",
    guid = "Player-4477-044B93D3",
    race = "Scourge",
    class = "MAGE",
    faction = "Horde",
    description = "Steckt gern Items sich selbst oder seinen Kumpels zu. ",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1044684405840564316",
    category = "trade",
    level = 3,
  },
  [16] = {
    name = "Cycral",
    guid = "Player-4477-04E27973",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Vergibt in Naxx10er ein Endboss item an einen Spieler der es nicht gewonnen hat und der dann instant offline geht",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1096600239164629114",
    category = "raid",
    level = 3,
  },
  [17] = {
    name = "Cînderrella",
    guid = "Player-4477-046669DD",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Eröffnet Gdkp run und haut dann mit dem gesamten Pot ab.  81.402 Gold / Zweiter Gdkp Scam: 56.500",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1080868571279790210",
    category = "gdkp",
    level = 3,
    aliases = { "Pumperlumper", "Dannymage" },
  },
  [18] = {
    name = "Dakiny",
    guid = "Player-4477-042FF318",
    race = "Human",
    class = "WARRIOR",
    faction = "Alliance",
    description = "Kara Mount geninjat + leave",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/984075667069095936",
    category = "raid",
    level = 3,
  },
  [19] = {
    name = "Dancus",
    guid = "Player-4477-033E14B7",
    race = "Tauren",
    class = "DRUID",
    faction = "Horde",
    description = "Würfelt gern um Gold und zahlt dann nicht",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1135607685920858162",
    category = "trade",
    level = 3,
  },
  [20] = {
    description = "Danser und Intonraiha ninjan sich gern mal gegenseitig Items zu als Plündermeister. Scam Pugs!",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1046099363648245930",
    category = "raid",
    level = 3,
    players = {
      [1] = {
        name = "Danser",
        guid = "Player-4477-043160B7",
        race = "Orc",
        class = "ROGUE",
        faction = "Horde",
      },
      [2] = {
        name = "Intonraiha",
        guid = "Player-4477-04316087",
        race = "BloodElf",
        class = "PALADIN",
        faction = "Horde",
      },
    },
  },
  [21] = {
    description = "Geheime Absprachen bezüglich Gold-Gebote in seinen Gdkp-Raids",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1054029597320163408",
    category = "gdkp",
    level = 3,
    players = {
      [1] = {
        name = "Daserus",
        guid = "Player-4477-04AC5F5C",
        race = "BloodElf",
        class = "PALADIN",
        faction = "Horde",
      },
      [2] = {
        name = "Fleta",
        guid = "Player-4477-029C4B7E",
        race = "Orc",
        class = "WARRIOR",
        faction = "Horde",
      },
    },
  },
  [22] = {
    name = "Deinorc",
    guid = "Player-4477-031A85E5",
    race = "Orc",
    class = "WARRIOR",
    faction = "Horde",
    description = "Ninjat durch PM-Bug das Prio1 Item eines anderen Spielers und geht instant offline",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1064114144883785838",
    category = "raid",
    level = 3,
  },
  [23] = {
    name = "Diggernîck",
    guid = "Player-4477-02557182",
    race = "Tauren",
    class = "DRUID",
    faction = "Horde",
    description = "Rollt gern ohne zu Zahlen",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/976906725380722688",
    category = "trade",
    level = 3,
  },
  [24] = {
    name = "Dirtyrouge",
    guid = "Player-4477-03AE5C6F",
    race = "Scourge",
    class = "ROGUE",
    faction = "Horde",
    description = "Lootdrama / spricht kein Deutsch / versucht zu scammen",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/960870173500399618",
    category = "gdkp",
    level = 3,
  },
  [25] = {
    name = "Dreamyx",
    guid = "Player-4477-03B0FD91",
    race = "Orc",
    class = "SHAMAN",
    faction = "Horde",
    description = "ZA GDKP Orga: Will loot behalten statt diss aber nicht zahlen. Geht off vorm Endboss mitm Pot",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/972439422299693076",
    category = "gdkp",
    level = 3,
  },
  [26] = {
    name = "Elrether",
    guid = "Player-4477-044348A4",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://docs.google.com/spreadsheets/d/1IKAr8A4P0-LhkXqMxizvgYy1E2gph_00M_O0r3rDGkY/edit",
    category = "dungeon",
    level = 3,
  },
  [27] = {
    name = "Faktorial",
    guid = "Player-4477-034B6F50",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Kassiert 120 Gold - pullt - stirbt und geht dann offline",
    url = "https://docs.google.com/spreadsheets/d/1IKAr8A4P0-LhkXqMxizvgYy1E2gph_00M_O0r3rDGkY/edit",
    category = "dungeon",
    level = 3,
  },
  [28] = {
    name = "Fikky",
    guid = "Player-4477-03BD37F7",
    race = "Scourge",
    class = "MAGE",
    faction = "Horde",
    description = "Blacklisted sich selbst: Verkauft ZA Bär für 2K und fügt es nicht dem GDKP Pot hinzu.",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/1009841223105785947",
    category = "gdkp",
    level = 3,
  },
  [29] = {
    name = "Fyfy",
    guid = "Player-4477-04983B8E",
    race = "Tauren",
    class = "DRUID",
    faction = "Horde",
    description = "	Needet alle Items in 5mann HC+ / mehrfach reportet",
    url = "https://discord.com/channels/613060619738021890/1029711210918191154/1065655958795194378",
    category = "dungeon",
    level = 3,
  },
  [30] = {
    name = "Gladix",
    guid = "Player-4477-04E405A6",
    race = "BloodElf",
    class = "ROGUE",
    faction = "Horde",
    description = "Plündert am 28.06.2023 eine Gildenbank",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1124450377534800052",
    category = "trade",
    level = 3,
  },
  [31] = {
    description = "Zorodan (RL) hat PM vergessen, called passen und verschwindet zusammen mit Rhoran nachdem beide items per need gewonnen haben.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1097453560188375122",
    category = "raid",
    level = 3,
    players = {
      [1] = {
        name = "Gladix",
        guid = "Player-4477-04E405A6",
        race = "BloodElf",
        class = "ROGUE",
        faction = "Horde",
        aliases = { "Rhoran" },
      },
      [2] = {
        name = "Zorodan",
        guid = "Player-4477-0381BCBA",
        race = "BloodElf",
        class = "PALADIN",
        faction = "Horde",
      },
    },
  },
  [32] = {
    name = "Gladix",
    guid = "Player-4477-04E405A6",
    race = "BloodElf",
    class = "ROGUE",
    faction = "Horde",
    description = "Ninjat in Archavons Kammer 25 zwei Items",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1093498181402251294",
    category = "raid",
    level = 3,
  },
  [33] = {
    name = "Greves",
    guid = "Player-4477-03AF1BAC",
    race = "Orc",
    class = "HUNTER",
    faction = "Horde",
    description = "ZA GDKP Orga: Will loot behalten statt diss aber nicht zahlen.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/972466166641619034",
    category = "gdkp",
    level = 3,
  },
  [34] = {
    name = "Gromgrul",
    guid = "Player-4477-03DE0567",
    race = "Orc",
    class = "WARRIOR",
    faction = "Horde",
    description = "Plündert gern mal die Gildenbank",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/972958108475330570",
    category = "trade",
    level = 3,
  },
  [35] = {
    name = "Handwerkerer",
    guid = "Player-4477-04C72D08",
    race = "Tauren",
    class = "WARRIOR",
    faction = "Horde",
    description = "Geht mit 116k Gold offline und verteilt keinen Cut",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/1068898422259732531",
    category = "gdkp",
    level = 3,
    aliases = { "Handwerkerr", "Würfelbotqt" },
  },
  [36] = {
    name = "Happybeast",
    guid = "Player-4477-048E9F36",
    race = "Orc",
    class = "HUNTER",
    faction = "Horde",
    description = "Deathrollbetrüger",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/1038987893823242301",
    category = "trade",
    level = 3,
  },
  [37] = {
    name = "Hellsângel",
    guid = "Player-4477-04D9ADE0",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Geht mit 23.5k vom Gdkp offline und kommt nicht wieder",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1078427424926220409",
    category = "gdkp",
    level = 3,
  },
  [38] = {
    name = "Hoibedere",
    guid = "Player-4477-03B9E56F",
    race = "Human",
    class = "PALADIN",
    faction = "Alliance",
    description = "Gönnt sich als ZA alle Splitter Greens und Hexerstecken",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/978261580716331038",
    category = "raid",
    level = 3,
  },
  [39] = {
    name = "Holyfansqt",
    guid = "Player-4477-04498816",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Betrügt andere Spieler um 10.000 Gold Cut - erfindet dafür nicht existente Regeln. Der übrig gebliebene Pot wird dann durch 25 gerechnet und der entzogene Cut wird einfach einbehalten. Auch bereits auf anderen Servern bekannt.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1136837983178338364",
    category = "gdkp",
    level = 3,
  },
  [40] = {
    description = "Scammt Endboss-Tokens / Behält sich den Loot im 25er egal ob jemand Prio darauf hatte oder nicht",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1102594033651564546",
    category = "raid",
    level = 3,
    players = {
      [1] = {
        name = "Infernâ",
        guid = "Player-4477-03B07A37",
        race = "Tauren",
        class = "DRUID",
        faction = "Horde",
      },
      [2] = {
        name = "Rosabienchen",
        guid = "Player-4477-03B074F6",
        race = "BloodElf",
        class = "PALADIN",
        faction = "Horde",
      },
    },
  },
  [41] = {
    name = "Javoor",
    guid = "Player-4477-035A99C2",
    race = "Tauren",
    class = "DRUID",
    faction = "Horde",
    description = "Rollt gern ohne zu Zahlen",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/997262970960760983",
    category = "trade",
    level = 3,
  },
  [42] = {
    name = "Jenpai",
    guid = "Player-4477-03B2BFD8",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/983417620437032970",
    category = "dungeon",
    level = 3,
  },
  [43] = {
    name = "Jensha",
    guid = "Player-4477-03FF5FEF",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/980863146111672370",
    category = "dungeon",
    level = 3,
  },
  [44] = {
    name = "Jondeepfreez",
    guid = "Player-4477-0464DE81",
    race = "Scourge",
    class = "MAGE",
    faction = "Horde",
    description = "Scammt in 5er Gruppen alle Items, geht und dann offline ohne die Splitter zu verteilen / zudem gibt er es auch per whisper zu",
    url = "https://discord.com/channels/613060619738021890/1029711210918191154/1087391435378143393",
    category = "dungeon",
    level = 3,
  },
  [45] = {
    name = "Kessler",
    guid = "Player-4477-04BABDB4",
    race = "Tauren",
    class = "DRUID",
    faction = "Horde",
    description = "Hält sich nicht an Prio-Listen und verteilt Items nach seinem Ermessen",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1055966524466274315",
    category = "raid",
    level = 3,
  },
  [46] = {
    name = "Kisxí",
    guid = "Player-4477-03B293E1",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Erhält in Naxx10 irrtümlicherweise ein falsches Item welches ihm nicht zusteht, zündet Ruhestein und geht offline. Endbossitem Naxx: Torch",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1096600239164629114",
    category = "raid",
    level = 3,
  },
  [47] = {
    name = "Kreiszahl",
    guid = "Player-4477-03346F2C",
    race = "Troll",
    class = "SHAMAN",
    faction = "Horde",
    description = "Siehe auch Spieler Pi / Versucht Cut zu scammen (gesamt 8k)",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1101288642649014374",
    category = "gdkp",
    level = 3,
  },
  [48] = {
    name = "Kugit",
    guid = "Player-4477-044F88CE",
    race = "Orc",
    class = "HUNTER",
    faction = "Horde",
    description = "Erstellt NaxxPUG ohne Lootsystem und tradet Endbossloot an jemanden der nicht per Roll gewonnen hat",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/1068688364716445807",
    category = "raid",
    level = 3,
  },
  [49] = {
    name = "Lachman",
    guid = "Player-4477-03EC6CF8",
    race = "Orc",
    class = "WARRIOR",
    faction = "Horde",
    description = "Ninjat Items als Plündermeister",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/980200744185630781",
    category = "raid",
    level = 3,
  },
  [50] = {
    name = "Laredai",
    guid = "Player-4477-04BDD735",
    race = "BloodElf",
    class = "PRIEST",
    faction = "Horde",
    description = "Lockt Betrayer aber gibt diese Info nicht an nachträglich in den Raid geladene Spieler weiter. Nachzügler setzt Betrayer auf Prio1 - erhält trotzdem keine Info / Betrayer ist droppt und wurde an Stahlklang-Gildenmember vergeben",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1057476414938546236",
    category = "raid",
    level = 3,
  },
  [51] = {
    name = "Lebkuchen",
    guid = "Player-4477-040379B4",
    race = "Dwarf",
    class = "PALADIN",
    faction = "Alliance",
    description = "Locken mitten im ZA Prio Run Items",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/976518445510328401",
    category = "raid",
    level = 3,
  },
  [52] = {
    name = "Listers",
    guid = "Player-4477-03B198AD",
    race = "Scourge",
    class = "MAGE",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://docs.google.com/spreadsheets/d/1IKAr8A4P0-LhkXqMxizvgYy1E2gph_00M_O0r3rDGkY",
    category = "dungeon",
    level = 3,
  },
  [53] = {
    name = "Lookìí",
    guid = "Player-4477-04BC3E60",
    race = "Tauren",
    class = "DRUID",
    faction = "Horde",
    description = "Verrollt Items nicht - zieht sie einfach an / lässt Items im Raid ablaufen - sodass kein verrollen mehr möglich ist / DC-Tag: Lookii#9050",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1068320436456259654",
    category = "raid",
    level = 3,
  },
  [54] = {
    name = "Lovetap",
    guid = "Player-4477-03BE372B",
    race = "Orc",
    class = "SHAMAN",
    faction = "Horde",
    description = "Antisemit",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/982000954377396244",
    category = "harassment",
    level = 3,
  },
  [55] = {
    name = "Lyzak",
    guid = "Player-4477-048F3883",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Kassiert 2k Gold als Eintrittsgeld für 25Prio-Run + scamt dann Prio1 Item Turning Tide / Empfänger des Items: Lorani - gleiche Gilde / Discord-Tag: EinfachCanTV#8479",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1066022134540931243",
    category = "raid",
    level = 3,
  },
  [56] = {
    name = "Maximabi",
    guid = "Player-4477-04D08212",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Betrügt andere Spieler um 10.000 Gold Cut - erfindet dafür nicht existente Regeln. Der übrig gebliebene Pot wird dann durch 25 gerechnet und der entzogene Cut wird einfach einbehalten. Auch bereits auf anderen Servern bekannt.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1136837983178338364",
    category = "gdkp",
    level = 3,
  },
  [57] = {
    name = "Mczwuggi",
    guid = "Player-4477-044CA3A0",
    race = "Orc",
    class = "WARRIOR",
    faction = "Horde",
    description = "Steckt kompletten Pot im 10er GDKP ein. Scam",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1045384854042324992",
    category = "gdkp",
    level = 3,
  },
  [58] = {
    name = "Melthise",
    guid = "Player-4477-04434888",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://docs.google.com/spreadsheets/d/1IKAr8A4P0-LhkXqMxizvgYy1E2gph_00M_O0r3rDGkY/edit",
    category = "dungeon",
    level = 3,
  },
  [59] = {
    name = "Mylifebelike",
    guid = "Player-4477-049A0545",
    race = "BloodElf",
    class = "ROGUE",
    faction = "Horde",
    description = "Zahlt beim Crossgamble nicht - Wenn er verliert geht er offline (zweiter Char = Myshoxbelike)",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1124062214337351720",
    category = "trade",
    level = 3,
  },
  [60] = {
    name = "Nakrotss",
    guid = "Player-4477-0419454D",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/987944740307759145",
    category = "dungeon",
    level = 3,
  },
  [61] = {
    name = "Palaslust",
    guid = "Player-4477-04D8C118",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Prio 1 Run: Der RL teilt das Sartharion-3D-Mount dem falschen Spieler zu und dieser geht instant offline. ",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1071209778996580422",
    category = "raid",
    level = 3,
  },
  [62] = {
    name = "Patapeng",
    guid = "Player-4477-022E45F0",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Ninjat ein Item vom Endboss in Naxx25, gibt es zu und sagt er schickt 1k Gold compensation / schickt dann ein Wurmfleisch mit 1k Gold Nachnahme",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1092478052723867798",
    category = "raid",
    level = 3,
    aliases = { "Bakery" },
  },
  [63] = {
    name = "Pi",
    guid = "Player-4477-00CDA567",
    race = "Troll",
    class = "PRIEST",
    faction = "Horde",
    description = "Zahlt Cut per Post nicht aus - lässt sich dann 3x bitten - erst nachdem der BL Eintrag erstellt wurde zahlt er die Hälfte des unterschlagenen Goldes. Konversation mit dem Typen auf der BL eher schwierig.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1101288642649014374",
    category = "gdkp",
    level = 3,
  },
  [64] = {
    name = "Sandmanncs",
    guid = "Player-4477-0320C13C",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Schließt Raider willkürlich vom Cut aus DC-Tag: Sandmann#7274",
    url = "https://docs.google.com/spreadsheets/d/1IKAr8A4P0-LhkXqMxizvgYy1E2gph_00M_O0r3rDGkY/edit",
    category = "gdkp",
    level = 3,
  },
  [65] = {
    name = "Saucenbinder",
    guid = "Player-4477-045558EF",
    race = "Orc",
    class = "WARLOCK",
    faction = "Horde",
    description = "Plündert gern mal die Gildenbank",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1035874189783093248",
    category = "trade",
    level = 3,
  },
  [66] = {
    name = "Spansau",
    guid = "Player-4477-044801AB",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Unterschlägt Items in Raids",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1009144231627079750",
    category = "raid",
    level = 3,
  },
  [67] = {
    name = "Spansau",
    guid = "Player-4477-044801AB",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Schleicht sich in Eventbossgruppen ein und beschwört nicht",
    url = "https://discord.com/channels/613060619738021890/1029711210918191154/1033409599526682706",
    category = "dungeon",
    level = 3,
  },
  [68] = {
    name = "Spansau",
    guid = "Player-4477-044801AB",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Betrüger - klaut Juwe Mats",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/1122530271149965423",
    category = "trade",
    level = 3,
  },
  [69] = {
    name = "Strongscam",
    guid = "Player-4477-04AC4DB2",
    race = "Orc",
    class = "WARRIOR",
    faction = "Horde",
    description = "Ändert im Priorun die Prios ab nachdem die Liste veröffentlich wurde (wieder hidden und reopen). Gilde steht dahinter ... komplett meiden den Verein.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1038474981937528913",
    category = "raid",
    level = 3,
    aliases = { "Strønghøld" },
  },
  [70] = {
    name = "Stysthy",
    guid = "Player-4477-04EE3626",
    race = "Orc",
    class = "DEATHKNIGHT",
    faction = "Horde",
    description = "Würfelt 2x für ein Item bei Malygos. Der RL übersieht das und weist ihm ungerechtfertigt ein Item zu. Danach verlässt er direkt den Raid. Wurde wegen diesem Vorfall aus der Gilde gekickt.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1073981448580763658",
    category = "raid",
    level = 3,
  },
  [71] = {
    name = "Sunnytätär",
    guid = "Player-4477-039FE91B",
    race = "BloodElf",
    class = "PRIEST",
    faction = "Horde",
    description = "Locken mitten im ZA Prio Run Items",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/976518445510328401",
    category = "raid",
    level = 3,
  },
  [72] = {
    name = "Tialen",
    guid = "Player-4477-04829ADC",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Lockt Betrayer aber gibt diese Info nicht an nachträglich in den Raid geladene Spieler weiter. Nachzügler setzt Betrayer auf Prio1 - erhält trotzdem keine Info / Betrayer ist droppt und wurde an Stahlklang-Gildenmember vergeben",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1057476414938546236",
    category = "raid",
    level = 3,
    aliases = { "Thilon" },
  },
  [73] = {
    name = "Totemholiker",
    guid = "Player-4477-04B3673D",
    race = "Troll",
    class = "SHAMAN",
    faction = "Horde",
    description = "Zahlt beim Crossgamble nicht - Wenn er verliert geht er offline (zweiter Char = Mylifebelike)",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1124062214337351720",
    category = "trade",
    level = 3,
    aliases = { "Myshoxbelike" },
  },
  [74] = {
    name = "Toxiic",
    guid = "Player-4477-03891F47",
    race = "Scourge",
    class = "WARLOCK",
    faction = "Horde",
    description = "Geht als Buyer mit und hat kein Gold - beleidigt dann nach Aufforderung zu kaufen.",
    url = "https://discord.com/channels/613060619738021890/972036752283926578/989965855112716409",
    category = "gdkp",
    level = 3,
  },
  [75] = {
    name = "Trytofly",
    guid = "Player-4477-03BDE4D2",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Scammer! Klaut Craftmats",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/962628189962768405",
    category = "trade",
    level = 3,
  },
  [76] = {
    name = "Ukrgul",
    guid = "Player-4477-02D6082C",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/982727605914599557",
    category = "dungeon",
    level = 3,
  },
  [77] = {
    name = "Ultraboost",
    guid = "Player-4477-04445671",
    race = "Troll",
    class = "SHAMAN",
    faction = "Horde",
    description = "Zahlt falschen Cut aus und beleidigt auf Nachfrage",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/967767521560240169",
    category = "gdkp",
    level = 3,
  },
  [78] = {
    name = "Unikuhm",
    guid = "Player-4477-04BB8BEB",
    race = "Tauren",
    class = "DRUID",
    faction = "Horde",
    description = "Steckt sich bei Ony25 die Tasche und die Gems ein und betitelt das als Orga Cut (Raid war jedoch kein Gdkp)",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1131005690475970560",
    category = "raid",
    level = 3,
  },
  [79] = {
    name = "Valentinmlk",
    guid = "Player-4477-02D60832",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/982727605914599557",
    category = "dungeon",
    level = 3,
  },
  [80] = {
    name = "Vejrekaiah",
    guid = "Player-4477-0310DAC1",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Macht Gdkp auf und verschwindet mit dem ganzen Pot / 108.750 Gold",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1069276743430570035",
    category = "gdkp",
    level = 3,
  },
  [81] = {
    name = "Vibechekk",
    guid = "Player-4477-03C0FD2D",
    race = "Orc",
    class = "SHAMAN",
    faction = "Horde",
    description = "Lockt rnd Items ohne Vorabinfo",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/982634146717401138",
    category = "raid",
    level = 3,
  },
  [82] = {
    name = "Vitalyv",
    guid = "Player-4477-043BDE5B",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Würfelt auf alles Bedarf und versucht die Items dann gegen Gold an die Spieler zu verkaufen die Need haben.",
    url = "https://discord.com/channels/613060619738021890/1029711210918191154/1080245642896613417",
    category = "trade",
    level = 3,
  },
  [83] = {
    name = "Wandan",
    guid = "Player-4477-041935AD",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/984875343175352361",
    category = "dungeon",
    level = 3,
  },
  [84] = {
    name = "Weedneyhustn",
    guid = "Player-4477-040DE346",
    race = "Orc",
    class = "WARRIOR",
    faction = "Horde",
    description = "Geht als Buyer mit und hat kein Gold - beleidigt dann nach Aufforderung zu kaufen.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/989901518922743868",
    category = "gdkp",
    level = 3,
    aliases = { "Rôôz" },
  },
  [85] = {
    name = "Wortalmombat",
    guid = "Player-4477-04554B62",
    race = "Orc",
    class = "WARRIOR",
    faction = "Horde",
    description = "Beleidigt aufs übelste den Gildenlead nach Kick (Homophob diesdas)",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1035617814171623474",
    category = "harassment",
    level = 3,
  },
  [86] = {
    name = "Wounds",
    guid = "Player-4477-03B82274",
    race = "Orc",
    class = "WARRIOR",
    faction = "Horde",
    description = "GDKP 25 Ulduar: Verrollt nicht alle Items - Kickt als sich ein paar beschweren einfach alle Spieler aus dem Raid",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/963749339778412594",
    category = "gdkp",
    level = 3,
  },
  [87] = {
    name = "Xintû",
    guid = "Player-4477-03AFB576",
    race = "Tauren",
    class = "WARRIOR",
    faction = "Horde",
    description = "Kickt rnd Leute aus dem GDKP und zwingt zum kauf von Trashitems",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/982419099516801095",
    category = "gdkp",
    level = 3,
    aliases = { "Sintussa" },
  },
  [88] = {
    name = "Yaxrail",
    guid = "Player-4477-04D02AC4",
    race = "Orc",
    class = "WARRIOR",
    faction = "Horde",
    description = "PvP Main Warrior Yaxrail macht Ulduar10 GDKP auf und täuscht Lags und Disconnects vor, nachdem Thorim seinen Runestone nicht dropt.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1103120025340104785",
    category = "raid",
    level = 3,
  },
  [89] = {
    name = "Zayr",
    guid = "Player-4477-0476BF51",
    race = "BloodElf",
    class = "PALADIN",
    faction = "Horde",
    description = "Lockt sich in Naxx25iger die Torch, als diese nicht droppt ninjat er sich einfach Turning Tide und geht mit Ansage offline	",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1100951022094008360",
    category = "raid",
    level = 3,
  },
  [90] = {
    name = "Zenjen",
    guid = "Player-4477-04DC35A4",
    race = "Orc",
    class = "SHAMAN",
    faction = "Horde",
    description = "Kickt ohne Grund Leute aus ner angefangenen PDOK 25er ID ohne Loot zu verrollen.",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/1124432246317776946",
    category = "raid",
    level = 3,
    aliases = { "Vhelron" },
  },
  [91] = {
    name = "Zizmo",
    guid = "Player-4477-04A0BDED",
    race = "Orc",
    class = "DEATHKNIGHT",
    faction = "Horde",
    description = "Scammed bei Deathrolls (rolled /2-2 und so faxen) der Frechfuchs",
    url = "https://discord.com/channels/613060619738021890/915181409155563521/995699503577436180",
    category = "trade",
    level = 3,
  },
  [92] = {
    name = "Zugzugondeez",
    guid = "Player-4477-04D7B02C",
    race = "Orc",
    class = "WARRIOR",
    faction = "Horde",
    description = "Needet den gesamten Loot und gewinnt dann auch noch den Schurken Token in HC++",
    url = "https://discord.com/channels/613060619738021890/1029711210918191154/1143307109568610314",
    category = "dungeon",
    level = 3,
  },
  [93] = {
    name = "Zullser",
    guid = "Player-4477-03B58DCD",
    race = "Troll",
    class = "MAGE",
    faction = "Horde",
    description = "Booster kickt Leute / geht Offline nach Bezahlung ohne Leistung",
    url = "https://docs.google.com/spreadsheets/d/1IKAr8A4P0-LhkXqMxizvgYy1E2gph_00M_O0r3rDGkY/edit",
    category = "dungeon",
    level = 3,
  },
  [94] = {
    name = "Zumbleistift",
    guid = "Player-4477-03B14913",
    race = "Tauren",
    class = "DRUID",
    faction = "Horde",
    description = "Kickt gern ungerechtfertigt Spieler aus HC ++ Dungeons und klaut ihnen somit die ID",
    url = "https://discord.com/channels/613060619738021890/1029711210918191154/1123313827539329044",
    category = "dungeon",
    level = 3,
  },
};
