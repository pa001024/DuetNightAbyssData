local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AppearanceCollectReward", {
  [103024] = {
    BGPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/SkinCollect/BG/WBP_Activity_SkinCollect_PopBG.WBP_Activity_SkinCollect_PopBG'",
    EventId = 103024,
    HighlightReward = {
      [1] = false,
      [2] = false,
      [3] = false,
      [4] = false,
      [5] = true,
      [6] = true,
      [7] = true,
      [8] = true,
      [9] = true
    },
    PointsReward = {
      [1] = 360001,
      [2] = 360002,
      [3] = 360003,
      [4] = 360004,
      [5] = 360005,
      [6] = 360006,
      [7] = 360007,
      [8] = 360008,
      [9] = 360009
    },
    PointsTarget = {
      [1] = 1,
      [2] = 10,
      [3] = 20,
      [4] = 30,
      [5] = 40,
      [6] = 50,
      [7] = 60,
      [8] = 70,
      [9] = 80
    },
    TokenIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Coin_SkinCollect.T_Coin_SkinCollect'",
    UnlockItemCount = 900,
    UnlockItemType = 100
  }
})
