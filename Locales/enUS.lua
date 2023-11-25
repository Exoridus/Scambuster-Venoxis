local AddonName = ...;
---@class AddonLocale : table<string, string>
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "enUS", true);
if not L then return end

L.BLOCKLIST_NAME = "Venoxis Discord Blocklist";
L.BLOCKLIST_PROVIDER = "Venoxis Discord";
L.BLOCKLIST_DESCRIPTION = "Scambuster database with chars of scammers and inappropriate players on Venoxis.";

L.UPDATE_NOTICE = "A new version is available! Please update as soon as possible!";

L.AVAILABLE_COMMANDS = "Available slash commands: (/v also works)";
L.PRINT_COMMAND_1 = "opens a copy window with character data of the player in your target.";
L.PRINT_COMMAND_2 = "opens a copy window with character data of players you provided.";
L.REPORT_COMMAND_1 = "opens a report window with character data of the player in your target.";
L.REPORT_COMMAND_2 = "opens a report window with character data of players you provided.";
L.CONFIG_COMMAND = "opens the main configuration window of Scambuster-Venoxis.";
L.VERSION_COMMAND = "print the current addon version inside the active chat frame.";
L.ENTER_PLAYER_NAME = "Provide a name or target the player you want to report.";

L.NAME = "Name";
L.GUID = "GUID";
L.RACE = "Race";
L.CLASS = "Class";
L.FACTION = "Faction";
L.SETTINGS = "Settings";
L.PROFILES = "Profiles";
L.ABOUT = "About";
L.ACTIVATE = "Activate";
L.IGNORE = "Ignore";

L.NO_BLOCKLIST_ENTRIES = "No blocklist entries found for %s";
L.FOUND_BLOCKLIST_ENTRIES = "Found %d blocklist entries for %s:";
L.NO_BANNED_ENTRIES = "No banned entries found in blocklist.";
L.BANNED_ENTRY = "%d. %s (%s)";
L.CHECK_STARTED = "Search for changes in %d entries. (duration ~%ds)";
L.CHECK_PROGRESS = "Checking entry %d/%d";
L.CHECK_FINISHED = "Finished search for changes in %d entries.";
L.UNKNOWN_GUID = "GUID %s is not available anymore.";
L.FOUND_NAME_COLLISION = "Different names were found for GUID %s: %s, %s.";
L.NAME_CHANGE_COMPARE = "Old Name: %s|nNew Name: %s";

L.COPY_SHORTCUT_INFO = "Use CTRL+C to copy data.";
L.GUID_FROM_ANOTHER_REALM = "Player is from another realm (%s).";

L.PLAYER_NOT_FOUND_TITLE = "Could not fetch player info for \"%s\". Possible reasons are:";
L.PLAYER_NOT_FOUND_REASONS = [[
1. The given name was misspelled or contains typos.
2. The character is on the opposite faction as you.
3. The character ignores your character and/or account.
4. The character was renamed, transferred or deleted.
5. Your friends list is full and can't fit any more players.
]];
