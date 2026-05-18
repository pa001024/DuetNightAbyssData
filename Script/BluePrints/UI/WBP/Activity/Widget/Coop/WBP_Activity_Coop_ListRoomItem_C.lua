require("UnLua")
local WBP_Activity_Coop_ListRoomItem_C = Class({
  "BluePrints.UI.BP_UIState_C"
})

function WBP_Activity_Coop_ListRoomItem_C:Construct()
  self.TextReward:SetText(GText("UI_AsyncCombat_RewardRate"))
  self.TextLevel:SetText(GText("UI_AsyncCombat_Difficulty"))
  self.TextPeople:SetText(GText("UI_AsyncComcast_Headcount"))
  self.TextCd:SetText(GText("UI_AsyncCombat_RoomCoolDown"))
  self.Btn_Reward.Button.OnClicked:Add(self, self.OnBtnRewardClicked)
  self.Btn_Go.Button.OnClicked:Add(self, self.OnBtnGoClicked)
  self.Btn_Ranking.Button.OnClicked:Add(self, self.OnBtnRankingClicked)
  self.Icon.Btn.OnClicked:Add(self, function()
    self.Icon.WBP_Com_ItemIcon:OnMouseButtonUp()
  end)
  self:InitKeyInfo()
end

function WBP_Activity_Coop_ListRoomItem_C:Destruct()
  self.RoomData = nil
  self:RemoveTimer("UpdateShopItemEndRefreshTime")
end

function WBP_Activity_Coop_ListRoomItem_C:OnFaceButtonBottomClick()
  if self.Content.IsEmpty then
    return
  end
  if 0 == self.RoomState then
    self:OnBtnRewardClicked()
  elseif 1 == self.RoomState then
    self:OnBtnGoClicked()
  elseif 2 == self.RoomState then
    self:OnBtnRankingClicked()
  end
end

function WBP_Activity_Coop_ListRoomItem_C:OnBtnRewardClicked()
  self.Content.CoopModel:AsyncCombatClaimReward({
    self.RoomData.RoomUniqueId
  }, function(Err, AllRewards)
    if Err == ErrorCode.RET_SUCCESS then
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, AllRewards, false, nil, self, false)
      self.RoomData.RewardState = 2
      self:RefreshWsBtnState()
      ReddotManager.DecreaseLeafNodeCount(self.ReddotNodeName, 1, {CacheKey = "Red"})
    end
  end)
end

function WBP_Activity_Coop_ListRoomItem_C:OnBtnGoClicked()
  local RoomData = self.RoomData
  if RoomData and RoomData.RoomUniqueId then
    self.Content.JoinRoomCallback(RoomData.RoomUniqueId)
  end
end

function WBP_Activity_Coop_ListRoomItem_C:OnBtnRankingClicked()
  local RoomData = self.RoomData
  if not RoomData then
    return
  end
  self.Content.CoopModel:AsyncCombatGetRoomRankData(RoomData, function(SelfRankInfo, TopNInfo, RankingRoomData)
    UIManager(self):LoadUINew("CoopRank", SelfRankInfo, TopNInfo, RankingRoomData)
  end)
end

function WBP_Activity_Coop_ListRoomItem_C:OnListItemObjectSet(Content)
  Content.Widget = self
  self.ParentWidget = Content.ParentWidget
  self.Content = Content
  if Content.IsEmpty then
    self.IsEmpty = true
    self.bIsFocusable = false
    self.Ws_Panel:SetActiveWidgetIndex(1)
    return
  else
    self.IsEmpty = false
    self.Ws_Panel:SetActiveWidgetIndex(0)
  end
  self.RoomData = Content.RoomData
  self.ReddotNodeName = Content.ReddotNodeName
  self:SetUsingGamepad(false)
  local RoomData = self.RoomData
  local RoomCfg = DataMgr.AsyncCombat[RoomData.RoomConfId]
  local Level = RoomCfg.Level
  local RateResData = DataMgr.Resource[RoomData.RateResId]
  self.Tag_Reward.TextNum:SetText(string.format("+%d%%", RateResData.UseParam / 100))
  local AnimationName = Content.CoopModel:GetRewardAnimationByDifficultyId(RoomData.RateResId)
  self.Tag_Reward:PlayAnimation(self.Tag_Reward[AnimationName])
  self.TextLv:SetText(GText("UI_LEVEL_NAME") .. Level)
  local RoomNumberLimitCount = DataMgr.AsyncCombatEventConstant.AsyncCombat_RoomCapacityLimit.ConstantValue
  if RoomData.MemberCount == RoomNumberLimitCount then
    self.TextPeopleNum:SetText(string.format("<Highlight>%d</>/%d", RoomData.MemberCount, RoomNumberLimitCount))
  else
    self.TextPeopleNum:SetText(string.format("%d/%d", RoomData.MemberCount, RoomNumberLimitCount))
  end
  self:InitReward()
  self:RefreshWsBtnState()
  self:UpdateCDState()
  self:UpdateRoomInfo()
  self:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    self.HandleNavigationUp
  })
  self:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    self.HandleNavigationDown
  })
end

function WBP_Activity_Coop_ListRoomItem_C:RefreshWsBtnState()
  local RoomData = self.RoomData
  if not RoomData then
    return
  end
  local CreateTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(RoomData.CreateTime or 0)
  local CurTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
  local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(CurTime, CreateTime)
  local elapsedSeconds = UKismetMathLibrary.GetTotalSeconds(RemainTime)
  local MaxDurationSeconds = DataMgr.AsyncCombatEventConstant.AsyncCombat_RoomDuration.ConstantValue * 60
  if elapsedSeconds >= MaxDurationSeconds then
    RoomData.IsPass = true
  end
  if RoomData.IsPass == true then
    if 1 == RoomData.RewardState then
      self.RoomState = 0
      self.Ws_Btn:SetActiveWidgetIndex(0)
    else
      self.RoomState = 1
      self.Ws_Btn:SetActiveWidgetIndex(2)
    end
    self.TextNum:SetText("")
    self.TextState:SetText(GText("UI_AsyncCombat_ChallengeEnd"))
  else
    self.RoomState = 1
    self.Ws_Btn:SetActiveWidgetIndex(1)
    self.TextState:SetText(GText("UI_AsyncCombat_RemainProgress"))
    local LastProgress = 100 - RoomData.Progress
    if LastProgress <= 10 then
      self.TextNum:SetText("<Highlight>" .. LastProgress .. "%</>")
    else
      self.TextNum:SetText(LastProgress .. "%")
    end
  end
end

function WBP_Activity_Coop_ListRoomItem_C:InitReward()
  local RoomData = self.RoomData
  local RoomCfg = DataMgr.AsyncCombat[RoomData.RoomConfId]
  local RewardData = DataMgr.Resource[RoomCfg.ID]
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Id = RewardData.ResourceId
  Content.Icon = RewardData.Icon
  Content.ItemType = "Resource"
  Content.UIName = RewardData.ResourceName
  Content.Rarity = RewardData.Rarity
  Content.IsShowDetails = true
  Content.ParentWidget = self
  Content.bIsResetFocus = true
  self.Icon.WBP_Com_ItemIcon:Init(Content)
  self.Icon.TextNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Icon.Img_Quality:SetBrush(self.Icon["Color_0" .. RewardData.Rarity - 1])
  self.Icon.WBP_Com_ItemIcon:BindEvents(self, {
    OnMenuOpenChanged = self.OnStuffMenuOpenChanged
  })
end

function WBP_Activity_Coop_ListRoomItem_C:OnStuffMenuOpenChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  if not self.ParentWidget then
    return
  end
  if self.ParentWidget.MenuOpenChanged then
    self.ParentWidget:MenuOpenChanged(bIsOpen)
  end
end

function WBP_Activity_Coop_ListRoomItem_C:RefreshRoomData(RoomUniId, IsPass, RewardState)
  if self.IsEmpty then
    return
  end
  local RoomData = self.RoomData
  if not RoomData then
    return
  end
  if RoomData.RoomUniqueId ~= RoomUniId then
    return
  end
  self.RoomData.IsPass = IsPass
  self.RoomData.RewardState = RewardState
  self:RefreshWsBtnState()
end

function WBP_Activity_Coop_ListRoomItem_C:UpdateRoomInfo()
  local RoomData = self.RoomData
  if not RoomData then
    return
  end
  local IsOwnedRoom = self.Content.CoopModel:CheckIsInRoomByRoomUniqueID(RoomData.RoomUniqueId)
  if false == IsOwnedRoom then
    self.Ws_Tag:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  else
    self.Ws_Tag:SetVisibility(UE4.ESlateVisibility.Visible)
  end
  if RoomData.IsMaster == true then
    self.Tag_Room.TextTag:SetText(GText("UI_AsyncCombat_Host"))
    self.Ws_Tag:SetActiveWidgetIndex(0)
  elseif true == RoomData.IsMvp then
    self.Tag_Mvp.TextTag:SetText(GText("UI_AsyncCombat_MVP"))
    self.Ws_Tag:SetActiveWidgetIndex(1)
  else
    self.Tag_My.TextTag:SetText(GText("UI_AsyncCombat_Player"))
    self.Ws_Tag:SetActiveWidgetIndex(2)
  end
end

function WBP_Activity_Coop_ListRoomItem_C:UpdateCDState()
  local RoomData = self.RoomData
  if not RoomData then
    self.Ws_State_Cd:SetActiveWidgetIndex(1)
    return
  end
  if not RoomData.EnterRoomCD then
    self.Ws_State_Cd:SetActiveWidgetIndex(1)
    return
  end
  if RoomData.IsPass == true then
    self.Ws_State_Cd:SetActiveWidgetIndex(1)
    return
  end
  if TimeUtils.NowTime() < RoomData.EnterRoomCD then
    self.Ws_State_Cd:SetActiveWidgetIndex(0)
    self:AddTimer(1, self.UpdateLimitTime, true, 0, "UpdateShopItemEndRefreshTime", true)
    self:UpdateLimitTime()
  else
    self.Ws_State_Cd:SetActiveWidgetIndex(1)
  end
end

function WBP_Activity_Coop_ListRoomItem_C:UpdateLimitTime()
  local RoomData = self.RoomData
  if not RoomData then
    self.Ws_State_Cd:SetActiveWidgetIndex(1)
    self:RemoveTimer("UpdateShopItemEndRefreshTime")
    return
  end
  if not RoomData.EnterRoomCD then
    self.Ws_State_Cd:SetActiveWidgetIndex(1)
    self:RemoveTimer("UpdateShopItemEndRefreshTime")
    return
  end
  if RoomData.IsPass == true then
    self.Ws_State_Cd:SetActiveWidgetIndex(1)
    self:RemoveTimer("UpdateShopItemEndRefreshTime")
    return
  end
  if TimeUtils.NowTime() <= RoomData.EnterRoomCD then
    self.Ws_State_Cd:SetActiveWidgetIndex(0)
    local StartTiem = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
    local EndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(RoomData.EnterRoomCD)
    local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(EndTime, StartTiem)
    local RemainTimeStr = ""
    local TimeCount = 0
    if UKismetMathLibrary.GetDays(RemainTime) > 0 then
      TimeCount = TimeCount + 1
      RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_DAY"), UKismetMathLibrary.GetDays(RemainTime))
    end
    if UKismetMathLibrary.GetHours(RemainTime) > 0 or 1 == TimeCount then
      TimeCount = TimeCount + 1
      RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_HOUR"), UKismetMathLibrary.GetHours(RemainTime))
    end
    if UKismetMathLibrary.GetMinutes(RemainTime) > 0 and TimeCount < 2 or 1 == TimeCount then
      TimeCount = TimeCount + 1
      RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_MINUTE"), UKismetMathLibrary.GetMinutes(RemainTime))
    end
    if UKismetMathLibrary.GetSeconds(RemainTime) > 0 and TimeCount < 2 or 1 == TimeCount then
      TimeCount = TimeCount + 1
      RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_SECOND"), UKismetMathLibrary.GetSeconds(RemainTime))
    end
    self.TextTime:SetText(string.format(GText("UI_SHOP_REMAINTIME"), RemainTimeStr))
  else
    self.Ws_State_Cd:SetActiveWidgetIndex(1)
    self:RemoveTimer("UpdateShopItemEndRefreshTime")
  end
end

function WBP_Activity_Coop_ListRoomItem_C:SetUsingGamepad(UsingGamepad)
  if not UsingGamepad then
    self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self.UsingGamepad = UsingGamepad
  if self.UsingGamepad then
    self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Visible)
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
  else
    self.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
  end
end

function WBP_Activity_Coop_ListRoomItem_C:InitKeyInfo()
  self.WBP_Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {ImgShortPath = "A", Type = "Img"}
    },
    bLongPress = false
  })
end

function WBP_Activity_Coop_ListRoomItem_C:HandleNavigationUp()
  if not self.Content or not self.RoomData then
    return self
  end
  local Contents = self.ParentWidget.ShowList
  local PrevContent = Contents and Contents[self.Content.Index - 1]
  if not PrevContent then
    return self
  end
  local PrevIndex = self.Content.Index - 2
  self.ParentWidget.ListRoom:NavigateToIndex(PrevIndex)
  return PrevContent.Widget
end

function WBP_Activity_Coop_ListRoomItem_C:HandleNavigationDown()
  if not (self.Content and self.Content.Index) or not self.ParentWidget then
    return self
  end
  local Contents = self.ParentWidget.ShowList
  local NextContent = Contents and Contents[self.Content.Index + 1]
  if not NextContent then
    return self
  end
  local NextIndex = self.Content.Index
  self.ParentWidget.ListRoom:NavigateToIndex(NextIndex)
  return NextContent.Widget
end

return WBP_Activity_Coop_ListRoomItem_C
