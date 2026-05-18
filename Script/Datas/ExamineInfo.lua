local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ExamineInfo", {
  [1] = {
    ChannelID = 56,
    ExamineKey = 1,
    HostNum = 5001,
    IP = "121.199.19.146",
    JumpURL = "https://apps.apple.com/cn/app/%E4%BA%8C%E9%87%8D%E8%9E%BA%E6%97%8B/id6470771372",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "IOS-官方"
  },
  [2] = {
    ChannelID = 18,
    ExamineKey = 2,
    HostNum = 5001,
    IP = "121.199.19.146",
    JumpURL = "https://cdn-dna.yingxiong.com/dna/Android_dna.apk",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "安卓-官方"
  },
  [3] = {
    ChannelID = 46,
    ExamineKey = 3,
    HostNum = 5002,
    IP = "106.14.60.38",
    JumpURL = "https://app.biligame.com/page/detail_share.html?id=111015&sourceFrom=23006&_1758700080446",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "安卓-B站"
  },
  [4] = {
    ChannelID = 18,
    ExamineKey = 4,
    HostNum = 5001,
    IP = "121.199.19.146",
    JumpURL = "https://www.taptap.cn/app/388717",
    MirrorChannelID = 167,
    Port = 8000,
    Remark = "安卓-Tap"
  },
  [5] = {
    ChannelID = 18,
    ExamineKey = 5,
    HostNum = 5001,
    IP = "121.199.19.146",
    JumpURL = "https://www.3839.com/a/158909.htm",
    MirrorChannelID = 161,
    Port = 8000,
    Remark = "安卓-好游"
  },
  [6] = {
    ChannelID = 18,
    ExamineKey = 6,
    HostNum = 5001,
    IP = "121.199.19.146",
    JumpURL = "https://www.douyin.com/user/MS4wLjABAAAARPsdV6EkvU0tLECUo1hukfkzr697ntfSEVS3CVCh5R0",
    MirrorChannelID = 296,
    Port = 8000,
    Remark = "安卓-抖音"
  },
  [7] = {
    ChannelID = 303,
    ExamineKey = 7,
    HostNum = 5001,
    IP = "121.199.19.146",
    JumpURL = "https://actcpc.heytapimage.com/userfiles/pager_render/game_detail/index.html?banner_type=icon&appId=36323183",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "安卓-oppo"
  },
  [8] = {
    ChannelID = 237,
    ExamineKey = 8,
    HostNum = 5001,
    IP = "121.199.19.146",
    MirrorChannelID = 259,
    Port = 8000,
    Remark = "PC-官方"
  },
  [9] = {
    ChannelID = 269,
    ExamineKey = 9,
    HostNum = 5002,
    IP = "106.14.60.38",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "PC-B站"
  },
  [10] = {
    ChannelID = 286,
    ExamineKey = 10,
    HostNum = 5001,
    IP = "121.199.19.146",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "PC-Wegame"
  },
  [11] = {
    ChannelID = 297,
    ExamineKey = 11,
    HostNum = 5001,
    IP = "121.199.19.146",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "PC-联想"
  },
  [12] = {
    ChannelID = 237,
    ExamineKey = 12,
    HostNum = 5001,
    IP = "121.199.19.146",
    MirrorChannelID = 287,
    Port = 8000,
    Remark = "PC-Tap"
  },
  [13] = {
    ChannelID = 237,
    ExamineKey = 13,
    HostNum = 5001,
    IP = "121.199.19.146",
    JumpURL = "https://www.3839.com/a/183726.htm",
    MirrorChannelID = 288,
    Port = 8000,
    Remark = "PC-好游"
  },
  [14] = {
    ChannelID = 301,
    ExamineKey = 14,
    HostNum = 5001,
    IP = "121.199.19.146",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "IOS-云游戏"
  },
  [15] = {
    ChannelID = 300,
    ExamineKey = 15,
    HostNum = 5001,
    IP = "121.199.19.146",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "安卓-云游戏"
  },
  [16] = {
    ChannelID = 171,
    ExamineKey = 16,
    HostNum = 5003,
    IP = "43.130.139.32",
    JumpURL = "https://apps.apple.com/us/app/id6744096826",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "IOS-海外"
  },
  [17] = {
    ChannelID = 160,
    ExamineKey = 17,
    HostNum = 5003,
    IP = "43.130.139.32",
    JumpURL = "https://play.google.com/store/apps/details?id=com.panstudio.gplay.duetnightabyss.arpg.global",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "谷歌-海外"
  },
  [18] = {
    ChannelID = 240,
    ExamineKey = 18,
    MirrorChannelID = 0,
    Remark = "PC-海外"
  },
  [19] = {
    ChannelID = 295,
    ExamineKey = 19,
    HostNum = 5003,
    IP = "43.130.139.32",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "Epic-海外"
  },
  [20] = {
    ChannelID = 240,
    ExamineKey = 20,
    MirrorChannelID = 307,
    Remark = "PC投放包体"
  },
  [21] = {
    ChannelID = 305,
    ExamineKey = 21,
    HostNum = 5003,
    IP = "43.130.139.32",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "Steam"
  },
  [22] = {
    ChannelID = 314,
    ExamineKey = 22,
    HostNum = 5001,
    IP = "121.199.19.146",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "PC-云游戏"
  },
  [23] = {
    ChannelID = 315,
    ExamineKey = 23,
    HostNum = 5003,
    IP = "43.130.139.32",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "谷歌海外PC"
  },
  [24] = {
    ChannelID = 270,
    ExamineKey = 24,
    HostNum = 5002,
    IP = "106.14.60.38",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "鸿蒙"
  },
  [25] = {
    ChannelID = 255,
    ExamineKey = 25,
    HostNum = 5002,
    IP = "106.14.60.38",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "安卓-荣耀"
  },
  [26] = {
    ChannelID = 11,
    ExamineKey = 26,
    HostNum = 5002,
    IP = "106.14.60.38",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "安卓-华为"
  },
  [27] = {
    ChannelID = 2,
    ExamineKey = 27,
    HostNum = 5002,
    IP = "106.14.60.38",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "安卓-vivo"
  },
  [28] = {
    ChannelID = 23,
    ExamineKey = 28,
    HostNum = 5002,
    IP = "106.14.60.38",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "安卓-小米"
  },
  [29] = {
    ChannelID = 160,
    ExamineKey = 29,
    HostNum = 5003,
    IP = "121.199.19.146",
    MirrorChannelID = 181,
    Port = 8000,
    Remark = "安卓-海外华为"
  },
  [30] = {
    ChannelID = 160,
    ExamineKey = 30,
    HostNum = 5003,
    IP = "121.199.19.146",
    MirrorChannelID = 197,
    Port = 8000,
    Remark = "安卓-Onestore"
  },
  [31] = {
    ChannelID = 160,
    ExamineKey = 31,
    HostNum = 5003,
    IP = "121.199.19.146",
    MirrorChannelID = 272,
    Port = 8000,
    Remark = "安卓-rustore"
  },
  [32] = {
    ChannelID = 272,
    ExamineKey = 32,
    HostNum = 5003,
    IP = "121.199.19.146",
    MirrorChannelID = 0,
    Port = 8000,
    Remark = "安卓-海外taptap"
  }
})
