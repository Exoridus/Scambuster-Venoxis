---@alias Class "DEATHKNIGHT" | "DRUID" | "HUNTER" | "MAGE" | "PALADIN" | "PRIEST" | "ROGUE" | "SHAMAN" | "WARRIOR" | "WARLOCK"
---@alias Faction "Horde" | "Alliance"
---@alias Category "dungeon" | "raid" | "trade" | "gdkp" | "harassment"
---@alias Level 1 | 2 | 3

---@class Dict<K, V>
---@field [K] V

---@shape Player
---@field name string The last known name of the listed toon.
---@field guid string The GUID of the player is a more powerful identifier than the toon's name, and persists through most types of reroll.
---@field class Class One of "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "DEATHKNIGHT", "SHAMAN", "MAGE", "WARLOCK", "DRUID".
---@field faction Faction Either "Horde" or "Alliance"
---@field aliases nil|string[] A list of the previous aliases this player has gone under.

---@shape PlayerCase : Player
---@field url string A URL to the evidence against this player.
---@field description string A short verbal description of the case and offence.
---@field category Category One of "dungeon", "raid", "trade", "gdkp", "harassment".
---@field level Level Numeric severity level. 1 (Reformed), 2 (Probation), "Scammer" (default)

---@shape GroupCase
---@field url string A URL to the evidence against this player.
---@field description string A short verbal description of the case and offence.
---@field category Category One of "dungeon", "raid", "trade", "gdkp", "harassment".
---@field level Level Numeric severity level. 1 (Reformed), 2 (Probation), "Scammer" (default)
---@field players Player[] A list of the previous aliases this player has gone under.

---@alias CaseTable (PlayerCase | GroupCase)[]

---@shape AddonTable
---@field my_name string
---@field my_provider string
---@field my_realm string
---@field my_description string
---@field my_url string
---@field case_table CaseTable

---@shape ProviderTable
---@field name string
---@field provider string
---@field description string
---@field url string
---@field realm_data table<string, CaseTable>