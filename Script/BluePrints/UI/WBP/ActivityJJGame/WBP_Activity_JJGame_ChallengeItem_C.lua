require("UnLua")
local JJGameModel = require("BluePrints.UI.WBP.ActivityJJGame.JJGameModel")
local JJGameController = require("BluePrints.UI.WBP.ActivityJJGame.JJGameController")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local ChallengeTaskNewReddotName = JJGameModel.ChallengeTaskNewReddotName

function M:Construct()
  self.Text_Doing:SetText(GText("UI_Event_MidTerm_InProgress"))
  self.Btn_Jump:SetText(GText("UI_Event_MidTerm_GotoTask"))
  self.Text_WaitRefresh:SetText(GText("UI_Event_MidTerm_RefreshTask"))
  self.Btn_Jump.Button_Area.OnClicked:Add(self, self.OnJumpClicked)
  self.Btn_Jump:SetGamepadIconVisibility(false)
  self.Btn_CanGet.Text_GetReward:SetText(GText("UI_Achievement_GetReward"))
  self.Btn_CanGet.Btn_GetReward.OnClicked:Add(self, self.OnCanGetClicked)
  self.Btn_Controller.OnClicked:Add(self, self.OnControllerClicked)
  self.Avatar = GWorld:GetAvatar()
  self:InitListenEvent()
  self:RefreshBaseInfo()
end

function M:Destruct()
  self.Btn_Jump.Button_Area.OnClicked:Clear()
  self.Btn_CanGet.Btn_GetReward.OnClicked:Clear()
  self.Btn_Controller.OnClicked:Clear()
  ReddotManager.RemoveListener(ChallengeTaskNewReddotName, self)
end

function M:OnListItemObjectSet(Content)
  self.Owner = Content.Owner
  self.JJGameBase = self.Owner.Owner
  self.Content = Content
  self.TaskId = Content.TaskId
  self.TaskProp = Content.TaskProp
  self.TaskConfig = Content.TaskConfig
  self.MidTermConst = DataMgr.MidTermGoalConstant
  Content.SelfWidget = self
  self.Text_RewardNum:SetText(Content.Point)
  self.Text_Desc:SetText(GText(Content.Desc))
  local Progress = self.TaskProp.Progress or 0
  if Progress >= self.TaskProp.Target then
    if self.TaskProp.RewardsGot then
      self.WS_Btn:SetActiveWidgetIndex(3)
      if self.Owner and self.Owner.TrySubChallengeTaskRewardReddot then
        self.Owner:TrySubChallengeTaskRewardReddot(self.TaskProp.UniqueID)
      end
      if self.Owner and self.Owner.TrySubChallengeTaskNewReddot then
        self.Owner:TrySubChallengeTaskNewReddot(self.TaskProp.UniqueID)
      end
    else
      self.Content.CanGet = true
      self.WS_Btn:SetActiveWidgetIndex(2)
    end
  elseif Content.TaskConfig.JumpUIId then
    self.WS_Btn:SetActiveWidgetIndex(1)
    self.JumpUIId = Content.TaskConfig.JumpUIId
  else
    self.WS_Btn:SetActiveWidgetIndex(0)
  end
  self:UpdateGetRewardNum()
  ReddotManager.AddListenerEx(ChallengeTaskNewReddotName, self, self.UpdateChallengeTaskNewReddot)
end

function M:BP_OnEntryReleased()
  if self.Content then
    self.Content.SelfWidget = nil
  end
  ReddotManager.RemoveListener(ChallengeTaskNewReddotName, self)
end

function M:OnCanGetClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_normal_btn_click", nil, nil)
  self.JJGameBase:GetTaskReward(self, self.Owner, self.TaskId)
end

function M:OnControllerClicked()
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
  if self.TaskProp.Progress >= self.TaskProp.Target and self.TaskProp.RewardsGot then
    if self.Owner and self.Owner.TrySubChallengeTaskRewardReddot then
      self.Owner:TrySubChallengeTaskRewardReddot(self.TaskProp.UniqueID)
    end
    if self.Owner and self.Owner.TrySubChallengeTaskNewReddot then
      self.Owner:TrySubChallengeTaskNewReddot(self.TaskProp.UniqueID)
    end
    self.WS_Btn:SetActiveWidgetIndex(3)
  end
end

function M:OnJumpClicked()
  JJGameController:JumpToTask(self.TaskConfig.JumpUIId)
end

function M:TryIncreaceChallengeTaskRewardReddot(TaskId)
  local Avatar = GWorld:GetAvatar()
  if Avatar:CheckIsChallengeRewardAllClaimed() then
    return
  end
  JJGameController:TryIncreaseChallengeTaskRewardReddot(TaskId)
end

function M:OnAchvFinished(TaskId)
  if not IsValid(self) then
    return
  end
  if TaskId == self.TaskId then
    self.Content.CanGet = true
    self.WS_Btn:SetActiveWidgetIndex(2)
    self:UpdateGetRewardNum()
    self:TryIncreaceChallengeTaskRewardReddot(self.TaskProp.UniqueID)
    DebugPrint("任务", self.TaskId, "已完成，可以领取奖励")
  end
end

function M:OnMidTermTaskProgressChange(TaskId, Progress)
  if not IsValid(self) then
    return
  end
  if TaskId == self.TaskId then
    self:UpdateGetRewardNum()
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

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.CurInputDevice == ECommonInputType.Gamepad then
    self.Btn_Controller:SetFocus()
    self:PlayAnimation(self.Hover)
  end
  return UIUtils.Handle
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self.CurInputDevice == ECommonInputType.Gamepad then
    self.Owner.CurFocusTask = self.Content
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

function M:UpdateChallengeTaskNewReddot(Count)
  if not IsValid(self) or not self.TaskProp then
    return
  end
  local CacheKey = self.TaskProp.UniqueID or ""
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
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
