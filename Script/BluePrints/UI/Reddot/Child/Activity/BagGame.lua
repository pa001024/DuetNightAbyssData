local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local BagGameAwardReddotName = "BagGameAward"
local BagGameNewReddotName = "BagGameNew"
local ReddotTreeNode_BagGame = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_BagGame:_IsActivityEnded()
  return BagGameModel:IsActivityEnded()
end

function ReddotTreeNode_BagGame:_ClearReddotCache(ReddotName)
  if not ReddotManager.GetTreeNode(ReddotName) then
    ReddotManager.AddNodeEx(ReddotName, nil, Const.ReddotCacheType.UserCache)
  end
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
  if CacheData then
    for key, _ in pairs(CacheData) do
      CacheData[key] = nil
    end
  end
  ReddotManager.ClearLeafNodeCount(ReddotName)
end

function ReddotTreeNode_BagGame:ClearBagGameReddotWhenActivityEnd()
  if not self:_IsActivityEnded() then
    return
  end
  self:_ClearReddotCache(BagGameAwardReddotName)
  self:_ClearReddotCache(BagGameNewReddotName)
end

function ReddotTreeNode_BagGame:_ResetNodeCache(NodeCache)
  NodeCache.Count = 0
  NodeCache.Detail = {}
  if self.Name == BagGameAwardReddotName then
    NodeCache.Detail.Red = 0
  elseif self.Name == BagGameNewReddotName then
    NodeCache.Detail.New = 0
  end
  self:_JudgeReddotType(NodeCache.Detail)
end

function ReddotTreeNode_BagGame:OnInitNodeCache(NodeCache)
  self.bImplemented = true
  self.bInvokeEveryTime = true
  NodeCache.Count = 0
  NodeCache.Detail = NodeCache.Detail or {}
  if self:_IsActivityEnded() then
    self:ClearBagGameReddotWhenActivityEnd()
    self:_ResetNodeCache(NodeCache)
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar:CheckUIUnlocked("GameEvent") then
    NodeCache.Detail = {}
    return
  end
  if self.Name == "BagGameAward" then
    self:_InitAwardCache(NodeCache)
    NodeCache.Detail.Red = NodeCache.Count > 0 and 1 or 0
  elseif self.Name == "BagGameNew" then
    self:_InitNewCache(NodeCache)
    NodeCache.Detail.New = NodeCache.Count > 0 and 1 or 0
  end
  self:_JudgeReddotType(NodeCache.Detail)
end

function ReddotTreeNode_BagGame:_InitAwardCache(NodeCache)
  local LevelsInfo = DataMgr.BackpackPuzzleLevel
  if not LevelsInfo then
    return
  end
  NodeCache.Detail = {}
  for LevelId, _ in pairs(LevelsInfo) do
    if BagGameModel:HasRewardToGet(LevelId) then
      NodeCache.Detail[LevelId] = true
      NodeCache.Count = NodeCache.Count + 1
    end
  end
end

function ReddotTreeNode_BagGame:_InitNewCache(NodeCache)
  for k, v in pairs(NodeCache.Detail) do
    if type(k) == "number" and true == v then
      NodeCache.Count = NodeCache.Count + 1
    end
  end
end

function ReddotTreeNode_BagGame:_UpdateAggregateKey()
  local CacheDetail = self.Cache.Detail
  if self.Name == "BagGameAward" then
    CacheDetail.Red = self.Count > 0 and 1 or 0
  elseif self.Name == "BagGameNew" then
    CacheDetail.New = self.Count > 0 and 1 or 0
  end
end

function ReddotTreeNode_BagGame:OnIncreaseJudge(AddValue, Params)
  if self:_IsActivityEnded() then
    self:ClearBagGameReddotWhenActivityEnd()
    return false
  end
  if not Params then
    return true
  end
  local LevelId = Params.LevelId
  if not LevelId then
    return false
  end
  if self.Name == "BagGameNew" then
    return self.Cache.Detail[LevelId] == nil
  end
  return not self.Cache.Detail[LevelId]
end

function ReddotTreeNode_BagGame:OnDecreaseJudge(SubValue, Params)
  if not Params then
    return true
  end
  local LevelId = Params.LevelId
  if not LevelId then
    return true
  end
  return self.Cache.Detail[LevelId] == true
end

function ReddotTreeNode_BagGame:OnIncreaseCount(AddValue, Params)
  if not Params then
    return
  end
  local LevelId = Params.LevelId
  if LevelId then
    self.Cache.Detail[LevelId] = true
  end
  self:_UpdateAggregateKey()
  self:JudgeReddotType(self.Cache.Detail)
end

function ReddotTreeNode_BagGame:OnDecreaseCount(SubValue, Params, OldCount)
  if not Params then
    return
  end
  local LevelId = Params.LevelId
  if LevelId then
    if self.Name == "BagGameNew" then
      self.Cache.Detail[LevelId] = false
    else
      self.Cache.Detail[LevelId] = nil
    end
  end
  self:_UpdateAggregateKey()
  self:JudgeReddotType(self.Cache.Detail)
end

function ReddotTreeNode_BagGame:_Judge(EventId)
  if self:_IsActivityEnded() then
    self:ClearBagGameReddotWhenActivityEnd()
    return false
  else
    local Avatar = GWorld:GetAvatar()
    Avatar:_TryRefreshBagGameNewReddot()
  end
  if self.Name == "BagGameAward" then
    local LevelsInfo = DataMgr.BackpackPuzzleLevel
    if not LevelsInfo then
      return false
    end
    for LevelId, _ in pairs(LevelsInfo) do
      if BagGameModel:HasRewardToGet(LevelId) then
        return true
      end
    end
  end
  return false
end

return ReddotTreeNode_BagGame
