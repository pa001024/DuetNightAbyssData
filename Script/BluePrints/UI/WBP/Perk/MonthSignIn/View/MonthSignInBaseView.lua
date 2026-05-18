require("UnLua")
local MonthCardModel = require("BluePrints.UI.WBP.Perk.MonthCard.MonthCardModel")
local MonthSignInCommon = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInCommon")
local MonthSignInController = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInController")
local MonthSignInModel = MonthSignInController:GetModel()
local ItemUtil = require("Utils.ItemUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitBaseView()
  self.NowCard = 1
  self:BindReddotTreeEvents()
  self:InitPageView()
  self:BindButtonEvent()
  self:PlayAnimationIn()
end

function M:BindButtonEvent()
  self.Btn_Buy.OnClicked:Add(self, self.OnBuyBtnClicked)
  self.Btn_Buy.OnHovered:Add(self, self.OnBuyBtnHovered)
  self.BtnSwitch.Btn.OnClicked:Add(self, self.OnSwitchBtnClicked)
  self.BtnSwitch.Btn.OnHovered:Add(self, self.OnSwitchBtnHovered)
end

function M:BindReddotTreeEvents()
  ReddotManager.ClearLeafNodeCount(MonthSignInCommon.ReddotName, true)
  ReddotManager.AddListenerEx(MonthSignInCommon.ReddotName, self, function()
    self:UpdateReddot()
  end)
end

function M:UpdateReddot()
  local MonthCheckNode = ReddotManager.GetTreeNode(MonthSignInCommon.ReddotName)
  DebugPrint("Yihan@  UpdateReddot: ", MonthCheckNode)
  if MonthCheckNode then
    local Count = MonthCheckNode.Count
    DebugPrint("Yihan@  UpdateReddot: ", Count)
    if Count > 0 then
      self.Common_Item_Subsize_Reddot_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      self.Common_Item_Subsize_Reddot_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:UnBindReddotTreeEvents()
  ReddotManager.RemoveListener(MonthSignInCommon.ReddotName, self)
end

function M:InitPageView()
  self.Content01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.CardBg01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Content02:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.CardBg02:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.ListCumulative:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:UpdateStaticWidget()
  self:UpdateMonthCardRegionInfo()
  self:UpdateMonthSignInRewardInfo()
  self:UpdateCumulativeRewardInfo()
  self:UpdateCumulativeSignInText()
end

function M:UpdateStaticWidget()
  self.Text_BtnBuy:SetText(GText(MonthSignInCommon.SkinGotoBuy))
  self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.TextTitleCard01:SetText(GText(MonthSignInCommon.MontlyCheckTitle))
  self.TextTitleCard02:SetText(GText(MonthSignInCommon.MontlyCheckTotal))
  local TodayMonth = MonthSignInModel:GetTodayMonth()
  self.TextMonth:SetText(string.format(GText(MonthSignInCommon.MontlyCheckMonth), TodayMonth))
  local TodaySignInDay = MonthSignInModel:GetTodaySignInDay()
  self.TextDate:SetText(string.format(GText(MonthSignInCommon.MontlyCheckDay), TodaySignInDay))
  self.TextDone:SetText(GText(MonthSignInCommon.MontlyCheckCheckDone))
  self.BtnSwitch.Ws_Icon:SetActiveWidgetIndex(0)
  self:IsShowTextDoneAndSwitchBtn()
end

function M:IsShowTextDoneAndSwitchBtn()
  if MonthSignInModel:IsTodaySigned() then
    self.TextDone:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.BtnSwitch:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    self.TextDone:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.BtnSwitch:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:UpdateMonthCardRegionInfo()
  self.TextName:SetText(GText(MonthSignInCommon.MontlyCheckMonthlyCard))
  self.MonthCardReward = MonthCardModel:GetRewardEveryDayItem()
  self:UpdateMonthCardRewardInfo()
end

function M:UpdateMonthCardRewardInfo()
  local MonthCardReward = self.MonthCardReward
  if not MonthCardReward then
    return
  end
  DebugPrint("Yihan@  UpdateMonthCardRewardInfo: ", MonthCardReward, #MonthCardReward)
  local IsHasMonthCard = MonthCardModel:HasMonthCard()
  local IsMonthCardSigned = MonthCardModel:HasGetMonthCardDailyReward()
  for i = 1, #MonthCardReward do
    local Item = self["Item0" .. i]
    local Content = {}
    Content.Id = MonthCardReward[i].ItemId
    Content.ItemType = MonthCardReward[i].ItemType
    Content.Count = MonthCardReward[i].Count
    local ResourceData = DataMgr.Resource[MonthCardReward[i].ItemId]
    Content.Rarity = ResourceData.Rarity
    Content.Icon = ResourceData.Icon
    Content.IsShowDetails = true
    Content.IsSelect = false
    Content.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnMenuOpenChange
    }
    DebugPrint("Yihan@ UpdateMonthCardRewardInfo: ", Content.Id, Content.ItemType, Content.Count, Content.Rarity, Content.Icon)
    DebugPrint("Yihan@ UpdateMonthCardRewardInfo: ", IsHasMonthCard, IsMonthCardSigned)
    if IsHasMonthCard then
      if not IsMonthCardSigned then
        self.TextTime:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Group_BtnBuy:SetVisibility(UE4.ESlateVisibility.Collapsed)
      else
        Content.bHasGot = true
        self.TextTime:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Group_BtnBuy:SetVisibility(UE4.ESlateVisibility.Visible)
        self:PlayAnimation(self.BuyBtn_In)
        self.TextTime:SetText(string.format(GText(MonthSignInCommon.MontlyCheckRemain), MonthCardModel:GetMonthCardLeftTimes()))
      end
    else
      Content.LockType = 1
      if not IsMonthCardSigned then
        self.TextTime:SetText(GText(MonthSignInCommon.MonthlyCardNone))
        self.Group_BtnBuy:SetVisibility(UE4.ESlateVisibility.Visible)
        self:PlayAnimation(self.BuyBtn_In)
      end
    end
    Item:Init(Content)
  end
end

function M:OnGetMonthCardReward(Content)
  DebugPrint("Yihan@ OnGetMonthCardReward: ", Content)
  local Avatar = GWorld:GetAvatar()
  local IsHasMonthCard = MonthCardModel:HasMonthCard()
  local IsGetDailyReward = MonthCardModel:HasGetMonthCardDailyReward()
  if not (Avatar and IsHasMonthCard) or not IsGetDailyReward then
  end
end

function M:OnMenuOpenChange(IsOpen)
  if IsOpen then
    self.Panel_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Panel_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:UpdateMonthSignInRewardInfo()
  self.List:ClearListItems()
  local CurYear = tonumber(os.date("%Y"))
  local CurMonth = tonumber(os.date("%m"))
  local TemplateId = DataMgr.MonthlyCheckConf[CurYear][CurMonth].MonthlyCheckId
  local SignInReward = DataMgr.MonthlyCheck[TemplateId]
  DebugPrint("Yihan@ OnGetMonthSignInReward: ", #SignInReward, CurYear, CurMonth)
  for index = 1, #SignInReward do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local RewardId = SignInReward[index].CheckReward
    local RewardData = DataMgr.Reward[RewardId]
    local ResourceData = DataMgr.Resource[RewardData.Id[1]]
    DebugPrint("Yihan@ OnGetMonthSignInReward: ", RewardData, ResourceData, RewardData.Id[1], RewardData.Count[1][1])
    Content.Id = RewardData.Id[1]
    Content.ItemType = RewardData.Type[1]
    Content.Rarity = ResourceData.Rarity
    Content.Icon = ResourceData.Icon
    Content.bIsImportant = SignInReward[index].IsImportant
    Content.ParentWidget = self
    Content.IsShowDetails = true
    Content.TextDate = SignInReward[index].CheckCount
    Content.Count = RewardData.Count[1][1]
    Content.NotInteractive = true
    Content.HandleMouseDown = true
    Content.bIsGet = MonthSignInModel:IsGetSignRewardByDay(Content.TextDate)
    if index == MonthSignInModel:GetTodaySignInDay() and not Content.bIsGet then
      self.GetRewardTimer = self:AddTimer(0.6, function()
        self:OnGetMonthSignInReward(Content)
        self:RemoveTimer("TimeToGetMonthSignInReward")
      end, false, 0, "TimeToGetMonthSignInReward")
    end
    Content.bIsResetFocus = true
    self.List:AddItem(Content)
  end
  self.List:RequestPlayEntriesAnim()
end

function M:OnGetMonthSignInReward(Content)
  DebugPrint("Yihan@ OnGetMonthSignInReward: ", Content.TextDate, MonthSignInModel:IsTodaySigned())
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:MonthlyCheckGetReward(Content.TextDate, function(ret, RewardList)
      if ErrorCode:Check(ret) then
        self:PlayGetAnimation(Content, RewardList)
      end
    end)
  end
end

function M:PlayGetAnimation(Content, RewardList)
  if self.bIsInGetAnimation then
    return
  end
  self.bIsInGetAnimation = true
  local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List, self.List:GetIndexForItem(Content))
  DebugPrint("Yihan@ PlayGetAnimation ", CurWidget)
  if CurWidget then
    CurWidget:PlayAnimation(CurWidget.GetNow)
  end
  self:AddTimer(1.0, function()
    self:ShowGetItemPage(RewardList)
    Content.bIsGet = true
    Content.bIsCanGet = false
    self:UpdateCumulativeRewardInfo()
    self.bIsInGetAnimation = false
    self:IsShowTextDoneAndSwitchBtn()
    self:RemoveTimer("TimeToShowGetItemUI")
  end, false, 0, "TimeToShowGetItemUI")
end

function M:ShowGetItemPage(RewardList)
  DebugPrint("Yihan@ ShowGetItemPage", RewardList, #RewardList)
  UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardList, false, function()
    local Item = self.List:GetItemAt(MonthSignInModel:GetTodaySignInDay() - 1)
    Item.SelfWidget:SetFocus()
  end, self, true)
end

function M:UpdateCumulativeSignInText()
  local CumulativeSignInDay = MonthSignInModel:GetCumulativeSignInDay()
  self.TextCumulative:SetText(string.format(GText(MonthSignInCommon.MontlyCheckTotalDone), CumulativeSignInDay))
end

function M:UpdateCumulativeRewardInfo()
  DebugPrint("Yihan@ UpdateCumulativeRewardInfo")
  ReddotManager.ClearLeafNodeCount(MonthSignInCommon.ReddotName, true)
  self.ListCumulative:ClearListItems()
  local CurYear = tonumber(os.date("%Y"))
  local CurMonth = tonumber(os.date("%m"))
  local TemplateId = DataMgr.MonthlyCheckConf[CurYear][CurMonth].TotalCheckId
  local CumulativeReward = DataMgr.TotalCheck[TemplateId]
  self.NeedNavigateTo = #CumulativeReward - 1 or 0
  for index = 1, #CumulativeReward do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local RewardId = CumulativeReward[index].CheckReward
    local RewardData = DataMgr.Reward[RewardId]
    Content.Id = RewardData.Id[1]
    Content.ItemType = RewardData.Type[1]
    Content.Count = RewardData.Count[1]
    Content.Step = CumulativeReward[index].Step
    Content.TargetDay = CumulativeReward[index].CheckCount
    Content.bIsEmpty = false
    Content.ParentWidget = self
    Content.ConditionListData = {}
    local bIsCanReceive = true
    local bIsFinish = true
    if MonthSignInModel:GetCumulativeSignInDay() < CumulativeReward[index].CheckCount then
      bIsFinish = false
    end
    if MonthSignInModel:GetCumulativeSignInDay() < CumulativeReward[index].CheckCount or MonthSignInModel:IsGetCumulativeReward(Content.Step) then
      bIsCanReceive = false
    end
    table.insert(Content.ConditionListData, {
      ConditionText = MonthSignInCommon.MontlyCheckTotalCondition1,
      Target = CumulativeReward[index].CheckCount,
      Mine = MonthSignInModel:GetCumulativeSignInDay()
    })
    local ConditionLIst = CumulativeReward[index].Condition
    if ConditionLIst then
      for i = 1, #ConditionLIst do
        local Target = 180
        local Mine = 1
        if Target > Mine then
          bIsFinish = false
        end
        table.insert(Content.ConditionListData, {
          ConditionText = MonthSignInCommon.MontlyCheckTotalCondition2,
          Target = 180,
          Mine = 1
        })
      end
    end
    if not bIsFinish then
      self.NeedNavigateTo = math.min(index - 1, self.NeedNavigateTo)
    end
    DebugPrint("Yihan@ UpdateCumulativeRewardInfo", bIsCanReceive)
    self:IncreaseReddotCount(bIsCanReceive)
    self.ListCumulative:AddItem(Content)
  end
  local EmptyContent = NewObject(UIUtils.GetCommonItemContentClass())
  EmptyContent.bIsEmpty = true
  self.ListCumulative:AddItem(EmptyContent)
  self.ListCumulative:RequestPlayEntriesAnim()
end

function M:IncreaseReddotCount(bIsCanReceive)
  if bIsCanReceive then
    ReddotManager.IncreaseLeafNodeCount(MonthSignInCommon.ReddotName)
  end
end

function M:UpdateMonthardPurchased()
  local bIsMonthCardPurchased = MonthCardModel:IsMonthCardPurchased()
  if bIsMonthCardPurchased then
    self.Group_BtnBuy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Group_BtnBuy:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:UpdatePrice()
  local MonthCardPrice = MonthCardModel:GetMonthCardPrice()
  local PriceSymbol = MonthCardModel:GetPriceSymbol()
  self.Text_PriceNum:SetText(MonthCardPrice)
  self.Text_PriceNum_Symbol:SetText(PriceSymbol)
end

function M:OnBuyBtnClicked()
  DebugPrint("Yihan@ OnBuyBtnClicked: ", MonthCardModel:GetNowMonthCard(), MonthCardModel:IsMonthCardCanPurchase())
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", nil, nil)
  if not MonthCardModel:GetNowMonthCard() and not MonthCardModel:IsMonthCardCanPurchase() then
    self:OnBuyBtnClickedForbid()
    return
  end
  self:AddTimer(0.3, function()
    PageJumpUtils:JumpToShopPage(MonthSignInCommon.ShopJumpIndex, nil, nil, "Shop")
  end)
end

function M:OnBuyBtnHovered()
  AudioManager(self):PlayUISound(self, "event:/ui/common/hover_btn_large_crystal", nil, nil)
end

function M:OnBuyBtnClickedForbid()
  MonthCardController:DisplayForbiddenTip()
end

function M:OnSwitchBtnClicked()
  DebugPrint("Yihan@ OnSwitchBtnClicked: ", self.NowCard)
  if self.IsInSwitching then
    return
  end
  self.IsInSwitching = true
  if 1 == self.NowCard then
    self:PlayAnimation(self.Card02_In)
    self.NowCard = 2
  else
    self:PlayAnimation(self.Card02_Out)
    self.NowCard = 1
  end
  self.BtnSwitch.Ws_Icon:SetActiveWidgetIndex(self.NowCard - 1)
end

function M:OnSwitchBtnHovered()
end

function M:RefreshPageView()
  self:UpdateStaticWidget()
  self:UpdateMonthardPurchased()
  self:UpdatePrice()
  self:UpdatePurchaseState()
  self:UpdateMonthCardSaleTime()
  self.Btn_Info.Btn_Click:SetChecked(false)
  self.Btn_CardRefresh.Btn_Click:SetChecked(false)
  self.HandleAKeyDown = nil
end

function M:NotifyTimeTick()
end

function M:NotifyMonthCardRefresh()
  self:RefreshPageView()
end

function M:NotifyPurchasedRefresh()
  self:UpdateMonthardPurchased()
end

function M:NotifyPurchaseStateRefresh()
end

function M:OnViewClose()
  self:UnBindReddotTreeEvents()
  if self.GetRewardTimer then
    self:RemoveTimer(self.GetRewardTimer)
  end
  self:PlayAnimationOut()
end

function M:PlayAnimationIn()
  DebugPrint("Yihan@ PlayAnimationIn: ")
  self:PlayAnimation(self.In)
  self:PlayAnimation(self.SwitchBtn_In)
  self.IsInAnimation = true
end

function M:PlayAnimationOut()
  self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.In then
    self.IsInAnimation = false
  elseif InAnimation == self.Card02_In or InAnimation == self.Card02_Out then
    self.IsInSwitching = false
  end
end

AssembleComponents(M)
return M
