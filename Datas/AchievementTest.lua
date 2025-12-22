local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AchievementTest", {
  [1] = {
    Count = 1,
    Index = 1,
    Param1Int = 200101,
    TargetId = 70102,
    TargetType = 10701
  }
})
