local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PayGoodsToScore", {
  [113001] = {
    ["com.hero.dna.Pay_101"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_101",
      GoodsName = "GoodsName_101",
      PayGoodsScore = 60
    },
    ["com.hero.dna.Pay_102"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_102",
      GoodsName = "GoodsName_102",
      PayGoodsScore = 300
    },
    ["com.hero.dna.Pay_103"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_103",
      GoodsName = "GoodsName_103",
      PayGoodsScore = 980
    },
    ["com.hero.dna.Pay_104"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_104",
      GoodsName = "GoodsName_104",
      PayGoodsScore = 1980
    },
    ["com.hero.dna.Pay_105"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_105",
      GoodsName = "GoodsName_105",
      PayGoodsScore = 3280
    },
    ["com.hero.dna.Pay_106"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_106",
      GoodsName = "GoodsName_106",
      PayGoodsScore = 6480
    },
    ["com.hero.dna.Pay_107"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_107",
      GoodsName = "GoodsName_107",
      PayGoodsScore = 300
    },
    ["com.hero.dna.Pay_108"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_108",
      GoodsName = "GoodsName_108",
      PayGoodsScore = 12880
    },
    ["com.hero.dna.Pay_109"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_109",
      GoodsName = "GoodsName_109",
      PayGoodsScore = 32980
    },
    ["com.hero.dna.Pay_BaituWanhua1"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BaituWanhua1",
      GoodsName = "Pack_Name_16_Gacha6",
      PayGoodsScore = 60
    },
    ["com.hero.dna.Pay_BaituWanhua2"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BaituWanhua2",
      GoodsName = "Pack_Name_16_Gacha7",
      PayGoodsScore = 180
    },
    ["com.hero.dna.Pay_BaituWanhua3"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BaituWanhua3",
      GoodsName = "Pack_Name_16_Gacha8",
      PayGoodsScore = 680
    },
    ["com.hero.dna.Pay_BaituWanhuaSupply1"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BaituWanhuaSupply1",
      GoodsName = "Pack_Name_16_Gacha3",
      PayGoodsScore = 980
    },
    ["com.hero.dna.Pay_BaituWanhuaSupply2"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BaituWanhuaSupply2",
      GoodsName = "Pack_Name_16_Gacha4",
      PayGoodsScore = 1980
    },
    ["com.hero.dna.Pay_BaituWanhuaSupply3"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BaituWanhuaSupply3",
      GoodsName = "Pack_Name_16_Gacha5",
      PayGoodsScore = 3280
    },
    ["com.hero.dna.Pay_BaituZhuangshiWanhua1"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BaituZhuangshiWanhua1",
      GoodsName = "Pack_Name_16_Gacha1",
      PayGoodsScore = 180
    },
    ["com.hero.dna.Pay_BaituZhuangshiWanhua2"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BaituZhuangshiWanhua2",
      GoodsName = "Pack_Name_16_Gacha2",
      PayGoodsScore = 480
    },
    ["com.hero.dna.Pay_BattlePassRank2"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BattlePassRank2",
      GoodsName = "GoodsName_BattlePassRank2",
      PayGoodsScore = 680
    },
    ["com.hero.dna.Pay_BattlePassRank2to3"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BattlePassRank2to3",
      GoodsName = "GoodsName_BattlePassRank2to3",
      PayGoodsScore = 780
    },
    ["com.hero.dna.Pay_BattlePassRank3"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_BattlePassRank3",
      GoodsName = "GoodsName_BattlePassRank3",
      PayGoodsScore = 1280
    },
    ["com.hero.dna.Pay_Bundle1"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_Bundle1",
      GoodsName = "Pack_Name_Shop_Start_01",
      PayGoodsScore = 60
    },
    ["com.hero.dna.Pay_Bundle2"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_Bundle2",
      GoodsName = "Pack_Name_Shop_Start_02",
      PayGoodsScore = 300
    },
    ["com.hero.dna.Pay_Bundle3"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_Bundle3",
      GoodsName = "Pack_Name_Shop_Start_03",
      PayGoodsScore = 680
    },
    ["com.hero.dna.Pay_Bundle4"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_Bundle4",
      GoodsName = "Pack_Name_Shop_Start_04",
      PayGoodsScore = 1280
    },
    ["com.hero.dna.Pay_Bundle5"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_Bundle5",
      GoodsName = "Pack_Name_Shop_Start_05",
      PayGoodsScore = 2680
    },
    ["com.hero.dna.Pay_Bundle6"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_Bundle6",
      GoodsName = "Pack_Name_Shop_Start_06",
      PayGoodsScore = 3280
    },
    ["com.hero.dna.Pay_CharaShards_faluxi1"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_CharaShards_faluxi1",
      GoodsName = "Pack_Name_16_CharPiece",
      PayGoodsScore = 680
    },
    ["com.hero.dna.Pay_CharaShards_faluxi2"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_CharaShards_faluxi2",
      GoodsName = "Pack_Name_16_CharPiece",
      PayGoodsScore = 880
    },
    ["com.hero.dna.Pay_CharaShards_faluxi3"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_CharaShards_faluxi3",
      GoodsName = "Pack_Name_16_CharPiece",
      PayGoodsScore = 1080
    },
    ["com.hero.dna.Pay_DailyCharaShards_faluxi"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_DailyCharaShards_faluxi",
      GoodsName = "DailyPack_Name_1",
      PayGoodsScore = 300
    },
    ["com.hero.dna.Pay_DailyRandomPack2_1.6"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_DailyRandomPack2_1.6",
      GoodsName = "Pack_Name_13_Random",
      PayGoodsScore = 30
    },
    ["com.hero.dna.Pay_MoneyTree_All_Test"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_MoneyTree_All_Test",
      GoodsName = "GoodsName_MoneyTree_All",
      PayGoodsScore = 1080
    },
    ["com.hero.dna.Pay_MoneyTree_Single_Test"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_MoneyTree_Single_Test",
      GoodsName = "GoodsName_MoneyTree_Single",
      PayGoodsScore = 60
    },
    ["com.hero.dna.Pay_ThemedSkinPack01"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_ThemedSkinPack01",
      GoodsName = "Pack_Name_MainChar_General_1",
      PayGoodsScore = 1280
    },
    ["com.hero.dna.Pay_ThemedSkinPack_congcong01"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_ThemedSkinPack_congcong01",
      GoodsName = "Pack_Name_MainChar_General_3",
      PayGoodsScore = 1280
    },
    ["com.hero.dna.Pay_ThemedSkinPack_dongri01"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_ThemedSkinPack_dongri01",
      GoodsName = "Pack_Name_MainChar_General_4",
      PayGoodsScore = 980
    },
    ["com.hero.dna.Pay_ThemedSkinPack_qipao01"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_ThemedSkinPack_qipao01",
      GoodsName = "Pack_Name_13_MainChar",
      PayGoodsScore = 1280
    },
    ["com.hero.dna.Pay_YouyuanWeeklyLuckyPack_1.6"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_YouyuanWeeklyLuckyPack_1.6",
      GoodsName = "Pack_Name_15_Gacha9",
      PayGoodsScore = 30
    },
    ["com.hero.dna.Pay_ZaieWeaponSupply1_1.6"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_ZaieWeaponSupply1_1.6",
      GoodsName = "Pack_Name_14_HyperWeapon1",
      PayGoodsScore = 1680
    },
    ["com.hero.dna.Pay_ZaieWeaponSupply2_1.6"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_ZaieWeaponSupply2_1.6",
      GoodsName = "Pack_Name_14_HyperWeapon2",
      PayGoodsScore = 2280
    },
    ["com.hero.dna.Pay_ZaieWeaponSupply3_1.6"] = {
      EventId = 113001,
      GoodsId = "com.hero.dna.Pay_ZaieWeaponSupply3_1.6",
      GoodsName = "Pack_Name_14_HyperWeapon3",
      PayGoodsScore = 3280
    }
  }
})
