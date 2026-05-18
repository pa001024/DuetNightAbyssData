local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildListRule", {
  [1] = {
    Id = 1,
    PecentRange = {0, 0},
    PickNum = 3
  },
  [2] = {
    Id = 2,
    PecentRange = {0, 10},
    PickNum = 20
  },
  [3] = {
    Id = 3,
    PecentRange = {10, 30},
    PickNum = 15
  },
  [4] = {
    Id = 4,
    PecentRange = {30, 80},
    PickNum = 15
  }
})
