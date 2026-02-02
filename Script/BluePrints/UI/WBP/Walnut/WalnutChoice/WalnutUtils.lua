require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = {}

function M:GetWalnutCacheIdByDungeonId(DungeonId)
  if not DungeonId then
    return nil
  end
  local WalnutType
  for _, WalnutSelectDungeonData in pairs(DataMgr.WalnutSelectDungeon) do
    if WalnutSelectDungeonData and WalnutSelectDungeonData.DungeonId then
      for _, Id in pairs(WalnutSelectDungeonData.DungeonId) do
        if Id == DungeonId then
          WalnutType = WalnutSelectDungeonData.WalnutType
          break
        end
      end
      if WalnutType then
        break
      end
    end
  end
  if not WalnutType then
    return nil
  end
  local CacheKey = "WalnutIDType" .. WalnutType
  local WalnutCacheId = EMCache:Get(CacheKey, true, true)
  return WalnutCacheId, WalnutType
end

function M:SetWalnutCacheId(WalnutId, WalnutType)
  if not WalnutId then
    return
  end
  if not WalnutType then
    return
  end
  local CacheKey = "WalnutIDType" .. WalnutType
  EMCache:Set(CacheKey, WalnutId, true)
end

function M:CheckWalnutCanPurchase(WalnutId)
  if not WalnutId or WalnutId <= 0 then
    return false, nil
  end
  local WalnutData = DataMgr.Walnut[WalnutId]
  if not WalnutData or not WalnutData.AccessKey then
    return false, nil
  end
  for _, AccessKey in pairs(WalnutData.AccessKey) do
    local AccessData = DataMgr.Access[AccessKey]
    if AccessData then
      local ShopType
      local ActualAccessKey = AccessKey
      if string.sub(AccessKey, 1, 5) == "Shop_" and "Shop_Pack" ~= AccessKey then
        ShopType = AccessData.AccessParam
        ActualAccessKey = "Shop"
      elseif "Shop" == AccessKey then
        ShopType = AccessData.AccessParam or "Shop"
        ActualAccessKey = "Shop"
      end
      if "Shop" == ActualAccessKey and DataMgr.ShopItem2ShopSubId.Walnut and DataMgr.ShopItem2ShopSubId.Walnut[ShopType] and DataMgr.ShopItem2ShopSubId.Walnut[ShopType][WalnutId] then
        local ShopDatas = DataMgr.ShopItem2ShopSubId.Walnut[ShopType][WalnutId]
        for _, ShopData in ipairs(ShopDatas) do
          if ShopUtils:GetShopItemCanShow(ShopData.ShopItemId) and 0 ~= ShopUtils:GetShopItemPurchaseLimit(ShopData.ShopItemId) then
            return true, ShopType
          end
        end
      end
    end
  end
  return false, nil
end

return M
