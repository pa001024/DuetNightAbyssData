local Component = {}

function Component:FinishSystemGuide(SystemGuideId)
  self.logger.info("FinishSystemGuide", SystemGuideId)
  
  local function Callback(Ret, RewardReturn)
    self.logger.info("FinishSystemGuide callback", Ret, SystemGuideId, RewardReturn)
    SystemGuideManager:FinishSystemGuideCallback(Ret, RewardReturn)
  end
  
  self:CallServer("FinishSystemGuide", Callback, SystemGuideId)
end

function Component:OnGMFinishSystemGuide(SystemGuideId, RewardReturn)
  self.logger.info("OnGMFinishSystemGuide", SystemGuideId, RewardReturn)
  SystemGuideManager:FinishSystemGuideEvent(SystemGuideId)
end

return Component
