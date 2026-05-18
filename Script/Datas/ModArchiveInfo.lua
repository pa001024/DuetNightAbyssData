local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ModArchiveInfo", {
  [1001] = {
    ApplicationTypeIdList = {
      1,
      11,
      12,
      13,
      14,
      15,
      16,
      1504
    },
    ArchiveStep = 3,
    ArchiveTitle = "UI_Armory_Char",
    ModArchiveType = 1001,
    RewardId = 1001001,
    RewardTabIconPath = "Texture2D'/Game/UI/T"
  },
  [1002] = {
    ApplicationTypeIdList = {
      2,
      21,
      22,
      23,
      101,
      102,
      103,
      104,
      105,
      106
    },
    ArchiveStep = 3,
    ArchiveTitle = "UI_BAG_Meleeweapon",
    ModArchiveType = 1002,
    RewardId = 1001001,
    RewardTabIconPath = "Texture2D'/Game/UI/T"
  },
  [1003] = {
    ApplicationTypeIdList = {
      3,
      31,
      32,
      33,
      34,
      35
    },
    ArchiveStep = 3,
    ArchiveTitle = "UI_BAG_Longrange",
    ModArchiveType = 1003,
    RewardId = 1001001,
    RewardTabIconPath = "Texture2D'/Game/UI/T"
  },
  [1004] = {
    ApplicationTypeIdList = {
      4,
      41,
      42,
      43
    },
    ArchiveStep = 3,
    ArchiveTitle = "UI_Armory_MeleeweaponUltra",
    ModArchiveType = 1004,
    RewardId = 1001001,
    RewardTabIconPath = "Texture2D'/Game/UI/T"
  },
  [1005] = {
    ApplicationTypeIdList = {
      5,
      51,
      52,
      53
    },
    ArchiveStep = 3,
    ArchiveTitle = "UI_Armory_LongrangeUltra",
    ModArchiveType = 1005,
    RewardId = 1001001,
    RewardTabIconPath = "Texture2D'/Game/UI/T"
  }
})
