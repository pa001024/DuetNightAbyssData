local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildSeatScoreRule", {
  [1] = {
    ActivityMin = 1500,
    ActivityScore = 50,
    RuleId = 1
  },
  [2] = {
    ActivityMin = 700,
    ActivityScore = 25,
    RuleId = 2
  },
  [3] = {
    ActivityMin = 0,
    ActivityScore = 0,
    RuleId = 3
  }
})
