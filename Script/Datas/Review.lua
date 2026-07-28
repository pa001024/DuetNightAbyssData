local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Review", {
  [110201] = {
    FinishCondition = 11020102,
    QuestChainId = 110201,
    ReviewContent = "UI_ReviewName_10020101",
    ReviewID = 110201,
    ReviewName = "UI_ReviewName_10020101",
    ReviewPic1 = "路径A",
    ReviewPic2 = "路径B",
    ReviewType = 1,
    UnlockCondition = 11020101
  },
  [110202] = {
    FinishCondition = 11020202,
    QuestChainId = 110202,
    ReviewContent = "UI_ReviewName_10020102",
    ReviewID = 110202,
    ReviewName = "UI_ReviewName_10020102",
    ReviewPic1 = "路径A",
    ReviewPic2 = "路径B",
    ReviewType = 2,
    UnlockCondition = 11020201
  },
  [110203] = {
    FinishCondition = 11020302,
    QuestChainId = 110203,
    ReviewContent = "UI_ReviewName_10020103",
    ReviewID = 110203,
    ReviewName = "UI_ReviewName_10020103",
    ReviewPic1 = "路径A",
    ReviewPic2 = "路径B",
    ReviewType = 3,
    UnlockCondition = 11020301
  },
  [110211] = {ReviewID = 110211},
  [110212] = {ReviewID = 110212},
  [110213] = {ReviewID = 110213}
})
