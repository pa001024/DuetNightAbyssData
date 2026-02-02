require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.CursorLineIdx = 0
  self.CursorOffset = 0
  self.CurrentText = ""
  self.bHasNewText = false
  if self.Text_Input then
    self.Text_Input.OnTextChanged:Add(self, self.OnInputTextChanged)
    self.Text_Input.OnTextComposing:Add(self, self.OnTextComposing)
    self.Text_Input.OnPressed:Add(self, self.ExecOnTextOnPressed)
    self.Text_Input.OnTextCommitted:Add(self, self.ExecOnTextCommintted)
    self.Text_Input.OnFocusReceived:Add(self, self.EditOnTextFocusReceived)
    self.Text_Input.OnFocusLost:Add(self, self.EditOnTextFocusLost)
    self.Text_Input.OnCursorMoved:Add(self, self.OnEditTextCursorMoved)
    self.CurrentText = self.Text_Input:GetText()
    self.CursorOffset = string.len(self.CurrentText)
  end
  self:PlayAnimation(self.Click)
  if not UIUtils.IsGamepadInput() then
    self.Text_Input:SetKeyboardFocus()
  end
end

function M:Init(Params)
  self.InputCallback = Params.InputCallback or nil
  self.OwnerPanel = Params.OwnerPanel or nil
  self.TextLimit = Params.TextLimit or 9999
end

function M:SetTextLimit(Limit)
  self.TextLimit = Limit or 9999
end

function M:OnInputTextChanged(Text)
  local FilteredText = string.gsub(Text, "%D", "")
  if string.len(FilteredText) > self.TextLimit then
    if self.Text_Input:GetText() ~= self.CurrentText then
      self.Text_Input:SetText(self.CurrentText)
      self:SetCursorPosition(0, self.CursorOffset)
    end
    if not self.bIsLimitTipShowing then
      self.OwnerPanel:ShowTip("UI_Number_MaxNumber", false)
      self.bIsLimitTipShowing = true
    end
    return
  elseif self.bIsLimitTipShowing then
    self.OwnerPanel:HideTip()
    self.bIsLimitTipShowing = false
  end
  if FilteredText ~= Text then
    self.Text_Input:SetText(FilteredText)
  end
  self.CurrentText = FilteredText
end

function M:OnTextComposing(Text)
  local FilteredText = string.gsub(Text, "%D", "")
  if string.len(FilteredText) > self.TextLimit then
    if self.Text_Input:GetText() ~= self.CurrentText then
      self.Text_Input:SetText(self.CurrentText)
      self:SetCursorPosition(0, self.CursorOffset)
    end
    return
  else
  end
  if FilteredText ~= Text then
    self.Text_Input:SetText(FilteredText)
  end
  self.CurrentText = FilteredText
end

function M:ExecOnTextOnPressed()
  self.Text_Input:SetText(tostring(self.CurrentText))
  self.Text_Input:SetRenderOpacity(1.0)
end

function M:ExecOnTextCommintted(InText, CommitType)
  local TempNumber = "" ~= InText and tonumber(InText) or 1
  local OldNumberValue = self.CurrentText
  if type(self.InputCallback) == "function" then
    self.InputCallback(self.OwnerPanel, self.CurrentText, OldNumberValue)
  end
end

function M:EditOnTextFocusReceived()
end

function M:EditOnTextFocusLost()
end

function M:OnEditTextCursorMoved(LineIdx, Offset)
  if self.bHasNewText then
    self.bHasNewText = false
    local OldText = self.CurrentText
    self.CurrentText = self.NewText
    self:SetCursorPosition(LineIdx, Offset)
    self.CursorLineIdx = LineIdx
    self.CursorOffset = Offset
    return
  end
  self.CursorLineIdx = LineIdx
  self.CursorOffset = Offset
end

function M:SetCursorPosition(LineIdx, Offset)
  if self.Text_Input then
    self.Text_Input:CursorGoto(LineIdx, Offset)
  end
end

function M:SetText(Text)
  if self.Text_Input then
    self.Text_Input:SetText(Text)
    self.CurrentText = Text
    if not UIUtils.IsGamepadInput() then
      self.Text_Input:SetKeyboardFocus()
      self.CursorOffset = string.len(Text)
      self:SetCursorPosition(0, self.CursorOffset)
    end
  end
end

function M:GetText()
  if self.Text_Input then
    return self.Text_Input:GetText()
  end
  return ""
end

function M:InsertTextAtCursor(InStr)
  if not self.Text_Input then
    return
  end
  local Position = self.CursorOffset
  local SelfStr = self.Text_Input:GetText()
  local Len = string.len(SelfStr)
  if Len + string.len(InStr) > self.TextLimit then
    if not self.bIsLimitTipShowing then
      self.OwnerPanel:ShowTip("UI_Number_MaxNumber", false)
      self.bIsLimitTipShowing = true
    end
    if not UIUtils.IsGamepadInput() then
      self.Text_Input:SetKeyboardFocus()
      self:SetCursorPosition(0, Position)
    end
    return
  else
  end
  if Position > Len then
    Position = Len
  end
  local LeftStr = string.sub(SelfStr, 1, Position)
  local RightStr = string.sub(SelfStr, Position + 1)
  local NewText = LeftStr .. InStr .. RightStr
  self.Text_Input:SetText(NewText)
  self.CurrentText = NewText
  local NewCursorPos = Position + string.len(InStr)
  self.CursorOffset = NewCursorPos
  if not UIUtils.IsGamepadInput() then
    self.Text_Input:SetKeyboardFocus()
    self:SetCursorPosition(0, NewCursorPos)
  end
end

function M:DeleteTextBack()
  if not self.Text_Input then
    return
  end
  local Position = self.CursorOffset
  local SelfStr = self.Text_Input:GetText()
  if Position <= 0 or "" == SelfStr then
    if not UIUtils.IsGamepadInput() then
      self.Text_Input:SetKeyboardFocus()
      self:SetCursorPosition(0, Position)
    end
    return
  end
  local LeftStr = string.sub(SelfStr, 1, Position - 1)
  local RightStr = string.sub(SelfStr, Position + 1)
  local NewText = LeftStr .. RightStr
  self.Text_Input:SetText(NewText)
  self.CurrentText = NewText
  local NewCursorPos = Position - 1
  self.CursorOffset = NewCursorPos
  if not UIUtils.IsGamepadInput() then
    self.Text_Input:SetKeyboardFocus()
    self:SetCursorPosition(0, NewCursorPos)
  end
end

return M
