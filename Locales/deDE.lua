---@type AddonName, Addon
local AddonName = ...;
---@type AddonLocale
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "deDE", false);

if not L then
  return;
end

L.BLOCKLIST_NAME = "Venoxis Discord Blocklist";
L.BLOCKLIST_PROVIDER = "Venoxis Discord";

L.ABOUT = "Über";
L.ABOUT_HEAD = "Über Scambuster-Venoxis";
L.ABOUT_DESC = "Über";
L.VERSION = "Version";
L.REVISION = "Revision";
L.DATE = "Datum";
L.AUTHOR = "Author";
L.CREDITS = "Unterstützer";
L.LICENSE = "Lizens";
L.LOCALIZATIONS = "Lokalisierungen";
L.CATEGORY = "Kategorie";
L.DISCORD = "Discord";
L.WEBSITE = "Website";
L.FEEDBACK = "Feedback";
L.DONATE = "Spenden";

L.SETTINGS = "Einstellungen";
L.SETTINGS_HEAD = "Einstellungen";
L.SETTINGS_DESC = "Einstellungen";
L.WELCOME_MESSAGE = "Welcome Message";
L.DEBUG_MODE = "Debug Mode";
L.PURGE_DATABASE = "Clean Database";
L.PURGE_DATABASE_DESC = "Click to purge the settings of all unused add-ons and groups.";
L.PURGE_DATABASE_CONFIRM = "This action cannot be undone. Continue?";

L.OVERRIDES = "Overrides";
L.OVERRIDES_HEAD = "Scambuster Overrides";
L.OVERRIDES_DESC = "Overrides";
L.REQUIRE_GUID_MATCH = "GUID Matching";
L.MATCH_ALL_INCIDENTS = "Name Matching";
L.ALERT_LOCKOUT_SECONDS = "Alert Lockout";
L.USE_GROUP_CHAT_ALERT = "Group/Raid chat";

L.PROFILES = "Profile";

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

L.UPDATE_NOTICE = "Eine neue Version ist verfügbar! Bitte update so bald wie möglich!";

L.ENTER_PLAYER_NAME = "Gib einen Namen an oder nimm nimm den Spieler ins Target.";
L.PLAYER_NOT_FOUND_TITLE = "Konnte keine Spielerinformationen für \"%s\" anfragen. Mögliche Gründe sind:";
L.PLAYER_NOT_FOUND_REASONS = [[
1. Der eingegebene Name wurde falsch geschrieben.
2. Der Charakter ist deiner aktuellen Fraktion feindlich gesinnt.
3. Der Charakter ignoriert deinen Charakter und/oder Account.
4. Der Charakter wurde umbenannt, transferiert oder gelöscht.
5. Deine Freundesliste kann keine weiteren Spieler aufnehmen.
]];

L.COMMANDS = [[
Verfügbare Slash Befehle für Scambuster-Venoxis:

|cFFFFFF33/v print [name]|r
Öffnet ein Kopierfenster mit Charakterdaten der genannten Spieler.
Wenn kein Name angegeben wurde, wird der aktuell anvisierte Spieler benutzt.

|cFFFFFF33/v report [name]|r
Öffnet ein Reportfenster mit Charakterdaten der genannten Spieler.
Wenn kein Name angegeben wurde, wird der aktuell anvisierte Spieler benutzt.

|cFFFFFF33/v config|r
Öffnet das Konfigurationsfenster von Scambuster-Venoxis.

|cFFFFFF33/v version|r
Gibt die aktuelle Addon Version im aktiven Chatfenster aus.
]];

L.PLAYER_REPORT = [[
Name: %s
GUID: %s
Volk: %s
Klasse: %s
Fraktion: %s
]];

L.PLAYER_ENTRY = [[
{
  name = %q,
  guid = %q,
  class = %q,
  faction = %q,
  description = "",
  url = "",
  category = "",
  level = 3,
},
]];
