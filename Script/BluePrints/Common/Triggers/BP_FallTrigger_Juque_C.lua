require("UnLua")
local BP_FallTrigger_Juque_C = Class("BluePrints.Common.TimerMgr")

function BP_FallTrigger_Juque_C:Initialize(Initializer)
  self.InRange = false
end

function BP_FallTrigger_Juque_C:ReceiveBeginPlay()
  if IsAuthority(self) then
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState:AddFallTriggerInfo(self)
  end
end

function BP_FallTrigger_Juque_C:ReceiveEndPlay()
  if IsAuthority(self) then
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState:RemoveFallTriggerInfo(self)
  end
end

function BP_FallTrigger_Juque_C:OnOverlapActor(OtherActor, OtherComponent)
  if not self.Active or UE4.UKismetMathLibrary.ClassIsChildOf(OtherComponent:GetClass(), UInteractiveBaseComponent:StaticClass()) then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not GameMode then
    return
  end
  if not OtherActor.IsCharacter then
    print(_G.LogTag, "Error: FallTrigger 触发到了没有IsCharacter()的东西, 此物不在ActorType范畴内", OtherActor:GetName())
  end
  if OtherActor.IsCharacter and not OtherActor:IsCharacter() and not OtherActor:Cast(UE4.APickupBase) then
    return
  end
  local Res, ResTransform = self:CheckHasSafeTransform(OtherActor)
  if Res then
    GameMode:TriggerFallingCallable(OtherActor, ResTransform, self.MaxDis, self.DefaultEnable, self)
  else
    local ResComponent = self:GetNearestComponentTransform(OtherActor:K2_GetActorLocation())
    GameMode:TriggerFallingCallable(OtherActor, ResComponent:K2_GetComponentToWorld(), self.MaxDis, self.DefaultEnable, self)
  end
end

function BP_FallTrigger_Juque_C:CheckHasSafeTransform(OtherActor)
  if not (OtherActor and OtherActor.IsPlayer) or not OtherActor:IsPlayer() then
    return false, nil
  end
  local Reborn = self.Reborn
  if not Reborn or Reborn:Length() <= 0 then
    return false, nil
  end
  local PlayerLoc = OtherActor:K2_GetActorLocation()
  local SortedEntries = {}
  for i = 1, Reborn:Length() do
    local RebornTransform = Reborn:Get(i)
    local RebornLoc = RebornTransform.Translation
    local Dis = UE4.UKismetMathLibrary.Vector_Distance(PlayerLoc, RebornLoc)
    table.insert(SortedEntries, {
      Index = i,
      Distance = Dis,
      Transform = RebornTransform
    })
  end
  table.sort(SortedEntries, function(A, B)
    return A.Distance < B.Distance
  end)
  local Capsule = OtherActor.CapsuleComponent
  if not Capsule then
    return false, nil
  end
  local CapsuleHalfHeight = Capsule:GetScaledCapsuleHalfHeight()
  local CapsuleRadius = Capsule:GetScaledCapsuleRadius()
  local ActorsToIgnore = UE4.TArray(UE4.AActor)
  ActorsToIgnore:Add(self)
  ActorsToIgnore:Add(OtherActor)
  for _, Entry in ipairs(SortedEntries) do
    local CandidateTransform = Entry.Transform
    local TestLocation = CandidateTransform.Translation
    local TestCenter = UE4.FVector(TestLocation.X, TestLocation.Y, TestLocation.Z)
    local bHasOverlap = UE4.UKismetSystemLibrary.CapsuleOverlapActors(self, TestCenter, CapsuleRadius * 1.1, CapsuleHalfHeight * 1.1, UE4.TArray(UE4.EObjectTypeQuery), nil, ActorsToIgnore, UE4.TArray(UE4.AActor))
    if bHasOverlap then
      return true, CandidateTransform
    end
  end
  return false, nil
end

return BP_FallTrigger_Juque_C
