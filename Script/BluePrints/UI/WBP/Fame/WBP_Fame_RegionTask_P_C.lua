require("UnLua")
local RegionFameController = require("BluePrints.UI.WBP.Fame.RegionFameController")
local RegionFameModel = RegionFameController:GetModel()
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

local function GetCurrentReputationID()
  return self.CurRegionTabId
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.bClosing = false
  self.bInAnimationFinished = self.In == nil
  self.CurRegionTabId = (...)
  self.QuestDataMap = {}
  self:InitRegionTabInfo()
  self.bRegionTaskDataInitialized = true
  ReddotManager.AddListenerEx("ExperienceFameTask", self, self.OnExperienceFameTaskReddotChange)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "FameRegionTask", nil)
  if self.In then
    self:PlayAnimation(self.In)
  end
end

function M:Construct()
  print("WBP_Fame_RegionTask_P_C Construct")
  self.Fame_CompletionProgress.Btn_Reward.Button_Area.OnClicked:Add(self, self.OnGetAllRewardsBtnClicked)
  self.Fame_CompletionProgress.Btn_Reward:SetGamePadImg("Y")
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
    TitleName = GText("Reigion_Task"),
    OwnerPanel = self,
    BackCallback = self.CloseSelf
  })
  self.List_Tab:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    self.OnUINavigation
  })
  self.List_Item:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    self.OnUINavigation
  })
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:BindToAnimationStarted(self.Out, {
    self,
    self.OnOutAnimationStarted
  })
end

function M:AreAllTaskRewardsClaimed(QuestChainType)
  local itemData = self.QuestDataMap and self.QuestDataMap[tostring(QuestChainType)] or {}
  if next(itemData) == nil then
    return false
  end
  local avatar = GWorld:GetAvatar()
  local reputation = avatar and avatar.RegionReputations[self.CurRegionTabId]
  local rewardRecord = reputation and reputation.ExperienceQuestRewardRecord
  if not rewardRecord then
    return false
  end
  for _, QuestId in ipairs(itemData) do
    if not rewardRecord[QuestId] then
      return false
    end
  end
  return true
end

function M:InitRegionTabInfo()
  self.CurQuestChainType = nil
  self.CurSelectedFameTaskTab = nil
  self.List_Tab:ClearListItems()
  self.List_Tab.BP_OnItemClicked:Add(self, self.OnList_TabItemClicked)
  self.List_Tab.BP_OnItemSelectionChanged:Add(self, self.OnList_TabItemSelectionChanged)
  local curReputationID = self.CurRegionTabId
  for _, Data in pairs(DataMgr.ReputationExperience) do
    if curReputationID == Data.ReputationId then
      local questData = DataMgr.QuestChain[Data.QuestId]
      if questData then
        if nil == self.QuestDataMap[tostring(questData.QuestChainType)] then
          self.QuestDataMap[tostring(questData.QuestChainType)] = {}
        end
        table.insert(self.QuestDataMap[tostring(questData.QuestChainType)], Data.QuestId)
      end
    end
  end
  local QuestChainTypeOrder = {
    Const.MainQuestChainType,
    Const.SideQuestChainType
  }
  for _, QuestChainType in ipairs(QuestChainTypeOrder) do
    local Key = tostring(QuestChainType)
    local Data = self.QuestDataMap[Key]
    if Data then
      local itemContent = NewObject(UIUtils.GetCommonItemContentClass())
      itemContent.Owner = self
      itemContent.QuestChainType = Key
      itemContent.OnTaskTabClicked = self.OnTaskTabClicked
      itemContent.ShowRedDot = RegionFameModel:HasTargetRegionCanClaimExperienceTask(curReputationID, Key)
      itemContent.AllItemsAlreadyClaimed = self:AreAllTaskRewardsClaimed(Key)
      self.List_Tab:AddItem(itemContent)
      if self.CurQuestChainType == nil and nil == self.CurSelectedFameTaskTab then
        self.CurQuestChainType = Key
        self.List_Tab:BP_SetSelectedItem(itemContent)
        self.CurSelectedFameTaskTab = self.List_Tab:GetItemAt(0)
      end
    end
  end
  local curSelectedItem = self.List_Tab:BP_GetSelectedItem()
  self:UpdateTaskItem()
end

function M:RefreshRegionTaskTabReddots()
  local ReputationId = self.CurRegionTabId
  for Index = 0, self.List_Tab:GetNumItems() - 1 do
    local Content = self.List_Tab:GetItemAt(Index)
    if Content then
      Content.ShowRedDot = RegionFameModel:HasTargetRegionCanClaimExperienceTask(ReputationId, Content.QuestChainType)
      if Content.EntryWidget then
        Content.EntryWidget:ShowRedDot(Content.ShowRedDot)
      end
    end
  end
end

function M:RefreshRegionTaskTabCompletionState()
  for Index = 0, self.List_Tab:GetNumItems() - 1 do
    local Content = self.List_Tab:GetItemAt(Index)
    if Content then
      Content.AllItemsAlreadyClaimed = self:AreAllTaskRewardsClaimed(Content.QuestChainType)
      if Content.EntryWidget then
        Content.EntryWidget:SetImageDone(Content.AllItemsAlreadyClaimed)
      end
    end
  end
end

function M:OnExperienceFameTaskReddotChange()
  if not self.bRegionTaskDataInitialized then
    return
  end
  self:UpdateTaskItem()
end

function M:UpdateTaskItem()
  if not self.QuestDataMap then
    return
  end
  self:RefreshRegionTaskTabReddots()
  self:RefreshRegionTaskTabCompletionState()
  self.List_Item:ClearListItems()
  local itemData = self.QuestDataMap[tostring(self.CurQuestChainType)] or {}
  local bHasClaimableReward = false
  local bUnfinishedTaskCount = 0
  local defaultFocusIndex = 0
  local ReadyClaimContents = {}
  local NotClaimableContents = {}
  local AlreadyClaimedContents = {}
  for index, value in ipairs(itemData) do
    local questData = DataMgr.ReputationExperience[value]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.IsFameTaskItem = true
    Content.QuestId = questData.QuestId
    Content.ResourceId = questData.ResourceId
    Content.RewardID = questData.ResourceId
    Content.ExpCount = questData.ExpCount
    Content.Description = questData.Description
    Content.State = CommonConst.FameRewardState.ReadyClaim
    Content.Parent = self
    Content.Index = index - 1
    Content.OnMenuOpenChanged = self.OnMenuOpenChanged
    do
      local avatar = GWorld:GetAvatar()
      if avatar then
        local questChain = avatar.QuestChains[questData.QuestId]
        if not questChain or not questChain:IsFinish() then
          Content.State = CommonConst.FameRewardState.NotClaimable
          bUnfinishedTaskCount = bUnfinishedTaskCount + 1
        end
        local reputation = avatar.RegionReputations[self.CurRegionTabId]
        if reputation and reputation.ExperienceQuestRewardRecord[questData.QuestId] then
          Content.State = CommonConst.FameRewardState.AlreadyClaimed
        end
      end
    end
    if Content.State == CommonConst.FameRewardState.ReadyClaim then
      table.insert(ReadyClaimContents, Content)
      bHasClaimableReward = true
    elseif Content.State == CommonConst.FameRewardState.NotClaimable then
      table.insert(NotClaimableContents, Content)
    elseif Content.State == CommonConst.FameRewardState.AlreadyClaimed then
      table.insert(AlreadyClaimedContents, Content)
    end
    
    function Content.OnReceiveRewardCallBack(Ret, RewardReturn, QuestId)
      if Ret == ErrorCode.RET_SUCCESS then
        self:UpdateTaskItem()
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardReturn, false, function()
          self:FocusDefaultTaskItem()
        end, self)
      end
    end
  end
  local OrderedContents = {}
  for _, Content in ipairs(ReadyClaimContents) do
    table.insert(OrderedContents, Content)
  end
  for _, Content in ipairs(NotClaimableContents) do
    table.insert(OrderedContents, Content)
  end
  for _, Content in ipairs(AlreadyClaimedContents) do
    table.insert(OrderedContents, Content)
  end
  for index, Content in ipairs(OrderedContents) do
    Content.Index = index - 1
    self.List_Item:AddItem(Content)
  end
  defaultFocusIndex = 0
  self.SelectedRewardIdx = defaultFocusIndex
  self.Fame_CompletionProgress.Text01:SetText(string.format(GText("UI_Party_Parkour_FinishingRate") .. ": "))
  self.Fame_CompletionProgress.Text_Now:SetText(string.format("%d", #itemData - bUnfinishedTaskCount))
  self.Fame_CompletionProgress.Text_Total:SetText(string.format("%d", #itemData))
  self.Fame_CompletionProgress.Btn_Reward:SetText(GText("UI_Mail_Recieveall"))
  if not bHasClaimableReward then
    self.Fame_CompletionProgress.Btn_Reward:ForbidBtn(true)
  else
    self.Fame_CompletionProgress.Btn_Reward:ForbidBtn(false)
  end
  self:RefreshGamepadStyle()
end

function M:OnList_TabItemClicked(Content)
  self:SelectTaskTab(Content)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
end

function M:OnList_TabItemSelectionChanged(Content)
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:SelectTaskTab(Content)
  end
end

function M:SelectTaskTab(Content)
  if not Content or Content == self.CurSelectedFameTaskTab then
    return
  end
  if self.CurSelectedFameTaskTab and self.CurSelectedFameTaskTab.EntryWidget then
    self.CurSelectedFameTaskTab.EntryWidget:UnSelected()
  end
  self.CurSelectedFameTaskTab = Content
  self.CurQuestChainType = Content.QuestChainType
  self.List_Tab:BP_SetSelectedItem(Content)
  if Content.EntryWidget then
    Content.EntryWidget:Selected()
  end
  self:UpdateTaskItem()
end

function M:OnTaskTabClicked(QuestChainType)
  for index = 0, self.List_Tab:GetNumItems() - 1 do
    local content = self.List_Tab:GetItemAt(index)
    if content and tostring(content.QuestChainType) == tostring(QuestChainType) then
      self:SelectTaskTab(content)
      return
    end
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bHandled = false
  if "Escape" == InKeyName then
    self:CloseSelf()
    bHandled = true
  elseif UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:CloseSelf()
      bHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop and not self.Fame_CompletionProgress.Btn_Reward:IsBtnForbidden() then
      self:OnGetAllRewardsBtnClicked()
      bHandled = true
    end
  end
  return bHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnUINavigation(NavigationDirection)
  if NavigationDirection == EUINavigation.Left then
    if self.CurSelectedFameTaskTab and self.CurSelectedFameTaskTab.EntryWidget then
      return self.CurSelectedFameTaskTab.EntryWidget
    end
    return self.List_Tab
  elseif NavigationDirection == EUINavigation.Right then
    local index = self.SelectedRewardIdx or 0
    self.List_Item:NavigateToIndex(index)
    local content = self.List_Item:GetItemAt(index)
    return content and content.SelfWidget or self.List_Item
  end
end

function M:FocusDefaultTaskItem()
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad or self.bItemMenuOpen then
    return
  end
  local itemCount = self.List_Item:GetNumItems()
  if itemCount <= 0 then
    if self.CurSelectedFameTaskTab and self.CurSelectedFameTaskTab.EntryWidget then
      self.CurSelectedFameTaskTab.EntryWidget:SetFocus()
    end
    return
  end
  local index = math.max(0, math.min(self.SelectedRewardIdx or 0, itemCount - 1))
  self.List_Item:ScrollIndexIntoView(index)
  self:AddDelayFrameFunc(function()
    local content = self.List_Item:GetItemAt(index)
    if content and content.SelfWidget then
      content.SelfWidget:SetFocus()
    else
      self.List_Item:NavigateToIndex(index)
      self.List_Item:SetFocus()
    end
  end, 1, "FocusDefaultTaskItem")
end

function M:SetFocus_Lua()
  self:FocusDefaultTaskItem()
end

function M:UpdateSelectedRewardIdx(NewIdx)
  rawset(self, "SelectedRewardIdx", NewIdx)
end

function M:OnMenuOpenChanged(bIsOpen)
  rawset(self, "bItemMenuOpen", bIsOpen)
  if not bIsOpen then
    self:FocusDefaultTaskItem()
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  rawset(self, "CurInputDeviceType", CurInputDevice)
  rawset(self, "CurGamepadName", CurGamepadName)
  self:RefreshGamepadStyle()
  if CurInputDevice == ECommonInputType.Gamepad then
    self:FocusDefaultTaskItem()
  end
end

function M:RefreshGamepadStyle()
  local bShow = self.CurInputDeviceType == ECommonInputType.Gamepad and not self.Fame_CompletionProgress.Btn_Reward:IsBtnForbidden()
  self.Fame_CompletionProgress.Btn_Reward:SetGamePadVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:CloseSelf()
  if not self.bInAnimationFinished then
    return
  end
  if self.bClosing or self:IsAnimationPlaying(self.Out) then
    return
  end
  self.bClosing = true
  self:PlayAnimation(self.Out)
  self:BeginAnimOutToExitWithInStack(true)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.In then
    self:AddDelayFrameFunc(function()
      self.bInAnimationFinished = true
    end, 1, "EnableRegionTaskClose")
  elseif InAnimation == self.Out and self.bClosing then
    self.Super.Close(self)
  end
end

function M:OnGetAllRewardsBtnClicked()
  if self.Fame_CompletionProgress.Btn_Reward:IsBtnForbidden() then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:GetAllExperienceQuestReward(self.CurRegionTabId, function(Ret, RewardReturn, ReputationId)
      if Ret == ErrorCode.RET_SUCCESS then
        self:UpdateTaskItem()
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardReturn, false, function()
          self:FocusDefaultTaskItem()
        end, self)
      end
    end)
  end
end

function M:Destruct()
  self.bRegionTaskDataInitialized = false
  ReddotManager.RemoveListener("ExperienceFameTask", self)
  self.Fame_CompletionProgress.Btn_Reward.Button_Area.OnClicked:Remove(self, self.OnGetAllRewardsBtnClicked)
  self.List_Tab.BP_OnItemClicked:Remove(self, self.OnList_TabItemClicked)
  self.List_Tab.BP_OnItemSelectionChanged:Remove(self, self.OnList_TabItemSelectionChanged)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:OnOutAnimationStarted()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "FameRegionTask", {ToEnd = 1})
end

return M
