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
      110201,
      110202,
      110203,
      110204,
      110205,
      110206,
      110207,
      110208,
      110209,
      110210,
      110211,
      110212,
      110213,
      110214,
      110215,
      110216
    }
  }
})
