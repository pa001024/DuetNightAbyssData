local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
local Component = {}

function Component:EnterWorld()
  GuildWarUtils.RefreshQuestReddot(true)
end

function Component:CommonQuestActivityGetPhaseReward(InCallBack, EventId, QuestPhaseId)
  self.logger.info("CommonQuestActivityGetPhaseReward", EventId, QuestPhaseId)
  
  local function Cb(Ret, Rewards)
    if not ErrorCode:Check(Ret) then
      DebugPrint("CommonQuestActivityGetPhaseReward", ErrorCode:Name(Ret))
      return
    end
    if InCallBack then
      InCallBack(Ret, Rewards)
    end
  end
  
  self:CallServer("CommonQuestActivityGetPhaseReward", Cb, EventId, QuestPhaseId)
end

function Component:CommonQuestActivityGetReward(InCallBack, EventId, CommonQuestId)
  self.logger.info("CommonQuestActivityGetReward", EventId, CommonQuestId)
  
  local function Cb(Ret, Rewards)
    if not ErrorCode:Check(Ret) then
      DebugPrint("CommonQuestActivityGetReward", ErrorCode:Name(Ret))
      return
    end
    if InCallBack then
      InCallBack(Ret, Rewards)
    end
  end
  
  self:CallServer("CommonQuestActivityGetReward", Cb, EventId, CommonQuestId)
end

function Component:_OnPropChangeCommonQuestActivity(EventIDs, OldValue)
  GuildWarUtils.RefreshQuestReddot()
end

return Component
