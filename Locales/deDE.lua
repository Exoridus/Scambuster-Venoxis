local AddonName = ...;
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "deDE", false);
if not L then return end

L["BLOCKLIST_NAME"] = "Venoxis Discord Blocklist";
L["BLOCKLIST_PROVIDER"] = "Venoxis Discord";
L["BLOCKLIST_DESCRIPTION"] = "Scambuster Datenbank mit Chars von Betrügern und unangemessenen Spielern auf Venoxis.";
L["BLOCKLIST_URL"] = "https://discord.gg/NGtvvQYnmP";

L["AVAILABLE_COMMANDS"] = "Verfügbare Slash Commands:";
L["PRINT_COMMAND"] = "schreibt Characterdaten ins aktive Chatframe";
L["REPORT_COMMAND"] = "öffnet formatierte Characterdaten im separaten Fenster";
L["SEARCH_COMMAND"] = "durchsucht die Blocklisteneinträge nach dem Spielernamen";
L["DUMP_COMMAND"] = "öffnet die sortierten Listeneinträge im separaten Fenster";
L["CONFIG_COMMAND"] = "öffnet die Addon Konfiguration";

L["NO_BLOCKLIST_ENTRIES"] = "Keine Einträge gefunden für %s";
L["FOUND_BLOCKLIST_ENTRIES"] = "%d |4Eintrag:Einträge; in der Blockliste gefunden für %s:";
L["FOUND_CHECKLIST_ENTRIES"] = "%d |4Eintrag:Einträge; in der Checkliste gefunden für %s:";
L["CHECKLIST_SEARCH_STARTED"] = "Checkliste wird überprüft. Geschätzte Dauer liegt bei %d |4Sekunde:Sekunden;.";
L["CHECKLIST_CHECK_PLAYER"] = "Suche nach Spieler %s...";
L["CHECKLIST_NEW_MATCH"] = "Neuer treffer für Spieler %s (index %d):";
L["CHECKLIST_NO_MATCH"] = "Kein Ergebnis für %s.";
L["CHECKLIST_SEARCH_FINISHED"] = "Checkliste vollständig überprüft mit %d neuen |4Treffer:Treffern;.";

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
