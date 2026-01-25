local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("EventTab", {
  [1] = {
    EventId = {103001},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_RougeJump.T_Activity_Tab_Head_RougeJump",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_Rouge.T_Activity_Tab_Sign_Rouge",
    EventTabId = 1,
    EventTabName = "Event_Tab_103001",
    ReddotNode = "Acti_Rouge",
    Sequence = 50
  },
  [2] = {
    EventId = {101001},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_SevenDaySaiqi.T_Activity_Tab_Head_SevenDaySaiqi",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_SevenDaySaiqi.T_Activity_Tab_Sign_SevenDaySaiqi",
    EventTabId = 2,
    EventTabName = "Event_Tab_101001",
    ReddotNode = "Acti_SignInSaiqi",
    Sequence = 100
  },
  [4] = {
    EventId = {103002},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_Abyss.T_Activity_Tab_Head_Abyss",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_Abyss.T_Activity_Tab_Sign_Abyss",
    EventTabId = 4,
    EventTabName = "Abyss_entry",
    ReddotNode = "Acti_Abyss01",
    Sequence = 55
  },
  [6] = {
    EventId = {103003},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TryOut_Aote.T_Activity_Tab_Head_TryOut_Aote",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TryOut_Aote.T_Activity_Tab_Sign_TryOut_Aote",
    EventTabId = 6,
    EventTabName = "Event_Tab_103003",
    ReddotNode = "Acti_GiveAoge",
    Sequence = 70
  },
  [7] = {
    EventId = {103004},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TryOut_Dafu.T_Activity_Tab_Head_TryOut_Dafu",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TryOut_Dafu.T_Activity_Tab_Sign_TryOut_Dafu",
    EventTabId = 7,
    EventTabName = "Event_Tab_103004",
    ReddotNode = "Acti_GiveDafunie",
    Sequence = 65
  },
  [8] = {
    EventId = {105001},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_RechargeRebate.T_Activity_Tab_Head_RechargeRebate",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_RechargeRebate.T_Activity_Tab_Head_RechargeRebate",
    EventTabId = 8,
    EventTabName = "Event_Tab_105001",
    Sequence = 65
  },
  [9] = {
    EventId = {103005},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_ZhiLiu.T_Activity_Tab_Head_ZhiLiu",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_Zhiliu.T_Activity_Tab_Sign_Zhiliu",
    EventTabId = 9,
    EventTabName = "Event_Tab_103005",
    ReddotNode = "Acti_ZhiliuEvent",
    Sequence = 93
  },
  [10] = {
    EventId = {106001},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TrainingLevel.T_Activity_Tab_Head_TrainingLevel",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TrainingLevel.T_Activity_Tab_Sign_TrainingLevel",
    EventTabId = 10,
    EventTabName = "Event_Tab_106001",
    ReddotNode = "Acti_ChallengeLevel",
    Sequence = 86
  },
  [11] = {
    EventId = {
      105102011,
      105102012,
      105102013
    },
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TryOut_Saiqi01.T_Activity_Tab_Head_TryOut_Saiqi01",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TryOut_Saiqi01.T_Activity_Tab_Sign_TryOut_Saiqi01",
    EventTabId = 11,
    EventTabName = "Event_Tab_105102011",
    ReddotNode = "Acti_TrailSkin01",
    Sequence = 85
  },
  [12] = {
    EventId = {103006},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_JJGame.T_Activity_Tab_Head_JJGame",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_JJGame.T_Activity_Tab_Sign_JJGame",
    EventTabId = 12,
    EventTabName = "Event_Tab_103006",
    ReddotNode = "Acti_MidTerm",
    Sequence = 91
  },
  [13] = {
    EventId = {105101013},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TryOut_Baiheng.T_Activity_Tab_Head_TryOut_Baiheng",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TryOut_Baiheng.T_Activity_Tab_Sign_TryOut_Baiheng",
    EventTabId = 13,
    EventTabName = "Event_Tab_CharTrialEvent",
    ReddotNode = "Acti_TrailFuShuChar",
    Sequence = 94
  },
  [14] = {
    EventId = {105101014},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TryOut_Feina.T_Activity_Tab_Head_TryOut_Feina",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TryOut_Feina.T_Activity_Tab_Sign_TryOut_Feina",
    EventTabId = 14,
    EventTabName = "Event_Tab_CharTrialEvent",
    ReddotNode = "Acti_TrailFeinaChar",
    Sequence = 85
  },
  [15] = {
    EventId = {101002},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_SevenDayBaiheng.T_Activity_Tab_Head_SevenDayBaiheng",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_SevenDayBaiheng.T_Activity_Tab_Sign_SevenDayBaiheng",
    EventTabId = 15,
    EventTabName = "Event_Tab_101002",
    ReddotNode = "Acti_SignInFuShu",
    Sequence = 100
  },
  [16] = {
    EventId = {103007},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_Fort.T_Activity_Tab_Head_Fort",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_Fort.T_Activity_Tab_Sign_Fort",
    EventTabId = 16,
    EventTabName = "Event_Tab_103007",
    ReddotNode = "Acti_PaoTaiTab",
    Sequence = 92
  },
  [17] = {
    EventId = {103008},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_SevenDaySign.T_Activity_Tab_Head_SevenDaySign",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_CommunityFollow.T_Activity_Tab_Sign_CommunityFollow",
    EventTabId = 17,
    EventTabName = "Event_Tab_103008",
    ReddotNode = "Acti_Community",
    Sequence = 45
  },
  [18] = {
    EventId = {107001},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TenTimesRewards.T_Activity_Tab_Head_TenTimesRewards",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TenTimesRewards.T_Activity_Tab_Sign_TenTimesRewards",
    EventTabId = 18,
    EventTabName = "Event_Tab_107001",
    ReddotNode = "Acti_BetaAward",
    Sequence = 98
  },
  [19] = {
    EventId = {103009001},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_DoubleMod.T_Activity_Tab_Head_DoubleMod",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_DoubleMod.T_Activity_Tab_Sign_DoubleMod",
    EventTabId = 19,
    EventTabName = "Event_Tab_103009001",
    ReddotNode = "Acti_DobuleMod",
    Sequence = 91
  },
  [21] = {
    EventId = {107002},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_LoginReward.T_Activity_Tab_Head_LoginReward",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_LoginReward.T_Activity_Tab_Sign_LoginReward",
    EventTabId = 21,
    EventTabName = "Event_Tab_107002",
    ReddotNode = "Acti_MultiDeviceLogin",
    Sequence = 40
  },
  [22] = {
    EventId = {102001},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_East_Season01.T_Activity_Tab_Head_East_Season01",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_East_Season01.T_Activity_Tab_Sign_East_Season01",
    EventTabId = 22,
    EventTabName = "Event_Tab_102001",
    ReddotNode = "Acti_DongGuo",
    Sequence = 88
  },
  [23] = {
    EventId = {108001},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_Temple_Solo.T_Activity_Tab_Head_Temple_Solo",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_Temple_Solo.T_Activity_Tab_Sign_Temple_Solo",
    EventTabId = 23,
    EventTabName = "Event_Tab_108001",
    ReddotNode = "Acti_TempleTab",
    Sequence = 91
  },
  [24] = {
    EventId = {103010},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_FeinaEvent.T_Activity_Tab_Head_FeinaEvent",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_FeinaEvent.T_Activity_Tab_Sign_FeinaEvent",
    EventTabId = 24,
    EventTabName = "Event_Tab_103010",
    ReddotNode = "Acti_FeinaEvent",
    Sequence = 95
  },
  [25] = {
    EventId = {103011},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_Theater.T_Activity_Tab_Head_Theater",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_Theater.T_Activity_Tab_Sign_Theater",
    EventTabId = 25,
    EventTabName = "Event_Tab_103011",
    ReddotNode = "Acti_Theater",
    Sequence = 89
  },
  [26] = {
    EventId = {101003},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_SevenDayFeiNa.T_Activity_Tab_Head_SevenDayFeiNa",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_SevenDayFeiNa.T_Activity_Tab_Sign_SevenDayFeiNa",
    EventTabId = 26,
    EventTabName = "Event_Tab_101003",
    ReddotNode = "Acti_SignInFeina",
    Sequence = 100
  },
  [27] = {
    EventId = {103012},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TryOut_Baonu.T_Activity_Tab_Head_TryOut_Baonu",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TryOut_Baonu.T_Activity_Tab_Sign_TryOut_Baonu",
    EventTabId = 27,
    EventTabName = "Event_Tab_103012",
    ReddotNode = "Acti_GiveBaonu",
    Sequence = 60
  },
  [28] = {
    EventId = {1030022},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_Abyss.T_Activity_Tab_Head_Abyss",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_Abyss.T_Activity_Tab_Sign_Abyss",
    EventTabId = 28,
    EventTabName = "Abyss_entry",
    ReddotNode = "Acti_Abyss02",
    Sequence = 55
  },
  [29] = {
    EventId = {103013},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TryOut_Songlu.T_Activity_Tab_Head_TryOut_Songlu",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TryOut_Songlu.T_Activity_Tab_Sign_TryOut_Songlu",
    EventTabId = 29,
    EventTabName = "Event_Tab_103013",
    ReddotNode = "Acti_GiveSonglu",
    Sequence = 75
  },
  [30] = {
    EventId = {107003},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_CoopOnline.T_Activity_Tab_Head_CoopOnline",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_CoopOnline.T_Activity_Tab_Sign_CoopOnline",
    EventTabId = 30,
    EventTabName = "Event_Tab_107003",
    ReddotNode = "Acti_RegionOnline",
    Sequence = 80
  },
  [32] = {
    EventId = {111001},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_GuildWar.T_Activity_Tab_Head_GuildWar",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_GuildWar.T_Activity_Tab_Sign_GuildWar",
    EventTabId = 32,
    EventTabName = "Event_Raid_Title",
    ReddotNode = "Acti_SoloRaid",
    Sequence = 93
  },
  [33] = {
    EventId = {101004},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_Warmup.T_Activity_Tab_Head_Warmup",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_Warmup.T_Activity_Tab_Sign_Warmup",
    EventTabId = 33,
    EventTabName = "Event_Tab_101004",
    ReddotNode = "Acti_SignIn11",
    Sequence = 90
  },
  [35] = {
    EventId = {105102014},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TryOut_Baiheng01.T_Activity_Tab_Head_TryOut_Baiheng01",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TryOut_Baiheng01.T_Activity_Tab_Sign_TryOut_Baiheng01",
    EventTabId = 35,
    EventTabName = "Event_Tab_105102014",
    ReddotNode = "Acti_TrailFuShuSkin01",
    Sequence = 95
  },
  [36] = {
    EventId = {101005},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_SevenDayKezhou.T_Activity_Tab_Head_SevenDayKezhou",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_SevenDayKezhou.T_Activity_Tab_Sign_SevenDayKezhou",
    EventTabId = 36,
    EventTabName = "Event_Tab_101005",
    ReddotNode = "Acti_SignInKezhou",
    Sequence = 100
  },
  [37] = {
    EventId = {105101015},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TryOut_Kezhou.T_Activity_Tab_Head_TryOut_Kezhou",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_TryOut_Kezhou.T_Activity_Tab_Sign_TryOut_Kezhou",
    EventTabId = 37,
    EventTabName = "Event_Tab_CharTrialEvent",
    ReddotNode = "Acti_TrailKezhouChar",
    Sequence = 94
  },
  [38] = {
    EventId = {1030023},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_Abyss.T_Activity_Tab_Head_Abyss",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_Abyss.T_Activity_Tab_Sign_Abyss",
    EventTabId = 38,
    EventTabName = "Abyss_entry",
    ReddotNode = "Acti_Abyss02",
    Sequence = 55
  },
  [39] = {
    EventId = {1030024},
    EventTabBg = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_Abyss.T_Activity_Tab_Head_Abyss",
    EventTabIcon = "/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Sign_Abyss.T_Activity_Tab_Sign_Abyss",
    EventTabId = 39,
    EventTabName = "Abyss_entry",
    ReddotNode = "Acti_Abyss02",
    Sequence = 55
  }
})
