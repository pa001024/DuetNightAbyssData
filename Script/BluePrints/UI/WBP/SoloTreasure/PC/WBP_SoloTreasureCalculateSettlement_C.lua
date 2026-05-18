require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  EventManager:AddEvent(EventID.GameWindowActionChanged, self, self.OnDrawListviewItem)
  self:InitDeviceInfo()
  self:InitListenEvent()
end

function M:OnLoaded(...)
  self.DungeonSettlementInfo = (...)
  local DungeonId, IsWin, Rewards, DungeonRewards, PlayerTime, GameTime, ClientRes = table.unpack(self.DungeonSettlementInfo, 1, self.DungeonSettlementInfo.n)
  self.SoloTreasureInfo = ClientRes
  if not self.SoloTreasureInfo then
    ScreenPrint("SoloTreasureInfo is nil, use test data !!!!!!!!!!!")
    self.SoloTreasureInfo = {
      ItemList = {},
      Ticket = -1
    }
  end
  self.ItemList = self.SoloTreasureInfo.ItemList
  self.TicketId = self.SoloTreasureInfo.Ticket
  self.SoloTreasureScore = 0
  self:InitText()
  self:InitBtn()
  self:InitTicketInfo()
  self:InitItemListInfo()
  self:FillEmptyItem()
  self:UnbindAllFromAnimationFinished(self.In)
  self:BindToAnimationFinished(self.In, {
    self,
    function()
      self:StartToShowItem()
    end
  })
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_result_panel_open", "CalculateSettlement", nil)
end

function M:OnDrawListviewItem(WindowAction)
  DebugPrint("OnDrawListviewItem:", WindowAction)
  if not self.NeedDraw then
    return
  end
  self:AddTimer(0.1, function()
    if not self.RealShowItemList then
      return
    end
    local TotalScoreBeforeLottery = 0
    for Index, ItemContent in pairs(self.RealShowItemList) do
      DebugPrint("OnDrawListviewItem RealShowItemList:", Index, ItemContent.IsEmpty)
      local Item = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Items, Index - 1)
      Item:LoadItem(ItemContent)
      Item:PlayAnimation(Item.Normal)
      TotalScoreBeforeLottery = TotalScoreBeforeLottery + Item:GetItemRealValue()
    end
    DebugPrint("OnDrawListviewItem SoloTreasureScore:", self.SoloTreasureScore, TotalScoreBeforeLottery)
    TotalScoreBeforeLottery = math.max(TotalScoreBeforeLottery, self.SoloTreasureScore)
    self.Text_TitleNum:SetText(Utils.FormatNumber(TotalScoreBeforeLottery, false))
    self.NeedDraw = false
  end, false, 0.05)
end

function M:FillEmptyItem()
  local RowNum = math.ceil(#self.ItemShowInfo / 5)
  RowNum = math.max(3, RowNum)
  local EmptyItemNums = 5 * RowNum - #self.ItemShowInfo
  for i = 1, 5 * RowNum do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.IsEmpty = true
    self.List_Items:AddItem(Content)
  end
end

function M:StartToShowItem()
  if not self.ItemShowInfo or self.ItemShowInfo and #self.ItemShowInfo < 1 then
    return
  end
  self.CurIndex = 1
  self.RealShowItemList = {}
  self:AddTimer(self.ItemInterval, function()
    if self.CurIndex > #self.ItemShowInfo then
      if not self.TicketId or self.TicketId <= 0 then
        self:RemoveTimer("ShowItem")
        return
      end
      local LotteryInfo = self.TicketId and DataMgr.ExtractionLottery[self.TicketId]
      local AddScore = 0
      self.SoloTreasureScore = 0
      local ScoreExcludeKey = 0
      for Index, ItemContent in pairs(self.RealShowItemList) do
        if self:CheckBuffCondition(ItemContent) then
          self.SoloTreasureScore = self.SoloTreasureScore + ItemContent.Value * ItemContent.BuffRate
        else
          self.SoloTreasureScore = self.SoloTreasureScore + ItemContent.Value
        end
        if 6 ~= ItemContent.Rarity then
          if self:CheckBuffCondition(ItemContent) then
            ScoreExcludeKey = ScoreExcludeKey + ItemContent.Value * ItemContent.BuffRate
          else
            ScoreExcludeKey = ScoreExcludeKey + ItemContent.Value
          end
        end
      end
      if LotteryInfo then
        if 3 == self.TicketType then
          if ScoreExcludeKey >= LotteryInfo.Param[1] then
            AddScore = ScoreExcludeKey * (LotteryInfo.EffectParam - 1)
          end
        elseif 4 == self.TicketType then
          if self:GetItemNumByType("TreasureType", LotteryInfo.Param[1], LotteryInfo.Param[2]) then
            AddScore = ScoreExcludeKey * (LotteryInfo.EffectParam - 1)
          end
        elseif 5 == self.TicketType and self:GetItemNumByType("Rarity", LotteryInfo.Param[1], LotteryInfo.Param[2]) then
          AddScore = ScoreExcludeKey * (LotteryInfo.EffectParam - 1)
        end
      end
      if AddScore > 0 then
        self.WBP_Buff02:PlayAnimation(self.WBP_Buff02.Buff_Add)
        self.SoloTreasureScore = UIUtils.RollingNumberEffect(self, self.Text_TitleNum, self.SoloTreasureScore, AddScore)
      end
      self:RemoveTimer("ShowItem")
    else
      local ItemInfo = self.ItemShowInfo[self.CurIndex]
      if not ItemInfo then
        return
      end
      local Content = {}
      Content.ItemIndex = self.CurIndex
      Content.Icon = ItemInfo.SettlementIcon
      Content.Rarity = ItemInfo.TreasureRarity
      Content.Value = ItemInfo.TreasureValue
      Content.TreasureType = ItemInfo.TreasureType
      Content.BuffRarity = self.TicketRarity
      Content.BuffRate = self.TicketRate
      Content.BuffType = self.TicketType
      Content.BuffParam1 = self.TicketParam1
      Content.BuffParam2 = self.TicketParam2
      Content.Owner = self
      table.insert(self.RealShowItemList, Content)
      if #self.RealShowItemList > 1 then
        table.sort(self.RealShowItemList, function(a, b)
          return a.ItemIndex > b.ItemIndex
        end)
      end
      for Index, value in ipairs(self.RealShowItemList) do
        local Item = self.List_Items:GetItemAt(Index - 1)
        DebugPrint("thy ", Item, Item and Item.SelfWidget)
        if Item and Item.SelfWidget then
          Item.SelfWidget:LoadItem(value)
        else
          self.NeedDraw = true
        end
      end
      local AddScore = 0
      if self.CurWidget then
        AddScore = self.CurWidget:GetItemRealValue()
      end
      self.SoloTreasureScore = UIUtils.RollingNumberEffect(self, self.Text_TitleNum, self.SoloTreasureScore, AddScore)
      self.CurIndex = self.CurIndex + 1
    end
  end, true, 0, "ShowItem", false)
end

function M:CheckBuffCondition(Content)
  if not Content.BuffType then
    return false
  end
  if 6 == Content.Rarity then
    return false
  end
  if 1 == Content.BuffType then
    return Content.Rarity == Content.BuffParam1
  elseif 2 == Content.BuffType then
    return Content.TreasureType == Content.BuffParam1
  else
    return false
  end
end

function M:GetItemNumByType(ItemType, Type1, Type2)
  local ItemNum = 0
  for _, ItemInfo in pairs(self.RealShowItemList) do
    if ItemInfo[ItemType] == Type1 then
      ItemNum = ItemNum + 1
    end
  end
  return Type2 <= ItemNum
end

function M:InitItemListInfo()
  local SoloTreasureData = DataMgr.ExtractionTreasure
  self.List_Items:ClearListItems()
  if not SoloTreasureData then
    return
  end
  self.ItemShowInfo = {}
  for _, ItemId in pairs(self.ItemList) do
    if SoloTreasureData[ItemId] then
      table.insert(self.ItemShowInfo, SoloTreasureData[ItemId])
    end
  end
  if #self.ItemShowInfo > 1 then
    table.sort(self.ItemShowInfo, function(a, b)
      local RaityInfo = DataMgr.ExtractionTreasureRarity
      if RaityInfo[a.TreasureRarity].ShowRarity == RaityInfo[b.TreasureRarity].ShowRarity then
        return a.TreasureValue < b.TreasureValue
      end
      return RaityInfo[a.TreasureRarity].ShowRarity < RaityInfo[b.TreasureRarity].ShowRarity
    end)
  end
end

function M:InitTicketInfo()
  if not self.TicketId or self.TicketId <= 0 then
    self.WBP_Buff02:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  local TicketInfo = DataMgr.ExtractionLottery[self.TicketId]
  if TicketInfo then
    self.TicketRarity = TicketInfo.Quality
    self.TicketRate = TicketInfo.EffectParam
    self.TicketType = TicketInfo.LotteryType
    self.TicketParam1 = TicketInfo.Param[1]
    self.TicketParam2 = TicketInfo.Param[2]
    self.TicketDesc = TicketInfo.Desc
    self:UpdateBuffUI()
  else
    self.WBP_Buff02:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:UpdateBuffUI()
  self.WBP_Buff02:SetBuffType(self.TicketRarity - 1)
  self.WBP_Buff02:InitData({
    Description = self.TicketDesc
  })
end

function M:InitBtn()
  self.Btn_Check:SetText(GText("UI_Extraction_TM_29"))
  self.Btn_Check:SetDefaultGamePadImg("A")
  self.Btn_Check.Button_Area.OnClicked:Add(self, self.LoadRealSettlement)
end

function M:LoadRealSettlement()
  AudioManager(self):SetEventSoundParam(self, "CalculateSettlement", {ToEnd = 1})
  UIManager(self):LoadUINew("SoloTreasureEvacuation", self.DungeonSettlementInfo)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  end
  self:Close()
end

function M:InitText()
  self.Text_Title:SetText(GText("UI_Extraction_TM_27"))
  self.Text_TitleNum:SetText("0")
  self.Text_Details:SetText(GText("UI_Extraction_TM_28"))
end

function M:InitDeviceInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDeviceType = CurInputDevice
  self.CurGamepadName = CurGamepadName
  self.IsSwitchDevice = true
  self:UpdateUI()
end

function M:UpdateUI()
  if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard or self.CurInputDeviceType == ECommonInputType.Touch then
    if self.Key_Check_GamePad then
      self.Key_Check_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end
  elseif self.Key_Check_GamePad then
    self.Key_Check_GamePad:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RV"}
      },
      Desc = GText("UI_Controller_Slide")
    })
    self.Key_Check_GamePad:SetVisibility(ESlateVisibility.Visible)
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY and math.abs(UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)) >= 0.5 then
    local DeltaOffset = -1 * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    local CurrentOffset = self.EMScrollBox_0:GetScrollOffset()
    local NextOffset = math.clamp(CurrentOffset + DeltaOffset, 0, self.EMScrollBox_0:GetScrollOffsetOfEnd())
    self.EMScrollBox_0:SetScrollOffset(NextOffset)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
  else
    IsEventHandled = self:Handle_OnPCDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_OnGamePadDown(InKeyName)
  if "Gamepad_FaceButton_Bottom" == InKeyName then
    self:LoadRealSettlement()
    return true
  end
  return false
end

function M:Handle_OnPCDown(InKeyName)
  return false
end

return M
