local Component = {}
local BackpackPuzzleController = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameController")
local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local TimeUtils = require("Utils.TimeUtils")
local BagGameAwardReddotName = "BagGameAward"
local BagGameNewReddotName = "BagGameNew"

function Component:_OnLoginSuccess()
  BackpackPuzzleController:Init()
  self:InitReddot()
end

function Component:LeaveWorld()
  BackpackPuzzleController:Destory()
end

function Component:InitReddot()
  ReddotManager.AddNodeEx(BagGameAwardReddotName, nil, Const.ReddotCacheType.UserCache)
  ReddotManager.AddNodeEx(BagGameNewReddotName, nil, Const.ReddotCacheType.UserCache)
  if self:_ClearBagGameReddotWhenActivityEnd() then
    return
  end
  self:_TryRefreshBagGameNewReddot()
end

function Component:_OnPropChangeBackpackPuzzles(keys)
  if self:_ClearBagGameReddotWhenActivityEnd() then
    return
  end
  self:_TryRefreshBagGameAwardReddot()
  self:_TryRefreshBagGameNewReddot()
end

function Component:_GetBagGameLevelUnlockTimestamp(LevelInfo)
  if not LevelInfo then
    return 0
  end
  if LevelInfo.UnlockDate ~= nil then
    return LevelInfo.UnlockDate:GetTime()
  end
  if BagGameModel.EventStartTime then
    return BagGameModel.EventStartTime:GetTime()
  end
  return 0
end

function Component:_IsBagGameLevelUnlockTimeReached(LevelInfo)
  local UnlockTs = self:_GetBagGameLevelUnlockTimestamp(LevelInfo)
  return UnlockTs <= 0 or UnlockTs <= TimeUtils.NowTime()
end

function Component:_TryClearBagGameNewReddotByStarRecord(LevelId, CacheDetail)
  if not LevelId or BagGameModel:GetPlayerStarCount(LevelId) <= 0 then
    return false
  end
  if CacheDetail and true == CacheDetail[LevelId] then
    ReddotManager.DecreaseLeafNodeCount(BagGameNewReddotName, 1, {LevelId = LevelId})
  end
  return true
end

function Component:_TryRefreshBagGameAwardReddot()
  if self:_ClearBagGameReddotWhenActivityEnd() then
    return
  end
  local ReddotNode = ReddotManager.GetTreeNode(BagGameAwardReddotName)
  if not ReddotNode then
    return
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(BagGameAwardReddotName)
  if not CacheDetail then
    return
  end
  local LevelsInfo = DataMgr.BackpackPuzzleLevel
  if not LevelsInfo then
    return
  end
  for LevelId, _ in pairs(LevelsInfo) do
    local bHasReward = BagGameModel:HasRewardToGet(LevelId)
    local bCached = true == CacheDetail[LevelId]
    if bHasReward and not bCached then
      ReddotManager.IncreaseLeafNodeCount(BagGameAwardReddotName, 1, {LevelId = LevelId})
    elseif not bHasReward and bCached then
      ReddotManager.DecreaseLeafNodeCount(BagGameAwardReddotName, 1, {LevelId = LevelId})
    end
  end
end

function Component:_TryRefreshBagGameNewReddot()
  if self:_ClearBagGameReddotWhenActivityEnd() then
    return
  end
  local ReddotNode = ReddotManager.GetTreeNode(BagGameNewReddotName)
  if not ReddotNode then
    return
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(BagGameNewReddotName)
  if not CacheDetail then
    return
  end
  local LevelsInfo = BagGameModel:GetLevelsInfo()
  if not LevelsInfo or 0 == #LevelsInfo then
    return
  end
  for i, LevelInfo in ipairs(LevelsInfo) do
    local LevelId = LevelInfo.LevelId
    if self:_TryClearBagGameNewReddotByStarRecord(LevelId, CacheDetail) then
    elseif nil ~= CacheDetail[LevelId] then
    else
      local bUnlocked = false
      if 1 == i then
        bUnlocked = self:_IsBagGameLevelUnlockTimeReached(LevelInfo)
      else
        local PrevLevelId = LevelsInfo[i - 1].LevelId
        if BagGameModel:GetPlayerStarCount(PrevLevelId) > 0 then
          bUnlocked = self:_IsBagGameLevelUnlockTimeReached(LevelInfo)
        end
      end
      if bUnlocked then
        ReddotManager.IncreaseLeafNodeCount(BagGameNewReddotName, 1, {LevelId = LevelId})
      end
    end
  end
end

function Component:_ClearSingleBagGameReddot(ReddotName)
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
  if CacheDetail then
    for key, _ in pairs(CacheDetail) do
      CacheDetail[key] = nil
    end
  end
  ReddotManager.ClearLeafNodeCount(ReddotName)
end

function Component:_ClearBagGameReddotWhenActivityEnd()
  if not BagGameModel:IsActivityEnded() then
    return false
  end
  self:_ClearSingleBagGameReddot(BagGameAwardReddotName)
  self:_ClearSingleBagGameReddot(BagGameNewReddotName)
  return true
end

function Component:BackpackPuzzleGetScoreReward(BackpackPuzzleId, RewardKeyId, CallBack)
  self.logger.info("BackpackPuzzleGetScoreReward", BackpackPuzzleId, RewardKeyId)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    DebugPrint("BackpackPuzzleGetScoreReward", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("BackpackPuzzleGetScoreReward", Cb, BackpackPuzzleId, RewardKeyId)
end

function Component:BackpackPuzzleGetAllScoreReward(BackpackPuzzleId, CallBack)
  self.logger.info("BackpackPuzzleGetAllScoreReward", BackpackPuzzleId)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    DebugPrint("BackpackPuzzleGetAllScoreReward", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("BackpackPuzzleGetAllScoreReward", Cb, BackpackPuzzleId)
end

function Component:BackpackPuzzleFinishGame(BackpackPuzzleId, Score, CallBack)
  self.logger.info("BackpackPuzzleFinishGame", BackpackPuzzleId, Score)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    DebugPrint("BackpackPuzzleFinishGame", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("BackpackPuzzleFinishGame", Cb, BackpackPuzzleId, Score)
end

return Component
