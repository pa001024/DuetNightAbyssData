local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CustomGesture", {
  [1001] = {
    Document = "/Interactive/Fishing/",
    GestureId = 1001,
    GestureTag = "Pose",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Action/T_Resource_Gesture_Caocong.T_Resource_Gesture_Caocong'",
    Name = "UI_Name_Gesture_01",
    PoseName = "Crouch_Idle"
  },
  [1002] = {
    Document = "/Locomotion/",
    GestureId = 1002,
    GestureTag = "Pose",
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Action/T_Resource_Gesture_Angling.T_Resource_Gesture_Angling'",
    Name = "UI_Name_Gesture_02",
    PoseName = "Fish_Idle"
  },
  [2001] = {
    GestureId = 2001,
    GestureTag = "Gesture",
    Name = "姿势：滋滋烤肉",
    ReleaseWheel = 41001
  },
  [2002] = {
    GestureId = 2002,
    GestureTag = "Gesture",
    Name = "姿势：箱中之猫·本色",
    ReleaseWheel = 41002
  },
  [2003] = {
    GestureId = 2003,
    GestureTag = "Gesture",
    Name = "姿势：魔法学徒",
    ReleaseWheel = 41003
  },
  [2004] = {
    GestureId = 2004,
    GestureTag = "Gesture",
    Name = "姿势：隐蔽之所",
    ReleaseWheel = 41004
  },
  [2005] = {
    GestureId = 2005,
    GestureTag = "Gesture",
    Name = "姿势：箱中之猫·铅灰",
    ReleaseWheel = 41005
  },
  [2006] = {
    GestureId = 2006,
    GestureTag = "Gesture",
    Name = "姿势：箱中之猫·白樱",
    ReleaseWheel = 41006
  },
  [2007] = {
    GestureId = 2007,
    GestureTag = "Gesture",
    Name = "姿势：宝箱诱惑",
    ReleaseWheel = 41010
  },
  [2008] = {
    GestureId = 2008,
    GestureTag = "Gesture",
    Name = "姿势：床的束缚",
    ReleaseWheel = 41011
  },
  [2009] = {
    GestureId = 2009,
    GestureTag = "Gesture",
    Name = "姿势：弦上诗篇·黛蓝",
    ReleaseWheel = 41012
  },
  [2010] = {
    GestureId = 2010,
    GestureTag = "Gesture",
    Name = "姿势：“绝不空军”",
    ReleaseWheel = 41013
  },
  [2011] = {
    GestureId = 2011,
    GestureTag = "Gesture",
    Name = "姿势：极速定格·本色",
    ReleaseWheel = 41014
  },
  [2012] = {
    GestureId = 2012,
    GestureTag = "Gesture",
    Name = "姿势：弦上诗篇·焦糖",
    ReleaseWheel = 41015
  },
  [2013] = {
    GestureId = 2013,
    GestureTag = "Gesture",
    Name = "姿势：弦上诗篇·涅白",
    ReleaseWheel = 41016
  },
  [2014] = {
    GestureId = 2014,
    GestureTag = "Gesture",
    Name = "姿势：极速定格·白樱",
    ReleaseWheel = 41017
  },
  [2015] = {
    GestureId = 2015,
    GestureTag = "Gesture",
    Name = "姿势：极速定格·鎏金",
    ReleaseWheel = 41018
  },
  [2016] = {
    GestureId = 2016,
    GestureTag = "Gesture",
    Name = "姿势：泡泡泡泡鸭",
    ReleaseWheel = 41019
  },
  [2017] = {
    GestureId = 2017,
    GestureTag = "Gesture",
    Name = "姿势：悠游水岸·本色",
    ReleaseWheel = 41020
  },
  [2018] = {
    GestureId = 2018,
    GestureTag = "Gesture",
    Name = "姿势：悠游水岸·白樱",
    ReleaseWheel = 41021
  },
  [2019] = {
    GestureId = 2019,
    GestureTag = "Gesture",
    Name = "姿势：悠游水岸·黛蓝",
    ReleaseWheel = 41022
  },
  [2020] = {
    GestureId = 2020,
    GestureTag = "Gesture",
    Name = "姿势：技能五子棋",
    ReleaseWheel = 41028
  },
  [2021] = {
    GestureId = 2021,
    GestureTag = "Gesture",
    Name = "姿势：幻想骑士一式",
    ReleaseWheel = 41029
  },
  [2022] = {
    GestureId = 2022,
    GestureTag = "Gesture",
    Name = "姿势：幻想骑士二式",
    ReleaseWheel = 41030
  },
  [2023] = {
    GestureId = 2023,
    GestureTag = "Gesture",
    Name = "姿势：承露",
    ReleaseWheel = 41031
  },
  [2024] = {
    GestureId = 2024,
    GestureTag = "Gesture",
    Name = "睥睨山河·鎏金",
    ReleaseWheel = 41032
  },
  [2025] = {
    GestureId = 2025,
    GestureTag = "Gesture",
    Name = "幻想整备",
    ReleaseWheel = 41033
  },
  [2026] = {
    GestureId = 2026,
    GestureTag = "Gesture",
    Name = "林梢日光",
    ReleaseWheel = 41034
  },
  [2027] = {
    GestureId = 2027,
    GestureTag = "Gesture",
    Name = "林梢日光·鎏金",
    ReleaseWheel = 41035
  },
  [2028] = {
    GestureId = 2028,
    GestureTag = "Gesture",
    Name = "高雅人士",
    ReleaseWheel = 41036
  },
  [2029] = {
    GestureId = 2029,
    GestureTag = "Gesture",
    Name = "睥睨山河·铅灰",
    ReleaseWheel = 41040
  },
  [2030] = {
    GestureId = 2030,
    GestureTag = "Gesture",
    Name = "睥睨山河·绛紫",
    ReleaseWheel = 41041
  },
  [2031] = {
    GestureId = 2031,
    GestureTag = "Gesture",
    Name = "转动螺旋",
    ReleaseWheel = 41046
  },
  [2032] = {
    GestureId = 2032,
    GestureTag = "Gesture",
    Name = "慷慨解囊",
    ReleaseWheel = 41047
  },
  [2033] = {
    GestureId = 2033,
    GestureTag = "Gesture",
    Name = "请求",
    ReleaseWheel = 41048
  },
  [2034] = {
    GestureId = 2034,
    GestureTag = "Gesture",
    Name = "火辣派对",
    ReleaseWheel = 41049
  },
  [2035] = {
    GestureId = 2035,
    GestureTag = "Gesture",
    Name = "抽陀螺",
    ReleaseWheel = 41050
  },
  [2036] = {
    GestureId = 2036,
    GestureTag = "Gesture",
    Name = "机枢幻想·涅白",
    ReleaseWheel = 41051
  },
  [2037] = {
    GestureId = 2037,
    GestureTag = "Gesture",
    Name = "休息一式",
    ReleaseWheel = 41052
  },
  [2038] = {
    GestureId = 2038,
    GestureTag = "Gesture",
    Name = "休息二式",
    ReleaseWheel = 41053
  },
  [2039] = {
    GestureId = 2039,
    GestureTag = "Gesture",
    Name = "机枢幻想·锈红",
    ReleaseWheel = 41054
  },
  [2040] = {
    GestureId = 2040,
    GestureTag = "Gesture",
    Name = "机枢幻想·墨玉",
    ReleaseWheel = 41055
  },
  [2041] = {
    GestureId = 2041,
    GestureTag = "Gesture",
    Name = "出拳",
    ReleaseWheel = 41056
  },
  [2042] = {
    GestureId = 2042,
    GestureTag = "Gesture",
    Name = "小熊出没",
    ReleaseWheel = 41057
  },
  [2043] = {
    GestureId = 2043,
    GestureTag = "Gesture",
    Name = "罪壤·锈红",
    ReleaseWheel = 41058
  },
  [2044] = {
    GestureId = 2044,
    GestureTag = "Gesture",
    Name = "月台等候",
    ReleaseWheel = 41059
  },
  [2045] = {
    GestureId = 2045,
    GestureTag = "Gesture",
    Name = "姿势：滴答舞步",
    ReleaseWheel = 41060
  },
  [2046] = {
    GestureId = 2046,
    GestureTag = "Gesture",
    Name = "行驶号令",
    ReleaseWheel = 41061
  },
  [2047] = {
    GestureId = 2047,
    GestureTag = "Gesture",
    Name = "罪壤·鎏金",
    ReleaseWheel = 41062
  },
  [2048] = {
    GestureId = 2048,
    GestureTag = "Gesture",
    Name = "罪壤·晴蓝",
    ReleaseWheel = 41063
  },
  [2049] = {
    GestureId = 2049,
    GestureTag = "Gesture",
    Name = "初雪小夜曲",
    ReleaseWheel = 41064
  },
  [2050] = {
    GestureId = 2050,
    GestureTag = "Gesture",
    Name = "琉璃之心",
    ReleaseWheel = 41065
  },
  [2051] = {
    GestureId = 2051,
    GestureTag = "Gesture",
    Name = "伸展运动",
    ReleaseWheel = 41066
  },
  [2052] = {
    GestureId = 2052,
    GestureTag = "Gesture",
    Name = "初雪小夜曲02",
    ReleaseWheel = 41067
  },
  [2053] = {
    GestureId = 2053,
    GestureTag = "Gesture",
    Name = "初雪小夜曲03",
    ReleaseWheel = 41068
  }
})
