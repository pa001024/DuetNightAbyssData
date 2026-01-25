require("UnLua")
local FSM = require("Blueprints.UI.FocusStateMachine")
local FocusAreas = {
  SkinList = "SkinList",
  AccessoryList = "AccessoryList",
  AccessoryTab = "AccessoryTab",
  HiddenSelf = "HiddenSelf",
  Resource = "Resource"
}
local M = Class("BluePrints.UI.WBP.Armory.WBP_Armory_Skin_Base_C")
M._components = {
  "BluePrints.UI.KeyInputComponent"
}

function M:Construct()
  rawset(self, "TabStyleName", "Text")
  rawset(self, "EscapeKey", EKeys.Escape.KeyName)
  rawset(self, "ZoomKey", "Mouse_Button")
  self.ESCKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = self.EscapeKey,
        ClickCallback = self.OnBackKeyDown,
        Owner = self
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        ClickCallback = self.OnBackKeyDown,
        Owner = self
      }
    },
    Desc = GText("UI_BACK")
  }
  self.HideUI_KeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText("U"),
        ClickCallback = self.OnHideUIKeyDown,
        Owner = self
      }
    },
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    },
    Desc = GText("UI_Dye_HideUI")
  }
  self.ZoomKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = self.ZoomKey,
        Owner = self
      }
    },
    GamePadInfoList = {
      {Type = "Or"},
      GamePadSubKeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "LT",
          Owner = self
        },
        {
          Type = "Img",
          ImgShortPath = "RT",
          Owner = self
        }
      }
    },
    Desc = GText("UI_Dye_Zoom"),
    bLongPress = false
  }
  self.RightThumbstickAnalogBottomKeyInfoList = {
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "RH"}
    },
    Desc = GText("UI_CTL_RotatePreview")
  }
  self.Btn_Function:SetDefaultGamePadImg("A")
  self.Key_Check:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    },
    Desc = GText("UI_Controller_Check")
  })
  self.Key_Dye:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  M.Super.Construct(self)
  
  function self.TabConfig.GetReplyOnBack()
    self.FSM:Pop()
    return self:GetReplyOnBack()
  end
  
  self.TabConfig.OnResourceBarAddedToFocusPath = self.OnResourceBarAddedToFocusPath
  self.TabConfig.OnResourceBarRemovedFromFocusPath = self.OnResourceBarRemovedFromFocusPath
  rawset(self, "FSM", FSM:New(self, {
    StateNames = FocusAreas,
    OnStateChanged = self.OnFocusStateChanged,
    CheckFunction = self.IsFocusStateValid
  }))
  self.WBP_Com_Cost:SwitchToPC()
end

function M:InitUIInfo(...)
  M.Super.InitUIInfo(self, ...)
end

function M:OnInited()
  M.Super.OnInited(self)
  rawset(self, "Inited", true)
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:UpdateKeySetting()
  self:ClearAllKeyEvents()
  self.BottomKeyInfo = {}
  if self.IsGamepadInput then
    local StateName = self.FSM:Peak().Name
    if StateName == FocusAreas.Resource then
      self:AddKeyDownEvent(Const.GamepadFaceButtonRight, self.OnBackKeyDown)
      table.insert(self.BottomKeyInfo, self.ESCKeyInfoList)
    else
      self.RepeatKeyDownEvents = {}
      self.RepeatKeyDownEvents[Const.GamepadLeftTrigger] = self.OnCameraScrollBackwardKeyDown
      self.RepeatKeyDownEvents[Const.GamepadRightTrigger] = self.OnCameraScrollForwardKeyDown
      self:AddKeyDownEvent(Const.GamepadRightThumbstick, self.OnFocusToResourceKeyDown)
      self:AddKeyDownEvent(Const.GamepadSpecialLeft, self.OnOpenVideoKeyDown)
      self:AddKeyDownEvent(Const.GamepadFaceButtonRight, self.OnBackKeyDown)
      self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonLeft, self.OnHideUIKeyDown)
      self:AddKeyDownEvent(Const.GamepadLeftShoulder, self.OnTabLeftKeyDown)
      self:AddKeyDownEvent(Const.GamepadRightShoulder, self.OnTabRightKeyDown)
      if not self.bSelfHidden and self.CurrentTopTabIdx == self.SkinTabIdx and not self.IsPreviewMode and not self.IsCharacterTrialMode then
        self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonTop, self.OnGamePadGotoDyeKeyDown)
      end
      table.insert(self.BottomKeyInfo, self.HideUI_KeyInfoList)
      table.insert(self.BottomKeyInfo, self.ZoomKeyInfoList)
      table.insert(self.BottomKeyInfo, self.RightThumbstickAnalogBottomKeyInfoList)
      table.insert(self.BottomKeyInfo, self.ESCKeyInfoList)
    end
  else
    self:AddKeyDownEvent(self.EscapeKey, self.OnBackKeyDown)
    self:AddKeyDownEvent(EKeys.U.KeyName, self.OnHideUIKeyDown)
    self:AddKeyDownEvent(EKeys.Q.KeyName, self.OnTabLeftKeyDown)
    self:AddKeyDownEvent(EKeys.E.KeyName, self.OnTabRightKeyDown)
    table.insert(self.BottomKeyInfo, self.HideUI_KeyInfoList)
    table.insert(self.BottomKeyInfo, self.ZoomKeyInfoList)
    table.insert(self.BottomKeyInfo, self.RightThumbstickAnalogBottomKeyInfoList)
    table.insert(self.BottomKeyInfo, self.ESCKeyInfoList)
  end
  self.Tab_Skin:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function M:OnFocusToResourceKeyDown()
  self.Tab_Skin:Handle_KeyEventOnGamePad(Const.GamepadRightThumbstick)
  return UIUtils.Handled, true
end

function M:OnOpenVideoKeyDown()
  self:OpenSkinVideo()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputDevice, CurGamepadName)
  if not rawget(self, "Inited") then
    return
  end
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamepadInput then
    self.GamePad_Check:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Panel_Key_Dye:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if not self.IsInFocusPath then
      return
    end
    local State = self.FSM:Peak()
    if not self:IsFocusStateValid(State) then
      self.FSM:Clear()
    end
    local Widget = self:GetDesiredFocusTarget()
    if Widget and not UIUtils.HasAnyFocus(Widget) then
      Widget:SetFocus()
    end
  else
    self.Panel_Key_Dye:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.GamePad_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:UpdateKeySetting()
end

function M:OnFocusStateChanged()
  self:UpdateKeySetting()
end

function M:IsFocusStateValid(State)
  local StateName = State.Name
  if StateName == FocusAreas.SkinList then
    return self.List_Skin:GetIndexForItem(State.Content) >= 0
  elseif StateName == FocusAreas.AccessoryTab then
    local CurrentTab = self.AccessoryTabsArray and self.AccessoryTabsArray[self.CurrentAccessoryTabIdx]
    return CurrentTab and CurrentTab == State.Content
  elseif StateName == FocusAreas.AccessoryList then
    return self.List_Accessory:GetIndexForItem(State.Content) >= 0
  elseif StateName == FocusAreas.HiddenSelf then
    return self.bSelfHidden
  end
end

function M:GetDesiredFocusTarget()
  local State = self.FSM:Peak()
  local StateName = State.Name
  if self.bSelfHidden then
    return self
  elseif self.CurrentTopTabIdx == self.SkinTabIdx then
    return self:NavigateToSkinList()
  elseif StateName == FocusAreas.AccessoryTab then
    return self:NavigateToAccessoryTab()
  else
    return self:NavigateToAccessoryList()
  end
end

function M:OnSkinContentCreated(Content)
  Content.OnAddedToFocusPath = self.OnSkinItemAddedToFocusPath
  Content.OnRemovedFromFocusPath = self.OnSkinItemRemovedFromFocusPath
end

function M:OnSkinItemAddedToFocusPath(Content)
  self.FSM:Clear()
  self.FSM:Push({
    Name = FocusAreas.SkinList,
    Content = Content
  })
  if self.IsGamepadInput then
    self:SelectSkinByContent(Content)
  end
end

function M:OnSkinItemRemovedFromFocusPath(Content)
end

function M:OnResourceBarAddedToFocusPath(Widget)
  self.FSM:Push({
    Name = FocusAreas.Resource,
    Widget = Widget
  })
end

function M:OnResourceBarRemovedFromFocusPath(Widget)
end

function M:NavigateToSkinList(Content)
  local Content = Content or self.SkinMap[self.SelectedSkinId]
  if not Content or self.List_Skin:GetIndexForItem(Content) < 0 then
    Content = self.List_Skin:GetItemAt(0)
  end
  self.List_Skin:BP_CancelScrollIntoView()
  self.List_Skin:BP_SetSelectedItem(Content)
  self.List_Skin:BP_NavigateToItem(Content)
  if Content and Content.Widget then
    return Content.Widget
  end
  return self.List_Skin
end

function M:NavigateToAccessoryTab()
  local CurrentTab = self.AccessoryTabsArray and self.AccessoryTabsArray[self.CurrentAccessoryTabIdx]
  return CurrentTab and CurrentTab.UI
end

function M:NavigateToAccessoryList()
  local Content = self.ComparedContent or self.CurrentContent
  if not Content or self.List_Accessory:GetIndexForItem(Content) < 0 then
    Content = self.List_Accessory:GetItemAt(0)
  end
  self.List_Accessory:BP_CancelScrollIntoView()
  self.List_Accessory:BP_SetSelectedItem(Content)
  self.List_Accessory:BP_NavigateToItem(Content)
  if Content and Content.SelfWidget then
    return Content.SelfWidget
  end
  return self.List_Accessory
end

function M:OnAccessoryContentCreated(Content)
  Content.OnAddedToFocusPathEvent = {
    Obj = self,
    Callback = function()
      self.FSM:Clear()
      self.FSM:Push({
        Name = FocusAreas.AccessoryList,
        Content = Content
      })
    end
  }
  Content.OnRemovedFromFocusPathEvent = {
    Obj = self,
    Callback = function()
    end
  }
end

function M:OnAccessoryTabContentCreated(Content, Widget)
  function Content.OnAddedToFocusPath()
    self.FSM:Clear()
    
    self.FSM:Push({
      Name = FocusAreas.AccessoryTab,
      Content = Content,
      Widget = Widget
    })
  end
  
  function Content.OnRemovedFromFocusPath()
  end
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
end

function M:InitAccessoryNavigationRules()
  self.Tab_Accessory:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Tab_Accessory:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Tab_Accessory:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Accessory:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Accessory:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Accessory:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  if self.Tab_Accessory:IsVisible() then
    self.Tab_Accessory:SetNavigationRuleCustom(EUINavigation.Right, {
      self,
      function()
        return self:NavigateToAccessoryList()
      end
    })
    self.List_Accessory:SetNavigationRuleCustom(EUINavigation.Left, {
      self,
      function()
        return self:NavigateToAccessoryTab()
      end
    })
  end
end

function M:OnAccessoryListSelectionChanged(Content, IsSelected)
  if not IsSelected or not self.IsGamepadInput then
    return
  end
  self:TrySelectAccessoryItem(Content)
end

function M:OnAccessoryItemClicked(Content)
  if self.IsGamepadInput then
    self:OnGamePadConfirKeyDown()
  else
    M.Super.OnAccessoryItemClicked(self, Content)
  end
end

function M:OnSkinListSelectionChanged(Content, IsSelected)
  if self.IsGamepadInput then
    M.Super.OnSkinItemClicked(self, Content)
  end
end

function M:OnSkinItemClicked(Content)
  if self.IsGamepadInput then
    self:OnGamePadConfirKeyDown()
  else
    M.Super.OnSkinItemClicked(self, Content)
  end
end

function M:OnGamePadConfirKeyDown()
  if self.IsPreviewMode or self.IsCharacterTrialMode then
    return UIUtils.Handled, true
  end
  if self.Btn_Function:IsVisible() and not self.Btn_Function:IsBtnForbidden() and 0 == self.WidgetSwitcher_BtnState:GetActiveWidgetIndex() and self.ConfirmBtnFunc then
    self.ConfirmBtnFunc(self)
  end
  return UIUtils.Handled, true
end

function M:OnGamePadGotoDyeKeyDown()
  if self.IsPreviewMode or self.IsCharacterTrialMode or self.IsTargetUnowned then
    return UIUtils.Handled, true
  end
  local Content = self.SkinMap[self.SelectedSkinId]
  if not Content then
    return UIUtils.Handled, true
  end
  if Content.bDyeable and not Content.LockType then
    self:OpenDye()
  end
  return UIUtils.Handled, true
end

function M:OnCameraScrollBackwardKeyDown()
  self:ScrollCamera(1)
end

function M:OnCameraScrollForwardKeyDown()
  self:ScrollCamera(-1)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonDown then
    self:OnGamePadConfirKeyDown()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local RepeatKeyDownEvent = self.RepeatKeyDownEvents[InKeyName]
  if RepeatKeyDownEvent then
    local Reply, IsHandled = RepeatKeyDownEvent(self)
    if IsHandled then
      return Reply
    end
  end
  return UIUtils.Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Reply = M.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
  if not self.IsGamepadInput then
    return UIUtils.Handled
  end
  local Widget = self:GetDesiredFocusTarget()
  if Widget == self then
    self:OnFocusStateChanged()
    return UIUtils.Handled
  end
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), Widget)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightX" == InKeyName then
    if self.ActorController then
      local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
      self.ActorController:OnDragging({X = DeltaX})
    end
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnTabLeftKeyDown()
  self.Tab_Skin:TabToLeft()
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget()), true
end

function M:OnTabRightKeyDown()
  self.Tab_Skin:TabToRight()
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget()), true
end

function M:OnHideUIKeyDown()
  M.Super.OnHideUIKeyDown(self)
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget()), true
end

function M:GetReplyOnBack()
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget()), true
end

function M:OnBackKeyDown()
  M.Super.OnBackKeyDown(self)
end

AssembleComponents(M)
return M
