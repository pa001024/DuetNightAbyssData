require("UnLua")
local ComRankingUtils = require("BluePrints.UI.WBP.Common.Ranking.ComRankingUtils")
local RankingPreviewScene = require("BluePrints.UI.WBP.Common.Ranking.RankingPreviewScene")
local RankingAppearancePreview = require("BluePrints.UI.WBP.Common.Ranking.RankingAppearancePreview")
local PreviewLevelHandoffMask = require("BluePrints.UI.Common.Preview.PreviewLevelHandoffMask")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent"
}
local TypeWidgetPath = "WidgetBlueprint'/Game/UI/WBP/Common/Ranking/Widget/WBP_Com_Ranking_Type.WBP_Com_Ranking_Type'"
local RANKING_NEXT_FRAME_SEC = 0.001

function M:Construct()
  M.Super.Construct(self)
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:InitRankingEmptyContent()
end

function M:InitRankingEmptyContent()
  if self.List_Ranking and self.List_Ranking.OnCreateEmptyContent then
    self.List_Ranking.OnCreateEmptyContent:Bind(self, self.OnCreateRankingEmptyContent)
  end
end

function M:ShouldFillRankingEmptyContent()
  local Params = self.Params
  if not Params or Params.FillRankingEmptyContent == nil then
    return true
  end
  return Params.FillRankingEmptyContent == true
end

function M:OnCreateRankingEmptyContent()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Empty = true
  Content.TabId = self.TabId or 1
  Content.ParentWidget = self
  Content.Columns = self:BuildEmptyColumns(self:GetEffectiveColumnSchema(Content.TabId))
  return Content
end

function M:ResolveDefaultRankIndex(TabId)
  TabId = TabId or self.TabId or 1
  local SavedRankNum = self.SelectedRankNumByTab and self.SelectedRankNumByTab[TabId]
  if SavedRankNum and self.ValidItemNum and SavedRankNum >= 1 and SavedRankNum <= self.ValidItemNum then
    return SavedRankNum - 1
  end
  return 0
end

function M:EnsureDefaultSelectedRankNum(TabId)
  TabId = TabId or self.TabId or 1
  if not self.SelectedRankNumByTab then
    self.SelectedRankNumByTab = {}
  end
  if not self.ValidItemNum or self.ValidItemNum <= 0 then
    return
  end
  local SavedRankNum = self.SelectedRankNumByTab[TabId]
  if not SavedRankNum or SavedRankNum < 1 or SavedRankNum > self.ValidItemNum then
    self.SelectedRankNumByTab[TabId] = 1
  end
  local Index = self:ResolveDefaultRankIndex(TabId)
  self.NavigatedRankIndex = Index
  local Content = self:GetRankItemContentByIndex(Index)
  if Content and not Content.Empty then
    self.LastClickedItem = Content
  end
end

function M:SelectDefaultRankEntry()
  if not (self.List_Ranking and self.ValidItemNum) or self.ValidItemNum <= 0 then
    return
  end
  local TabId = self.TabId or 1
  local Index = self:ResolveDefaultRankIndex(TabId)
  self.NavigatedRankIndex = Index
  self.List_Ranking:NavigateToIndex(Index)
  self:RemoveTimer("RankingSelectDefaultEntry")
  self.bAutoSelectingRankEntry = true
  self:AddTimer(0.05, function()
    if not IsValid(self) or (self.TabId or 1) ~= TabId then
      self.bAutoSelectingRankEntry = false
      return
    end
    local Content = self:GetRankItemContentByIndex(Index)
    if not Content or Content.Empty then
      self.bAutoSelectingRankEntry = false
      return
    end
    local SelectedRankNum = self.SelectedRankNumByTab and self.SelectedRankNumByTab[TabId]
    if SelectedRankNum == Content.RankNum then
      if self.bRankingListScrollReady then
        self:ScrollRankListToIndex(Index)
      else
        self.PendingMyselfScrollIndex = Index
      end
      if self.IsShowActor and self._PreviewRankContent ~= Content then
        self._PreviewRankContent = Content
        self:RequestRankTargetPreview(Content.RankInfo.Uid, Content.RankInfo)
      end
      self:RefreshDisplayedRankSelection(nil, nil)
    else
      if not self.bRankingListScrollReady then
        self.PendingMyselfScrollIndex = Index
      end
      self:ApplyRankListSelection(Index, true)
    end
    if self.IsGamePad and self.FocusSelectedListEntry then
      self:FocusSelectedListEntry(Index, true)
    end
    self.bAutoSelectingRankEntry = false
  end, false, 0, "RankingSelectDefaultEntry", true)
end

function M:CancelPendingRankSelection()
  self:RemoveTimer("RankingSelectDefaultEntry")
  self:RemoveTimer("RankingDeferredScroll")
  self.bAutoSelectingRankEntry = false
end

function M:ReceiveExitState(StackAction)
  M.Super.ReceiveExitState(self, StackAction)
  if 0 ~= StackAction then
    return
  end
  local Manager = UIManager(self)
  local IncomingName
  if Manager and Manager.CurrentUIList then
    local UINameList = Manager.CurrentUIList:ToTable()
    IncomingName = UINameList[#UINameList]
  end
  if "PersonInfoPageMain" ~= IncomingName and "AppearanceMain" ~= IncomingName then
    return
  end
  self._bStackCovered = true
  PreviewLevelHandoffMask.Show(self)
  if self.PreviewScene and self.PreviewScene.ReleaseLevelForStack then
    self.PreviewScene:ReleaseLevelForStack()
  end
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  if 1 ~= StackAction or not self._bStackCovered then
    return
  end
  self._bStackCovered = nil
  if self.PreviewScene and self.PreviewScene.RestoreLevelForStack then
    self.PreviewScene:RestoreLevelForStack()
  end
end

function M:Destruct()
  self._bRankingShown = false
  self._bStackCovered = nil
  if self._bIsClosing then
    self:BlockAllUIInput(false)
    self._bIsClosing = false
  end
  self:RemoveTimer("RankingPreviewReadyFallback")
  self:RemoveTimer("RankingPreviewReady")
  self:CancelPendingRankSelection()
  self:RemoveTimer("RankingFillEmptyContent")
  self:RemoveTimer("RankingFillEmptyReady")
  self:RemoveTimer("RankingScrollRefresh")
  self:RemoveTimer("AlignHeaderColumnWidth")
  self:RemoveTimer("DelaySelectTab")
  self:UnbindAllFromAnimationFinished(self.Out)
  if self.SubTab and self.SubTab.BindEventOnTabSelected then
    self.SubTab:BindEventOnTabSelected(nil, nil)
  end
  if self.List_Ranking then
    if self.List_Ranking.OnCreateEmptyContent then
      self.List_Ranking.OnCreateEmptyContent:Unbind()
    end
    if self.List_Ranking.BP_OnItemClicked then
      self.List_Ranking.BP_OnItemClicked:Clear()
    end
    if self.List_Ranking.BP_OnItemIsHoveredChanged then
      self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
    end
    if self.List_Ranking.OnListViewScrolled then
      self.List_Ranking.OnListViewScrolled:Clear()
    end
  end
  EventManager:RemoveEvent(EventID.OnPlayerRankAccessoryInfo, self, self.OnPlayerRankAccessoryInfo)
  self:ResetRankingUIHiddenState()
  if self.PreviewContext then
    self.PreviewContext.PendingPreviewUid = nil
    self.PreviewContext.PendingPreviewRankInfo = nil
  end
  if self.PreviewScene then
    self.PreviewScene:Destroy()
    self.PreviewScene = nil
  end
  self.PreviewContext = nil
  M.Super.Destruct(self)
end

function M:OnLoaded(...)
  self.Params = (...) or {}
  self.MainTab = self.Params.MainTab or {}
  self.TopNRankInfo = self.Params.TopNRankInfo or {}
  self.SelfRankInfo = self.Params.SelfRankInfo or {}
  self.ColumnSchema = self.Params.ColumnSchema or {}
  self.PreviewActorTabId = self.Params.PreviewActorTabId or 1
  self.Avatar = GWorld:GetAvatar()
  self._bRankingShown = false
  self._bIsClosing = false
  self._bStackCovered = nil
  if self.PreviewScene then
    self.PreviewScene:Destroy()
    self.PreviewScene = nil
  end
  if self.PreviewContext then
    self.PreviewContext.PendingPreviewUid = nil
    self.PreviewContext.PendingPreviewRankInfo = nil
    self.PreviewContext = nil
  end
  local BgParams = self.Params.BgParams
  self.IsShowActor = not BgParams or not BgParams.BgWidgetPath
  self.PreviewScene = nil
  self.PreviewContext = nil
  EventManager:AddEvent(EventID.OnPlayerRankAccessoryInfo, self, self.OnPlayerRankAccessoryInfo)
  self.SelectedRankNumByTab = {}
  self.bShowTeam = true
  self.TopNContents = {}
  self.SelfContents = {}
  self.SelfRankNumByTab = {}
  self.HeaderColumnWidths = nil
  self.HeaderColumnWidthsByTab = {}
  self.TabId = nil
  self.LastClickedItem = nil
  self.NavigatedRankIndex = 0
  self.ValidItemNum = 0
  self.bAutoSelectingRankEntry = false
  self.bRankingListScrolling = false
  self._HoveredRankContent = nil
  self._PreviewRankContent = nil
  self:ResetRankingUIHiddenState()
  self:InitMainTab()
  self:InitSubTab()
  self:InitBackground(function()
    self:NotifyRankingPreviewReady()
  end)
  self:ScheduleRankingPreviewFallback()
end

local RANKING_PREVIEW_READY_FALLBACK_SEC = 0.8
local RANKING_PREVIEW_READY_DELAY_SEC = 0.08

function M:NotifyRankingPreviewReady()
  if self._bRankingShown or not IsValid(self) then
    return
  end
  self:RemoveTimer("RankingPreviewReady")
  self:AddTimer(RANKING_PREVIEW_READY_DELAY_SEC, function()
    if not IsValid(self) then
      return
    end
    self:ShowRankingUI()
  end, false, 0, "RankingPreviewReady", true)
end

function M:ScheduleRankingPreviewFallback()
  self:RemoveTimer("RankingPreviewReadyFallback")
  self:AddTimer(RANKING_PREVIEW_READY_FALLBACK_SEC, function()
    if not IsValid(self) then
      return
    end
    self:ShowRankingUI()
  end, false, 0, "RankingPreviewReadyFallback", true)
end

function M:ForceHideStackUnderUI()
  local UiMgr = UIManager(self)
  local UnderUI = UiMgr and UiMgr:GetUnderState()
  if not UnderUI or not IsValid(UnderUI) then
    return
  end
  if UnderUI.CancelTweenOutSystemStackChange then
    UnderUI:CancelTweenOutSystemStackChange()
  end
  if UnderUI.SetUIVisibilityTag then
    UnderUI:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, true, UE4.ESlateVisibility.Collapsed)
  elseif UnderUI.SetVisibility then
    UnderUI:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:ShowRankingUI()
  if self._bRankingShown or not IsValid(self) then
    return
  end
  self._bRankingShown = true
  self:RemoveTimer("RankingPreviewReadyFallback")
  self:RemoveTimer("RankingPreviewReady")
  self:ForceHideStackUnderUI()
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:PlayInAnimation()
  self:RequestFillRankingEmptyContent()
end

function M:InitMainTab()
  if IsValid(self.MainTabSubWidget) then
    self.MainTabSubWidget:RemoveFromParent()
    self.MainTabSubWidget = nil
  end
  local SubWidgetInfo = self.MainTab.SubWidgetInfo
  if not SubWidgetInfo then
    return
  end
  self.MainTabSubWidget = UIManager(self):CreateWidget(SubWidgetInfo.WidgetPath)
  if self.MainTabSubWidget then
    self.Tab.Pos_Common:AddChild(self.MainTabSubWidget)
    if self.MainTabSubWidget.Init then
      self.MainTabSubWidget:Init({Parent = self})
    end
  end
end

function M:InitSubTab()
  if not self.Params then
    return
  end
  if self.Text_Title then
    if self.Params.TitleText then
      self.Text_Title:SetText(GText(self.Params.TitleText))
      self.Text_Title:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.Text_Title:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  local Tabs = self.Params.SubTab
  if not Tabs or #Tabs <= 1 then
    if self.Panel_Tab then
      self.Panel_Tab:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    local FirstTabId = Tabs and Tabs[1] and Tabs[1].TabId or 1
    self:UpdateSubTab(nil, {TabId = FirstTabId})
    return
  end
  if self.Panel_Tab then
    self.Panel_Tab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.SubTab then
    self.SubTab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local LocalizedTabs = {}
    for _, Tab in ipairs(Tabs) do
      local TabCopy = {}
      for Key, Value in pairs(Tab) do
        TabCopy[Key] = Value
      end
      TabCopy.Text = GText(Tab.Text)
      table.insert(LocalizedTabs, TabCopy)
    end
    self.SubTab:Init({
      Tabs = LocalizedTabs,
      SoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
      end
    })
    self.SubTab:BindEventOnTabSelected(self, self.UpdateSubTab)
    local FirstTabId = Tabs[1] and Tabs[1].TabId or 1
    self:UpdateSubTab(nil, {TabId = FirstTabId})
    self:AddTimer(0.1, function()
      if not IsValid(self) or not self.SubTab then
        return
      end
      self.SubTab:SelectTab(1)
      if self.IsGamePad and self.FocusSelectedItem then
        self:FocusSelectedItem()
      elseif self.IsGamePad and self.FocusSelectedListEntry then
        self:FocusSelectedListEntry(self.NavigatedRankIndex or 0, true)
      else
        self:SetFocus()
      end
    end, nil, nil, "DelaySelectTab", true)
    if self.BlockSubTabGamepadNavigation then
      self:BlockSubTabGamepadNavigation()
    end
  end
end

function M:UpdateSubTab(TabWidget, TabInfo)
  local NewTabId = TabInfo and TabInfo.TabId or 1
  if self.TabId == NewTabId then
    self:UpdateBottomKeyOnSubTabChange()
    return
  end
  local PrevTabId = self.TabId
  self.TabId = NewTabId
  self:UpdateRankInfos(NewTabId)
  self:UpdateSelfInfos(NewTabId)
  if self.UpdateShowTeamToggleVisibility then
    self:UpdateShowTeamToggleVisibility()
  end
  self:UpdateHeaderInfo(NewTabId)
  self:UpdateBottomKeyOnSubTabChange()
  if PrevTabId and NewTabId ~= PrevTabId and self.Change then
    self:PlayAnimation(self.Change)
  end
end

function M:HideHBox_Type()
  if self.HBox_Type then
    self.HBox_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:UpdateHeaderInfo(TabId)
  local HeaderNames = self:GetEffectiveHeaderNames(TabId)
  if not HeaderNames or not self.HBox_Type then
    return
  end
  local TopNInfo = self.TopNRankInfo and self.TopNRankInfo[TabId]
  if not TopNInfo or ComRankingUtils.IsEmptyTable(TopNInfo) then
    self.HBox_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.HBox_Type:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.HBox_Type:ClearChildren()
  self.HeaderColumns = {}
  self.QaWidgets = {}
  self.CurQaIndex = nil
  for Index, NameInfo in ipairs(HeaderNames) do
    local ColumnWidget = UIManager(self):CreateWidget(TypeWidgetPath)
    if ColumnWidget then
      self.HBox_Type:AddChild(ColumnWidget)
      table.insert(self.HeaderColumns, ColumnWidget)
      local CachedWidths = self.HeaderColumnWidthsByTab and self.HeaderColumnWidthsByTab[TabId] or self.HeaderColumnWidths
      local PrevWidth = CachedWidths and CachedWidths[Index]
      if PrevWidth then
        self:SetHeaderColumnWidth(ColumnWidget, PrevWidth)
      end
      if ColumnWidget.Text then
        ColumnWidget.Text:SetText(GText(NameInfo.Text))
      end
      if ColumnWidget.Btn_Qa then
        if NameInfo.QaText then
          ColumnWidget.Btn_Qa:Init({
            OwnerWidget = self,
            TextContent = GText(NameInfo.QaText),
            SoundFunc = function(Obj)
              AudioManager(Obj):PlayUISound(Obj, "event:/ui/common/click_btn_small", nil, nil)
            end
          })
          ColumnWidget.Btn_Qa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
          table.insert(self.QaWidgets, ColumnWidget.Btn_Qa)
        else
          ColumnWidget.Btn_Qa:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
      end
    end
  end
  self:RemoveTimer("AlignHeaderColumnWidth")
  self:AddTimer(0.15, function()
    if not IsValid(self) then
      return
    end
    self:AlignHeaderColumnWidth()
  end, false, 0, "AlignHeaderColumnWidth", true)
end

function M:AlignHeaderColumnWidth()
  if not self.HeaderColumns then
    return
  end
  if self.ForceLayoutPrepass then
    self:ForceLayoutPrepass()
  end
  local RefWidths = self:GetRefColumnWidths()
  if not RefWidths then
    return
  end
  self.HeaderColumnWidths = RefWidths
  if not self.HeaderColumnWidthsByTab then
    self.HeaderColumnWidthsByTab = {}
  end
  self.HeaderColumnWidthsByTab[self.TabId or 1] = RefWidths
  for Index, ColumnWidget in ipairs(self.HeaderColumns) do
    local Width = RefWidths[Index]
    if Width then
      self:SetHeaderColumnWidth(ColumnWidget, Width)
    end
  end
end

function M:SetHeaderColumnWidth(ColumnWidget, Width)
  local RootWidget = ColumnWidget.WidgetTree and ColumnWidget.WidgetTree.RootWidget
  if RootWidget and RootWidget.SetWidthOverride then
    RootWidget:SetWidthOverride(Width)
  end
end

function M:GetRefColumnWidths()
  local RefWidget
  if self.List_Ranking then
    RefWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Ranking, 0)
  end
  RefWidget = RefWidget or self.Ranking_Myself
  if not RefWidget or not RefWidget.HBox_Info then
    return nil
  end
  local Widths = {}
  local ChildCount = RefWidget.HBox_Info:GetChildrenCount()
  for i = 0, ChildCount - 1 do
    local Child = RefWidget.HBox_Info:GetChildAt(i)
    if Child then
      Widths[i + 1] = Child:GetDesiredSize().X
    end
  end
  return Widths
end

function M:ShouldShowMyselfBar(TabId)
  TabId = TabId or self.TabId or 1
  local TopNInfo = self.TopNRankInfo and self.TopNRankInfo[TabId]
  if not TopNInfo or ComRankingUtils.IsEmptyTable(TopNInfo) then
    return false
  end
  return true
end

function M:UpdateSelfInfos(TabId)
  TabId = TabId or 1
  if not self:ShouldShowMyselfBar(TabId) then
    if self.Ranking_Myself then
      self.Ranking_Myself:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    return
  end
  if self.Ranking_Myself then
    local Content = self:GetSelfContent(TabId)
    if not Content then
      self.Ranking_Myself:SetVisibility(UIConst.VisibilityOp.Collapsed)
      return
    end
    self.Ranking_Myself:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Ranking_Myself._bIsMyselfBar = true
    self.Ranking_Myself:OnListItemObjectSet(Content)
    if self.Ranking_Myself.EnsureBtnAeraBindings then
      self.Ranking_Myself:EnsureBtnAeraBindings()
    end
    if self.Ranking_Myself.Btn_Aera then
      self.Ranking_Myself.Btn_Aera.OnPressed:Clear()
    end
    if self.Ranking_Myself.ApplySelectedState then
      self.Ranking_Myself:ApplySelectedState(false, false)
    end
  end
end

function M:BuildSelfRankInfo(TabId)
  TabId = TabId or 1
  local CurRankInfo = self.SelfRankInfo and self.SelfRankInfo[TabId]
  if not CurRankInfo or ComRankingUtils.IsEmptyTable(CurRankInfo) then
    return nil
  end
  local RankInfo = {}
  local Avatar = self.Avatar
  if Avatar then
    RankInfo.HeadIconId = Avatar.HeadIconId
    RankInfo.HeadFrameId = Avatar.HeadFrameId
    RankInfo.Level = Avatar.Level
    RankInfo.Nickname = Avatar.Nickname
    RankInfo.TitleBefore = Avatar.TitleBefore
    RankInfo.TitleAfter = Avatar.TitleAfter
    RankInfo.TitleFrame = Avatar.TitleFrame
    RankInfo.Uid = Avatar.Uid
  end
  for Key, Value in pairs(CurRankInfo) do
    RankInfo[Key] = Value
  end
  return RankInfo
end

function M:ResolveSelfContentRankNum(TabId)
  TabId = TabId or 1
  local OnListRankNum = self.SelfRankNumByTab and self.SelfRankNumByTab[TabId]
  if OnListRankNum and OnListRankNum >= 1 then
    return OnListRankNum
  end
  return -1
end

function M:RefreshSelfContent(Content, TabId)
  TabId = TabId or 1
  local RankInfo = self:BuildSelfRankInfo(TabId)
  if not RankInfo then
    return false
  end
  local RankNum = self:ResolveSelfContentRankNum(TabId)
  Content.Empty = false
  Content.bIsSelfRow = true
  Content.TabId = TabId
  Content.RankNum = RankNum
  Content.RankInfo = RankInfo
  Content.Columns = self:BuildColumns(self:GetEffectiveColumnSchema(TabId), RankInfo, RankNum, true)
  Content.ParentWidget = self
  Content.SelfAvatar = self.Avatar
  Content.CallbackObj = self
  Content.ClickCallback = self.OnMyselfButtonClicked
  Content.MenuOpenCallback = self.OnHeadMenuOpenChanged
  return true
end

function M:GetSelfContent(TabId)
  TabId = TabId or 1
  if not self.SelfContents then
    self.SelfContents = {}
  end
  if self.SelfContents[TabId] then
    local Cached = self.SelfContents[TabId]
    if not self:RefreshSelfContent(Cached, TabId) then
      self.SelfContents[TabId] = nil
      return nil
    end
    return Cached
  end
  local RankInfo = self:BuildSelfRankInfo(TabId)
  if not RankInfo then
    return
  end
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  self:RefreshSelfContent(Content, TabId)
  self.SelfContents[TabId] = Content
  return Content
end

function M:UpdateRankInfos(TabId)
  TabId = TabId or 1
  self:CancelPendingRankSelection()
  self._PreviewRankContent = nil
  self._HoveredRankContent = nil
  self.bRankingListScrolling = false
  local TopNInfo = self.TopNRankInfo[TabId]
  if not TopNInfo or ComRankingUtils.IsEmptyTable(TopNInfo) then
    self.WS_Type:SetActiveWidget(self.Com_Empty)
    self:HideHBox_Type()
    local EmptyText = "UI_AppearanceScore_NoRanktoast"
    if self.Com_Empty and self.Com_Empty.Text_Empty then
      self.Com_Empty.Text_Empty:SetText(GText(EmptyText))
    end
    if self.Text_Empty then
      self.Text_Empty:SetText(GText(EmptyText))
    end
    if self.List_Ranking then
      self.List_Ranking:ClearListItems()
    end
    self.ValidItemNum = 0
    self.LastClickedItem = nil
    return
  end
  if self.HBox_Type then
    self.HBox_Type:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.WS_Type:SetActiveWidget(self.List_Ranking)
  self.List_Ranking:ClearListItems()
  self.LastClickedItem = nil
  self.bRankingListScrollReady = false
  self.PendingMyselfScrollIndex = nil
  if not self.TopNContents then
    self.TopNContents = {}
  end
  self.TopNContents[TabId] = {}
  local TopNContents = self:GetTopNContens(TabId)
  self:EnsureDefaultSelectedRankNum(TabId)
  for _, Content in ipairs(TopNContents) do
    self.List_Ranking:AddItem(Content)
  end
  self:RequestFillRankingEmptyContent()
  self:SelectDefaultRankEntry()
  if self.List_Ranking.BP_OnItemClicked then
    self.List_Ranking.BP_OnItemClicked:Clear()
    self.List_Ranking.BP_OnItemClicked:Add(self, self.OnListRankItemClicked)
  end
  if self.List_Ranking.BP_OnItemIsHoveredChanged then
    self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
    self.List_Ranking.BP_OnItemIsHoveredChanged:Add(self, self.OnListRankItemIsHoveredChanged)
  end
  if self.List_Ranking.OnListViewScrolled then
    self.List_Ranking.OnListViewScrolled:Clear()
    self.List_Ranking.OnListViewScrolled:Add(self, self.OnListRankScrolled)
  end
end

function M:RequestFillRankingEmptyContent()
  local CurTopNInfo = self.TopNRankInfo and self.TopNRankInfo[self.TabId or 1]
  if not CurTopNInfo or ComRankingUtils.IsEmptyTable(CurTopNInfo) then
    self:MarkRankingListScrollReady()
    return
  end
  if not (self:ShouldFillRankingEmptyContent() and self.List_Ranking) or not self.List_Ranking.RequestFillEmptyContent then
    self:MarkRankingListScrollReady()
    return
  end
  if not self._bRankingShown then
    return
  end
  self:RemoveTimer("RankingFillEmptyContent")
  self:AddTimer(0.1, function()
    if not IsValid(self) or not self.List_Ranking then
      return
    end
    self.List_Ranking:RequestFillEmptyContent()
    self:RemoveTimer("RankingFillEmptyReady")
    self:AddTimer(RANKING_NEXT_FRAME_SEC, function()
      if not IsValid(self) then
        return
      end
      self:MarkRankingListScrollReady()
    end, false, 0, "RankingFillEmptyReady", true)
  end, false, 0, "RankingFillEmptyContent", true)
end

function M:MarkRankingListScrollReady()
  self.bRankingListScrollReady = true
  self:FlushPendingMyselfScroll()
end

function M:FlushPendingMyselfScroll()
  local Index = self.PendingMyselfScrollIndex
  if nil == Index then
    return
  end
  self.PendingMyselfScrollIndex = nil
  if not IsValid(self) or not self.List_Ranking then
    return
  end
  self:ScrollRankListToIndex(Index)
  self:ApplyRankListSelection(Index, true)
end

function M:ScrollRankListToIndex(Index)
  if not (self.List_Ranking and self.ValidItemNum) or self.ValidItemNum <= 0 then
    return
  end
  Index = Index or self.NavigatedRankIndex or 0
  if Index < 0 then
    Index = 0
  end
  if Index >= self.ValidItemNum then
    Index = self.ValidItemNum - 1
  end
  if self.List_Ranking.ScrollIndexIntoView then
    self.List_Ranking:ScrollIndexIntoView(Index)
  end
  self.List_Ranking:NavigateToIndex(Index)
end

function M:GetTopNContens(TabId)
  TabId = TabId or 1
  if not self.TopNContents then
    self.TopNContents = {}
  end
  if not self.TopNContents[TabId] then
    self.TopNContents[TabId] = {}
  end
  if not ComRankingUtils.IsEmptyTable(self.TopNContents[TabId]) then
    self.ValidItemNum = #self.TopNContents[TabId]
    return self.TopNContents[TabId]
  end
  local TopNInfo = self.TopNRankInfo[TabId]
  if not TopNInfo or ComRankingUtils.IsEmptyTable(TopNInfo) then
    self.ValidItemNum = 0
    return self.TopNContents[TabId]
  end
  local ColumnSchema = self:GetEffectiveColumnSchema(TabId)
  local RankCount = 0
  if not self.SelfRankNumByTab then
    self.SelfRankNumByTab = {}
  end
  self.SelfRankNumByTab[TabId] = nil
  for _, RankInfo in ipairs(TopNInfo or {}) do
    RankCount = RankCount + 1
    if self:IsSelfUid(RankInfo.Uid) then
      self.SelfRankNumByTab[TabId] = RankCount
    end
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Empty = false
    Content.TabId = TabId
    Content.RankNum = RankCount
    Content.RankInfo = RankInfo
    Content.Columns = self:BuildColumns(ColumnSchema, RankInfo, RankCount)
    Content.ParentWidget = self
    Content.SelfAvatar = self.Avatar
    Content.CallbackObj = self
    Content.ClickCallback = self.OnListRankItemClicked
    Content.MenuOpenCallback = self.OnHeadMenuOpenChanged
    table.insert(self.TopNContents[TabId], Content)
  end
  self.ValidItemNum = RankCount
  return self.TopNContents[TabId]
end

function M:BuildColumns(ColumnSchema, RankInfo, RankNum, bPlaceholderWhenNil)
  local Columns = {}
  for _, ColumnDecl in ipairs(ColumnSchema or {}) do
    local ColumnType = ColumnDecl.Type
    if "RankingNum" == ColumnType then
      table.insert(Columns, {
        Type = "RankingNum",
        RankNum = RankNum,
        RankNumText = RankInfo.RankNumText
      })
    elseif "GradeIcon" == ColumnType then
      table.insert(Columns, {
        Type = "GradeIcon",
        GroupId = RankInfo.PreRaidGroupId
      })
    elseif "Name" == ColumnType then
      table.insert(Columns, {Type = "Name", RankInfo = RankInfo})
    elseif "TextInfo" == ColumnType then
      table.insert(Columns, {
        Type = "TextInfo",
        Text1 = self:FormatTextInfoLine(RankInfo, ColumnDecl.Text1, bPlaceholderWhenNil),
        Text2 = self:FormatTextInfoLine(RankInfo, ColumnDecl.Text2, bPlaceholderWhenNil)
      })
    elseif "Team" == ColumnType then
      local CharSlots, PhantomSlots = ComRankingUtils.GetSquadInfo(RankInfo)
      table.insert(Columns, {
        Type = "Team",
        CharSlots = CharSlots,
        PhantomSlots = PhantomSlots,
        bHide = RankInfo.bSquadView == false
      })
    end
  end
  return Columns
end

function M:BuildEmptyColumns(ColumnSchema)
  local Columns = {}
  for _, ColumnDecl in ipairs(ColumnSchema or {}) do
    local ColumnType = ColumnDecl.Type
    if "RankingNum" == ColumnType then
      table.insert(Columns, {Type = "RankingNum"})
    elseif "GradeIcon" == ColumnType then
      table.insert(Columns, {Type = "GradeIcon"})
    elseif "Name" == ColumnType then
      table.insert(Columns, {Type = "Name"})
    elseif "TextInfo" == ColumnType then
      table.insert(Columns, {Type = "TextInfo"})
    elseif "Team" == ColumnType then
      table.insert(Columns, {Type = "Team"})
    end
  end
  return Columns
end

function M:ResolveColumnFormat(TextMapId)
  if not TextMapId or "" == TextMapId then
    return nil
  end
  local FormatStr = GText(TextMapId)
  if not FormatStr or "" == FormatStr then
    FormatStr = TextMapId
  end
  return FormatStr
end

function M:CountFormatSpecs(FormatStr)
  local Count = 0
  local Index = 1
  local Len = #FormatStr
  while Index <= Len do
    local Percent = FormatStr:find("%", Index, true)
    if not Percent then
      break
    end
    if "%" == FormatStr:sub(Percent + 1, Percent + 1) then
      Index = Percent + 2
    else
      Count = Count + 1
      Index = Percent + 1
    end
  end
  return Count
end

function M:BuildFormatPlaceholder(FormatStr)
  if not FormatStr or "" == FormatStr then
    return "-"
  end
  local Out = {}
  local Index = 1
  local Len = #FormatStr
  while Index <= Len do
    local Char = FormatStr:sub(Index, Index)
    if "%" ~= Char then
      Out[#Out + 1] = Char
      Index = Index + 1
    elseif FormatStr:sub(Index + 1, Index + 1) == "%" then
      Out[#Out + 1] = "%"
      Index = Index + 2
    else
      local Cursor = Index + 1
      local Slice = FormatStr:sub(Cursor)
      local Flags = Slice:match("^[-+ #0]*") or ""
      Cursor = Cursor + #Flags
      Slice = FormatStr:sub(Cursor)
      local Width = Slice:match("^%d*") or ""
      Cursor = Cursor + #Width
      local Prec = ""
      if FormatStr:sub(Cursor, Cursor) == "." then
        local PrecDigits = FormatStr:sub(Cursor + 1):match("^%d*") or ""
        Prec = "." .. PrecDigits
        Cursor = Cursor + #Prec
      end
      local TypeSpec = FormatStr:sub(Cursor, Cursor):match("^[cdiouxXeEfgGaAsq]")
      if not TypeSpec then
        Out[#Out + 1] = "%"
        Index = Index + 1
      else
        local WidthNum = tonumber(Width)
        local DashCount = WidthNum and WidthNum > 0 and WidthNum or 1
        local PrecNum = tonumber(Prec:match("%d+"))
        local TypeLower = string.lower(TypeSpec)
        if ("f" == TypeLower or "e" == TypeLower or "g" == TypeLower or "a" == TypeLower) and PrecNum and PrecNum > 0 then
          Out[#Out + 1] = string.rep("-", DashCount) .. "." .. string.rep("-", PrecNum)
        else
          Out[#Out + 1] = string.rep("-", DashCount)
        end
        Index = Cursor + 1
      end
    end
  end
  if 0 == #Out then
    return "-"
  end
  return table.concat(Out)
end

function M:FormatColumnText(Value, TextMapId)
  if nil == Value then
    return nil
  end
  if not TextMapId or "" == TextMapId then
    return Value
  end
  local FormatStr = self:ResolveColumnFormat(TextMapId)
  if type(Value) == "string" and self:CountFormatSpecs(FormatStr) > 1 then
    return Value
  end
  local Ok, Result = pcall(string.format, FormatStr, Value)
  if Ok then
    return Result
  end
  DebugPrint("[ComRanking] FormatColumnText failed", tostring(FormatStr), tostring(Value), tostring(Result))
  return tostring(Value)
end

function M:FormatTextInfoLine(RankInfo, TextDecl, bPlaceholderWhenNil)
  if type(RankInfo) ~= "table" or type(TextDecl) ~= "table" then
    return nil
  end
  if not TextDecl.TextMapId or not TextDecl.ValueKey then
    return nil
  end
  local Value = RankInfo[TextDecl.ValueKey]
  local NumberValue = tonumber(Value)
  local bEmptyScore = nil == Value or "" == Value or nil ~= NumberValue and 0 == NumberValue
  if bEmptyScore then
    if bPlaceholderWhenNil then
      return self:BuildFormatPlaceholder(self:ResolveColumnFormat(TextDecl.TextMapId))
    end
    if nil == Value or "" == Value then
      return nil
    end
  end
  return self:FormatColumnText(Value, TextDecl.TextMapId)
end

function M:GetEffectiveColumnSchema(TabId)
  local Schema = self.ColumnSchema and self.ColumnSchema[TabId]
  if self.bShowTeam then
    return Schema
  end
  local Filtered = {}
  for _, ColumnDecl in ipairs(Schema or {}) do
    if ColumnDecl.Type ~= "Team" then
      table.insert(Filtered, ColumnDecl)
    end
  end
  return Filtered
end

function M:GetEffectiveHeaderNames(TabId)
  local HeaderNames = {}
  for _, ColumnDecl in ipairs(self:GetEffectiveColumnSchema(TabId) or {}) do
    local HeaderText, QaText
    if ColumnDecl.Type == "TextInfo" then
      HeaderText = ColumnDecl.HeaderName
      QaText = ColumnDecl.QaText
    else
      HeaderText = ComRankingUtils.HeaderNameByType[ColumnDecl.Type]
    end
    table.insert(HeaderNames, {
      Text = HeaderText or "",
      QaText = QaText
    })
  end
  return HeaderNames
end

function M:ApplyShowTeam(bShow)
  if self.bShowTeam == bShow then
    return
  end
  self.bShowTeam = bShow
  local TabId = self.TabId or 1
  self.SelfContents = {}
  self.HeaderColumnWidths = nil
  self.HeaderColumnWidthsByTab = {}
  self:UpdateRankInfos(TabId)
  self:UpdateSelfInfos(TabId)
  self:UpdateHeaderInfo(TabId)
  if self.Change then
    self:PlayAnimation(self.Change)
  end
end

function M:InitBackground(OnReady)
  local BgParams = self.Params.BgParams
  local BgWidgetPath = BgParams and BgParams.BgWidgetPath
  local HasBGWidget = BgParams and BgWidgetPath
  self.IsShowActor = not HasBGWidget
  if self.IsShowActor then
    self:InitRankingPreviewScene(OnReady)
  else
    self:InitBackgroundImage()
    if OnReady then
      OnReady()
    end
  end
end

function M:InitBackgroundImage()
end

function M:EnsurePreviewContext()
  if not self.PreviewContext then
    self.PreviewScene = RankingPreviewScene:New(self, {
      UIName = DataMgr.SystemUI.CommonRanking.UIName,
      PreviewInstanceKey = "CommonRanking"
    })
    if self._bStackCovered then
      self.PreviewScene.bStackCovered = true
    end
    self.PreviewContext = {
      UI = self,
      Scene = self.PreviewScene,
      Avatar = self.Avatar
    }
  else
    self.PreviewContext.Avatar = self.Avatar
  end
  return self.PreviewContext
end

function M:InitRankingPreviewScene(OnReady)
  self:EnsurePreviewContext()
  self.PreviewScene:Init(function()
    if OnReady then
      OnReady()
    end
  end)
  local TopNInfo = self.TopNRankInfo[self.PreviewActorTabId] or {}
  local RankInfo = TopNInfo[1]
  if RankInfo and RankInfo.Uid then
    self:RequestRankTargetPreview(RankInfo.Uid, RankInfo)
  elseif self.Avatar and self.Avatar.Uid then
    self:RequestRankTargetPreview(self.Avatar.Uid)
  end
end

function M:RequestRankTargetPreview(Uid, RankInfo)
  local Context = self.PreviewContext
  if not Context then
    return
  end
  Uid = tonumber(Uid)
  if not Uid or Uid <= 0 then
    return
  end
  if RankInfo then
    Context.PendingPreviewRankInfo = RankInfo
  end
  if Context.PendingPreviewUid == Uid then
    return
  end
  RankingAppearancePreview:RequestPreview(Context, Uid)
end

function M:OnPlayerRankAccessoryInfo(Obj, Ret)
  if self.PreviewContext then
    RankingAppearancePreview:HandleEventPayload(self.PreviewContext, Ret)
  end
end

function M:OnListRankItemIsHoveredChanged(Item, IsHovered)
  if not Item or Item.Empty then
    return
  end
  if IsHovered then
    self._HoveredRankContent = Item
  elseif self._HoveredRankContent == Item then
    self._HoveredRankContent = nil
  end
  if self.bRankingListScrolling then
    return
  end
  local ItemWidget = self:GetRankItemWidgetFromContent(Item)
  if ItemWidget and ItemWidget.SetRowHovered then
    ItemWidget:SetRowHovered(true == IsHovered)
  end
end

function M:ClearDisplayedRankHover()
  for _, EntryWidget in ipairs(self:GetDisplayedRankEntryWidgets()) do
    if EntryWidget and EntryWidget.ClearRowHoverVisual then
      EntryWidget:ClearRowHoverVisual()
    end
  end
end

function M:RestoreHoveredRankEntry()
  if self.IsGamePad then
    return
  end
  local Content = self._HoveredRankContent
  if not Content or Content.Empty then
    return
  end
  local ItemWidget = self:GetRankItemWidgetFromContent(Content)
  if ItemWidget and ItemWidget.SetRowHovered then
    ItemWidget._bRowHovered = false
    ItemWidget:SetRowHovered(true)
  end
end

function M:OnListRankScrolled()
  local bWasScrolling = self.bRankingListScrolling
  self.bRankingListScrolling = true
  for _, EntryWidget in ipairs(self:GetDisplayedRankEntryWidgets()) do
    if EntryWidget and EntryWidget.IsHeadMenuOpen and EntryWidget:IsHeadMenuOpen() then
      EntryWidget:CloseHeadMenu()
    end
  end
  if not bWasScrolling then
    self:ClearDisplayedRankHover()
  end
  self:RemoveTimer("RankingScrollRefresh")
  self:AddTimer(0.05, function()
    if not IsValid(self) then
      return
    end
    self.bRankingListScrolling = false
    self:RefreshDisplayedRankSelection(nil, nil)
    self:RestoreHoveredRankEntry()
  end, false, 0, "RankingScrollRefresh", true)
end

function M:GetDisplayedRankEntryWidgets()
  if not self.List_Ranking or not self.List_Ranking.GetDisplayedEntryWidgets then
    return {}
  end
  local Entries = self.List_Ranking:GetDisplayedEntryWidgets()
  if not Entries or type(Entries.ToTable) ~= "function" then
    return {}
  end
  return Entries:ToTable()
end

function M:RefreshDisplayedRankSelection(PrevRankNum, NewRankNum)
  local TabId = self.TabId or 1
  local SelectedRankNum = self.SelectedRankNumByTab and self.SelectedRankNumByTab[TabId]
  for _, EntryWidget in ipairs(self:GetDisplayedRankEntryWidgets()) do
    if EntryWidget and EntryWidget.ApplySelectedState then
      local Content = EntryWidget.Content
      local RankNum
      if Content and not Content.Empty and not Content.bIsSelfRow then
        RankNum = Content.RankNum
      end
      local bSelected = nil ~= RankNum and RankNum == SelectedRankNum
      local bPlayAnim = nil ~= RankNum and (RankNum == PrevRankNum or RankNum == NewRankNum)
      EntryWidget:ApplySelectedState(bSelected, bPlayAnim)
    end
  end
end

function M:OnListRankItemClicked(Content, bForceRefresh)
  if not Content or Content.Empty then
    return
  end
  if not bForceRefresh and not self.bAutoSelectingRankEntry then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  end
  local TabId = Content.TabId or self.TabId or 1
  local NewRankNum = Content.RankNum
  local OldRankNum = self.SelectedRankNumByTab[TabId]
  if OldRankNum == NewRankNum then
    self:RefreshDisplayedRankSelection(nil, nil)
    return
  end
  self.SelectedRankNumByTab[TabId] = NewRankNum
  self.LastClickedItem = Content
  if Content.RankNum then
    self.NavigatedRankIndex = Content.RankNum - 1
  end
  if self.IsShowActor and self._PreviewRankContent ~= Content then
    self._PreviewRankContent = Content
    self:RequestRankTargetPreview(Content.RankInfo.Uid, Content.RankInfo)
  end
  if self.bAutoSelectingRankEntry then
    self:RefreshDisplayedRankSelection(nil, nil)
  else
    self:RefreshDisplayedRankSelection(OldRankNum, NewRankNum)
  end
  return true
end

function M:ApplyRankListSelection(Index, bForceRefresh)
  local Content = self:GetRankItemContentByIndex(Index)
  if not Content or Content.Empty then
    return false
  end
  return self:OnListRankItemClicked(Content, false ~= bForceRefresh) == true
end

function M:GetRankItemContentByIndex(Index)
  Index = Index or self.NavigatedRankIndex or 0
  local TabId = self.TabId or 1
  local Contents = self.TopNContents and self.TopNContents[TabId]
  if Contents and Contents[Index + 1] and not Contents[Index + 1].Empty then
    return Contents[Index + 1]
  end
  if self.List_Ranking and self.List_Ranking.GetItemAt then
    local Item = self.List_Ranking:GetItemAt(Index)
    if Item and not Item.Empty then
      return Item
    end
  end
  return nil
end

function M:GetRankItemWidgetFromContent(Content)
  if not Content or Content.Empty then
    return nil
  end
  local Cached = Content.SelfWidget
  if Cached and Cached.Content == Content then
    return Cached
  end
  if not self.List_Ranking then
    return nil
  end
  local Index = (Content.RankNum or 1) - 1
  local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Ranking, Index)
  if EntryWidget and EntryWidget.Content == Content then
    return EntryWidget
  end
  return nil
end

function M:GetSelectedRankItemContent()
  local TabId = self.TabId or 1
  local SelectedRankNum = self.SelectedRankNumByTab and self.SelectedRankNumByTab[TabId]
  if SelectedRankNum then
    local Content = self:GetRankItemContentByIndex(SelectedRankNum - 1)
    if Content and not Content.Empty then
      return Content
    end
  end
  local Content = self.LastClickedItem
  if not Content or Content.Empty then
    Content = self:GetRankItemContentByIndex(self.NavigatedRankIndex or 0)
  end
  if Content and Content.Empty then
    return nil
  end
  return Content
end

function M:OpenSelectedRankItemHeadMenu()
  return self:OpenHeadMenuForRankContent(self:GetSelectedRankItemContent())
end

function M:GetOpenHeadMenuWidget()
  local ItemWidget = self:GetRankItemWidgetFromContent(self:GetSelectedRankItemContent())
  if ItemWidget and ItemWidget.GetHeadMenuWidget then
    return ItemWidget:GetHeadMenuWidget()
  end
  return nil
end

function M:IsSelectedItemHeadMenuOpen()
  local ItemWidget = self:GetRankItemWidgetFromContent(self:GetSelectedRankItemContent())
  return (ItemWidget and ItemWidget.IsHeadMenuOpen and ItemWidget:IsHeadMenuOpen()) == true
end

function M:OpenHeadMenuForRankContent(Content)
  if not Content or Content.Empty then
    return false
  end
  local ItemWidget = self:GetRankItemWidgetFromContent(Content)
  if ItemWidget and ItemWidget.OpenHeadMenu then
    return ItemWidget:OpenHeadMenu()
  end
  return false
end

function M:CloseOpenedRankHeadMenus(ExceptRow)
  local MyselfRow = self.Ranking_Myself
  if MyselfRow and MyselfRow ~= ExceptRow and MyselfRow.IsHeadMenuOpen and MyselfRow:IsHeadMenuOpen() then
    MyselfRow:CloseHeadMenu()
  end
  for _, EntryWidget in ipairs(self:GetDisplayedRankEntryWidgets()) do
    if EntryWidget and EntryWidget ~= ExceptRow and EntryWidget.IsHeadMenuOpen and EntryWidget:IsHeadMenuOpen() then
      EntryWidget:CloseHeadMenu()
    end
  end
end

function M:FocusSelectedListEntry(Index, bSilent)
  if not (self.List_Ranking and self.ValidItemNum) or self.ValidItemNum <= 0 then
    return
  end
  Index = Index or self.NavigatedRankIndex or 0
  if Index < 0 then
    Index = 0
  end
  if Index >= self.ValidItemNum then
    Index = self.ValidItemNum - 1
  end
  if bSilent then
    self.bAutoSelectingRankEntry = true
  end
  self.NavigatedRankIndex = Index
  local TabId = self.TabId or 1
  local bDeferScroll = self.PendingMyselfScrollIndex ~= nil
  if not bDeferScroll then
    self:ScrollRankListToIndex(Index)
  end
  
  local function IsStillValid()
    return IsValid(self) and (self.TabId or 1) == TabId
  end
  
  local Content = self:GetRankItemContentByIndex(Index)
  local bSameItem = Content and self.SelectedRankNumByTab[TabId] == Content.RankNum
  local bSelectionApplied = false
  
  local function TryApplySelection()
    if not IsStillValid() then
      return
    end
    if bSilent and bSameItem then
      self:RefreshDisplayedRankSelection(nil, nil)
      return
    end
    if bSelectionApplied then
      return
    end
    bSelectionApplied = self:ApplyRankListSelection(Index, true) == true
  end
  
  TryApplySelection()
  
  local function SyncEntryFocus()
    if not IsStillValid() or not self.List_Ranking then
      return
    end
    local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Ranking, Index)
    if EntryWidget and EntryWidget.SetFocus then
      EntryWidget:SetFocus()
    elseif self.List_Ranking.SetFocus then
      self.List_Ranking:SetFocus()
    end
  end
  
  local function EndSilentSelect()
    if bSilent and IsValid(self) then
      self.bAutoSelectingRankEntry = false
    end
  end
  
  SyncEntryFocus()
  self:RemoveTimer("RankingDeferredScroll")
  self:AddTimer(0.05, function()
    if not IsStillValid() then
      EndSilentSelect()
      return
    end
    if not bDeferScroll then
      self:ScrollRankListToIndex(Index)
    end
    SyncEntryFocus()
    TryApplySelection()
    EndSilentSelect()
  end, false, 0, "RankingDeferredScroll", true)
end

function M:GetLastClickedRankItemWidget()
  return self:GetRankItemWidgetFromContent(self:GetSelectedRankItemContent())
end

function M:OnListRankItemGamepadConfirm()
  local IsGamePad = self.IsGamePad or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if not IsGamePad then
    return false
  end
  return self:OpenSelectedRankItemHeadMenu()
end

function M:IsSelfUid(Uid)
  return ComRankingUtils.IsSameUid(Uid, self.Avatar and self.Avatar.Uid)
end

function M:GetSelfRankNumOnList(TabId)
  TabId = TabId or self.TabId or 1
  local RankNum = self.SelfRankNumByTab and self.SelfRankNumByTab[TabId]
  if RankNum and RankNum >= 1 then
    return RankNum
  end
  local Contents = self.TopNContents and self.TopNContents[TabId]
  if Contents then
    for _, Content in ipairs(Contents) do
      if Content and not Content.Empty and Content.RankInfo and self:IsSelfUid(Content.RankInfo.Uid) then
        return Content.RankNum
      end
    end
  end
  return nil
end

function M:OnMyselfButtonClicked()
  local TabId = self.TabId or 1
  local SelfRankNum = self:GetSelfRankNumOnList(TabId)
  if not SelfRankNum then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AppearanceScore_NoRanktoast"))
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  if self.Ranking_Myself and self.Ranking_Myself.ApplySelectedState then
    self.Ranking_Myself:ApplySelectedState(false, false)
  end
  local Index = SelfRankNum - 1
  local IsGamePad = self.IsGamePad or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if not IsGamePad and not self.bRankingListScrollReady then
    self.PendingMyselfScrollIndex = Index
  elseif not IsGamePad then
    self:ScrollRankListToIndex(Index)
  end
  if IsGamePad then
    self:FocusSelectedListEntry(Index, true)
    return
  end
  local TargetContent = self:GetRankItemContentByIndex(Index)
  if TargetContent and not TargetContent.Empty then
    self:OnListRankItemClicked(TargetContent, false)
  end
end

function M:TryCloseListRankItemHeadMenu()
  local ItemWidget = self:GetLastClickedRankItemWidget()
  if ItemWidget and ItemWidget.IsHeadMenuOpen and ItemWidget:IsHeadMenuOpen() then
    ItemWidget:CloseHeadMenu()
    if self.FocusSelectedItem then
      self:FocusSelectedItem()
    elseif ItemWidget.SetFocus then
      ItemWidget:SetFocus()
    end
    return true
  end
  return false
end

function M:OnHeadMenuOpenChanged(bOpen)
end

function M:UpdateBottomKeyOnSubTabChange()
end

function M:PlayInAnimation()
  self:StopAllAnimations()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "CommonRankingIn", nil)
  self:PlayAnimation(self.In)
end

function M:PlayOutAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Out)
end

function M:CloseSelf()
  if self._bIsClosing then
    return
  end
  if self:IsRankingUIHidden() then
    self:RecoverRankingUI()
  end
  if self:IsAnimationPlaying(self.In) then
    self:StopAnimation(self.In)
  end
  self._bIsClosing = true
  AudioManager(self):SetEventSoundParam(self, "CommonRankingIn", {ToEnd = 1})
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  if self.Out then
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.Out, {
      self,
      self.OnRankingOutFinished
    })
    self:PlayAnimation(self.Out)
  else
    self:OnRankingOutFinished()
  end
end

function M:OnRankingOutFinished()
  if not self._bIsClosing then
    return
  end
  self._bIsClosing = false
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BlockAllUIInput(false)
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:Close()
end

function M:ReloadWhileClosing(...)
  if not self._bIsClosing then
    return
  end
  self:UnbindAllFromAnimationFinished(self.Out)
  if self.Out then
    self:StopAnimation(self.Out)
  end
  self._bIsClosing = false
  self._bRankingShown = false
  self:BlockAllUIInput(false)
  if self.PreviewScene then
    self.PreviewScene:Destroy()
    self.PreviewScene = nil
  end
  self.PreviewContext = nil
  self:OnLoaded(...)
end

function M:FindRankingWidget(Name)
  if not Name then
    return nil
  end
  if self.GetWidgetFromName then
    local Widget = self:GetWidgetFromName(Name)
    if Widget then
      return Widget
    end
  end
  if self[Name] then
    return self[Name]
  end
  if self.WidgetTree and self.WidgetTree.FindWidget then
    return self.WidgetTree:FindWidget(Name)
  end
  return nil
end

function M:GetRankingChromeWidgetNames()
  local Names = {
    "VerticalBox_2",
    "Tab",
    "Sort_Visible",
    "BackgroundBlurWithMask_99",
    "Com_BgSwitch"
  }
  if self.IsShowActor then
    table.insert(Names, "Bg")
  end
  return Names
end

function M:IsRankingUIHidden()
  return self._bRankingUIHidden == true
end

function M:ResetRankingUIHiddenState()
  if self._bRankingUIHidden then
    self:ApplyRankingChromeHidden(false)
  end
  self._bRankingUIHidden = false
  self._SavedRankingChromeVis = nil
  self:SetRankingNavigateOpacity(1)
end

function M:SetRankingNavigateOpacity(Opacity)
  local Subsystem = self.GameInputModeSubsystem
  if not IsValid(Subsystem) then
    Subsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self.GameInputModeSubsystem = Subsystem
  end
  if IsValid(Subsystem) and Subsystem.SetNavigateWidgetOpacity then
    Subsystem:SetNavigateWidgetOpacity(Opacity)
  end
end

function M:CloseRankingOverlaysBeforeHide()
  if self.IsHeaderQaMenuOpen and self:IsHeaderQaMenuOpen() and self.CloseHeaderQaMenu then
    self:CloseHeaderQaMenu()
  end
  if self.TryCloseListRankItemHeadMenu then
    self:TryCloseListRankItemHeadMenu()
  end
  if self.TryCloseSortList then
    self:TryCloseSortList()
  end
end

function M:ApplyRankingChromeHidden(bHidden)
  if bHidden then
    self._SavedRankingChromeVis = {}
    local Names = self:GetRankingChromeWidgetNames()
    for _, Name in ipairs(Names) do
      local Widget = self:FindRankingWidget(Name)
      if Widget and Widget.GetVisibility then
        self._SavedRankingChromeVis[Name] = Widget:GetVisibility()
        Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    end
    return
  end
  local Saved = self._SavedRankingChromeVis or {}
  for Name, Vis in pairs(Saved) do
    local Widget = self:FindRankingWidget(Name)
    if Widget and Widget.SetVisibility and nil ~= Vis then
      Widget:SetVisibility(Vis)
    end
  end
  self._SavedRankingChromeVis = nil
end

function M:HideRankingUI()
  if self._bRankingUIHidden then
    return
  end
  self:CloseRankingOverlaysBeforeHide()
  self:ApplyRankingChromeHidden(true)
  self._bRankingUIHidden = true
  self:SetRankingNavigateOpacity(0)
  if self.SetFocus then
    self:SetFocus()
  end
end

function M:RecoverRankingUI()
  if not self._bRankingUIHidden then
    return
  end
  self:ApplyRankingChromeHidden(false)
  self._bRankingUIHidden = false
  self:SetRankingNavigateOpacity(1)
  if self.IsGamePad and self.FocusSelectedItem then
    self:FocusSelectedItem()
  end
end

function M:OnHideUIClick()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  if self:IsRankingUIHidden() then
    self:RecoverRankingUI()
  else
    self:HideRankingUI()
  end
end

function M:OnBackgroundClicked()
  if not self:IsRankingUIHidden() then
    return nil
  end
  self:RecoverRankingUI()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
  self:OnPointerCaptureLost()
end

AssembleComponents(M)
return M
