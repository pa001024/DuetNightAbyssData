local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ReviewChain", {
  [1001] = {
    FirstShowCondition = 11020100,
    ReviewChainMain = {110201},
    ReviewChainSequence = 1001,
    ReviewChainSide = "0"
  },
  [1002] = {
    ReviewChainMain = {110202},
    ReviewChainSequence = 1002,
    ReviewChainSide = "0"
  },
  [1003] = {
    ReviewChainMain = {110203},
    ReviewChainSequence = 1003,
    ReviewChainSide = "110204"
  },
  [1004] = {
    ReviewChainMain = {
      110211,
      110212,
      110213
    },
    ReviewChainSequence = 1004,
    ReviewChainSide = "0"
  }
})
