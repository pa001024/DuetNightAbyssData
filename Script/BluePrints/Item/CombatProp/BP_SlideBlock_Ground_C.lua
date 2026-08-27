require("UnLua")
local BP_SlideBlock_Ground_C = Class({
  "BluePrints/Item/CombatProp/BP_CombatPropBase_C"
})

function BP_SlideBlock_Ground_C:ReceiveBeginPlay()
  BP_SlideBlock_Ground_C.Super.ReceiveBeginPlay(self)
  self.OverlapEffectMap = {}
  self.OverlapEndTimerMap = {}
  if IsValid(self.SlideBlockGroundMove) then
    self.SlideBlockGroundMove:InitComponent(self.RelativeSpeed, self.Cube)
  end
  self:InitOverlapEvent()
end

function BP_SlideBlock_Ground_C:GetOverlapCheckComponents()
  return {
    self.Cube
  }
end

function BP_SlideBlock_Ground_C:GetOverlapEndDebounceTime()
  return 0.15
end

function BP_SlideBlock_Ground_C:GetOverlapEndTimerName(Eid)
  return "SlideOverlapEnd_" .. tostring(Eid)
end

function BP_SlideBlock_Ground_C:CancelOverlapEndClear(Eid)
  local TimerName = self:GetOverlapEndTimerName(Eid)
  if self.OverlapEndTimerMap and self.OverlapEndTimerMap[Eid] then
    self:RemoveTimer(TimerName)
    self.OverlapEndTimerMap[Eid] = nil
  end
end

function BP_SlideBlock_Ground_C:ScheduleOverlapEndClear(OtherActor)
  local Eid = OtherActor.Eid
  self:CancelOverlapEndClear(Eid)
  local TimerName = self:GetOverlapEndTimerName(Eid)
  self.OverlapEndTimerMap[Eid] = true
  self:AddTimer(self:GetOverlapEndDebounceTime(), function()
    self.OverlapEndTimerMap[Eid] = nil
    if not IsValid(self) or not IsValid(OtherActor) then
      return
    end
    if self:IsOverlappingTarget(OtherActor) then
      return
    end
    self.OverlapEffectMap[Eid] = nil
  end, false, 0, TimerName)
end

function BP_SlideBlock_Ground_C:InitOverlapEvent()
  local Comps = self:GetOverlapCheckComponents()
  for i = 1, #Comps do
    local Comp = Comps[i]
    if IsValid(Comp) then
      Comp.OnComponentBeginOverlap:Add(self, self.OnBeginOverlap)
      Comp.OnComponentEndOverlap:Add(self, self.OnEndOverlap)
    end
  end
end

function BP_SlideBlock_Ground_C:IsOverlappingTarget(OtherActor)
  if not IsValid(OtherActor) then
    return false
  end
  local Comps = self:GetOverlapCheckComponents()
  for i = 1, #Comps do
    local Comp = Comps[i]
    if IsValid(Comp) and Comp:IsOverlappingActor(OtherActor) then
      return true
    end
  end
  return false
end

function BP_SlideBlock_Ground_C:OnActorReady(Info)
  BP_SlideBlock_Ground_C.Super.OnActorReady(self, Info)
  local NeedAttach = Info.BoolParams:FindRef("NeedAttach")
  local Boss = self:GetDirectSource()
  if NeedAttach and IsValid(Boss) then
    local PosIndex = Info.IntParams:Find("PosIndex")
    local PosComp = Boss["Pos" .. PosIndex]
    local ArrowComp = Boss["Arrow" .. PosIndex]
    if IsValid(PosComp) and IsValid(ArrowComp) then
      self:K2_SetActorLocationAndRotation(PosComp:K2_GetComponentLocation(), ArrowComp:K2_GetComponentRotation(), false, nil, true)
    end
    if IsValid(Boss.Core) then
      self:K2_AttachToComponent(Boss.Core, "None", UE4.EAttachmentRule.KeepWorld, UE4.EAttachmentRule.KeepWorld, UE4.EAttachmentRule.KeepWorld, true)
    end
  end
  self:SetLifeTime(self.LifeTime)
  if self.StartMoveTime <= 0 then
    self:StartMove()
  else
    self:AddTimer(self.StartMoveTime, self.StartMove, false)
  end
end

function BP_SlideBlock_Ground_C:StartMove()
  if IsValid(self.SlideBlockGroundMove) then
    self.SlideBlockGroundMove:StartMove()
  end
end

function BP_SlideBlock_Ground_C:StopMove()
  if IsValid(self.SlideBlockGroundMove) then
    self.SlideBlockGroundMove:StopMove()
  end
end

function BP_SlideBlock_Ground_C:DisableOverlap()
  local Comps = self:GetOverlapCheckComponents()
  for i = 1, #Comps do
    local Comp = Comps[i]
    if Comp then
      Comp:SetGenerateOverlapEvents(false)
    end
  end
end

function BP_SlideBlock_Ground_C:EnableOverlap()
  local Comps = self:GetOverlapCheckComponents()
  for i = 1, #Comps do
    local Comp = Comps[i]
    if Comp then
      Comp:SetGenerateOverlapEvents(true)
    end
  end
end

function BP_SlideBlock_Ground_C:OnBeginOverlap(Component, OtherActor, OtherComp, OtherBodyIndex, bFromSweep)
  if not OtherActor or not OtherActor.Eid then
    return
  end
  local PlayerCharacter = OtherActor:Cast(UE4.APlayerCharacter)
  if not PlayerCharacter or PlayerCharacter.InSlideMechJump then
    return
  end
  self:CancelOverlapEndClear(OtherActor.Eid)
  if self.OverlapEffectMap[OtherActor.Eid] then
    return
  end
  self.OverlapEffectMap[OtherActor.Eid] = true
  if self.SkillEffect then
    DebugPrint("BP_SlideBlock_Ground_C PropUseSkill OtherActor.Eid:", OtherActor.Eid, "SkillEffect:", self.SkillEffect)
    self:PropUseSkill(self.SkillEffect, OtherActor)
  end
end

function BP_SlideBlock_Ground_C:OnEndOverlap(Component, OtherActor, OtherComp, OtherBodyIndex)
  if not OtherActor or not OtherActor.Eid then
    return
  end
  if not self.OverlapEffectMap[OtherActor.Eid] then
    return
  end
  self:ScheduleOverlapEndClear(OtherActor)
end

return BP_SlideBlock_Ground_C
