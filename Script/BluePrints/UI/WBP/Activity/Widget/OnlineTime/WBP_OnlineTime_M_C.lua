require("UnLua")
local ActivityUtils = require("BluePrints.UI.WBP.Activity.ActivityUtils")
local ActivityCommon = require("BluePrints.UI.WBP.Activity.ActivityCommon")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent"
})
M._components = {
  "BluePrints.UI.WBP.Activity.Widget.View.ActivityAccumulateView"
}

function M:Initialize(Initializer)
  self.EventId = nil
  self.ParentTabId = nil
  self.ParentWidget = nil
  self.QuestPhaseId = nil
  self.Progress = 0
  self.RewardList = {}
  self.FocusWidgetName = nil
  self.FocusWidgetWidget = nil
end

function M:InitPage(EventId, ParentTabId, AllActivityId, ParentWidget)
  self.EventId = EventId
  self.CurActivityId = EventId
  self.ParentTabId = ParentTabId
  self.ParentWidget = ParentWidget
  self.QuestPhaseId = DataMgr.AccumulateTargetEvent[self.EventId].QuestPhaseId
  self.Btn_Reward.Button_Area.OnClicked:Clear()
  self.Btn_Reward.Button_Area.OnClicked:Add(self, self.GetAllReward)
  self.Btn_Goto:SetVisibility(UE4.ESlateVisibility.Visible)
  self.Btn_Goto.Button_Area.OnClicked:Clear()
  self.Btn_Goto.Button_Area.OnClicked:Add(self, self.GotoClick)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local CommonQuestDetail = DataMgr.CommonQuestDetail
  local SPTarget, SPQuestId = 0, 0
  for i, v in pairs(CommonQuestDetail) do
    if v.EventId == self.EventId and v.QuestPhaseId == self.QuestPhaseId and SPTarget < v.Target then
      SPTarget = v.Target
      SPQuestId = i
    end
  end
  self.Progress = Avatar.CommonQuestActivity[self.EventId][SPQuestId].Progress
  self:InitUIInfo()
  self:InitRewards()
end

function M:GetPageConfigData()
  return DataMgr.AccumulateTargetEvent[self.EventId]
end

function M:UpdatePage(OperateSrc)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local CommonQuestDetail = DataMgr.CommonQuestDetail
  local SPTarget, SPQuestId = 0, 0
  for i, v in pairs(CommonQuestDetail) do
    if v.EventId == self.EventId and v.QuestPhaseId == self.QuestPhaseId and SPTarget < v.Target then
      SPTarget = v.Target
      SPQuestId = i
    end
  end
  self.Progress = Avatar.CommonQuestActivity[self.EventId][SPQuestId].Progress
  self:InitUIInfo()
  self:InitRewards()
  ActivityReddotHelper.RefreshReddotNode(self.EventId)
end

function M:GetCurFocusWidgetInfo()
  return self.FocusWidgetName, self.FocusWidgetWidget
end

function M:EnterStuffViewMode()
  self:AddDelayFrameFunc(function()
    self.List_Reward:SetFocus()
  end, 1)
  self.FocusWidgetName = "CheckRewardDetailView"
  self.FocusWidgetWidget = self.List_Reward
  if self.ParentWidget then
    self.ParentWidget:UpdateActivityKeyTips("CheckRewardDetailView", self.List_Reward)
  end
  self.IsInStuffViewMode = true
  return true
end

function M:LeaveStuffViewMode()
  if self.FocusWidgetName == nil then
    return false
  end
  self.FocusWidgetName = nil
  self.FocusWidgetWidget = nil
  if self.ParentWidget then
    self.ParentWidget:UpdateActivityKeyTips()
    self.ParentWidget:SetFocus()
  end
  self:OnUpdateSubUIViewStyle(true, true)
  self.IsInStuffViewMode = false
  return true
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadButtonDown(InKeyName)
  else
    IsEventHandled = false
  end
  return IsEventHandled
end

function M:OnGamePadButtonDown(InKeyName)
  local IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  return IsEventHandled
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    IsEventHandled = self:EnterStuffViewMode()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    IsEventHandled = self:LeaveStuffViewMode()
  end
  return IsEventHandled
end

function M:ItemMenuAnchorChanged(IsOpen)
end

AssembleComponents(M)
return M
