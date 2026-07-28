local TimeUtils = require("Utils.TimeUtils")
local ScoreTierRewardConst = require("BluePrints.UI.UI_PC.Common.ScoreTierReward.ScoreTierRewardConst")
local ScoreTierRewardHelper = require("BluePrints.UI.UI_PC.Common.ScoreTierReward.ScoreTierRewardHelper")
local M = {}

function M:ScoreTierReward_InitPage(Config)
  Config = Config or {}
  self.ScoreTierRewardConfig = Config
  self:SetFocus()
  self.Index = 0
  self.ChangeSpeed = Config.ChangeSpeed or 3
  self.PlayInAnimation = true
  self.IsInSelectState = false
  self.CurFocusedItem = nil
  self.CurCommonTabCanGet = nil
  self.RemainRefreshTime = nil
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.Btn_Click:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Btn_Click.OnClicked:Add(self, self.PlayOutAnim)
  self.Btn_Close:Init("Close", self, self.PlayOutAnim)
  self.Btn_GetAllBtn:BindEventOnClicked(self, self.ScoreTierReward_ClaimAll)
  self.Btn_GetAllBtn:SetText(Config.GetAllText or GText("UI_Mail_Recieveall"))
  if Config.Title and self.Text_Title then
    self.Text_Title:SetText(Config.Title)
  end
  if Config.Desc and self.Text_Desc then
    self.Text_Desc:SetText(Config.Desc)
  end
  if Config.ClickEmptyText and self.Text_Click then
    self.Text_Click:SetText(Config.ClickEmptyText)
  end
  self.List_Reward:SetScrollbarVisibility(UIConst.VisibilityOp.Hidden)
  self.List_Reward:SetControlScrollbarInside(false)
  self:ScoreTierReward_SetInfo()
  if Config.EnableRefreshTimer then
    self:ScoreTierReward_StartRefreshTimer()
  end
  if IsValid(self.GameInputModeSubsystem) and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Touch then
    self.Key_Tips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif self.Key_Tips then
    self.Key_Tips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.In then
    self:PlayAnimation(self.In)
  end
  local ReddotNodeName = self:GetScoreTierReddotNodeName()
  if ReddotNodeName then
    ReddotManager.AddListener(ReddotNodeName, self, self.ScoreTierReward_UpdateClaimAllButton)
  end
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:InitListenEvent()
  self.Btn_GetAllBtn:SetDefaultGamePadImg("Y")
end

function M:ScoreTierReward_Destruct()
  self:ClearListenEvent()
  local ReddotNodeName = self:GetScoreTierReddotNodeName()
  if ReddotNodeName then
    ReddotManager.RemoveListener(ReddotNodeName, self)
  end
end

function M:ScoreTierReward_Close()
  self:ScoreTierReward_Destruct()
end

function M:GetScoreTierReddotNodeName()
  local Config = self.ScoreTierRewardConfig
  return Config and Config.ReddotNodeName or nil
end

function M:GetScoreTierItemDetailUIName()
  local Config = self.ScoreTierRewardConfig
  return Config and Config.ItemDetailUIName or "ScoreTierReward"
end

function M:GetScoreTierCurrentScore()
  local Snapshot = self:GetScoreTierRewardSnapshot()
  return Snapshot and Snapshot.CurrentScore or 0
end

function M:IsScoreTierRewardGot(Index)
  local Snapshot = self:GetScoreTierRewardSnapshot()
  if Snapshot and Snapshot.IsRewardGot then
    return Snapshot.IsRewardGot(Index)
  end
  return false
end

function M:ScoreTierReward_CheckHaveAnyRewardCanGet()
  return ScoreTierRewardHelper.HasAnyRewardCanGet(self:GetScoreTierRewardSnapshot())
end

function M:ScoreTierReward_SetInfo()
  local ClassPath = ScoreTierRewardConst.LIST_ITEM_CONTENT_CLASS
  local Snapshot = self:GetScoreTierRewardSnapshot()
  self.List_Reward:SetVisibility(ESlateVisibility.HitTestInvisible)
  self.List_Reward:ClearListItems()
  if Snapshot and Snapshot.RewardIds and Snapshot.EachGradePoints then
    self.MaxRewardGot = #Snapshot.RewardIds
    self.EachGradePoints = Snapshot.EachGradePoints
    local CurScore = Snapshot.CurrentScore or 0
    local MaxScore = Snapshot.MaxScore or self.MaxRewardGot * Snapshot.EachGradePoints
    self.ScrollIndex = math.floor(CurScore / Snapshot.EachGradePoints)
    if self.Text_Score then
      self.Text_Score:SetText(CurScore)
    end
    if self.Text_MaxScore then
      self.Text_MaxScore:SetText(MaxScore)
    end
    if Snapshot.TokenIcon and self.Icon_Token then
      self.Icon_Token:SetBrushResourceObject(Snapshot.TokenIcon)
    end
    if self.ScoreTierReward_UpdateExtraHeader then
      self:ScoreTierReward_UpdateExtraHeader(Snapshot)
    end
    local Object = NewObject(UE4.LoadClass(ClassPath))
    Object.NotReward = true
    self.List_Reward:AddItem(Object)
  end
  self:AddTimer(0.001, function()
    local MaxCount = UIUtils.GetListViewContentMaxCount(self.List_Reward)
    self.List_Reward:SetEmptyGridItemCount(0)
    self.Mid = math.ceil(MaxCount / 2)
    self.List_Reward:ClearListItems()
    Snapshot = self:GetScoreTierRewardSnapshot()
    if Snapshot and Snapshot.RewardIds and Snapshot.EachGradePoints then
      for Index, RewardId in ipairs(Snapshot.RewardIds) do
        local ItemObject = NewObject(UE4.LoadClass(ClassPath))
        ItemObject.RewardInfoId = RewardId
        ItemObject.GradePoints = Snapshot.EachGradePoints * Index
        ItemObject.StartTime = UGameplayStatics.GetTimeSeconds(self)
        ItemObject.Index = Index
        ItemObject.Parent = self
        self.List_Reward:AddItem(ItemObject)
      end
    end
    self:AddTimer(0.001, function()
      self.List_Reward:ScrollToBottom(self.ScrollIndex or 0)
      self:AddTimer(0.001, function()
        self.BottomOffset = self.List_Reward:GetScrollOffset()
        self:ScoreTierReward_GetOffsetByIndex(self.ScrollIndex or 0)
        self.List_Reward:ScrollToTop()
        self.LerpAlpha = 0
        self:AddTimer(0.033, function(_, DeltaTime)
          self.LerpAlpha = self.LerpAlpha + self.ChangeSpeed * DeltaTime
          if self.LerpAlpha >= 1 then
            self.LerpAlpha = 1
            self.List_Reward:SetScrollOffset(self.TargetOffset)
            self.PlayInAnimation = false
            self.List_Reward:SetVisibility(ESlateVisibility.Visible)
            if self.ScrollIndex and self.ScrollIndex > 0 then
              self.List_Reward:NavigateToIndex(self.ScrollIndex - 1)
            else
              self.List_Reward:NavigateToIndex(0)
            end
            self:RemoveTimer(ScoreTierRewardConst.SCROLL_OFFSET_TIMER_KEY)
            return
          end
          local Offset = UE4.UKismetMathLibrary.Lerp(0, self.TargetOffset, self.LerpAlpha)
          self.List_Reward:SetScrollOffset(Offset)
        end, true, 0, ScoreTierRewardConst.SCROLL_OFFSET_TIMER_KEY, true, 0.033)
      end)
    end)
  end)
end

function M:ScoreTierReward_GetOffsetByIndex(Index)
  if Index <= self.Mid then
    self.TargetOffset = 0
  elseif self.MaxRewardGot - Index <= self.Mid - 1 then
    self.TargetOffset = self.BottomOffset
  else
    local k = self.BottomOffset / (self.MaxRewardGot - self.Mid + 1 - self.Mid)
    local z = -k * self.Mid
    self.TargetOffset = k * Index + z
  end
end

function M:ScoreTierReward_StartRefreshTimer()
  self:ScoreTierReward_RefreshTimerTick()
  self:AddTimer(1, self.ScoreTierReward_RefreshTimerTick, true, 0, ScoreTierRewardConst.REFRESH_TIMER_KEY, true)
end

function M:ScoreTierReward_RefreshTimerTick()
  local RemainTime = self:ScoreTierReward_UpdateRemainTime()
  if RemainTime and self.Time then
    self.Time:SetTimeText(nil, RemainTime)
  end
  return
end

function M:ScoreTierReward_OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonTop then
      IsEventHandled = true
      self:ScoreTierReward_TryClaimAll()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      IsEventHandled = true
      self:PlayOutAnim()
    end
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:PlayOutAnim()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:PlayOutAnim()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  self:PlayAnimationForward(self.Out)
end

function M:ScoreTierReward_OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "SpaceBar" == InKeyName then
    self:ScoreTierReward_TryClaimAll()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:ScoreTierReward_UpdateDisplayedItems()
  local Entrys = self.List_Reward:GetDisplayedEntryWidgets()
  local Len = Entrys:Length()
  for i = Len, 1, -1 do
    if Entrys[i]:CheckIsCompleteState() then
      Entrys[i]:ChangeState("Received")
    end
  end
end

function M:ScoreTierReward_ClaimAll()
  self:RequestClaimScoreTierReward(nil, function(RetCode, Rewards)
    if 0 ~= RetCode then
      return
    end
    self:ScoreTierReward_UpdateDisplayedItems()
    if self.ScoreTierReward_OnClaimSuccess then
      self:ScoreTierReward_OnClaimSuccess(Rewards, nil)
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
      self:SetFocus()
    end, self)
  end)
end

function M:ScoreTierReward_TryClaimAll()
  if self.Btn_GetAllBtn:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
    self:ScoreTierReward_ClaimAll()
  end
end

function M:ScoreTierReward_UpdateClaimAllButton(Count)
  if Count and Count > 0 then
    self.Btn_GetAllBtn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Btn_GetAllBtn:SetVisibility(ESlateVisibility.Collapsed)
  end
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

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  self:ScoreTierReward_UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:ScoreTierReward_UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  if IsUseKeyAndMouse then
    self:ScoreTierReward_InitKeyboardView()
  else
    self:ScoreTierReward_InitGamepadView()
  end
end

function M:ScoreTierReward_InitGamepadView()
  if UIUtils.HasAnyFocus(self) then
    self:SetFocus()
    self:ScoreTierReward_NavigateToFirstDisplayedItem(self.List_Reward)
  end
  self.Btn_GetAllBtn:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:ScoreTierReward_InitCommonTab(false)
end

function M:ScoreTierReward_InitKeyboardView()
  self.Btn_GetAllBtn:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  if self.CurFocusedItem then
    self:TryLeaveSelectMode(self.CurFocusedItem)
  end
  self.CurFocusedItem = nil
  self:ScoreTierReward_InitKeyboardCommonTab()
end

function M:TryEnterSelectMode(Entry)
  if self.IsInSelectState then
    return false
  end
  Entry:EnterSelectMode()
  self:ScoreTierReward_InitSelectTab()
  self.IsInSelectState = true
  return true
end

function M:TryLeaveSelectMode(Entry)
  if not self.IsInSelectState then
    return false
  end
  Entry:LeaveSelectMode()
  if Entry:CheckIsCompleteState() then
    self:ScoreTierReward_InitCommonTab(true)
  else
    self:ScoreTierReward_InitCommonTab(false)
  end
  self.IsInSelectState = false
  return true
end

function M:ScoreTierReward_NavigateToFirstDisplayedItem(List)
  local ItemUIs = List:GetDisplayedEntryWidgets()
  if ItemUIs:Length() > 0 then
    local TargetWidget
    for i = 1, ItemUIs:Length() do
      local Widget = ItemUIs:GetRef(i)
      local Index = Widget.Content.Index
      if Index and (not TargetWidget or Index < TargetWidget.Content.Index) then
        TargetWidget = Widget
      end
    end
    if TargetWidget then
      List:BP_NavigateToItem(TargetWidget.Content)
      return TargetWidget
    end
  end
  return List
end

function M:TryChangeCurFocusedItem(Item)
  self.CurFocusedItem = Item
  if IsValid(self.GameInputModeSubsystem) and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and not self.IsInSelectState then
    if self.CurFocusedItem:CheckIsCompleteState() then
      self:ScoreTierReward_InitCommonTab(true)
    else
      self:ScoreTierReward_InitCommonTab(false)
    end
  end
end

function M:ScoreTierReward_InitKeyboardCommonTab()
  self.CurCommonTabCanGet = nil
  local BottomKeyInfo = {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.PlayOutAnim,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  if self:ScoreTierReward_CheckHaveAnyRewardCanGet() then
    table.insert(BottomKeyInfo, 1, {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Space",
          ClickCallback = self.ScoreTierReward_ClaimAll,
          Owner = self
        }
      },
      Desc = GText("UI_GameEvent_ClaimAll"),
      bLongPress = false
    })
  end
  self.Key_Tips:UpdateKeyInfo(BottomKeyInfo)
end

function M:ScoreTierReward_InitCommonTab(CanGet)
  if self.CurCommonTabCanGet == CanGet then
    return
  end
  self.CurCommonTabCanGet = CanGet
  local BottomKeyInfo = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_Controller_CheckReward")
    },
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    }
  }
  if CanGet then
    table.insert(BottomKeyInfo, 2, {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Achievement_GetReward")
    })
  end
  self.Key_Tips:UpdateKeyInfo(BottomKeyInfo)
end

function M:ScoreTierReward_InitSelectTab()
  self.CurCommonTabCanGet = nil
  local BottomKeyInfo = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Tips_Ensure")
    },
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    }
  }
  self.Key_Tips:UpdateKeyInfo(BottomKeyInfo)
end

function M:ScoreTierReward_InitEmptyTab()
  self.CurCommonTabCanGet = nil
  self.Key_Tips:UpdateKeyInfo({})
end

function M:OnMenuOpenChanged(bIsOpen)
  if bIsOpen then
    self:ScoreTierReward_InitEmptyTab()
    self.Btn_Click:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Btn_Click:SetVisibility(UIConst.VisibilityOp.Visible)
    if IsValid(self.GameInputModeSubsystem) and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
      if self.IsInSelectState then
        self:ScoreTierReward_InitSelectTab()
      elseif self.CurFocusedItem and self.CurFocusedItem:CheckIsCompleteState() then
        self:ScoreTierReward_InitCommonTab(true)
      else
        self:ScoreTierReward_InitCommonTab(false)
      end
    else
      self:ScoreTierReward_InitKeyboardCommonTab()
    end
  end
end

return M
