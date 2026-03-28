local M = Class({
  "BluePrints/Item/ExploreGroup/BP_DongGuoBreakableItem_C",
  "BluePrints.Common.TimerMgr"
})

function M:ReceiveBeginPlay()
  M.Super.ReceiveBeginPlay(self)
end

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  self:HideMechanism(false, "Condition")
  self:StartMove()
end

function M:StartIntegration(Actor)
  if Actor.IsDongGuoDarkCloud and Actor.IsCanDestroy and Actor.Eid == self.Parent.Eid then
    local Loc = self:K2_GetActorLocation()
    self:SetMovementTarget(2, true, Loc)
    self.bCanMove = false
    self.IsIntegrated = true
    self:AddTimer(1, function()
      Actor:StartIntegration()
      self:K2_DestroyActor()
    end)
  end
end

function M:MoveToTarget()
  self:ShowMechanism("Condition")
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local StaticCreator = GameState:GetStaticCreatorInfo(self.CreatorId)
  if IsValid(StaticCreator) then
    local TargetLoc = StaticCreator:K2_GetActorLocation()
    local FlashTime = self.UnitParams.FlashTime or 1
    self:SetMovementTarget(FlashTime, true, TargetLoc)
  end
end

function M:MoveTargetEnd()
end

function M:StartMove()
  self.bCanMove = true
  self.IsMoving = true
end

function M:UpdateMovementTarget(SourceId)
  if not self.bCanMove then
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local StaticCreator = GameState and GameState:GetStaticCreatorInfo(self.CreatorId)
  local TargetLoc = IsValid(StaticCreator) and StaticCreator:K2_GetActorLocation() or nil
  if TargetLoc then
    local CurLoc = self:K2_GetActorLocation()
    local ResetDistance = self.UnitParams.ResetDistance or 3000
    if ResetDistance <= UE4.UKismetMathLibrary.Vector_Distance(CurLoc, TargetLoc) then
      self:SetMovementTarget(0.1, true, TargetLoc)
      self:K2_SetActorLocation(TargetLoc, false, nil, false)
      return
    end
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not Player then
    return
  end
  local NewLoc = Player:K2_GetActorLocation()
  self:SetMovementTarget(2, true, NewLoc)
end

function M:IntergrationOver()
  self.IsMoving = false
  self.bCanMove = false
end

return M
