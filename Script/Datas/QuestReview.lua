local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("QuestReview", {
  [1] = {
    QuestReviewId = 1,
    QuestReviewName = "Name_1301",
    QuestchainId = {130101}
  }
})
