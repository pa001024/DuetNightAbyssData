local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildFirstCategory", {
  [1] = {
    DisplayOrder = 1,
    FirstCategory = 1,
    Name = "DUNGEON_NAME_6"
  },
  [2] = {
    DisplayOrder = 2,
    FirstCategory = 2,
    Name = "DUNGEON_NAME_6"
  },
  [3] = {
    DisplayOrder = 3,
    FirstCategory = 3,
    Name = "DUNGEON_NAME_6"
  },
  [4] = {
    DisplayOrder = 4,
    FirstCategory = 4,
    Name = "DUNGEON_NAME_6"
  }
})
