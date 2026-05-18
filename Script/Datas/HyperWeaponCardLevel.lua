local T = {}
T.RT_1 = {
  [1] = 36,
  [2] = 5,
  [3] = 30,
  [4] = 30
}
T.RT_2 = {
  [1] = 42,
  [2] = 20,
  [3] = 6,
  [4] = 40,
  [5] = 40
}
T.RT_3 = {
  [1] = 48,
  [2] = 30,
  [3] = 5,
  [4] = 6,
  [5] = 50,
  [6] = 50
}
T.RT_4 = {
  [1] = 54,
  [2] = 50,
  [3] = 15,
  [4] = 6,
  [5] = 60,
  [6] = 60
}
T.RT_5 = {
  [1] = 100,
  [2] = 90,
  [3] = 20,
  [4] = 1,
  [5] = 100,
  [6] = 100
}
T.RT_6 = {
  [1] = 100
}
T.RT_7 = {
  [1] = 5
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("HyperWeaponCardLevel", {
  [10299] = {
    [1] = {
      CollectRewardExp = 200,
      ResourceId = {
        [1] = 15002,
        [2] = 202,
        [3] = 15026,
        [4] = 15027
      },
      ResourceNum = T.RT_1,
      UnlockCondition = 443001,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel1",
      WeaponCardLevel = 1,
      WeaponId = 10299
    },
    [2] = {
      CollectRewardExp = 200,
      ResourceId = {
        [1] = 15002,
        [2] = 15031,
        [3] = 20027,
        [4] = 15026,
        [5] = 15027
      },
      ResourceNum = T.RT_2,
      UnlockCondition = 443002,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel2",
      WeaponCardLevel = 2,
      WeaponId = 10299
    },
    [3] = {
      CollectRewardExp = 200,
      ResourceId = {
        [1] = 15002,
        [2] = 15031,
        [3] = 15037,
        [4] = 202,
        [5] = 15026,
        [6] = 15027
      },
      ResourceNum = T.RT_3,
      UnlockCondition = 443003,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel3",
      WeaponCardLevel = 3,
      WeaponId = 10299
    },
    [4] = {
      CollectRewardExp = 200,
      ResourceId = {
        [1] = 15002,
        [2] = 15031,
        [3] = 15037,
        [4] = 20027,
        [5] = 15026,
        [6] = 15027
      },
      ResourceNum = T.RT_4,
      UnlockCondition = 443004,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel4",
      WeaponCardLevel = 4,
      WeaponId = 10299
    },
    [5] = {
      CollectRewardExp = 200,
      ResourceId = {
        [1] = 15002,
        [2] = 15031,
        [3] = 15037,
        [4] = 1006,
        [5] = 15026,
        [6] = 15027
      },
      ResourceNum = T.RT_5,
      UnlockCondition = 443005,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel5",
      WeaponCardLevel = 5,
      WeaponId = 10299
    }
  },
  [10399] = {
    [1] = {
      CollectRewardExp = 200,
      ResourceId = T.RT_6,
      ResourceNum = T.RT_7,
      UnlockCondition = 443001,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel1",
      WeaponCardLevel = 1,
      WeaponId = 10399
    },
    [2] = {
      CollectRewardExp = 200,
      ResourceId = T.RT_6,
      ResourceNum = T.RT_7,
      UnlockCondition = 443002,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel2",
      WeaponCardLevel = 2,
      WeaponId = 10399
    },
    [3] = {
      CollectRewardExp = 200,
      ResourceId = T.RT_6,
      ResourceNum = T.RT_7,
      UnlockCondition = 443003,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel3",
      WeaponCardLevel = 3,
      WeaponId = 10399
    },
    [4] = {
      CollectRewardExp = 200,
      ResourceId = T.RT_6,
      ResourceNum = T.RT_7,
      UnlockCondition = 443004,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel4",
      WeaponCardLevel = 4,
      WeaponId = 10399
    },
    [5] = {
      CollectRewardExp = 200,
      ResourceId = T.RT_6,
      ResourceNum = T.RT_7,
      UnlockCondition = 443005,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel5",
      WeaponCardLevel = 5,
      WeaponId = 10399
    }
  },
  [20298] = {
    [1] = {
      CollectRewardExp = 200,
      ResourceId = T.RT_6,
      ResourceNum = T.RT_7,
      UnlockCondition = 443001,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel1",
      WeaponCardLevel = 1,
      WeaponId = 20298
    },
    [2] = {
      CollectRewardExp = 200,
      ResourceId = T.RT_6,
      ResourceNum = T.RT_7,
      UnlockCondition = 443002,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel2",
      WeaponCardLevel = 2,
      WeaponId = 20298
    },
    [3] = {
      CollectRewardExp = 200,
      ResourceId = T.RT_6,
      ResourceNum = T.RT_7,
      UnlockCondition = 443003,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel3",
      WeaponCardLevel = 3,
      WeaponId = 20298
    },
    [4] = {
      CollectRewardExp = 200,
      ResourceId = T.RT_6,
      ResourceNum = T.RT_7,
      UnlockCondition = 443004,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel4",
      WeaponCardLevel = 4,
      WeaponId = 20298
    },
    [5] = {
      CollectRewardExp = 200,
      ResourceId = T.RT_6,
      ResourceNum = T.RT_7,
      UnlockCondition = 443005,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel5",
      WeaponCardLevel = 5,
      WeaponId = 20298
    }
  },
  [20599] = {
    [1] = {
      CollectRewardExp = 200,
      ResourceId = {
        [1] = 15003,
        [2] = 202,
        [3] = 15028,
        [4] = 15029
      },
      ResourceNum = T.RT_1,
      UnlockCondition = 443001,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel1",
      WeaponCardLevel = 1,
      WeaponId = 20599
    },
    [2] = {
      CollectRewardExp = 200,
      ResourceId = {
        [1] = 15003,
        [2] = 15036,
        [3] = 20028,
        [4] = 15028,
        [5] = 15029
      },
      ResourceNum = T.RT_2,
      UnlockCondition = 443002,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel2",
      WeaponCardLevel = 2,
      WeaponId = 20599
    },
    [3] = {
      CollectRewardExp = 200,
      ResourceId = {
        [1] = 15003,
        [2] = 15036,
        [3] = 15037,
        [4] = 202,
        [5] = 15028,
        [6] = 15029
      },
      ResourceNum = T.RT_3,
      UnlockCondition = 443003,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel3",
      WeaponCardLevel = 3,
      WeaponId = 20599
    },
    [4] = {
      CollectRewardExp = 200,
      ResourceId = {
        [1] = 15003,
        [2] = 15036,
        [3] = 15037,
        [4] = 20028,
        [5] = 15028,
        [6] = 15029
      },
      ResourceNum = T.RT_4,
      UnlockCondition = 443004,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel4",
      WeaponCardLevel = 4,
      WeaponId = 20599
    },
    [5] = {
      CollectRewardExp = 200,
      ResourceId = {
        [1] = 15003,
        [2] = 15036,
        [3] = 15037,
        [4] = 1006,
        [5] = 15028,
        [6] = 15029
      },
      ResourceNum = T.RT_5,
      UnlockCondition = 443005,
      UnlockConditionDes = "UI_HyperWeapon_ForgeLevel5",
      WeaponCardLevel = 5,
      WeaponId = 20599
    }
  }
})
