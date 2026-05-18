local Component = {}
local StateNames = {
  PC = "PC",
  Preview = "Preview",
  ImportWindow = "ImportWindow"
}
local AnalogDeadZone = 0.25
local AnalogScrollScale = 12

function Component:Construct()
  self.ImportInputStateType = nil
  self.IsGamepadInput = UIUtils.IsGamepadInput and UIUtils.IsGamepadInput() or false
  self.CurrentPlanFocusIndex = 1
end

function Component:InitImportGamepadWidgets()
  self.ImportWindow:InitImportWindowGamepadWidgets()
  self:UpdateImportInputState(self.IsGamepadInput and StateNames.Preview or StateNames.PC)
end

function Component:OnImportInputTypeChanged(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamepadInput then
    self:UpdateImportInputState(self:IsImportWindowOpen() and StateNames.ImportWindow or StateNames.Preview)
  else
    self:UpdateImportInputState(StateNames.PC)
  end
  self:RefreshImportBottomKeyInfo()
  self:RefreshImportWindowGamepadVisible()
end

function Component:UpdateImportInputState(StateType)
  if self.ImportInputStateType == StateType then
    return
  end
  self.ImportInputStateType = StateType
  self:RefreshImportBottomKeyInfo()
  self:RefreshImportGamepadFocus()
  self:RefreshImportWindowGamepadVisible()
end

function Component:OnImportWindowOpenedByGamepad()
  self.CurrentPlanFocusIndex = self:GetSelectedPlanIndex()
  self:UpdateImportInputState(StateNames.ImportWindow)
  self:AddTimer(0, function()
    self:FocusCurrentPlanItem()
  end)
end

function Component:OnImportWindowClosedByGamepad()
  self:UpdateImportInputState(self.IsGamepadInput and StateNames.Preview or StateNames.PC)
end

function Component:RefreshImportWindowGamepadVisible()
  self.ImportWindow:RefreshImportWindowGamepadVisible(self.IsGamepadInput and self:IsImportWindowOpen(), self.ImportInputStateType)
end

function Component:GetSelectedPlanIndex()
  return self.Model:GetSelectedTargetPlanIndex() or 1
end

function Component:GetPlanWidget(Index)
  local Widgets = self.ImportWindow:GetPlanItemWidgets()
  return Widgets[Index]
end

function Component:GetVisiblePlanCount()
  local Count = 0
  for _, Widget in ipairs(self.ImportWindow:GetPlanItemWidgets()) do
    if Widget:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
      Count = Count + 1
    end
  end
  return Count
end

function Component:FocusCurrentPlanItem()
  local Count = self:GetVisiblePlanCount()
  if Count <= 0 then
    return false
  end
  self.CurrentPlanFocusIndex = math.max(1, math.min(self.CurrentPlanFocusIndex or 1, Count))
  local Widget = self:GetPlanWidget(self.CurrentPlanFocusIndex)
  Widget:SetKeyboardFocus()
  Widget.Com_List:SetFocus()
  return true
end

function Component:MovePlanFocus(Delta)
  local Count = self:GetVisiblePlanCount()
  if Count <= 0 then
    return false
  end
  self.CurrentPlanFocusIndex = self.CurrentPlanFocusIndex or self:GetSelectedPlanIndex()
  self.CurrentPlanFocusIndex = math.max(1, math.min(self.CurrentPlanFocusIndex + Delta, Count))
  return self:FocusCurrentPlanItem()
end

function Component:SelectCurrentPlan()
  local Widget = self:GetPlanWidget(self.CurrentPlanFocusIndex or self:GetSelectedPlanIndex())
  local Key = Widget.PlanItemKey
  self.ImportWindow:OnPlanItemClicked(Widget, Key)
  return true
end

function Component:OpenImportWindowByGamepad()
  if self:IsImportWindowOpen() then
    return true
  end
  self:OpenImportWindow()
  if self:IsImportWindowOpen() then
    return true
  end
  return false
end

function Component:CloseImportWindowByGamepad()
  if not self:IsImportWindowOpen() then
    return false
  end
  self:CloseImportWindow()
  return true
end

function Component:ConfirmImportByGamepad()
  self:OnImportClicked()
  return true
end

function Component:RefreshImportGamepadFocus()
  if not self.IsGamepadInput then
    return
  end
  if self.bSelfHidden then
    if self.IMG_Click then
      self.IMG_Click:SetFocus()
    end
    return
  end
  if self.ImportInputStateType == StateNames.ImportWindow then
    if not self:HasWidgetFocus(self) and not self:HasWidgetFocus(self.ImportWindow) then
      return
    end
    self:FocusCurrentPlanItem()
    return
  end
  self:SetFocus()
end

function Component:GetPreviewBottomKeyInfo()
  local KeyInfo = {}
  table.insert(KeyInfo, self.HideUIKeyInfoList)
  table.insert(KeyInfo, self.ZoomKeyInfoList)
  table.insert(KeyInfo, {
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "RH",
        Owner = self
      }
    },
    Desc = GText("UI_CTL_RotatePreview")
  })
  table.insert(KeyInfo, self.ESCKeyInfoList)
  return KeyInfo
end

function Component:GetImportWindowBottomKeyInfo()
  return {
    self:CreateBottomKey("A", GText("UI_Tips_Ensure"), self.SelectCurrentPlan),
    self:CreateBottomKey("Y", GText("UI_AppearanceScore_Import"), self.ConfirmImportByGamepad),
    self:CreateBottomKey("B", GText("UI_BACK"), self.CloseImportWindowByGamepad)
  }
end

function Component:RefreshImportBottomKeyInfo()
  if not (self.IsPC and self.Com_Tab) or not self.Com_Tab.UpdateBottomKeyInfo then
    return
  end
  if not self.IsGamepadInput then
    self.Com_Tab:UpdateBottomKeyInfo(self.BottomKeyInfoList or {})
    return
  end
  if self.ImportInputStateType == StateNames.ImportWindow then
    self.Com_Tab:UpdateBottomKeyInfo(self:GetImportWindowBottomKeyInfo())
  else
    self.Com_Tab:UpdateBottomKeyInfo(self:GetPreviewBottomKeyInfo())
  end
end

function Component:ScrollPreviewAppearanceList(Delta)
  if not IsValid(self.List_Appearance) then
    return false
  end
  local ScrollTarget = self.List_Appearance
  if IsValid(self.List_Appearance.EMScrollBox) then
    ScrollTarget = self.List_Appearance.EMScrollBox
  end
  if ScrollTarget.ScrollWheel then
    ScrollTarget:ScrollWheel(Delta)
    return true
  end
  if ScrollTarget.SetScrollOffset and ScrollTarget.GetScrollOffset then
    ScrollTarget:SetScrollOffset(ScrollTarget:GetScrollOffset() + Delta)
    return true
  end
  if ScrollTarget.ScrollToStart and Delta < 0 then
    ScrollTarget:ScrollToStart()
    return true
  end
  if ScrollTarget.ScrollToEnd and Delta > 0 then
    ScrollTarget:ScrollToEnd()
    return true
  end
  return false
end

function Component:ScrollCamera(DeltaMove)
  if self.ActorController then
    self.ActorController:OnScrolling(DeltaMove)
  end
end

function Component:HandleImportTriggerAnalogInput(InKeyName, InAnalogInputEvent)
  if not InAnalogInputEvent then
    return false
  end
  local AnalogValue = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  if not AnalogValue or math.abs(AnalogValue) <= 0.1 then
    return false
  end
  if self:IsImportWindowOpen() then
    return false
  end
  if InKeyName == UIConst.GamePadKey.LeftTriggerAnalog then
    self:ScrollCamera(AnalogValue)
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightTriggerAnalog then
    self:ScrollCamera(-AnalogValue)
    return true
  end
  return false
end

function Component:HandleImportGamepadInput(InKeyName, InAnalogInputEvent)
  if self.bSelfHidden then
    if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      self:OnHideUIKeyDown()
      return true
    end
    return false
  end
  if self.ImportInputStateType == StateNames.ImportWindow then
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      self:SelectCurrentPlan()
      return true
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonTop then
      self:ConfirmImportByGamepad()
      return true
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:CloseImportWindowByGamepad()
      return true
    end
    if InKeyName == UIConst.GamePadKey.LeftStickUp then
      return self:MovePlanFocus(-1)
    end
    if InKeyName == UIConst.GamePadKey.LeftStickDown then
      return self:MovePlanFocus(1)
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OpenImportWindowByGamepad()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self:OnHideUIKeyDown()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnBackKeyDown()
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold then
    self:ScrollCamera(1)
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
    self:ScrollCamera(-1)
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightStickUp then
    return self:ScrollPreviewAppearanceList(-AnalogScrollScale)
  end
  if InKeyName == UIConst.GamePadKey.RightStickDown then
    return self:ScrollPreviewAppearanceList(AnalogScrollScale)
  end
  if InKeyName == UIConst.GamePadKey.RightStickLeft and self.ActorController then
    self.ActorController:OnDragViewActor({X = -10})
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightStickRight and self.ActorController then
    self.ActorController:OnDragViewActor({X = 10})
    return true
  end
  if self:HandleImportTriggerAnalogInput(InKeyName, InAnalogInputEvent) then
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightAnalogX and InAnalogInputEvent and self.ActorController then
    local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    if math.abs(DeltaX) > AnalogDeadZone then
      self.ActorController:OnDragViewActor({
        X = DeltaX * 10
      })
      return true
    end
  end
  if InKeyName == UIConst.GamePadKey.RightAnalogY and InAnalogInputEvent then
    local DeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    if math.abs(DeltaY) > AnalogDeadZone then
      return self:ScrollPreviewAppearanceList(-DeltaY * AnalogScrollScale)
    end
  end
  return false
end

function Component:HandleImportKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == EKeys.U.KeyName then
    return self:OnHideUIKeyDown()
  end
  if InKeyName == EKeys.Escape.KeyName then
    return self:OnBackKeyDown()
  end
  if self:HandleImportGamepadInput(InKeyName) then
    return UIUtils.Handled, true
  end
  return UIUtils.Unhandled, false
end

function Component:HandleImportRepeatKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:HandleImportGamepadInput(InKeyName) then
    return UIUtils.Handled, true
  end
  return UIUtils.Unhandled, false
end

function Component:HandleImportAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:HandleImportGamepadInput(InKeyName, InAnalogInputEvent) then
    return UIUtils.Handled, true
  end
  return UIUtils.Unhandled, false
end

function Component:HandleImportFocusReceived(MyGeometry, InFocusEvent)
  self:RefreshImportGamepadFocus()
  return UIUtils.Handled
end

function Component:CreateBottomKey(ImgShortPath, Desc, ClickCallback)
  return {
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = ImgShortPath,
        Owner = self,
        ClickCallback = ClickCallback
      }
    },
    Desc = Desc,
    bLongPress = false
  }
end

function Component:HasWidgetFocus(Widget)
  if Widget.HasAnyFocus and Widget:HasAnyFocus() then
    return true
  end
  if Widget.HasAnyUserFocus and Widget:HasAnyUserFocus() then
    return true
  end
  if Widget.HasFocusedDescendants and Widget:HasFocusedDescendants() then
    return true
  end
  return false
end

return Component
