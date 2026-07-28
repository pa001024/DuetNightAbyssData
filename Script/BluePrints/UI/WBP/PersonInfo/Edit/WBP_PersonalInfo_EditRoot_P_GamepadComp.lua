local Component = {}
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local CAMERA_MOVE_KEY_MAP = {
  Gamepad_DPad_Up = "W",
  Gamepad_DPad_Down = "S",
  Gamepad_DPad_Left = "A",
  Gamepad_DPad_Right = "D"
}
local COMBO_HOLD_KEY = UIConst.GamePadKey.SpecialLeft

local function GetCameraInputConfig()
  return PersonInfoCommon.CameraInputConfig or {}
end

local function GetGameInputModeSubsystem(Owner)
  if IsValid(Owner.GameInputModeSubsystem) then
    return Owner.GameInputModeSubsystem
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(Owner, 0)
  if not PlayerController then
    return nil
  end
  Owner.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  return Owner.GameInputModeSubsystem
end

local function ShouldShowCharacterSlotSwitchGamepadKey(Owner)
  if Owner.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return false
  end
  if not Owner.PageController or not Owner.PageController:IsChoosePageActive() then
    return false
  end
  local ChooseMode = Owner.PageController.ActiveChooseMode
  return "Character" == ChooseMode or "Weapon" == ChooseMode or "Action" == ChooseMode
end

local function EnsureCharacterSlotSwitchGamepadKeyInitialized(Owner)
  if Owner.bCharacterSlotSwitchGamepadKeyInitialized then
    return
  end
  if Owner.Key_ListLeft and Owner.Key_ListLeft.CreateCommonKey then
    Owner.Key_ListLeft:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "LB",
          Owner = Owner
        }
      }
    })
    Owner.Key_ListLeft:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if Owner.Key_ListRight and Owner.Key_ListRight.CreateCommonKey then
    Owner.Key_ListRight:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "RB",
          Owner = Owner
        }
      }
    })
    Owner.Key_ListRight:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  Owner.bCharacterSlotSwitchGamepadKeyInitialized = true
end

local function RefreshCharacterSlotSwitchGamepadKeyState(Owner)
  if Owner.CurInputDeviceType == ECommonInputType.Gamepad then
    EnsureCharacterSlotSwitchGamepadKeyInitialized(Owner)
  end
  local Visibility = ShouldShowCharacterSlotSwitchGamepadKey(Owner) and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  if Owner.Key_ListLeft and Owner.Key_ListLeft.SetVisibility then
    Owner.Key_ListLeft:SetVisibility(Visibility)
  end
  if Owner.Key_ListRight and Owner.Key_ListRight.SetVisibility then
    Owner.Key_ListRight:SetVisibility(Visibility)
  end
end

local function EnsureAddButtonGamepadKeyInitialized(Owner)
  if Owner.bAddButtonGamepadKeyInitialized then
    return
  end
  if not Owner.Key_Add or not Owner.Key_Add.CreateCommonKey then
    return
  end
  Owner.Key_Add:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "X",
        ClickCallback = Owner.OnClickAdd,
        Owner = Owner
      }
    }
  })
  Owner.bAddButtonGamepadKeyInitialized = true
end

local function RefreshAddButtonGamepadKeyState(Owner, bShowAddButton)
  Owner.bShouldShowAddButtonGamepadKey = true == bShowAddButton
  local bIsGamepadInput = Owner.CurInputDeviceType == ECommonInputType.Gamepad
  if bIsGamepadInput then
    EnsureAddButtonGamepadKeyInitialized(Owner)
  end
  local Visibility = Owner.bShouldShowAddButtonGamepadKey == true and bIsGamepadInput and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  if Owner.Function_Add and Owner.Function_Add.SetVisibility then
    Owner.Function_Add:SetVisibility(Visibility)
  end
end

local function EnsureEditModelGamepadKeyInitialized(Owner)
  if Owner.bEditModelGamepadKeyInitialized then
    return
  end
  if not Owner.Key_EditModel or not Owner.Key_EditModel.CreateCommonKey then
    return
  end
  Owner.Key_EditModel:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "A",
        Owner = Owner
      }
    },
    Desc = GText("UI_PersonalPage_AdjustParameters")
  })
  if Owner.Group_Key and Owner.Group_Key.SetVisibility then
    Owner.Group_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif Owner.Key_EditModel and Owner.Key_EditModel.SetVisibility then
    Owner.Key_EditModel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  Owner.bEditModelGamepadKeyInitialized = true
end

local function ShouldShowEditModelGamepadKey(Owner)
  if not Owner.EditRootController then
    return false
  end
  if Owner.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return false
  end
  if not Owner.EditRootController:IsCharacterMainPageActive() then
    return false
  end
  local SlotIndex = Owner.EditRootController:GetSelectedCharacterSlotIndex()
  local Content = Owner.CharacterSlotItemContents and Owner.CharacterSlotItemContents[SlotIndex] or nil
  if not Content or Content.HasCharacter ~= true or true ~= Content.CanInteract then
    return false
  end
  local EntryWidget = Owner.CharacterSlotEntryWidgetMap and Owner.CharacterSlotEntryWidgetMap[SlotIndex] or nil
  if not IsValid(EntryWidget) then
    return false
  end
  return EntryWidget:HasAnyUserFocus() or EntryWidget:HasFocusedDescendants()
end

local function RefreshEditModelGamepadKeyState(Owner)
  local bIsGamepadInput = Owner.CurInputDeviceType == ECommonInputType.Gamepad
  if bIsGamepadInput then
    EnsureEditModelGamepadKeyInitialized(Owner)
  end
  local Visibility = ShouldShowEditModelGamepadKey(Owner) and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  if Owner.Group_Key and Owner.Group_Key.SetVisibility then
    Owner.Group_Key:SetVisibility(Visibility)
    return
  end
  if Owner.Key_EditModel and Owner.Key_EditModel.SetVisibility then
    Owner.Key_EditModel:SetVisibility(Visibility)
  end
end

function Component:FirstInitGamePadView()
  if self.bCustomEditGamepadViewInitialized then
    return
  end
  local GameInputModeSubsystem = GetGameInputModeSubsystem(self)
  if not GameInputModeSubsystem then
    return
  end
  self.GameInputModeSubsystem = GameInputModeSubsystem
  EnsureCharacterSlotSwitchGamepadKeyInitialized(self)
  EnsureAddButtonGamepadKeyInitialized(self)
  EnsureEditModelGamepadKeyInitialized(self)
  self.bCustomEditGamepadViewInitialized = true
  local CurInputType = GameInputModeSubsystem.GetCurrentInputType and GameInputModeSubsystem:GetCurrentInputType() or nil
  local CurGamepadName = GameInputModeSubsystem.GetCurrentGamepadName and GameInputModeSubsystem:GetCurrentGamepadName() or nil
  if CurInputType == ECommonInputType.Gamepad then
    self:InitGamePadView(CurInputType, CurGamepadName)
    return
  end
  self:InitKeyboardView(CurInputType, CurGamepadName)
end

function Component:InitGamePadView(CurInputType, CurGamepadName)
  self.CurInputDeviceType = CurInputType
  self.CurGamepadName = CurGamepadName
  self.GamepadPressedKeyMap = self.GamepadPressedKeyMap or {}
  RefreshCharacterSlotSwitchGamepadKeyState(self)
  RefreshAddButtonGamepadKeyState(self, self.bShouldShowAddButtonGamepadKey == true)
  RefreshEditModelGamepadKeyState(self)
  self:ApplyCurrentEditStateGamepadFocus()
end

function Component:InitKeyboardView(CurInputType, CurGamepadName)
  self.CurInputDeviceType = CurInputType or ECommonInputType.MouseAndKeyboard
  self.CurGamepadName = CurGamepadName
  self.GamepadPressedKeyMap = {}
  self:_CancelScheduledGamepadDefaultFocus()
  RefreshCharacterSlotSwitchGamepadKeyState(self)
  RefreshAddButtonGamepadKeyState(self, self.bShouldShowAddButtonGamepadKey == true)
  RefreshEditModelGamepadKeyState(self)
end

function Component:RefreshCustomEditGamepadPageState()
  RefreshCharacterSlotSwitchGamepadKeyState(self)
  if self.EditRootController then
    RefreshAddButtonGamepadKeyState(self, self.EditRootController:GetActiveMainTabName() == "Char" and not self.EditRootController:IsChoosePageActive())
  end
  RefreshEditModelGamepadKeyState(self)
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self:FirstInitGamePadView()
  if CurInputType == ECommonInputType.Gamepad then
    self:InitGamePadView(CurInputType, CurGamepadName)
    return
  end
  self:InitKeyboardView(CurInputType, CurGamepadName)
end

function Component:ApplyCurrentEditStateGamepadFocus()
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  self:_CancelScheduledGamepadDefaultFocus()
  self:AddTimer(0.01, function()
    if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
      return
    end
    local ChoosePagePanel = self.PageController and self.PageController.ChoosePagePanel or nil
    if ChoosePagePanel and ChoosePagePanel.ShouldKeepCurrentGamepadFocus and ChoosePagePanel:ShouldKeepCurrentGamepadFocus() then
      self:RefreshCustomEditGamepadPageState()
      return
    end
    local CurrentState = self.PageController and self.PageController.GetCurrentEditUIState and self.PageController:GetCurrentEditUIState() or nil
    if CurrentState and CurrentState.ApplyGamepadInitialFocus then
      CurrentState:ApplyGamepadInitialFocus()
    else
      self:SetFocus_Lua()
    end
    self:RefreshCustomEditGamepadPageState()
  end, false, 0, "PersonInfoCustomEditGamepadDefaultFocus")
end

function Component:_CancelScheduledGamepadDefaultFocus()
  if self.IsExistTimer and self.RemoveTimer and self:IsExistTimer("PersonInfoCustomEditGamepadDefaultFocus") then
    self:RemoveTimer("PersonInfoCustomEditGamepadDefaultFocus")
  end
end

function Component:SetFocus_Lua()
  local FocusTarget = self.GetGamepadDefaultFocusTarget and self:GetGamepadDefaultFocusTarget() or nil
  if FocusTarget and FocusTarget.SetFocus then
    FocusTarget:SetFocus()
    return
  end
  self:SetFocus()
end

function Component:ApplyGamepadFocusToSelectedCharacterSlot()
  self:SetFocus_Lua()
end

function Component:HandleGamepadConfirmCharacterSlotFromEntry(Content, EntryWidget)
  if not (self.EditRootController and Content and Content.SlotIndex) or Content.CanInteract ~= true then
    return false
  end
  self:OnCharacterSlotEntryFocused(Content, EntryWidget)
  if not self.EditRootController:OpenSelectedCharacterDetailPanelWithoutFocus() then
    return false
  end
  local CharacterEditPanel = self.EditRootController.CharacterEditPanel
  if CharacterEditPanel and CharacterEditPanel.FocusGamepadDefaultPanelItem then
    CharacterEditPanel:FocusGamepadDefaultPanelItem()
  end
  self:RefreshCustomEditGamepadPageState()
  return true
end

function Component:Handle_KeyDownOnGamePad(InKeyName)
  if not self.PageController then
    return false
  end
  self.GamepadPressedKeyMap = self.GamepadPressedKeyMap or {}
  self.GamepadPressedKeyMap[InKeyName] = true
  if self.PageController:IsChoosePageActive() then
    local ChoosePagePanel = self.PageController.ChoosePagePanel
    if ChoosePagePanel and ChoosePagePanel.Handle_ChoosePageGamepadKeyDown and ChoosePagePanel:Handle_ChoosePageGamepadKeyDown(InKeyName) then
      return true
    end
  end
  if self.bHiddenUI then
    if InKeyName == UIConst.GamePadKey.RightThumb then
      self:OnHideUIClick()
      return true
    end
    return false
  end
  if nil ~= CAMERA_MOVE_KEY_MAP[InKeyName] then
    return true == self:OnCameraRoamKeyDown(CAMERA_MOVE_KEY_MAP[InKeyName])
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.PageController:IsChoosePageActive() then
      if self.PageController:IsCharacterTipsOpened() then
        self.PageController:TryCloseCharacterTipsByMask()
        return true
      end
      self.PageController:CloseChoosePageAndReturn()
      return true
    end
    if self.PageController:ShouldShowCharacterDetailPanel() and self.PageController.CharacterEditPanel:HasFocusedDescendants() then
      self:ApplyGamepadFocusToSelectedCharacterSlot()
      self:RefreshCustomEditGamepadPageState()
      return true
    end
    self:OnReturnKeyDown()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft and self.PageController:IsChoosePageActive() and self.PageController:IsCharacterTipsOpened() and self.PageController.ChoosePagePanel and self.PageController.ChoosePagePanel.WBP_PersonalInfo_Edit_Tips and self.PageController.ChoosePagePanel.OnCharacterTipsConfirmClicked then
    local ChoosePagePanel = self.PageController.ChoosePagePanel
    local TipsWidget = ChoosePagePanel.WBP_PersonalInfo_Edit_Tips
    local AppearanceIndex, ModIndex
    if TipsWidget.GetPlan then
      AppearanceIndex, ModIndex = TipsWidget:GetPlan()
    else
      AppearanceIndex = TipsWidget.SelectAppearanceIndex
      ModIndex = TipsWidget.SelectModIndex
    end
    ChoosePagePanel:OnCharacterTipsConfirmClicked(TipsWidget, ModIndex, AppearanceIndex)
    return true
  end
  if not self.PageController:IsChoosePageActive() and self.PageController:IsCharacterMainPageActive() then
    if self.GamepadPressedKeyMap[COMBO_HOLD_KEY] == true then
      if InKeyName == UIConst.GamePadKey.FaceButtonLeft and self.PageController.UndoEdit then
        self.PageController:UndoEdit()
        return true
      end
      if InKeyName == UIConst.GamePadKey.FaceButtonTop and self.PageController.RedoEdit then
        self.PageController:RedoEdit()
        return true
      end
    end
    if self.GamepadPressedKeyMap[COMBO_HOLD_KEY] ~= true and InKeyName == UIConst.GamePadKey.FaceButtonLeft and self.OnClickAdd then
      self:OnClickAdd()
      return true
    end
    if "Gamepad_LeftThumbstick" == InKeyName and self.OnClickResetCamera then
      self:OnClickResetCamera()
      return true
    end
    if InKeyName == UIConst.GamePadKey.RightThumb and self.OnHideUIClick then
      self:OnHideUIClick()
      return true
    end
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self.ActorController and self.ActorController.IsCameraPreviewTransactionActive and self.ActorController:IsCameraPreviewTransactionActive() then
      self.ActorController:CommitCameraPreviewTransaction()
    end
    if self.TriggerCommonButtonClick and self:TriggerCommonButtonClick(self.Btn_Save) then
      return true
    end
    return false
  end
  if not self.PageController:IsChoosePageActive() then
    if InKeyName == UIConst.GamePadKey.LeftShoulder then
      self:_SwitchMainTabByOffset(-1)
      return true
    end
    if InKeyName == UIConst.GamePadKey.RightShoulder then
      self:_SwitchMainTabByOffset(1)
      return true
    end
  end
  return false
end

function Component:Handle_PreviewKeyDownOnGamePad(InKeyName)
  if self.bHiddenUI then
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom or InKeyName == UIConst.GamePadKey.FaceButtonRight or InKeyName == UIConst.GamePadKey.FaceButtonLeft or InKeyName == UIConst.GamePadKey.FaceButtonTop then
      self:OnHideUIClick()
      return true
    end
    if nil ~= CAMERA_MOVE_KEY_MAP[InKeyName] then
      return self:Handle_KeyDownOnGamePad(InKeyName) == true
    end
    return false
  end
  if nil == CAMERA_MOVE_KEY_MAP[InKeyName] then
    return false
  end
  return self:Handle_KeyDownOnGamePad(InKeyName) == true
end

function Component:Handle_KeyUpOnGamePad(InKeyName)
  if self.GamepadPressedKeyMap then
    self.GamepadPressedKeyMap[InKeyName] = nil
  end
  if nil ~= CAMERA_MOVE_KEY_MAP[InKeyName] then
    return self:OnCameraRoamKeyUp(CAMERA_MOVE_KEY_MAP[InKeyName]) == true
  end
  return false
end

function Component:Handle_CustomEditGamepadAnalog(InKeyName, AnalogValue)
  if not self.PageController then
    return false
  end
  if not self.PageController:IsPreviewCameraRoamEnabled() then
    return false
  end
  local MoveValue = AnalogValue or 0
  if math.abs(MoveValue) < (GetCameraInputConfig().GamepadInputDeadZone or 0.05) then
    MoveValue = 0
  end
  if "Gamepad_RightX" == InKeyName then
    if 0 ~= MoveValue and self.ActorController and self.ActorController.BeginCameraPreviewTransaction then
      self.ActorController:BeginCameraPreviewTransaction()
    elseif 0 == MoveValue and self.ActorController and self.ActorController.CommitCameraPreviewTransaction then
      self.ActorController:CommitCameraPreviewTransaction()
    end
    self.RotateCameraByPointer = 0 ~= MoveValue
    self.RotYaw = MoveValue * (GetCameraInputConfig().EditGamepadRotateScale or 12)
    return true
  end
  if "Gamepad_RightY" == InKeyName then
    if 0 ~= MoveValue and self.ActorController and self.ActorController.BeginCameraPreviewTransaction then
      self.ActorController:BeginCameraPreviewTransaction()
    elseif 0 == MoveValue and self.ActorController and self.ActorController.CommitCameraPreviewTransaction then
      self.ActorController:CommitCameraPreviewTransaction()
    end
    self.RotateCameraByPointer = 0 ~= MoveValue
    self.RotPitch = MoveValue * (GetCameraInputConfig().EditGamepadRotateScale or 12)
    return true
  end
  if "Gamepad_LeftTriggerAxis" == InKeyName or "Gamepad_RightTriggerAxis" == InKeyName then
    if not self.ActorController or 0 == MoveValue then
      return true
    end
    self.ActorController:BeginCameraPreviewTransaction()
    local ZoomDelta = MoveValue * (GetCameraInputConfig().EditGamepadZoomScale or 2)
    if "Gamepad_LeftTriggerAxis" == InKeyName then
      ZoomDelta = -ZoomDelta
    end
    self.ActorController:OnScrolling(ZoomDelta)
    self.ActorController:CommitCameraPreviewTransaction()
    return true
  end
  return false
end

return Component
