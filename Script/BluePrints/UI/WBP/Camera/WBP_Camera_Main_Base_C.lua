require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local EMCache = require("EMCache.EMCache")
local CommonUtils = require("Utils.CommonUtils")
local Config = Utils.GetConfig()
local Component = {}
local ClosedPCKey = "T"
local OpenPCKey = "Escape"
local OpenPCKeyText = "Esc"
local ClosedGamePadKey = "Menu"
local OpenGamePadKey = "B"
local ClosedButtonText = "UI_CameraSystem_Custom"
local OpenButtonTextKey = "UI_BACK"
local CustomizeButtonClickSound = "event:/ui/common/click_mid"
local CustomizePanelExpandSound = "event:/ui/common/sub_panel_expand"
local CustomizePanelExpandSoundKey = "CameraCustomizePanelExpand"
local GamePadAnalogThreshold = 0.45
local GamePadAnalogInitialRepeatDelay = 0.35
local GamePadAnalogRepeatInterval = 0.18
local GamePadAnalogAxisSwitchMargin = 0.15
local ValueCacheKeyPrefix = "CameraCustomize_1_5_Value_"
local RoleRotationItemId = "RoleRotation"
local RoleRotationDefaultValue = 180
local RoleRotationMinValue = 0
local RoleRotationMaxValue = 360
local LookAtCameraType = "CameraCustomize"
local WheelActionItemId = Utils.WheelActionItemId
local TargetSelectionItemId = "TargetSelection"
local TargetSelectionAllItemId = "TargetSelectionAll"
local RoleRotationToastCooldown = 0.5
local RoleRotationLookAtToastCooldownKey = "RoleRotationLookAt"
local RoleRotationMountToastCooldownKey = "RoleRotationMount"
local RoleRotationMountToastTextKey = "UI_CameraSystem_CannotRotateOnMount"
local RoleRotationMountToastFallbackText = "UI_CameraSystem_Toast_Riding_UnableRotate"
local RoleRotationRegionOnlineToastCooldownKey = "RoleRotationRegionOnline"
local RoleRotationRegionOnlineToastTextKey = "UI_CameraSystem_CannotRotateInOnlineAction"
local RoleRotationRegionOnlineToastFallbackText = "UI_CameraSystem_Toast_InUse_UnableRotate"
local bEnableWheelActionPauseGreenChannel = true
local bEnableRoleRotationPauseGreenChannel = true
local WheelActionStateIdle = "Idle"
local WheelActionStateStarting = "Starting"
local WheelActionStateWaitingActivation = "WaitingActivation"
local WheelActionStateStopping = "Stopping"
local WheelActionTransitionTimeout = 3
local TargetSelectionCharTypeKey = {
  Role = "Char",
  Player = "Player",
  NPC = "NPC",
  Monster = "Monster",
  Pet = "Pet"
}

local function GetButtonWidget(Widget)
  if not Widget then
    return nil
  end
  return Widget.Btn_Click or Widget.Btn_Area or Widget.Button_Area or Widget.ButtonArea or Widget
end

local function CreateTextKey(KeyWidget, KeyText)
  if KeyWidget and KeyWidget.CreateCommonKey then
    KeyWidget:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = KeyText}
      },
      bDisableResetWhenChangeDevice = true
    })
  end
end

local function CreateGamePadKey(KeyWidget, KeyName)
  if KeyWidget and KeyWidget.CreateCommonKey then
    KeyWidget:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = KeyName}
      },
      bDisableResetWhenChangeDevice = true
    })
  end
end

local function EnsureOwnerInputFocus(Owner)
  if Owner and Owner.EnsureCameraMainInputFocus then
    Owner:EnsureCameraMainInputFocus()
  end
end

local function PlayCameraCustomizeUISound(Owner, EventPath, EventKey)
  if Owner and AudioManager then
    AudioManager(Owner):PlayUISound(Owner, EventPath, EventKey, nil)
  end
end

local function SetCameraCustomizeUISoundToEnd(Owner, EventKey)
  if Owner and AudioManager then
    AudioManager(Owner):SetEventSoundParam(Owner, EventKey, {ToEnd = 1})
  end
end

local function RefreshOwnerHudShortcut(Owner)
  if Owner and Owner.RefreshCameraCustomizeHudShortcutVisible then
    Owner:RefreshCameraCustomizeHudShortcutVisible()
  end
end

local function IsCameraCustomizeHudGamePadPassthroughKey(InKeyName)
  return InKeyName == UIConst.GamePadKey.LeftThumb or InKeyName == UIConst.GamePadKey.FaceButtonTop or InKeyName == UIConst.GamePadKey.SpecialLeft or InKeyName == UIConst.GamePadKey.FaceButtonLeft
end

local function GetCameraCustomizeTabSwitchKey(InKeyName)
  if InKeyName == UIConst.GamePadKey.LeftShoulder then
    return "Left"
  elseif InKeyName == UIConst.GamePadKey.RightShoulder then
    return "Right"
  end
  return nil
end

local function GetCameraCustomizeButtonText(bOpened)
  if bOpened and GText then
    return GText(OpenButtonTextKey)
  end
  return GText(ClosedButtonText)
end

local function GetValueCacheKey(ItemConfig, Extra)
  if not ItemConfig or not ItemConfig.Id then
    return nil
  end
  if nil ~= Extra then
    return ValueCacheKeyPrefix .. tostring(ItemConfig.Id) .. "_" .. tostring(Extra)
  end
  return ValueCacheKeyPrefix .. tostring(ItemConfig.Id)
end

local function TryReadObjectField(Object, FieldName)
  if not Object then
    return nil
  end
  local bSuccess, Value = pcall(function()
    return Object[FieldName]
  end)
  if bSuccess then
    return Value
  end
  return "<unavailable:" .. tostring(Value) .. ">"
end

local function TryWriteObjectField(Object, FieldName, Value)
  if not Object then
    return false
  end
  local bSuccess = pcall(function()
    Object[FieldName] = Value
  end)
  return true == bSuccess
end

local function GetRotatorYaw(Value)
  if not Value then
    return nil
  end
  local Yaw = TryReadObjectField(Value, "Yaw")
  if type(Yaw) == "number" then
    return Yaw
  end
  return nil
end

local function GetObjIdString(Eid)
  if nil == Eid then
    return nil
  end
  if CommonUtils and CommonUtils.ObjId2Str then
    local bSuccess, EidString = pcall(CommonUtils.ObjId2Str, Eid)
    if bSuccess and nil ~= EidString then
      return tostring(EidString)
    end
  end
  return tostring(Eid)
end

local function IsEmptyObjId(Eid)
  local EidString = GetObjIdString(Eid)
  return not EidString or "" == EidString or "0" == EidString
end

local function FindMapValue(Map, Key)
  if not Map or nil == Key then
    return nil
  end
  if Map.Find then
    local bSuccess, Value = pcall(function()
      return Map:Find(Key)
    end)
    if bSuccess and nil ~= Value then
      return Value
    end
  end
  if Map.FindRef then
    local bSuccess, Value = pcall(function()
      return Map:FindRef(Key)
    end)
    if bSuccess and nil ~= Value then
      return Value
    end
  end
  return nil
end

function Component:InitCameraCustomizeMain()
  Config = Utils.GetConfig()
  self.CustomizeOpened = false
  self.CustomizeValues = self.CustomizeValues or {}
  self.Handlers = self.Handlers or {}
  self:ResetCameraCustomizeTabSwitchKeyDownState()
  self:InitCameraCustomizeWheelActionState()
  self:CaptureCameraCustomizeInitialRoleRotation()
  self.bCameraCustomizeRoleRotationBlockedByRegionOnlineInteraction = false
  self:ResetCameraCustomizeLookAtOnCameraEnter()
  self:ResetCameraCustomizeTargetSelectionOnCameraEnter()
  self:BindCameraCustomizeEvents()
  self:BindCameraCustomizeInputModeEvent()
  self:BindCameraCustomizeRegionOnlineInteractionEvent()
  self:RefreshCameraCustomizeRoleRotationRegionOnlineInteractionState(true)
  self.bCameraCustomizeInitializing = true
  if self.Customize and self.Customize.Init then
    self.Customize:Init(Config, self)
  end
  self.bCameraCustomizeInitializing = false
  self:CloseCameraCustomizePanel(true)
  self:SyncCameraCustomizeLookAtCameraFromValue()
  self:RefreshCameraCustomizeButton()
  EnsureOwnerInputFocus(self)
end

function Component:Init(Handlers)
  self:InitCustomizeHandlers(Handlers)
end

function Component:InitCustomizeHandlers(Handlers)
  self.Handlers = Handlers or self.Handlers or {}
end

function Component:BindCameraCustomizeEvents()
  if not self.Btn_Customize then
    return
  end
  if self.Btn_Customize.Init then
    self.Btn_Customize:Init({
      Text = ClosedButtonText,
      ClosedPCKey = ClosedPCKey,
      OpenPCKey = OpenPCKey,
      PCKey = "T",
      ClosedGamePadKey = ClosedGamePadKey,
      OpenGamePadKey = OpenGamePadKey,
      GamePadKey = "Menu"
    }, self)
  elseif not self.bCameraCustomizeButtonBound then
    local Button = GetButtonWidget(self.Btn_Customize)
    if Button and Button.OnClicked then
      Button.OnClicked:Add(self, self.OnCustomizeClicked)
      self.bCameraCustomizeButtonBound = true
    end
  end
  self:SetupCameraCustomizeButtonStaticInfo()
end

function Component:BindCameraCustomizeInputModeEvent()
  if self.bCameraCustomizeInputModeBound then
    return
  end
  local Subsystem = self.GameInputModeSubsystem
  if not Subsystem and UIManager then
    Subsystem = UIManager(self):GetGameInputModeSubsystem()
    self.GameInputModeSubsystem = Subsystem
  end
  if Subsystem and Subsystem.OnInputMethodChanged then
    Subsystem.OnInputMethodChanged:Add(self, self.RefreshCameraCustomizeInputStyle)
    self.bCameraCustomizeInputModeBound = true
  end
end

function Component:UnbindCameraCustomizeInputModeEvent()
  if not self.bCameraCustomizeInputModeBound then
    return
  end
  local Subsystem = self.GameInputModeSubsystem
  if Subsystem and Subsystem.OnInputMethodChanged then
    Subsystem.OnInputMethodChanged:Remove(self, self.RefreshCameraCustomizeInputStyle)
  end
  self.bCameraCustomizeInputModeBound = false
end

function Component:BindCameraCustomizeRegionOnlineInteractionEvent()
  if self.bCameraCustomizeRegionOnlineInteractionEventBound then
    return
  end
  if not (EventManager and EventID) or not EventID.OnRegionOnlineInteractionChanged then
    return
  end
  EventManager:RemoveEvent(EventID.OnRegionOnlineInteractionChanged, self)
  EventManager:AddEvent(EventID.OnRegionOnlineInteractionChanged, self, self.OnCameraCustomizeRegionOnlineInteractionChanged)
  self.bCameraCustomizeRegionOnlineInteractionEventBound = true
end

function Component:UnbindCameraCustomizeRegionOnlineInteractionEvent()
  if not self.bCameraCustomizeRegionOnlineInteractionEventBound then
    return
  end
  if EventManager and EventID and EventID.OnRegionOnlineInteractionChanged then
    EventManager:RemoveEvent(EventID.OnRegionOnlineInteractionChanged, self)
  end
  self.bCameraCustomizeRegionOnlineInteractionEventBound = false
end

function Component:SetupCameraCustomizeButtonStaticInfo()
  local Btn = self.Btn_Customize
  if not Btn then
    return
  end
  self:RefreshCameraCustomizeButtonText()
  self:RefreshCameraCustomizeButtonKey()
end

function Component:RefreshCameraCustomizeInputStyle()
  self:RefreshCameraCustomizeButton()
  RefreshOwnerHudShortcut(self)
  if self:IsCustomizeOpened() and self:IsCameraCustomizeGamePadInput() then
    self:RefreshCameraCustomizeCurrentGamePadFocus(true)
  elseif not self:IsCameraCustomizeGamePadInput() then
    self:ResetCameraCustomizeGamePadFocusStyle()
  end
end

function Component:ResetCameraCustomizeGamePadFocusStyle()
  if self.Customize and self.Customize.ResetGamePadFocusStyle then
    self.Customize:ResetGamePadFocusStyle()
  end
end

function Component:RefreshCameraCustomizeButton()
  local Btn = self.Btn_Customize
  if not Btn then
    return
  end
  self:RefreshCameraCustomizeButtonText()
  self:RefreshCameraCustomizeButtonNewState()
  if not Btn.WS_Type or not Btn.WS_Type.SetActiveWidgetIndex then
    return
  end
  if self:IsCameraCustomizeMobile() then
    Btn.WS_Type:SetActiveWidgetIndex(self:IsCustomizeOpened() and 1 or 0)
    return
  end
  local bUseGamePad = self:IsCameraCustomizeGamePadInput()
  self:RefreshCameraCustomizeButtonKey()
  Btn.WS_Type:SetActiveWidgetIndex(bUseGamePad and 1 or 0)
end

function Component:RefreshCameraCustomizeButtonText()
  local Btn = self.Btn_Customize
  if not Btn then
    return
  end
  Utils.SetText(Btn.Text_Button, GetCameraCustomizeButtonText(self:IsCustomizeOpened()))
end

function Component:RefreshCameraCustomizeButtonKey()
  local Btn = self.Btn_Customize
  if not Btn then
    return
  end
  local PCKeyText = self:IsCustomizeOpened() and OpenPCKeyText or ClosedPCKey
  local GamePadKey = self:IsCustomizeOpened() and OpenGamePadKey or ClosedGamePadKey
  if Btn.RefreshInputStyle then
    Btn.Config = Btn.Config or {}
    Btn.Config.PCKey = PCKeyText
    Btn.Config.GamePadKey = GamePadKey
    Btn:RefreshInputStyle(self:IsCameraCustomizeGamePadInput())
    return
  end
  CreateTextKey(Btn.Key, PCKeyText)
  CreateGamePadKey(Btn.Key_Controller, GamePadKey)
end

function Component:HasNewInCameraCustomizeTabs()
  if not (Config and Config.Tabs) or not Config.Items then
    return false
  end
  for _, Tab in ipairs(Config.Tabs) do
    for _, ItemId in ipairs(Tab.Items or {}) do
      if Component.HasNewInItem(self, Config.Items[ItemId]) then
        return true
      end
    end
  end
  return false
end

function Component:RefreshCameraCustomizeButtonNewState()
  local Btn = self.Btn_Customize
  if not Btn then
    return
  end
  local bHasNew = self:HasNewInCameraCustomizeTabs()
  if Btn.RefreshNewState then
    Btn:RefreshNewState(bHasNew)
  else
    Utils.SetNew(Btn.New, bHasNew)
  end
end

function Component:IsCameraCustomizeMobile()
  return self.CameraCustomizePlatform == "Mobile"
end

function Component:IsCameraCustomizeGamePadInput()
  local Subsystem = self.GameInputModeSubsystem
  if Subsystem and Subsystem.GetCurrentInputType then
    return Subsystem:GetCurrentInputType() == ECommonInputType.Gamepad
  end
  return false
end

function Component:OnCameraCustomizeCloseClicked()
  if self.CheckHasAnyOperationOrClose then
    self:CheckHasAnyOperationOrClose()
  elseif self.Close then
    self:Close()
  else
    self:RemoveFromParent()
  end
end

function Component:OnCustomizeClicked()
  PlayCameraCustomizeUISound(self.Btn_Customize or self, CustomizeButtonClickSound, nil)
  self:ToggleCameraCustomizePanel()
end

function Component:ToggleCameraCustomizePanel()
  if self:IsCustomizeOpened() then
    self:CloseCameraCustomizePanel()
  else
    self:OpenCameraCustomizePanel()
  end
end

function Component:OpenCameraCustomizePanel()
  if self.bSelfHidden or self.bDisableCustom then
    return
  end
  self:StopCameraMove()
  self.CustomizeOpened = true
  self:ResetCameraCustomizeTabSwitchKeyDownState()
  if self.Customize and self.Customize.SetVisibility then
    self.Customize:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self:SetCameraCustomizeVirtualAccept(true)
  if self.Customize and type(self.Customize.RefreshPanel) == "function" then
    self.Customize:RefreshPanel()
  end
  if self.Customize and self.Customize.FocusDefaultItem then
    self.Customize:FocusDefaultItem()
  end
  if not self:IsCameraCustomizeGamePadInput() then
    self:ResetCameraCustomizeGamePadFocusStyle()
  end
  PlayCameraCustomizeUISound(self.Customize or self, CustomizePanelExpandSound, CustomizePanelExpandSoundKey)
  if self.Customize_In then
    self:PlayAnimation(self.Customize_In)
  end
  self:RefreshCameraCustomizeButton()
  RefreshOwnerHudShortcut(self)
  if self:IsParameterWidgetShowed() then
    self:HideParameterWidget()
  end
end

function Component:CloseCameraCustomizePanel(bInstant)
  self:ResetCameraCustomizeGamePadFocusStyle()
  self.CustomizeOpened = false
  self:ResetCameraCustomizeTabSwitchKeyDownState()
  self:SetCameraCustomizeVirtualAccept(false)
  if not bInstant and self.Customize_Out then
    SetCameraCustomizeUISoundToEnd(self.Customize or self, CustomizePanelExpandSoundKey)
    self:PlayAnimation(self.Customize_Out)
  end
  Utils.SetVisibility(self.Customize, false)
  self:RefreshCameraCustomizeButton()
  RefreshOwnerHudShortcut(self)
  EnsureOwnerInputFocus(self)
  self:HideCameraCustomizeGamePadCursorForHud()
end

function Component:IsCustomizeOpened()
  return self.CustomizeOpened == true
end

function Component:ResetCameraCustomizeTabSwitchKeyDownState()
  self.CameraCustomizeTabSwitchKeyDownState = {Left = false, Right = false}
end

function Component:RefreshCameraCustomizeGamePadCursor(TargetWidget)
  if not self:IsCustomizeOpened() or not self:IsCameraCustomizeGamePadInput() then
    return
  end
  local Subsystem = self.GameInputModeSubsystem
  if not Subsystem and UIManager then
    Subsystem = UIManager(self):GetGameInputModeSubsystem()
    self.GameInputModeSubsystem = Subsystem
  end
  if not Subsystem then
    return
  end
  if Subsystem.SetNavigateWidgetOpacity then
    Subsystem:SetNavigateWidgetOpacity(1)
  end
  if TargetWidget and Subsystem.SetTargetUIFocusWidget then
    Subsystem:SetTargetUIFocusWidget(TargetWidget)
  end
  if Subsystem.UpdateCurrentFocusWidgetPos then
    Subsystem:UpdateCurrentFocusWidgetPos()
  end
  RefreshOwnerHudShortcut(self)
end

function Component:GetCameraCustomizeFocusedControllerOpInfo()
  if self.Customize and self.Customize.GetFocusedControllerOpInfo then
    return self.Customize:GetFocusedControllerOpInfo()
  end
  return nil
end

function Component:RefreshCameraCustomizeCurrentGamePadFocus(bDelay)
  local function RefreshFocus()
    if not self:IsCustomizeOpened() or not self:IsCameraCustomizeGamePadInput() then
      return
    end
    if self.Customize and self.Customize.RefreshGamePadFocus then
      self.Customize:RefreshGamePadFocus()
    elseif self.Customize and self.Customize.FocusDefaultItem then
      self.Customize:FocusDefaultItem()
    end
  end
  
  if bDelay and self.AddDelayFrameFunc then
    self:AddDelayFrameFunc(RefreshFocus, 1, "CameraCustomizeRefreshGamePadFocus")
  else
    RefreshFocus()
  end
end

function Component:HideCameraCustomizeGamePadCursorForHud()
  if not self:IsCameraCustomizeGamePadInput() then
    return
  end
  local Subsystem = self.GameInputModeSubsystem
  if not Subsystem and UIManager then
    Subsystem = UIManager(self):GetGameInputModeSubsystem()
    self.GameInputModeSubsystem = Subsystem
  end
  if not Subsystem then
    return
  end
  if Subsystem.SetTargetUIFocusWidget then
    Subsystem:SetTargetUIFocusWidget(self)
  end
  if Subsystem.SetNavigateWidgetOpacity then
    Subsystem:SetNavigateWidgetOpacity(0)
  end
end

function Component:SetCameraCustomizeVirtualAccept(bEnable)
  if not self.SetIsDealWithVirtualAccept then
    return
  end
  if bEnable then
    if self.CameraCustomizePrevVirtualAccept == nil then
      self.CameraCustomizePrevVirtualAccept = self.bIsDealWithVirtualAccept == true
    end
    self:SetIsDealWithVirtualAccept(true)
    return
  end
  local PrevValue = self.CameraCustomizePrevVirtualAccept
  self.CameraCustomizePrevVirtualAccept = nil
  if nil == PrevValue then
    return
  end
  self:SetIsDealWithVirtualAccept(true == PrevValue)
end

function Component:SelectNextCustomizeTab()
  if self.Customize and self.Customize.SelectNextTab then
    self.Customize:SelectNextTab()
  end
end

function Component:SelectPrevCustomizeTab()
  if self.Customize and self.Customize.SelectPrevTab then
    self.Customize:SelectPrevTab()
  end
end

function Component:HandleCustomizeConfirm()
  if self.Customize and self.Customize.HandleConfirm then
    return self.Customize:HandleConfirm() == true
  end
  return false
end

function Component:HandleCameraCustomizePreviewKeyDown(MyGeometry, InKeyEvent)
  return self:HandleCameraCustomizeKeyDown(MyGeometry, InKeyEvent)
end

function Component:HandleCameraCustomizeKeyUp(MyGeometry, InKeyEvent)
  if not self:IsCustomizeOpened() or self.bDisableCustom then
    return nil
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local TabSwitchKey = GetCameraCustomizeTabSwitchKey(InKeyName)
  if TabSwitchKey then
    self.CameraCustomizeTabSwitchKeyDownState = self.CameraCustomizeTabSwitchKeyDownState or {}
    self.CameraCustomizeTabSwitchKeyDownState[TabSwitchKey] = false
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.Customize and self.Customize.HandleGamePadKeyUp then
    if self.Customize:HandleGamePadKeyUp(InKeyName) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold or InKeyName == UIConst.GamePadKey.RightTriggerThreshold or InKeyName == UIConst.GamePadKey.RightStickLeft or InKeyName == UIConst.GamePadKey.RightStickRight then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return nil
end

function Component:HandleCameraCustomizeRepeatKeyDown(MyGeometry, InKeyEvent)
  if self.bDisableCustom or not self:IsCustomizeOpened() then
    return nil
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and GetCameraCustomizeTabSwitchKey(InKeyName) and self:HandleCameraCustomizeGamePadDown(InKeyName, true) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return nil
end

function Component:HandleCameraCustomizeKeyDown(MyGeometry, InKeyEvent)
  if self.bDisableCustom then
    return nil
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if self:HandleCameraCustomizeGamePadDown(InKeyName) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return nil
  end
  if "Escape" == InKeyName or "Android_Back" == InKeyName then
    if self:IsCustomizeOpened() then
      self:CloseCameraCustomizePanel()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return nil
  elseif InKeyName == ClosedPCKey and not self:IsCameraCustomizeMobile() and not self:IsCustomizeOpened() then
    self:OpenCameraCustomizePanel()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self:IsCustomizeOpened() and not self:IsCameraCustomizeMobile() and self.Customize and self.Customize.HandleKeyEventOnPC and self.Customize:HandleKeyEventOnPC(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self:IsCustomizeOpened() and not self:IsCameraCustomizeMobile() and "U" == InKeyName then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return nil
end

function Component:HandleCameraCustomizeGamePadDown(InKeyName, bIsRepeat)
  if not self:IsCustomizeOpened() then
    if InKeyName == UIConst.GamePadKey.SpecialRight then
      self:OpenCameraCustomizePanel()
      return true
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:CloseCameraCustomizePanel()
  elseif InKeyName == UIConst.GamePadKey.LeftShoulder then
    if bIsRepeat then
      return true
    end
    self.CameraCustomizeTabSwitchKeyDownState = self.CameraCustomizeTabSwitchKeyDownState or {}
    if self.CameraCustomizeTabSwitchKeyDownState.Left then
      return true
    end
    self.CameraCustomizeTabSwitchKeyDownState.Left = true
    self:SelectPrevCustomizeTab()
  elseif InKeyName == UIConst.GamePadKey.RightShoulder then
    if bIsRepeat then
      return true
    end
    self.CameraCustomizeTabSwitchKeyDownState = self.CameraCustomizeTabSwitchKeyDownState or {}
    if self.CameraCustomizeTabSwitchKeyDownState.Right then
      return true
    end
    self.CameraCustomizeTabSwitchKeyDownState.Right = true
    self:SelectNextCustomizeTab()
  elseif InKeyName == UIConst.GamePadKey.DPadUp or InKeyName == UIConst.GamePadKey.DPadDown or InKeyName == UIConst.GamePadKey.DPadLeft or InKeyName == UIConst.GamePadKey.DPadRight then
    if self.Customize and self.Customize.HandleGamePadAnalog then
      self.Customize:HandleGamePadAnalog(nil, InKeyName, 1)
    end
  elseif InKeyName == UIConst.GamePadKey.LeftTriggerThreshold or InKeyName == UIConst.GamePadKey.RightTriggerThreshold or InKeyName == UIConst.GamePadKey.RightStickLeft or InKeyName == UIConst.GamePadKey.RightStickRight then
    if self.Customize and self.Customize.HandleGamePadKeyDown then
      self.Customize:HandleGamePadKeyDown(InKeyName)
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:HandleCustomizeConfirm()
    return true
  elseif IsCameraCustomizeHudGamePadPassthroughKey(InKeyName) then
    return false
  else
    return true
  end
  return true
end

function Component:GetCameraCustomizeAnalogDirection(AxisName, Value)
  if math.abs(Value or 0) < GamePadAnalogThreshold then
    return nil
  end
  if AxisName == UIConst.GamePadKey.RightAnalogX then
    return Value > 0 and UIConst.GamePadKey.RightStickRight or UIConst.GamePadKey.RightStickLeft
  end
  return nil
end

function Component:GetCameraCustomizeLeftAnalogDirection()
  local State = self.CameraCustomizeLeftAnalogState
  if not State then
    return nil
  end
  local X = State.X or 0
  local Y = State.Y or 0
  local AbsX = math.abs(X)
  local AbsY = math.abs(Y)
  if AbsX < GamePadAnalogThreshold and AbsY < GamePadAnalogThreshold then
    return nil
  end
  local LastDirection = State.DirectionKey
  local bLastHorizontal = LastDirection == UIConst.GamePadKey.DPadLeft or LastDirection == UIConst.GamePadKey.DPadRight
  local bUseHorizontal = AbsX >= AbsY
  if LastDirection then
    if bLastHorizontal then
      if AbsY > AbsX + GamePadAnalogAxisSwitchMargin then
        bUseHorizontal = false
      else
        bUseHorizontal = true
      end
    elseif AbsX > AbsY + GamePadAnalogAxisSwitchMargin then
      bUseHorizontal = true
    else
      bUseHorizontal = false
    end
  end
  if bUseHorizontal and AbsX >= GamePadAnalogThreshold then
    return X > 0 and UIConst.GamePadKey.DPadRight or UIConst.GamePadKey.DPadLeft
  elseif AbsY >= GamePadAnalogThreshold then
    return Y > 0 and UIConst.GamePadKey.DPadUp or UIConst.GamePadKey.DPadDown
  end
  return nil
end

function Component:GetCameraCustomizeLeftAnalogAxisName(DirectionKey)
  if DirectionKey == UIConst.GamePadKey.DPadLeft or DirectionKey == UIConst.GamePadKey.DPadRight then
    return UIConst.GamePadKey.LeftAnalogX
  end
  return UIConst.GamePadKey.LeftAnalogY
end

function Component:ShouldHandleCameraCustomizeLeftAnalog(DirectionKey)
  self.CameraCustomizeLeftAnalogState = self.CameraCustomizeLeftAnalogState or {}
  local State = self.CameraCustomizeLeftAnalogState
  if not DirectionKey then
    State.DirectionKey = nil
    State.LastTime = nil
    State.bRepeatStarted = false
    return false
  end
  local NowTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
  if State.DirectionKey ~= DirectionKey then
    State.DirectionKey = DirectionKey
    State.LastTime = NowTime
    State.bRepeatStarted = false
    return true
  end
  local RepeatInterval = State.bRepeatStarted and GamePadAnalogRepeatInterval or GamePadAnalogInitialRepeatDelay
  if not State.LastTime or RepeatInterval <= NowTime - State.LastTime then
    State.LastTime = NowTime
    State.bRepeatStarted = true
    return true
  end
  return false
end

function Component:DispatchCameraCustomizeLeftAnalog()
  local DirectionKey = self:GetCameraCustomizeLeftAnalogDirection()
  if not self:ShouldHandleCameraCustomizeLeftAnalog(DirectionKey) then
    return
  end
  if self.Customize and self.Customize.HandleGamePadAnalog then
    self.Customize:HandleGamePadAnalog(self:GetCameraCustomizeLeftAnalogAxisName(DirectionKey), DirectionKey, 1)
  end
end

function Component:UpdateCameraCustomizeLeftAnalog(AxisName, Value)
  self.CameraCustomizeLeftAnalogState = self.CameraCustomizeLeftAnalogState or {}
  local State = self.CameraCustomizeLeftAnalogState
  if AxisName == UIConst.GamePadKey.LeftAnalogX then
    State.X = Value or 0
  elseif AxisName == UIConst.GamePadKey.LeftAnalogY then
    State.Y = Value or 0
  end
  if State.bDispatchPending then
    return
  end
  State.bDispatchPending = true
  if self.AddDelayFrameFunc then
    self:AddDelayFrameFunc(function()
      if self.CameraCustomizeLeftAnalogState then
        self.CameraCustomizeLeftAnalogState.bDispatchPending = false
      end
      self:DispatchCameraCustomizeLeftAnalog()
    end, 1, "CameraCustomizeLeftAnalogDispatch")
  else
    State.bDispatchPending = false
    self:DispatchCameraCustomizeLeftAnalog()
  end
end

function Component:HandleCameraCustomizeAnalog(MyGeometry, InAnalogInputEvent)
  if not self:IsCustomizeOpened() then
    return nil
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local Value = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  local DirectionKey = self:GetCameraCustomizeAnalogDirection(InKeyName, Value)
  if InKeyName == UIConst.GamePadKey.RightAnalogX then
    if self.Customize and self.Customize.HandleGamePadAnalog and self.Customize:HandleGamePadAnalog(InKeyName, DirectionKey, Value) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if InKeyName ~= UIConst.GamePadKey.LeftAnalogX and InKeyName ~= UIConst.GamePadKey.LeftAnalogY then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  self:UpdateCameraCustomizeLeftAnalog(InKeyName, Value)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function Component:GetCachedCustomizeValue(ItemConfig, Extra)
  local CacheKey = GetValueCacheKey(ItemConfig, Extra)
  if not CacheKey then
    return nil
  end
  return EMCache:Get(CacheKey, true)
end

function Component:SetCachedCustomizeValue(ItemConfig, Value, Extra)
  local CacheKey = GetValueCacheKey(ItemConfig, Extra)
  if not CacheKey then
    return
  end
  EMCache:Set(CacheKey, Value, true)
end

function Component:ResetCameraCustomizeLookAtOnCameraEnter()
  local ItemConfig = Config.Items and Config.Items.LookAtCamera
  if not ItemConfig then
    return
  end
  self:StopCameraCustomizeLookAtCamera()
  self.bCameraCustomizeLookAtCameraEnabled = false
  self.CustomizeValues[ItemConfig.Id] = false
  self:SetCachedCustomizeValue(ItemConfig, false)
end

function Component:ResetCameraCustomizeTargetSelectionOnCameraEnter()
  local SelectionConfig = Config.Items and Config.Items[TargetSelectionItemId]
  if not SelectionConfig then
    return
  end
  local SelectionValue = {}
  for _, Option in ipairs(SelectionConfig.Options or {}) do
    SelectionValue[Option.Id] = false
    self:SetCachedCustomizeValue(SelectionConfig, false, Option.Id)
  end
  self.CustomizeValues[SelectionConfig.Id] = SelectionValue
  local ControlSwitchItem = Config.Items and Config.Items[TargetSelectionAllItemId]
  if ControlSwitchItem then
    self.CustomizeValues[ControlSwitchItem.Id] = false
    self:SetCachedCustomizeValue(ControlSwitchItem, false)
  end
  self:ApplyTargetSelectionHiddenState(SelectionConfig, SelectionValue)
end

function Component:IsCameraCustomizeGamePaused()
  return UE4.UGameplayStatics.IsGamePaused(self) == true
end

function Component:CanShowCameraCustomizeToast(CooldownKey, CooldownSeconds)
  if not (CooldownKey and CooldownSeconds) or CooldownSeconds <= 0 then
    return true
  end
  local NowTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
  self.CameraCustomizeToastCooldowns = self.CameraCustomizeToastCooldowns or {}
  local LastTime = self.CameraCustomizeToastCooldowns[CooldownKey]
  if LastTime and CooldownSeconds > NowTime - LastTime then
    return false
  end
  self.CameraCustomizeToastCooldowns[CooldownKey] = NowTime
  return true
end

function Component:GetCameraCustomizeToastText(TextKey, FallbackText)
  if TextKey and GText then
    local Text = GText(TextKey)
    if Text and Text ~= TextKey and "" ~= Text then
      return Text
    end
  end
  return FallbackText or TextKey and GText and GText(TextKey) or TextKey or ""
end

function Component:ShowCameraCustomizePauseToast(TextKey, FallbackText, CooldownKey, CooldownSeconds)
  if not self:CanShowCameraCustomizeToast(CooldownKey, CooldownSeconds) then
    return
  end
  if UIManager and UIConst and UIConst.Tip_CommonToast then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, self:GetCameraCustomizeToastText(TextKey, FallbackText))
  end
end

function Component:ShowCameraCustomizePauseStateToast(IsGamePause)
  if IsGamePause then
    self:ShowCameraCustomizePauseToast("UI_CameraSystem_TimePauseOn", "已开启时停")
  else
    self:ShowCameraCustomizePauseToast("UI_CameraSystem_TimePauseOff", "已关闭时停")
  end
end

function Component:CanApplyLookAtCamera(IsOn, bSilent)
  if true == IsOn and self:IsCameraCustomizeGamePaused() then
    if not bSilent then
      self:ShowCameraCustomizePauseToast("UI_CameraSystem_RequireTimeResume")
    end
    return false
  end
  return true
end

function Component:IsCameraCustomizeRoleRotationDefault(Degree)
  Degree = math.clamp(tonumber(Degree) or RoleRotationDefaultValue, RoleRotationMinValue, RoleRotationMaxValue)
  return math.abs(Degree - RoleRotationDefaultValue) <= 0.001
end

function Component:IsCameraCustomizeRoleRotationBlockedByLookAt()
  return self.bCameraCustomizeLookAtCameraEnabled == true
end

function Component:IsCameraCustomizeRoleRotationBlockedByMount()
  local Player = self:GetCameraCustomizePlayerCharacter()
  return Player and (not IsValid or IsValid(Player)) and Player.IsInMountState and Player:IsInMountState() == true
end

function Component:GetCameraCustomizeSelfEidString()
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar()
  if Avatar and Avatar.Eid then
    return GetObjIdString(Avatar.Eid)
  end
  local Player = self:GetCameraCustomizePlayerCharacter()
  return Player and GetObjIdString(Player.Eid) or nil
end

function Component:GetCameraCustomizePlayerRegionOnlineMechanismList(SelfEidString)
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar()
  if not Avatar or not Avatar.IsInRegionOnline then
    return nil
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local MechanismMap = GameState and GameState.PlayerRegionOnlineMechanismMap
  return FindMapValue(MechanismMap, SelfEidString or self:GetCameraCustomizeSelfEidString())
end

function Component:GetCameraCustomizeRegionOnlineMechanism(GameState, UniqueId)
  local MechanismMap = GameState and GameState.RegionOnlineMechanismMap
  return FindMapValue(MechanismMap, UniqueId)
end

function Component:GetCameraCustomizeCurrentRegionOnlineMechanismInfo(SelfEidString)
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar()
  local UserMechanismMap = Avatar and Avatar.User2Mechanism
  if not UserMechanismMap then
    return nil
  end
  return UserMechanismMap[SelfEidString or self:GetCameraCustomizeSelfEidString()]
end

function Component:GetOtherRegionOnlineInteractorInAvatarCacheState(UniqueId, SelfEidString)
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar()
  local MechanismUserMap = Avatar and Avatar.Mechanism2User and Avatar.Mechanism2User[UniqueId]
  if not MechanismUserMap and Avatar and Avatar.Mechanism2User and nil ~= UniqueId then
    MechanismUserMap = Avatar.Mechanism2User[tostring(UniqueId)]
  end
  if not MechanismUserMap then
    return nil
  end
  for _, AvatarEid in pairs(MechanismUserMap) do
    if not IsEmptyObjId(AvatarEid) and GetObjIdString(AvatarEid) ~= SelfEidString then
      return true
    end
  end
  return false
end

function Component:HasOtherRegionOnlineInteractorInAvatarCache(UniqueId, SelfEidString)
  return self:GetOtherRegionOnlineInteractorInAvatarCacheState(UniqueId, SelfEidString) == true
end

function Component:HasOtherRegionOnlineInteractorInMechanism(Mechanism, SelfEidString)
  if not Mechanism then
    return false
  end
  if Mechanism.PlayerAndSeat then
    for PlayerEid in pairs(Mechanism.PlayerAndSeat) do
      if not IsEmptyObjId(PlayerEid) and GetObjIdString(PlayerEid) ~= SelfEidString then
        return true
      end
    end
  end
  if Mechanism.GetValidPoint then
    local bSuccess, PointInfoMap = pcall(function()
      return Mechanism:GetValidPoint()
    end)
    if bSuccess and type(PointInfoMap) == "table" then
      for _, PointInfo in pairs(PointInfoMap) do
        local Eid = PointInfo and PointInfo.Eid
        if not IsEmptyObjId(Eid) and GetObjIdString(Eid) ~= SelfEidString then
          return true
        end
      end
    end
  end
  return false
end

function Component:IsCameraCustomizeJoinedOtherRegionOnlineAction(GameState, SelfEidString)
  local MechanismInfo = self:GetCameraCustomizeCurrentRegionOnlineMechanismInfo(SelfEidString)
  local UniqueId = MechanismInfo and MechanismInfo.UniqueId
  if not UniqueId then
    return false
  end
  local Mechanism = self:GetCameraCustomizeRegionOnlineMechanism(GameState, UniqueId)
  if not Mechanism then
    return false
  end
  if not IsEmptyObjId(Mechanism.SenderId) then
    return GetObjIdString(Mechanism.SenderId) ~= SelfEidString
  end
  local bHasOtherInCache = self:GetOtherRegionOnlineInteractorInAvatarCacheState(UniqueId, SelfEidString)
  if nil ~= bHasOtherInCache then
    return bHasOtherInCache
  end
  return self:HasOtherRegionOnlineInteractorInMechanism(Mechanism, SelfEidString)
end

function Component:HasOtherRegionOnlineInteractorInCameraCustomizeOnlineAction()
  local SelfEidString = self:GetCameraCustomizeSelfEidString()
  if not SelfEidString then
    return false
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if self:IsCameraCustomizeJoinedOtherRegionOnlineAction(GameState, SelfEidString) then
    return true
  end
  local MechanismList = self:GetCameraCustomizePlayerRegionOnlineMechanismList(SelfEidString)
  if not MechanismList or not MechanismList.Array then
    return false
  end
  for _, UniqueId in pairs(MechanismList.Array) do
    local bHasOtherInCache = self:GetOtherRegionOnlineInteractorInAvatarCacheState(UniqueId, SelfEidString)
    if nil ~= bHasOtherInCache then
      if bHasOtherInCache then
        return true
      end
    else
      local Mechanism = self:GetCameraCustomizeRegionOnlineMechanism(GameState, UniqueId)
      if self:HasOtherRegionOnlineInteractorInMechanism(Mechanism, SelfEidString) then
        return true
      end
    end
  end
  return false
end

function Component:IsCameraCustomizeRoleRotationBlockedByRegionOnlineInteraction()
  return self.bCameraCustomizeRoleRotationBlockedByRegionOnlineInteraction == true
end

function Component:IsCameraCustomizeGamePauseLocked()
  if self.GetLockGamePause then
    return self:GetLockGamePause() == true
  end
  return true == self.bLockGamePause
end

function Component:ForceResumeCameraCustomizeForRegionOnlineInteraction()
  if not self.NotifyGamePauseChange or not self:IsCameraCustomizeGamePaused() then
    return false
  end
  if self:IsCameraCustomizeGamePauseLocked() then
    return false
  end
  self.bCameraCustomizeSuppressNextPauseStateToast = true
  if self:NotifyGamePauseChange(false) == false then
    self.bCameraCustomizeSuppressNextPauseStateToast = false
    return false
  end
  return true
end

function Component:RefreshCameraCustomizeRoleRotationRegionOnlineInteractionState(bForce)
  local bBlocked = self:HasOtherRegionOnlineInteractorInCameraCustomizeOnlineAction()
  local bWasBlocked = self.bCameraCustomizeRoleRotationBlockedByRegionOnlineInteraction == true
  local bChanged = bWasBlocked ~= bBlocked
  local bEnteredBlockedState = bBlocked and not bWasBlocked
  local bHadRoleRotationChanged = true == self.bCameraCustomizeRoleRotationChanged
  self.bCameraCustomizeRoleRotationBlockedByRegionOnlineInteraction = bBlocked
  if bBlocked then
    self.CustomizeValues = self.CustomizeValues or {}
    if bHadRoleRotationChanged then
      self:RestoreCameraCustomizeRoleRotation()
    end
    self.CustomizeValues[RoleRotationItemId] = RoleRotationDefaultValue
    self.bCameraCustomizeRoleRotationChanged = false
    if bEnteredBlockedState and bHadRoleRotationChanged then
      self:ForceResumeCameraCustomizeForRegionOnlineInteraction()
    end
  end
  if (bChanged or true == bForce) and self.Customize and self.Customize.RefreshValue then
    self.Customize:RefreshValue()
  end
  return bBlocked
end

function Component:OnCameraCustomizeRegionOnlineInteractionChanged(UniqueId, InteractiveId, SenderEid, bInteractive, bHasOtherInteractor)
  self:RefreshCameraCustomizeRoleRotationRegionOnlineInteractionState()
end

function Component:IsCameraCustomizeRoleRotationForbidden()
  return self:IsCameraCustomizeRoleRotationBlockedByLookAt() or self:IsCameraCustomizeRoleRotationBlockedByMount() or self:IsCameraCustomizeRoleRotationBlockedByRegionOnlineInteraction()
end

function Component:ShowCameraCustomizeRoleRotationMountToast()
  self:ShowCameraCustomizePauseToast(RoleRotationMountToastTextKey, RoleRotationMountToastFallbackText, RoleRotationMountToastCooldownKey, RoleRotationToastCooldown)
end

function Component:ShowCameraCustomizeRoleRotationRegionOnlineToast()
  self:ShowCameraCustomizePauseToast(RoleRotationRegionOnlineToastTextKey, RoleRotationRegionOnlineToastFallbackText, RoleRotationRegionOnlineToastCooldownKey, RoleRotationToastCooldown)
end

function Component:ShowCameraCustomizeRoleRotationForbiddenToast()
  if self:IsCameraCustomizeRoleRotationBlockedByRegionOnlineInteraction() then
    self:ShowCameraCustomizeRoleRotationRegionOnlineToast()
  elseif self:IsCameraCustomizeRoleRotationBlockedByMount() then
    self:ShowCameraCustomizeRoleRotationMountToast()
  end
end

function Component:CanApplyRoleRotation(Degree)
  if self:IsCameraCustomizeRoleRotationDefault(Degree) then
    return true
  end
  if self:RefreshCameraCustomizeRoleRotationRegionOnlineInteractionState() then
    self:ShowCameraCustomizeRoleRotationRegionOnlineToast()
    return false
  end
  if self:IsCameraCustomizeRoleRotationBlockedByMount() then
    self:ShowCameraCustomizeRoleRotationMountToast()
    return false
  end
  if self:IsCameraCustomizeGamePaused() then
    return true
  end
  if self:IsCameraCustomizeRoleRotationBlockedByLookAt() then
    self:ShowCameraCustomizePauseToast("UI_CameraSystem_CannotEnableTimePause", "UI_CameraSystem_CannotTimePause", RoleRotationLookAtToastCooldownKey, RoleRotationToastCooldown)
    return false
  end
  if bEnableRoleRotationPauseGreenChannel and self.NotifyGamePauseChange then
    return self:NotifyGamePauseChange(true) ~= false
  end
  self:ShowCameraCustomizePauseToast("UI_CameraSystem_RequireTimePause", nil, "RoleRotation", RoleRotationToastCooldown)
  return false
end

function Component:ResetCameraCustomizeRoleRotationBeforeResume()
  if self:ResetCameraCustomizeRoleRotationToDefault() then
    return true
  end
  self:ShowCameraCustomizePauseToast("UI_CameraSystem_CannotDisableTimePause", "UI_CameraSystem_CannotTimeResume")
  return false
end

function Component:HasCameraCustomizePausedRequirement()
  return self.bCameraCustomizeRoleRotationChanged == true
end

function Component:CanChangeCameraCustomizePause(IsGamePause)
  if true == IsGamePause and self:HasCameraCustomizeRunningRequirement() then
    self:ShowCameraCustomizePauseToast("UI_CameraSystem_CannotEnableTimePause", "UI_CameraSystem_CannotTimePause")
    return false
  end
  if false == IsGamePause and self:HasCameraCustomizePausedRequirement() then
    return self:ResetCameraCustomizeRoleRotationBeforeResume()
  end
  return true
end

function Component:CanPlayWheelAction(ResourceId, Content)
  if Content and Content.IsDefaultAction or 0 == tonumber(ResourceId) then
    return true
  end
  if self:IsCameraCustomizeGamePaused() then
    return self:CanUseWheelActionWithPauseGreenChannel(ResourceId, Content)
  end
  return true
end

function Component:CanUseWheelActionWithPauseGreenChannel(ResourceId, Content)
  if not bEnableWheelActionPauseGreenChannel then
    self:ShowCameraCustomizePauseToast("UI_CameraSystem_RequireTimeResume")
    return false
  end
  if self.NotifyGamePauseChange and self:NotifyGamePauseChange(false) ~= false then
    return true
  end
  return false
end

function Component:HasCameraCustomizeRunningRequirement()
  if self.bCameraCustomizeLookAtCameraEnabled == true then
    return true
  end
  return not bEnableWheelActionPauseGreenChannel and self.CameraCustomizeActiveWheelActionResourceId ~= nil
end

function Component:GetCameraCustomizeRoleActor()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player and (not IsValid or IsValid(Player)) then
    return Player
  end
  return nil
end

function Component:GetCameraCustomizePlayerCharacter()
  return self:GetCameraCustomizeRoleActor()
end

function Component:GetCameraCustomizeActiveCameraLocation()
  local CameraComponent = self.GetCameraComponent and self:GetCameraComponent()
  if not CameraComponent and self.Camera and self.Camera.GetActiveCamera then
    CameraComponent = self.Camera:GetActiveCamera()
  end
  if CameraComponent and (not IsValid or IsValid(CameraComponent)) and CameraComponent.K2_GetComponentLocation then
    return CameraComponent:K2_GetComponentLocation()
  end
  return nil
end

function Component:CaptureCameraCustomizeInitialRoleRotation(bKeepValue)
  self.CustomizeValues = self.CustomizeValues or {}
  if not bKeepValue then
    self.CustomizeValues[RoleRotationItemId] = RoleRotationDefaultValue
  end
  self.CameraCustomizeRoleActor = self:GetCameraCustomizeRoleActor()
  self.CameraCustomizeInitialRoleRotation = self.CameraCustomizeRoleActor and self.CameraCustomizeRoleActor:K2_GetActorRotation() or nil
  self.bCameraCustomizeRoleRotationChanged = false
end

function Component:HandleRoleRotationChanged(Degree)
  if self.bCameraCustomizeInitializing then
    return true
  end
  Degree = math.clamp(tonumber(Degree) or RoleRotationDefaultValue, RoleRotationMinValue, RoleRotationMaxValue)
  self.CustomizeValues[RoleRotationItemId] = Degree
  if not (self.CameraCustomizeInitialRoleRotation and self.CameraCustomizeRoleActor) or IsValid and not IsValid(self.CameraCustomizeRoleActor) then
    self:CaptureCameraCustomizeInitialRoleRotation(true)
  end
  local Player = self.CameraCustomizeRoleActor
  local InitialRotation = self.CameraCustomizeInitialRoleRotation
  if not Player or not InitialRotation then
    return
  end
  local TargetRotation = FRotator(InitialRotation.Pitch, InitialRotation.Yaw + Degree - RoleRotationDefaultValue, InitialRotation.Roll)
  Player:K2_SetActorRotation(TargetRotation, false, nil, true)
  self.bCameraCustomizeRoleRotationChanged = not self:IsCameraCustomizeRoleRotationDefault(Degree)
  self.bHasAnyOperation = true
  return true
end

function Component:RestoreCameraCustomizeRoleRotation()
  if not self.bCameraCustomizeRoleRotationChanged then
    return
  end
  local Player = self.CameraCustomizeRoleActor
  if not Player or IsValid and not IsValid(Player) then
    Player = self:GetCameraCustomizeRoleActor()
  end
  if Player and self.CameraCustomizeInitialRoleRotation then
    Player:K2_SetActorRotation(self.CameraCustomizeInitialRoleRotation, false, nil, true)
  end
  self.CustomizeValues[RoleRotationItemId] = RoleRotationDefaultValue
  self.bCameraCustomizeRoleRotationChanged = false
  if self.Customize and self.Customize.RefreshValue then
    self.Customize:RefreshValue()
  end
end

function Component:ResetCameraCustomizeRoleRotationToDefault()
  local ItemConfig = Config.Items and Config.Items[RoleRotationItemId]
  local bSuccess = true
  if ItemConfig then
    bSuccess = self:NotifyCustomizeValueChanged(ItemConfig, RoleRotationDefaultValue)
  else
    bSuccess = self:HandleRoleRotationChanged(RoleRotationDefaultValue)
  end
  if false == bSuccess then
    return false
  end
  self.CustomizeValues = self.CustomizeValues or {}
  self.CustomizeValues[RoleRotationItemId] = RoleRotationDefaultValue
  self.bCameraCustomizeRoleRotationChanged = false
  if self.Customize and self.Customize.RefreshValue then
    self.Customize:RefreshValue()
  end
  return true
end

function Component:RestoreCameraCustomizeLookAtTickableState()
  local TickableStates = self.CameraCustomizeLookAtTickableStates
  if not TickableStates then
    return
  end
  for Target, bTickableWhenPaused in pairs(TickableStates) do
    if Target and (not IsValid or IsValid(Target)) and Target.SetTickableWhenPaused then
      Target:SetTickableWhenPaused(true == bTickableWhenPaused)
    end
  end
  self.CameraCustomizeLookAtTickableStates = nil
end

function Component:BuildCameraCustomizeLookAtInfo(CameraLocation)
  return {
    TargetLocation = CameraLocation,
    TurnHeadParam = {bLookUseCamera = false, bIsLookAt = true}
  }
end

function Component:ApplyCameraCustomizeAnimBlueprintLookAtTarget(AnimInstance, CameraLocation)
  if not AnimInstance or not CameraLocation then
    return false
  end
  local CurrentTarget = TryReadObjectField(AnimInstance, "LookAtTarget")
  if nil == CurrentTarget or type(CurrentTarget) == "string" then
    return false
  end
  if nil == self.CameraCustomizeOriginalAnimLookAtTarget then
    self.CameraCustomizeOriginalAnimLookAtTarget = CurrentTarget
  end
  self.CameraCustomizeLookAtAnimInstance = AnimInstance
  return TryWriteObjectField(AnimInstance, "LookAtTarget", CameraLocation)
end

function Component:ApplyCameraCustomizeAnimBlueprintLookAtRuntimeValues(AnimInstance)
  if not AnimInstance then
    return false
  end
  local CurrentSmoothZ = TryReadObjectField(AnimInstance, "SmoothLookatAddRotationZ")
  if nil == CurrentSmoothZ or type(CurrentSmoothZ) == "string" then
    return false
  end
  local Yaw = GetRotatorYaw(TryReadObjectField(AnimInstance, "LookAtAddRotation"))
  if not Yaw then
    return false
  end
  if nil == self.CameraCustomizeOriginalSmoothLookatAddRotationZ then
    self.CameraCustomizeOriginalSmoothLookatAddRotationZ = CurrentSmoothZ
  end
  self.CameraCustomizeLookAtAnimInstance = AnimInstance
  return TryWriteObjectField(AnimInstance, "SmoothLookatAddRotationZ", Yaw)
end

function Component:RestoreCameraCustomizeAnimBlueprintLookAtRuntimeValues(Player)
  if self.CameraCustomizeOriginalSmoothLookatAddRotationZ == nil then
    return
  end
  local AnimInstance = Player and Player.PlayerAnimInstance or self.CameraCustomizeLookAtAnimInstance
  if AnimInstance then
    TryWriteObjectField(AnimInstance, "SmoothLookatAddRotationZ", self.CameraCustomizeOriginalSmoothLookatAddRotationZ)
  end
  self.CameraCustomizeOriginalSmoothLookatAddRotationZ = nil
end

function Component:RestoreCameraCustomizeAnimBlueprintLookAtTarget(Player)
  if self.CameraCustomizeOriginalAnimLookAtTarget == nil then
    return
  end
  local AnimInstance = Player and Player.PlayerAnimInstance or self.CameraCustomizeLookAtAnimInstance
  if AnimInstance then
    TryWriteObjectField(AnimInstance, "LookAtTarget", self.CameraCustomizeOriginalAnimLookAtTarget)
  end
  self.CameraCustomizeOriginalAnimLookAtTarget = nil
  self.CameraCustomizeLookAtAnimInstance = nil
end

function Component:ApplyCameraCustomizeLookAtTarget(Player, CameraLocation)
  if not (Player and Player.CurrentLookInfo and Player.PlayerAnimInstance and Player.PlayerAnimInstance.SetLookAtLocation) or not CameraLocation then
    return false
  end
  local LookInfo = Player.CurrentLookInfo
  LookInfo.TargetLocation = CameraLocation
  LookInfo.TurnHeadParam = LookInfo.TurnHeadParam or {}
  LookInfo.TurnHeadParam.bLookUseCamera = false
  LookInfo.TurnHeadParam.bIsLookAt = true
  if Player.SetLookAtParam then
    Player:SetLookAtParam()
  else
    Player.PlayerAnimInstance.bLookUseCamera = false
    Player.PlayerAnimInstance.bIsLookAt = true
    Player.PlayerAnimInstance:SetLookAtLocation(CameraLocation)
  end
  self:ApplyCameraCustomizeAnimBlueprintLookAtTarget(Player.PlayerAnimInstance, CameraLocation)
  self:ApplyCameraCustomizeAnimBlueprintLookAtRuntimeValues(Player.PlayerAnimInstance)
  return true
end

function Component:StartCameraCustomizeLookAtCamera()
  local Player = self:GetCameraCustomizePlayerCharacter()
  local CameraLocation = self:GetCameraCustomizeActiveCameraLocation()
  if not (Player and Player.StartLookAt and Player.PlayerAnimInstance and Player.PlayerAnimInstance.SetLookAtLocation) or not CameraLocation then
    return false
  end
  if not self.bCameraCustomizeLookAtCameraEnabled or Player.CurrentLookType ~= LookAtCameraType or not Player.CurrentLookInfo then
    Player:StartLookAt(LookAtCameraType, self:BuildCameraCustomizeLookAtInfo(CameraLocation))
  end
  if Player.CurrentLookType ~= LookAtCameraType or not Player.CurrentLookInfo then
    return false
  end
  if not self:ApplyCameraCustomizeLookAtTarget(Player, CameraLocation) then
    return false
  end
  self.CameraCustomizeLookAtPlayer = Player
  self.bCameraCustomizeLookAtCameraEnabled = true
  return true
end

function Component:UpdateCameraCustomizeLookAtCamera()
  if not self.bCameraCustomizeLookAtCameraEnabled then
    return false
  end
  local Player = self.CameraCustomizeLookAtPlayer
  if not Player or IsValid and not IsValid(Player) then
    Player = self:GetCameraCustomizePlayerCharacter()
    self.CameraCustomizeLookAtPlayer = Player
  end
  local CameraLocation = self:GetCameraCustomizeActiveCameraLocation()
  if not (Player and Player.StartLookAt and Player.PlayerAnimInstance and Player.PlayerAnimInstance.SetLookAtLocation) or not CameraLocation then
    return false
  end
  if Player.CurrentLookType ~= LookAtCameraType or not Player.CurrentLookInfo then
    Player:StartLookAt(LookAtCameraType, self:BuildCameraCustomizeLookAtInfo(CameraLocation))
  end
  if Player.CurrentLookType ~= LookAtCameraType or not Player.CurrentLookInfo then
    return false
  end
  if not self:ApplyCameraCustomizeLookAtTarget(Player, CameraLocation) then
    return false
  end
  self.CameraCustomizeLookAtPlayer = Player
  return true
end

function Component:StopCameraCustomizeLookAtCamera()
  local Player = self.CameraCustomizeLookAtPlayer
  if not Player or IsValid and not IsValid(Player) then
    Player = self:GetCameraCustomizePlayerCharacter()
  end
  if Player and Player.StopLookAt and Player.CurrentLookType == LookAtCameraType then
    Player:StopLookAt(LookAtCameraType)
  end
  self:RestoreCameraCustomizeAnimBlueprintLookAtRuntimeValues(Player)
  self:RestoreCameraCustomizeAnimBlueprintLookAtTarget(Player)
  self.CameraCustomizeLookAtPlayer = nil
  self.bCameraCustomizeLookAtCameraEnabled = false
  self:RestoreCameraCustomizeLookAtTickableState()
end

function Component:SyncCameraCustomizeLookAtCameraFromValue()
  local ItemConfig = Config.Items and Config.Items.LookAtCamera
  if not ItemConfig then
    return
  end
  if self:GetCustomizeValue(ItemConfig) == true then
    if self:CanApplyLookAtCamera(true, true) then
      if self:StartCameraCustomizeLookAtCamera() == false then
        self.CustomizeValues[ItemConfig.Id] = false
        self:SetCachedCustomizeValue(ItemConfig, false)
        self:StopCameraCustomizeLookAtCamera()
      end
    else
      self.CustomizeValues[ItemConfig.Id] = false
      self:SetCachedCustomizeValue(ItemConfig, false)
      self:StopCameraCustomizeLookAtCamera()
    end
  else
    self:StopCameraCustomizeLookAtCamera()
  end
end

function Component:GetControlSwitchItem(SelectionConfig)
  if not SelectionConfig then
    return nil
  end
  for _, ItemConfig in pairs(Config.Items or {}) do
    if ItemConfig.ControlSelection == SelectionConfig.Id then
      return ItemConfig
    end
  end
  return nil
end

function Component:GetSelectionOptionConfig(SelectionConfig, OptionId)
  if not SelectionConfig then
    return nil
  end
  for _, Option in ipairs(SelectionConfig.Options or {}) do
    if Option.Id == OptionId then
      return Option
    end
  end
  return nil
end

function Component:BuildCustomizeSelectionValue(SelectionConfig)
  local Value = {}
  local StoredValue = self.CustomizeValues and self.CustomizeValues[SelectionConfig.Id]
  local ControlSwitchItem = self:GetControlSwitchItem(SelectionConfig)
  for _, Option in ipairs(SelectionConfig.Options or {}) do
    local CachedValue = self:GetCachedCustomizeValue(SelectionConfig, Option.Id)
    if nil ~= CachedValue then
      Value[Option.Id] = true == CachedValue
    elseif type(StoredValue) == "table" and StoredValue[Option.Id] ~= nil then
      Value[Option.Id] = StoredValue[Option.Id] == true
    elseif ControlSwitchItem then
      Value[Option.Id] = false
      self:SetCachedCustomizeValue(SelectionConfig, false, Option.Id)
    else
      Value[Option.Id] = SelectionConfig.DefaultValue and true == SelectionConfig.DefaultValue[Option.Id]
    end
  end
  return Value
end

function Component:DispatchCustomizeHandler(ItemConfig, Value, Extra)
  local HandlerName = ItemConfig and ItemConfig.Handler
  local Handler = HandlerName and self.Handlers and self.Handlers[HandlerName]
  if not Handler then
    return
  end
  if ItemConfig.Type == Utils.ItemType.Selection then
    Handler(Extra or ItemConfig.Id, Value)
  else
    Handler(Value)
  end
end

function Component:NotifyCustomizeValueChanged(ItemConfig, Value, Extra)
  if not ItemConfig then
    return false
  end
  if ItemConfig.Id == WheelActionItemId and Extra and Extra.IsForbiddenAction == true and true ~= Extra.IsDefaultAction then
    self.bCameraCustomizeWheelActionSelectionDirty = true
  end
  if ItemConfig.Id == "LookAtCamera" and not self:CanApplyLookAtCamera(true == Value) then
    return false
  elseif ItemConfig.Id == RoleRotationItemId and not self:CanApplyRoleRotation(Value) then
    return false
  elseif ItemConfig.Id == WheelActionItemId and not self:CanPlayWheelAction(Value, Extra) then
    return false
  end
  if ItemConfig.Id == "LookAtCamera" then
    if self:HandleLookAtCameraChanged(true == Value) == false then
      return false
    end
    self.CustomizeValues[ItemConfig.Id] = true == Value
    self:SetCachedCustomizeValue(ItemConfig, true == Value)
    self:ClearNew(ItemConfig.NewKey)
    return true
  end
  if ItemConfig.ControlSelection then
    self:SetCachedCustomizeValue(ItemConfig, true == Value)
    self:HandleTargetSelectionAllChanged(ItemConfig, Value)
    return true
  end
  if ItemConfig.Type == Utils.ItemType.Selection and Extra then
    local SelectionValue = self:BuildCustomizeSelectionValue(ItemConfig)
    SelectionValue[Extra] = true == Value
    self.CustomizeValues[ItemConfig.Id] = SelectionValue
    self:SetCachedCustomizeValue(ItemConfig, true == Value, Extra)
    self:ClearSelectionOptionNew(ItemConfig, Extra)
    self:RefreshControlSwitchBySelection(ItemConfig, SelectionValue)
    if false == self:ApplyTargetSelectionHiddenState(ItemConfig, SelectionValue) then
      return false
    end
  else
    self.CustomizeValues[ItemConfig.Id] = Value
    if ItemConfig.Type == Utils.ItemType.Switch then
      self:SetCachedCustomizeValue(ItemConfig, true == Value)
    end
  end
  self:ClearNew(ItemConfig.NewKey)
  if ItemConfig.Id == RoleRotationItemId then
    if false == self:HandleRoleRotationChanged(Value) then
      return false
    end
    self:DispatchCustomizeHandler(ItemConfig, Value, Extra)
  elseif ItemConfig.Id == WheelActionItemId then
    if false == self:HandleActionPlay(Value, Extra) then
      return false
    end
    self:DispatchCustomizeHandler(ItemConfig, Value, Extra)
  else
    self:DispatchCustomizeHandler(ItemConfig, Value, Extra)
  end
  return true
end

function Component:ClearSelectionOptionNew(SelectionConfig, OptionId)
  local OptionConfig = self:GetSelectionOptionConfig(SelectionConfig, OptionId)
  if OptionConfig then
    self:ClearNew(OptionConfig.NewKey)
  end
end

function Component:RefreshControlSwitchBySelection(SelectionConfig, SelectionValue)
  local ControlSwitchItem = self:GetControlSwitchItem(SelectionConfig)
  if not ControlSwitchItem then
    return
  end
  local bAllSelected = Utils.IsSelectionAllSelected(SelectionConfig, SelectionValue)
  self.CustomizeValues[ControlSwitchItem.Id] = bAllSelected
  self:SetCachedCustomizeValue(ControlSwitchItem, bAllSelected)
end

function Component:HandleLookAtCameraChanged(IsOn)
  if IsOn then
    if self:StartCameraCustomizeLookAtCamera() == false then
      return false
    end
  else
    self:StopCameraCustomizeLookAtCamera()
  end
  local Handler = self.Handlers and self.Handlers.OnLookAtCameraChanged
  if Handler then
    Handler(IsOn)
  end
  self.bHasAnyOperation = true
  return true
end

function Component:RefreshCameraCustomizeActionList()
  if self.Customize and self.Customize.RefreshValue then
    self.Customize:RefreshValue()
  elseif self.Customize and self.Customize.RefreshPanel then
    self.Customize:RefreshPanel()
  end
end

function Component:InitCameraCustomizeWheelActionState()
  self.CameraCustomizeWheelActionState = WheelActionStateIdle
  self.CameraCustomizePendingWheelAction = nil
  self.CameraCustomizeWheelActionRequestSerial = (self.CameraCustomizeWheelActionRequestSerial or 0) + 1
  self.CameraCustomizeWheelActionStateStartTime = 0
  self.CameraCustomizeWheelActionWaitingResourceId = nil
  self.CameraCustomizeWheelActionCurrentRequestId = nil
  self.CameraCustomizeWheelActionStopConfirmed = false
  self.CameraCustomizeWheelActionTerminated = false
  self.CameraCustomizeActiveWheelActionResourceId = nil
  self.bCameraCustomizeWheelActionExitOperation = false
  self.bCameraCustomizeWheelActionSelectionDirty = false
end

function Component:HasCameraCustomizeExitOperation()
  return self.bCameraCustomizeWheelActionExitOperation == true or true == self.bCameraCustomizeWheelActionSelectionDirty
end

function Component:GetCameraCustomizeWheelActionNow()
  return UE4.UGameplayStatics.GetRealTimeSeconds(self)
end

function Component:GetCameraCustomizeWheelActionAnimInstance(Player)
  if not Player then
    return nil
  end
  if Player.Mesh and Player.Mesh.GetAnimInstance then
    local AnimInstance = Player.Mesh:GetAnimInstance()
    if AnimInstance then
      Player.PlayerAnimInstance = AnimInstance
      return AnimInstance
    end
  end
  return Player.PlayerAnimInstance
end

function Component:IsCameraCustomizeWheelActionIdleTag(AnimInstance)
  return AnimInstance and tostring(AnimInstance.IdleTagName) == "Gesture01_Idle"
end

function Component:IsCameraCustomizeWheelActionMontagePlaying(AnimInstance)
  if not AnimInstance then
    return nil
  end
  local CheckFunc = AnimInstance.IsAnyMontagePlaying or AnimInstance.IsAnymontagePlaying
  if not CheckFunc then
    return nil
  end
  local bSuccess, bPlaying = pcall(CheckFunc, AnimInstance)
  if not bSuccess then
    return nil
  end
  return true == bPlaying
end

function Component:HasCameraCustomizeOnlineActionMechanism()
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar()
  if not (Avatar and Avatar.IsInRegionOnline) or not Avatar.Eid then
    return false
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local MechanismMap = GameState and GameState.PlayerRegionOnlineMechanismMap
  if not MechanismMap or not MechanismMap.Find then
    return false
  end
  local MechanismList = MechanismMap:Find(CommonUtils.ObjId2Str(Avatar.Eid))
  if not MechanismList or not MechanismList.Array then
    return false
  end
  for _ in pairs(MechanismList.Array) do
    return true
  end
  return false
end

function Component:HasCameraCustomizeWheelActionRuntimeState()
  local Player = self:GetCameraCustomizePlayerCharacter()
  local AnimInstance = self:GetCameraCustomizeWheelActionAnimInstance(Player)
  return self.CameraCustomizeActiveWheelActionResourceId ~= nil or Player and 0 ~= tonumber(Player.CurResourceId or 0) or self:IsCameraCustomizeWheelActionIdleTag(AnimInstance) or self:HasCameraCustomizeOnlineActionMechanism()
end

function Component:IsCameraCustomizeWheelActionActivationObserved(ResourceId)
  local Player = self:GetCameraCustomizePlayerCharacter()
  if Player and tonumber(Player.CurResourceId or 0) == tonumber(ResourceId) then
    return true
  end
  local AnimInstance = self:GetCameraCustomizeWheelActionAnimInstance(Player)
  return self:IsCameraCustomizeWheelActionIdleTag(AnimInstance)
end

function Component:CancelCameraCustomizeWheelActionNow()
  local Player = self:GetCameraCustomizePlayerCharacter()
  if not Player then
    self.CameraCustomizeActiveWheelActionResourceId = nil
    return true
  end
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar()
  local AnimInstance = self:GetCameraCustomizeWheelActionAnimInstance(Player)
  local IdleTagName = AnimInstance and AnimInstance.IdleTagName
  local bWasResourceIdle = self:IsCameraCustomizeWheelActionIdleTag(AnimInstance)
  if not bWasResourceIdle and Player.IsArmoryIdleTag and IdleTagName then
    local bSuccess, bIsArmoryIdle = pcall(Player.IsArmoryIdleTag, Player, IdleTagName)
    bWasResourceIdle = bSuccess and true == bIsArmoryIdle
  end
  local bHadActionState = self.CameraCustomizeActiveWheelActionResourceId ~= nil or 0 ~= tonumber(Player.CurResourceId or 0) or bWasResourceIdle or self:HasCameraCustomizeOnlineActionMechanism()
  if not bHadActionState then
    return true
  end
  local bMontagePlaying = self:IsCameraCustomizeWheelActionMontagePlaying(AnimInstance)
  local bLeaveChainTriggered = bWasResourceIdle and false ~= bMontagePlaying
  if AnimInstance and AnimInstance.ResetIdleTag then
    AnimInstance:ResetIdleTag()
  end
  if not bLeaveChainTriggered or self:IsCameraCustomizeWheelActionIdleTag(AnimInstance) then
    if Player.ResetResourceGesture then
      Player:ResetResourceGesture()
    end
    if Player.OnLeaveGesture01_Idle then
      Player:OnLeaveGesture01_Idle()
    elseif Avatar and Avatar.IsInRegionOnline and Avatar.RequestCancelGestureOnline then
      Avatar:RequestCancelGestureOnline(Player)
    end
  end
  Player.CurResourceId = 0
  return true
end

function Component:BeginCameraCustomizeWheelActionStop()
  if self.CameraCustomizeWheelActionState == WheelActionStateStopping then
    return
  end
  self.CameraCustomizeWheelActionState = WheelActionStateStopping
  self.CameraCustomizeWheelActionStateStartTime = self:GetCameraCustomizeWheelActionNow()
  self.CameraCustomizeWheelActionStopConfirmed = false
  self:CancelCameraCustomizeWheelActionNow()
end

function Component:IsCameraCustomizeWheelActionStopComplete()
  local Player = self:GetCameraCustomizePlayerCharacter()
  local AnimInstance = self:GetCameraCustomizeWheelActionAnimInstance(Player)
  return not self:IsCameraCustomizeWheelActionIdleTag(AnimInstance) and (not Player or 0 == tonumber(Player.CurResourceId or 0)) and not self:HasCameraCustomizeOnlineActionMechanism()
end

function Component:CompleteCameraCustomizeWheelActionStop()
  local PendingAction = self.CameraCustomizePendingWheelAction
  self.CameraCustomizeActiveWheelActionResourceId = nil
  self.CameraCustomizeWheelActionWaitingResourceId = nil
  self.CameraCustomizeWheelActionCurrentRequestId = nil
  self.CameraCustomizeWheelActionStopConfirmed = false
  self.CameraCustomizeWheelActionState = WheelActionStateIdle
  self:ProcessCameraCustomizePendingWheelAction()
  if not PendingAction then
    self:RefreshCameraCustomizeActionList()
  end
end

function Component:OnCameraCustomizeWheelActionRequestFinished(RequestSerial, ResourceId, bUseSuccess)
  if RequestSerial ~= self.CameraCustomizeWheelActionRequestSerial or self.CameraCustomizeWheelActionTerminated then
    if bUseSuccess then
      self.CameraCustomizeActiveWheelActionResourceId = ResourceId
      self:CancelCameraCustomizeWheelActionNow()
      self.CameraCustomizeActiveWheelActionResourceId = nil
    end
    return
  end
  self.CameraCustomizeWheelActionCurrentRequestId = nil
  if not bUseSuccess then
    local PendingAction = self.CameraCustomizePendingWheelAction
    self.CameraCustomizeActiveWheelActionResourceId = nil
    self.bCameraCustomizeWheelActionExitOperation = false
    self.CameraCustomizeWheelActionState = WheelActionStateIdle
    self:ProcessCameraCustomizePendingWheelAction()
    if not PendingAction then
      self:RefreshCameraCustomizeActionList()
    end
    return
  end
  self.CameraCustomizeActiveWheelActionResourceId = ResourceId
  self.bCameraCustomizeWheelActionExitOperation = true
  self:RefreshCameraCustomizeActionList()
  if self.CameraCustomizePendingWheelAction then
    self.CameraCustomizeWheelActionState = WheelActionStateWaitingActivation
    self.CameraCustomizeWheelActionWaitingResourceId = ResourceId
    self.CameraCustomizeWheelActionStateStartTime = self:GetCameraCustomizeWheelActionNow()
  else
    self.CameraCustomizeWheelActionState = WheelActionStateIdle
  end
end

function Component:StartCameraCustomizeWheelAction(ResourceId)
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar()
  if not (Avatar and Avatar.UseWheelItemInBattle) or not ResourceId then
    self.CameraCustomizeWheelActionState = WheelActionStateIdle
    return false
  end
  self.CameraCustomizeWheelActionRequestSerial = (self.CameraCustomizeWheelActionRequestSerial or 0) + 1
  local RequestSerial = self.CameraCustomizeWheelActionRequestSerial
  self.CameraCustomizeWheelActionCurrentRequestId = ResourceId
  self.CameraCustomizeWheelActionState = WheelActionStateStarting
  self.CameraCustomizeWheelActionStateStartTime = self:GetCameraCustomizeWheelActionNow()
  Avatar:UseWheelItemInBattle(ResourceId, function(bUseSuccess)
    self:OnCameraCustomizeWheelActionRequestFinished(RequestSerial, ResourceId, bUseSuccess)
  end)
  return true
end

function Component:ProcessCameraCustomizePendingWheelAction()
  local PendingAction = self.CameraCustomizePendingWheelAction
  if not PendingAction or self.CameraCustomizeWheelActionState ~= WheelActionStateIdle then
    return
  end
  if 0 == tonumber(PendingAction.ResourceId) then
    if self.CameraCustomizeActiveWheelActionResourceId and not self:IsCameraCustomizeWheelActionActivationObserved(self.CameraCustomizeActiveWheelActionResourceId) then
      self.CameraCustomizeWheelActionState = WheelActionStateWaitingActivation
      self.CameraCustomizeWheelActionWaitingResourceId = self.CameraCustomizeActiveWheelActionResourceId
      self.CameraCustomizeWheelActionStateStartTime = self:GetCameraCustomizeWheelActionNow()
      return
    end
    self.CameraCustomizePendingWheelAction = nil
    if self:HasCameraCustomizeWheelActionRuntimeState() then
      self:BeginCameraCustomizeWheelActionStop()
    end
    return
  end
  if self.CameraCustomizeActiveWheelActionResourceId and not self:IsCameraCustomizeWheelActionActivationObserved(self.CameraCustomizeActiveWheelActionResourceId) then
    self.CameraCustomizeWheelActionState = WheelActionStateWaitingActivation
    self.CameraCustomizeWheelActionWaitingResourceId = self.CameraCustomizeActiveWheelActionResourceId
    self.CameraCustomizeWheelActionStateStartTime = self:GetCameraCustomizeWheelActionNow()
    return
  end
  if self:HasCameraCustomizeWheelActionRuntimeState() then
    self:BeginCameraCustomizeWheelActionStop()
    return
  end
  self.CameraCustomizePendingWheelAction = nil
  if self:StartCameraCustomizeWheelAction(PendingAction.ResourceId) == false then
    self:RefreshCameraCustomizeActionList()
  end
end

function Component:QueueCameraCustomizeWheelAction(ResourceId)
  if self.CameraCustomizeWheelActionTerminated then
    return false
  end
  self.CameraCustomizePendingWheelAction = {
    ResourceId = tonumber(ResourceId) or 0
  }
  self:ProcessCameraCustomizePendingWheelAction()
  return true
end

function Component:UpdateCameraCustomizeWheelActionTransition()
  local State = self.CameraCustomizeWheelActionState
  if State == WheelActionStateWaitingActivation then
    local ResourceId = self.CameraCustomizeWheelActionWaitingResourceId
    local bTimedOut = self:GetCameraCustomizeWheelActionNow() - self.CameraCustomizeWheelActionStateStartTime >= WheelActionTransitionTimeout
    if self:IsCameraCustomizeWheelActionActivationObserved(ResourceId) or bTimedOut then
      self:BeginCameraCustomizeWheelActionStop()
    end
    return
  end
  if State ~= WheelActionStateStopping then
    return
  end
  if self:GetCameraCustomizeWheelActionNow() - self.CameraCustomizeWheelActionStateStartTime >= WheelActionTransitionTimeout then
    self.CameraCustomizePendingWheelAction = nil
    self.CameraCustomizeActiveWheelActionResourceId = nil
    self.CameraCustomizeWheelActionWaitingResourceId = nil
    self.CameraCustomizeWheelActionStopConfirmed = false
    self.CameraCustomizeWheelActionState = WheelActionStateIdle
    return
  end
  if not self:IsCameraCustomizeWheelActionStopComplete() then
    self.CameraCustomizeWheelActionStopConfirmed = false
    return
  end
  if not self.CameraCustomizeWheelActionStopConfirmed then
    self.CameraCustomizeWheelActionStopConfirmed = true
    return
  end
  self:CompleteCameraCustomizeWheelActionStop()
end

function Component:ResetCameraCustomizeWheelActionSelection()
  self.CameraCustomizeSelectedActionId = 0
  if self.Customize then
    self.Customize.CameraCustomizeSelectedActionId = 0
  end
end

function Component:StopCameraCustomizeWheelAction()
  self.CameraCustomizeWheelActionTerminated = true
  self.CameraCustomizeWheelActionRequestSerial = (self.CameraCustomizeWheelActionRequestSerial or 0) + 1
  self.CameraCustomizePendingWheelAction = nil
  self.CameraCustomizeWheelActionState = WheelActionStateIdle
  self.CameraCustomizeWheelActionWaitingResourceId = nil
  self.CameraCustomizeWheelActionCurrentRequestId = nil
  self.CameraCustomizeWheelActionStopConfirmed = false
  self:CancelCameraCustomizeWheelActionNow()
  self.CameraCustomizeActiveWheelActionResourceId = nil
  self.bCameraCustomizeWheelActionExitOperation = false
  self.bCameraCustomizeWheelActionSelectionDirty = false
  self:ResetCameraCustomizeWheelActionSelection()
  self:RefreshCameraCustomizeActionList()
  return true
end

function Component:HandleActionPlay(ResourceId, Content)
  if Content and Content.IsDefaultAction or 0 == tonumber(ResourceId) then
    self.bCameraCustomizeWheelActionExitOperation = false
    return self:QueueCameraCustomizeWheelAction(0)
  end
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar()
  if not (Avatar and Avatar.UseWheelItemInBattle) or not ResourceId then
    return false
  end
  local Resource = Avatar.Resources and Avatar.Resources[ResourceId]
  if not Utils.IsWheelActionResource(Resource) then
    return false
  end
  return self:QueueCameraCustomizeWheelAction(ResourceId)
end

function Component:GetTargetSelectionHiddenMask()
  local CharType = self.CharType
  if not CharType then
    return 0
  end
  local HiddenMask = 0
  for _, CharTypeKey in pairs(TargetSelectionCharTypeKey) do
    local CharacterType = CharType[CharTypeKey]
    if CharacterType then
      HiddenMask = HiddenMask | CharacterType
    end
  end
  return HiddenMask
end

function Component:ApplyTargetSelectionHiddenState(SelectionConfig, SelectionValue)
  if not SelectionConfig or SelectionConfig.Id ~= TargetSelectionItemId then
    return true
  end
  if not self.SetCharHiddengState or not self.CharType then
    return false
  end
  local HiddenMask = self:GetTargetSelectionHiddenMask()
  local NewHiddenState = (self.CurCharHiddenState or 0) & ((self.CharType.All or HiddenMask) ~ HiddenMask)
  for OptionId, bSelected in pairs(SelectionValue or {}) do
    local CharTypeKey = TargetSelectionCharTypeKey[OptionId]
    local CharacterType = CharTypeKey and self.CharType[CharTypeKey]
    if CharacterType and true == bSelected then
      NewHiddenState = NewHiddenState | CharacterType
    end
  end
  if NewHiddenState ~= (self.CurCharHiddenState or 0) then
    self:SetCharHiddengState(NewHiddenState)
  end
  return true
end

function Component:HandleTargetSelectionAllChanged(ItemConfig, Value)
  local SelectionConfig = Config.Items[ItemConfig.ControlSelection]
  if not SelectionConfig then
    return
  end
  local bSelected = true == Value
  local SelectionValue = self:BuildCustomizeSelectionValue(SelectionConfig)
  local HandlerName = SelectionConfig.Handler
  local Handler = HandlerName and self.Handlers and self.Handlers[HandlerName]
  for _, Option in ipairs(SelectionConfig.Options or {}) do
    SelectionValue[Option.Id] = bSelected
    self:SetCachedCustomizeValue(SelectionConfig, bSelected, Option.Id)
    self:ClearNew(Option.NewKey)
    if Handler then
      Handler(Option.Id, bSelected)
    end
  end
  self.CustomizeValues[SelectionConfig.Id] = SelectionValue
  self.CustomizeValues[ItemConfig.Id] = bSelected
  self:ApplyTargetSelectionHiddenState(SelectionConfig, SelectionValue)
  self:ClearNew(ItemConfig.NewKey)
  self:ClearNew(SelectionConfig.NewKey)
end

function Component:GetCustomizeValue(ItemConfig)
  if not ItemConfig then
    return nil
  end
  if ItemConfig.ControlSelection then
    local CachedValue = self:GetCachedCustomizeValue(ItemConfig)
    if nil ~= CachedValue then
      self.CustomizeValues[ItemConfig.Id] = true == CachedValue
      return true == CachedValue
    end
    if nil ~= self.CustomizeValues[ItemConfig.Id] then
      return self.CustomizeValues[ItemConfig.Id] == true
    end
    local bDefaultValue = true == ItemConfig.DefaultValue
    self.CustomizeValues[ItemConfig.Id] = bDefaultValue
    self:SetCachedCustomizeValue(ItemConfig, bDefaultValue)
    return bDefaultValue
  end
  if ItemConfig.Type == Utils.ItemType.Selection then
    local SelectionValue = self:BuildCustomizeSelectionValue(ItemConfig)
    self.CustomizeValues[ItemConfig.Id] = SelectionValue
    return SelectionValue
  end
  if ItemConfig.Type == Utils.ItemType.Switch then
    local CachedValue = self:GetCachedCustomizeValue(ItemConfig)
    if nil ~= CachedValue then
      self.CustomizeValues[ItemConfig.Id] = true == CachedValue
      return true == CachedValue
    end
    if nil == self.CustomizeValues[ItemConfig.Id] then
      local bDefaultValue = true == ItemConfig.DefaultValue
      self.CustomizeValues[ItemConfig.Id] = bDefaultValue
      self:SetCachedCustomizeValue(ItemConfig, bDefaultValue)
      return bDefaultValue
    end
  end
  if nil ~= self.CustomizeValues[ItemConfig.Id] then
    return self.CustomizeValues[ItemConfig.Id]
  end
  return ItemConfig.DefaultValue
end

function Component:GetCacheKey(NewKey)
  return NewKey and Utils.CacheKeyPrefix .. NewKey or nil
end

function Component:IsNewVisible(NewKey)
  local CacheKey = self:GetCacheKey(NewKey)
  if not CacheKey then
    return false
  end
  return EMCache:Get(CacheKey, true) ~= true
end

function Component:ClearNew(NewKey)
  local CacheKey = self:GetCacheKey(NewKey)
  if not CacheKey then
    return
  end
  EMCache:Set(CacheKey, true, true)
  if self.Customize and self.Customize.RefreshNewState then
    self.Customize:RefreshNewState()
  end
  self:RefreshCameraCustomizeButtonNewState()
end

function Component:ClearItemNew(ItemConfig)
  if not ItemConfig then
    return
  end
  self:ClearNew(ItemConfig.NewKey)
end

function Component.HasNewInItem(Owner, ItemConfig)
  if not Owner or not ItemConfig then
    return false
  end
  if ItemConfig.Id == WheelActionItemId then
    return Utils.HasNewWheelActionResource()
  end
  if Owner:IsNewVisible(ItemConfig.NewKey) then
    return true
  end
  if ItemConfig.ControlSelection then
    local SelectionConfig = Config.Items[ItemConfig.ControlSelection]
    if SelectionConfig and Component.HasNewInItem(Owner, SelectionConfig) then
      return true
    end
  end
  for _, Action in ipairs(ItemConfig.Actions or {}) do
    if Owner:IsNewVisible(Action.NewKey) then
      return true
    end
  end
  for _, Option in ipairs(ItemConfig.Options or {}) do
    if Owner:IsNewVisible(Option.NewKey) then
      return true
    end
  end
  return false
end

return Component
