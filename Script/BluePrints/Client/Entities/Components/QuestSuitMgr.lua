local Component = {}

function Component:GetQuestChainSuit(QuestChainId)
  if not QuestChainId then
    return
  end
  local QuestChain = self.QuestChains and self.QuestChains[QuestChainId]
  if not QuestChain then
    return
  end
  return QuestChain.Suit
end

function Component:GetQuestChainBGMSuitBase(QuestChainId)
  local QuestChainSuit = self:GetQuestChainSuit(QuestChainId)
  if not QuestChainSuit then
    return
  end
  return QuestChainSuit:GetBGMSuitBase()
end

function Component:GetQuestChainBGMParamsSuitBase(QuestChainId)
  local QuestChainSuit = self:GetQuestChainSuit(QuestChainId)
  if not QuestChainSuit then
    return
  end
  return QuestChainSuit:GetBGMParamsSuitBase()
end

return Component
