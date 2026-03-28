local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent"
})

function M:Construct()
  self.FadeInAnimation = self.In
  self.FadeOutAnimation = self.Out
  self.Title = self.Title
  self.Round = self.RewardWave
  self.Rewards = self.List_Item
  self.HistoryButton = self.Btn_History
  self.PrizeButton = self.Btn_Gacha
  self.FinishTip = self.Text_Complete
  self.FinishTip:SetText(GText("UI_LimitedPrizePool_EndPool"))
  self.HistoryButton:SetText(GText("UI_LimitedPrizePool_History"))
  self.HistoryButton:BindEventOnClicked(self, self.OpenHistory)
  self.HistoryButton:SetGamePadImg("X")
  self.ParentWidget = nil
  self.EventId = nil
  self.EventEndTime = nil
  self.PrizeButton:BindForbiddenPrizeDraw({
    self,
    self.PromptSelectableRewards
  })
  self.PrizeButton:BindUpdateReward({
    self,
    self.UpdateReward
  })
  self.PrizeButton:SetGamePadImg("Y")
  self.Round:BindOnMenuOpenChanged({
    self,
    self.OnMenuOpenChangedEvent
  })
  self.Rewards:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    self.LeaveRewardViewMode
  })
  self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
  self:ListenInputTypeChanged()
end

function M:Destruct()
  self.PrizeButton:UnbindForbiddenPrizeDraw()
  self.PrizeButton:UnbindUpdateReward()
  self.Round:UnbindindOnMenuOpenChanged()
  self.HistoryButton:UnBindEventOnClicked(self, self.OpenHistory)
  self:UnlistenInputTypeChanged()
end

function M:ListenInputTypeChanged()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SetInputType)
  end
end

function M:UnlistenInputTypeChanged()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SetInputType)
  end
end

function M:SetInputType(NewInputType, NewGamepadName)
  if NewInputType == ECommonInputType.Touch then
  else
    if NewInputType == ECommonInputType.Gamepad then
    else
    end
  end
end

function M:InitPage(ActivityId, TabId, ActivityInfo, ParentWidget)
  local EventData = DataMgr.EventMain[ActivityId]
  if not EventData then
    return
  end
  self.ParentWidget = ParentWidget
  self.EventId = ActivityId
  self.EventEndTime = EventData.EventEndTime
  self.PrizeButton:Init(self, self.EventId)
  self.Title:SetTitle(GText(EventData.EventName))
  self.Title:SetDesc(GText(EventData.EventDes), false)
  self.Title:SetTips(EventData.EventRule, self.ViewInfoBtnClick, self)
  self.Title:SetGamePadImg("Menu")
  self:SetEndTime(EventData.EventEndTime)
  self:SetPool(ActivityId, true)
end

function M:UpdatePage()
  self:SetEndTime(self.EventEndTime)
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
  local bHandled = false
  local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(Key) then
    bHandled = self:OnGamePadButtonDown(KeyName)
  else
    bHandled = false
  end
  return bHandled
end

function M:OnGamePadButtonDown(InKeyName)
  local IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  return IsEventHandled
end

function M:Handle_KeyDownOnGamePad(KeyName)
  local bHandled = false
  if self:IsInCheckDetailMode() and KeyName ~= UIConst.GamePadKey.FaceButtonRight and KeyName ~= UIConst.GamePadKey.SpecialLeft then
    bHandled = true
  elseif KeyName == UIConst.GamePadKey.SpecialLeft then
    bHandled = true
    self.Round:SetQAChecked(not self.Round:IsQAChecked())
  elseif KeyName == UIConst.GamePadKey.FaceButtonBottom then
    bHandled = true
    self:EnterRewardViewMode()
  elseif KeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.Round:IsQAChecked() then
      bHandled = true
      self.Round:SetQAChecked(false)
      if self.FocusWidget then
        self.FocusWidget:SetFocus()
      else
        self:EnterRewardViewMode()
      end
    else
      bHandled = self:LeaveRewardViewMode()
    end
  elseif KeyName == UIConst.GamePadKey.FaceButtonLeft then
    bHandled = true
    self.HistoryButton:OnBtnClicked()
  elseif KeyName == UIConst.GamePadKey.FaceButtonTop then
    if 0 == self.WS:GetActiveWidgetIndex() then
      bHandled = true
      self.PrizeButton:PrizeDrawWithSound()
    end
  elseif KeyName == UIConst.GamePadKey.SpecialRight then
    bHandled = true
    self:ViewInfoBtnClick()
  end
  return bHandled
end

function M:ShowPage()
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:HidePage()
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:PlayFadeIn()
  self:PlayAnimation(self.FadeInAnimation)
end

function M:PlayFadeOut()
  self:PlayAnimation(self.FadeOutAnimation)
end

function M:GetPageConfigData()
  return {}
end

function M:GetDefaultBottomTips()
  local ResultKeyInfo = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_Tips_Close")
    }
  }
  return ResultKeyInfo
end

function M:SetEndTime(EndTime)
  self.Title:SetTime(EndTime)
  if self.Title:IsTimeOut() then
    self:SetIsEnabled(false)
  else
    self:SetIsEnabled(true)
  end
end

function M:SetPool(PoolId, bRefreshAll)
  local PoolData = DataMgr.LimitedPrizePool[PoolId]
  if not PoolData then
    return
  end
  local CurrentRound = 1
  local NextDrawCount = 1
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local LimitPrizeData = Avatar.LimitPrize[PoolId]
    if LimitPrizeData then
      local Round = LimitPrizeData.Round
      if Round > #PoolData.LimitedPrizePoolId then
        Round = #PoolData.LimitedPrizePoolId
      end
      CurrentRound = Round
      if LimitPrizeData.DrawCounts then
        NextDrawCount = LimitPrizeData.DrawCounts + 1
      end
    end
  end
  self.Round:SetCurrentRound(CurrentRound)
  self.Round:SetTotalRound(#PoolData.LimitedPrizePoolId)
  self:SetRound(PoolId, CurrentRound, PoolData.LimitedPrizePoolId[CurrentRound], NextDrawCount, bRefreshAll)
end

function M:SetRound(PoolId, Round, RoundId, NextDrawCount, bRefreshAll)
  local RoundData = DataMgr.LimitedPrizeItem[RoundId]
  if not RoundData then
    return
  end
  if bRefreshAll then
    self.Rewards:ClearListItems()
  end
  local RewardNumber = #RoundData.Id
  for i = 1, RewardNumber do
    self:AddReward(PoolId, i, RoundData.Id[i], RoundData.Type[i], RoundData.Count[i], RoundData.Probability[i])
  end
  self.PrizeButton:SetCost(RoundData.CostRuleId, Round, NextDrawCount)
  self:UpdatePrizeButtonState()
end

function M:UpdatePrizeButtonState()
  local bAllSelected = true
  local bAllGot = true
  local Items = self.Rewards:GetListItems()
  for _, Item in pairs(Items) do
    if IsValid(Item) then
      if bAllSelected and Item.Id == nil then
        bAllSelected = false
      end
      if bAllGot and not Item.bGot then
        bAllGot = false
      end
    end
  end
  if bAllGot then
    self.WS:SetActiveWidgetIndex(2)
  else
    self.WS:SetActiveWidgetIndex(0)
  end
  self.PrizeButton:SetForbidden(not bAllSelected)
end

function M:AddReward(PoolId, Number, Ids, Type, Count, Probability)
  local Content = self.Rewards:GetItemAt(Number - 1)
  local NeedAdd = false
  if not IsValid(Content) then
    NeedAdd = true
    Content = UE4.NewObject(UIUtils.GetCommonItemContentClass())
  end
  Content.EventId = self.EventId
  Content.Number = Number
  Content.Ids = Ids
  Content.Type = ItemUtils.GetItemType(Type)
  Content.Count = Count
  Content.SelectedIndex = 0
  Content.Probability = Probability
  Content.Id = 1 == #Ids and Ids[1] or nil
  Content.bLocked = false
  Content.bGot = false
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local LimitPrizeData = Avatar.LimitPrize[PoolId]
    if LimitPrizeData then
      Content.bLocked = LimitPrizeData.DrawCounts > 0
      local SelfSelectData = LimitPrizeData.SelfSelect
      if SelfSelectData and SelfSelectData[Number] then
        do
          local Index = SelfSelectData[Number]
          Content.SelectedIndex = Index
          Content.Id = Ids[Index] or nil
        end
      end
      for _, GotNumber in pairs(LimitPrizeData.HasDrawPrizes) do
        if 1 == GotNumber or GotNumber == Number then
          Content.bGot = true
          break
        end
      end
    end
  end
  Content.OnSetSelectableReward = {
    self,
    self.HandleSetSelectableReward
  }
  Content.OnFocusWidget = {
    self,
    self.UpdateParentActivityKeyTips
  }
  Content.OnMenuOpenChangedEvent = {
    self,
    self.OnMenuOpenChangedEvent
  }
  if NeedAdd then
    self.Rewards:AddItem(Content)
  elseif Content.Entry then
    Content.Entry:Refresh()
  end
end

function M:PromptSelectableRewards()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_disable", nil, nil)
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_LimitedPrizePool_SelectToast"))
  local EntryWidgets = self.Rewards:GetDisplayedEntryWidgets()
  for _, EntryWidget in pairs(EntryWidgets) do
    if IsValid(EntryWidget) then
      EntryWidget:TryPromptSelectableReward()
    end
  end
end

function M:HandleSetSelectableReward()
  self:UpdatePrizeButtonState()
end

function M:UpdateReward(bRefreshRound, bIsBigPrize)
  if bIsBigPrize then
    self.FocusWidgetName = nil
    self.FocusWidget = nil
    self.FocusWidgetIndex = nil
  end
  local bNavigate = false
  local FocusWidgetIndex = self.FocusWidgetIndex
  if FocusWidgetIndex then
    bNavigate = true
  end
  if bNavigate then
    self.FocusWidget = self.Rewards
  end
  self.ParentWidget:UpdateActivityKeyTips(self.FocusWidgetName, self.FocusWidget)
  self:SetPool(self.EventId, bRefreshRound)
  if bRefreshRound then
    self:PlayAnimation(self.Change)
  end
  if bNavigate then
    self:EnterRewardViewMode(FocusWidgetIndex)
  else
    self.ParentWidget:SetFocus()
  end
end

function M:OpenHistory()
  if self.EventId then
    UIManager(self):ShowCommonPopupUI(100334, {
      PoolId = self.EventId
    })
  end
end

function M:GetCurFocusWidgetInfo()
  return self.FocusWidgetName, self.FocusWidget
end

function M:OnSubTabNavigationRight()
  self:EnterRewardViewMode()
end

function M:EnterRewardViewMode(Index)
  Index = Index or 0
  self.Rewards:NavigateToIndex(Index)
end

function M:LeaveRewardViewMode()
  if self.FocusWidget == nil then
    return false
  end
  self.FocusWidgetName = nil
  self.FocusWidget = nil
  self.FocusWidgetIndex = nil
  if self.ParentWidget then
    self.ParentWidget:UpdateActivityKeyTips()
    self.ParentWidget:SetFocus()
  end
  return true
end

function M:UpdateParentActivityKeyTips(FocusWidgetName, FocusWidget, FocusWidgetIndex, bIsFocusToParent)
  self.FocusWidgetName = FocusWidgetName
  self.FocusWidget = FocusWidget
  self.FocusWidgetIndex = FocusWidgetIndex
  if self.ParentWidget then
    self.ParentWidget:UpdateActivityKeyTips(FocusWidgetName, FocusWidget)
    if bIsFocusToParent then
      self.ParentWidget:SetFocus()
    end
  end
end

function M:EnterCheckDetailMode()
  self.bInCheckDetailMode = true
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.HistoryButton:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self.PrizeButton:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self.Title:UpdateUIStyleInPlatform(false)
    local FocusWidgetName
    if not self.Round:IsQAChecked() then
      FocusWidgetName = "EmptyView"
      self.Round:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.ParentWidget:UpdateActivityKeyTips(FocusWidgetName, self.FocusWidget)
    self.ParentWidget.Activity_Tab.WBP_Com_Tab_ResourceBar:HideGamePadKey(true)
  end
end

function M:LeaveCheckDetailMode()
  self.bInCheckDetailMode = false
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.HistoryButton:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.PrizeButton:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Round:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Title:UpdateUIStyleInPlatform(true)
    self.ParentWidget.Activity_Tab.WBP_Com_Tab_ResourceBar:HideGamePadKey(false)
  end
  self:AddDelayFrameFunc(function()
    if self:HasAnyUserFocus() or self:HasFocusedDescendants() then
      if self.FocusWidget then
        self.FocusWidget:SetFocus()
      else
        self:EnterRewardViewMode()
      end
    end
  end, 2)
end

function M:IsInCheckDetailMode()
  return self.bInCheckDetailMode
end

function M:OnMenuOpenChangedEvent(IsOpen)
  if IsOpen then
    self:EnterCheckDetailMode()
  else
    self:LeaveCheckDetailMode()
  end
end

function M:ViewInfoBtnClick()
  local ActivityConfigData = DataMgr.EventMain[self.EventId]
  if not ActivityConfigData.EventRule then
    DebugPrint("ViewInfoBtn Click, EventRule is nil, EventId is", self.EventId)
    return
  end
  local Params = {
    LongText = GText(ActivityConfigData.EventRule)
  }
  UIManager(self):ShowCommonPopupUI(100192, Params, self)
end

function M:SetShowRewardWidget(Widget)
  self.ShowRewardWidget = Widget
  if IsValid(self.ShowRewardWidget) then
    self.ParentWidget:UpdateActivityKeyTips(nil, self.ShowRewardWidget)
  else
    self.ParentWidget:UpdateActivityKeyTips(self.FocusWidgetName, self.FocusWidget)
  end
end

return M
