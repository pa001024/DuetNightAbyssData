local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CombatVersionOpenList", {
  [10] = true,
  [11] = true
})
