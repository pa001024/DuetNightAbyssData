local T = {}
T.RT_1 = {}
T.RT_2 = {}
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("FlowExportBranchImpr", {
  [120104291] = T.RT_2,
  [120104292] = T.RT_2,
  [120131061] = T.RT_1,
  [120131062] = T.RT_1
})
