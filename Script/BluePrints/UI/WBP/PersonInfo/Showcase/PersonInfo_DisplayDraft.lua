local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local M = {}

local function GetDefaultCharacterSlotCount()
  return DisplayConfig:GetCharacterSlotCount()
end

local function GetDefaultPetSlotCount()
  return DisplayConfig:GetPetSlotCount()
end

local function CloneValue(Value, Visited)
  if type(Value) ~= "table" then
    return Value
  end
  Visited = Visited or {}
  if Visited[Value] then
    return Visited[Value]
  end
  local NewValue = {}
  Visited[Value] = NewValue
  for Key, SubValue in pairs(Value) do
    NewValue[CloneValue(Key, Visited)] = CloneValue(SubValue, Visited)
  end
  return NewValue
end

local function IsSameTable(ValueA, ValueB, Visited)
  if ValueA == ValueB then
    return true
  end
  if type(ValueA) ~= type(ValueB) then
    return false
  end
  if type(ValueA) ~= "table" then
    return false
  end
  Visited = Visited or {}
  if Visited[ValueA] == ValueB then
    return true
  end
  Visited[ValueA] = ValueB
  for Key, SubValueA in pairs(ValueA) do
    if not IsSameTable(SubValueA, ValueB[Key], Visited) then
      return false
    end
  end
  for Key, _ in pairs(ValueB) do
    if nil == ValueA[Key] then
      return false
    end
  end
  return true
end

local function CloneCharacterSlot(Slot)
  if not Slot then
    return nil
  end
  return {
    SlotIndex = Slot.SlotIndex,
    CharData = Slot.CharData,
    Avatar = Slot.Avatar,
    Appearance = CloneValue(Slot.Appearance),
    WeaponData = Slot.WeaponData,
    Action = CloneValue(Slot.Action),
    Transform = Slot.Transform,
    TransformRotation = CloneValue(Slot.TransformRotation)
  }
end

local function ClonePetSlot(Slot)
  if not Slot then
    return nil
  end
  return {
    SlotIndex = Slot.SlotIndex,
    PetData = Slot.PetData,
    OwnerEntityId = Slot.OwnerEntityId,
    Transform = Slot.Transform
  }
end

local function IsDraftTable(Draft)
  return type(Draft) == "table" and Draft.CharacterSlots ~= nil and nil ~= Draft.PetSlots and nil ~= Draft.Scene
end

local function BuildEmptyCharacterSlot(Index)
  return {
    SlotIndex = Index,
    CharData = nil,
    Avatar = nil,
    Appearance = nil,
    WeaponData = nil,
    Action = nil,
    Transform = nil,
    TransformRotation = nil
  }
end

local function BuildEmptyPetSlot(Index)
  return {
    SlotIndex = Index,
    PetData = nil,
    OwnerEntityId = nil,
    Transform = nil
  }
end

function M:CreateEmpty(SceneId)
  local Draft = {
    Version = 1,
    CharacterSlots = {},
    PetSlots = {},
    Scene = {
      SceneType = CommonConst.EPreviewSceneType.PreviewCommon,
      SceneLocation = nil,
      SceneId = nil,
      EnvLight = {},
      FreeLight = {}
    },
    Other = {Filter = nil, Sticker = nil},
    Camera = {
      Offset = nil,
      Rotation = nil,
      Distance = nil,
      LocalPosition = nil,
      LocalRotation = nil,
      LimitConfig = nil,
      HasCustomCamera = false
    }
  }
  for Index = 1, GetDefaultCharacterSlotCount() do
    Draft.CharacterSlots[Index] = BuildEmptyCharacterSlot(Index)
  end
  for Index = 1, GetDefaultPetSlotCount() do
    Draft.PetSlots[Index] = BuildEmptyPetSlot(Index)
  end
  DisplayConfig:ApplySceneDefaults(Draft, true, SceneId)
  return Draft
end

function M:Clone(Draft)
  if not Draft then
    return self:CreateEmpty()
  end
  if not IsDraftTable(Draft) then
    return CloneValue(Draft)
  end
  local NewDraft = {
    Version = Draft.Version,
    CharacterSlots = {},
    PetSlots = {},
    Scene = CloneValue(Draft.Scene),
    Other = CloneValue(Draft.Other),
    Camera = CloneValue(Draft.Camera)
  }
  for Index, Slot in ipairs(Draft.CharacterSlots or {}) do
    NewDraft.CharacterSlots[Index] = CloneCharacterSlot(Slot)
  end
  for Index, Slot in ipairs(Draft.PetSlots or {}) do
    NewDraft.PetSlots[Index] = ClonePetSlot(Slot)
  end
  self:EnsureCharacterSlots(NewDraft)
  self:EnsurePetSlots(NewDraft)
  return NewDraft
end

function M:EnsureCharacterSlots(Draft, Count)
  Draft.CharacterSlots = Draft.CharacterSlots or {}
  Count = Count or GetDefaultCharacterSlotCount()
  for Index = 1, Count do
    Draft.CharacterSlots[Index] = Draft.CharacterSlots[Index] or BuildEmptyCharacterSlot(Index)
  end
end

function M:EnsurePetSlots(Draft, Count)
  Draft.PetSlots = Draft.PetSlots or {}
  Count = Count or GetDefaultPetSlotCount()
  for Index = 1, Count do
    Draft.PetSlots[Index] = Draft.PetSlots[Index] or BuildEmptyPetSlot(Index)
  end
end

function M:GetCharacterSlot(Draft, SlotIndex)
  self:EnsureCharacterSlots(Draft, SlotIndex)
  return Draft.CharacterSlots[SlotIndex]
end

function M:GetPetSlot(Draft, SlotIndex)
  self:EnsurePetSlots(Draft, SlotIndex)
  return Draft.PetSlots[SlotIndex]
end

function M:IsValidCharacterData(CharData)
  if type(CharData) ~= "table" then
    return false
  end
  return CharData.Uuid ~= nil or nil ~= CharData.CharId
end

function M:IsCharacterSlotOccupied(Slot)
  return Slot and self:IsValidCharacterData(Slot.CharData)
end

function M:IsPetSlotOccupied(Slot)
  return Slot and Slot.PetData ~= nil
end

function M:IsEquivalent(DraftA, DraftB)
  return IsSameTable(DraftA, DraftB)
end

return M
