local RewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
local Component = {}

function Component:EnterWorld()
  self.logger.debug("ZJT_ EnterWorld MountMgr ")
end

function Component:MountLevelUp(TargetLevel)
  local function Callback(Ret)
    self.logger.debug("ZJT_ MountLevelUp ", TargetLevel, Ret)
  end
  
  self:CallServer("MountLevelUp", Callback, TargetLevel)
end

function Component:HasMountById(MountId)
  return self.Mounts[MountId] ~= nil
end

return Component
