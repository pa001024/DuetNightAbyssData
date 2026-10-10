require("UnLua")
local HardBossEventController = require("BluePrints.UI.WBP.Play.Widget.HardBossEvent.HardBossEventController")
local ipairs = _ENV.ipairs
local math_floor = math.floor
local tostring = _ENV.tostring
local MODE_BOSS = "BOSS"
local MODE_REWARD = "REWARD"
local MODE_TIP = "TIP"
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})
local BOSS_LIST_EMPTY_TIMER = "HardBossEventFillBossEmpty"
local BOSS_CONTENT_CLASS_PATH = "/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C"

function M:Initialize(Initializer)
  self.EventId = nil
  self.ParentRoot = nil
  self.BossConfigList = nil
  self.BossConfigById = nil
  self.SelectedIndex = nil
  self.CurrentBossConfig = nil
  self.TitleWidget = nil
  self.HardBossFocusMode = MODE_BOSS
  self.IsHardBossGamepad = false
  self.RewardSelectedContent = nil
  self.HardBossRewardDetailOpen = false
end

function M:Construct()
  EventManager:AddEvent(EventID.OnWeeklyRefresh, self, self.OnWeeklyRefresh)
  self.List_Boss.BP_OnItemSelectionChanged:Add(self, self.OnHardBossItemSelectionChanged)
  self.List_Boss.BP_OnItemClicked:Add(self, self.OnHardBossItemClicked)
  self.ListView_Rewards.BP_OnItemSelectionChanged:Add(self, self.OnHardBossRewardSelectionChanged)
  self.Btn_Enter:BindSingleEventOnClicked(self, self.OnClickEnter)
  self.Btn_Enter:TryOverrideSoundFunc(self.Btn_Enter_SoundFuc)
  self.Text_BossRewards:SetText(GText("UI_HardBoss_Preview"))
  self.Btn_Enter:SetText(GText("UI_HardBoss_Track"))
  self.Key_Rewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnWeeklyRefresh(ServerTime)
  self:RefreshRewardTimes()
end

function M:Btn_Enter_SoundFuc()
end

function M:Init(EventId, ParentRoot)
  self.ParentRoot = ParentRoot
  self.HardBossFocusMode = MODE_BOSS
  self.RewardSelectedContent = nil
  self.HardBossRewardDetailOpen = false
  self.EventId, self.BossConfigList = HardBossEventController:GetSelectPageData(EventId)
  self.BossConfigById = {}
  for _, BossConfig in ipairs(self.BossConfigList) do
    self.BossConfigById[BossConfig.HardBossDungeonId] = BossConfig
  end
  self:RefreshRewardTimes()
  self:RefreshBossList()
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
  if self.In then
    self:PlayAnimation(self.In)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "OpenSound", nil)
end

function M:RefreshRewardTimes()
  if not self.EventId then
    self.Text_RewardTimes:SetText("")
    return
  end
  local RemainTimes, TotalTimes = HardBossEventController:GetRewardTimes(self.EventId)
  local Text = GText("UI_HardBoss_ChancesRemain")
  local TimesText = tostring(RemainTimes) .. "/" .. tostring(math_floor(TotalTimes))
  if RemainTimes <= 0 then
    TimesText = "<Warning>" .. TimesText .. "</>"
  end
  self.Text_RewardTimes:SetText(Text .. TimesText)
end

function M:RefreshBossList()
  self.SelectedIndex = nil
  self.CurrentBossConfig = nil
  self.List_Boss:ClearListItems()
  local Contents = HardBossEventController:BuildBossContents(self, self.BossConfigList)
  for _, Content in ipairs(Contents) do
    self.List_Boss:AddItem(Content)
  end
  self:FillBossListEmptyCells(#Contents)
end

function M:FillBossListEmptyCells(BossCount)
  self:RemoveTimer(BOSS_LIST_EMPTY_TIMER)
  if 0 == BossCount then
    local EmptyContent = NewObject(UE4.LoadClass(BOSS_CONTENT_CLASS_PATH))
    EmptyContent.Parent = self
    EmptyContent.Empty = true
    self.List_Boss:AddItem(EmptyContent)
    self.List_Boss.ConsumeMouseWheel = EConsumeMouseWheel.Never
    return
  end
  local TryTime = 0
  self:AddTimer(0.05, function()
    local FirstItem = self.List_Boss:GetItemAt(0)
    if not FirstItem or not FirstItem.Entry then
      TryTime = TryTime + 1
      if TryTime >= 20 then
        self:RemoveTimer(BOSS_LIST_EMPTY_TIMER)
      end
      return
    end
    local ListSize = USlateBlueprintLibrary.GetLocalSize(self.List_Boss:GetCachedGeometry())
    local EntrySize = USlateBlueprintLibrary.GetLocalSize(FirstItem.Entry:GetCachedGeometry())
    if 0 == ListSize.X or 0 == EntrySize.X then
      TryTime = TryTime + 1
      if TryTime >= 20 then
        self:RemoveTimer(BOSS_LIST_EMPTY_TIMER)
      end
      return
    end
    local ColumnCount = math.max(1, math_floor(ListSize.X / EntrySize.X) + 1)
    local EmptyCount = (ColumnCount - BossCount % ColumnCount) % ColumnCount
    for _ = 1, EmptyCount do
      local EmptyContent = NewObject(UE4.LoadClass(BOSS_CONTENT_CLASS_PATH))
      EmptyContent.Parent = self
      EmptyContent.Empty = true
      self.List_Boss:AddItem(EmptyContent)
    end
    if EmptyCount > 0 then
      self.List_Boss.ConsumeMouseWheel = EConsumeMouseWheel.Never
      self.List_Boss:SetEmptyGridItemCount(EmptyCount)
    else
      self.List_Boss.ConsumeMouseWheel = EConsumeMouseWheel.WhenScrollingPossible
    end
    self:RemoveTimer(BOSS_LIST_EMPTY_TIMER)
  end, true, 0, BOSS_LIST_EMPTY_TIMER, true)
end

function M:TrySelectFirstTime(Entry)
  if self.SelectedIndex or not Entry then
    return
  end
  Entry:OnCellClickedWithoutSound(true, true)
  if self.IsHardBossGamepad then
    Entry:SetFocus()
  end
  self.List_Boss:BP_NavigateToItem(Entry.Content)
end

function M:RefreshListBossInfo(Index, IsFirstTime)
  if self.SelectedIndex then
    local PreviousContent = self.List_Boss:GetItemAt(self.SelectedIndex - 1)
    if PreviousContent then
      PreviousContent.IsSelect = false
      local PreviousEntry = PreviousContent.Entry
      if PreviousEntry then
        PreviousEntry:StopAllAnimationsExceptIn()
        PreviousEntry:PlayAnimation(PreviousEntry.Normal)
      end
    end
  end
  self.SelectedIndex = Index
  local CurrentContent = self.List_Boss:GetItemAt(Index - 1)
  if CurrentContent then
    self.List_Boss:BP_NavigateToItem(CurrentContent)
  end
  self.CurrentBossConfig = CurrentContent and self.BossConfigById[CurrentContent.Id] or nil
  if not self.CurrentBossConfig then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/normal_boss_select_in", nil, nil)
  HardBossEventController:SetCurrentBossConfig(self.CurrentBossConfig)
  if self.ParentRoot and self.ParentRoot.OnBossSelected then
    self.ParentRoot:OnBossSelected(self.CurrentBossConfig, IsFirstTime)
  end
  self:RefreshTitle(self.CurrentBossConfig)
  self.Text_BossDetail:SetText(GText(self.CurrentBossConfig.HardBossDes))
  self:RefreshRewards(self.CurrentBossConfig)
end

function M:RefreshTitle(BossConfig)
  local NewTitleWidget
  if BossConfig.TitleBp then
    NewTitleWidget = UIManager(self):CreateWidget(BossConfig.TitleBp, false)
  end
  if NewTitleWidget then
    self.Group_Title:ClearChildren()
    self.Group_Title:AddChild(NewTitleWidget)
    self.TitleWidget = NewTitleWidget
  elseif not self.TitleWidget and self.WBP_Play_HardBoss_Title_Xibi then
    self.TitleWidget = self.WBP_Play_HardBoss_Title_Xibi
  end
  if self.TitleWidget and self.TitleWidget.SetInfo then
    self.TitleWidget:SetInfo(BossConfig.HardBossName)
    if self.TitleWidget.In then
      self.TitleWidget:PlayAnimation(self.TitleWidget.In)
    end
  end
end

function M:RefreshRewards(BossConfig)
  self.ListView_Rewards:ClearListItems()
  local Contents = HardBossEventController:BuildRewardContents(self, BossConfig)
  local HasReward = #Contents > 0
  local RewardVisibility = HasReward and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  self.HB_Rewards:SetVisibility(RewardVisibility)
  self.ListView_Rewards:SetVisibility(RewardVisibility)
  for _, Content in ipairs(Contents) do
    Content.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnHardBossRewardMenuChanged
    }
    self.ListView_Rewards:AddItem(Content)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice)
  local IsGamepad = CurInputDevice == ECommonInputType.Gamepad and not ModController:IsMobile()
  self.IsHardBossGamepad = IsGamepad
  self.Btn_Enter:SetVisibility(IsGamepad and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Enter:SetGamePadVisibility(IsGamepad and self.HardBossFocusMode == MODE_BOSS and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Key_Rewards:SetVisibility(IsGamepad and self.HardBossFocusMode == MODE_BOSS and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if IsGamepad then
    self.Btn_Enter:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonBottom)
    self.Key_Rewards:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.LeftThumb
        }
      }
    })
  elseif self.HardBossFocusMode ~= MODE_BOSS then
    self:ChangeHardBossFocusMode(MODE_BOSS)
  end
end

function M:ChangeHardBossFocusMode(FocusMode)
  self.HardBossFocusMode = FocusMode
  self.Btn_Enter:SetGamePadVisibility(self.IsHardBossGamepad and FocusMode == MODE_BOSS and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Key_Rewards:SetVisibility(self.IsHardBossGamepad and FocusMode == MODE_BOSS and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if self.ParentRoot then
    self.ParentRoot:UpdateHardBossBottomKeys()
  end
end

function M:GetCurrentBossFocusTarget()
  local Content = self.SelectedIndex and self.List_Boss:GetItemAt(self.SelectedIndex - 1)
  local Entry = Content and Content.Entry
  if IsValid(Entry) and Entry:IsVisible() then
    return Entry
  end
  return self.List_Boss
end

function M:FocusCurrentBoss()
  local Target = self:GetCurrentBossFocusTarget()
  if Target then
    Target:SetFocus()
  end
end

function M:OnHardBossItemSelectionChanged(Content)
  if self.IsHardBossGamepad and self.HardBossFocusMode == MODE_BOSS and Content and Content.Entry then
    Content.Entry:OnCellClicked()
  end
end

function M:OnHardBossItemClicked(Content)
  if self.IsHardBossGamepad and self.HardBossFocusMode == MODE_BOSS and Content and self.CurrentBossConfig and self.CurrentBossConfig.HardBossDungeonId == Content.Id then
    self:OnClickEnter()
  end
end

function M:EnterHardBossRewardMode()
  if not self.IsHardBossGamepad or 0 == self.ListView_Rewards:GetNumItems() then
    return false
  end
  self.RewardSelectedContent = self.ListView_Rewards:GetItemAt(0)
  self.HardBossRewardDetailOpen = true
  self:ChangeHardBossFocusMode(MODE_REWARD)
  self.ListView_Rewards:NavigateToIndex(0)
  return true
end

function M:OnHardBossRewardSelectionChanged(Content)
  if self.IsHardBossGamepad and Content then
    self.RewardSelectedContent = Content
  end
end

function M:RestoreHardBossRewardFocusAfterDetail()
  if not self.IsHardBossGamepad then
    return
  end
  self:ChangeHardBossFocusMode(MODE_REWARD)
  self.ListView_Rewards:BP_CancelScrollIntoView()
  local Target = self.RewardSelectedContent and self.RewardSelectedContent.SelfWidget
  if not IsValid(Target) then
    Target = self.ListView_Rewards
  end
  if IsValid(Target) then
    Target:SetFocus()
  end
end

function M:LeaveHardBossRewardMode()
  self.HardBossRewardDetailOpen = false
  self.RewardSelectedContent = nil
  self:ChangeHardBossFocusMode(MODE_BOSS)
  self:FocusCurrentBoss()
end

function M:OnHardBossRewardMenuChanged(IsOpen, Content)
  if not self.IsHardBossGamepad then
    if not IsOpen and self.ParentRoot and self.ParentRoot.RestoreKeyboardFocusToPage then
      self.ParentRoot:RestoreKeyboardFocusToPage()
    end
    return
  end
  if IsOpen then
    self:ChangeHardBossFocusMode(MODE_TIP)
  else
    self.RewardSelectedContent = Content or self.RewardSelectedContent
    self:RestoreHardBossRewardFocusAfterDetail()
  end
end

function M:HandleHardBossBack()
  if not self.IsHardBossGamepad then
    return false
  end
  if self.HardBossFocusMode == MODE_TIP then
    return false
  end
  if self.HardBossFocusMode == MODE_REWARD then
    self:LeaveHardBossRewardMode()
    return true
  end
  if self.ParentRoot then
    self.ParentRoot:OnReturnKeyDown()
    return true
  end
  return false
end

function M:HandleHardBossGamepadKey(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    return self:HandleHardBossBack()
  end
  if not self.IsHardBossGamepad or self.HardBossFocusMode == MODE_TIP then
    return false
  end
  if InKeyName == UIConst.GamePadKey.LeftThumb and self.HardBossFocusMode == MODE_BOSS then
    return self:EnterHardBossRewardMode()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.HardBossFocusMode == MODE_BOSS then
    self:OnClickEnter()
    return true
  end
  return false
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if self:HandleHardBossGamepadKey(InKeyName) then
      return UIUtils.Handled
    end
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleHardBossGamepadKey(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnClickEnter()
  if not (self.ParentRoot and self.ParentRoot.ShowHardBossDetail) or not self.CurrentBossConfig then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
  self.ParentRoot:ShowHardBossDetail(self.CurrentBossConfig.HardBossDungeonId)
end

function M:Destruct()
  self:RemoveTimer(BOSS_LIST_EMPTY_TIMER)
  EventManager:RemoveEvent(EventID.OnWeeklyRefresh, self)
  self.List_Boss.BP_OnItemSelectionChanged:Remove(self, self.OnHardBossItemSelectionChanged)
  self.List_Boss.BP_OnItemClicked:Remove(self, self.OnHardBossItemClicked)
  self.ListView_Rewards.BP_OnItemSelectionChanged:Remove(self, self.OnHardBossRewardSelectionChanged)
  self.EventId = nil
  self.ParentRoot = nil
  self.BossConfigList = nil
  self.BossConfigById = nil
  self.SelectedIndex = nil
  self.CurrentBossConfig = nil
  self.TitleWidget = nil
  self.HardBossFocusMode = nil
  self.IsHardBossGamepad = nil
  self.RewardSelectedContent = nil
  self.HardBossRewardDetailOpen = nil
  AudioManager(self):SetEventSoundParam(self, "OpenSound", {ToEnd = 1})
end

return M
