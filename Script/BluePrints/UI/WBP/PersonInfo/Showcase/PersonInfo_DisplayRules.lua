local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local M = {}

local function GetCharacterUniqueKey(CharData)
  return CharData and (CharData.Uuid or CharData.CharId) or nil
end

local function GetPetId(PetData)
  return PetData and PetData.PetId or nil
end

local function GetWeaponId(WeaponData)
  return WeaponData and WeaponData.WeaponId or nil
end

local function CloneSimpleTable(Value)
  if type(Value) ~= "table" then
    return Value
  end
  local NewValue = {}
  for Key, SubValue in pairs(Value) do
    NewValue[Key] = SubValue
  end
  return NewValue
end

function M:NormalizeCharacterSlots(Draft)
  DisplayDraft:EnsureCharacterSlots(Draft)
  local OccupiedSlots = {}
  local EmptySlots = {}
  for _, Slot in ipairs(Draft.CharacterSlots) do
    if DisplayDraft:IsCharacterSlotOccupied(Slot) then
      table.insert(OccupiedSlots, Slot)
    else
      table.insert(EmptySlots, Slot)
    end
  end
  local OrderedSlots = {}
  for _, Slot in ipairs(OccupiedSlots) do
    table.insert(OrderedSlots, Slot)
  end
  for _, Slot in ipairs(EmptySlots) do
    table.insert(OrderedSlots, Slot)
  end
  for Index, Slot in ipairs(OrderedSlots) do
    Slot.SlotIndex = Index
    Draft.CharacterSlots[Index] = Slot
  end
end

function M:NormalizePetSlots(Draft)
  DisplayDraft:EnsurePetSlots(Draft)
  local OccupiedSlots = {}
  local EmptySlots = {}
  for _, Slot in ipairs(Draft.PetSlots) do
    if DisplayDraft:IsPetSlotOccupied(Slot) then
      table.insert(OccupiedSlots, Slot)
    else
      table.insert(EmptySlots, Slot)
    end
  end
  local OrderedSlots = {}
  for _, Slot in ipairs(OccupiedSlots) do
    table.insert(OrderedSlots, Slot)
  end
  for _, Slot in ipairs(EmptySlots) do
    table.insert(OrderedSlots, Slot)
  end
  for Index, Slot in ipairs(OrderedSlots) do
    Slot.SlotIndex = Index
    Draft.PetSlots[Index] = Slot
  end
end

function M:FindCharacterSlotByCharacterKey(Draft, CharacterKey)
  if not CharacterKey then
    return nil
  end
  DisplayDraft:EnsureCharacterSlots(Draft)
  for Index, Slot in ipairs(Draft.CharacterSlots) do
    if GetCharacterUniqueKey(Slot.CharData) == CharacterKey then
      return Slot, Index
    end
  end
  return nil
end

function M:FindPetSlotByPetId(Draft, PetId)
  if not PetId then
    return nil
  end
  DisplayDraft:EnsurePetSlots(Draft)
  for Index, Slot in ipairs(Draft.PetSlots) do
    if GetPetId(Slot.PetData) == PetId then
      return Slot, Index
    end
  end
  return nil
end

function M:FindWeaponConflictSlot(Draft, WeaponId, IgnoreSlotIndex)
  if not WeaponId then
    return nil
  end
  DisplayDraft:EnsureCharacterSlots(Draft)
  for Index, Slot in ipairs(Draft.CharacterSlots) do
    if Index ~= IgnoreSlotIndex and GetWeaponId(Slot.WeaponData) == WeaponId then
      return Slot, Index
    end
  end
  return nil
end

function M:AssignCharacterToSlot(Draft, SlotIndex, CharData, Avatar, Appearance)
  local TargetSlot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
  local CharacterKey = GetCharacterUniqueKey(CharData)
  if not TargetSlot or not CharacterKey then
    return TargetSlot
  end
  local OldSlot = self:FindCharacterSlotByCharacterKey(Draft, CharacterKey)
  if OldSlot and OldSlot ~= TargetSlot then
    OldSlot.CharData = nil
    OldSlot.Avatar = nil
    OldSlot.Appearance = nil
    OldSlot.WeaponData = nil
    OldSlot.Action = nil
    OldSlot.Transform = nil
    OldSlot.TransformRotation = nil
  end
  local SceneId = Draft and Draft.Scene and Draft.Scene.SceneId or nil
  local bReplacingOccupiedSlot = DisplayDraft:IsCharacterSlotOccupied(TargetSlot)
  local KeepTransform, KeepTransformRotation
  if bReplacingOccupiedSlot then
    KeepTransform = TargetSlot.Transform or DisplayConfig:GetDefaultCharacterTransform(SlotIndex, SceneId)
    KeepTransformRotation = CloneSimpleTable(TargetSlot.TransformRotation)
  else
    KeepTransform = DisplayConfig:GetDefaultCharacterTransform(SlotIndex, SceneId)
  end
  TargetSlot.CharData = CharData
  TargetSlot.Avatar = Avatar
  TargetSlot.Appearance = Appearance
  TargetSlot.Transform = KeepTransform
  TargetSlot.TransformRotation = KeepTransformRotation
  TargetSlot.WeaponData = nil
  TargetSlot.Action = nil
  return TargetSlot
end

function M:AssignPetToSlot(Draft, SlotIndex, PetData)
  local TargetSlot = DisplayDraft:GetPetSlot(Draft, SlotIndex)
  local PetId = GetPetId(PetData)
  if not TargetSlot or not PetId then
    return TargetSlot
  end
  local OldSlot = self:FindPetSlotByPetId(Draft, PetId)
  if OldSlot and OldSlot ~= TargetSlot then
    OldSlot.PetData = nil
  end
  TargetSlot.PetData = PetData
  TargetSlot.Transform = TargetSlot.Transform or DisplayConfig:GetDefaultPetTransform(SlotIndex)
  return TargetSlot
end

function M:RemoveCharacterFromSlot(Draft, SlotIndex)
  local Slot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
  if not Slot then
    return
  end
  Slot.CharData = nil
  Slot.Avatar = nil
  Slot.Appearance = nil
  Slot.WeaponData = nil
  Slot.Action = nil
  Slot.Transform = nil
  Slot.TransformRotation = nil
end

function M:RemovePetFromSlot(Draft, SlotIndex)
  local Slot = DisplayDraft:GetPetSlot(Draft, SlotIndex)
  if not Slot then
    return
  end
  Slot.PetData = nil
end

function M:ApplyWeaponToCharacterSlot(Draft, SlotIndex, WeaponData)
  local Slot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
  if not Slot or not Slot.CharData then
    return false, "character_missing"
  end
  local WeaponId = GetWeaponId(WeaponData)
  if not WeaponId then
    Slot.WeaponData = nil
    return true
  end
  local _, ConflictSlotIndex = self:FindWeaponConflictSlot(Draft, WeaponId, SlotIndex)
  if ConflictSlotIndex then
    return false, "weapon_conflict"
  end
  Slot.WeaponData = WeaponData
  return true
end

function M:ApplyActionToCharacterSlot(Draft, SlotIndex, ActionData)
  local Slot = DisplayDraft:GetCharacterSlot(Draft, SlotIndex)
  if not Slot or not Slot.CharData then
    return false, "character_missing"
  end
  Slot.Action = ActionData
  return true
end

return M
