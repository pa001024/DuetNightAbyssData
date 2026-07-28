local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local JJGameController = require("BluePrints.UI.WBP.ActivityJJGame.JJGameController")
local Component = {}
local MidTermGoalEventId = DataMgr.MidTermGoalConstant.MidTermGoalEventId.ConstantValue

function Component:_OnLoginSuccess()
  JJGameController:Init()
end

function Component:LeaveWorld()
  JJGameController:Destory()
end

function Component:MidTermGetScoresRewards(InCallBack)
  self.logger.info("MidTermGetScoresRewards")
  
  local function Cb(ErrCode, Ret)
    DebugPrint("MidTermGetScoresRewards", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("MidTermGetScoresRewards", Cb)
end

function Component:MidTermGetAllAchvScores(InCallBack)
  self.logger.info("MidTermGetAllAchvScores")
  
  local function Cb(ErrCode, Ret)
    DebugPrint("MidTermGetAllAchvScores", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("MidTermGetAllAchvScores", Cb)
end

function Component:MidTermGetAllNormalScores(InCallBack)
  self.logger.info("MidTermGetAllNormalScores")
  
  local function Cb(ErrCode, Ret)
    DebugPrint("MidTermGetAllNormalScores", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("MidTermGetAllNormalScores", Cb)
end

function Component:MidTermGetProgressReward(InCallBack)
  self.logger.info("MidTermGetProgressReward")
  
  local function Cb(ErrCode, Ret)
    DebugPrint("MidTermGetProgressReward", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, Ret)
    end
  end
  
  self:CallServer("MidTermGetProgressReward", Cb)
end

function Component:MidTermGetTaskReward(TaskId, InCallBack)
  self.logger.info("MidTermGetTaskReward", TaskId)
  
  local function Cb(ErrCode)
    DebugPrint("MidTermGetTaskReward", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode)
    end
  end
  
  self:CallServer("MidTermGetTaskReward", Cb, TaskId)
end

function Component:NotifyMidTermTaskComplete(TaskId)
  self.logger.info("NotifyMidTermTaskComplete", TaskId)
  EventManager:FireEvent(EventID.OnMidTermTaskComplete, TaskId)
  self:DelayUpdateJJGameReddot()
end

function Component:NotifyMidTermTaskProgressChange(TaskId, Progress)
  self.logger.info("NotifyMidTermTaskProgressChange", TaskId, Progress)
  EventManager:FireEvent(EventID.OnMidTermTaskProgressChange, TaskId, Progress)
end

function Component:DelayUpdateJJGameReddot()
  local WorldContextObject = GWorld and GWorld.GameInstance
  UE4.UBattleFunctionLibrary.DeferredCall(WorldContextObject, "MidTermMgr_UpdateJJGameReddot", function()
    self:UpdateJJGameReddot()
  end)
end

function Component:UpdateJJGameReddot()
  if not ActivityUtils.CheckEventIsOpen(MidTermGoalEventId, nil, true) then
    return
  end
  JJGameController:RefreshEntryReddotState()
  local ActiNode = ReddotManager.GetTreeNode("Acti_JJGame")
  if ActiNode and ActiNode.OnRefreshNodeData then
    ActiNode:OnRefreshNodeData(MidTermGoalEventId)
  end
end

return Component
