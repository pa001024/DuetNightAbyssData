local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ClueContentId2ClueId", {
  [10000101] = 100001,
  [10000102] = 100001,
  [10000103] = 100001,
  [10000201] = 100002,
  [10000301] = 100003
})
