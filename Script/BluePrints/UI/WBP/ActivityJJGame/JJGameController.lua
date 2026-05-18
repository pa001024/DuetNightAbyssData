local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local JJGameModel = require("BluePrints.UI.WBP.ActivityJJGame.JJGameModel")
local M = Class("BluePrints.Common.MVC.Controller")

function M:EnsureInit()
  if not self.bInited then
    self:Init()
  end
end

function M:Init()
  if self.bInited then
    return
  end
  M.Super.Init(self)
end

function M:GetModel()
  return JJGameModel
end

function M:GetEventName()
  return "JJGameControllerEvent"
end

function M:RefreshModel()
  self:EnsureInit()
  self:GetModel():Refresh()
  return self:GetModel()
end

function M:OpenTaskView(Owner, ActivityJJGameTask, TabId, CloseCallback, CloseCallbackObj)
  AudioManager(Owner):PlayUISound(Owner, "event:/ui/activity/wenmingboyi_entrance_btn_click", nil, nil)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  if not UIManager then
    return ActivityJJGameTask
  end
  local Params = {
    Owner = Owner,
    TabId = TabId,
    CloseCallback = CloseCallback,
    CloseCallbackObj = CloseCallbackObj
  }
  if IsValid(ActivityJJGameTask) then
    UIManager:LoadUI(UIConst.LoadInConfig, "ActivityJJGameTask", ActivityJJGameTask:GetZOrder(), Params)
    return ActivityJJGameTask
  end
  return UIManager:LoadUINew("ActivityJJGameTask", Params)
end

function M:EnsureReddotNodes()
  local Model = self:RefreshModel()
  local NodeNames = {
    Model.NormalRewardReddotName,
    Model.ChallengeRewardReddotName,
    Model.NormalTaskNewReddotName,
    Model.ChallengeTaskNewReddotName
  }
  for _, NodeName in ipairs(NodeNames) do
    if not ReddotManager.GetTreeNode(NodeName) then
      ReddotManager.AddNodeEx(NodeName, nil, Const.ReddotCacheType.UserCache)
    end
  end
end

function M:TryIncreaseReddot(NodeName, CacheKey)
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(NodeName)
  if CacheData and nil == CacheData[CacheKey] then
    CacheData[CacheKey] = true
    ReddotManager.IncreaseLeafNodeCount(NodeName)
  end
end

function M:TryDecreaseReddot(NodeName, CacheKey, ClearValue)
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(NodeName)
  if CacheData and CacheData[CacheKey] then
    CacheData[CacheKey] = ClearValue
    ReddotManager.DecreaseLeafNodeCount(NodeName)
  end
end

function M:ClearReddot(NodeName, ClearValue)
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(NodeName)
  if CacheData then
    for Key in pairs(CacheData) do
      CacheData[Key] = ClearValue
    end
  end
  ReddotManager.ClearLeafNodeCount(NodeName)
end

function M:HasTrueValue(CacheData)
  if not CacheData then
    return false
  end
  for _, Value in pairs(CacheData) do
    if true == Value then
      return true
    end
  end
  return false
end

function M:TryIncreaseNormalRewardReddot(Key)
  local Model = self:RefreshModel()
  self:TryIncreaseReddot(Model.NormalRewardReddotName, Model.NormalRewardReddotName .. Key)
end

function M:TrySubNormalRewardReddot(Key)
  local Model = self:RefreshModel()
  self:TryDecreaseReddot(Model.NormalRewardReddotName, Model.NormalRewardReddotName .. Key, nil)
end

function M:TryIncreaseChallengeRewardReddot(Key)
  local Model = self:RefreshModel()
  self:TryIncreaseReddot(Model.ChallengeRewardReddotName, "ChallengeScoreItem" .. Key)
end

function M:TryIncreaseChallengeTaskRewardReddot(TaskId)
  local Model = self:RefreshModel()
  self:TryIncreaseReddot(Model.ChallengeRewardReddotName, Model.ChallengeRewardReddotName .. TaskId)
end

function M:TrySubChallengeTaskRewardReddot(TaskId)
  local Model = self:RefreshModel()
  self:TryDecreaseReddot(Model.ChallengeRewardReddotName, Model.ChallengeRewardReddotName .. TaskId, nil)
end

function M:TrySubChallengeRewardReddot(Target)
  local Model = self:RefreshModel()
  self:TryDecreaseReddot(Model.ChallengeRewardReddotName, "ChallengeScoreItem" .. Target, nil)
end

function M:TryIncreaseNormalTaskNewReddot(TaskOrUniqueID)
  local Model = self:RefreshModel()
  local CacheKey = type(TaskOrUniqueID) == "table" and TaskOrUniqueID.UniqueID or TaskOrUniqueID
  self:TryIncreaseReddot(Model.NormalTaskNewReddotName, CacheKey)
end

function M:TryIncreaseChallengeTaskNewReddot(TaskOrUniqueID)
  local Model = self:RefreshModel()
  local CacheKey = type(TaskOrUniqueID) == "table" and TaskOrUniqueID.UniqueID or TaskOrUniqueID
  self:TryIncreaseReddot(Model.ChallengeTaskNewReddotName, CacheKey)
end

function M:TrySubNormalTaskNewReddot(TaskId)
  local Model = self:RefreshModel()
  self:TryDecreaseReddot(Model.NormalTaskNewReddotName, TaskId, false)
end

function M:TrySubChallengeTaskNewReddot(TaskId)
  local Model = self:RefreshModel()
  self:TryDecreaseReddot(Model.ChallengeTaskNewReddotName, TaskId, false)
end

function M:ClearNormalRewardReddot()
  local Model = self:RefreshModel()
  self:ClearReddot(Model.NormalRewardReddotName, nil)
end

function M:ClearChallengeRewardReddot()
  local Model = self:RefreshModel()
  self:ClearReddot(Model.ChallengeRewardReddotName, nil)
end

function M:ClearNormalTaskNewReddot(ClearValue)
  local Model = self:RefreshModel()
  self:ClearReddot(Model.NormalTaskNewReddotName, ClearValue)
end

function M:ClearChallengeTaskNewReddot(ClearValue)
  local Model = self:RefreshModel()
  self:ClearReddot(Model.ChallengeTaskNewReddotName, ClearValue)
end

function M:ClearNormalTaskRewardReddotByTasks(MidTermTasks)
  local Model = self:RefreshModel()
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(Model.NormalRewardReddotName)
  if not CacheData then
    return
  end
  for _, Task in pairs(MidTermTasks or {}) do
    local TaskData = DataMgr.MidTermTask[Task.UniqueID]
    if TaskData and TaskData.TaskType ~= Model.TaskType.Achievement then
      local CacheKey = Model.NormalRewardReddotName .. Task.UniqueID
      if CacheData[CacheKey] then
        CacheData[CacheKey] = nil
        ReddotManager.DecreaseLeafNodeCount(Model.NormalRewardReddotName)
      end
    end
  end
end

function M:ClearUnlockedChallengeScoreRewardReddot()
  local Model = self:RefreshModel()
  local AchievementPrize = DataMgr.AchievementPrize
  local MaxCount = 0
  for Count in pairs(AchievementPrize) do
    if Count > MaxCount then
      MaxCount = Count
    end
  end
  if MaxCount <= Model.MidTermAchvScores then
    self:ClearChallengeRewardReddot()
    return
  end
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(Model.ChallengeRewardReddotName)
  if not CacheData then
    return
  end
  for Count in pairs(AchievementPrize) do
    local CacheKey = "ChallengeScoreItem" .. Count
    if Count <= Model.MidTermAchvScores and CacheData[CacheKey] then
      CacheData[CacheKey] = nil
      ReddotManager.DecreaseLeafNodeCount(Model.ChallengeRewardReddotName)
    end
  end
end

function M:RefreshEntryReddotState()
  self:EnsureReddotNodes()
  local Model = self:RefreshModel()
  local NowTime = TimeUtils.NowTime()
  self:ClearNormalRewardReddot()
  if Model:HasUnclaimedNormalScoreReward() then
    self:TryIncreaseNormalRewardReddot("ScoresRewards")
  else
    self:TrySubNormalRewardReddot("ScoresRewards")
  end
  self:ClearChallengeRewardReddot()
  for Count in pairs(DataMgr.AchievementPrize) do
    if Count <= Model.MidTermAchvScores and 1 ~= Model.MidTermAchvProgressRewarded[Count] then
      self:TryIncreaseChallengeRewardReddot(Count)
    end
  end
  for TaskId, Task in pairs(Model.MidTermTasks) do
    local TaskData = DataMgr.MidTermTask[Task.UniqueID]
    if not TaskData then
    elseif TaskData.TaskType == Model.TaskType.Achievement then
      if not Model:CheckIsChallengeRewardAllClaimed() and Task.Progress >= Task.Target and Task.RewardsGot == false and TaskData.EnableDay <= Model.EventDay then
        self:TryIncreaseChallengeTaskRewardReddot(Task.UniqueID)
      else
        self:TrySubChallengeTaskRewardReddot(Task.UniqueID)
      end
      if NowTime <= Model.EventEndTime then
        self:TryIncreaseChallengeTaskNewReddot(Task)
      end
    elseif TaskData.TaskType == Model.TaskType.Cycle then
      if NowTime <= Model.EventEndTime then
        self:TryIncreaseNormalTaskNewReddot(Task)
      end
    elseif TaskData.EnableDay == Model.EventDay and not Model:HasUnclaimedNormalScoreReward() then
      self:TryIncreaseNormalTaskNewReddot(Task)
    end
  end
  if NowTime > Model.EventEndTime then
    self:ClearChallengeTaskNewReddot(nil)
    self:ClearNormalTaskNewReddot(nil)
    if NowTime > Model.RewardEndTime then
      self:ClearChallengeRewardReddot()
      self:ClearNormalRewardReddot()
    elseif not Model:HasUnclaimedNormalScoreReward() then
      self:ClearNormalRewardReddot()
    end
  end
  self:UpdateActivityTabNewReddot()
  return Model
end

function M:UpdateActivityTabNewReddot()
  local Model = self:RefreshModel()
  local HasNormalJJGameTaskNew = self:HasTrueValue(ReddotManager.GetLeafNodeCacheDetail(Model.NormalTaskNewReddotName))
  local HasChallengeJJGameTaskNew = self:HasTrueValue(ReddotManager.GetLeafNodeCacheDetail(Model.ChallengeTaskNewReddotName))
  if HasNormalJJGameTaskNew or HasChallengeJJGameTaskNew then
    ActivityReddotHelper.TryAddReddotCount(ActivityUtils, Model.MidTermGoalEventId, "New")
  else
    ActivityReddotHelper.TrySubReddotCount(ActivityUtils, Model.MidTermGoalEventId, "New")
  end
end

function M:UpdateTaskTabReddot(ComTab)
  if not ComTab then
    return
  end
  local Model = self:RefreshModel()
  if TimeUtils.NowTime() > Model.RewardEndTime then
    ComTab:ShowTabRedDot(1, false)
    ComTab:ShowTabRedDot(2, false)
    return
  end
  local HasNewNormalTask = self:HasTrueValue(ReddotManager.GetLeafNodeCacheDetail(Model.NormalTaskNewReddotName))
  local HasNewChallengeTask = self:HasTrueValue(ReddotManager.GetLeafNodeCacheDetail(Model.ChallengeTaskNewReddotName))
  local HasNormalReward = self:HasTrueValue(ReddotManager.GetLeafNodeCacheDetail(Model.NormalRewardReddotName))
  local HasChallengeReward = self:HasTrueValue(ReddotManager.GetLeafNodeCacheDetail(Model.ChallengeRewardReddotName))
  if HasNormalReward then
    ComTab:ShowTabRedDot(1, false, true)
  elseif HasNewNormalTask and TimeUtils.NowTime() < Model.EventEndTime then
    ComTab:ShowTabRedDot(1, true, false)
  else
    ComTab:ShowTabRedDot(1, false)
  end
  if HasChallengeReward then
    ComTab:ShowTabRedDot(2, false, true)
  elseif HasNewChallengeTask and TimeUtils.NowTime() < Model.EventEndTime then
    ComTab:ShowTabRedDot(2, true, false)
  else
    ComTab:ShowTabRedDot(2, false)
  end
end

function M:CanReceiveAnyNormalTask(NormalTaskList, CycleTaskList, YesterdayRewardGot, EventEndTime)
  local Model = self:RefreshModel()
  
  local function checkTaskItemCanReceive(TaskItem)
    if not (TaskItem and TaskItem.TaskProp) or not TaskItem.TaskConfig then
      return false
    end
    if TaskItem.CanGet == false then
      return false
    end
    local TaskType = TaskItem.TaskConfig.TaskType
    if type(Model.TaskType.Daily) == "table" and (TaskType == Model.TaskType.Daily[1] or TaskType == Model.TaskType.Daily[2]) then
      return Model:CanClaimNormalTask(TaskItem.TaskProp)
    end
    if TaskType == Model.TaskType.Cycle then
      return Model:CanClaimCycleTask(TaskItem.TaskProp.UniqueID)
    end
    return false
  end
  
  local CanReceive = false
  for _, TaskItem in pairs(NormalTaskList or {}) do
    if checkTaskItemCanReceive(TaskItem) then
      CanReceive = true
      break
    end
  end
  if not CanReceive then
    for _, TaskItem in pairs(CycleTaskList or {}) do
      if checkTaskItemCanReceive(TaskItem) then
        CanReceive = true
        break
      end
    end
  end
  if false == YesterdayRewardGot then
    CanReceive = true
  end
  if EventEndTime < TimeUtils.NowTime() then
    CanReceive = false
  end
  return CanReceive
end

function M:CanReceiveAnyChallengeTask(ChallengeTaskList, EventEndTime)
  local Model = self:RefreshModel()
  if EventEndTime < TimeUtils.NowTime() then
    return false
  end
  for _, TaskItem in pairs(ChallengeTaskList or {}) do
    if TaskItem and Model:CanClaimChallengeTask(TaskItem.TaskProp) then
      return true
    end
  end
  return false
end

function M:UpdateClaimAllBottomKey(ComTab, CanReceive, ClaimAllCallback, CloseCallback, Owner)
  if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" or not ComTab then
    return
  end
  if CanReceive then
    ComTab:UpdateBottomKeyInfo({
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "SpaceBar",
            ClickCallback = ClaimAllCallback,
            Owner = Owner
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "Y",
            ClickCallback = ClaimAllCallback
          }
        },
        Desc = GText("UI_CTL_ClaimALL"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = CloseCallback,
            Owner = Owner
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = CloseCallback
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    })
  else
    ComTab:UpdateBottomKeyInfo({
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = CloseCallback,
            Owner = Owner
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = CloseCallback
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    })
  end
end

function M:UpdateTaskProgressTexts(Widget, TaskProp)
  local Num = self:RefreshModel():GetProgressText(TaskProp)
  Widget.Text_GetRewardNum:SetText(Num)
  Widget.Text_DoingNum:SetText(Num)
  Widget.Text_JumpNum:SetText(Num)
end

function M:JumpToTask(JumpUIId)
  PageJumpUtils:JumpToTargetPageByJumpId(JumpUIId)
end

function M:RefreshTaskOpInfoByInputDevice(Widget, CurInputDevice, CurGamepadName)
  Widget.CurGamepadName = CurGamepadName
  local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
  if IsUseGamepad then
    Widget.Btn_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
    Widget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if Widget:HasAnyUserFocus() or Widget:HasFocusedDescendants() then
      Widget:PlayAnimation(Widget.Hover)
    end
  else
    Widget.Btn_Controller:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    Widget:SetVisibility(UIConst.VisibilityOp.Visible)
    Widget:StopAnimation(Widget.Hover)
    Widget:PlayAnimation(Widget.Normal)
  end
  Widget.CurInputDevice = CurInputDevice
end

_G.JJGameController = M
return M
