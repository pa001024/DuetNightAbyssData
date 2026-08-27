local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("TeamFirstType", {
  [1] = {
    DisplayOrder = 1,
    FilterMaxCapacity = 4,
    FirstType = 1,
    Name = "UI_teamHallModeA",
    SecondTypes = {
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10
    },
    TabIcon = "RESOURCE_NAME_30001"
  },
  [2] = {
    DisplayOrder = 2,
    FilterMaxCapacity = 4,
    FirstType = 2,
    Name = "UI_teamHallModeB",
    SecondTypes = {
      11,
      12,
      13
    },
    TabIcon = "RESOURCE_NAME_30002"
  },
  [3] = {
    DisplayOrder = 3,
    FilterMaxCapacity = 4,
    FirstType = 3,
    Name = "UI_teamHallModeC",
    SecondTypes = {14, 15},
    TabIcon = "RESOURCE_NAME_20001"
  },
  [4] = {
    DisplayOrder = 4,
    FilterMaxCapacity = 3,
    FirstType = 4,
    Name = "UI_teamHallModeD",
    SecondTypes = {16, 17},
    TabIcon = "RESOURCE_NAME_20002"
  }
})
