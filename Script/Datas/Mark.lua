local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Mark", {
  [150401] = {
    MarkId = 150401,
    VisualEffects = {150433}
  },
  [150499] = {
    MarkId = 150499,
    VisualEffects = {150434}
  },
  [2060301] = {
    MarkId = 2060301,
    VisualEffects = {2060301}
  }
})
