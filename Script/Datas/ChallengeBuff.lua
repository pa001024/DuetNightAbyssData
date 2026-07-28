local T = {}
T.RT_1 = {2}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ChallengeBuff", {
  [101] = {
    ActualBuffList = {4020704},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_31",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Weather/T_Activity_AutoChess_Weather_AcidRain.T_Activity_AutoChess_Weather_AcidRain'",
    BuffName = "UI_AutoChess_WeatherName1",
    BuffType = 1,
    ChallengeBuffId = 101,
    DailyChallengeId = 1,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_Acidrain.BP_Activity_Zizouqi_Acidrain"
  },
  [102] = {
    ActualBuffList = {4020708, 4020709},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_32",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Weather/T_Activity_AutoChess_Weather_Dry.T_Activity_AutoChess_Weather_Dry'",
    BuffName = "UI_AutoChess_WeatherName2",
    BuffType = 1,
    ChallengeBuffId = 102,
    DailyChallengeId = 2,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_Dry.BP_Activity_Zizouqi_Dry"
  },
  [103] = {
    ActualBuffList = {4020705},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_33",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Weather/T_Activity_AutoChess_Weather_Sun.T_Activity_AutoChess_Weather_Sun'",
    BuffName = "UI_AutoChess_WeatherName3",
    BuffType = 1,
    ChallengeBuffId = 103,
    DailyChallengeId = 3,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_Sun.BP_Activity_Zizouqi_Sun"
  },
  [104] = {
    ActualBuffList = {4020710, 4020731},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_34",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Weather/T_Activity_AutoChess_Weather_Thunder.T_Activity_AutoChess_Weather_Thunder'",
    BuffName = "UI_AutoChess_WeatherName4",
    BuffType = 1,
    ChallengeBuffId = 104,
    DailyChallengeId = 4,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_ThunderStorm.BP_Activity_Zizouqi_ThunderStorm"
  },
  [105] = {
    ActualBuffList = {4020706, 4020707},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_35",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Weather/T_Activity_AutoChess_Weather_Tornado.T_Activity_AutoChess_Weather_Tornado'",
    BuffName = "UI_AutoChess_WeatherName5",
    BuffType = 1,
    ChallengeBuffId = 105,
    DailyChallengeId = 5,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_Wet.BP_Activity_Zizouqi_Wet"
  },
  [106] = {
    ActualBuffList = {4020711, 4020732},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_36",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Weather/T_Activity_AutoChess_Weather_Wind.T_Activity_AutoChess_Weather_Wind'",
    BuffName = "UI_AutoChess_WeatherName6",
    BuffType = 1,
    ChallengeBuffId = 106,
    DailyChallengeId = 6,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_Storm.BP_Activity_Zizouqi_Storm"
  },
  [201] = {
    ActualBuffList = {4020712},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_37",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Shield.T_Activity_AutoChess_Buff_Shield'",
    BuffName = "UI_AutoChess_WeatherName7",
    BuffType = 2,
    ChallengeBuffId = 201,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1
  },
  [202] = {
    ActualBuffList = {4020713},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_38",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Attack.T_Activity_AutoChess_Buff_Attack'",
    BuffName = "UI_AutoChess_WeatherName8",
    BuffType = 2,
    ChallengeBuffId = 202,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1
  },
  [203] = {
    ActualBuffList = {4020714},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_39",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Defense.T_Activity_AutoChess_Buff_Defense'",
    BuffName = "UI_AutoChess_WeatherName9",
    BuffType = 2,
    ChallengeBuffId = 203,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1
  },
  [204] = {
    ActualBuffList = {4020715},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_40",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Health.T_Activity_AutoChess_Buff_Health'",
    BuffName = "UI_AutoChess_WeatherName10",
    BuffType = 2,
    ChallengeBuffId = 204,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1
  },
  [205] = {
    ActualBuffList = {4020716},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_41",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Break.T_Activity_AutoChess_Buff_Break'",
    BuffName = "UI_AutoChess_WeatherName11",
    BuffType = 2,
    ChallengeBuffId = 205,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1
  },
  [206] = {
    ActualBuffList = {4020717},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_42",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Attack_D.T_Activity_AutoChess_Buff_Attack_D'",
    BuffName = "UI_AutoChess_WeatherName12",
    BuffType = 2,
    ChallengeBuffId = 206,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1
  },
  [207] = {
    ActualBuffList = {4020718},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_43",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Shield_R.T_Activity_AutoChess_Buff_Shield_R'",
    BuffName = "UI_AutoChess_WeatherName13",
    BuffType = 2,
    ChallengeBuffId = 207,
    DifficultyStar = 0,
    EffectiveMissionType = T.RT_1
  },
  [208] = {
    ActualBuffList = {4020719},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_44",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Attack_R.T_Activity_AutoChess_Buff_Attack_R'",
    BuffName = "UI_AutoChess_WeatherName14",
    BuffType = 2,
    ChallengeBuffId = 208,
    DifficultyStar = 1,
    EffectiveMissionType = T.RT_1
  },
  [209] = {
    ActualBuffList = {4020720},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_45",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Defense_R.T_Activity_AutoChess_Buff_Defense_R'",
    BuffName = "UI_AutoChess_WeatherName15",
    BuffType = 2,
    ChallengeBuffId = 209,
    DifficultyStar = 2,
    EffectiveMissionType = T.RT_1
  },
  [210] = {
    ActualBuffList = {4020721},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_46",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Health_R.T_Activity_AutoChess_Buff_Health_R'",
    BuffName = "UI_AutoChess_WeatherName16",
    BuffType = 2,
    ChallengeBuffId = 210,
    DifficultyStar = 2,
    EffectiveMissionType = T.RT_1
  },
  [211] = {
    ActualBuffList = {4020722},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_47",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Break_R.T_Activity_AutoChess_Buff_Break_R'",
    BuffName = "UI_AutoChess_WeatherName17",
    BuffType = 2,
    ChallengeBuffId = 211,
    DifficultyStar = 2,
    EffectiveMissionType = T.RT_1
  },
  [212] = {
    ActualBuffList = {4020723},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_48",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Survival.T_Activity_AutoChess_Buff_Survival'",
    BuffName = "UI_AutoChess_WeatherName18",
    BuffType = 2,
    ChallengeBuffId = 212,
    DifficultyStar = 2,
    EffectiveMissionType = T.RT_1
  },
  [213] = {
    ActualBuffList = {4020724},
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_49",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Survival.T_Activity_AutoChess_Buff_Survival'",
    BuffName = "UI_AutoChess_WeatherName19",
    BuffType = 2,
    ChallengeBuffId = 213,
    DifficultyStar = 4,
    EffectiveMissionType = T.RT_1
  },
  [301] = {
    AutoChessFormatId = 99001,
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_50",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Spring.T_Activity_AutoChess_Buff_Spring'",
    BuffName = "UI_AutoChess_WeatherName20",
    BuffType = 3,
    ChallengeBuffId = 301,
    DifficultyStar = 1,
    EffectiveMissionType = T.RT_1
  },
  [302] = {
    AutoChessFormatId = 99002,
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_51",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Lava.T_Activity_AutoChess_Buff_Lava'",
    BuffName = "UI_AutoChess_WeatherName21",
    BuffType = 3,
    ChallengeBuffId = 302,
    DifficultyStar = 1,
    EffectiveMissionType = T.RT_1
  },
  [303] = {
    AutoChessFormatId = 99003,
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_52",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Wind.T_Activity_AutoChess_Buff_Wind'",
    BuffName = "UI_AutoChess_WeatherName22",
    BuffType = 3,
    ChallengeBuffId = 303,
    DifficultyStar = 1,
    EffectiveMissionType = T.RT_1
  },
  [304] = {
    AutoChessFormatId = 99004,
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_53",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Energy.T_Activity_AutoChess_Buff_Energy'",
    BuffName = "UI_AutoChess_WeatherName23",
    BuffType = 3,
    ChallengeBuffId = 304,
    DifficultyStar = 1,
    EffectiveMissionType = T.RT_1
  },
  [305] = {
    AutoChessFormatId = 99005,
    BuffDesc = "UI_AutoChess_ExtraBuffDesc_54",
    BuffIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/Buff/T_Activity_AutoChess_Buff_Frog.T_Activity_AutoChess_Buff_Frog'",
    BuffName = "UI_AutoChess_WeatherName24",
    BuffType = 3,
    ChallengeBuffId = 305,
    DifficultyStar = 3,
    EffectiveMissionType = T.RT_1
  }
})
