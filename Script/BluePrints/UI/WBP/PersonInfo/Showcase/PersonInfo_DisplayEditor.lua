local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayRules = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayRules")
local DisplayPersistence = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayPersistence")
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
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
    self:RefreshDirtyState()
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

function M:AcceptPreviewTransaction()
  local Transaction = self.ActivePreviewTransaction
  if not Transaction or not Transaction.Active then
    return false
  end
  self.ActivePreviewTransaction = nil
  self:RefreshDirtyState()
  return true
end

function M:CommitSlotChoosePreviewTransaction()
  local Transaction = self.ActivePreviewTransaction
  if not Transaction or not Transaction.Active then
    return false
  end
  local OperationMeta
  if Transaction.Key == "pet_choose" then
    OperationMeta = {
      Type = "PetSlotChange",
      AffectedSlotIndices = self:_BuildChangedPetSlotIndexMap(Transaction.StartDraft, self.Draft)
    }
  elseif Transaction.Key == "item_choose" then
    OperationMeta = {
      Type = "ItemChoose",
      AffectedItemSlotIndices = self:_BuildChangedItemSlotIndexMap(Transaction.StartDraft, self.Draft)
    }
  end
  if not OperationMeta then
    return false
  end
  Transaction.Operation = self:_CloneHistoryOperation(OperationMeta)
  Transaction.Changed = true
  return self:CommitPreviewTransaction()
end

function M:CommitCharacterEquipChoosePreviewTransaction()
  local Transaction = self.ActivePreviewTransaction
  if not Transaction or not Transaction.Active then
    return false
  end
  Transaction.Operation = self:_CloneHistoryOperation({
    Type = "CharacterWeaponAction",
    AffectedSlotIndices = self:_BuildChangedCharacterWeaponSlotIndexMap(Transaction.StartDraft, self.Draft)
  })
  Transaction.Changed = true
  return self:CommitPreviewTransaction()
end

function M:_BuildChangedCharacterWeaponSlotIndexMap(PreviousDraft, NextDraft)
  local AffectedSlotIndices = {}
  local SlotCount = DisplayConfig:GetCharacterSlotCount()
  for SlotIndex = 1, SlotCount do
    local LeftIdentity = self:_GetCharacterWeaponActionIdentity(DisplayDraft:GetCharacterSlot(PreviousDraft, SlotIndex))
    local RightIdentity = self:_GetCharacterWeaponActionIdentity(DisplayDraft:GetCharacterSlot(NextDraft, SlotIndex))
    if not self:_IsSameCharacterWeaponActionIdentity(LeftIdentity, RightIdentity) then
      AffectedSlotIndices[SlotIndex] = true
    end
  end
  return AffectedSlotIndices
end

function M:CancelPreviewTransaction()
  local Transaction = self.ActivePreviewTransaction
  if not Transaction or not Transaction.Active then
    return false
  end
  local Operation = self:_CloneHistoryOperation(Transaction.Operation)
  local PreviousDraft = self.Draft
  self.ActivePreviewTransaction = nil
  if not DisplayDraft:IsEquivalent(self.Draft, Transaction.StartDraft) then
    self.Draft = self:_CloneDraft(Transaction.StartDraft)
    self:RefreshDirtyState()
    if Operation and Operation.Type == "CharacterWeaponAction" then
      self:_ApplyChangedCharacterWeaponSlots(PreviousDraft, self.Draft)
    elseif Operation and Operation.Type == "PetSlotChange" then
      self:_ApplyChangedPetSlots(PreviousDraft, self.Draft)
    elseif Operation and Operation.Type == "ItemChoose" then
      self:_ApplyChangedItemSlots(PreviousDraft, self.Draft)
    else
      self:_ApplyDraftByHistoryOperation(Operation)
    end
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
  DebugPrint("PersonInfoDisplayEditor: Render\n" .. tostring(debug.traceback("", 2)))
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

function M:_GetTransformSlot(Draft, Kind, SlotIndex)
  if not Draft or type(SlotIndex) ~= "number" then
    return nil
  end
  local SlotGroup
  if "Character" == Kind then
    SlotGroup = Draft.CharacterSlots
  elseif "Pet" == Kind then
    SlotGroup = Draft.PetSlots
  elseif "Item" == Kind then
    SlotGroup = Draft.ItemSlots
  end
  if not SlotGroup then
    return nil
  end
  return SlotGroup[SlotIndex]
end

function M:_GetIntegerTransformBaselineSlot(Kind, SlotIndex)
  local Draft = self.Draft
  local Transaction = self.ActivePreviewTransaction
  if Transaction and Transaction.Active and Transaction.StartDraft then
    Draft = Transaction.StartDraft
  end
  return self:_GetTransformSlot(Draft, Kind, SlotIndex)
end

function M:_IsSameEditIntegerTransform(Slot, Transform, TransformRotation)
  if not Slot then
    return false
  end
  local OldTranslation = Slot.Transform and Slot.Transform.Translation or nil
  local NewTranslation = Transform and Transform.Translation or nil
  local OldX = PersonInfoCommon.RoundEditInteger(OldTranslation and OldTranslation.X)
  local OldY = PersonInfoCommon.RoundEditInteger(OldTranslation and OldTranslation.Y)
  local OldZ = PersonInfoCommon.RoundEditInteger(OldTranslation and OldTranslation.Z)
  local NewX = PersonInfoCommon.RoundEditInteger(NewTranslation and NewTranslation.X)
  local NewY = PersonInfoCommon.RoundEditInteger(NewTranslation and NewTranslation.Y)
  local NewZ = PersonInfoCommon.RoundEditInteger(NewTranslation and NewTranslation.Z)
  if OldX ~= NewX or OldY ~= NewY or OldZ ~= NewZ then
    return false
  end
  local OldRotation = Slot.TransformRotation or {}
  local NewRotation = TransformRotation or {}
  local OldPitch = PersonInfoCommon.RoundEditInteger(OldRotation.Pitch)
  local OldYaw = PersonInfoCommon.RoundEditInteger(OldRotation.Yaw)
  local OldRoll = PersonInfoCommon.RoundEditInteger(OldRotation.Roll)
  local NewPitch = PersonInfoCommon.RoundEditInteger(NewRotation.Pitch)
  local NewYaw = PersonInfoCommon.RoundEditInteger(NewRotation.Yaw)
  local NewRoll = PersonInfoCommon.RoundEditInteger(NewRotation.Roll)
  return OldPitch == NewPitch and OldYaw == NewYaw and OldRoll == NewRoll
end

function M:_ReapplySlotTransform(Kind, SlotIndex, Transform)
  local Renderer = self.Renderer
  if "Character" == Kind and Renderer and Renderer.ApplyCharacterTransform then
    if Renderer:ApplyCharacterTransform(SlotIndex, Transform, self.Draft) == true then
      return
    end
  elseif "Pet" == Kind and Renderer and Renderer.ApplyPetTransform then
    if true == Renderer:ApplyPetTransform(SlotIndex, Transform, self.Draft) then
      return
    end
  elseif "Item" == Kind and Renderer and Renderer.ApplyItemTransform and true == Renderer:ApplyItemTransform(SlotIndex, Transform, self.Draft) then
    return
  end
  self:Render()
end

function M:_BuildIntegerTransformOperation(Kind, SlotIndex)
  if "Pet" == Kind then
    return {
      Type = "PetTransform",
      SlotIndex = SlotIndex,
      AffectedSlotIndices = {
        [SlotIndex] = true
      }
    }
  end
  if "Item" == Kind then
    return {
      Type = "ItemTransform",
      AffectedItemSlotIndices = {
        [SlotIndex] = true
      }
    }
  end
  return {
    Type = "CharacterTransform",
    SlotIndex = SlotIndex,
    AffectedSlotIndices = {
      [SlotIndex] = true
    }
  }
end

function M:_RestoreIntegerTransformSlot(LiveSlot, SourceSlot)
  local SourceRotation = SourceSlot.TransformRotation
  LiveSlot.Transform = SourceSlot.Transform
  if type(SourceRotation) == "table" then
    LiveSlot.TransformRotation = {
      Pitch = SourceRotation.Pitch,
      Yaw = SourceRotation.Yaw,
      Roll = SourceRotation.Roll
    }
  else
    LiveSlot.TransformRotation = nil
  end
end

function M:_MarkIntegerTransformTransaction(Kind, SlotIndex)
  local Transaction = self.ActivePreviewTransaction
  if not Transaction or not Transaction.Active then
    self:RefreshDirtyState()
    return
  end
  Transaction.Changed = true
  Transaction.Operation = self:_CloneHistoryOperation(self:_BuildIntegerTransformOperation(Kind, SlotIndex))
  self.RedoStack = {}
end

function M:_TryKeepIntegerTransform(Kind, SlotIndex, Transform, TransformRotation)
  local SaveSlot = self:_GetTransformSlot(self.BaselineDraft, Kind, SlotIndex)
  local GestureSlot = self:_GetIntegerTransformBaselineSlot(Kind, SlotIndex)
  local KeepSlot
  if self:_IsSameEditIntegerTransform(SaveSlot, Transform, TransformRotation) then
    KeepSlot = SaveSlot
  elseif self:_IsSameEditIntegerTransform(GestureSlot, Transform, TransformRotation) then
    KeepSlot = GestureSlot
  end
  if not KeepSlot then
    return false
  end
  local LiveSlot = self:_GetTransformSlot(self.Draft, Kind, SlotIndex)
  if LiveSlot and LiveSlot.Transform ~= KeepSlot.Transform then
    self:_RestoreIntegerTransformSlot(LiveSlot, KeepSlot)
    self:_ReapplySlotTransform(Kind, SlotIndex, LiveSlot.Transform)
    self:_MarkIntegerTransformTransaction(Kind, SlotIndex)
  end
  return true
end

function M:SetCharacterTransform(SlotIndex, Transform, TransformRotation)
  if self:_TryKeepIntegerTransform("Character", SlotIndex, Transform, TransformRotation) then
    return false
  end
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
  local AffectedSlotIndices = self:_BuildChangedCharacterSlotIndexMap(self.Draft, Draft)
  return self:_CommitDraftIfChanged(Draft, {
    Type = "CharacterChooseCommit",
    AffectedSlotIndices = AffectedSlotIndices
  }, true)
end

function M:_BuildCharacterSlotContentIdentity(Slot)
  if not DisplayDraft:IsCharacterSlotOccupied(Slot) then
    return nil
  end
  local CharData = Slot.CharData
  local WeaponData = Slot.WeaponData
  local Action = Slot.Action
  local Appearance = Slot.Appearance
  local AppearanceKey
  if type(Appearance) == "table" then
    AppearanceKey = Appearance.AppearancePlan or Appearance.PlanIndex or Appearance.SuitIndex
  end
  local ContentIdentity = self:_BuildSlotTransformCompareIdentity(Slot)
  ContentIdentity.CharKey = CharData.Uuid or CharData.CharId
  ContentIdentity.WeaponId = WeaponData and WeaponData.WeaponId or nil
  ContentIdentity.ActionMode = Action and Action.Mode or nil
  ContentIdentity.ActionPoseId = Action and Action.PoseId or nil
  ContentIdentity.ActionPoseTag = Action and Action.PoseTag or nil
  ContentIdentity.ActionMontagePath = Action and Action.MontagePath or nil
  ContentIdentity.ActionDocument = Action and Action.Document or nil
  ContentIdentity.ActionPoseName = Action and Action.PoseName or nil
  ContentIdentity.ActionReleaseWheel = Action and Action.ReleaseWheel or nil
  ContentIdentity.AppearanceKey = AppearanceKey
  return ContentIdentity
end

function M:_IsSameCharacterSlotContent(LeftSlot, RightSlot)
  return DisplayDraft:IsEquivalent(self:_BuildCharacterSlotContentIdentity(LeftSlot), self:_BuildCharacterSlotContentIdentity(RightSlot)) == true
end

function M:_BuildChangedCharacterSlotIndexMap(LeftDraft, RightDraft)
  local AffectedSlotIndices = {}
  local CharacterSlotCount = DisplayConfig:GetCharacterSlotCount()
  for SlotIndex = 1, CharacterSlotCount do
    local LeftSlot = LeftDraft and DisplayDraft:GetCharacterSlot(LeftDraft, SlotIndex) or nil
    local RightSlot = RightDraft and DisplayDraft:GetCharacterSlot(RightDraft, SlotIndex) or nil
    if not self:_IsSameCharacterSlotContent(LeftSlot, RightSlot) then
      AffectedSlotIndices[SlotIndex] = true
    end
  end
  return AffectedSlotIndices
end

function M:_BuildPetAffectedSlotIndexMap(SlotIndex, ExtraSlotIndex)
  local AffectedSlotIndices = {}
  if type(SlotIndex) == "number" and SlotIndex > 0 then
    AffectedSlotIndices[SlotIndex] = true
  end
  if type(ExtraSlotIndex) == "number" and ExtraSlotIndex > 0 then
    AffectedSlotIndices[ExtraSlotIndex] = true
  end
  return AffectedSlotIndices
end

function M:SetPetToSlot(SlotIndex, PetData)
  local PetKey = PetData and PetData.UniqueId or nil
  local _, OldSlotIndex = DisplayRules:FindPetSlotByPetKey(self.Draft, PetKey)
  local AffectedSlotIndices = self:_BuildPetAffectedSlotIndexMap(SlotIndex, OldSlotIndex)
  local Draft = self:_CloneDraft(self.Draft)
  DisplayRules:AssignPetToSlot(Draft, SlotIndex, PetData)
  return self:_CommitPetSlotDraftIfChanged(Draft, AffectedSlotIndices)
end

function M:RemovePetFromSlot(SlotIndex)
  local Draft = self:_CloneDraft(self.Draft)
  DisplayRules:RemovePetFromSlot(Draft, SlotIndex)
  return self:_CommitPetSlotDraftIfChanged(Draft, self:_BuildPetAffectedSlotIndexMap(SlotIndex))
end

function M:RestorePetSlotsFromDraft(SourceDraft)
  if not SourceDraft then
    return false
  end
  local Draft = self:_CloneDraft(self.Draft)
  local SourceClone = DisplayDraft:Clone(SourceDraft)
  Draft.PetSlots = SourceClone.PetSlots
  DisplayDraft:EnsurePetSlots(Draft)
  return self:_CommitPetSlotDraftIfChanged(Draft, self:_BuildChangedPetSlotIndexMap(self.Draft, Draft))
end

function M:_GetPetSlotIdentity(Slot)
  if not DisplayDraft:IsPetSlotOccupied(Slot) then
    return nil
  end
  local PetData = Slot.PetData
  return PetData.UniqueId or PetData.PetId
end

function M:_BuildSlotTransformCompareIdentity(Slot)
  local Translation = Slot and Slot.Transform and Slot.Transform.Translation or nil
  local Rotation = Slot and Slot.TransformRotation or nil
  if type(Rotation) ~= "table" and Slot and Slot.Transform and Slot.Transform.Rotation then
    local Quat = Slot.Transform.Rotation
    if Quat and Quat.ToRotator then
      local Rotator = Quat:ToRotator()
      Rotation = {
        Pitch = Rotator and Rotator.Pitch,
        Yaw = Rotator and Rotator.Yaw,
        Roll = Rotator and Rotator.Roll
      }
    end
  end
  Rotation = Rotation or {}
  return {
    TransformX = PersonInfoCommon.RoundEditInteger(Translation and Translation.X),
    TransformY = PersonInfoCommon.RoundEditInteger(Translation and Translation.Y),
    TransformZ = PersonInfoCommon.RoundEditInteger(Translation and Translation.Z),
    TransformPitch = PersonInfoCommon.RoundEditInteger(Rotation.Pitch),
    TransformYaw = PersonInfoCommon.RoundEditInteger(Rotation.Yaw),
    TransformRoll = PersonInfoCommon.RoundEditInteger(Rotation.Roll)
  }
end

function M:_IsSamePetSlotContent(LeftSlot, RightSlot)
  local LeftIdentity = self:_GetPetSlotIdentity(LeftSlot)
  local RightIdentity = self:_GetPetSlotIdentity(RightSlot)
  if LeftIdentity ~= RightIdentity then
    return false
  end
  if nil == LeftIdentity then
    return true
  end
  return DisplayDraft:IsEquivalent(self:_BuildSlotTransformCompareIdentity(LeftSlot), self:_BuildSlotTransformCompareIdentity(RightSlot)) == true
end

function M:_BuildChangedPetSlotIndexMap(LeftDraft, RightDraft)
  local AffectedSlotIndices = {}
  local PetSlotCount = DisplayConfig:GetPetSlotCount()
  for SlotIndex = 1, PetSlotCount do
    local LeftSlot = LeftDraft and DisplayDraft:GetPetSlot(LeftDraft, SlotIndex) or nil
    local RightSlot = RightDraft and DisplayDraft:GetPetSlot(RightDraft, SlotIndex) or nil
    if not self:_IsSamePetSlotContent(LeftSlot, RightSlot) then
      AffectedSlotIndices[SlotIndex] = true
    end
  end
  return AffectedSlotIndices
end

function M:_CommitPetSlotDraftIfChanged(Draft, AffectedSlotIndices)
  if DisplayDraft:IsEquivalent(self.Draft, Draft) then
    return false
  end
  local OperationMeta = {
    Type = "PetSlotChange",
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
  self:_ApplyPetSlotIndexMap(AffectedSlotIndices)
  return true
end

function M:_ApplyCharacterSlotIndexMap(AffectedSlotIndices)
  if not self.Renderer or not self.Renderer.ApplyCharacterSlot then
    self:Render()
    return
  end
  local bOccupiedFailed = false
  for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
    if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
      local bApplied = true == self.Renderer:ApplyCharacterSlot(SlotIndex, self.Draft)
      if not bApplied then
        local Slot = DisplayDraft:GetCharacterSlot(self.Draft, SlotIndex)
        if DisplayDraft:IsCharacterSlotOccupied(Slot) then
          bOccupiedFailed = true
        end
      end
    end
  end
  if bOccupiedFailed then
    self:Render()
  end
end

function M:_ApplyPetSlotIndexMap(AffectedSlotIndices)
  if not self.Renderer or not self.Renderer.ApplyPetSlot then
    self:Render()
    return
  end
  local bOccupiedFailed = false
  for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
    if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
      local bApplied = true == self.Renderer:ApplyPetSlot(SlotIndex, self.Draft)
      if not bApplied then
        local Slot = DisplayDraft:GetPetSlot(self.Draft, SlotIndex)
        if DisplayDraft:IsPetSlotOccupied(Slot) then
          bOccupiedFailed = true
        end
      end
    end
  end
  if bOccupiedFailed then
    self:Render()
  end
end

function M:_ApplyChangedPetSlots(PreviousDraft, NextDraft)
  self:_ApplyPetSlotIndexMap(self:_BuildChangedPetSlotIndexMap(PreviousDraft, NextDraft))
end

function M:SetPetTransform(SlotIndex, Transform, TransformRotation)
  if self:_TryKeepIntegerTransform("Pet", SlotIndex, Transform, TransformRotation) then
    return false
  end
  if self.ActivePreviewTransaction and self.ActivePreviewTransaction.Active then
    return self:_ApplyPetTransformPreview(SlotIndex, Transform, TransformRotation)
  end
  local Draft = self:_CloneDraft(self.Draft)
  local Slot = DisplayDraft:GetPetSlot(Draft, SlotIndex)
  if Slot then
    Slot.Transform = Transform
    Slot.TransformRotation = TransformRotation
  end
  return self:_CommitPetTransformDraftIfChanged(Draft, SlotIndex)
end

function M:_BuildItemAffectedSlotIndexMap(SlotIndex, ExtraSlotIndex)
  local AffectedItemSlotIndices = {}
  if type(SlotIndex) == "number" and SlotIndex > 0 then
    AffectedItemSlotIndices[SlotIndex] = true
  end
  if type(ExtraSlotIndex) == "number" and ExtraSlotIndex > 0 then
    AffectedItemSlotIndices[ExtraSlotIndex] = true
  end
  return AffectedItemSlotIndices
end

function M:SetItemToSlot(SlotIndex, ItemData)
  local ItemKey = ItemData and ItemData.ItemId or nil
  local _, OldSlotIndex = DisplayRules:FindItemSlotByItemKey(self.Draft, ItemKey)
  local Draft = self:_CloneDraft(self.Draft)
  if not DisplayRules:AssignItemToSlot(Draft, SlotIndex, ItemData) then
    return false
  end
  return self:_CommitItemSlotDraftIfChanged(Draft, self:_BuildItemAffectedSlotIndexMap(SlotIndex, OldSlotIndex))
end

function M:RemoveItemFromSlot(SlotIndex)
  local Draft = self:_CloneDraft(self.Draft)
  if not DisplayRules:RemoveItemFromSlot(Draft, SlotIndex) then
    return false
  end
  return self:_CommitItemSlotDraftIfChanged(Draft, self:_BuildItemAffectedSlotIndexMap(SlotIndex))
end

function M:RestoreItemSlotsFromDraft(SourceDraft)
  if not SourceDraft then
    return false
  end
  local Draft = self:_CloneDraft(self.Draft)
  local SourceClone = DisplayDraft:Clone(SourceDraft)
  Draft.ItemSlots = SourceClone.ItemSlots
  DisplayDraft:EnsureItemSlots(Draft)
  return self:_CommitItemSlotDraftIfChanged(Draft, self:_BuildChangedItemSlotIndexMap(self.Draft, Draft))
end

function M:_GetItemSlotIdentity(Slot)
  if not DisplayDraft:IsItemSlotOccupied(Slot) then
    return nil
  end
  local ItemData = Slot.ItemData
  return ItemData.ItemId or ItemData.Id
end

function M:_IsSameItemSlotContent(LeftSlot, RightSlot)
  local LeftIdentity = self:_GetItemSlotIdentity(LeftSlot)
  local RightIdentity = self:_GetItemSlotIdentity(RightSlot)
  if LeftIdentity ~= RightIdentity then
    return false
  end
  if nil == LeftIdentity then
    return true
  end
  return DisplayDraft:IsEquivalent(self:_BuildSlotTransformCompareIdentity(LeftSlot), self:_BuildSlotTransformCompareIdentity(RightSlot)) == true
end

function M:_BuildChangedItemSlotIndexMap(LeftDraft, RightDraft)
  local AffectedItemSlotIndices = {}
  local ItemSlotCount = DisplayConfig:GetItemSlotCount()
  for SlotIndex = 1, ItemSlotCount do
    local LeftSlot = LeftDraft and DisplayDraft:GetItemSlot(LeftDraft, SlotIndex) or nil
    local RightSlot = RightDraft and DisplayDraft:GetItemSlot(RightDraft, SlotIndex) or nil
    if not self:_IsSameItemSlotContent(LeftSlot, RightSlot) then
      AffectedItemSlotIndices[SlotIndex] = true
    end
  end
  return AffectedItemSlotIndices
end

function M:_CommitItemSlotDraftIfChanged(Draft, AffectedItemSlotIndices)
  if DisplayDraft:IsEquivalent(self.Draft, Draft) then
    return false
  end
  local OperationMeta = {
    Type = "ItemChoose",
    AffectedItemSlotIndices = self:_CloneAffectedSlotIndexMap(AffectedItemSlotIndices)
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
  self:_ApplyItemSlotIndexMap(AffectedItemSlotIndices)
  return true
end

function M:_ApplyItemSlotIndexMap(AffectedItemSlotIndices)
  if not self.Renderer or not self.Renderer.ApplyItemSlot then
    self:Render()
    return
  end
  local bOccupiedFailed = false
  for SlotIndex, bAffected in pairs(AffectedItemSlotIndices or {}) do
    if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
      local bApplied = true == self.Renderer:ApplyItemSlot(SlotIndex, self.Draft)
      if not bApplied then
        local Slot = DisplayDraft:GetItemSlot(self.Draft, SlotIndex)
        if DisplayDraft:IsItemSlotOccupied(Slot) then
          bOccupiedFailed = true
        end
      end
    end
  end
  if bOccupiedFailed then
    self:Render()
  end
end

function M:_ApplyChangedItemSlots(PreviousDraft, NextDraft)
  self:_ApplyItemSlotIndexMap(self:_BuildChangedItemSlotIndexMap(PreviousDraft, NextDraft))
end

function M:SetItemTransform(SlotIndex, Transform, TransformRotation)
  local Draft = self:_CloneDraft(self.Draft)
  local Slot = DisplayDraft:GetItemSlot(Draft, SlotIndex)
  if not DisplayDraft:IsItemSlotOccupied(Slot) then
    return false
  end
  if self:_TryKeepIntegerTransform("Item", SlotIndex, Transform, TransformRotation) then
    return false
  end
  Slot.Transform = Transform
  Slot.TransformRotation = TransformRotation
  return self:_CommitItemTransformDraftIfChanged(Draft, SlotIndex)
end

function M:_ApplyPetTransformPreview(SlotIndex, Transform, TransformRotation)
  local Slot = DisplayDraft:GetPetSlot(self.Draft, SlotIndex)
  if not Slot then
    return false
  end
  Slot.Transform = Transform
  Slot.TransformRotation = TransformRotation
  local OperationMeta = {
    Type = "PetTransform",
    SlotIndex = SlotIndex,
    AffectedSlotIndices = {
      [SlotIndex] = true
    }
  }
  self.ActivePreviewTransaction.Changed = true
  self.ActivePreviewTransaction.Operation = self:_CloneHistoryOperation(OperationMeta)
  self.RedoStack = {}
  self.IsDirty = true
  if self.Renderer and self.Renderer.ApplyPetTransform then
    local bApplied = self.Renderer:ApplyPetTransform(SlotIndex, Transform, self.Draft)
    if true == bApplied then
      return true
    end
  end
  self:Render()
  return true
end

function M:SetSceneData(SceneData)
  local Draft = self:_CloneDraft(self.Draft)
  local PreviousLightParam = self.Draft and self.Draft.Scene and self.Draft.Scene.LightParam or nil
  Draft.Scene = self:_CloneDraft(SceneData or {})
  if Draft.Scene.LightParam == nil and nil ~= PreviousLightParam then
    Draft.Scene.LightParam = self:_CloneDraft(PreviousLightParam)
  end
  DisplayConfig:ApplySceneDefaults(Draft, true)
  return self:_CommitSceneSwitchDraftIfChanged(Draft)
end

function M:_CommitSceneSwitchDraftIfChanged(Draft)
  if DisplayDraft:IsEquivalent(self.Draft, Draft) then
    return false
  end
  local OperationMeta = {
    Type = "SceneSwitch",
    SceneId = Draft.Scene and Draft.Scene.SceneId or nil
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
  if self.Renderer and self.Renderer.ApplySceneSwitch and true == self.Renderer:ApplySceneSwitch(self.Draft) then
    return true
  end
  self:Render()
  return true
end

function M:UpdateSceneLightData(LightEditData)
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Scene = Draft.Scene or {}
  if not LightEditData or LightEditData.HasUserLight == false then
    Draft.Scene.LightParam = DisplayPersistence:BuildSceneInitialLightParam(Draft.Scene.SceneId)
  else
    Draft.Scene.LightParam = {
      Intensity = LightEditData.LightIntensity or LightEditData.Intensity or 0,
      Direction = {
        LightEditData.Roll or 0,
        LightEditData.Pitch or 0,
        LightEditData.Yaw or 0
      }
    }
  end
  if DisplayDraft:IsEquivalent(self.Draft, Draft) then
    return false
  end
  local OperationMeta = {Type = "SceneLight"}
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
  return true
end

function M:SetOtherData(OtherData, OperationMeta)
  if self.ActivePreviewTransaction and self.ActivePreviewTransaction.Active then
    return self:_ApplyOtherPreview(OtherData, OperationMeta)
  end
  local Draft = self:_CloneDraft(self.Draft)
  Draft.Other = self:_CloneDraft(OtherData or {})
  return self:_CommitOtherDraftIfChanged(Draft, OperationMeta)
end

function M:_ApplyOtherPreview(OtherData, OperationMeta)
  if not self.ActivePreviewTransaction or not self.ActivePreviewTransaction.Active then
    return false
  end
  self.Draft.Other = self:_CloneDraft(OtherData or {})
  self.ActivePreviewTransaction.Changed = true
  self.ActivePreviewTransaction.Operation = self:_CloneHistoryOperation(OperationMeta)
  self.RedoStack = {}
  self.IsDirty = true
  return true
end

function M:_CommitOtherDraftIfChanged(Draft, OperationMeta)
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
  return true
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

function M:PrepareDraftForSave()
  local SaveDraft = self:_CloneDraft(self.Draft)
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar() or nil
  local OwnedPets = Avatar and Avatar.Pets or nil
  DisplayRules:DropUnownedPetSlots(SaveDraft, OwnedPets)
  return SaveDraft
end

function M:ExportSaveData()
  return DisplayPersistence:ExportSaveData(self:PrepareDraftForSave())
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

function M:_CommitDraftIfChanged(Draft, OperationMeta, bSkipRender)
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
  if true ~= bSkipRender then
    self:Render()
  end
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

function M:_CommitPetTransformDraftIfChanged(Draft, SlotIndex)
  if DisplayDraft:IsEquivalent(self.Draft, Draft) then
    return false
  end
  local OperationMeta = {
    Type = "PetTransform",
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
  local Slot = DisplayDraft:GetPetSlot(self.Draft, SlotIndex)
  local Transform = Slot and Slot.Transform or nil
  if self.Renderer and self.Renderer.ApplyPetTransform then
    local bApplied = self.Renderer:ApplyPetTransform(SlotIndex, Transform, self.Draft)
    if true == bApplied then
      return true
    end
  end
  self:Render()
  return true
end

function M:_CommitItemTransformDraftIfChanged(Draft, SlotIndex)
  if DisplayDraft:IsEquivalent(self.Draft, Draft) then
    return false
  end
  local OperationMeta = {
    Type = "ItemTransform",
    AffectedItemSlotIndices = {
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
  local Slot = DisplayDraft:GetItemSlot(self.Draft, SlotIndex)
  if self.Renderer and self.Renderer.ApplyItemTransform and self.Renderer:ApplyItemTransform(SlotIndex, Slot and Slot.Transform or nil, self.Draft) then
    return true
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
  elseif "PetTransform" == OperationType then
    if self:_ApplyPetTransformHistory(Operation) then
      return
    end
  elseif "CharacterWeaponAction" == OperationType then
    if self:_ApplyCharacterWeaponActionHistory(Operation) then
      return
    end
  elseif "CameraAdjust" == OperationType then
    if self:_ApplyCameraAdjustHistory() then
      return
    end
  elseif "SceneLight" == OperationType then
    if self.Renderer and self.Renderer.ApplyDraftSceneLight then
      self.Renderer:ApplyDraftSceneLight(self.Draft)
      return
    end
  elseif "SceneSwitch" == OperationType then
    if self.Renderer and self.Renderer.ApplySceneSwitch and self.Renderer:ApplySceneSwitch(self.Draft) == true then
      return
    end
  elseif "FilterSwitch" == OperationType or "FilterIntensity" == OperationType then
    if self.Renderer and self.Renderer.ApplyDraftFilter then
      self.Renderer:ApplyDraftFilter(self.Draft)
    end
    return
  elseif "StickerSwitch" == OperationType or "StickerRemove" == OperationType or "StickerTransform" == OperationType then
    return
  elseif "PetSlotChange" == OperationType then
    self:_ApplyPetSlotIndexMap(Operation and Operation.AffectedSlotIndices or nil)
    return
  elseif "ItemChoose" == OperationType then
    self:_ApplyItemSlotIndexMap(Operation and Operation.AffectedItemSlotIndices or nil)
    return
  elseif "CharacterChooseCommit" == OperationType then
    self:_ApplyCharacterSlotIndexMap(Operation and Operation.AffectedSlotIndices or nil)
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

function M:_ApplyPetTransformHistory(Operation)
  if not self.Renderer or not self.Renderer.ApplyPetTransform then
    return false
  end
  local AffectedSlotIndices = Operation and Operation.AffectedSlotIndices or nil
  local bAppliedAny = false
  for SlotIndex, bAffected in pairs(AffectedSlotIndices or {}) do
    if true == bAffected and type(SlotIndex) == "number" and SlotIndex > 0 then
      local Slot = DisplayDraft:GetPetSlot(self.Draft, SlotIndex)
      local Transform = Slot and Slot.Transform or nil
      local bApplied = self.Renderer:ApplyPetTransform(SlotIndex, Transform, self.Draft)
      bAppliedAny = bAppliedAny or true == bApplied
    end
  end
  return bAppliedAny
end

function M:_GetCharacterWeaponActionIdentity(Slot)
  if not Slot or not Slot.CharData then
    return nil
  end
  local WeaponData = Slot.WeaponData
  local Action = Slot.Action
  return {
    WeaponId = WeaponData and WeaponData.WeaponId or nil,
    Mode = Action and Action.Mode or nil,
    PoseId = Action and Action.PoseId or nil,
    PoseTag = Action and Action.PoseTag or nil,
    MontagePath = Action and Action.MontagePath or nil,
    Document = Action and Action.Document or nil,
    PoseName = Action and Action.PoseName or nil,
    ReleaseWheel = Action and Action.ReleaseWheel or nil
  }
end

function M:_IsSameCharacterWeaponActionIdentity(Left, Right)
  if nil == Left and nil == Right then
    return true
  end
  if type(Left) ~= "table" or type(Right) ~= "table" then
    return false
  end
  return Left.WeaponId == Right.WeaponId and Left.Mode == Right.Mode and Left.PoseId == Right.PoseId and Left.PoseTag == Right.PoseTag and Left.MontagePath == Right.MontagePath and Left.Document == Right.Document and Left.PoseName == Right.PoseName and Left.ReleaseWheel == Right.ReleaseWheel
end

function M:_ApplyChangedCharacterWeaponSlots(PreviousDraft, NextDraft)
  if not self.Renderer or not self.Renderer.ApplyCharacterWeaponAndAction then
    return
  end
  local SlotCount = DisplayConfig:GetCharacterSlotCount()
  for SlotIndex = 1, SlotCount do
    local LeftIdentity = self:_GetCharacterWeaponActionIdentity(DisplayDraft:GetCharacterSlot(PreviousDraft, SlotIndex))
    local RightIdentity = self:_GetCharacterWeaponActionIdentity(DisplayDraft:GetCharacterSlot(NextDraft, SlotIndex))
    if not self:_IsSameCharacterWeaponActionIdentity(LeftIdentity, RightIdentity) then
      self.Renderer:ApplyCharacterWeaponAndAction(SlotIndex, self.Draft)
    end
  end
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
