local Component = {}

function Component:RedoQuestBacktrack(QuestId, InCallback)
  self.logger.debug("RedoQuestBacktrack Begin", QuestId)
  
  local function Callback(Ret)
    self.logger.debug("RedoQuestBacktrack Callback", Ret, QuestId)
    if InCallback then
      InCallback(Ret, QuestId)
    end
  end
  
  self:CallServer("RedoQuestBacktrack", Callback, QuestId)
end

function Component:GiveUpQuestBacktrack(QuestChainId, InCallback)
  self.logger.debug("GiveUpQuestBacktrack Begin", QuestChainId)
  
  local function Callback(Ret)
    self.logger.debug("GiveUpQuestBacktrack Callback", Ret, QuestChainId)
    if InCallback then
      InCallback(Ret, QuestChainId)
    end
  end
  
  self:CallServer("GiveUpQuestBacktrack", Callback, QuestChainId)
end

return Component
