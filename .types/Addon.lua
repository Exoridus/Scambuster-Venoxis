---@meta

---@alias AddonName "Scambuster-Venoxis"

---@alias AddonModules
---| '"Utils"'
---| '"Blocklist"'
---| '"Commands"'
---| '"Config"'
---| '"Networking"'

---@class Addon: AceAddon
local Addon = {};

---@generic T: AddonModules
---@param name `T`
---@param silent? boolean
---@return T
function Addon:GetModule(name, silent) end
