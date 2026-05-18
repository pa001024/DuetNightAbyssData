require("UnLua")
local EMCache = require("EMCache.EMCache")
local JJGameModel = require("BluePrints.UI.WBP.ActivityJJGame.JJGameModel")
local JJGameController = require("BluePrints.UI.WBP.ActivityJJGame.JJGameController")
local NormalTaskNewReddotName = JJGameModel.NormalTaskNewReddotName
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local TaskType = JJGameModel.TaskType

function M:Construct()
  self.Text_InfinityNum:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Image_IconInfinity:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_Doing:SetText(GText("UI_Event_MidTerm_InProgress"))
  self.Btn_Jump:SetText(GText("UI_Event_MidTerm_GotoTask"))
  self.Text_WaitRefresh:SetText(GText("UI_Event_MidTerm_RefreshTask"))
  self.Btn_Jump.Button_Area.OnClicked:Add(self, self.OnJumpClicked)
  self.Btn_Jump:SetGamepadIconVisibility(false)
  self.Btn_CanGet.Text_GetReward:SetText(GText("UI_Achievement_GetReward"))
  self.Btn_CanGet.Btn_GetReward.OnClicked:Add(self, self.OnCanGetClicked)
  self.Btn_Controller.OnClicked:Add(self, self.OnControllerClicked)
  self.Avatar = GWorld:GetAvatar()
  self.MidTermConst = DataMgr.MidTermGoalConstant
  self.MidTermGoalEventId = self.MidTermConst.MidTermGoalEventId.ConstantValue
  self:InitListenEvent()
  self:RefreshBaseInfo()
end

function M:Destruct()
  self.Btn_Jump.Button_Area.OnClicked:Clear()
  self.Btn_CanGet.Btn_GetReward.OnClicked:Clear()
  self.Btn_Controller.OnClicked:Clear()
  ReddotManager.RemoveListener(NormalTaskNewReddotName, self)
end

function M:SyncTaskData()
  local Model = JJGameController:RefreshModel()
  self.MidTermGoals = Model.MidTermGoals
  local Task = Model:GetTaskByTaskId(self.TaskId)
  if Task then
    self.TaskProp = Task.Props or Task.TaskProp or Task
    if self.Content then
      self.Content.TaskProp = self.TaskProp
    end
  end
  if self.MidTermGoals and self.MidTermGoals.TaskFinishCount then
    self.TaskFinishCount = self.MidTermGoals.TaskFinishCount[self.TaskId] or 0
  else
    self.TaskFinishCount = 0
  end
  self.Progress = self.TaskProp and (self.TaskProp.Progress or 0) or 0
end

function M:RefreshTaskState()
  if not IsValid(self) or not self.Content then
    return
  end
  self:SyncTaskData()
  if not self.TaskProp then
    return
  end
  self.Content.CanGet = false
  local Progress = self.TaskProp.Progress or 0
  local Target = self.TaskProp.Target or 0
  local IsFinished = Progress >= Target
  if self.TaskConfig and self.TaskConfig.TaskType == TaskType.Cycle and self.TaskFinishCount > 0 then
    IsFinished = true
  end
  if IsFinished then
    self.JumpUIId = nil
    self.WS_Btn:SetActiveWidgetIndex(3)
  elseif self.TaskConfig and self.TaskConfig.JumpUIId then
    self.JumpUIId = self.TaskConfig.JumpUIId
    self.WS_Btn:SetActiveWidgetIndex(1)
  else
    self.JumpUIId = nil
    self.WS_Btn:SetActiveWidgetIndex(0)
  end
  self:UpdateGetRewardNum()
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.TaskId = Content.Id
  self.Owner = Content.Owner
  self.TaskConfig = Content.TaskConfig
  self.TaskProp = Content.TaskProp
  self.JJGameBase = self.Owner.JJGameBase
  self.YesterdayRewardGot = Content.YesterdayRewardGot
  Content.SelfWidget = self
  self._Avatar = GWorld:GetAvatar()
  self.Text_RewardNum:SetText(Content.Point)
  self.Text_Desc:SetText(GText(Content.Desc))
  if Content.TaskType == TaskType.Cycle then
    self.Image_IconInfinity:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    local PlayReminder = EMCache:Get("MidTermReminder_" .. self.TaskId, true)
    if not PlayReminder then
      self:PlayAnimation(self.VX_Reminder)
      EMCache:Set("MidTermReminder_" .. self.TaskId, true, true)
    end
  end
  if Content.TaskConfig.TargetId then
    if CommonUtils.Size(Content.TaskConfig.TargetId) > 1 then
      self.IsMultiTarget = true
      self.TargetId = Content.TaskConfig.TargetId
    else
      self.IsMultiTarget = false
      self.TargetId = Content.TaskConfig.TargetId[1]
    end
  end
  self:RefreshTaskState()
  ReddotManager.AddListenerEx(NormalTaskNewReddotName, self, self.UpdateNormalTaskNewReddot)
  if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" then
    self:PlayAnimation(self.In)
  end
end

function M:BP_OnEntryReleased()
  if self.Content then
    self.Content.SelfWidget = nil
  end
  ReddotManager.RemoveListener(NormalTaskNewReddotName, self)
end

function M:OnCanGetClicked()
  self:RefreshTaskState()
end

function M:OnControllerClicked()
  if self.CurInputDevice ~= ECommonInputType.Gamepad then
    return
  end
  if 2 == self.WS_Btn:GetActiveWidgetIndex() then
    self:OnCanGetClicked()
  elseif 1 == self.WS_Btn:GetActiveWidgetIndex() then
    self:OnJumpClicked()
  end
end

function M:UpdateGetRewardNum()
  if not IsValid(self) or not self.TaskProp then
    return
  end
  JJGameController:UpdateTaskProgressTexts(self, self.TaskProp)
end

function M:UpdateInfinityNum(finishCount)
  if finishCount then
    self.Text_InfinityNum:SetText(string.format(GText("UI_Event_MidTerm_RepeatCount"), finishCount))
  end
end

function M:OnJumpClicked()
  JJGameController:JumpToTask(self.JumpUIId)
end

function M:OnAchvFinished(TaskId)
  if not IsValid(self) then
    return
  end
  if TaskId == self.TaskId then
    self:RefreshTaskState()
    DebugPrint("任务", self.TaskId, "已完成，积分已自动领取")
  end
end

function M:OnMidTermTaskProgressChange(TaskId, Progress)
  if not IsValid(self) then
    return
  end
  if TaskId == self.TaskId then
    self:RefreshTaskState()
  end
end

function M:InitListenEvent()
  local PlayerController = self:GetOwningPlayer()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshBaseInfo()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  JJGameController:RefreshTaskOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.CurInputDevice == ECommonInputType.Gamepad then
    self.Btn_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_Controller:SetFocus()
    self:PlayAnimation(self.Hover)
  end
  return UIUtils.Handle
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self.CurInputDevice == ECommonInputType.Gamepad then
    self.Owner.Owner.CurFocusTask = self.Content
    self:PlayAnimation(self.Hover)
    self.Btn_Jump:SetGamepadIconVisibility(true)
    self.Btn_CanGet.Key_GetReward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Normal)
  self.Btn_Jump:SetGamepadIconVisibility(false)
  self.Btn_CanGet.Key_GetReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:UpdateNormalTaskNewReddot(Count)
  if not IsValid(self) or not self.TaskProp then
    return
  end
  local CacheKey = self.TaskProp.UniqueID or ""
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
  if not CacheData then
    return
  end
  if CacheData[CacheKey] and Count > 0 then
    self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Hidden)
  end
end

return M
