require("UnLua")
local UIUtils = require("Utils.UIUtils")
local QuestReviewUtils = {}

function QuestReviewUtils:GetSortedReviewList()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.QuestBacktracks then
    return {}
  end
  local List = {}
  for _, Cfg in pairs(DataMgr.QuestReview or {}) do
    if Cfg then
      table.insert(List, Cfg)
    end
  end
  table.sort(List, function(A, B)
    return A.QuestReviewId < B.QuestReviewId
  end)
  return List
end

function QuestReviewUtils:CreateChapterContent(Content)
  local Object = NewObject(UIUtils.GetCommonItemContentClass())
  Object.QuestReviewId = Content.QuestReviewId
  Object.OwnerWidget = Content.OwnerWidget
  return Object
end

function QuestReviewUtils:GetReviewIdByQuestChainId(QuestChainId)
  local Map = DataMgr.QuestChainId2QuestReviewId
  if not Map or not QuestChainId then
    return nil
  end
  return Map[QuestChainId]
end

return QuestReviewUtils
