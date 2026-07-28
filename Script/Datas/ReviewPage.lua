local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ReviewPage", {
  [1] = {
    EpisodeName = "Episode_Ex02",
    ReviewChainPage = 1,
    ReviewChainSequence = {
      1001,
      1002,
      1003,
      1004
    }
  }
})
