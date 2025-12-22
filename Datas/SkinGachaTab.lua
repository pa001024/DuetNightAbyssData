local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SkinGachaTab", {
  [1] = {
    GachaId = {9001},
    Icon = "/Game/UI/Texture/Dynamic/Image/Gacha/Banner/T_Gacha_PoolBanner_Normal01.T_Gacha_PoolBanner_Normal01",
    ReddotNode = "Gacha_Normal",
    Sequence = 99,
    TabId = 1,
    TabName = "UI_SkinGacha_Normal"
  },
  [2] = {
    GachaId = {9002},
    Icon = "/Game/UI/Texture/Dynamic/Image/Gacha/Banner/T_Gacha_PoolBanner_Saiqi01.T_Gacha_PoolBanner_Saiqi01",
    ReddotNode = "Gacha_Special",
    Sequence = 1,
    TabId = 2,
    TabName = "UI_SkinGacha_Special"
  },
  [3] = {
    GachaId = {9003},
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Gacha/Banner/T_Gacha_PoolBanner_Baiheng01.T_Gacha_PoolBanner_Baiheng01'",
    ReddotNode = "Gacha_Special_2",
    Sequence = 1,
    TabId = 3,
    TabName = "UI_SkinGacha_Special"
  }
})
