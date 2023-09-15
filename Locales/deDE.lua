local AddonName = ...;
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "deDE", false);
if not L then return end

L["BLOCKLIST_NAME"] = "Venoxis Discord Blocklist";
L["BLOCKLIST_PROVIDER"] = "Venoxis Discord";
L["BLOCKLIST_DESCRIPTION"] = "Scambuster Datenbank mit Chars von Betrügern und unangemessenen Spielern auf Venoxis.";

L["AVAILABLE_COMMANDS"] = "Verfügbare Slash Commands:";
L["PRINT_COMMAND_1"] = "schreibt die Characterdaten deines Targets ins aktive Chatfenster.";
L["PRINT_COMMAND_2"] = "schreibt Characterdaten der genannten Spieler ins aktive Chatframe.";
L["REPORT_COMMAND_1"] = "öffnet ein Kopierfenster mit Characterdaten deines Targets.";
L["REPORT_COMMAND_2"] = "öffnet ein Kopierfenster mit Characterdaten der genannten Spieler.";
L["CHECK_COMMAND"] = "durchsucht Blockliste nach geänderten Namen/Klassen/Fraktionen.";
L["ABOUT_COMMAND"] = "öffnet ein Fenster mit Informationen über Scambuster-Venoxis.";
L["ENTER_PLAYER_NAME"] = "Gib einen Namen an oder nimm nimm den Spieler ins Target.";

L["NAME_PROP"] = "Name: ";
L["GUID_PROP"] = "GUID: ";
L["RACE_PROP"] = "Volk: ";
L["CLASS_PROP"] = "Klasse: ";
L["FACTION_PROP"] = "Fraktion: ";

L["NO_BLOCKLIST_ENTRIES"] = "Keine Einträge gefunden für %s";
L["FOUND_BLOCKLIST_ENTRIES"] = "%d |4Eintrag:Einträge; in der Blockliste gefunden für %s:";
L["CHECK_STARTED"] = "Suche nach Änderungen in %d GUIDs. (ca. %ds)";
L["CHECK_PROGRESS"] = "Überprüfe %s (%d/%d)";
L["CHANGE_FOUND"] = "%s wurde geändert!";
L["NAME_CHANGE"] = "Namensänderung";
L["CLASS_CHANGE"] = "Klassenänderung";
L["FACTION_CHANGE"] = "Fraktionsänderung";
L["CHANGED_VALUE"] = "%s (Vorher: %s)";
L["UNKNOWN_GUID"] = "GUID %s ist nicht mehr verfügbar.";
L["CHECK_FINISHED"] = "Alle %d GUIDs erfolgreich überprüft.";
L["FOUND_NAME_COLLISION"] = "Verschiedenen Namen gefunden bei GUID %s: %s, %s.";

L["CAUTION"] = "ACHTUNG!";
L["FRIENDS_LIST_NOTE"] = format("Von %s", AddonName);
L["COPY_SHORTCUT_INFO"] = "CTRL+C zum kopieren";
L["GUID_FROM_ANOTHER_REALM"] = "Spieler ist auf einem anderen Realm (%s).";

L["PLAYER_NOT_FOUND_TITLE"] = "Konnte keine Spielerinformationen für \"%s\" anfragen. Mögliche Gründe sind:";
L["PLAYER_NOT_FOUND_REASON_1"] = "1. Der eingegebene Name wurde falsch geschrieben.";
L["PLAYER_NOT_FOUND_REASON_2"] = "2. Der Charakter ist deiner aktuellen Fraktion feindlich gesinnt.";
L["PLAYER_NOT_FOUND_REASON_3"] = "3. Der Charakter ignoriert deinen Charakter und/oder Account.";
L["PLAYER_NOT_FOUND_REASON_4"] = "4. Der Charakter wurde umbenannt, transferiert oder gelöscht.";
L["PLAYER_NOT_FOUND_REASON_5"] = "5. Deine Freundesliste kann keine weiteren Spieler aufnehmen.";

L["TURN_ON_GUID_MATCHING"] = "GUID Matching in Scambuster aktivieren?";
L["GUID_MATCHING_DESCRIPTION"] = "Durch GUID Matching werden Betrüger selbst nach Namensänderungen weiterhin erkannt.";
L["GUID_MATCHING_ENABLED"] = "GUID Matching wurde aktiviert.";
