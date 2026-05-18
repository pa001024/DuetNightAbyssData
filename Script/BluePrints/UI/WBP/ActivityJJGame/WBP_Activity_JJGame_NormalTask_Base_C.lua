require("UnLua")
local JJGameModel = require("BluePrints.UI.WBP.ActivityJJGame.JJGameModel")
local JJGameController = require("BluePrints.UI.WBP.ActivityJJGame.JJGameController")
local NormalRewardReddotName = JJGameModel.NormalRewardReddotName
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local TaskType = JJGameModel.TaskType

function M:Construct()
  self.MidTermConst = DataMgr.MidTermGoalConstant
  self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_PointView"))
  self.Text_NeedScore:SetText(GText("UI_Event_MidTerm_NoPoint"))
  self.Text_NextDay:SetText(GText("UI_Event_MidTerm_Prize"))
  self.Text_GetBigReward:SetText(GText("UI_Event_MidTerm_GetPrize"))
  self.Text_TaskScoreToday_Total:SetText(self.MidTermConst.MaxPrizePoint.ConstantValue)
  self.Text_NextDay:SetText(GText("UI_Event_MidTerm_Prize"))
  self.Text_NeedScore:SetText(GText("UI_Event_MidTerm_NoPoint"))
  self.Text_BottomOneClickTitle:SetText(GText("UI_Event_MidTerm_Overflow"))
  self.Text_Empty:SetText(GText("UI_Event_MidTerm_End"))
  self.Btn_OneClickGet:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_GetBigReward.OnClicked:Add(self, self.GetBigReward)
  self.TaskScroll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.CurFocusTask = nil
  self:InitListenEvent()
  self:RefreshBaseInfo()
  self.Key_GetBigReward:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.Key_Title:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
end

function M:UpdateNormalRewardReddot(Count)
  if not self.Owner.Com_Tab then
    return
  end
  self.Owner:UpdateTabNewReddot()
end

function M:Destruct()
  ReddotManager.RemoveListener(NormalRewardReddotName, self)
  self.Btn_GetBigReward.OnClicked:Clear()
  self:UnbindFromAnimationFinished(self.Percent, {
    self,
    self.OnPercentAnimFinished
  })
end

function M:Init(Params)
  self.Params = Params
  self.Owner = Params.Owner
  self.EventEndTime = Params.EventEndTime
  self._Avatar = GWorld:GetAvatar()
  local Model = JJGameController:RefreshModel()
  self.MidTermGoalEventId = self.MidTermConst.MidTermGoalEventId.ConstantValue
  self.MidTermGoals = Model.MidTermGoals
  self.EventDay = Model.EventDay
  self.RewardEndTime = Model.RewardEndTime
  if Model:HasUnclaimedNormalScoreReward() then
    self.Group_Score:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Group_Progress:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:TryIncreaceNormalRewardReddot("ScoresRewards")
    if TimeUtils.NowTime() > self.EventEndTime then
      self.Text_BigRewardTitle:SetText(GText("UI_Event_MidTerm_Settled_End"))
    else
      self.Text_BigRewardTitle:SetText(GText("UI_Event_MidTerm_Settled"))
    end
    self.YesterdayRewardGot = false
    self:InitYesterdayRewardList()
    self:PlayAnimation(self.VX_Reminder)
  else
    self:TrySubNormalRewardReddot("ScoresRewards")
    self.Group_Score:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Group_Progress:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_BigRewardTitle:SetText(GText("UI_Event_MidTerm_NormalPreview"))
    self.YesterdayRewardGot = true
  end
  self:UpdateTaskScoreToday()
  self:InitTaskList()
  self:PlayAnimation(self.In)
  ReddotManager.AddListenerEx(NormalRewardReddotName, self, self.UpdateNormalRewardReddot)
  if TimeUtils.NowTime() > self.EventEndTime then
    self:TryClearNormalTaskRewardReddot()
    self.WS_Right:SetActiveWidgetIndex(1)
    if self.YesterdayRewardGot or TimeUtils.NowTime() > self.RewardEndTime then
      self:TryClearNormalRewardReddot()
      self.WS_Btn:SetActiveWidgetIndex(1)
      self.Text_NeedScore:SetText(GText("UI_Event_MidTerm_PrizeEnd"))
      for _, Item in pairs(self.List_BigReward:GetListItems()) do
        Item.bShadow = true
        Item.BonusType = nil
      end
      self.List_BigReward:RegenerateAllEntries()
    end
  end
  self:SetFocus()
end

function M:CalEventDay()
  return JJGameController:RefreshModel().EventDay
end

function M:TryIncreaceNormalRewardReddot(Key)
  JJGameController:TryIncreaseNormalRewardReddot(Key)
end

function M:TrySubNormalRewardReddot(Key)
  JJGameController:TrySubNormalRewardReddot(Key)
end

function M:TryClearNormalRewardReddot()
  JJGameController:ClearNormalRewardReddot()
end

function M:TryClearNormalTaskRewardReddot()
  local Model = JJGameController:RefreshModel()
  JJGameController:ClearNormalTaskRewardReddotByTasks(Model.MidTermTasks)
end

function M:TrySubNormalTaskNewReddot(TaskId)
  JJGameController:TrySubNormalTaskNewReddot(TaskId)
end

function M:UpdateTaskScoreToday()
  local Model = JJGameController:RefreshModel()
  self.MidTermGoals = Model.MidTermGoals
  local MidTermScores = Model.MidTermScores
  self.Text_TaskScoreToday:SetText(MidTermScores)
  if IsValid(self.Owner.Owner) then
    self.Owner.Owner.Text_TaskScoreToday:SetText(MidTermScores)
  end
  local MaxPrizePoint = self.MidTermConst.MaxPrizePoint.ConstantValue
  local previousScore = (self.previousProgressPercent or 0) * MaxPrizePoint
  local shouldPlayToMax = false
  if MaxPrizePoint > previousScore and MidTermScores > MaxPrizePoint then
    shouldPlayToMax = true
  end
  if MidTermScores <= MaxPrizePoint or shouldPlayToMax then
    if not self.previousProgressPercent then
      self.previousProgressPercent = 0
    end
    local targetScore = shouldPlayToMax and MaxPrizePoint or MidTermScores
    local progressPercent = targetScore / MaxPrizePoint
    progressPercent = math.max(0, math.min(1, progressPercent))
    local startTime = self.previousProgressPercent * self.Percent:GetEndTime()
    local animationTime = progressPercent * self.Percent:GetEndTime()
    if 0 == animationTime then
      animationTime = 0.001
    end
    if startTime >= animationTime then
      startTime = animationTime - 0.001
    end
    self:UnbindFromAnimationFinished(self.Percent, {
      self,
      self.OnPercentAnimFinished
    })
    self._pendingPlayToMax = shouldPlayToMax
    self:PlayAnimationTimeRange(self.Percent, startTime, animationTime)
    self:BindToAnimationFinished(self.Percent, {
      self,
      self.OnPercentAnimFinished
    })
    if not shouldPlayToMax then
      self.previousProgressPercent = progressPercent
    end
  end
  if self.YesterdayRewardGot then
    self:UpdateRewardList(MidTermScores)
  end
  self:UpdateBtnState(MidTermScores)
end

function M:OnPercentAnimFinished()
  self:PlayAnimation(self.Percent_VX)
  if self._pendingPlayToMax then
    self._pendingPlayToMax = false
    self.previousProgressPercent = 1.0
    self:AddTimer(0.1, function()
      self:UpdateTaskScoreToday()
    end)
  end
end

function M:InitTaskList()
  self:UpdateNormalTaskList()
  self:UpdateCycleTaskList()
  self:UpdateOneClickBtnState()
end

function M:RefreshTaskView()
  if not IsValid(self) then
    return
  end
  local Model = JJGameController:RefreshModel()
  self.MidTermGoals = Model.MidTermGoals
  self.EventDay = Model.EventDay
  self.EventEndTime = Model.EventEndTime
  self.RewardEndTime = Model.RewardEndTime
  if Model:HasUnclaimedNormalScoreReward() then
    self.Group_Score:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Group_Progress:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:TryIncreaceNormalRewardReddot("ScoresRewards")
    if TimeUtils.NowTime() > self.EventEndTime then
      self.Text_BigRewardTitle:SetText(GText("UI_Event_MidTerm_Settled_End"))
    else
      self.Text_BigRewardTitle:SetText(GText("UI_Event_MidTerm_Settled"))
    end
    self.YesterdayRewardGot = false
    self:InitYesterdayRewardList()
  else
    self:TrySubNormalRewardReddot("ScoresRewards")
    self.Group_Score:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Group_Progress:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_BigRewardTitle:SetText(GText("UI_Event_MidTerm_NormalPreview"))
    self.YesterdayRewardGot = true
  end
  self:UpdateTaskScoreToday()
  self:InitTaskList()
  if TimeUtils.NowTime() > self.EventEndTime then
    self:TryClearNormalTaskRewardReddot()
    self.WS_Right:SetActiveWidgetIndex(1)
    if self.YesterdayRewardGot or TimeUtils.NowTime() > self.RewardEndTime then
      self:TryClearNormalRewardReddot()
      self.WS_Btn:SetActiveWidgetIndex(1)
      self.Text_NeedScore:SetText(GText("UI_Event_MidTerm_PrizeEnd"))
      for _, Item in pairs(self.List_BigReward:GetListItems()) do
        Item.bShadow = true
        Item.BonusType = nil
      end
      self.List_BigReward:RegenerateAllEntries()
    end
  end
end

function M:UpdateNormalTaskList()
  local NormalTaskConfig = {
    Name = "UI_Event_MidTerm_DailyTask",
    EventDay = self.EventDay,
    TaskType = TaskType.Daily,
    YesterdayRewardGot = self.YesterdayRewardGot,
    Owner = self
  }
  self.NormalItem:Init(NormalTaskConfig)
end

function M:UpdateCycleTaskList()
  local CycleTaskConfig = {
    Name = "UI_Event_MidTerm_RepeatTask",
    EventDay = self.EventDay,
    TaskType = TaskType.Cycle,
    YesterdayRewardGot = self.YesterdayRewardGot,
    Owner = self
  }
  self.CycleItem:Init(CycleTaskConfig)
end

function M:InitYesterdayRewardList()
  self.List_BigReward:ClearListItems()
  local RewardList = JJGameController:RefreshModel():BuildYesterdayRewardPreview()
  for _, RewardData in ipairs(RewardList) do
    self.List_BigReward:AddItem(self:NewItemContent(RewardData.ItemType, RewardData.ItemId, RewardData.Icon, RewardData.Rarity, RewardData.Count))
  end
end

function M:UpdateRewardList(TaskScoreToday)
  self.List_BigReward:ClearListItems()
  local RewardList = JJGameController:RefreshModel():BuildCurrentRewardPreview(TaskScoreToday)
  for _, RewardData in ipairs(RewardList) do
    local ItemContent = self:NewItemContent(RewardData.ItemType, RewardData.ItemId, RewardData.Icon, RewardData.Rarity, RewardData.Count)
    ItemContent.BonusType = RewardData.BonusType
    self.List_BigReward:AddItem(ItemContent)
  end
end

function M:UpdateBtnState(TaskScoreToday)
  if not self.YesterdayRewardGot then
    self.WS_Btn:SetActiveWidgetIndex(0)
    return
  end
  if 0 == TaskScoreToday then
    self.WS_Btn:SetActiveWidgetIndex(1)
  elseif self.NeedTorrow then
    self.WS_Btn:SetActiveWidgetIndex(2)
  else
    self.WS_Btn:SetActiveWidgetIndex(3)
  end
end

function M:UpdateOneClickBtnState()
  local CloseCallback = not self.CloseSelf and self.Owner and self.Owner.CloseSelf
  local CloseOwner = self.CloseSelf and self or self.Owner
  local ComTab = self.Owner and self.Owner.Com_Tab
  if ComTab and not IsValid(ComTab) then
    ComTab = nil
  end
  JJGameController:UpdateClaimAllBottomKey(ComTab, false, nil, CloseCallback, CloseOwner)
end

function M:GetBigReward()
  if TimeUtils.NowTime() > self.RewardEndTime then
    return
  end
  local Avatar = GWorld:GetAvatar()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_all_btn_click", nil, nil)
  
  local function Cb(ErrCode, Ret)
    DebugPrint("GetBigReward", ErrorCode:Name(ErrCode))
    if ErrCode == ErrorCode.RET_SUCCESS then
      self.YesterdayRewardGot = true
      self:UpdateTaskScoreToday()
      self:TrySubNormalRewardReddot("ScoresRewards")
      UIManager(GWorld.GameInstance):LoadUI(UIConst.LoadInConfig, "GetItemPage", nil, nil, nil, nil, Ret, self.OnGetItemPageClosed, self)
    end
    self.Owner:BlockAllUIInput(false)
  end
  
  self.Owner:BlockAllUIInput(true)
  Avatar:MidTermGetScoresRewards(Cb)
end

function M:OnGetItemPageClosed()
  self.Group_Score:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Group_Progress:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:InitTaskList()
  if TimeUtils.NowTime() > self.EventEndTime then
    self:TryClearNormalRewardReddot()
    self.WS_Btn:SetActiveWidgetIndex(1)
    self.Text_NeedScore:SetText(GText("UI_Event_MidTerm_PrizeEnd"))
    for _, Item in pairs(self.List_BigReward:GetListItems()) do
      Item.bShadow = true
      Item.BonusType = nil
    end
    self.List_BigReward:RegenerateAllEntries()
  end
  self:AddTimer(0.1, function()
    if self.CurInputDevice == ECommonInputType.Gamepad then
      local FocusedTask = self.CurFocusTask or self.NormalItem.List_Task:GetItemAt(0) or self.CycleItem.List_Task:GetItemAt(0)
      if FocusedTask then
        if FocusedTask.TaskType == TaskType.Cycle then
          self.CycleItem.List_Task:BP_NavigateToItem(FocusedTask)
        else
          self.NormalItem.List_Task:BP_NavigateToItem(FocusedTask)
        end
      else
        self:SetFocus()
      end
    else
      local NormalFirstItem = self.NormalItem.List_Task:GetItemAt(0)
      local CycleFirstItem = self.CycleItem.List_Task:GetItemAt(0)
      if NormalFirstItem and NormalFirstItem.SelfWidget and IsValid(NormalFirstItem.SelfWidget) then
        NormalFirstItem.SelfWidget:SetFocus()
      elseif CycleFirstItem and CycleFirstItem.SelfWidget and IsValid(CycleFirstItem.SelfWidget) then
        CycleFirstItem.SelfWidget:SetFocus()
      else
        self:SetFocus()
      end
    end
  end)
end

function M:NewItemContent(ItemType, ItemId, Icon, Rarity, Count, Quantity, OpenFunction)
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.ItemType = ItemType
  Obj.ItemId = ItemId
  Obj.UnitId = ItemId
  Obj.Rarity = Rarity
  Obj.Icon = Icon
  Obj.IsShowDetails = true
  Obj.OnMenuOpenChangedEvents = {Obj = self, Callback = OpenFunction}
  Obj.UIName = "ActivityJJGameNormalTask"
  Obj.Count = Count
  return Obj
end

function M:OnAchvFinished(TaskId)
  if IsValid(self.NormalItem) and self.NormalItem.OnAchvFinished then
    self.NormalItem:OnAchvFinished(TaskId)
  end
  if IsValid(self.CycleItem) and self.CycleItem.OnAchvFinished then
    self.CycleItem:OnAchvFinished(TaskId)
  end
  self:UpdateTaskScoreToday()
end

function M:OnMidTermTaskProgressChange(TaskId, Progress)
  if IsValid(self.NormalItem) and self.NormalItem.OnMidTermTaskProgressChange then
    self.NormalItem:OnMidTermTaskProgressChange(TaskId, Progress)
  end
  if IsValid(self.CycleItem) and self.CycleItem.OnMidTermTaskProgressChange then
    self.CycleItem:OnMidTermTaskProgressChange(TaskId, Progress)
  end
end

function M:OnTaskGet(Item)
  if not Item or not Item.Content then
    return
  end
  Item.Content.CanGet = false
  if Item.TaskProp then
    Item.TaskProp.RewardsGot = true
  end
  if Item.Content and Item.Content.TaskProp then
    Item.Content.TaskProp.RewardsGot = true
  end
  if Item.RefreshTaskState then
    Item:RefreshTaskState()
  else
    Item.WS_Btn:SetActiveWidgetIndex(3)
  end
  if Item.Content.TaskType ~= TaskType.Cycle then
    Item:PlayAnimation(Item.In_Got)
  end
  self:UpdateTaskScoreToday()
  self:UpdateOneClickBtnState()
  local UniqueID = Item.TaskProp and Item.TaskProp.UniqueID
  if UniqueID then
    self:TrySubNormalTaskNewReddot(UniqueID)
  end
  if Item.New then
    Item.New:SetVisibility(UIConst.VisibilityOp.Hidden)
  end
  self:AddTimer(0.1, function()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_jiaojiao_score_add", nil, nil)
    self:PlayAnimation(self.Up)
  end)
end

function M:InitListenEvent()
  local PlayerController = self:GetOwningPlayer()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self:InitNavigationRules()
end

function M:RefreshBaseInfo()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurGamepadName = CurGamepadName
  local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
  if IsUseGamepad then
    self.Key_GetBigReward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Key_Title:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_GetBigReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Title:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.CurInputDevice = CurInputDevice
end

function M:InitNavigationRules()
  self.NormalItem:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.NormalItem:SetNavigationRuleExplicit(EUINavigation.Down, self.CycleItem)
  self.CycleItem:SetNavigationRuleExplicit(EUINavigation.Up, self.NormalItem)
  self.CycleItem:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.CycleItem:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_BigReward:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_BigReward:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
end

function M:BP_GetDesiredFocusTarget()
  if not IsValid(self) then
    return nil
  end
  if self.CurFocusTask ~= nil and self.CurFocusTask.SelfWidget and IsValid(self.CurFocusTask.SelfWidget) then
    return self.CurFocusTask.SelfWidget
  end
  local NormalFirstItem = IsValid(self.NormalItem) and self.NormalItem.List_Task:GetItemAt(0) or nil
  if NormalFirstItem and NormalFirstItem.SelfWidget and IsValid(NormalFirstItem.SelfWidget) then
    return NormalFirstItem.SelfWidget
  end
  local CycleFirstItem = IsValid(self.CycleItem) and self.CycleItem.List_Task:GetItemAt(0) or nil
  if CycleFirstItem and CycleFirstItem.SelfWidget and IsValid(CycleFirstItem.SelfWidget) then
    return CycleFirstItem.SelfWidget
  else
    return nil
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
  elseif "Q" == InKeyName then
  elseif "E" == InKeyName then
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = true
  if "Gamepad_LeftThumbstick" == InKeyName then
    self.List_BigReward:SetFocus()
    self.IsFocusBigReward = true
  elseif InKeyName == Const.GamepadFaceButtonLeft then
    IsEventHandled = false
    self:GetBigReward()
  elseif InKeyName == Const.GamepadFaceButtonRight then
    if self.IsFocusBigReward then
      local FocusedTask = self.CurFocusTask or self.NormalItem.List_Task:GetItemAt(0) or self.CycleItem.List_Task:GetItemAt(0)
      if not FocusedTask then
        return
      end
      if FocusedTask.TaskType == TaskType.Cycle then
        self.CycleItem.List_Task:BP_NavigateToItem(FocusedTask)
      else
        self.NormalItem.List_Task:BP_NavigateToItem(FocusedTask)
      end
    else
      IsEventHandled = false
    end
  elseif InKeyName == Const.GamepadLeftShoulder then
    IsEventHandled = false
  elseif InKeyName == Const.GamepadRightShoulder then
    IsEventHandled = false
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

return M
