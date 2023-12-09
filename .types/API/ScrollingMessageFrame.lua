---@meta

---@class ScrollingMessageFrameMixin: FontableFrameMixin
local ScrollingMessageFrameMixin = {}

function ScrollingMessageFrameMixin:AddMessage(message, r, g, b, ...) end
function ScrollingMessageFrameMixin:BackFillMessage(message, r, g, b, ...) end
function ScrollingMessageFrameMixin:GetMessageInfo(messageIndex) end
function ScrollingMessageFrameMixin:RemoveMessagesByPredicate(predicate) end
function ScrollingMessageFrameMixin:AdjustMessageColors(transformFunction) end
function ScrollingMessageFrameMixin:TransformMessages(predicate, transformFunction) end
function ScrollingMessageFrameMixin:ScrollByAmount(amount) end
function ScrollingMessageFrameMixin:AddOnDisplayRefreshedCallback(callback) end
function ScrollingMessageFrameMixin:SetOnScrollChangedCallback(onScrollChangedCallback) end
function ScrollingMessageFrameMixin:SetOnTextCopiedCallback(onTextCopiedCallback) end
function ScrollingMessageFrameMixin:SetScrollOffset(offset) end
function ScrollingMessageFrameMixin:SetMaxLines(maxLines) end
function ScrollingMessageFrameMixin:SetFading(shouldFadeAfterInactivity) end
function ScrollingMessageFrameMixin:SetTimeVisible(timeVisibleSecs) end
function ScrollingMessageFrameMixin:SetFadeDuration(fadeDurationSecs) end
function ScrollingMessageFrameMixin:SetInsertMode(insertMode) end
function ScrollingMessageFrameMixin:SetTextCopyable(textIsCopyable) end
function ScrollingMessageFrameMixin:OnPostUpdate(elapsed) end
function ScrollingMessageFrameMixin:CalculateSelectingCharacterIndicesForVisibleLine(lineIndex, startLineIndex, endLineIndex, startCharacterIndex, endCharacterIndex) end
function ScrollingMessageFrameMixin:GatherSelectedText(x, y) end
function ScrollingMessageFrameMixin:FindCharacterAndLineIndexAtCoordinate(x, y) end
function ScrollingMessageFrameMixin:CalculateLineAlphaValueFromTimestamp(now, timestamp) end
function ScrollingMessageFrameMixin:PackageEntry(message, r, g, b, ...) end
function ScrollingMessageFrameMixin:UnpackageEntry(entry) end

---@class ScrollingMessageFrame: Frame, ScrollingMessageFrameMixin
ScrollingMessageFrame = {}
