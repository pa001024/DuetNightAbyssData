local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayRules = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayRules")
local DisplayTypes = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayTypes")
local M = {}

local function ExportVectorToArray(VectorValue)
  if not VectorValue then
    return {
      0,
      0,
      0
    }
  end
  return {
    VectorValue.X or 0,
    VectorValue.Y or 0,
    VectorValue.Z or 0
  }
end

local function ExportRotatorToArray(RotatorValue)
  if not RotatorValue then
    return {
      0,
      0,
      0
    }
  end
  return {
    RotatorValue.Roll or 0,
    RotatorValue.Pitch or 0,
    RotatorValue.Yaw or 0
  }
end

local function ExportTransform(TransformValue, TransformRotation)
  if not TransformValue then
    return {
      Position = {
        0,
        0,
        0
      },
      Rotation = ExportRotatorToArray(TransformRotation)
    }
  end
  local Translation = TransformValue.Translation or nil
  local RotatorValue = TransformRotation or TransformValue.Rotator or nil
  if not RotatorValue and TransformValue.Rotation and TransformValue.Rotation.ToRotator then
    RotatorValue = TransformValue.Rotation:ToRotator()
  end
  if not RotatorValue and TransformValue.Rotation and TransformValue.Rotation.Rotator then
    RotatorValue = TransformValue.Rotation:Rotator()
  end
  return {
    Position = ExportVectorToArray(Translation),
    Rotation = ExportRotatorToArray(RotatorValue)
  }
end

local function ResolveExportPoseId(ActionData)
  local PoseId = ActionData and ActionData.PoseId or nil
  if nil == PoseId then
    return nil
  end
  local GestureConfig = DataMgr and DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
  if not GestureConfig then
    return nil
  end
  return PoseId
end

local function BuildCharacterActionFromPoseId(PoseId)
  if nil == PoseId then
    return nil
  end
  local GestureConfig = PoseId and DataMgr and DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
  if not GestureConfig then
    return nil
  end
  local ReleaseWheel = GestureConfig.ReleaseWheel
  if ReleaseWheel and 0 ~= ReleaseWheel then
    local Resource = DataMgr.Resource and DataMgr.Resource[ReleaseWheel] or nil
    return {
      PoseId = PoseId,
      Mode = DisplayTypes.AnimMode.Montage,
      GestureTag = GestureConfig.GestureTag or "Gesture",
      ReleaseWheel = ReleaseWheel,
      ResourceId = ReleaseWheel,
      MontagePath = Resource and Resource.PlayAnim or nil
    }
  end
  return {
    PoseId = PoseId,
    Mode = DisplayTypes.AnimMode.Sequence,
    GestureTag = GestureConfig.GestureTag or "Pose",
    Document = GestureConfig.Document,
    PoseName = GestureConfig.PoseName
  }
end

local function ExportCharacterParamGroup(Draft)
  local CharParamGroup = {}
  for _, Slot in ipairs(Draft and Draft.CharacterSlots or {}) do
    if DisplayDraft:IsCharacterSlotOccupied(Slot) and Slot.CharData and Slot.CharData.CharId then
      local TransformInfo = ExportTransform(Slot.Transform, Slot.TransformRotation)
      local PoseId = ResolveExportPoseId(Slot.Action)
      local WeaponId = tonumber(Slot.WeaponData and Slot.WeaponData.WeaponId or nil)
      local AppearancePlan = Slot.Appearance and Slot.Appearance.CurrentPlanIndex or nil
      local CharParam = {
        CharId = Slot.CharData.CharId,
        AppearancePlan = AppearancePlan and AppearancePlan > 0 and AppearancePlan or 1,
        Position = TransformInfo.Position,
        Rotation = TransformInfo.Rotation
      }
      if PoseId then
        CharParam.PoseId = PoseId
      end
      if WeaponId and WeaponId > 0 then
        CharParam.WeaponId = WeaponId
      end
      table.insert(CharParamGroup, CharParam)
    end
  end
  return CharParamGroup
end

local function ExportCameraParam(Draft)
  local CameraData = Draft and Draft.Camera or nil
  local LocalPosition = CameraData and CameraData.LocalPosition or nil
  local LocalRotation = CameraData and CameraData.LocalRotation or nil
  local Offset = CameraData and CameraData.Offset or nil
  local Rotation = CameraData and CameraData.Rotation or nil
  local Distance = CameraData and CameraData.Distance or nil
  return {
    Position = {
      LocalPosition and LocalPosition.X or Distance or 0,
      LocalPosition and LocalPosition.Y or Offset and Offset.Horizontal or 0,
      LocalPosition and LocalPosition.Z or Offset and Offset.Vertical or 0
    },
    Rotation = {
      LocalRotation and LocalRotation.Roll or 0,
      LocalRotation and LocalRotation.Pitch or Rotation and Rotation.Pitch or 0,
      LocalRotation and LocalRotation.Yaw or Rotation and Rotation.Yaw or 0
    }
  }
end

function M:BuildInitialDraft(Params)
  Params = Params or {}
  local Draft = DisplayDraft:CreateEmpty(Params.SceneId)
  if Params.Char then
    DisplayRules:AssignCharacterToSlot(Draft, 1, Params.Char, Params.Avatar, Params.AppearanceInfo)
  end
  DisplayConfig:ApplySceneDefaults(Draft, true, Params.SceneId)
  return Draft
end

function M:BuildDraftFromSceneSpec(SceneSpec)
  local SceneData = SceneSpec and SceneSpec.Scene or nil
  local Draft = DisplayDraft:CreateEmpty(SceneData and SceneData.SceneId or nil)
  if not SceneSpec then
    return Draft
  end
  local CharacterSlotIndex = 1
  local PetSlotIndex = 1
  for _, Entity in ipairs(SceneSpec.Entities or {}) do
    if Entity.Type == DisplayTypes.EntityType.Char then
      local Slot = DisplayDraft:GetCharacterSlot(Draft, CharacterSlotIndex)
      Slot.CharData = Entity.Source and Entity.Source.CharData or nil
      Slot.Avatar = Entity.Source and Entity.Source.Avatar or nil
      Slot.Appearance = Entity.Appearance
      Slot.WeaponData = Entity.Source and Entity.Source.WeaponData or nil
      Slot.Action = Entity.Anim
      if Slot.Action and Slot.Action.PoseId and Slot.Action.ReleaseWheel == nil and nil == Slot.Action.Document then
        Slot.Action = BuildCharacterActionFromPoseId(Slot.Action.PoseId)
      end
      Slot.Transform = Entity.Transform
      CharacterSlotIndex = CharacterSlotIndex + 1
    elseif Entity.Type == DisplayTypes.EntityType.Pet then
      local Slot = DisplayDraft:GetPetSlot(Draft, PetSlotIndex)
      Slot.PetData = Entity.Source and Entity.Source.PetData or nil
      Slot.OwnerEntityId = Entity.OwnerEntityId
      Slot.Transform = Entity.Transform
      PetSlotIndex = PetSlotIndex + 1
    end
  end
  DisplayRules:NormalizeCharacterSlots(Draft)
  DisplayRules:NormalizePetSlots(Draft)
  Draft.Scene = SceneSpec.Scene or Draft.Scene
  Draft.Other = SceneSpec.Other or Draft.Other
  Draft.Camera = SceneSpec.Camera or Draft.Camera
  DisplayConfig:ApplySceneDefaults(Draft, nil == Draft.Camera or nil == Draft.Camera.LimitConfig)
  return Draft
end

function M:ExportSaveData(Draft)
  Draft = Draft or DisplayDraft:CreateEmpty()
  return {
    SceneId = Draft.Scene and Draft.Scene.SceneId or nil,
    CharParamGroup = ExportCharacterParamGroup(Draft),
    CameraParam = ExportCameraParam(Draft)
  }
end

return M
