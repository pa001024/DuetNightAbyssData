require("UnLua")
local EMCache = require("EMCache.EMCache")
local EDetectTargetMethods = {
  ProjectToScreen = 1,
  LineTrace = 2,
  ProjectToScreenAndLineTrace = 3
}
local M = Class("BluePrints.Common.TimerMgr")

function M:Init(GuildManager)
  self.GuildManager = GuildManager
end

function M:Rotate(Roll, Pitch, Yaw)
  local bTopView = self.GuildManager.Settings.CameraMoveMode == UE4.EGuildCameraMoveMode.TopDownView
  local CurRotation = self:K2_GetActorRotation()
  Yaw = Yaw * self.YawSpeed
  Pitch = Pitch * self.PitchSpeed
  CurRotation.Yaw = CurRotation.Yaw + Yaw
  CurRotation.Yaw = math.clamp(CurRotation.Yaw, self.YawMin, self.YawMax)
  if bTopView then
    CurRotation.Pitch = -89.9
  else
    CurRotation.Pitch = CurRotation.Pitch + Pitch
    CurRotation.Pitch = math.clamp(CurRotation.Pitch, -self.PitchMax, -self.PitchMin)
  end
  self:K2_SetActorRotation(CurRotation, false)
end

local function GetHorizontalDirection(Vector, DefaultVector)
  Vector.Z = 0
  if math.abs(Vector.X) < 1.0E-4 and math.abs(Vector.Y) < 1.0E-4 then
    return DefaultVector
  end
  Vector:Normalize()
  return Vector
end

function M:Move(X, Y, Z)
  local CurrentLocation = self:K2_GetActorLocation()
  local Forward = GetHorizontalDirection(self:GetActorForwardVector(), FVector(1, 0, 0))
  local Right = GetHorizontalDirection(self:GetActorRightVector(), FVector(0, 1, 0))
  local Delta = (Forward * X + Right * Y + FVector(0, 0, 0)) * self.MoveStep
  self:K2_SetActorLocation(CurrentLocation + Delta, false, nil, false)
end

function M:Zoom(Distance)
  local TargetArmLength = self.SpringArm.TargetArmLength
  TargetArmLength = TargetArmLength + Distance * self.ZoomSpeed
  TargetArmLength = math.clamp(TargetArmLength, self.ZoomMin, self.ZoomMax)
  self.SpringArm.TargetArmLength = TargetArmLength
end

function M:OnChangedCameraMode()
  self:Rotate(0, 0, 0)
end

return M
