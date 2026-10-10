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
    self:_ApplySavedDraftToEditor()
    local Editor = self:_ResolveDisplayEditor()
    if Editor then
      Editor:AcceptCurrentDraftAsBaseline()
    end
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
    local bSuccess = ErrorCode and ErrorCode.Check and ErrorCode:Check(Ret)
    if bSuccess then
      self.bPendingRestoreAfterSave = false
      local Editor = self:_ResolveDisplayEditor()
      if Editor then
        self.ValidCharacterSlotIndices = self:_CollectOccupiedCharacterSlotIndices(Editor:GetDraft())
      end
      if OnSaved then
        OnSaved(Ret)
      end
      return
    end
    if self.bPendingRestoreAfterSave then
      self.bPendingRestoreAfterSave = false
      self:_ApplySavedDraftToEditor()
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

local function RoundCompareNumber(Value)
  return math.floor((tonumber(Value) or 0) * 100 + 0.5) / 100
end

local function BuildTransformCompareTable(Transform)
  if type(Transform) ~= "userdata" then
    return Transform
  end
  local Location = Transform.Translation
  local Scale = Transform.Scale3D
  local Rotation = Transform.Rotation
  local Rotator
  if Rotation and Rotation.ToRotator then
    Rotator = Rotation:ToRotator()
  end
  return {
    X = RoundCompareNumber(Location and Location.X),
    Y = RoundCompareNumber(Location and Location.Y),
    Z = RoundCompareNumber(Location and Location.Z),
    Pitch = RoundCompareNumber(Rotator and Rotator.Pitch),
    Yaw = RoundCompareNumber(Rotator and Rotator.Yaw),
    Roll = RoundCompareNumber(Rotator and Rotator.Roll),
    ScaleX = RoundCompareNumber(Scale and Scale.X),
    ScaleY = RoundCompareNumber(Scale and Scale.Y),
    ScaleZ = RoundCompareNumber(Scale and Scale.Z)
  }
end

local function BuildActionCompareTable(Action)
  if type(Action) ~= "table" then
    return nil
  end
  return {
    Mode = Action.Mode,
    PoseId = Action.PoseId,
    PoseTag = Action.PoseTag,
    MontagePath = Action.MontagePath,
    Document = Action.Document,
    PoseName = Action.PoseName,
    ReleaseWheel = Action.ReleaseWheel
  }
end

local function BuildDefaultWeaponActionIdentity(WeaponData)
  if not WeaponData then
    return nil
  end
  local PoseTag = "Melee"
  if WeaponData.HasTag and WeaponData:HasTag("Ranged") then
    PoseTag = "Ranged"
  end
  return BuildActionCompareTable({PoseTag = PoseTag})
end

local function BuildSlotActorIdentity(Slot, Kind)
  if type(Slot) ~= "table" then
    return nil
  end
  local Identity = {
    Transform = BuildTransformCompareTable(Slot.Transform)
  }
  if "Char" == Kind then
    local CharData = Slot.CharData
    local WeaponData = Slot.WeaponData
    Identity.CharId = CharData and (CharData.CharId or CharData.Uuid) or nil
    Identity.WeaponId = WeaponData and WeaponData.WeaponId or nil
    Identity.Action = BuildActionCompareTable(Slot.Action) or BuildDefaultWeaponActionIdentity(WeaponData)
  elseif "Pet" == Kind then
    local PetData = Slot.PetData
    Identity.PetId = PetData and (PetData.UniqueId or PetData.PetId) or nil
  else
    local ItemData = Slot.ItemData
    Identity.ItemId = ItemData and (ItemData.ItemId or ItemData.Id) or nil
  end
  return Identity
end

local function BuildSlotGroupActorIdentity(SlotGroup, Kind)
  local Identities = {}
  if type(SlotGroup) ~= "table" then
    return Identities
  end
  for Index, Slot in ipairs(SlotGroup) do
    Identities[Index] = BuildSlotActorIdentity(Slot, Kind)
  end
  return Identities
end

local function IsIncomingDraftSameForRender(CurrentDraft, IncomingDraft)
  local CurrentSceneId = CurrentDraft and CurrentDraft.Scene and CurrentDraft.Scene.SceneId or nil
  local IncomingSceneId = IncomingDraft and IncomingDraft.Scene and IncomingDraft.Scene.SceneId or nil
  if CurrentSceneId ~= IncomingSceneId then
    return false
  end
  local CurrentIdentity = {
    CharacterSlots = BuildSlotGroupActorIdentity(CurrentDraft and CurrentDraft.CharacterSlots, "Char"),
    PetSlots = BuildSlotGroupActorIdentity(CurrentDraft and CurrentDraft.PetSlots, "Pet"),
    ItemSlots = BuildSlotGroupActorIdentity(CurrentDraft and CurrentDraft.ItemSlots, "Item")
  }
  local IncomingIdentity = {
    CharacterSlots = BuildSlotGroupActorIdentity(IncomingDraft and IncomingDraft.CharacterSlots, "Char"),
    PetSlots = BuildSlotGroupActorIdentity(IncomingDraft and IncomingDraft.PetSlots, "Pet"),
    ItemSlots = BuildSlotGroupActorIdentity(IncomingDraft and IncomingDraft.ItemSlots, "Item")
  }
  return DisplayDraft:IsEquivalent(CurrentIdentity, IncomingIdentity) == true
end

function M:_LoadInitialDraftFromServer()
  if not self.DisplayEditor then
    return
  end
  local Draft = PersonInfoModel:GetCustomDisplayDraft()
  Draft = Draft or self:_BuildInitialEmptyDraft()
  local bSkipRender = IsIncomingDraftSameForRender(self.DisplayEditor:GetDraft(), Draft)
  self.DisplayEditor:SetDraft(Draft, bSkipRender)
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

function M:_ResolveDisplayEditor()
  if self.DisplayEditor then
    return self.DisplayEditor
  end
  if self.DisplayController and self.DisplayController.GetEditor then
    return self.DisplayController:GetEditor()
  end
  local RootPage = PersonInfoController.MainPage
  local MainPage = RootPage and RootPage.PersonInfoMainPage or nil
  local ActorController = MainPage and MainPage.ActorController or nil
  if ActorController and ActorController.GetEditor then
    return ActorController:GetEditor()
  end
  return nil
end

function M:_ApplySavedDraftToEditor()
  local Editor = self:_ResolveDisplayEditor()
  if not Editor then
    return false
  end
  local SavedDraft = PersonInfoModel:GetCustomDisplayDraft()
  SavedDraft = SavedDraft or self:_BuildInitialEmptyDraft()
  self.InitialSavedDraft = DisplayDraft:Clone(SavedDraft)
  self.UsedSceneId = SavedDraft and SavedDraft.Scene and SavedDraft.Scene.SceneId or nil
  local bSkipRender = IsIncomingDraftSameForRender(Editor:GetDraft(), SavedDraft)
  Editor:SetDraft(SavedDraft, bSkipRender)
  if true == bSkipRender then
    local Renderer = Editor.Renderer
    if Renderer and Renderer.ApplyDraftFilter then
      Renderer:ApplyDraftFilter(Editor:GetDraft())
    end
  end
  self.ValidCharacterSlotIndices = self:_CollectOccupiedCharacterSlotIndices(SavedDraft)
  self.PendingCharacterChoosePreview = nil
  self.StagedCharacterChooseSelections = {}
  self.CharacterChooseBaseDraft = nil
  self.CharacterChoosePreviewSceneSlotIndex = nil
  return true
end

function M:_RestoreDraftOnAbandonIfNeeded()
  local Editor = self:_ResolveDisplayEditor()
  if nil == Editor then
    return
  end
  if self.IsSaving == true then
    self.bPendingRestoreAfterSave = true
    return
  end
  if nil == self.InitialSavedDraft then
    return
  end
  if not Editor:IsDraftDirty() and not Editor:IsPreviewTransactionActive() then
    return
  end
  self:_ApplySavedDraftToEditor()
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
