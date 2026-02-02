local InventoryModel = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryModel")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local InventoryController = Class()
InventoryController._components = {
  "BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.ItemMoveComponent"
}

function InventoryController:Init(Params)
  DebugPrint("lgc@InventoryController Init  bInit =", self.bInit)
  self.InventoryModel = InventoryModel
  self.MainWidget = Params.MainWidget
  self.InventoryModel:Init(Params)
  self.bInit = true
  self:InitEvents()
  self.LastTargetGrids = {}
  self.AllPockets = {
    "WBP_Type01_Bag01",
    "WBP_Type01_Bag02",
    "WBP_Type01_Bag03",
    "WBP_Type01_Bag04",
    {
      "Bag_Search",
      "WBP_Search_Bag"
    }
  }
  for _, Pocket in ipairs(self.AllPockets) do
    if type(Pocket) == "table" then
      if self.MainWidget[Pocket[1]][Pocket[2]] and IsValid(self.MainWidget[Pocket[1]][Pocket[2]]) then
        self.MainWidget[Pocket[1]][Pocket[2]].Name = Pocket[2]
        self:RegisterPocket(self.MainWidget[Pocket[1]][Pocket[2]])
      end
    elseif self.MainWidget[Pocket] and IsValid(self.MainWidget[Pocket]) then
      self.MainWidget[Pocket].Name = Pocket
      self:RegisterPocket(self.MainWidget[Pocket])
    end
  end
  if self.bInit then
    return
  end
end

function InventoryController:UpdateView()
  local ResetParams = {bCanMove = nil, bReset = true}
  local TreasureItemSet = {}
  for _, Cols in pairs(self.InventoryModel.Grids or {}) do
    for X, Col in pairs(Cols or {}) do
      if type(X) == "number" then
        for Y, Grid in pairs(Col or {}) do
          if type(Y) == "number" then
            if Grid and Grid.UpdateView then
              Grid:UpdateView(ResetParams)
            end
            local TI = Grid and Grid.TreasureItem
            if TI and not TreasureItemSet[TI] then
              TreasureItemSet[TI] = true
            end
          end
        end
      end
    end
  end
  for TI, _ in pairs(TreasureItemSet) do
    if TI and TI.UpdateView then
      TI:UpdateView({
        NewPocket = TI.Pocket,
        NewPosition = TI.Position,
        NewDirection = TI.Direction,
        bDrag = false
      })
    end
  end
end

function InventoryController:InitEvents()
end

function InventoryController:RemoveEvents()
end

function InventoryController:Tick(DeltaTime)
  if not self.DragWidget then
    return
  end
  if not IsValid(self.DragWidget) then
    return
  end
  local MousePos = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self.MainWidget)
  if not MousePos then
    return
  end
  if not self._DragWidgetPivotSet then
    self.DragWidget:SetRenderTransformPivot(FVector2D(0.5, 0.5))
    self._DragWidgetPivotSet = true
  end
  self.DragWidget:SetRenderTranslation(MousePos)
end

function InventoryController:RegisterPocket(Pocket)
  local PocketData
  if not self.InventoryModel.Pockets[Pocket.Name] then
    PocketData = {
      Inventory = Pocket.Inventory,
      Pocket = Pocket,
      Name = Pocket.Name
    }
    self.InventoryModel.Pockets[Pocket.Name] = PocketData
    Pocket.Data = PocketData
  else
    PocketData = self.InventoryModel.Pockets[Pocket.Name]
    PocketData.Pocket = Pocket
    Pocket.Data = PocketData
  end
  local AllGrids = Pocket.WrapBoxBag:GetAllChildren():ToTable()
  for _, Grid in ipairs(AllGrids) do
    if Grid and IsValid(Grid) then
      self:RegisterGrid(Grid, PocketData, Pocket.Inventory)
    end
  end
  Pocket:Init()
end

function InventoryController:RegisterGrid(Grid, PocketData, Inventory)
  if not self.InventoryModel.Grids[PocketData.Name] then
    self.InventoryModel.Grids[PocketData.Name] = {}
  end
  if not self.InventoryModel.Grids[PocketData.Name][Grid.Position.X] then
    self.InventoryModel.Grids[PocketData.Name][Grid.Position.X] = {}
  end
  local GridData
  if not self.InventoryModel.Grids[PocketData.Name][Grid.Position.X][Grid.Position.Y] then
    GridData = {
      Grid = Grid,
      Position = Grid.Position,
      PocketName = PocketData.Name,
      PocketInventory = Inventory,
      TreasureData = nil
    }
    self.InventoryModel.Grids[PocketData.Name][Grid.Position.X][Grid.Position.Y] = GridData
    Grid.Data = GridData
  else
    GridData = self.InventoryModel.Grids[PocketData.Name][Grid.Position.X][Grid.Position.Y]
    GridData.Grid = Grid
    Grid.Data = GridData
  end
  Grid:Init({PocketData = PocketData, Inventory = Inventory})
end

function InventoryController:Destory()
  DebugPrint("lgc@InventoryController Destory  bInit =", self.bInit)
  InventoryModel:Destory()
  if not self.bInit then
    return
  end
  self:RemoveEvents()
  self.bInit = false
end

function InventoryController:OnDragDetected(DragWidget, MyGeometry, PointerEvent)
  DebugPrint("lgc@InventoryController OnDragDetected Pos =", DragWidget.Position.X, DragWidget.Position.Y)
  EventManager:FireEvent(EventID.OnTreasureItemDragDetected, DragWidget)
  self:NotifyDragUp(DragWidget)
end

function InventoryController:OnDragCancelled(DragWidget, PointerEvent, Operation)
  EventManager:FireEvent(EventID.OnTreasureItemDragCancelled)
  self:NotifyDragOverGrids(DragWidget, nil)
  local DragItem = DragWidget.TreasureItem
  if DragItem then
    DragItem:UpdateView({bDrag = false})
  end
  UIManager(self):ShowUITip("CommonToastMain", GText(InventoryCommonConst.DropFailedToastText), 2)
end

function InventoryController:OnDragEnter(DragEnterWidget, MyGeometry, PointerEvent, Operation)
  DebugPrint("lgc@InventoryController OnDragEnter Pos =", DragEnterWidget.Position.X, DragEnterWidget.Position.Y)
  local DragGrid = Operation.Payload
  if not DragGrid or not DragEnterWidget then
    return
  end
  self:NotifyDragOverGrids(DragGrid, DragEnterWidget)
end

function InventoryController:OnDragLeave(DragLeaveWidget, PointerEvent, Operation)
  DebugPrint("lgc@InventoryController OnDragLeave Pos =", DragLeaveWidget.Position.X, DragLeaveWidget.Position.Y)
  local DragGrid = Operation.Payload
  if not DragGrid or not DragLeaveWidget then
    return
  end
  self:NotifyDragOverGrids(DragGrid, nil)
end

function InventoryController:OnDrop(DropWidget, MyGeometry, PointerEvent, Operation)
  DebugPrint("lgc@InventoryController OnDrop Pos =", DropWidget.Position.X, DropWidget.Position.Y)
  local DragGrid = Operation.Payload
  if not DragGrid or not DropWidget then
    return
  end
  local bDropSuccess = self:TryDropAndSwitchItem(DragGrid, DropWidget)
  DebugPrint("lgc@InventoryController TryDropAndSwitchItem bDropSuccess =", bDropSuccess)
  return bDropSuccess
end

function InventoryController:QuickTransferFromGrid(DragGrid)
  if not DragGrid then
    return false
  end
  local bSuccess = false
  local MoveInfo = self:GetItemMoveData(DragGrid, nil, true)
  if MoveInfo and MoveInfo.bCanMove then
    bSuccess = self:ApplyItemMoveData(MoveInfo)
  else
    for _, PocketData in ipairs(MoveInfo.EndInfo.CandidatePockets) do
      bSuccess = self:TryArrangePocketAndPutItem(PocketData.Pocket, MoveInfo.StartInfo.DragItem)
      if bSuccess then
        break
      end
    end
  end
  if bSuccess then
    EventManager:FireEvent(EventID.OnTreasureItemDrop, MoveInfo)
  else
    UIManager(self):ShowUITip("CommonToastMain", GText(InventoryCommonConst.DropFailedToastText), 2)
  end
  return bSuccess
end

function InventoryController:NotifyDragUp(TargetDragWidget)
  if not TargetDragWidget then
    return
  end
  local TargetTreasureItem = TargetDragWidget.TreasureItem
  if not TargetTreasureItem then
    return
  end
  local UpdateParams = {bDrag = true}
  TargetTreasureItem:UpdateView(UpdateParams)
end

function InventoryController:NotifyDragOverGrids(DragGrid, DragOverWidget)
  local MoveInfo = self:GetItemMoveData(DragGrid, DragOverWidget)
  self.NewTargetGrids = {}
  local TargetDirection
  if MoveInfo.EndInfo.Type == "Grid" then
    if MoveInfo.EndInfo.TopLeft and MoveInfo.EndInfo.ValidTopLeftList[1] then
      local TopLeft = MoveInfo.EndInfo.TopLeft
      local Width, Height = self:GetWHByDir(MoveInfo.StartInfo.DragItem.Size, MoveInfo.EndInfo.Direction)
      self.NewTargetGrids = self:GetTargetGrids(MoveInfo.EndInfo.PocketData, TopLeft, Width, Height)
      TargetDirection = MoveInfo.EndInfo.Direction
    elseif MoveInfo.EndInfo.AllInvalidResults[1] then
      local MaxTargetGrids = {}
      for _, InvalidTopLeftInfo in ipairs(MoveInfo.EndInfo.AllInvalidResults) do
        local Width, Height = self:GetWHByDir(MoveInfo.StartInfo.DragItem.Size, InvalidTopLeftInfo[1])
        local TargetGrids = self:GetTargetGrids(MoveInfo.EndInfo.PocketData, InvalidTopLeftInfo[2], Width, Height)
        if #TargetGrids > #MaxTargetGrids then
          MaxTargetGrids = TargetGrids
          TargetDirection = InvalidTopLeftInfo[1]
        end
      end
      for _, Grid in ipairs(MaxTargetGrids) do
        table.insert(self.NewTargetGrids, Grid)
      end
    end
  end
  if TargetDirection then
    local DefaultDragVisual = MoveInfo.StartInfo.DragItem and MoveInfo.StartInfo.DragItem.DefaultDragVisual
    local bSquare = MoveInfo.StartInfo.DragItem and MoveInfo.StartInfo.DragItem.Size.X == MoveInfo.StartInfo.DragItem.Size.Y
    if DefaultDragVisual and not bSquare then
      if TargetDirection == InventoryCommonConst.Direction.Vertical then
        DefaultDragVisual:SetRenderTransformAngle(90)
      elseif TargetDirection == InventoryCommonConst.Direction.Horizontal then
        DefaultDragVisual:SetRenderTransformAngle(0)
      end
    end
  end
  local UpdateParams = {
    bCanMove = MoveInfo.bCanMove,
    bReset = false
  }
  for _, Grid in ipairs(self.NewTargetGrids) do
    Grid:UpdateView(UpdateParams)
    Grid.bUpdated = true
  end
  UpdateParams = {bCanMove = nil, bReset = true}
  for _, Grid in ipairs(self.LastTargetGrids) do
    if not Grid.bUpdated then
      Grid:UpdateView(UpdateParams)
    end
  end
  for _, Grid in ipairs(self.NewTargetGrids) do
    Grid.bUpdated = false
  end
  self.LastTargetGrids = self.NewTargetGrids
end

function InventoryController:TryDropAndSwitchItem(DragGrid, DropGrid)
  self:NotifyDragOverGrids(DragGrid, nil)
  local MoveInfo = self:GetItemMoveData(DragGrid, DropGrid)
  if not MoveInfo.bCanMove then
    return false
  end
  self:ApplyItemMoveData(MoveInfo)
  EventManager:FireEvent(EventID.OnTreasureItemDrop, MoveInfo)
  self.LastMoveInfo = MoveInfo
  return true
end

function InventoryController:NotifyCreateNewTreasureItem(TargetPocketWidget, TreasureContent)
  return TargetPocketWidget:CreateIconItem(TreasureContent.Size, TreasureContent.Texture, TreasureContent.Position, TreasureContent.Color)
end

AssembleComponents(InventoryController)
return InventoryController
