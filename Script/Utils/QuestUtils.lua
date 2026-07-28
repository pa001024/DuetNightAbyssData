local QuestUtils = {}

function QuestUtils:GetQuestChainId_QuestId(QuestId)
  if not QuestId then
    return 0
  end
  return tonumber(string.sub(QuestId, 1, 6))
end

function QuestUtils:GetSTLQuestChain(QuestChainId)
  local STLQuestChain = DataMgr.STLExportQuestChain[QuestChainId]
  if not STLQuestChain then
    DebugPrint("ERROR::", "@lzc GetSTLQuestChain 该任务链不存在STL信息", QuestChainId)
  end
  return STLQuestChain
end

function QuestUtils:GetSTLQuest(QuestId, QuestChainId, STLQuestChain)
  if not QuestId then
    DebugPrint("ERROR::", "@lzc GetSTLQuest QuestId为空", QuestId)
    return
  end
  QuestChainId = QuestChainId or self:GetQuestChainId_QuestId(QuestId)
  STLQuestChain = STLQuestChain or self:GetSTLQuestChain(QuestChainId)
  if not STLQuestChain then
    DebugPrint("ERROR::", "@lzc GetSTLQuest STLNode为空", QuestId, QuestChainId)
    return
  end
  local Quests = STLQuestChain.Quests or {}
  local STLQuest = Quests[QuestId]
  if not STLQuest then
    DebugPrint("ERROR::", "@lzc GetSTLQuest 任务不存在", QuestId, QuestChainId)
    return
  end
  return STLQuest, STLQuestChain, QuestChainId
end

function QuestUtils:IsPreQuest(QuestId, STLQuest)
  STLQuest = STLQuest or self:GetSTLQuest(QuestId) or {}
  return STLQuest.IsPreQuest
end

return QuestUtils
