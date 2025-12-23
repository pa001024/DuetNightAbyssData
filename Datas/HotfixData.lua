local hotfix_data = "-- 请在此处编写HotFix代码,请组长编写\n\tDataMgr.ShopItem[140118].Price = 100\n\tDataMgr.ShopItem[140133].Price = 100\n\tDataMgr.ShopItem[140134].Price = 100\n\tDataMgr.ShopItem[140135].Price = 100\n\n\tUE4.URuntimeCommonFunctionLibrary.EnableGlobalAnimCache(GWorld and GWorld.GameInstance, false)\n"
return {
  index = 2,
  script = hotfix_data,
  client_version = {ForceUpdateCheck = "1"},
  force_update_version = "1",
  patch_version = {
    ["1"] = "0"
  }
}
