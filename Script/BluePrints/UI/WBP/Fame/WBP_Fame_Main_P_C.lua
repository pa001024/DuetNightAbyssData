require("UnLua")
local RegionFameController = require("BluePrints.UI.WBP.Fame.RegionFameController")
local RegionFameModel = RegionFameController:GetModel()
local PageJumpUtils = require("Utils.PageJumpUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local FameTaskType = {RecurringTask = 1, ReputationEntrust = 2}

function M:Destruct()
  M.Super.Destruct(self)
  EventManager:RemoveEvent(EventID.RegionReputationsChange, self, self.RefreshUI)
  ReddotManager.RemoveListener(self.UIName, self)
  ReddotManager.RemoveListener("RecurringFameTask", self)
  ReddotManager.RemoveListener("EntrustFameTask", self)
  ReddotManager.RemoveListener("ExperienceFameTask", self)
  ReddotManager.RemoveListener("MountLicense_Item", self)
  self:RemoveTimer("UpdateRefreshRemainingTime", true)
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.UIName = "FameMain"
  self.CachedTaskButtonName = nil
  self:InitRegionButtonGroups()
  for _, ButtonGroup in pairs(self.RegionButtonGroups) do
    ButtonGroup.Conquer.TextName:SetText(GText("RecurringTask_Title"))
    ButtonGroup.Gift.TextName:SetText(GText("ReputationEntrust_Title"))
    ButtonGroup.Task.TextName:SetText(GText("Reigion_Task"))
    ButtonGroup.Conquer:BindEventOnClicked(self, self.OnConquer)
    ButtonGroup.Gift:BindEventOnClicked(self, self.OnGift)
    ButtonGroup.Task:BindEventOnClicked(self, self.OnRegionTask)
    ButtonGroup.Conquer.SoundFunc = self.ButtonClickSoundFunc
    ButtonGroup.Gift.SoundFunc = self.ButtonClickSoundFunc
    ButtonGroup.Task.SoundFunc = self.ButtonClickSoundFunc
  end
  self.Fame_Progress:BindEventOnClicked(self, self.OnOpenReward)
  local InReputationID = (...)
  self:InitRegionTab(InReputationID)
  self:InitLicenseUI()
  ReddotManager.AddListenerEx(self.UIName, self, self.OnFameMainReddotChange)
  ReddotManager.AddListenerEx(self.UIName, self, self.FameMainTabReddotChange)
  ReddotManager.AddListenerEx("RecurringFameTask", self, self.OnFameMainReddotChange)
  ReddotManager.AddListenerEx("RecurringFameTask", self, self.FameMainTabReddotChange)
  ReddotManager.AddListenerEx("EntrustFameTask", self, self.OnFameMainReddotChange)
  ReddotManager.AddListenerEx("EntrustFameTask", self, self.FameMainTabReddotChange)
  ReddotManager.AddListenerEx("ExperienceFameTask", self, self.OnFameMainReddotChange)
  ReddotManager.AddListenerEx("ExperienceFameTask", self, self.FameMainTabReddotChange)
  EventManager:AddEvent(EventID.RegionReputationsChange, self, self.RefreshUI)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "Fame_Main", nil)
end

function M:InitRegionButtonGroups()
  self.RegionButtonGroups = {
    [0] = {
      Conquer = self.Btn_Conquer,
      Gift = self.Btn_Gift,
      Task = self.Btn_Task
    },
    [1] = {
      Conquer = self.Btn_Conquer_Huaxu,
      Gift = self.Btn_Gift_Huaxu,
      Task = self.Btn_Task_Huaxu
    }
  }
  self.RegionButtonSwitchers = {
    self.Ws_BtnConquer,
    self.Ws_BtnGift,
    self.Ws_BtnTask
  }
end

function M:GetActiveRegionButtonGroup()
  local RegionUIButtonBGIndex = self.CurRegionData and self.CurRegionData.RegionUIButtonBGIndex or 0
  return self.RegionButtonGroups[RegionUIButtonBGIndex] or self.RegionButtonGroups[0]
end

function M:InitLicenseUI()
  self.Mounts_License.Btn_Area.OnClicked:Add(self, self.OnLicenseBtn_OnClicked)
  self:AddDispatcher(EventID.OnGetLicense, self, self.OnGetLicense)
  self.Mounts_License.Text_License:SetText(GText("UI_Mount_FlyLicense"))
  self.Mounts_License.Text_Area:SetText(GText("UI_Mount_FlyLicense_Activated"))
  self.Mounts_License.Key_License:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    }
  })
  ReddotManager.AddListenerEx("MountLicense_Item", self, self.InitLicenseRedDot)
  self:InitLicenseRedDot()
end

function M:OnGetLicense()
  self:InitLicenseRedDot()
end

function M:OnLicenseBtn_OnClicked()
  UIManager(self):LoadUINew("MountLicense", self)
end

function M:InitLicenseRedDot()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.Mounts_License.Num_Now:SetText(CommonUtils.TableLength(Avatar.MountFlyLicenses))
  local Count = 0
  for i, v in pairs(DataMgr.FlyLicense) do
    Count = Count + 1
  end
  self.Mounts_License.Num_Total:SetText(Count)
  local RedDot = ReddotManager.GetTreeNode("MountLicense_Item")
  self.Mounts_License.Reddot:SetVisibility(RedDot and RedDot.Count > 0 and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:UpdateRefreshTime(RegionTabId)
  local EntrustTaskRefreshTimestamp = RegionFameModel:GetEntrustTaskRefreshTime(RegionTabId)
  if not EntrustTaskRefreshTimestamp then
    return
  end
  local RecurringTaskRefreshTimestamp = RegionFameModel:GetRecurringTaskRefreshTime(RegionTabId)
  rawset(self, "EntrustTaskRefreshTimestamp", EntrustTaskRefreshTimestamp)
  rawset(self, "RecurringTaskRefreshTimestamp", RecurringTaskRefreshTimestamp)
  self:AddTimer(0.01, function()
    self:UpdateRefreshRemainingTime()
  end)
  self:AddTimer(1, self.UpdateRefreshRemainingTime, true, 0, "UpdateRefreshRemainingTime", true)
end

function M:UpdateRefreshRemainingTime()
  if self.EntrustTaskRefreshTimestamp and self.RecurringTaskRefreshTimestamp then
    local RemainingTimeText1 = UIUtils.GetRemainingTimeByTimestamp(self.RecurringTaskRefreshTimestamp)
    local RemainingTimeText2 = UIUtils.GetRemainingTimeByTimestamp(self.EntrustTaskRefreshTimestamp)
    local AlreadyClaimedCount = 0
    local TotalCount = 0
    do
      local avatar = GWorld:GetAvatar()
      if avatar then
        local reputation = avatar.RegionReputations[self.CurRegionTabId]
        if not reputation or reputation.ExperienceQuestRewardRecord then
        end
        for _, Data in pairs(DataMgr.ReputationExperience) do
          if self.CurRegionTabId == Data.ReputationId then
            local questChain = avatar.QuestChains[Data.QuestId]
            if not questChain or not questChain:IsFinish() then
              AlreadyClaimedCount = AlreadyClaimedCount + 1
            end
          end
        end
        if self.CurRegionTabId then
          TotalCount = #DataMgr.ReputationId2ExperienceQuestId[self.CurRegionTabId]
        end
      end
    end
    for _, ButtonGroup in pairs(self.RegionButtonGroups) do
      ButtonGroup.Conquer:SetTextRefresTime(RemainingTimeText1)
      ButtonGroup.Gift:SetTextRefresTime(RemainingTimeText2)
      ButtonGroup.Task:SetTextRefresTime_1(GText("UI_Party_Parkour_FinishingRate"))
      ButtonGroup.Task:SetTextRefresTime(TotalCount - AlreadyClaimedCount .. "/" .. TotalCount)
    end
  end
end

function M:InitRegionTabInfo()
  local AllRegionTabInfo = {}
  for key, TabData in pairs(DataMgr.RegionReputation) do
    local Locked = not RegionFameModel:CheckTabCondition(TabData.Condition)
    local LockToast = TabData.LockToast
    table.insert(AllRegionTabInfo, {
      Text = GText(TabData.RegionName),
      IconPath = TabData.RegionIconPath,
      TabId = key,
      IsLocked = Locked,
      LockReasonText = LockToast
    })
  end
  rawset(self, "AllRegionTabInfo", AllRegionTabInfo)
end

function M:FindRegionReputationIndexByRegionId()
  local TargetRegionId = WorldTravelSubsystem():GetCurrentSceneId()
  local MainMap = UIManager(self):GetUIObj("LevelMapMain")
  if MainMap and MainMap.CurrentMainRegionId then
    TargetRegionId = MainMap.CurrentMainRegionId
  end
  for repKey, repData in pairs(DataMgr.RegionReputation) do
    local regionList = repData.RegionId
    if regionList then
      for _, regionId in ipairs(regionList) do
        if regionId == TargetRegionId then
          return repKey
        end
      end
    end
  end
  return nil
end

function M:InitRegionTab(InReputationID)
  self:InitRegionTabInfo()
  self.Com_Tab:Init({
    LeftKey = "Q",
    RightKey = "E",
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
    TitleName = GText("RegionReputation_Title"),
    OwnerPanel = self,
    BackCallback = self.CloseSelf
  })
  self.Com_Tab:BindEventOnTabSelected(self, self.OnRegionTabItemClick)
  local RegionTabId = self:FindRegionReputationIndexByRegionId()
  local SelectId
  if RegionTabId and DataMgr.RegionReputation[RegionTabId] then
    local data = DataMgr.RegionReputation[RegionTabId]
    if RegionFameModel:CheckTabCondition(data.Condition) then
      SelectId = RegionTabId
    end
  end
  if not SelectId then
    if self.AllRegionTabInfo[1] then
      SelectId = self.AllRegionTabInfo[1].TabId
    else
      return
    end
  end
  self:TrySelectRegionTabById(SelectId)
  if InReputationID then
    self:TrySelectRegionTabById(InReputationID)
  end
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self.Com_Tab:Play_Com_Tab_M_In()
  else
    self.Com_Tab:Play_WBP_Com_Tab_P_In()
  end
end

function M:TrySelectRegionTabById(targetTabId)
  if not targetTabId then
    return
  end
  local NewData = DataMgr.RegionReputation[targetTabId]
  if not NewData then
    return
  end
  if not RegionFameModel:CheckTabCondition(NewData.Condition) then
    local FallbackId = not self.CurRegionTabId and self.AllRegionTabInfo[1] and self.AllRegionTabInfo[1].TabId
    if FallbackId and FallbackId ~= targetTabId then
      self.Com_Tab:SelectTabById(FallbackId)
    end
    return
  end
  self.Com_Tab:SelectTabById(targetTabId)
end

function M:OnRegionTabItemClick(TabWidget)
  if not TabWidget then
    return
  end
  local NewTabId = TabWidget:GetTabId()
  local NewData = DataMgr.RegionReputation[NewTabId]
  if not NewData then
    return
  end
  rawset(self, "CurRegionTabId", NewTabId)
  rawset(self, "CurRegionData", NewData)
  self:RefreshUI()
end

function M:RefreshUI()
  self:RefreshReputationData()
  self:RefreshUIBG()
  self:PlayAnimation(self.In)
  self:RefreshCurRewardReddot()
  self:RefreshAllTabReddots()
end

function M:RefreshReputationData()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local AvatarReputation = Avatar.RegionReputations[self.CurRegionTabId]
  if not AvatarReputation then
    DebugPrint("[RefreshReputationData] AvatarReputation is Null")
    return
  end
  self.Fame_Progress:Init(self.CurRegionTabId, AvatarReputation)
  self:RemoveTimer("UpdateRefreshRemainingTime", true)
  self:UpdateRefreshTime(self.CurRegionTabId)
end

function M:RefreshUIBG()
  local RegionUIBG = self.CurRegionData and self.CurRegionData.RegionUIBG
  if self.RegionUIBG and self.RegionUIBG == RegionUIBG then
    return
  end
  self.RegionUIBG = RegionUIBG
  local Item = UIManager(self):CreateWidget(RegionUIBG)
  self.Bg0:ClearChildren()
  if Item then
    self.Bg0:AddChild(Item)
    if Item.Loop then
      Item:PlayAnimation(Item.Loop, 0, 0)
    end
    if Item.In then
      Item:PlayAnimation(Item.In)
    end
  else
    DebugPrint("SL RegionTabUIBG Create Failed")
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:UpdateUIStyleInPlatform(false)
  else
    self:UpdateUIStyleInPlatform(true)
  end
  local RegionUIButtonBGIndex = self.CurRegionData.RegionUIButtonBGIndex or 0
  for _, ButtonSwitcher in ipairs(self.RegionButtonSwitchers) do
    ButtonSwitcher:SetActiveWidgetIndex(RegionUIButtonBGIndex)
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:SetDefaultTaskButtonFocus()
  end
end

function M:ButtonClickSoundFunc()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
end

function M:OnConquer()
  DebugPrint("SL OnConquer")
  self.CachedTaskButtonName = "Conquer"
  return PageJumpUtils:JumpToFameTask(self.CurRegionTabId, FameTaskType.RecurringTask)
end

function M:OnGift()
  DebugPrint("SL OnGift")
  self.CachedTaskButtonName = "Gift"
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:MarkEntrustFameTaskReddotRead(self.CurRegionTabId)
    self:RefreshAllTabReddots()
  end
  return PageJumpUtils:JumpToFameTask(self.CurRegionTabId, FameTaskType.ReputationEntrust)
end

function M:OnOpenReward()
  DebugPrint("SL OpenReward")
  local GameInstance = self:GetGameInstance()
  local UIManager = GameInstance:GetGameUIManager()
  return UIManager:LoadUINew("FameReward", self.CurRegionTabId)
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.Out) or self:IsAnimationPlaying(self.In) then
    return
  end
  AudioManager(self):SetEventSoundParam(self, "Fame_Main", {ToEnd = 1})
  self:PlayAnimation(self.Out)
end

function M:OnFameMainReddotChange()
  self:RefreshCurRewardReddot()
end

function M:FameMainTabReddotChange()
  self:RefreshAllTabReddots()
end

function M:RefreshCurRewardReddot()
  local Show = false
  local Avatar = GWorld:GetAvatar()
  if Avatar and self.CurRegionTabId then
    local TreeNode = ReddotManager.GetTreeNode(self.UIName)
    if TreeNode and TreeNode.Count > 0 then
      Show = Avatar:HasAnyRewardUpToCurLevel(self.CurRegionTabId)
    end
  end
  if self.Fame_Progress and self.Fame_Progress.Reddot then
    self.Fame_Progress.Reddot:SetVisibility(Show and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  self:RefreshRecurringTaskReddot()
  self:RefreshEntrustTaskReddot()
  self:RefreshExperienceTaskReddot()
end

function M:RefreshExperienceTaskReddot()
  local bHasCanClaim = RegionFameModel:HasTargetRegionCanClaimExperienceTask(self.CurRegionTabId)
  for _, ButtonGroup in pairs(self.RegionButtonGroups) do
    if ButtonGroup.Task and ButtonGroup.Task.Reddot then
      ButtonGroup.Task.Reddot:SetVisibility(bHasCanClaim and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:RefreshRecurringTaskReddot()
  local bHasCanClaim = false
  local AllCanClaimTasks = RegionFameModel:GetTargetRegionAllCanClaimRecurringTasks(self.CurRegionTabId)
  if AllCanClaimTasks and #AllCanClaimTasks > 0 then
    bHasCanClaim = true
  end
  for _, ButtonGroup in pairs(self.RegionButtonGroups) do
    if ButtonGroup.Conquer and ButtonGroup.Conquer.Reddot then
      ButtonGroup.Conquer.Reddot:SetVisibility(bHasCanClaim and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:RefreshEntrustTaskReddot()
  local bHasCanClaim = RegionFameModel:GetTargetRegionEntrustTaskCanSubmit(self.CurRegionTabId)
  for _, ButtonGroup in pairs(self.RegionButtonGroups) do
    if ButtonGroup.Gift and ButtonGroup.Gift.Reddot then
      ButtonGroup.Gift.Reddot:SetVisibility(bHasCanClaim and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:RefreshAllTabReddots()
  if not self.Com_Tab then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    for _, RegionCfg in pairs(DataMgr.RegionReputation) do
      self.Com_Tab:ShowTabRedDotByTabId(RegionCfg.ReputationID, false, false, false)
    end
    return
  end
  local TreeNode = ReddotManager.GetTreeNode(self.UIName)
  local HasAny = TreeNode and TreeNode.Count > 0
  if not HasAny then
    for _, RegionCfg in pairs(DataMgr.RegionReputation) do
      self.Com_Tab:ShowTabRedDotByTabId(RegionCfg.ReputationID, false, false, false)
    end
  end
  for _, RegionCfg in pairs(DataMgr.RegionReputation) do
    local TabRed, _ = Avatar:HasAnyRewardUpToCurLevel(RegionCfg.ReputationID)
    local AllCanClaimTasks = RegionFameModel:GetTargetRegionAllCanClaimRecurringTasks(RegionCfg.ReputationID)
    local HasUnreadEntrustTask = Avatar:HasUnreadEntrustFameTaskReddot(RegionCfg.ReputationID)
    local CanClaimExperienceTask = RegionFameModel:HasTargetRegionCanClaimExperienceTask(RegionCfg.ReputationID)
    TabRed = TabRed or AllCanClaimTasks and #AllCanClaimTasks > 0 or HasUnreadEntrustTask or CanClaimExperienceTask
    self.Com_Tab:ShowTabRedDotByTabId(RegionCfg.ReputationID, false, TabRed, false)
  end
end

function M:Close()
  self.Super.Close(self)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:Close()
  elseif InAnimation == self.In then
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:CloseSelf()
  elseif "Q" == InKeyName then
    if self.Com_Tab then
      self.Com_Tab:TabToLeft()
      IsEventHandled = true
    end
  elseif "E" == InKeyName and self.Com_Tab then
    self.Com_Tab:TabToRight()
    IsEventHandled = true
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  else
    return UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnGamePadDown(InKeyName)
  DebugPrint("SL OnGamePadDown is InKeyName Detail", InKeyName)
  local IsEventHandled = false
  if "Gamepad_FaceButton_Right" == InKeyName then
    self:CloseSelf()
    IsEventHandled = true
  end
  if "Gamepad_Special_Right" == InKeyName then
    self:OnLicenseBtn_OnClicked()
    IsEventHandled = true
  elseif "Gamepad_LeftShoulder" == InKeyName or "Gamepad_RightShoulder" == InKeyName then
    if self.Com_Tab then
      self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
      IsEventHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self.Fame_Progress:OnClicked()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if not IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
    self:SetDefaultTaskButtonFocus()
  end
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  self:SetRegionButtonKeyVisibility(UE4.ESlateVisibility.Collapsed)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self.Fame_Progress.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Mounts_License.Key_License:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if IsUseKeyAndMouse then
    self.Fame_Progress.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Mounts_License.Key_License:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Fame_Progress.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Fame_Progress.WBP_Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Y"}
      }
    })
    self.Mounts_License.Key_License:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:SetRegionButtonKeyVisibility(Visibility)
  for _, ButtonGroup in pairs(self.RegionButtonGroups) do
    for _, Button in pairs(ButtonGroup) do
      if Button and Button.WBP_Com_KeyImg then
        Button.WBP_Com_KeyImg:SetVisibility(Visibility)
      end
    end
  end
end

function M:SetDefaultTaskButtonFocus()
  local ButtonGroup = self:GetActiveRegionButtonGroup()
  local DefaultButton = ButtonGroup and (ButtonGroup[self.CachedTaskButtonName] or ButtonGroup.Conquer)
  local TargetWidget = DefaultButton and DefaultButton.Button_Area
  if IsValid(TargetWidget) then
    TargetWidget:SetFocus()
  end
end

function M:SetFocus_Lua()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:SetDefaultTaskButtonFocus()
  end
end

function M:OnRegionTask()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
  self.CachedTaskButtonName = "Task"
  local GameInstance = self:GetGameInstance()
  local UIManager = GameInstance:GetGameUIManager()
  return UIManager:LoadUINew("FameRegionTask", self.CurRegionTabId)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:SetDefaultTaskButtonFocus()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

return M
