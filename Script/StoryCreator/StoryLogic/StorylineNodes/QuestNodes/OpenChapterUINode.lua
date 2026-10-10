local OpenChapterUINode = Class("StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode")
local ClientEventUtils = require("BluePrints.Common.ClientEvent.ClientEventUtils")
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
OpenChapterUINode._components = {
  "StoryCreator.StoryLogic.StorylineNodes.QuestNodes.GuideNodeComp"
}

function OpenChapterUINode:Init()
end

function OpenChapterUINode:Start(Context)
  EventManager:AddEvent(EventID.UnLoadUI, self, self.FinishAction)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.CurQuestChainId = self.QuestChainId
  if Avatar.InSpecialQuest and ClientEventUtils:GetCurrentEvent() and ClientEventUtils:GetCurrentEvent().PreQuestChainId then
    self.CurQuestChainId = ClientEventUtils:GetCurrentEvent().PreQuestChainId
  end
  if Avatar.QuestChains[self.CurQuestChainId] then
    self.CurDoingQuestId = Avatar.QuestChains[self.CurQuestChainId].DoingQuestId
  end
  local Info = DataMgr.QuestUI[self.ChapterUIId]
  self.UIName = Info.UIName
  local GameInstance = GWorld.GameInstance
  local QuestData = TaskUtils:GetQuestDetail(self.CurQuestChainId, self.CurDoingQuestId)
  if QuestData and QuestData.EndingId then
    local QuestEndData = DataMgr.QuestEnd[QuestData.EndingId]
    if QuestEndData then
      self.UIType = "BackUp"
      self.EndingData = QuestEndData
    end
  end
  UIManager(GameInstance):LoadUINew(self.UIName, self.ChapterUIId, self.UIType, self.EndingData)
end

function OpenChapterUINode:FinishAction(UIName)
  if UIName == self.UIName then
    EventManager:RemoveEvent(EventID.UnLoadUI, self)
    self:Finish()
  end
end

function OpenChapterUINode:Clear()
  EventManager:RemoveEvent(EventID.UnLoadUI, self)
end

AssembleComponents(OpenChapterUINode)
return OpenChapterUINode
