local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:InitNodeCache()
  self:OnInitNodeCache(self.Cache)
  if self.Cache then
    self.Cache.Count = self.Count or 0
  end
  DebugPrint("[StringBoardReddot] InitNodeCache", self.Name, "Count=", self.Count)
end

function M:OnInitNodeCache(NodeCache)
  NodeCache.Detail = NodeCache.Detail or {}
  local NewCount = 0
  for _, Value in pairs(NodeCache.Detail) do
    if true == Value then
      NewCount = NewCount + 1
    end
  end
  NodeCache.Count = NewCount
  self.Count = NewCount
  self.bInvokeEveryTime = true
  self.ReddotType = EReddotType.New
end

function M:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
  local CacheKey = CacheDetailChangedParams and CacheDetailChangedParams.CacheKey
  if not CacheKey then
    return false
  end
  local Detail = self.Cache and self.Cache.Detail
  if not Detail then
    return false
  end
  return nil == Detail[CacheKey]
end

function M:OnIncreaseCount(AddValue, CacheDetailChangedParams, OldCount)
  local CacheKey = CacheDetailChangedParams and CacheDetailChangedParams.CacheKey
  if not (CacheKey and self.Cache) or not self.Cache.Detail then
    return
  end
  self.Cache.Detail[CacheKey] = true
  self.bInvokeEveryTime = true
  self.ReddotType = EReddotType.New
end

function M:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
  local CacheKey = CacheDetailChangedParams and CacheDetailChangedParams.CacheKey
  if not CacheKey then
    return false
  end
  local Detail = self.Cache and self.Cache.Detail
  if not Detail then
    return false
  end
  return true == Detail[CacheKey]
end

function M:OnDecreaseCount(SubValue, CacheDetailChangedParams, OldCount)
  local CacheKey = CacheDetailChangedParams and CacheDetailChangedParams.CacheKey
  if not (CacheKey and self.Cache) or not self.Cache.Detail then
    return
  end
  self.Cache.Detail[CacheKey] = false
  self.bInvokeEveryTime = true
  self.ReddotType = EReddotType.New
end

return M
