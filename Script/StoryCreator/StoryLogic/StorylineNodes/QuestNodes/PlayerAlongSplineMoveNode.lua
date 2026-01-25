local PlayerAlongSplineMoveNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")
local DefaultBlendTime = 0.5
local DefaultBlendFunc = UE4.EViewTargetBlendFunction.VTBlend_Linear

function PlayerAlongSplineMoveNode:Init()
  self.SplineActorIndex = 0
  self.WalkType = 0
  self.MoveSpeedRate = 1.0
  self.ExitBlendTime = 0.5
  self.bEnableCameraSeq = false
  self.bEnableCameraBlend = false
  self.IsTriggerable = false
  self.CanMoveReverse = false
  self.CanExitSpline = false
  self.bStartOverlap = false
end

function PlayerAlongSplineMoveNode:Execute(Callback)
  self.Callback = Callback
  self.Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  DebugPrint("PlayerAlongSplineMoveNode ", GWorld.GameInstance)
  if not IsValid(self.Player) then
    Callback()
    return
  end
  self.MoveComp = self.Player.CharacterMovement and self.Player.CharacterMovement:Cast(UPlayerCharMoveComp)
  if not IsValid(self.MoveComp) then
    return
  end
  self.CinemaMoveSpline = URuntimeCommonFunctionLibrary.FindCinemaMoveSplineByIndex(self.SplineActorIndex, self.Player)
  if not self.CinemaMoveSpline then
    Callback()
    return
  end
  self.bEnableCameraSeq = IsValid(self.CinemaMoveSpline.CameraSequence)
  self.bEnableCameraBlend = self.CinemaMoveSpline.bEnableCameraBlend
  self.CinemaMoveSpline.IsTriggerable = self.IsTriggerable
  self.CinemaMoveSpline.bCanExit = self.CanExitSpline
  self.CinemaMoveSpline.Player = self.Player
  self.CinemaMoveSpline.EndPointOverlapBox.OnComponentBeginOverlap:Add(self.Player, function(Obj, Comp, OtherActor)
    if OtherActor == self.Player then
      Callback()
    end
  end)
  if self.IsTriggerable then
    if self.CinemaMoveSpline.StartPointOverlapBox:IsOverlappingActor(self.Player) then
      self:OnStartBoxOverlap(true)
    end
    self.CinemaMoveSpline.StartPointOverlapBox.OnComponentBeginOverlap:Add(self.Player, function(Obj, Comp, OtherActor)
      if OtherActor == self.Player then
        self:OnStartBoxOverlap(true)
      end
    end)
    self.CinemaMoveSpline.StartPointOverlapBox.OnComponentEndOverlap:Add(self.Player, function(Obj, Comp, OtherActor)
      if OtherActor == self.Player then
        self:OnStartBoxOverlap(false)
      end
    end)
  else
    self:ExecEnterLogic()
    if self.bEnableCameraSeq then
      self.CinemaMoveSpline:SetActorTickEnabled(true)
    end
  end
end

function PlayerAlongSplineMoveNode:OnStartBoxOverlap(bBegin)
  if not IsValid(self.MoveComp) then
    return
  end
  if self.MoveComp.ReachedSplineTarget then
    return
  end
  if self.bStartOverlap == bBegin then
    return
  end
  self.bStartOverlap = bBegin
  if bBegin then
    self:ExecEnterLogic()
  else
    self:ExecQuitLogic()
  end
  self.CinemaMoveSpline:SetActorTickEnabled(bBegin)
end

function PlayerAlongSplineMoveNode:ExecEnterLogic()
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
  if IsValid(self.CinemaMoveSpline) and IsValid(self.CinemaMoveSpline.SplineComponent) then
    TargetPoint = self.CinemaMoveSpline.SplineComponent:GetLocationAtSplinePoint(0, ESplineCoordinateSpace.World)
  end
  self.Player:StartMoveAlongSpline(self.CinemaMoveSpline and self.CinemaMoveSpline.SplineComponent, TargetPoint, self.CanMoveReverse, self.IsTriggerable)
  self.Player:MoveAlongSplineBanSkills()
  self.Player:ForbidActionWhileMoveAlongSpline(true)
  if self.bEnableCameraSeq then
    self:ResetAndLockPlayerCamera()
  end
end

function PlayerAlongSplineMoveNode:ExecQuitLogic()
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
    self:UnLockPlayerCamera()
  end
end

function PlayerAlongSplineMoveNode:ResetAndLockPlayerCamera()
  if not IsValid(self.Player) then
    return
  end
  self.CameraLocked = true
  if self.IsTriggerable then
    self:StartCameraGuidance()
  end
  self.Player.Controller:AddDisableRotationInputTag("PlayerAlongSplineMoveNode")
end

function PlayerAlongSplineMoveNode:UnLockPlayerCamera()
  if not IsValid(self.Player) then
    return
  end
  self.CameraLocked = false
  if self.IsTriggerable then
    self:StopCameraGuidance()
  end
  self.Player.Controller:RemoveDisableRotationInputTag("PlayerAlongSplineMoveNode")
end

function PlayerAlongSplineMoveNode:StartCameraGuidance()
  local CurrentRotation = self.Player.Controller:GetControlRotation()
  local CurrentPitch = CurrentRotation.Pitch
  self.Player.CameraRotationComponent:SetControlRotationAbsolute_Lerp(FRotator(CurrentPitch, 0, 0), 1, 5, false, function()
  end)
  if self.bEnableCameraBlend then
    self:InitBlendCamera()
  end
end

function PlayerAlongSplineMoveNode:StopCameraGuidance()
  self.Player.CameraRotationComponent:StopControlRotationLerp()
  if IsValid(self.CinemaMoveSpline) then
    if self.CinemaMoveSpline.BlendCameraInitialized then
      USequenceFunctionLibrary.SetViewTargetWithBlend(self.Player.Controller, self.Player, DefaultBlendTime, DefaultBlendFunc)
    end
    self.CinemaMoveSpline.BlendCameraInitialized = false
  else
    USequenceFunctionLibrary.SetViewTargetWithBlend(self.Player.Controller, self.Player, DefaultBlendTime, DefaultBlendFunc)
  end
end

function PlayerAlongSplineMoveNode:InitBlendCamera()
  if not self.CameraLocked then
    return
  end
  if not IsValid(self.CinemaMoveSpline) or not IsValid(self.CinemaMoveSpline.BlendCamera) then
    return
  end
  local BlendCamera = self.CinemaMoveSpline.BlendCamera
  local CameraComp = self.Player:GetCameraComponent()
  local CineCamComponent = BlendCamera:GetCineCameraComponent()
  CineCamComponent:SetFieldOfView(CameraComp.FieldOfView)
  CineCamComponent.bConstrainAspectRatio = CameraComp.bConstrainAspectRatio
  BlendCamera:K2_SetActorLocationAndRotation(CameraComp:K2_GetComponentLocation(), CameraComp:K2_GetComponentRotation(), false, nil, false)
  self.CinemaMoveSpline:UpdateBlendCameraLoc(self.Player:K2_GetActorLocation())
  USequenceFunctionLibrary.SetViewTargetWithBlend(self.Player.Controller, BlendCamera, DefaultBlendTime, DefaultBlendFunc)
  self.CinemaMoveSpline.BlendCameraInitialized = true
end

function PlayerAlongSplineMoveNode:SequenceBlendOut()
  if IsValid(self.Player) then
    local ViewTarget = self.Player.Controller:GetViewTarget()
    local ViewLocation, ViewRotation = ViewTarget:GetActorEyesViewPoint()
    local BlendCamera = self.CinemaMoveSpline.BlendCamera
    if IsValid(BlendCamera) then
      BlendCamera:K2_SetActorLocationAndRotation(ViewLocation, ViewRotation, false, nil, false)
    end
  end
  if IsValid(self.CinemaMoveSpline.SequenceActor) then
    local SequencePlayer = self.CinemaMoveSpline.SequenceActor:GetSequencePlayer()
    if IsValid(SequencePlayer) then
      SequencePlayer:StopAtCurrentTime()
    end
  end
  USequenceFunctionLibrary.SetViewTargetWithBlend(self.Player.Controller, self.Player, self.ExitBlendTime, DefaultBlendFunc)
end

function PlayerAlongSplineMoveNode:Stop()
  self:Clear()
end

function PlayerAlongSplineMoveNode:Clear()
  if IsValid(self.CinemaMoveSpline) then
    self.CinemaMoveSpline.StartPointOverlapBox.OnComponentBeginOverlap:Clear()
    self.CinemaMoveSpline.StartPointOverlapBox.OnComponentEndOverlap:Clear()
    self.CinemaMoveSpline.EndPointOverlapBox.OnComponentBeginOverlap:Clear()
    self.CinemaMoveSpline:SetActorTickEnabled(false)
    self.CinemaMoveSpline.BlendCameraInitialized = false
    self.CinemaMoveSpline.IsTriggerable = false
    self.CinemaMoveSpline.bCanExit = false
    if self.bEnableCameraSeq then
      self:SequenceBlendOut()
    end
  end
  self:ExecQuitLogic()
  self.bEnableCameraBlend = false
  self.bEnableCameraSeq = false
  self.CameraLocked = false
  self.Player = nil
end

return PlayerAlongSplineMoveNode
