local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildEntranceCompType", {
  [1] = {
    DisplayOrder = 1,
    LimitNum = 10,
    SubType = -1,
    Type = 1,
    TypeName = "建筑"
  },
  [2] = {
    DisplayOrder = 1,
    LimitNum = 999,
    SubType = -1,
    Type = 2,
    TypeName = "装饰"
  },
  [3] = {
    DisplayOrder = 1,
    LimitNum = -1,
    SubType = 1,
    Type = 3,
    TypeName = "浮空装饰"
  },
  [4] = {
    DisplayOrder = 2,
    LimitNum = -1,
    SubType = 2,
    Type = 4,
    TypeName = "室内装饰"
  }
})
