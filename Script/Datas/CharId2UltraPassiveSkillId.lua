local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CharId2UltraPassiveSkillId", {
  [1101] = 110105,
  [1501] = 150105,
  [2101] = 210105,
  [3201] = 320105,
  [3202] = 320205
})
