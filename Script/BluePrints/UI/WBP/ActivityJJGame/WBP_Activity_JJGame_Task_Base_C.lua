require("UnLua")
local JJGameModel = require("BluePrints.UI.WBP.ActivityJJGame.JJGameModel")
local JJGameController = require("BluePrints.UI.WBP.ActivityJJGame.JJGameController")
local TaskType = JJGameModel.TaskType
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local NormalTaskBP_P = "/Game/UI/WBP/Activity/PC/JJGame/WBP_Activity_JJGame_NormalTask_P.WBP_Activity_JJGame_NormalTask_P"
local NormalTaskBP_M = "/Game/UI/WBP/Activity/Mobile/JJGame/WBP_Activity_JJGame_NormalTask_M.WBP_Activity_JJGame_NormalTask_M"
local ChallengeTaskBP_P = "/Game/UI/WBP/Activity/PC/JJGame/WBP_Activity_JJGame_ChallengeTask_P.WBP_Activity_JJGame_ChallengeTask_P"
local ChallengeTaskBP_M = "/Game/UI/WBP/Activity/Mobile/JJGame/WBP_Activity_JJGame_ChallengeTask_M.WBP_Activity_JJGame_ChallengeTask_M"
local NormalRewardReddotName = JJGameModel.NormalRewardReddotName
local ChallengeRewardReddotName = JJGameModel.ChallengeRewardReddotName
local NormalTaskNewReddotName = JJGameModel.NormalTaskNewReddotName
local ChallengeTaskNewReddotName = JJGameModel.ChallengeTaskNewReddotName

function M:Construct()
  self.Super.Construct(self)
  self:AddDispatcher(EventID.OnMidTermTaskComplete, self, self.OnAchvFinished)
  self:AddDispatcher(EventID.OnMidTermTaskProgressChange, self, self.OnMidTermTaskProgressChange)
  self:AddDispatcher(EventID.OnActivityEntryShowVisible, self, self.RefreshCurrentTaskWidget)
  self:InitListenEvent()
  self:RefreshBaseInfo()
  ReddotManager.AddListenerEx(NormalTaskNewReddotName, self, self.UpdateNormalTaskNewReddot)
  ReddotManager.AddListenerEx(ChallengeTaskNewReddotName, self, self.UpdateChallengeTaskNewReddot)
  ReddotManager.AddListenerEx(NormalRewardReddotName, self, self.UpdateNormalRewardReddot)
  ReddotManager.AddListenerEx(ChallengeRewardReddotName, self, self.UpdateChallengeRewardReddot)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "JJGameTaskBase", nil)
end

function M:Destruct()
  AudioManager(self):SetEventSoundParam(self, "JJGameTaskBase", {ToEnd = 1})
  self.Super.Destruct(self)
  ReddotManager.RemoveListener(NormalTaskNewReddotName, self)
  ReddotManager.RemoveListener(ChallengeTaskNewReddotName, self)
  ReddotManager.RemoveListener(NormalRewardReddotName, self)
  ReddotManager.RemoveListener(ChallengeRewardReddotName, self)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  self.NormalTaskBP = nil
  self.ChallengeTaskBP = nil
  if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" then
    self.NormalTaskBP = NormalTaskBP_M
    self.ChallengeTaskBP = ChallengeTaskBP_M
  else
    self.NormalTaskBP = NormalTaskBP_P
    self.ChallengeTaskBP = ChallengeTaskBP_P
  end
  self.Params = Params
  self.Owner = Params.Owner
  self:SwitchBG(Params.TabId)
  self._Avatar = GWorld:GetAvatar()
  self:InitTaskData()
  self:InitMainTab(Params.TabId)
  self:UpdateTabNewReddot()
  self:PlayAnimation(self.In)
  self:SetFocus()
end

function M:InitTaskData()
  local Model = JJGameController:RefreshModel()
  self.MidTermConst = Model.MidTermConst
  self.MidTermGoalEventId = Model.MidTermGoalEventId
  self.EventStartTime = Model.EventStartTime
  self.EventEndTime = Model.EventEndTime
  self.RewardEndTime = Model.RewardEndTime
  self.MidTermGoals = Model.MidTermGoals
  self.MidTermAchvScores = Model.MidTermAchvScores
  self.MidTermTasks = Model.MidTermTasks
  self.MidTermTasksRecord = Model.MidTermTasksRecord
  self.MidTermAchvProgressRewarded = Model.MidTermAchvProgressRewarded
  self.MidTermScores = Model.MidTermScores
  self.MidTermScoresRewards = Model.MidTermScoresRewards
  self.EventDay = Model.EventDay
  self.remainDays, self.remainHours = self:UpdateEventDay()
end

function M:UpdateEventDay()
  local Model = JJGameController:RefreshModel()
  self.EventDay = Model.EventDay
  return Model.RemainDays, Model.RemainHours
end

function M:InitMainTab(TargetTabId)
  local IsInPc = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
  if IsInPc then
    self.Com_Tab = self.Com_Tab_P
  else
    self.Com_Tab = self.Com_Tab_M
  end
  self.Tabs = {
    {
      TabId = 0,
      Text = GText("UI_Event_MidTerm_NormalTask"),
      IconPath = self.MidTermConst.TabIcon_1.ConstantString
    },
    {
      TabId = 1,
      Text = GText("UI_Event_MidTerm_ChallengeTask"),
      IconPath = self.MidTermConst.TabIcon_2.ConstantString
    }
  }
  self.Com_Tab:Init({
    Tabs = self.Tabs,
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "SpaceBar",
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "Y",
            Owner = self
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
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    },
    OwnerPanel = self,
    BackCallback = self.CloseSelf,
    StyleName = "TextImage",
    TitleName = GText("Event_Title_103006")
  })
  if self.Com_Tab.Btn_Confirm then
    self.Com_Tab.Btn_Confirm:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Com_Tab:BindEventOnTabSelected(self, self.OnTabChanged)
  self.IsInited = true
  self.Com_Tab:SelectTabById(TargetTabId)
end

function M:UpdateTabNewReddot()
  if not self.Com_Tab then
    return
  end
  JJGameController:UpdateTaskTabReddot(self.Com_Tab)
end

function M:UpdateNormalRewardReddot(Count)
  if not self.Com_Tab then
    return
  end
  self:UpdateTabNewReddot()
end

function M:UpdateChallengeRewardReddot(Count)
  if not self.Com_Tab then
    return
  end
  self:UpdateTabNewReddot()
end

function M:UpdateNormalTaskNewReddot(Count)
  if not self.Com_Tab then
    return
  end
  self:UpdateTabNewReddot()
end

function M:UpdateChallengeTaskNewReddot(Count)
  if not self.Com_Tab then
    return
  end
  self:UpdateTabNewReddot()
end

function M:InitTask(TargetTabId)
  self.PanelAnchor:ClearChildren()
  self.TaskWidget = nil
  if 0 == TargetTabId then
    self.ChallengeTaskWidget = nil
    self.NormalTaskWidget = UIManager(self):CreateWidget(self.NormalTaskBP)
    self.TaskWidget = self.NormalTaskWidget
  else
    self.NormalTaskWidget = nil
    self.ChallengeTaskWidget = UIManager(self):CreateWidget(self.ChallengeTaskBP)
    self.TaskWidget = self.ChallengeTaskWidget
  end
  if not self.TaskWidget then
    return
  end
  local Slot = self.PanelAnchor:AddChildToOverlay(self.TaskWidget)
  Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  local Params = {
    Owner = self,
    EventDay = self.EventDay,
    RemainDays = self.remainDays,
    RemainHours = self.remainHours,
    EventEndTime = self.EventEndTime
  }
  self.TaskWidget:Init(Params)
end

function M:TryIncreaceNormalRewardReddot(TaskId)
  JJGameController:TryIncreaseNormalRewardReddot(TaskId)
end

function M:TryIncreaceChallengeTaskRewardReddot(TaskId)
  if self._Avatar:CheckIsChallengeRewardAllClaimed() then
    return
  end
  JJGameController:TryIncreaseChallengeTaskRewardReddot(TaskId)
end

function M:OnAchvFinished(TaskId)
  if IsValid(self.TaskWidget) and self.TaskWidget.OnAchvFinished then
    self.TaskWidget:OnAchvFinished(TaskId)
  end
  local Model = JJGameController:RefreshModel()
  self.MidTermAchvProgressRewarded = Model.MidTermAchvProgressRewarded
  self.EventDay = Model.EventDay
  local Task = Model:GetTaskByTaskId(TaskId)
  if Task then
    local TaskData = DataMgr.MidTermTask[Task.UniqueID]
    if TaskData and TaskData.TaskType == TaskType.Achievement and TaskData.EnableDay <= self.EventDay then
      self:TryIncreaceChallengeTaskRewardReddot(TaskId)
    end
  end
end

function M:OnMidTermTaskProgressChange(TaskId, Progress)
  if IsValid(self.TaskWidget) and self.TaskWidget.OnMidTermTaskProgressChange then
    self.TaskWidget:OnMidTermTaskProgressChange(TaskId, Progress)
  end
end

function M:GetTaskReward(Item, TaskWidget, TaskId)
  local Avatar = GWorld:GetAvatar()
  
  local function Callback(ErrCode)
    print("MidTermGetTaskReward", ErrorCode:Name(ErrCode))
    if ErrCode == ErrorCode.RET_SUCCESS then
      if IsValid(TaskWidget) and TaskWidget.OnTaskGet then
        TaskWidget:OnTaskGet(Item)
      end
    else
      local ErrorCodeData = DataMgr.ErrorCode[ErrCode]
      if IsValid(self) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(ErrorCodeData.ErrorCodeContent))
      end
    end
    if IsValid(self) then
      self:BlockAllUIInput(false)
    end
  end
  
  self:BlockAllUIInput(true)
  Avatar:MidTermGetTaskReward(TaskId, Callback)
end

function M:OnTabChanged(TabWidget)
  if self.IsInited then
    self.IsInited = false
  else
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_page_refresh", nil, nil)
  end
  self:PlayAnimation(self.Change)
  local TabId = TabWidget:GetTabId()
  self.CurrentTabIndex = TabId
  self:SwitchBG(TabId)
  self:InitTask(TabId)
end

function M:RefreshCurrentTaskWidget()
  if not IsValid(self) then
    return
  end
  self:InitTaskData()
  if IsValid(self.TaskWidget) then
    if self.TaskWidget.RefreshTaskView then
      self.TaskWidget:RefreshTaskView()
    elseif self.TaskWidget.InitTaskList then
      self.TaskWidget:InitTaskList()
    end
  end
  self:UpdateTabNewReddot()
end

function M:SwitchBG(TabId)
  if 0 == TabId then
    self.WS_BG:SetActiveWidgetIndex(0)
  else
    self.WS_BG:SetActiveWidgetIndex(1)
  end
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
  self:PlayAnimation(self.Out)
  if self.Params.CloseCallback then
    self.Params.CloseCallback(self, self.Params.CloseCallbackObj)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    self:CloseSelf()
  elseif "Q" == InKeyName then
    self.Com_Tab:TabToLeft()
  elseif "E" == InKeyName then
    self.Com_Tab:TabToRight()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnGamePadDown(InKeyName)
  if "Gamepad_FaceButton_Right" == InKeyName then
    if self.NormalTaskWidget and self.NormalTaskWidget.IsFocusBigReward then
      self.NormalTaskWidget.IsFocusBigReward = false
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    self:CloseSelf()
  elseif InKeyName == Const.GamepadLeftShoulder then
    self.Com_Tab:TabToLeft()
  elseif InKeyName == Const.GamepadRightShoulder then
    self.Com_Tab:TabToRight()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
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
  self.CurGamepadName = CurGamepadName
  self.CurInputDevice = CurInputDevice
end

function M:BP_GetDesiredFocusTarget()
  return self.TaskWidget
end

function M:ReceiveEnterState(StackAction)
  self.Super.ReceiveEnterState(self, StackAction)
  self:RefreshCurrentTaskWidget()
  if not IsValid(self.TaskWidget) then
    return
  end
  if 0 == self.CurrentTabIndex then
    if IsValid(self.TaskWidget.NormalItem) then
      local FirstItem = self.TaskWidget.NormalItem.List_Task:GetItemAt(0)
      if FirstItem and FirstItem.SelfWidget and IsValid(FirstItem.SelfWidget) then
        FirstItem.SelfWidget:SetFocus()
      else
        self.TaskWidget.NormalItem:SetFocus()
      end
    end
  elseif 1 == self.CurrentTabIndex and IsValid(self.TaskWidget.List_Challenge) then
    local FirstItem = self.TaskWidget.List_Challenge:GetItemAt(0)
    if FirstItem and FirstItem.SelfWidget and IsValid(FirstItem.SelfWidget) then
      FirstItem.SelfWidget:SetFocus()
    else
      self.TaskWidget.List_Challenge:SetFocus()
    end
  end
end

return M
