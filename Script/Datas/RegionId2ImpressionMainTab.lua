local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RegionId2ImpressionMainTab", {
  [1011] = 1,
  [1041] = 2
})
