local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GenderToNpcId", {
  [1001] = {
    DarkFM = 1001,
    DarkM = 1002,
    LightFM = 100001,
    LightM = 100002,
    NormalFM = 100001,
    NormalM = 100002,
    PlayerType = "Player",
    UnitId = 1001
  },
  [1002] = {
    DarkFM = 1001,
    DarkM = 1002,
    LightFM = 100001,
    LightM = 100002,
    NormalFM = 100001,
    NormalM = 100002,
    PlayerType = "Player",
    UnitId = 1002
  },
  [100001] = {
    DarkFM = 1001,
    DarkM = 1002,
    LightFM = 100001,
    LightM = 100002,
    NormalFM = 100001,
    NormalM = 100002,
    PlayerType = "Player",
    UnitId = 100001
  },
  [100002] = {
    DarkFM = 1001,
    DarkM = 1002,
    LightFM = 100001,
    LightM = 100002,
    NormalFM = 100001,
    NormalM = 100002,
    PlayerType = "Player",
    UnitId = 100002
  },
  [100012] = {
    NormalFM = 1000121,
    NormalM = 100012,
    PlayerType = "EXPlayer",
    UnitId = 100012,
    WaterFM = 1000121,
    WaterM = 100012
  },
  [100014] = {
    NormalFM = 1000141,
    NormalM = 100014,
    PlayerType = "EXPlayer",
    UnitId = 100014,
    WaterFM = 1000141,
    WaterM = 100014
  },
  [110022] = {
    NormalFM = 1100221,
    NormalM = 110022,
    PlayerType = "EXPlayer",
    UnitId = 110022,
    WaterFM = 1100221,
    WaterM = 110022
  },
  [110040] = {
    NormalFM = 1100401,
    NormalM = 110040,
    PlayerType = "EXPlayer",
    UnitId = 110040,
    WaterFM = 1100401,
    WaterM = 110040
  },
  [110048] = {
    NormalFM = 1100481,
    NormalM = 110048,
    PlayerType = "EXPlayer",
    UnitId = 110048,
    WaterFM = 1100481,
    WaterM = 110048
  },
  [111126] = {
    NormalFM = 11112601,
    NormalM = 111126,
    PlayerType = "EXPlayer",
    UnitId = 111126,
    WaterFM = 11112601,
    WaterM = 111126
  },
  [111127] = {
    NormalFM = 11112701,
    NormalM = 111127,
    PlayerType = "EXPlayer",
    UnitId = 111127,
    WaterFM = 11112701,
    WaterM = 111127
  },
  [111177] = {
    NormalFM = 11117701,
    NormalM = 111177,
    PlayerType = "EXPlayer",
    UnitId = 111177,
    WaterFM = 11117701,
    WaterM = 111177
  },
  [200061] = {
    DarkFM = 2000612,
    DarkM = 2000613,
    LightFM = 200061,
    LightM = 2000611,
    NormalFM = 200061,
    NormalM = 2000611,
    PlayerType = "Player",
    UnitId = 200061
  },
  [220042] = {
    DarkFM = 2200421,
    DarkM = 2200441,
    LightFM = 220042,
    LightM = 220044,
    NormalFM = 220042,
    NormalM = 220044,
    PlayerType = "Player",
    UnitId = 220042
  },
  [220044] = {
    DarkFM = 2200421,
    DarkM = 2200441,
    LightFM = 220042,
    LightM = 220044,
    NormalFM = 220042,
    NormalM = 220044,
    PlayerType = "Player",
    UnitId = 220044
  },
  [240060] = {
    DarkFM = 2400601,
    DarkM = 2400611,
    LightFM = 240060,
    LightM = 240061,
    NormalFM = 240060,
    NormalM = 240061,
    PlayerType = "Player",
    UnitId = 240060
  },
  [240061] = {
    DarkFM = 2400601,
    DarkM = 2400611,
    LightFM = 240060,
    LightM = 240061,
    NormalFM = 240060,
    NormalM = 240061,
    PlayerType = "Player",
    UnitId = 240061
  },
  [700210] = {
    DarkFM = 7002102,
    DarkM = 7002103,
    LightFM = 700210,
    LightM = 7002101,
    NormalFM = 700210,
    NormalM = 7002101,
    PlayerType = "Player",
    UnitId = 700210
  },
  [790008] = {
    DarkFM = 1001,
    DarkM = 1002,
    LightFM = 790008,
    LightM = 7900081,
    NormalFM = 790008,
    NormalM = 7900081,
    PlayerType = "Player",
    UnitId = 790008
  },
  [790064] = {
    DarkFM = 7900642,
    DarkM = 7900643,
    LightFM = 790064,
    LightM = 7900641,
    NormalFM = 790064,
    NormalM = 7900641,
    PlayerType = "Player",
    UnitId = 790064
  },
  [1000121] = {
    NormalFM = 1000121,
    NormalM = 100012,
    PlayerType = "EXPlayer",
    UnitId = 1000121,
    WaterFM = 1000121,
    WaterM = 100012
  },
  [1000141] = {
    NormalFM = 1000141,
    NormalM = 100014,
    PlayerType = "EXPlayer",
    UnitId = 1000141,
    WaterFM = 1000141,
    WaterM = 100014
  },
  [1100221] = {
    NormalFM = 1100221,
    NormalM = 110022,
    PlayerType = "EXPlayer",
    UnitId = 1100221,
    WaterFM = 1100221,
    WaterM = 110022
  },
  [1100401] = {
    NormalFM = 1100401,
    NormalM = 110040,
    PlayerType = "EXPlayer",
    UnitId = 1100401,
    WaterFM = 1100401,
    WaterM = 110040
  },
  [1100481] = {
    NormalFM = 1100481,
    NormalM = 110048,
    PlayerType = "EXPlayer",
    UnitId = 1100481,
    WaterFM = 1100481,
    WaterM = 110048
  },
  [2000611] = {
    DarkFM = 2000612,
    DarkM = 2000613,
    LightFM = 200061,
    LightM = 2000611,
    NormalFM = 200061,
    NormalM = 2000611,
    PlayerType = "Player",
    UnitId = 2000611
  },
  [2000612] = {
    DarkFM = 2000612,
    DarkM = 2000613,
    LightFM = 200061,
    LightM = 2000611,
    NormalFM = 200061,
    NormalM = 2000611,
    PlayerType = "Player",
    UnitId = 2000612
  },
  [2000613] = {
    DarkFM = 2000612,
    DarkM = 2000613,
    LightFM = 200061,
    LightM = 2000611,
    NormalFM = 200061,
    NormalM = 2000611,
    PlayerType = "Player",
    UnitId = 2000613
  },
  [2200421] = {
    DarkFM = 2200421,
    DarkM = 2200441,
    LightFM = 220042,
    LightM = 220044,
    NormalFM = 220042,
    NormalM = 220044,
    PlayerType = "Player",
    UnitId = 2200421
  },
  [2200441] = {
    DarkFM = 2200421,
    DarkM = 2200441,
    LightFM = 220042,
    LightM = 220044,
    NormalFM = 220042,
    NormalM = 220044,
    PlayerType = "Player",
    UnitId = 2200441
  },
  [2400601] = {
    DarkFM = 2400601,
    DarkM = 2400611,
    LightFM = 240060,
    LightM = 240061,
    NormalFM = 240060,
    NormalM = 240061,
    PlayerType = "Player",
    UnitId = 2400601
  },
  [2400611] = {
    DarkFM = 2400601,
    DarkM = 2400611,
    LightFM = 240060,
    LightM = 240061,
    NormalFM = 240060,
    NormalM = 240061,
    PlayerType = "Player",
    UnitId = 2400611
  },
  [7002101] = {
    DarkFM = 7002102,
    DarkM = 7002103,
    LightFM = 700210,
    LightM = 7002101,
    NormalFM = 700210,
    NormalM = 7002101,
    PlayerType = "Player",
    UnitId = 7002101
  },
  [7002102] = {
    DarkFM = 7002102,
    DarkM = 7002103,
    LightFM = 700210,
    LightM = 7002101,
    NormalFM = 700210,
    NormalM = 7002101,
    PlayerType = "Player",
    UnitId = 7002102
  },
  [7002103] = {
    DarkFM = 7002102,
    DarkM = 7002103,
    LightFM = 700210,
    LightM = 7002101,
    NormalFM = 700210,
    NormalM = 7002101,
    PlayerType = "Player",
    UnitId = 7002103
  },
  [7900081] = {
    DarkFM = 1001,
    DarkM = 1002,
    LightFM = 790008,
    LightM = 7900081,
    NormalFM = 790008,
    NormalM = 7900081,
    PlayerType = "Player",
    UnitId = 7900081
  },
  [7900641] = {
    DarkFM = 7900642,
    DarkM = 7900643,
    LightFM = 790064,
    LightM = 7900641,
    NormalFM = 790064,
    NormalM = 7900641,
    PlayerType = "Player",
    UnitId = 7900641
  },
  [7900642] = {
    DarkFM = 7900642,
    DarkM = 7900643,
    LightFM = 790064,
    LightM = 7900641,
    NormalFM = 790064,
    NormalM = 7900641,
    PlayerType = "Player",
    UnitId = 7900642
  },
  [7900643] = {
    DarkFM = 7900642,
    DarkM = 7900643,
    LightFM = 790064,
    LightM = 7900641,
    NormalFM = 790064,
    NormalM = 7900641,
    PlayerType = "Player",
    UnitId = 7900643
  },
  [11112601] = {
    NormalFM = 11112601,
    NormalM = 111126,
    PlayerType = "EXPlayer",
    UnitId = 11112601,
    WaterFM = 11112601,
    WaterM = 111126
  },
  [11112701] = {
    NormalFM = 11112701,
    NormalM = 111127,
    PlayerType = "EXPlayer",
    UnitId = 11112701,
    WaterFM = 11112701,
    WaterM = 111127
  },
  [11117701] = {
    NormalFM = 11117701,
    NormalM = 111177,
    PlayerType = "EXPlayer",
    UnitId = 11117701,
    WaterFM = 11117701,
    WaterM = 111177
  }
})
