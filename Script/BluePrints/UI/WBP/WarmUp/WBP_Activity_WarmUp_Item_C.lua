require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:AddTimer(0.1, function()
      self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end)
  end
  self.IsFocused = false
  self.Key_Item:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
  self.Key_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self.CurGamepadName = CurGamepadName
  self:UpdateUIByInputDevice(self.CurInputDeviceType)
end

function M:UpdateUIByInputDevice(CurInputDeviceType)
  if CurInputDeviceType ~= ECommonInputType.Gamepad and self.IsFocused then
    self:PlayAnimation(self.UnHover)
    self.Key_Item:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  self.IsFocused = true
  self:PlayAnimation(self.Hover)
  self.Key_Item:SetVisibility(UE4.ESlateVisibility.Visible)
  return self
end

function M:OnFocusLost(InFocusEvent)
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  self.IsFocused = false
  self:PlayAnimation(self.UnHover)
  self.Key_Item:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:SetDateText(Index)
  local DateTemplate = GText("UI_Event_DailyLogin_Date")
  local Prefix, Number, Suffix = self:SplitDateText(DateTemplate, Index)
  self.Text_Title01:SetText(Prefix)
  self.Text_LvNum:SetText(Number)
  self.Text_Title02:SetText(Suffix)
end

function M:SplitDateText(Template, Index)
  local IndexStr = tostring(Index)
  local PercentSIndex = string.find(Template, "%%s")
  if not PercentSIndex then
    return Template, IndexStr, ""
  end
  local Prefix = string.sub(Template, 1, PercentSIndex - 1)
  local Suffix = string.sub(Template, PercentSIndex + 2)
  return Prefix, IndexStr, Suffix
end

return M
