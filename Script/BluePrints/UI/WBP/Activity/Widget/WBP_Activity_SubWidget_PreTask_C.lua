require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitPage(EventId)
  self.EventId = EventId
  self.EventInfo = DataMgr.EventMain[self.EventId]
  if not self.EventInfo then
    ScreenPrint("初始化前置任务组件读表失败！EventId:", self.EventId)
    return
  end
  self:UpdateVisibility()
  self.Text_TaskTitle:SetText(GText("UI_PretextTasks"))
  self.TaskListContents = {}
  local MainQuestInfo = self:GetMainQuestInfo()
  if MainQuestInfo.DisplayTextName then
    local MainQuestContent = NewObject(UIUtils.GetCommonItemContentClass())
    MainQuestContent.ParentWidget = self
    MainQuestContent.OnClickedParams = {
      Obj = self,
      Callback = self.OnClicked_TaskBtn,
      Params = table.pack(MainQuestInfo.JumpQuestChainId)
    }
    MainQuestContent.BtnName = "Main"
    MainQuestContent.DisplayText = MainQuestInfo.DisplayTextName
    MainQuestContent.IsShowLock = MainQuestInfo.IsShowLock
    MainQuestContent.IsForbidClick = MainQuestInfo.IsForbidClick
    MainQuestContent.IsShowFinish = MainQuestInfo.IsShowFinish
    self.List_Task:AddItem(MainQuestContent)
    table.insert(self.TaskListContents, MainQuestContent)
  end
  local SideQuestInfoList = self:GetSideQuestInfoList()
  for _, SideQuestInfo in pairs(SideQuestInfoList or {}) do
    if SideQuestInfo.DisplayTextName then
      local SideQuestContent = NewObject(UIUtils.GetCommonItemContentClass())
      SideQuestContent.ParentWidget = self
      SideQuestContent.OnClickedParams = {
        Obj = self,
        Callback = self.OnClicked_TaskBtn,
        Params = table.pack(SideQuestInfo.JumpQuestChainId)
      }
      SideQuestContent.BtnName = "Side"
      SideQuestContent.DisplayText = SideQuestInfo.DisplayTextName
      SideQuestContent.IsShowLock = SideQuestInfo.IsShowLock
      SideQuestContent.IsForbidClick = SideQuestInfo.IsForbidClick
      SideQuestContent.IsShowFinish = SideQuestInfo.IsShowFinish
      SideQuestContent.IsShowTip = SideQuestInfo.IsShowTip
      SideQuestContent.TipText = SideQuestInfo.TipText
      SideQuestContent.SideQuestChainId = SideQuestInfo.SideQuestChainId
      self.List_Task:AddItem(SideQuestContent)
      table.insert(self.TaskListContents, SideQuestContent)
    end
  end
  self.Key_PerTaskTitle:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    }
  })
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(self.GameInputModeSubsystem) then
    self:OnUpdateSubUIViewStyle(self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad)
  end
end

function M:UpdatePage()
  self:UpdateVisibility()
  for _, QuestContent in pairs(self.TaskListContents) do
    if IsValid(QuestContent) then
      local NewQuestInfo = {}
      if QuestContent.BtnName == "Main" then
        NewQuestInfo = self:GetMainQuestInfo()
      elseif QuestContent.BtnName == "Side" then
        NewQuestInfo = self:GetSideQuestInfoNew(QuestContent.SideQuestChainId)
      end
      QuestContent.OnClickedParams = {
        Obj = self,
        Callback = self.OnClicked_TaskBtn,
        Params = table.pack(NewQuestInfo.JumpQuestChainId)
      }
      QuestContent.DisplayText = NewQuestInfo.DisplayTextName
      QuestContent.IsShowLock = NewQuestInfo.IsShowLock
      QuestContent.IsForbidClick = NewQuestInfo.IsForbidClick
      QuestContent.IsShowFinish = NewQuestInfo.IsShowFinish
      QuestContent.IsShowTip = NewQuestInfo.IsShowTip
      QuestContent.TipText = NewQuestInfo.TipText
      QuestContent.SideQuestChainId = NewQuestInfo.SideQuestChainId
      QuestContent.SelfWidget:OnListItemObjectSet(QuestContent)
    end
  end
end

function M:UpdateVisibility()
  self.IsShow = self:IsNeedShow()
  DebugPrint("PreTaskSubWidget:UpdateVisibility IsShow", self.IsShow)
  if self.IsShow then
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:OnSubWidgetReceivedFocus()
  if self.IsShow then
    self.List_Task:SetFocus()
    self.Key_PerTaskTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  return "SelectView", self.List_Task
end

function M:OnSubWidgetLostFocus()
  if self.IsShow then
    self.Key_PerTaskTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  return nil, nil
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad)
  if self.IsShow then
    if IsUseGamePad then
      self.Key_PerTaskTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      self.Key_PerTaskTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:IsNeedShow()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local EventInfo = DataMgr.EventMain[self.EventId]
  if not EventInfo then
    ScreenPrint("EventMain表中找不到止流活动相关信息！读取的EventId:" .. self.EventId)
    return false
  end
  local PrerequisiteQuestId = {}
  if EventInfo.PretextTasks1 then
    table.insert(PrerequisiteQuestId, EventInfo.PretextTasks1)
  end
  for _, QuestId in pairs(EventInfo.PretextTasks2 or {}) do
    table.insert(PrerequisiteQuestId, QuestId)
  end
  for _, QuestId in pairs(PrerequisiteQuestId) do
    local IsQuestFinished = Avatar:IsQuestFinished(QuestId)
    local IsQuestAssumeFinished = Avatar:IsQuestAssumeFinished(QuestId)
    if not IsQuestFinished and not IsQuestAssumeFinished then
      return true
    end
  end
  return false
end

function M:OnClicked_TaskBtn(JumpQuestChainId)
  DebugPrint("OnClicked_JumpQuestChainId", JumpQuestChainId)
  PageJumpUtils:JumpToTargetPageByJumpId(23, JumpQuestChainId)
end

function M:GetMainQuestInfo()
  local Res = {}
  local ConfigedMainQuestChainId = self.EventInfo.PretextTasks1
  if not ConfigedMainQuestChainId then
    return Res
  end
  local ConfigedMainQuestChainState = self:GetQuestChainState(ConfigedMainQuestChainId)
  if "Unlock" == ConfigedMainQuestChainState then
    local Avatar = GWorld:GetAvatar()
    for QuestChainId, Data in pairs(Avatar.QuestChains) do
      local QuestChainType = DataMgr.QuestChain[QuestChainId].QuestChainType
      if QuestChainType == Const.MainQuestChainType and Data:IsDoing() then
        Res.JumpQuestChainId = QuestChainId
        break
      end
    end
    Res.IsShowLock = true
    Res.IsForbidClick = false
  else
    Res.JumpQuestChainId = ConfigedMainQuestChainId
    Res.IsShowLock = false
    if "Doing" == ConfigedMainQuestChainState then
      Res.IsForbidClick = false
      Res.IsShowFinish = false
    else
      Res.IsForbidClick = true
      Res.IsShowFinish = true
    end
  end
  local ChapterName = DataMgr.QuestChain[ConfigedMainQuestChainId].ChapterName or ""
  local QuestChainName = DataMgr.QuestChain[ConfigedMainQuestChainId].QuestChainName or ""
  Res.DisplayTextName = GText(ChapterName) .. "·" .. GText(QuestChainName)
  return Res
end

function M:GetSideQuestInfoList()
  local Res = {}
  local ConfigedSideQuestChainIds = self.EventInfo.PretextTasks2
  if not ConfigedSideQuestChainIds then
    return Res
  end
  for _, SideQuestChainId in pairs(ConfigedSideQuestChainIds) do
    table.insert(Res, self:GetSideQuestInfoNew(SideQuestChainId))
  end
  return Res
end

function M:GetSideQuestInfoNew(SideQuestChainId)
  local Res = {}
  local SideQuestChainState = self:GetQuestChainStateNew(SideQuestChainId)
  if "Finish" == SideQuestChainState then
    Res.IsShowFinish = true
    Res.IsForbidClick = true
  elseif "Doing" == SideQuestChainState then
    Res.JumpQuestChainId = SideQuestChainId
  elseif "Unlock" == SideQuestChainState then
    Res.IsShowTip = true
    Res.TipText = self:GetSideTipTextByQuestChainId(SideQuestChainId, SideQuestChainState)
  elseif "Lock" == SideQuestChainState then
    Res.IsShowLock = true
    Res.IsShowTip = true
    Res.TipText = self:GetSideTipTextByQuestChainId(SideQuestChainId, SideQuestChainState)
  end
  local QuestChain = DataMgr.QuestChain[SideQuestChainId]
  if QuestChain then
    local ChapterName = QuestChain.ChapterName or ""
    local QuestChainName = QuestChain.QuestChainName or ""
    Res.DisplayTextName = GText(ChapterName) .. "·" .. GText(QuestChainName)
  end
  Res.SideQuestChainId = SideQuestChainId
  return Res
end

function M:GetSideTipTextByQuestChainId(QuestChainId, QuestChainState)
  local Index = 0
  for i, SideQuestChainId in pairs(self.EventInfo.PretextTasks2) do
    if SideQuestChainId == QuestChainId then
      Index = i
      break
    end
  end
  if "Unlock" == QuestChainState then
    return self.EventInfo.PretextTask2ReceiveToast and self.EventInfo.PretextTask2ReceiveToast[Index]
  end
  if "Lock" == QuestChainState then
    return self.EventInfo.PretextTask2UnlockToast and self.EventInfo.PretextTask2UnlockToast[Index]
  end
  return ""
end

function M:GetQuestChainStateNew(QuestChainId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return ""
  end
  if Avatar:IsQuestChainFinished(QuestChainId) then
    return "Finish"
  end
  if Avatar:IsQuestChainDoing(QuestChainId) then
    return "Doing"
  end
  if Avatar:IsQuestChainUnlock(QuestChainId) then
    return "Unlock"
  end
  if Avatar:IsQuestChainLock(QuestChainId) then
    return "Lock"
  end
  return "Lock"
end

function M:GetQuestChainState(QuestChainId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return ""
  end
  if not Avatar.QuestChains[QuestChainId] then
    return "Unlock"
  end
  if Avatar.QuestChains[QuestChainId]:IsFinish() then
    return "Finish"
  elseif Avatar.QuestChains[QuestChainId]:IsDoing() then
    return "Doing"
  else
    return "Unlock"
  end
end

return M
