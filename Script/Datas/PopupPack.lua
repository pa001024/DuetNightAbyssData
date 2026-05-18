local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PopupPack", {
  [1] = {
    Duration = 1,
    MaxTrigger = 1,
    PopupPackId = 1,
    ShopItemId = 110101
  },
  [2] = {
    Duration = 2,
    MaxTrigger = 2,
    PopupPackId = 2,
    ShopItemId = 110102
  },
  [3] = {
    Duration = 3,
    MaxTrigger = 3,
    PopupPackId = 3,
    ShopItemId = 110103
  },
  [4] = {
    Duration = 4,
    MaxTrigger = 4,
    PopupPackId = 4,
    ShopItemId = 110104
  }
})
