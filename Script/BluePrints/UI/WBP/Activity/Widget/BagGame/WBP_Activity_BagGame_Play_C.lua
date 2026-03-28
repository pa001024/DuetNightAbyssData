require("UnLua")
local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local BagGameController = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameController")
local ActivityUtils = require("BluePrints.UI.WBP.Activity.ActivityUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Activity.Widget.BagGame.WBP_Activity_BagGame_Play_C_GamepadComp"
}

local function FindAndRelinkEntry(DisplayedWidgets, ContentData, DisPlayItemId)
  if not DisplayedWidgets then
    return nil
  end
  for i = 1, DisplayedWidgets:Length() do
    local Entry = DisplayedWidgets:GetRef(i)
    if Entry then
      if Entry.Content == ContentData then
        return Entry
      end
      if not Entry.IsEmpty and Entry.DisPlayItemId == DisPlayItemId then
        Entry.Content = ContentData
        Entry.PlayScreen = ContentData.PlayScreen
        Entry.IsEmpty = ContentData.IsEmpty or false
        return Entry
      end
    end
  end
  return nil
end

local GUIDE_RESTORE_FOCUS_TIMER = "BagGameGuideRestoreFocus"
local GUIDE_RESTORE_FOCUS_DELAY = 0.1
local OWNER_RESTORE_FOCUS_TIMER = "BagGameMainRestoreFocusAfterPlayClose"
local OWNER_RESTORE_FOCUS_DELAY = 0.25

function M:Construct()
  M.Super.Construct(self)
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/weimangzhencang_level_start", nil, nil)
  self.Tab.Panel_Top:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Tab.Panel_Bottom:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Overlay_Recycle:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Btn_Refresh.OnClicked:Add(self, self.OnBtnRefreshClicked)
  self.Btn_Finish.OnClicked:Add(self, self.OnBtnFinishClicked)
  self.Btn_Close.OnClicked:Add(self, self.OnBtnCloseClicked)
  if self.Btn_Explanation and self.Btn_Explanation.Btn_Area then
    self.Btn_Explanation.Btn_Area.OnClicked:Add(self, self.ShowGuide)
  end
  self.CurrentUnconfirmedItem = nil
  self:SetFinishButtonEnabled(false)
  self.TextTitle:SetText(GText("Event_Title_103015"))
  self.Text_Title_R:SetText(GText("UI_GameEvent_BagGame_Title_ItemToOrganize"))
  self.Text_Finish:SetText(GText("UI_GameEvent_BagGame_Button_OrganizeFinish"))
  self.Text_Recycle:SetText(GText("UI_GameEvent_BagGame_PutBackItem"))
  self.Text_Target:SetText(GText("UI_BackpackPuzzle_TargetScore"))
  self.Text_AllScore:SetText(GText("UI_GameEvent_BagGame_TotalScore"))
  if self.Btn_Explanation and self.Btn_Explanation.Tex_Explanation then
    self.Btn_Explanation.Tex_Explanation:SetText(GText("MAIN_UI_GUIDEBOOK"))
  end
  self:InitListenEvent()
  self:RefreshBaseInfo()
  self:UpdateRefreshButtonState()
end

function M:Destruct()
  self:_ClearGuideFocusRestoreState()
  self:CleanupPlayState()
  self.Btn_Refresh.OnClicked:Remove(self, self.OnBtnRefreshClicked)
  self.Btn_Finish.OnClicked:Remove(self, self.OnBtnFinishClicked)
  if self.EMTileView1 and self._OnDisPlayItemSelected then
    self.EMTileView1.BP_OnItemSelectionChanged:Remove(self, self._OnDisPlayItemSelected)
  end
  M.Super.Destruct(self)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  self.Params = Params
  self.Owner = Params.Owner
  self:CleanupPlayState()
  self:InitData(Params)
  self:InitView(Params)
  self:PlayAnimation(self.In)
  self:SetFocus()
  self:InitGamePadKey()
  self:_InitGamepadItemList()
end

function M:InitData(Params)
  self.Content = Params.Content
  self.Id = self.Content.Id
  self.LevelId = self.Content.LevelId
  self.LevelName = self.Content.LevelName
  self.LevelDes = self.Content.LevelDes
  self.TargetScore = self.Content.TargetScore
  self.TargetReward = self.Content.TargetReward
  self.LevelInitialItem = self.Content.LevelInitialItem
  self.GridDistribute = self.Content.GridDistribute
  self.PlayerScore = self.Content.PlayerScore or 0
  BagGameController:StartGame(self.LevelId)
end

function M:InitView(Params)
  local MaxTargetScore = 0
  if self.TargetScore then
    for i, Score in ipairs(self.TargetScore) do
      self["ScoreItem0" .. i].Text_ScoreInfo_Star:SetText(string.format(GText("UI_BackpackPuzzle_Target" .. i), Score))
      self["ScoreItem0" .. i].Text_ScoreInfo_Empty:SetText(string.format(GText("UI_BackpackPuzzle_Target" .. i), Score))
      if Score > MaxTargetScore then
        MaxTargetScore = Score
      end
    end
  end
  self:UpdateStarCountByScore(self.PlayerScore or 0)
  self:InitContainItem(self.GridDistribute)
  self:ResetPlayArea()
end

function M:UpdateStarCountByScore(Score)
  local StarCount = 0
  if self.TargetScore then
    for _, TargetScore in ipairs(self.TargetScore) do
      if TargetScore <= Score then
        StarCount = StarCount + 1
      end
    end
  end
  local RomanIndex = BagGameModel:ConvertIndex2Roman(self.Id)
  self:Set_NumandStart(RomanIndex, StarCount)
  return StarCount
end

function M:InitDisPlayItem(LevelInitialItem)
  if not LevelInitialItem then
    return
  end
  self.EMTileView1:ClearListItems()
  self.DisPlayItemDataById = {}
  self.DisPlayItemDataList = {}
  self._TileViewContentList = {}
  self.TotalDisPlayItemCount = #LevelInitialItem
  local InstanceCounter = {}
  for _, TemplateId in ipairs(LevelInitialItem) do
    local ItemData = BagGameModel:BuildItemContent(TemplateId)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    for Key, Value in pairs(ItemData) do
      Content[Key] = Value
    end
    Content.ShapeOffsets = Content.ItemGrid and BagGameModel:ParseItemGrid(Content.ItemGrid) or {
      {0, 0}
    }
    Content.SwitchIndex = 0
    Content.PlayScreen = self
    InstanceCounter[TemplateId] = (InstanceCounter[TemplateId] or 0) + 1
    local InstanceNum = InstanceCounter[TemplateId]
    if 1 == InstanceNum then
      Content.DisPlayItemId = TemplateId
    else
      Content.DisPlayItemId = tostring(TemplateId) .. "#" .. InstanceNum
    end
    self.EMTileView1:AddItem(Content)
    self.DisPlayItemDataById[Content.DisPlayItemId] = Content
    table.insert(self.DisPlayItemDataList, Content)
    table.insert(self._TileViewContentList, Content)
  end
end

function M:RebuildTileView()
  if self._TileViewContentList then
    local Seen = {}
    for i = #self._TileViewContentList, 1, -1 do
      local Item = self._TileViewContentList[i]
      if not Item or Seen[Item] then
        table.remove(self._TileViewContentList, i)
      else
        Seen[Item] = true
      end
    end
  end
  self.EMTileView1:BP_SetListItems(self._TileViewContentList)
end

function M:SetDisPlayItemSwitchIndex(DisPlayItemId, Index)
  local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
  if not ContentData then
    return
  end
  ContentData.SwitchIndex = Index
  local DisplayedWidgets = self.EMTileView1:GetDisplayedEntryWidgets()
  local Entry = FindAndRelinkEntry(DisplayedWidgets, ContentData, DisPlayItemId)
  if Entry and Entry.Switch_Type then
    Entry.Switch_Type:SetActiveWidgetIndex(Index)
    if Entry.Overlay_Icon then
      if 2 == Index then
        Entry.Overlay_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
      elseif 0 == Index then
        Entry.Overlay_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      end
    end
  end
end

function M:HasUnconfirmedItem()
  return BagGameModel:HasUnconfirmedItem()
end

function M:GetUnconfirmedItem()
  return BagGameModel:GetUnconfirmedItem()
end

function M:SetUnconfirmedItem(PlacedItem)
  BagGameModel:SetUnconfirmedItem(PlacedItem)
  self.CurrentUnconfirmedItem = PlacedItem
  if self._SyncGamepadStateWithRuntimeContext then
    self:_SyncGamepadStateWithRuntimeContext()
  end
  if self.RefreshGamepadBottomKeyInfo then
    self:RefreshGamepadBottomKeyInfo()
  end
end

function M:ConfirmPlacedItem(PlacedItem)
  if not PlacedItem then
    return false
  end
  if PlacedItem.IsTempPlacement then
    DebugPrint("ConfirmPlacedItem: 临时放置存在重叠，不能确认")
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_CannotPutDown")
    return false
  end
  local PlacedRecordForCheck
  if self.PlacedItems then
    for _, Record in ipairs(self.PlacedItems) do
      if Record.Widget == PlacedItem then
        PlacedRecordForCheck = Record
        break
      end
    end
  end
  if PlacedRecordForCheck and PlacedRecordForCheck.Cells then
    local GridRows = BagGameModel.GRID_ROWS
    local GridCols = BagGameModel.GRID_COLS
    for _, Cell in ipairs(PlacedRecordForCheck.Cells) do
      local R, C = Cell.Row, Cell.Col
      if R < 1 or GridRows < R or C < 1 or GridCols < C then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_CannotPutDown")
        return false
      end
      local Value = BagGameModel:GetGridValue(R, C)
      if Value == BagGameModel.VALUE_UNCLICKABLE or Value == BagGameModel.VALUE_BLOCKED then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_CannotPutDown")
        return false
      end
    end
    for _, Cell in ipairs(PlacedRecordForCheck.Cells) do
      if self:IsCellOccupiedByOtherItem(Cell.Row, Cell.Col, PlacedItem) then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_CannotPutDown")
        return false
      end
    end
  end
  if not BagGameController:ConfirmPlacedItem(PlacedItem) then
    DebugPrint("ConfirmPlacedItem: 该物品不是当前未确认物品")
    return false
  end
  self:SetUnconfirmedItem(nil)
  if PlacedItem.PlayAnimation and PlacedItem.Btn_Out then
    PlacedItem:PlayAnimation(PlacedItem.Btn_Out)
  end
  if PlacedItem.Btn_Stop then
    PlacedItem.Btn_Stop:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if PlacedItem.Btn_Rotation then
    PlacedItem.Btn_Rotation:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if PlacedItem.Btn_Check then
    PlacedItem.Btn_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  PlacedItem.bIsConfirmed = true
  PlacedItem:SetVisibility(UIConst.VisibilityOp.Visible)
  local PlacedRecord
  if self.PlacedItems then
    for _, Record in ipairs(self.PlacedItems) do
      if Record.Widget == PlacedItem then
        PlacedRecord = Record
        break
      end
    end
  end
  if PlacedRecord and PlacedRecord.Cells then
    local bDouble = PlacedRecord.IsDoubleReward
    for _, Cell in ipairs(PlacedRecord.Cells) do
      local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
      if ContainItem then
        if bDouble then
          ContainItem:PlayPutGetPoint()
        else
          ContainItem:PlayPutNormal()
        end
        ContainItem:PlayPutFlash()
        if bDouble then
          ContainItem:PlayDoubleLoop()
        end
      end
    end
  end
  if PlacedItem.SetDoubleRewardState then
    PlacedItem:SetDoubleRewardState(false)
  end
  if PlacedRecord then
    PlacedRecord.ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[PlacedItem.DisPlayItemId]
    if not PlacedRecord.ContentData and PlacedItem.TemplateId then
      local SyncData = PlacedItem.GetDragSyncData and PlacedItem:GetDragSyncData()
      if SyncData then
        local FallbackContent = NewObject(UIUtils.GetCommonItemContentClass())
        FallbackContent.TemplateId = SyncData.TemplateId or PlacedItem.TemplateId
        FallbackContent.ItemId = PlacedItem.ItemId
        FallbackContent.ItemType = SyncData.ItemType or PlacedItem.ItemType
        FallbackContent.ItemName = PlacedItem.ItemName
        FallbackContent.BasicPoint = PlacedItem.BasicPoint
        FallbackContent.GUIPath = SyncData.GUIPath or PlacedItem.GUIPath
        FallbackContent.MaxAmmo = SyncData.MaxAmmo or 0
        FallbackContent.MaxStack = SyncData.MaxStack or 0
        FallbackContent.CurrentAmmo = SyncData.CurrentAmmo or 0
        FallbackContent.CurrentStack = SyncData.CurrentStack or 0
        FallbackContent.ShapeOffsets = PlacedItem.OriginalShapeOffsets or PlacedItem.ShapeOffsets
        FallbackContent.DisPlayItemId = PlacedItem.DisPlayItemId
        FallbackContent.PlayScreen = self
        FallbackContent.SwitchIndex = 2
        PlacedRecord.ContentData = FallbackContent
      end
    end
  end
  self:RemoveConfirmedItemFromList(PlacedItem.DisPlayItemId)
  self:UpdateFinishButtonState()
  if PlacedItem.Image_Icon then
    PlacedItem.Image_Icon:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if PlacedItem.Bg_Line then
    PlacedItem.Bg_Line:SetVisibility(UIConst.VisibilityOp.Hidden)
  end
  local ItemSlot = UE.UWidgetLayoutLibrary.SlotAsCanvasSlot(PlacedItem)
  if ItemSlot then
    ItemSlot:SetZOrder(200)
  end
  if PlacedRecord and PlacedRecord.Cells and #PlacedRecord.Cells > 0 then
    local MountRow, MountCol = PlacedRecord.Cells[1].Row, PlacedRecord.Cells[1].Col
    for _, Cell in ipairs(PlacedRecord.Cells) do
      if MountRow > Cell.Row then
        MountRow = Cell.Row
      end
      if MountCol > Cell.Col then
        MountCol = Cell.Col
      end
    end
    PlacedRecord.MountRow = MountRow
    PlacedRecord.MountCol = MountCol
  end
  if not self._ConfirmedPlacedItems then
    self._ConfirmedPlacedItems = {}
  end
  if PlacedRecord then
    table.insert(self._ConfirmedPlacedItems, PlacedRecord)
  end
  if PlacedRecord and PlacedRecord.ContentData then
    self._ContentDataGCGuard = self._ContentDataGCGuard or {}
    self._ContentDataGCGuard[PlacedRecord.ContentData] = true
  end
  DebugPrint("ConfirmPlacedItem: 确认成功，DisPlayItemId=" .. tostring(PlacedItem.DisPlayItemId))
  return true
end

function M:UnconfirmPlacedItem(PlacedItem)
  if not PlacedItem then
    return false
  end
  if self:HasUnconfirmedItem() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_PutDownItem")
    return false
  end
  local PlacedRecord
  if self.PlacedItems then
    for _, Record in ipairs(self.PlacedItems) do
      if Record.Widget == PlacedItem then
        PlacedRecord = Record
        break
      end
    end
  end
  if not PlacedRecord and PlacedItem.IsTempPlacement then
    PlacedRecord = {
      Widget = PlacedItem,
      IsTempPlacement = true,
      ConflictRecord = PlacedItem.ConflictRecord
    }
    DebugPrint("UnconfirmPlacedItem: 恢复临时放置物品")
  elseif not PlacedRecord then
    DebugPrint("UnconfirmPlacedItem: 未找到放置记录")
    return false
  end
  PlacedItem.bIsConfirmed = false
  if PlacedRecord and PlacedRecord.MountRow then
    local TopLeftCell = self:GetContainItemAt(PlacedRecord.MountRow, PlacedRecord.MountCol)
    if TopLeftCell then
      PlacedItem:RemoveFromParent()
      self:MountItemToCell(PlacedItem, TopLeftCell, false)
      self:_PromoteItemToCanvasPanel(PlacedItem, TopLeftCell, 300)
    end
  end
  PlacedItem:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if PlacedItem.Btn_Stop then
    PlacedItem.Btn_Stop:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if PlacedItem.Btn_Rotation then
    PlacedItem.Btn_Rotation:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if PlacedItem.Btn_Check then
    PlacedItem.Btn_Check:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if PlacedItem.Btn_In and PlacedItem.PlayAnimation then
    PlacedItem:PlayAnimation(PlacedItem.Btn_In)
  end
  if PlacedItem.Image_Icon then
    PlacedItem.Image_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if PlacedItem.Bg_Line then
    PlacedItem.Bg_Line:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if PlacedRecord.Cells then
    for _, Cell in ipairs(PlacedRecord.Cells) do
      local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
      if ContainItem then
        ContainItem:StopAllHighlightAnimations()
        ContainItem:StopDoubleLoopAnimation()
        ContainItem:ActivateHighlight(true)
      end
    end
  end
  local ContentData = PlacedRecord.ContentData
  if ContentData then
    if self._ContentDataGCGuard then
      self._ContentDataGCGuard[ContentData] = nil
    end
    ContentData.SwitchIndex = 1
    local DisPlayItemId = PlacedItem.DisPlayItemId
    self.DisPlayItemDataById = self.DisPlayItemDataById or {}
    self.DisPlayItemDataById[DisPlayItemId] = ContentData
    self.DisPlayItemDataList = self.DisPlayItemDataList or {}
    table.insert(self.DisPlayItemDataList, ContentData)
    self:_InsertContentToTileViewHead(ContentData)
    self:RebuildTileView()
    self:SetDisPlayItemSwitchIndex(DisPlayItemId, 1)
  end
  self:SetUnconfirmedItem(PlacedItem)
  self:_RemoveFromConfirmedItems(PlacedRecord)
  self:UpdateFinishButtonState()
  if PlacedRecord.IsDoubleReward and PlacedItem.SetDoubleRewardState then
    PlacedItem:SetDoubleRewardState(true)
  end
  DebugPrint("UnconfirmPlacedItem: 恢复成功，DisPlayItemId=" .. tostring(PlacedItem.DisPlayItemId))
  return true
end

function M:RemoveConfirmedItemFromList(DisPlayItemId)
  local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
  if not ContentData then
    return
  end
  self.DisPlayItemDataById[DisPlayItemId] = nil
  if self.DisPlayItemDataList then
    for i, Data in ipairs(self.DisPlayItemDataList) do
      if Data == ContentData then
        table.remove(self.DisPlayItemDataList, i)
        break
      end
    end
  end
  local bRemoved = false
  for i, Content in ipairs(self._TileViewContentList) do
    if Content == ContentData then
      table.remove(self._TileViewContentList, i)
      bRemoved = true
      break
    end
  end
  if bRemoved then
    local EmptyObj = NewObject(UIUtils.GetCommonItemContentClass())
    EmptyObj.IsEmpty = true
    EmptyObj.PlayScreen = self
    table.insert(self._TileViewContentList, EmptyObj)
    self:RebuildTileView()
  end
end

function M:PickUpPlacedItem(PlacedItem)
  if not PlacedItem then
    return false
  end
  local CurrentUnconfirmed = self:GetUnconfirmedItem()
  if CurrentUnconfirmed and CurrentUnconfirmed ~= PlacedItem then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_PutDownItem")
    return false
  end
  local PlacedRecord, RecordIndex
  if self.PlacedItems then
    for i, Record in ipairs(self.PlacedItems) do
      if Record and Record.Widget == PlacedItem then
        PlacedRecord = Record
        RecordIndex = i
        break
      end
    end
  end
  if not PlacedRecord and PlacedItem.IsTempPlacement then
    PlacedRecord = {
      Widget = PlacedItem,
      IsTempPlacement = true,
      ConflictRecord = PlacedItem.ConflictRecord,
      ConsumedItems = PlacedItem.ConsumedItems,
      OriginalAmmo = PlacedItem.OriginalAmmo,
      OriginalStack = PlacedItem.OriginalStack
    }
    DebugPrint("PickUpPlacedItem: 拉起临时放置物品")
  elseif not PlacedRecord then
    DebugPrint("PickUpPlacedItem: 未找到放置记录")
    return false
  end
  if PlacedItem and PlacedItem.bIsConfirmed then
    PlacedItem.bIsConfirmed = false
    self:_RemoveFromConfirmedItems(PlacedRecord)
  end
  self:OnDragStateChanged(true)
  if PlacedItem and PlacedRecord and PlacedRecord.ItemType then
    PlacedItem.DragSyncData = {
      ItemType = PlacedRecord.ItemType,
      GUIPath = PlacedItem.GUIPath,
      CurrentAmmo = PlacedRecord.CurrentAmmo or 0,
      MaxAmmo = PlacedRecord.MaxAmmo or 0,
      CurrentStack = PlacedRecord.CurrentStack or 0,
      MaxStack = PlacedRecord.MaxStack or 0
    }
  end
  PlacedItem.ConsumedItems = PlacedRecord.ConsumedItems
  PlacedItem.OriginalAmmo = PlacedRecord.OriginalAmmo
  PlacedItem.OriginalStack = PlacedRecord.OriginalStack
  if PlacedRecord and PlacedRecord.Cells then
    for _, Cell in ipairs(PlacedRecord.Cells) do
      if Cell and Cell.Row and Cell.Col then
        self:ClearCellOccupied(Cell.Row, Cell.Col)
      end
    end
  end
  if PlacedRecord.IsTempPlacement and PlacedItem and PlacedItem.PlacedCells then
    for _, Cell in ipairs(PlacedItem.PlacedCells) do
      local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
      if ContainItem then
        ContainItem:DeactivateHighlight()
      end
    end
  end
  if not PlacedRecord.IsTempPlacement and PlacedItem then
    local _, ModelIndex = BagGameModel:FindPlacedItemByWidget(PlacedItem)
    if ModelIndex and ModelIndex > 0 and ModelIndex <= #BagGameModel.PlacedItems then
      BagGameModel:RemovePlacedItem(ModelIndex)
    end
  end
  if RecordIndex and RecordIndex > 0 and RecordIndex <= #self.PlacedItems and not PlacedRecord.IsTempPlacement then
    table.remove(self.PlacedItems, RecordIndex)
  elseif RecordIndex and PlacedRecord.IsTempPlacement then
    DebugPrint("PickUpPlacedItem: 临时放置，无需从列表移除")
  end
  self:RefreshPlacedItemDoubleState()
  if self:GetUnconfirmedItem() == PlacedItem then
    self:SetUnconfirmedItem(nil)
  end
  local DisPlayItemId = PlacedRecord.DisPlayItemId
  if PlacedRecord.IsTempPlacement and DisPlayItemId and PlacedItem then
    local SyncData = PlacedItem.GetDragSyncData and PlacedItem:GetDragSyncData()
    if SyncData then
      local ContentData = {
        TemplateId = PlacedItem.TemplateId,
        ItemId = PlacedItem.ItemId,
        ItemType = SyncData.ItemType or PlacedItem.ItemType,
        ItemName = PlacedItem.ItemName,
        BasicPoint = PlacedItem.BasicPoint,
        GUIPath = SyncData.GUIPath or PlacedItem.GUIPath,
        MaxAmmo = SyncData.MaxAmmo or 0,
        MaxStack = SyncData.MaxStack or 0,
        CurrentAmmo = SyncData.CurrentAmmo or 0,
        CurrentStack = SyncData.CurrentStack or 1,
        ShapeOffsets = PlacedItem.OriginalShapeOffsets or PlacedItem.ShapeOffsets,
        DisPlayItemId = PlacedItem.DisPlayItemId,
        PlayScreen = self,
        SwitchIndex = 1
      }
      self.DisPlayItemDataById = self.DisPlayItemDataById or {}
      self.DisPlayItemDataById[DisPlayItemId] = ContentData
      self.DisPlayItemDataList = self.DisPlayItemDataList or {}
      table.insert(self.DisPlayItemDataList, ContentData)
      self:_InsertContentToTileViewHead(ContentData)
      ContentData.SwitchIndex = 1
      self:RebuildTileView()
      self:SetDisPlayItemSwitchIndex(DisPlayItemId, 1)
    end
  elseif DisPlayItemId and PlacedRecord.ContentData and (not self.DisPlayItemDataById or not self.DisPlayItemDataById[DisPlayItemId]) then
    local ContentData = PlacedRecord.ContentData
    ContentData.CurrentStack = PlacedRecord.CurrentStack or ContentData.CurrentStack or 0
    ContentData.CurrentAmmo = PlacedRecord.CurrentAmmo or ContentData.CurrentAmmo or 0
    self.DisPlayItemDataById = self.DisPlayItemDataById or {}
    self.DisPlayItemDataById[DisPlayItemId] = ContentData
    self.DisPlayItemDataList = self.DisPlayItemDataList or {}
    table.insert(self.DisPlayItemDataList, ContentData)
    self:_InsertContentToTileViewHead(ContentData)
    ContentData.SwitchIndex = 1
    self:RebuildTileView()
    self:SetDisPlayItemSwitchIndex(DisPlayItemId, 1)
  end
  if DisPlayItemId then
    self:SetDisPlayItemSwitchIndex(DisPlayItemId, 1)
  end
  self:UpdateScoreDisplay()
  self:UpdateFinishButtonState()
  DebugPrint("PickUpPlacedItem: 拉起成功，DisPlayItemId=" .. tostring(PlacedRecord.DisPlayItemId))
  return true
end

function M:RefreshPlacedItemDoubleState(TriggerWidget)
  if not self.PlacedItems then
    return
  end
  for _, PlacedRecord in ipairs(self.PlacedItems) do
    if PlacedRecord and PlacedRecord.Widget and PlacedRecord.Widget.SetDoubleRewardState then
      local bWasDoubleReward = PlacedRecord.IsDoubleReward == true
      local bIsDoubleReward = BagGameModel:IsItemAllOnDoubleReward(PlacedRecord)
      PlacedRecord.IsDoubleReward = bIsDoubleReward
      if bWasDoubleReward ~= bIsDoubleReward then
        if bIsDoubleReward then
          if PlacedRecord.Widget == TriggerWidget then
            PlacedRecord.Widget:SetDoubleRewardState(true)
          elseif PlacedRecord.Widget.SyncDoubleRewardVisual then
            PlacedRecord.Widget:SyncDoubleRewardVisual(true)
          else
            PlacedRecord.Widget:SetDoubleRewardState(true)
          end
        else
          PlacedRecord.Widget:SetDoubleRewardState(false)
        end
      elseif PlacedRecord.Widget.SyncDoubleRewardVisual then
        PlacedRecord.Widget:SyncDoubleRewardVisual(bIsDoubleReward)
      end
    end
  end
end

function M:RotatePlacedItem(PlacedItem)
  if not PlacedItem or not self.PlacedItems then
    return
  end
  local GridRows = BagGameModel.GRID_ROWS or 0
  local GridCols = BagGameModel.GRID_COLS or 0
  if GridRows <= 0 or GridCols <= 0 then
    return
  end
  local PlacedRecord
  for _, Record in ipairs(self.PlacedItems) do
    if Record.Widget == PlacedItem then
      PlacedRecord = Record
      break
    end
  end
  if not (PlacedRecord and PlacedRecord.Cells) or 0 == #PlacedRecord.Cells then
    return
  end
  local NewRotCount = PlacedItem.RotationCount or 0
  local OldRotCount = (NewRotCount - 1 + 4) % 4
  local OldTopLeftRow = PlacedRecord.Cells[1].Row
  local OldTopLeftCol = PlacedRecord.Cells[1].Col
  for _, Cell in ipairs(PlacedRecord.Cells) do
    if OldTopLeftRow > Cell.Row then
      OldTopLeftRow = Cell.Row
    end
    if OldTopLeftCol > Cell.Col then
      OldTopLeftCol = Cell.Col
    end
  end
  local OldAlignRS, OldAlignCS = PlacedItem:GetAlignShift(OldRotCount)
  local FrameRow = OldTopLeftRow - OldAlignRS
  local FrameCol = OldTopLeftCol - OldAlignCS
  local NewAlignRS, NewAlignCS = PlacedItem:GetAlignShift(NewRotCount)
  local CurRows, CurCols
  if 1 == NewRotCount % 2 then
    CurRows = PlacedItem.OriginalCols or 1
    CurCols = PlacedItem.OriginalRows or 1
  else
    CurRows = PlacedItem.OriginalRows or 1
    CurCols = PlacedItem.OriginalCols or 1
  end
  local NewTopRow = math.max(1, math.min(FrameRow + NewAlignRS, GridRows - CurRows + 1))
  local NewTopCol = math.max(1, math.min(FrameCol + NewAlignCS, GridCols - CurCols + 1))
  local NewCells = {}
  for _, Off in ipairs(PlacedItem.ShapeOffsets) do
    table.insert(NewCells, {
      Row = NewTopRow + (Off[1] - NewAlignRS),
      Col = NewTopCol + (Off[2] - NewAlignCS)
    })
  end
  local OldCells = PlacedRecord.Cells
  for _, Cell in ipairs(OldCells) do
    self:ClearCellOccupied(Cell.Row, Cell.Col)
  end
  local bValid = true
  for _, Cell in ipairs(NewCells) do
    local R, C = Cell.Row, Cell.Col
    if R < 1 or GridRows < R or C < 1 or GridCols < C then
      bValid = false
      break
    end
    local Value = BagGameModel:GetGridValue(R, C)
    if nil == Value or Value == BagGameModel.VALUE_BLOCKED or Value == BagGameModel.VALUE_UNCLICKABLE then
      bValid = false
      break
    end
    if self:IsCellOccupiedByOtherItem(R, C, PlacedItem) then
      bValid = false
      break
    end
  end
  PlacedItem:RemoveFromParent()
  local NewTopLeftCell = self:GetContainItemAt(NewTopRow, NewTopCol)
  if not NewTopLeftCell then
    for _, Cell in ipairs(OldCells) do
      self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
    end
    PlacedItem.RotationCount = OldRotCount
    PlacedItem.ShapeOffsets = PlacedItem:CalculateRotatedOffsets(OldRotCount)
    PlacedItem:UpdateVisualRotation()
    return
  end
  self:MountItemToCell(PlacedItem, NewTopLeftCell, false)
  self:_PromoteItemToCanvasPanel(PlacedItem, NewTopLeftCell, 300)
  if PlacedItem.SetItemSize then
    PlacedItem:SetItemSize()
  end
  for _, Cell in ipairs(NewCells) do
    self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
  end
  PlacedRecord.Cells = NewCells
  PlacedRecord.BaseRow = NewTopRow
  PlacedRecord.BaseCol = NewTopCol
  local NewCellSet = {}
  for _, C in ipairs(NewCells) do
    local Key = C.Row * 100 + C.Col
    NewCellSet[Key] = true
  end
  for _, C in ipairs(OldCells) do
    local Key = C.Row * 100 + C.Col
    if not NewCellSet[Key] then
      local ContainItem = self:GetContainItemAt(C.Row, C.Col)
      if ContainItem and ContainItem.DeactivateHighlight then
        ContainItem:DeactivateHighlight()
      end
    end
  end
  self:RefreshPlacedItemDoubleState(PlacedItem)
  self:UpdateScoreDisplay()
  for _, C in ipairs(NewCells) do
    local ContainItem = self:GetContainItemAt(C.Row, C.Col)
    if ContainItem then
      ContainItem:ActivateHighlight(bValid)
    end
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_cell_click_replace", nil, nil)
  DebugPrint(string.format("RotatePlacedItem: 旋转到 %d°, 新锚点(%d,%d), 合法=%s", NewRotCount * 90, NewTopRow, NewTopCol, tostring(bValid)))
end

function M:ShowCannotDragToast()
  UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_PutDownItem")
end

function M:OnDragStateChanged(bIsDragging)
  if bIsDragging then
    if self.Recycle_In then
      self:StopAnimation(self.Recycle_Out)
      self:PlayAnimation(self.Recycle_In)
    end
    self.bIsDraggingItem = true
    self:SetConfirmedItemsHitTestEnabled(false)
    DebugPrint("抓取状态: 进入，播放 Recycle_In")
  else
    if self.Recycle_Out then
      self:StopAnimation(self.Recycle_In)
      self:PlayAnimation(self.Recycle_Out)
    end
    self.bIsDraggingItem = false
    self:_CancelPendingHighlight()
    self:SetConfirmedItemsHitTestEnabled(true)
    DebugPrint("抓取状态: 退出，播放 Recycle_Out")
  end
  if self._SyncGamepadStateWithRuntimeContext then
    self:_SyncGamepadStateWithRuntimeContext()
  end
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)
  if not Operation or Operation.Tag ~= "BagGameDisPlayItem" then
    return false
  end
  local DragUI = Operation.DefaultDragVisual
  if DragUI and DragUI.DisPlayItemId then
    self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 0)
  end
  self:_CancelPendingHighlight()
  self:DeactivateShapeArea()
  self:OnDragStateChanged(false)
  return true
end

function M:SetConfirmedItemsHitTestEnabled(bEnabled)
  if not self.PlacedItems then
    return
  end
  for _, Record in ipairs(self.PlacedItems) do
    local Widget = Record.Widget
    if Widget and Widget.bIsConfirmed then
      if bEnabled then
        Widget:SetVisibility(UIConst.VisibilityOp.Visible)
      else
        Widget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      end
    end
  end
end

local GRID_ROWS = BagGameModel.GRID_ROWS
local GRID_COLS = BagGameModel.GRID_COLS

function M:GetGridValue(Row, Col)
  return BagGameModel:GetGridValue(Row, Col)
end

function M:SetGridValue(Row, Col, Value)
  BagGameModel:SetGridValue(Row, Col, Value)
  local Index = (Row - 1) * GRID_COLS + Col
  local ContainItem = self.ContainItems and self.ContainItems[Index]
  if ContainItem then
    ContainItem:SetValue(Value)
  end
end

function M:InitContainItem(GridDistribute)
  self.GridMatrix = BagGameModel:ParseGridDistribute(GridDistribute)
  self.ContainItems = {}
  self.ContainItemsByPos = {}
  for Row = 1, GRID_ROWS do
    self.ContainItemsByPos[Row] = {}
  end
  local TotalCells = GRID_ROWS * GRID_COLS
  for i = 1, TotalCells do
    local ContainItem = self["PlayItem_" .. i]
    if ContainItem then
      local Row = math.ceil(i / GRID_COLS)
      local Col = (i - 1) % GRID_COLS + 1
      local Value = self.GridMatrix[Row][Col]
      ContainItem:Init(Row, Col, Value)
      ContainItem:SetPlayScreen(self)
      self.ContainItems[i] = ContainItem
      self.ContainItemsByPos[Row][Col] = ContainItem
    end
  end
  self.ActiveHighlightCells = {}
  self._PendingHighlightRow = nil
  self._PendingHighlightCol = nil
  self._PendingHighlightDragUI = nil
end

function M:GetContainItemAt(Row, Col)
  if Row < 1 or Row > GRID_ROWS or Col < 1 or Col > GRID_COLS then
    return nil
  end
  if self.ContainItemsByPos and self.ContainItemsByPos[Row] then
    return self.ContainItemsByPos[Row][Col]
  end
  return nil
end

function M:CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells)
  return BagGameModel:CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells)
end

local HIGHLIGHT_DEBOUNCE_SEC = 0.05
local HIGHLIGHT_DEBOUNCE_KEY = "BagGameHighlightDebounce"

function M:_RequestActivateShapeArea(BaseRow, BaseCol, DragUI)
  self._PendingHighlightRow = BaseRow
  self._PendingHighlightCol = BaseCol
  self._PendingHighlightDragUI = DragUI
  self:RemoveTimer(HIGHLIGHT_DEBOUNCE_KEY)
  self:AddTimer(HIGHLIGHT_DEBOUNCE_SEC, function()
    if self._PendingHighlightRow then
      local Row = self._PendingHighlightRow
      local Col = self._PendingHighlightCol
      local UI = self._PendingHighlightDragUI
      self._PendingHighlightRow = nil
      self._PendingHighlightCol = nil
      self._PendingHighlightDragUI = nil
      self:ActivateShapeArea(Row, Col, UI)
    end
  end, false, 0, HIGHLIGHT_DEBOUNCE_KEY)
end

function M:_FlushPendingHighlight()
  self:RemoveTimer(HIGHLIGHT_DEBOUNCE_KEY)
  if self._PendingHighlightRow then
    local Row = self._PendingHighlightRow
    local Col = self._PendingHighlightCol
    local UI = self._PendingHighlightDragUI
    self._PendingHighlightRow = nil
    self._PendingHighlightCol = nil
    self._PendingHighlightDragUI = nil
    self:ActivateShapeArea(Row, Col, UI)
  end
end

function M:_CancelPendingHighlight()
  self:RemoveTimer(HIGHLIGHT_DEBOUNCE_KEY)
  self._PendingHighlightRow = nil
  self._PendingHighlightCol = nil
  self._PendingHighlightDragUI = nil
end

function M:ActivateShapeArea(BaseRow, BaseCol, DragUI)
  self:DeactivateShapeArea()
  self.CurrentHoverRow = BaseRow
  self.CurrentHoverCol = BaseCol
  if not DragUI or not DragUI.GetShapeCells then
    return
  end
  local ShapeCells = DragUI:GetShapeCells(BaseRow, BaseCol)
  local bIsAmmo = BagGameModel:IsAmmoItem(DragUI.TemplateId)
  local bIsOther = BagGameModel:IsOtherItem(DragUI.TemplateId)
  self.CurrentOverlappingGun = nil
  self.bCanLoadAmmo = false
  self.bIsAmmoMode = bIsAmmo
  self.CurrentOverlappingOther = nil
  self.bCanStack = false
  self.bIsStackMode = false
  self.bIsConflictMode = false
  self.ConflictOverlappingRecord = nil
  if bIsAmmo then
    local GunRecord, bCanLoad = BagGameModel:FindOverlappingGun(ShapeCells)
    if GunRecord then
      self.CurrentOverlappingGun = GunRecord
      self.bCanLoadAmmo = bCanLoad
      for _, Cell in ipairs(GunRecord.Cells) do
        local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
        if ContainItem and ContainItem.ActivateLoadHighlight then
          ContainItem:ActivateLoadHighlight(bCanLoad)
          table.insert(self.ActiveHighlightCells, ContainItem)
        end
      end
      self.CurrentDragUI = DragUI
      self.CurrentShapeCells = ShapeCells
      self.bCanPlaceCurrent = false
      return
    end
    local AmmoStackRecord, bCanStackAmmo = BagGameModel:FindOverlappingSameAmmo(DragUI.TemplateId, ShapeCells)
    if AmmoStackRecord then
      self.CurrentOverlappingOther = AmmoStackRecord
      self.bCanStack = bCanStackAmmo
      self.bIsStackMode = true
      for _, Cell in ipairs(AmmoStackRecord.Cells) do
        local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
        if ContainItem and ContainItem.ActivateStackHighlight then
          ContainItem:ActivateStackHighlight(bCanStackAmmo)
          table.insert(self.ActiveHighlightCells, ContainItem)
        elseif ContainItem and ContainItem.ActivateLoadHighlight then
          ContainItem:ActivateLoadHighlight(bCanStackAmmo)
          table.insert(self.ActiveHighlightCells, ContainItem)
        end
      end
      self.CurrentDragUI = DragUI
      self.CurrentShapeCells = ShapeCells
      self.bCanPlaceCurrent = false
      return
    end
  end
  if bIsOther then
    local OtherRecord, bCanStackItem = BagGameModel:FindOverlappingSameOther(DragUI.TemplateId, ShapeCells)
    if OtherRecord then
      self.CurrentOverlappingOther = OtherRecord
      self.bCanStack = bCanStackItem
      self.bIsStackMode = true
      for _, Cell in ipairs(OtherRecord.Cells) do
        local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
        if ContainItem and ContainItem.ActivateStackHighlight then
          ContainItem:ActivateStackHighlight(bCanStackItem)
          table.insert(self.ActiveHighlightCells, ContainItem)
        elseif ContainItem and ContainItem.ActivateLoadHighlight then
          ContainItem:ActivateLoadHighlight(bCanStackItem)
          table.insert(self.ActiveHighlightCells, ContainItem)
        end
      end
      self.CurrentDragUI = DragUI
      self.CurrentShapeCells = ShapeCells
      self.bCanPlaceCurrent = false
      return
    end
  end
  local ConflictRecord = BagGameModel:FindOverlappingPlacedItem(ShapeCells)
  if ConflictRecord then
    self.bIsConflictMode = true
    self.ConflictOverlappingRecord = ConflictRecord
    for _, Cell in ipairs(ConflictRecord.Cells) do
      local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
      if ContainItem and ContainItem.ActivateHighlight then
        ContainItem:ActivateHighlight(false)
        table.insert(self.ActiveHighlightCells, ContainItem)
      end
    end
    self.CurrentDragUI = DragUI
    self.CurrentShapeCells = ShapeCells
    self.bCanPlaceCurrent = false
    return
  end
  local bCanPlace = self:CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells)
  for _, Cell in ipairs(ShapeCells) do
    local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
    if ContainItem and ContainItem.ActivateHighlight then
      ContainItem:ActivateHighlight(bCanPlace)
      table.insert(self.ActiveHighlightCells, ContainItem)
    end
  end
  self.CurrentDragUI = DragUI
  self.CurrentShapeCells = ShapeCells
  self.bCanPlaceCurrent = bCanPlace
end

function M:DeactivateShapeArea()
  self:_CancelPendingHighlight()
  if self.ActiveHighlightCells then
    for _, ContainItem in ipairs(self.ActiveHighlightCells) do
      if ContainItem and ContainItem.DeactivateHighlight then
        ContainItem:DeactivateHighlight()
      end
    end
  end
  self.ActiveHighlightCells = {}
  self.CurrentDragUI = nil
  self.CurrentShapeCells = nil
  self.bCanPlaceCurrent = false
  self.CurrentHoverRow = nil
  self.CurrentHoverCol = nil
  self.CurrentOverlappingGun = nil
  self.bCanLoadAmmo = false
  self.bIsAmmoMode = false
  self.CurrentOverlappingOther = nil
  self.bCanStack = false
  self.bIsStackMode = false
  self.bIsConflictMode = false
  self.ConflictOverlappingRecord = nil
end

function M:CanPlaceCurrent()
  return self.bCanPlaceCurrent == true
end

function M:OnCellDragLeave(Row, Col)
  if self._PendingHighlightRow == Row and self._PendingHighlightCol == Col then
    self:_CancelPendingHighlight()
  end
  if self.CurrentHoverRow == Row and self.CurrentHoverCol == Col then
    self:DeactivateShapeArea()
  else
    local ContainItem = self:GetContainItemAt(Row, Col)
    if ContainItem and ContainItem:IsHighlighted() then
      local bInCurrentShape = false
      if self.ActiveHighlightCells then
        for _, Cell in ipairs(self.ActiveHighlightCells) do
          if Cell == ContainItem then
            bInCurrentShape = true
            break
          end
        end
      end
      if not bInCurrentShape then
        ContainItem:DeactivateHighlight()
      end
    end
  end
end

function M:GetCurrentShapeCells()
  return self.CurrentShapeCells
end

function M:PlaceItemAtCell(BaseRow, BaseCol, DragUI, Operation)
  if not DragUI or not DragUI.GetShapeCells then
    return false
  end
  local ShapeCells = DragUI:GetShapeCells(BaseRow, BaseCol)
  if not ShapeCells or 0 == #ShapeCells then
    return false
  end
  local bIsAmmo = self.bIsAmmoMode or BagGameModel:IsAmmoItem(DragUI.TemplateId)
  if bIsAmmo then
    local GunRecord = self.CurrentOverlappingGun
    local bCanLoad = self.bCanLoadAmmo
    if not GunRecord then
      GunRecord, bCanLoad = BagGameModel:FindOverlappingGun(ShapeCells)
    end
    if GunRecord then
      self.CurrentOverlappingGun = GunRecord
      self.bCanLoadAmmo = bCanLoad
      return self:HandleAmmoLoad(DragUI, Operation)
    end
    if not self.bIsStackMode then
      local AmmoStackRecord, bCanStackAmmo = BagGameModel:FindOverlappingSameAmmo(DragUI.TemplateId, ShapeCells)
      if AmmoStackRecord then
        self.CurrentOverlappingOther = AmmoStackRecord
        self.bCanStack = bCanStackAmmo
        self.bIsStackMode = true
      end
    end
  end
  local bIsOther = self.bIsStackMode or BagGameModel:IsOtherItem(DragUI.TemplateId)
  if bIsOther then
    local OtherRecord = self.CurrentOverlappingOther
    local bCanStack = self.bCanStack
    if not OtherRecord then
      OtherRecord, bCanStack = BagGameModel:FindOverlappingSameOther(DragUI.TemplateId, ShapeCells)
    end
    if OtherRecord then
      self.CurrentOverlappingOther = OtherRecord
      self.bCanStack = bCanStack
      return self:HandleOtherStack(DragUI, Operation)
    end
  end
  local OverlappingRecord = BagGameModel:FindOverlappingPlacedItem(ShapeCells)
  if self.bIsConflictMode or OverlappingRecord then
    local ConflictRecord = self.bIsConflictMode and self.ConflictOverlappingRecord or OverlappingRecord
    DebugPrint("PlaceItemAtCell: 检测到重叠，允许临时放置")
    return self:PlaceItemNormal(BaseRow, BaseCol, DragUI, Operation, ShapeCells, ConflictRecord)
  end
  local Result = self:PlaceItemNormal(BaseRow, BaseCol, DragUI, Operation, ShapeCells, nil)
  DebugPrint("PlaceItemAtCell: 普通放置结果=" .. tostring(Result))
  return Result
end

function M:HandleAmmoLoad(DragUI, Operation)
  local GunRecord = self.CurrentOverlappingGun
  local bCanLoad = self.bCanLoadAmmo
  if not GunRecord then
    DebugPrint("HandleAmmoLoad: 没有目标武器")
    self:DeactivateShapeArea()
    return false
  end
  if not bCanLoad then
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_AmmoFull")
    self:DeactivateShapeArea()
    return false
  end
  local ActualStack = DragUI.CurrentStack and DragUI.CurrentStack > 0 and DragUI.CurrentStack or DragUI.DragSyncData and DragUI.DragSyncData.CurrentStack or nil
  local LoadAmount, Remaining, bSuccess = BagGameModel:CalculateLoadResult(GunRecord, DragUI.TemplateId, ActualStack)
  if not bSuccess then
    DebugPrint("HandleAmmoLoad: 装配失败")
    self:DeactivateShapeArea()
    return false
  end
  local ConsumedSnapshot = self:SnapshotContentData(DragUI.DisPlayItemId)
  local PreLoadAmmo = GunRecord.CurrentAmmo or 0
  BagGameModel:ExecuteLoadAmmo(GunRecord, LoadAmount)
  GunRecord.ConsumedItems = GunRecord.ConsumedItems or {}
  table.insert(GunRecord.ConsumedItems, {
    DisPlayItemId = DragUI.DisPlayItemId,
    TemplateId = DragUI.TemplateId,
    ConsumedAmount = LoadAmount,
    ContentDataSnapshot = ConsumedSnapshot
  })
  if GunRecord.OriginalAmmo == nil then
    GunRecord.OriginalAmmo = PreLoadAmmo
  end
  if GunRecord.Widget and GunRecord.Widget.UpdateAmmoDisplay then
    GunRecord.Widget:UpdateAmmoDisplay(GunRecord.CurrentAmmo)
  end
  if Remaining > 0 then
    self:UpdateAmmoRemaining(DragUI.DisPlayItemId, Remaining)
    self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 0)
    DebugPrint("HandleAmmoLoad: 装配完成，装入=" .. LoadAmount .. "，剩余=" .. Remaining)
  else
    self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 2)
    self:RemoveConfirmedItemFromList(DragUI.DisPlayItemId)
    DebugPrint("HandleAmmoLoad: 装配完成，子弹全部装入=" .. LoadAmount)
  end
  self:DeactivateShapeArea()
  self:UpdateScoreDisplay()
  self:UpdateFinishButtonState()
  self:OnDragStateChanged(false)
  return true
end

function M:UpdateAmmoRemaining(DisPlayItemId, Remaining)
  local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
  if not ContentData then
    return
  end
  ContentData.CurrentStack = Remaining
  self:RefreshVisibleEntryWidget(DisPlayItemId)
end

function M:HandleOtherStack(DragUI, Operation)
  local OtherRecord = self.CurrentOverlappingOther
  local bCanStack = self.bCanStack
  if not OtherRecord then
    DebugPrint("HandleOtherStack: 没有目标物品")
    self:DeactivateShapeArea()
    return false
  end
  if not bCanStack then
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_StackFull")
    self:DeactivateShapeArea()
    return false
  end
  local ActualStack = DragUI.CurrentStack and DragUI.CurrentStack > 0 and DragUI.CurrentStack or DragUI.DragSyncData and DragUI.DragSyncData.CurrentStack or nil
  local StackAmount, Remaining, bSuccess = BagGameModel:CalculateStackResult(OtherRecord, DragUI.TemplateId, ActualStack)
  if not bSuccess then
    DebugPrint("HandleOtherStack: 堆叠失败")
    self:DeactivateShapeArea()
    return false
  end
  local ConsumedSnapshot = self:SnapshotContentData(DragUI.DisPlayItemId)
  local PreStackCount = OtherRecord.CurrentStack or 0
  BagGameModel:ExecuteStack(OtherRecord, StackAmount)
  OtherRecord.ConsumedItems = OtherRecord.ConsumedItems or {}
  table.insert(OtherRecord.ConsumedItems, {
    DisPlayItemId = DragUI.DisPlayItemId,
    TemplateId = DragUI.TemplateId,
    ConsumedAmount = StackAmount,
    ContentDataSnapshot = ConsumedSnapshot
  })
  if OtherRecord.OriginalStack == nil then
    OtherRecord.OriginalStack = PreStackCount
  end
  self:UpdatePlacedItemStackDisplay(OtherRecord)
  if Remaining > 0 then
    self:UpdateOtherRemaining(DragUI.DisPlayItemId, Remaining)
    self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 0)
    DebugPrint("HandleOtherStack: 堆叠完成，堆入=" .. StackAmount .. "，剩余=" .. Remaining)
  else
    self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 2)
    self:RemoveConfirmedItemFromList(DragUI.DisPlayItemId)
    DebugPrint("HandleOtherStack: 堆叠完成，物品全部堆入=" .. StackAmount)
  end
  self:DeactivateShapeArea()
  self:UpdateScoreDisplay()
  self:UpdateFinishButtonState()
  self:OnDragStateChanged(false)
  return true
end

function M:UpdateOtherRemaining(DisPlayItemId, Remaining)
  local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
  if not ContentData then
    return
  end
  ContentData.CurrentStack = Remaining
  self:RefreshVisibleEntryWidget(DisPlayItemId)
end

function M:RefreshVisibleEntryWidget(DisPlayItemId)
  local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
  if not ContentData then
    return
  end
  local DisplayedWidgets = self.EMTileView1:GetDisplayedEntryWidgets()
  local Entry = FindAndRelinkEntry(DisplayedWidgets, ContentData, DisPlayItemId)
  if Entry and Entry.SyncDisplayFromContent then
    Entry:SyncDisplayFromContent()
  end
end

function M:UpdatePlacedItemStackDisplay(PlacedRecord)
  if not PlacedRecord or not PlacedRecord.Widget then
    return
  end
  local Widget = PlacedRecord.Widget
  local CurrentStack = PlacedRecord.CurrentStack or 0
  local ItemContent = BagGameModel:GetPlacedItemContent(PlacedRecord)
  local MaxStack = ItemContent and ItemContent.MaxStack or 0
  if Widget.UpdateStackDisplay then
    Widget:UpdateStackDisplay(CurrentStack, MaxStack)
  elseif Widget.SetAmmoNumber then
    Widget:SetAmmoNumber(CurrentStack, MaxStack)
  end
  DebugPrint("UpdatePlacedItemStackDisplay: 更新堆叠显示 " .. CurrentStack .. "/" .. MaxStack)
end

function M:SnapshotContentData(DisPlayItemId)
  local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
  if not ContentData then
    return nil
  end
  return {
    TemplateId = ContentData.TemplateId,
    ItemId = ContentData.ItemId,
    ItemType = ContentData.ItemType,
    ItemName = ContentData.ItemName,
    BasicPoint = ContentData.BasicPoint,
    GUIPath = ContentData.GUIPath,
    MaxAmmo = ContentData.MaxAmmo,
    MaxStack = ContentData.MaxStack,
    CurrentAmmo = ContentData.CurrentAmmo,
    CurrentStack = ContentData.CurrentStack,
    ShapeOffsets = ContentData.ShapeOffsets,
    DisPlayItemId = ContentData.DisPlayItemId
  }
end

function M:RestoreConsumedItem(ConsumedInfo)
  if not ConsumedInfo or not ConsumedInfo.DisPlayItemId then
    return
  end
  local DisPlayItemId = ConsumedInfo.DisPlayItemId
  local ExistingData = self.DisPlayItemDataById and self.DisPlayItemDataById[DisPlayItemId]
  if ExistingData then
    ExistingData.CurrentStack = (ExistingData.CurrentStack or 0) + ConsumedInfo.ConsumedAmount
    self:RefreshVisibleEntryWidget(DisPlayItemId)
    self:SetDisPlayItemSwitchIndex(DisPlayItemId, 0)
    return
  end
  local Snapshot = ConsumedInfo.ContentDataSnapshot
  if not Snapshot then
    return
  end
  local ContentData = NewObject(UIUtils.GetCommonItemContentClass())
  for k, v in pairs(Snapshot) do
    ContentData[k] = v
  end
  ContentData.SwitchIndex = 0
  ContentData.PlayScreen = self
  self.DisPlayItemDataById = self.DisPlayItemDataById or {}
  self.DisPlayItemDataById[DisPlayItemId] = ContentData
  self.DisPlayItemDataList = self.DisPlayItemDataList or {}
  table.insert(self.DisPlayItemDataList, ContentData)
  self:_InsertContentToTileViewHead(ContentData)
end

function M:PlaceItemNormal(BaseRow, BaseCol, DragUI, Operation, ShapeCells, ConflictRecord)
  if not ConflictRecord and not self:CanPlaceShapeAt(BaseRow, BaseCol, ShapeCells) then
    DebugPrint("PlaceItemNormal: 无法放置，位置不合法")
    self:DeactivateShapeArea()
    return false
  end
  local TopLeftRow, TopLeftCol = ShapeCells[1].Row, ShapeCells[1].Col
  for _, Cell in ipairs(ShapeCells) do
    if TopLeftRow > Cell.Row then
      TopLeftRow = Cell.Row
    end
    if TopLeftCol > Cell.Col then
      TopLeftCol = Cell.Col
    end
  end
  local MountRow = math.max(1, TopLeftRow)
  local MountCol = math.max(1, TopLeftCol)
  local TopLeftCell = self:GetContainItemAt(MountRow, MountCol)
  if not TopLeftCell then
    DebugPrint("PlaceItemNormal: 无法获取挂载格子(" .. MountRow .. "," .. MountCol .. ")")
    return false
  end
  local ShapeRows = 1
  local ShapeCols = 1
  if DragUI and DragUI.ShapeOffsets and #DragUI.ShapeOffsets > 0 then
    local MinRow, MaxRow = DragUI.ShapeOffsets[1][1], DragUI.ShapeOffsets[1][1]
    local MinCol, MaxCol = DragUI.ShapeOffsets[1][2], DragUI.ShapeOffsets[1][2]
    for _, Offset in ipairs(DragUI.ShapeOffsets) do
      MinRow = math.min(MinRow, Offset[1] or 0)
      MaxRow = math.max(MaxRow, Offset[1] or 0)
      MinCol = math.min(MinCol, Offset[2] or 0)
      MaxCol = math.max(MaxCol, Offset[2] or 0)
    end
    ShapeRows = MaxRow - MinRow + 1
    ShapeCols = MaxCol - MinCol + 1
  end
  local PlacedItem = self:CreatePlacedItem(DragUI, Operation, ShapeRows, ShapeCols)
  if not PlacedItem then
    return false
  end
  self:AttachPlacedItemToCell(PlacedItem, TopLeftCell)
  self:_PromoteItemToCanvasPanel(PlacedItem, TopLeftCell, 300)
  if not ConflictRecord then
    for _, Cell in ipairs(ShapeCells) do
      self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
    end
  end
  local ItemContent = BagGameModel:BuildItemContent(DragUI.TemplateId)
  if not self.PlacedItems then
    self.PlacedItems = {}
  end
  local PlacedRecord = {
    Widget = PlacedItem,
    Cells = ShapeCells,
    BaseRow = BaseRow,
    BaseCol = BaseCol,
    TemplateId = DragUI.TemplateId,
    DisPlayItemId = DragUI.DisPlayItemId,
    ItemType = ItemContent and ItemContent.ItemType,
    BasicPoint = ItemContent and ItemContent.BasicPoint or 0,
    CurrentAmmo = DragUI.DragSyncData and DragUI.DragSyncData.CurrentAmmo and DragUI.DragSyncData.CurrentAmmo > 0 and DragUI.DragSyncData.CurrentAmmo or ItemContent and ItemContent.CurrentAmmo or 0,
    MaxAmmo = ItemContent and ItemContent.MaxAmmo or 0,
    CurrentStack = DragUI.CurrentStack and DragUI.CurrentStack > 0 and DragUI.CurrentStack or ItemContent and ItemContent.CurrentStack or 1,
    MaxStack = ItemContent and ItemContent.MaxStack or 0,
    ConsumedItems = PlacedItem.ConsumedItems,
    OriginalAmmo = PlacedItem.OriginalAmmo,
    OriginalStack = PlacedItem.OriginalStack
  }
  local IsTempPlacement = nil ~= ConflictRecord
  if not IsTempPlacement then
    table.insert(self.PlacedItems, PlacedRecord)
    BagGameModel:AddPlacedItem(PlacedRecord)
  else
    PlacedRecord.IsTempPlacement = true
    PlacedRecord.ConflictRecord = ConflictRecord
    PlacedItem.IsTempPlacement = true
    PlacedItem.ConflictRecord = ConflictRecord
    PlacedItem.PlacedCells = ShapeCells
    DebugPrint("PlaceItemNormal: 创建临时放置，与物品重叠")
  end
  local FinalRecord = IsTempPlacement and PlacedRecord or self.PlacedItems[#self.PlacedItems]
  if not IsTempPlacement then
    self:RefreshPlacedItemDoubleState(PlacedItem)
  end
  if FinalRecord and FinalRecord.Cells then
    for _, Cell in ipairs(FinalRecord.Cells) do
      local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
      if ContainItem then
        ContainItem:ActivateHighlight(true)
      end
    end
  end
  self:UpdateScoreDisplay()
  self:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 2)
  self:SetUnconfirmedItem(PlacedItem)
  PlacedItem.bIsConfirmed = false
  self:UpdateFinishButtonState()
  self:UpdateRefreshButtonState()
  self:OnDragStateChanged(false)
  DebugPrint("PlaceItemNormal: 放置成功，左上角(" .. TopLeftRow .. "," .. TopLeftCol .. "), 大小(" .. ShapeRows .. "x" .. ShapeCols .. ")")
  return true
end

function M:CreatePlacedItem(DragUI, Operation, ShapeRows, ShapeCols)
  local PlacedItem = UIManager(self):_CreateWidgetNew("BagGameDragUIItem")
  if not PlacedItem then
    return nil
  end
  PlacedItem:SetVisibility(UIConst.VisibilityOp.Visible)
  PlacedItem.DisPlayItemId = DragUI.DisPlayItemId
  PlacedItem.TemplateId = DragUI.TemplateId
  PlacedItem.PlayScreen = self
  if DragUI.GetDragSyncData and PlacedItem.ApplyDragSyncData then
    local SyncData = DragUI:GetDragSyncData()
    if SyncData then
      PlacedItem:ApplyDragSyncData(SyncData)
    end
  end
  if DragUI.ShapeOffsets then
    PlacedItem:SetShape(DragUI.ShapeOffsets)
  end
  if PlacedItem.SetItemSize then
    PlacedItem:SetItemSize()
  end
  if DragUI.RotationCount then
    PlacedItem.RotationCount = DragUI.RotationCount
  end
  PlacedItem.bIsPlaced = true
  PlacedItem.bIsConfirmed = false
  PlacedItem.ConsumedItems = DragUI.ConsumedItems
  PlacedItem.OriginalAmmo = DragUI.OriginalAmmo
  PlacedItem.OriginalStack = DragUI.OriginalStack
  return PlacedItem
end

function M:MountItemToCell(PlacedItem, TopLeftCell, bPlayAnim)
  local CellPanel = TopLeftCell.Pos_Item or TopLeftCell
  if CellPanel and CellPanel.AddChild then
    local PanelSlot = CellPanel:AddChild(PlacedItem)
    if PanelSlot then
      local Anchors = PanelSlot:GetAnchors()
      Anchors.Minimum = FVector2D(0.0, 0.0)
      Anchors.Maximum = FVector2D(0.0, 0.0)
      PanelSlot:SetAnchors(Anchors)
      PanelSlot:SetAlignment(FVector2D(0.0, 0.0))
      PanelSlot:SetPosition(FVector2D(0.0, 0.0))
      PanelSlot:SetAutoSize(true)
    end
    if PlacedItem.Main then
      local MainSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(PlacedItem.Main)
      if MainSlot then
        local MainAnchors = MainSlot:GetAnchors()
        MainAnchors.Minimum = FVector2D(0.0, 0.0)
        MainAnchors.Maximum = FVector2D(0.0, 0.0)
        MainSlot:SetAnchors(MainAnchors)
        MainSlot:SetAlignment(FVector2D(0.0, 0.0))
        MainSlot:SetPosition(FVector2D(0.0, 0.0))
      end
    end
    PlacedItem:SetRenderScale(FVector2D(1, 1))
    if bPlayAnim then
      PlacedItem:PlayAnimation(PlacedItem.Size_In)
      PlacedItem:PlayAnimation(PlacedItem.Btn_In)
    end
  end
  self:BringCellToFront(TopLeftCell)
end

function M:AttachPlacedItemToCell(PlacedItem, TopLeftCell)
  self:MountItemToCell(PlacedItem, TopLeftCell, true)
  DebugPrint("AttachPlacedItemToCell: 放置到左上角格子(" .. TopLeftCell.Row .. "," .. TopLeftCell.Col .. ")")
end

function M:_PromoteItemToCanvasPanel(PlacedItem, TopLeftCell, nZOrder)
  local CellPanel = TopLeftCell.Pos_Item or TopLeftCell
  local WrapBox = TopLeftCell:GetParent()
  local GridCanvas = WrapBox:GetParent()
  local PosItemGeo = CellPanel:GetCachedGeometry()
  local PosItemAbsPos = UE4.USlateBlueprintLibrary.LocalToAbsolute(PosItemGeo, FVector2D(0, 0))
  local GridCanvasGeo = GridCanvas:GetCachedGeometry()
  local TargetPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(GridCanvasGeo, PosItemAbsPos)
  PlacedItem:RemoveFromParent()
  GridCanvas:AddChild(PlacedItem)
  local ItemSlot = UE.UWidgetLayoutLibrary.SlotAsCanvasSlot(PlacedItem)
  if ItemSlot then
    local Anchors = ItemSlot:GetAnchors()
    Anchors.Minimum = FVector2D(0.0, 0.0)
    Anchors.Maximum = FVector2D(0.0, 0.0)
    ItemSlot:SetAnchors(Anchors)
    ItemSlot:SetAlignment(FVector2D(0.0, 0.0))
    ItemSlot:SetPosition(TargetPos)
    ItemSlot:SetAutoSize(true)
    ItemSlot:SetZOrder(nZOrder)
  end
  if PlacedItem.Main then
    local MainSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(PlacedItem.Main)
    if MainSlot then
      local MainAnchors = MainSlot:GetAnchors()
      MainAnchors.Minimum = FVector2D(0.0, 0.0)
      MainAnchors.Maximum = FVector2D(0.0, 0.0)
      MainSlot:SetAnchors(MainAnchors)
      MainSlot:SetAlignment(FVector2D(0.0, 0.0))
      MainSlot:SetPosition(FVector2D(0.0, 0.0))
    end
  end
end

function M:AttachPlacedItemByAbsolutePosition(PlacedItem, TopLeftCell, ItemWidth, ItemHeight)
  local CellGeometry = TopLeftCell:GetCachedGeometry()
  if not CellGeometry then
    TopLeftCell:ForceLayoutPrepass()
    CellGeometry = TopLeftCell:GetCachedGeometry()
  end
  if not CellGeometry then
    DebugPrint("AttachPlacedItemByAbsolutePosition: 无法获取格子几何信息")
    return
  end
  local CellAbsPos = UIManager(self):GetWorldPosition(TopLeftCell)
  local PlacedContainer = TopLeftCell.Pos_Item
  if PlacedContainer and PlacedContainer.AddChild then
    PlacedContainer:AddChild(PlacedItem)
  end
end

function M:GetCellSize(Cell)
  if not Cell then
    return FVector2D(50, 50)
  end
  local CellGeometry = Cell:GetCachedGeometry()
  if not CellGeometry then
    Cell:ForceLayoutPrepass()
    CellGeometry = Cell:GetCachedGeometry()
  end
  if CellGeometry then
    return UE4.USlateBlueprintLibrary.GetLocalSize(CellGeometry)
  end
  local DesiredSize = Cell:GetDesiredSize()
  if DesiredSize and DesiredSize.X > 0 then
    return DesiredSize
  end
  return FVector2D(50, 50)
end

function M:MarkCellOccupied(Row, Col, PlacedItem)
  BagGameModel:MarkCellOccupied(Row, Col, PlacedItem)
  local Cell = self:GetContainItemAt(Row, Col)
  if Cell then
    Cell.bIsOccupied = true
    Cell.OccupiedBy = PlacedItem
  end
end

function M:IsCellOccupied(Row, Col)
  return BagGameModel:IsCellOccupied(Row, Col)
end

function M:IsCellOccupiedByOtherItem(Row, Col, ExcludeWidget)
  if not self.PlacedItems then
    return false
  end
  for _, Record in ipairs(self.PlacedItems) do
    if Record.Widget ~= ExcludeWidget and Record.Cells then
      for _, Cell in ipairs(Record.Cells) do
        if Cell.Row == Row and Cell.Col == Col then
          return true
        end
      end
    end
  end
  return false
end

function M:GetConfirmedPlacedItemAtCell(Row, Col)
  if not self.PlacedItems then
    return nil
  end
  for _, Record in ipairs(self.PlacedItems) do
    local Widget = Record.Widget
    if Widget and Widget.bIsConfirmed and Record.Cells then
      for _, Cell in ipairs(Record.Cells) do
        if Cell.Row == Row and Cell.Col == Col then
          return Record
        end
      end
    end
  end
  return nil
end

function M:BringCellToFront(Cell)
  if not Cell then
    return
  end
  local Parent = Cell:GetParent()
  if not Parent then
    return
  end
  local CanvasSlot = UE.UWidgetLayoutLibrary.SlotAsCanvasSlot(Cell)
  if CanvasSlot then
    CanvasSlot:SetZOrder(100)
    DebugPrint("BringCellToFront: 使用 ZOrder 提升层级")
    return
  end
end

function M:ResetCellZOrder(Cell)
  if not Cell then
    return
  end
  local CanvasSlot = UE.UWidgetLayoutLibrary.SlotAsCanvasSlot(Cell)
  if CanvasSlot then
    local Row, Col = Cell:GetPosition()
    local Index = (Row - 1) * GRID_COLS + Col
    CanvasSlot:SetZOrder(Index)
  end
end

function M:RecycleItem(PlacedItem)
  if not PlacedItem or not self.PlacedItems then
    return false
  end
  local RecordIndex, PlacedRecord
  for i, Record in ipairs(self.PlacedItems) do
    if Record.Widget == PlacedItem then
      RecordIndex = i
      PlacedRecord = Record
      break
    end
  end
  if not PlacedRecord then
    if PlacedItem.IsTempPlacement then
      PlacedItem:RemoveFromParent()
      if self.CurrentUnconfirmedItem == PlacedItem then
        self:SetUnconfirmedItem(nil)
      end
      self:SetDisPlayItemSwitchIndex(PlacedItem.DisPlayItemId, 0)
      self:RefreshVisibleEntryWidget(PlacedItem.DisPlayItemId)
      self:UpdateScoreDisplay()
      self:UpdateFinishButtonState()
      self:UpdateRefreshButtonState()
      DebugPrint("RecycleItem: 回收临时放置物品，DisPlayItemId=" .. tostring(PlacedItem.DisPlayItemId))
      return true
    end
    DebugPrint("RecycleItem: 未找到放置记录")
    return false
  end
  if PlacedRecord.Cells then
    for _, Cell in ipairs(PlacedRecord.Cells) do
      self:ClearCellOccupied(Cell.Row, Cell.Col)
    end
  end
  local _, ModelIndex = BagGameModel:FindPlacedItemByWidget(PlacedItem)
  if ModelIndex then
    BagGameModel:RemovePlacedItem(ModelIndex)
  end
  table.remove(self.PlacedItems, RecordIndex)
  self:_RemoveFromConfirmedItems(PlacedRecord)
  PlacedItem:RemoveFromParent()
  if self.CurrentUnconfirmedItem == PlacedItem then
    self:SetUnconfirmedItem(nil)
  end
  local ContentData = self.DisPlayItemDataById and self.DisPlayItemDataById[PlacedRecord.DisPlayItemId]
  if ContentData then
    if self._ContentDataGCGuard then
      self._ContentDataGCGuard[ContentData] = nil
    end
    if nil ~= PlacedRecord.CurrentAmmo then
      ContentData.CurrentAmmo = PlacedRecord.CurrentAmmo
    end
    if nil ~= PlacedRecord.CurrentStack then
      ContentData.CurrentStack = PlacedRecord.CurrentStack
    end
  end
  if ContentData and self._TileViewContentList then
    local bWasInList = false
    for i = #self._TileViewContentList, 1, -1 do
      if self._TileViewContentList[i] == ContentData then
        table.remove(self._TileViewContentList, i)
        bWasInList = true
      end
    end
    if not bWasInList then
      for i = #self._TileViewContentList, 1, -1 do
        if self._TileViewContentList[i].IsEmpty then
          table.remove(self._TileViewContentList, i)
          break
        end
      end
    end
    table.insert(self._TileViewContentList, 1, ContentData)
    ContentData.SwitchIndex = 0
    if self.DisPlayItemDataList then
      for i, Data in ipairs(self.DisPlayItemDataList) do
        if Data == ContentData then
          table.remove(self.DisPlayItemDataList, i)
          break
        end
      end
      table.insert(self.DisPlayItemDataList, 1, ContentData)
    end
    self:RebuildTileView()
    self:SetDisPlayItemSwitchIndex(PlacedRecord.DisPlayItemId, 0)
    self:RefreshVisibleEntryWidget(PlacedRecord.DisPlayItemId)
  else
    self:SetDisPlayItemSwitchIndex(PlacedRecord.DisPlayItemId, 0)
    self:RefreshVisibleEntryWidget(PlacedRecord.DisPlayItemId)
  end
  self:UpdateScoreDisplay()
  self:UpdateFinishButtonState()
  self:UpdateRefreshButtonState()
  DebugPrint("RecycleItem: 回收成功，DisPlayItemId=" .. tostring(PlacedRecord.DisPlayItemId))
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_cell_click_remove", nil, nil)
  return true
end

function M:ClearCellOccupied(Row, Col)
  BagGameModel:ClearCellOccupied(Row, Col)
  local Cell = self:GetContainItemAt(Row, Col)
  if Cell then
    Cell.bIsOccupied = false
    Cell.OccupiedBy = nil
    self:ResetCellZOrder(Cell)
    if Cell.DeactivateHighlight then
      Cell:DeactivateHighlight()
    end
  end
end

function M:CanReset()
  return self.PlacedItems ~= nil and #self.PlacedItems > 0
end

function M:UpdateRefreshButtonState()
  if self.Btn_Refresh then
    self.Btn_Refresh:SetForbidden(not self:CanReset())
  end
end

function M:OnBtnRefreshClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  if not self:CanReset() then
    return
  end
  UIManager():ShowCommonPopupUI(100332, {
    RightCallbackFunction = function()
      self:ResetPlayArea()
      AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_cell_click_remove", nil, nil)
    end
  }, self)
end

function M:ShowGuide(bFirst)
  local GuideRestoreCallback
  if bFirst then
    self:_PrepareGuideFocusRestore(2093)
    SystemGuideManager:RunGuideById(2093)
  else
    if self:_PrepareGuideFocusRestore() then
      function GuideRestoreCallback()
        self:_RequestGuideFocusRestore()
      end
    end
    GWorld.StoryMgr:RunStory("Guide/Guide_ZhengLi.story", nil, nil, GuideRestoreCallback, GuideRestoreCallback)
  end
end

function M:ResetPlayArea()
  BagGameController:ResetGame()
  self:SetUnconfirmedItem(nil)
  self:ClearAllPlacedItems()
  self:ResetAllCells()
  self:DeactivateShapeArea()
  if self.LevelInitialItem then
    self:InitDisPlayItem(self.LevelInitialItem)
  end
  self:UpdateScoreDisplay()
  self:SetFinishButtonEnabled(false)
  self:UpdateRefreshButtonState()
  DebugPrint("ResetPlayArea: 重置完成")
end

function M:_RemoveFromConfirmedItems(PlacedRecord)
  if not self._ConfirmedPlacedItems then
    return
  end
  for i, Record in ipairs(self._ConfirmedPlacedItems) do
    if Record == PlacedRecord then
      table.remove(self._ConfirmedPlacedItems, i)
      return
    end
  end
end

function M:ClearAllPlacedItems()
  if self.PlacedItems then
    for _, PlacedRecord in ipairs(self.PlacedItems) do
      if PlacedRecord.Widget then
        PlacedRecord.Widget:RemoveFromParent()
      end
    end
  end
  self.PlacedItems = {}
  self._ConfirmedPlacedItems = {}
  self._ContentDataGCGuard = nil
  if self._GamepadState == "FOCUS" then
    self._GamepadState = "SCROLL"
    self._FocusIndex = 1
    if self.EMTileView1 then
      self.EMTileView1:SetFocus()
    end
  end
end

function M:_InsertContentToTileViewHead(ContentData)
  if not self._TileViewContentList or not ContentData then
    return
  end
  for _, Content in ipairs(self._TileViewContentList) do
    if Content == ContentData then
      return
    end
  end
  for i = #self._TileViewContentList, 1, -1 do
    if self._TileViewContentList[i].IsEmpty then
      table.remove(self._TileViewContentList, i)
      break
    end
  end
  table.insert(self._TileViewContentList, 1, ContentData)
end

function M:ResetAllCells()
  if self.ContainItems then
    for i, ContainItem in ipairs(self.ContainItems) do
      if ContainItem then
        ContainItem.bIsOccupied = false
        ContainItem.OccupiedBy = nil
        if ContainItem.DeactivateHighlight then
          ContainItem:DeactivateHighlight()
        end
        self:ResetCellZOrder(ContainItem)
      end
    end
  end
end

function M:OnBtnFinishClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_sub_level_btn_click", nil, nil)
  if not self:CheckAllItemsPlaced() then
    DebugPrint("OnBtnFinishClicked: 还有物品未放置，无法结算")
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_HasnotFinsh")
    return
  end
  if self:HasUnconfirmedItem() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "UI_GameEvent_BagGame_Toast_HasnotFinsh")
    DebugPrint("OnBtnFinishClicked: 有未确认的物品，请先确认")
    return
  end
  local TotalScore = self:UpdateScoreDisplay()
  DebugPrint("最终得分: " .. TotalScore)
  self:DoSettlement(TotalScore)
end

function M:DoSettlement(TotalScore)
  self:SetFinishButtonEnabled(false)
  BagGameController:FinishGame(function(bSuccess)
    if bSuccess then
      self:ShowSettlementResult(TotalScore)
    else
      self:SetFinishButtonEnabled(true)
    end
  end)
end

function M:ShowSettlementResult(TotalScore)
  self.bLevelCompletedThisSession = true
  local StarCount = self:UpdateStarCountByScore(TotalScore)
  DebugPrint(string.format("结算完成: 得分=%d, 星数=%d", TotalScore, StarCount))
  local ScoreInfo = {}
  if self.TargetScore then
    for i, Score in ipairs(self.TargetScore) do
      table.insert(ScoreInfo, {
        text = string.format(GText("UI_BackpackPuzzle_Target" .. i), Score),
        isFinish = TotalScore >= Score
      })
    end
  end
  local IsNewRecord = TotalScore > (self.PlayerScore or 0)
  local Params = {
    LevelScore = TotalScore,
    IsWin = StarCount > 0,
    IsNewRecord = IsNewRecord,
    ActivityId = BagGameModel.CurEventId,
    ScoreInfo = ScoreInfo,
    RewardIds = self.TargetReward,
    Btn_Continue_Text = "UI_TEMPLE_RESTART",
    ExitCallback = function(SettlementWidget)
      if self.SettlementPage and self.SettlementPage.RemoveFromParent then
        self.SettlementPage:RemoveFromParent()
      end
      self.SettlementPage = nil
      self:CleanupPlayState()
      if self.Owner and self.Owner.RefreshLevelListAfterPlay then
        self.Owner:RefreshLevelListAfterPlay(self.LevelId)
      end
      self:_RequestOwnerFocusRestore()
      self:Close()
      DebugPrint("WBP_Activity_BagGame_Play_C: ExitCallback")
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    end,
    ContinueCallback = function(SettlementWidget)
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
      if self.SettlementPage and self.SettlementPage.RemoveFromParent then
        self.SettlementPage:RemoveFromParent()
      end
      self.SettlementPage = nil
      self:ResetPlayArea()
      self:SetFocus()
    end
  }
  self.SettlementPage = ActivityUtils.OpenActivitySettlement(BagGameModel.CurEventId, nil, Params)
end

function M:UpdateScoreDisplay()
  local TotalScore, DoubleScore, NormalScore = BagGameModel:CalculateCurrentScore()
  if self.Text_Score then
    self.Text_Score:SetText(tostring(TotalScore))
  end
  if self.Text_ScoreDetail then
    local DetailText = string.format("双倍区: %d×2 + 普通区: %d = %d", DoubleScore, NormalScore, TotalScore)
    self.Text_ScoreDetail:SetText(DetailText)
  end
  DebugPrint(string.format("分数更新: 总分=%d (双倍区=%d, 普通区=%d)", TotalScore, DoubleScore, NormalScore))
  self:UpdateStarCountByScore(TotalScore)
  return TotalScore
end

function M:GetCurrentScore()
  return BagGameModel.CurrentScore or 0
end

function M:SetFinishButtonEnabled(bEnabled)
  if not self.Btn_Finish then
    return
  end
  self.bFinishButtonEnabled = bEnabled
  if bEnabled then
    self.Btn_Finish:SetForbidden(false)
    DebugPrint("完成按钮: 启用")
  else
    self.Btn_Finish:SetForbidden(true)
    DebugPrint("完成按钮: 禁用")
  end
end

function M:CheckAllItemsPlaced()
  if not self.TotalDisPlayItemCount or 0 == self.TotalDisPlayItemCount then
    return false
  end
  if self.DisPlayItemDataById then
    for _, ContentData in pairs(self.DisPlayItemDataById) do
      if 2 ~= ContentData.SwitchIndex then
        return false
      end
    end
  end
  local bAllPlaced = true
  DebugPrint(string.format("检查物品放置状态: 全部完成=%s", tostring(bAllPlaced)))
  return bAllPlaced
end

function M:UpdateFinishButtonState()
  local bAllPlaced = self:CheckAllItemsPlaced()
  local bHasUnconfirmed = self:HasUnconfirmedItem()
  local bAllScoring = BagGameModel:AreAllPlacedItemsScoring()
  local bShouldEnable = bAllPlaced and not bHasUnconfirmed and bAllScoring
  self:SetFinishButtonEnabled(bShouldEnable)
  DebugPrint(string.format("更新完成按钮: 全部放置=%s, 有未确认=%s, 全部得分=%s, 启用=%s", tostring(bAllPlaced), tostring(bHasUnconfirmed), tostring(bAllScoring), tostring(bShouldEnable)))
end

function M:CleanupPlayState()
  self:SetUnconfirmedItem(nil)
  self:ClearAllPlacedItems()
  self:ResetAllCells()
  self:DeactivateShapeArea()
  self:ClearAllCellPosItems()
end

function M:ClearAllCellPosItems()
  local TotalCells = GRID_ROWS * GRID_COLS
  for i = 1, TotalCells do
    local ContainItem = self["PlayItem_" .. i]
    if ContainItem and ContainItem.Pos_Item and ContainItem.Pos_Item.ClearChildren then
      ContainItem.Pos_Item:ClearChildren()
    end
  end
end

function M:ExecuteExitLevel()
  self:_ClearGuideFocusRestoreState()
  self:CleanupPlayState()
  if self.bLevelCompletedThisSession and self.Owner and self.Owner.RefreshLevelListAfterPlay then
    self.Owner:RefreshLevelListAfterPlay(self.LevelId)
  end
  self:_RequestOwnerFocusRestore()
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  self:PlayAnimation(self.Out)
end

function M:OnBtnCloseClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_return", nil, nil)
  self:CloseSelf()
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  
  local function CancelFunc()
  end
  
  local function ConfirmFunc()
    self:ExecuteExitLevel()
  end
  
  local function CloseBtnFunc()
  end
  
  UIManager():ShowCommonPopupUI(100330, {
    LeftCallbackFunction = CancelFunc,
    RightCallbackFunction = ConfirmFunc,
    CloseBtnCallbackFunction = CloseBtnFunc
  }, self)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self._GamepadState == "MOVING" then
    if "Gamepad_LeftStick_Up" == InKeyName or "Gamepad_LeftStick_Down" == InKeyName or "Gamepad_LeftStick_Left" == InKeyName or "Gamepad_LeftStick_Right" == InKeyName then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    self:HandleGamepadInput(InKeyName)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if self._GamepadState == "FOCUS" then
    if "Gamepad_LeftStick_Up" == InKeyName or "Gamepad_LeftStick_Down" == InKeyName or "Gamepad_LeftStick_Left" == InKeyName or "Gamepad_LeftStick_Right" == InKeyName then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    self:HandleGamepadInput(InKeyName)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local Const = UIConst.GamePadKey
  if InKeyName == Const.FaceButtonBottom or InKeyName == Const.FaceButtonRight or InKeyName == Const.LeftThumb or InKeyName == Const.RightThumb then
    self:HandleGamepadInput(InKeyName)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  local Const = UIConst.GamePadKey
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:HandleGamepadInput(InKeyName)
    if not IsEventHandled and InKeyName == Const.FaceButtonTop then
      self:OnBtnRefreshClicked()
      IsEventHandled = true
    end
    if not IsEventHandled and InKeyName == Const.FaceButtonLeft then
      self:OnBtnFinishClicked()
      IsEventHandled = true
    end
    if not IsEventHandled and InKeyName == Const.SpecialRight then
      self:ShowGuide()
      IsEventHandled = true
    end
  elseif "Escape" == InKeyName then
    self:CloseSelf()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:ConsumeGamepadStackItem(PlacedItem, PlacedRecord, TargetRecord, bCanStack)
  if not bCanStack then
    return false
  end
  local StackAmount, Remaining, bSuccess = BagGameModel:CalculateStackResult(TargetRecord, PlacedItem.TemplateId, PlacedRecord.CurrentStack)
  if not bSuccess then
    return false
  end
  BagGameModel:ExecuteStack(TargetRecord, StackAmount)
  self:UpdatePlacedItemStackDisplay(TargetRecord)
  PlacedItem:RemoveFromParent()
  local _, ModelIndex = BagGameModel:FindPlacedItemByWidget(PlacedItem)
  if ModelIndex then
    BagGameModel:RemovePlacedItem(ModelIndex)
  end
  for i, Record in ipairs(self.PlacedItems) do
    if Record == PlacedRecord then
      table.remove(self.PlacedItems, i)
      break
    end
  end
  self:_RemoveFromConfirmedItems(PlacedRecord)
  if self.CurrentUnconfirmedItem == PlacedItem then
    self:SetUnconfirmedItem(nil)
  end
  if Remaining > 0 then
    self:UpdateOtherRemaining(PlacedItem.DisPlayItemId, Remaining)
    self:SetDisPlayItemSwitchIndex(PlacedItem.DisPlayItemId, 0)
  else
    self:SetDisPlayItemSwitchIndex(PlacedItem.DisPlayItemId, 2)
    self:RemoveConfirmedItemFromList(PlacedItem.DisPlayItemId)
  end
  self:UpdateScoreDisplay()
  self:UpdateFinishButtonState()
  return true
end

function M:ConsumeGamepadAmmoItem(PlacedItem, PlacedRecord, GunRecord, bCanLoad)
  if not bCanLoad then
    return false
  end
  local LoadAmount, Remaining, bSuccess = BagGameModel:CalculateLoadResult(GunRecord, PlacedItem.TemplateId, PlacedRecord.CurrentStack)
  if not bSuccess then
    return false
  end
  BagGameModel:ExecuteLoadAmmo(GunRecord, LoadAmount)
  if GunRecord.Widget and GunRecord.Widget.UpdateAmmoDisplay then
    GunRecord.Widget:UpdateAmmoDisplay(GunRecord.CurrentAmmo)
  end
  PlacedItem:RemoveFromParent()
  local _, ModelIndex = BagGameModel:FindPlacedItemByWidget(PlacedItem)
  if ModelIndex then
    BagGameModel:RemovePlacedItem(ModelIndex)
  end
  for i, Record in ipairs(self.PlacedItems) do
    if Record == PlacedRecord then
      table.remove(self.PlacedItems, i)
      break
    end
  end
  self:_RemoveFromConfirmedItems(PlacedRecord)
  if self.CurrentUnconfirmedItem == PlacedItem then
    self:SetUnconfirmedItem(nil)
  end
  if Remaining > 0 then
    self:UpdateAmmoRemaining(PlacedItem.DisPlayItemId, Remaining)
    self:SetDisPlayItemSwitchIndex(PlacedItem.DisPlayItemId, 0)
  else
    self:SetDisPlayItemSwitchIndex(PlacedItem.DisPlayItemId, 2)
    self:RemoveConfirmedItemFromList(PlacedItem.DisPlayItemId)
  end
  self:UpdateScoreDisplay()
  self:UpdateFinishButtonState()
  return true
end

function M:BP_GetDesiredFocusTarget()
  if self._SyncGamepadStateWithRuntimeContext then
    self:_SyncGamepadStateWithRuntimeContext()
  end
  if self._GamepadState == "MOVING" or self._GamepadState == "FOCUS" then
    return self
  end
  return self.EMTileView1
end

function M:_IsGuideRestoreFocusNeeded()
  return UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
end

function M:_ClearGuideFocusRestoreState()
  if self.bGuideFocusListenerRegistered then
    EventManager:RemoveEvent(EventID.OnGuideEnd, self)
  end
  self:RemoveTimer(GUIDE_RESTORE_FOCUS_TIMER)
  self.bGuideFocusRestorePending = false
  self.bGuideFocusListenerRegistered = false
  self.GuideFocusRestoreGuideId = nil
end

function M:_PrepareGuideFocusRestore(GuideId)
  self:_ClearGuideFocusRestoreState()
  if not self:_IsGuideRestoreFocusNeeded() then
    return false
  end
  self.bGuideFocusRestorePending = true
  self.GuideFocusRestoreGuideId = GuideId
  if GuideId then
    EventManager:AddEvent(EventID.OnGuideEnd, self, self.OnGuideEnd)
    self.bGuideFocusListenerRegistered = true
  end
  return true
end

function M:_RequestGuideFocusRestore()
  if self.bGuideFocusListenerRegistered then
    EventManager:RemoveEvent(EventID.OnGuideEnd, self)
    self.bGuideFocusListenerRegistered = false
  end
  if not self.bGuideFocusRestorePending then
    return
  end
  self:RemoveTimer(GUIDE_RESTORE_FOCUS_TIMER)
  self:AddTimer(GUIDE_RESTORE_FOCUS_DELAY, function()
    self:RemoveTimer(GUIDE_RESTORE_FOCUS_TIMER)
    self.bGuideFocusRestorePending = false
    self.GuideFocusRestoreGuideId = nil
    if not self:_IsGuideRestoreFocusNeeded() then
      return
    end
    local FocusTarget = self:BP_GetDesiredFocusTarget()
    if FocusTarget and FocusTarget.SetFocus then
      FocusTarget:SetFocus()
      return
    end
    self:SetFocus()
  end, false, 0, GUIDE_RESTORE_FOCUS_TIMER, true)
end

function M:OnGuideEnd(GuideId)
  if not self.bGuideFocusRestorePending then
    return
  end
  if self.GuideFocusRestoreGuideId and GuideId ~= self.GuideFocusRestoreGuideId then
    return
  end
  self:_RequestGuideFocusRestore()
end

function M:_RequestOwnerFocusRestore()
  local Owner = self.Owner
  if not Owner or UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  
  local function RestoreFocus()
    if not Owner then
      return
    end
    if Owner._RestoreMainFocusForGamepad then
      Owner:_RestoreMainFocusForGamepad()
      return
    end
    local FocusTarget = Owner.BP_GetDesiredFocusTarget and Owner:BP_GetDesiredFocusTarget() or Owner
    if FocusTarget and FocusTarget.SetFocus then
      FocusTarget:SetFocus()
      return
    end
    if Owner.SetFocus then
      Owner:SetFocus()
    end
  end
  
  RestoreFocus()
  if Owner.RemoveTimer then
    Owner:RemoveTimer(OWNER_RESTORE_FOCUS_TIMER)
  end
  if Owner.AddTimer then
    Owner:AddTimer(OWNER_RESTORE_FOCUS_DELAY, RestoreFocus, false, 0, OWNER_RESTORE_FOCUS_TIMER, true)
  end
end

AssembleComponents(M)
return M
