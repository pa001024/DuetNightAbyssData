require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local FSM = require("Blueprints.UI.FocusStateMachine")
local Handled = UE4.UWidgetBlueprintLibrary.Handled()
local Unhandled = UE4.UWidgetBlueprintLibrary.Unhandled()
local FocusStates = {
  RoleList = "RoleList",
  SubTab = "SubTab",
  SubUI = "SubUI"
}
local M = Class("BluePrints.UI.WBP.Armory.Armory_Main_Base_C")
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_ReddotTree_Component",
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_CharMainCompnent",
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PetMainCompnent",
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_WeaponMainCompnent",
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_BattleWheelMainComponent",
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_ExpandListComponent",
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
  "BluePrints.UI.KeyInputComponent"
}

function M:Construct()
  M.Super.Construct(self)
  self.bShoulFocusToLastFocusedWidget = false
  self.BoxWidget = self.WidgetSwitcher_MP
  self.LockStar = false
  self.LockEdit = false
  self.StarCD = false
  self.Button_Element.bIsFocusable = false
  self.EMListView_Role.BP_OnItemSelectionChanged:Clear()
  self.EMListView_Role.BP_OnItemSelectionChanged:Add(self, self.OnRoleListItemSelectionChanged)
  self.EMListView_SubTab.BP_OnItemSelectionChanged:Clear()
  self.EMListView_SubTab.BP_OnItemSelectionChanged:Add(self, self.OnSubTabItemSelectionChanged)
  self.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    },
    Desc = GText("UI_CTL_ExpandList")
  })
  self.bIsFocusable = true
  self.BottomKeyInfo = {}
  self.KeyDownEvents = {}
  self.RepeatKeyDownEvents = {}
  self.LongPressEvents = {}
  self.KeyUpEvents = {}
  self:CreateKeySetting()
  self:CreateKeyInfoLists()
  self.FSM = FSM:New(self, {
    StateNames = FocusStates,
    OnStateChanged = self.OnFocusChanged,
    CheckFunction = self.IsFocusStateValid
  })
  self.CheckBox_Incarnon:InitGamepadKey(UIConst.GamePadImgKey.SpecialLeft, true)
  self.Btn_StarTarget:TryOverrideSoundFunc(function(...)
    self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_PlayRetrySound", ...)
  end)
end

function M:CreateConstInfos()
  M.Super.CreateConstInfos(self)
  self.MainTabsStyle.BackCallback = self.OnBackKeyDown
  self.IsPC = true
  self.MainTabStyleName = "Text"
  self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
  self.IsGamepadInput = self.CurInputDeviceType == ECommonInputType.Gamepad
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:ReceiveEnterState(StackAction)
  if not UIUtils.HasAnyFocus(self) then
    self:SetFocus()
  end
  M.Super.ReceiveEnterState(self, StackAction)
end

function M:CreateKeySetting()
  self.TableKey = "Tab"
  self.MainTabLeftKey = "Q"
  self.MainTabRightKey = "E"
  self.MainTabGamePadLeftKey = Const.GamepadLeftShoulder
  self.MainTabGamePadRightKey = Const.GamepadRightShoulder
  self.UpgradeKey = "V"
  self.OpenKey = CommonUtils:GetActionMappingKeyName("OpenArmory")
  self.LeftMouseButton = "LeftMouseButton"
  self.LeftThumbstickKey = Const.GamepadLeftThumbstick
  self.RightThumbstickKey = Const.GamepadRightThumbstick
  self.LeftTriggerKey = Const.GamepadLeftTrigger
  self.RightTriggerKey = Const.GamepadRightTrigger
  self.CommonKeyDownEvents = {}
  self:AddKeyEvent(self.CommonKeyDownEvents, self.OnOpenKeyDown, self.OpenKey)
  self:AddKeyEvent(self.CommonKeyDownEvents, self.OnBackKeyDown, {
    "Escape",
    UIConst.GamePadKey.FaceButtonRight
  })
  self:AddKeyEvent(self.CommonKeyDownEvents, self.OnMenuCloseKeyDown, self.LeftMouseButton)
  self.OpenKeyUpEvents = {}
  self:AddKeyEvent(self.OpenKeyUpEvents, self.OnOpenKeyUp, self.OpenKey)
  self.CameraScrollKeyDownEvents = {}
  self:AddKeyEvent(self.CameraScrollKeyDownEvents, self.OnCameraScrollBackwardKeyDown, self.LeftTriggerKey)
  self:AddKeyEvent(self.CameraScrollKeyDownEvents, self.OnCameraScrollForwardKeyDown, self.RightTriggerKey)
  self.ViewKeyDownEvents = {}
  self:AddKeyEvent(self.ViewKeyDownEvents, self.OnViewKeyDown, UIConst.GamePadKey.SpecialLeft)
  self.MenuKeyDownEvents = {}
  self:AddKeyEvent(self.MenuKeyDownEvents, self.Tab_Arm.Entrance_Build.EnterSquadMainUI, UIConst.GamePadKey.SpecialRight)
  self.LeftThumbstickKeyDownEvents = {}
  self:AddKeyEvent(self.LeftThumbstickKeyDownEvents, self.OnLeftThumbstickKeyDown, self.LeftThumbstickKey)
  self.LeftThumbstickKeyUpEvents = {}
  self:AddKeyEvent(self.LeftThumbstickKeyUpEvents, self.OnLeftThumbstickKeyUp, self.LeftThumbstickKey)
  self.RightThumbstickKeyDownEvents = {}
  self:AddKeyEvent(self.RightThumbstickKeyDownEvents, self.OnRightThumbstickKeyDown, self.RightThumbstickKey)
  self.MainTabKeyDownEvents = {}
  self:AddKeyEvent(self.MainTabKeyDownEvents, self.OnMainTabLeftKeyDown, self.MainTabLeftKey)
  self:AddKeyEvent(self.MainTabKeyDownEvents, self.OnMainTabRightKeyDown, self.MainTabRightKey)
  self:AddKeyEvent(self.MainTabKeyDownEvents, self.OnMainTabLeftKeyDown, self.MainTabGamePadLeftKey)
  self:AddKeyEvent(self.MainTabKeyDownEvents, self.OnMainTabRightKeyDown, self.MainTabGamePadRightKey)
  self.SubTabKeyDownEvents = {}
  self:AddKeyEvent(self.SubTabKeyDownEvents, self.OnSubTabLeftKeyDown, "A")
  self:AddKeyEvent(self.SubTabKeyDownEvents, self.OnSubTabRightKeyDown, "D")
  self.RoleTabKeyDownEvents = {}
  self:AddKeyEvent(self.RoleTabKeyDownEvents, self.OnRoleUpKeyDown, "W")
  self:AddKeyEvent(self.RoleTabKeyDownEvents, self.OnRoleDownKeyDown, "S")
  self.UpgradeKeyDownEvents = {}
  self:AddKeyEvent(self.UpgradeKeyDownEvents, self.OnUpgradeKeyDown, {
    self.UpgradeKey,
    UIConst.GamePadKey.FaceButtonLeft
  })
  self.InGearKeyDownEvents = {}
  self.FaceButtonBottomKeyDownEvents = {}
  self:AddKeyEvent(self.FaceButtonBottomKeyDownEvents, self.OnFaceButtonBottomKeyDown, UIConst.GamePadKey.FaceButtonBottom)
end

function M:AddKeyEvent(Events, Event, KeyName)
  if not Events then
    return
  end
  if type(KeyName) == "string" then
    Events[KeyName] = Event
  elseif type(KeyName) == "table" then
    for _, Key in pairs(KeyName) do
      Events[Key] = Event
    end
  end
end

function M:CreateKeyInfoLists()
  self.ESCKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText("Escape"),
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
  self.UpgradeKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText(self.UpgradeKey),
        ClickCallback = self.OnUpgradeKeyDown,
        Owner = self
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "X",
        ClickCallback = self.OnUpgradeKeyDown,
        Owner = self
      }
    },
    Desc = "",
    bLongPress = false
  }
  self.CameraScrollBottomKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = CommonUtils:GetKeyText("Mouse_Button"),
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
    Desc = GText("UI_Dye_Zoom")
  }
  self.RightThumbstickAnalogBottomKeyInfoList = {
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "RH"}
    },
    Desc = GText("UI_CTL_RotatePreview")
  }
  self.LeftThumbstickBottomKeyInfoList = {
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    },
    Desc = ""
  }
  self.EditNameBottomKeyInfoList = {
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "Left"}
    },
    Desc = GText("UI_CTL_Pet_Rename")
  }
  self.SelectBottomKeyInfoList = {
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    },
    Desc = GText("UI_CTL_Select")
  }
  self.ESCOnlyBottomKeyInfo = {
    self.ESCKeyInfoList
  }
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return Handled
  end
  M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.KeyDownEvents[InKeyName] and (InKeyName == UIConst.GamePadKey.DPadUp or InKeyName == UIConst.GamePadKey.DPadDown or InKeyName == UIConst.GamePadKey.DPadLeft or InKeyName == UIConst.GamePadKey.DPadRight) then
    local KeyDownEvent = self.KeyDownEvents[InKeyName]
    if KeyDownEvent then
      local Reply, IsHandled = KeyDownEvent(self, MyGeometry, InKeyEvent)
      if IsHandled then
        return Reply
      else
        return Handled
      end
    end
  end
  if IsValid(self.CurrentSubUI) and self.CurrentSubUI.OnParentPreviewKeyDown then
    local Reply, IsHandled = self.CurrentSubUI:OnParentPreviewKeyDown(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  return Unhandled
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
  local Reply, IsHandled
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local RepeatKeyDownEvent = self.RepeatKeyDownEvents[InKeyName]
  if RepeatKeyDownEvent then
    Reply, IsHandled = RepeatKeyDownEvent(self, MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  return Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local MyInKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local MyInKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(MyInKey)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return Handled
  end
  if self.IsGamepadInput and self.LockStar and MyInKeyName ~= UIConst.GamePadKey.FaceButtonBottom and MyInKeyName ~= UIConst.GamePadKey.FaceButtonRight then
    return Handled
  end
  local Reply, IsHandled
  if IsValid(self.CurrentSubUI) and self.CurrentSubUI.OnParentKeyDown then
    Reply, IsHandled = self.CurrentSubUI:OnParentKeyDown(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return Handled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local MyInKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local MyInKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(MyInKey)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return Handled
  end
  if self.IsGamepadInput and self.LockStar and MyInKeyName ~= UIConst.GamePadKey.FaceButtonBottom and MyInKeyName ~= UIConst.GamePadKey.FaceButtonRight then
    return Handled
  end
  local Reply, IsHandled
  if IsValid(self.CurrentSubUI) and self.CurrentSubUI.OnParentKeyUp then
    Reply, IsHandled = self.CurrentSubUI:OnParentKeyUp(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  Reply, IsHandled = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  local KeyUpEvent = self.KeyUpEvents and self.KeyUpEvents[MyInKeyName]
  if KeyUpEvent then
    Reply, IsHandled = KeyUpEvent(self, MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  return Handled
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.CurrentSubUI and self.CurrentSubUI.UnlockDialog then
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.CurrentSubUI.UnlockDialog)
  end
  local Reply = M.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
  local ReplyInfo = {}
  self:CallFunctionByName(self.CurMainTab.Name .. "Main_OnFocusReceived", ReplyInfo)
  if ReplyInfo.IsHandled then
    return ReplyInfo.Reply
  else
    self:GetDesiredFocusTargetInfo(ReplyInfo)
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), ReplyInfo.Widget)
  end
  return Reply
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.EnableDrag and "Gamepad_RightX" == InKeyName then
    if self.ActorController then
      local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
      self.ActorController:OnDragViewActor({X = DeltaX})
    end
    return Handled
  end
  return Unhandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDeviceType = CurInputDevice
  self.IsGamepadInput = self.CurInputDeviceType == ECommonInputType.Gamepad
  if self.IsGamepadInput and self.IsInFocusPath and not self:IsFocusStateWidgetHasAnyFocus(self.FSM:Peak()) then
    local Info = {}
    self:GetDesiredFocusTargetInfo(Info)
    if Info.Widget then
      Info.Widget:SetFocus()
    end
  end
  self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputDevice, CurGamepadName)
  self:OnFocusChanged()
end

function M:OnTableKeyDown(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnTableKeyDown", ...)
end

function M:OnTableKeyUp(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnTableKeyUp", ...)
end

function M:OnMainTabLeftKeyDown()
  if self.ComponentReceivedEvent.MainTabLeft then
    return
  end
  self.LockStar = false
  self.Tab_Arm:TabToLeft()
  return self:GetReplyWhenMainTabChanged(), true
end

function M:OnMainTabRightKeyDown()
  if self.ComponentReceivedEvent.MainTabRight then
    return
  end
  self.LockStar = false
  self.Tab_Arm:TabToRight()
  return self:GetReplyWhenMainTabChanged(), true
end

function M:GetReplyWhenMainTabChanged()
  local StateName = self.FSM:Peak().Name
  local Widget
  if StateName == FocusStates.SubTab and self.EMListView_SubTab:IsVisible() then
    Widget = self:NavigateToSubTab()
  elseif self.Tab_L:IsVisible() then
    Widget = self:NavigateToRoleList()
  elseif IsValid(self.CurrentSubUI) then
    Widget = self.CurrentSubUI
  end
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), Widget or self), true
end

function M:OnSubTabLeftKeyDown(...)
  if self.ComponentReceivedEvent.SubTabLeft then
    return
  end
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnSubTabLeftKeyDown", ...)
end

function M:OnSubTabRightKeyDown(...)
  if self.ComponentReceivedEvent.SubTabRight then
    return
  end
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnSubTabRightKeyDown", ...)
end

function M:OnOpenKeyDown()
  return self:OnBackKeyDown()
end

function M:OnOpenKeyUp()
  self.bUserLongPressOpenKeyWhenOpen = false
end

function M:NavigateToPre()
  local State = self.FSM:Peak()
  local StateName = State.Name
  local WidgetToFocus
  if StateName == FocusStates.RoleList then
    WidgetToFocus = self:NavigateToRoleList()
  elseif StateName == FocusStates.SubTab then
    WidgetToFocus = self:NavigateToSubTab()
  elseif StateName == FocusStates.SubUI then
    WidgetToFocus = self.CurrentSubUI
  elseif self.Tab_L:IsVisible() then
    WidgetToFocus = self:NavigateToRoleList()
  end
  if WidgetToFocus then
    WidgetToFocus:SetFocus()
  end
end

function M:OnBackKeyDown()
  if self.ComponentReceivedEvent.Back then
    return
  end
  if self.IsGamepadInput then
    local State = self.FSM:Peak()
    local StateName = State.Name
    if UIUtils.HasAnyFocus(self.Btn_StarPet) or UIUtils.HasAnyFocus(self.Btn_ReName) then
      if self.Panel_Btn:IsVisible() then
        self.Panel_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      end
      return self.Btn_More:SetFocus()
    end
    if self.LockStar then
      self.LockStar = false
      self:InitKeySetting()
      return self:NavigateToPre()
    end
    self.FSM:Pop()
    local WidgetToFocus
    if StateName == FocusStates.RoleList then
      return self:OnBackBtnClicked()
    elseif StateName == FocusStates.SubTab then
      WidgetToFocus = self:NavigateToRoleList()
    elseif StateName == FocusStates.SubUI then
      if self.EMListView_SubTab:IsVisible() then
        WidgetToFocus = self:NavigateToSubTab()
      end
    elseif self.Tab_L:IsVisible() then
      WidgetToFocus = self:NavigateToRoleList()
    end
    if WidgetToFocus then
      return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), WidgetToFocus), true
    end
  end
  return self:OnBackBtnClicked()
end

function M:OnViewKeyDown(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnViewKeyDown", ...)
end

function M:OnMenuCloseKeyDown()
  EventManager:FireEvent(EventID.OnMenuClose)
end

function M:OnUKeyDown(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnUKeyDown", ...)
end

function M:OnUpgradeKeyDown(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnBtnIntensifyClicked", ...)
end

function M:OnLeftThumbstickKeyDown(...)
  if self.ComponentReceivedEvent.OnLeftThumbstickKeyDown then
    return
  end
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnLeftThumbstickKeyDown", ...)
end

function M:OnLeftThumbstickKeyUp()
  if self.ComponentReceivedEvent.OnLeftThumbstickKeyUp then
    return
  end
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnLeftThumbstickKeyUp")
end

function M:OnRightThumbstickKeyDown(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnRightThumbstickKeyDown", ...)
end

function M:CallKeyFunctionByName(FunctionName, ...)
  local ReplyInfo = {}
  self:CallFunctionByName(FunctionName, ReplyInfo, ...)
  return ReplyInfo.Reply, ReplyInfo.IsHandled
end

function M:OnCameraScrollBackwardKeyDown()
  self:ScrollCamera(1)
end

function M:OnCameraScrollForwardKeyDown()
  self:ScrollCamera(-1)
end

function M:InitSubUI(...)
  M.Super.InitSubUI(self, ...)
  self:InitNavigationRulesCommon()
  self:InitLockAndStarNavigationRules()
  self:OnFocusChanged()
end

function M:InitNavigationRulesCommon()
  self.EMListView_Role:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.EMListView_Role:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.EMListView_Role:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.EMListView_Role:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    self.OnRoleListNavigation
  })
  self.EMListView_SubTab:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.EMListView_SubTab:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.EMListView_SubTab:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    self.OnSubTabListNavigation
  })
  self.EMListView_SubTab:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    self.OnSubTabListNavigation
  })
  if IsValid(self.CurrentSubUI) then
    self.CurrentSubUI:SetNavigationRuleCustom(EUINavigation.Left, {
      self,
      self.OnSubUINavigation
    })
  end
end

function M:InitLockAndStarNavigationRules()
  self.Btn_Locked:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Btn_Locked:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Btn_Locked:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Btn_StarTarget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Btn_StarTarget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Btn_StarTarget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Btn_More:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Btn_More:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Btn_More:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Btn_StarPet:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Btn_StarPet:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Btn_StarPet:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Btn_ReName:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Btn_ReName:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Btn_ReName:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:OnRoleListNavigation(NavigationDirection)
  if NavigationDirection == EUINavigation.Right then
    if self.EMListView_SubTab:IsVisible() then
      self:NavigateToSubTab()
      return self.EMListView_SubTab
    elseif IsValid(self.CurrentSubUI) then
      return self.CurrentSubUI
    end
  end
  return self.EMListView_Role
end

function M:OnSubTabListNavigation(NavigationDirection)
  if NavigationDirection == EUINavigation.Right then
    if IsValid(self.CurrentSubUI) and self.CurrentSubUI.bIsFocusable then
      return self.CurrentSubUI
    end
  elseif NavigationDirection == EUINavigation.Left then
    self:NavigateToRoleList()
    return self.EMListView_Role
  end
  return self.EMListView_SubTab
end

function M:OnSubUINavigation(NavigationDirection)
  local Info = {}
  self:OnGetSubUINavigationInfo(Info, NavigationDirection)
  return Info.Widget
end

function M:OnGetSubUINavigationInfo(Info, NavigationDirection)
  if self.ComponentReceivedEvent.OnGetSubUINavigationInfo then
    return
  end
  if NavigationDirection == EUINavigation.Left then
    if self.EMListView_SubTab:IsVisible() then
      Info.Widget = self.EMListView_SubTab
    elseif self.Tab_L:IsVisible() then
      Info.Widget = self.EMListView_Role
    end
  end
end

function M:OnRoleListItemSelectionChanged(Content, IsSelected)
  if not IsSelected then
    return
  end
  if self.ComponentReceivedEvent.OnRoleListItemSelectionChanged then
    return
  end
  if self.IsGamepadInput and IsSelected then
    M.Super.OnRoleListItemClicked(self, Content)
    self.EMListView_Role:BP_NavigateToItem(Content)
  end
end

function M:OnRoleListItemClicked(Content)
  if self.IsGamepadInput then
    local CmpContent = self[self.CurMainTab.Name .. "Main_CmpContent"]
    if CmpContent ~= Content then
      M.Super.OnRoleListItemClicked(self, Content)
    else
      self:NavigateToSubTab()
    end
  else
    M.Super.OnRoleListItemClicked(self, Content)
  end
end

function M:OnRoleUpKeyDown()
  if self.ComponentReceivedEvent.RoleUp then
    return
  end
  local CmpContent = self[self.CurMainTab.Name .. "Main_CmpContent"]
  local ContetsArray = self[self.CurMainTab.Name .. "ItemContentsArray"]
  if CmpContent and ContetsArray then
    local Idx = self.EMListView_Role:GetIndexForItem(CmpContent)
    local Content = ContetsArray[Idx]
    if Idx >= 0 and Content then
      M.Super.OnRoleListItemClicked(self, Content)
      self:NavigateToRoleList()
    end
  end
end

function M:OnRoleDownKeyDown()
  if self.ComponentReceivedEvent.RoleDown then
    return
  end
  local CmpContent = self[self.CurMainTab.Name .. "Main_CmpContent"]
  local ContetsArray = self[self.CurMainTab.Name .. "ItemContentsArray"]
  if CmpContent and ContetsArray then
    local Idx = self.EMListView_Role:GetIndexForItem(CmpContent)
    local Content = ContetsArray[Idx + 2]
    if Idx >= 0 and Content then
      M.Super.OnRoleListItemClicked(self, Content)
      self:NavigateToRoleList()
    end
  end
end

function M:OnRoleListContentCreated(Content)
  Content.Owner = self
  Content.OnAddedToFocusPath = self.OnRoleItemAddToFocusPath
  Content.OnRemovedFromFocusPath = self.OnRoleItemRemovedFromFocusPath
  Content.OnPreviewKeyDown = self.OnRoleListContentPreviewKeyDown
end

function M:NavigateToRoleList()
  local CmpContent = self[self.CurMainTab.Name .. "Main_CmpContent"]
  if CmpContent then
    self.EMListView_Role:BP_CancelScrollIntoView()
    self.EMListView_Role:BP_SetSelectedItem(CmpContent)
    self.EMListView_Role:BP_NavigateToItem(CmpContent)
    if CmpContent.Widget then
      return CmpContent.Widget
    end
  end
  return self.EMListView_Role
end

function M:OnLockKeyDown(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnLockKeyDown", ...)
end

function M:OnEditNameKeyDown(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnEditNameKeyDown", ...)
end

function M:OnFaceButtonBottomKeyDown(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnFaceButtonBottomKeyDown", ...)
end

function M:OnStarTargetKeyDown(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnStarTargetBtnClicked", ...)
end

function M:OnStarTargetGamePadKeyDown(...)
  return self:CallKeyFunctionByName(self.CurMainTab.Name .. "Main_OnStarTargetGamePadKeyDown", ...)
end

function M:OnPreviewModeStateChanged()
  if not self.IsPreviewMode then
    return
  end
  M.Super.OnPreviewModeStateChanged(self)
  if UIUtils.HasAnyFocus(self.EMListView_Role) then
    self:NavigateToRoleList()
  end
end

function M:NavigateToSubTab()
  if self.CurSubTab and self.CurSubTab ~= self.NoneTab then
    self.EMListView_SubTab:BP_CancelScrollIntoView()
    self.EMListView_SubTab:BP_SetSelectedItem(self.CurSubTab)
    self.EMListView_SubTab:BP_NavigateToItem(self.CurSubTab)
    if self.CurSubTab.Widget then
      return self.CurSubTab.Widget
    end
  end
  return self.EMListView_SubTab
end

function M:UpdateSubTabs(SubTabs)
  local TabToSelect = M.Super.UpdateSubTabs(self, SubTabs)
  for key, value in pairs(SubTabs) do
    value.OnAddedToFocusPath = self.OnSubTabAddToFocusPath
    value.OnRemovedFromFocusPath = self.OnSubTabRemovedFromFocusPath
  end
  return TabToSelect
end

function M:OnSubTabItemSelectionChanged(Content, IsSelected)
  if not IsSelected then
    return
  end
  if self.IsGamepadInput and IsSelected then
    M.Super.OnSubTabItemClicked(self, Content)
  end
end

function M:OnSubTabItemClicked(Content)
  if self.IsGamepadInput then
    if Content ~= self.CurSubTab then
      M.Super.OnSubTabItemClicked(self, Content)
      return
    end
    if IsValid(self.CurrentSubUI) then
      if self.CurrentSubUI.OnParentFaceButtonBottomKeyDown then
        local Reply, IsHandled = self.CurrentSubUI:OnParentFaceButtonBottomKeyDown()
        if IsHandled then
          return
        end
      end
      if self.CurrentSubUI.bIsFocusable then
        self.CurrentSubUI:SetFocus()
      end
    end
  else
    M.Super.OnSubTabItemClicked(self, Content)
  end
end

function M:ModifySubUIInitParams(Params)
  M.Super.ModifySubUIInitParams(self, Params)
  Params.OnAddedToFocusPath = self.OnSubUIAddedToFocusPath
  Params.OnRemovedFromFocusPath = self.OnSubUIRemovedFromFocusPath
end

function M:OnFocusChanged()
  if not self.Loaded then
    return
  end
  if self.ComponentReceivedEvent.OnFocusChanged then
    return
  end
  if not self.IsGamepadInput then
    self.LockStar = false
  end
  self:InitKeySetting()
  self:InitNavigationRules()
  self:UpdateGamepadStyle()
end

function M:IsFocusStateValid(State)
  local StateName = State.Name
  if StateName == FocusStates.RoleList then
    return self.Tab_L:IsVisible()
  elseif StateName == FocusStates.SubTab then
    return self.EMListView_SubTab:IsVisible()
  elseif StateName == FocusStates.SubUI then
    return IsValid(self.CurrentSubUI) and self.CurrentSubUI.bIsFocusable
  end
end

function M:IsFocusStateWidgetHasAnyFocus(State)
  local bIsFocusStateValid = self:IsFocusStateValid(State)
  if not bIsFocusStateValid then
    return
  end
  local StateName = State.Name
  if StateName == FocusStates.RoleList then
    return UIUtils.HasAnyFocus(self.EMListView_Role)
  elseif StateName == FocusStates.SubTab then
    return UIUtils.HasAnyFocus(self.EMListView_SubTab)
  elseif StateName == FocusStates.SubUI then
    return UIUtils.HasAnyFocus(self.CurrentSubUI)
  end
end

function M:InitKeySetting()
  if self.ComponentReceivedEvent.InitKeySetting then
    return
  end
  self:InitKeySettingCommon()
  self:CallFunctionByName(self.CurMainTab.Name .. "Main_InitKeySetting", self.KeyDownEvents, self.KeyUpEvents, self.BottomKeyInfo)
  self:UpdateBottomKeyInfo(self.BottomKeyInfo)
end

function M:InitLockStarKeySettingCommon()
  self.BottomKeyInfo = {}
  self:ClearAllKeyEvents()
  self.EnableDrag = false
  self.LockStarBottomKeyInfoList = {
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "FaceButtonBottom"
      }
    },
    Desc = GText("UI_Tips_Ensure")
  }
  table.insert(self.BottomKeyInfo, self.LockStarBottomKeyInfoList)
end

function M:InitKeySettingCommon()
  if self.LockStar then
    self:InitLockStarKeySettingCommon()
    return
  end
  self.BottomKeyInfo = {}
  self:ClearAllKeyEvents()
  local ConstCurSubTab = self:GetConstTab(self.CurMainTab.Name, self.CurSubTab.Name)
  if self.bFromArchive and (self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Melee or self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Ranged or self.CurMainTab.Name == ArmoryUtils.ArmoryMainTabNames.Weapon) then
    self.EnableMouseWheel = false
  else
    self.EnableMouseWheel = ConstCurSubTab.EnableMouseWheel
  end
  local ActorControllerEnable = self.ActorController:IsEnableCameraScrolling()
  if self.EnableMouseWheel and self.IsGamepadInput and ActorControllerEnable then
    self:AddKeyEvents(self.RepeatKeyDownEvents, self.CameraScrollKeyDownEvents)
    table.insert(self.BottomKeyInfo, self.CameraScrollBottomKeyInfoList)
  end
  self.EnableDrag = ConstCurSubTab.EnableDrag
  if self.EnableDrag then
    table.insert(self.BottomKeyInfo, self.RightThumbstickAnalogBottomKeyInfoList)
  else
    self:ResetActorRotation()
  end
  self:AddKeyEvents(self.KeyUpEvents, self.OpenKeyUpEvents)
end

function M:AddKeyEvents(InKeyEvents, ...)
  local ConstKeyDownEventsTable = {
    ...
  }
  for _, ConstKeyDownEvents in pairs(ConstKeyDownEventsTable) do
    for key, value in pairs(ConstKeyDownEvents) do
      InKeyEvents[key] = value
    end
  end
end

function M:UpdateBottomKeyInfo(BottomKeyInfo)
  if self.ComponentReceivedEvent.UpdateBottomKeyInfo then
    return
  end
  BottomKeyInfo = BottomKeyInfo or self.BottomKeyInfo
  self.Tab_Arm:UpdateBottomKeyInfo(BottomKeyInfo)
end

function M:GetBottomKeyWidget(Index)
  return self.Tab_Arm.BottomKeyWidget and self.Tab_Arm.BottomKeyWidget[Index]
end

function M:InitNavigationRules()
  self:CallFunctionByName(self.CurMainTab.Name .. "Main_InitNavigationRules")
end

function M:UpdateGamepadStyle()
  self.Key_GamePad_Btn:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    },
    bLongPress = true,
    bButton = true
  })
  if self.IsGamepadInput then
    local State = self.FSM:Peak()
    local StateName = State.Name
    if StateName == FocusStates.RoleList then
      self:ShowListShadow(self.EMListView_Role, false)
    else
      self:ShowListShadow(self.EMListView_Role, true)
    end
    if StateName == FocusStates.SubUI then
      self:ShowListShadow(self.EMListView_SubTab, true)
    else
      self:ShowListShadow(self.EMListView_SubTab, false)
    end
    if self.Panel_Btn:IsVisible() then
      self.Panel_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
    if not self.IsPreviewMode then
      self.Panel_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.Key_GamePad_Btn:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  else
    self:ShowListShadow(self.EMListView_Role, false)
    self:ShowListShadow(self.EMListView_SubTab, false)
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
    self.Panel_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_GamePad_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:CallFunctionByName(self.CurMainTab.Name .. "Main_UpdateGamepadStyle")
end

function M:ShowListShadow(List, IsShow)
  local Contents = List:GetListItems():ToTable()
  for _, value in ipairs(Contents) do
    value.bShadowed = IsShow
    if value.Widget then
      value.Widget:ShowShadow(IsShow)
    end
  end
end

function M:OnRoleItemAddToFocusPath(Content)
  local StateName = self.FSM:Peak().Name
  if StateName ~= FocusStates.RoleList then
    self.FSM:Pop()
  end
  self.FSM:Push({
    Name = FocusStates.RoleList,
    Content = Content
  })
end

function M:OnRoleListContentPreviewKeyDown(KeyName)
  if "Gamepad_FaceButton_Bottom" == KeyName and self.EMListView_SubTab:IsVisible() then
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self:NavigateToSubTab()), true
  end
  return UIUtils.Unhandled
end

function M:OnRoleItemRemovedFromFocusPath()
  self.EMListView_Role:BP_CancelScrollIntoView()
end

function M:OnSubTabAddToFocusPath(Content)
  if self.FSM:Peak().Name == FocusStates.SubUI then
    self.FSM:Pop()
  end
  self.FSM:Push({
    Name = FocusStates.SubTab,
    Content = Content
  })
end

function M:OnSubTabRemovedFromFocusPath(Content)
  self.EMListView_SubTab:BP_CancelScrollIntoView()
end

function M:OnSubUIAddedToFocusPath(Widget)
  self.FSM:Push({
    Name = FocusStates.SubUI,
    Widget = Widget
  })
end

function M:OnSubUIRemovedFromFocusPath()
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
  self.EMListView_SubTab:BP_CancelScrollIntoView()
  self.EMListView_Role:BP_CancelScrollIntoView()
end

function M:GetDesiredFocusTarget()
  if self.CurrentSubUI and self.CurrentSubUI.UnlockDialog then
    return self.CurrentSubUI.UnlockDialog
  end
  local State = self.FSM:Peak()
  if not self:IsFocusStateValid(State) then
    self.FSM:Pop()
    State = self.FSM:Peak()
  end
  local StateName = State.Name
  if StateName == FocusStates.RoleList then
    return self:NavigateToRoleList()
  elseif StateName == FocusStates.SubTab then
    return self:NavigateToSubTab()
  elseif StateName == FocusStates.SubUI then
    return self.CurrentSubUI
  elseif self.Tab_L:IsVisible() then
    return self:NavigateToRoleList()
  elseif IsValid(self.CurrentSubUI) and self.CurrentSubUI.bIsFocusable then
    return self.CurrentSubUI
  else
    DebugPrint("Error: 整备聚焦状态错误!")
    Traceback()
    return self
  end
end

function M:GetDesiredFocusTargetInfo(Info)
  if self.ComponentReceivedEvent.GetDesiredFocusTargetInfo then
    return
  end
  Info.Widget = self:GetDesiredFocusTarget()
end

AssembleComponents(M)
return M
