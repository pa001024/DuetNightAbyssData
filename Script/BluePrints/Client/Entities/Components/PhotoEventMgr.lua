local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local Component = {}

function Component:GetPhotoQuestFinishReward(InCallback, QuestChainId)
  local function Callback(ErrorCode, Rewards)
    self.logger.info("GetPhotoQuestFinishReward ", ErrorCode)
    
    if InCallback then
      InCallback(ErrorCode, Rewards)
    end
  end
  
  self:CallServer("GetPhotoQuestFinishReward", Callback, QuestChainId)
end

return Component
