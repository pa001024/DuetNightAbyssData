require("UnLua")
local M = {}

function M:ApplyTaggedCamera(Params)
  local Controller = Params and Params.Controller or nil
  local CameraRuntime = Params and Params.CameraRuntime or nil
  local Data = Params and Params.Data or nil
  local OffsetVector = Params and Params.OffsetVector or FVector(0, 0, 0)
  local OffsetRotator = Params and Params.OffsetRotator or FRotator(0, 0, 0)
  if not (Controller and CameraRuntime) or not Data then
    return false
  end
  local Location = FVector(Data.Location[1], Data.Location[2], Data.Location[3]) + OffsetVector
  local Rotation = FRotator(Data.Rotation[2], Data.Rotation[3], Data.Rotation[1]) + OffsetRotator
  local FOV = CommonUtils:FocalLengthToFOV(Data.CameraFocal or 22)
  CameraRuntime:SetCameraStartInfo(nil, nil, FOV)
  Controller:SetCameraRigLocalTransform(Location, Rotation, true)
  CameraRuntime:StartFOVAnim(FOV, Params.Time or 0, Data.Ease)
  local ForwardLocation = Data.ForwardLocation
  local BackwardLocation = Data.BackwardLocation
  if ForwardLocation or BackwardLocation then
    ForwardLocation = ForwardLocation and FVector(ForwardLocation[1], ForwardLocation[2], ForwardLocation[3]) + OffsetVector
    BackwardLocation = BackwardLocation and FVector(BackwardLocation[1], BackwardLocation[2], BackwardLocation[3]) + OffsetVector
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
