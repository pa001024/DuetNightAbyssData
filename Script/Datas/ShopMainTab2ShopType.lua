local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ShopMainTab2ShopType", {
  [110] = "Shop",
  [120] = "Shop",
  [140] = "Shop",
  [150] = "Shop",
  [160] = "Shop",
  [170] = "Shop",
  [180] = "Shop",
  [200] = "Shop",
  [701] = "ExploreBadgeShop",
  [702] = "ExploreBadgeShop",
  [703] = "ExploreBadgeShop",
  [704] = "ExploreBadgeShop",
  [705] = "ExploreBadgeShop",
  [801] = "FishingShop",
  [802] = "FishingShop",
  [10000] = "AbyssShop",
  [10001] = "HuaxuEventShop",
  [10002] = "Rouge",
  [10003] = "WeeklyDungeonShop",
  [10004] = "RaidShopSeason01",
  [10005] = "HuaxuExploreShop",
  [10006] = "AutoChessShop",
  [10007] = "SoloTreasureShop",
  [10008] = "AccessoryDropShop",
  [10009] = "GuildShop",
  [10010] = "AppearenceShop",
  [10011] = "RaceLotteryShop",
  [10012] = "SoloTreasurePermShop",
  [10013] = "IronModeShop",
  [10015] = "AccessoryDropShop2",
  [90001] = "GiftShop",
  [90003] = "GiftShop",
  [90004] = "GiftShop",
  [90005] = "GiftShop",
  [90006] = "GiftShop"
})
