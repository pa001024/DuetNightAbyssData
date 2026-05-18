local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AsyncBossBg", {
  [8500602] = {
    BossUnitID = 8500602,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG01.WBP_AreaCoop_LoadingBG01'"
  },
  [8505603] = {
    BossUnitID = 8505603,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG04.WBP_AreaCoop_LoadingBG04'"
  },
  [8512603] = {
    BossUnitID = 8512603,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG05.WBP_AreaCoop_LoadingBG05'"
  },
  [8512604] = {
    BossUnitID = 8512604,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG05.WBP_AreaCoop_LoadingBG05'"
  },
  [8512605] = {
    BossUnitID = 8512605,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG05.WBP_AreaCoop_LoadingBG05'"
  },
  [8512606] = {
    BossUnitID = 8512606,
    MainIcon = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/BG/WBP_AreaCoop_LoadingBG05.WBP_AreaCoop_LoadingBG05'"
  }
})
