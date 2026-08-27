local M = Class({
  "BluePrints.Item.BP_CombatItemBase_C"
})

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  if not self.BpBorn then
    self.Rate = self.UnitParams.Rate
    self.BuffLayer = self.UnitParams.BuffLayer
  end
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
  self.Box.OnComponentBeginOverlap:Add(self, self.OnBoxBeginOverlap)
end

function M:OnBoxBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex)
  if not (OtherActor and OtherActor.IsPlayer) or not OtherActor:IsPlayer() then
    return
  end
  if IsAuthority(self) and OtherActor:AddSlideAccelerationBuff(self.Rate, self.BuffLayer) then
    self:OnTrigger(OtherActor)
  end
  AudioManager(self):PlayFMODSound(self, nil, "event:/sfx/common/player/buff/huaxu_speed_up")
end

function M:ReceiveEndPlay(Reason)
  self.Box.OnComponentBeginOverlap:Clear()
  M.Super.ReceiveEndPlay(self, Reason)
end

return M
