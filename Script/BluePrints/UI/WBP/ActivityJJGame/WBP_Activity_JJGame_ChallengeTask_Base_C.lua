require("UnLua")
local JJGameModel = require("BluePrints.UI.WBP.ActivityJJGame.JJGameModel")
local JJGameController = require("BluePrints.UI.WBP.ActivityJJGame.JJGameController")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local ChallengeTaskNewReddotName = JJGameModel.ChallengeTaskNewReddotName

function M:Construct()
  self.MidTermConst = DataMgr.MidTermGoalConstant
  self.AchievementRewardPoint = self.MidTermConst.AchievementRewardPoint.ConstantValue
  self.MidTermGoalEventId = self.MidTermConst.MidTermGoalEventId.ConstantValue
  self.AchievementPrize = DataMgr.AchievementPrize
  self.Text_Empty:SetText(GText("UI_Event_MidTerm_End"))
  self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_ChallengePoint"))
  self.Text_TaskScoreToday_Total:SetText(self.MidTermConst.MaxPrizePoint.ConstantValue)
  self.Text_TaskScoreToday_Total:SetText(50)
  self.Btn_OneClickGet.Text_GetReward:SetText(GText("UI_CTL_ClaimALL"))
  self.Btn_OneClickGet.Btn_GetReward.OnClicked:Add(self, self.GetAllTaskScores)
  self.Btn_Score.OnClicked:Add(self, function()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_challenge_btn_click", nil, nil)
    local Params = {
      Count = self.Count,
      Index = self.Index,
      ActivityId = self.MidTermGoalEventId,
      BackFocusWidget = self.List_Challenge,
      OnCloseCallbackFunction = function()
        self.List_Challenge:SetFocus()
      end
    }
    UIManager(self):ShowCommonPopupUI(100101, Params, self)
  end)
  self:InitListenEvent()
  self:RefreshBaseInfo()
  self.List_Challenge:SetScrollBarVisibility(UIConst.VisibilityOp.Hidden)
  self.List_Challenge:SetControlScrollbarInside(true)
  self.CurFocusTask = nil
end

function M:Destruct()
  if self.HasNewTask then
    self:TryClearChallengeTaskNewReddot()
  end
  self.Btn_OneClickGet.Btn_GetReward.OnClicked:Clear()
end

function M:Init(Params)
  self.Params = Params
  self.Owner = Params.Owner
  self.EventDay = Params.EventDay
  self._Avatar = GWorld:GetAvatar()
  local Model = JJGameController:RefreshModel()
  self.MidTermGoals = Model.MidTermGoals
  self.MidTermTask = Model.MidTermTasks
  self.MidTermAchvProgressRewarded = Model.MidTermAchvProgressRewarded
  self.EventEndTime = Model.EventEndTime
  self:InitTaskList()
  self:InitChallengeScoreItem()
  self.ChallengeTaskScore = self:CalChallengeTaskScore()
  self:UpdateChallengeTaskScore(self.ChallengeTaskScore)
  self:PlayAnimation(self.In)
  if Params.RemainDays ~= false then
    self.Text_BottomOneClickTitle:SetText(string.format(GText("UI_Event_MidTerm_NewChallenge"), Params.RemainDays, Params.RemainHours))
  else
    self.Text_BottomOneClickTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if TimeUtils.NowTime() > self.EventEndTime then
    self:ClearChallengeReddot()
    self.WS_Right:SetActiveWidgetIndex(1)
  end
  if CommonUtils.GetDeviceTypeByPlatformName() ~= "Mobile" then
    self.Key_TitleScore:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "X"}
      }
    })
  end
  self.Btn_OneClickGet.Key_GetReward:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self:SetFocus()
end

function M:CalChallengeTaskScore()
  local Model = JJGameController:RefreshModel()
  self.MidTermGoals = Model.MidTermGoals
  return Model.MidTermAchvScores
end

function M:UpdateChallengeTaskScore(TaskScoreToday)
  self.Text_TaskScoreToday:SetText(TaskScoreToday)
  self:UpdateChallengeScoreItem(TaskScoreToday)
end

function M:InitTaskList()
  self:UpdateChallengeTaskList()
  self:UpdateOneClickBtnState()
end

function M:RefreshTaskView()
  if not IsValid(self) then
    return
  end
  local Model = JJGameController:RefreshModel()
  self.MidTermGoals = Model.MidTermGoals
  self.MidTermTask = Model.MidTermTasks
  self.MidTermAchvProgressRewarded = Model.MidTermAchvProgressRewarded
  self.EventEndTime = Model.EventEndTime
  self.EventDay = Model.EventDay
  self:UpdateChallengeTaskList()
  self.ChallengeTaskScore = self:CalChallengeTaskScore()
  self:UpdateChallengeTaskScore(self.ChallengeTaskScore)
  self:UpdateOneClickBtnState()
  if TimeUtils.NowTime() > self.EventEndTime then
    self:ClearChallengeReddot()
    self.WS_Right:SetActiveWidgetIndex(1)
  end
end

function M:UpdateChallengeTaskList()
  self.List_Challenge:ClearListItems()
  local Model = JJGameController:RefreshModel()
  self.MidTermGoals = Model.MidTermGoals
  local Entries = Model:BuildChallengeTaskEntries(self.EventDay)
  self.ChallengeTaskList = {}
  for _, Entry in ipairs(Entries) do
    local TaskItem = self:NewItemContent(Entry.TaskType, Entry.TaskId, Entry.Point, Entry.Desc)
    TaskItem.TaskProp = Entry.TaskProp
    TaskItem.TaskConfig = Entry.TaskConfig
    self.List_Challenge:AddItem(TaskItem)
    table.insert(self.ChallengeTaskList, TaskItem)
  end
  self.List_Challenge:RequestPlayEntriesAnim()
  self.List_Challenge:SetFocus()
  self:TryIncreaceChallengeTaskNewReddot()
end

function M:SortTaskList(TaskList)
  return JJGameController:RefreshModel():GetSortedTaskList(TaskList)
end

function M:TryIncreaceChallengeTaskNewReddot()
  self.HasNewTask = false
  if TimeUtils.NowTime() > self.EventEndTime then
    return
  end
  for _, TaskItem in pairs(self.ChallengeTaskList) do
    JJGameController:TryIncreaseChallengeTaskNewReddot(TaskItem.TaskProp.UniqueID)
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(ChallengeTaskNewReddotName)
    if CacheData and CacheData[TaskItem.TaskProp.UniqueID] == true then
      self.HasNewTask = true
    end
  end
end

function M:TryClearChallengeTaskNewReddot()
  JJGameController:ClearChallengeTaskNewReddot(false)
  self.HasNewTask = false
end

function M:InitChallengeScoreItem()
  local Model = JJGameController:RefreshModel()
  self.MidTermAchvProgressRewarded = Model.MidTermAchvProgressRewarded
  for Count, RewardId in pairs(self.AchievementPrize) do
    local Index = math.floor(Count / 10)
    local Params = {
      Owner = self,
      Count = Count,
      Index = Index,
      RewardId = RewardId,
      CanGet = self.MidTermAchvProgressRewarded[Count] and true or false,
      IsReceived = 1 == self.MidTermAchvProgressRewarded[Count],
      CacheKey = "ChallengeScoreItem" .. Count
    }
    self["ChallengeScoreItem_" .. Index]:Init(Params)
  end
end

function M:TryIncreaceChallengeRewardReddot(Count)
  JJGameController:TryIncreaseChallengeRewardReddot(Count)
end

function M:TrySubChallengeTaskRewardReddot(TaskId)
  JJGameController:TrySubChallengeTaskRewardReddot(TaskId)
end

function M:TrySubChallengeTaskNewReddot(TaskId)
  JJGameController:TrySubChallengeTaskNewReddot(TaskId)
end

function M:UpdateChallengeScoreItem(TaskScoreToday)
  local Model = JJGameController:RefreshModel()
  local MidTermAchvProgressRewarded = Model.MidTermAchvProgressRewarded
  local RewardCanGet = false
  for Count in pairs(self.AchievementPrize) do
    local Index = math.floor(Count / 10)
    local Item = self["ChallengeScoreItem_" .. Index]
    if Count <= TaskScoreToday then
      if 1 == MidTermAchvProgressRewarded[Count] then
        Item:StopAnimation(Item.Reward)
        Item:PlayAnimation(Item.Recived)
      else
        Item:StopAnimation(Item.Forbidden)
        Item:PlayAnimation(Item.In_Reward)
        Item:PlayAnimation(Item.Reward, 0, 0)
        Item.CanGet = true
        RewardCanGet = true
        self:TryIncreaceChallengeRewardReddot(Count)
      end
    else
      Item:PlayAnimation(Item.Forbidden)
    end
  end
  self.RewardCanGet = RewardCanGet
  if self.RewardCanGet then
    if self.CurInputDevice == ECommonInputType.Gamepad then
      self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_GetPrize"))
    end
  elseif self.CurInputDevice == ECommonInputType.Gamepad then
    self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_GotoPreview"))
  end
end

function M:UpdateOneClickBtnState()
  if not (IsValid(self) and self.Btn_OneClickGet) or not IsValid(self.Btn_OneClickGet) then
    return
  end
  if not self.Btn_OneClickGet.Btn_GetReward or not self.Btn_OneClickGet.Key_GetReward then
    return
  end
  local canReceive = JJGameController:CanReceiveAnyChallengeTask(self.ChallengeTaskList, self.EventEndTime)
  local CloseCallback = not self.CloseSelf and self.Owner and self.Owner.CloseSelf
  local CloseOwner = self.CloseSelf and self or self.Owner
  if canReceive then
    self.Btn_OneClickGet.Btn_GetReward:SetForbidden(false)
    self.Btn_OneClickGet.Key_GetReward:SetForbidKey(false)
  else
    self.Btn_OneClickGet.Btn_GetReward:SetForbidden(true)
    self.Btn_OneClickGet.Key_GetReward:SetForbidKey(true)
  end
  local ComTab = self.Owner and self.Owner.Com_Tab
  if ComTab and not IsValid(ComTab) then
    ComTab = nil
  end
  JJGameController:UpdateClaimAllBottomKey(ComTab, canReceive, self.GetAllTaskScores, CloseCallback, CloseOwner)
  self.canReceive = canReceive
end

function M:GetAllTaskScores()
  if TimeUtils.NowTime() > self.EventEndTime then
    return
  end
  if self.Btn_OneClickGet.Btn_GetReward:GetForbidden() then
    return
  end
  local Avatar = GWorld:GetAvatar()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_all_btn_click", nil, nil)
  
  local function Cb(ErrCode, Ret)
    DebugPrint("GetAllChallengeTaskScores", ErrorCode:Name(ErrCode))
    if ErrCode == ErrorCode.RET_SUCCESS then
      self:UpdateChallengeTaskList()
      self.ChallengeTaskScore = self:CalChallengeTaskScore()
      self:UpdateChallengeTaskScore(self.ChallengeTaskScore)
      self:UpdateOneClickBtnState()
      self:TryClearChallengeTaskNewReddot()
      if self.ChallengeTaskList then
        for _, TaskItem in pairs(self.ChallengeTaskList) do
          if TaskItem.TaskProp and TaskItem.TaskProp.RewardsGot then
            self:TrySubChallengeTaskRewardReddot(TaskItem.TaskProp.UniqueID)
          end
        end
      end
      self:PlayAnimation(self.Up)
      AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_challenge_score_add", nil, nil)
    end
    self.Owner:BlockAllUIInput(false)
  end
  
  self.Owner:BlockAllUIInput(true)
  Avatar:MidTermGetAllAchvScores(Cb)
end

function M:NewItemContent(TaskType, TaskId, TaskPoint, TaskDes)
  local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
  ItemContent.Owner = self
  ItemContent.TaskType = TaskType
  ItemContent.TaskId = TaskId
  ItemContent.Point = TaskPoint
  ItemContent.Desc = TaskDes
  return ItemContent
end

function M:OnAchvFinished(TaskId)
  if not IsValid(self) then
    return
  end
  if not self.ChallengeTaskList then
    return
  end
  for _, TaskItem in pairs(self.ChallengeTaskList) do
    if TaskItem.SelfWidget and IsValid(TaskItem.SelfWidget) and TaskItem.SelfWidget.OnAchvFinished then
      TaskItem.SelfWidget:OnAchvFinished(TaskId)
    end
  end
  self:UpdateOneClickBtnState()
end

function M:OnMidTermTaskProgressChange(TaskId, Progress)
  if not IsValid(self) then
    return
  end
  if not self.ChallengeTaskList then
    return
  end
  for _, TaskItem in pairs(self.ChallengeTaskList) do
    if TaskItem.SelfWidget and IsValid(TaskItem.SelfWidget) and TaskItem.SelfWidget.OnMidTermTaskProgressChange then
      TaskItem.SelfWidget:OnMidTermTaskProgressChange(TaskId, Progress)
    end
  end
end

function M:OnTaskGet(Item)
  if not IsValid(self) then
    return
  end
  Item.WS_Btn:SetActiveWidgetIndex(3)
  Item:PlayAnimation(Item.In_Got)
  Item.Content.CanGet = false
  Item.Content.TaskProp.RewardsGot = true
  self.ChallengeTaskScore = self:CalChallengeTaskScore()
  self:TrySubChallengeTaskRewardReddot(Item.TaskProp.UniqueID)
  self:TrySubChallengeTaskNewReddot(Item.TaskProp.UniqueID)
  Item.New:SetVisibility(UIConst.VisibilityOp.Hidden)
  self:UpdateChallengeTaskScore(self.ChallengeTaskScore)
  self:UpdateOneClickBtnState()
  self:AddTimer(0.1, function()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/wenmingboyi_challenge_score_add", nil, nil)
    self:PlayAnimation(self.Up)
  end)
end

function M:OnChallengeRewardGet()
  local Avatar = GWorld:GetAvatar()
  
  local function Callback(ErrCode, Ret)
    if ErrCode == ErrorCode.RET_SUCCESS then
      UIManager(GWorld.GameInstance):LoadUI(UIConst.LoadInConfig, "GetItemPage", nil, nil, nil, nil, Ret, function()
        self:AddTimer(0.1, function()
          local FocusedTask = self.CurFocusTask or self.List_Challenge:GetItemAt(0)
          self.List_Challenge:BP_NavigateToItem(FocusedTask)
        end)
      end)
      self:UpdateChallengeScoreItem(self:CalChallengeTaskScore())
      self:ClearChallengeRewardReddot()
    else
      local Params = {
        Count = self.Count,
        Index = self.Index,
        ActivityId = self.MidTermGoalEventId,
        BackFocusWidget = self.List_Challenge,
        OnCloseCallbackFunction = function()
          self:AddTimer(0.1, function()
            local FocusedTask = self.CurFocusTask or self.List_Challenge:GetItemAt(0)
            self.List_Challenge:BP_NavigateToItem(FocusedTask)
          end)
        end
      }
      UIManager(self):ShowCommonPopupUI(100101, Params, self)
    end
    self.Owner:BlockAllUIInput(false)
  end
  
  self.Owner:BlockAllUIInput(true)
  Avatar:MidTermGetProgressReward(Callback)
end

function M:ClearChallengeReddot()
  JJGameController:ClearChallengeRewardReddot()
end

function M:ClearChallengeRewardReddot()
  JJGameController:ClearUnlockedChallengeScoreRewardReddot()
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
    if CommonUtils.GetDeviceTypeByPlatformName() ~= "Mobile" then
      self.Key_TitleScore:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.RewardCanGet then
      self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_GetPrize"))
    else
      self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_GotoPreview"))
    end
    self.Btn_OneClickGet.Key_GetReward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    if CommonUtils.GetDeviceTypeByPlatformName() ~= "Mobile" then
      self.Key_TitleScore:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Text_TaskScoreTodayTitle:SetText(GText("UI_Event_MidTerm_ChallengePoint"))
    self.Btn_OneClickGet.Key_GetReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.CurInputDevice = CurInputDevice
end

function M:InitNavigationRules()
  self.List_Challenge:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Challenge:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
end

function M:BP_GetDesiredFocusTarget()
  if not IsValid(self) then
    return nil
  end
  if self.CurFocusTask ~= nil and self.CurFocusTask.SelfWidget and IsValid(self.CurFocusTask.SelfWidget) then
    return self.CurFocusTask.SelfWidget
  end
  local FirstItem = IsValid(self.List_Challenge) and self.List_Challenge:GetItemAt(0) or nil
  if FirstItem and FirstItem.SelfWidget and IsValid(FirstItem.SelfWidget) then
    return FirstItem.SelfWidget
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
  elseif "SpaceBar" == InKeyName then
    self:GetAllTaskScores()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = true
  if InKeyName == Const.GamepadFaceButtonLeft then
    self:OnChallengeRewardGet()
  elseif InKeyName == Const.GamepadFaceButtonUp then
    self:GetAllTaskScores()
  elseif InKeyName == Const.GamepadFaceButtonRight then
    IsEventHandled = false
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
