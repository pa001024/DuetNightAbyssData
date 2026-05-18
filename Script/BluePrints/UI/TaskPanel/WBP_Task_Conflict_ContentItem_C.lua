require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local TaskUtil = require("BluePrints.UI.TaskPanel.TaskUtils")

function M:Construct()
  EventManager:AddEvent(EventID.OnBlockQuestSelect, self, self.OnBlockQuestSelect)
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnBlockQuestSelect, self)
end

function M:OnListItemObjectSet(Content)
  self.QuestChainId = Content.QuestChainId
  self.ChapId = Content.ChapId
  local QuestConfig = DataMgr.QuestChain[self.QuestChainId]
  if not QuestConfig then
    return
  end
  local TaskArea = DataMgr.TextMap[QuestConfig.ChapterName] and GText(QuestConfig.ChapterName) or GText("UI_QUEST_UNKNOWN")
  local ChapterName = DataMgr.TextMap[QuestConfig.QuestChainName] and GText(QuestConfig.QuestChainName) or GText("UI_QUEST_UNKNOWN")
  local Chapter = DataMgr.TextMap[QuestConfig.EpisodeName] and GText(QuestConfig.EpisodeName) or GText("UI_QUEST_UNKNOWN")
  local QuestChainType = DataMgr.QuestChain[self.QuestChainId].QuestChainType
  self.Text_TaskName:SetText(ChapterName)
  self.Text_TaskPosition:SetText(Chapter .. " " .. TaskArea)
  self.Com_List01BG.Button_Area.OnClicked:Add(self, self.OnCellClicked)
  if QuestChainType == Const.MainQuestChainType or QuestChainType == Const.MainActivityQuestChainType then
    self:PlayAnimation(self.MainColor)
  elseif 2 == QuestChainType then
    self:PlayAnimation(self.DailyColor)
  elseif QuestChainType == Const.SideQuestChainType then
    self:PlayAnimation(self.SideColor)
  elseif QuestChainType == Const.LimTimeQuestChainType or QuestChainType == Const.SpecialSideQuestChainType then
    self:PlayAnimation(self.SpecialColor)
  end
end

function M:OnCellClicked()
  local CurrSelectChapId = TaskUtil:GetChooseCharId()
  if CurrSelectChapId == self.ChapId then
    TaskUtil:SetBlockQuestToStart()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    self:PlayAnimation(self.Normal)
  else
    TaskUtil:SetBlockQuestToStart(self.ChapId)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
    self:PlayAnimation(self.Click)
  end
  EventManager:FireEvent(EventID.OnBlockQuestSelect, TaskUtil:GetChooseCharId())
end

function M:OnBlockQuestSelect(SelectChapId)
  if SelectChapId ~= self.ChapId then
    self:PlayAnimation(self.Normal)
  else
    self:PlayAnimation(self.Click)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self:OnCellClicked()
  return UIUtils.Handled
end

function M:OnFocusLost(MyGeometry, InFocusEvent)
  self:PlayAnimation(self.Normal)
  return UIUtils.Handled
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    return false
  end
end

return M
