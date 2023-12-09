---@meta

---@class LibSerializeOptions
---@field errorOnUnserializableType? boolean
---@field stable? boolean
---@field filter? fun(t: table, k: any, v: any): boolean

---@class LibSerialize
local LibSerialize = {};

---@param opts LibSerializeOptions
---@param ... any
---@return string
function LibSerialize:SerializeEx(opts, ...) end

---@param ... any
---@return string
function LibSerialize:Serialize(...) end

---@param input string
---@return true, ...
---@overload fun(input: string): false, string
function LibSerialize:Deserialize(input) end

---@param input string
---@return ...
function LibSerialize:DeserializeValue(input) end

---@param ... any
---@return boolean
function LibSerialize:IsSerializableType(...) end
