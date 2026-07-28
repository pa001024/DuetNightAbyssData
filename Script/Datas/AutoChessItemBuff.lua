local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AutoChessItemBuff", {
  [1] = {
    BuffId = {4020726},
    EnableRankId = 1,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_Spring.BP_Activity_Zizouqi_Spring"
  },
  [2] = {
    BuffId = {4020727},
    EnableRankId = 2,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_Lava.BP_Activity_Zizouqi_Lava"
  },
  [3] = {
    BuffId = {4020728},
    EnableRankId = 3,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_Wind.BP_Activity_Zizouqi_Wind"
  },
  [4] = {
    BuffId = {4020729},
    EnableRankId = 4,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_Energy.BP_Activity_Zizouqi_Energy"
  },
  [5] = {
    BuffId = {4020730},
    EnableRankId = 5,
    ItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/Zizouqi/BP_Activity_Zizouqi_Fog.BP_Activity_Zizouqi_Fog"
  }
})
