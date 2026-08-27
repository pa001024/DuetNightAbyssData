local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildSeat", {
  [10101] = {
    CreateType = 1,
    Priority = 1,
    SeatId = 10101,
    Type = 1
  },
  [10102] = {
    CreateType = 1,
    Priority = 2,
    SeatId = 10102,
    Type = 1
  },
  [10103] = {
    CreateType = 1,
    Priority = 3,
    SeatId = 10103,
    Type = 2
  },
  [10104] = {
    CreateType = 1,
    Priority = 4,
    SeatId = 10104,
    Type = 3
  },
  [10201] = {
    CreateType = 2,
    Priority = 1,
    SeatId = 10201,
    Type = 1
  },
  [10202] = {
    CreateType = 2,
    Priority = 2,
    SeatId = 10202,
    Type = 2
  },
  [10203] = {
    CreateType = 2,
    Priority = 3,
    SeatId = 10203,
    Type = 3
  }
})
