local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildEntranceComponent", {
  [1001] = {
    ComponentDesc = "UI_OnlineRegion_Enter",
    ComponentName = "小房子",
    ComponentSubType = -1,
    ComponentType = 1,
    ConsumeCurrency = 4005,
    ConsumeNum = 10,
    ConsumeValue = 356,
    ID = 1001,
    PicAlbum = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_BreakRes_Light05.T_BreakRes_Light05'",
    UnlockLevel = 1
  },
  [1002] = {
    ComponentDesc = "UI_OnlineStatus",
    ComponentName = "桌子",
    ComponentSubType = 1,
    ComponentType = 2,
    ConsumeCurrency = 4005,
    ConsumeNum = 20,
    ConsumeValue = 10,
    ID = 1002,
    PicAlbum = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_BreakRes_Light05.T_BreakRes_Light05'",
    UnlockLevel = 5
  },
  [1003] = {
    ComponentDesc = "UI_OnlyShowMod_Get",
    ComponentName = "石头",
    ComponentSubType = 1,
    ComponentType = 3,
    ConsumeCurrency = 4005,
    ConsumeNum = 30,
    ConsumeValue = 20,
    ID = 1003,
    PicAlbum = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_BreakRes_Light05.T_BreakRes_Light05'",
    UnlockLevel = 5
  }
})
