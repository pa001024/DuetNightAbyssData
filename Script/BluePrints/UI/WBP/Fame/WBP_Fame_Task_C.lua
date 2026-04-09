require("UnLua")
local RegionFameController = require("BluePrints.UI.WBP.Fame.RegionFameController")
local RegionFameModel = RegionFameController:GetModel()
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local FameTaskType = {RecurringTask = 1, ReputationEntrust = 2}
local RecurringTaskNum = 3

function M:Construct()
  EventManager:AddEvent(EventID.GetReputationExp, self, self.OnGetReputationExp)
  EventManager:AddEvent(EventID.RecurringQuestTimeOut, self, self.OnRecurringQuestTimeOut)
  ReddotManager.AddListenerEx("RecurringFameTask", self, self.OnRecurringFameTaskReddotChange)
  ReddotManager.AddListenerEx("EntrustFameTask", self, self.OnEntrustFameTaskReddotChange)
end

function M:Destruct()
  DebugPrint("WYX WBP_Fame_Task_C Destruct !!!")
  RegionFameModel:ClearOriginalModsData()
  EventManager:RemoveEvent(EventID.GetReputationExp, self, self.OnGetReputationExp)
  EventManager:RemoveEvent(EventID.RecurringQuestTimeOut, self, self.OnRecurringQuestTimeOut)
  self:RemoveTimer("UpdateRefreshRemainingTime", true)
  self.List_Item_1:ClearListItems()
end

function M:OnLoaded(...)
  local CurRegionTabId, CurTaskTabId = ...
  rawset(self, "CurRegionTabId", CurRegionTabId and tonumber(CurRegionTabId) or 1001)
  rawset(self, "CurTaskTabId", CurTaskTabId and tonumber(CurTaskTabId) or FameTaskType.RecurringTask)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  rawset(self, "GameInputModeSubsystem", GameInputModeSubsystem)
  self:InitWeeklyDetail()
  self:InitFameDetail()
  self:InitRegionTab()
  self:InitTaskTab()
  self:UpdateRefreshDetail()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "FameTaskIn", nil)
end

function M:InitRegionTab()
  self:InitRegionTabInfo()
  self.Com_Tab:Init({
    LeftKey = "Q",
    RightKe = "E",
    Tabs = self.AllRegionTabInfo,
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    StyleName = "Text",
    TitleName = GText("RegionReputation_TaskTitle"),
    OwnerPanel = self,
    BackCallback = self.CloseSelf,
    LastFocusWidget = self.List_Item_1
  })
  self.Com_Tab:BindEventOnTabSelected(self, self.OnRegionTabItemClick)
  self:AddDelayFrameFunc(function()
    self.Com_Tab:SelectTabById(self.CurRegionTabId)
  end, 1, "FillWithRegionInfo")
end

function M:InitTaskTab()
  self:InitTaskTabInfo()
  self.Fame_Tab:Init({
    LeftKey = "A",
    RightKe = "D",
    Tabs = self.AllTaskTabInfo,
    ChildWidgetName = "ModArchiveTabSubItem"
  })
  self.Fame_Tab:BindEventOnTabSelected(self, self.OnTaskTabItemClick)
  self:AddDelayFrameFunc(function()
    self.Fame_Tab:SelectTab(self.CurTaskTabId)
  end, 1, "FillWithTaskInfo")
end

function M:InitRegionTabInfo()
  local AllRegionTabInfo = {}
  for RegionId, TabData in pairs(DataMgr.RegionReputation) do
    local Locked = not RegionFameModel:CheckTabCondition(TabData.Condition)
    local LockToast = TabData.LockToast
    local bHasCanClaim = false
    local AllCanClaimTasks = RegionFameModel:GetTargetRegionAllCanClaimRecurringTasks(RegionId)
    if AllCanClaimTasks and #AllCanClaimTasks > 0 then
      bHasCanClaim = true
    end
    if not bHasCanClaim then
      local CanSubmitEntrustTask = RegionFameModel:GetTargetRegionEntrustTaskCanSubmit(RegionId)
      if CanSubmitEntrustTask then
        bHasCanClaim = true
      end
    end
    local TabName = GText(TabData.RegionName)
    table.insert(AllRegionTabInfo, {
      Text = TabName,
      IconPath = TabData.RegionIconPath,
      TabId = RegionId,
      ShowRedDot = bHasCanClaim,
      IsLocked = Locked,
      LockReasonText = LockToast
    })
  end
  rawset(self, "AllRegionTabInfo", AllRegionTabInfo)
end

function M:InitTaskTabInfo()
  local AllTaskTabInfo = {}
  table.insert(AllTaskTabInfo, {
    Text = GText("RecurringTask_Title"),
    TabId = FameTaskType.RecurringTask
  })
  table.insert(AllTaskTabInfo, {
    Text = GText("ReputationEntrust_Title"),
    TabId = FameTaskType.ReputationEntrust
  })
  rawset(self, "AllTaskTabInfo", AllTaskTabInfo)
end

function M:OnRegionTabItemClick(TabWidget)
  local NewTabId = TabWidget:GetTabId()
  local OldTabId = self.CurRegionTabId
  local NewData = DataMgr.RegionReputation[NewTabId]
  if not NewData then
    return
  end
  if not self:CheckDungeonCondition(NewData.Condition) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(NewData.LockToast))
    local FallbackId = OldTabId or self.AllRegionTabInfo[1] and self.AllRegionTabInfo[1].TabId
    if FallbackId and FallbackId ~= NewTabId then
      self.Com_Tab:SelectTabById(FallbackId)
    end
    return
  end
  rawset(self, "CurRegionTabId", NewTabId)
  rawset(self, "CurRecurringTaskLevel", nil)
  self:InitWeeklyDetail()
  self:InitFameDetail()
  self:UpdateRefreshDetail()
  self:UpdateRecurringTaskReddot()
  self:UpdateEntrustTaskReddot()
  self:UpdateBackground()
  self.Fame_Tab:SelectTab(self.CurTaskTabId)
  self:SetFocus()
end

function M:OnTaskTabItemClick(TabWidget)
  local TabId = TabWidget:GetTabId()
  rawset(self, "CurTaskTabId", TabId)
  if 1 == TabId then
    self.SelectedEntrustTask = nil
    self:RefreshRecurringTask()
  else
    self.SelectedRecurringTask = nil
    self:RefreshEntrustTask()
  end
  local SwitcherIdx = 1 == TabId and 1 or 0
  self.Switcher:SetActiveWidgetIndex(SwitcherIdx)
  self:UpdateTopResource()
  self:UpdateRefreshDetail()
  self:SetFocus()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
end

function M:OnMenuOpenChanged(IsOpen)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if IsOpen then
    self.Com_Tab:UpdateBottomKeyInfo({
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        }
      }
    })
  else
    local NewBottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    if self.CanQuickClaimIndex and self.CanQuickClaimIndex > 0 then
      table.insert(NewBottomKeyInfo, 1, {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Space",
            ClickCallback = self.QuickClaimCurrentRecurringTask,
            Owner = self
          }
        },
        Desc = GText("UI_BattlePass_QuestRewardClaim")
      })
    end
    self.Com_Tab:UpdateBottomKeyInfo(NewBottomKeyInfo)
  end
end

function M:UpdateTopResource()
  if self.CurTaskTabId == FameTaskType.ReputationEntrust then
    local RegionReputationData = DataMgr.RegionReputation[self.CurRegionTabId]
    if not RegionReputationData then
      return
    end
    local ManualRefreshId = RegionReputationData.ManualRefreshId
    self.Com_Tab:OverrideTopResource({ManualRefreshId}, true)
  else
    self.Com_Tab:OverrideTopResource({}, true)
  end
end

function M:InitWeeklyDetail()
  local FameData = DataMgr.RegionReputation
  if not FameData then
    return
  end
  local RegionData = FameData[self.CurRegionTabId]
  if not RegionData then
    return
  end
  self.Fame_UpperLimit.TextLimit:SetText(GText("ReputationExp_WeekLimit"))
  local WeeklyFame = RegionFameModel:GetRegionWeeklyFame(self.CurRegionTabId)
  if not WeeklyFame then
    return
  end
  self.Fame_UpperLimit.TextNow:SetText(WeeklyFame)
  local MaxWeeklyFame = RegionData.WeekLimit
  self.Fame_UpperLimit.TextTotal:SetText(string.format("/%d", MaxWeeklyFame))
end

function M:InitFameDetail(bNotUpdateProgress)
  local FameData = DataMgr.ReputationLevel
  if not FameData then
    return
  end
  local RegionData = FameData[self.CurRegionTabId]
  if not RegionData then
    return
  end
  local Content = {}
  local FameLevel = RegionFameModel:GetRegionFameLevel(self.CurRegionTabId)
  if not FameLevel then
    return
  end
  Content.FameLevel = FameLevel
  Content.CurrentFameValue = RegionFameModel:GetRegionFameValue(self.CurRegionTabId)
  Content.bMaxLevel = Content.FameLevel >= #RegionData
  if not Content.bMaxLevel then
    Content.MaxFameValue = RegionData[Content.FameLevel + 1].ReputationLevelMaxExp
  end
  Content.bNotUpdateProgress = bNotUpdateProgress
  self.Fame_Progress:Init(Content)
end

function M:UpdateRefreshDetail()
  local EntrustTaskRefreshTimestamp = RegionFameModel:GetEntrustTaskRefreshTime(self.CurRegionTabId)
  if not EntrustTaskRefreshTimestamp then
    return
  end
  local RecurringTaskRefreshTimestamp = RegionFameModel:GetRecurringTaskRefreshTime(self.CurRegionTabId)
  rawset(self, "EntrustTaskRefreshTimestamp", EntrustTaskRefreshTimestamp)
  rawset(self, "RecurringTaskRefreshTimestamp", RecurringTaskRefreshTimestamp)
  self.Text_Time:SetText(GText("RegionReputation_RefreshTime01"))
  self:AddTimer(0.01, function()
    self:UpdateRefreshRemainingTime()
  end)
  self:AddTimer(1, self.UpdateRefreshRemainingTime, true, 0, "UpdateRefreshRemainingTime", true)
end

function M:UpdateRefreshRemainingTime()
  local RemainingRefreshTime
  if 1 == self.CurTaskTabId then
    RemainingRefreshTime = self.RecurringTaskRefreshTimestamp
  else
    RemainingRefreshTime = self.EntrustTaskRefreshTimestamp
  end
  if RemainingRefreshTime then
    local RemainingTimeText = UIUtils.GetRemainingTimeByTimestamp(RemainingRefreshTime)
    if "" == RemainingTimeText then
      self:InitWeeklyDetail()
      self:InitFameDetail()
      self:UpdateRefreshDetail()
      if 1 == self.CurTaskTabId then
        self:RefreshRecurringTask()
      else
        self:RefreshEntrustTask()
      end
    end
    self.Text_Time_Num:SetText(RemainingTimeText)
  end
end

function M:UpdateRefreshBtnDetail()
  local RegionReputationData = DataMgr.RegionReputation[self.CurRegionTabId]
  if not RegionReputationData then
    return
  end
  local Content = {}
  Content.Type = RegionReputationData.ManualRefreshType
  Content.Id = RegionReputationData.ManualRefreshId
  Content.Expend = RegionReputationData.ManualRefreshCount
  Content.MaxRefreshCount = RegionReputationData.ManualRefreshNumber
  Content.AlreadyRefreshCount = RegionFameModel:GetAlreadyRefreshEntrustTaskCount(self.CurRegionTabId)
  Content.Parent = self
  Content.RefreshClickedCallBack = self.OnRefreshClickedCallBack
  self.WBP_Fame_BtnRefresh:Init(Content)
end

function M:UpdateBackground()
  local RegionReputationData = DataMgr.RegionReputation[self.CurRegionTabId]
  if not RegionReputationData then
    return
  end
  local BgPath = RegionReputationData.RegionUIBG
  local BgWidget = UIManager(self):CreateWidget(BgPath)
  if BgWidget then
    self.Bg0:ClearChildren()
    self.Bg0:AddChild(BgWidget)
    if BgWidget.Loop then
      BgWidget:PlayAnimation(BgWidget.Loop, 0, 0)
    end
    if BgWidget.In then
      BgWidget:PlayAnimation(BgWidget.In)
    end
  else
    DebugPrint("SL RegionTabUIBG Create Failed")
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  rawset(self, "CurInputDeviceType", CurInputDevice)
  rawset(self, "CurGamepadName", CurGamepadName)
  self:UpdateUIStyleInPlatform(CurInputDevice, CurGamepadName)
end

function M:UpdateUIStyleInPlatform(CurInputDevice, CurGamepadName)
  if self.CurTaskTabId == FameTaskType.RecurringTask then
    for i = 1, RecurringTaskNum do
      self["WBP_Fame_PopupTask0" .. i]:UpdateGamePadStyle()
    end
  else
    local AllItemCount = self.List_Item_1:GetNumItems()
    for i = 0, AllItemCount - 1 do
      local Item = self.List_Item_1:GetItemAt(i)
      if IsValid(Item) and Item.SelfWidget then
        Item.SelfWidget:UpdateGamePadStyle()
      end
    end
  end
  self:SetFocus()
  self.WBP_Fame_BtnRefresh:UpdateGamePadStyle()
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:ClearListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:OnRecurringFameTaskReddotChange()
  local AllRegionReputationData = DataMgr.RegionReputation
  if not AllRegionReputationData then
    return
  end
  local TreeNode = ReddotManager.GetTreeNode("RecurringFameTask")
  local HaveReddot = false
  if TreeNode and TreeNode.Count > 0 then
    HaveReddot = true
  end
  if not HaveReddot then
    if self.Fame_Tab.ConfigData then
      self.Fame_Tab:ShowTabRedDotByTabId(FameTaskType.RecurringTask)
    end
    for i = 1, RecurringTaskNum do
      self["WBP_Fame_TaskLevel_" .. i]:ShowRedDot(false)
    end
    self:UpdateRegionTabReddot()
    return
  end
  for RegionId, _ in pairs(AllRegionReputationData) do
    local bHasCanClaim = false
    local AllCanClaimTasks = RegionFameModel:GetTargetRegionAllCanClaimRecurringTasks(RegionId)
    if AllCanClaimTasks and #AllCanClaimTasks > 0 then
      bHasCanClaim = true
      if RegionId == self.CurRegionTabId then
        self:UpdateRecurringTaskReddot()
        self:RefreshRecurringTask()
      end
    end
  end
  self:UpdateRegionTabReddot()
end

function M:OnEntrustFameTaskReddotChange()
  local AllRegionReputationData = DataMgr.RegionReputation
  if not AllRegionReputationData then
    return
  end
  local TreeNode = ReddotManager.GetTreeNode("EntrustFameTask")
  local HaveReddot = false
  if TreeNode and TreeNode.Count > 0 then
    HaveReddot = true
  end
  if not HaveReddot then
    if self.Fame_Tab.ConfigData then
      self.Fame_Tab:ShowTabRedDotByTabId(FameTaskType.ReputationEntrust)
    end
    self:UpdateRegionTabReddot()
    return
  end
  if self.CurRegionTabId then
    local CanSubmitEntrustTask = RegionFameModel:GetTargetRegionEntrustTaskCanSubmit(self.CurRegionTabId)
    if CanSubmitEntrustTask then
      self:UpdateEntrustTaskReddot()
      if self.CurTaskTabId == FameTaskType.ReputationEntrust then
        self:RefreshEntrustTask()
      end
    end
  end
  self:UpdateRegionTabReddot()
end

function M:UpdateRegionTabReddot()
  local AllRegionReputationData = DataMgr.RegionReputation
  if not AllRegionReputationData then
    return
  end
  for RegionId, _ in pairs(AllRegionReputationData) do
    local bHasReddot = false
    local AllCanClaimTasks = RegionFameModel:GetTargetRegionAllCanClaimRecurringTasks(RegionId)
    if AllCanClaimTasks and #AllCanClaimTasks > 0 then
      bHasReddot = true
    end
    if not bHasReddot then
      local CanSubmitEntrustTask = RegionFameModel:GetTargetRegionEntrustTaskCanSubmit(RegionId)
      if CanSubmitEntrustTask then
        bHasReddot = true
      end
    end
    self.Com_Tab:ShowTabRedDotByTabId(RegionId, false, bHasReddot, false)
  end
end

function M:OnGetReputationExp(ReputationExpAddInfo)
  self.Fame_Progress:UpdateReputationExp(ReputationExpAddInfo)
  self:InitFameDetail(true)
end

function M:OnRecurringQuestTimeOut(RegionId)
  if RegionId == self.CurRegionTabId and self.CurTaskTabId == FameTaskType.RecurringTask then
    self:RefreshRecurringTask()
  end
end

function M:OnRefreshClickedCallBack()
  DebugPrint("WYX OnRefreshClickedCallBack")
  if self.CurRegionState ~= CommonConst.RegionFameState.Normal then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local function CallBack(Ret)
      if Ret == ErrorCode.RET_SUCCESS then
        self:RefreshEntrustTask()
        
        self:UpdateEntrustTaskReddot()
        self:UpdateRegionTabReddot()
        return
      end
      local Error = DataMgr.ErrorCode[Ret]
      if nil ~= Error then
        UIManager(self):ShowError(Ret, 1.5)
      else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format("ErrorCode :%d", Ret))
      end
    end
    
    Avatar:ManualRefreshEntrustQuest(self.CurRegionTabId, CallBack)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
end

function M:UpdateRecurringTaskReddot()
  local bHasCanClaim = false
  local AllCanClaimTasks = RegionFameModel:GetTargetRegionAllCanClaimRecurringTasks(self.CurRegionTabId)
  if AllCanClaimTasks and #AllCanClaimTasks > 0 then
    bHasCanClaim = true
  end
  self.Fame_Tab:ShowTabRedDotByTabId(FameTaskType.RecurringTask, false, bHasCanClaim, false)
  for i = 1, RecurringTaskNum do
    self["WBP_Fame_TaskLevel_" .. i]:ShowRedDot(false)
  end
  for _, TaskInfo in ipairs(AllCanClaimTasks) do
    local TaskLevel = TaskInfo.Level
    if TaskLevel and self["WBP_Fame_TaskLevel_" .. TaskLevel] then
      self["WBP_Fame_TaskLevel_" .. TaskLevel]:ShowRedDot(true)
    end
  end
end

function M:UpdateEntrustTaskReddot()
  local bHasCanClaim = false
  bHasCanClaim = RegionFameModel:GetTargetRegionEntrustTaskCanSubmit(self.CurRegionTabId)
  self.Fame_Tab:ShowTabRedDotByTabId(FameTaskType.ReputationEntrust, false, bHasCanClaim, false)
end

function M:RefreshRecurringTask()
  local MaxTaskLevel = RegionFameModel:GetCurrentRecurringTaskLevel(self.CurRegionTabId)
  rawset(self, "CurRecurringTaskLevel", rawget(self, "CurRecurringTaskLevel") or math.min(MaxTaskLevel, RecurringTaskNum))
  rawset(self, "MaxRecurringTaskLevel", MaxTaskLevel)
  for i = 1, RecurringTaskNum do
    local Content = {}
    Content.TaskLevel = i
    Content.TaskName = GText("RecurringTask_Rarity" .. i)
    Content.CurrentTaskLevel = self.CurRecurringTaskLevel
    Content.MaxTaskLevel = self.MaxRecurringTaskLevel
    Content.Parent = self
    Content.BtnClickedCallBack = self.OnRecurringTaskBtnClickedCallBack
    self["WBP_Fame_TaskLevel_" .. i]:Init(Content)
  end
  self:RefreshRecurringTaskDetail()
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Tab_Change)
  self:RefreshMaskVisibility()
  self:SetFocus()
end

function M:CheckDungeonCondition(Condition)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  if not Condition then
    return true
  end
  if ConditionUtils.CheckCondition(Avatar, Condition) == false then
    return false
  end
  return true
end

function M:RefreshMaskVisibility()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local State = RegionFameModel:GetRegionState(self.CurRegionTabId, self.CurTaskTabId == FameTaskType.RecurringTask)
  rawset(self, "CurRegionState", State)
  if State ~= CommonConst.RegionFameState.Normal then
    local MaskText = ""
    if State == CommonConst.RegionFameState.MaxLevel then
      MaskText = GText("Reputation_MaxLevel_01")
    elseif State == CommonConst.RegionFameState.WeeklyFameLimit then
      MaskText = GText("ReputationExp_AchievedWeekLimit")
    elseif State == CommonConst.RegionFameState.DoingOtherRegionFameTask then
      local DoingTaskRegionId = Avatar:GetCurrentDoingRecurringQuestId()
      local RegionReputationData = DataMgr.RegionReputation[DoingTaskRegionId]
      if not RegionReputationData then
        return
      end
      local DoingRegionName = GText(RegionReputationData.RegionName)
      MaskText = string.format(GText("RecurringTask_Occupied"), DoingRegionName)
    end
    self.EMRichTextBlock:SetText(MaskText)
    self.EMRichTextBlock_66:SetText(MaskText)
    self.Group_TaskMask:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Group_Mask:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self.Group_TaskMask:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Group_Mask:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:NeedShowMask()
  local State = RegionFameModel:GetRegionState(self.CurRegionTabId, self.CurTaskTabId == FameTaskType.RecurringTask)
  rawset(self, "CurRegionState", State)
  if State ~= CommonConst.RegionFameState.Normal then
    return true
  end
  return false
end

function M:RefreshRecurringTaskDetail()
  local AllRecurringTasks = RegionFameModel:GetRecurringTasks(self.CurRegionTabId)
  local _, CurrentDoingRecurringTask = RegionFameModel:GetCurrentRecurringTaskLevel(self.CurRegionTabId)
  local ReceiveTaskTimestamp = RegionFameModel:GetCurrentRecurringTaskTimestamp()
  rawset(self, "AllRecurringTasks", AllRecurringTasks)
  rawset(self, "ReceiveTaskTimestamp", ReceiveTaskTimestamp)
  rawset(self, "CurrentDoingRecurringTask", CurrentDoingRecurringTask)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if #self.AllRecurringTasks < 9 then
    ScreenPrint(string.format("从服务器获取的当前区域：%s 的副本任务数量不对，请联系WYX 进行检查", self.CurRegionTabId))
    return
  end
  rawset(self, "CanQuickClaimIndex", -1)
  local AllTaskStates = {}
  local HasCanClaimTask = false
  for i = 1, RecurringTaskNum do
    local TaskLevel = math.min(self.CurRecurringTaskLevel, RecurringTaskNum)
    local index = (TaskLevel - 1) * 3 + i
    local TaskId = self.AllRecurringTasks[index].QuestId
    local TaskState = RegionFameModel:GetTargetRecurringTaskStat(self.CurRegionTabId, TaskId)
    AllTaskStates[i] = TaskState
    if TaskState == CommonConst.RecurringTaskState.CanClaim then
      HasCanClaimTask = true
      rawset(self, "CanQuickClaimIndex", i)
    end
  end
  for i = 1, RecurringTaskNum do
    local Content = {}
    local TaskLevel = math.min(self.CurRecurringTaskLevel, RecurringTaskNum)
    local index = (TaskLevel - 1) * 3 + i
    Content.RegionId = self.CurRegionTabId
    Content.MaxLevel = self.MaxRecurringTaskLevel
    Content.CurrentLevel = self.CurRecurringTaskLevel
    Content.DoingTaskId = self.CurrentDoingRecurringTask
    Content.TaskId = self.AllRecurringTasks[index].QuestId
    Content.DoingTaskTimestamp = self.ReceiveTaskTimestamp
    Content.OnMenuOpenChanged = self.OnMenuOpenChanged
    Content.Parent = self
    Content.TaskState = AllTaskStates[i]
    Content.HasCanClaimTask = HasCanClaimTask
    
    function Content.AbandonRecurringTaskCallback(Ret, ReputationId, QuestId)
      if Ret == ErrorCode.RET_SUCCESS then
        self:RefreshRecurringTaskDetail()
        self:AddTimer(0.25, function()
          self:SetFocus()
        end)
        return
      end
      local Error = DataMgr.ErrorCode[Ret]
      if nil ~= Error then
        UIManager(self):ShowError(Ret, 1.5)
      else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format("ErrorCode :%d", Ret))
      end
    end
    
    function Content.GetRecurringTaskRewardCallback(Ret, ReputationId, QuestId)
      if Ret == ErrorCode.RET_SUCCESS then
        self:RefreshRecurringTask()
        self:InitWeeklyDetail()
        return
      end
      local Error = DataMgr.ErrorCode[Ret]
      if nil ~= Error then
        UIManager(self):ShowError(Ret, 1.5)
      else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format("ErrorCode :%d", Ret))
      end
    end
    
    self["WBP_Fame_PopupTask0" .. i]:Init(Content)
  end
  self:UpdateQuickClaimButtomTip()
end

function M:UpdateQuickClaimButtomTip()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  local NewBottomKeyInfo = {
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = self
        }
      },
      Desc = GText("UI_Tips_Ensure")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.CloseSelf,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.CloseSelf,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  if self.CanQuickClaimIndex and self.CanQuickClaimIndex > 0 then
    table.insert(NewBottomKeyInfo, 1, {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Space",
          ClickCallback = self.QuickClaimCurrentRecurringTask,
          Owner = self
        }
      },
      Desc = GText("UI_BattlePass_QuestRewardClaim")
    })
  end
  self.Com_Tab:UpdateBottomKeyInfo(NewBottomKeyInfo)
end

function M:QuickClaimCurrentRecurringTask()
  if self.CanQuickClaimIndex and self.CanQuickClaimIndex > 0 then
    local TargetWidget = self["WBP_Fame_PopupTask0" .. self.CanQuickClaimIndex]
    if IsValid(TargetWidget) then
      TargetWidget:OnRewardBtnClicked()
    end
  end
end

function M:SetFocusRecurringTask(TargetRecurringTaskWidget)
  TargetRecurringTaskWidget:SetFocus()
  rawset(self, "SelectedRecurringTask", TargetRecurringTaskWidget)
end

function M:OnRecurringTaskBtnClickedCallBack(TaskLevel)
  if self.CurRecurringTaskLevel == TaskLevel then
    self:SetFocusRecurringTask(self.WBP_Fame_PopupTask01)
    return
  end
  self.CurRecurringTaskLevel = TaskLevel
  for i = 1, RecurringTaskNum do
    self["WBP_Fame_TaskLevel_" .. i]:RefreshState(self.CurRecurringTaskLevel)
  end
  self:RefreshRecurringTaskDetail()
end

function M:RefreshEntrustTask()
  self.List_Item_1:ClearListItems()
  local EntrustTasks = RegionFameModel:GetEntrustTasks(self.CurRegionTabId)
  for index, Task in ipairs(EntrustTasks) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local TaskInfo = Task.TaskInfo
    Content.TaskID = TaskInfo.TaskID
    Content.Index = index
    Content.TaskState = TaskInfo.TaskState
    Content.TaskRegionID = TaskInfo.TaskRegionID
    Content.TaskNPCIcon = TaskInfo.TaskNPCIcon
    Content.TaskTitle = TaskInfo.TaskTitle
    Content.TaskContent = TaskInfo.TaskContent
    Content.TaskReward = TaskInfo.TaskReward
    Content.TaskSubmissions = TaskInfo.TaskSubmissions
    Content.NPCName = TaskInfo.NPCName
    Content.OnMenuOpenChanged = self.OnMenuOpenChanged
    
    function Content.SubmitTaskCallback(Ret, ReputationId, QuestId)
      if Ret == ErrorCode.RET_SUCCESS then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("ReputationEntrust_Submit_Tips"))
        self:ConsumeTargetQuestMod(QuestId)
        self:RefreshEntrustTask()
        self:InitWeeklyDetail()
        self:UpdateEntrustTaskReddot()
        return
      end
      local Error = DataMgr.ErrorCode[Ret]
      if nil ~= Error then
        UIManager(self):ShowError(Ret, 1.5)
      else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format("ErrorCode :%d", Ret))
      end
    end
    
    Content.TaskModel = RegionFameModel
    Content.Parent = self
    self.List_Item_1:AddItem(Content)
  end
  self:UpdateRefreshBtnDetail()
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Tab_Change_Back)
  self:RefreshMaskVisibility()
  self:SetFocus()
end

function M:ConsumeTargetQuestMod(QuestId)
  local QuestData = DataMgr.ReputationEntrust[QuestId]
  if not QuestData then
    return
  end
  local ModIndex = 0
  for Index, Type in ipairs(QuestData.Type) do
    if "Mod" == Type then
      ModIndex = Index
    end
  end
  if 0 == ModIndex then
    return
  end
  local ModId = QuestData.Id[ModIndex]
  local ModCount = QuestData.Count[ModIndex]
  RegionFameModel:ConsumeMod(ModId, ModCount)
end

function M:CloseSelf()
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:PlayAnimation(self.Out)
  self:BeginAnimOutToExitWithInStack(true)
  AudioManager(self):SetEventSoundParam(self, "FameTaskIn", {ToEnd = 1})
end

function M:Close()
  self.Super.Close(self)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:BlockAllUIInput(true, "SP_DisplayOnly")
    self:Close()
  elseif InAnimation == self.In then
  end
end

function M:SetFocus()
  if self:NeedShowMask() then
    self.Overridden.SetFocus(self)
    return
  end
  if self.CurTaskTabId == FameTaskType.RecurringTask then
    if self.CurRecurringTaskLevel then
      self["WBP_Fame_TaskLevel_" .. self.CurRecurringTaskLevel].Button:SetFocus()
    end
  else
    self.List_Item_1:NavigateToIndex(0)
    self.List_Item_1:SetFocus()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_OnGamePadButtonDown(InKeyName)
    if not IsEventHandled then
      IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    end
  else
    if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
      IsEventHandled = self.Com_Tab:Handle_KeyEventOnPC(InKeyName)
    else
      IsEventHandled = self.Com_Tab:Handle_KeyEventOnTouch(InKeyName)
    end
    IsEventHandled = IsEventHandled or self:Handle_OnPCButtonDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_OnGamePadButtonDown(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold then
    self.Fame_Tab:TabToLeft()
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
    self.Fame_Tab:TabToRight()
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.SelectedRecurringTask then
      self:SetFocus()
      self.SelectedRecurringTask = nil
      IsEventHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnRefreshClickedCallBack()
    EMUIAnimationSubsystem:EMPlayAnimation(self.WBP_Fame_BtnRefresh, self.WBP_Fame_BtnRefresh.Click)
  end
  return IsEventHandled
end

function M:Handle_OnPCButtonDown(InKeyName)
  local IsEventHandled = false
  if "A" == InKeyName then
    self.Fame_Tab:TabToLeft()
    IsEventHandled = true
  elseif "D" == InKeyName then
    self.Fame_Tab:TabToRight()
    IsEventHandled = true
  elseif "SpaceBar" == InKeyName then
    self:QuickClaimCurrentRecurringTask()
    IsEventHandled = true
  end
  return IsEventHandled
end

return M
