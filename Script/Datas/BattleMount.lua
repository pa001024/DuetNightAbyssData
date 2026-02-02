local T = {}
T.RT_1 = {
  Boy = 0.85,
  Girl = 1,
  Loli = 0.8,
  Man = 1.2,
  Woman = 1.1
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("BattleMount", {
  [1000] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = "socket_spine2",
    MonsterId = 1000,
    MountDieSlotName = "MountDie01",
    MountId = 1000,
    MountPrefix = "Mnt01",
    MountTurnPrefix = "Mnt01",
    TurnSlotName = "DefaultSlot"
  },
  [1001] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = "socket_spine2",
    FroceRideFly = true,
    MonsterId = 1001,
    MountDieSlotName = "MountDie02",
    MountId = 1001,
    MountPrefix = "Mnt02"
  },
  [1002] = {
    BodyScaleRule = T.RT_1,
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = "socket_spine2",
    MonsterId = 1002,
    MountDieSlotName = "MountDie03",
    MountId = 1002,
    MountPrefix = "Mnt03",
    MountTurnPrefix = "Mnt03",
    TurnSlotName = "DefaultSlot"
  },
  [1003] = {
    BodyScaleRule = T.RT_1,
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = "socket_spine2",
    MonsterId = 1003,
    MountDieSlotName = "MountDie04",
    MountId = 1003,
    MountPrefix = "Mnt04",
    MountTurnPrefix = "Mnt01",
    TurnSlotName = "MountTurnNull"
  }
})
