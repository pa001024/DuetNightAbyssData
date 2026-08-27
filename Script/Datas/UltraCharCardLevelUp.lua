local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("UltraCharCardLevelUp", {
  [1101] = {
    CharId = 1101,
    CollectRewardExp = 250,
    ExtraUnlockCondition = 110180,
    ResourceId1 = 1021101,
    ResourceId2 = 1001101,
    ResourceId3 = 10100,
    ResourceId4 = 20030,
    ResourceId5 = 10024,
    ResourceNum1 = 1,
    ResourceNum2 = 30,
    ResourceNum3 = 2,
    ResourceNum4 = 5,
    ResourceNum5 = 20,
    UnlockDes = "CardLevel7thUnlockDEs"
  },
  [1501] = {
    CharId = 1501,
    CollectRewardExp = 250,
    ExtraUnlockCondition = 150180,
    ResourceId1 = 1021501,
    ResourceId2 = 1001501,
    ResourceId3 = 10100,
    ResourceId4 = 20030,
    ResourceId5 = 10020,
    ResourceNum1 = 1,
    ResourceNum2 = 30,
    ResourceNum3 = 2,
    ResourceNum4 = 5,
    ResourceNum5 = 20,
    UnlockDes = "CardLevel7thUnlockDEs"
  },
  [2101] = {
    CharId = 2101,
    CollectRewardExp = 250,
    ExtraUnlockCondition = 210180,
    ResourceId1 = 1022101,
    ResourceId2 = 1002101,
    ResourceId3 = 10100,
    ResourceId4 = 20031,
    ResourceId5 = 10012,
    ResourceNum1 = 1,
    ResourceNum2 = 30,
    ResourceNum3 = 2,
    ResourceNum4 = 5,
    ResourceNum5 = 20,
    UnlockDes = "CardLevel7thUnlockDEs"
  },
  [3201] = {
    CharId = 3201,
    CollectRewardExp = 250,
    ExtraUnlockCondition = 320180,
    ResourceId1 = 1023201,
    ResourceId2 = 1003201,
    ResourceId3 = 10100,
    ResourceId4 = 20030,
    ResourceId5 = 10008,
    ResourceNum1 = 1,
    ResourceNum2 = 30,
    ResourceNum3 = 2,
    ResourceNum4 = 5,
    ResourceNum5 = 20,
    UnlockDes = "CardLevel7thUnlockDEs"
  },
  [3202] = {
    CharId = 3202,
    CollectRewardExp = 250,
    ExtraUnlockCondition = 320280,
    ResourceId1 = 1023202,
    ResourceId2 = 1003202,
    ResourceId3 = 10100,
    ResourceId4 = 20031,
    ResourceId5 = 10008,
    ResourceNum1 = 1,
    ResourceNum2 = 30,
    ResourceNum3 = 2,
    ResourceNum4 = 5,
    ResourceNum5 = 20,
    UnlockDes = "CardLevel7thUnlockDEs"
  }
})
