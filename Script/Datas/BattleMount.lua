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
    CharMeshSocket = true,
    MonsterId = 1000,
    MountDieSlotName = "MountDie01",
    MountId = 1000,
    MountLayerTag = 0,
    MountPrefix = "Mnt01",
    MountTurnPrefix = "Mnt01",
    TurnSlotName = "DefaultSlot"
  },
  [1001] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = true,
    FroceRideFly = true,
    MonsterId = 1001,
    MountDieSlotName = "MountDie02",
    MountId = 1001,
    MountLayerTag = 1,
    MountPermanentVX = {
      10005,
      10006,
      10007,
      10008,
      10009,
      10010,
      10011,
      10012,
      10013,
      10014,
      10015,
      10016
    },
    MountPrefix = "Mnt02"
  },
  [1002] = {
    BodyScaleRule = T.RT_1,
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = true,
    MonsterId = 1002,
    MountDieSlotName = "MountDie03",
    MountId = 1002,
    MountLayerTag = 2,
    MountPermanentVX = {
      10000,
      10001,
      10002
    },
    MountPrefix = "Mnt03",
    MountTurnPrefix = "Mnt03",
    RolePermanentVX = {10003, 10004},
    TurnSlotName = "DefaultSlot"
  },
  [1003] = {
    BodyScaleRule = T.RT_1,
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = true,
    MonsterId = 1003,
    MountDieSlotName = "MountDie04",
    MountId = 1003,
    MountLayerTag = 3,
    MountPrefix = "Mnt04",
    MountTurnPrefix = "Mnt01",
    TurnSlotName = "MountTurnNull"
  },
  [1004] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = false,
    MonsterId = 1004,
    MountDieSlotName = "MountDie05",
    MountId = 1004,
    MountLayerTag = 4,
    MountMeshSocket = "ik_foot_root",
    MountPermanentVX = {10022, 10025},
    MountPrefix = "Mnt05",
    MountTurnPrefix = "Mnt05",
    TurnSlotName = "DefaultSlot"
  },
  [1005] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = false,
    MonsterId = 1005,
    MountDieSlotName = "MountDie05",
    MountId = 1005,
    MountLayerTag = 4,
    MountMeshSocket = "ik_foot_root",
    MountPermanentVX = {
      10017,
      10018,
      10019,
      10020,
      10021
    },
    MountPrefix = "Mnt05",
    MountTurnPrefix = "Mnt05",
    TurnSlotName = "DefaultSlot"
  },
  [1006] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = false,
    MonsterId = 1004,
    MountDieSlotName = "MountDie05",
    MountId = 1006,
    MountLayerTag = 4,
    MountMeshSocket = "ik_foot_root",
    MountPermanentVX = {10023, 10025},
    MountPrefix = "Mnt05",
    MountTurnPrefix = "Mnt05",
    TurnSlotName = "DefaultSlot"
  },
  [1007] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = false,
    MonsterId = 1004,
    MountDieSlotName = "MountDie05",
    MountId = 1007,
    MountLayerTag = 4,
    MountMeshSocket = "ik_foot_root",
    MountPermanentVX = {10024, 10025},
    MountPrefix = "Mnt05",
    MountTurnPrefix = "Mnt05",
    TurnSlotName = "DefaultSlot"
  },
  [1008] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = true,
    MonsterId = 1006,
    MountDieSlotName = "MountDie07",
    MountId = 1008,
    MountLayerTag = 5,
    MountPermanentVX = {10027},
    MountPrefix = "Mnt07",
    MountTurnPrefix = "Mnt07",
    RolePermanentVX = {10026},
    TurnSlotName = "DefaultSlot"
  },
  [1009] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = true,
    MonsterId = 1007,
    MountDieSlotName = "MountDie06",
    MountId = 1009,
    MountLayerTag = 6,
    MountPermanentVX = {
      10028,
      10029,
      10030,
      10031,
      10032,
      10033,
      10034
    },
    MountPrefix = "Mnt06",
    MountTurnPrefix = "Mnt06",
    TurnSlotName = "DefaultSlot"
  },
  [1010] = {
    CharAnimInstance = "ABP_Mount_",
    CharMeshSocket = true,
    FroceRideFly = true,
    MonsterId = 1008,
    MountDieSlotName = "MountDie08",
    MountId = 1010,
    MountLayerTag = 7,
    MountPermanentVX = {
      10037,
      10038,
      10039,
      10040,
      10041,
      10042,
      10043,
      10044,
      10045,
      10046,
      10047,
      10048,
      10049,
      10050,
      10051,
      10052,
      10053,
      10054,
      10055,
      10056,
      10057,
      10058
    },
    MountPrefix = "Mnt08"
  }
})
