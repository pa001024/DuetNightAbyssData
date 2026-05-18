require("UnLua")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local JJGameModel = require("BluePrints.UI.WBP.ActivityJJGame.JJGameModel")
local JJGameController = require("BluePrints.UI.WBP.ActivityJJGame.JJGameController")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local NormalRewardReddotName = JJGameModel.NormalRewardReddotName
local NormalTaskNewReddotName = JJGameModel.NormalTaskNewReddotName
local ChallengeRewardReddotName = JJGameModel.ChallengeRewardReddotName
local ChallengeTaskNewReddotName = JJGameModel.ChallengeTaskNewReddotName

function M:Construct()
  local Model = JJGameController:RefreshModel()
  self.MidTermConst = Model.MidTermConst
  self.MidTermGoalEventId = Model.MidTermGoalEventId
  self.EventEndTime = Model.EventEndTime
  self.RewardEndTime = Model.RewardEndTime
  self.Text_TaskScoreToday_Total:SetText(tonumber(self.MidTermConst.MaxPrizePoint.ConstantValue))
  self.Text_NormalTask:SetText(GText("UI_Event_MidTerm_NormalTask"))
  self.Text_ChallengeTask:SetText(GText("UI_Event_MidTerm_ChallengeTask"))
  self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_PointView"))
  self.Btn_NormalTask.OnClicked:Add(self, self.OnNormalTaskClicked)
  self.Btn_ChallengeTask.OnClicked:Add(self, self.OnChallengeTaskClicked)
  self._Avatar = Model:GetAvatar()
  self.MidTermGoals = Model.MidTermGoals
  self.Text_TaskScoreToday:SetText(self.MidTermGoals.Scores or 0)
  self:InitGamepadKey()
  self:RefreshBaseInfo()
  self:InitListenEvent()
  self:InitJJGameReddot()
end

function M:Destruct()
  self.Btn_NormalTask.OnClicked:Clear()
  self.Btn_ChallengeTask.OnClicked:Clear()
  ReddotManager.RemoveListener(NormalRewardReddotName, self)
  ReddotManager.RemoveListener(ChallengeRewardReddotName, self)
  ReddotManager.RemoveListener(NormalTaskNewReddotName, self)
  ReddotManager.RemoveListener(ChallengeTaskNewReddotName, self)
end

function M:Init()
  self:PlayAnimation(self.In_1)
  self:PlayAnimation(self.In_2)
end

function M:InitPage(EventId)
  self:PlayAnimation(self.In_1)
  self:PlayAnimation(self.In_2)
end

function M:OnNormalTaskClicked()
  self.ActivityJJGameTask = JJGameController:OpenTaskView(self, self.ActivityJJGameTask, 0, self.OnCloseCallback, self)
end

function M:OnChallengeTaskClicked()
  self.ActivityJJGameTask = JJGameController:OpenTaskView(self, self.ActivityJJGameTask, 1, self.OnCloseCallback, self)
end

function M:OnCloseCallback(CloseCallbackObj)
  CloseCallbackObj:InitJJGameReddot()
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshBaseInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurGamepadName = CurGamepadName
  local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
  if IsUseGamepad then
    self.Key_Normal:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Key_Challenge:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_Normal:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Challenge:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.CurInputDevice = CurInputDevice
end

function M:InitGamepadKey()
  self.Key_Normal:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.Key_Challenge:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadButtonDown(InKeyName)
  end
  return IsEventHandled
end

function M:OnGamePadButtonDown(InKeyName)
  return self:HandleKeyDownOnGamePad(InKeyName)
end

function M:HandleKeyDownOnGamePad(InKeyName)
  local IsEventHandled = false
  if InKeyName == Const.GamepadFaceButtonLeft then
    self:OnNormalTaskClicked()
  elseif InKeyName == Const.GamepadFaceButtonUp then
    self:OnChallengeTaskClicked()
  end
  return IsEventHandled
end

function M:InitJJGameReddot()
  JJGameController:EnsureReddotNodes()
  ReddotManager.AddListenerEx(NormalRewardReddotName, self, self.UpdateNormalReddot)
  ReddotManager.AddListenerEx(ChallengeRewardReddotName, self, self.UpdateChallengeReddot)
  ReddotManager.AddListenerEx(NormalTaskNewReddotName, self, self.UpdateNormalTaskNewReddot)
  ReddotManager.AddListenerEx(ChallengeTaskNewReddotName, self, self.UpdateChallengeTaskNewReddot)
  local Model = JJGameController:RefreshEntryReddotState()
  self._Avatar = Model:GetAvatar()
  self.MidTermGoals = Model.MidTermGoals
  self.MidTermGoalEventId = Model.MidTermGoalEventId
  self.EventEndTime = Model.EventEndTime
  self.RewardEndTime = Model.RewardEndTime
end

function M:CalEventDay()
  return JJGameController:RefreshModel().EventDay
end

function M:CheckIsMidTermGoalNeedShowReddot()
  local Model = JJGameController:RefreshEntryReddotState()
  self._Avatar = Model:GetAvatar()
  self.MidTermGoals = Model.MidTermGoals
  self.EventEndTime = Model.EventEndTime
  self.RewardEndTime = Model.RewardEndTime
end

function M:TryIncreaceNormalRewardReddot(Key)
  JJGameController:TryIncreaseNormalRewardReddot(Key)
end

function M:TrySubNormalRewardReddot(Key)
  JJGameController:TrySubNormalRewardReddot(Key)
end

function M:TryIncreaceChallengeRewardReddot(Key)
  JJGameController:TryIncreaseChallengeRewardReddot(Key)
end

function M:TrySubChallengeTaskRewardReddot(TaskId)
  JJGameController:TrySubChallengeTaskRewardReddot(TaskId)
end

function M:TrySubChallengeRewardReddot(Target)
  JJGameController:TrySubChallengeRewardReddot(Target)
end

function M:TryIncreaceChallengeTaskNewReddot(TaskItem)
  JJGameController:TryIncreaseChallengeTaskNewReddot(TaskItem)
end

function M:TryIncreaceNormalTaskNewReddot(TaskItem)
  JJGameController:TryIncreaseNormalTaskNewReddot(TaskItem)
end

function M:UpdateNormalReddot(Count)
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalRewardReddotName)
  if not CacheData then
    return
  end
  self.HasNormalReddot = false
  if Count > 0 then
    if self.NormalNew:IsVisible() then
      self.NormalNew:SetVisibility(UIConst.VisibilityOp.Hidden)
    end
    self.NormalReddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.HasNormalReddot = true
  else
    self.NormalReddot:SetVisibility(UIConst.VisibilityOp.Hidden)
    self.HasNormalReddot = false
  end
  ActivityReddotHelper.RefreshReddotNode(self.MidTermGoalEventId)
end

function M:UpdateChallengeReddot(Count)
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeRewardReddotName)
  if not CacheData then
    return
  end
  self.HasChallengeReddot = false
  if Count > 0 then
    if self.SpecialNew:IsVisible() then
      self.SpecialNew:SetVisibility(UIConst.VisibilityOp.Hidden)
    end
    self.SpecialReddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.HasChallengeReddot = true
  else
    self.SpecialReddot:SetVisibility(UIConst.VisibilityOp.Hidden)
    self.HasChallengeReddot = false
  end
  ActivityReddotHelper.RefreshReddotNode(self.MidTermGoalEventId)
end

function M:UpdateNormalTaskNewReddot(Count)
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
  if not CacheData then
    return
  end
  if Count > 0 then
    if self.NormalReddot:IsVisible() then
      return
    end
    self.NormalNew:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.NormalNew:SetVisibility(UIConst.VisibilityOp.Hidden)
  end
end

function M:UpdateChallengeTaskNewReddot(Count)
  local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
  if not CacheData then
    return
  end
  if Count > 0 then
    if self.SpecialReddot:IsVisible() then
      return
    end
    self.SpecialNew:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.SpecialNew:SetVisibility(UIConst.VisibilityOp.Hidden)
  end
end

function M:ClearChallengeTaskNewReddot()
  JJGameController:ClearChallengeTaskNewReddot(nil)
end

function M:ClearChallengeRewardReddot()
  JJGameController:ClearChallengeRewardReddot()
end

function M:ClearNormalTaskNewReddot()
  JJGameController:ClearNormalTaskNewReddot(nil)
end

function M:ClearNormalRewardReddot()
  JJGameController:ClearNormalRewardReddot()
end

function M:UpdateActivityTabNewReddot()
  JJGameController:UpdateActivityTabNewReddot()
end

return M
