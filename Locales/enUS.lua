---@type AddonName, Addon
local AddonName = ...;
---@class AddonLocale: { [string]: string }
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "enUS", true, true);

if not L then
  return;
end

L.BLOCKLIST_NAME = "Venoxis Discord Blocklist";
L.BLOCKLIST_PROVIDER = "Venoxis Discord";

L.ABOUT = "About";
L.ABOUT_HEAD = "About Scambuster-Venoxis";
L.ABOUT_DESC = "About";
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

L.UPDATE_NOTICE = "A new version is available! Please update as soon as possible!";

L.ENTER_PLAYER_NAME = "Provide a name or target the player you want to report.";
L.PLAYER_NOT_FOUND = [[
Could not fetch player info for %q. Possible reasons are:
1. The given name was misspelled or contains typos.
2. The character is on the opposite faction as you.
3. The character ignores your character and/or account.
4. The character was renamed, transferred or deleted.
5. Your friends list is full and can't fit any more players.
]];

L.COMMANDS = [[
Available slash commands for Scambuster-Venoxis:

|cFFFFFF33/v print [name]|r
Opens a copy window with the character data of players you provided.
If no name was provided then the current targeted player is used.

|cFFFFFF33/v report [name]|r
Opens a report window with the character data of players you provided.
If no name was provided then the current targeted player is used.

|cFFFFFF33/v config|r
Opens the main configuration window of Scambuster-Venoxis.

|cFFFFFF33/v version|r
Print the current addon version inside the active chat frame.
]];

L.PLAYER_REPORT = [[
Name: %s
GUID: %s
Race: %s
Class: %s
Faction: %s
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
