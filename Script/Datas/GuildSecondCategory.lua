local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildSecondCategory", {
  [1] = {
    DisplayOrder = 1,
    FirstCategory = 1,
    LimitNum = 10,
    Name = "DUNGEON_NAME_6",
    SecondCategory = 1
  },
  [2] = {
    DisplayOrder = 2,
    FirstCategory = 2,
    LimitNum = -1,
    Name = "DUNGEON_NAME_6",
    SecondCategory = 2
  },
  [3] = {
    DisplayOrder = 3,
    FirstCategory = 3,
    LimitNum = -1,
    Name = "DUNGEON_NAME_6",
    SecondCategory = 3
  },
  [4] = {
    DisplayOrder = 1,
    FirstCategory = 4,
    LimitNum = -1,
    Name = "DUNGEON_NAME_6",
    SecondCategory = 4
  },
  [5] = {
    DisplayOrder = 2,
    FirstCategory = 1,
    LimitNum = -1,
    Name = "DUNGEON_NAME_6",
    SecondCategory = 5
  },
  [6] = {
    DisplayOrder = 3,
    FirstCategory = 2,
    LimitNum = -1,
    Name = "DUNGEON_NAME_6",
    SecondCategory = 6
  },
  [7] = {
    DisplayOrder = 1,
    FirstCategory = 3,
    LimitNum = -1,
    Name = "DUNGEON_NAME_6",
    SecondCategory = 7
  },
  [8] = {
    DisplayOrder = 1,
    FirstCategory = 4,
    LimitNum = -1,
    Name = "DUNGEON_NAME_6",
    SecondCategory = 8
  }
})
