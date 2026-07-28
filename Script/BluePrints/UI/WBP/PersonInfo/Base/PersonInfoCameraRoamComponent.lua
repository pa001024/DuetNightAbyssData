require("UnLua")
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local M = {}
local CameraRoamKeyMap = {
  W = {Horizontal = 0, Vertical = 1},
  A = {Horizontal = -1, Vertical = 0},
  S = {Horizontal = 0, Vertical = -1},
  D = {Horizontal = 1, Vertical = 0}
}

local function BuildCameraRelativeMoveVector(ActorController, HorizontalDelta, VerticalDelta)
  if not ActorController then
    return nil
  end
  if ActorController.MoveCameraByAxis then
    return "use_controller_axis"
  end
  if not ActorController.GetCameraRigLocalTransform then
    return nil
  end
  local _, LocalRotation = ActorController:GetCameraRigLocalTransform()
  LocalRotation = LocalRotation or FRotator(0, 0, 0)
  local RightVector = UE4.UKismetMathLibrary.GetRightVector(LocalRotation)
  local UpVector = UE4.UKismetMathLibrary.GetUpVector(LocalRotation)
  return RightVector * (HorizontalDelta or 0) + UpVector * (VerticalDelta or 0)
end

local function GetCustomEditRootController(Owner)
  if not Owner or not Owner.GetCustomEditRootController then
    return nil
  end
  return Owner:GetCustomEditRootController()
end

local function GetCameraInputConfig()
  return PersonInfoCommon.CameraInputConfig or {}
end

function M:InitCameraRoam()
  local CameraInputConfig = GetCameraInputConfig()
  self.bEnableCameraRoam = true
  self.CameraRoamConfig = {
    KeyMoveSpeed = CameraInputConfig.CameraRoamKeyMoveSpeed or 240,
    DragMoveSpeed = CameraInputConfig.CameraRoamDragMoveSpeed or 1,
    LimitConfig = nil
  }
  self.CameraRoamKeyState = {}
end

function M:CanUseCameraRoam()
  local RootController = GetCustomEditRootController(self)
  local bEnablePreviewCameraRoam = true
  if RootController and RootController.IsPreviewCameraRoamEnabled then
    bEnablePreviewCameraRoam = RootController:IsPreviewCameraRoamEnabled()
  end
  return self.bEnableCameraRoam ~= false and self.ActorController ~= nil and true == bEnablePreviewCameraRoam
end

function M:ResetCameraRoamInput()
  self.CameraRoamKeyState = {}
  if self.ActorController and self.ActorController.CommitCameraPreviewTransaction then
    self.ActorController:CommitCameraPreviewTransaction()
  end
end

function M:GetCameraRoamLimitConfig()
  local Editor = self.ActorController and self.ActorController.GetEditor and self.ActorController:GetEditor() or nil
  local Draft = Editor and Editor.GetDraft and Editor:GetDraft() or nil
  local CameraData = Draft and Draft.Camera or nil
  if CameraData and CameraData.LimitConfig ~= nil then
    return CameraData.LimitConfig
  end
  if not self.CameraRoamConfig then
    return nil
  end
  return self.CameraRoamConfig.LimitConfig
end

function M:OnCameraRoamKeyDown(KeyName)
  if not CameraRoamKeyMap[KeyName] then
    return false
  end
  if not self:CanUseCameraRoam() then
    self.CameraRoamKeyState[KeyName] = false
    return false
  end
  if self.ActorController and self.ActorController.BeginCameraPreviewTransaction then
    self.ActorController:BeginCameraPreviewTransaction()
  end
  self.CameraRoamKeyState[KeyName] = true
  return true
end

function M:OnCameraRoamKeyUp(KeyName)
  if not CameraRoamKeyMap[KeyName] then
    return false
  end
  self.CameraRoamKeyState[KeyName] = false
  if not self:HasAnyCameraRoamKeyDown() and self.ActorController and self.ActorController.CommitCameraPreviewTransaction then
    self.ActorController:CommitCameraPreviewTransaction()
  end
  return true
end

function M:HasAnyCameraRoamKeyDown()
  for KeyName, _ in pairs(CameraRoamKeyMap) do
    if self.CameraRoamKeyState and self.CameraRoamKeyState[KeyName] then
      return true
    end
  end
  return false
end

function M:TickCameraRoam(DeltaTime)
  if not self:CanUseCameraRoam() then
    return false
  end
  local HorizontalAxis = 0
  local VerticalAxis = 0
  for KeyName, MoveConfig in pairs(CameraRoamKeyMap) do
    if self.CameraRoamKeyState and self.CameraRoamKeyState[KeyName] then
      HorizontalAxis = HorizontalAxis + MoveConfig.Horizontal
      VerticalAxis = VerticalAxis + MoveConfig.Vertical
    end
  end
  if 0 == HorizontalAxis and 0 == VerticalAxis then
    return false
  end
  local Step = (self.CameraRoamConfig and self.CameraRoamConfig.KeyMoveSpeed or 0) * (DeltaTime or 0)
  if 0 == Step then
    return false
  end
  return self:MoveCameraRoamByDelta(HorizontalAxis * Step, VerticalAxis * Step)
end

function M:MoveCameraRoamByDelta(HorizontalDelta, VerticalDelta)
  if not self:CanUseCameraRoam() then
    return false
  end
  local ActorController = self.ActorController
  if ActorController and ActorController.MoveCameraByAxis then
    return ActorController:MoveCameraByAxis(0, HorizontalDelta, VerticalDelta)
  end
  local Editor = ActorController and ActorController:GetEditor() or nil
  if not Editor or not Editor.MoveCameraLocalPosition then
    return false
  end
  local MoveVector = BuildCameraRelativeMoveVector(ActorController, HorizontalDelta, VerticalDelta)
  if not MoveVector then
    return false
  end
  return Editor:MoveCameraLocalPosition(MoveVector.X or 0, MoveVector.Y or 0, MoveVector.Z or 0, self:GetCameraRoamLimitConfig())
end

function M:MoveCameraRoamByCursorDelta(CursorDelta)
  if not self:CanUseCameraRoam() or not CursorDelta then
    return false
  end
  local HorizontalDelta = (CursorDelta.X or 0) * (self.CameraRoamConfig and self.CameraRoamConfig.DragMoveSpeed or 0)
  local VerticalDelta = -(CursorDelta.Y or 0) * (self.CameraRoamConfig and self.CameraRoamConfig.DragMoveSpeed or 0)
  if 0 == HorizontalDelta and 0 == VerticalDelta then
    return false
  end
  return self:MoveCameraRoamByDelta(HorizontalDelta, VerticalDelta)
end

return M
