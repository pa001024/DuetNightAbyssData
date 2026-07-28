local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = PersonInfoController:GetModel()
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local M = {}

function M:ResetCameraToSceneDefault()
  if not self.DisplayEditor or not self.DisplayEditor.ResetCameraToSceneDefault then
    return false
  end
  local Draft = self.DisplayEditor:GetDraft()
  local SceneId = Draft and Draft.Scene and Draft.Scene.SceneId or nil
  return self.DisplayEditor:ResetCameraToSceneDefault(SceneId) == true
end

function M:ApplyCharacterSelection(CharData, AppearanceInfo)
  local bSuccess = self:_ApplyCharacterSelection(self:GetSelectedCharacterSlotIndex(), CharData, AppearanceInfo)
  if bSuccess then
    self:RefreshRootView()
  end
  return bSuccess
end

function M:PreviewCharacterChooseSelection(CharUuid, AppearancePlan)
  return self:_PreviewCharacterChooseSelection(self:GetSelectedCharacterSlotIndex(), CharUuid, AppearancePlan)
end

function M:CommitCharacterChoosePreview(CharUuid, AppearancePlan)
  local CommittedSlotIndex = self:GetSelectedCharacterSlotIndex()
  local bSuccess = self:_CommitCharacterChoosePreview(CommittedSlotIndex, CharUuid, AppearancePlan)
  if not bSuccess then
    return false
  end
  if self:GetSelectedCharacterSlotIndex() == CommittedSlotIndex then
    self.CharacterChoosePreviewSceneSlotIndex = CommittedSlotIndex
  else
    self.CharacterChoosePreviewSceneSlotIndex = nil
  end
  self:_RefreshCharacterChooseRootState(CommittedSlotIndex)
  return true
end

function M:ApplyWeaponSelection(WeaponData)
  DebugPrint(string.format("PersonInfoWeaponSelect: ApplyWeaponSelection slot=%s weaponId=%s weaponUuid=%s hasTagRanged=%s", tostring(self:GetSelectedCharacterSlotIndex()), tostring(WeaponData and WeaponData.WeaponId or nil), tostring(WeaponData and WeaponData.Uuid or nil), tostring(WeaponData and WeaponData.HasTag and WeaponData:HasTag("Ranged") or false)))
  local bSuccess, Reason = self:_ApplyWeaponSelection(self:GetSelectedCharacterSlotIndex(), WeaponData)
  local CurrentSlot = self:_GetCharacterSlot(self:GetSelectedCharacterSlotIndex())
  DebugPrint(string.format("PersonInfoWeaponSelect: ApplyWeaponSelection result success=%s reason=%s slot=%s draftWeaponId=%s draftActionPose=%s", tostring(true == bSuccess), tostring(Reason), tostring(self:GetSelectedCharacterSlotIndex()), tostring(CurrentSlot and CurrentSlot.WeaponData and CurrentSlot.WeaponData.WeaponId or nil), tostring(CurrentSlot and CurrentSlot.Action and CurrentSlot.Action.PoseTag or nil)))
  return bSuccess, Reason
end

function M:ApplyActionSelection(ActionData)
  return self:_ApplyActionSelection(self:GetSelectedCharacterSlotIndex(), ActionData)
end

function M:BeginCharacterTransformPreview()
  return self.DisplayEditor:BeginPreviewTransaction("character_transform_" .. tostring(self:GetSelectedCharacterSlotIndex()))
end

function M:CommitCharacterTransformPreview()
  local bCommitted = self.DisplayEditor:CommitPreviewTransaction() == true
  if bCommitted then
    self.RootViewPanel:RefreshCommonActionState()
    if self:ShouldShowCharacterDetailPanel() and self.CharacterEditPanel then
      self.CharacterEditPanel:RefreshView()
    end
  end
  return bCommitted
end

function M:PreviewCharacterTransform(TransformData)
  local Transform = self:_BuildTransformFromEditData(self:GetSelectedCharacterSlotIndex(), TransformData)
  local TransformRotation = self:_BuildTransformRotationFromEditData(TransformData)
  self.DisplayEditor:SetCharacterTransform(self:GetSelectedCharacterSlotIndex(), Transform, TransformRotation)
  return true
end

function M:SetFocusedCharacterSlot(SlotIndex, bOpenHighlight)
  self.DisplayController:SetFocusCharacterSlot(SlotIndex, true == bOpenHighlight)
end

function M:TrySelectPreviewEntityByPointer()
  local EntityId = self.DisplayController:CommitPointerSelection()
  local SlotIndex = self:_GetCharacterSlotIndexByEntityId(EntityId)
  if not SlotIndex then
    return false
  end
  return self:_SelectCharacterSlot(SlotIndex, {
    OpenHighlight = true,
    OpenDetail = self:IsCharacterMainPageActive()
  })
end

function M:_ApplySelectedSceneId(SceneId)
  if type(SceneId) ~= "number" then
    return false
  end
  local Draft = self.DisplayEditor:GetDraft()
  local SceneData = self:_CloneTable(Draft.Scene or {})
  SceneData.SceneId = SceneId
  return self.DisplayEditor:SetSceneData(SceneData) == true
end

function M:_ApplyCharacterSelection(SlotIndex, CharData, AppearanceInfo)
  if not self.DisplayEditor or not CharData then
    return false
  end
  return self.DisplayEditor:SetCharacterToSlot(SlotIndex, CharData, self:_GetPreviewAvatar(), AppearanceInfo) == true
end

function M:_PreviewCharacterChooseSelection(SlotIndex, CharUuid, AppearancePlan)
  if not self.DisplayController then
    return false
  end
  local PreviousPreview = self.PendingCharacterChoosePreview
  if nil ~= PreviousPreview then
    self.PendingCharacterChoosePreview = nil
    if not self:_RestoreCharacterChooseSlotPreview(PreviousPreview.SlotIndex) then
      return false
    end
    if nil ~= PreviousPreview.RemovedSlotIndex and not self:_RestoreCharacterChooseSlotPreview(PreviousPreview.RemovedSlotIndex) then
      return false
    end
  end
  local Avatar = self:_GetPreviewAvatar()
  local CharData = Avatar and Avatar.Chars and Avatar.Chars[CharUuid] or nil
  if not CharData then
    return false
  end
  local WorkingDraft = self:_BuildCharacterChooseSlotDraft()
  local ReferenceSlotDraft = WorkingDraft and WorkingDraft.CharacterSlots and WorkingDraft.CharacterSlots[SlotIndex] or nil
  local RemovedSlotIndex = self:_FindCharacterChooseSlotIndexByUuid(CharUuid, SlotIndex)
  if nil ~= RemovedSlotIndex and not self.DisplayController:RestoreCharacterChooseSlotPreview(RemovedSlotIndex, nil) then
    return false
  end
  local AppearanceInfo = self:_BuildCharacterAppearanceByPlan(CharData, AppearancePlan)
  self.PendingCharacterChoosePreview = {
    SlotIndex = SlotIndex,
    CharUuid = CharUuid,
    AppearancePlan = AppearancePlan or 1,
    RemovedSlotIndex = RemovedSlotIndex
  }
  self.CharacterChoosePreviewSceneSlotIndex = SlotIndex
  return self.DisplayController:PreviewCharacterChooseSlot(SlotIndex, CharData, Avatar, AppearanceInfo, ReferenceSlotDraft)
end

function M:_StageCharacterChoosePreview(SlotIndex, CharUuid, AppearancePlan)
  local PendingPreview = self.PendingCharacterChoosePreview
  local bNeedRefreshPreview = nil == PendingPreview or PendingPreview.SlotIndex ~= SlotIndex or PendingPreview.CharUuid ~= CharUuid or (PendingPreview.AppearancePlan or 1) ~= (AppearancePlan or 1)
  if not bNeedRefreshPreview then
    return true
  end
  return self:_PreviewCharacterChooseSelection(SlotIndex, CharUuid, AppearancePlan)
end

function M:_CommitCharacterChoosePreview(SlotIndex, CharUuid, AppearancePlan)
  local PendingPreview = self.PendingCharacterChoosePreview
  local bNeedRefreshPreview = nil == PendingPreview or PendingPreview.SlotIndex ~= SlotIndex or PendingPreview.CharUuid ~= CharUuid or (PendingPreview.AppearancePlan or 1) ~= (AppearancePlan or 1)
  if bNeedRefreshPreview and not self:_PreviewCharacterChooseSelection(SlotIndex, CharUuid, AppearancePlan) then
    return false
  end
  local PreviewRemovedSlotIndex = self.PendingCharacterChoosePreview and self.PendingCharacterChoosePreview.RemovedSlotIndex or nil
  local PreviousSlotIndex = self:_FindCharacterChooseSlotIndexByUuid(CharUuid, SlotIndex) or PreviewRemovedSlotIndex
  if nil ~= PreviousSlotIndex then
    self.StagedCharacterChooseSelections[PreviousSlotIndex] = false
  end
  self.StagedCharacterChooseSelections[SlotIndex] = {
    SlotIndex = SlotIndex,
    CharUuid = CharUuid,
    AppearancePlan = AppearancePlan or 1
  }
  self.PendingCharacterChoosePreview = nil
  self.CharacterChoosePreviewSceneSlotIndex = SlotIndex
  if nil ~= PreviousSlotIndex then
    self:_RestoreCharacterChooseSlotPreview(PreviousSlotIndex)
    if self.RootViewPanel then
      self.RootViewPanel:RefreshCharacterSlotItem(PreviousSlotIndex)
    end
  end
  self:_SelectNextEditableEmptyCharacterSlot()
  if self:GetSelectedCharacterSlotIndex() ~= SlotIndex then
    self.CharacterChoosePreviewSceneSlotIndex = nil
  end
  return true
end

function M:_DoesCharacterSlotMatchSelection(SlotIndex, CharData, AppearanceInfo)
  local Slot = self:_GetCharacterSlot(SlotIndex)
  if not (Slot and Slot.CharData) or not CharData then
    return false
  end
  if Slot.CharData.Uuid ~= CharData.Uuid then
    return false
  end
  local TargetAppearancePlan = AppearanceInfo and AppearanceInfo.CurrentPlanIndex or 1
  local CurrentAppearance = Slot.Appearance or nil
  local CurrentAppearancePlan = CurrentAppearance and CurrentAppearance.CurrentPlanIndex or 1
  return CurrentAppearancePlan == TargetAppearancePlan
end

function M:_CancelCharacterChoosePreview()
  self.PendingCharacterChoosePreview = nil
  return self:CancelPendingCharacterChoosePreview()
end

function M:_ApplyWeaponSelection(SlotIndex, WeaponData)
  local BeforeSlot = self:_GetCharacterSlot(SlotIndex)
  DebugPrint(string.format("PersonInfoWeaponSelect: _ApplyWeaponSelection before slot=%s beforeWeaponId=%s beforeActionPose=%s beforeActionMode=%s newWeaponId=%s", tostring(SlotIndex), tostring(BeforeSlot and BeforeSlot.WeaponData and BeforeSlot.WeaponData.WeaponId or nil), tostring(BeforeSlot and BeforeSlot.Action and BeforeSlot.Action.PoseTag or nil), tostring(BeforeSlot and BeforeSlot.Action and BeforeSlot.Action.Mode or nil), tostring(WeaponData and WeaponData.WeaponId or nil)))
  local CurrentActionData = BeforeSlot and BeforeSlot.Action or nil
  local ActionData = self:_ResolveWeaponSelectionActionData(CurrentActionData)
  local bSuccess, Reason = self.DisplayEditor:SetCharacterWeaponWithAction(SlotIndex, WeaponData, ActionData)
  local AfterSlot = self:_GetCharacterSlot(SlotIndex)
  DebugPrint(string.format("PersonInfoWeaponSelect: _ApplyWeaponSelection after success=%s reason=%s slot=%s afterWeaponId=%s afterActionPose=%s afterActionMode=%s", tostring(true == bSuccess), tostring(Reason), tostring(SlotIndex), tostring(AfterSlot and AfterSlot.WeaponData and AfterSlot.WeaponData.WeaponId or nil), tostring(AfterSlot and AfterSlot.Action and AfterSlot.Action.PoseTag or nil), tostring(AfterSlot and AfterSlot.Action and AfterSlot.Action.Mode or nil)))
  return true == bSuccess, Reason
end

function M:_ResolveWeaponSelectionActionData(CurrentActionData)
  if self:_IsRealEquippedActionData(CurrentActionData) then
    return CurrentActionData
  end
  return nil
end

function M:_IsRealEquippedActionData(ActionData)
  if not ActionData then
    return false
  end
  if ActionData.PoseId ~= nil then
    return true
  end
  if nil ~= ActionData.Mode then
    return true
  end
  if nil ~= ActionData.Document or nil ~= ActionData.PoseName then
    return true
  end
  if nil ~= ActionData.MontagePath or nil ~= ActionData.ReleaseWheel then
    return true
  end
  return false
end

function M:_ApplyActionSelection(SlotIndex, ActionData)
  DebugPrint(string.format("PersonInfoCustomEdit: ApplyActionSelection slot=%s mode=%s poseId=%s releaseWheel=%s montage=%s document=%s poseName=%s", tostring(SlotIndex), tostring(ActionData and ActionData.Mode or nil), tostring(ActionData and ActionData.PoseId or nil), tostring(ActionData and ActionData.ReleaseWheel or nil), tostring(ActionData and ActionData.MontagePath or nil), tostring(ActionData and ActionData.Document or nil), tostring(ActionData and ActionData.PoseName or nil)))
  local bSuccess, Reason = self.DisplayEditor:SetCharacterAction(SlotIndex, ActionData)
  return true == bSuccess, Reason
end

function M:_BindRuntimeContext(OpenContext)
  OpenContext = OpenContext or self.OpenContext
  self.MainPageView = OpenContext and OpenContext.PersonInfoMainPage or self.Root and self.Root.PersonInfoMainPage or self.PersonInfoMainPage
  assert(self.MainPageView, "PersonalEdit 缺少 PersonInfoMainPage 运行上下文")
  self.DisplayController = self.MainPageView.ActorController
  assert(self.DisplayController, "PersonalEdit 缺少主页 ActorController 运行上下文")
  self.DisplayController.ActiveCustomEditRootController = self
  self.ActorController = self.DisplayController
  if self.RootViewPanel then
    self.RootViewPanel.ActorController = self.DisplayController
  end
  self.DisplayEditor = self.DisplayController:GetEditor()
  assert(self.DisplayEditor, "PersonalEdit 无法从 ActorController 获取 DisplayEditor")
end

function M:_GetCharacterSlotIndexByEntityId(EntityId)
  local SlotIndexText = string.match(EntityId or "", "^char_slot_(%d+)$")
  if not SlotIndexText then
    return nil
  end
  return tonumber(SlotIndexText)
end

function M:_RebuildCharacterChoosePreviewTransaction()
  local Draft = self:_BuildCharacterChooseSlotDraft()
  if not self:_ApplyCharacterChooseDraftToScene(Draft) then
    return false
  end
  local PendingPreview = self.PendingCharacterChoosePreview
  if not PendingPreview then
    return true
  end
  local Avatar = self:_GetPreviewAvatar()
  local CharData = Avatar and Avatar.Chars and Avatar.Chars[PendingPreview.CharUuid] or nil
  if not CharData then
    return false
  end
  local AppearanceInfo = self:_BuildCharacterAppearanceByPlan(CharData, PendingPreview.AppearancePlan)
  local ReferenceSlotDraft = Draft and Draft.CharacterSlots and Draft.CharacterSlots[PendingPreview.SlotIndex] or nil
  return self.DisplayController:PreviewCharacterChooseSlot(PendingPreview.SlotIndex, CharData, Avatar, AppearanceInfo, ReferenceSlotDraft)
end

function M:_RestoreCharacterChooseSlotPreview(SlotIndex)
  if not self.DisplayController or type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  local Draft = self:_BuildCharacterChooseSlotDraft()
  local SlotDraft = Draft and Draft.CharacterSlots and Draft.CharacterSlots[SlotIndex] or nil
  return self.DisplayController:RestoreCharacterChooseSlotPreview(SlotIndex, SlotDraft)
end

function M:_ApplyCharacterChooseDraftToScene(Draft)
  if not self.DisplayController then
    return false
  end
  for SlotIndex = 1, 4 do
    local SlotDraft = Draft and Draft.CharacterSlots and Draft.CharacterSlots[SlotIndex] or nil
    if not self.DisplayController:RestoreCharacterChooseSlotPreview(SlotIndex, SlotDraft) then
      return false
    end
  end
  return true
end

function M:_WriteCharacterChooseDraftToEditor(Draft)
  assert(self.DisplayEditor, "PersonalEdit 缺少 DisplayEditor，无法写回角色选择草稿")
  assert(Draft, "PersonalEdit 角色选择确认时缺少目标草稿")
  local CurrentDraft = self.DisplayEditor:GetDraft()
  if not DisplayDraft:IsEquivalent(CurrentDraft, Draft) then
    self.DisplayEditor:SetCharacterSlotsDraft(Draft)
  end
  self.DisplayController.SceneDraft = self.DisplayEditor:GetDraft()
end

function M:_GetPreviewAvatar()
  local MainPageView = self.MainPageView
  if MainPageView and MainPageView.ActorController and MainPageView.ActorController.Avatar then
    return MainPageView.ActorController.Avatar
  end
  return GWorld and GWorld:GetAvatar() or nil
end

function M:_BuildCharacterAppearanceByPlan(CharData, AppearancePlan)
  if not CharData or not CharData.DumpAppearanceSuit then
    return nil
  end
  local Avatar = self:_GetPreviewAvatar()
  local FinalPlan = AppearancePlan or 1
  if FinalPlan <= 0 then
    FinalPlan = 1
  end
  local AppearanceInfo = CharData:DumpAppearanceSuit(Avatar, FinalPlan)
  if type(AppearanceInfo) == "table" then
    AppearanceInfo.CurrentPlanIndex = FinalPlan
  end
  return AppearanceInfo
end

function M:_BuildTransformRotationFromEditData(TransformData)
  return {
    Pitch = TransformData.Pitch or 0,
    Yaw = TransformData.Yaw or 0,
    Roll = TransformData.Roll or 0
  }
end

function M:_BuildTransformFromEditData(SlotIndex, TransformData)
  local SceneId = self:_GetCurrentSceneId()
  local BaseTransform = DisplayConfig:GetDefaultCharacterTransform(SlotIndex, SceneId)
  local Scale = BaseTransform and BaseTransform.Scale3D or FVector(1, 1, 1)
  local Rotation = FRotator(TransformData.Pitch or 0, TransformData.Yaw or 0, TransformData.Roll or 0)
  local Translation = FVector(TransformData.X or 0, TransformData.Y or 0, TransformData.Z or 0)
  return FTransform(Rotation:ToQuat(), Translation, Scale)
end

function M:_CloneTable(Source, Visited)
  if type(Source) ~= "table" then
    return {}
  end
  Visited = Visited or {}
  if Visited[Source] then
    return Visited[Source]
  end
  local Cloned = {}
  Visited[Source] = Cloned
  for Key, Value in pairs(Source) do
    if type(Value) == "table" then
      Cloned[Key] = self:_CloneTable(Value, Visited)
    else
      Cloned[Key] = Value
    end
  end
  return Cloned
end

function M:_RebuildCharacterChoosePreviewTransaction()
  local Draft = self:_BuildCharacterChooseSlotDraft()
  if not self:_ApplyCharacterChooseDraftToScene(Draft) then
    return false
  end
  local PendingPreview = self.PendingCharacterChoosePreview
  if not PendingPreview then
    return true
  end
  local Avatar = self:_GetPreviewAvatar()
  local CharData = Avatar and Avatar.Chars and Avatar.Chars[PendingPreview.CharUuid] or nil
  if not CharData then
    return false
  end
  local AppearanceInfo = self:_BuildCharacterAppearanceByPlan(CharData, PendingPreview.AppearancePlan)
  local ReferenceSlotDraft = Draft and Draft.CharacterSlots and Draft.CharacterSlots[PendingPreview.SlotIndex] or nil
  return self.DisplayController:PreviewCharacterChooseSlot(PendingPreview.SlotIndex, CharData, Avatar, AppearanceInfo, ReferenceSlotDraft)
end

function M:_RestoreCharacterChooseSlotPreview(SlotIndex)
  if not self.DisplayController or type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  local Draft = self:_BuildCharacterChooseSlotDraft()
  local SlotDraft = Draft and Draft.CharacterSlots and Draft.CharacterSlots[SlotIndex] or nil
  return self.DisplayController:RestoreCharacterChooseSlotPreview(SlotIndex, SlotDraft)
end

function M:_ApplyCharacterChooseDraftToScene(Draft)
  if not self.DisplayController then
    return false
  end
  for SlotIndex = 1, 4 do
    local SlotDraft = Draft and Draft.CharacterSlots and Draft.CharacterSlots[SlotIndex] or nil
    if not self.DisplayController:RestoreCharacterChooseSlotPreview(SlotIndex, SlotDraft) then
      return false
    end
  end
  return true
end

function M:_WriteCharacterChooseDraftToEditor(Draft)
  assert(self.DisplayEditor, "PersonalEdit 缺少 DisplayEditor，无法写回角色选择草稿")
  assert(Draft, "PersonalEdit 角色选择确认时缺少目标草稿")
  local CurrentDraft = self.DisplayEditor:GetDraft()
  if not DisplayDraft:IsEquivalent(CurrentDraft, Draft) then
    self.DisplayEditor:SetCharacterSlotsDraft(Draft)
  end
  self.DisplayController.SceneDraft = self.DisplayEditor:GetDraft()
end

return M
