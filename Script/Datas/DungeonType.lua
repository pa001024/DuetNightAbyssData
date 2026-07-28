local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("DungeonType", {
  Capture = {
    Desc = "UI_DUNGEON_DES_CAPTURE_1",
    DungeonType = "Capture",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_06.T_Piano_LevelSelect_06'",
    Name = "UI_DUNGEON_TYPE_CAPTURE",
    RewardViewId = 90004
  },
  Defence = {
    Desc = "UI_DUNGEON_DES_DEFENCE_2",
    DungeonType = "Defence",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_04.T_Piano_LevelSelect_04'",
    Name = "UI_DUNGEON_TYPE_DEFENCE",
    RewardViewId = 90010
  },
  DefencePro = {
    Desc = "UI_DUNGEON_DES_DEFENCEPRO_1",
    DungeonType = "DefencePro",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_04.T_Piano_LevelSelect_04'",
    Name = "UI_DUNGEON_TYPE_DEFENCEPRO",
    RewardViewId = 90010
  },
  Excavation = {
    Desc = "UI_DUNGEON_DES_EXCAVATION_1",
    DungeonType = "Excavation",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_02.T_Piano_LevelSelect_02'",
    Name = "UI_DUNGEON_TYPE_EXCAVATION",
    RewardViewId = 90000
  },
  ExtermPro = {
    Desc = "UI_DUNGEON_DES_TESTING_1",
    DungeonType = "ExtermPro",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_13.T_Piano_LevelSelect_13'",
    Name = "UI_DUNGEON_TYPE_DEF_EXTERMINATE",
    RewardViewId = 90006
  },
  Exterminate = {
    Desc = "UI_DUNGEON_DES_EXTERMINATE_1",
    DungeonType = "Exterminate",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_11.T_Piano_LevelSelect_11'",
    Name = "UI_DUNGEON_TYPE_EXTERMINATE",
    RewardViewId = 90002
  },
  Hijack = {
    Desc = "UI_DUNGEON_DES_HIJACK_1",
    DungeonType = "Hijack",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_08.T_Piano_LevelSelect_08'",
    Name = "UI_DUNGEON_TYPE_HIJACK",
    RewardViewId = 90011
  },
  Rescue = {
    Desc = "UI_DUNGEON_DES_RESCUE_1",
    DungeonType = "Rescue",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_12.T_Piano_LevelSelect_12'",
    Name = "UI_DUNGEON_TYPE_RESCUE",
    RewardViewId = 90009
  },
  Sabotage = {
    Desc = "UI_DUNGEON_DES_SABOTAGE_1",
    DungeonType = "Sabotage",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_07.T_Piano_LevelSelect_07'",
    Name = "UI_DUNGEON_TYPE_SABOTAGE",
    RewardViewId = 90008
  },
  Survival = {
    Desc = "UI_DUNGEON_DES_SURVIVAL_1",
    DungeonType = "Survival",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_03.T_Piano_LevelSelect_03'",
    Name = "UI_DUNGEON_TYPE_SURVIVAL",
    RewardViewId = 90007
  },
  SurvivalPro = {
    Desc = "UI_DUNGEON_DES_SURVIVALPRO_1",
    DungeonType = "SurvivalPro",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_09.T_Piano_LevelSelect_09'",
    Name = "UI_DUNGEON_TYPE_SURVIVALPRO",
    RewardViewId = 90001
  }
})
