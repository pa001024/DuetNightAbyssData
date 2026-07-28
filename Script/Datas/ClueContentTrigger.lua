local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ClueContentTrigger", {
  Dialogue = {
    [11100201] = {
      [1] = {ClueContentId = 10000101, State = 1}
    },
    [11100301] = {
      [1] = {ClueContentId = 10000101, State = 2}
    }
  },
  MechState = {
    [152480411] = {
      [495004] = {
        [1] = {ClueContentId = 10000102, State = 1}
      }
    }
  },
  Resource = {
    [2000017] = {
      [1] = {ClueContentId = 10000103, State = 1}
    }
  }
})
