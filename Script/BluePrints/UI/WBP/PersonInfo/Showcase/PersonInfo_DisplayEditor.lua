local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayRules = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayRules")
local DisplayPersistence = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayPersistence")
local M = {}

function M:Init(Params)
  Params = Params or {}
  self.ViewUI = Params.ViewUI
  self.Renderer = Params.Renderer
  self.Draft = DisplayDraft:CreateEmpty()
  self.BaselineDraft = self:_CloneDraft(self.Draft)
  self.IsDirty = false
  self.UndoStack = {}
  self.RedoStack = {}
  self.ActivePreviewTransaction = nil
  self.LastHistoryOperation = nil
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

function M:SetRenderer(Renderer)
  self.Renderer = Renderer
end

function M:GetDraft()
  return self.Draft
end

function M:SetDraft(Draft, SkipRender)
  self.Draft = self:_CloneDraft(Draft)
  DisplayConfig:ApplySceneDefaults(self.Draft)
  self:_ResetBaselineState()
  if not SkipRender then
    self:Render()
  end
end

function M:AcceptCurrentDraftAsBaseline()
  self:_ResetBaselineState()
end

function M:LoadInitialState(Params)
  self.Draft = DisplayPersistence:BuildInitialDraft(Params)
  DisplayConfig:ApplySceneDefaults(self.Draft)
  self:_ResetBaselineState()
  self:Render()
end

function M:Snapshot(OperationMeta)
  table.insert(self.UndoStack, {
    Draft = self:_CloneDraft(self.Draft),
    Operation = self:_CloneHistoryOperation(OperationMeta)
  })
  self.RedoStack = {}
end

function M:RefreshDirtyState()
  self.IsDirty = not DisplayDraft:IsEquivalent(self.Draft, self.BaselineDraft)
end

function M:MarkDirty()
  self:RefreshDirtyState()
end

function M:IsDraftDirty()
  return self.IsDirty == true
end

function M:BeginPreviewTransaction(TransactionKey)
  local Transaction = self.ActivePreviewTransaction
  if Transaction and Transaction.Active then
    if Transaction.Key == TransactionKey then
      return false
    end
    self:CommitPreviewTransaction()
  end
  self.ActivePreviewTransaction = {
    Active = true,
    Key = TransactionKey or "default",
    StartDraft = self:_CloneDraft(self.Draft),
    Changed = false,
    Operation = nil
  }
  return true
end

function M:CommitPreviewTransaction()
  local Transaction = self.ActivePreviewTransaction
  if not Transaction or not Transaction.Active then
    return false
  end
  self.ActivePreviewTransaction = nil
  if not Transaction.Changed or DisplayDraft:IsEquivalent(Transaction.StartDraft, self.Draft) then
    return false
  end
  table.insert(self.UndoStack, {
    Draft = Transaction.StartDraft,
    Operation = self:_CloneHistoryOperation(Transaction.Operation)
  })
  self.RedoStack = {}
  self.LastHistoryOperation = self:_CloneHistoryOperation(Transaction.Operation)
  self:RefreshDirtyState()
  return true
end

function M:CancelPreviewTransaction()
  local Transaction = self.ActivePreviewTransaction
  if not Transaction or not Transaction.Active then
    return false
  end
  self.ActivePreviewTransaction = nil
  if not DisplayDraft:IsEquivalent(self.Draft, Transaction.StartDraft) then
    self.Draft = self:_CloneDraft(Transaction.StartDraft)
    self:RefreshDirtyState()
    self:Render()
  end
  return true
end

function M:IsPreviewTransactionActive(TransactionKey)
  local Transaction = self.ActivePreviewTransaction
  if not Transaction or not Transaction.Active then
    return false
  end
  if nil == TransactionKey then
    return true
  end
  return Transaction.Key == TransactionKey
end

function M:Undo()
  self:CommitPreviewTransaction()
  local SnapshotEntry = table.remove(self.UndoStack)
  if not SnapshotEntry then
    return false, nil
  end
  local SnapshotDraft = self:_ExtractHistoryDraft(SnapshotEntry)
  local Operation = self:_ExtractHistoryOperation(SnapshotEntry)
  table.insert(self.RedoStack, {
    Draft = self:_CloneDraft(self.Draft),
    Operation = self:_CloneHistoryOperation(Operation)
  })
  self.Draft = SnapshotDraft
  self.LastHistoryOperation = self:_CloneHistoryOperation(Operation)
  self:RefreshDirtyState()
  self:_ApplyDraftByHistoryOperation(Operation)
  return true, self:_CloneHistoryOperation(Operation)
end

function M:Redo()
  self:CommitPreviewTransaction()
  local SnapshotEntry = table.remove(self.RedoStack)
  if not SnapshotEntry then
    return false, nil
  end
  local SnapshotDraft = self:_ExtractHistoryDraft(SnapshotEntry)
  local Operation = self:_ExtractHistoryOperation(SnapshotEntry)
  table.insert(self.UndoStack, {
    Draft = self:_CloneDraft(self.Draft),
    Operation = self:_CloneHistoryOperation(Operation)
  })
  self.Draft = SnapshotDraft
  self.LastHistoryOperation = self:_CloneHistoryOperation(Operation)
  self:RefreshDirtyState()
  self:_ApplyDraftByHistoryOperation(Operation)
  return true, self:_CloneHistoryOperation(Operation)
end

function M:Render()
  if self.Renderer and self.Renderer.LoadDraft then
    self.Renderer:LoadDraft(self.Draft)
  end
end

function M:SetSingleCharacter(CharData, Avatar, AppearanceInfo)
  local Draft = self:_CloneDraft(self.Draft)
  DisplayRules:AssignCharacterToSlot(Draft, 1, CharData, Avatar, AppearanceInfo)
  DisplayRules:NormalizeCharacterSlots(Draft)
  return self:_CommitDraftIfChanged(Draft, {
    Type = "CharacterChooseCommit",
    AffectedSlotIndices = {
      [1] = true
    }
  })
end

function M:SetCharacterToSlot(SlotIndex, CharData, Avatar, AppearanceInfo)
  local Draft = self:_CloneDraft(self.Draft)
  DisplayRules:AssignCharacterToSlot(Draft, SlotIndex or 1, CharData, Avatar, AppearanceInfo)
  DisplayRules:NormalizeCharacterSlots(Draft)
  return self:_CommitDraftIfChanged(Draft, {
    Type = "CharacterChooseCommit",
    AffectedSlotIndices = {
      [SlotIndex or 1] = true
    }
  })
end

function M:SetCharacterAppearance(SlotIndex, AppearanceInfo)
  local Draft = self:_CloneDraft(self.Draft)
  local Slot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
  if Slot then
    Slot.Appearance = AppearanceInfo
  end
  return self:_CommitDraftIfChanged(Draft, {
    Type = "CharacterChooseCommit",
    AffectedSlotIndices = {
      [SlotIndex] = true
    }
  })
end

function M:SetCharacterWeapon(SlotIndex, WeaponData)
  local Draft = self:_CloneDraft(self.Draft)
  local Ok, Reason = DisplayRules:ApplyWeaponToCharacterSlot(Draft, SlotIndex, WeaponData)
  DebugPrint(string.format("PersonInfoDisplayEditor: SetCharacterWeapon slot=%s ok=%s reason=%s weaponId=%s weaponUuid=%s", tostring(SlotIndex), tostring(true == Ok), tostring(Reason), tostring(WeaponData and WeaponData.WeaponId or nil), tostring(WeaponData and WeaponData.Uuid or nil)))
  if not Ok then
    return false, Reason
  end
  local TargetSlot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
  if TargetSlot and TargetSlot.CharData and nil ~= WeaponData then
    TargetSlot.Action = nil
  end
  self:_CommitCharacterWeaponDraftIfChanged(Draft, {
    [SlotIndex] = true
  })
  return true
end

function M:MoveCharacterWeaponToSlot(SlotIndex, WeaponData)
  local Draft = self:_CloneDraft(self.Draft)
  DisplayDraft:EnsureCharacterSlots(Draft)
  local TargetSlot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
  if not TargetSlot or not TargetSlot.CharData then
    return false, "character_missing"
  end
  local WeaponUuid = WeaponData and WeaponData.Uuid or nil
  if not WeaponUuid then
    TargetSlot.WeaponData = nil
    self:_CommitCharacterWeaponDraftIfChanged(Draft, {
      [SlotIndex] = true
    })
    return true
  end
  local AffectedSlotIndices = {
    [SlotIndex] = true
  }
  for Index, Slot in ipairs(Draft.CharacterSlots) do
    if Index ~= SlotIndex and Slot.WeaponData and Slot.WeaponData.Uuid == WeaponUuid then
      Slot.WeaponData = nil
      AffectedSlotIndices[Index] = true
    end
  end
  TargetSlot.WeaponData = WeaponData
  TargetSlot.Action = nil
  self:_CommitCharacterWeaponDraftIfChanged(Draft, AffectedSlotIndices)
  return true
end

function M:SetCharacterWeaponWithAction(SlotIndex, WeaponData, ActionData)
  local Draft = self:_CloneDraft(self.Draft)
  DisplayDraft:EnsureCharacterSlots(Draft)
  local TargetSlot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
  if not TargetSlot or not TargetSlot.CharData then
    return false, "character_missing"
  end
  local WeaponUuid = WeaponData and WeaponData.Uuid or nil
  local AffectedSlotIndices = {
    [SlotIndex] = true
  }
  if not WeaponUuid then
    TargetSlot.WeaponData = nil
    TargetSlot.Action = ActionData
    self:_CommitCharacterWeaponDraftIfChanged(Draft, AffectedSlotIndices)
    return true
  end
  for Index, Slot in ipairs(Draft.CharacterSlots) do
    if Index ~= SlotIndex and Slot.WeaponData and Slot.WeaponData.Uuid == WeaponUuid then
      Slot.WeaponData = nil
      AffectedSlotIndices[Index] = true
    end
  end
  TargetSlot.WeaponData = WeaponData
  TargetSlot.Action = ActionData
  self:_CommitCharacterWeaponDraftIfChanged(Draft, AffectedSlotIndices)
  return true
end

function M:SetCharacterAction(SlotIndex, ActionData)
  local Draft = self:_CloneDraft(self.Draft)
  local Ok, Reason = DisplayRules:ApplyActionToCharacterSlot(Draft, SlotIndex, ActionData)
  if not Ok then
    return false, Reason
  end
  self:_CommitCharacterWeaponDraftIfChanged(Draft, {
    [SlotIndex] = true
  })
  return true
end

function M:SetCharacterTransform(SlotIndex, Transform, TransformRotation)
  local Draft = self:_CloneDraft(self.Draft)
  local Slot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
  if Slot then
    Slot.Transform = Transform
    Slot.TransformRotation = TransformRotation
  end
  return self:_CommitCharacterTransformDraftIfChanged(Draft, SlotIndex)
end

function M:SetCharacterSlotsDraft(CharacterDraft)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.CharacterSlots = DisplayDraft:Clone(CharacterDraft).CharacterSlots
  local AffectedSlotIndices = {}
  for SlotIndex = 1, 4 do
    AffectedSlotIndices[SlotIndex] = true
  end
  return self:_CommitDraftIfChanged(Draft, {
    Type = "CharacterChooseCommit",
    AffectedSlotIndices = AffectedSlotIndices
  })
end

function M:SetPetToSlot(SlotIndex, PetData)
  local Draft = self:_CloneDraft(self.Draft)
  DisplayRules:AssignPetToSlot(Draft, SlotIndex, PetData)
  DisplayRules:NormalizePetSlots(Draft)
  return self:_CommitDraftIfChanged(Draft)
end

function M:SetPetTransform(SlotIndex, Transform)
  local Draft = self:_CloneDraft(self.Draft)
  local Slot = DisplayDraft:GetPetSlot(Draft, SlotIndex)
  if Slot then
    Slot.Transform = Transform
  end
  return self:_CommitDraftIfChanged(Draft)
end

function M:SetSceneData(SceneData)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Scene = self:_CloneDraft(SceneData or {})
  DisplayConfig:ApplySceneDefaults(Draft, true)
  return self:_CommitDraftIfChanged(Draft, {
    Type = "SceneSwitch",
    SceneId = Draft.Scene and Draft.Scene.SceneId or nil
  })
end

function M:SetOtherData(OtherData)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Other = self:_CloneDraft(OtherData or {})
  return self:_CommitDraftIfChanged(Draft)
end

function M:SetCameraData(CameraData)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Camera = self:_CloneDraft(CameraData or {})
  Draft.Camera.HasCustomCamera = true
  return self:_CommitCameraDraftIfChanged(Draft, {
    Type = "CameraAdjust"
  })
end

function M:ResetCameraToSceneDefault(SceneId)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Camera = {}
  DisplayConfig:ApplySceneDefaults(Draft, true, SceneId)
  Draft.Camera.HasCustomCamera = false
  return self:_CommitCameraDraftIfChanged(Draft, {
    Type = "CameraAdjust"
  })
end

local function EnsureLocalCameraFields(Camera)
  Camera = Camera or {}
  Camera.LocalPosition = Camera.LocalPosition or {
    X = 0,
    Y = 0,
    Z = 0
  }
  Camera.LocalRotation = Camera.LocalRotation or {
    Pitch = 0,
    Yaw = 0,
    Roll = 0
  }
  return Camera
end

function M:MoveCameraOffset(HorizontalDelta, VerticalDelta, LimitConfig)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Camera = EnsureLocalCameraFields(Draft.Camera)
  local Offset = Draft.Camera.Offset or {Horizontal = 0, Vertical = 0}
  Offset.Horizontal = (Offset.Horizontal or 0) + (HorizontalDelta or 0)
  Offset.Vertical = (Offset.Vertical or 0) + (VerticalDelta or 0)
  if type(LimitConfig) == "table" then
    if LimitConfig.HorizontalMin ~= nil then
      Offset.Horizontal = math.max(LimitConfig.HorizontalMin, Offset.Horizontal)
    end
    if nil ~= LimitConfig.HorizontalMax then
      Offset.Horizontal = math.min(LimitConfig.HorizontalMax, Offset.Horizontal)
    end
    if nil ~= LimitConfig.VerticalMin then
      Offset.Vertical = math.max(LimitConfig.VerticalMin, Offset.Vertical)
    end
    if nil ~= LimitConfig.VerticalMax then
      Offset.Vertical = math.min(LimitConfig.VerticalMax, Offset.Vertical)
    end
  end
  Draft.Camera.Offset = Offset
  Draft.Camera.LocalPosition.Y = Offset.Horizontal or 0
  Draft.Camera.LocalPosition.Z = Offset.Vertical or 0
  Draft.Camera.LimitConfig = LimitConfig
  Draft.Camera.HasCustomCamera = true
  return self:_CommitCameraDraftIfChanged(Draft, {
    Type = "CameraAdjust"
  })
end

function M:MoveCameraDistance(DistanceDelta, LimitConfig)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Camera = EnsureLocalCameraFields(Draft.Camera)
  local Distance = (Draft.Camera.Distance or 0) + (DistanceDelta or 0)
  if type(LimitConfig) == "table" then
    if LimitConfig.DistanceMin ~= nil then
      Distance = math.max(LimitConfig.DistanceMin, Distance)
    end
    if nil ~= LimitConfig.DistanceMax then
      Distance = math.min(LimitConfig.DistanceMax, Distance)
    end
  end
  Draft.Camera.Distance = Distance
  Draft.Camera.LocalPosition.X = Distance
  Draft.Camera.LimitConfig = LimitConfig
  Draft.Camera.HasCustomCamera = true
  return self:_CommitCameraDraftIfChanged(Draft, {
    Type = "CameraAdjust"
  })
end

function M:MoveCameraRotation(PitchDelta, YawDelta, LimitConfig)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Camera = EnsureLocalCameraFields(Draft.Camera)
  local Rotation = Draft.Camera.Rotation or {Pitch = 0, Yaw = 0}
  Rotation.Pitch = (Rotation.Pitch or 0) + (PitchDelta or 0)
  Rotation.Yaw = (Rotation.Yaw or 0) + (YawDelta or 0)
  if type(LimitConfig) == "table" then
    if LimitConfig.PitchMin ~= nil then
      Rotation.Pitch = math.max(LimitConfig.PitchMin, Rotation.Pitch)
    end
    if nil ~= LimitConfig.PitchMax then
      Rotation.Pitch = math.min(LimitConfig.PitchMax, Rotation.Pitch)
    end
    if nil ~= LimitConfig.YawMin then
      Rotation.Yaw = math.max(LimitConfig.YawMin, Rotation.Yaw)
    end
    if nil ~= LimitConfig.YawMax then
      Rotation.Yaw = math.min(LimitConfig.YawMax, Rotation.Yaw)
    end
  end
  Draft.Camera.Rotation = Rotation
  Draft.Camera.LocalRotation.Pitch = Rotation.Pitch or 0
  Draft.Camera.LocalRotation.Yaw = Rotation.Yaw or 0
  Draft.Camera.LimitConfig = LimitConfig
  Draft.Camera.HasCustomCamera = true
  return self:_CommitCameraDraftIfChanged(Draft, {
    Type = "CameraAdjust"
  })
end

function M:MoveCameraLocalPosition(XDelta, YDelta, ZDelta, LimitConfig)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Camera = EnsureLocalCameraFields(Draft.Camera)
  local LocalPosition = Draft.Camera.LocalPosition
  LocalPosition.X = (LocalPosition.X or 0) + (XDelta or 0)
  LocalPosition.Y = (LocalPosition.Y or 0) + (YDelta or 0)
  LocalPosition.Z = (LocalPosition.Z or 0) + (ZDelta or 0)
  if type(LimitConfig) == "table" then
    if LimitConfig.DistanceMin ~= nil then
      LocalPosition.X = math.max(LimitConfig.DistanceMin, LocalPosition.X)
    end
    if nil ~= LimitConfig.DistanceMax then
      LocalPosition.X = math.min(LimitConfig.DistanceMax, LocalPosition.X)
    end
    if nil ~= LimitConfig.HorizontalMin then
      LocalPosition.Y = math.max(LimitConfig.HorizontalMin, LocalPosition.Y)
    end
    if nil ~= LimitConfig.HorizontalMax then
      LocalPosition.Y = math.min(LimitConfig.HorizontalMax, LocalPosition.Y)
    end
    if nil ~= LimitConfig.VerticalMin then
      LocalPosition.Z = math.max(LimitConfig.VerticalMin, LocalPosition.Z)
    end
    if nil ~= LimitConfig.VerticalMax then
      LocalPosition.Z = math.min(LimitConfig.VerticalMax, LocalPosition.Z)
    end
  end
  Draft.Camera.Offset = {
    Horizontal = LocalPosition.Y or 0,
    Vertical = LocalPosition.Z or 0
  }
  Draft.Camera.Distance = LocalPosition.X or 0
  Draft.Camera.LimitConfig = LimitConfig
  Draft.Camera.HasCustomCamera = true
  return self:_CommitCameraDraftIfChanged(Draft, {
    Type = "CameraAdjust"
  })
end

function M:MoveCameraLocalRotation(PitchDelta, YawDelta, RollDelta, LimitConfig)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Camera = EnsureLocalCameraFields(Draft.Camera)
  local LocalRotation = Draft.Camera.LocalRotation
  LocalRotation.Pitch = (LocalRotation.Pitch or 0) + (PitchDelta or 0)
  LocalRotation.Yaw = (LocalRotation.Yaw or 0) + (YawDelta or 0)
  LocalRotation.Roll = (LocalRotation.Roll or 0) + (RollDelta or 0)
  if type(LimitConfig) == "table" then
    if LimitConfig.PitchMin ~= nil then
      LocalRotation.Pitch = math.max(LimitConfig.PitchMin, LocalRotation.Pitch)
    end
    if nil ~= LimitConfig.PitchMax then
      LocalRotation.Pitch = math.min(LimitConfig.PitchMax, LocalRotation.Pitch)
    end
    if nil ~= LimitConfig.YawMin then
      LocalRotation.Yaw = math.max(LimitConfig.YawMin, LocalRotation.Yaw)
    end
    if nil ~= LimitConfig.YawMax then
      LocalRotation.Yaw = math.min(LimitConfig.YawMax, LocalRotation.Yaw)
    end
  end
  Draft.Camera.Rotation = {
    Pitch = LocalRotation.Pitch or 0,
    Yaw = LocalRotation.Yaw or 0
  }
  Draft.Camera.LimitConfig = LimitConfig
  Draft.Camera.HasCustomCamera = true
  return self:_CommitCameraDraftIfChanged(Draft, {
    Type = "CameraAdjust"
  })
end

function M:ExportSaveData()
  return DisplayPersistence:ExportSaveData(self.Draft)
end

function M:_CloneDraft(Draft)
  return DisplayDraft:Clone(Draft)
end

function M:_ResetBaselineState()
  self.BaselineDraft = self:_CloneDraft(self.Draft)
  self.IsDirty = false
  self.UndoStack = {}
  self.RedoStack = {}
  self.ActivePreviewTransaction = nil
  self.LastHistoryOperation = nil
end

function M:_CommitDraftIfChanged(Draft, OperationMeta)
  if DisplayDraft:IsEquivalent(self.Draft, Draft) then
    return false
  end
  if self.ActivePreviewTransaction and self.ActivePreviewTransaction.Active then
    self.ActivePreviewTransaction.Changed = true
    self.ActivePreviewTransaction.Operation = self:_CloneHistoryOperation(OperationMeta)
    self.RedoStack = {}
  else
    self:Snapshot(OperationMeta)
    self.LastHistoryOperation = self:_CloneHistoryOperation(OperationMeta)
  end
  self.Draft = Draft
  self:RefreshDirtyState()
  self:Render()
  return true
end

function M:_CommitCameraDraftIfChanged(Draft, OperationMeta)
  if DisplayDraft:IsEquivalent(self.Draft, Draft) then
    return false
  end
  if self.ActivePreviewTransaction and self.ActivePreviewTransaction.Active then
    self.ActivePreviewTransaction.Changed = true
    self.ActivePreviewTransaction.Operation = self:_CloneHistoryOperation(OperationMeta)
    self.RedoStack = {}
  else
    self:Snapshot(OperationMeta)
    self.LastHistoryOperation = self:_CloneHistoryOperation(OperationMeta)
  end
  self.Draft = Draft
  self:RefreshDirtyState()
  if self.Renderer and self.Renderer.ApplyDraftCamera then
    self.Renderer:ApplyDraftCamera(self.Draft.Camera)
  else
    self:Render()
  end
  return true
end

function M:_CommitCharacterTransformDraftIfChanged(Draft, SlotIndex)
  if DisplayDraft:IsEquivalent(self.Draft, Draft) then
    return false
  end
  local OperationMeta = {
    Type = "CharacterTransform",
    SlotIndex = SlotIndex,
    AffectedSlotIndices = {
      [SlotIndex] = true
    }
  }
  if self.ActivePreviewTransaction and self.ActivePreviewTransaction.Active then
    self.ActivePreviewTransaction.Changed = true
    self.ActivePreviewTransaction.Operation = self:_CloneHistoryOperation(OperationMeta)
    self.RedoStack = {}
  else
    self:Snapshot(OperationMeta)
    self.LastHistoryOperation = self:_CloneHistoryOperation(OperationMeta)
  end
  self.Draft = Draft
  self:RefreshDirtyState()
  local Slot = DisplayDraft:GetCharacterSlot(self.Draft, SlotIndex)
  local Transform = Slot and Slot.Transform or nil
  if self.Renderer and self.Renderer.ApplyCharacterTransform then
    local bApplied = self.Renderer:ApplyCharacterTransform(SlotIndex, Transform, self.Draft)
    if true == bApplied then
      return true
    end
  end
  self:Render()
  return true
end

function M:_CommitCharacterWeaponDraftIfChanged(Draft, AffectedSlotIndices)
  if DisplayDraft:IsEquivalent(self.Draft, Draft) then
    DebugPrint("PersonInfoDisplayEditor: _CommitCharacterWeaponDraftIfChanged skipped because equivalent")
    return false
  end
  local OperationMeta = {
    Type = "CharacterWeaponAction",
    AffectedSlotIndices = self:_CloneAffectedSlotIndexMap(AffectedSlotIndices)
  }
  if self.ActivePreviewTransaction and self.ActivePreviewTransaction.Active then
    self.ActivePreviewTransaction.Changed = true
    self.ActivePreviewTransaction.Operation = self:_CloneHistoryOperation(OperationMeta)
    self.RedoStack = {}
  else
    self:Snapshot(OperationMeta)
    self.LastHistoryOperation = self:_CloneHistoryOperation(OperationMeta)
  end
  self.Draft = Draft
  self:RefreshDirtyState()
  local bAppliedAny = false
  if self.Renderer and self.Renderer.ApplyCharacterWeaponAndAction then
    for AffectedSlotIndex, _ in pairs(AffectedSlotIndices or {}) do
      if type(AffectedSlotIndex) == "number" and AffectedSlotIndex > 0 then
        local bApplied = self.Renderer:ApplyCharacterWeaponAndAction(AffectedSlotIndex, self.Draft)
        local Slot = self.Draft and self.Draft.CharacterSlots and self.Draft.CharacterSlots[AffectedSlotIndex] or nil
        DebugPrint(string.format("PersonInfoDisplayEditor: apply weapon/action slot=%s applied=%s weaponId=%s actionPose=%s", tostring(AffectedSlotIndex), tostring(true == bApplied), tostring(Slot and Slot.WeaponData and Slot.WeaponData.WeaponId or nil), tostring(Slot and Slot.Action and Slot.Action.PoseTag or nil)))
        bAppliedAny = bAppliedAny or true == bApplied
      end
    end
  end
  if true == bAppliedAny then
    return true
  end
  self:Render()
  return true
end

function M:_CloneAffectedSlotIndexMap(AffectedSlotIndices)
  local Result = {}
  for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
    if true == bAffected then
      Result[SlotIndex] = true
    end
  end
  return Result
end

function M:_CloneHistoryOperation(Operation)
  if type(Operation) ~= "table" then
    return nil
  end
  local Result = {}
  for Key, Value in pairs(Operation) do
    if type(Value) == "table" then
      local Child = {}
      for ChildKey, ChildValue in pairs(Value) do
        Child[ChildKey] = ChildValue
      end
      Result[Key] = Child
    else
      Result[Key] = Value
    end
  end
  return Result
end

function M:_ExtractHistoryDraft(SnapshotEntry)
  if type(SnapshotEntry) == "table" and SnapshotEntry.Draft ~= nil then
    return self:_CloneDraft(SnapshotEntry.Draft)
  end
  return self:_CloneDraft(SnapshotEntry)
end

function M:_ExtractHistoryOperation(SnapshotEntry)
  if type(SnapshotEntry) ~= "table" then
    return nil
  end
  return self:_CloneHistoryOperation(SnapshotEntry.Operation)
end

function M:_ApplyDraftByHistoryOperation(Operation)
  local OperationType = Operation and Operation.Type or nil
  if "CharacterTransform" == OperationType then
    if self:_ApplyCharacterTransformHistory(Operation) then
      return
    end
  elseif "CharacterWeaponAction" == OperationType then
    if self:_ApplyCharacterWeaponActionHistory(Operation) then
      return
    end
  elseif "CameraAdjust" == OperationType and self:_ApplyCameraAdjustHistory() then
    return
  end
  self:Render()
end

function M:_ApplyCharacterTransformHistory(Operation)
  if not self.Renderer or not self.Renderer.ApplyCharacterTransform then
    return false
  end
  local AffectedSlotIndices = Operation and Operation.AffectedSlotIndices or nil
  local bAppliedAny = false
  for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
    if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
      local Slot = DisplayDraft:GetCharacterSlot(self.Draft, SlotIndex)
      local Transform = Slot and Slot.Transform or nil
      local bApplied = self.Renderer:ApplyCharacterTransform(SlotIndex, Transform, self.Draft)
      bAppliedAny = bAppliedAny or true == bApplied
    end
  end
  return bAppliedAny
end

function M:_ApplyCharacterWeaponActionHistory(Operation)
  if not self.Renderer or not self.Renderer.ApplyCharacterWeaponAndAction then
    return false
  end
  local AffectedSlotIndices = Operation and Operation.AffectedSlotIndices or nil
  local bAppliedAny = false
  for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
    if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
      local bApplied = self.Renderer:ApplyCharacterWeaponAndAction(SlotIndex, self.Draft)
      bAppliedAny = bAppliedAny or true == bApplied
    end
  end
  return bAppliedAny
end

function M:_ApplyCameraAdjustHistory()
  if not self.Renderer or not self.Renderer.ApplyDraftCamera then
    return false
  end
  self.Renderer:ApplyDraftCamera(self.Draft and self.Draft.Camera or nil)
  return true
end

return M
