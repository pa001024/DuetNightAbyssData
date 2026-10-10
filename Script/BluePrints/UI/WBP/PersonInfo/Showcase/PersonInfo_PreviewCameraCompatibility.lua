require("UnLua")
local M = {}

local function ResolveMainActor(Controller, Fallback)
  local Actor = Fallback
  if not Actor and Controller then
    local Getter = Controller.GetMainCharacterActor
    if type(Getter) == "function" then
      Actor = Controller:GetMainCharacterActor()
    end
    if not Actor and Controller.EntityHandles then
      local OrderedGetter = Controller._GetOrderedCharacterEntityIds
      local Ids = type(OrderedGetter) == "function" and Controller:_GetOrderedCharacterEntityIds() or nil
      if not Ids then
        Ids = {}
        for Id in pairs(Controller.EntityHandles) do
          Ids[#Ids + 1] = Id
        end
      end
      for _, EntityId in ipairs(Ids) do
        local Handle = Controller.EntityHandles[EntityId]
        if Handle and "function" == type(Handle.GetActor) then
          local Candidate = Handle:GetActor()
          if Candidate and IsValid(Candidate) then
            Actor = Candidate
            break
          end
        end
      end
    end
  end
  return Actor and IsValid(Actor) and Actor or nil
end

function M:ApplyTaggedCamera(Params)
  local Controller = Params and Params.Controller or nil
  local CameraRuntime = Params and Params.CameraRuntime or nil
  local Data = Params and Params.Data or nil
  local OffsetVector = Params and Params.OffsetVector or FVector(0, 0, 0)
  local OffsetRotator = Params and Params.OffsetRotator or FRotator(0, 0, 0)
  if not (Controller and CameraRuntime) or not Data then
    return false
  end
  local RawLocation = FVector(Data.Location[1], Data.Location[2], Data.Location[3])
  local RawRotation = FRotator(Data.Rotation[2], Data.Rotation[3], Data.Rotation[1])
  local ArmoryLoc = RawLocation + OffsetVector
  local ArmoryRot = RawRotation + OffsetRotator
  local Location = ArmoryLoc
  local Rotation = ArmoryRot
  local CharRelative
  
  local function FmtV(V)
    return string.format("(%.2f,%.2f,%.2f)", V.X, V.Y, V.Z)
  end
  
  local function FmtR(R)
    return string.format("(P%.2f,Y%.2f,R%.2f)", R.Pitch, R.Yaw, R.Roll)
  end
  
  if Params.bRelativeCharacter == true then
    local Actor = ResolveMainActor(Controller, Params.MainCharacterActor)
    if Actor then
      local RootActor
      if CameraRuntime and type(CameraRuntime.GetPreviewRootActor) == "function" then
        RootActor = CameraRuntime:GetPreviewRootActor()
      end
      local MeshComponent = Actor.Mesh
      local CharTransform
      if MeshComponent and IsValid(MeshComponent) then
        CharTransform = MeshComponent:GetSocketTransform("Root", ERelativeTransformSpace.RTS_World)
      else
        CharTransform = Actor:GetTransform()
      end
      local ActorWorld = CharTransform
      local RootWorld = RootActor and RootActor:GetTransform() or nil
      if RootWorld then
        CharRelative = UE4.UKismetMathLibrary.ComposeTransforms(ActorWorld, UE4.UKismetMathLibrary.InvertTransform(RootWorld))
      else
        CharRelative = nil
      end
      if CharRelative then
        Location = UE4.UKismetMathLibrary.TransformLocation(CharRelative, ArmoryLoc)
        Rotation = UE4.UKismetMathLibrary.TransformRotation(CharRelative, ArmoryRot)
      end
      
      local function FmtQ(Q)
        local R = UE4.UKismetMathLibrary.Quat_Rotator(Q)
        return FmtR(R)
      end
      
      DebugPrint(string.format("[CamConv] MeshSrc=%s | CharT Loc=%s Rot=%s | ArmoryLoc=%s ArmoryRot=%s | RootFound=%s | CharRel Loc=%s Rot=%s | -> OutLoc=%s OutRot=%s", MeshComponent and IsValid(MeshComponent) and "Mesh" or "Actor", FmtV(CharTransform.Translation), FmtR(UE4.UKismetMathLibrary.Quat_Rotator(CharTransform.Rotation)), FmtV(ArmoryLoc), FmtR(ArmoryRot), tostring(nil ~= RootActor), CharRelative and FmtV(CharRelative.Translation) or "nil", CharRelative and FmtQ(CharRelative.Rotation) or "nil", FmtV(Location), FmtR(Rotation)))
    end
  end
  local FOV = CommonUtils:FocalLengthToFOV(Data.CameraFocal or 22)
  CameraRuntime:SetCameraStartInfo(nil, nil, FOV)
  if Params.bRelativeCharacter == true then
    CameraRuntime:SetRelativeTransform(Location, Rotation)
    Controller.CurrentCameraRigLocalPosition = Location
    Controller.CurrentCameraRigLocalRotation = Rotation
  else
    Controller:SetCameraRigLocalTransform(Location, Rotation, true)
  end
  CameraRuntime:StartFOVAnim(FOV, Params.Time or 0, Data.Ease)
  local ForwardLocation = Data.ForwardLocation
  local BackwardLocation = Data.BackwardLocation
  if ForwardLocation or BackwardLocation then
    if ForwardLocation then
      ForwardLocation = FVector(ForwardLocation[1], ForwardLocation[2], ForwardLocation[3]) + OffsetVector
      if CharRelative then
        ForwardLocation = UE4.UKismetMathLibrary.TransformLocation(CharRelative, ForwardLocation)
      end
    end
    if BackwardLocation then
      BackwardLocation = FVector(BackwardLocation[1], BackwardLocation[2], BackwardLocation[3]) + OffsetVector
      if CharRelative then
        BackwardLocation = UE4.UKismetMathLibrary.TransformLocation(CharRelative, BackwardLocation)
      end
    end
    CameraRuntime:SetCameraScrollRange(ForwardLocation or Location, BackwardLocation or Location, 0.5, Data.Ease)
    Controller:EnableCameraScrolling(true)
  else
    Controller:EnableCameraScrolling(false)
  end
  if Controller.SceneService and Controller.SceneService:IsSceneLoaded() and Controller.SceneService.PreviewSceneType == CommonConst.EPreviewSceneType.PreviewCommon then
    Controller.SceneService:StartPreviewBGAnimation(Data.PreviewBGPos, Params.Time or 0)
  end
  return true
end

return M
