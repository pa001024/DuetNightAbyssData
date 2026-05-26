require("UnLua")
local FSM = require("Blueprints.UI.FocusStateMachine")
local M = Class("BluePrints.UI.WBP.Armory.WBP_Armory_IncarnonDetail_Base_C")
local FocusStates = {Incarnon = "Incarnon", StuffItem = "StuffItem"}

function M:Initialize(Initializer)
  rawset(self, "FSM", FSM:New(self, {
    StateNames = FocusStates,
    OnStateChanged = self.OnFocusChanged,
    CheckFunction = self.IsFocusStateValid
  }))
end

function M:Construct()
  self.Super.Construct(self)
  self:InitGamepadTips()
  self.Btn_Unlock:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonTop)
  self.Btn_Unlock_Free:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonTop)
  self.Key_Consume:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
  self.Key_Qa:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
  self:SwitchGamepadKeyState(FocusStates.Incarnon)
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:InitGamepadTips()
  local BackInfo = {
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("UI_BACK")
  }
  local ConformInfo = {
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    },
    Desc = GText("UI_Controller_Check")
  }
  self.GamepadWidgets = {}
  self.HB_Key_GamePad:ClearChildren()
  for _, Info in pairs({ConformInfo, BackInfo}) do
    local Item = self:CreateWidgetNew("ComKeyTextDesc")
    Item:CreateCommonKey(Info)
    self.HB_Key_GamePad:AddChild(Item)
    local KeyName = Info.KeyInfoList[1].ImgShortPath
    self.GamepadWidgets[KeyName] = Item
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  M.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
  if self.IsGamepadInput and self.IsInFocusPath and not self:IsFocusStateWidgetHasAnyFocus(self.FSM:Peak()) then
    local Widget = self:GetDesiredFocusTarget()
    if Widget then
      Widget:SetFocus()
    end
  end
  self:RefreshGamepadUIVisibility()
end

function M:RefreshGamepadUIVisibility()
  local Visible = UIConst.VisibilityOp.SelfHitTestInvisible
  local Collapsed = UIConst.VisibilityOp.Collapsed
  local Visibility = self.IsGamepadInput and Visible or Collapsed
  self.Panel_GamePad:SetVisibility(Visibility)
  self:RefreshConsumeVisibility()
  if self.Panel_FreeHint:IsVisible() then
    self.Key_Qa:SetVisibility(Visibility)
  end
  self.Btn_Unlock_Free.Img_GamePad:SetVisibility(Visibility)
end

function M:RefreshConsumeVisibility()
  if not self.HB_Consume:IsVisible() then
    return
  end
  local Visible = UIConst.VisibilityOp.SelfHitTestInvisible
  local Collapsed = UIConst.VisibilityOp.Collapsed
  local State = self.FSM:Peak()
  local StateName = State.Name
  if StateName == FocusStates.StuffItem then
    self.Key_Consume:SetVisibility(Collapsed)
  else
    local Visibility = self.IsGamepadInput and Visible or Collapsed
    self.Key_Consume:SetVisibility(Visibility)
  end
end

function M:IsFocusStateValid(State)
  return true
end

function M:OnFocusChanged(NewState, OldState, Operation)
end

function M:IsFocusStateWidgetHasAnyFocus(State)
  local StateName = State.Name
  if StateName == FocusStates.StuffItem then
    return UIUtils.HasAnyFocus(self.HB_Item)
  elseif StateName == FocusStates.Incarnon then
    return UIUtils.HasAnyFocus(self.Armory_Incarnon)
  end
end

function M:GetDesiredFocusTarget()
  local State = self.FSM:Peak()
  local StateName = State.Name
  if StateName == FocusStates.StuffItem then
    if not self.HB_Item:IsVisible() then
      self.FSM:Pop()
      return self.Armory_Incarnon
    end
    if State.Content and State.Content.SelfWidget then
      return State.Content.SelfWidget
    else
      return self.HB_Item:GetChildAt(0)
    end
  elseif StateName == FocusStates.Incarnon then
    return self.Armory_Incarnon
  else
    return self.Armory_Incarnon
  end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self.Com_BtnQa:OnViewInfoClick(false)
    local Widget = self:GetDesiredFocusTarget()
    if Widget then
      Widget:SetFocus()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
  else
    IsEventHandled = self:Handle_OnPCDown(InKeyName)
  end
  if not IsEventHandled then
    self.Armory_Incarnon:OnParentKeyDown(MyGeometry, InKeyEvent)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:Handle_OnPCDown(InKeyName)
  if "Escape" == InKeyName then
    self:OnBackgroundClicked()
    return true
  end
  return false
end

function M:Handle_OnGamePadDown(InKeyName)
  local StateName = self.FSM:Peak().Name
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if StateName == FocusStates.StuffItem then
      self.FSM:Pop()
      local Widget = self:GetDesiredFocusTarget()
      Widget:SetFocus()
    else
      local Free_Hint = self.Panel_FreeHint
      if Free_Hint:IsVisible() and self.Com_BtnQa:IsChecked() then
        self.Com_BtnQa:OnViewInfoClick(false)
      else
        self:OnBackgroundClicked()
      end
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self:CanClickActivationButton() then
      local Button = self.WS_Btn:GetActiveWidget()
      if Button then
        Button:OnBtnClicked()
      end
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftThumb then
    if self.HB_Item:IsVisible() and StateName ~= FocusStates.StuffItem then
      local Item = self.HB_Item:GetChildAt(0)
      Item:SetFocus()
      self:RefreshConsumeVisibility()
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.SpecialRight then
    if self.Panel_FreeHint:IsVisible() then
      self.Com_BtnQa:OnViewInfoClick(true)
    end
    return true
  end
  return false
end

function M:SwitchGamepadKeyState(State)
  local Visible = UIConst.VisibilityOp.SelfHitTestInvisible
  local Hidden = UIConst.VisibilityOp.Hidden
  if State == FocusStates.StuffItem then
    self.GamepadWidgets.A:SetVisibility(Visible)
    self.GamepadWidgets.B:SetVisibility(Visible)
  elseif State == FocusStates.Incarnon then
    self.GamepadWidgets.A:SetVisibility(Hidden)
    self.GamepadWidgets.B:SetVisibility(Visible)
  else
    self.GamepadWidgets.A:SetVisibility(Hidden)
    self.GamepadWidgets.B:SetVisibility(Hidden)
  end
end

function M:CanClickActivationButton()
  if not self.Panel_Unlock:IsVisible() then
    return
  end
  local ActiveWidgetIndex = self.WS_Btn:GetActiveWidgetIndex()
  return ActiveWidgetIndex < 2
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Widget = self:GetDesiredFocusTarget()
  if not Widget then
    return UIUtils.Handled
  end
  if self.IsAnimationPlaying then
    self:BlockAllUIInput(true)
    self:AddTimer(2, function()
      Widget:SetFocus()
      self:BlockAllUIInput(false)
      self.IsAnimationPlaying = false
    end)
  else
    Widget:SetFocus()
  end
  return UIUtils.Handled
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
end

function M:OnIncarnonPageAddtoFocusPath(Content)
  local StateName = self.FSM:Peak().Name
  if StateName ~= FocusStates.Incarnon then
    self.FSM:Pop()
  end
  self.FSM:Push({
    Name = FocusStates.Incarnon,
    Content = Content
  })
  self:RefreshConsumeVisibility()
end

function M:OnIncarnonPageRemovedFromFocusPath()
end

function M:OnStuffItemMenuOpenChanged(bIsOpen, Content)
  if not self.IsGamepadInput then
    return
  end
  if bIsOpen then
    self:SwitchGamepadKeyState()
  else
    self:SwitchGamepadKeyState(FocusStates.StuffItem)
  end
end

function M:OnStuffItemAddToFocusPath(Content)
  local StateName = self.FSM:Peak().Name
  if StateName == FocusStates.StuffItem then
    self.FSM:Pop()
  end
  self.FSM:Push({
    Name = FocusStates.StuffItem,
    Content = Content
  })
  self:SwitchGamepadKeyState(FocusStates.StuffItem)
end

function M:OnStuffItemRemovedFromFocusPath(Content)
  self:SwitchGamepadKeyState(FocusStates.Incarnon)
end

function M:OnLevelWidgetAddToFocusPath(LevelWidgetBtn)
  if self.IsGamepadInput then
    local CardWidget = LevelWidgetBtn.Parent
    CardWidget:PlaySelectedAnimation()
    self:OnCardLevelClicked(CardWidget, CardWidget.CardLevel)
    self:RefreshGamepadUIVisibility()
  end
end

function M:OnTalentWidgetAddToFocusPath(TalentWidget)
  if self.IsGamepadInput then
    TalentWidget:PlaySelectedAnimation()
    self:OnTalentPointClicked(TalentWidget, TalentWidget.TalentId)
    self:RefreshGamepadUIVisibility()
  end
end

return M
