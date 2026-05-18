local M = Class()
local DefaultBlendTime = 0.5
local DefaultBlendFunc = UE4.EViewTargetBlendFunction.VTBlend_Linear

function M:SplineInit(Player, WalkType, MoveSpeedRate, bCanMoveReverse, bCanExit, IsTriggerable, StopAtEndPoint, UseEndOverlapBox, GuideCameraToStart)
  self.Player = Player
  self.WalkType = WalkType or 0
  self.MoveSpeedRate = MoveSpeedRate or 1.0
  self.bCanExit = bCanExit or false
  self.IsTriggerable = IsTriggerable or false
  self.bGuideCameraToStart = false ~= GuideCameraToStart
  self.bUseEndOverlapBox = true
  if nil ~= UseEndOverlapBox then
    self.bUseEndOverlapBox = UseEndOverlapBox
  end
  if not IsValid(Player) then
    GWorld.logger.error("CinemaMoveSpline:Init, Player is Invalid!")
    return false
  end
  self.PlayerMoveComp = self.Player.CharacterMovement and self.Player.CharacterMovement:Cast(UPlayerCharMoveComp)
  if not IsValid(self.PlayerMoveComp) then
    GWorld.logger.error("CinemaMoveSpline:Init, MoveComp of Player is Invalid!")
    return false
  end
  self.Controller = self.Player.Controller and self.Player.Controller:Cast(ASinglePlayerController)
  if not IsValid(self.Controller) then
    GWorld.logger.error("CinemaMoveSpline:Init, PlayerController is Invalid!")
    return false
  end
  self.bCanMoveReverse = bCanMoveReverse or false
  self.bStopAtEndPoint = StopAtEndPoint
  self.bEnableCameraSeq = IsValid(self.CameraSequence)
  self.bStartBoxOverlap = false
  self.BlendCameraInitialized = false
  self.bSplineMoveFinished = false
  return true
end

function M:SplineStart()
  if not IsValid(self.Player) then
    return
  end
  if self.IsTriggerable then
    self.StartPointOverlapBox.OnComponentBeginOverlap:Clear()
    self.StartPointOverlapBox.OnComponentEndOverlap:Clear()
    if self.StartPointOverlapBox:IsOverlappingComponent(self.Player.CapsuleComponent) then
      self:OnStartBoxOverlap(true)
    end
    self.StartPointOverlapBox.OnComponentBeginOverlap:Add(self, function(Obj, Comp, OtherActor, OtherComp)
      if not IsValid(self.Player) then
        return
      end
      if OtherComp == self.Player.CapsuleComponent then
        self:OnStartBoxOverlap(true)
      end
    end)
    self.StartPointOverlapBox.OnComponentEndOverlap:Add(self, function(Obj, Comp, OtherActor, OtherComp)
      if not IsValid(self.Player) then
        return
      end
      if OtherComp == self.Player.CapsuleComponent then
        self:OnStartBoxOverlap(false)
      end
    end)
  else
    self:ExecEnterLogic()
    if self.bEnableCameraSeq == true or self.bUseEndOverlapBox == false then
      self:SetActorTickEnabled(true)
    end
  end
end

function M:SplineEnd(EndBlendTime)
  self:SetActorTickEnabled(false)
  if self.bEnableCameraSeq then
    self:SequenceBlendOut(EndBlendTime)
  end
  self:ExecQuitLogic()
  self:Clear()
end

function M:OnStartBoxOverlap(bBegin)
  if not IsValid(self.PlayerMoveComp) then
    return
  end
  if self.PlayerMoveComp.ReachedSplineTarget then
    return
  end
  if self.bStartBoxOverlap == bBegin then
    return
  end
  self.bStartBoxOverlap = bBegin
  if bBegin then
    self:ExecEnterLogic()
  else
    self:ExecQuitLogic()
  end
  self:SetActorTickEnabled(bBegin)
end

function M:OnEndBoxOverlap(Comp, OtherActor, OtherComp)
  if not IsValid(self.Player) then
    return
  end
  if OtherComp ~= self.Player.CapsuleComponent then
    return
  end
  self:OnSplineMoveFinished()
end

function M:OnSplineMoveFinished()
  if self.bSplineMoveFinished then
    return
  end
  self.bSplineMoveFinished = true
  if self.bStopAtEndPoint then
    self.Player.bCinemaMoveCanReverse = false
  end
  if self.SplineMoveFinishEvent then
    self.SplineMoveFinishEvent()
  end
end

function M:BindOnSplineMoveFinished(Event)
  if type(Event) ~= "function" then
    return
  end
  self.SplineMoveFinishEvent = Event
  if self.bUseEndOverlapBox then
    self.EndPointOverlapBox.OnComponentBeginOverlap:Clear()
    if IsValid(self.Player) and self.EndPointOverlapBox:IsOverlappingComponent(self.Player.CapsuleComponent) then
      self:OnSplineMoveFinished()
    else
      self.EndPointOverlapBox.OnComponentBeginOverlap:Add(self, self.OnEndBoxOverlap)
    end
  elseif not self.bUseEndOverlapBox and IsValid(self.PlayerMoveComp) and IsValid(self.SplineComponent) then
    local TotalLength = self.SplineComponent:GetSplineLength()
    if TotalLength > 1.0E-4 and self.PlayerMoveComp.MoveSplineAccumlate / TotalLength >= 1 then
      self:OnSplineMoveFinished()
    end
  end
end

function M:ClearOnSplineMoveFinished()
  self.SplineMoveFinishEvent = nil
end

function M:ExecEnterLogic()
  if not IsValid(self.Player) then
    return
  end
  if self.Player.PlayerAnimInstance then
    self.OriginalWalkType = self.Player.PlayerAnimInstance.WalkType
    self.OriginalWalkSpeedRate = self.Player.SpeedRate <= 0 and 1 or self.Player.SpeedRate
    self.Player:SetWalkType(self.WalkType)
    self.Player:SetPlayerMaxMovingSpeed(self.MoveSpeedRate)
  end
  local TargetPoint
  if IsValid(self.SplineComponent) then
    TargetPoint = self.SplineComponent:GetLocationAtSplinePoint(0, ESplineCoordinateSpace.World)
  end
  self.Player:StartMoveAlongSpline(self.SplineComponent, TargetPoint, self.bCanMoveReverse, self.IsTriggerable)
  self.Player:MoveAlongSplineBanSkills()
  self.Player:ForbidActionWhileMoveAlongSpline(true)
  if self.bEnableCameraSeq then
    self:LockPlayerCamera(true)
  end
  if self.IsTriggerable and self.bGuideCameraToStart then
    self:StartCameraGuidance()
  end
  if self.IsTriggerable and self.bEnableCameraBlend then
    self:InitBlendCamera()
  end
end

function M:ExecQuitLogic()
  if not IsValid(self.Player) then
    return
  end
  self.Player:EndMoveAlongSpline()
  self.Player:MoveAlongSplineUnBanSkills()
  self.Player:ForbidActionWhileMoveAlongSpline(false)
  if self.OriginalWalkType then
    self.Player:SetWalkType(self.OriginalWalkType)
    self.Player:SetPlayerMaxMovingSpeed(self.OriginalWalkSpeedRate)
  end
  if self.bEnableCameraSeq then
    self:LockPlayerCamera(false)
  end
  if self.IsTriggerable and self.bGuideCameraToStart then
    self:StopCameraGuidance()
  end
  if self.IsTriggerable and self.bEnableCameraBlend then
    self:StopBlendCamera()
  end
end

function M:LockPlayerCamera(bLock)
  if not IsValid(self.Controller) then
    return
  end
  self.CameraLocked = bLock
  if bLock then
    self.Controller:AddDisableRotationInputTag("CinemaMoveSpline")
  else
    self.Controller:RemoveDisableRotationInputTag("CinemaMoveSpline")
  end
end

function M:StartCameraGuidance()
  local CurrentPitch = 0
  if IsValid(self.Controller) then
    local CurrentRotation = self.Controller:GetControlRotation()
    CurrentPitch = CurrentRotation.Pitch
  end
  local DestRotation = FRotator(CurrentPitch, 0, 0)
  self.Player.CameraRotationComponent:SetControlRotationAbsolute_Lerp(DestRotation, 1, 5, false, function()
  end)
end

function M:StopCameraGuidance()
  self.Player.CameraRotationComponent:StopControlRotationLerp()
end

function M:InitBlendCamera()
  if not self.CameraLocked then
    return
  end
  if not IsValid(self.BlendCamera) then
    return
  end
  local BlendCamera = self.BlendCamera
  local CameraComp = self.Player:GetCameraComponent()
  local CineCamComponent = BlendCamera:GetCineCameraComponent()
  CineCamComponent:SetFieldOfView(CameraComp.FieldOfView)
  CineCamComponent.bConstrainAspectRatio = CameraComp.bConstrainAspectRatio
  BlendCamera:K2_SetActorLocationAndRotation(CameraComp:K2_GetComponentLocation(), CameraComp:K2_GetComponentRotation(), false, nil, false)
  self:UpdateBlendCameraLoc(self.Player:K2_GetActorLocation())
  USequenceFunctionLibrary.SetViewTargetWithBlend(self.Controller, BlendCamera, DefaultBlendTime, DefaultBlendFunc)
  self.BlendCameraInitialized = true
end

function M:StopBlendCamera()
  if self.BlendCameraInitialized then
    USequenceFunctionLibrary.SetViewTargetWithBlend(self.Controller, self.Player, DefaultBlendTime, DefaultBlendFunc)
  end
  self.BlendCameraInitialized = false
end

function M:SequenceBlendOut(EndBlendTime)
  if IsValid(self.Controller) then
    local ViewTarget = self.Controller:GetViewTarget()
    local ViewLocation, ViewRotation = ViewTarget:GetActorEyesViewPoint()
    local BlendCamera = self.BlendCamera
    if IsValid(BlendCamera) then
      BlendCamera:K2_SetActorLocationAndRotation(ViewLocation, ViewRotation, false, nil, false)
    end
  end
  if IsValid(self.SequenceActor) then
    local SequencePlayer = self.SequenceActor:GetSequencePlayer()
    if IsValid(SequencePlayer) then
      SequencePlayer:StopAtCurrentTime()
    end
  end
  USequenceFunctionLibrary.SetViewTargetWithBlend(self.Controller, self.Player, EndBlendTime, DefaultBlendFunc)
end

function M:Clear()
  self.StartPointOverlapBox.OnComponentBeginOverlap:Clear()
  self.StartPointOverlapBox.OnComponentEndOverlap:Clear()
  self.EndPointOverlapBox.OnComponentBeginOverlap:Clear()
  self.BlendCameraInitialized = false
  self.bSplineMoveFinished = false
  self.bStartBoxOverlap = false
  self.CameraLocked = false
  self.PlayerMoveComp = nil
  self.Player = nil
end

function M:ReceiveEndPlay()
end

function M:OnReachSplineEndByProgress()
  self:OnSplineMoveFinished()
end

return M
