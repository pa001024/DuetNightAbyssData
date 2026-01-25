local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PaotaiEventConstant", {
  PaotaiGameEventId = {
    ConstantName = "PaotaiGameEventId",
    ConstantValue = 103007
  },
  PreDungeonRequiredStar = {
    ConstantName = "PreDungeonRequiredStar",
    ConstantValue = 1
  },
  PropNumMax = {ConstantName = "PropNumMax", ConstantValue = 2},
  WeaponNumMax = {
    ConstantName = "WeaponNumMax",
    ConstantValue = 1
  }
})
