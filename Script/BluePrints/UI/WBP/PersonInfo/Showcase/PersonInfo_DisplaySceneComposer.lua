local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayTypes = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayTypes")
local M = {}

function M:BuildSceneSpec(View, Draft)
  Draft = Draft or DisplayDraft:CreateEmpty()
  DisplayDraft:EnsureCharacterSlots(Draft)
  DisplayDraft:EnsurePetSlots(Draft)
  local Scene = Draft.Scene or {}
  local SceneId = Scene.SceneId
  local Entities = {}
  local FirstCharacterEntityId
  local CharacterEntityIdMap = {}
  for _, Slot in ipairs(Draft.CharacterSlots) do
    if DisplayDraft:IsCharacterSlotOccupied(Slot) then
      local EntityId = self:_BuildCharacterEntityId(Slot.SlotIndex)
      FirstCharacterEntityId = FirstCharacterEntityId or EntityId
      CharacterEntityIdMap[EntityId] = true
      table.insert(Entities, {
        Id = EntityId,
        Type = DisplayTypes.EntityType.Char,
        Source = {
          CharData = Slot.CharData,
          Avatar = Slot.Avatar,
          WeaponData = Slot.WeaponData
        },
        Transform = Slot.Transform or DisplayConfig:GetDefaultCharacterTransform(Slot.SlotIndex, SceneId),
        Appearance = Slot.Appearance,
        Anim = Slot.Action,
        Visible = true
      })
    end
  end
  for _, Slot in ipairs(Draft.PetSlots) do
    if DisplayDraft:IsPetSlotOccupied(Slot) then
      local OwnerEntityId = Slot.OwnerEntityId
      if not OwnerEntityId or not CharacterEntityIdMap[OwnerEntityId] then
        OwnerEntityId = FirstCharacterEntityId
      end
      table.insert(Entities, {
        Id = self:_BuildPetEntityId(Slot.SlotIndex),
        Type = DisplayTypes.EntityType.Pet,
        Source = {
          PetData = Slot.PetData
        },
        OwnerEntityId = OwnerEntityId,
        Transform = Slot.Transform or DisplayConfig:GetDefaultPetTransform(Slot.SlotIndex),
        Visible = true
      })
    end
  end
  return {
    SceneType = Scene.SceneType or CommonConst.EPreviewSceneType.PreviewCommon,
    SceneLocation = Scene.SceneLocation,
    FocusEntityId = Draft.FocusEntityId,
    Entities = Entities,
    Scene = Scene,
    Other = Draft.Other,
    Camera = Draft.Camera
  }
end

function M:_BuildCharacterEntityId(SlotIndex)
  return "char_slot_" .. tostring(SlotIndex)
end

function M:_BuildPetEntityId(SlotIndex)
  return "pet_slot_" .. tostring(SlotIndex)
end

return M
