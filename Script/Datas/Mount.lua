local T = {}
T.RT_1 = {
  "Text_SHOP_MAINTAB_GACHA"
}
T.RT_2 = {"Shop_Main"}
T.RT_3 = {
  0,
  0,
  5
}
T.RT_4 = {
  10,
  0,
  -30
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Mount", {
  [1000] = {
    AccessKey = {
      "Text_MountQuest01"
    },
    AnimPath = "/Game/Asset/Char/Mount/Mnt001_Bian/Animation/Montage/Interactive/Mnt_Bian_System_Idle_Montage.Mnt_Bian_System_Idle_Montage",
    BattleMountId = 1000,
    CameraName = "Char_Mount_Bian",
    FlyLicense = 1,
    MountDes = "RESOURCE_DESC_49999",
    MountDisplayScale = 0.5,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0002.T_Mounts_0002",
    MountId = 1000,
    MountLocOffset = {
      0,
      0,
      0
    },
    MountName = "RESOURCE_NAME_49999",
    MountRarity = 4,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0002.T_Icon_Mounts_0002",
    ResourceId = 49999,
    SortPriority = 97
  },
  [1001] = {
    AccessKey = T.RT_1,
    AnimPath = "/Game/Asset/Char/Mount/Mnt002_Zhuyin/Animation/Montage/Interactive/Mnt002_Zhuyin_System_Idle_Montage.Mnt002_Zhuyin_System_Idle_Montage",
    BattleMountId = 1001,
    CameraName = "Char_Mount_ZhuYin",
    MountDes = "RESOURCE_DESC_49998",
    MountDisplayScale = 0.3,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0001.T_Mounts_0001",
    MountId = 1001,
    MountLocOffset = {
      -20,
      0,
      15
    },
    MountName = "RESOURCE_NAME_49998",
    MountRarity = 6,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0001.T_Icon_Mounts_0001",
    ResourceId = 49998,
    SortPriority = 100
  },
  [1002] = {
    AccessKey = T.RT_2,
    AnimPath = "/Game/Asset/Char/Mount/Mnt003_Yinyi/Animation/Montage/Interactive/Mnt003_Yinyi_System_Idle_Montage.Mnt003_Yinyi_System_Idle_Montage",
    BattleMountId = 1002,
    CameraName = "Char_Mount_Motor",
    FlyLicense = 1,
    MountDes = "RESOURCE_DESC_49997",
    MountDisplayScale = 0.5,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0003.T_Mounts_0003",
    MountId = 1002,
    MountLocOffset = T.RT_3,
    MountName = "RESOURCE_NAME_49997",
    MountRarity = 5,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0003.T_Icon_Mounts_0003",
    ResourceId = 49997,
    SortPriority = 99
  },
  [1003] = {
    AccessKey = T.RT_2,
    AnimPath = "/Game/Asset/Char/Mount/Mnt004_Zhenzi/Animation/Montage/Interactive/Mnt004_Zhenzi_System_Idle_Montage.Mnt004_Zhenzi_System_Idle_Montage",
    BattleMountId = 1003,
    CameraName = "Char_Mount_ZhenZi",
    FlyLicense = 1,
    MountDes = "RESOURCE_DESC_49996",
    MountDisplayScale = 0.6,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0004.T_Mounts_0004",
    MountId = 1003,
    MountLocOffset = {
      0,
      0,
      15
    },
    MountName = "RESOURCE_NAME_49996",
    MountRarity = 4,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0004.T_Icon_Mounts_0004",
    ResourceId = 49996,
    SortPriority = 98
  },
  [1004] = {
    AccessKey = T.RT_2,
    AnimPath = "/Game/Asset/Char/Mount/Mnt005_Taixu/Animation/Montage/Interactive/Mnt005_Taixu_System_Idle_Montage.Mnt005_Taixu_System_Idle_Montage",
    BattleMountId = 1004,
    CameraName = "Char_Mount_Taixu",
    FlyLicense = 1,
    MountDes = "RESOURCE_DESC_49995",
    MountDisplayScale = 0.5,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0005.T_Mounts_0005",
    MountId = 1004,
    MountLocOffset = T.RT_4,
    MountName = "RESOURCE_NAME_49995",
    MountRarity = 5,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0005.T_Icon_Mounts_0005",
    ResourceId = 49995,
    SortPriority = 101
  },
  [1005] = {
    AccessKey = {
      "Text_MountEvent"
    },
    AnimPath = "/Game/Asset/Char/Mount/Mnt005_Taixu/Animation/Montage/Interactive/Mnt005_Taixu_System_Idle_Montage.Mnt005_Taixu_System_Idle_Montage",
    BattleMountId = 1005,
    CameraName = "Char_Mount_Taixu",
    FlyLicense = 1,
    MountDes = "RESOURCE_DESC_49995",
    MountDisplayScale = 0.5,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0006.T_Mounts_0006",
    MountId = 1005,
    MountLocOffset = T.RT_4,
    MountName = "RESOURCE_NAME_49992",
    MountRarity = 5,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0006.T_Icon_Mounts_0006",
    ResourceId = 49994,
    SortPriority = 101
  },
  [1006] = {
    AccessKey = T.RT_2,
    AnimPath = "/Game/Asset/Char/Mount/Mnt005_Taixu/Animation/Montage/Interactive/Mnt005_Taixu_System_Idle_Montage.Mnt005_Taixu_System_Idle_Montage",
    BattleMountId = 1006,
    CameraName = "Char_Mount_Taixu",
    FlyLicense = 1,
    MountDes = "RESOURCE_DESC_49995",
    MountDisplayScale = 0.5,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0008.T_Mounts_0008",
    MountId = 1006,
    MountLocOffset = T.RT_4,
    MountName = "RESOURCE_NAME_49994",
    MountRarity = 5,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0008.T_Icon_Mounts_0008",
    ResourceId = 49993,
    SortPriority = 101
  },
  [1007] = {
    AccessKey = T.RT_2,
    AnimPath = "/Game/Asset/Char/Mount/Mnt005_Taixu/Animation/Montage/Interactive/Mnt005_Taixu_System_Idle_Montage.Mnt005_Taixu_System_Idle_Montage",
    BattleMountId = 1007,
    CameraName = "Char_Mount_Taixu",
    FlyLicense = 1,
    MountDes = "RESOURCE_DESC_49995",
    MountDisplayScale = 0.5,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0007.T_Mounts_0007",
    MountId = 1007,
    MountLocOffset = T.RT_4,
    MountName = "RESOURCE_NAME_49993",
    MountRarity = 5,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0007.T_Icon_Mounts_0007",
    ResourceId = 49992,
    SortPriority = 101
  },
  [1008] = {
    AccessKey = T.RT_2,
    AnimPath = "/Game/Asset/Char/Mount/Mnt007_Chensi/Animation/Montage/Interactive/Mnt007_Chensi_System_Idle_Montage.Mnt007_Chensi_System_Idle_Montage",
    BattleMountId = 1008,
    CameraName = "Char_Mount_Chensi",
    FlyLicense = 1,
    MountDes = "RESOURCE_DESC_49991",
    MountDisplayScale = 0.6,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0009.T_Mounts_0009",
    MountId = 1008,
    MountLocOffset = T.RT_3,
    MountName = "RESOURCE_NAME_49991",
    MountRarity = 4,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0009.T_Icon_Mounts_0009",
    ResourceId = 49991,
    SortPriority = 98
  },
  [1009] = {
    AccessKey = T.RT_1,
    AnimPath = "/Game/Asset/Char/Mount/Mnt006_Yewei/Animation/Montage/Interactive/Mnt006_Yewei_System_Idle_Montage.Mnt006_Yewei_System_Idle_Montage",
    BattleMountId = 1009,
    CameraName = "Char_Mount_Yewei",
    MountDes = "RESOURCE_DESC_49990",
    MountDisplayScale = 0.5,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0011.T_Mounts_0011",
    MountId = 1009,
    MountLocOffset = {
      0,
      0,
      -10
    },
    MountName = "RESOURCE_NAME_49990",
    MountRarity = 6,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0011.T_Icon_Mounts_0011",
    ResourceId = 49990,
    SortPriority = 103
  },
  [1010] = {
    AccessKey = T.RT_1,
    AnimPath = "/Game/Asset/Char/Mount/Mnt008_Shiru/Animation/Montage/Interactive/Mnt008_Shiru_System_Idle_Montage.Mnt008_Shiru_System_Idle_Montage",
    BattleMountId = 1010,
    CameraName = "Char_Mount_Shiru",
    MountDes = "RESOURCE_DESC_49989",
    MountDisplayScale = 0.6,
    MountIcon = "/Game/UI/Texture/Dynamic/Image/Mounts/T_Mounts_0010.T_Mounts_0010",
    MountId = 1010,
    MountLocOffset = {
      -40,
      0,
      -30
    },
    MountName = "RESOURCE_NAME_49989",
    MountRarity = 6,
    ResourceIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Mounts/T_Icon_Mounts_0010.T_Icon_Mounts_0010",
    ResourceId = 49989,
    SortPriority = 103
  }
})
