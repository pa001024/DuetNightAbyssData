local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Mark", {
  [2060301] = {
    MarkId = 2060301,
    VisualEffects = {2060301}
  }
})
