require("UnLua")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = PersonInfoController:GetModel()
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local DisplayPersistence = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayPersistence")
local RootState = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditState_Root")
local CharacterEditState = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditState_CharacterEdit")
local ChooseState = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditState_Choose")
local SceneState = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditState_Scene")
local PetState = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditState_Pet")
local OtherState = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditState_Other")
local StickerEditState = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditState_StickerEdit")
local SessionModel = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditSessionModel")
local DisplayBridge = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditDisplayBridge")
local ViewDataBuilder = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditViewDataBuilder")
local UniqueSlotChooseController = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditUniqueSlotChooseController")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_P_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_M_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditChoose_P_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditChoose_M_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditScence_P_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditScence_M_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditOther_P_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditOther_M_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_Filters_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_Stickers_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_DetailsItem_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_StickersItem_C")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_StickersEdit_C")
local M = Class()
for Key, Value in pairs(SessionModel) do
  M[Key] = Value
end
for Key, Value in pairs(DisplayBridge) do
  M[Key] = Value
end
for Key, Value in pairs(ViewDataBuilder) do
  M[Key] = Value
end
for Key, Value in pairs(UniqueSlotChooseController) do
  M[Key] = Value
end
local CharacterEquipChooseConfig = {
  Weapon = {
    TransactionKey = "weapon_choose",
    BaseDraftField = "WeaponChooseBaseDraft",
    SkipCancelField = "SkipCancelWeaponChooseOnce"
  },
  Action = {
    TransactionKey = "action_choose",
    BaseDraftField = "ActionChooseBaseDraft",
    SkipCancelField = "SkipCancelActionChooseOnce"
  }
}

function M:New(OwnerWidget)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj.OwnerWidget = OwnerWidget
  Obj.RootViewPanel = OwnerWidget
  return Obj
end

function M:InitPageController(TabName, OpenContext)
  self.OwnerWidget = self.OwnerWidget or self
  self.RootViewPanel = self.RootViewPanel or self.OwnerWidget
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "PersonInfoCustomEditPageOpen", nil)
  self.OpenContext = OpenContext
  self.CharacterEditPanel = nil
  self.ChoosePagePanel = nil
  self.ScenePagePanel = nil
  self.OtherPagePanel = nil
  self.MainPageView = nil
  self.DisplayController = nil
  self.DisplayEditor = nil
  self.ValidCharacterSlotIndices = {}
  self.PendingCharacterChoosePreview = nil
  self.StagedCharacterChooseSelections = {}
  self.CharacterChooseBaseDraft = nil
  self.CharacterChoosePreviewSceneSlotIndex = nil
  self.ItemChooseBaseDraft = nil
  self.PetChooseBaseDraft = nil
  self.WeaponChooseBaseDraft = nil
  self.ActionChooseBaseDraft = nil
  self.InitialSavedDraft = nil
  self.IsSaving = false
  self.bPendingRestoreAfterSave = false
  self.bHasLocalStickerDraft = false
  self.bHasLocalFilterDraft = false
  self.bHasStickerEditEnterSnapshot = false
  self.StickerEditEnterSnapshot = nil
  self.SelectedCharacterSlotIndex = nil
  self.SelectedPetSlotIndex = nil
  self.SelectedItemSlotIndex = nil
  self.ActiveTabName = TabName or "Char"
  if self.ActiveTabName == "Item" then
    self.ActiveSubPageName = "ItemMain"
  elseif self.ActiveTabName == "Scene" then
    self.ActiveSubPageName = "Scene"
  elseif self.ActiveTabName == "Other" then
    self.ActiveSubPageName = "Other"
  elseif self.ActiveTabName == "Pet" then
    self.ActiveSubPageName = "PetMain"
  else
    self.ActiveSubPageName = "CharacterMain"
  end
  self.ActiveCharacterPanelState = "Main"
  self.ActivePetPanelState = "Main"
  self.ActiveChooseMode = nil
  self.SelectedSceneId = nil
  self.UsedSceneId = nil
  self.SkipCancelCharacterChoosePreviewOnce = false
  self.SkipCancelItemChooseOnce = false
  self.SkipCancelPetChooseOnce = false
  self.SkipCancelWeaponChooseOnce = false
  self.SkipCancelActionChooseOnce = false
  self.bEnablePreviewCameraRoam = false
  self.bPreferShowMobileLeftPanel = nil
  self.EditUIStateMap = nil
  self.CurrentEditUIState = nil
  self.CurrentEditUIStateName = nil
  self.CurrentUIModel = nil
  self.PendingDefaultSelectTimerHandle = nil
  self.bOpenDetailOnNextRootEnter = true
  self:_BindRuntimeContext(OpenContext)
  self:_InitEditUIStates()
  self:_LoadInitialDraftFromServer()
  self:_InitSelectedCharacterSlotIndex()
  self:_InitSelectedItemSlotIndex()
  self:_CreateCharacterEditPanelIfNeeded()
  self.RootViewPanel:InitMainPage(self)
  self:RefreshRootView()
end

function M:OnDestructPageController()
  self:_ClearPendingDefaultSelectTimer()
  if self.DisplayEditor and self.DisplayEditor.IsPreviewTransactionActive and self.DisplayEditor:IsPreviewTransactionActive("item_choose") and self.DisplayEditor.CancelPreviewTransaction then
    self.DisplayEditor:CancelPreviewTransaction()
  end
  if self.DisplayEditor and self.DisplayEditor.IsPreviewTransactionActive and self.DisplayEditor:IsPreviewTransactionActive("pet_choose") and self.DisplayEditor.CancelPreviewTransaction then
    self.DisplayEditor:CancelPreviewTransaction()
  end
  if self.DisplayEditor and self.DisplayEditor.IsPreviewTransactionActive and self.DisplayEditor:IsPreviewTransactionActive("weapon_choose") and self.DisplayEditor.CancelPreviewTransaction then
    self.DisplayEditor:CancelPreviewTransaction()
  end
  if self.DisplayEditor and self.DisplayEditor.IsPreviewTransactionActive and self.DisplayEditor:IsPreviewTransactionActive("action_choose") and self.DisplayEditor.CancelPreviewTransaction then
    self.DisplayEditor:CancelPreviewTransaction()
  end
  self.ItemChooseBaseDraft = nil
  self.PetChooseBaseDraft = nil
  self.WeaponChooseBaseDraft = nil
  self.ActionChooseBaseDraft = nil
  self:_RestoreDraftOnAbandonIfNeeded()
  if self.bHasStickerEditEnterSnapshot then
    self:_ClearStickerEditEnterSnapshot()
  end
  if self.HideStickerEdit then
    self:HideStickerEdit()
  end
  self.RootViewPanel:RemoveAllEditSubPages(self)
  self.ScenePagePanel = nil
  self.OtherPagePanel = nil
  self.ChoosePagePanel = nil
  self.CharacterEditPanel = nil
  if self.DisplayController and self.DisplayController.ActiveCustomEditRootController == self then
    self.DisplayController.ActiveCustomEditRootController = nil
  end
  self.MainPageView = nil
  self.DisplayController = nil
  self.DisplayEditor = nil
  self.ValidCharacterSlotIndices = {}
  self.SelectedCharacterSlotIndex = nil
  self.SelectedPetSlotIndex = nil
  self.ActivePetPanelState = "Main"
  self.PendingCharacterChoosePreview = nil
  self.StagedCharacterChooseSelections = {}
  self.CharacterChoosePreviewSceneSlotIndex = nil
  self.ItemChooseBaseDraft = nil
  self.SkipCancelItemChooseOnce = false
  self.PetChooseBaseDraft = nil
  self.SkipCancelPetChooseOnce = false
  self.WeaponChooseBaseDraft = nil
  self.SkipCancelWeaponChooseOnce = false
  self.ActionChooseBaseDraft = nil
  self.SkipCancelActionChooseOnce = false
  self.InitialSavedDraft = nil
  if self.IsSaving ~= true then
    self.bPendingRestoreAfterSave = false
    self.IsSaving = false
  end
  self.bHasLocalStickerDraft = false
  self.bHasLocalFilterDraft = false
  self.bHasStickerEditEnterSnapshot = false
  self.StickerEditEnterSnapshot = nil
  self.bEnablePreviewCameraRoam = false
  self.CurrentUIModel = nil
  self.CurrentEditUIState = nil
  self.CurrentEditUIStateName = nil
  self.EditUIStateMap = nil
  self.RootViewPanel = nil
  self.OwnerWidget = nil
end

function M:_ScheduleDefaultCharacterSlotSelection(bOpenDetail)
  self:_ClearPendingDefaultSelectTimer()
  local TimerOwner = self.RootViewPanel or self.OwnerWidget
  local bShouldOpenDetail = false ~= bOpenDetail
  if not TimerOwner or not TimerOwner.AddTimer then
    DebugPrint("PersonInfoEdit: default delayed select fallback immediate because timer owner invalid")
    self:_SelectCharacterSlot(self.SelectedCharacterSlotIndex, {
      OpenHighlight = true,
      OpenDetail = bShouldOpenDetail,
      ForceRefresh = true
    })
    return
  end
  self.PendingDefaultSelectTimerHandle = TimerOwner:AddTimer(0.1, function()
    self.PendingDefaultSelectTimerHandle = nil
    DebugPrint(string.format("PersonInfoEdit: default delayed select fire activeSubPage=%s panelState=%s selectedSlot=%s hasSelected=%s", tostring(self.ActiveSubPageName), tostring(self.ActiveCharacterPanelState), tostring(self.SelectedCharacterSlotIndex), tostring(self:HasSelectedCharacter())))
    if not self:IsCharacterMainPageActive() or not self.SelectedCharacterSlotIndex then
      DebugPrint("PersonInfoEdit: default delayed select skipped and refresh root only")
      self:RefreshRootView()
      return
    end
    self:_SelectCharacterSlot(self.SelectedCharacterSlotIndex, {
      OpenHighlight = true,
      OpenDetail = bShouldOpenDetail,
      ForceRefresh = true
    })
  end, false, 0, "PersonInfoDefaultSelect")
end

function M:_ClearPendingDefaultSelectTimer()
  local TimerOwner = self.RootViewPanel or self.OwnerWidget
  if TimerOwner and TimerOwner.IsExistTimer and TimerOwner.RemoveTimer and TimerOwner:IsExistTimer("PersonInfoDefaultSelect") then
    TimerOwner:RemoveTimer("PersonInfoDefaultSelect")
  end
  self.PendingDefaultSelectTimerHandle = nil
end

function M:HandleEnterRootState()
  self:_ClearPendingDefaultSelectTimer()
  if not self:IsCharacterMainPageActive() then
    self:_SyncFocusedCharacterHighlight()
    return
  end
  self.SelectedCharacterSlotIndex = self:_ResolveRootSelectedCharacterSlotIndex(self.SelectedCharacterSlotIndex)
  self.SelectCharIndex = self.SelectedCharacterSlotIndex
  if not self.SelectedCharacterSlotIndex or not self:HasSelectedCharacter() then
    self:_SyncFocusedCharacterHighlight()
    return
  end
  local bOpenDetailOnRootEnter = self.bOpenDetailOnNextRootEnter ~= false
  self.bOpenDetailOnNextRootEnter = true
  self:_SyncFocusedCharacterHighlight()
  self:_ScheduleDefaultCharacterSlotSelection(bOpenDetailOnRootEnter)
end

function M:HandleEnterChooseState(_Params)
  self:_ClearPendingDefaultSelectTimer()
  if self.ActiveChooseMode == "Item" then
    self.RootViewPanel:RefreshSlotAreaState()
    self:_SyncFocusedItemHighlight()
    return
  end
  if self.ActiveChooseMode == "Pet" then
    local SlotCount = DisplayConfig:GetPetSlotCount()
    if self.RootViewPanel and self.RootViewPanel.RefreshPetSlotItem then
      for SlotIndex = 1, SlotCount do
        self.RootViewPanel:RefreshPetSlotItem(SlotIndex)
      end
    end
    self:_SyncFocusedPetHighlight()
    return
  end
  if self.RootViewPanel and self.RootViewPanel.RefreshCharacterSlotItem then
    for SlotIndex = 1, 4 do
      self.RootViewPanel:RefreshCharacterSlotItem(SlotIndex)
    end
  end
  self:_SyncFocusedCharacterHighlight()
end

function M:HandleExitChooseState(_Params)
  if _Params and _Params.ChooseKind == "Item" or "Item" == self.ActiveTabName then
    self.RootViewPanel:RefreshSlotAreaState()
    self:_SyncFocusedItemHighlight()
    return
  end
  if self.ActiveChooseMode == "Pet" or self.ActiveTabName == "Pet" then
    local SlotCount = DisplayConfig:GetPetSlotCount()
    if self.RootViewPanel and self.RootViewPanel.RefreshPetSlotItem then
      for SlotIndex = 1, SlotCount do
        self.RootViewPanel:RefreshPetSlotItem(SlotIndex)
      end
    end
    self:_SyncFocusedPetHighlight()
    return
  end
  if self.RootViewPanel and self.RootViewPanel.RefreshCharacterSlotItem then
    for SlotIndex = 1, 4 do
      self.RootViewPanel:RefreshCharacterSlotItem(SlotIndex)
    end
  end
  self:_SyncFocusedCharacterHighlight()
end

function M:RefreshRootView()
  self:_SyncCurrentEditUIState()
  self:RefreshPreviewCameraRoamState()
  self:_RefreshViewByUIModelDiff()
  if self.RootViewPanel and self.RootViewPanel.RefreshCustomEditGamepadPageState then
    self.RootViewPanel:RefreshCustomEditGamepadPageState()
  end
  self:RefreshImageClickMaskState()
end

function M:RefreshPageStructure()
  self:RefreshView()
  self.RootViewPanel:EnsureActiveEditSubPageCreated(self)
  self.RootViewPanel:RefreshEditSubPageVisibility(self)
  self:RefreshRootStickerPreview()
end

function M:RefreshActivePageContent()
  if self.ActiveSubPageName == "Choose" then
    if self.ChoosePagePanel then
      self.ChoosePagePanel:RefreshView()
    end
    self:RefreshRootStickerPreview()
    return
  end
  if self.ActiveSubPageName == "Scene" then
    self.ScenePagePanel:RefreshView()
    self:RefreshRootStickerPreview()
    return
  end
  if self.ActiveSubPageName == "Other" then
    if self.OtherPagePanel then
      self.OtherPagePanel:RefreshView()
    end
    self:RefreshRootStickerPreview()
    return
  end
  if self.ActiveSubPageName == "PetMain" then
    if self.CharacterEditPanel and self:ShouldShowPetDetailPanel() then
      self.CharacterEditPanel:RefreshView()
    end
    self:RefreshRootStickerPreview()
    return
  end
  if self.CharacterEditPanel and self:ShouldShowEditDetailPanel() then
    self.CharacterEditPanel:RefreshView()
  end
  self:RefreshRootStickerPreview()
end

function M:RefreshSelectedCharacterSlotContext()
  self:_SyncCurrentEditUIState()
  self:_RefreshViewByUIModelDiff()
  if self.CharacterEditPanel and self:ShouldShowCharacterDetailPanel() then
    self.CharacterEditPanel:RefreshView()
  end
end

function M:RefreshSelectedItemSlotContext()
  self:_SyncCurrentEditUIState()
  self:_RefreshViewByUIModelDiff()
  if self.CharacterEditPanel and self:ShouldShowItemDetailPanel() then
    self.CharacterEditPanel:RefreshView()
  end
  self:_SyncFocusedItemHighlight()
end

function M:_EnsureSelectedCharacterSlotAfterCharacterChange()
  local PreviousSelectedSlotIndex = self.SelectedCharacterSlotIndex
  self.SelectedCharacterSlotIndex = self:_ResolveRootSelectedCharacterSlotIndex(self.SelectedCharacterSlotIndex)
  self.SelectCharIndex = self.SelectedCharacterSlotIndex
  if self.SelectedCharacterSlotIndex then
    local bHasCharacter = self:HasSelectedCharacter()
    if PreviousSelectedSlotIndex ~= self.SelectedCharacterSlotIndex then
      return self:_SelectCharacterSlot(self.SelectedCharacterSlotIndex, {
        OpenHighlight = bHasCharacter,
        OpenDetail = false,
        ForceRefresh = true
      })
    end
    if not bHasCharacter then
      self:_SyncFocusedCharacterHighlight()
    end
    return false
  end
  local FallbackSlotIndex = self:_FindFirstEmptyCharacterSlotIndex()
  if not FallbackSlotIndex then
    self.SelectedCharacterSlotIndex = nil
    self.SelectCharIndex = nil
    self:_SyncFocusedCharacterHighlight()
    return false
  end
  self:_SelectCharacterSlot(FallbackSlotIndex, {
    OpenHighlight = false,
    OpenDetail = false,
    ForceRefresh = true
  })
  return true
end

function M:_EnsureSelectedCharacterFocusAfterHistoryChange()
  if self:_EnsureSelectedCharacterSlotAfterCharacterChange() then
    return true
  end
  if not self.DisplayController or not self.DisplayController.GetFocusedCharacterEntityId then
    return false
  end
  if self.DisplayController:GetFocusedCharacterEntityId() then
    return false
  end
  local SlotIndex = self:GetSelectedCharacterSlotIndex()
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  local Slot = self:_GetCharacterSlot(SlotIndex, self:IsCharacterChoosePageActive())
  if not DisplayDraft:IsCharacterSlotOccupied(Slot) then
    return false
  end
  return self:_SelectCharacterSlot(SlotIndex, {
    OpenHighlight = true,
    OpenDetail = false,
    ForceRefresh = true
  })
end

function M:RefreshCharacterPanelStateContext()
  self:_SyncCurrentEditUIState()
  self:RefreshPreviewCameraRoamState()
  self:_RefreshViewByUIModelDiff()
  if self.RootViewPanel and self.RootViewPanel.RefreshCustomEditGamepadPageState then
    self.RootViewPanel:RefreshCustomEditGamepadPageState()
  end
end

function M:_RefreshCharacterChooseRootState(RefreshSlotIndex)
  if self.RootViewPanel then
    local SelectedSlotIndex = RefreshSlotIndex
    if type(SelectedSlotIndex) ~= "number" or SelectedSlotIndex <= 0 then
      SelectedSlotIndex = self:GetSelectedCharacterSlotIndex()
    end
    if type(SelectedSlotIndex) == "number" and SelectedSlotIndex > 0 and self.RootViewPanel.RefreshCharacterSlotItem then
      self.RootViewPanel:RefreshCharacterSlotItem(SelectedSlotIndex)
    end
    self.RootViewPanel:RefreshCommonActionState()
    self.RootViewPanel:RefreshTitleText()
  end
end

function M:_RefreshChoosePageEquippedEntryState()
  if not self.ChoosePagePanel then
    return
  end
  local ChooseMode = self.ChoosePagePanel.ChooseMode
  local bCharacterChooseMode = "Character" == ChooseMode
  local bPetChooseMode = "Pet" == ChooseMode
  if bCharacterChooseMode and self.ChoosePagePanel._RefreshCharacterChosenState then
    self.ChoosePagePanel:_RefreshCharacterChosenState(self.ChoosePagePanel.FilteredContents or {})
  end
  if bPetChooseMode and self.ChoosePagePanel._RefreshPetChosenState then
    self.ChoosePagePanel:_RefreshPetChosenState(self.ChoosePagePanel.FilteredContents or {})
  end
  local RefreshFunc = self.ChoosePagePanel.RefreshEntryEquipState or self.ChoosePagePanel.RefreshEntryVisual
  if (bCharacterChooseMode or bPetChooseMode) and self.ChoosePagePanel.RefreshEntryVisual then
    RefreshFunc = self.ChoosePagePanel.RefreshEntryVisual
  end
  if not RefreshFunc then
    return
  end
  for _, Content in ipairs(self.ChoosePagePanel.FilteredContents or {}) do
    RefreshFunc(self.ChoosePagePanel, Content)
  end
end

function M:_RefreshAffectedCharacterSlotItems(AffectedSlotIndices)
  if not self.RootViewPanel or not self.RootViewPanel.RefreshCharacterSlotItem then
    return
  end
  local bHasAnyAffectedSlot = false
  for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
    if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
      self.RootViewPanel:RefreshCharacterSlotItem(SlotIndex)
      bHasAnyAffectedSlot = true
    end
  end
  if bHasAnyAffectedSlot then
    return
  end
  local SelectedSlotIndex = self:GetSelectedCharacterSlotIndex()
  if type(SelectedSlotIndex) == "number" and SelectedSlotIndex > 0 then
    self.RootViewPanel:RefreshCharacterSlotItem(SelectedSlotIndex)
  end
end

function M:_RefreshAffectedPetSlotItems(AffectedSlotIndices)
  if not self.RootViewPanel or not self.RootViewPanel.RefreshPetSlotItem then
    return
  end
  local bHasAnyAffectedSlot = false
  for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
    if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
      self.RootViewPanel:RefreshPetSlotItem(SlotIndex)
      bHasAnyAffectedSlot = true
    end
  end
  if bHasAnyAffectedSlot then
    return
  end
  local SelectedSlotIndex = self:GetSelectedPetSlotIndex()
  if type(SelectedSlotIndex) == "number" and SelectedSlotIndex > 0 then
    self.RootViewPanel:RefreshPetSlotItem(SelectedSlotIndex)
  end
end

function M:_RefreshAfterHistoryOperation(Operation)
  if type(Operation) ~= "table" then
    self:RefreshRootView()
    return
  end
  self:_SyncCurrentEditUIState()
  self:RefreshPreviewCameraRoamState()
  local OperationType = Operation.Type
  if "CharacterChooseCommit" == OperationType then
    self:_EnsureSelectedCharacterFocusAfterHistoryChange()
    self:_RefreshAffectedCharacterSlotItems(Operation.AffectedSlotIndices)
    if self:IsChoosePageActive() then
      self:_RefreshCharacterChooseRootState()
      self:_RefreshChoosePageEquippedEntryState()
      if self.ActiveChooseMode == "Weapon" or self.ActiveChooseMode == "Action" then
        self.ChoosePagePanel:RefreshTitle()
      end
      self.ChoosePagePanel:RefreshBottomKeyInfo()
      return
    end
    self:RefreshSelectedCharacterSlotContext()
    if self.RootViewPanel then
      self.RootViewPanel:RefreshCommonActionState()
      self.RootViewPanel:RefreshTitleText()
    end
    return
  end
  if "CharacterTransform" == OperationType then
    if self:ShouldShowCharacterDetailPanel() and self.CharacterEditPanel then
      self.CharacterEditPanel:RefreshView()
    end
    if self.RootViewPanel then
      self.RootViewPanel:RefreshCommonActionState()
    end
    return
  end
  if "PetTransform" == OperationType then
    if self:ShouldShowPetDetailPanel() and self.CharacterEditPanel then
      self.CharacterEditPanel:RefreshView()
    end
    if self.RootViewPanel then
      self.RootViewPanel:RefreshCommonActionState()
    end
    return
  end
  if "ItemTransform" == OperationType then
    if self:ShouldShowItemDetailPanel() and self.CharacterEditPanel then
      self.CharacterEditPanel:RefreshView()
    end
    if self.RootViewPanel then
      self.RootViewPanel:RefreshCommonActionState()
    end
    return
  end
  if "ItemChoose" == OperationType then
    self:_InitSelectedItemSlotIndex()
    if self.RootViewPanel and self.RootViewPanel.RefreshItemSlotItem then
      for SlotIndex in pairs(Operation.AffectedItemSlotIndices or {}) do
        self.RootViewPanel:RefreshItemSlotItem(SlotIndex)
      end
      self.RootViewPanel:RefreshItemSlotSelection()
    end
    if self:IsChoosePageActive() and self.ActiveChooseMode == "Item" then
      self:_RefreshChoosePageEquippedEntryState()
      if self.ChoosePagePanel then
        self.ChoosePagePanel:RefreshTitle()
      end
    else
      self:RefreshSelectedItemSlotContext()
    end
    if self.RootViewPanel then
      self.RootViewPanel:RefreshCommonActionState()
      self.RootViewPanel:RefreshTitleText()
    end
    return
  end
  if "PetSlotChange" == OperationType then
    local SlotCount = DisplayConfig:GetPetSlotCount()
    if self.RootViewPanel and self.RootViewPanel.RefreshPetSlotItem then
      for SlotIndex = 1, SlotCount do
        self.RootViewPanel:RefreshPetSlotItem(SlotIndex)
      end
    else
      self:_RefreshAffectedPetSlotItems(Operation.AffectedSlotIndices)
    end
    if self:IsChoosePageActive() and self.ActiveChooseMode == "Pet" then
      if self.ChoosePagePanel then
        if self.ChoosePagePanel.RefreshBottomKeyInfo then
          self.ChoosePagePanel:RefreshBottomKeyInfo()
        end
        if self.ChoosePagePanel.RefreshView then
          self.ChoosePagePanel:RefreshView()
        end
      end
      if self.RootViewPanel then
        if self.RootViewPanel.RefreshCommonActionState then
          self.RootViewPanel:RefreshCommonActionState()
        end
        if self.RootViewPanel.RefreshTitleText then
          self.RootViewPanel:RefreshTitleText()
        end
      end
      self:_SyncFocusedPetHighlight()
      return
    end
    self:RefreshSelectedPetSlotContext()
    if self.RootViewPanel then
      if self.RootViewPanel.RefreshCommonActionState then
        self.RootViewPanel:RefreshCommonActionState()
      end
      if self.RootViewPanel.RefreshTitleText then
        self.RootViewPanel:RefreshTitleText()
      end
    end
    return
  end
  if "CharacterWeaponAction" == OperationType then
    if self:IsChoosePageActive() then
      if self.ActiveChooseMode == "Weapon" or self.ActiveChooseMode == "Action" then
        self.ChoosePagePanel:RefreshTitle()
        self.ChoosePagePanel:RefreshBottomKeyInfo()
      end
      self:_RefreshChoosePageEquippedEntryState()
      if self.RootViewPanel then
        self.RootViewPanel:RefreshCommonActionState()
        self.RootViewPanel:RefreshTitleText()
      end
      return
    end
    if self.RootViewPanel then
      self.RootViewPanel:RefreshCommonActionState()
      self.RootViewPanel:RefreshTitleText()
    end
    if self:ShouldShowCharacterDetailPanel() and self.CharacterEditPanel then
      self.CharacterEditPanel:RefreshView()
    end
    return
  end
  if "SceneSwitch" == OperationType then
    self.SelectedSceneId = self:_GetCurrentSceneId()
    self.UsedSceneId = self.SelectedSceneId
    if self:IsScenePageActive() and self.ScenePagePanel then
      self.ScenePagePanel:RefreshSelectedSceneState(self:_GetCurrentSceneId(), self:_GetUsedSceneId())
    end
    if self.RootViewPanel then
      self.RootViewPanel:RefreshCommonActionState()
    end
    return
  end
  if "SceneLight" == OperationType then
    if self.ScenePagePanel then
      local SceneId = self:_GetCurrentSceneId()
      self.ScenePagePanel:RefreshSceneLightFromDraft(SceneId, self:IsScenePageActive())
    end
    if self.RootViewPanel then
      self.RootViewPanel:RefreshCommonActionState()
    end
    return
  end
  if "CameraAdjust" == OperationType then
    if self.RootViewPanel then
      self.RootViewPanel:RefreshCommonActionState()
    end
    return
  end
  if "FilterSwitch" == OperationType or "FilterIntensity" == OperationType then
    self:_RefreshOtherFilterAfterHistory()
    self:_RefreshRootCommonActionState()
    return
  end
  if "StickerSwitch" == OperationType or "StickerRemove" == OperationType or "StickerTransform" == OperationType then
    self:_RefreshOtherStickerAfterHistory()
    self:_RefreshRootCommonActionState()
    return
  end
  self:RefreshRootView()
end

function M:_RefreshOtherFilterAfterHistory()
  self.bHasLocalFilterDraft = true
  local OtherPage = self.OtherPagePanel
  if OtherPage and OtherPage.EditModel_Filters and OtherPage.EditModel_Filters.SyncSelectionFromWorkingFilter then
    OtherPage.EditModel_Filters:SyncSelectionFromWorkingFilter()
  elseif OtherPage and OtherPage.EditModel_Filters and OtherPage.EditModel_Filters.RefreshView then
    OtherPage.EditModel_Filters:RefreshView()
  end
  self:_RefreshPreviewFilterEffect()
end

function M:_RefreshPreviewFilterEffect()
  if not self.DisplayController or not self.DisplayController.ApplyFilterEffect then
    return
  end
  self.DisplayController:ApplyFilterEffect(self:GetWorkingFilterData())
end

function M:_RefreshOtherStickerAfterHistory()
  self.bHasLocalStickerDraft = true
  local StickerData = self:GetWorkingStickerData()
  local OtherPage = self.OtherPagePanel
  if OtherPage and OtherPage.SyncStickerSelectionToWorking then
    OtherPage:SyncStickerSelectionToWorking()
  end
  if self:IsStickerEditPageActive() then
    local RootViewPanel = self.RootViewPanel
    local EditWidget = RootViewPanel and RootViewPanel.StickersEditWidget or nil
    if EditWidget and EditWidget.ApplyStickerTransform and type(StickerData) == "table" then
      EditWidget:ApplyStickerTransform(StickerData.PosX, StickerData.PosY, StickerData.Scale)
      if EditWidget.CaptureInitialTransformSnapshot then
        EditWidget:CaptureInitialTransformSnapshot()
      end
      if EditWidget._NotifyHostTransformChanged then
        EditWidget:_NotifyHostTransformChanged()
      end
    end
    self:ClearRootStickerPreview()
    return
  end
  self:RefreshRootStickerPreview()
end

function M:_BuildHistoryDraftSummary(Draft)
  local Other = Draft and Draft.Other or nil
  local Filter = Other and Other.Filter or nil
  local Sticker = Other and Other.Sticker or nil
  local Summary = {
    SceneId = Draft and Draft.Scene and Draft.Scene.SceneId or nil,
    CharacterSlots = {},
    PetSlots = {},
    Camera = {
      LocalPosition = Draft and Draft.Camera and Draft.Camera.LocalPosition or nil,
      LocalRotation = Draft and Draft.Camera and Draft.Camera.LocalRotation or nil,
      Distance = Draft and Draft.Camera and Draft.Camera.Distance or nil,
      Offset = Draft and Draft.Camera and Draft.Camera.Offset or nil,
      Rotation = Draft and Draft.Camera and Draft.Camera.Rotation or nil,
      HasCustomCamera = Draft and Draft.Camera and Draft.Camera.HasCustomCamera or false
    },
    Filter = {
      FilterId = type(Filter) == "table" and (Filter.FilterId or Filter.Id) or Filter,
      Intensity = type(Filter) == "table" and Filter.Intensity or nil
    },
    Sticker = {
      StickerId = type(Sticker) == "table" and (Sticker.StickerId or Sticker.Id) or Sticker,
      PosX = type(Sticker) == "table" and Sticker.PosX or nil,
      PosY = type(Sticker) == "table" and Sticker.PosY or nil,
      Scale = type(Sticker) == "table" and Sticker.Scale or nil
    }
  }
  local CharacterSlots = Draft and Draft.CharacterSlots or nil
  for SlotIndex = 1, 4 do
    local Slot = CharacterSlots and CharacterSlots[SlotIndex] or nil
    Summary.CharacterSlots[SlotIndex] = {
      CharUuid = Slot and Slot.CharData and Slot.CharData.CharUuid or nil,
      WeaponId = Slot and Slot.WeaponData and Slot.WeaponData.WeaponId or nil,
      ActionPose = Slot and Slot.Action and (Slot.Action.PoseId or Slot.Action.PoseTag or Slot.Action.PoseName) or nil,
      Transform = Slot and Slot.Transform or nil,
      TransformRotation = Slot and Slot.TransformRotation or nil
    }
  end
  local PetSlots = Draft and Draft.PetSlots or nil
  local PetSlotCount = DisplayConfig:GetPetSlotCount()
  for SlotIndex = 1, PetSlotCount do
    local Slot = PetSlots and PetSlots[SlotIndex] or nil
    Summary.PetSlots[SlotIndex] = {
      UniqueId = Slot and Slot.PetData and Slot.PetData.UniqueId or nil,
      Transform = Slot and Slot.Transform or nil,
      TransformRotation = Slot and Slot.TransformRotation or nil
    }
  end
  return Summary
end

function M:_FormatHistoryVector(Value)
  if type(Value) ~= "table" then
    return tostring(Value)
  end
  return string.format("(%s, %s, %s)", tostring(Value.X), tostring(Value.Y), tostring(Value.Z))
end

function M:_FormatHistoryRotator(Value)
  if type(Value) ~= "table" then
    return tostring(Value)
  end
  return string.format("(%s, %s, %s)", tostring(Value.Pitch), tostring(Value.Yaw), tostring(Value.Roll))
end

function M:_BuildHistoryOperationLog(ActionName, Operation, BeforeSummary, AfterSummary)
  local OperationType = Operation and Operation.Type or "Unknown"
  local ChangeParts = {}
  if "SceneSwitch" == OperationType then
    ChangeParts[#ChangeParts + 1] = string.format("场景：%s -> %s；Used态：%s -> %s", tostring(BeforeSummary.SceneId), tostring(AfterSummary.SceneId), tostring(BeforeSummary.SceneId), tostring(AfterSummary.SceneId))
  elseif "CharacterChooseCommit" == OperationType or "CharacterWeaponAction" == OperationType or "CharacterTransform" == OperationType then
    local AffectedSlotIndices = Operation and Operation.AffectedSlotIndices or nil
    local bHasAnyAffectedSlot = false
    for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
      if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
        bHasAnyAffectedSlot = true
        local BeforeSlot = BeforeSummary.CharacterSlots and BeforeSummary.CharacterSlots[SlotIndex] or {}
        local AfterSlot = AfterSummary.CharacterSlots and AfterSummary.CharacterSlots[SlotIndex] or {}
        if "CharacterTransform" == OperationType then
          ChangeParts[#ChangeParts + 1] = string.format("槽位%d：位置 %s -> %s；旋转 %s -> %s", SlotIndex, self:_FormatHistoryVector(BeforeSlot.Transform), self:_FormatHistoryVector(AfterSlot.Transform), self:_FormatHistoryRotator(BeforeSlot.TransformRotation), self:_FormatHistoryRotator(AfterSlot.TransformRotation))
        else
          ChangeParts[#ChangeParts + 1] = string.format("槽位%d：角色 %s -> %s；武器 %s -> %s；动作 %s -> %s", SlotIndex, tostring(BeforeSlot.CharUuid), tostring(AfterSlot.CharUuid), tostring(BeforeSlot.WeaponId), tostring(AfterSlot.WeaponId), tostring(BeforeSlot.ActionPose), tostring(AfterSlot.ActionPose))
        end
      end
    end
    if not bHasAnyAffectedSlot then
      ChangeParts[#ChangeParts + 1] = "未记录受影响槽位，需结合当前草稿查看"
    end
  elseif "PetTransform" == OperationType then
    local AffectedSlotIndices = Operation and Operation.AffectedSlotIndices or nil
    local bHasAnyAffectedSlot = false
    for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
      if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
        bHasAnyAffectedSlot = true
        local BeforeSlot = BeforeSummary.PetSlots and BeforeSummary.PetSlots[SlotIndex] or {}
        local AfterSlot = AfterSummary.PetSlots and AfterSummary.PetSlots[SlotIndex] or {}
        ChangeParts[#ChangeParts + 1] = string.format("魔灵槽位%d：位置 %s -> %s；旋转 %s -> %s", SlotIndex, self:_FormatHistoryVector(BeforeSlot.Transform), self:_FormatHistoryVector(AfterSlot.Transform), self:_FormatHistoryRotator(BeforeSlot.TransformRotation), self:_FormatHistoryRotator(AfterSlot.TransformRotation))
      end
    end
    if not bHasAnyAffectedSlot then
      ChangeParts[#ChangeParts + 1] = "未记录受影响魔灵槽位，需结合当前草稿查看"
    end
  elseif "PetSlotChange" == OperationType then
    local AffectedSlotIndices = Operation and Operation.AffectedSlotIndices or nil
    local bHasAnyAffectedSlot = false
    for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
      if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
        bHasAnyAffectedSlot = true
        local BeforeSlot = BeforeSummary.PetSlots and BeforeSummary.PetSlots[SlotIndex] or {}
        local AfterSlot = AfterSummary.PetSlots and AfterSummary.PetSlots[SlotIndex] or {}
        ChangeParts[#ChangeParts + 1] = string.format("魔灵槽位%d：魔灵 %s -> %s", SlotIndex, tostring(BeforeSlot.UniqueId), tostring(AfterSlot.UniqueId))
      end
    end
    if not bHasAnyAffectedSlot then
      ChangeParts[#ChangeParts + 1] = "未记录受影响魔灵槽位，需结合当前草稿查看"
    end
  elseif "CameraAdjust" == OperationType then
    ChangeParts[#ChangeParts + 1] = string.format("镜头局部位置 %s -> %s；镜头局部旋转 %s -> %s；镜头距离 %s -> %s；HasCustomCamera %s -> %s", self:_FormatHistoryVector(BeforeSummary.Camera and BeforeSummary.Camera.LocalPosition or nil), self:_FormatHistoryVector(AfterSummary.Camera and AfterSummary.Camera.LocalPosition or nil), self:_FormatHistoryRotator(BeforeSummary.Camera and BeforeSummary.Camera.LocalRotation or nil), self:_FormatHistoryRotator(AfterSummary.Camera and AfterSummary.Camera.LocalRotation or nil), tostring(BeforeSummary.Camera and BeforeSummary.Camera.Distance or nil), tostring(AfterSummary.Camera and AfterSummary.Camera.Distance or nil), tostring(BeforeSummary.Camera and BeforeSummary.Camera.HasCustomCamera or false), tostring(AfterSummary.Camera and AfterSummary.Camera.HasCustomCamera or false))
  elseif "FilterSwitch" == OperationType or "FilterIntensity" == OperationType then
    local BeforeFilter = BeforeSummary.Filter or {}
    local AfterFilter = AfterSummary.Filter or {}
    ChangeParts[#ChangeParts + 1] = string.format("滤镜 Id %s -> %s；强度 %s -> %s", tostring(BeforeFilter.FilterId), tostring(AfterFilter.FilterId), tostring(BeforeFilter.Intensity), tostring(AfterFilter.Intensity))
  elseif "StickerSwitch" == OperationType or "StickerRemove" == OperationType or "StickerTransform" == OperationType then
    local BeforeSticker = BeforeSummary.Sticker or {}
    local AfterSticker = AfterSummary.Sticker or {}
    ChangeParts[#ChangeParts + 1] = string.format("贴纸 Id %s -> %s；位置 (%s, %s) -> (%s, %s)；缩放 %s -> %s", tostring(BeforeSticker.StickerId), tostring(AfterSticker.StickerId), tostring(BeforeSticker.PosX), tostring(BeforeSticker.PosY), tostring(AfterSticker.PosX), tostring(AfterSticker.PosY), tostring(BeforeSticker.Scale), tostring(AfterSticker.Scale))
  else
    ChangeParts[#ChangeParts + 1] = "当前历史类型未配置详细差异文本"
  end
  return string.format("%s操作：%s；%s", ActionName, tostring(OperationType), table.concat(ChangeParts, "；"))
end

function M:SetActiveMainTab(TabName)
  if "Char" ~= TabName and "Pet" ~= TabName and "Item" ~= TabName and "Scene" ~= TabName and "Other" ~= TabName then
    return
  end
  if self.ActiveTabName == TabName then
    if "Scene" == TabName and "Scene" == self.ActiveSubPageName then
      return
    end
    if "Other" == TabName and "Other" == self.ActiveSubPageName then
      return
    end
    if "Pet" == TabName and self.ActiveSubPageName == "PetMain" then
      return
    end
    if "Item" == TabName and self.ActiveSubPageName == "ItemMain" then
      return
    end
    if "Char" == TabName and self.ActiveSubPageName == "CharacterMain" then
      return
    end
  end
  if self:IsStickerEditPageActive() then
    self:_RestoreStickerEditEnterSnapshot()
    self:HideStickerEdit()
  end
  self.ActiveTabName = TabName
  if self.RootViewPanel and self.RootViewPanel.Change and self.RootViewPanel.PlayAnimation then
    self.RootViewPanel:PlayAnimation(self.RootViewPanel.Change)
    self.RootViewPanel:PlayAnimation(self.RootViewPanel.Change_List)
  end
  if "Scene" == TabName then
    self.ActiveSubPageName = "Scene"
    self.ActiveCharacterPanelState = "Main"
    self.ActiveChooseMode = nil
    self:_CreateScenePageIfNeeded()
  elseif "Other" == TabName then
    self.ActiveSubPageName = "Other"
    self.ActiveCharacterPanelState = "Main"
    self.ActiveChooseMode = nil
    self:_CreateOtherPageIfNeeded()
  elseif "Pet" == TabName then
    self.ActiveSubPageName = "PetMain"
    self.ActiveCharacterPanelState = "Main"
    self.ActivePetPanelState = "Main"
    self.ActiveChooseMode = nil
    self:_InitSelectedPetSlotIndex()
  elseif "Item" == TabName then
    self.ActiveSubPageName = "ItemMain"
    self.ActiveCharacterPanelState = "Main"
    self.ActivePetPanelState = "Main"
    self.ActiveChooseMode = nil
    self:_InitSelectedItemSlotIndex()
    self:_CreateCharacterEditPanelIfNeeded()
  else
    self.ActiveSubPageName = "CharacterMain"
    self.ActiveCharacterPanelState = "Main"
    self.ActivePetPanelState = "Main"
    self.ActiveChooseMode = nil
    self:_CreateCharacterEditPanelIfNeeded()
  end
  self:_SyncFocusedCharacterHighlight()
  self:RefreshRootView()
  if "Other" == TabName and self.OtherPagePanel then
    if self.OtherPagePanel.OnEnterOtherTab then
      self.OtherPagePanel:OnEnterOtherTab()
    end
    if self.OtherPagePanel.PlayChangeListAnimation then
      self.OtherPagePanel:PlayChangeListAnimation()
    end
  end
  if "Pet" == TabName and self.SelectedPetSlotIndex then
    local bHasPet = self:HasSelectedPet()
    self:_SelectPetSlot(self.SelectedPetSlotIndex, {
      OpenHighlight = bHasPet,
      OpenDetail = bHasPet,
      ForceRefresh = true
    })
  end
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
end

function M:_SyncFocusedCharacterHighlight()
  if not self.DisplayController then
    return
  end
  if self.ActiveTabName == "Scene" or "Scene" == self.ActiveSubPageName or self.ActiveTabName == "Other" or self.ActiveSubPageName == "Other" then
    self.DisplayController:ClearFocusHighlight()
    return
  end
  if self.ActiveTabName == "Item" then
    self:_SyncFocusedItemHighlight()
    return
  end
  if self.ActiveTabName == "Pet" or self.ActiveSubPageName == "PetMain" then
    self:_SyncFocusedPetHighlight()
    return
  end
  local SlotIndex = self.SelectedCharacterSlotIndex
  if self.ActiveChooseMode == "Character" and type(self.CharacterChoosePreviewSceneSlotIndex) == "number" and self.CharacterChoosePreviewSceneSlotIndex > 0 then
    SlotIndex = self.CharacterChoosePreviewSceneSlotIndex
  end
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    self.DisplayController:ClearFocusHighlight()
    return
  end
  local Slot = self:_GetCharacterSlot(SlotIndex, self:IsCharacterChoosePageActive())
  if not DisplayDraft:IsCharacterSlotOccupied(Slot) then
    self.DisplayController:ClearFocusHighlight()
    return
  end
  self:SetFocusedCharacterSlot(SlotIndex, true)
end

function M:_SyncFocusedPetHighlight()
  if not self.DisplayController then
    return
  end
  local SlotIndex = self.SelectedPetSlotIndex
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 or not self:HasSelectedPet() then
    self.DisplayController:ClearFocusHighlight()
    return
  end
  self:SetFocusedPetSlot(SlotIndex, true)
end

function M:_SyncFocusedItemHighlight()
  if not self.DisplayController then
    return
  end
  if self.ActiveTabName ~= "Item" then
    return
  end
  local SlotIndex = self.SelectedItemSlotIndex
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 or not self:HasSelectedItem() then
    self.DisplayController:ClearFocusHighlight()
    return
  end
  self:SetFocusedItemSlot(SlotIndex, true)
end

function M:SetSelectedPetSlotIndex(SlotIndex, Options)
  return self:_SelectPetSlot(SlotIndex, Options)
end

function M:_SelectPetSlot(SlotIndex, Options)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  Options = Options or {}
  local Slot = self:_GetPetSlot(SlotIndex)
  local bHasPet = DisplayDraft:IsPetSlotOccupied(Slot)
  local bOpenHighlight = Options.OpenHighlight == true and bHasPet
  local bOpenDetail = true == Options.OpenDetail and bHasPet
  local bForceRefresh = true == Options.ForceRefresh
  if self.SelectedPetSlotIndex == SlotIndex and not bForceRefresh then
    if bOpenHighlight then
      self:SetFocusedPetSlot(SlotIndex, true)
    end
    self:RefreshSelectedPetSlotContext()
    if bOpenDetail then
      self:OpenSelectedPetDetailPanelWithoutFocus()
    end
    return true
  end
  self.SelectedPetSlotIndex = SlotIndex
  if bOpenHighlight then
    self:SetFocusedPetSlot(SlotIndex, true)
  elseif self.DisplayController and not bHasPet then
    self.DisplayController:ClearFocusHighlight()
  end
  if not bHasPet then
    self.ActivePetPanelState = "Main"
  end
  self:RefreshSelectedPetSlotContext()
  if bOpenDetail then
    self:OpenSelectedPetDetailPanelWithoutFocus()
  end
  return true
end

function M:RefreshSelectedPetSlotContext()
  self:_SyncCurrentEditUIState()
  self:_RefreshViewByUIModelDiff()
  if self.CharacterEditPanel and self:ShouldShowPetDetailPanel() then
    self.CharacterEditPanel:RefreshView()
  end
  local ChoosePagePanel = self.ChoosePagePanel
  if self:IsChoosePageActive() and self.ActiveChooseMode == "Pet" and ChoosePagePanel and ChoosePagePanel.EditRootController then
    if ChoosePagePanel._SyncEquippedContentAsSelectedForUniqueEquipModes then
      ChoosePagePanel:_SyncEquippedContentAsSelectedForUniqueEquipModes()
    end
    self:_RefreshChoosePageEquippedEntryState()
    if ChoosePagePanel.RefreshTitle then
      ChoosePagePanel:RefreshTitle()
    end
    if ChoosePagePanel.RefreshBottomKeyInfo then
      ChoosePagePanel:RefreshBottomKeyInfo()
    end
  end
  self:_SyncFocusedPetHighlight()
end

function M:OpenSelectedPetDetailPanelWithoutFocus()
  if not self:IsPetMainPageActive() then
    return false
  end
  if not self:HasSelectedPet() then
    return false
  end
  self.ActivePetPanelState = "Detail"
  self:RefreshCharacterPanelStateContext()
  return true
end

function M:GetSelectedPetSlotIndex()
  return self.SelectedPetSlotIndex
end

function M:_InitSelectedPetSlotIndex()
  self.SelectedPetSlotIndex = self:_ResolvePreferredPetSlotIndex(self.SelectedPetSlotIndex)
end

function M:_ResolvePreferredPetSlotIndex(PreferredSlotIndex)
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  local SlotCount = DisplayConfig:GetPetSlotCount()
  if type(PreferredSlotIndex) == "number" and PreferredSlotIndex > 0 and PreferredSlotIndex <= SlotCount then
    local PreferredSlot = Draft and Draft.PetSlots and Draft.PetSlots[PreferredSlotIndex] or nil
    if DisplayDraft:IsPetSlotOccupied(PreferredSlot) then
      return PreferredSlotIndex
    end
  end
  for SlotIndex = 1, SlotCount do
    local Slot = Draft and Draft.PetSlots and Draft.PetSlots[SlotIndex] or nil
    if DisplayDraft:IsPetSlotOccupied(Slot) then
      return SlotIndex
    end
  end
  return nil
end

function M:_FindFirstEmptyPetSlotIndex()
  local SlotCount = DisplayConfig:GetPetSlotCount()
  for SlotIndex = 1, SlotCount do
    local Slot = self:_GetPetSlot(SlotIndex)
    if not DisplayDraft:IsPetSlotOccupied(Slot) then
      return SlotIndex
    end
  end
  return nil
end

function M:_FindNextEmptyPetSlotIndex(StartSlotIndex)
  local SlotCount = DisplayConfig:GetPetSlotCount()
  local BeginIndex = type(StartSlotIndex) == "number" and StartSlotIndex or 1
  for SlotIndex = BeginIndex + 1, SlotCount do
    local Slot = self:_GetPetSlot(SlotIndex)
    if not DisplayDraft:IsPetSlotOccupied(Slot) then
      return SlotIndex
    end
  end
  for SlotIndex = 1, BeginIndex - 1 do
    local Slot = self:_GetPetSlot(SlotIndex)
    if not DisplayDraft:IsPetSlotOccupied(Slot) then
      return SlotIndex
    end
  end
  return nil
end

function M:_SelectFirstEditableEmptyPetSlot()
  local EmptySlotIndex = self:_FindFirstEmptyPetSlotIndex()
  if nil == EmptySlotIndex then
    EmptySlotIndex = 1
  end
  self:_SelectPetSlot(EmptySlotIndex, {ForceRefresh = true})
end

function M:_SelectNextEditableEmptyPetSlot()
  local EmptySlotIndex = self:_FindNextEmptyPetSlotIndex(self:GetSelectedPetSlotIndex())
  if nil == EmptySlotIndex then
    return
  end
  self:_SelectPetSlot(EmptySlotIndex, {ForceRefresh = true})
end

function M:_FindNextEmptyItemSlotIndex(StartSlotIndex)
  local SlotCount = DisplayConfig:GetItemSlotCount()
  local BeginIndex = type(StartSlotIndex) == "number" and StartSlotIndex or 1
  for SlotIndex = BeginIndex + 1, SlotCount do
    local Slot = self:_GetItemSlot(SlotIndex)
    if not DisplayDraft:IsItemSlotOccupied(Slot) then
      return SlotIndex
    end
  end
  for SlotIndex = 1, BeginIndex - 1 do
    local Slot = self:_GetItemSlot(SlotIndex)
    if not DisplayDraft:IsItemSlotOccupied(Slot) then
      return SlotIndex
    end
  end
  return nil
end

function M:_SelectNextEditableEmptyItemSlot()
  local EmptySlotIndex = self:_FindNextEmptyItemSlotIndex(self:GetSelectedItemSlotIndex())
  if nil == EmptySlotIndex then
    return
  end
  self:SetSelectedItemSlotIndex(EmptySlotIndex)
end

function M:SetSelectedCharacterSlotIndex(SlotIndex, Options)
  return self:_SelectCharacterSlot(SlotIndex, Options)
end

function M:_SelectCharacterSlot(SlotIndex, Options)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  Options = Options or {}
  local PreviousSelectedSlotIndex = self.SelectedCharacterSlotIndex
  local Slot = self:_GetCharacterSlot(SlotIndex, self:IsCharacterChoosePageActive())
  local bHasCharacter = DisplayDraft:IsCharacterSlotOccupied(Slot)
  local bOpenHighlight = Options.OpenHighlight == true and bHasCharacter
  local bOpenDetail = true == Options.OpenDetail and bHasCharacter
  local bForceRefresh = true == Options.ForceRefresh
  DebugPrint(string.format("PersonInfoEdit: SelectCharacterSlot slot=%s hasCharacter=%s openHighlight=%s openDetail=%s forceRefresh=%s activeSubPage=%s panelState=%s", tostring(SlotIndex), tostring(bHasCharacter), tostring(bOpenHighlight), tostring(bOpenDetail), tostring(bForceRefresh), tostring(self.ActiveSubPageName), tostring(self.ActiveCharacterPanelState)))
  if self.SelectedCharacterSlotIndex == SlotIndex and self.ActiveChooseMode ~= "Character" and not bForceRefresh then
    if bOpenHighlight then
      self:SetFocusedCharacterSlot(SlotIndex, true)
    end
    if self.CharacterEditPanel and self:ShouldShowCharacterDetailPanel() then
      self.CharacterEditPanel:RefreshView()
    end
    if bOpenDetail then
      self:OpenSelectedCharacterDetailPanel()
    end
    return true
  end
  if self.ActiveChooseMode == "Character" and self.PendingCharacterChoosePreview ~= nil then
    self:CancelPendingCharacterChoosePreview()
    self.ChoosePagePanel:_HideCharacterTips(false)
  end
  self.SelectedCharacterSlotIndex = SlotIndex
  self.SelectCharIndex = SlotIndex
  if bOpenHighlight then
    self:SetFocusedCharacterSlot(SlotIndex, bOpenHighlight)
  elseif self.DisplayController and self.ActiveChooseMode == "Character" then
    self.DisplayController:ClearFocusHighlight()
  end
  self:RefreshSelectedCharacterSlotContext()
  if self:ShouldShowCharacterDetailPanel() then
    self.RootViewPanel:PlayAnimation(self.RootViewPanel.Change_List)
  end
  if self:IsChoosePageActive() and self.ActiveChooseMode ~= "Character" and self.RootViewPanel and self.RootViewPanel.Change and self.RootViewPanel.PlayAnimation then
    self.RootViewPanel:PlayAnimation(self.RootViewPanel.Change)
  end
  if self:IsChoosePageActive() and self.ActiveChooseMode ~= "Character" then
    local bWeaponSubTabSwitched = false
    if PreviousSelectedSlotIndex ~= SlotIndex and self.ActiveChooseMode == "Weapon" and self.ChoosePagePanel and self.ChoosePagePanel.TrySyncWeaponSubTabWithSelectedSlot then
      bWeaponSubTabSwitched = self.ChoosePagePanel:TrySyncWeaponSubTabWithSelectedSlot()
    end
    if not bWeaponSubTabSwitched then
      if PreviousSelectedSlotIndex ~= SlotIndex and self.ChoosePagePanel and self.ChoosePagePanel._SyncEquippedContentAsSelectedForUniqueEquipModes then
        self.ChoosePagePanel:_SyncEquippedContentAsSelectedForUniqueEquipModes()
      end
      self:_RefreshChoosePageEquippedEntryState()
      if self.ChoosePagePanel then
        self.ChoosePagePanel:RefreshTitle()
        self.ChoosePagePanel:RefreshBottomKeyInfo()
      end
    end
  end
  if bOpenDetail then
    self:OpenSelectedCharacterDetailPanel()
  end
  return true
end

function M:OpenSelectedCharacterDetailPanel()
  DebugPrint(string.format("PersonInfoEdit: OpenSelectedCharacterDetailPanel before activeSubPage=%s panelState=%s hasSelected=%s selectedSlot=%s", tostring(self.ActiveSubPageName), tostring(self.ActiveCharacterPanelState), tostring(self:HasSelectedCharacter()), tostring(self.SelectedCharacterSlotIndex)))
  if not self:IsCharacterMainPageActive() then
    DebugPrint("PersonInfoEdit: OpenSelectedCharacterDetailPanel abort because not character main page")
    return false
  end
  if not self:HasSelectedCharacter() then
    DebugPrint("PersonInfoEdit: OpenSelectedCharacterDetailPanel abort because no selected character")
    return false
  end
  self.ActiveCharacterPanelState = "Detail"
  self:RefreshCharacterPanelStateContext()
  if self:IsChoosePageActive() and self.ChoosePagePanel and self.ChoosePagePanel.Change_List and self.ChoosePagePanel.PlayAnimation then
    self.ChoosePagePanel:PlayAnimation(self.ChoosePagePanel.Change_List)
  end
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
  DebugPrint(string.format("PersonInfoEdit: OpenSelectedCharacterDetailPanel after panelState=%s shouldShow=%s", tostring(self.ActiveCharacterPanelState), tostring(self:ShouldShowCharacterDetailPanel())))
  return true
end

function M:OpenSelectedCharacterDetailPanelWithoutFocus()
  if not self:IsCharacterMainPageActive() then
    return false
  end
  if not self:HasSelectedCharacter() then
    return false
  end
  self.ActiveCharacterPanelState = "Detail"
  self:RefreshCharacterPanelStateContext()
  return true
end

function M:GetSelectedCharacterSlotIndex()
  return self.SelectedCharacterSlotIndex
end

function M:GetSelectedItemSlotIndex()
  return type(self.SelectedItemSlotIndex) == "number" and self.SelectedItemSlotIndex or nil
end

function M:SetSelectedItemSlotIndex(SlotIndex, Options)
  return self:_SelectItemSlot(SlotIndex, Options)
end

function M:_SelectItemSlot(SlotIndex, Options)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  Options = Options or {}
  local Slot = self:_GetItemSlot(SlotIndex)
  local bHasItem = DisplayDraft:IsItemSlotOccupied(Slot)
  if not bHasItem and (not self:IsChoosePageActive() or self.ActiveChooseMode ~= "Item") then
    return false
  end
  local bOpenHighlight = Options.OpenHighlight == true and bHasItem
  local bForceRefresh = true == Options.ForceRefresh
  if self.SelectedItemSlotIndex == SlotIndex and not bForceRefresh then
    if bOpenHighlight then
      self:SetFocusedItemSlot(SlotIndex, true)
    end
    self:RefreshSelectedItemSlotContext()
    return true
  end
  self.SelectedItemSlotIndex = SlotIndex
  if bOpenHighlight then
    self:SetFocusedItemSlot(SlotIndex, true)
  elseif self.DisplayController and not bHasItem then
    self.DisplayController:ClearFocusHighlight()
  end
  self:RefreshSelectedItemSlotContext()
  return true
end

function M:GetDisplayEditor()
  return self.DisplayEditor
end

function M:ReadSceneLightEditData(SceneId)
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  return DisplayPersistence:ReadSceneLightData(Draft, SceneId)
end

function M:IsChoosePageActive()
  return self.ActiveSubPageName == "Choose"
end

function M:IsScenePageActive()
  return self.ActiveSubPageName == "Scene"
end

function M:IsOtherPageActive()
  return self.ActiveSubPageName == "Other"
end

function M:IsStickerEditPageActive()
  return self.ActiveSubPageName == "StickerEdit"
end

function M:GetFilterData()
  return PersonInfoModel:GetFilterData()
end

function M:GetWorkingFilterData()
  if self.bHasLocalFilterDraft == true then
    local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
    local Other = Draft and Draft.Other or nil
    local Filter = Other and Other.Filter or nil
    if type(Filter) ~= "table" then
      return nil
    end
    local FilterId = Filter.FilterId or Filter.Id
    if nil == FilterId or "" == FilterId then
      return nil
    end
    return Filter
  end
  return self:GetFilterData()
end

function M:ApplyFilterToDraft(FilterData, OperationMeta)
  if not self.DisplayEditor or not self.DisplayEditor.SetOtherData then
    return false
  end
  local Draft = self.DisplayEditor:GetDraft()
  local Other = {}
  if type(Draft) == "table" and "table" == type(Draft.Other) then
    for Key, Value in pairs(Draft.Other) do
      Other[Key] = Value
    end
  end
  Other.Filter = FilterData
  self.bHasLocalFilterDraft = true
  return self.DisplayEditor:SetOtherData(Other, OperationMeta) == true
end

function M:CommitFilterSwitch(FilterId, Intensity)
  local bSuccess = false
  if nil == FilterId or "" == FilterId then
    bSuccess = self:ApplyFilterToDraft(nil, {
      Type = "FilterSwitch"
    })
  else
    local CustomDisplayDefaults = PersonInfoCommon.CustomDisplayDefaults
    local DefaultIntensity = tonumber(CustomDisplayDefaults.FilterIntensity) or 50
    local FilterData = {
      FilterId = FilterId,
      Intensity = math.floor((tonumber(Intensity) or DefaultIntensity) + 0.5)
    }
    bSuccess = self:ApplyFilterToDraft(FilterData, {
      Type = "FilterSwitch",
      FilterId = FilterId,
      Intensity = FilterData.Intensity
    })
  end
  self:_RefreshPreviewFilterEffect()
  return bSuccess
end

function M:BeginFilterIntensityPreview()
  if not self.DisplayEditor or not self.DisplayEditor.BeginPreviewTransaction then
    return false
  end
  return self.DisplayEditor:BeginPreviewTransaction("filter_intensity") == true
end

function M:CommitFilterIntensityPreview()
  if not self.DisplayEditor or not self.DisplayEditor.CommitPreviewTransaction then
    return false
  end
  local bCommitted = self.DisplayEditor:CommitPreviewTransaction() == true
  self:_RefreshRootCommonActionState()
  return bCommitted
end

function M:PreviewFilterIntensity(FilterId, Intensity)
  if nil == FilterId or "" == FilterId then
    return false
  end
  local FilterData = {
    FilterId = FilterId,
    Intensity = math.floor((Intensity or 0) + 0.5)
  }
  local bSuccess = self:ApplyFilterToDraft(FilterData, {
    Type = "FilterIntensity",
    FilterId = FilterId,
    Intensity = FilterData.Intensity
  })
  self:_RefreshPreviewFilterEffect()
  return bSuccess
end

function M:GetStickerData()
  return PersonInfoModel:GetStickerData()
end

function M:GetWorkingStickerData()
  if self.bHasLocalStickerDraft == true then
    local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
    local Other = Draft and Draft.Other or nil
    local Sticker = Other and Other.Sticker or nil
    if type(Sticker) ~= "table" then
      return nil
    end
    return PersonInfoModel:ResolveDisplayStickerData(Sticker)
  end
  return self:GetStickerData()
end

function M:_CloneStickerEditSnapshot(StickerData)
  if type(StickerData) ~= "table" then
    return nil
  end
  local StickerId = StickerData.StickerId or StickerData.Id
  if nil == StickerId or "" == StickerId then
    return nil
  end
  return {
    StickerId = StickerId,
    PosX = StickerData.PosX or 0,
    PosY = StickerData.PosY or 0,
    Scale = StickerData.Scale or 1,
    Icon = StickerData.Icon,
    StickerPath = StickerData.StickerPath or StickerData.Icon,
    Name = StickerData.Name
  }
end

function M:_CaptureStickerEditEnterSnapshot()
  self.StickerEditEnterSnapshot = self:_CloneStickerEditSnapshot(self:GetWorkingStickerData())
  self.bHasStickerEditEnterSnapshot = true
end

function M:_ClearStickerEditEnterSnapshot()
  self.StickerEditEnterSnapshot = nil
  self.bHasStickerEditEnterSnapshot = false
end

function M:_RestoreStickerEditEnterSnapshot()
  if not self.bHasStickerEditEnterSnapshot then
    return
  end
  local Snapshot = self.StickerEditEnterSnapshot
  self:_ClearStickerEditEnterSnapshot()
  if type(Snapshot) == "table" and Snapshot.StickerId ~= nil and Snapshot.StickerId ~= "" then
    self:ApplyStickerPreviewToDraft(Snapshot, {
      Type = "StickerTransform",
      StickerId = Snapshot.StickerId
    })
  else
    self:ApplyStickerPreviewToDraft(nil, {
      Type = "StickerRemove"
    })
  end
end

function M:OpenStickerEditPage(StickerViewData)
  if self.ActiveTabName ~= "Other" then
    return
  end
  self:_CaptureStickerEditEnterSnapshot()
  self:ClearRootStickerPreview()
  self.ActiveSubPageName = "StickerEdit"
  self:ShowStickerEdit(StickerViewData)
  self:RefreshRootView()
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
end

function M:CloseStickerEditAndReturn()
  if not self:IsStickerEditPageActive() then
    return
  end
  self:_RestoreStickerEditEnterSnapshot()
  self:HideStickerEdit()
  self.ActiveSubPageName = "Other"
  self:RefreshRootView()
  self:RefreshRootStickerPreview()
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
  if RootView and RootView.RefreshCommonActionState then
    RootView:RefreshCommonActionState()
  elseif RootView and RootView.RefreshSaveButtonState then
    RootView:RefreshSaveButtonState()
  end
end

function M:ConfirmStickerEditAndReturn()
  if not self:IsStickerEditPageActive() then
    return
  end
  local RootViewPanel = self.RootViewPanel
  local EditWidget = RootViewPanel and RootViewPanel.StickersEditWidget or nil
  local StickerData
  if EditWidget and EditWidget.ExportStickerEditData then
    StickerData = EditWidget:ExportStickerEditData()
  end
  if type(StickerData) ~= "table" or StickerData.StickerId == nil or StickerData.StickerId == "" then
    self:CloseStickerEditAndReturn()
    return
  end
  self:_ClearStickerEditEnterSnapshot()
  self:ApplyStickerPreviewToDraft(StickerData, {
    Type = "StickerTransform",
    StickerId = StickerData.StickerId
  })
  self:HideStickerEdit()
  self.ActiveSubPageName = "Other"
  self:RefreshRootView()
  self:RefreshRootStickerPreview()
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
  if RootView and RootView.RefreshCommonActionState then
    RootView:RefreshCommonActionState()
  elseif RootView and RootView.RefreshSaveButtonState then
    RootView:RefreshSaveButtonState()
  end
end

function M:ApplyStickerPreviewToDraft(StickerData, OperationMeta)
  if not self.DisplayEditor or not self.DisplayEditor.SetOtherData then
    return false
  end
  local Draft = self.DisplayEditor:GetDraft()
  local Other = {}
  if type(Draft) == "table" and "table" == type(Draft.Other) then
    for Key, Value in pairs(Draft.Other) do
      Other[Key] = Value
    end
  end
  Other.Sticker = StickerData
  self.bHasLocalStickerDraft = true
  if nil == OperationMeta then
    if nil == StickerData then
      OperationMeta = {
        Type = "StickerRemove"
      }
    else
      OperationMeta = {
        Type = "StickerSwitch",
        StickerId = StickerData.StickerId or StickerData.Id
      }
    end
  end
  return self.DisplayEditor:SetOtherData(Other, OperationMeta) == true
end

function M:ClearStickerPreview()
  self:ApplyStickerPreviewToDraft(nil, {
    Type = "StickerRemove"
  })
  self:RefreshRootStickerPreview()
  self:_RefreshRootCommonActionState()
end

function M:ApplyStickerPreviewKeepingTransform(StickerViewData)
  if type(StickerViewData) ~= "table" then
    return
  end
  local StickerId = StickerViewData.StickerId
  if nil == StickerId or "" == StickerId then
    return
  end
  local PosX, PosY, Scale = 0, 0, 1
  local WorkingData = self.GetWorkingStickerData and self:GetWorkingStickerData() or nil
  if type(WorkingData) == "table" then
    if type(WorkingData.PosX) == "number" then
      PosX = WorkingData.PosX
    end
    if "number" == type(WorkingData.PosY) then
      PosY = WorkingData.PosY
    end
    if "number" == type(WorkingData.Scale) and WorkingData.Scale > 0 then
      Scale = WorkingData.Scale
    end
  end
  local StickerData = {
    StickerId = StickerId,
    PosX = PosX,
    PosY = PosY,
    Scale = Scale,
    Icon = StickerViewData.Icon,
    StickerPath = StickerViewData.StickerPath or StickerViewData.Icon,
    Name = StickerViewData.Name
  }
  self:ApplyStickerPreviewToDraft(StickerData, {
    Type = "StickerSwitch",
    StickerId = StickerId
  })
  self:RefreshRootStickerPreview()
  self:_RefreshRootCommonActionState()
end

function M:ClearRootStickerPreview()
  if self:IsStickerEditPageActive() then
    return
  end
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.bStickerEditActive ~= true and RootView.ClearConfirmedStickerPreview then
    RootView:ClearConfirmedStickerPreview()
  end
end

function M:RefreshRootStickerPreview()
  if self:IsStickerEditPageActive() then
    return
  end
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.bStickerEditActive ~= true and RootView.RefreshConfirmedStickerPreviewFromDraft then
    RootView:RefreshConfirmedStickerPreviewFromDraft()
  end
end

function M:_RefreshRootCommonActionState()
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.RefreshCommonActionState then
    RootView:RefreshCommonActionState()
  elseif RootView and RootView.RefreshSaveButtonState then
    RootView:RefreshSaveButtonState()
  end
end

function M:CanConfirmStickerEdit()
  return self:IsStickerEditPageActive()
end

function M:ResetStickerEdit()
  if not self:IsStickerEditPageActive() then
    return
  end
  local RootViewPanel = self.RootViewPanel
  local EditWidget = RootViewPanel and RootViewPanel.StickersEditWidget or nil
  if not EditWidget or not EditWidget.ResetStickerEdit then
    return
  end
  if EditWidget.bStickerTransformPreviewActive ~= nil then
    EditWidget.bStickerTransformPreviewActive = false
  end
  EditWidget:ResetStickerEdit()
  if RootViewPanel and RootViewPanel.OnStickerEditTransformChanged then
    RootViewPanel:OnStickerEditTransformChanged()
  end
end

function M:IsStickerEditAtDefaultTransform()
  if not self:IsStickerEditPageActive() then
    return true
  end
  local RootViewPanel = self.RootViewPanel
  local EditWidget = RootViewPanel and RootViewPanel.StickersEditWidget or nil
  if EditWidget and EditWidget.IsAtDefaultTransform then
    return EditWidget:IsAtDefaultTransform()
  end
  return true
end

function M:ShowStickerEdit(StickerViewData)
  local RootViewPanel = self.RootViewPanel
  if RootViewPanel and RootViewPanel.ShowStickerEditWidget then
    RootViewPanel:ShowStickerEditWidget(StickerViewData)
  end
end

function M:HideStickerEdit()
  local RootViewPanel = self.RootViewPanel
  if RootViewPanel and RootViewPanel.HideStickerEditWidget then
    RootViewPanel:HideStickerEditWidget()
  end
end

function M:IsPetPageActive()
  return self.ActiveTabName == "Pet"
end

function M:IsPetMainPageActive()
  return self.ActiveTabName == "Pet" and self.ActiveSubPageName == "PetMain"
end

function M:IsPetChoosePageActive()
  return self.ActiveSubPageName == "Choose" and self.ActiveChooseMode == "Pet"
end

function M:IsCharacterMainPageActive()
  return self.ActiveTabName == "Char" and self.ActiveSubPageName == "CharacterMain"
end

function M:IsItemMainPageActive()
  return self.ActiveTabName == "Item" and self.ActiveSubPageName == "ItemMain"
end

function M:IsItemPageActive()
  return self.ActiveTabName == "Item"
end

function M:IsCharacterChoosePageActive()
  return self.ActiveSubPageName == "Choose" and self.ActiveChooseMode == "Character"
end

function M:IsCharacterTipsOpened()
  return self:IsCharacterChoosePageActive() and self.ChoosePagePanel ~= nil and self.ChoosePagePanel.IsCharacterTipsOpened == true
end

function M:IsSceneTipsOpened()
  return self:IsScenePageActive() and self.ScenePagePanel ~= nil and nil ~= self.ScenePagePanel.IsSceneTipsOpened and self.ScenePagePanel:IsSceneTipsOpened() == true
end

function M:RefreshPreviewCameraRoamState()
  local UIModel = self:_BuildCurrentUIModel()
  local bEnablePreviewCameraRoam = UIModel and UIModel.CanPreviewCameraRoam == true
  if self:IsCharacterTipsOpened() or self:IsSceneTipsOpened() then
    bEnablePreviewCameraRoam = false
  end
  self.bEnablePreviewCameraRoam = true == bEnablePreviewCameraRoam
  if self.RootViewPanel then
    self.RootViewPanel.EnableDrag = self.bEnablePreviewCameraRoam
    self.RootViewPanel.EnableMouseWheel = self.bEnablePreviewCameraRoam
    self.RootViewPanel.bEnableCameraRoam = self.bEnablePreviewCameraRoam
  end
  if not self.bEnablePreviewCameraRoam and self.ResetCameraRoamInput then
    self:ResetCameraRoamInput()
  end
end

function M:IsPreviewCameraRoamEnabled()
  return self.bEnablePreviewCameraRoam == true
end

function M:ShouldShowMobileLeftPanel()
  if not self:IsMobileCharacterEditToggleAvailable() then
    return false
  end
  if self.bPreferShowMobileLeftPanel ~= nil then
    return self.bPreferShowMobileLeftPanel == true
  end
  return self:_ShouldDefaultShowMobileLeftPanel()
end

function M:ShouldShowMobileCameraJoystick()
  if self:IsChoosePageActive() then
    return false
  end
  return self:IsPreviewCameraRoamEnabled() and not self:ShouldShowMobileLeftPanel()
end

function M:ToggleMobileLeftPanelMode()
  if not self:IsMobileCharacterEditToggleAvailable() then
    self.bPreferShowMobileLeftPanel = false
    return false
  end
  self.bPreferShowMobileLeftPanel = not self:ShouldShowMobileLeftPanel()
  return self.bPreferShowMobileLeftPanel == true
end

function M:GetMobileResetCameraState()
  if self:IsChoosePageActive() then
    return false, false
  end
  local bVisible = self:IsPreviewCameraRoamEnabled()
  return bVisible, bVisible and not self:_IsCurrentCameraAtSceneDefault()
end

function M:GetMainPageView()
  return self.MainPageView
end

function M:_InitEditUIStates()
  self.EditUIStateMap = {
    Root = RootState:New(self),
    CharacterEdit = CharacterEditState:New(self),
    Choose = ChooseState:New(self),
    Scene = SceneState:New(self),
    Pet = PetState:New(self),
    Other = OtherState:New(self),
    StickerEdit = StickerEditState:New(self)
  }
end

function M:_DetermineCurrentEditUIStateName()
  if self.ActiveSubPageName == "StickerEdit" then
    return "StickerEdit"
  end
  if self.ActiveTabName == "Scene" and self.ActiveSubPageName == "Scene" then
    return "Scene"
  end
  if self.ActiveTabName == "Other" and self.ActiveSubPageName == "Other" then
    return "Other"
  end
  if self.ActiveTabName == "Pet" and self.ActiveSubPageName == "PetMain" then
    return "Pet"
  end
  if self.ActiveSubPageName == "Choose" then
    return "Choose"
  end
  if self:ShouldShowCharacterDetailPanel() or self:ShouldShowItemDetailPanel() then
    return "CharacterEdit"
  end
  return "Root"
end

function M:_SyncCurrentEditUIState()
  local StateName = self:_DetermineCurrentEditUIStateName()
  if self.CurrentEditUIStateName == StateName then
    return self.CurrentEditUIState
  end
  if self.CurrentEditUIState and self.CurrentEditUIState.Exit then
    self.CurrentEditUIState:Exit()
  end
  self.CurrentEditUIStateName = StateName
  self.CurrentEditUIState = self.EditUIStateMap and self.EditUIStateMap[StateName] or nil
  if self.CurrentEditUIState and self.CurrentEditUIState.Enter then
    self.CurrentEditUIState:Enter({
      ChooseKind = self.ActiveChooseMode
    })
  end
  return self.CurrentEditUIState
end

function M:GetCurrentEditUIState()
  return self.CurrentEditUIState or self:_SyncCurrentEditUIState()
end

function M:_RefreshViewByUIModelDiff()
  local NewModel = self:_BuildCurrentUIModel()
  if not NewModel then
    self:RefreshPageStructure()
    self:RefreshActivePageContent()
    return
  end
  local OldModel = self.CurrentUIModel
  self:_RefreshTopBarByUIModelDiff(OldModel, NewModel)
  self:_RefreshSidePanelByUIModelDiff(OldModel, NewModel)
  self:_RefreshSlotPanelByUIModelDiff(OldModel, NewModel)
  self:_RefreshWSPanelByUIModelDiff(OldModel, NewModel)
  self.CurrentUIModel = NewModel
end

function M:_BuildCurrentUIModel()
  local State = self.CurrentEditUIState or self:_SyncCurrentEditUIState()
  if not State or not State.BuildUIModel then
    return nil
  end
  return State:BuildUIModel()
end

function M:_RefreshTopBarByUIModelDiff(OldModel, NewModel)
  if not OldModel or OldModel.StateName ~= NewModel.StateName or OldModel.ChooseKind ~= NewModel.ChooseKind or OldModel.TopBarMode ~= NewModel.TopBarMode then
    self.RootViewPanel:RefreshTabState()
  end
end

function M:_RefreshSidePanelByUIModelDiff(OldModel, NewModel)
  if not OldModel or OldModel.StateName ~= NewModel.StateName or OldModel.ChooseKind ~= NewModel.ChooseKind or OldModel.SidePanelMode ~= NewModel.SidePanelMode or OldModel.DetailContentKind ~= NewModel.DetailContentKind then
    self.RootViewPanel:EnsureActiveEditSubPageCreated(self)
    self.RootViewPanel:RefreshEditSubPageVisibility(self)
    self:RefreshActivePageContent()
  end
end

function M:_RefreshSlotPanelByUIModelDiff(OldModel, NewModel)
  if not OldModel or OldModel.SlotPanelMode ~= NewModel.SlotPanelMode then
    self.RootViewPanel:RefreshSlotAreaState()
    return
  end
  if OldModel.FocusSlotIndex ~= NewModel.FocusSlotIndex then
    if NewModel.SlotPanelMode == "ItemSlot" then
      self.RootViewPanel:RefreshItemSlotSelection()
    else
      self.RootViewPanel:RefreshSelectedCharacterSlotContext()
    end
  end
end

function M:_RefreshWSPanelByUIModelDiff(OldModel, NewModel)
  if not OldModel or OldModel.StateName ~= NewModel.StateName or OldModel.ChooseKind ~= NewModel.ChooseKind or OldModel.WSMode ~= NewModel.WSMode or OldModel.DetailContentKind ~= NewModel.DetailContentKind then
    self.RootViewPanel:RefreshCommonActionState()
    self.RootViewPanel:RefreshTitleText()
  end
end

function M:RefreshImageClickMaskState()
end

function M:TryCloseCharacterTipsByMask()
  local ChoosePagePanel = self.ChoosePagePanel
  if not ChoosePagePanel then
    return false
  end
  if self:IsCharacterTipsOpened() and ChoosePagePanel._TryCloseCharacterTips then
    ChoosePagePanel:_TryCloseCharacterTips()
    return true
  end
  if self.ActiveChooseMode == "Item" and ChoosePagePanel.bItemDetailsOpened and ChoosePagePanel.HideItemDetails then
    ChoosePagePanel:HideItemDetails()
    return true
  end
  return false
end

function M:GetActiveMainTabName()
  return self.ActiveTabName or "Char"
end

function M:CanCloseDirectly()
  return not self:IsDirty()
end

function M:RequestCloseEdit()
  if self:CanCloseDirectly() then
    self:_CloseOwnerEditPage()
    return true
  end
  if UIManager(self.OwnerWidget):GetUIObj("CommonDialog") ~= nil then
    return true
  end
  local Params = {
    RightCallbackFunction = function()
      self:_ClearStickerEditEnterSnapshot()
      self:_RestoreDraftOnAbandonIfNeeded()
      self:_CloseOwnerEditPage()
    end
  }
  UIManager(self.OwnerWidget):ShowCommonPopupUI(100398, Params, self.OwnerWidget)
  return true
end

function M:_IsCurrentCameraAtSceneDefault()
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  local CurrentCamera = Draft and Draft.Camera or nil
  if type(CurrentCamera) ~= "table" then
    return true
  end
  local SceneId = Draft and Draft.Scene and Draft.Scene.SceneId or nil
  local DefaultDraft = DisplayDraft:CreateEmpty(SceneId)
  local DefaultCamera = DefaultDraft and DefaultDraft.Camera or nil
  if type(DefaultCamera) ~= "table" then
    return false
  end
  return self:_IsCameraDataEquivalent(CurrentCamera, DefaultCamera)
end

function M:_IsCameraDataEquivalent(CameraA, CameraB)
  if type(CameraA) ~= "table" or type(CameraB) ~= "table" then
    return false
  end
  return self:_IsCameraNumberEqual(CameraA.Distance, CameraB.Distance) and self:_IsCameraOffsetEquivalent(CameraA.Offset, CameraB.Offset) and self:_IsCameraRotationEquivalent(CameraA.Rotation, CameraB.Rotation) and self:_IsCameraLocalPositionEquivalent(CameraA.LocalPosition, CameraB.LocalPosition) and self:_IsCameraLocalRotationEquivalent(CameraA.LocalRotation, CameraB.LocalRotation) and self:_IsCameraLimitConfigEquivalent(CameraA.LimitConfig, CameraB.LimitConfig)
end

function M:_IsCameraOffsetEquivalent(OffsetA, OffsetB)
  return self:_IsCameraNumberEqual(OffsetA and OffsetA.Horizontal, OffsetB and OffsetB.Horizontal) and self:_IsCameraNumberEqual(OffsetA and OffsetA.Vertical, OffsetB and OffsetB.Vertical)
end

function M:_IsCameraRotationEquivalent(RotationA, RotationB)
  return self:_IsCameraNumberEqual(RotationA and RotationA.Pitch, RotationB and RotationB.Pitch) and self:_IsCameraNumberEqual(RotationA and RotationA.Yaw, RotationB and RotationB.Yaw)
end

function M:_IsCameraLocalPositionEquivalent(PositionA, PositionB)
  return self:_IsCameraNumberEqual(PositionA and PositionA.X, PositionB and PositionB.X) and self:_IsCameraNumberEqual(PositionA and PositionA.Y, PositionB and PositionB.Y) and self:_IsCameraNumberEqual(PositionA and PositionA.Z, PositionB and PositionB.Z)
end

function M:_IsCameraLocalRotationEquivalent(RotationA, RotationB)
  return self:_IsCameraNumberEqual(RotationA and RotationA.Pitch, RotationB and RotationB.Pitch) and self:_IsCameraNumberEqual(RotationA and RotationA.Yaw, RotationB and RotationB.Yaw) and self:_IsCameraNumberEqual(RotationA and RotationA.Roll, RotationB and RotationB.Roll)
end

function M:_IsCameraLimitConfigEquivalent(ConfigA, ConfigB)
  if nil == ConfigA and nil == ConfigB then
    return true
  end
  if type(ConfigA) ~= "table" or type(ConfigB) ~= "table" then
    return false
  end
  return self:_IsCameraNumberEqual(ConfigA.DistanceMin, ConfigB.DistanceMin) and self:_IsCameraNumberEqual(ConfigA.DistanceMax, ConfigB.DistanceMax) and self:_IsCameraNumberEqual(ConfigA.HorizontalMin, ConfigB.HorizontalMin) and self:_IsCameraNumberEqual(ConfigA.HorizontalMax, ConfigB.HorizontalMax) and self:_IsCameraNumberEqual(ConfigA.VerticalMin, ConfigB.VerticalMin) and self:_IsCameraNumberEqual(ConfigA.VerticalMax, ConfigB.VerticalMax) and self:_IsCameraNumberEqual(ConfigA.PitchMin, ConfigB.PitchMin) and self:_IsCameraNumberEqual(ConfigA.PitchMax, ConfigB.PitchMax) and self:_IsCameraNumberEqual(ConfigA.YawMin, ConfigB.YawMin) and self:_IsCameraNumberEqual(ConfigA.YawMax, ConfigB.YawMax)
end

function M:_IsCameraNumberEqual(ValueA, ValueB)
  local NumberA = tonumber(ValueA)
  local NumberB = tonumber(ValueB)
  if nil == NumberA and nil == NumberB then
    return true
  end
  if nil == NumberA or nil == NumberB then
    return false
  end
  return math.abs(NumberA - NumberB) <= 0.01
end

function M:UndoEdit()
  local BeforeSummary = self:_BuildHistoryDraftSummary(self.DisplayEditor and self.DisplayEditor:GetDraft() or nil)
  local bSuccess, Operation = self.DisplayEditor:Undo()
  if bSuccess then
    local AfterSummary = self:_BuildHistoryDraftSummary(self.DisplayEditor and self.DisplayEditor:GetDraft() or nil)
    GreenPrint(self:_BuildHistoryOperationLog("撤销", Operation, BeforeSummary, AfterSummary))
    self:_RefreshAfterHistoryOperation(Operation)
  end
  return bSuccess
end

function M:RedoEdit()
  local BeforeSummary = self:_BuildHistoryDraftSummary(self.DisplayEditor and self.DisplayEditor:GetDraft() or nil)
  local bSuccess, Operation = self.DisplayEditor:Redo()
  if bSuccess then
    local AfterSummary = self:_BuildHistoryDraftSummary(self.DisplayEditor and self.DisplayEditor:GetDraft() or nil)
    GreenPrint(self:_BuildHistoryOperationLog("复原", Operation, BeforeSummary, AfterSummary))
    self:_RefreshAfterHistoryOperation(Operation)
  end
  return bSuccess
end

function M:OpenCharacterChoosePage()
  self:CancelCharacterChoosePreview()
  self.StagedCharacterChooseSelections = {}
  self.CharacterChooseBaseDraft = DisplayDraft:Clone(self.DisplayEditor:GetDraft())
  self.PendingCharacterChoosePreview = nil
  self.CharacterChoosePreviewSceneSlotIndex = nil
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "PersonInfoChoosePageOpen", nil)
  self.ActiveChooseMode = "Character"
  self.ActiveSubPageName = "Choose"
  self.ActiveCharacterPanelState = "Main"
  if not self:GetSelectedCharacterSlotIndex() or not self:HasSelectedCharacter() then
    self:_SelectFirstEditableEmptyCharacterSlot()
  end
  self:_CreateChoosePageIfNeeded()
  self.ChoosePagePanel:InitChoosePage(self, self.ActiveChooseMode, self:BuildChoosePageViewData())
  self:RefreshRootView()
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
end

function M:OpenWeaponChoosePage()
  self.WeaponChooseBaseDraft = DisplayDraft:Clone(self.DisplayEditor:GetDraft())
  self.SkipCancelWeaponChooseOnce = false
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "PersonInfoChoosePageOpen", nil)
  self.ActiveChooseMode = "Weapon"
  self.ActiveSubPageName = "Choose"
  self.ActiveCharacterPanelState = "Detail"
  self:_BeginCharacterEquipChoosePreview("Weapon")
  self:_CreateChoosePageIfNeeded()
  self.ChoosePagePanel:InitChoosePage(self, self.ActiveChooseMode, self:BuildChoosePageViewData())
  self:RefreshRootView()
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
end

function M:OpenActionChoosePage()
  if not self:HasSelectedCharacter() then
    UIManager(self.OwnerWidget):ShowUITip("CommonToastMain", "当前槽位未放入角色(待配表)")
    return
  end
  self.ActionChooseBaseDraft = DisplayDraft:Clone(self.DisplayEditor:GetDraft())
  self.SkipCancelActionChooseOnce = false
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "PersonInfoChoosePageOpen", nil)
  self.ActiveChooseMode = "Action"
  self.ActiveSubPageName = "Choose"
  self.ActiveCharacterPanelState = "Detail"
  self:_BeginCharacterEquipChoosePreview("Action")
  self:_CreateChoosePageIfNeeded()
  self.ChoosePagePanel:InitChoosePage(self, self.ActiveChooseMode, self:BuildChoosePageViewData())
  self:RefreshRootView()
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
end

function M:ConfirmWeaponChoosePage()
  return self:_ConfirmCharacterEquipChoosePage("Weapon")
end

function M:ConfirmActionChoosePage()
  return self:_ConfirmCharacterEquipChoosePage("Action")
end

function M:CancelWeaponChooseChanges()
  return self:_CancelCharacterEquipChooseChanges("Weapon")
end

function M:CancelActionChooseChanges()
  return self:_CancelCharacterEquipChooseChanges("Action")
end

function M:_BeginCharacterEquipChoosePreview(Mode)
  local Config = CharacterEquipChooseConfig[Mode]
  if not (Config and self.DisplayEditor) or not self.DisplayEditor.BeginPreviewTransaction then
    return false
  end
  if self.DisplayEditor.IsPreviewTransactionActive and self.DisplayEditor:IsPreviewTransactionActive(Config.TransactionKey) then
    return true
  end
  return self.DisplayEditor:BeginPreviewTransaction(Config.TransactionKey) == true
end

function M:_ConfirmCharacterEquipChoosePage(Mode)
  local Config = CharacterEquipChooseConfig[Mode]
  local CanConfirm = self["CanConfirm" .. Mode .. "ChoosePage"]
  if not Config or self.ActiveChooseMode ~= Mode or not self.DisplayEditor then
    return false
  end
  if not CanConfirm or true ~= CanConfirm(self) then
    return false
  end
  if self.DisplayEditor.IsPreviewTransactionActive and self.DisplayEditor:IsPreviewTransactionActive(Config.TransactionKey) and self.DisplayEditor.AcceptPreviewTransaction then
    self.DisplayEditor:AcceptPreviewTransaction()
  end
  self[Config.SkipCancelField] = true
  self[Config.BaseDraftField] = nil
  self:CloseChoosePageAndReturn()
  return true
end

function M:_CancelCharacterEquipChooseChanges(Mode)
  local Config = CharacterEquipChooseConfig[Mode]
  if not Config or not self.DisplayEditor then
    return false
  end
  local bRestored = false
  if self.DisplayEditor.IsPreviewTransactionActive and self.DisplayEditor:IsPreviewTransactionActive(Config.TransactionKey) and self.DisplayEditor.CancelPreviewTransaction then
    bRestored = self.DisplayEditor:CancelPreviewTransaction() == true
  end
  self[Config.BaseDraftField] = nil
  if bRestored then
    self:_RefreshCharacterChooseRootState(self:GetSelectedCharacterSlotIndex())
  end
  return bRestored
end

function M:OpenItemChoosePage()
  self.ItemChooseBaseDraft = DisplayDraft:Clone(self.DisplayEditor:GetDraft())
  self.SkipCancelItemChooseOnce = false
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "PersonInfoChoosePageOpen", nil)
  self.ActiveChooseMode = "Item"
  self.ActiveSubPageName = "Choose"
  self.ActiveCharacterPanelState = "Main"
  self:_SelectDefaultItemSlotForChoose()
  self:_BeginUniqueSlotChoosePreview("Item")
  self:_CreateChoosePageIfNeeded()
  self.ChoosePagePanel:InitChoosePage(self, self.ActiveChooseMode, self:BuildChoosePageViewData())
  self:RefreshRootView()
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
end

function M:OpenPetChoosePage()
  self.PetChooseBaseDraft = DisplayDraft:Clone(self.DisplayEditor:GetDraft())
  self.SkipCancelPetChooseOnce = false
  self:_BeginUniqueSlotChoosePreview("Pet")
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "PersonInfoChoosePageOpen", nil)
  self.ActiveChooseMode = "Pet"
  self.ActiveSubPageName = "Choose"
  self.ActiveCharacterPanelState = "Main"
  if not self:GetSelectedPetSlotIndex() then
    self:_SelectFirstEditableEmptyPetSlot()
  end
  self:_CreateChoosePageIfNeeded()
  self.ChoosePagePanel:InitChoosePage(self, self.ActiveChooseMode, self:BuildChoosePageViewData())
  self:RefreshRootView()
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
end

function M:_ReallyCloseChoosePageAndReturn()
  local bIsCharacterChoosePage = self.ActiveChooseMode == "Character"
  local bIsItemChoosePage = self.ActiveChooseMode == "Item"
  local bIsPetChoosePage = self.ActiveChooseMode == "Pet"
  local bIsWeaponChoosePage = self.ActiveChooseMode == "Weapon"
  local bIsActionChoosePage = self.ActiveChooseMode == "Action"
  if bIsCharacterChoosePage and not self.SkipCancelCharacterChoosePreviewOnce then
    self:CancelCharacterChoosePreview()
  end
  if bIsPetChoosePage and not self.SkipCancelPetChooseOnce then
    self:CancelPetChooseChanges()
  end
  if bIsItemChoosePage and not self.SkipCancelItemChooseOnce then
    self:CancelItemChooseChanges()
  end
  if bIsWeaponChoosePage and not self.SkipCancelWeaponChooseOnce then
    self:CancelWeaponChooseChanges()
  end
  if bIsActionChoosePage and not self.SkipCancelActionChooseOnce then
    self:CancelActionChooseChanges()
  end
  if bIsCharacterChoosePage then
    self.PendingCharacterChoosePreview = nil
    self.StagedCharacterChooseSelections = {}
    self.CharacterChooseBaseDraft = nil
    self.CharacterChoosePreviewSceneSlotIndex = nil
  end
  if bIsPetChoosePage then
    self.PetChooseBaseDraft = nil
  end
  if bIsItemChoosePage then
    self.ItemChooseBaseDraft = nil
  end
  if bIsWeaponChoosePage then
    self.WeaponChooseBaseDraft = nil
  end
  if bIsActionChoosePage then
    self.ActionChooseBaseDraft = nil
  end
  self.SkipCancelCharacterChoosePreviewOnce = false
  self.SkipCancelItemChooseOnce = false
  self.SkipCancelPetChooseOnce = false
  self.SkipCancelWeaponChooseOnce = false
  self.SkipCancelActionChooseOnce = false
  self.ActiveChooseMode = nil
  if self.ActiveTabName == "Scene" then
    self.ActiveSubPageName = "Scene"
    self.ActiveCharacterPanelState = "Main"
  elseif self.ActiveTabName == "Other" then
    self.ActiveSubPageName = "Other"
    self.ActiveCharacterPanelState = "Main"
  elseif "Pet" == self.ActiveTabName then
    self.ActiveSubPageName = "PetMain"
    self.ActiveCharacterPanelState = "Main"
    self.ActivePetPanelState = "Main"
  elseif "Item" == self.ActiveTabName then
    self.ActiveSubPageName = "ItemMain"
    self.ActiveCharacterPanelState = "Main"
  else
    self.ActiveSubPageName = "CharacterMain"
    self.ActiveCharacterPanelState = "Detail"
    self.bOpenDetailOnNextRootEnter = true
    if bIsCharacterChoosePage then
      self.SelectedCharacterSlotIndex = self:_ResolveRootSelectedCharacterSlotIndex(self.SelectedCharacterSlotIndex)
      self.SelectCharIndex = self.SelectedCharacterSlotIndex
    end
  end
  self:RefreshRootView()
  if bIsPetChoosePage and "Pet" == self.ActiveTabName then
    local ResolvedSlotIndex = self:_ResolvePreferredPetSlotIndex(self.SelectedPetSlotIndex)
    self.SelectedPetSlotIndex = ResolvedSlotIndex
    if ResolvedSlotIndex then
      local Slot = self:_GetPetSlot(ResolvedSlotIndex)
      local bHasPet = DisplayDraft:IsPetSlotOccupied(Slot)
      self:_SelectPetSlot(ResolvedSlotIndex, {
        OpenHighlight = bHasPet,
        OpenDetail = bHasPet,
        ForceRefresh = true
      })
    end
  end
  local RootView = self.RootViewPanel or self.OwnerWidget
  if RootView and RootView.ApplyCurrentEditStateGamepadFocus then
    RootView:ApplyCurrentEditStateGamepadFocus()
  end
end

function M:CloseChoosePageAndReturn()
  AudioManager(self):SetEventSoundParam(self, "PersonInfoChoosePageOpen", {ToEnd = 1})
  self:_ReallyCloseChoosePageAndReturn()
end

function M:RemoveCharacterChooseSelectionBySlot(SlotIndex)
  if self.ActiveChooseMode ~= "Character" then
    return false
  end
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  local Selection = self.StagedCharacterChooseSelections[SlotIndex]
  local PendingPreview = self.PendingCharacterChoosePreview
  local WorkingSlot = self:_GetCharacterSlot(SlotIndex, true)
  local bHasCommittedCharacter = DisplayDraft:IsCharacterSlotOccupied(WorkingSlot)
  DebugPrint(string.format("PersonInfoDeleteChar: begin remove slot=%s selectedSlot=%s staged=%s pendingSlot=%s workingUuid=%s", tostring(SlotIndex), tostring(self.SelectedCharacterSlotIndex), tostring(nil ~= Selection), tostring(PendingPreview and PendingPreview.SlotIndex or nil), tostring(WorkingSlot and WorkingSlot.CharData and WorkingSlot.CharData.Uuid or nil)))
  if nil == Selection and (nil == PendingPreview or PendingPreview.SlotIndex ~= SlotIndex) and not bHasCommittedCharacter then
    DebugPrint(string.format("PersonInfoDeleteChar: skip remove slot=%s because no staged/pending/working character", tostring(SlotIndex)))
    return false
  end
  self.StagedCharacterChooseSelections[SlotIndex] = false
  if nil ~= PendingPreview and PendingPreview.SlotIndex == SlotIndex then
    self.PendingCharacterChoosePreview = nil
  end
  local WorkingDraft = self:_BuildCharacterChooseSlotDraft()
  local WorkingSlotDraft = WorkingDraft and WorkingDraft.CharacterSlots and WorkingDraft.CharacterSlots[SlotIndex] or nil
  DebugPrint(string.format("PersonInfoDeleteChar: rebuilt draft slot=%s stagedValue=%s draftUuid=%s draftCharId=%s", tostring(SlotIndex), tostring(self.StagedCharacterChooseSelections[SlotIndex]), tostring(WorkingSlotDraft and WorkingSlotDraft.CharData and WorkingSlotDraft.CharData.Uuid or nil), tostring(WorkingSlotDraft and WorkingSlotDraft.CharData and WorkingSlotDraft.CharData.CharId or nil)))
  if not self.DisplayController:RestoreCharacterChooseSlotPreview(SlotIndex, WorkingSlotDraft) then
    DebugPrint(string.format("PersonInfoDeleteChar: restore preview failed slot=%s", tostring(SlotIndex)))
    return false
  end
  WorkingSlot = WorkingSlotDraft
  if DisplayDraft:IsCharacterSlotOccupied(WorkingSlot) then
    self.CharacterChoosePreviewSceneSlotIndex = SlotIndex
  elseif self.CharacterChoosePreviewSceneSlotIndex == SlotIndex then
    self.CharacterChoosePreviewSceneSlotIndex = nil
  end
  self.ValidCharacterSlotIndices = self:_CollectOccupiedCharacterSlotIndices(WorkingDraft)
  if self.SelectedCharacterSlotIndex == SlotIndex then
    self.SelectCharIndex = SlotIndex
  end
  self:_EnsureSelectedCharacterSlotAfterCharacterChange()
  if self.RootViewPanel then
    self.RootViewPanel:RefreshCharacterSlotItem(SlotIndex)
    self.RootViewPanel:RefreshCommonActionState()
  end
  self:RefreshSelectedCharacterSlotContext()
  DebugPrint(string.format("PersonInfoDeleteChar: remove success slot=%s newSelectedSlot=%s newWorkingUuid=%s", tostring(SlotIndex), tostring(self.SelectedCharacterSlotIndex), tostring(WorkingSlot and WorkingSlot.CharData and WorkingSlot.CharData.Uuid or nil)))
  return true
end

function M:ConfirmCharacterChoosePage()
  if self.ActiveChooseMode ~= "Character" then
    return false
  end
  local bHasAnySelection = false
  for _, _ in pairs(self.StagedCharacterChooseSelections or {}) do
    bHasAnySelection = true
    break
  end
  if not bHasAnySelection then
    return false
  end
  self.PendingCharacterChoosePreview = nil
  local Draft = self:_BuildCharacterChooseSlotDraft()
  self:_WriteCharacterChooseDraftToEditor(Draft)
  self.SelectedCharacterSlotIndex = self:_ResolveRootSelectedCharacterSlotIndex(self.SelectedCharacterSlotIndex)
  local CurrentDraft = self.DisplayEditor:GetDraft()
  self.ValidCharacterSlotIndices = self:_CollectOccupiedCharacterSlotIndices(CurrentDraft)
  self.PendingCharacterChoosePreview = nil
  self.StagedCharacterChooseSelections = {}
  self.CharacterChooseBaseDraft = nil
  self.CharacterChoosePreviewSceneSlotIndex = nil
  self.SkipCancelCharacterChoosePreviewOnce = true
  self:CloseChoosePageAndReturn()
  return true
end

function M:CancelPendingCharacterChoosePreview()
  if self.PendingCharacterChoosePreview == nil then
    return false
  end
  local PendingPreview = self.PendingCharacterChoosePreview
  self.PendingCharacterChoosePreview = nil
  local bSuccess = self:_RestoreCharacterChooseSlotPreview(PendingPreview.SlotIndex)
  if bSuccess and nil ~= PendingPreview.RemovedSlotIndex then
    bSuccess = self:_RestoreCharacterChooseSlotPreview(PendingPreview.RemovedSlotIndex)
  end
  local WorkingSlot = self:_GetCharacterSlot(PendingPreview.SlotIndex, true)
  if DisplayDraft:IsCharacterSlotOccupied(WorkingSlot) then
    self.CharacterChoosePreviewSceneSlotIndex = PendingPreview.SlotIndex
  elseif self.CharacterChoosePreviewSceneSlotIndex == PendingPreview.SlotIndex then
    self.CharacterChoosePreviewSceneSlotIndex = nil
  end
  return bSuccess
end

function M:CancelCharacterChoosePreview()
  local bHadPreviewChange = self.PendingCharacterChoosePreview ~= nil or nil ~= next(self.StagedCharacterChooseSelections or {})
  if not bHadPreviewChange then
    self.SkipCancelCharacterChoosePreviewOnce = false
    self.PendingCharacterChoosePreview = nil
    self.StagedCharacterChooseSelections = {}
    self.CharacterChooseBaseDraft = nil
    self.CharacterChoosePreviewSceneSlotIndex = nil
    return false
  end
  local Draft = self.DisplayEditor:GetDraft()
  local bSuccess = self:_ApplyCharacterChooseDraftToScene(Draft)
  self.SkipCancelCharacterChoosePreviewOnce = false
  self.PendingCharacterChoosePreview = nil
  self.StagedCharacterChooseSelections = {}
  self.CharacterChooseBaseDraft = nil
  self.CharacterChoosePreviewSceneSlotIndex = nil
  return bSuccess
end

function M:_EnsureActivePageCreated()
  self.RootViewPanel:EnsureActiveEditSubPageCreated(self)
end

function M:_CreateCharacterEditPanelIfNeeded()
  self.CharacterEditPanel = self.RootViewPanel:EnsureCharacterEditPanelCreated(self)
end

function M:_CreateChoosePageIfNeeded()
  self.ChoosePagePanel = self.RootViewPanel:EnsureChoosePageCreated(self)
end

function M:_CreateScenePageIfNeeded()
  self.ScenePagePanel = self.RootViewPanel:EnsureScenePageCreated(self)
end

function M:_CreateOtherPageIfNeeded()
  self.OtherPagePanel = self.RootViewPanel:EnsureOtherPageCreated(self)
end

function M:_RefreshActivePageVisibility()
  self.RootViewPanel:RefreshEditSubPageVisibility(self)
end

function M:_SetPanelVisibility(Panel, bVisible)
  self.RootViewPanel:_SetPanelVisibility(Panel, bVisible)
end

function M:_InitSelectedCharacterSlotIndex()
  local MainPageView = self.MainPageView
  local PageSelectedIndex = MainPageView and MainPageView.SelectCharIndex or nil
  self.SelectedCharacterSlotIndex = self:_ResolveRootSelectedCharacterSlotIndex(PageSelectedIndex)
  self.SelectCharIndex = self.SelectedCharacterSlotIndex
end

function M:_InitSelectedItemSlotIndex()
  local Draft = self.DisplayEditor and self.DisplayEditor:GetDraft() or nil
  local SelectedSlotIndex = self.SelectedItemSlotIndex
  if type(SelectedSlotIndex) ~= "number" then
    if nil ~= SelectedSlotIndex then
      DebugPrint(string.format("PersonInfoEdit: discard invalid item slot index type=%s value=%s", type(SelectedSlotIndex), tostring(SelectedSlotIndex)))
    end
    self.SelectedItemSlotIndex = nil
    SelectedSlotIndex = nil
  end
  if SelectedSlotIndex then
    local CurrentSlot = Draft and DisplayDraft:GetItemSlot(Draft, SelectedSlotIndex) or nil
    if DisplayDraft:IsItemSlotOccupied(CurrentSlot) then
      return
    end
  end
  self.SelectedItemSlotIndex = nil
  for SlotIndex = 1, DisplayConfig:GetItemSlotCount() do
    local Slot = Draft and DisplayDraft:GetItemSlot(Draft, SlotIndex) or nil
    if DisplayDraft:IsItemSlotOccupied(Slot) then
      self.SelectedItemSlotIndex = SlotIndex
      return
    end
  end
end

function M:_SelectDefaultItemSlotForChoose()
  self:_InitSelectedItemSlotIndex()
  if self.SelectedItemSlotIndex then
    return
  end
  local Draft = self.DisplayEditor and self.DisplayEditor:GetDraft() or nil
  local SlotCount = DisplayConfig:GetItemSlotCount()
  for SlotIndex = 1, SlotCount do
    local Slot = Draft and DisplayDraft:GetItemSlot(Draft, SlotIndex) or nil
    if not DisplayDraft:IsItemSlotOccupied(Slot) then
      self.SelectedItemSlotIndex = SlotIndex
      return
    end
  end
  self.SelectedItemSlotIndex = SlotCount > 0 and 1 or nil
end

function M:_SelectFirstEditableEmptyCharacterSlot()
  local EmptySlotIndex = self:_FindFirstEmptyCharacterSlotIndex()
  if nil ~= EmptySlotIndex then
    self:_SelectCharacterSlot(EmptySlotIndex, {ForceRefresh = true})
  end
end

function M:_SelectNextEditableEmptyCharacterSlot()
  local EmptySlotIndex = self:_FindNextEmptyCharacterSlotIndex(self:GetSelectedCharacterSlotIndex())
  if nil ~= EmptySlotIndex then
    self:_SelectCharacterSlot(EmptySlotIndex, {ForceRefresh = true})
    if self.DisplayController then
      self.DisplayController:ClearFocusHighlight()
    end
  end
end

function M:_CloseOwnerEditPage()
  if self.bClosingOwnerEditPageByOutAnimation then
    return
  end
  AudioManager(self):SetEventSoundParam(self, "PersonInfoCustomEditPageOpen", {ToEnd = 1})
  if self.OwnerWidget.Out then
    self.bClosingOwnerEditPageByOutAnimation = true
    self.OwnerWidget:UnbindAllFromAnimationFinished(self.OwnerWidget.Out)
    self.OwnerWidget:BindToAnimationFinished(self.OwnerWidget.Out, function()
      self.OwnerWidget:UnbindAllFromAnimationFinished(self.OwnerWidget.Out)
      self.bClosingOwnerEditPageByOutAnimation = false
      self.DisplayController:ClearFocusHighlight()
      self.OwnerWidget:Close()
      self:_RestoreMainPageFocusAfterClose()
    end)
    self.OwnerWidget:PlayAnimation(self.OwnerWidget.Out)
    return
  end
  self.DisplayController:ClearFocusHighlight()
  self.OwnerWidget:Close()
  self:_RestoreMainPageFocusAfterClose()
end

function M:_RestoreMainPageFocusAfterClose()
  PersonInfoController:RestoreMainPageAfterCustomEditClosed()
end

function M:GetCustomEditRootController()
  return self
end

for Key, Value in pairs(SessionModel) do
  M[Key] = Value
end
for Key, Value in pairs(DisplayBridge) do
  M[Key] = Value
end
for Key, Value in pairs(ViewDataBuilder) do
  M[Key] = Value
end
return M
