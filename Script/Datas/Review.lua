local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Review", {
  [1001] = {
    FinishCondition = 11020102,
    QuestChainId = 110201,
    ReviewContent = "UI_ReviewContent_1001",
    ReviewID = 1001,
    ReviewName = "UI_ReviewName_1001",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0050.T_StringBoard_Main_0050'",
    ReviewType = 1,
    UnlockCondition = 11020101
  },
  [1002] = {
    FinishCondition = 11020104,
    QuestChainId = 110201,
    ReviewContent = "UI_ReviewContent_1002",
    ReviewID = 1002,
    ReviewName = "UI_ReviewName_1002",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0051.T_StringBoard_Main_0051'",
    ReviewType = 1,
    UnlockCondition = 11020102
  },
  [1003] = {
    FinishCondition = 11020104,
    QuestChainId = 110201,
    ReviewContent = "UI_ReviewContent_1003",
    ReviewID = 1003,
    ReviewName = "UI_ReviewName_1003",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0052.T_StringBoard_Main_0052'",
    ReviewType = 1,
    UnlockCondition = 11020104
  },
  [1004] = {
    FinishCondition = 11020201,
    QuestChainId = 110202,
    ReviewContent = "UI_ReviewContent_1004",
    ReviewID = 1004,
    ReviewName = "UI_ReviewName_1004",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0053.T_StringBoard_Main_0053'",
    ReviewType = 1,
    UnlockCondition = 11020104
  },
  [1005] = {
    FinishCondition = 11020301,
    QuestChainId = 110203,
    ReviewContent = "UI_ReviewContent_1005",
    ReviewID = 1005,
    ReviewName = "UI_ReviewName_1005",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0054.T_StringBoard_Main_0054'",
    ReviewType = 1,
    UnlockCondition = 11020301
  },
  [1006] = {
    FinishCondition = 11020302,
    QuestChainId = 110203,
    ReviewContent = "UI_ReviewContent_1006",
    ReviewID = 1006,
    ReviewName = "UI_ReviewName_1006",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0055.T_StringBoard_Main_0055'",
    ReviewType = 1,
    UnlockCondition = 11020301
  },
  [1007] = {
    FinishCondition = 110211,
    QuestChainId = 110211,
    ReviewContent = "UI_ReviewContent_1007",
    ReviewID = 1007,
    ReviewName = "UI_ReviewName_1007",
    ReviewPic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0056.T_StringBoard_Main_0056'",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0057.T_StringBoard_Main_0057'",
    ReviewType = 1,
    UnlockCondition = 11020302
  },
  [1008] = {
    FinishCondition = 110212,
    QuestChainId = 110212,
    ReviewContent = "UI_ReviewContent_1008",
    ReviewID = 1008,
    ReviewName = "UI_ReviewName_1008",
    ReviewPic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0058.T_StringBoard_Main_0058'",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0059.T_StringBoard_Main_0059'",
    ReviewType = 1,
    UnlockCondition = 11020302
  },
  [1009] = {
    FinishCondition = 110213,
    QuestChainId = 110213,
    ReviewContent = "UI_ReviewContent_1009",
    ReviewID = 1009,
    ReviewName = "UI_ReviewName_1009",
    ReviewPic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0020.T_StringBoard_Main_0020'",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0021.T_StringBoard_Main_0021'",
    ReviewType = 1,
    UnlockCondition = 11020302
  },
  [1010] = {
    FinishCondition = 110214,
    QuestChainId = 110214,
    ReviewContent = "UI_ReviewContent_1010",
    ReviewID = 1010,
    ReviewName = "UI_ReviewName_1010",
    ReviewPic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0024.T_StringBoard_Main_0024'",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0063.T_StringBoard_Main_0063'",
    ReviewType = 1,
    UnlockCondition = 11020302
  },
  [1011] = {
    FinishCondition = 110215,
    QuestChainId = 110215,
    ReviewContent = "UI_ReviewContent_1011",
    ReviewID = 1011,
    ReviewName = "UI_ReviewName_1011",
    ReviewPic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0064.T_StringBoard_Main_0064'",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0065_2.T_StringBoard_Main_0065_2'",
    ReviewType = 1,
    UnlockCondition = 11020302
  },
  [1012] = {
    FinishCondition = 11022002,
    QuestChainId = 110220,
    ReviewContent = "UI_ReviewContent_1012",
    ReviewID = 1012,
    ReviewName = "UI_ReviewName_1012",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0066.T_StringBoard_Main_0066'",
    ReviewType = 1,
    UnlockCondition = 11022001
  },
  [1013] = {
    FinishCondition = 1102200101,
    QuestChainId = 110220,
    ReviewContent = "UI_ReviewContent_1013",
    ReviewID = 1013,
    ReviewName = "UI_ReviewName_1013",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0067.T_StringBoard_Main_0067'",
    ReviewType = 1,
    UnlockCondition = 1102200101
  },
  [1014] = {
    FinishCondition = 11022001,
    QuestChainId = 110220,
    ReviewContent = "UI_ReviewContent_1014",
    ReviewID = 1014,
    ReviewName = "UI_ReviewName_1014",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0068.T_StringBoard_Main_0068'",
    ReviewType = 1,
    UnlockCondition = 11022000
  },
  [1015] = {
    FinishCondition = 110221,
    QuestChainId = 110221,
    ReviewContent = "UI_ReviewContent_1015",
    ReviewID = 1015,
    ReviewName = "UI_ReviewName_1015",
    ReviewPic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0069.T_StringBoard_Main_0069'",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0025.T_StringBoard_Main_0025'",
    ReviewType = 1,
    UnlockCondition = 11022002
  },
  [1016] = {
    FinishCondition = 110222,
    QuestChainId = 110222,
    ReviewContent = "UI_ReviewContent_1016",
    ReviewID = 1016,
    ReviewName = "UI_ReviewName_1016",
    ReviewPic1 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0071.T_StringBoard_Main_0071'",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0072.T_StringBoard_Main_0072'",
    ReviewType = 1,
    UnlockCondition = 11022002
  },
  [1017] = {
    FinishCondition = 11023101,
    QuestChainId = 110231,
    ReviewContent = "UI_ReviewContent_1017",
    ReviewID = 1017,
    ReviewName = "UI_ReviewName_1017",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0073.T_StringBoard_Main_0073'",
    ReviewType = 1,
    UnlockCondition = 11023100
  },
  [1018] = {
    FinishCondition = 11023102,
    QuestChainId = 110231,
    ReviewContent = "UI_ReviewContent_1018",
    ReviewID = 1018,
    ReviewName = "UI_ReviewName_1018",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0074.T_StringBoard_Main_0074'",
    ReviewType = 1,
    UnlockCondition = 11023101
  },
  [1019] = {
    FinishCondition = 11023104,
    QuestChainId = 110231,
    ReviewContent = "UI_ReviewContent_1019",
    ReviewID = 1019,
    ReviewName = "UI_ReviewName_1019",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0075.T_StringBoard_Main_0075'",
    ReviewType = 1,
    UnlockCondition = 11023102
  },
  [1020] = {
    FinishCondition = 11023201,
    QuestChainId = 110232,
    ReviewContent = "UI_ReviewContent_1020",
    ReviewID = 1020,
    ReviewName = "UI_ReviewName_1020",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0076.T_StringBoard_Main_0076'",
    ReviewType = 1,
    UnlockCondition = 11023104
  },
  [1021] = {
    FinishCondition = 11023203,
    QuestChainId = 110232,
    ReviewContent = "UI_ReviewContent_1021",
    ReviewID = 1021,
    ReviewName = "UI_ReviewName_1021",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0077.T_StringBoard_Main_0077'",
    ReviewType = 1,
    UnlockCondition = 11023201
  },
  [1022] = {
    FinishCondition = 11023204,
    QuestChainId = 110232,
    ReviewContent = "UI_ReviewContent_1022",
    ReviewID = 1022,
    ReviewName = "UI_ReviewName_1022",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0078.T_StringBoard_Main_0078'",
    ReviewType = 1,
    UnlockCondition = 11023203
  },
  [1023] = {
    FinishCondition = 11023205,
    QuestChainId = 110232,
    ReviewContent = "UI_ReviewContent_1023",
    ReviewID = 1023,
    ReviewName = "UI_ReviewName_1023",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0079.T_StringBoard_Main_0079'",
    ReviewType = 3,
    UnlockCondition = 11023204
  },
  [1024] = {
    FinishCondition = 110233,
    QuestChainId = 110233,
    ReviewContent = "UI_ReviewContent_1024",
    ReviewID = 1024,
    ReviewName = "UI_ReviewName_1024",
    ReviewPic2 = "Texture2D'/Game/UI/Texture/Dynamic/Image/StringBoard/T_StringBoard_Main_0080.T_StringBoard_Main_0080'",
    ReviewType = 2,
    UnlockCondition = 11023205
  }
})
