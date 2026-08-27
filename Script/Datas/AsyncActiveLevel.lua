local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AsyncActiveLevel", {
  [1] = {
    AsyncParticipateRank = 0,
    AsyncRoomMax = 100,
    AsyncRoomMin = 85,
    ID = 1
  },
  [2] = {
    AsyncParticipateRank = 20,
    AsyncRoomMax = 85,
    AsyncRoomMin = 70,
    ID = 2
  },
  [3] = {
    AsyncParticipateRank = 40,
    AsyncRoomMax = 70,
    AsyncRoomMin = 55,
    ID = 3
  },
  [4] = {
    AsyncParticipateRank = 60,
    AsyncRoomMax = 55,
    AsyncRoomMin = 40,
    ID = 4
  },
  [5] = {
    AsyncParticipateRank = 80,
    AsyncRoomMax = 40,
    AsyncRoomMin = 35,
    ID = 5
  },
  [6] = {
    AsyncParticipateRank = 100,
    AsyncRoomMax = 35,
    AsyncRoomMin = 20,
    ID = 6
  }
})
