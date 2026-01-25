require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitParams(Params)
  self.Params = Params
  self.Btn_Exit.Button_Area.OnClicked:Add(self, self.OnExitClicked)
  self.Btn_Continue.Button_Area.OnClicked:Add(self, self.OnContinueClicked)
  self:InitUI()
  if Params.IsWin then
    self:PlayAnimation(self.In)
    if self.EventSettlementPage and self.EventSettlementPage.WinSound then
      AudioManager(self):PlayUISound(self, self.EventSettlementPage.WinSound, "ActivitySettlement", nil)
    end
  else
    self:PlayAnimation(self.Fail_In)
    if self.EventSettlementPage and self.EventSettlementPage.FailSound then
      AudioManager(self):PlayUISound(self, self.EventSettlementPage.FailSound, "ActivitySettlement", nil)
    end
  end
  if Params.IsNewRecord and self.EventSettlementPage and self.EventSettlementPage.NewRecordSound then
    AudioManager(self):PlayUISound(self, self.EventSettlementPage.NewRecordSound, "ActivitySettlement", nil)
  end
  self:AddTimer(0.1, function()
    self:SetFocus()
  end)
  self.RemainTime = 100
  self:AddTimer(1, self.CountDown, true, -1, "ActivitySettlementCountDown")
  self:SetupGamepadControls()
  self:UpdateBottomKeyInfo(false)
end

function M:CountDown()
  local Text = string.format(GText("UI_Text_ExitTime"), self.RemainTime)
  self.Text_ExitTime:SetText(Text)
  if self.RemainTime <= 0 then
    self:OnExitClicked()
    self:RemoveTimer("ActivitySettlementCountDown")
  end
  self.RemainTime = self.RemainTime - 1
end

function M:InitUI()
  local EventSettlementPage = DataMgr.EventSettlementPage[1]
  for Id, ConfigData in pairs(DataMgr.EventSettlementPage) do
    if ConfigData.EventId == self.Params.ActivityId and ConfigData.DungeonId == self.Params.DungeonId then
      EventSettlementPage = ConfigData
    end
  end
  self.EventSettlementPage = EventSettlementPage
  if not EventSettlementPage then
    return
  end
  if self.Params.Text_TotalScore then
    if self.Text_TotalScore then
      self.Text_TotalScore:SetText(GText(EventSettlementPage.DungeonPassTitle))
    end
  elseif self.Text_TotalScore then
    self.Text_TotalScore:SetText(GText("UI_SettlementPage_TotalScore"))
  end
  if self.Params.LevelScore then
    self.Text_NewRecord:SetText(GText("UI_SettlementPage_NewRecord"))
    if self.Params.IsNewRecord then
      self.Text_NewRecord:SetVisibility(UE4.ESlateVisibility.Visible)
    else
      self.Text_NewRecord:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if self.Params.TimeRemain == nil then
      self.Num_Score:SetText(self.Params.LevelScore)
    end
  end
  if self.Cost and self.Params.CostParams then
    if self.Panel_Cost then
      self.Panel_Cost:SetVisibility(UE4.ESlateVisibility.Visible)
    else
      self.Panel_Cost:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Params.CostParams.Owner = self
    self.Params.CostParams.ItemMenuAnchorChangedCallback = self.ItemMenuAnchorChanged
    self.Params.CostParams.KeyIconName = "RS"
    self.Cost:InitContent(self.Params.CostParams)
  end
  if self.Params.TimeRemain then
    self.Num_Time:SetText(string.format("%d:%02d", math.floor(self.Params.TimeRemain / 60), self.Params.TimeRemain % 60))
    self.Num_Time:SetVisibility(UE4.ESlateVisibility.Visible)
    self.VB_Time:SetVisibility(UE4.ESlateVisibility.Visible)
  elseif self.Num_Time then
    self.Num_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.VB_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.Text_TotalTime then
    self.Text_TotalTime:SetText(GText("RaidDungeon_Time_Remain"))
  end
  if self.Text_Return then
    self.Text_Return:SetText(GText("UI_Refund"))
    if self.Params and self.Params.IsShowReturnText and self.Panel_Return then
      self.Panel_Return:SetVisibility(UE4.ESlateVisibility.Visible)
    else
      self.Panel_Return:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  if self.Text_Title then
    if self.Params.IsWin then
      self.Text_Title:SetText(GText("EventDungeonPass_Title1"))
      if self.Text_Title_1 then
        self.Text_Title_1:SetText(GText("EventDungeonPass_Title1"))
      end
    else
      self.Text_Title:SetText(GText("EventDungeonPass_Title2"))
      if self.Text_Title_1 then
        self.Text_Title_1:SetText(GText("EventDungeonPass_Title2"))
      end
    end
  end
  if self.Params.TitleColor and self.Text_Title then
    self.Text_Title:SetColorAndOpacity(self.Params.TitleColor)
  end
  if self.Params.ScoreLineColor and self.Line then
    self.Line:SetBrushTintColor(self.Params.ScoreLineColor)
  end
  local RewardWidget = self.Settlement_RewardItem
  if RewardWidget then
    if self.Params.RewardIds then
      RewardWidget:SetVisibility(UE4.ESlateVisibility.Visible)
      for _, rewardId in ipairs(self.Params.RewardIds) do
        local RewardInfo = DataMgr.Reward[rewardId]
        if RewardInfo then
          local Ids = RewardInfo.Id or {}
          local RewardCount = RewardInfo.Count or {}
          local TableName = RewardInfo.Type or {}
          for i = 1, #Ids do
            self.CanFocusList = true
            local ItemId = Ids[i]
            local Count = RewardUtils:GetCount(RewardCount[i])
            local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
            local ItemType = TableName[i]
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Count = Count
            Content.Id = ItemId
            Content.Icon = DataMgr[ItemType][ItemId].Icon
            Content.ItemType = ItemType
            Content.Rarity = Rarity
            Content.IsShowDetails = true
            Content.OnMenuOpenChangedEvents = {
              Obj = self,
              Callback = self.ItemMenuAnchorChanged
            }
            RewardWidget.List_Reward:AddItem(Content)
          end
        end
      end
      if RewardWidget.Text_GetReward then
        if self.Params.Text_GetReward and RewardWidget.Text_GetReward then
          RewardWidget.Text_GetReward:SetText(GText(self.Params.Text_GetReward))
        else
          RewardWidget.Text_GetReward:SetText(GText("UI_COMMON_REWARD"))
        end
      end
    elseif self.Params.RewardsInfo then
      local RewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
      local RewardType = DataMgr.RewardType
      local hasReward = false
      for ItemType, RewardTypeValue in pairs(RewardType) do
        if not RewardTypeValue.DungeonRewardType then
        else
          local Rewards = self.Params.RewardsInfo[ItemType .. "s"]
          if Rewards then
            hasReward = true
            local RewardInfo = DataMgr[ItemType]
            for ItemId, ItemCount in pairs(Rewards) do
              self.CanFocusList = true
              local count = 0
              if type(ItemCount) == "table" then
                count = RewardBox:GetCount(ItemCount)
              elseif type(ItemCount) == "number" then
                count = ItemCount
              end
              local Rarity = ItemUtils.GetItemRarity(ItemId, ItemType)
              local Content = NewObject(UIUtils.GetCommonItemContentClass())
              Content.Count = count
              Content.Id = ItemId
              Content.Icon = DataMgr[ItemType][ItemId].Icon
              Content.ItemType = ItemType
              Content.Rarity = Rarity
              Content.IsShowDetails = true
              Content.OnMenuOpenChangedEvents = {
                Obj = self,
                Callback = self.ItemMenuAnchorChanged
              }
              RewardWidget.List_Reward:AddItem(Content)
            end
          end
        end
      end
      if hasReward then
        RewardWidget:SetVisibility(UE4.ESlateVisibility.Visible)
      else
        RewardWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
      if RewardWidget.Text_GetReward then
        if self.Params.Text_GetReward and RewardWidget.Text_GetReward then
          RewardWidget.Text_GetReward:SetText(GText(self.Params.Text_GetReward))
        else
          RewardWidget.Text_GetReward:SetText(GText("UI_COMMON_REWARD"))
        end
      end
    else
      RewardWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  self:InitScoreInfo(self.Params.ScoreInfo, self.List_ScoreItem)
  if self.Params.Btn_Exit_Text and self.Btn_Exit.Text_Button then
    self.Btn_Exit:SetText(GText(self.Params.Btn_Exit_Text))
  else
    self.Btn_Exit:SetText(GText("UI_CTL_Quit"))
  end
  if self.Params.Btn_Continue_Text and self.Btn_Continue.Text_Button then
    self.Btn_Continue:SetText(GText(self.Params.Btn_Continue_Text))
  else
    self.Btn_Continue:SetText(GText("UI_TEMPLE_RESTART"))
  end
  if self.Params.IsWin then
    if EventSettlementPage.IsShowTitle then
      self.Panel_Title:SetVisibility(UE4.ESlateVisibility.Visible)
    else
      self.Panel_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if EventSettlementPage.IsShowScore then
      self.VB_Score:SetVisibility(UE4.ESlateVisibility.Visible)
    else
      self.VB_Score:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if EventSettlementPage.IsShowCondition then
      self.List_ScoreItem:SetVisibility(UE4.ESlateVisibility.Visible)
    else
      self.List_ScoreItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if EventSettlementPage.IsShowReward then
      self.Settlement_RewardItem:SetVisibility(UE4.ESlateVisibility.Visible)
    else
      self.Settlement_RewardItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:Play_In()
  self:PlayScoreAndTimeAnimation()
end

function M:PlayScoreAndTimeAnimation()
  local animationDuration = 1.0
  local startTime = UE4.UGameplayStatics.GetTimeSeconds(self)
  local targetScore = self.Params.LevelScore
  local startTimeRemain = self.Params.TimeRemain
  self.Num_Score:SetText("0")
  self.Num_Time:SetText(string.format("%d:%02d", math.floor(startTimeRemain / 60), startTimeRemain % 60))
  if self.ScoreAnimationTimer then
    self:RemoveTimer(self.ScoreAnimationTimer)
    self.ScoreAnimationTimer = nil
  end
  self.ScoreAnimationTimer = self:AddTimer(0.016, function()
    local currentTime = UE4.UGameplayStatics.GetTimeSeconds(self)
    local elapsedTime = currentTime - startTime
    local progress = math.min(elapsedTime / animationDuration, 1.0)
    local currentScore = math.floor(targetScore * progress)
    self.Num_Score:SetText(tostring(currentScore))
    local currentTimeRemain = math.floor(startTimeRemain * (1.0 - progress))
    self.Num_Time:SetText(string.format("%d:%02d", math.floor(currentTimeRemain / 60), currentTimeRemain % 60))
    if progress >= 1.0 then
      self.Num_Score:SetText(tostring(targetScore))
      self.Num_Time:SetText("0:00")
      self:RemoveTimer(self.ScoreAnimationTimer)
      self.ScoreAnimationTimer = nil
    end
  end, true, -1, "ScoreAndTimeAnimation")
end

function M:ItemMenuAnchorChanged(IsOpen)
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.IsOpenItemMenu = IsOpen
  if IsOpen then
    local BottomKeyInfo = {}
    self.Key_GamePad:UpdateKeyInfo(BottomKeyInfo)
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    if self.IsFocusRewardList then
      local RewardWidget = self.Settlement_RewardItem
      if RewardWidget and RewardWidget.List_Reward then
        RewardWidget.List_Reward:SetFocus()
      end
    elseif self.IsFocusCost and self.Cost then
      self.Cost:SetFocus()
    end
    self:UpdateBottomKeyInfo(true)
  end
end

function M:InitScoreInfo(ScoreInfo, ListWidget)
  if ScoreInfo then
    local IsMobile = ModController:IsMobile()
    ListWidget:ClearListItems()
    for i, item in ipairs(ScoreInfo) do
      local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
      ItemContent.Text = GText(item.text)
      ItemContent.IsFinish = item.isFinish
      ItemContent.IsMobile = IsMobile
      ItemContent.ParentWidget = self
      ItemContent.Idx = i
      ListWidget:AddItem(ItemContent)
    end
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local isHandle = false
  if self.IsFocusList then
    if "Gamepad_FaceButton_Right" == InKeyName then
      if self.IsOpenItemMenu then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
      end
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
      self.IsFocusList = false
      self.IsFocusRewardList = false
      self.IsFocusCost = false
      local RewardWidget = self.Settlement_RewardItem
      if RewardWidget and RewardWidget.Key_GamePad then
        RewardWidget.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
      end
      self.Btn_Exit:SetGamePadVisibility(UE4.ESlateVisibility.Visible)
      self.Btn_Continue:SetGamePadVisibility(UE4.ESlateVisibility.Visible)
      self:UpdateBottomKeyInfo(false)
      isHandle = true
    end
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    self:OnExitClicked()
    isHandle = true
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    self:OnContinueClicked()
    isHandle = true
  elseif "Gamepad_LeftThumbstick" == InKeyName then
    if not self.CanFocusList then
      return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    local RewardWidget = self.Settlement_RewardItem
    if RewardWidget and RewardWidget.List_Reward then
      RewardWidget.List_Reward:SetFocus()
    end
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    self.IsFocusList = true
    self.IsFocusRewardList = true
    if RewardWidget and RewardWidget.Key_GamePad then
      RewardWidget.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.Btn_Exit:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Continue:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
    self:UpdateBottomKeyInfo(true)
    isHandle = true
  end
  if isHandle then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnExitClicked()
  self:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  Avatar:ExitDungeonSettlement()
  EventManager:AddEvent(EventID.OnExitDungeon, self, self.DefaultExit)
end

function M:DefaultExit()
  EventManager:RemoveEvent(EventID.OnExitDungeon, self)
  if self.Params.IsWin then
    self:PlayAnimation(self.Out)
  else
    self:PlayAnimation(self.Fail_Out)
  end
end

function M:OnContinueClicked()
  local CallbackResult
  if self.Params.ContinueCallback then
    CallbackResult = self.Params.ContinueCallback(self)
  end
  if false == CallbackResult then
    return
  end
  if self.Params.IsWin then
    self:PlayAnimation(self.Out)
  else
    self:PlayAnimation(self.Fail_Out)
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out or InAnimation == self.Fail_Out then
    self:BlockAllUIInput(false)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    self:Close()
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    DebugPrint("jly    已经显示的是该输入模式，不需要进行刷新")
    return
  end
  self.CurInputDeviceType = CurInputDevice
  if CurInputDevice == ECommonInputType.MouseAndKeyboard then
    if ModController:IsMobile() then
      return
    end
    local RewardWidget = self.Settlement_RewardItem
    if RewardWidget and RewardWidget.Key_GamePad then
      RewardWidget.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.IsFocusList = false
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
  elseif CurInputDevice == ECommonInputType.Gamepad then
    if self.IsFocusList then
      local RewardWidget = self.Settlement_RewardItem
      if RewardWidget and RewardWidget.List_Reward then
        RewardWidget.List_Reward:SetFocus()
      end
    else
      self:SetFocus()
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
      self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    local RewardWidget = self.Settlement_RewardItem
    if RewardWidget and RewardWidget.Key_GamePad then
      RewardWidget.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
    end
    if self.Cost and self.Cost.Key then
      self.Cost.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if not self.MaxListScrollOffset then
    self.MaxListScrollOffset = UIUtils.GetMaxScrollOffsetOfListView(self.List_ScoreItem)
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 0.5
  if math.abs(AddOffset) < 0.01 then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if "Gamepad_RightY" == InKeyName then
    local CurScrollOffset = self.List_ScoreItem:GetScrollOffset()
    local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, self.MaxListScrollOffset)
    self.List_ScoreItem:SetScrollOffset(ScrollOffset)
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:UpdateBottomKeyInfo(IsFocusList)
  if not self.Key_GamePad then
    return
  end
  self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
  if IsFocusList then
    local BottomKeyInfo = {
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Controller_CheckDetails")
      },
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_Tips_Close")
      }
    }
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Key_GamePad:UpdateKeyInfo(BottomKeyInfo)
  else
    local BottomKeyInfo = {}
    if CommonUtils.TableLength(self.Params.ScoreInfo) > 3 then
      BottomKeyInfo = {
        {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "RV"}
          },
          Desc = GText("UI_CTL_CheckCondition")
        }
      }
      self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Visible)
    end
    self.Key_GamePad:UpdateKeyInfo(BottomKeyInfo)
  end
end

function M:SetupGamepadControls()
  local RewardWidget = self.Settlement_RewardItem
  if RewardWidget and RewardWidget.Key_GamePad then
    RewardWidget.Key_GamePad:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      }
    })
  end
  self.IsFocusList = false
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self.Btn_Exit:SetGamePadImg("B")
  self.Btn_Continue:SetGamePadImg("Y")
end

function M:SequenceEvent_PlayScoreItemAnim()
  self.List_ScoreItem:RequestPlayEntriesAnim()
end

function M:Destruct()
  if self.ScoreAnimationTimer then
    self:RemoveTimer(self.ScoreAnimationTimer)
    self.ScoreAnimationTimer = nil
  end
end

return M
