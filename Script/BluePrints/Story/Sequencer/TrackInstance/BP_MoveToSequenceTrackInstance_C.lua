local M = Class()
local LogType = UE.EStoryLogType.Sequence

function M:StartMoveTo(MoveToData)
  local Section = MoveToData.Section
  local Character = MoveToData.Character
  local AnimResourceResult = MoveToData.AnimResourceResult
  if not IsValid(Section) or not IsValid(Character) then
    return
  end
  if Character.NpcAnimInstance and AnimResourceResult then
    local NpcAnim = Character.NpcAnimInstance
    for _, Replacement in pairs(AnimResourceResult.Replacements) do
      if Replacement.Type ~= UE4.EAnimReplaceType.None then
        NpcAnim:ReplaceAnimSequence(Replacement.AnimPath, Replacement.Type, true)
      end
    end
  end
  local SourceLocation = MoveToData.SourceLocation
  local TargetLocation = MoveToData.TargetLocation
  local NowLocation = Character:K2_GetActorLocation()
  local SquaredDis = UE4.UKismetMathLibrary.Vector_DistanceSquared(NowLocation, SourceLocation)
  local TargetRotation = MoveToData.TargetRotation
  if TargetRotation and (0 ~= TargetRotation.Roll or 0 ~= TargetRotation.Pitch or 0 ~= TargetRotation.Yaw) then
    Character:K2_SetActorRotation(TargetRotation, false, nil, false)
  end
  local TalkSequenceObject = UTrackInstanceFunctionLibrary.GetTalkSequenceObject(self, MoveToData.Input)
  if (not TalkSequenceObject or not TalkSequenceObject:IsInSkip()) and Character.NpcAnimInstance and MoveToData.Character.NpcAnimInstance.IsRotating then
    Character:AbortRotation()
    local Message = string.format("%s %d 转身尚未结束就开始Moveto，请把转身加快一点", Character:GetName(), Character.NpcId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, LogType, "Sequence移动轨道异常", Message)
  end
  USequenceMontageLibrary.ClearAccumulatedRootMotion(Character)
  Character:SetMaxWalkSpeed(MoveToData.MoveToSpeed)
  Character.bUseControllerRotationYaw = false
  if Character:GetMovementComponent() then
    Character:GetMovementComponent():LockMovementMode(false, EMovementMode.MOVE_Walking)
  end
  Character:ForbidFootStep(not Section.EnableFootStepFX)
  USequenceMovementLibrary.CreateMoveToProxyObject(Character, Character, TargetLocation, nil, Section.MoveAcceptRadius, false, Section.bUsePathfinding)
end

function M:EndMoveTo(MoveToData)
  local Character = MoveToData.Character
  if not IsValid(Character) then
    return
  end
  if Character.NpcAnimInstance then
    Character.NpcAnimInstance:StopReplaceAnimSequence()
  end
  self:FinishMoveTo(MoveToData)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  if not GameInstance then
    return
  end
  Character.bUseControllerRotationYaw = MoveToData.UseControllerRotationYaw
  Character:ForbidFootStep(MoveToData.NpcForbidFootStep)
  Character:SetWalkSpeed()
  Character:CacheLastMovementLoc()
end

return M
