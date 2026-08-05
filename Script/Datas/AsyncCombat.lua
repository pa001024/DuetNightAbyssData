local T = {}
T.RT_1 = {
  4,
  9,
  10
}
T.RT_2 = {
  8513602,
  8522602,
  8500602,
  8515602,
  8501602,
  8509603,
  8514602,
  8521602,
  8505603,
  8512603
}
T.RT_3 = {
  8513603,
  8522603,
  8500603,
  8515603,
  8501603,
  8509604,
  8514603,
  8521603,
  8505604,
  8512604
}
T.RT_4 = {
  8513604,
  8522604,
  8500604,
  8515604,
  8501604,
  8509605,
  8514604,
  8521604,
  8505605,
  8512605
}
T.RT_5 = {
  8513605,
  8522605,
  8500605,
  8515605,
  8501605,
  8509606,
  8514605,
  8521605,
  8505606,
  8512606
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AsyncCombat", {
  [1] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_2,
    Count = 80000,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40601,
    ID = 101,
    Key = 1,
    Level = 50,
    Type = "Resource"
  },
  [2] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_3,
    Count = 160000,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40602,
    ID = 101,
    Key = 2,
    Level = 70,
    Type = "Resource"
  },
  [3] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_4,
    Count = 280000,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40603,
    ID = 101,
    Key = 3,
    Level = 90,
    Type = "Resource"
  },
  [4] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_5,
    Count = 400000,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40604,
    ID = 101,
    Key = 4,
    Level = 110,
    Type = "Resource"
  },
  [5] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_2,
    Count = 4320,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40601,
    ID = 102,
    Key = 5,
    Level = 50,
    Type = "Resource"
  },
  [6] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_3,
    Count = 8460,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40602,
    ID = 102,
    Key = 6,
    Level = 70,
    Type = "Resource"
  },
  [7] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_4,
    Count = 15120,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40603,
    ID = 102,
    Key = 7,
    Level = 90,
    Type = "Resource"
  },
  [8] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_5,
    Count = 21600,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40604,
    ID = 102,
    Key = 8,
    Level = 110,
    Type = "Resource"
  },
  [9] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_2,
    Count = 40,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40601,
    ID = 20013,
    Key = 9,
    Level = 50,
    Type = "Resource"
  },
  [10] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_3,
    Count = 80,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40602,
    ID = 20013,
    Key = 10,
    Level = 70,
    Type = "Resource"
  },
  [11] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_4,
    Count = 140,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40603,
    ID = 20013,
    Key = 11,
    Level = 90,
    Type = "Resource"
  },
  [12] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_5,
    Count = 200,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40604,
    ID = 20013,
    Key = 12,
    Level = 110,
    Type = "Resource"
  },
  [13] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_2,
    Count = 30,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40601,
    ID = 2013,
    Key = 13,
    Level = 50,
    Type = "Resource"
  },
  [14] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_3,
    Count = 60,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40602,
    ID = 2013,
    Key = 14,
    Level = 70,
    Type = "Resource"
  },
  [15] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_4,
    Count = 90,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40603,
    ID = 2013,
    Key = 15,
    Level = 90,
    Type = "Resource"
  },
  [16] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_5,
    Count = 135,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40604,
    ID = 2013,
    Key = 16,
    Level = 110,
    Type = "Resource"
  },
  [17] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_2,
    Count = 45,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40601,
    ID = 2009,
    Key = 17,
    Level = 50,
    Type = "Resource"
  },
  [18] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_3,
    Count = 90,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40602,
    ID = 2009,
    Key = 18,
    Level = 70,
    Type = "Resource"
  },
  [19] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_4,
    Count = 135,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40603,
    ID = 2009,
    Key = 19,
    Level = 90,
    Type = "Resource"
  },
  [20] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_5,
    Count = 200,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40604,
    ID = 2009,
    Key = 20,
    Level = 110,
    Type = "Resource"
  },
  [21] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_2,
    Count = 30,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40601,
    ID = 211,
    Key = 21,
    Level = 50,
    Type = "Resource"
  },
  [22] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_3,
    Count = 60,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40602,
    ID = 211,
    Key = 22,
    Level = 70,
    Type = "Resource"
  },
  [23] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_4,
    Count = 100,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40603,
    ID = 211,
    Key = 23,
    Level = 90,
    Type = "Resource"
  },
  [24] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_5,
    Count = 150,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40604,
    ID = 211,
    Key = 24,
    Level = 110,
    Type = "Resource"
  },
  [25] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_2,
    Count = 20,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40601,
    ID = 110061,
    Invalid = true,
    Key = 25,
    Level = 50,
    Type = "Resource"
  },
  [26] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_3,
    Count = 30,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40602,
    ID = 110061,
    Invalid = true,
    Key = 26,
    Level = 70,
    Type = "Resource"
  },
  [27] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_4,
    Count = 50,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40603,
    ID = 110061,
    Invalid = true,
    Key = 27,
    Level = 90,
    Type = "Resource"
  },
  [28] = {
    BossCreatorID = 1001,
    BossRound = T.RT_1,
    BossUnitID = T.RT_5,
    Count = 75,
    DungeonBuff = "0:2500101,40:2500102,80:2500103,120:2500104,160:2500105",
    DungeonID = 40604,
    ID = 110061,
    Invalid = true,
    Key = 28,
    Level = 110,
    Type = "Resource"
  }
})
