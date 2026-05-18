local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("TotalCheck", {
  [1] = {
    [1] = {
      CheckCount = 180,
      CheckReward = 7741,
      Id = 1,
      Step = 1
    },
    [2] = {
      CheckCount = 360,
      CheckReward = 7742,
      Id = 1,
      Step = 2
    }
  }
})
