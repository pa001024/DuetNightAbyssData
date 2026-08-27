local T = {}
T.RT_1 = {
  2000,
  3000,
  4000
}
T.RT_2 = {
  4400,
  6600,
  8800
}
T.RT_3 = {
  1600,
  2400,
  3200
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("BackpackPuzzleLevel", {
  [10301501] = {
    EventId = 103015,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301501",
    LevelId = 10301501,
    LevelInitialItem = {
      304,
      308,
      301
    },
    LevelName = "BackpackEventTitle_10301501",
    TargetReward = {
      113001,
      113002,
      113003
    },
    TargetScore = {
      1200,
      1800,
      2400
    }
  },
  [10301502] = {
    EventId = 103015,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 2, 2, 2, 1, 0, 0, 0],
[0, 0, 0, 2, 2, 2, 1, 0, 0, 0],
[0, 0, 0, 2, 2, 2, 2, 0, 0, 0],
[0, 0, 0, 2, 2, 2, 2, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301502",
    LevelId = 10301502,
    LevelInitialItem = {
      105,
      308,
      301,
      301
    },
    LevelName = "BackpackEventTitle_10301502",
    TargetReward = {
      113004,
      113005,
      113006
    },
    TargetScore = {
      1400,
      2100,
      2800
    }
  },
  [10301503] = {
    EventId = 103015,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 1, 2, 2, 2, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301503",
    LevelId = 10301503,
    LevelInitialItem = {
      111,
      110,
      301,
      303
    },
    LevelName = "BackpackEventTitle_10301503",
    TargetReward = {
      113007,
      113008,
      113009
    },
    TargetScore = {
      1700,
      2550,
      3400
    }
  },
  [10301504] = {
    EventId = 103015,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 1, 1, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 1, 2, 2, 2, 2, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301504",
    LevelId = 10301504,
    LevelInitialItem = {
      303,
      303,
      308,
      302,
      302,
      306
    },
    LevelName = "BackpackEventTitle_10301504",
    TargetReward = {
      113010,
      113011,
      113012
    },
    TargetScore = T.RT_1,
    UnlockDate = LocalTimeProxy(1779415200)
  },
  [10301505] = {
    EventId = 103015,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 2, 2, 2, 1, 1, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 1, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301505",
    LevelId = 10301505,
    LevelInitialItem = {
      301,
      301,
      301,
      105,
      312,
      312,
      102
    },
    LevelName = "BackpackEventTitle_10301505",
    TargetReward = {
      113013,
      113014,
      113015
    },
    TargetScore = {
      2500,
      3750,
      5000
    },
    UnlockDate = LocalTimeProxy(1779415200)
  },
  [10301506] = {
    EventId = 103015,
    GridDistribute = [=[
[0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
[0, 1, 2, 2, 2, 2, 2, 2, 1, 0],
[0, 1, 2, 2, 2, 2, 2, 2, 1, 0],
[0, 1, 2, 2, 1, 1, 2, 2, 1, 0],
[0, 1, 2, 2, 1, 1, 2, 2, 1, 0],
[0, 1, 2, 2, 2, 2, 2, 2, 1, 0],
[0, 1, 2, 2, 2, 2, 2, 2, 1, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301506",
    LevelId = 10301506,
    LevelInitialItem = {
      111,
      107,
      304,
      301,
      301,
      303,
      303
    },
    LevelName = "BackpackEventTitle_10301506",
    TargetReward = {
      113016,
      113017,
      113018
    },
    TargetScore = {
      2800,
      4200,
      5600
    },
    UnlockDate = LocalTimeProxy(1779415200)
  },
  [10301507] = {
    EventId = 103015,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 2, 2, 2, 1, 1, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301507",
    LevelId = 10301507,
    LevelInitialItem = {
      105,
      102,
      109,
      111,
      201,
      201,
      201,
      201
    },
    LevelName = "BackpackEventTitle_10301507",
    TargetReward = {
      113019,
      113020,
      113021
    },
    TargetScore = {
      3300,
      4950,
      6600
    },
    UnlockDate = LocalTimeProxy(1779501600)
  },
  [10301508] = {
    EventId = 103015,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301508",
    LevelId = 10301508,
    LevelInitialItem = {
      301,
      301,
      312,
      302,
      102,
      102,
      201,
      201,
      201,
      201
    },
    LevelName = "BackpackEventTitle_10301508",
    TargetReward = {
      113022,
      113023,
      113024
    },
    TargetScore = {
      3500,
      5250,
      7000
    },
    UnlockDate = LocalTimeProxy(1779501600)
  },
  [10301509] = {
    EventId = 103015,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301509",
    LevelId = 10301509,
    LevelInitialItem = {
      301,
      111,
      105,
      105,
      303,
      303,
      102,
      308,
      312,
      201,
      201,
      201,
      201
    },
    LevelName = "BackpackEventTitle_10301509",
    TargetReward = {
      113025,
      113026,
      113027
    },
    TargetScore = T.RT_2,
    UnlockDate = LocalTimeProxy(1779501600)
  },
  [10301510] = {
    EventId = 103015,
    GridDistribute = [=[
[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
[1, 1, 2, 2, 1, 1, 2, 2, 1, 1],
[1, 2, 2, 2, 2, 2, 2, 2, 2, 1],
[1, 2, 2, 2, 2, 2, 2, 2, 2, 1],
[1, 2, 2, 2, 2, 2, 2, 2, 2, 1],
[1, 1, 2, 2, 2, 2, 2, 2, 1, 1],
[1, 1, 1, 2, 2, 2, 2, 1, 1, 1],
[1, 1, 1, 1, 2, 2, 1, 1, 1, 1]]=],
    LevelDes = "BackpackEventDes_10301510",
    LevelId = 10301510,
    LevelInitialItem = {
      309,
      304,
      102,
      301,
      302,
      107,
      312,
      201,
      201
    },
    LevelName = "BackpackEventTitle_10301510",
    TargetReward = {
      113028,
      113029,
      113030
    },
    TargetScore = {
      4500,
      6750,
      9000
    },
    UnlockDate = LocalTimeProxy(1779588000)
  },
  [10301511] = {
    EventId = 103015,
    GridDistribute = [=[
[1, 2, 2, 2, 2, 2, 2, 2, 1, 0],
[1, 1, 2, 2, 2, 2, 2, 1, 1, 0],
[1, 1, 1, 2, 2, 2, 1, 1, 1, 0],
[1, 1, 1, 1, 2, 1, 1, 1, 1, 0],
[1, 1, 1, 2, 2, 2, 1, 1, 1, 0],
[1, 1, 2, 2, 2, 2, 2, 1, 1, 0],
[1, 2, 2, 2, 2, 2, 2, 2, 1, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301511",
    LevelId = 10301511,
    LevelInitialItem = {
      306,
      304,
      304,
      305,
      305,
      201,
      201,
      303,
      303,
      303
    },
    LevelName = "BackpackEventTitle_10301511",
    TargetReward = {
      113031,
      113032,
      113033
    },
    TargetScore = {
      3400,
      5100,
      6800
    },
    UnlockDate = LocalTimeProxy(1779588000)
  },
  [10301512] = {
    EventId = 103015,
    GridDistribute = [=[
[0, 0, 0, 1, 1, 1, 1, 0, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 1, 2, 1, 2, 2, 1, 2, 1, 0],
[0, 1, 2, 2, 2, 2, 2, 2, 1, 0],
[0, 1, 2, 1, 2, 2, 1, 2, 1, 0],
[0, 1, 2, 2, 1, 1, 2, 2, 1, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 0, 1, 1, 1, 1, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301512",
    LevelId = 10301512,
    LevelInitialItem = {
      308,
      102,
      302,
      302,
      301,
      301,
      201,
      201
    },
    LevelName = "BackpackEventTitle_10301512",
    TargetReward = {
      113034,
      113035,
      113036
    },
    TargetScore = {
      2900,
      4350,
      5800
    },
    UnlockDate = LocalTimeProxy(1779588000)
  },
  [10303201] = {
    EventId = 103032,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301501",
    LevelId = 10303201,
    LevelInitialItem = {
      304,
      308,
      308,
      301
    },
    LevelName = "BackpackEventTitle_10301501",
    TargetReward = {
      1030320101,
      1030320102,
      1030320103
    },
    TargetScore = T.RT_3
  },
  [10303202] = {
    EventId = 103032,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 2, 2, 2, 2, 0, 0, 0],
[0, 0, 0, 2, 2, 2, 2, 0, 0, 0],
[0, 0, 0, 2, 2, 2, 2, 0, 0, 0],
[0, 0, 0, 2, 2, 2, 2, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301502",
    LevelId = 10303202,
    LevelInitialItem = {
      105,
      308,
      301,
      301,
      201
    },
    LevelName = "BackpackEventTitle_10301502",
    TargetReward = {
      1030320201,
      1030320202,
      1030320203
    },
    TargetScore = T.RT_3
  },
  [10303203] = {
    EventId = 103032,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301503",
    LevelId = 10303203,
    LevelInitialItem = {
      111,
      109,
      110
    },
    LevelName = "BackpackEventTitle_10301503",
    TargetReward = {
      1030320301,
      1030320302,
      1030320303
    },
    TargetScore = {
      1800,
      2700,
      3600
    }
  },
  [10303204] = {
    EventId = 103032,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301504",
    LevelId = 10303204,
    LevelInitialItem = {
      301,
      301,
      304,
      111
    },
    LevelName = "BackpackEventTitle_10301504",
    TargetReward = {
      1030320401,
      1030320402,
      1030320403
    },
    TargetScore = {
      2600,
      3200,
      3800
    },
    UnlockDate = LocalTimeProxy(1790906400)
  },
  [10303205] = {
    EventId = 103032,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 2, 2, 2, 1, 1, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 1, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301505",
    LevelId = 10303205,
    LevelInitialItem = {
      301,
      301,
      301,
      108,
      310,
      312
    },
    LevelName = "BackpackEventTitle_10301505",
    TargetReward = {
      1030320501,
      1030320502,
      1030320503
    },
    TargetScore = {
      3200,
      4000,
      5600
    },
    UnlockDate = LocalTimeProxy(1790906400)
  },
  [10303206] = {
    EventId = 103032,
    GridDistribute = [=[
[0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
[0, 1, 2, 2, 2, 2, 2, 2, 1, 0],
[0, 1, 2, 2, 2, 2, 2, 2, 1, 0],
[0, 1, 2, 2, 1, 1, 2, 2, 1, 0],
[0, 1, 2, 2, 1, 1, 2, 2, 1, 0],
[0, 1, 2, 2, 2, 2, 2, 2, 1, 0],
[0, 1, 2, 2, 2, 2, 2, 2, 1, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301506",
    LevelId = 10303206,
    LevelInitialItem = {
      309,
      201,
      201,
      111,
      301,
      301,
      302,
      302,
      303,
      303
    },
    LevelName = "BackpackEventTitle_10301506",
    TargetReward = {
      1030320601,
      1030320602,
      1030320603
    },
    TargetScore = {
      4000,
      6000,
      8000
    },
    UnlockDate = LocalTimeProxy(1790906400)
  },
  [10303207] = {
    EventId = 103032,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 2, 2, 2, 1, 1, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301507",
    LevelId = 10303207,
    LevelInitialItem = {
      101,
      310,
      308,
      201
    },
    LevelName = "BackpackEventTitle_10301507",
    TargetReward = {
      1030320701,
      1030320702,
      1030320703
    },
    TargetScore = {
      3600,
      4500,
      5400
    },
    UnlockDate = LocalTimeProxy(1790992800)
  },
  [10303208] = {
    EventId = 103032,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301508",
    LevelId = 10303208,
    LevelInitialItem = {
      107,
      109,
      102,
      304,
      201,
      201,
      201,
      201,
      201
    },
    LevelName = "BackpackEventTitle_10301508",
    TargetReward = {
      1030320801,
      1030320802,
      1030320803
    },
    TargetScore = {
      5000,
      6000,
      7000
    },
    UnlockDate = LocalTimeProxy(1790992800)
  },
  [10303209] = {
    EventId = 103032,
    GridDistribute = [=[
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 2, 2, 2, 2, 2, 2, 0, 0],
[0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]=],
    LevelDes = "BackpackEventDes_10301509",
    LevelId = 10303209,
    LevelInitialItem = {
      102,
      102,
      304,
      305,
      309,
      201,
      201
    },
    LevelName = "BackpackEventTitle_10301509",
    TargetReward = {
      1030320901,
      1030320902,
      1030320903
    },
    TargetScore = T.RT_2,
    UnlockDate = LocalTimeProxy(1790992800)
  },
  [10303210] = {
    EventId = 103032,
    GridDistribute = [=[
[1, 1, 2, 2, 2, 2, 1, 1, 1, 1],
[1, 1, 2, 2, 2, 2, 2, 1, 1, 1],
[1, 1, 2, 1, 1, 1, 2, 1, 1, 1],
[1, 1, 2, 1, 1, 1, 2, 1, 1, 1],
[1, 1, 2, 1, 1, 1, 2, 1, 1, 1],
[1, 1, 2, 1, 1, 1, 2, 1, 1, 1],
[1, 1, 2, 2, 2, 2, 2, 1, 1, 1],
[1, 1, 2, 2, 2, 2, 1, 1, 1, 1]]=],
    LevelDes = "BackpackEventDes_10301510",
    LevelId = 10303210,
    LevelInitialItem = {
      111,
      111,
      312,
      312,
      308
    },
    LevelName = "BackpackEventTitle_10301510",
    TargetReward = {
      1030321001,
      1030321002,
      1030321003
    },
    TargetScore = {
      4000,
      4600,
      5200
    },
    UnlockDate = LocalTimeProxy(1791079200)
  },
  [10303211] = {
    EventId = 103032,
    GridDistribute = [=[
[1, 1, 2, 1, 1, 1, 1, 2, 1, 1],
[1, 1, 2, 2, 1, 1, 1, 2, 1, 1],
[1, 1, 2, 1, 2, 1, 1, 2, 1, 1],
[1, 1, 2, 1, 2, 1, 1, 2, 1, 1],
[1, 1, 2, 1, 1, 2, 1, 2, 1, 1],
[1, 1, 2, 1, 1, 2, 1, 2, 1, 1],
[1, 1, 2, 1, 1, 1, 2, 2, 1, 1],
[1, 1, 2, 1, 1, 1, 1, 2, 1, 1]]=],
    LevelDes = "BackpackEventDes_10301511",
    LevelId = 10303211,
    LevelInitialItem = {
      307,
      307,
      302,
      302,
      201,
      201
    },
    LevelName = "BackpackEventTitle_10301511",
    TargetReward = {
      1030321101,
      1030321102,
      1030321103
    },
    TargetScore = {
      2200,
      3300,
      4400
    },
    UnlockDate = LocalTimeProxy(1791079200)
  },
  [10303212] = {
    EventId = 103032,
    GridDistribute = [=[
[1, 1, 1, 1, 2, 2, 1, 1, 1, 1],
[1, 1, 1, 2, 1, 1, 2, 1, 1, 1],
[1, 1, 1, 2, 1, 1, 2, 1, 1, 1],
[1, 1, 1, 2, 1, 1, 2, 1, 1, 1],
[1, 1, 2, 2, 2, 2, 2, 2, 1, 1],
[1, 1, 2, 1, 1, 1, 1, 2, 1, 1],
[1, 1, 2, 1, 1, 1, 1, 2, 1, 1],
[1, 1, 2, 1, 1, 1, 1, 2, 1, 1]]=],
    LevelDes = "BackpackEventDes_10301512",
    LevelId = 10303212,
    LevelInitialItem = {
      110,
      201,
      312,
      303,
      306,
      312
    },
    LevelName = "BackpackEventTitle_10301512",
    TargetReward = {
      1030321201,
      1030321202,
      1030321203
    },
    TargetScore = T.RT_1,
    UnlockDate = LocalTimeProxy(1791079200)
  }
})
