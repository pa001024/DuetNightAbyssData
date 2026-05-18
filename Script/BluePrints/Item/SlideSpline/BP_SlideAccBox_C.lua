local M = Class({
  "BluePrints.Item.BP_CombatItemBase_C"
})

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
  if not self.BpBorn then
    self.Rate = self.UnitParams.Rate
    self.Duration = self.UnitParams.Duration
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
  if OtherActor.SlideMovingRate ~= nil then
    OtherActor.SlideMovingRate = OtherActor.SlideMovingRate * (self.Rate + 1)
    self:OnTrigger(OtherActor)
    OtherActor:AddTimer(self.Duration, function()
      OtherActor.SlideMovingRate = 1
    end, false, 0, "SlideAccDurationEnd")
  end
end

function M:ReceiveEndPlay(Reason)
  self.Box.OnComponentBeginOverlap:Clear()
  M.Super.ReceiveEndPlay(self, Reason)
end

return M
