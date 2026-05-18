local T = {}
T.RT_1 = {
  Path = "WidgetBlueprint'/Game/UI/WBP/Dungeon/Defense/WBP_Dungeon_DefenseWaveStart.WBP_Dungeon_DefenseWaveStart'"
}
T.RT_2 = {
  Path = "WidgetBlueprint'/Game/UI/WBP/Dungeon/Defense/WBP_Dungeon_DefenseCountDown.WBP_Dungeon_DefenseCountDown'"
}
T.RT_3 = {
  [1] = T.RT_1,
  [2] = T.RT_2
}
T.RT_4 = {
  Path = "WidgetBlueprint'/Game/UI/WBP/Dungeon/Excavation/WBP_Dungeon_ExcavationToast_New.WBP_Dungeon_ExcavationToast_New'"
}
T.RT_5 = {
  [1] = T.RT_4
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CommonAssetByDungeon", {
  [1] = {
    AssetPath = {
      [1] = {
        Path = "/Game/AssetDesign/AI/Z_Misc_Test/BT/TestNew.TestNew"
      }
    },
    DungeonId = 1
  },
  [20002] = {
    AssetPath = T.RT_3,
    DungeonId = 20002
  },
  [30101] = {
    AssetPath = T.RT_3,
    DungeonId = 30101
  },
  [30102] = {
    AssetPath = T.RT_3,
    DungeonId = 30102
  },
  [30103] = {
    AssetPath = T.RT_3,
    DungeonId = 30103
  },
  [30104] = {
    AssetPath = T.RT_3,
    DungeonId = 30104
  },
  [30105] = {
    AssetPath = T.RT_3,
    DungeonId = 30105
  },
  [30106] = {
    AssetPath = T.RT_3,
    DungeonId = 30106
  },
  [30107] = {
    AssetPath = T.RT_3,
    DungeonId = 30107
  },
  [30108] = {
    AssetPath = T.RT_3,
    DungeonId = 30108
  },
  [60101] = {
    AssetPath = T.RT_3,
    DungeonId = 60101
  },
  [60102] = {
    AssetPath = T.RT_3,
    DungeonId = 60102
  },
  [62101] = {
    AssetPath = T.RT_3,
    DungeonId = 62101
  },
  [62102] = {
    AssetPath = T.RT_3,
    DungeonId = 62102
  },
  [64101] = {
    AssetPath = T.RT_3,
    DungeonId = 64101
  },
  [64102] = {
    AssetPath = T.RT_3,
    DungeonId = 64102
  },
  [90102] = {
    AssetPath = T.RT_3,
    DungeonId = 90102
  },
  [90104] = {
    AssetPath = T.RT_3,
    DungeonId = 90104
  },
  [90106] = {
    AssetPath = T.RT_3,
    DungeonId = 90106
  },
  [90108] = {
    AssetPath = T.RT_3,
    DungeonId = 90108
  },
  [90110] = {
    AssetPath = T.RT_3,
    DungeonId = 90110
  },
  [90112] = {
    AssetPath = T.RT_3,
    DungeonId = 90112
  },
  [90114] = {
    AssetPath = T.RT_3,
    DungeonId = 90114
  },
  [90201] = {
    AssetPath = T.RT_5,
    DungeonId = 90201
  },
  [90202] = {
    AssetPath = T.RT_5,
    DungeonId = 90202
  },
  [90203] = {
    AssetPath = T.RT_5,
    DungeonId = 90203
  },
  [90204] = {
    AssetPath = T.RT_5,
    DungeonId = 90204
  },
  [90205] = {
    AssetPath = T.RT_5,
    DungeonId = 90205
  },
  [90206] = {
    AssetPath = T.RT_5,
    DungeonId = 90206
  },
  [90207] = {
    AssetPath = T.RT_5,
    DungeonId = 90207
  },
  [91134] = {
    AssetPath = T.RT_3,
    DungeonId = 91134
  },
  [91135] = {
    AssetPath = T.RT_3,
    DungeonId = 91135
  },
  [91146] = {
    AssetPath = T.RT_3,
    DungeonId = 91146
  },
  [91147] = {
    AssetPath = T.RT_3,
    DungeonId = 91147
  },
  [91150] = {
    AssetPath = T.RT_3,
    DungeonId = 91150
  },
  [91183] = {
    AssetPath = T.RT_3,
    DungeonId = 91183
  },
  [91184] = {
    AssetPath = T.RT_3,
    DungeonId = 91184
  },
  [91187] = {
    AssetPath = T.RT_3,
    DungeonId = 91187
  },
  [91208] = {
    AssetPath = T.RT_3,
    DungeonId = 91208
  },
  [91209] = {
    AssetPath = T.RT_3,
    DungeonId = 91209
  },
  [91212] = {
    AssetPath = T.RT_3,
    DungeonId = 91212
  },
  [91213] = {
    AssetPath = T.RT_3,
    DungeonId = 91213
  }
})
