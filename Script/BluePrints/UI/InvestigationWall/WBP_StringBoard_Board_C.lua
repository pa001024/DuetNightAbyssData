require("UnLua")
local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
local StringBoardConfig = require("BluePrints.UI.InvestigationWall.StringBoardConfig")
local CommonConst = require("CommonConst")
local table_insert = table.insert
local table_sort = table.sort
local pairs = _ENV.pairs
local ipairs = _ENV.ipairs
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Initialize(Initializer)
  self.ClueTabList = {}
  self.ClueStructureTable = {}
  self.VisibleClueTabList = {}
  self.VisibleCluePageList = {}
  self.SelectedClueTabIndex = 1
  self.SelectedCluePageId = nil
  self.SelectedClueListIndex = 1
  self.PendingFocusSubTabListIndex = nil
  self.bPreferSubTabGamepadCursor = false
  self.bClueDetailGamepadOverlayActive = false
  self.bSkipGamepadRestoreAfterDetailClose = false
  self.LastFocusedClueTileX = nil
  self.LastFocusedClueTileY = nil
  self.RestoreDetailFocusX = nil
  self.RestoreDetailFocusY = nil
  self.CurrentClueTileDataList = {}
  self.ClueIndexToTileCoordinate = {}
  self.ClueItemInStaggerToken = 0
  self.bClueItemInStaggerAwaitingGenerate = false
  self.ClueItemInStaggerExpectedCoordinates = nil
  self.ClueItemInStaggerWidgetByCoordinate = nil
  self.SelectedClueItemWidget = nil
  self.FocusedClueItemWidget = nil
  self.bClueTileAcceptPressed = false
  self.ActiveClueItemWidgetByClueId = {}
  self.bSubTabStickArmed = true
  self.bBoardHorizontalStickArmed = true
end

function M:Init()
  self:BuildClueStructureTable()
  self:InitMainUI()
  self:BindTilePanelEvents()
  self:InitPanelParams()
  self:RefreshBoard()
  self:BindBoardNewReddotListener()
  self:InitGamePad()
end

function M:InitPanelParams()
  local TilePanel = self.Group_Item
  if not TilePanel or not TilePanel.SetContentSize then
    return
  end
  if not TilePanel.bUseFixedGrid then
    return
  end
  local ColumnCount = TilePanel.FixedGridWidth or 0
  local RowCount = TilePanel.FixedGridHeight or 0
  if ColumnCount < 1 or RowCount < 1 then
    return
  end
  local SizeX, SizeY = 0, 0
  local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(TilePanel)
  local SlotSize = CanvasSlot and CanvasSlot.GetSize and CanvasSlot:GetSize()
  if SlotSize then
    SizeX = SlotSize.X or 0
    SizeY = SlotSize.Y or 0
  end
  if SizeX <= 0 or SizeY <= 0 then
    if TilePanel.ForceLayoutPrepass then
      TilePanel:ForceLayoutPrepass()
    end
    local PanelSize = UE4.USlateBlueprintLibrary.GetLocalSize(TilePanel:GetCachedGeometry())
    SizeX = PanelSize and PanelSize.X or 0
    SizeY = PanelSize and PanelSize.Y or 0
  end
  if SizeX <= 0 or SizeY <= 0 then
    return
  end
  local ExpectedSizeX = SizeX / ColumnCount
  local ExpectedSizeY = SizeY / RowCount
  local CurrentSize = TilePanel.Config and TilePanel.Config.ContentSize
  local CurrentX = CurrentSize and CurrentSize.X or 0
  local CurrentY = CurrentSize and CurrentSize.Y or 0
  if math.abs(CurrentX - ExpectedSizeX) < 0.5 and math.abs(CurrentY - ExpectedSizeY) < 0.5 then
    return
  end
  TilePanel:SetContentSize(UE4.FVector2D(ExpectedSizeX, ExpectedSizeY))
end

function M:Destruct()
  self:UnbindBoardNewReddotListener()
  self:CancelClueItemInStagger()
  if self.CleanTimer then
    self:CleanTimer()
  end
  self:ClearSelectedClueItem()
  self:ClearFocusedClueItemVisual()
  self:UnbindSubTabEntryInitialized()
  self:UnbindTilePanelEvents()
  self:UnbindBoardBackgroundButton()
  self:UnbindBoardKeyTipsInputListen()
  self.PendingFocusSubTabListIndex = nil
  self.bSkipGamepadRestoreAfterDetailClose = nil
  self:ClearSubTabNavigationLock()
  self.CurrentClueTileDataList = {}
  self.ClueIndexToTileCoordinate = {}
  self.ActiveClueItemWidgetByClueId = {}
  self.ClueTabList = {}
  self.ClueStructureTable = {}
  self.VisibleClueTabList = {}
  self.VisibleCluePageList = {}
  self.SelectedClueTabIndex = nil
  self.SelectedCluePageId = nil
  self.SelectedClueListIndex = nil
  self.bSubTabStickArmed = nil
  self.bBoardHorizontalStickArmed = nil
end

function M:BuildClueStructureTable()
  self.ClueStructureTable = InvestigationWallUtils.BuildClueStructureTable()
end

function M:InitMainUI()
  self.ClueTabList = {
    self.Tab_1,
    self.Tab_2,
    self.Tab_3
  }
  if self.Board_Detail and self.Board_Detail.InitUI then
    self.Board_Detail:InitUI(self)
  end
  self:BindBoardBackgroundButton()
end

function M:BindBoardBackgroundButton()
  local BoardBackgroundButton = self.Btn_BoardBG
  if not BoardBackgroundButton or not BoardBackgroundButton.OnClicked then
    return
  end
  BoardBackgroundButton.OnClicked:Clear()
  BoardBackgroundButton.OnClicked:Add(self, self.OnBoardBackgroundButtonClicked)
end

function M:UnbindBoardBackgroundButton()
  local BoardBackgroundButton = self.Btn_BoardBG
  if not BoardBackgroundButton or not BoardBackgroundButton.OnClicked then
    return
  end
  BoardBackgroundButton.OnClicked:Remove(self, self.OnBoardBackgroundButtonClicked)
end

function M:OnBoardBackgroundButtonClicked()
  self:HideClueDetail()
end

function M:ResetBoardInteractionState()
  self:HideClueDetail()
  local TilePanel = self.Group_Item
  if TilePanel and TilePanel.ClearFocus then
    TilePanel:ClearFocus()
  end
end

function M:RefreshInitialState()
  self:ResetBoardInteractionState()
  if not self.VisibleClueTabList or 0 == #self.VisibleClueTabList then
    return
  end
  local PreviousTabIndex = self.SelectedClueTabIndex
  self.SelectedClueTabIndex = 1
  self:RefreshClueTabState()
  if 1 ~= PreviousTabIndex then
    self:RefreshClueListInfo()
    self:RefreshClueListState()
  end
end

function M:IsClueDetailShowing()
  local BoardDetail = self.Board_Detail
  return BoardDetail and BoardDetail.IsShowing and BoardDetail:IsShowing()
end

function M:IsClueDetailGamepadLocked()
  return self.bClueDetailGamepadOverlayActive == true
end

function M:HideClueDetail()
  local BoardDetail = self.Board_Detail
  if not BoardDetail then
    return
  end
  if BoardDetail.RequestHide then
    BoardDetail:RequestHide()
  elseif BoardDetail.Hide then
    BoardDetail:Hide()
    self:OnClueDetailHidden()
  end
end

function M:ShowClueDetail(Content, ClueState)
  if self.Board_Detail and self.Board_Detail.ShowClueDetail then
    return self.Board_Detail:ShowClueDetail(Content, ClueState) == true
  end
  return false
end

function M:SnapBoardAnimationToEnd(Animation)
  if not Animation or not self.PlayAnimation then
    return
  end
  if self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(Animation)
  end
  local EndTime = Animation.GetEndTime and Animation:GetEndTime() or nil
  if EndTime then
    self:PlayAnimation(Animation, EndTime)
    if self.SetAnimationCurrentTime then
      self:SetAnimationCurrentTime(Animation, EndTime)
    end
  else
    self:PlayAnimation(Animation)
  end
  if self.StopAnimation then
    self:StopAnimation(Animation)
  end
end

function M:PlayBoardDetailInAnimation()
  if self.Detail_Out then
    self:SnapBoardAnimationToEnd(self.Detail_Out)
  end
  local DetailInAnim = self.Detail_In
  if not DetailInAnim or not self.PlayAnimation then
    return
  end
  if self.IsAnimationPlaying and self:IsAnimationPlaying(DetailInAnim) and self.StopAnimation then
    self:StopAnimation(DetailInAnim)
  end
  self:PlayAnimation(DetailInAnim)
end

function M:PlayBoardDetailOutAnimation()
  if self.Detail_In then
    self:SnapBoardAnimationToEnd(self.Detail_In)
  end
  local DetailOutAnim = self.Detail_Out
  if not DetailOutAnim or not self.PlayAnimation then
    return
  end
  if self.IsAnimationPlaying and self:IsAnimationPlaying(DetailOutAnim) and self.StopAnimation then
    self:StopAnimation(DetailOutAnim)
  end
  self:PlayAnimation(DetailOutAnim)
end

function M:OnClueDetailShown()
  self:ApplyGamepadWhileDetailOpen()
end

function M:OnClueDetailCloseBegin()
  local bSkipTileRestore = self.bSkipGamepadRestoreAfterDetailClose == true
  self:RestoreGamepadAfterDetailClose()
  if UIUtils.IsGamepadInput() and not bSkipTileRestore then
    self:ApplyFocusedClueItemHover()
  end
end

function M:OnClueDetailHidden()
  self:ClearSelectedClueItem()
  if not self.bClueDetailGamepadOverlayActive then
    return
  end
  local bSkipTileRestore = self.bSkipGamepadRestoreAfterDetailClose == true
  self:RestoreGamepadAfterDetailClose()
  if UIUtils.IsGamepadInput() and not bSkipTileRestore then
    self:ApplyFocusedClueItemHover()
  end
end

function M:ClearSelectedClueItem()
  local SelectedClueItemWidget = self.SelectedClueItemWidget
  self.SelectedClueItemWidget = nil
  if SelectedClueItemWidget and IsValid(SelectedClueItemWidget) and SelectedClueItemWidget.ClearClueItemSelected then
    SelectedClueItemWidget:ClearClueItemSelected()
  end
end

function M:SetSelectedClueItem(ClueItemWidget)
  if not ClueItemWidget then
    self:ClearSelectedClueItem()
    return
  end
  if self.SelectedClueItemWidget == ClueItemWidget then
    return
  end
  self:ClearSelectedClueItem()
  self.SelectedClueItemWidget = ClueItemWidget
  if ClueItemWidget.ApplyClueItemSelected then
    ClueItemWidget:ApplyClueItemSelected()
  end
end

function M:OnClueItemClicked(Content, ClueState, ClueItemWidget)
  if not Content or ClueState == CommonConst.ClueState.Locked then
    return
  end
  if ClueItemWidget then
    if self.SelectedClueItemWidget == ClueItemWidget then
      return
    end
    self:SetSelectedClueItem(ClueItemWidget)
  else
    self:ClearSelectedClueItem()
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/camera_photo_click", nil, nil)
  if self:ShowClueDetail(Content, ClueState) then
    StringBoardReddotHelper.ClearClueItemNews(Content.ClueId)
  end
end

function M:HideGamepadNavigateCursor()
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if not GameInputModeSubsystem then
    return
  end
  if GameInputModeSubsystem.SetShowFocusedWidget then
    GameInputModeSubsystem:SetShowFocusedWidget(nil)
  end
  if GameInputModeSubsystem.SetNavigateWidgetVisibility then
    GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
  end
end

function M:RefreshNavigateCursorWhileDetailOpen()
  if not self.bClueDetailGamepadOverlayActive and not self:IsClueDetailShowing() then
    return
  end
  if UIUtils.IsGamepadInput() then
    self:ApplyGamepadWhileDetailOpen()
    return
  end
  self:HideGamepadNavigateCursor()
end

function M:ApplyGamepadWhileDetailOpen()
  if not UIUtils.IsGamepadInput() then
    return
  end
  self:ClearClueTileAcceptPressed()
  if not self.bClueDetailGamepadOverlayActive then
    self.bClueDetailGamepadOverlayActive = true
    self.RestoreDetailFocusX = self.LastFocusedClueTileX
    self.RestoreDetailFocusY = self.LastFocusedClueTileY
    self:NotifyOwnerBoardCanOpenDetailKeyTip(false)
  end
  self:HideGamepadNavigateCursor()
  local BoardDetail = self.Board_Detail
  if BoardDetail and BoardDetail.ApplyGamepadDetailFocus then
    BoardDetail:ApplyGamepadDetailFocus()
  end
end

function M:RestoreGamepadAfterDetailClose()
  if not self.bClueDetailGamepadOverlayActive then
    self.bSkipGamepadRestoreAfterDetailClose = false
    return
  end
  local bSkipTileRestore = self.bSkipGamepadRestoreAfterDetailClose == true
  self.bSkipGamepadRestoreAfterDetailClose = false
  self.bClueDetailGamepadOverlayActive = false
  local PosX = self.RestoreDetailFocusX
  local PosY = self.RestoreDetailFocusY
  self.RestoreDetailFocusX = nil
  self.RestoreDetailFocusY = nil
  self:SetDetailListScrollKeyTip(false)
  local BoardDetail = self.Board_Detail
  if BoardDetail and BoardDetail.ClearGamepadDetailFocus then
    BoardDetail:ClearGamepadDetailFocus()
  end
  if not UIUtils.IsGamepadInput() then
    return
  end
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem and GameInputModeSubsystem.SetNavigateWidgetVisibility then
    GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
  end
  if bSkipTileRestore then
    self:FocusTargetSubTabAfterSwitch((self.SelectedClueListIndex or 1) - 1)
    return
  end
  local TilePanel = self.Group_Item
  if not TilePanel then
    return
  end
  if TilePanel.SetFocus then
    TilePanel:SetFocus()
  end
  if nil == PosX or nil == PosY or not TilePanel.SetFocusedTile then
    return
  end
  local SavedFocusScrollDuration = TilePanel.FocusScrollDuration
  if nil ~= SavedFocusScrollDuration then
    TilePanel.FocusScrollDuration = 0
  end
  TilePanel:SetFocusedTile(PosX, PosY)
  if nil ~= SavedFocusScrollDuration then
    TilePanel.FocusScrollDuration = SavedFocusScrollDuration
  end
end

function M:MarkSkipGamepadRestoreAfterDetailCloseIfNeeded()
  if self.bClueDetailGamepadOverlayActive or self:IsClueDetailShowing() then
    self.bSkipGamepadRestoreAfterDetailClose = true
  end
end

function M:SetDetailListScrollKeyTip(bCanScroll)
  local OwnerStringBoard = self.OwnerStringBoard
  if OwnerStringBoard and OwnerStringBoard.SetBoardDetailListScrollKeyTip then
    OwnerStringBoard:SetBoardDetailListScrollKeyTip(bCanScroll)
  end
end

function M:BindTilePanelEvents()
  local TilePanel = self.Group_Item
  if not TilePanel then
    return
  end
  if TilePanel.OnTileWidgetGenerated then
    TilePanel.OnTileWidgetGenerated:Clear()
    TilePanel.OnTileWidgetGenerated:Add(self, self.OnClueTileWidgetGenerated)
  end
  if TilePanel.OnTileWidgetReleased then
    TilePanel.OnTileWidgetReleased:Clear()
    TilePanel.OnTileWidgetReleased:Add(self, self.OnClueTileWidgetReleased)
  end
  if TilePanel.OnTileItemClicked then
    TilePanel.OnTileItemClicked:Clear()
    TilePanel.OnTileItemClicked:Add(self, self.OnClueTileItemClicked)
  end
  if TilePanel.OnTileFocusChanged then
    TilePanel.OnTileFocusChanged:Clear()
    TilePanel.OnTileFocusChanged:Add(self, self.OnClueTileFocusChanged)
  end
  if TilePanel.OnNavigateBoundary then
    TilePanel.OnNavigateBoundary:Clear()
    TilePanel.OnNavigateBoundary:Add(self, self.OnClueTileNavigateBoundary)
  end
end

function M:UnbindTilePanelEvents()
  local TilePanel = self.Group_Item
  if not TilePanel then
    return
  end
  if TilePanel.OnTileWidgetGenerated then
    TilePanel.OnTileWidgetGenerated:Remove(self, self.OnClueTileWidgetGenerated)
  end
  if TilePanel.OnTileWidgetReleased then
    TilePanel.OnTileWidgetReleased:Remove(self, self.OnClueTileWidgetReleased)
  end
  if TilePanel.OnTileItemClicked then
    TilePanel.OnTileItemClicked:Remove(self, self.OnClueTileItemClicked)
  end
  if TilePanel.OnTileFocusChanged then
    TilePanel.OnTileFocusChanged:Remove(self, self.OnClueTileFocusChanged)
  end
  if TilePanel.OnNavigateBoundary then
    TilePanel.OnNavigateBoundary:Remove(self, self.OnClueTileNavigateBoundary)
  end
end

function M:OnClueTileWidgetReleased(ItemData)
  local ClueId = ItemData and ItemData.ContentObject and ItemData.ContentObject.ClueId
  local ChildWidget = ItemData and ItemData.Widget
  if ClueId and self.ActiveClueItemWidgetByClueId and self.ActiveClueItemWidgetByClueId[ClueId] == ChildWidget then
    self.ActiveClueItemWidgetByClueId[ClueId] = nil
  end
end

function M:OnClueTileWidgetGenerated(ItemData)
  local ChildWidget = ItemData.Widget
  if ChildWidget and ChildWidget.OnTileItemSet then
    ChildWidget:OnTileItemSet(ItemData.ContentObject)
  end
  if ChildWidget and ChildWidget.Btn_Click then
    self:SetWidgetFocusable(ChildWidget.Btn_Click, false)
  end
  local ClueId = ItemData and ItemData.ContentObject and ItemData.ContentObject.ClueId
  if ClueId and ChildWidget then
    self.ActiveClueItemWidgetByClueId = self.ActiveClueItemWidgetByClueId or {}
    self.ActiveClueItemWidgetByClueId[ClueId] = ChildWidget
  end
  if ItemData and ItemData.bFocused and ChildWidget then
    self.FocusedClueItemWidget = ChildWidget
    self:ApplyClueItemFocusVisual(ChildWidget, true)
  end
  if not self.bClueItemInStaggerAwaitingGenerate or not ChildWidget then
    return
  end
  local CoordinateKey = self:MakeClueItemStaggerCoordinateKey(ItemData.X, ItemData.Y)
  if not CoordinateKey then
    return
  end
  self.ClueItemInStaggerWidgetByCoordinate = self.ClueItemInStaggerWidgetByCoordinate or {}
  self.ClueItemInStaggerWidgetByCoordinate[CoordinateKey] = ChildWidget
  self:TryStartClueItemInStaggerIfReady()
end

function M:OnClueTileFocusChanged(ItemData)
  local bCanOpenDetail = false
  local ChildWidget = ItemData and ItemData.Widget
  if ItemData and ItemData.bFocused then
    self.LastFocusedClueTileX = ItemData.X
    self.LastFocusedClueTileY = ItemData.Y
    bCanOpenDetail = self:CanOpenClueDetailFromContent(ItemData.ContentObject)
    self.FocusedClueItemWidget = ChildWidget
    self:ApplyClueItemFocusVisual(ChildWidget, true)
  else
    self:ClearClueTileAcceptPressed()
    if not self:IsClueDetailShowing() then
      self:ResetClueItemInteractionVisual(ChildWidget)
    end
    if self.FocusedClueItemWidget == ChildWidget then
      self.FocusedClueItemWidget = nil
    end
  end
  self:NotifyOwnerBoardCanOpenDetailKeyTip(bCanOpenDetail)
end

function M:ApplyClueItemFocusVisual(ClueItemWidget, bFocused)
  if not ClueItemWidget or not IsValid(ClueItemWidget) then
    return
  end
  if bFocused then
    if ClueItemWidget.PlayClueItemHoverVisual then
      ClueItemWidget:PlayClueItemHoverVisual()
    elseif ClueItemWidget.OnClueItemHovered then
      ClueItemWidget:OnClueItemHovered()
    end
  end
end

function M:ResetClueItemInteractionVisual(ClueItemWidget)
  if not ClueItemWidget or not IsValid(ClueItemWidget) then
    return
  end
  if ClueItemWidget.ResetClueItemInteractionVisual then
    ClueItemWidget:ResetClueItemInteractionVisual()
  end
end

function M:ApplyFocusedClueItemHover()
  self:ApplyClueItemFocusVisual(self.FocusedClueItemWidget, true)
end

function M:ClearClueTileAcceptPressed()
  self.bClueTileAcceptPressed = false
end

function M:ClearFocusedClueItemVisual()
  self:ClearClueTileAcceptPressed()
  self:ResetClueItemInteractionVisual(self.FocusedClueItemWidget)
  self.FocusedClueItemWidget = nil
  self.LastFocusedClueTileX = nil
  self.LastFocusedClueTileY = nil
end

function M:CanOpenClueDetailFromContent(Content)
  if not Content or not Content.ClueId then
    return false
  end
  return self:CheckClueState(Content.ClueId) ~= CommonConst.ClueState.Locked
end

function M:NotifyOwnerBoardCanOpenDetailKeyTip(bCanOpenDetail)
  local OwnerStringBoard = self.OwnerStringBoard
  if OwnerStringBoard and OwnerStringBoard.SetBoardCanOpenDetailKeyTip then
    OwnerStringBoard:SetBoardCanOpenDetailKeyTip(bCanOpenDetail)
  end
end

function M:OnClueTileItemClicked(ItemData)
  local ChildWidget = ItemData and ItemData.Widget
  if ChildWidget and ChildWidget.OnClueItemClicked then
    ChildWidget:OnClueItemClicked()
    return
  end
  local Content = ItemData and ItemData.ContentObject
  if not Content then
    return
  end
  local ClueState = self:CheckClueState(Content.ClueId)
  self:OnClueItemClicked(Content, ClueState)
end

function M:RefreshBoard()
  StringBoardReddotHelper.SyncBoardNews(self.ClueStructureTable)
  self:RefreshClueTabInfo()
  self:RefreshClueListInfo()
  self:RefreshClueListState()
  self:RefreshAllBoardNewReddot()
end

function M:BindBoardNewReddotListener()
  StringBoardReddotHelper.EnsureNodes()
  ReddotManager.AddListenerEx(StringBoardReddotHelper.NodeName.BoardNew, self, self.OnBoardNewReddotChanged)
end

function M:UnbindBoardNewReddotListener()
  ReddotManager.RemoveListener(StringBoardReddotHelper.NodeName.BoardNew, self)
end

function M:OnBoardNewReddotChanged(Count, RdType, Name)
  self:RefreshAllBoardNewReddot()
end

function M:RefreshAllBoardNewReddot()
  for _, TabWidget in ipairs(self.ClueTabList or {}) do
    if TabWidget and TabWidget.RefreshStringBoardNewReddot then
      TabWidget:RefreshStringBoardNewReddot()
    end
  end
  local ListSubTab = self.List_SubTab
  if ListSubTab then
    if ListSubTab.GetDisplayedEntryWidgets then
      local DisplayedEntryWidgets = ListSubTab:GetDisplayedEntryWidgets()
      if DisplayedEntryWidgets then
        for _, EntryWidget in pairs(DisplayedEntryWidgets) do
          if EntryWidget and EntryWidget.RefreshStringBoardNewReddot then
            EntryWidget:RefreshStringBoardNewReddot()
          end
        end
      end
    else
      local ItemCount = ListSubTab.GetNumItems and ListSubTab:GetNumItems() or 0
      for ItemIndex = 0, ItemCount - 1 do
        local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(ListSubTab, ItemIndex)
        if EntryWidget and EntryWidget.RefreshStringBoardNewReddot then
          EntryWidget:RefreshStringBoardNewReddot()
        end
      end
    end
  end
  for _, ClueItemWidget in pairs(self.ActiveClueItemWidgetByClueId or {}) do
    if ClueItemWidget and ClueItemWidget.RefreshStringBoardNewReddot then
      ClueItemWidget:RefreshStringBoardNewReddot()
    end
  end
end

function M:CheckPageTypeHasUnlockedCluePage(PageTypeData)
  if not PageTypeData then
    return false
  end
  for _, CluePageEntry in ipairs(PageTypeData.CluePageList or {}) do
    if self:CheckCluePageUnlockCondition(CluePageEntry.CluePageId) then
      return true
    end
  end
  return false
end

function M:BuildVisibleClueTabList()
  local VisibleClueTabList = {}
  for StructureIndex, PageTypeData in ipairs(self.ClueStructureTable or {}) do
    if self:CheckPageTypeHasUnlockedCluePage(PageTypeData) then
      table_insert(VisibleClueTabList, {
        StructureIndex = StructureIndex,
        ClueTypeID = PageTypeData.PageType
      })
    end
  end
  return VisibleClueTabList
end

function M:GetPageTypeDataByDisplayIndex(DisplayIndex)
  local VisibleTabData = self.VisibleClueTabList and self.VisibleClueTabList[DisplayIndex]
  if not VisibleTabData then
    return nil
  end
  return self.ClueStructureTable and self.ClueStructureTable[VisibleTabData.StructureIndex]
end

function M:RefreshClueTabWidget(DisplayIndex, TabWidget, VisibleTabData)
  if not TabWidget then
    return
  end
  if VisibleTabData and TabWidget.InitUI then
    TabWidget:InitUI(self, DisplayIndex, VisibleTabData.ClueTypeID, self.SelectedClueTabIndex == DisplayIndex)
  elseif TabWidget.RefreshClueTabState then
    TabWidget:RefreshClueTabState(false, false)
  else
    TabWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshClueTabInfo()
  self.VisibleClueTabList = self:BuildVisibleClueTabList()
  local VisibleTabCount = #self.VisibleClueTabList
  if VisibleTabCount > 0 then
    self.SelectedClueTabIndex = 1
  else
    self.SelectedClueTabIndex = nil
  end
  for DisplayIndex, TabWidget in ipairs(self.ClueTabList) do
    local VisibleTabData = self.VisibleClueTabList[DisplayIndex]
    self:RefreshClueTabWidget(DisplayIndex, TabWidget, VisibleTabData)
  end
end

function M:BuildVisibleCluePageList(CluePageList)
  local VisibleCluePageList = {}
  for _, CluePageEntry in ipairs(CluePageList or {}) do
    if self:CheckCluePageUnlockCondition(CluePageEntry.CluePageId) then
      table_insert(VisibleCluePageList, {
        CluePageId = CluePageEntry.CluePageId
      })
    end
  end
  return VisibleCluePageList
end

function M:RefreshClueListInfo(ListIndex)
  ListIndex = ListIndex or self.SelectedClueTabIndex or 1
  local ListSubTab = self.List_SubTab
  if not ListSubTab then
    return
  end
  local PageTypeData = self:GetPageTypeDataByDisplayIndex(ListIndex)
  if not PageTypeData then
    self.VisibleCluePageList = {}
    self.SelectedCluePageId = nil
    self.SelectedClueListIndex = nil
    self:ResetDisplayedSubTabVisuals()
    ListSubTab:ClearListItems()
    return
  end
  self.VisibleCluePageList = self:BuildVisibleCluePageList(PageTypeData.CluePageList)
  local VisiblePageCount = #self.VisibleCluePageList
  if VisiblePageCount > 0 then
    self.SelectedClueListIndex = 1
    self.SelectedCluePageId = self.VisibleCluePageList[1].CluePageId
  else
    self.SelectedClueListIndex = nil
    self.SelectedCluePageId = nil
  end
  self:ResetDisplayedSubTabVisuals()
  ListSubTab:ClearListItems()
  for Index, VisibleCluePageEntry in ipairs(self.VisibleCluePageList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.CluePageId = VisibleCluePageEntry.CluePageId
    Content.Parent = self
    Content.Index = Index
    ListSubTab:AddItem(Content)
  end
  if self.SelectedCluePageId then
    self:RefreshClueItemInfo(self.SelectedCluePageId)
  elseif self.Group_Item then
    self:CancelClueItemInStagger()
    self:ClearSelectedClueItem()
    self.Group_Item:ClearTiles()
    self:NotifyOwnerBoardCanOpenDetailKeyTip(false)
  end
end

function M:ResetDisplayedSubTabVisuals()
  local ListSubTab = self.List_SubTab
  if not ListSubTab then
    return
  end
  if ListSubTab.GetDisplayedEntryWidgets then
    local DisplayedEntryWidgets = ListSubTab:GetDisplayedEntryWidgets()
    if DisplayedEntryWidgets then
      for _, EntryWidget in pairs(DisplayedEntryWidgets) do
        if EntryWidget and EntryWidget.ResetSubTabInteractionVisual then
          EntryWidget:ResetSubTabInteractionVisual()
        end
      end
    end
    return
  end
  local ItemCount = ListSubTab.GetNumItems and ListSubTab:GetNumItems() or 0
  for ItemIndex = 0, ItemCount - 1 do
    local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(ListSubTab, ItemIndex)
    if EntryWidget and EntryWidget.ResetSubTabInteractionVisual then
      EntryWidget:ResetSubTabInteractionVisual()
    end
  end
end

function M:RefreshClueTabState()
  for DisplayIndex, TabWidget in ipairs(self.ClueTabList or {}) do
    if TabWidget then
      local VisibleTabData = self.VisibleClueTabList and self.VisibleClueTabList[DisplayIndex]
      local bCanShow = nil ~= VisibleTabData
      local bIsSelected = bCanShow and self.SelectedClueTabIndex == DisplayIndex
      if TabWidget.RefreshClueTabState then
        TabWidget:RefreshClueTabState(bCanShow, bIsSelected)
      else
        TabWidget:SetVisibility(bCanShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
      end
    end
  end
end

function M:RefreshClueListState(ListIndex)
  ListIndex = ListIndex or self.SelectedClueTabIndex or 1
  local ListSubTab = self.List_SubTab
  if not ListSubTab then
    return
  end
  local ItemCount = ListSubTab:GetNumItems()
  for ItemIndex = 0, ItemCount - 1 do
    local Content = ListSubTab:GetItemAt(ItemIndex)
    local CluePageId = Content and Content.CluePageId
    local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(ListSubTab, ItemIndex)
    if EntryWidget and EntryWidget.RefreshClueListState then
      local bCanShow = CluePageId and self:CheckClueListCanShow(CluePageId) or false
      local bIsSelected = Content and Content.Index and self.SelectedClueListIndex == Content.Index or false
      EntryWidget:RefreshClueListState(bCanShow, bIsSelected)
    end
  end
end

function M:GetCluePageClueList(CluePageId)
  for _, PageTypeData in ipairs(self.ClueStructureTable or {}) do
    for _, CluePageEntry in ipairs(PageTypeData.CluePageList or {}) do
      if CluePageEntry.CluePageId == CluePageId then
        return CluePageEntry.ClueList or {}
      end
    end
  end
  return {}
end

function M:CheckClueItemCanShow(ClueId)
  if not ClueId then
    return false
  end
  return DataMgr.Clue and DataMgr.Clue[ClueId] ~= nil
end

function M:CheckClueListCanShow(CluePageId)
  if not CluePageId then
    return false
  end
  if not self:CheckCluePageUnlockCondition(CluePageId) then
    return false
  end
  local ClueList = self:GetCluePageClueList(CluePageId)
  for _, ClueId in ipairs(ClueList) do
    if self:CheckClueItemCanShow(ClueId) then
      return true
    end
  end
  return false
end

function M:CheckCluePageUnlockCondition(CluePageId)
  return InvestigationWallUtils.CheckCluePageUnlockCondition(CluePageId)
end

function M:OnClueTabClick(DisplayIndex)
  if not DisplayIndex then
    return
  end
  local VisibleTabData = self.VisibleClueTabList and self.VisibleClueTabList[DisplayIndex]
  if not VisibleTabData then
    return
  end
  if self.SelectedClueTabIndex == DisplayIndex then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  self:MarkSkipGamepadRestoreAfterDetailCloseIfNeeded()
  self:HideClueDetail()
  self.SelectedClueTabIndex = DisplayIndex
  self:RefreshClueTabState()
  self:RefreshClueListInfo()
  self:RefreshClueListState()
  if UIUtils.IsGamepadInput() then
    self:FocusFirstSubTabAfterTabSwitch()
  end
end

function M:OnClueSubTabClick(ListIndex, CluePageId)
  if not CluePageId or not self:CheckCluePageUnlockCondition(CluePageId) then
    return
  end
  if self.SelectedCluePageId == CluePageId then
    if UIUtils.IsGamepadInput() then
      self:PinCurrentSubTabGamepadFocus()
    end
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
  self:MarkSkipGamepadRestoreAfterDetailCloseIfNeeded()
  self:HideClueDetail()
  self.SelectedCluePageId = CluePageId
  self.SelectedClueListIndex = ListIndex
  self:RefreshClueListState()
  self:RefreshClueItemInfo(CluePageId)
  if UIUtils.IsGamepadInput() then
    self:FocusTargetSubTabAfterSwitch((ListIndex or 1) - 1)
  end
end

function M:BuildClueTileContentObject(ClueId, ClueConfig)
  ClueConfig = ClueId and DataMgr.Clue and DataMgr.Clue[ClueId] or ClueConfig
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.ClueId = ClueId
  Content.ClueConfig = ClueConfig
  Content.ClueType = ClueConfig.ClueType
  Content.ClueName = ClueConfig.ClueName
  Content.CluePic1 = ClueConfig.CluePic1
  Content.CluePic2 = ClueConfig.CluePic2
  Content.ClueContentIdList = ClueConfig.ClueContent or {}
  Content.Parent = self
  return Content
end

function M:RefreshClueItemInfo(CluePageId)
  CluePageId = CluePageId or self.SelectedCluePageId
  local TilePanel = self.Group_Item
  if not TilePanel or not CluePageId then
    return
  end
  self:CancelClueItemInStagger()
  self:ClearSelectedClueItem()
  self:ClearFocusedClueItemVisual()
  if UIUtils.IsGamepadInput() then
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if GameInputModeSubsystem and GameInputModeSubsystem.SetShowFocusedWidget then
      GameInputModeSubsystem:SetShowFocusedWidget(nil)
    end
  end
  TilePanel:ClearTiles()
  self.ActiveClueItemWidgetByClueId = {}
  self:NotifyOwnerBoardCanOpenDetailKeyTip(false)
  self.CurrentClueTileDataList = {}
  self.ClueIndexToTileCoordinate = {}
  local ClueList = self:GetCluePageClueList(CluePageId)
  local VisibleClueList = {}
  for _, ClueId in ipairs(ClueList) do
    if self:CheckClueItemCanShow(ClueId) then
      table_insert(VisibleClueList, ClueId)
    end
  end
  local MaxItemCount = 0
  if TilePanel.bUseFixedGrid then
    local GridWidth = TilePanel.FixedGridWidth or 0
    local GridHeight = TilePanel.FixedGridHeight or 0
    if GridWidth > 0 and GridHeight > 0 then
      MaxItemCount = GridWidth * GridHeight
    end
  end
  local TileDataList = InvestigationWallUtils.BuildTilePositionDataFromClueList(VisibleClueList, MaxItemCount)
  self.CurrentClueTileDataList = TileDataList
  local AddedTileCoordinateList = {}
  self.bClueItemInStaggerAwaitingGenerate = true
  self.ClueItemInStaggerWidgetByCoordinate = {}
  self.ClueItemInStaggerExpectedCoordinates = nil
  local TileContentSize = TilePanel.Config and TilePanel.Config.ContentSize
  for _, TileData in ipairs(TileDataList) do
    local Position = TileData.Position
    local DataContent = TileData.Content or {}
    local ClueId = DataContent.ClueId
    local ClueConfig = DataContent.ClueConfig
    if ClueId and ClueConfig then
      local Content = self:BuildClueTileContentObject(ClueId, ClueConfig)
      Content.ClueIndex = DataContent.ClueIndex
      Content.PosX = Position.X
      Content.PosY = Position.Y
      Content.Angle = TileData.Angle or 0
      local OffsetX, OffsetY = InvestigationWallUtils.ResolveTileOffsetFromContent(Content, TileContentSize, TileData.Offset)
      local WidgetClassPath = TileData.WidgetClass
      if WidgetClassPath then
        local PosX = math.floor((Position.X or 0) + 0.5)
        local PosY = math.floor((Position.Y or 0) + 0.5)
        local ClueState = self:CheckClueState(ClueId)
        local bFocusable = ClueState ~= CommonConst.ClueState.Locked
        TilePanel:AddTileContent(PosX, PosY, LoadClass(WidgetClassPath), UE4.FVector2D(OffsetX, OffsetY), Content, TileData.Angle or 0, bFocusable)
        table_insert(AddedTileCoordinateList, {X = PosX, Y = PosY})
        if bFocusable and nil ~= DataContent.ClueIndex then
          self.ClueIndexToTileCoordinate[DataContent.ClueIndex] = {X = PosX, Y = PosY}
        end
      end
    end
  end
  self.ClueItemInStaggerExpectedCoordinates = AddedTileCoordinateList
  self:TryStartClueItemInStaggerIfReady()
end

function M:MakeClueItemStaggerCoordinateKey(PosX, PosY)
  if nil == PosX or nil == PosY then
    return nil
  end
  return tostring(PosX) .. "_" .. tostring(PosY)
end

function M:CancelClueItemInStagger()
  self.ClueItemInStaggerToken = (self.ClueItemInStaggerToken or 0) + 1
  self.bClueItemInStaggerAwaitingGenerate = false
  self.ClueItemInStaggerExpectedCoordinates = nil
  self.ClueItemInStaggerWidgetByCoordinate = nil
  self:RemoveTimer("ClueItemInStagger")
end

function M:TryStartClueItemInStaggerIfReady()
  if not self.bClueItemInStaggerAwaitingGenerate then
    return
  end
  local ExpectedCoordinates = self.ClueItemInStaggerExpectedCoordinates
  if not ExpectedCoordinates then
    return
  end
  if 0 == #ExpectedCoordinates then
    self.bClueItemInStaggerAwaitingGenerate = false
    return
  end
  local WidgetByCoordinate = self.ClueItemInStaggerWidgetByCoordinate or {}
  local ClueItemWidgetList = {}
  for _, Coordinate in ipairs(ExpectedCoordinates) do
    local CoordinateKey = self:MakeClueItemStaggerCoordinateKey(Coordinate.X, Coordinate.Y)
    local ChildWidget = CoordinateKey and WidgetByCoordinate[CoordinateKey]
    if not ChildWidget or not IsValid(ChildWidget) then
      return
    end
    table_insert(ClueItemWidgetList, ChildWidget)
  end
  self.bClueItemInStaggerAwaitingGenerate = false
  self.ClueItemInStaggerExpectedCoordinates = nil
  self.ClueItemInStaggerWidgetByCoordinate = nil
  self:StartClueItemInStagger(ClueItemWidgetList)
end

function M:StartClueItemInStagger(ClueItemWidgetList)
  if not ClueItemWidgetList or 0 == #ClueItemWidgetList then
    return
  end
  self.ClueItemInStaggerToken = (self.ClueItemInStaggerToken or 0) + 1
  self:RemoveTimer("ClueItemInStagger")
  local StaggerToken = self.ClueItemInStaggerToken
  local PlayIndex = 0
  local Interval = StringBoardConfig.ClueItemInStaggerInterval or 0.05
  
  local function PlayNextClueItemIn()
    if not IsValid(self) or self.ClueItemInStaggerToken ~= StaggerToken then
      return false
    end
    PlayIndex = PlayIndex + 1
    local ChildWidget = ClueItemWidgetList[PlayIndex]
    if ChildWidget and IsValid(ChildWidget) and ChildWidget.PlayOpenAnimation then
      ChildWidget:PlayOpenAnimation()
    end
    return PlayIndex < #ClueItemWidgetList
  end
  
  if not PlayNextClueItemIn() then
    return
  end
  self:AddTimer(Interval, function()
    if not PlayNextClueItemIn() then
      self:RemoveTimer("ClueItemInStagger")
    end
  end, true, 0, "ClueItemInStagger")
end

function M:CheckClueState(ClueId)
  return InvestigationWallUtils.CheckClueState(ClueId, InvestigationWallUtils.GetAvatarSafe())
end

function M:InitGamePad()
  self:ForbidMainTabFocus()
  local TilePanel = self.Group_Item
  if TilePanel then
    TilePanel.bIgnoreGamepadDPadNavigation = false
  end
  self:BindSubTabEntryInitialized()
  self:InitBoardKeyTips()
  self:BindBoardKeyTipsInputListen()
  self:RefreshBoardKeyTipsVisibility(UIUtils.IsGamepadInput())
end

function M:InitBoardKeyTips()
  if self.Key_Left and self.Key_Left.CreateGamepadKey then
    self.Key_Left:CreateGamepadKey(UIConst.GamePadImgKey.LeftShoulder)
  end
  if self.Key_Right and self.Key_Right.CreateGamepadKey then
    self.Key_Right:CreateGamepadKey(UIConst.GamePadImgKey.RightShoulder)
  end
end

function M:BindBoardKeyTipsInputListen()
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if not GameInputModeSubsystem then
    return
  end
  self.GameInputModeSubsystem = GameInputModeSubsystem
  GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnBoardKeyTipsInputMethodChanged)
  GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnBoardKeyTipsInputMethodChanged)
end

function M:UnbindBoardKeyTipsInputListen()
  local GameInputModeSubsystem = self.GameInputModeSubsystem or UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if not GameInputModeSubsystem then
    return
  end
  GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnBoardKeyTipsInputMethodChanged)
end

function M:OnBoardKeyTipsInputMethodChanged(CurInputDevice, CurGamepadName)
  self:RefreshBoardKeyTipsVisibility(CurInputDevice == ECommonInputType.Gamepad)
  self:RefreshNavigateCursorWhileDetailOpen()
end

function M:RefreshBoardKeyTipsVisibility(bIsGamepad)
  local Visibility = bIsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  if self.Key_Left then
    self.Key_Left:SetVisibility(Visibility)
  end
  if self.Key_Right then
    self.Key_Right:SetVisibility(Visibility)
  end
end

function M:BindSubTabEntryInitialized()
  local ListSubTab = self.List_SubTab
  if not ListSubTab or not ListSubTab.BP_OnEntryInitialized then
    return
  end
  ListSubTab.BP_OnEntryInitialized:Remove(self, self.OnSubTabEntryInitialized)
  ListSubTab.BP_OnEntryInitialized:Add(self, self.OnSubTabEntryInitialized)
end

function M:UnbindSubTabEntryInitialized()
  local ListSubTab = self.List_SubTab
  if not ListSubTab or not ListSubTab.BP_OnEntryInitialized then
    return
  end
  ListSubTab.BP_OnEntryInitialized:Remove(self, self.OnSubTabEntryInitialized)
end

function M:OnSubTabEntryInitialized(Item, Widget)
  local PendingListIndex = self.PendingFocusSubTabListIndex
  if not (nil ~= PendingListIndex and Item) or not Widget then
    return
  end
  if not self.bPreferSubTabGamepadCursor then
    return
  end
  if not self:IsSubTabItemMatchListIndex(Item, PendingListIndex) then
    return
  end
  if self:ApplySubTabGamepadFocus(Widget.Btn_Click or Widget) then
    self.PendingFocusSubTabListIndex = nil
  end
end

function M:IsSubTabItemMatchListIndex(Item, ListIndex)
  if not Item or nil == ListIndex then
    return false
  end
  if nil ~= Item.Index and Item.Index == ListIndex + 1 then
    return true
  end
  local ListSubTab = self.List_SubTab
  local TargetItem = ListSubTab and ListSubTab.GetItemAt and ListSubTab:GetItemAt(ListIndex)
  if TargetItem and Item == TargetItem then
    return true
  end
  if TargetItem and Item.CluePageId and Item.CluePageId == TargetItem.CluePageId then
    return true
  end
  return false
end

function M:SetWidgetFocusable(Widget, bFocusable)
  if not Widget then
    return
  end
  Widget.bIsFocusable = bFocusable
  if Widget.SetIsFocusable then
    Widget:SetIsFocusable(bFocusable)
  end
end

function M:ForbidMainTabFocus()
  for _, TabWidget in ipairs(self.ClueTabList or {}) do
    self:SetWidgetFocusable(TabWidget, false)
    if TabWidget and TabWidget.Btn_Click then
      self:SetWidgetFocusable(TabWidget.Btn_Click, false)
    end
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleBoardGamePadKeyDown(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleBoardGamePadKeyDown(InKeyName) then
    return UIUtils.Handled
  end
  local OwnerStringBoard = self.OwnerStringBoard
  if OwnerStringBoard and UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and OwnerStringBoard.HandleGamePadKeyDown and OwnerStringBoard:HandleGamePadKeyDown(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleBoardGamePadKeyUp(InKeyName) then
    return UIUtils.Handled
  end
  local OwnerStringBoard = self.OwnerStringBoard
  if OwnerStringBoard and UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and OwnerStringBoard.HandleGamePadKeyUp and OwnerStringBoard:HandleGamePadKeyUp(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:IsBoardNavUpKey(InKeyName)
  return InKeyName == UIConst.GamePadKey.LeftStickUp or InKeyName == UIConst.GamePadKey.DPadUp
end

function M:IsBoardNavDownKey(InKeyName)
  return InKeyName == UIConst.GamePadKey.LeftStickDown or InKeyName == UIConst.GamePadKey.DPadDown
end

function M:IsBoardNavLeftKey(InKeyName)
  return InKeyName == UIConst.GamePadKey.LeftStickLeft or InKeyName == UIConst.GamePadKey.DPadLeft
end

function M:IsBoardNavRightKey(InKeyName)
  return InKeyName == UIConst.GamePadKey.LeftStickRight or InKeyName == UIConst.GamePadKey.DPadRight
end

function M:TryConsumeSubTabVerticalStickArmed()
  if not self.bSubTabStickArmed then
    return false
  end
  self.bSubTabStickArmed = false
  return true
end

function M:TryConsumeBoardHorizontalStickArmed()
  if not self.bBoardHorizontalStickArmed then
    return false
  end
  self.bBoardHorizontalStickArmed = false
  return true
end

function M:HandleBoardGamePadKeyDown(InKeyName)
  if self:IsClueDetailGamepadLocked() and (self:IsBoardNavUpKey(InKeyName) or self:IsBoardNavDownKey(InKeyName) or self:IsBoardNavLeftKey(InKeyName) or self:IsBoardNavRightKey(InKeyName) or InKeyName == UIConst.GamePadKey.FaceButtonBottom) then
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftShoulder or InKeyName == UIConst.GamePadKey.RightShoulder or InKeyName == UIConst.GamePadKey.FaceButtonRight then
    return true
  end
  if self:IsBoardNavUpKey(InKeyName) then
    if not self:IsSubTabFocused() then
      return false
    end
    if not self:TryConsumeSubTabVerticalStickArmed() then
      return true
    end
    self:SwitchClueSubTabByOffset(-1)
    return true
  end
  if self:IsBoardNavDownKey(InKeyName) then
    if not self:IsSubTabFocused() then
      return false
    end
    if not self:TryConsumeSubTabVerticalStickArmed() then
      return true
    end
    self:SwitchClueSubTabByOffset(1)
    return true
  end
  if self:IsBoardNavRightKey(InKeyName) then
    if not self:IsSubTabFocused() then
      return false
    end
    if not self:TryConsumeBoardHorizontalStickArmed() then
      return true
    end
    if not self:TryEnterClueTilePanelFromSubTab() then
      self.bBoardHorizontalStickArmed = true
      return true
    end
    return true
  end
  if self:IsBoardNavLeftKey(InKeyName) then
    return self:IsSubTabFocused()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    if self:IsSubTabFocused() then
      self:PinCurrentSubTabGamepadFocus()
      return true
    end
    return self:TryPressFocusedClueTileOnAccept()
  end
  return false
end

function M:HandleBoardGamePadKeyUp(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    if self:IsSubTabFocused() then
      self:PinCurrentSubTabGamepadFocus()
      return true
    end
    return self:TryClickFocusedClueTileOnAcceptRelease()
  end
  if InKeyName == UIConst.GamePadKey.LeftShoulder then
    self:SwitchClueTabByOffset(-1)
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightShoulder then
    self:SwitchClueTabByOffset(1)
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    local OwnerStringBoard = self.OwnerStringBoard
    if OwnerStringBoard and OwnerStringBoard.bIgnoreNextFaceButtonRightKeyUp then
      return false
    end
    return self:TryHandleGamepadBackToSubTab()
  end
  if InKeyName == UIConst.GamePadKey.DPadUp or InKeyName == UIConst.GamePadKey.DPadDown then
    self.bSubTabStickArmed = true
    return true
  end
  if InKeyName == UIConst.GamePadKey.DPadLeft or InKeyName == UIConst.GamePadKey.DPadRight then
    self.bBoardHorizontalStickArmed = true
    return true
  end
  return false
end

function M:TryPressFocusedClueTileOnAccept()
  if self:IsSubTabFocused() then
    return false
  end
  if self.LastFocusedClueTileX == nil or nil == self.LastFocusedClueTileY then
    return false
  end
  if self.bClueTileAcceptPressed then
    return true
  end
  local ClueItemWidget = self.FocusedClueItemWidget
  if ClueItemWidget and IsValid(ClueItemWidget) and ClueItemWidget.OnClueItemPressed then
    ClueItemWidget:OnClueItemPressed()
  end
  self.bClueTileAcceptPressed = true
  return true
end

function M:TryClickFocusedClueTileOnAcceptRelease()
  if not self.bClueTileAcceptPressed then
    return false
  end
  self:ClearClueTileAcceptPressed()
  if self:IsClueDetailGamepadLocked() or self:IsSubTabFocused() then
    return true
  end
  local TilePanel = self.Group_Item
  if TilePanel and TilePanel.ClickFocusedTile then
    return TilePanel:ClickFocusedTile()
  end
  return false
end

function M:IsSubTabFocused()
  return self.bPreferSubTabGamepadCursor == true
end

function M:PinCurrentSubTabGamepadFocus()
  if not UIUtils.IsGamepadInput() then
    return
  end
  self:FocusTargetSubTabAfterSwitch((self.SelectedClueListIndex or 1) - 1)
end

function M:ApplySubTabNavigationLock(FocusTarget)
  if FocusTarget and FocusTarget.SetNavigationRuleBase then
    FocusTarget:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
    FocusTarget:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
    FocusTarget:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
    FocusTarget:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
  end
  local ListSubTab = self.List_SubTab
  if not ListSubTab then
    return
  end
  if ListSubTab.SetNavigationRuleBase then
    ListSubTab:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
    ListSubTab:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
    ListSubTab:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
    ListSubTab:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
  end
  if ListSubTab.SetIsLimitNavigationInside then
    ListSubTab:SetIsLimitNavigationInside(true)
  end
end

function M:ClearSubTabNavigationLock()
  local ListSubTab = self.List_SubTab
  if ListSubTab and ListSubTab.SetIsLimitNavigationInside then
    ListSubTab:SetIsLimitNavigationInside(false)
  end
end

function M:TryEnterClueTilePanelFromSubTab()
  if not self:IsSubTabFocused() then
    return false
  end
  return self:FocusClueTilePanel()
end

function M:TryHandleGamepadBackToSubTab()
  if self:IsClueDetailGamepadLocked() or self:IsSubTabFocused() then
    return false
  end
  return self:TryReturnToSubTabFromClueTilePanel()
end

function M:TryReturnToSubTabFromClueTilePanel()
  if self:IsClueDetailGamepadLocked() then
    return true
  end
  if self:IsSubTabFocused() then
    return false
  end
  self:ClearClueTileAcceptPressed()
  self.bSubTabStickArmed = true
  self:FocusTargetSubTabAfterSwitch((self.SelectedClueListIndex or 1) - 1)
  return true
end

function M:OnClueTileNavigateBoundary(Direction)
  if Direction ~= UE4.EUINavigation.Left then
    return
  end
  if self:IsClueDetailGamepadLocked() or self:IsSubTabFocused() then
    return
  end
  if not self:TryConsumeBoardHorizontalStickArmed() then
    return
  end
  if not self:TryReturnToSubTabFromClueTilePanel() then
    self.bBoardHorizontalStickArmed = true
  end
end

function M:FindClueTileCoordinateByFrontIndex()
  local CoordinateMap = self.ClueIndexToTileCoordinate
  local BestClueIndex, BestX, BestY
  if CoordinateMap then
    for ClueIndex, Coordinate in pairs(CoordinateMap) do
      if Coordinate and Coordinate.X ~= nil and nil ~= Coordinate.Y and (nil == BestClueIndex or ClueIndex < BestClueIndex) then
        BestClueIndex = ClueIndex
        BestX = Coordinate.X
        BestY = Coordinate.Y
      end
    end
  end
  if nil ~= BestX then
    return BestX, BestY
  end
  local TileDataList = self.CurrentClueTileDataList
  if TileDataList then
    local BestFallbackIndex, BestFallbackX, BestFallbackY
    for _, TileData in ipairs(TileDataList) do
      local Position = TileData and TileData.Position
      local DataContent = TileData and TileData.Content
      local ClueIndex = DataContent and DataContent.ClueIndex
      local ClueId = DataContent and DataContent.ClueId
      if Position and ClueId and self:CheckClueState(ClueId) ~= CommonConst.ClueState.Locked and (nil == BestFallbackIndex or nil ~= ClueIndex and BestFallbackIndex > ClueIndex) then
        BestFallbackIndex = ClueIndex or math.huge
        BestFallbackX = math.floor((Position.X or 0) + 0.5)
        BestFallbackY = math.floor((Position.Y or 0) + 0.5)
      end
    end
    if nil ~= BestFallbackX then
      return BestFallbackX, BestFallbackY
    end
  end
  return nil, nil
end

function M:FocusClueTilePanel()
  if self:IsClueDetailGamepadLocked() then
    return false
  end
  local TilePanel = self.Group_Item
  if not TilePanel or not TilePanel.FocusPanel then
    return false
  end
  local TargetX, TargetY = self:FindClueTileCoordinateByFrontIndex()
  if nil == TargetX or nil == TargetY then
    return false
  end
  self:ClearSubTabNavigationLock()
  self.bPreferSubTabGamepadCursor = false
  self.PendingFocusSubTabListIndex = nil
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem and GameInputModeSubsystem.SetShowFocusedWidget then
    GameInputModeSubsystem:SetShowFocusedWidget(nil)
  end
  local SavedFocusScrollDuration = TilePanel.FocusScrollDuration
  if nil ~= SavedFocusScrollDuration then
    TilePanel.FocusScrollDuration = 0
  end
  if TilePanel.SetFocusedTile then
    TilePanel:SetFocusedTile(TargetX, TargetY)
  end
  TilePanel:FocusPanel()
  if nil ~= SavedFocusScrollDuration then
    TilePanel.FocusScrollDuration = SavedFocusScrollDuration
  end
  return true
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local AnalogValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  if "Gamepad_LeftY" == InKeyName then
    self.AnalogLeftY = AnalogValue
  elseif "Gamepad_LeftX" == InKeyName then
    self.AnalogLeftX = AnalogValue
  else
    return UIUtils.Unhandled
  end
  if self:IsClueDetailGamepadLocked() then
    return UIUtils.Handled
  end
  local AnalogThreshold = StringBoardConfig.AnalogThreshold
  local AnalogDeadZone = AnalogThreshold * 0.5
  if self:IsSubTabFocused() then
    if "Gamepad_LeftY" == InKeyName then
      if AnalogDeadZone >= math.abs(AnalogValue) then
        self.bSubTabStickArmed = true
        return UIUtils.Handled
      end
      if not self.bSubTabStickArmed then
        return UIUtils.Handled
      end
      if AnalogValue > AnalogThreshold then
        if not self:TryConsumeSubTabVerticalStickArmed() then
          return UIUtils.Handled
        end
        self:SwitchClueSubTabByOffset(-1)
        return UIUtils.Handled
      end
      if AnalogValue < -AnalogThreshold then
        if not self:TryConsumeSubTabVerticalStickArmed() then
          return UIUtils.Handled
        end
        self:SwitchClueSubTabByOffset(1)
        return UIUtils.Handled
      end
      return UIUtils.Handled
    end
    if AnalogThreshold < math.abs(self.AnalogLeftY or 0) then
      return UIUtils.Handled
    end
    if AnalogDeadZone >= math.abs(AnalogValue) then
      self.bBoardHorizontalStickArmed = true
      return UIUtils.Handled
    end
    if not self.bBoardHorizontalStickArmed then
      return UIUtils.Handled
    end
    if AnalogValue > AnalogThreshold then
      if not self:TryConsumeBoardHorizontalStickArmed() then
        return UIUtils.Handled
      end
      if not self:TryEnterClueTilePanelFromSubTab() then
        self.bBoardHorizontalStickArmed = true
      end
      return UIUtils.Handled
    end
    return UIUtils.Handled
  end
  self.bSubTabStickArmed = true
  if "Gamepad_LeftX" ~= InKeyName then
    return UIUtils.Unhandled
  end
  if AnalogDeadZone >= math.abs(AnalogValue) then
    self.bBoardHorizontalStickArmed = true
  end
  return UIUtils.Unhandled
end

function M:SwitchClueTabByOffset(Offset)
  local VisibleCount = self.VisibleClueTabList and #self.VisibleClueTabList or 0
  if VisibleCount <= 0 or not Offset then
    return false
  end
  local CurrentIndex = self.SelectedClueTabIndex or 1
  local TargetIndex = CurrentIndex + Offset
  if TargetIndex < 1 or VisibleCount < TargetIndex or TargetIndex == CurrentIndex then
    return false
  end
  self:OnClueTabClick(TargetIndex)
  return true
end

function M:SwitchClueSubTabByOffset(Offset)
  local VisiblePageCount = self.VisibleCluePageList and #self.VisibleCluePageList or 0
  if VisiblePageCount <= 0 or not Offset then
    return false
  end
  local CurrentIndex = self.SelectedClueListIndex or 1
  local TargetIndex = CurrentIndex + Offset
  if TargetIndex < 1 or VisiblePageCount < TargetIndex then
    if UIUtils.IsGamepadInput() and self:IsSubTabFocused() then
      self:PinCurrentSubTabGamepadFocus()
    end
    return false
  end
  local TargetPageEntry = self.VisibleCluePageList[TargetIndex]
  local TargetCluePageId = TargetPageEntry and TargetPageEntry.CluePageId
  if not TargetCluePageId then
    return false
  end
  if TargetIndex ~= CurrentIndex then
    self:OnClueSubTabClick(TargetIndex, TargetCluePageId)
  else
    self:FocusTargetSubTabAfterSwitch(TargetIndex - 1)
  end
  return true
end

function M:FocusTargetSubTabAfterSwitch(ListIndex)
  if not UIUtils.IsGamepadInput() then
    return
  end
  local TilePanel = self.Group_Item
  if TilePanel and TilePanel.ClearFocus then
    TilePanel:ClearFocus()
  end
  self:NotifyOwnerBoardCanOpenDetailKeyTip(false)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem and GameInputModeSubsystem.SetShowFocusedWidget then
    GameInputModeSubsystem:SetShowFocusedWidget(nil)
  end
  self:RequestFocusSubTabByListIndex(ListIndex)
end

function M:RequestFocusSubTabByListIndex(ListIndex)
  if not UIUtils.IsGamepadInput() then
    return
  end
  self.bPreferSubTabGamepadCursor = true
  self.PendingFocusSubTabListIndex = ListIndex
  if self:FocusSubTabByListIndex(ListIndex) then
    self.PendingFocusSubTabListIndex = nil
    return
  end
  if self.AddTimer then
    self:AddTimer(0.01, function()
      if not IsValid(self) then
        return
      end
      if self.PendingFocusSubTabListIndex ~= ListIndex then
        return
      end
      if not self.bPreferSubTabGamepadCursor then
        return
      end
      if self:FocusSubTabByListIndex(ListIndex) then
        self.PendingFocusSubTabListIndex = nil
      end
    end)
  end
end

function M:FocusFirstSubTabAfterTabSwitch()
  self:FocusTargetSubTabAfterSwitch(0)
end

function M:RestoreGamepadFocusAfterProgressReward(PosX, PosY)
  if not UIUtils.IsGamepadInput() then
    return
  end
  local TilePanel = self.Group_Item
  if not TilePanel then
    return
  end
  self:ClearSubTabNavigationLock()
  self.bPreferSubTabGamepadCursor = false
  self.PendingFocusSubTabListIndex = nil
  if TilePanel.SetFocus then
    TilePanel:SetFocus()
  end
  if nil == PosX or nil == PosY or not TilePanel.SetFocusedTile then
    return
  end
  local SavedFocusScrollDuration = TilePanel.FocusScrollDuration
  if nil ~= SavedFocusScrollDuration then
    TilePanel.FocusScrollDuration = 0
  end
  TilePanel:SetFocusedTile(PosX, PosY)
  if nil ~= SavedFocusScrollDuration then
    TilePanel.FocusScrollDuration = SavedFocusScrollDuration
  end
end

function M:FocusToCurrentSelectionForGamepad()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self:IsClueDetailShowing() then
    self:ApplyGamepadWhileDetailOpen()
    return
  end
  local SelectedClueItemWidget = self.SelectedClueItemWidget
  if SelectedClueItemWidget and IsValid(SelectedClueItemWidget) then
    local ClueIndex = SelectedClueItemWidget.Content and SelectedClueItemWidget.Content.ClueIndex
    local Coordinate = ClueIndex and self.ClueIndexToTileCoordinate and self.ClueIndexToTileCoordinate[ClueIndex]
    if Coordinate and Coordinate.X ~= nil and nil ~= Coordinate.Y then
      self:RestoreGamepadFocusAfterProgressReward(Coordinate.X, Coordinate.Y)
      return
    end
  end
  self:FocusTargetSubTabAfterSwitch((self.SelectedClueListIndex or 1) - 1)
end

function M:FocusDefaultForGamepad()
  if not UIUtils.IsGamepadInput() then
    return
  end
  self:RequestFocusSubTabByListIndex(0)
end

function M:ApplySubTabGamepadFocus(FocusTarget)
  if not FocusTarget or not FocusTarget.SetFocus then
    return false
  end
  if not self.bPreferSubTabGamepadCursor then
    return false
  end
  self:ApplySubTabNavigationLock(FocusTarget)
  FocusTarget:SetFocus()
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem then
    if GameInputModeSubsystem.SetShowFocusedWidget then
      GameInputModeSubsystem:SetShowFocusedWidget(FocusTarget)
    end
    if GameInputModeSubsystem.UpdateCurrentFocusWidgetPos then
      GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
    end
  end
  return true
end

function M:ResolveSubTabFocusTarget(ListIndex)
  local ListSubTab = self.List_SubTab
  if not (ListSubTab and ListSubTab.GetNumItems) or ListSubTab:GetNumItems() <= 0 then
    return nil, nil
  end
  local ItemCount = ListSubTab:GetNumItems()
  if ListIndex < 0 or ListIndex >= ItemCount then
    ListIndex = 0
  end
  local TargetItem = ListSubTab.GetItemAt and ListSubTab:GetItemAt(ListIndex)
  if not TargetItem then
    return nil, ListIndex
  end
  if ListSubTab.GetDisplayedEntryWidgets then
    local DisplayedEntryWidgets = ListSubTab:GetDisplayedEntryWidgets()
    if DisplayedEntryWidgets then
      for _, EntryWidget in pairs(DisplayedEntryWidgets) do
        local EntryContent = EntryWidget and EntryWidget.Content
        if EntryContent == TargetItem or EntryContent and EntryContent.CluePageId == TargetItem.CluePageId then
          return EntryWidget.Btn_Click or EntryWidget, ListIndex
        end
      end
    end
  end
  local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(ListSubTab, ListIndex)
  if EntryWidget then
    return EntryWidget.Btn_Click or EntryWidget, ListIndex
  end
  return nil, ListIndex
end

function M:FocusSubTabByListIndex(ListIndex)
  local ListSubTab = self.List_SubTab
  if not (ListSubTab and ListSubTab.GetNumItems) or ListSubTab:GetNumItems() <= 0 then
    return false
  end
  local ItemCount = ListSubTab:GetNumItems()
  if ListIndex < 0 or ListIndex >= ItemCount then
    ListIndex = 0
  end
  local TargetItem = ListSubTab.GetItemAt and ListSubTab:GetItemAt(ListIndex)
  if TargetItem and ListSubTab.BP_NavigateToItem then
    ListSubTab:BP_NavigateToItem(TargetItem)
  elseif ListSubTab.NavigateToIndex then
    ListSubTab:NavigateToIndex(ListIndex)
  else
    return false
  end
  local TilePanel = self.Group_Item
  if TilePanel and TilePanel.ClearFocus then
    TilePanel:ClearFocus()
  end
  local FocusTarget = self:ResolveSubTabFocusTarget(ListIndex)
  if not FocusTarget then
    return false
  end
  return self:ApplySubTabGamepadFocus(FocusTarget)
end

return M
