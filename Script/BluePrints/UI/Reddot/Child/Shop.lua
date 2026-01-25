local TimeUtils = require("Utils.TimeUtils")
local EMCache = require("EMCache.EMCache")
local ReddotTreeNode_Shop = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function ReddotTreeNode_Shop:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return true
  end
  local CacheDetail = self.Cache.Detail
  local ShopItemId = CacheDetailChangedParams.ShopItemId
  if 1 == AddValue and ShopItemId and self:IsValidShopItem(ShopItemId) then
    return not CacheDetail[ShopItemId]
  end
  return false
end

function ReddotTreeNode_Shop:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
  if not CacheDetailChangedParams then
    return true
  end
  local CacheDetail = self.Cache.Detail
  local ShopItemId = CacheDetailChangedParams.ShopItemId
  if 1 == SubValue and ShopItemId then
    return CacheDetail[ShopItemId] ~= Const.ShopCacheReason.Read
  end
  if CacheDetailChangedParams.bAll then
    return true
  end
  return false
end

function ReddotTreeNode_Shop:OnDecreaseCount(SubValue, CacheDetailChangedParams, OldCount)
  if not CacheDetailChangedParams then
    return
  end
  local CacheDetail = self.Cache.Detail
  if not CacheDetail then
    return
  end
  local ShopItemId = CacheDetailChangedParams.ShopItemId
  local bAll = CacheDetailChangedParams.bAll
  if 1 == SubValue and ShopItemId then
    if CacheDetail[ShopItemId] then
      if 0 == DataMgr.ShopItem[ShopItemId].Price and self.FreeCount > 0 then
        self.FreeCount = self.FreeCount - 1
        if 0 == self.FreeCount then
          self.ReddotType = self.Conf.Type
          ReddotManager.TryInvokeEvent(self, self.Count, true)
          self:UpdateRdType()
        end
      end
      CacheDetail[ShopItemId] = Const.ShopCacheReason.Read
    end
  elseif 0 == self.Count and bAll then
    local Avatar = GWorld:GetAvatar()
    local SubTabConf = DataMgr.ShopTabSub[self.SubTabId]
    local ShopItems = DataMgr.ShopItem2ShopTab[SubTabConf.MainTabId][self.SubTabId]
    for _, ItemId in pairs(ShopItems) do
      if not self:IsValidShopItem(ItemId) then
      elseif ShopUtils:IsFree(ItemId) then
        self.Count = self.Count + 1
      elseif Avatar:CheckShopItemEnhanceRedDot(ItemId) then
        self.Count = self.Count + 1
      else
        CacheDetail[ItemId] = Const.ShopCacheReason.Read
      end
    end
  end
end

function ReddotTreeNode_Shop:OnIncreaseCount(AddValue, CacheDetailChangedParams, OldCount)
  if not CacheDetailChangedParams then
    return
  end
  local CacheDetail = self.Cache.Detail
  local ShopItemId = CacheDetailChangedParams.ShopItemId
  local Reason = CacheDetailChangedParams.Reason or Const.ShopCacheReason.Persistent
  if 1 == AddValue and ShopItemId then
    CacheDetail[ShopItemId] = Reason
  end
end

function ReddotTreeNode_Shop:OnInitNodeCache(NodeCache)
  self.SubTabId = nil
  self.Level2ShopItem = {}
  local ShopType = "Shop"
  NodeCache.Count = 0
  if not self.SubTabId then
    for _, MainTabId in pairs(DataMgr.Shop[ShopType].MainTabId) do
      local Data = DataMgr.ShopItem2ShopTab[MainTabId]
      for SubTabId, ShopItems in pairs(Data or {}) do
        local ReddotName = DataMgr.ShopTabSub[SubTabId].ReddotNode
        if self.Name == ReddotName then
          self.SubTabId = SubTabId
          break
        end
      end
      if self.SubTabId then
        break
      end
    end
  end
  local Avatar = GWorld:GetAvatar()
  local ShopSubTabData = DataMgr.ShopTabSub[self.SubTabId]
  if not ShopSubTabData then
    return
  end
  if self.Conf.RuleId and not Avatar:CheckUIUnlocked(self.Conf.RuleId) then
    return
  end
  self:RefreshCacheDetail(NodeCache)
  EventManager:AddEvent(EventID.OnPlayerLevelUp, self, function()
    if table.isempty(self.Level2ShopItem) then
      return
    end
    local Avatar = GWorld:GetAvatar()
    local ItemList = self.Level2ShopItem[Avatar.Level]
    if not ItemList then
      return
    end
    local NowTime = TimeUtils.NowTime()
    for ItemId, _ in pairs(ItemList) do
      local Delta = self:_RefreshAShopItem(ItemId, self.Cache, NowTime, true)
      if Delta > 0 then
        self:IncreaseCount(Delta)
      end
    end
  end)
end

function ReddotTreeNode_Shop:OnDisposeNode()
  EventManager:RemoveEvent(EventID.OnPlayerLevelUp, self)
end

function ReddotTreeNode_Shop:IsValidShopItem(ItemId)
  local Avatar = GWorld:GetAvatar()
  local ItemData = DataMgr.ShopItem[ItemId]
  if not ItemData then
    return false
  end
  if not ShopUtils:GetShopItemCanShow(ItemId) then
    return false
  end
  local NeedLevel = ItemData.UnlockLevel or 0
  if NeedLevel > 0 then
    if not self.Level2ShopItem[NeedLevel] then
      self.Level2ShopItem[NeedLevel] = {}
    end
    self.Level2ShopItem[NeedLevel][ItemId] = 1
  end
  local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(ItemId)
  if 0 ~= PurchaseLimit then
    if NeedLevel > Avatar.Level then
      return false
    else
      return true
    end
  else
    return true
  end
  return false
end

function ReddotTreeNode_Shop:RefreshCacheDetail(NodeCache)
  self.FreeCount = 0
  local DeltaCount = 0
  local SubTabConf = DataMgr.ShopTabSub[self.SubTabId]
  if not SubTabConf then
    return 0
  end
  local ShopItems = DataMgr.ShopItem2ShopTab[SubTabConf.MainTabId][self.SubTabId]
  local NowTime = TimeUtils.NowTime()
  for _, ItemId in ipairs(ShopItems) do
    DeltaCount = DeltaCount + self:_RefreshAShopItem(ItemId, NodeCache, NowTime)
  end
  for ItemId, CacheReason in pairs(NodeCache.Detail) do
    if CacheReason == Const.ShopCacheReason.Persistent and NodeCache.Count then
      NodeCache.Count = NodeCache.Count + 1
    end
  end
  return DeltaCount
end

function ReddotTreeNode_Shop:_RefreshAShopItem(ItemId, NodeCache, NowTime, bIgnoreTime)
  local Avatar = GWorld:GetAvatar()
  local ShopUnlockTime = EMCache:Get("ShopUnlockTime", true)
  if not self:IsValidShopItem(ItemId) then
    if NodeCache.Detail[ItemId] ~= Const.ShopCacheReason.Read then
      NodeCache.Detail[ItemId] = nil
    end
    return 0
  end
  local ShopItemConf = DataMgr.ShopItem[ItemId]
  if not ShopItemConf then
    Traceback(ErrorTag, string.format("商品Id %s 不存在，策划应该是删表了然后你又用新号，换个新号，别死磕这个报错", ItemId))
    return 0
  end
  if ShopUtils:IsFree(ItemId) then
    self.ReddotType = EReddotType.Normal
    self.FreeCount = self.FreeCount + 1
    NodeCache.Detail[ItemId] = Const.ShopCacheReason.Temporary
    if NodeCache.Count then
      NodeCache.Count = NodeCache.Count + 1
    end
  elseif Avatar:CheckShopItemEnhanceRedDot(ItemId) then
    NodeCache.Detail[ItemId] = Const.ShopCacheReason.Temporary
    if NodeCache.Count then
      NodeCache.Count = NodeCache.Count + 1
    end
  else
    if ShopUnlockTime and ShopItemConf.StartTime and NowTime > ShopItemConf.StartTime and not NodeCache.Detail[ItemId] then
      if ShopUnlockTime < ShopItemConf.StartTime or bIgnoreTime then
        NodeCache.Detail[ItemId] = Const.ShopCacheReason.Persistent
        return 1
      else
        NodeCache.Detail[ItemId] = Const.ShopCacheReason.Read
        return 0
      end
    end
    if ShopItemConf.EndTime and NowTime > ShopItemConf.EndTime and NodeCache.Detail[ItemId] == Const.ShopCacheReason.Persistent then
      NodeCache.Detail[ItemId] = Const.ShopCacheReason.Read
      return -1
    end
  end
  return 0
end

return ReddotTreeNode_Shop
