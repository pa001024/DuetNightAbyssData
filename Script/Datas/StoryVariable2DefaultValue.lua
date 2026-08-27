local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("StoryVariable2DefaultValue", {Scehutao_110220 = 1, TestVar6 = 3})
