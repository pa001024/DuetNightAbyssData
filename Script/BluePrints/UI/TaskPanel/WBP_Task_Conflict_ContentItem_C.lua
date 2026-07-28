require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local TaskUtil = require("BluePrints.UI.TaskPanel.TaskUtils")

function M:Initialize(Initializer)
  self.bPressed = nil
  self.bHovered = nil
end

function M:Construct()
  EventManager:AddEvent(EventID.OnBlockQuestSelect, self, self.OnBlockQuestSelect)
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnBlockQuestSelect, self)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
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
  self:UpdateTaskIcon()
  self.Text_TaskPosition:SetText(Chapter .. " " .. TaskArea)
  self:UpdateQuestDetail()
  self.Com_List01BG.Button_Area.OnClicked:Add(self, self.OnCellClicked)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    self.Com_List01BG.Button_Area.OnHovered:Add(self, self.OnCellHovered)
    self.Com_List01BG.Button_Area.OnUnHovered:Add(self, self.OnCellUnhovered)
  end
  self.Com_List01BG.Button_Area.OnPressed:Add(self, self.OnCellPressed)
  self.Com_List01BG.Button_Area.OnReleased:Add(self, self.OnCellReleased)
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
  else
    TaskUtil:SetBlockQuestToStart(self.ChapId)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
  end
  if self.Content and self.Content.CallbackInfo and self.Content.CallbackInfo[1] and self.Content.CallbackInfo[2] then
    self.Content.CallbackInfo[2](self.Content.CallbackInfo[1], self.ChapId, self.Content)
  end
  EventManager:FireEvent(EventID.OnBlockQuestSelect, TaskUtil:GetChooseCharId())
end

function M:OnBlockQuestSelect(SelectChapId)
  if SelectChapId ~= self.ChapId then
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
    self:OnCellClicked()
    if self.ScrollBox and self.ScrollBox.GetScrollOffsetOfEnd then
      local Value = self.ScrollBox:GetScrollOffsetOfEnd()
      if self.Content.CallbackInfo and self.Content.CallbackInfo[3] then
        self.Content.CallbackInfo[3](self.Content.CallbackInfo[1], Value > 0)
      end
    end
  end
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

function M:UpdateTaskIcon()
  if not self.QuestChainId then
    return
  end
  local QuestChainData = DataMgr.QuestChain and DataMgr.QuestChain[self.QuestChainId]
  if not QuestChainData then
    return
  end
  local Icon
  local QuestChainType = QuestChainData.QuestChainType
  for Index, TabData in pairs(DataMgr.QuestTab) do
    if TabData.QuestType == QuestChainType then
      Icon = TabData.Icon
      break
    end
  end
  if not Icon then
    return
  end
  if self.Image_TaskTypeIcon then
    self.Image_TaskTypeIcon:SetBrushResourceObject(LoadObject(Icon))
  end
end

function M:UpdateQuestDetail()
  if not self.QuestChainId then
    return
  end
  local QuestChainData = DataMgr.QuestChain[self.QuestChainId]
  if not QuestChainData then
    return
  end
  if self.Text_TaskDetail then
    self.Text_TaskDetail:SetText(GText(QuestChainData.QuestDetail))
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local AddOffset = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
  if "Gamepad_RightY" == InKeyName then
    local CurScrollOffset = self.ScrollBox:GetScrollOffset()
    self.ScrollBox:SetScrollOffset(CurScrollOffset - AddOffset)
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnCellHovered()
  if TaskUtil:GetChooseCharId() ~= self.ChapId then
    self:PlayAnimation(self.Hover)
  end
  self.bHovered = true
end

function M:OnCellUnhovered()
  if TaskUtil:GetChooseCharId() ~= self.ChapId and self.bHovered then
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
  end
  self.bHovered = false
end

function M:OnCellPressed()
  self:PlayAnimation(self.Press)
  self.bPressed = true
  self.bHovered = false
end

function M:OnCellReleased()
  if self.bPressed then
    self:PlayAnimation(self.Click)
    self.bPressed = false
  end
  self.bHovered = false
end

return M
