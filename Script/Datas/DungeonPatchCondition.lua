local T = {}
T.RT_1 = {
  "Patch_Icelake",
  "Patch_East"
}
T.RT_2 = {
  "Patch_Icelake"
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("DungeonPatchCondition", {
  [21301] = {
    DungeonID = 21301,
    NecessaryPatch = T.RT_1
  },
  [21302] = {
    DungeonID = 21302,
    NecessaryPatch = T.RT_1
  },
  [21303] = {
    DungeonID = 21303,
    NecessaryPatch = T.RT_1
  },
  [21311] = {
    DungeonID = 21311,
    NecessaryPatch = T.RT_1
  },
  [21312] = {
    DungeonID = 21312,
    NecessaryPatch = T.RT_1
  },
  [21313] = {
    DungeonID = 21313,
    NecessaryPatch = T.RT_1
  },
  [21401] = {
    DungeonID = 21401,
    NecessaryPatch = T.RT_1
  },
  [21402] = {
    DungeonID = 21402,
    NecessaryPatch = T.RT_1
  },
  [21403] = {
    DungeonID = 21403,
    NecessaryPatch = T.RT_1
  },
  [21411] = {
    DungeonID = 21411,
    NecessaryPatch = T.RT_1
  },
  [21412] = {
    DungeonID = 21412,
    NecessaryPatch = T.RT_1
  },
  [21413] = {
    DungeonID = 21413,
    NecessaryPatch = T.RT_1
  },
  [21414] = {
    DungeonID = 21414,
    NecessaryPatch = T.RT_1
  },
  [30100] = {DungeonID = 30100},
  [30101] = {
    DungeonID = 30101,
    NecessaryPatch = T.RT_1
  },
  [30102] = {
    DungeonID = 30102,
    NecessaryPatch = T.RT_1
  },
  [30103] = {
    DungeonID = 30103,
    NecessaryPatch = T.RT_1
  },
  [30104] = {
    DungeonID = 30104,
    NecessaryPatch = T.RT_1
  },
  [30105] = {
    DungeonID = 30105,
    NecessaryPatch = T.RT_1
  },
  [30106] = {
    DungeonID = 30106,
    NecessaryPatch = T.RT_1
  },
  [30107] = {
    DungeonID = 30107,
    NecessaryPatch = T.RT_1
  },
  [30108] = {
    DungeonID = 30108,
    NecessaryPatch = T.RT_1
  },
  [30601] = {
    DungeonID = 30601,
    NecessaryPatch = T.RT_1
  },
  [30602] = {
    DungeonID = 30602,
    NecessaryPatch = T.RT_1
  },
  [30603] = {
    DungeonID = 30603,
    NecessaryPatch = T.RT_1
  },
  [30604] = {
    DungeonID = 30604,
    NecessaryPatch = T.RT_1
  },
  [30605] = {
    DungeonID = 30605,
    NecessaryPatch = T.RT_1
  },
  [30606] = {
    DungeonID = 30606,
    NecessaryPatch = T.RT_1
  },
  [30607] = {
    DungeonID = 30607,
    NecessaryPatch = T.RT_1
  },
  [30608] = {
    DungeonID = 30608,
    NecessaryPatch = T.RT_1
  },
  [30609] = {
    DungeonID = 30609,
    NecessaryPatch = T.RT_2
  },
  [30801] = {
    DungeonID = 30801,
    NecessaryPatch = T.RT_1
  },
  [30802] = {
    DungeonID = 30802,
    NecessaryPatch = T.RT_1
  },
  [30803] = {
    DungeonID = 30803,
    NecessaryPatch = T.RT_1
  },
  [30804] = {
    DungeonID = 30804,
    NecessaryPatch = T.RT_1
  },
  [31001] = {
    DungeonID = 31001,
    NecessaryPatch = T.RT_1
  },
  [31002] = {
    DungeonID = 31002,
    NecessaryPatch = T.RT_1
  },
  [31003] = {
    DungeonID = 31003,
    NecessaryPatch = T.RT_1
  },
  [31004] = {
    DungeonID = 31004,
    NecessaryPatch = T.RT_1
  },
  [31005] = {
    DungeonID = 31005,
    NecessaryPatch = T.RT_2
  },
  [41801] = {
    DungeonID = 41801,
    NecessaryPatch = T.RT_1
  },
  [41802] = {
    DungeonID = 41802,
    NecessaryPatch = T.RT_1
  },
  [41803] = {
    DungeonID = 41803,
    NecessaryPatch = T.RT_1
  },
  [41804] = {
    DungeonID = 41804,
    NecessaryPatch = T.RT_1
  },
  [41805] = {
    DungeonID = 41805,
    NecessaryPatch = T.RT_1
  },
  [41806] = {
    DungeonID = 41806,
    NecessaryPatch = T.RT_1
  },
  [41807] = {
    DungeonID = 41807,
    NecessaryPatch = T.RT_1
  },
  [41808] = {
    DungeonID = 41808,
    NecessaryPatch = T.RT_1
  },
  [41809] = {
    DungeonID = 41809,
    NecessaryPatch = T.RT_1
  },
  [41810] = {
    DungeonID = 41810,
    NecessaryPatch = T.RT_1
  },
  [41811] = {
    DungeonID = 41811,
    NecessaryPatch = T.RT_1
  },
  [41812] = {
    DungeonID = 41812,
    NecessaryPatch = T.RT_1
  },
  [50601] = {
    DungeonID = 50601,
    NecessaryPatch = T.RT_1
  },
  [50602] = {
    DungeonID = 50602,
    NecessaryPatch = T.RT_1
  },
  [50603] = {
    DungeonID = 50603,
    NecessaryPatch = T.RT_1
  },
  [50604] = {
    DungeonID = 50604,
    NecessaryPatch = T.RT_1
  },
  [50605] = {
    DungeonID = 50605,
    NecessaryPatch = T.RT_1
  },
  [50606] = {
    DungeonID = 50606,
    NecessaryPatch = T.RT_1
  },
  [90108] = {
    DungeonID = 90108,
    NecessaryPatch = T.RT_1
  },
  [90604] = {
    DungeonID = 90604,
    NecessaryPatch = T.RT_1
  },
  [90804] = {
    DungeonID = 90804,
    NecessaryPatch = T.RT_1
  },
  [91009] = {
    DungeonID = 91009,
    NecessaryPatch = T.RT_1
  },
  [91124] = {
    DungeonID = 91124,
    NecessaryPatch = T.RT_1
  },
  [91125] = {
    DungeonID = 91125,
    NecessaryPatch = T.RT_1
  },
  [91126] = {
    DungeonID = 91126,
    NecessaryPatch = T.RT_1
  },
  [91127] = {
    DungeonID = 91127,
    NecessaryPatch = T.RT_1
  },
  [91128] = {
    DungeonID = 91128,
    NecessaryPatch = T.RT_1
  },
  [91129] = {
    DungeonID = 91129,
    NecessaryPatch = T.RT_1
  },
  [91132] = {
    DungeonID = 91132,
    NecessaryPatch = T.RT_1
  },
  [91133] = {
    DungeonID = 91133,
    NecessaryPatch = T.RT_1
  },
  [91134] = {
    DungeonID = 91134,
    NecessaryPatch = T.RT_1
  },
  [91135] = {
    DungeonID = 91135,
    NecessaryPatch = T.RT_1
  },
  [91136] = {
    DungeonID = 91136,
    NecessaryPatch = T.RT_1
  },
  [91144] = {
    DungeonID = 91144,
    NecessaryPatch = T.RT_1
  },
  [91145] = {
    DungeonID = 91145,
    NecessaryPatch = T.RT_1
  },
  [91146] = {
    DungeonID = 91146,
    NecessaryPatch = T.RT_1
  },
  [91147] = {
    DungeonID = 91147,
    NecessaryPatch = T.RT_1
  },
  [91148] = {
    DungeonID = 91148,
    NecessaryPatch = T.RT_1
  },
  [91149] = {
    DungeonID = 91149,
    NecessaryPatch = T.RT_1
  },
  [91150] = {
    DungeonID = 91150,
    NecessaryPatch = T.RT_1
  },
  [91181] = {
    DungeonID = 91181,
    NecessaryPatch = T.RT_1
  },
  [91182] = {
    DungeonID = 91182,
    NecessaryPatch = T.RT_1
  },
  [91183] = {
    DungeonID = 91183,
    NecessaryPatch = T.RT_1
  },
  [91184] = {
    DungeonID = 91184,
    NecessaryPatch = T.RT_1
  },
  [91185] = {
    DungeonID = 91185,
    NecessaryPatch = T.RT_1
  },
  [91186] = {
    DungeonID = 91186,
    NecessaryPatch = T.RT_1
  },
  [91187] = {
    DungeonID = 91187,
    NecessaryPatch = T.RT_1
  },
  [91203] = {
    DungeonID = 91203,
    NecessaryPatch = T.RT_1
  },
  [91204] = {
    DungeonID = 91204,
    NecessaryPatch = T.RT_1
  },
  [91205] = {
    DungeonID = 91205,
    NecessaryPatch = T.RT_1
  },
  [91206] = {
    DungeonID = 91206,
    NecessaryPatch = T.RT_1
  },
  [91207] = {
    DungeonID = 91207,
    NecessaryPatch = T.RT_1
  },
  [91208] = {
    DungeonID = 91208,
    NecessaryPatch = T.RT_1
  },
  [91209] = {
    DungeonID = 91209,
    NecessaryPatch = T.RT_1
  },
  [91210] = {
    DungeonID = 91210,
    NecessaryPatch = T.RT_1
  },
  [91211] = {
    DungeonID = 91211,
    NecessaryPatch = T.RT_1
  },
  [91212] = {
    DungeonID = 91212,
    NecessaryPatch = T.RT_1
  },
  [91213] = {
    DungeonID = 91213,
    NecessaryPatch = T.RT_1
  },
  [91221] = {
    DungeonID = 91221,
    NecessaryPatch = T.RT_1
  },
  [91222] = {
    DungeonID = 91222,
    NecessaryPatch = T.RT_1
  },
  [614002] = {
    DungeonID = 614002,
    NecessaryPatch = T.RT_2
  },
  [614003] = {
    DungeonID = 614003,
    NecessaryPatch = T.RT_2
  },
  [614004] = {
    DungeonID = 614004,
    NecessaryPatch = T.RT_2
  },
  [614005] = {
    DungeonID = 614005,
    NecessaryPatch = T.RT_2
  },
  [614006] = {
    DungeonID = 614006,
    NecessaryPatch = T.RT_2
  },
  [614007] = {
    DungeonID = 614007,
    NecessaryPatch = T.RT_1
  },
  [614008] = {
    DungeonID = 614008,
    NecessaryPatch = T.RT_1
  },
  [614102] = {
    DungeonID = 614102,
    NecessaryPatch = T.RT_2
  },
  [614103] = {
    DungeonID = 614103,
    NecessaryPatch = T.RT_2
  },
  [614104] = {
    DungeonID = 614104,
    NecessaryPatch = T.RT_2
  },
  [614105] = {
    DungeonID = 614105,
    NecessaryPatch = T.RT_2
  },
  [614106] = {
    DungeonID = 614106,
    NecessaryPatch = T.RT_2
  },
  [614107] = {
    DungeonID = 614107,
    NecessaryPatch = T.RT_1
  },
  [614108] = {
    DungeonID = 614108,
    NecessaryPatch = T.RT_1
  }
})
