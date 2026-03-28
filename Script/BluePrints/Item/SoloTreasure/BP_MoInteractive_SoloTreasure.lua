require("UnLua")
local BP_MoInteractive_SoloTreasure = Class("BluePrints.Item.MiniGame.BP_MiniGame_C")

function BP_MoInteractive_SoloTreasure:OnActorReady(Info)
  BP_MoInteractive_SoloTreasure.Super.OnActorReady(self, Info)
  if self.OutBoundsWarnTrigger then
    self.OutBoundsWarnTrigger.OnComponentEndOverlap:Add(self, self.OutBoundsWarn)
  end
  if self.OutBoundsFailTrigger then
    self.OutBoundsFailTrigger.OnComponentEndOverlap:Add(self, self.OutBoundsFail)
  end
end

function BP_MoInteractive_SoloTreasure:OutBoundsWarn(Component, OtherActor)
  EventManager:FireEvent(EventID.OnPlayerNearbyGuardBounds, self)
end

function BP_MoInteractive_SoloTreasure:OutBoundsFail(Component, OtherActor)
  EventManager:FireEvent(EventID.OnPlayerOutGuardBounds, self)
end

return BP_MoInteractive_SoloTreasure
