local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ReddotTreeNode_PaoTai = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_PaoTai:OnDecreaseCount(SubValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return
  end
  local CacheDetail = self.Cache.Detail
  local bClearAll = CacheDetailChangedParams.bClearAll
  if not bClearAll then
    local PaotaiEventNewLevel = ReddotManager.GetTreeNode("PaotaiEventNewLevel")
    PaotaiEventNewLevel = PaotaiEventNewLevel or ReddotManager.AddNodeEx("PaotaiEventNewLevel")
    if not PaotaiEventNewLevel or PaotaiEventNewLevel.Count <= 0 then
      local CacheKey = CacheDetailChangedParams.CacheKey
      CacheDetail[CacheKey] = 0
    end
  elseif 0 == self.Count then
    CacheDetail.New = 0
    CacheDetail.Red = 0
    CacheDetail.bClose = true
  end
  self:JudgeReddotType(CacheDetail)
end

function ReddotTreeNode_PaoTai:OnInitNodeCache(NodeCache)
  ReddotTreeNode_PaoTai.Super.OnInitNodeCache(self, NodeCache)
  ReddotManager.AddListenerEx("PaotaiEventNewLevel", self, self.OnPaotaiEventNewLevelChange)
end

function ReddotTreeNode_PaoTai:OnDisposeNode()
  ReddotManager.RemoveListener("PaotaiEventNewLevel", self)
end

function ReddotTreeNode_PaoTai:OnPaotaiEventNewLevelChange(Count, RdType, RdName)
  local CacheDetail = self.Cache.Detail
  if Count <= 0 then
    CacheDetail.New = 0
  else
    CacheDetail.New = 1
  end
  self:TryFireOnCountChange(self.Count, true)
end

return ReddotTreeNode_PaoTai
