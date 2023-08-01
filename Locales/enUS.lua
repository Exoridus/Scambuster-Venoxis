local AddonName = ...;
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "enUS", true);
if not L then return end

L["BLOCKLIST_NAME"] = "Venoxis Discord Blocklist";
L["BLOCKLIST_PROVIDER"] = "Venoxis Discord";
L["BLOCKLIST_DESCRIPTION"] = "Scambuster database with chars of scammers and inappropriate players on Venoxis.";
L["BLOCKLIST_URL"] = "https://discord.gg/NGtvvQYnmP";

L["AVAILABLE_COMMANDS"] = "Available Slash Commands:";
L["PRINT_COMMAND"] = "prints character data into your current chat frame";
L["REPORT_COMMAND"] = "displays character data in format of an lua entry";
L["SEARCH_COMMAND"] = "searches blocklist entries for matching player names";
L["DUMP_COMMAND"] = "dumps the list entries sorted by player names";
L["CONFIG_COMMAND"] = "open up the addons config window";

L["NO_BLOCKLIST_ENTRIES"] = "No blocklist entries found for %s";
L["FOUND_BLOCKLIST_ENTRIES"] = "Found %d blocklist entries for %s:";
L["FOUND_CHECKLIST_ENTRIES"] = "Found %d checklist entries for %s:";
L["CHECKLIST_SEARCH_STARTED"] = "Checklist search started. This takes about %d seconds.";
L["CHECKLIST_CHECK_PLAYER"] = "Checking player %s...";
L["CHECKLIST_NEW_MATCH"] = "New match for player %s on index %d:";
L["CHECKLIST_NO_MATCH"] = "No match for player %s.";
L["CHECKLIST_SEARCH_FINISHED"] = "Checklist search finished with %d new matches.";

L["CAUTION"] = "CAUTION!";
L["FRIENDS_LIST_NOTE"] = format("From %s", AddonName);
L["COPY_SHORTCUT_INFO"] = "Use CTRL+C to copy data.";
L["GUID_FROM_ANOTHER_REALM"] = "player is from another realm (%s).";

L["PLAYER_NOT_FOUND_TITLE"] = "Could not fetch player info for \"%s\". Possible reasons are:";
L["PLAYER_NOT_FOUND_REASON_1"] = "1. The given name was misspelled or contains typos.";
L["PLAYER_NOT_FOUND_REASON_2"] = "2. The character is on the opposite faction as you.";
L["PLAYER_NOT_FOUND_REASON_3"] = "3. The character was renamed, transferred or deleted.";
L["PLAYER_NOT_FOUND_REASON_4"] = "4. Your friends list is full but at least one free slot is required.";

L["TURN_ON_GUID_MATCHING"] = "Turn on GUID Matching in Scambuster?";
L["GUID_MATCHING_DESCRIPTION"] = "With activated GUID matching scammers still get found even after changing names.";
L["GUID_MATCHING_ENABLED"] = "GUID matching is now enabled.";