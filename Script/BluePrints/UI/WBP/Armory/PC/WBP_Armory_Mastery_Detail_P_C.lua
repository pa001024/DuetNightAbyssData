require("UnLua")
local M = Class("BluePrints.UI.WBP.Armory.WBP_Armory_Mastery_Detail_Base_C")
M._components = {
  "BluePrints.UI.KeyInputComponent"
}

function M:Construct()
  self:AddKeyDownEvent(EKeys.Escape.KeyName, self.OnBackKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonRight, self.OnBackKeyDown)
  M.Super.Construct(self)
  self.Key_Back:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("UI_BACK")
  })
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:RefreshOpInfoByInputDevice(InputType, GamepadName)
  if InputType == ECommonInputType.Gamepad then
    self.Panel_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Panel_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Armory_Mastery:RefreshOpInfoByInputDevice(InputType, GamepadName)
  self.Armory_MasteryWindow:RefreshOpInfoByInputDevice(InputType, GamepadName)
  if not self.IsInFocusPath then
    return
  end
  self:SetFocus()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.Armory_MasteryWindow)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if self.Armory_Mastery.OnParentKeyDown then
    local Reply, IsHandled = self.Armory_Mastery:OnParentKeyDown(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  if self.Armory_Mastery.OnParentKeyUp then
    local Reply, IsHandled = self.Armory_Mastery:OnParentKeyUp(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local Reply, IsHandled = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnBackKeyDown()
  self:OnCloseBtnClicked()
end

function M:OnAddedToFocusPath(InFocusEvent)
  self.IsInFocusPath = true
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
end

AssembleComponents(M)
return M
