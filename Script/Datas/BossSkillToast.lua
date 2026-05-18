local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("BossSkillToast", {
  [30401] = {
    Duration = 6,
    ID = 30401,
    TextMapKey = "找到特殊敌人并击败，使Boss防御下降",
    TipsStyle = "Common"
  },
  [30402] = {
    Duration = 5,
    ID = 30402,
    TextMapKey = "被点名玩家分担伤害",
    TipsStyle = "Common"
  },
  [30403] = {
    Duration = 6,
    ID = 30403,
    TextMapKey = "攻击与自己颜色相同怪物",
    TipsStyle = "Common"
  },
  [30409] = {
    Duration = 3,
    ID = 30409,
    TextMapKey = "黯蚀领域",
    TipsStyle = "Common"
  },
  [30412] = {
    Duration = 4,
    ID = 30412,
    TextMapKey = "轮盘",
    TipsStyle = "Common"
  },
  [30413] = {
    Duration = 4,
    ID = 30413,
    TextMapKey = "被点名玩家远离队友",
    TipsStyle = "Common"
  },
  [30417] = {
    Duration = 4,
    ID = 30417,
    TextMapKey = "击败敌人获取颜色",
    TipsStyle = "Common"
  },
  [30418] = {
    Duration = 4,
    ID = 30418,
    TextMapKey = "残月",
    TipsStyle = "Common"
  },
  [30420] = {
    Duration = 8,
    ID = 30420,
    TextMapKey = "颜色场即将消失，获取颜色阻止Boss释放毁灭技",
    TipsStyle = "InSequence"
  },
  [304171] = {
    Duration = 4,
    ID = 304171,
    TextMapKey = "召唤",
    TipsStyle = "Common"
  },
  [8500001] = {
    Duration = 2,
    ID = 8500001,
    TextMapKey = "BossSkillToast_Xibi_Skill05",
    TipsStyle = "Common"
  },
  [8500002] = {
    Duration = 2,
    ID = 8500002,
    TextMapKey = "BossSkillToast_Xibi_Skill09",
    TipsStyle = "Common"
  },
  [8500003] = {
    Duration = 2,
    ID = 8500003,
    TextMapKey = "BossSkillToast_Xibi_Skill10",
    TipsStyle = "Common"
  },
  [8500004] = {
    Duration = 2,
    ID = 8500004,
    TextMapKey = "BossSkillToast_Xibi_Skill15",
    TipsStyle = "Common"
  },
  [8502001] = {
    Duration = 2,
    ID = 8502001,
    TextMapKey = "BossSkillToast_Saiqi_Skill05",
    TipsStyle = "Common"
  },
  [8502002] = {
    Duration = 2,
    ID = 8502002,
    TextMapKey = "BossSkillToast_Saiqi_Skill10",
    TipsStyle = "Common"
  },
  [8502003] = {
    Duration = 2,
    ID = 8502003,
    TextMapKey = "BossSkillToast_Saiqi_Skill23",
    TipsStyle = "Common"
  },
  [8503001] = {
    Duration = 3,
    ID = 8503001,
    TextMapKey = "BossSkillToast_Shijingzhe_Skill05",
    TipsStyle = "Common"
  },
  [8503002] = {
    Duration = 2,
    ID = 8503002,
    TextMapKey = "BossSkillToast_Shijingzhe_Skill13",
    TipsStyle = "Common"
  },
  [8503003] = {
    Duration = 3,
    ID = 8503003,
    TextMapKey = "BossSkillToast_Shijingzhe_Skill14",
    TipsStyle = "Common"
  },
  [8503004] = {
    Duration = 3,
    ID = 8503004,
    TextMapKey = "BossSkillToast_Shijingzhe_Skill15",
    TipsStyle = "InSequence"
  },
  [8505001] = {
    Duration = 2,
    ID = 8505001,
    TextMapKey = "BossSkillToast_Lianhuo_Skill08",
    TipsStyle = "InSequence"
  },
  [8505002] = {
    Duration = 2,
    ID = 8505002,
    TextMapKey = "BossSkillToast_Lianhuo_Skill03",
    TipsStyle = "Common"
  },
  [8505003] = {
    Duration = 2,
    ID = 8505003,
    TextMapKey = "BossSkillToast_Lianhuo_Skill07",
    TipsStyle = "Common"
  },
  [8509001] = {
    Duration = 2,
    ID = 8509001,
    TextMapKey = "BossSkillToast_Tuosi_Skill07",
    TipsStyle = "Common"
  },
  [8509002] = {
    Duration = 2,
    ID = 8509002,
    TextMapKey = "BossSkillToast_Tuosi_Skill08",
    TipsStyle = "InSequence"
  },
  [8510001] = {
    Duration = 1.5,
    ID = 8510001,
    TextMapKey = "BossSkillToast_Heilong_Skill13",
    TipsStyle = "Common"
  },
  [8510002] = {
    Duration = 2,
    ID = 8510002,
    TextMapKey = "BossSkillToast_Heilong_Skill07",
    TipsStyle = "Common"
  },
  [8512001] = {
    Duration = 1.5,
    ID = 8512001,
    TextMapKey = "BossSkillToast_Linen_Skill04",
    TipsStyle = "Common"
  },
  [8512002] = {
    Duration = 2,
    ID = 8512002,
    TextMapKey = "BossSkillToast_Linen_Skill06",
    TipsStyle = "Common"
  },
  [8512003] = {
    Duration = 2,
    ID = 8512003,
    TextMapKey = "BossSkillToast_Linen_Skill07",
    TipsStyle = "Common"
  },
  [8512004] = {
    Duration = 3,
    ID = 8512004,
    TextMapKey = "BossSkillToast_Linen_Skill09",
    TipsStyle = "InSequence"
  },
  [8512005] = {
    Duration = 3,
    ID = 8512005,
    TextMapKey = "BossSkillToast_Linen_Skill11",
    TipsStyle = "InSequence"
  },
  [8513001] = {
    Duration = 3,
    ID = 8513001,
    TextMapKey = "BossSkillToast_Kuxiu_Skill07",
    TipsStyle = "Common"
  },
  [8514001] = {
    Duration = 3,
    ID = 8514001,
    TextMapKey = "BossSkillToast_Shenpan_Skill02",
    TipsStyle = "Common"
  },
  [8514002] = {
    Duration = 3,
    ID = 8514002,
    TextMapKey = "BossSkillToast_Shenpan_Skill05",
    TipsStyle = "Common"
  },
  [8515001] = {
    Duration = 3,
    ID = 8515001,
    TextMapKey = "BossSkillToast_Jushi_Skill07",
    TipsStyle = "Common"
  },
  [8515002] = {
    Duration = 3,
    ID = 8515002,
    TextMapKey = "BossSkillToast_Jushi_Skill08",
    TipsStyle = "Common"
  },
  [8518001] = {
    Duration = 3,
    ID = 8518001,
    TextMapKey = "BossSkillToast_Juque_Skill15",
    TipsStyle = "Common"
  },
  [8519001] = {
    Duration = 9,
    ID = 8519001,
    TextMapKey = "BossSkillToast_LiecheHand_Skill07",
    TipsStyle = "BossLiecheCommon"
  },
  [8519002] = {
    Duration = 3,
    ID = 8519002,
    TextMapKey = "BossSkillToast_LiecheCannon_Skill02",
    TipsStyle = "Common"
  },
  [8519003] = {
    Duration = 3,
    ID = 8519003,
    TextMapKey = "BossSkillToast_LiecheCannon_Skill06",
    TipsStyle = "BossLiecheCommon"
  },
  [8519004] = {
    Duration = 3,
    ID = 8519004,
    TextMapKey = "BossSkillToast_LiecheCannon_Skill07",
    TipsStyle = "Common"
  },
  [8519005] = {
    Duration = 3,
    ID = 8519005,
    TextMapKey = "BossSkillToast_LiecheCannon_Skill08",
    TipsStyle = "Common"
  },
  [8519006] = {
    Duration = 3,
    ID = 8519006,
    TextMapKey = "BossSkillToast_LiecheCannon_Skill09",
    TipsStyle = "InSequence"
  },
  [8519007] = {
    Duration = 3,
    ID = 8519007,
    TextMapKey = "BossSkillToast_LiecheCore_Skill01",
    TipsStyle = "Common"
  },
  [8519008] = {
    Duration = 3,
    ID = 8519008,
    TextMapKey = "BossSkillToast_LiecheCore_Skill02",
    TipsStyle = "Common"
  },
  [8519009] = {
    Duration = 3,
    ID = 8519009,
    TextMapKey = "BossSkillToast_LiecheCannon_Skill03",
    TipsStyle = "Common"
  },
  [8519010] = {
    Duration = 3,
    ID = 8519010,
    TextMapKey = "BossSkillToast_LiecheCannon_Skill04",
    TipsStyle = "Common"
  },
  [8520001] = {
    Duration = 3,
    ID = 8520001,
    TextMapKey = "摩天大厦（待包装）",
    TipsStyle = "Common"
  },
  [8520002] = {
    Duration = 6,
    ID = 8520002,
    TextMapKey = "撼动大地（待包装）",
    TipsStyle = "Common"
  },
  [8520003] = {
    Duration = 7,
    ID = 8520003,
    TextMapKey = "列车来袭，注意躲避！（待包装）",
    TipsStyle = "Common"
  },
  [8520004] = {
    Duration = 3,
    ID = 8520004,
    TextMapKey = "空间崩坏（待包装）",
    TipsStyle = "InSequence"
  },
  [8520005] = {
    Duration = 3,
    ID = 8520005,
    TextMapKey = "大地倒塌（待包装）",
    TipsStyle = "InSequence"
  },
  [8520006] = {
    Duration = 7,
    ID = 8520006,
    TextMapKey = "列车来袭，注意躲避！改（待包装）",
    TipsStyle = "Common"
  },
  [8520007] = {
    Duration = 3,
    ID = 8520007,
    TextMapKey = "复制再生（待包装）",
    TipsStyle = "Common"
  },
  [8520008] = {
    Duration = 3,
    ID = 8520008,
    TextMapKey = "摩天大厦·改（待包装）",
    TipsStyle = "InSequence"
  },
  [8520009] = {
    Duration = 20,
    ID = 8520009,
    TextMapKey = "寻找空中安全的地方！（待包装）",
    TipsStyle = "Common"
  },
  [8520010] = {
    Duration = 13,
    ID = 8520010,
    TextMapKey = "去往最高处，躲避陨石！（待包装）",
    TipsStyle = "Common"
  },
  [8524001] = {
    Duration = 3,
    ID = 8524001,
    TextMapKey = "黑潮涌现（待包装）",
    TipsStyle = "Common"
  },
  [8525001] = {
    Duration = 4,
    ID = 8525001,
    TextMapKey = "超载秒杀（待包装）",
    TipsStyle = "Common"
  },
  [8525002] = {
    Duration = 4,
    ID = 8525002,
    TextMapKey = "大范围激活（待包装）",
    TipsStyle = "Common"
  },
  [8525003] = {
    Duration = 4,
    ID = 8525003,
    TextMapKey = "追踪并激活（待包装）",
    TipsStyle = "Common"
  },
  [8525004] = {
    Duration = 2,
    ID = 8525004,
    TextMapKey = "浪潮（待包装）",
    TipsStyle = "Common"
  },
  [8525005] = {
    Duration = 4,
    ID = 8525005,
    TextMapKey = "十字升级（待包装）",
    TipsStyle = "Common"
  },
  [8525006] = {
    Duration = 4,
    ID = 8525006,
    TextMapKey = "三向激活（待包装）",
    TipsStyle = "Common"
  },
  [8525007] = {
    Duration = 18,
    ID = 8525007,
    TextMapKey = "运动会（待包装）",
    TipsStyle = "Common"
  }
})
