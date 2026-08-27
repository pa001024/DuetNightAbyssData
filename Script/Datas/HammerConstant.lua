local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HammerConstant", {
  Ham_ComboRate = {
    ConstantName = "Ham_ComboRate",
    ConstantValue = 1.15
  },
  Ham_ErrorLockTime = {
    ConstantName = "Ham_ErrorLockTime",
    ConstantValue = 0.5
  },
  Ham_PerfPos_Down = {
    ConstantName = "Ham_PerfPos_Down",
    ConstantValue = 0
  },
  Ham_PerfPos_Up = {
    ConstantName = "Ham_PerfPos_Up",
    ConstantValue = 10
  },
  Ham_PerfRate = {
    ConstantName = "Ham_PerfRate",
    ConstantValue = 1.3
  },
  Ham_VisPos = {ConstantName = "Ham_VisPos", ConstantValue = 1},
  Ham_VisPos_Key = {
    ConstantName = "Ham_VisPos_Key",
    ConstantValue = 1
  }
})
