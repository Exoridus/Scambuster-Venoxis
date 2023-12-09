---@meta

---@class FontableFrameMixin
FontableFrameMixin = {}

---@param font? SimpleFont|FontObject
function FontableFrameMixin:SetFontObject(font) end

---@return SimpleFont font
function FontableFrameMixin:GetFontObject() end

---@return boolean
function FontableFrameMixin:HasFontObject() end

---@param fontFile string
---@param fontHeight uiUnit
---@param flags TBFFlags
function FontableFrameMixin:SetFont(fontFile, fontHeight, flags) end

---@return string? fontFile
---@return uiUnit fontHeight
---@return TBFFlags flags
function FontableFrameMixin:GetFont() end

---@param colorR number
---@param colorG number
---@param colorB number
---@param colorA? number
function FontableFrameMixin:SetTextColor(colorR, colorG, colorB, colorA) end

---@return number colorR
---@return number colorG
---@return number colorB
---@return number colorA
function FontableFrameMixin:GetTextColor() end

---@param colorR number
---@param colorG number
---@param colorB number
---@param colorA? number
function FontableFrameMixin:SetShadowColor(colorR, colorG, colorB, colorA) end

---@return number colorR
---@return number colorG
---@return number colorB
---@return number colorA
function FontableFrameMixin:GetShadowColor() end

---@param offsetX number
---@param offsetY number
function FontableFrameMixin:SetShadowOffset(offsetX, offsetY) end

---@return number, number
function FontableFrameMixin:GetShadowOffset() end

---@param spacing number
function FontableFrameMixin:SetSpacing(spacing) end

---@return number
function FontableFrameMixin:GetSpacing() end

---@param justifyH JustifyH
function FontableFrameMixin:SetJustifyH(justifyH) end

---@return JustifyH
function FontableFrameMixin:GetJustifyH() end

---@param justifyV JustifyV
function FontableFrameMixin:SetJustifyV(justifyV) end

---@return JustifyV
function FontableFrameMixin:GetJustifyV() end

---@param wrap boolean
function FontableFrameMixin:SetIndentedWordWrap(wrap) end

---@return boolean wrap
function FontableFrameMixin:GetIndentedWordWrap() end

---@protected
---@param name string
function FontableFrameMixin:InitializeFontableFrame(name) end

---@protected
function FontableFrameMixin:OnFontObjectUpdated() end

---@private
function FontableFrameMixin:MakeFontObjectCustom() end
