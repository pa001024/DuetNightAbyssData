local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CustomDisplayGroup", {
  [101] = {
    DisplayGroupId = 101,
    EntityType = "Char",
    GestureTag = {"Pose", "Gesture"},
    MaxCount = 4
  },
  [102] = {
    DisplayGroupId = 102,
    EntityType = "Pet",
    MaxCount = 1
  },
  [103] = {
    DisplayGroupId = 103,
    EntityType = "Item",
    MaxCount = 0
  }
})
