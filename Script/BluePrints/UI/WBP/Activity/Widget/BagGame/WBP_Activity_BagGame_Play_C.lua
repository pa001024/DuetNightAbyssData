require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  M.Super.Construct(self)
  self.Overlay_Recycle:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Btn_Refresh.OnClicked:Add(self, self.OnBtnRefreshClicked)
  self.Btn_Finish.OnClicked:Add(self, self.OnBtnFinishClicked)
end

function M:Destruct()
  self.Btn_Refresh.OnClicked:Remove(self, self.OnBtnRefreshClicked)
  self.Btn_Finish.OnClicked:Remove(self, self.OnBtnFinishClicked)
  M.Super.Destruct(self)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  self.Params = Params
  self.Owner = Params.Owner
  self:InitData(Params)
  self:InitView(Params)
  self:PlayAnimation(self.In)
  self:SetFocus()
end

function M:InitData(Params)
  self.Content = Params.Content
  self.LevelId = self.Content.Id
  self.Title = self.Content.Title
  self.Rule = self.Content.Rule
  self.MaxScore = self.Content.MaxScore
  self.StarState = self.Content.StarState
  self.Reward = self.Content.Reward
end

function M:InitView(Params)
  self.Text_Score = self.MaxScore
  self:Set_NumandStart(self.LevelId, Params.Star)
  self:InitDisPlayItem(self.Content.DisPlayItems)
  self:InitContainItem(self.Content.ContainItems)
  self:OnBtnRefreshClicked()
end

function M:InitDisPlayItem(DisPlayItems)
  if not DisPlayItems then
    return
  end
  local Widget = self.WrapBox_122:GetChildAt(0)
  if not Widget then
    return
  end
  local WidgetClass = UGameplayStatics.GetObjectClass(Widget)
  self.WrapBox_122:ClearChildren()
  for _, DisPlayItem in ipairs(DisPlayItems) do
    local NewDisPlayItem = UIManager(self):CreateWidget(WidgetClass)
    local Content = {
      Id = DisPlayItem.Id,
      Title = DisPlayItem.Title,
      Type = DisPlayItem.Type,
      IconPath = DisPlayItem.IconPath,
      ShapeOffsets = DisPlayItem.ShapeOffsets
    }
    self.WrapBox_122:AddChild(NewDisPlayItem)
    NewDisPlayItem:Init(Content, self)
  end
end

local GRID_ROWS = 8
local GRID_COLS = 10

function M:CreateGridMatrix()
  local Matrix = {}
  for Row = 1, GRID_ROWS do
    Matrix[Row] = {}
    for Col = 1, GRID_COLS do
      Matrix[Row][Col] = 0
    end
  end
  return Matrix
end

function M:CreateGridMatrixFromConfig(ConfigData)
  local Matrix = self:CreateGridMatrix()
  if ConfigData then
    for _, CellData in ipairs(ConfigData) do
      local Row = CellData[1] or CellData.Row
      local Col = CellData[2] or CellData.Col
      local Value = CellData[3] or CellData.Value or 0
      if Row >= 1 and Row <= GRID_ROWS and Col >= 1 and Col <= GRID_COLS then
        Matrix[Row][Col] = Value
      end
    end
  end
  return Matrix
end

function M:GetGridValue(Row, Col)
  if not self.GridMatrix then
    return nil
  end
  if Row < 1 or Row > GRID_ROWS or Col < 1 or Col > GRID_COLS then
    return nil
  end
  return self.GridMatrix[Row][Col]
end

function M:SetGridValue(Row, Col, Value)
  if not self.GridMatrix then
    return
  end
  if Row < 1 or Row > GRID_ROWS or Col < 1 or Col > GRID_COLS then
    return
  end
  self.GridMatrix[Row][Col] = Value
  local Index = (Row - 1) * GRID_COLS + Col
  local ContainItem = self.ContainItems[Index]
  if ContainItem then
    ContainItem:SetValue(Value)
  end
end

function M:InitContainItem(ContainItemsConfig)
  if ContainItemsConfig and #ContainItemsConfig > 0 and ContainItemsConfig[1][1] then
    self.GridMatrix = self:CreateGridMatrixFromConfig(ContainItemsConfig)
  else
    self.GridMatrix = self:CreateGridMatrix()
  end
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
  for _, Cell in ipairs(ShapeCells) do
    local Row, Col = Cell.Row, Cell.Col
    if Row < 1 or Row > GRID_ROWS or Col < 1 or Col > GRID_COLS then
      return false
    end
    local Value = self:GetGridValue(Row, Col)
    if nil == Value or 0 == Value or -1 == Value then
      return false
    end
    if self:IsCellOccupied(Row, Col) then
      return false
    end
  end
  return true
end

function M:ActivateShapeArea(BaseRow, BaseCol, DragUI)
  self:DeactivateShapeArea()
  if not DragUI or not DragUI.GetShapeCells then
    return
  end
  local ShapeCells = DragUI:GetShapeCells(BaseRow, BaseCol)
  local bCanPlace = true
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
end

function M:CanPlaceCurrent()
  return self.bCanPlaceCurrent == true
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
  local MinRow, MaxRow = ShapeCells[1].Row, ShapeCells[1].Row
  local MinCol, MaxCol = ShapeCells[1].Col, ShapeCells[1].Col
  for _, Cell in ipairs(ShapeCells) do
    MinRow = math.min(MinRow, Cell.Row)
    MaxRow = math.max(MaxRow, Cell.Row)
    MinCol = math.min(MinCol, Cell.Col)
    MaxCol = math.max(MaxCol, Cell.Col)
  end
  local ShapeRows = MaxRow - MinRow + 1
  local ShapeCols = MaxCol - MinCol + 1
  local TopLeftCell = self:GetContainItemAt(MinRow, MinCol)
  if not TopLeftCell then
    DebugPrint("PlaceItemAtCell: 无法获取左上角格子")
    return false
  end
  local PlacedItem = self:CreatePlacedItem(DragUI, Operation, ShapeRows, ShapeCols)
  if not PlacedItem then
    return false
  end
  self:AttachPlacedItemToCell(PlacedItem, TopLeftCell, ShapeRows, ShapeCols)
  for _, Cell in ipairs(ShapeCells) do
    self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
  end
  if not self.PlacedItems then
    self.PlacedItems = {}
  end
  table.insert(self.PlacedItems, {
    Widget = PlacedItem,
    Cells = ShapeCells,
    BaseRow = BaseRow,
    BaseCol = BaseCol,
    DisPlayItemId = DragUI.DisPlayItemId
  })
  DebugPrint("PlaceItemAtCell: 放置成功，位置(" .. MinRow .. "," .. MinCol .. "), 大小(" .. ShapeRows .. "x" .. ShapeCols .. ")")
  return true
end

function M:CreatePlacedItem(DragUI, Operation, ShapeRows, ShapeCols)
  local PlacedItem = UIManager(self):_CreateWidgetNew("BagGameDragUIItem")
  if not PlacedItem then
    return nil
  end
  PlacedItem:SetVisibility(UIConst.VisibilityOp.Visible)
  PlacedItem.DisPlayItemId = DragUI.DisPlayItemId
  PlacedItem.PlayScreen = self
  if DragUI.ShapeOffsets then
    PlacedItem:SetShape(DragUI.ShapeOffsets)
  end
  return PlacedItem
end

function M:AttachPlacedItemToCell(PlacedItem, TopLeftCell, ShapeRows, ShapeCols)
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
    PlacedItem:SetRenderScale(FVector2D(1, 1))
    PlacedItem:PlayAnimation(PlacedItem.Size_In)
    PlacedItem:PlayAnimation(PlacedItem.Btn_In)
  end
  self:BringCellToFront(TopLeftCell)
  DebugPrint("AttachPlacedItemToCell: 放置到格子(" .. TopLeftCell.Row .. "," .. TopLeftCell.Col .. ")")
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
  if not self.OccupiedMatrix then
    self.OccupiedMatrix = {}
    for r = 1, GRID_ROWS do
      self.OccupiedMatrix[r] = {}
    end
  end
  self.OccupiedMatrix[Row][Col] = PlacedItem
  local Cell = self:GetContainItemAt(Row, Col)
  if Cell then
    Cell.bIsOccupied = true
    Cell.OccupiedBy = PlacedItem
  end
end

function M:IsCellOccupied(Row, Col)
  if not self.OccupiedMatrix then
    return false
  end
  if not self.OccupiedMatrix[Row] then
    return false
  end
  return self.OccupiedMatrix[Row][Col] ~= nil
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
    DebugPrint("RecycleItem: 未找到放置记录")
    return false
  end
  if PlacedRecord.Cells then
    for _, Cell in ipairs(PlacedRecord.Cells) do
      self:ClearCellOccupied(Cell.Row, Cell.Col)
    end
  end
  table.remove(self.PlacedItems, RecordIndex)
  PlacedItem:RemoveFromParent()
  DebugPrint("RecycleItem: 回收成功，DisPlayItemId=" .. tostring(PlacedRecord.DisPlayItemId))
  return true
end

function M:ClearCellOccupied(Row, Col)
  if self.OccupiedMatrix and self.OccupiedMatrix[Row] then
    self.OccupiedMatrix[Row][Col] = nil
  end
  local Cell = self:GetContainItemAt(Row, Col)
  if Cell then
    Cell.bIsOccupied = false
    Cell.OccupiedBy = nil
    self:ResetCellZOrder(Cell)
  end
end

function M:OnBtnRefreshClicked()
  DebugPrint("OnBtnRefreshClicked: 重置游戏界面")
  self:ResetPlayArea()
end

function M:ResetPlayArea()
  self:ClearAllPlacedItems()
  self:ResetAllCells()
  self:DeactivateShapeArea()
  if self.Content and self.Content.DisPlayItems then
    self:InitDisPlayItem(self.Content.DisPlayItems)
  end
  DebugPrint("ResetPlayArea: 重置完成")
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
end

function M:ResetAllCells()
  if self.OccupiedMatrix then
    for Row = 1, GRID_ROWS do
      if self.OccupiedMatrix[Row] then
        for Col = 1, GRID_COLS do
          self.OccupiedMatrix[Row][Col] = nil
        end
      end
    end
  end
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
  DebugPrint("OnBtnFinishClicked")
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  self:PlayAnimation(self.Out)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    self:CloseSelf()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

return M
