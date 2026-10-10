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
  local ChoosePagePanel = Owner.PageController.ChoosePagePanel
  if ChoosePagePanel and ChoosePagePanel.ShouldHideChoosePageGamepadKeys and ChoosePagePanel:ShouldHideChoosePageGamepadKeys() then
    return false
  end
  local ChooseMode = Owner.PageController.ActiveChooseMode
  return "Character" == ChooseMode or "Weapon" == ChooseMode or "Action" == ChooseMode or "Item" == ChooseMode or "Pet" == ChooseMode
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
  
  local function BindAddKey(KeyWidget)
    if not KeyWidget or not KeyWidget.CreateCommonKey then
      return
    end
    KeyWidget:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "X",
          ClickCallback = Owner.OnClickAdd,
          Owner = Owner
        }
      }
    })
  end
  
  BindAddKey(Owner.Key_Add)
  BindAddKey(Owner.Key_ChangeSubject)
  Owner.bAddButtonGamepadKeyInitialized = true
end

local function EnsureChangePetButtonGamepadKeyInitialized(Owner)
  if Owner.bChangePetButtonGamepadKeyInitialized then
    return
  end
  if not Owner.Key_ChangePet or not Owner.Key_ChangePet.CreateCommonKey then
    return
  end
  Owner.Key_ChangePet:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "X",
        ClickCallback = Owner.OnClickChangePet,
        Owner = Owner
      }
    }
  })
  Owner.bChangePetButtonGamepadKeyInitialized = true
end

local function EnsureResetButtonGamepadKeyInitialized(Owner)
  if Owner.bResetButtonGamepadKeyInitialized then
    return
  end
  if not Owner.Key_Reset or not Owner.Key_Reset.CreateCommonKey then
    return
  end
  Owner.Key_Reset:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "X",
        ClickCallback = Owner.OnClickStickerEditReset,
        Owner = Owner
      }
    }
  })
  Owner.bResetButtonGamepadKeyInitialized = true
end

local function SetGamepadKeyOverlayVisibility(OverlayWidget, bVisible)
  if not OverlayWidget or not OverlayWidget.SetVisibility then
    return
  end
  OverlayWidget:SetVisibility(bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

local function IsSceneTipsOpened(Owner)
  local Controller = Owner.EditRootController or Owner.PageController
  return nil ~= Controller and nil ~= Controller.IsSceneTipsOpened and Controller:IsSceneTipsOpened() == true
end

local function IsChoosePageExclusiveGamepadFocus(Owner)
  local ChoosePagePanel = Owner.PageController and Owner.PageController.ChoosePagePanel or nil
  return nil ~= ChoosePagePanel and nil ~= ChoosePagePanel.ShouldHideChoosePageGamepadKeys and ChoosePagePanel:ShouldHideChoosePageGamepadKeys() == true
end

local function RefreshSideBtnGamepadKeyState(Owner, SideBtnMode)
  Owner.SideBtnGamepadMode = SideBtnMode
  Owner.bShouldShowAddButtonGamepadKey = "Add" == SideBtnMode
  local bIsGamepadInput = Owner.CurInputDeviceType == ECommonInputType.Gamepad
  if bIsGamepadInput then
    if "Add" == SideBtnMode then
      EnsureAddButtonGamepadKeyInitialized(Owner)
    elseif "ChangePet" == SideBtnMode then
      EnsureChangePetButtonGamepadKeyInitialized(Owner)
    elseif "Reset" == SideBtnMode then
      EnsureResetButtonGamepadKeyInitialized(Owner)
    end
  end
  local bHideForExclusiveFocus = IsSceneTipsOpened(Owner) or IsChoosePageExclusiveGamepadFocus(Owner)
  local SideBtnIndex = Owner.SideBtnIndex
  if nil == SideBtnIndex and Owner._ResolveSideBtnIndex then
    SideBtnIndex = Owner:_ResolveSideBtnIndex()
  end
  local bShowAdd = bIsGamepadInput and "Add" == SideBtnMode and not bHideForExclusiveFocus
  SetGamepadKeyOverlayVisibility(Owner.Function_Add, bShowAdd and 2 ~= SideBtnIndex)
  SetGamepadKeyOverlayVisibility(Owner.Function_ChangeSubject, bShowAdd and 2 == SideBtnIndex)
  SetGamepadKeyOverlayVisibility(Owner.Function_ChangePet, bIsGamepadInput and "ChangePet" == SideBtnMode and not bHideForExclusiveFocus)
  SetGamepadKeyOverlayVisibility(Owner.Function_Reset, bIsGamepadInput and "Reset" == SideBtnMode and not bHideForExclusiveFocus)
end

local function ResolveSideBtnGamepadMode(Owner)
  local SideBtnIndex = Owner.SideBtnIndex
  if nil == SideBtnIndex and Owner._ResolveSideBtnIndex then
    SideBtnIndex = Owner:_ResolveSideBtnIndex()
  end
  if nil == SideBtnIndex then
    return nil
  end
  if 0 == SideBtnIndex or 2 == SideBtnIndex then
    return "Add"
  end
  if 1 == SideBtnIndex then
    return "ChangePet"
  end
  return "Reset"
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
  if IsSceneTipsOpened(Owner) or IsChoosePageExclusiveGamepadFocus(Owner) then
    return false
  end
  if Owner.EditRootController:IsScenePageActive() then
    local ScenePagePanel = Owner.EditRootController.ScenePagePanel
    return ScenePagePanel and ScenePagePanel.ShouldShowSceneLightAdjustGamepadKey and ScenePagePanel:ShouldShowSceneLightAdjustGamepadKey() == true
  end
  local bIsCharacterMain = true == Owner.EditRootController:IsCharacterMainPageActive()
  local bIsPetMain = true == Owner.EditRootController:IsPetMainPageActive()
  local bIsItemMain = true == Owner.EditRootController:IsItemMainPageActive()
  if not bIsCharacterMain and not bIsPetMain and not bIsItemMain then
    return false
  end
  local SlotIndex
  if bIsPetMain then
    SlotIndex = Owner.EditRootController:GetSelectedPetSlotIndex()
  elseif bIsItemMain then
    SlotIndex = Owner.EditRootController:GetSelectedItemSlotIndex()
  else
    SlotIndex = Owner.EditRootController:GetSelectedCharacterSlotIndex()
  end
  local Content = Owner.CharacterSlotItemContents and Owner.CharacterSlotItemContents[SlotIndex] or nil
  local bHasContent = Content and (true == Content.HasCharacter or true == Content.HasItem)
  if not bHasContent or true ~= Content.CanInteract then
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

local function RefreshScenePageGamepadState(Owner)
  local ScenePagePanel = Owner.PageController and Owner.PageController.ScenePagePanel or nil
  if ScenePagePanel and ScenePagePanel.RefreshScenePageGamepadState then
    ScenePagePanel:RefreshScenePageGamepadState()
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
  EnsureChangePetButtonGamepadKeyInitialized(self)
  EnsureResetButtonGamepadKeyInitialized(self)
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
  RefreshSideBtnGamepadKeyState(self, ResolveSideBtnGamepadMode(self))
  RefreshEditModelGamepadKeyState(self)
  RefreshScenePageGamepadState(self)
  self:_RefreshSaveGamepadHint()
  self:ApplyCurrentEditStateGamepadFocus()
end

function Component:InitKeyboardView(CurInputType, CurGamepadName)
  self.CurInputDeviceType = CurInputType or ECommonInputType.MouseAndKeyboard
  self.CurGamepadName = CurGamepadName
  self.GamepadPressedKeyMap = {}
  self:_CancelScheduledGamepadDefaultFocus()
  RefreshCharacterSlotSwitchGamepadKeyState(self)
  RefreshSideBtnGamepadKeyState(self, ResolveSideBtnGamepadMode(self))
  RefreshEditModelGamepadKeyState(self)
  RefreshScenePageGamepadState(self)
  self:_RefreshSaveGamepadHint()
end

function Component:RefreshCustomEditGamepadPageState()
  RefreshCharacterSlotSwitchGamepadKeyState(self)
  RefreshSideBtnGamepadKeyState(self, ResolveSideBtnGamepadMode(self))
  RefreshEditModelGamepadKeyState(self)
  RefreshScenePageGamepadState(self)
  self:_RefreshSaveGamepadHint()
end

function Component:_RefreshSaveGamepadHint()
  if not self.Btn_Save or not self.Btn_Save.SetGamePadVisibility then
    return
  end
  local bHide = IsSceneTipsOpened(self) or IsChoosePageExclusiveGamepadFocus(self)
  local GamePadVisibility = bHide and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible
  self.Btn_Save:SetGamePadVisibility(GamePadVisibility)
  local TitleConfirmButton = self.Edit_Title and self.Edit_Title.Btn_Confirm or nil
  if TitleConfirmButton and TitleConfirmButton.SetGamePadVisibility then
    TitleConfirmButton:SetGamePadVisibility(GamePadVisibility)
  end
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
  if Content.SlotKind == "Item" or self.EditRootController:IsItemMainPageActive() then
    if self.EditRootController:IsChoosePageActive() then
      local ChoosePagePanel = self.EditRootController.ChoosePagePanel
      if ChoosePagePanel and ChoosePagePanel.FocusGamepadDefaultListItem then
        ChoosePagePanel:FocusGamepadDefaultListItem()
      end
    else
      local CharacterEditPanel = self.EditRootController.CharacterEditPanel
      if CharacterEditPanel and CharacterEditPanel.FocusGamepadDefaultPanelItem then
        CharacterEditPanel:FocusGamepadDefaultPanelItem()
      end
    end
    self:RefreshCustomEditGamepadPageState()
    return true
  end
  if Content.SlotKind == "Pet" or self.EditRootController:IsPetPageActive() then
    if not self.EditRootController:OpenSelectedPetDetailPanelWithoutFocus() then
      self:RefreshCustomEditGamepadPageState()
      return true
    end
    self:_CancelScheduledGamepadDefaultFocus()
    local CharacterEditPanel = self.EditRootController.CharacterEditPanel
    if CharacterEditPanel and CharacterEditPanel.FocusGamepadDefaultPanelItem then
      CharacterEditPanel:FocusGamepadDefaultPanelItem()
    end
    self:RefreshCustomEditGamepadPageState()
    return true
  end
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

function Component:_TryCloseSceneTipsOnGamepadKey(InKeyName)
  if not self.PageController or not self.PageController:IsSceneTipsOpened() then
    return false
  end
  if InKeyName == UIConst.GamePadKey.SpecialRight and self.bIgnoreSceneTipsMenuHold then
    return true
  end
  local ScenePagePanel = self.PageController.ScenePagePanel
  if ScenePagePanel and ScenePagePanel._TryCloseSceneTips then
    ScenePagePanel:_TryCloseSceneTips()
  end
  return true
end

function Component:Handle_KeyDownOnGamePad(InKeyName, bIsRepeat)
  if not self.PageController then
    return false
  end
  self.GamepadPressedKeyMap = self.GamepadPressedKeyMap or {}
  self.GamepadPressedKeyMap[InKeyName] = true
  if self:_TryCloseSceneTipsOnGamepadKey(InKeyName) then
    return true
  end
  if self.PageController:IsChoosePageActive() then
    local ChoosePagePanel = self.PageController.ChoosePagePanel
    if ChoosePagePanel and ChoosePagePanel.Handle_ChoosePageGamepadKeyDown and ChoosePagePanel:Handle_ChoosePageGamepadKeyDown(InKeyName) then
      return true
    end
  end
  if self.PageController.IsStickerEditPageActive and self.PageController:IsStickerEditPageActive() then
    local StickersEditWidget = self:_GetStickersEditWidget()
    if StickersEditWidget and StickersEditWidget.HandleGamepadScaleByShoulder then
      if InKeyName == UIConst.GamePadKey.LeftShoulder then
        return true == StickersEditWidget:HandleGamepadScaleByShoulder(false)
      end
      if InKeyName == UIConst.GamePadKey.RightShoulder then
        return true == StickersEditWidget:HandleGamepadScaleByShoulder(true)
      end
    end
  end
  if self.bHiddenUI then
    if InKeyName == UIConst.GamePadKey.RightThumb then
      self:OnHideUIClick()
      return true
    end
    return false
  end
  if self.PageController:IsScenePageActive() then
    local ScenePagePanel = self.PageController.ScenePagePanel
    if ScenePagePanel and ScenePagePanel.Handle_ScenePageGamepadKeyDown and ScenePagePanel:Handle_ScenePageGamepadKeyDown(InKeyName, bIsRepeat) then
      return true
    end
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
    if self.PageController.IsStickerEditPageActive and self.PageController:IsStickerEditPageActive() then
      self.PageController:CloseStickerEditAndReturn()
      return true
    end
    if (self.PageController:ShouldShowCharacterDetailPanel() or self.PageController:ShouldShowPetDetailPanel() or self.PageController:ShouldShowItemDetailPanel()) and self.PageController.CharacterEditPanel and self.PageController.CharacterEditPanel:HasFocusedDescendants() then
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
  local bIsEditableMain = self.PageController:IsCharacterMainPageActive() or self.PageController:IsPetMainPageActive() or self.PageController:IsItemMainPageActive()
  local bIsOtherMain = self.PageController.IsOtherPageActive and true == self.PageController:IsOtherPageActive()
  local bIsStickerEdit = self.PageController.IsStickerEditPageActive and true == self.PageController:IsStickerEditPageActive()
  if not self.PageController:IsChoosePageActive() and (bIsEditableMain or bIsOtherMain or bIsStickerEdit) then
    if (bIsEditableMain or bIsOtherMain) and self.GamepadPressedKeyMap[COMBO_HOLD_KEY] == true then
      if InKeyName == UIConst.GamePadKey.FaceButtonLeft and self.PageController.UndoEdit then
        self.PageController:UndoEdit()
        return true
      end
      if InKeyName == UIConst.GamePadKey.FaceButtonTop and self.PageController.RedoEdit then
        self.PageController:RedoEdit()
        return true
      end
    end
    if self.GamepadPressedKeyMap[COMBO_HOLD_KEY] ~= true and InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      local SideBtnMode = ResolveSideBtnGamepadMode(self)
      if "ChangePet" == SideBtnMode and self.OnClickChangePet then
        self:OnClickChangePet()
        return true
      end
      if "Reset" == SideBtnMode and self.OnClickStickerEditReset then
        self:OnClickStickerEditReset()
        return true
      end
      if "Add" == SideBtnMode and self.OnClickAdd then
        self:OnClickAdd()
        return true
      end
    end
    if bIsEditableMain and "Gamepad_LeftThumbstick" == InKeyName and self.OnClickResetCamera then
      self:OnClickResetCamera()
      return true
    end
    if (bIsEditableMain or bIsOtherMain or bIsStickerEdit) and InKeyName == UIConst.GamePadKey.RightThumb and self.OnHideUIClick then
      self:OnHideUIClick()
      return true
    end
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self.ActorController and self.ActorController.IsCameraPreviewTransactionActive and self.ActorController:IsCameraPreviewTransactionActive() then
      self.ActorController:CommitCameraPreviewTransaction()
    end
    local ConfirmButton = self.GetActiveCommonConfirmButton and self:GetActiveCommonConfirmButton() or self.Btn_Save
    if self.TriggerCommonButtonClick and self:TriggerCommonButtonClick(ConfirmButton) then
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

function Component:Handle_PreviewKeyDownOnGamePad(InKeyName, bIsRepeat)
  if self:_TryCloseSceneTipsOnGamepadKey(InKeyName) then
    return true
  end
  if self.bHiddenUI then
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom or InKeyName == UIConst.GamePadKey.FaceButtonRight or InKeyName == UIConst.GamePadKey.FaceButtonLeft or InKeyName == UIConst.GamePadKey.FaceButtonTop then
      self:OnHideUIClick()
      return true
    end
    if nil ~= CAMERA_MOVE_KEY_MAP[InKeyName] then
      return self:Handle_KeyDownOnGamePad(InKeyName, bIsRepeat) == true
    end
    return false
  end
  if self.PageController and self.PageController:IsScenePageActive() and InKeyName == UIConst.GamePadKey.SpecialRight then
    self.GamepadPressedKeyMap = self.GamepadPressedKeyMap or {}
    self.GamepadPressedKeyMap[InKeyName] = true
    local ScenePagePanel = self.PageController.ScenePagePanel
    if ScenePagePanel and ScenePagePanel.Handle_ScenePageGamepadKeyDown and ScenePagePanel:Handle_ScenePageGamepadKeyDown(InKeyName, bIsRepeat) then
      return true
    end
  end
  if nil == CAMERA_MOVE_KEY_MAP[InKeyName] then
    return false
  end
  return self:Handle_KeyDownOnGamePad(InKeyName, bIsRepeat) == true
end

function Component:Handle_KeyUpOnGamePad(InKeyName)
  if self.GamepadPressedKeyMap then
    self.GamepadPressedKeyMap[InKeyName] = nil
  end
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self.bIgnoreSceneTipsMenuHold = false
  end
  if self.PageController and self.PageController:IsScenePageActive() then
    local ScenePagePanel = self.PageController.ScenePagePanel
    if ScenePagePanel and ScenePagePanel.Handle_ScenePageGamepadKeyUp and ScenePagePanel:Handle_ScenePageGamepadKeyUp(InKeyName) then
      return true
    end
  end
  if self.PageController and self.PageController.IsStickerEditPageActive and self.PageController:IsStickerEditPageActive() and (InKeyName == UIConst.GamePadKey.LeftShoulder or InKeyName == UIConst.GamePadKey.RightShoulder) then
    local StickersEditWidget = self:_GetStickersEditWidget()
    if StickersEditWidget and StickersEditWidget.StopGamepadScaleRepeat then
      local bIncrease = InKeyName == UIConst.GamePadKey.RightShoulder
      if StickersEditWidget:StopGamepadScaleRepeat(bIncrease) then
        return true
      end
    end
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
  if self.PageController:IsSceneTipsOpened() then
    return true
  end
  if self.PageController:IsScenePageActive() then
    local ScenePagePanel = self.PageController.ScenePagePanel
    if ScenePagePanel and ScenePagePanel.Handle_ScenePageGamepadAnalog and ScenePagePanel:Handle_ScenePageGamepadAnalog(InKeyName, AnalogValue) then
      return true
    end
  end
  if self.PageController.IsStickerEditPageActive and self.PageController:IsStickerEditPageActive() and ("Gamepad_LeftX" == InKeyName or "Gamepad_LeftY" == InKeyName) then
    local StickersEditWidget = self:_GetStickersEditWidget()
    if StickersEditWidget and StickersEditWidget.HandleGamepadMoveAnalog then
      return StickersEditWidget:HandleGamepadMoveAnalog(InKeyName, AnalogValue) == true
    end
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

function Component:_GetStickersEditWidget()
  local Candidates = {
    self.StickersEditWidget,
    self.RootViewPanel and self.RootViewPanel.StickersEditWidget or nil,
    self.PageController and self.PageController.RootViewPanel and self.PageController.RootViewPanel.StickersEditWidget or nil
  }
  for _, StickersEditWidget in ipairs(Candidates) do
    if StickersEditWidget and IsValid(StickersEditWidget) then
      return StickersEditWidget
    end
  end
  return nil
end

return Component
