require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local M = Class({
  "BluePrints.Common.TimerMgr"
})
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
  self.CurActivityId = ActivityId
  self.ParentTabId = ParentTabId
  self.AllActivityId = AllActivityId
  self.ParentWidget = ParentWidget
  local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
  self.ActivityEndTime = ActivityConfigData.EventEndTime and ActivityConfigData.EventEndTime or ActivityConfigData.PermanenEventTime
  self.RewardEndTime = ActivityConfigData.RewardEndTime
  self.FinishCondition = ActivityConfigData.EventEndCondition
  self.IsComplete = false
  self.IsCanGetReward = false
  self.IsGetReward = false
  self.RewardStateList = {}
  self:UpdateActivityConditionAndRewardState()
  self:InitUI()
  self:InitTimeInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self.CurGamepadName = CurGamepadName
  self.IsSwitchDevice = true
  self:UpdateUIByInputDevice(CurInputDevice)
end

function M:GetPageConfigData()
  return DataMgr.ConditionalRewardEvent[self.CurActivityId]
end

function M:ShowPage(IsNeedPlayInAnim)
  if IsNeedPlayInAnim then
    self:PlayFadeIn()
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:UpdateActivityConditionAndRewardState()
  self:InitUI()
  self:InitTimeInfo()
end

function M:HidePage(IsNeedPlayOutAnim)
  if IsNeedPlayOutAnim then
    self:PlayFadeOut()
  end
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:PlayFadeIn()
  self:PlayAnimation(self.In)
end

function M:PlayFadeOut(IsRemoveFromParent)
  self:PlayAnimation(self.Out)
  if IsRemoveFromParent then
    self:BindToAnimationFinished(self.Out, {
      self,
      self.RemoveFromParent
    })
  end
end

function M:UpdatePage(OperateSrc)
end

function M:InitCommonUI()
  local ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
  self.Activity_TimeView:SetForeverTimeText(GText("UI_GameEvent_EventTimeRemain"))
  self.Text_ActivityDescView:SetText(GText(ActivityConfigData.EventDes))
  if self.Text_TitleView then
    self.Text_TitleView:SetText(GText(ActivityConfigData.EventName))
  end
  if self.Text_ActivityDescView_White then
    self.Text_ActivityDescView_White:SetText(GText(ActivityConfigData.EventDes))
  end
  self.FocusWidgetWidget = nil
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:InitTimeInfo()
  if (self.ActivityEndTime ~= nil or nil ~= self.RewardEndTime or self.IsComplete) and self.Activity_TimeView then
    local bCheckNextDayFiveStamp = true
    ActivityUtils.RefreshLeftTime(self, self.Activity_TimeView, bCheckNextDayFiveStamp)
    self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, self.Activity_TimeView, bCheckNextDayFiveStamp)
  else
    ActivityUtils.SetLeftTimeView(self.Activity_TimeView, true)
  end
end

function M:UpdateActivityConditionAndRewardState()
  local Avatar = GWorld:GetAvatar()
  local PageConfigData = self:GetPageConfigData()
  if not Avatar or not PageConfigData then
    return
  end
  if self.FinishCondition then
    self.IsComplete = ConditionUtils.CheckCondition(Avatar, self.FinishCondition)
  else
    self.IsComplete = false
  end
  local RewardList = PageConfigData.EventReward or {}
  local ConditionList = PageConfigData.RewardClaimCondition or {}
  local RewardClaimDesList = PageConfigData.RewardClaimDes or {}
  local LegacyIsGetReward = Avatar.ClaimActivityConditionRewardRecord and Avatar.ClaimActivityConditionRewardRecord[self.CurActivityId]
  local RewardStateList = {}
  local ActivityClaimRecordList = Avatar.ClaimActivityConditionRewardRecordList
  local ActivityClaimRecord = ActivityClaimRecordList and ActivityClaimRecordList[self.CurActivityId]
  for Index, RewardId in ipairs(RewardList) do
    local ConditionId = ConditionList[Index]
    local IsCanGetReward = false
    if ConditionId then
      IsCanGetReward = ConditionUtils.CheckCondition(Avatar, ConditionId)
    end
    local IsGetReward = false
    if ActivityClaimRecord then
      IsGetReward = CommonUtils.HasValue(ActivityClaimRecord, Index)
    end
    if 1 == Index and not IsGetReward and LegacyIsGetReward then
      IsGetReward = true
    end
    RewardStateList[Index] = {
      Index = Index,
      RewardId = RewardId,
      ConditionId = ConditionId,
      RewardClaimDes = RewardClaimDesList[Index] or "",
      IsCanGetReward = IsCanGetReward,
      IsGetReward = IsGetReward,
      CanClaim = IsCanGetReward and not IsGetReward
    }
  end
  self.RewardStateList = RewardStateList
  self:SyncLegacyRewardState()
end

function M:SyncLegacyRewardState()
  local FirstRewardState = self.RewardStateList and self.RewardStateList[1]
  if not FirstRewardState then
    self.RewardId = nil
    self.IsCanGetReward = false
    self.IsGetReward = false
    return
  end
  self.RewardId = FirstRewardState.RewardId
  self.IsCanGetReward = FirstRewardState.IsCanGetReward
  self.IsGetReward = FirstRewardState.IsGetReward
end

function M:OnBtnClick(RewardIndex)
  RewardIndex = RewardIndex or 1
  local RewardState = self.RewardStateList and self.RewardStateList[RewardIndex]
  if not RewardState then
    return
  end
  if RewardState.IsCanGetReward ~= true then
    return
  end
  if RewardState.IsGetReward then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Callback(Ret, Rewards)
    if 0 == Ret then
      local AllRewards = RewardUtils:GetRewards(RewardState.RewardId, nil)
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, AllRewards, false, nil, self)
      self:UpdateActivityConditionAndRewardState()
      self:InitUI()
      ActivityReddotHelper.TrySubReddotCount(ActivityUtils, self.CurActivityId, "Red")
    end
  end
  
  Avatar:CallServer("ClaimActivityConditionRewardWithIndex", Callback, self.CurActivityId, RewardIndex)
end

return M
