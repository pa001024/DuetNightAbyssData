local Component = {}

function Component:UpdateReddotCommon(ShopItemData)
  self:EMShowReddot(false, EReddotType.New)
  local ShopTabConf = DataMgr.ShopTabSub[ShopItemData.SubTabId]
  local NodeName = ShopTabConf and ShopTabConf.ReddotNode
  if NodeName then
    local Node = ReddotManager.GetTreeNode(NodeName)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if CacheDetail and CacheDetail[self.ShopId] and CacheDetail[self.ShopId] ~= Const.ShopCacheReason.Read then
      if Node then
        self:EMShowReddot(true, Node.ReddotType)
      else
        self:EMShowReddot(true, EReddotType.New)
      end
    elseif not CacheDetail[self.ShopId] then
      local NowTime = TimeUtils.NowTime()
      Node:_RefreshAShopItem(self.ShopId, Node.Cache, NowTime)
      if Node.Cache.Count > Node.Count then
        local DeltaCount = Node.Cache.Count - Node.Count
        ReddotManager.IncreaseLeafNodeCount(NodeName, DeltaCount)
      end
    end
  end
end

function Component:DecreaseReddotCommon(ShopItemData)
  local ShopTabConf = DataMgr.ShopTabSub[ShopItemData.SubTabId]
  local NodeName = ShopTabConf and ShopTabConf.ReddotNode
  if NodeName and not self.IsFree and not self.bNewShopItem and ReddotManager.DecreaseLeafNodeCount(ShopTabConf.ReddotNode, 1, {
    ShopItemId = self.ShopId
  }) then
    self:EMShowReddot(false, EReddotType.New)
  end
end

return Component
