local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AxisName2ActionName", {
  MoveForward = {
    ["-1"] = "S",
    ["1"] = "W"
  },
  MoveRight = {
    ["-1"] = "A",
    ["1"] = "D"
  }
})
