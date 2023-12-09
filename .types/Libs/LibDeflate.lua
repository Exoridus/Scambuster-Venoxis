---@meta

---@class LibDeflate
local LibDeflate = {}

---@param str string
---@return integer
function LibDeflate:Adler32(str) end

---@param str string
---@param configs? table
---@return string, integer
function LibDeflate:CompressDeflate(str, configs) end

---@param str string
---@param dictionary table
---@param configs? table
---@return string, integer
function LibDeflate:CompressDeflateWithDict(str, dictionary, configs) end

---@param str string
---@param configs? table
---@return string, integer
function LibDeflate:CompressZlib(str, configs) end

---@param str string
---@param dictionary table
---@param configs? table
---@return string, integer
function LibDeflate:CompressZlibWithDict(str, dictionary, configs) end

---@param reserved_chars string
---@param escape_chars string
---@param map_chars string
---@return table|nil, nil|string
function LibDeflate:CreateCodec(reserved_chars, escape_chars, map_chars) end

---@param str string
---@param strlen integer
---@param adler32 integer
---@return table
function LibDeflate:CreateDictionary(str, strlen, adler32) end

---@param str string
---@return string|nil
function LibDeflate:DecodeForPrint(str) end

---@param str string
---@return string|nil
function LibDeflate:DecodeForWoWAddonChannel(str) end

---@param str string
---@return string|nil
function LibDeflate:DecodeForWoWChatChannel(str) end

---@param str string
---@return string|nil, integer
function LibDeflate:DecompressDeflate(str) end

---@param str string
---@param dictionary table
---@return string|nil, integer
function LibDeflate:DecompressDeflateWithDict(str, dictionary) end

---@param str string
---@return string|nil, integer
function LibDeflate:DecompressZlib(str) end

---@param str string
---@param dictionary table
---@return string|nil, integer
function LibDeflate:DecompressZlibWithDict(str, dictionary) end

---@param str string
---@return string
function LibDeflate:EncodeForPrint(str) end

---@param str string
---@return string
function LibDeflate:EncodeForWoWAddonChannel(str) end

---@param str string
---@return string
function LibDeflate:EncodeForWoWChatChannel(str) end