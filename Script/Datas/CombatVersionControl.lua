local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CombatVersionControl", {
  [1] = {
    CombatVersionOpen = {10, 11},
    Id = 1
  }
})
