require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local PageJumpUtils = require("Utils.PageJumpUtils")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.DelayFrameComponent"
})
M.EModuleState = {
  Normal = 1,
  Locked = 2,
  Finished = 3
}

function M:GetModuleSortWeight(ModuleData)
  if not ModuleData then
    return M.EModuleState.Finished
  end
  return ModuleData.State or M.EModuleState.Finished
end

function M:SortModuleList()
  table.sort(self.ModuleList, function(A, B)
    local AWeight = self:GetModuleSortWeight(A)
    local BWeight = self:GetModuleSortWeight(B)
    if AWeight ~= BWeight then
      return AWeight < BWeight
    end
    return (A.KeyId or 0) < (B.KeyId or 0)
  end)
  for Index, ModuleData in ipairs(self.ModuleList) do
    ModuleData.DisplayIndex = Index
  end
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
  self.CurActivityId = ActivityId
  self.ParentTabId = ParentTabId
  self.AllActivityId = AllActivityId
  self.ParentWidget = ParentWidget
  self.ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
  if self.ActivityConfigData then
    self.ActivityEndTime = self.ActivityConfigData.EventEndTime or self.ActivityConfigData.PermanenEventTime
    self.RewardEndTime = self.ActivityConfigData.RewardEndTime
  end
  self:InitModel(ActivityId)
  self:InitUI()
  self:InitTimeInfo()
  self:RefreshView()
end

function M:GetPageConfigData()
  return {
    ActivityId = self.CurActivityId
  }
end

function M:UpdatePage(OperateSrc)
  self:RefreshModuleStates()
  self:RefreshView()
  if "BackToPageWithJump" == OperateSrc then
    self:PlayFadeIn()
  end
end

function M:ShowPage(IsNeedPlayInAnim)
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if IsNeedPlayInAnim then
    self:PlayFadeIn()
  end
  self:RefreshModuleStates()
  self:RefreshView()
  self:InitTimeInfo()
end

function M:HidePage(IsNeedPlayOutAnim)
  if IsNeedPlayOutAnim then
    self:PlayFadeOut()
  end
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:PlayFadeIn()
  if self.In then
    self:PlayAnimation(self.In)
  end
end

function M:PlayFadeOut(IsRemoveFromParent)
  if self.Out then
    self:PlayAnimation(self.Out)
    if IsRemoveFromParent then
      self:BindToAnimationFinished(self.Out, {
        self,
        self.RemoveFromParent
      })
    end
  elseif IsRemoveFromParent then
    self:RemoveFromParent()
  end
end

function M:CleanSelf(bIsRemoveSelf)
  self:RemoveTimer("RefreshLeftTime")
  self.ModuleList = {}
  if bIsRemoveSelf then
    self:RemoveFromParent()
  end
end

function M:GetActivityId()
  return self.CurActivityId
end

function M:GetParentTabId()
  return self.ParentTabId
end

function M:ResetVariable()
end

function M:GetCurFocusWidgetInfo()
  return self.FocusWidgetName, self.FocusWidgetWidget
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad, bIsWithButton)
end

function M:IsPageInVisible()
  return self:GetVisibility() == UIConst.VisibilityOp.SelfHitTestInvisible
end

function M:InitModel(ActivityId)
  self.ModuleList = {}
  local RewardCollectionTable = DataMgr.PermRewardCollection
  if not RewardCollectionTable then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local IsActivityCompleted = Avatar and Avatar.CompletedActivity[ActivityId]
  for _, Row in pairs(RewardCollectionTable) do
    if not Row or IsActivityCompleted and not Avatar.PermRewardCollections[Row.KeyId] then
    else
      local ModuleData = NewObject(UIUtils.GetCommonItemContentClass())
      ModuleData.KeyId = Row.KeyId
      ModuleData.EventId = Row.EventId
      ModuleData.BigRewardView = Row.BigRewardView
      ModuleData.RewardView = Row.RewardView
      ModuleData.InterfaceJumpId = Row.InterfaceJumpId
      ModuleData.UnlockCondition = Row.UnlockCondition
      ModuleData.FinishCondition = Row.FinishCondition
      ModuleData.State = self:CalcModuleState(Row)
      ModuleData.DisplayIndex = 0
      ModuleData.LockDes = Row.LockDes
      ModuleData.EventTitle = Row.EventTitle
      ModuleData.DesText = Row.DesText
      ModuleData.Parent = self
      table.insert(self.ModuleList, ModuleData)
    end
  end
  self:SortModuleList()
end

function M:CalcModuleState(Row)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return M.EModuleState.Locked
  end
  if Row.FinishCondition and ConditionUtils.CheckCondition(Avatar, Row.FinishCondition) then
    return M.EModuleState.Finished
  end
  if Row.UnlockCondition and not ConditionUtils.CheckCondition(Avatar, Row.UnlockCondition) then
    return M.EModuleState.Locked
  end
  return M.EModuleState.Normal
end

function M:RefreshModuleStates()
  for _, ModuleData in ipairs(self.ModuleList) do
    ModuleData.State = self:CalcModuleState(ModuleData)
  end
  self:SortModuleList()
end

function M:InitTimeInfo()
  if (self.ActivityEndTime ~= nil or nil ~= self.RewardEndTime) and self.Activity_TimeView.Com_Time then
    ActivityUtils.RefreshLeftTime(self, self.Activity_TimeView.Com_Time)
    self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_TimeView.Com_Time)
  else
    ActivityUtils.SetLeftTimeView(self.Activity_TimeView.Com_Time, true)
  end
end

function M:OnGotoClick(KeyId)
  local ModuleData
  for _, Data in ipairs(self.ModuleList) do
    if Data.KeyId == KeyId then
      ModuleData = Data
      break
    end
  end
  if not ModuleData then
    return
  end
  if ModuleData.State ~= M.EModuleState.Normal then
    return
  end
  if not ModuleData.InterfaceJumpId then
    return
  end
  PageJumpUtils:JumpToTargetPageByJumpId(ModuleData.InterfaceJumpId)
end

function M:InitUI()
end

function M:InitCommonUI()
  self.Activity_TimeView = self.Activity_Time or self.Activity_TimeView
  if not self.TitleWidget and self.Title then
    local TitleBP = "/Game/UI/WBP/Activity/Widget/Permanent/WBP_Activity_Permanent_Title.WBP_Activity_Permanent_Title"
    local TitleWidget = UIManager(self):CreateWidget(TitleBP)
    if TitleWidget then
      self.Title:ClearChildren()
      self.Title:AddChildToOverlay(TitleWidget)
      self.TitleWidget = TitleWidget
    end
  end
  if self.TitleWidget and self.ActivityConfigData then
    self.TitleWidget.Text_Title:SetText(GText(self.ActivityConfigData.EventName or ""))
    self.TitleWidget:PlayAnimation(self.TitleWidget.In)
  end
  local DescText = self:GetActivityDescText()
  if self.Text_Desc then
    self.Text_Desc:SetText(DescText)
  end
  if self.Text_Desc_White then
    self.Text_Desc_White:SetText(DescText)
  end
  if self.Group_ActivityQa then
    local IsShowRule = self.ActivityConfigData and self.ActivityConfigData.EventRule
    self.Group_ActivityQa:SetVisibility(IsShowRule and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshView()
  self:InitCommonUI()
  if not self.List_Item then
    return
  end
  self.List_Item:ClearListItems()
  for Index, ModuleData in ipairs(self.ModuleList) do
    ModuleData.DisplayIndex = Index
    self.List_Item:AddItem(ModuleData)
  end
end

function M:GetActivityDescText()
  if not self.ActivityConfigData or not self.ActivityConfigData.EventDes then
    return ""
  end
  return GText(self.ActivityConfigData.EventDes)
end

return M
