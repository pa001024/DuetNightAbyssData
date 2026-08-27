local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ModTaskPhase", {
  [1] = {PhaseReward = 7101, QuestPhaseId = 1},
  [2] = {PhaseReward = 7101, QuestPhaseId = 2},
  [3] = {PhaseReward = 7101, QuestPhaseId = 3},
  [4] = {PhaseReward = 73010, QuestPhaseId = 4},
  [5] = {PhaseReward = 73011, QuestPhaseId = 5}
})
