local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ReviewChain", {
  [110201] = {
    FirstShowCondition = 11020101,
    ReviewChainMain = {1001},
    ReviewChainSequence = 110201,
    ReviewChainSide = "0"
  },
  [110202] = {
    ReviewChainMain = {1002},
    ReviewChainSequence = 110202,
    ReviewChainSide = "0"
  },
  [110203] = {
    ReviewChainMain = {1003},
    ReviewChainSequence = 110203,
    ReviewChainSide = "0"
  },
  [110204] = {
    ReviewChainMain = {1004},
    ReviewChainSequence = 110204,
    ReviewChainSide = "1005"
  },
  [110205] = {
    ReviewChainMain = {1006},
    ReviewChainSequence = 110205
  },
  [110206] = {
    ReviewChainMain = {
      1007,
      1008,
      1009,
      1010,
      1011
    },
    ReviewChainSequence = 110206
  },
  [110207] = {
    ReviewChainMain = {1014},
    ReviewChainSequence = 110207,
    ReviewChainSide = "1013"
  },
  [110208] = {
    ReviewChainMain = {1012},
    ReviewChainSequence = 110208
  },
  [110209] = {
    ReviewChainMain = {1015, 1016},
    ReviewChainSequence = 110209
  },
  [110210] = {
    ReviewChainMain = {1017},
    ReviewChainSequence = 110210
  },
  [110211] = {
    ReviewChainMain = {1018},
    ReviewChainSequence = 110211
  },
  [110212] = {
    ReviewChainMain = {1019},
    ReviewChainSequence = 110212
  },
  [110213] = {
    ReviewChainMain = {1020},
    ReviewChainSequence = 110213
  },
  [110214] = {
    ReviewChainMain = {1021},
    ReviewChainSequence = 110214
  },
  [110215] = {
    ReviewChainMain = {1022},
    ReviewChainSequence = 110215
  },
  [110216] = {
    ReviewChainMain = {1023},
    ReviewChainSequence = 110216,
    ReviewChainSide = "1024"
  }
})
