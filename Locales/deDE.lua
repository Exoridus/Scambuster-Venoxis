local AddonName = ...;
---@type AddonLocale
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "deDE", false);
if not L then return end

L.BLOCKLIST_NAME = "Venoxis Discord Blocklist";
L.BLOCKLIST_PROVIDER = "Venoxis Discord";
L.BLOCKLIST_DESCRIPTION = "Scambuster Datenbank mit Chars von Betrügern und unangemessenen Spielern auf Venoxis.";

L.NEW_VERSION_AVAILABLE = "Eine neue Version ist verfügbar!";
L.PLEASE_UPDATE_ASAP = "Bitte update so bald wie möglich!";

L.AVAILABLE_COMMANDS = "Verfügbare Slash Commands: (/v auch möglich)";
L.PRINT_COMMAND_1 = "öffnet ein Kopierfenster mit Charakterdaten des anvisierten Spielers.";
L.PRINT_COMMAND_2 = "öffnet ein Kopierfenster mit Charakterdaten der genannten Spieler.";
L.REPORT_COMMAND_1 = "öffnet ein Reportfenster mit Charakterdaten des anvisierten Spielers.";
L.REPORT_COMMAND_2 = "öffnet ein Reportfenster mit Characterdaten der genannten Spieler.";
L.CONFIG_COMMAND = "öffnet das Konfigurationsfenster von Scambuster-Venoxis.";
L.VERSION_COMMAND = "gibt die aktuelle Addon Version im aktiven Chatfenster aus.";
L.ENTER_PLAYER_NAME = "Gib einen Namen an oder nimm nimm den Spieler ins Target.";

L.NAME = "Name";
L.GUID = "GUID";
L.RACE = "Volk";
L.CLASS = "Klasse";
L.FACTION = "Fraktion";
L.SETTINGS = "Einstellungen";
L.PROFILES = "Profile";
L.ABOUT = "Über";
L.ACTIVATE = "Aktivieren";
L.IGNORE = "Ignorieren";

L.NO_BLOCKLIST_ENTRIES = "Keine Einträge gefunden für %s";
L.FOUND_BLOCKLIST_ENTRIES = "%d |4Eintrag:Einträge; in der Blockliste gefunden für %s:";
L.NO_BANNED_ENTRIES = "Keine Einträge gefunden die gebannt sein könnten.";
L.BANNED_ENTRY = "%d. %s (%s)";
L.CHECK_STARTED = "Suche nach Änderungen in %d Einträgen. (ca. %ds)";
L.CHECK_PROGRESS = "Überprüfe Eintrag %d/%d";
L.CHECK_FINISHED = "Alle %d Einträge erfolgreich überprüft.";
L.UNKNOWN_GUID = "GUID %s ist nicht mehr verfügbar.";
L.FOUND_NAME_COLLISION = "Verschiedenen Namen gefunden bei GUID %s: %s, %s.";
L.NAME_CHANGE_COMPARE = "Alter Name: %s|nNeuer Name: %s";

L.COPY_SHORTCUT_INFO = "CTRL+C zum kopieren";
L.GUID_FROM_ANOTHER_REALM = "Spieler ist auf einem anderen Realm (%s).";

L.PLAYER_NOT_FOUND_TITLE = "Konnte keine Spielerinformationen für \"%s\" anfragen. Mögliche Gründe sind:";
L.PLAYER_NOT_FOUND_REASONS = [[
1. Der eingegebene Name wurde falsch geschrieben.
2. Der Charakter ist deiner aktuellen Fraktion feindlich gesinnt.
3. Der Charakter ignoriert deinen Charakter und/oder Account.
4. Der Charakter wurde umbenannt, transferiert oder gelöscht.
5. Deine Freundesliste kann keine weiteren Spieler aufnehmen.
]];
