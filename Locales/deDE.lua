local AddonName = ...;
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "deDE", false);
if not L then return end

L["AVAILABLE_COMMANDS"] = "Verfügbare Slash Commands:";
L["PRINT_COMMAND"] = "schreibt Characterdaten ins aktive Chatframe";
L["REPORT_COMMAND"] = "öffnet formatierte Characterdaten im separaten Fenster";
L["SEARCH_COMMAND"] = "durchsucht die Blocklisteneinträge nach dem Spielernamen";
L["CONFIG_COMMAND"] = "öffnet das Konfigurationsfenster";

L["NO_BLOCKLIST_ENTRIES"] = "Keine Einträge gefunden für %s";
L["FOUND_BLOCKLIST_ENTRIES"] = "%d |4Eintrag:Einträge; in der Blockliste gefunden für %s:";
L["CHECK_CHECKING_GUID"] = "Überprüfe %s";
L["CHECK_NAME_CHANGED"] = "Namensänderung entdeckt!";
L["CHECK_CLASS_CHANGED"] = "Klassenändern entdeckt!";
L["CHECK_FACTION_CHANGED"] = "Fraktionsänderung entdeckt!";
L["CHECK_UNKNOWN_GUID"] = "GUID %s ist nicht mehr verfügbar.";
L["CHECK_FINISHED"] = "Alle Einträge erfolgreich überprüft.";

L["CAUTION"] = "ACHTUNG!";
L["FRIENDS_LIST_NOTE"] = format("Von %s", AddonName);
L["COPY_SHORTCUT_INFO"] = "CTRL+C zum kopieren";
L["GUID_FROM_ANOTHER_REALM"] = "Spieler ist auf einem anderen Realm (%s).";

L["PLAYER_NOT_FOUND_TITLE"] = "Konnte keine Spielerinformationen für \"%s\" anfragen. Mögliche Gründe sind:";
L["PLAYER_NOT_FOUND_REASON_1"] = "1. Der eingegebene Name wurde falsch geschrieben.";
L["PLAYER_NOT_FOUND_REASON_2"] = "2. Der Charakter ist deiner aktuellen Fraktion feindlich gesinnt.";
L["PLAYER_NOT_FOUND_REASON_3"] = "3. Der Charakter wurde umbenannt, transferiert oder gelöscht.";
L["PLAYER_NOT_FOUND_REASON_4"] = "4. Deine Freundesliste kann keine weiteren Spieler aufnehmen.";

L["TURN_ON_GUID_MATCHING"] = "GUID Matching in Scambuster aktivieren?";
L["GUID_MATCHING_DESCRIPTION"] = "Durch GUID Matching werden Betrüger selbst nach Namensänderungen weiterhin erkannt.";
L["GUID_MATCHING_ENABLED"] = "GUID Matching wurde aktiviert.";
