---@meta

---@class Scambuster: AceAddon, AceConsole-3.0, AceEvent-3.0
---@field db AceDBObject-3.0
---@field callbacks CallbackHandlerRegistry
---@field defaults table
---@field options table
---@field incident_categories table<Scambuster.Category, string>
---@field supported_case_data_fields table<string, boolean>
---@field scan_table table<string, Scambuster.ScanTable>
---@field levels table<Scambuster.Level, string>
local Scambuster = {};

---@alias Scambuster.Class
---| '"DEATHKNIGHT"'
---| '"DRUID"'
---| '"HUNTER"'
---| '"MAGE"'
---| '"PALADIN"'
---| '"PRIEST"'
---| '"ROGUE"'
---| '"SHAMAN"'
---| '"WARRIOR"'
---| '"WARLOCK"'

---@alias Scambuster.Faction
---| '"Horde"'
---| '"Alliance"'

---@alias Scambuster.Category
---| '"dungeon"'
---| '"raid"'
---| '"trade"'
---| '"gdkp"'
---| '"harassment"'

---@alias Scambuster.Level
---| 1
---| 2
---| 3

---@class Scambuster.PlayerInfo
---@field name string
---@field guid string
---@field class Scambuster.Class
---@field faction Scambuster.Faction
---@field aliases? string[]

---@class Scambuster.PlayerEntry : Scambuster.PlayerInfo
---@field url string
---@field description string
---@field category Scambuster.Category
---@field level Scambuster.Level

---@class Scambuster.GroupEntry
---@field url string
---@field description string
---@field category Scambuster.Category
---@field level Scambuster.Level
---@field players Scambuster.PlayerInfo[]

---@alias Scambuster.Entry Scambuster.PlayerEntry | Scambuster.GroupEntry

---@class Scambuster.ProviderInfo
---@field name string
---@field provider string
---@field description string
---@field url string
---@field realm_data { [string]: Scambuster.Entry[] }

---@class Scambuster.ScanTable
---@field event string
---@field pretty string
---@field can_broadcast boolean?
---@field events string[]?

---@alias Scambuster.EventName
---| '"SCAMBUSTER_LIST_CONSTRUCTION"'

---@param data Scambuster.ProviderInfo
function Scambuster:register_case_data(data) end

---@param target table
---@param eventName Scambuster.EventName
---@param method string|function
---@param ... any
function Scambuster.RegisterCallback(target, eventName, method, ...) end

---@param target table
---@param eventName Scambuster.EventName
function Scambuster.UnregisterCallback(target, eventName) end

---@param target table
function Scambuster.UnregisterAllCallbacks(target) end

---@class AceAddon-3.0
local AceAddon = {}

---@param name "Scambuster"
---@param silent? boolean
---@return Scambuster
function AceAddon:GetAddon(name, silent) end
