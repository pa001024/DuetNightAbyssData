local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
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
    ReddotNode = "Gacha_ReSpecial_1",
    Sequence = 2,
    TabId = 2,
    TabName = "UI_SkinGacha_ReSpecial"
  },
  [3] = {
    GachaId = {9003},
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Gacha/Banner/T_Gacha_PoolBanner_Baiheng01.T_Gacha_PoolBanner_Baiheng01'",
    ReddotNode = "Gacha_ReSpecial_2",
    Sequence = 2,
    TabId = 3,
    TabName = "UI_SkinGacha_ReSpecial"
  },
  [4] = {
    GachaId = {9004},
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Gacha/Banner/T_Gacha_PoolBanner_Zhiliu01.T_Gacha_PoolBanner_Zhiliu01'",
    ReddotNode = "Gacha_Special_3",
    Sequence = 1,
    TabId = 4,
    TabName = "UI_SkinGacha_Special"
  },
  [5] = {
    GachaId = {9005},
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Gacha/Banner/T_Gacha_PoolBanner_Suyi01.T_Gacha_PoolBanner_Suyi01'",
    ReddotNode = "Gacha_Special_4",
    Sequence = 1,
    TabId = 5,
    TabName = "UI_SkinGacha_Special"
  },
  [6] = {
    GachaId = {90021},
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Gacha/Banner/T_Gacha_PoolBanner_Fuluo01.T_Gacha_PoolBanner_Fuluo01'",
    ReddotNode = "Gacha_Special_5",
    Sequence = 1,
    TabId = 6,
    TabName = "UI_SkinGacha_Special"
  },
  [7] = {
    GachaId = {9007},
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Gacha/Banner/T_Gacha_PoolBanner_Eve01.T_Gacha_PoolBanner_Eve01'",
    ReddotNode = "Gacha_Special_6",
    Sequence = 1,
    TabId = 7,
    TabName = "UI_SkinGacha_Special"
  }
})
