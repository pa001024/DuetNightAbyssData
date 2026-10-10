local T = {}
T.RT_1 = {0.3, 3}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CustomStick", {
  [101] = {
    CustomStickId = 101,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Bainianchun_01.T_PersonalInfo_Sticker_Bainianchun_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_01",
    ScaleLimit = T.RT_1,
    StickerId = 101,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Bainianchun_01.T_PersonalInfo_Sticker_Bainianchun_01'"
  },
  [102] = {
    CustomStickId = 102,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Bainianchun_02.T_PersonalInfo_Sticker_Bainianchun_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_02",
    ScaleLimit = T.RT_1,
    StickerId = 102,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Bainianchun_02.T_PersonalInfo_Sticker_Bainianchun_02'"
  },
  [103] = {
    CustomStickId = 103,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Chaoshengyanxue_01.T_PersonalInfo_Sticker_Chaoshengyanxue_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_03",
    ScaleLimit = T.RT_1,
    StickerId = 103,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Chaoshengyanxue_01.T_PersonalInfo_Sticker_Chaoshengyanxue_01'"
  },
  [104] = {
    CustomStickId = 104,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Chaoshengyanxue_02.T_PersonalInfo_Sticker_Chaoshengyanxue_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_04",
    ScaleLimit = T.RT_1,
    StickerId = 104,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Chaoshengyanxue_02.T_PersonalInfo_Sticker_Chaoshengyanxue_02'"
  },
  [105] = {
    CustomStickId = 105,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Chenmoshihai_01.T_PersonalInfo_Sticker_Chenmoshihai_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_05",
    ScaleLimit = T.RT_1,
    StickerId = 105,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Chenmoshihai_01.T_PersonalInfo_Sticker_Chenmoshihai_01'"
  },
  [106] = {
    CustomStickId = 106,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Chenmoshihai_02.T_PersonalInfo_Sticker_Chenmoshihai_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_06",
    ScaleLimit = T.RT_1,
    StickerId = 106,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Chenmoshihai_02.T_PersonalInfo_Sticker_Chenmoshihai_02'"
  },
  [107] = {
    CustomStickId = 107,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Jianjiapu_01.T_PersonalInfo_Sticker_Jianjiapu_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_07",
    ScaleLimit = T.RT_1,
    StickerId = 107,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Jianjiapu_01.T_PersonalInfo_Sticker_Jianjiapu_01'"
  },
  [108] = {
    CustomStickId = 108,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Jianjiapu_02.T_PersonalInfo_Sticker_Jianjiapu_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_08",
    ScaleLimit = T.RT_1,
    StickerId = 108,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Jianjiapu_02.T_PersonalInfo_Sticker_Jianjiapu_02'"
  },
  [109] = {
    CustomStickId = 109,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Kurongge_01.T_PersonalInfo_Sticker_Kurongge_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_09",
    ScaleLimit = T.RT_1,
    StickerId = 109,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Kurongge_01.T_PersonalInfo_Sticker_Kurongge_01'"
  },
  [110] = {
    CustomStickId = 110,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Kurongge_02.T_PersonalInfo_Sticker_Kurongge_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_10",
    ScaleLimit = T.RT_1,
    StickerId = 110,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Kurongge_02.T_PersonalInfo_Sticker_Kurongge_02'"
  },
  [111] = {
    CustomStickId = 111,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Qianlongju_01.T_PersonalInfo_Sticker_Qianlongju_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_11",
    ScaleLimit = T.RT_1,
    StickerId = 111,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Qianlongju_01.T_PersonalInfo_Sticker_Qianlongju_01'"
  },
  [112] = {
    CustomStickId = 112,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Qianlongju_02.T_PersonalInfo_Sticker_Qianlongju_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_12",
    ScaleLimit = T.RT_1,
    StickerId = 112,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Qianlongju_02.T_PersonalInfo_Sticker_Qianlongju_02'"
  },
  [113] = {
    CustomStickId = 113,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Qianshushouzhen_01.T_PersonalInfo_Sticker_Qianshushouzhen_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_13",
    ScaleLimit = T.RT_1,
    StickerId = 113,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Qianshushouzhen_01.T_PersonalInfo_Sticker_Qianshushouzhen_01'"
  },
  [114] = {
    CustomStickId = 114,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Qianshushouzhen_02.T_PersonalInfo_Sticker_Qianshushouzhen_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_14",
    ScaleLimit = T.RT_1,
    StickerId = 114,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Qianshushouzhen_02.T_PersonalInfo_Sticker_Qianshushouzhen_02'"
  },
  [115] = {
    CustomStickId = 115,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Wangxi_01.T_PersonalInfo_Sticker_Wangxi_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_15",
    ScaleLimit = T.RT_1,
    StickerId = 115,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Wangxi_01.T_PersonalInfo_Sticker_Wangxi_01'"
  },
  [116] = {
    CustomStickId = 116,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Wangxi_02.T_PersonalInfo_Sticker_Wangxi_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_16",
    ScaleLimit = T.RT_1,
    StickerId = 116,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Wangxi_02.T_PersonalInfo_Sticker_Wangxi_02'"
  },
  [117] = {
    CustomStickId = 117,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Youmingjian_01.T_PersonalInfo_Sticker_Youmingjian_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_17",
    ScaleLimit = T.RT_1,
    StickerId = 117,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Youmingjian_01.T_PersonalInfo_Sticker_Youmingjian_01'"
  },
  [118] = {
    CustomStickId = 118,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Youmingjian_02.T_PersonalInfo_Sticker_Youmingjian_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_18",
    ScaleLimit = T.RT_1,
    StickerId = 118,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Youmingjian_02.T_PersonalInfo_Sticker_Youmingjian_02'"
  },
  [119] = {
    CustomStickId = 119,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhejisha_01.T_PersonalInfo_Sticker_Zhejisha_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_19",
    ScaleLimit = T.RT_1,
    StickerId = 119,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhejisha_01.T_PersonalInfo_Sticker_Zhejisha_01'"
  },
  [120] = {
    CustomStickId = 120,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhejisha_02.T_PersonalInfo_Sticker_Zhejisha_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_20",
    ScaleLimit = T.RT_1,
    StickerId = 120,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhejisha_02.T_PersonalInfo_Sticker_Zhejisha_02'"
  },
  [121] = {
    CustomStickId = 121,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhuoyinjitan_01.T_PersonalInfo_Sticker_Zhuoyinjitan_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_21",
    ScaleLimit = T.RT_1,
    StickerId = 121,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhuoyinjitan_01.T_PersonalInfo_Sticker_Zhuoyinjitan_01'"
  },
  [122] = {
    CustomStickId = 122,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhuoyinjitan_02.T_PersonalInfo_Sticker_Zhuoyinjitan_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_22",
    ScaleLimit = T.RT_1,
    StickerId = 122,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhuoyinjitan_02.T_PersonalInfo_Sticker_Zhuoyinjitan_02'"
  },
  [123] = {
    CustomStickId = 123,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Dongjiao_01.T_PersonalInfo_Sticker_Dongjiao_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_23",
    ScaleLimit = T.RT_1,
    StickerId = 123,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Dongjiao_01.T_PersonalInfo_Sticker_Dongjiao_01'"
  },
  [124] = {
    CustomStickId = 124,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Dongjiao_02.T_PersonalInfo_Sticker_Dongjiao_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_24",
    ScaleLimit = T.RT_1,
    StickerId = 124,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Dongjiao_02.T_PersonalInfo_Sticker_Dongjiao_02'"
  },
  [125] = {
    CustomStickId = 125,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingdongcheng_01.T_PersonalInfo_Sticker_Haojingdongcheng_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_25",
    ScaleLimit = T.RT_1,
    StickerId = 125,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingdongcheng_01.T_PersonalInfo_Sticker_Haojingdongcheng_01'"
  },
  [126] = {
    CustomStickId = 126,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingdongcheng_02.T_PersonalInfo_Sticker_Haojingdongcheng_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_26",
    ScaleLimit = T.RT_1,
    StickerId = 126,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingdongcheng_02.T_PersonalInfo_Sticker_Haojingdongcheng_02'"
  },
  [127] = {
    CustomStickId = 127,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingneicheng_01.T_PersonalInfo_Sticker_Haojingneicheng_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_27",
    ScaleLimit = T.RT_1,
    StickerId = 127,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingneicheng_01.T_PersonalInfo_Sticker_Haojingneicheng_01'"
  },
  [128] = {
    CustomStickId = 128,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingneicheng_02.T_PersonalInfo_Sticker_Haojingneicheng_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_28",
    ScaleLimit = T.RT_1,
    StickerId = 128,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingneicheng_02.T_PersonalInfo_Sticker_Haojingneicheng_02'"
  },
  [129] = {
    CustomStickId = 129,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingxicheng_01.T_PersonalInfo_Sticker_Haojingxicheng_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_29",
    ScaleLimit = T.RT_1,
    StickerId = 129,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingxicheng_01.T_PersonalInfo_Sticker_Haojingxicheng_01'"
  },
  [130] = {
    CustomStickId = 130,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingxicheng_02.T_PersonalInfo_Sticker_Haojingxicheng_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_30",
    ScaleLimit = T.RT_1,
    StickerId = 130,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Haojingxicheng_02.T_PersonalInfo_Sticker_Haojingxicheng_02'"
  },
  [131] = {
    CustomStickId = 131,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Jiaolancun_01.T_PersonalInfo_Sticker_Jiaolancun_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_31",
    ScaleLimit = T.RT_1,
    StickerId = 131,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Jiaolancun_01.T_PersonalInfo_Sticker_Jiaolancun_01'"
  },
  [132] = {
    CustomStickId = 132,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Jiaolancun_02.T_PersonalInfo_Sticker_Jiaolancun_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_32",
    ScaleLimit = T.RT_1,
    StickerId = 132,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Jiaolancun_02.T_PersonalInfo_Sticker_Jiaolancun_02'"
  },
  [133] = {
    CustomStickId = 133,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Shanwaishan_01.T_PersonalInfo_Sticker_Shanwaishan_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_33",
    ScaleLimit = T.RT_1,
    StickerId = 133,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Shanwaishan_01.T_PersonalInfo_Sticker_Shanwaishan_01'"
  },
  [134] = {
    CustomStickId = 134,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Shanwaishan_02.T_PersonalInfo_Sticker_Shanwaishan_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_34",
    ScaleLimit = T.RT_1,
    StickerId = 134,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Shanwaishan_02.T_PersonalInfo_Sticker_Shanwaishan_02'"
  },
  [135] = {
    CustomStickId = 135,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Taixuling_01.T_PersonalInfo_Sticker_Taixuling_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_35",
    ScaleLimit = T.RT_1,
    StickerId = 135,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Taixuling_01.T_PersonalInfo_Sticker_Taixuling_01'"
  },
  [136] = {
    CustomStickId = 136,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Taixuling_02.T_PersonalInfo_Sticker_Taixuling_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_36",
    ScaleLimit = T.RT_1,
    StickerId = 136,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Taixuling_02.T_PersonalInfo_Sticker_Taixuling_02'"
  },
  [137] = {
    CustomStickId = 137,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Yanyingong_01.T_PersonalInfo_Sticker_Yanyingong_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_37",
    ScaleLimit = T.RT_1,
    StickerId = 137,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Yanyingong_01.T_PersonalInfo_Sticker_Yanyingong_01'"
  },
  [138] = {
    CustomStickId = 138,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Yanyingong_02.T_PersonalInfo_Sticker_Yanyingong_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_38",
    ScaleLimit = T.RT_1,
    StickerId = 138,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Yanyingong_02.T_PersonalInfo_Sticker_Yanyingong_02'"
  },
  [139] = {
    CustomStickId = 139,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Youlaixiang_01.T_PersonalInfo_Sticker_Youlaixiang_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_39",
    ScaleLimit = T.RT_1,
    StickerId = 139,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Youlaixiang_01.T_PersonalInfo_Sticker_Youlaixiang_01'"
  },
  [140] = {
    CustomStickId = 140,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Youlaixiang_02.T_PersonalInfo_Sticker_Youlaixiang_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_40",
    ScaleLimit = T.RT_1,
    StickerId = 140,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Youlaixiang_02.T_PersonalInfo_Sticker_Youlaixiang_02'"
  },
  [141] = {
    CustomStickId = 141,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhilvge_01.T_PersonalInfo_Sticker_Zhilvge_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_41",
    ScaleLimit = T.RT_1,
    StickerId = 141,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhilvge_01.T_PersonalInfo_Sticker_Zhilvge_01'"
  },
  [142] = {
    CustomStickId = 142,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhilvge_02.T_PersonalInfo_Sticker_Zhilvge_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_42",
    ScaleLimit = T.RT_1,
    StickerId = 142,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Zhilvge_02.T_PersonalInfo_Sticker_Zhilvge_02'"
  },
  [143] = {
    CustomStickId = 143,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Aerkanuoshan_01.T_PersonalInfo_Sticker_Aerkanuoshan_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_43",
    ScaleLimit = T.RT_1,
    StickerId = 143,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Aerkanuoshan_01.T_PersonalInfo_Sticker_Aerkanuoshan_01'"
  },
  [144] = {
    CustomStickId = 144,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Aerkanuoshan_02.T_PersonalInfo_Sticker_Aerkanuoshan_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_44",
    ScaleLimit = T.RT_1,
    StickerId = 144,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Aerkanuoshan_02.T_PersonalInfo_Sticker_Aerkanuoshan_02'"
  },
  [145] = {
    CustomStickId = 145,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Aerkanuozhenfeixu_01.T_PersonalInfo_Sticker_Aerkanuozhenfeixu_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_45",
    ScaleLimit = T.RT_1,
    StickerId = 145,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Aerkanuozhenfeixu_01.T_PersonalInfo_Sticker_Aerkanuozhenfeixu_01'"
  },
  [146] = {
    CustomStickId = 146,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Aerkanuozhenfeixu_02.T_PersonalInfo_Sticker_Aerkanuozhenfeixu_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_46",
    ScaleLimit = T.RT_1,
    StickerId = 146,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Aerkanuozhenfeixu_02.T_PersonalInfo_Sticker_Aerkanuozhenfeixu_02'"
  },
  [147] = {
    CustomStickId = 147,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Leyuanzhen_01.T_PersonalInfo_Sticker_Leyuanzhen_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_47",
    ScaleLimit = T.RT_1,
    StickerId = 147,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Leyuanzhen_01.T_PersonalInfo_Sticker_Leyuanzhen_01'"
  },
  [148] = {
    CustomStickId = 148,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Leyuanzhen_02.T_PersonalInfo_Sticker_Leyuanzhen_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_48",
    ScaleLimit = T.RT_1,
    StickerId = 148,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Leyuanzhen_02.T_PersonalInfo_Sticker_Leyuanzhen_02'"
  },
  [149] = {
    CustomStickId = 149,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Leyuanzhenhanmengchi_01.T_PersonalInfo_Sticker_Leyuanzhenhanmengchi_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_49",
    ScaleLimit = T.RT_1,
    StickerId = 149,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Leyuanzhenhanmengchi_01.T_PersonalInfo_Sticker_Leyuanzhenhanmengchi_01'"
  },
  [150] = {
    CustomStickId = 150,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Leyuanzhenhanmengchi_02.T_PersonalInfo_Sticker_Leyuanzhenhanmengchi_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_50",
    ScaleLimit = T.RT_1,
    StickerId = 150,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Leyuanzhenhanmengchi_02.T_PersonalInfo_Sticker_Leyuanzhenhanmengchi_02'"
  },
  [151] = {
    CustomStickId = 151,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Longshayaosai_01.T_PersonalInfo_Sticker_Longshayaosai_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_51",
    ScaleLimit = T.RT_1,
    StickerId = 151,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Longshayaosai_01.T_PersonalInfo_Sticker_Longshayaosai_01'"
  },
  [152] = {
    CustomStickId = 152,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Longshayaosai_02.T_PersonalInfo_Sticker_Longshayaosai_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_52",
    ScaleLimit = T.RT_1,
    StickerId = 152,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Longshayaosai_02.T_PersonalInfo_Sticker_Longshayaosai_02'"
  },
  [153] = {
    CustomStickId = 153,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Shanguliexi_01.T_PersonalInfo_Sticker_Shanguliexi_01'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_53",
    ScaleLimit = T.RT_1,
    StickerId = 153,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Shanguliexi_01.T_PersonalInfo_Sticker_Shanguliexi_01'"
  },
  [154] = {
    CustomStickId = 154,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Shanguliexi_02.T_PersonalInfo_Sticker_Shanguliexi_02'",
    IsDefaultUnlock = false,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_54",
    ScaleLimit = T.RT_1,
    StickerId = 154,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_Shanguliexi_02.T_PersonalInfo_Sticker_Shanguliexi_02'"
  },
  [155] = {
    CustomStickId = 155,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_DNA_01.T_PersonalInfo_Sticker_DNA_01'",
    IsDefaultUnlock = true,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_55",
    ScaleLimit = T.RT_1,
    StickerId = 155,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_DNA_01.T_PersonalInfo_Sticker_DNA_01'"
  },
  [156] = {
    CustomStickId = 156,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_DNA_02.T_PersonalInfo_Sticker_DNA_02'",
    IsDefaultUnlock = true,
    IsOversea = false,
    Name = "UI_PersonalPage_Sticker_56",
    ScaleLimit = T.RT_1,
    StickerId = 156,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_DNA_02.T_PersonalInfo_Sticker_DNA_02'"
  },
  [2155] = {
    CustomStickId = 2155,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_DNA_01.T_PersonalInfo_Sticker_DNA_01'",
    IsDefaultUnlock = true,
    IsOversea = true,
    Name = "UI_PersonalPage_Sticker_55",
    ScaleLimit = T.RT_1,
    StickerId = 155,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_DNA_01.T_PersonalInfo_Sticker_DNA_01'"
  },
  [2156] = {
    CustomStickId = 2156,
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_DNA_02.T_PersonalInfo_Sticker_DNA_02'",
    IsDefaultUnlock = true,
    IsOversea = true,
    Name = "UI_PersonalPage_Sticker_56",
    ScaleLimit = T.RT_1,
    StickerId = 156,
    StickerPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/PersonalInfo/T_PersonalInfo_Sticker_DNA_02.T_PersonalInfo_Sticker_DNA_02'"
  }
})
