local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RaceLotteryMaxStake", {
  [1] = {EventDay = 1, MaxStake = 100000},
  [2] = {EventDay = 2, MaxStake = 300000},
  [3] = {EventDay = 3, MaxStake = 300000},
  [4] = {EventDay = 4, MaxStake = 300000},
  [5] = {EventDay = 5, MaxStake = 300000},
  [6] = {EventDay = 6, MaxStake = 300000},
  [7] = {EventDay = 7, MaxStake = 300000},
  [8] = {EventDay = 8, MaxStake = 300000}
})
