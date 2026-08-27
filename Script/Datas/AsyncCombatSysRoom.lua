local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AsyncCombatSysRoom", {
  [1] = {
    AsyncRomeAddNum = 40,
    AsyncRomeLimitNum = 40,
    AsyncRomeResType = 102,
    ID = 1
  },
  [2] = {
    AsyncRomeAddNum = 40,
    AsyncRomeLimitNum = 40,
    AsyncRomeResType = 20013,
    ID = 2
  },
  [3] = {
    AsyncRomeAddNum = 40,
    AsyncRomeLimitNum = 40,
    AsyncRomeResType = 2013,
    ID = 3
  },
  [4] = {
    AsyncRomeAddNum = 40,
    AsyncRomeLimitNum = 40,
    AsyncRomeResType = 2009,
    ID = 4
  },
  [5] = {
    AsyncRomeAddNum = 40,
    AsyncRomeLimitNum = 40,
    AsyncRomeResType = 211,
    ID = 5
  },
  [6] = {
    AsyncRomeAddNum = 40,
    AsyncRomeLimitNum = 40,
    AsyncRomeResType = 101,
    ID = 6
  }
})
