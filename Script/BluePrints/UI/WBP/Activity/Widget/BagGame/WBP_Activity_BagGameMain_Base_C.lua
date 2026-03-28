require("UnLua")
local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local BagGameController = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameController")
local TimeUtils = require("Utils.TimeUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Activity.Widget.BagGame.WBP_Activity_BagGameMain_Base_C_GamepadComp"
}
local BagGameAwardReddotName = "BagGameAward"
local BagGameNewReddotName = "BagGameNew"
local BagGamePlayBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/BagGame/WBP_Activity_BagGame_Play.WBP_Activity_BagGame_Play'"
local PC_FIXED_SELECT_POSITION = 4
local MOBILE_FIXED_SELECT_POSITION = 3
local MAIN_RESTORE_FOCUS_TIMER = "BagGameMainRestoreFocusOnEnter"
local MAIN_RESTORE_FOCUS_DELAY = 0.15

local function ClearBagGameReddot(ReddotName)
  if not ReddotManager.GetTreeNode(ReddotName) then
    ReddotManager.AddNodeEx(ReddotName, nil, Const.ReddotCacheType.UserCache)
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
  if CacheDetail then
    for key, _ in pairs(CacheDetail) do
      CacheDetail[key] = nil
    end
  end
  ReddotManager.ClearLeafNodeCount(ReddotName)
end

function M:Construct()
  M.Super.Construct(self)
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/weimangzhencang_level_select_in", nil, nil)
  self.WBP_Btn_Begin.Button_Area.OnClicked:Add(self, self.OnBeginBtnClicked)
  self.Wrap_Normal_L.OnListViewScrolled:Add(self, self._OnListItemScrolled)
  self.Wrap_Normal_L.OnMouseButtonUp:Add(self, self.OnListItemReleased)
  if self.Arrow_L and self.Arrow_L.Btn_Arrow then
    self.Arrow_L.Btn_Arrow.OnClicked:Add(self, self.OnArrowLeftClicked)
  end
  if self.Arrow_R and self.Arrow_R.Btn_Arrow then
    self.Arrow_R.Btn_Arrow.OnClicked:Add(self, self.OnArrowRightClicked)
  end
  self.CurrentSelectedContent = nil
  self.CurrentSelectedIndex = nil
  self.LastSelectedEntry = nil
  self.LastSelectedIndex = nil
  self.LastSelectedContentId = nil
  self.OriginalDataList = {}
  self.OriginalDataCount = 0
  self.bIsScrollingToTarget = false
  self.Text_Title02:SetText(GText("UI_BackpackPuzzle_BackgroundPosition"))
  self.Text_Rule:SetText(GText("UI_GameEvent_BagGame_LevelDes"))
  self.Text_Score:SetText(GText("UI_BackpackPuzzle_HighestScore"))
  self.WBP_Btn_Begin.Text_Button:SetText(GText("UI_BackpackPuzzle_StartGame"))
  self._ViewedLevelIds = nil
  self.BeginKey = self.WBP_Btn_Begin.Key_GamePad
  self:InitListenEvent()
  self:RefreshBaseInfo()
end

function M:Destruct()
  self:RemoveTimer(MAIN_RESTORE_FOCUS_TIMER)
  self.Wrap_Normal_L.OnListViewScrolled:Remove(self, self._OnListItemScrolled)
  self.Wrap_Normal_L.OnMouseButtonUp:Remove(self, self.OnListItemReleased)
  if self.Arrow_L and self.Arrow_L.Btn_Arrow then
    self.Arrow_L.Btn_Arrow.OnClicked:Remove(self, self.OnArrowLeftClicked)
  end
  if self.Arrow_R and self.Arrow_R.Btn_Arrow then
    self.Arrow_R.Btn_Arrow.OnClicked:Remove(self, self.OnArrowRightClicked)
  end
  self._ViewedLevelIds = nil
  M.Super.Destruct(self)
end

function M:ReceiveEnterState(StackAction)
  self.Super.ReceiveEnterState(self, StackAction)
  if 1 == StackAction then
    self:_RequestRestoreFocusOnEnter()
  end
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  self._Avatar = GWorld:GetAvatar()
  self:InitMainTab()
  self.Btn_Arward:Init()
  self:InitLevelList()
  self:PlayAnimation(self.In)
  self:SetFocus()
  self:InitScrollEffect()
  local CurInputDevice = UIUtils.UtilsGetCurrentInputType()
  self:InitGamePadKey()
end

function M:OnBeginBtnClicked()
  if not self.CurrentSelectedContent then
    print("警告：未选中任何关卡")
    return
  end
  local bCanBegin = self:IsSelectedLevelUnlockedByPrerequisite(self.CurrentSelectedContent) and self:IsSelectedLevelUnlockTimeReached(self.CurrentSelectedContent)
  if not bCanBegin then
    return
  end
  local LevelId = self.CurrentSelectedContent.LevelId
  local TargetScoreMax = BagGameModel:GetLevelMaxTargetScore(LevelId)
  print("开始游戏 - 关卡ID:", LevelId, ", 标题:", self.CurrentSelectedContent.LevelName, ", 最高目标分:", TargetScoreMax)
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_main_level_btn_click", nil, nil)
  BagGameController:OpenPlayUI(LevelId, self.CurrentSelectedContent, self)
end

function M:ScrollToPreviousItem()
  if self.bIsScrollingToTarget then
    return
  end
  local CurrentRealIndex = self:GetCurrentRealLevelIndex()
  if CurrentRealIndex <= 0 then
    return
  end
  self:ScrollToRealIndex(CurrentRealIndex - 1)
end

function M:ScrollToNextItem()
  if self.bIsScrollingToTarget then
    return
  end
  local CurrentRealIndex = self:GetCurrentRealLevelIndex()
  if CurrentRealIndex >= self.OriginalDataCount - 1 then
    return
  end
  self:ScrollToRealIndex(CurrentRealIndex + 1)
end

function M:OnArrowLeftClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  self:ScrollToPreviousItem()
end

function M:OnArrowRightClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  self:ScrollToNextItem()
end

function M:ScrollToRealIndex(RealIndex)
  self.bIsScrollingToTarget = true
  if RealIndex < 0 then
    RealIndex = 0
  end
  if RealIndex > self.OriginalDataCount - 1 then
    RealIndex = self.OriginalDataCount - 1
  end
  self.Wrap_Normal_L:SetScrollOffset(RealIndex)
  self:AddTimer(0.05, function()
    self.bIsScrollingToTarget = false
    self:UpdateSelectedItem()
    self:UpdateArrowButtons()
  end, false)
end

function M:GetCurrentRealLevelIndex()
  local ScrollOffset = self.Wrap_Normal_L:GetScrollOffset()
  local RealIndex = math.floor(ScrollOffset + 0.5)
  if RealIndex < 0 then
    RealIndex = 0
  end
  if self.OriginalDataCount > 0 and RealIndex > self.OriginalDataCount - 1 then
    RealIndex = self.OriginalDataCount - 1
  end
  return RealIndex
end

function M:InitMainTab()
  self.Tab:Init({
    Tabs = self.Tabs,
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Or"},
          GamePadSubKeyInfoList = {
            {Type = "Img", ImgShortPath = "LB"},
            {Type = "Img", ImgShortPath = "RB"}
          }
        },
        Desc = GText("切换关卡"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    },
    OwnerPanel = self,
    BackCallback = self.CloseSelf,
    StyleName = "TextImage",
    TitleName = GText("Event_Title_103015")
  })
end

function M:UpdateInfoTips(Content)
  self.Text_Title01:SetText(GText(Content.LevelName))
  self.Text_Message01:SetText(GText(Content.LevelDes))
  local LevelId = Content.LevelId
  local StarCount = BagGameModel:GetPlayerStarCount(LevelId)
  local DisplayScore = StarCount > 0 and BagGameModel:GetPlayerFinishScore(LevelId) or 0
  self.Text_Score_Num:SetText(DisplayScore)
  local FinishCount = BagGameModel:GetPlayerStarCount(LevelId)
  local TotalStars = Content.TargetScore and #Content.TargetScore or 0
  if Content.TargetScore then
    local PlayerScore = Content.PlayerScore or 0
    for i, TargetScore in ipairs(Content.TargetScore) do
      local IsFinish = TargetScore <= PlayerScore
      if IsFinish then
        self["ScoreItem0" .. i].WS_Type:SetActiveWidgetIndex(1)
        self["ScoreItem0" .. i].Text_ScoreInfo_Star:SetText(string.format(GText("UI_BackpackPuzzle_Target" .. i), TargetScore))
      else
        self["ScoreItem0" .. i].WS_Type:SetActiveWidgetIndex(0)
        self["ScoreItem0" .. i].Text_ScoreInfo_Empty:SetText(string.format(GText("UI_BackpackPuzzle_Target" .. i), TargetScore))
      end
    end
  end
  self.Text_Target:SetText(string.format(GText("UI_BackpackPuzzle_TargetScore") .. " (%d/%d)", FinishCount, TotalStars))
  self:RefreshBeginButtonText()
end

function M:SetBeginButtonText(TextValue)
  if self.WBP_Btn_Begin and self.WBP_Btn_Begin.SetText then
    self.WBP_Btn_Begin:SetText(TextValue)
  elseif self.WBP_Btn_Begin and self.WBP_Btn_Begin.Text_Button then
    self.WBP_Btn_Begin.Text_Button:SetText(TextValue)
  end
end

function M:IsSelectedLevelUnlockedByPrerequisite(Content)
  if not (Content and Content.Id) or Content.Id <= 1 then
    return true
  end
  if not self.OriginalDataList then
    return true
  end
  local PrevInfo = self.OriginalDataList[Content.Id - 1]
  if not PrevInfo then
    return true
  end
  return BagGameModel:GetPlayerStarCount(PrevInfo.LevelId) > 0
end

function M:GetSelectedLevelRemainUnlockSeconds(Content)
  if not Content or not Content.UnlockDate then
    return 0
  end
  local UnlockTs = Content.UnlockDate:GetTime()
  if UnlockTs <= 0 then
    return 0
  end
  local NowTs = TimeUtils.NowTime()
  local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(UnlockTs, NowTs)
  return UnlockTs - NowTs, RemainTimeDict
end

function M:IsSelectedLevelUnlockTimeReached(Content)
  local RemainUnlockSeconds = self:GetSelectedLevelRemainUnlockSeconds(Content)
  return RemainUnlockSeconds <= 0
end

function M:RefreshBeginButtonText()
  self.WBP_Btn_Begin.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
  if not self.CurrentSelectedContent then
    self:SetBeginButtonText(GText("UI_BackpackPuzzle_StartGame"))
    self.WBP_Btn_Begin.Button_Area:SetForbidden(true)
    self.WBP_Btn_Begin.WS_Text:SetActiveWidgetIndex(1)
    self._bBeginBtnForbidden = true
    self:RefreshBeginKeyVisibility()
    return
  end
  if not self:IsSelectedLevelUnlockedByPrerequisite(self.CurrentSelectedContent) then
    self:SetBeginButtonText(GText("UI_GameEvent_BagGame_LockDes_PerviousLevel"))
    self.WBP_Btn_Begin.Button_Area:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WBP_Btn_Begin.Button_Area:SetForbidden(true)
    self.WBP_Btn_Begin.WS_Text:SetActiveWidgetIndex(1)
    self._bBeginBtnForbidden = true
    self:RefreshBeginKeyVisibility()
    return
  end
  local RemanTimes, RemainTimeDict = self:GetSelectedLevelRemainUnlockSeconds(self.CurrentSelectedContent)
  if RemanTimes > 0 then
    self.WBP_Btn_Begin.WBP_Com_Time:SetTimeText(nil, RemainTimeDict)
    self.WBP_Btn_Begin.Button_Area:SetForbidden(true)
    self.WBP_Btn_Begin.Button_Area:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WBP_Btn_Begin.WS_Text:SetActiveWidgetIndex(0)
    self._bBeginBtnForbidden = true
    self:RefreshBeginKeyVisibility()
    return
  else
    self.WBP_Btn_Begin.WS_Text:SetActiveWidgetIndex(1)
  end
  self:SetBeginButtonText(GText("UI_BackpackPuzzle_StartGame"))
  self.WBP_Btn_Begin.Button_Area:SetForbidden(false)
  self._bBeginBtnForbidden = false
  self:RefreshBeginKeyVisibility()
end

function M:RefreshBeginKeyVisibility()
  if self._bBeginBtnForbidden then
    self.BeginKey:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local IsUseGamepad = self.CurInputDevice == ECommonInputType.Gamepad
  if IsUseGamepad then
    self.BeginKey:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.BeginKey:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitLevelList()
  self.LevelList = {}
  local LevelsInfo = BagGameModel:GetLevelsInfo()
  local FixedSelectPosition = self:GetFixedSelectPosition()
  local TrailingPlaceholderCount = self:GetTrailingPlaceholderCount()
  self.OriginalDataList = LevelsInfo
  self.OriginalDataCount = #LevelsInfo
  self.Wrap_Normal_L:ClearListItems()
  for i = 1, FixedSelectPosition do
    local Placeholder = NewObject(UIUtils.GetCommonItemContentClass())
    Placeholder.Owner = self
    Placeholder.IsPlaceholder = true
    Placeholder.Index = -i
    self.Wrap_Normal_L:AddItem(Placeholder)
  end
  for DataIndex, Info in ipairs(LevelsInfo) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Owner = self
    local LevelContent = BagGameModel:BuildLevelListContent(Info, DataIndex)
    for Key, Value in pairs(LevelContent) do
      Content[Key] = Value
    end
    Content.Index = DataIndex - 1
    Content.RealDataIndex = DataIndex - 1
    Content.IsPlaceholder = false
    Content.PlayerScore = BagGameModel:GetPlayerFinishScore(Info.LevelId)
    self.Wrap_Normal_L:AddItem(Content)
  end
  for i = 1, TrailingPlaceholderCount do
    local Placeholder = NewObject(UIUtils.GetCommonItemContentClass())
    Placeholder.Owner = self
    Placeholder.IsPlaceholder = true
    Placeholder.Index = self.OriginalDataCount + i - 1
    self.Wrap_Normal_L:AddItem(Placeholder)
  end
  self.Wrap_Normal_L:RequestPlayEntriesAnim()
  self:_TryRefreshBagGameNewReddot()
end

function M:RefreshLevelListAfterPlay(PreferLevelId)
  self._bIsAutoSelecting = true
  self:InitLevelList()
  local TargetRealIndex
  local UncompletedIndex = self:FindFirstUncompletedLevelIndex()
  if nil ~= UncompletedIndex then
    TargetRealIndex = UncompletedIndex
  else
    local HighestIndex = self:FindHighestCompletedLevelIndex()
    if nil ~= HighestIndex then
      TargetRealIndex = HighestIndex
    else
      TargetRealIndex = 0
    end
  end
  self:AddTimer(0.05, function()
    self:ScrollToRealIndex(TargetRealIndex)
    self:AddTimer(0.1, function()
      self.CurrentSelectedIndex = nil
      self.CurrentSelectedContent = nil
      self.LastSelectedEntry = nil
      self.LastSelectedIndex = nil
      self.LastSelectedContentId = nil
      self:UpdateSelectedItem()
      self:UpdateArrowButtons()
      self._bIsAutoSelecting = false
    end, false)
  end, false)
end

function M:IsLevelFirstClearCompleted(LevelInfo)
  if not (LevelInfo and LevelInfo.TargetScore) or 0 == #LevelInfo.TargetScore then
    return false
  end
  local FirstTargetScore = LevelInfo.TargetScore[1]
  local PlayerScore = BagGameModel:GetPlayerFinishScore(LevelInfo.LevelId)
  return FirstTargetScore <= PlayerScore
end

function M:FindFirstUncompletedLevelIndex()
  for Index, LevelInfo in ipairs(self.OriginalDataList) do
    if not self:IsLevelFirstClearCompleted(LevelInfo) then
      return Index - 1
    end
  end
  return nil
end

function M:FindHighestCompletedLevelIndex()
  local HighestIndex
  for Index, LevelInfo in ipairs(self.OriginalDataList) do
    if self:IsLevelFirstClearCompleted(LevelInfo) then
      HighestIndex = Index - 1
    else
      break
    end
  end
  return HighestIndex
end

function M:InitScrollEffect()
  self._bIsAutoSelecting = true
  self:AddTimer(0.1, function()
    local TargetRealIndex
    local UncompletedIndex = self:FindFirstUncompletedLevelIndex()
    if nil ~= UncompletedIndex then
      TargetRealIndex = UncompletedIndex
      print("初始化定位：未完成首通关卡，真实索引:", TargetRealIndex)
    else
      local HighestIndex = self:FindHighestCompletedLevelIndex()
      if nil ~= HighestIndex then
        TargetRealIndex = HighestIndex
        print("初始化定位：最高已首通关卡，真实索引:", TargetRealIndex)
      else
        TargetRealIndex = 0
        print("初始化定位：默认第一关")
      end
    end
    self:ScrollToRealIndex(TargetRealIndex)
    self:AddTimer(0.15, function()
      self.Wrap_Normal_L:ForceLayoutPrepass()
      self.CurrentSelectedIndex = nil
      self.LastSelectedEntry = nil
      self.LastSelectedIndex = nil
      self.LastSelectedContentId = nil
      self:UpdateSelectedItem()
      self:UpdateArrowButtons()
      self._bIsAutoSelecting = false
    end)
  end)
end

function M:OnListItemReleased()
  self:SnapToNearestItem()
end

function M:GetFixedSelectPosition()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return MOBILE_FIXED_SELECT_POSITION
  end
  return PC_FIXED_SELECT_POSITION
end

function M:GetTrailingPlaceholderCount()
  return self:GetFixedSelectPosition() * 2
end

function M:GetItemIndexAtSelectPosition()
  local RealIndex = self:GetCurrentRealLevelIndex()
  local FixedSelectPosition = self:GetFixedSelectPosition()
  return FixedSelectPosition + RealIndex
end

function M:GetCurrentSelectedContent()
  return self.CurrentSelectedContent
end

function M:HasSelectedContent()
  return self.CurrentSelectedContent ~= nil
end

function M:UpdateSelectedItem()
  if self.bIsScrollingToTarget then
    return
  end
  local NewSelectedIndex = self:GetItemIndexAtSelectPosition()
  if nil == NewSelectedIndex then
    return
  end
  local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.Wrap_Normal_L, NewSelectedIndex)
  if not (CurWidget and CurWidget.Content) or CurWidget.Content.IsPlaceholder then
    return
  end
  if self.CurrentSelectedIndex ~= NewSelectedIndex then
    if self.LastSelectedEntry and self.LastSelectedEntry.PlayUnselected and self.LastSelectedContentId and self.LastSelectedEntry.Content and self.LastSelectedEntry.Content.Id == self.LastSelectedContentId and self.LastSelectedEntry ~= CurWidget then
      self.LastSelectedEntry:PlayUnselected()
    end
    self.CurrentSelectedIndex = NewSelectedIndex
    if CurWidget then
      if CurWidget.PlaySelected then
        CurWidget:PlaySelected()
      end
      self.LastSelectedEntry = CurWidget
      self.LastSelectedIndex = NewSelectedIndex
      if CurWidget.Content then
        self.CurrentSelectedContent = CurWidget.Content
        self.LastSelectedContentId = CurWidget.Content.Id
        local RealIndex = NewSelectedIndex - self:GetFixedSelectPosition()
        print("选中 Item - 列表索引:", NewSelectedIndex, ", 真实索引:", RealIndex, ", Id:", CurWidget.Content.Id, ", LevelId:", CurWidget.Content.LevelId)
        self:UpdateInfoTips(self.CurrentSelectedContent)
        self:_TryClearNewReddotForLevel(self.CurrentSelectedContent.LevelId)
      else
        self.CurrentSelectedContent = nil
        self.LastSelectedContentId = nil
      end
    else
      self.CurrentSelectedContent = nil
      self.LastSelectedContentId = nil
    end
  end
end

function M:UpdateArrowButtons()
  local RealIndex = self:GetCurrentRealLevelIndex()
  local bCanScrollLeft = RealIndex > 0
  local bCanScrollRight = RealIndex < self.OriginalDataCount - 1
  local ListIndex = self:GetItemIndexAtSelectPosition()
  local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.Wrap_Normal_L, ListIndex)
  if self.Arrow_L and self.Arrow_L.Btn_Arrow then
    self.Arrow_L.Btn_Arrow:SetForbidden(not bCanScrollLeft)
  end
  if self.Arrow_R and self.Arrow_R.Btn_Arrow then
    self.Arrow_R.Btn_Arrow:SetForbidden(not bCanScrollRight)
  end
end

function M:ClampScrollPosition()
  if self.OriginalDataCount <= 0 then
    return false
  end
  local ScrollOffset = self.Wrap_Normal_L:GetScrollOffset()
  local MinOffset = 0
  local MaxOffset = self.OriginalDataCount - 1
  if ScrollOffset < MinOffset then
    self.Wrap_Normal_L:SetScrollOffset(MinOffset)
    return true
  elseif ScrollOffset > MaxOffset then
    self.Wrap_Normal_L:SetScrollOffset(MaxOffset)
    return true
  end
  return false
end

function M:SnapToNearestItem()
  local ScrollOffset = self.Wrap_Normal_L:GetScrollOffset()
  local SnappedOffset = math.floor(ScrollOffset + 0.5)
  if SnappedOffset < 0 then
    SnappedOffset = 0
  end
  if self.OriginalDataCount > 0 and SnappedOffset > self.OriginalDataCount - 1 then
    SnappedOffset = self.OriginalDataCount - 1
  end
  self.Wrap_Normal_L:SetScrollOffset(SnappedOffset)
  self:UpdateSelectedItem()
  self:UpdateArrowButtons()
end

function M:_OnListItemScrolled(ItemOffset, DistanceRemaining)
  self:ClampScrollPosition()
  local NewSelectedIndex = self:GetItemIndexAtSelectPosition()
  if NewSelectedIndex ~= self.CurrentSelectedIndex then
    self:UpdateSelectedItem()
    self:UpdateArrowButtons()
  end
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  self:_ClearUnviewedNewReddots()
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  EventManager:FireEvent(EventID.OnReturnToActivityEntry)
  self:PlayAnimation(self.Out)
  EventManager:FireEvent(EventID.OnReturnToActivityEntry)
  EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  self:HandleGamepadInput(InKeyName)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:HandleGamepadInput(InKeyName)
  elseif "Escape" == InKeyName then
    self:CloseSelf()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:_ClearBagGameReddotWhenActivityEnd()
  if not BagGameModel:IsActivityEnded() then
    return false
  end
  ClearBagGameReddot(BagGameAwardReddotName)
  ClearBagGameReddot(BagGameNewReddotName)
  return true
end

function M:_TryRefreshBagGameNewReddot()
  if self:_ClearBagGameReddotWhenActivityEnd() then
    return
  end
  local NewNode = ReddotManager.GetTreeNode(BagGameNewReddotName)
  if not NewNode then
    return
  end
  local NewCacheDetail = ReddotManager.GetLeafNodeCacheDetail(BagGameNewReddotName)
  if not NewCacheDetail then
    return
  end
  local LevelsInfo = self.OriginalDataList
  if not LevelsInfo or 0 == #LevelsInfo then
    return
  end
  for i, LevelInfo in ipairs(LevelsInfo) do
    local LevelId = LevelInfo.LevelId
    if nil ~= NewCacheDetail[LevelId] then
    else
      local bUnlocked = false
      if 1 == i then
        bUnlocked = true
      else
        local PrevLevelId = LevelsInfo[i - 1].LevelId
        if BagGameModel:GetPlayerStarCount(PrevLevelId) > 0 then
          local UnlockTs
          if nil == LevelInfo.UnlockDate then
            UnlockTs = BagGameModel.EventStartTime:GetTime()
          else
            UnlockTs = LevelInfo.UnlockDate:GetTime()
          end
          bUnlocked = UnlockTs <= 0 or UnlockTs <= TimeUtils.NowTime()
        end
      end
      if bUnlocked and 0 == BagGameModel:GetPlayerStarCount(LevelId) then
        ReddotManager.IncreaseLeafNodeCount(BagGameNewReddotName, 1, {LevelId = LevelId})
      end
    end
  end
end

function M:_TryClearNewReddotForLevel(LevelId)
  if not LevelId then
    return
  end
  if self._bIsAutoSelecting then
    return
  end
  if self:_ClearBagGameReddotWhenActivityEnd() then
    return
  end
  local NewCacheDetail = ReddotManager.GetLeafNodeCacheDetail(BagGameNewReddotName)
  if NewCacheDetail and NewCacheDetail[LevelId] then
    ReddotManager.DecreaseLeafNodeCount(BagGameNewReddotName, 1, {LevelId = LevelId})
  end
  self._ViewedLevelIds = self._ViewedLevelIds or {}
  self._ViewedLevelIds[LevelId] = true
end

function M:_ClearUnviewedNewReddots()
  if self:_ClearBagGameReddotWhenActivityEnd() then
    return
  end
  local NewNode = ReddotManager.GetTreeNode(BagGameNewReddotName)
  if not NewNode or NewNode.Count <= 0 then
    return
  end
  local NewCacheDetail = ReddotManager.GetLeafNodeCacheDetail(BagGameNewReddotName)
  if not NewCacheDetail then
    return
  end
  local LevelIdsToRemove = {}
  for LevelId, Flag in pairs(NewCacheDetail) do
    if type(LevelId) == "number" and true == Flag and (not self._ViewedLevelIds or not self._ViewedLevelIds[LevelId]) then
      table.insert(LevelIdsToRemove, LevelId)
    end
  end
  for _, LevelId in ipairs(LevelIdsToRemove) do
    ReddotManager.DecreaseLeafNodeCount(BagGameNewReddotName, 1, {LevelId = LevelId})
  end
  self._ViewedLevelIds = nil
end

function M:BP_GetDesiredFocusTarget()
  return self
end

function M:_RequestRestoreFocusOnEnter()
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  
  local function RestoreFocus()
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
      return
    end
    local FocusTarget = self:BP_GetDesiredFocusTarget()
    if FocusTarget and FocusTarget.SetFocus then
      FocusTarget:SetFocus()
      return
    end
    self:SetFocus()
  end
  
  RestoreFocus()
  self:RemoveTimer(MAIN_RESTORE_FOCUS_TIMER)
  self:AddTimer(MAIN_RESTORE_FOCUS_DELAY, RestoreFocus, false, 0, MAIN_RESTORE_FOCUS_TIMER, true)
end

AssembleComponents(M)
return M
