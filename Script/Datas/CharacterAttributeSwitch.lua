local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CharacterAttributeSwitch", {
  [1201] = {
    CharAttribute = "Dark",
    CharGroupId = 1,
    CharId = 1201
  },
  [1601] = {
    CharAttribute = "Light",
    CharGroupId = 1,
    CharId = 1601
  },
  [120101] = {
    CharAttribute = "Dark",
    CharGroupId = 0,
    CharId = 120101
  },
  [160101] = {
    CharAttribute = "Light",
    CharGroupId = 0,
    CharId = 160101
  }
})
