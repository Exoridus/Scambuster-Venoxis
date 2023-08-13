local AddonName = ...;
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "enUS", true);
if not L then return end

L["BLOCKLIST_NAME"] = "Venoxis Discord Blocklist";
L["BLOCKLIST_PROVIDER"] = "Venoxis Discord";
L["BLOCKLIST_DESCRIPTION"] = "Scambuster database with chars of scammers and inappropriate players on Venoxis.";

L["AVAILABLE_COMMANDS"] = "Available Slash Commands (/sv and /sbv are also possible):";
L["PRINT_COMMAND_1"] = "prints character data of your target into your chat frame";
L["PRINT_COMMAND_2"] = "prints character data of player <name> into your chat frame";
L["REPORT_COMMAND_1"] = "opens character data of your target inside a copy window";
L["REPORT_COMMAND_2"] = "opens character data of player <name> inside a copy window";
L["CONFIG_COMMAND"] = "open up the addons config window";
L["ENTER_PLAYER_NAME"] = "Please enter a player name you want to report.";

L["NO_BLOCKLIST_ENTRIES"] = "No blocklist entries found for %s";
L["FOUND_BLOCKLIST_ENTRIES"] = "Found %d blocklist entries for %s:";
L["CHECK_CHECKING_GUID"] = "Checking %s";
L["CHECK_NAME_CHANGED"] = "Name change detected!";
L["CHECK_CLASS_CHANGED"] = "Class change detected!";
L["CHECK_FACTION_CHANGED"] = "Faction change detected!";
L["CHECK_UNKNOWN_GUID"] = "GUID %s is not available anymore.";
L["CHECK_FINISHED"] = "Finished blocklist entry check.";

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