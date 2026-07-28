local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = PersonInfoController:GetModel()
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local DisplayRules = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayRules")
local M = {}

function M:CanSaveEdit()
  return self.DisplayEditor ~= nil and self.IsSaving ~= true and self:IsDirty()
end

function M:IsSavingEdit()
  return self.IsSaving == true
end

function M:IsDirty()
  return self.DisplayEditor:IsDraftDirty()
end

function M:SaveEditAndClose()
  local CurrentSceneId = self:_GetCurrentSceneId()
  if PersonInfoModel:HasOwnedCustomDisplayScene(CurrentSceneId) then
    return self:_ShowSaveConfirmDialog(100399, self._OnConfirmSaveCurrentEdit)
  end
  return self:_ShowSaveConfirmDialog(100400, self._OnConfirmSaveWithUnownedScene)
end

function M:SetSelectedSceneId(SceneId, bSkipScenePanelRefresh)
  local bUnlocked = PersonInfoModel:HasOwnedCustomDisplayScene(SceneId)
  local bSuccess = self:_ApplySelectedSceneId(SceneId)
  if bSuccess then
    self.SelectedSceneId = SceneId
    if bUnlocked then
      self.UsedSceneId = SceneId
    end
    self.RootViewPanel:RefreshCommonActionState()
    if not bSkipScenePanelRefresh and self.ScenePagePanel then
      self.ScenePagePanel:RefreshSelectedSceneState(SceneId, self:_GetUsedSceneId())
    end
  end
  return bSuccess
end

function M:_CanRestoreInitialSceneForSave()
  local InitialDraft = self.InitialSavedDraft
  return nil ~= InitialDraft and type(InitialDraft.Scene) == "table"
end

function M:_RestoreInitialSceneForSave()
  if not self:_CanRestoreInitialSceneForSave() then
    return false
  end
  local InitialSceneData = DisplayDraft:Clone(self.InitialSavedDraft.Scene)
  local bSuccess = self.DisplayEditor:SetSceneData(InitialSceneData) == true
  if not bSuccess then
    return false
  end
  self.SelectedSceneId = InitialSceneData and InitialSceneData.SceneId or nil
  self.UsedSceneId = self.SelectedSceneId
  if self.ScenePagePanel then
    self.ScenePagePanel:RefreshSelectedSceneState(self.SelectedSceneId, self.UsedSceneId)
  end
  if self.RootViewPanel then
    self.RootViewPanel:RefreshCommonActionState()
    self.RootViewPanel:RefreshTitleText()
  end
  return true
end

function M:_BuildSaveDialogParams(OnConfirm)
  return {RightCallbackFunction = OnConfirm, RightCallbackObj = self}
end

function M:_ShowSaveConfirmDialog(PopupId, OnConfirm)
  if UIManager(self.OwnerWidget):GetUIObj("CommonDialog") ~= nil then
    return false
  end
  UIManager(self.OwnerWidget):ShowCommonPopupUI(PopupId, self:_BuildSaveDialogParams(OnConfirm), self.OwnerWidget)
  return true
end

function M:_ExecuteSaveEditAndClose()
  local bStarted, Reason = self:SaveEdit(function()
    UIManager(self.OwnerWidget):ShowUITip("CommonToastMain", GText("UI_PersonalPage_SaveSuccess"))
    self.DisplayEditor:AcceptCurrentDraftAsBaseline()
    self.InitialSavedDraft = DisplayDraft:Clone(self.DisplayEditor:GetDraft())
    self.UsedSceneId = self:_GetCurrentSceneId()
    self:_CloseOwnerEditPage()
  end)
  if not bStarted and "draft_not_dirty" == Reason then
    UIManager(self.OwnerWidget):ShowUITip("CommonToastMain", GText("UI_PersonalPage_NoChanges"))
  end
  return true == bStarted
end

function M:_OnConfirmSaveCurrentEdit()
  return self:_ExecuteSaveEditAndClose()
end

function M:_OnConfirmSaveWithUnownedScene()
  if not self:_RestoreInitialSceneForSave() then
    return false
  end
  return self:_ExecuteSaveEditAndClose()
end

function M:SaveEdit(OnSaved)
  if self.IsSaving or not self.DisplayEditor then
    return false, "saving_or_editor_missing"
  end
  if not self:IsDirty() then
    return false, "draft_not_dirty"
  end
  self.IsSaving = true
  local bStarted = PersonInfoModel:SaveCustomDisplayDraft(self.DisplayEditor, function(Ret)
    self.IsSaving = false
    DebugPrint(string.format("PersonInfoSaveEdit: callback ret=%s", tostring(Ret)))
    if ErrorCode and ErrorCode.Check and ErrorCode:Check(Ret) then
      self.ValidCharacterSlotIndices = self:_CollectOccupiedCharacterSlotIndices(self.DisplayEditor:GetDraft())
      if OnSaved then
        OnSaved(Ret)
      end
    end
  end)
  if not bStarted then
    self.IsSaving = false
    return false, "start_failed"
  end
  return true
end

function M:_GetCharacterSlot(SlotIndex, bUseCharacterChooseDraft)
  local Draft
  if bUseCharacterChooseDraft and self.CharacterChooseBaseDraft ~= nil then
    Draft = self:_BuildCharacterChooseSlotDraft()
  else
    Draft = self.DisplayEditor:GetDraft()
  end
  if not Draft or not Draft.CharacterSlots then
    return nil
  end
  return Draft.CharacterSlots[SlotIndex]
end

function M:_GetPreferredSelectedCharacterSlotIndex(PageSelectedIndex)
  if type(PageSelectedIndex) == "number" and PageSelectedIndex > 0 then
    local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
    if self:IsCharacterChoosePageActive() and self.CharacterChooseBaseDraft ~= nil then
      Draft = self:_BuildCharacterChooseSlotDraft()
    end
    local CharacterSlots = Draft and Draft.CharacterSlots or nil
    local Slot = CharacterSlots and CharacterSlots[PageSelectedIndex] or nil
    if DisplayDraft:IsCharacterSlotOccupied(Slot) then
      return PageSelectedIndex
    end
  end
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  if self:IsCharacterChoosePageActive() and self.CharacterChooseBaseDraft ~= nil then
    Draft = self:_BuildCharacterChooseSlotDraft()
  end
  local CharacterSlots = Draft and Draft.CharacterSlots or nil
  for SlotIndex = 1, 4 do
    local Slot = CharacterSlots and CharacterSlots[SlotIndex] or nil
    if DisplayDraft:IsCharacterSlotOccupied(Slot) then
      return SlotIndex
    end
  end
  local EmptySlotIndex = self:_FindFirstEmptyCharacterSlotIndex()
  if nil ~= EmptySlotIndex then
    return EmptySlotIndex
  end
  return 1
end

function M:_GetPreferredOccupiedCharacterSlotIndex(PageSelectedIndex, Draft)
  local WorkingDraft = Draft or self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  local CharacterSlots = WorkingDraft and WorkingDraft.CharacterSlots or nil
  if type(PageSelectedIndex) == "number" and PageSelectedIndex > 0 then
    local Slot = CharacterSlots and CharacterSlots[PageSelectedIndex] or nil
    if DisplayDraft:IsCharacterSlotOccupied(Slot) then
      return PageSelectedIndex
    end
  end
  for SlotIndex = 1, 4 do
    local Slot = CharacterSlots and CharacterSlots[SlotIndex] or nil
    if DisplayDraft:IsCharacterSlotOccupied(Slot) then
      return SlotIndex
    end
  end
  return nil
end

function M:_FindFirstEmptyCharacterSlotIndex()
  local Draft = self.DisplayEditor:GetDraft()
  if self:IsCharacterChoosePageActive() and self.CharacterChooseBaseDraft ~= nil then
    Draft = self:_BuildCharacterChooseSlotDraft()
  end
  local CharacterSlots = Draft and Draft.CharacterSlots or nil
  if not CharacterSlots then
    return 1
  end
  for SlotIndex = 1, 4 do
    local Slot = CharacterSlots[SlotIndex]
    if not Slot or not Slot.CharData then
      return SlotIndex
    end
  end
  return nil
end

function M:_FindNextEmptyCharacterSlotIndex(StartSlotIndex)
  local Draft = self.DisplayEditor:GetDraft()
  if self:IsCharacterChoosePageActive() and self.CharacterChooseBaseDraft ~= nil then
    Draft = self:_BuildCharacterChooseSlotDraft()
  end
  local CharacterSlots = Draft and Draft.CharacterSlots or nil
  local BeginIndex = type(StartSlotIndex) == "number" and StartSlotIndex or 1
  if not CharacterSlots then
    return BeginIndex
  end
  for SlotIndex = BeginIndex + 1, 4 do
    local Slot = CharacterSlots[SlotIndex]
    if not Slot or not Slot.CharData then
      return SlotIndex
    end
  end
  for SlotIndex = 1, BeginIndex - 1 do
    local Slot = CharacterSlots[SlotIndex]
    if not Slot or not Slot.CharData then
      return SlotIndex
    end
  end
  return nil
end

function M:_LoadInitialDraftFromServer()
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  if not Draft then
    Draft = PersonInfoModel:GetCustomDisplayDraft()
    Draft = Draft or self:_BuildInitialEmptyDraft()
    self.DisplayEditor:SetDraft(Draft)
  end
  self.DisplayEditor:AcceptCurrentDraftAsBaseline()
  self.InitialSavedDraft = DisplayDraft:Clone(Draft)
  self.UsedSceneId = Draft and Draft.Scene and Draft.Scene.SceneId or nil
  self.ValidCharacterSlotIndices = self:_CollectOccupiedCharacterSlotIndices(Draft)
end

function M:_BuildInitialEmptyDraft()
  local Draft = {
    Scene = {
      SceneId = PersonInfoModel:GetCustomDisplaySceneId()
    }
  }
  DisplayConfig:ApplySceneDefaults(Draft)
  return Draft
end

function M:_CollectOccupiedCharacterSlotIndices(Draft)
  local SlotIndices = {}
  if not Draft or not Draft.CharacterSlots then
    return SlotIndices
  end
  for SlotIndex, Slot in ipairs(Draft.CharacterSlots) do
    if DisplayDraft:IsCharacterSlotOccupied(Slot) then
      SlotIndices[#SlotIndices + 1] = SlotIndex
    end
  end
  return SlotIndices
end

function M:_RestoreDraftOnAbandonIfNeeded()
  if self.DisplayEditor == nil or self.IsSaving == true then
    return
  end
  if nil == self.InitialSavedDraft then
    return
  end
  if not self.DisplayEditor:IsDraftDirty() and not self.DisplayEditor:IsPreviewTransactionActive() then
    return
  end
  local SavedDraft = PersonInfoModel:GetCustomDisplayDraft()
  SavedDraft = SavedDraft or self:_BuildInitialEmptyDraft()
  self.InitialSavedDraft = DisplayDraft:Clone(SavedDraft)
  self.UsedSceneId = SavedDraft and SavedDraft.Scene and SavedDraft.Scene.SceneId or nil
  self.DisplayEditor:SetDraft(SavedDraft)
  self.ValidCharacterSlotIndices = self:_CollectOccupiedCharacterSlotIndices(SavedDraft)
  self.PendingCharacterChoosePreview = nil
  self.StagedCharacterChooseSelections = {}
  self.CharacterChooseBaseDraft = nil
  self.CharacterChoosePreviewSceneSlotIndex = nil
end

function M:_BuildCharacterChooseSlotDraft()
  local Draft = DisplayDraft:Clone(self.CharacterChooseBaseDraft or self.DisplayEditor:GetDraft())
  local Avatar = self:_GetPreviewAvatar()
  local CharacterMap = Avatar and Avatar.Chars or nil
  for SlotIndex = 1, 4 do
    local Selection
    if self.StagedCharacterChooseSelections ~= nil then
      Selection = self.StagedCharacterChooseSelections[SlotIndex]
    end
    if nil == Selection then
    elseif false == Selection then
      DisplayRules:RemoveCharacterFromSlot(Draft, SlotIndex)
    elseif nil ~= CharacterMap then
      local CharData = CharacterMap[Selection.CharUuid]
      if nil ~= CharData then
        local AppearanceInfo = self:_BuildCharacterAppearanceByPlan(CharData, Selection.AppearancePlan)
        DisplayRules:AssignCharacterToSlot(Draft, SlotIndex, CharData, Avatar, AppearanceInfo)
      else
        DisplayRules:RemoveCharacterFromSlot(Draft, SlotIndex)
      end
    end
  end
  return Draft
end

function M:_FindCharacterChooseSlotIndexByUuid(CharUuid, IgnoreSlotIndex)
  if nil == CharUuid then
    return nil
  end
  local Draft = self:_BuildCharacterChooseSlotDraft()
  local CharacterSlots = Draft and Draft.CharacterSlots or nil
  if not CharacterSlots then
    return nil
  end
  for SlotIndex = 1, 4 do
    if SlotIndex ~= IgnoreSlotIndex then
      local Slot = CharacterSlots[SlotIndex]
      local SlotCharData = Slot and Slot.CharData or nil
      if SlotCharData and SlotCharData.Uuid == CharUuid then
        return SlotIndex
      end
    end
  end
  return nil
end

function M:_GetCurrentSceneId()
  local Draft = self.DisplayEditor:GetDraft()
  return Draft and Draft.Scene and Draft.Scene.SceneId or PersonInfoModel:GetCustomDisplaySceneId()
end

function M:_GetUsedSceneId()
  if type(self.UsedSceneId) == "number" then
    return self.UsedSceneId
  end
  local Draft = self.InitialSavedDraft
  local SceneId = Draft and Draft.Scene and Draft.Scene.SceneId or nil
  if type(SceneId) == "number" then
    return SceneId
  end
  return self:_GetCurrentSceneId()
end

function M:_GetPreferredOccupiedCharacterSlotIndex(PageSelectedIndex, Draft)
  local WorkingDraft = Draft or self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  local CharacterSlots = WorkingDraft and WorkingDraft.CharacterSlots or nil
  if type(PageSelectedIndex) == "number" and PageSelectedIndex > 0 then
    local Slot = CharacterSlots and CharacterSlots[PageSelectedIndex] or nil
    if DisplayDraft:IsCharacterSlotOccupied(Slot) then
      return PageSelectedIndex
    end
  end
  for SlotIndex = 1, 4 do
    local Slot = CharacterSlots and CharacterSlots[SlotIndex] or nil
    if DisplayDraft:IsCharacterSlotOccupied(Slot) then
      return SlotIndex
    end
  end
  return nil
end

function M:_FindFirstEmptyCharacterSlotIndex()
  local Draft = self.DisplayEditor:GetDraft()
  if self:IsCharacterChoosePageActive() and self.CharacterChooseBaseDraft ~= nil then
    Draft = self:_BuildCharacterChooseSlotDraft()
  end
  local CharacterSlots = Draft and Draft.CharacterSlots or nil
  if not CharacterSlots then
    return 1
  end
  for SlotIndex = 1, 4 do
    local Slot = CharacterSlots[SlotIndex]
    if not Slot or not Slot.CharData then
      return SlotIndex
    end
  end
  return nil
end

function M:_FindNextEmptyCharacterSlotIndex(StartSlotIndex)
  local Draft = self.DisplayEditor:GetDraft()
  if self:IsCharacterChoosePageActive() and self.CharacterChooseBaseDraft ~= nil then
    Draft = self:_BuildCharacterChooseSlotDraft()
  end
  local CharacterSlots = Draft and Draft.CharacterSlots or nil
  local BeginIndex = type(StartSlotIndex) == "number" and StartSlotIndex or 1
  if not CharacterSlots then
    return BeginIndex
  end
  for SlotIndex = BeginIndex + 1, 4 do
    local Slot = CharacterSlots[SlotIndex]
    if not Slot or not Slot.CharData then
      return SlotIndex
    end
  end
  for SlotIndex = 1, BeginIndex - 1 do
    local Slot = CharacterSlots[SlotIndex]
    if not Slot or not Slot.CharData then
      return SlotIndex
    end
  end
  return nil
end

function M:_ResolveRootSelectedCharacterSlotIndex(PreferredSlotIndex)
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  return self:_GetPreferredOccupiedCharacterSlotIndex(PreferredSlotIndex, Draft)
end

return M
