local T = {}
T.RT_1 = {
  "Patch_Icelake"
}
T.RT_2 = {
  "Patch_Icelake",
  "Patch_East"
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RegionPatchCondition", {
  [1011] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1011
  },
  [1013] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1013
  },
  [1014] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1014
  },
  [1017] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1017
  },
  [1019] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1019
  },
  [1021] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1021
  },
  [1022] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1022
  },
  [1032] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1032
  },
  [1041] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1041
  },
  [1042] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1042
  },
  [1043] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1043
  },
  [1044] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1044
  },
  [1045] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1045
  },
  [1046] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1046
  },
  [1047] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1047
  },
  [1048] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1048
  },
  [1049] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1049
  },
  [1050] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1050
  },
  [1051] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1051
  },
  [1052] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1052
  },
  [1053] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1053
  },
  [1054] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1054
  },
  [1055] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1055
  },
  [1056] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1056
  },
  [1057] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1057
  },
  [1058] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1058
  },
  [1059] = {
    NecessaryPatch = T.RT_2,
    RegionID = 1059
  },
  [1060] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1060
  },
  [1061] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1061
  },
  [1062] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1062
  },
  [1063] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1063
  },
  [1070] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1070
  },
  [1071] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1071
  },
  [1072] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1072
  },
  [1073] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1073
  },
  [1074] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1074
  },
  [1075] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1075
  },
  [1076] = {
    NecessaryPatch = T.RT_1,
    RegionID = 1076
  },
  [2001] = {
    NecessaryPatch = T.RT_1,
    RegionID = 2001
  },
  [2101] = {
    NecessaryPatch = T.RT_1,
    RegionID = 2101
  }
})
