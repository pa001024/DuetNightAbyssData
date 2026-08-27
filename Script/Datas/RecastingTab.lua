local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RecastingTab", {
  [1] = {
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_All.T_Tab_All",
    ProductType = "All",
    Sequence = 80,
    TabDefaultSlot = 999,
    TabId = 1,
    TabName = "UI_TAB_NAME_ALL"
  },
  [2] = {
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Forging_WPmaterial.T_Tab_Forging_WPmaterial",
    ProductType = "wpmaterial",
    Sequence = 20,
    TabDefaultSlot = 999,
    TabId = 2,
    TabName = "UI_TAB_NAME_WPMATE"
  },
  [3] = {
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Forging_WPcomponent.T_Tab_Forging_WPcomponent",
    ProductType = "wpcomponent",
    Sequence = 30,
    TabDefaultSlot = 999,
    TabId = 3,
    TabName = "UI_TAB_NAME_WPCOM"
  },
  [4] = {
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Forging_Reset.T_Tab_Forging_Reset",
    ProductType = "reset",
    Sequence = 70,
    TabDefaultSlot = 999,
    TabId = 4,
    TabName = "UI_SHOP_SUBTAB_NAME_RESET"
  },
  [5] = {
    Icon = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Forging_WeeklyBoss.T_Tab_Forging_WeeklyBoss",
    ProductType = "weeklyboss",
    Sequence = 60,
    TabDefaultSlot = 999,
    TabId = 5,
    TabName = "Draft_Resource_Education"
  }
})
