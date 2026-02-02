require("UnLua")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local Component = {}

function Component:GetItemMoveData(DragWidget, TargetDropWidget, bQuickTransfer)
  if not DragWidget or not DragWidget.TreasureItem then
    return {bCanMove = false}
  end
  local StartInfo = self:GenerateStartInfo(DragWidget)
  local EndInfo = self:GenerateEndInfo(StartInfo.DragItem or DragWidget.TreasureItem, TargetDropWidget, StartInfo, bQuickTransfer)
  local MoveInfo = {
    bCanMove = false,
    StartInfo = StartInfo,
    EndInfo = EndInfo
  }
  if EndInfo and EndInfo.Type == "Grid" and EndInfo.bCanPlace == true then
    MoveInfo.bCanMove = true
    return MoveInfo
  end
  return MoveInfo
end

function Component:GenerateStartInfo(DragWidget)
  if not DragWidget or not DragWidget.TreasureItem then
    return
  end
  if DragWidget.bGrid then
    local StartInfo = {
      Type = "Grid",
      DragGrid = DragWidget,
      DragItem = DragWidget.TreasureItem,
      PocketData = DragWidget.PocketData,
      TopLeft = DragWidget.TreasureItem.Position,
      Direction = DragWidget.TreasureItem.Direction
    }
    return StartInfo
  elseif DragWidget.bCycleBin then
    local StartInfo = {
      Type = "RecycleBin",
      DragWidget = DragWidget,
      DragItem = DragWidget.TreasureItem
    }
    return StartInfo
  end
  local StartInfo = {
    Type = "Error",
    DragWidget = DragWidget,
    DragItem = DragWidget.TreasureItem
  }
  return StartInfo
end

function Component:GenerateEndInfo(TreasureItem, TargetDropWidget, StartInfo, bQuickTransfer)
  if not TargetDropWidget and bQuickTransfer then
    return self:GenerateEndInfoAutoQuickTransfer(TreasureItem, StartInfo)
  end
  if TargetDropWidget and TargetDropWidget.bGrid then
    return self:GenerateEndInfoFromGrid(TreasureItem, TargetDropWidget)
  elseif TargetDropWidget and TargetDropWidget.bCycleBin then
    return self:GenerateEndInfoRecycle(TargetDropWidget)
  end
  return {Type = "Error", bCanPlace = false}
end

function Component:GenerateEndInfoFromGrid(TreasureItem, TargetDropWidget)
  local EndInfo = {
    Type = "Grid",
    DropGrid = TargetDropWidget,
    DropItem = TargetDropWidget.TreasureItem,
    PocketData = TargetDropWidget.PocketData
  }
  local Dir = TreasureItem.Direction
  local Width, Height = self:GetWHByDir(TreasureItem.Size, Dir)
  local Center = TargetDropWidget.Position
  local TopLeftList = self:ComputeTopLeftFromCenter(TreasureItem, TargetDropWidget.PocketData.Pocket, Center, Width, Height)
  local AltDir = Dir == InventoryCommonConst.Direction.Horizontal and InventoryCommonConst.Direction.Vertical or InventoryCommonConst.Direction.Horizontal
  local AltWidth, AltHeight = self:GetWHByDir(TreasureItem.Size, AltDir)
  local AltTopLeftList = self:ComputeTopLeftFromCenter(TreasureItem, TargetDropWidget.PocketData.Pocket, Center, AltWidth, AltHeight)
  local AllValid = {}
  for _, TL in ipairs(TopLeftList.ValidResults) do
    table.insert(AllValid, {
      TopLeft = TL,
      Direction = Dir,
      W = Width,
      H = Height
    })
  end
  for _, ATL in ipairs(AltTopLeftList.ValidResults) do
    table.insert(AllValid, {
      TopLeft = ATL,
      Direction = AltDir,
      W = AltWidth,
      H = AltHeight
    })
  end
  if #AllValid > 0 then
    local PocketGrids = self.InventoryModel.Grids[TargetDropWidget.PocketData.Name]
    
    local function IsEmptyAt(x, y)
      local col = PocketGrids and PocketGrids[x]
      local GridData = col and col[y]
      local Grid = GridData and GridData.Grid
      return nil ~= Grid and (nil == Grid.TreasureItem or Grid.TreasureItem == TreasureItem)
    end
    
    local SX = TargetDropWidget.Position.X
    local SY = TargetDropWidget.Position.Y
    local PreferredDir
    if IsEmptyAt(SX, SY) then
      local northEmpty = IsEmptyAt(SX, SY - 1)
      local southEmpty = IsEmptyAt(SX, SY + 1)
      local westEmpty = IsEmptyAt(SX - 1, SY)
      local eastEmpty = IsEmptyAt(SX + 1, SY)
      local edgeHorizontal = not northEmpty or not southEmpty
      local edgeVertical = not westEmpty or not eastEmpty
      if edgeHorizontal and edgeVertical then
        local q = TargetDropWidget._Quadrant
        if not northEmpty and not westEmpty then
          if 3 == q then
            PreferredDir = InventoryCommonConst.Direction.Vertical
          elseif 1 == q then
            PreferredDir = InventoryCommonConst.Direction.Horizontal
          else
            PreferredDir = Dir
          end
        elseif not northEmpty and not eastEmpty then
          if 2 == q then
            PreferredDir = InventoryCommonConst.Direction.Horizontal
          elseif 4 == q then
            PreferredDir = InventoryCommonConst.Direction.Vertical
          else
            PreferredDir = Dir
          end
        elseif not southEmpty and not westEmpty then
          if 2 == q then
            PreferredDir = InventoryCommonConst.Direction.Vertical
          elseif 4 == q then
            PreferredDir = InventoryCommonConst.Direction.Horizontal
          else
            PreferredDir = Dir
          end
        elseif not southEmpty and not eastEmpty then
          if 1 == q then
            PreferredDir = InventoryCommonConst.Direction.Vertical
          elseif 3 == q then
            PreferredDir = InventoryCommonConst.Direction.Horizontal
          else
            PreferredDir = Dir
          end
        else
          PreferredDir = Dir
        end
      elseif edgeHorizontal then
        PreferredDir = InventoryCommonConst.Direction.Horizontal
      elseif edgeVertical then
        PreferredDir = InventoryCommonConst.Direction.Vertical
      end
    end
    local Best
    if PreferredDir then
      for _, C in ipairs(AllValid) do
        if C.Direction == PreferredDir then
          Best = C
          break
        end
      end
    end
    if not Best then
      for _, C in ipairs(AllValid) do
        if C.Direction == Dir then
          Best = C
          break
        end
      end
    end
    Best = Best or AllValid[1]
    EndInfo.ValidTopLeftList = {}
    for _, C in ipairs(AllValid) do
      table.insert(EndInfo.ValidTopLeftList, C.TopLeft)
    end
    EndInfo.InvalidTopLeftList = {}
    for _, InvalidResult in ipairs(TopLeftList.InvalidResults) do
      table.insert(EndInfo.InvalidTopLeftList, InvalidResult)
    end
    for _, AltInvalidResult in ipairs(AltTopLeftList.InvalidResults) do
      table.insert(EndInfo.InvalidTopLeftList, AltInvalidResult)
    end
    EndInfo.TopLeft = Best.TopLeft
    EndInfo.Direction = Best.Direction
    EndInfo.bCanPlace = true
  else
    local AllInvalidResults = {}
    for _, InvalidTopLeft in ipairs(TopLeftList.InvalidResults) do
      table.insert(AllInvalidResults, {Dir, InvalidTopLeft})
    end
    for _, AltInvalidTopLeft in ipairs(AltTopLeftList.InvalidResults) do
      table.insert(AllInvalidResults, {AltDir, AltInvalidTopLeft})
    end
    EndInfo.ValidTopLeftList = {}
    EndInfo.AllInvalidResults = AllInvalidResults
    EndInfo.InvalidTopLeft = AllInvalidResults[1]
    EndInfo.TopLeft = nil
    EndInfo.bCanPlace = false
  end
  return EndInfo
end

function Component:GenerateEndInfoRecycle(TargetDropWidget)
  return {
    Type = "RecycleBin",
    DropWidget = TargetDropWidget,
    bCanPlace = false
  }
end

function Component:GetTargetTypePocketDatas(TargetType)
  local Ret = {}
  for _, PocketName in pairs(self.AllPockets or {}) do
    if type(PocketName) == "table" then
      PocketName = PocketName[2]
    end
    local PocketData = self.InventoryModel.Pockets[PocketName]
    local Pocket = PocketData and PocketData.Pocket
    if Pocket and IsValid(Pocket) then
      local T = Pocket.Inventory
      if T == TargetType then
        table.insert(Ret, PocketData)
      end
    end
  end
  return Ret
end

function Component:GetPocketBounds(PocketWidget)
  local GridDatas = self.InventoryModel.Grids[PocketWidget.Name]
  if not GridDatas then
    return nil
  end
  local MinX, MaxX, MinY, MaxY = math.huge, -math.huge, math.huge, -math.huge
  for X, Col in pairs(GridDatas) do
    if type(X) == "number" then
      if X < MinX then
        MinX = X
      end
      if X > MaxX then
        MaxX = X
      end
      for Y, GridData in pairs(Col) do
        if type(Y) == "number" then
          if Y < MinY then
            MinY = Y
          end
          if Y > MaxY then
            MaxY = Y
          end
        end
      end
    end
  end
  if MinX == math.huge then
    return nil
  end
  local Start = FVector2D(MinX, MinY)
  local W = MaxX - MinX + 1
  local H = MaxY - MinY + 1
  return Start, W, H
end

function Component:GenerateEndInfoAutoQuickTransfer(TreasureItem, StartInfo)
  if not (TreasureItem and StartInfo and StartInfo.PocketData) or not StartInfo.PocketData.Pocket then
    return {Type = "Error", bCanPlace = false}
  end
  local SourcePocket = StartInfo.PocketData.Pocket
  local SourceType = SourcePocket.Inventory
  local TargetType = SourceType == InventoryCommonConst.PocketType.Container and InventoryCommonConst.PocketType.Bag or InventoryCommonConst.PocketType.Container
  local Candidates = self:GetTargetTypePocketDatas(TargetType)
  for _, PocketData in ipairs(Candidates) do
    local StartItemWidth, StartItemHeight = self:GetWHByDir(StartInfo.DragItem.Size, StartInfo.Direction)
    local ValidInfo = self:GetValidTopLeftByTreasureId(PocketData.Pocket, TreasureItem.TreasureId, StartInfo.Direction)
    if ValidInfo and ValidInfo.TopLeft then
      return {
        Type = "Grid",
        PocketData = PocketData,
        TopLeft = ValidInfo.TopLeft,
        Direction = ValidInfo.Direction,
        bCanPlace = true
      }
    end
  end
  return {
    Type = "Grid",
    bCanPlace = false,
    CandidatePockets = Candidates
  }
end

function Component:CollectPocketItems(PocketWidget)
  if not PocketWidget or not IsValid(PocketWidget) then
    return {}
  end
  local Items = {}
  local Set = {}
  local GridDatas = self.InventoryModel.Grids[PocketWidget.Name]
  for X, Col in pairs(GridDatas or {}) do
    if type(X) == "number" then
      for Y, GD in pairs(Col or {}) do
        if type(Y) == "number" then
          local Grid = GD and GD.Grid
          local TI = Grid and Grid.TreasureItem
          if TI and not Set[TI] then
            Set[TI] = true
            table.insert(Items, TI)
          end
        end
      end
    end
  end
  return Items
end

function Component:TryArrangePocketAndPutItem(PocketWidget, TargetItem)
  if not PocketWidget or not TargetItem then
    return false
  end
  local SimResult = self:SimulateArrangePocketForNewItem(PocketWidget, TargetItem)
  if not SimResult or not SimResult.bCanPlace then
    return false
  end
  for _, Arr in ipairs(SimResult.Arrangements or {}) do
    local MoveDataArr = {
      StartInfo = {
        Type = "Grid",
        DragItem = Arr.Item,
        PocketData = PocketWidget.Data,
        TopLeft = Arr.Item.Position,
        Direction = Arr.Item.Direction
      },
      EndInfo = {
        Type = "Grid",
        PocketData = PocketWidget.Data,
        TopLeft = Arr.TopLeft,
        Direction = Arr.Direction,
        bCanPlace = true
      },
      bCanMove = true
    }
    if not self:PutUpStartInfoItem(MoveDataArr) then
      return false
    end
    if not self:PutDownStartInfoItemToEnd(MoveDataArr) then
      return false
    end
  end
  local EndInfo = {
    Type = "Grid",
    PocketData = PocketWidget.Data,
    TopLeft = SimResult.TopLeft,
    Direction = SimResult.Direction,
    bCanPlace = true
  }
  local StartInfo = {
    Type = "Grid",
    DragItem = TargetItem,
    PocketData = TargetItem.Pocket and TargetItem.Pocket.Data or nil,
    TopLeft = TargetItem.Position,
    Direction = TargetItem.Direction
  }
  local MoveData = {
    StartInfo = StartInfo,
    EndInfo = EndInfo,
    bCanMove = true
  }
  return self:ApplyItemMoveData(MoveData)
end

function Component:SimulateArrangePocketForNewItem(PocketWidget, TargetItem)
  if not (PocketWidget and IsValid(PocketWidget)) or not TargetItem then
    return nil
  end
  local Start, W, H = self:GetPocketBounds(PocketWidget)
  if not Start then
    return {bCanPlace = false}
  end
  local GridMap = {}
  for X = 0, W - 1 do
    GridMap[X] = {}
    for Y = 0, H - 1 do
      GridMap[X][Y] = false
    end
  end
  
  local function CanPlaceRect(LocalX, LocalY, RWidth, RHeight)
    if LocalX < 0 or LocalY < 0 then
      return false
    end
    if LocalX + RWidth > W or LocalY + RHeight > H then
      return false
    end
    for DX = 0, RWidth - 1 do
      local Col = GridMap[LocalX + DX]
      for DY = 0, RHeight - 1 do
        if Col[LocalY + DY] then
          return false
        end
      end
    end
    return true
  end
  
  local function MarkRectOccupied(LocalX, LocalY, RWidth, RHeight, Val)
    for DX = 0, RWidth - 1 do
      local Col = GridMap[LocalX + DX]
      for DY = 0, RHeight - 1 do
        Col[LocalY + DY] = Val
      end
    end
  end
  
  local function FindFirstFitFor(Size, Dir)
    local RWidth, RHeight = self:GetWHByDir(Size, Dir)
    for Y = 0, H - 1 do
      for X = W - 1, 0, -1 do
        if CanPlaceRect(X, Y, RWidth, RHeight) then
          return {
            FVector2D(Start.X + X, Start.Y + Y),
            Dir,
            RWidth,
            RHeight
          }
        end
      end
    end
    return nil
  end
  
  local Items = self:CollectPocketItems(PocketWidget)
  table.sort(Items, function(A, B)
    local Aw, Ah = self:GetWHByDir(A.Size, A.Direction)
    local Bw, Bh = self:GetWHByDir(B.Size, B.Direction)
    if Aw ~= Bw then
      return Aw > Bw
    end
    if Ah ~= Bh then
      return Ah > Bh
    end
    return Aw * Ah > Bw * Bh
  end)
  local Arrangements = {}
  for _, Item in ipairs(Items) do
    local FitResult1 = FindFirstFitFor(Item.Size, Item.Direction)
    local FitResult2 = FindFirstFitFor(Item.Size, Item.Direction == InventoryCommonConst.Direction.Horizontal and InventoryCommonConst.Direction.Vertical or InventoryCommonConst.Direction.Horizontal)
    local FitResult = (FitResult1 and FitResult1[1].X or -1) >= (FitResult2 and FitResult2[1].X or -1) and FitResult1 or FitResult2
    if not FitResult then
      return {bCanPlace = false}
    end
    local TopLeft, Dir, RWidth, RHeight = FitResult[1], FitResult[2], FitResult[3], FitResult[4]
    local LocalX = TopLeft.X - Start.X
    local LocalY = TopLeft.Y - Start.Y
    MarkRectOccupied(LocalX, LocalY, RWidth, RHeight, true)
    table.insert(Arrangements, {
      Item = Item,
      TopLeft = TopLeft,
      Direction = Dir
    })
  end
  local FitResultT1 = FindFirstFitFor(TargetItem.Size, TargetItem.Direction)
  local TargetAltDir = TargetItem.Direction == InventoryCommonConst.Direction.Horizontal and InventoryCommonConst.Direction.Vertical or InventoryCommonConst.Direction.Horizontal
  local FitResultT2 = FindFirstFitFor(TargetItem.Size, TargetAltDir)
  local FitResultT = (FitResultT1 and FitResultT1[1].X or -1) > (FitResultT2 and FitResultT2[1].X or -1) and FitResultT1 or FitResultT2
  if FitResultT1 and FitResultT2 and FitResultT1[1].X == FitResultT2[1].X then
    FitResultT = FitResultT1[1].Y <= FitResultT2[1].Y and FitResultT1 or FitResultT2
  end
  if not FitResultT then
    return {bCanPlace = false}
  end
  return {
    bCanPlace = true,
    TopLeft = FitResultT[1],
    Direction = FitResultT[2],
    Arrangements = Arrangements
  }
end

function Component:ApplyItemMoveData(MoveData)
  if not MoveData or MoveData.bCanMove == false then
    return false
  end
  if not self:PutUpStartInfoItem(MoveData) then
    DebugPrint("lgc@ItemMoveComponent ApplyItemMoveData PutUpStartInfoItem failed")
    return false
  end
  if not self:PutUpEndInfoItems(MoveData) then
    DebugPrint("lgc@ItemMoveComponent ApplyItemMoveData PutUpEndInfoItems failed")
    return false
  end
  if not self:PutDownStartInfoItemToEnd(MoveData) then
    DebugPrint("lgc@ItemMoveComponent ApplyItemMoveData PutDownStartInfoItemToEnd failed")
    return false
  end
  if not self:PutDownEndInfoItemsToStart(MoveData) then
    DebugPrint("lgc@ItemMoveComponent ApplyItemMoveData PutDownEndInfoItemsToStart failed")
    return false
  end
  DebugPrint("lgc@ItemMoveComponent ApplyItemMoveData success")
  return true
end

function Component:PutUpStartInfoItem(MoveData)
  if not MoveData or not MoveData.StartInfo then
    return false
  end
  local StartInfo = MoveData.StartInfo
  if StartInfo.Type == "Grid" then
    local Item = StartInfo.DragItem
    local PocketData = StartInfo.PocketData
    if not Item or not PocketData then
      return false
    end
    local Dir = Item.Direction
    local Width, Height = self:GetWHByDir(Item.Size, Dir)
    local TopLeft = StartInfo.TopLeft
    local Grids = self:GetTargetGrids(PocketData.Pocket, TopLeft, Width, Height)
    for _, Grid in ipairs(Grids) do
      Grid.TreasureItem = nil
    end
    return true
  elseif StartInfo.Type == "SystemGenerate" then
    return true
  end
  return false
end

function Component:PutUpEndInfoItems(MoveData)
  if not MoveData or not MoveData.EndInfo then
    return false
  end
  local EndInfo = MoveData.EndInfo
  if EndInfo.Type == "Grid" and EndInfo.bCanPlace == true then
    local PocketData = EndInfo.PocketData
    local TopLeft = EndInfo.TopLeft
    local Dir = EndInfo.Direction
    local Size = MoveData.StartInfo and MoveData.StartInfo.DragItem and MoveData.StartInfo.DragItem.Size or nil
    if not (PocketData and TopLeft and Dir) or not Size then
      return false
    end
    local Width, Height = self:GetWHByDir(Size, Dir)
    local OverlappedTreasureItems = {}
    local OverlappedSet = {}
    local Grids = self:GetTargetGrids(PocketData.Pocket, TopLeft, Width, Height)
    for _, Grid in ipairs(Grids) do
      local TreasureItem = Grid and Grid.TreasureItem
      if TreasureItem and not OverlappedSet[TreasureItem] then
        OverlappedSet[TreasureItem] = true
        table.insert(OverlappedTreasureItems, TreasureItem)
      end
      Grid.TreasureItem = nil
    end
    EndInfo.OverlappedTreasureItems = OverlappedTreasureItems
    return true
  end
  return false
end

function Component:PutDownStartInfoItemToEnd(MoveData)
  if not (MoveData and MoveData.StartInfo) or not MoveData.EndInfo then
    return false
  end
  local StartInfo = MoveData.StartInfo
  local EndInfo = MoveData.EndInfo
  if EndInfo.Type == "Grid" and EndInfo.bCanPlace == true then
    local Item = StartInfo.DragItem
    local PocketData = EndInfo.PocketData
    local TopLeft = EndInfo.TopLeft
    local Dir = EndInfo.Direction
    if not (Item and PocketData and TopLeft) or not Dir then
      return false
    end
    local Width, Height = self:GetWHByDir(Item.Size, Dir)
    local Grids = self:GetTargetGrids(PocketData.Pocket, TopLeft, Width, Height)
    for _, Grid in ipairs(Grids) do
      Grid.TreasureItem = Item
    end
    Item:UpdateView({
      NewPocketData = PocketData,
      NewPosition = TopLeft,
      NewDirection = Dir
    })
    return true
  end
  return false
end

function Component:PutDownEndInfoItemsToStart(MoveData)
  if not MoveData or not MoveData.EndInfo then
    return false
  end
  local EndInfo = MoveData.EndInfo
  local StartInfo = MoveData.StartInfo
  if EndInfo.Type == "Grid" and StartInfo and StartInfo.Type == "Grid" and EndInfo.OverlappedTreasureItems then
    local TargetPocketData = StartInfo.PocketData
    local Delta = FVector2D(EndInfo.TopLeft.X - StartInfo.TopLeft.X, EndInfo.TopLeft.Y - StartInfo.TopLeft.Y)
    local bSwitchDirection = EndInfo.Direction and StartInfo.Direction and EndInfo.Direction ~= StartInfo.Direction
    local SecondTryPutDownItems = {}
    for _, TreasureItem in ipairs(EndInfo.OverlappedTreasureItems) do
      local NewDir = TreasureItem.Direction
      if bSwitchDirection then
        if TreasureItem.Direction == InventoryCommonConst.Direction.Horizontal then
          NewDir = InventoryCommonConst.Direction.Vertical
        else
          NewDir = InventoryCommonConst.Direction.Horizontal
        end
        local RotationPositionX = TreasureItem.Position.Y - EndInfo.TopLeft.Y + EndInfo.TopLeft.X
        local RotationPositionY = TreasureItem.Position.X - EndInfo.TopLeft.X + EndInfo.TopLeft.Y
        TreasureItem.Position = FVector2D(RotationPositionX, RotationPositionY)
      end
      local IWidth, IHeight = self:GetWHByDir(TreasureItem.Size, NewDir)
      local NewTopLeft = FVector2D(TreasureItem.Position.X - Delta.X, TreasureItem.Position.Y - Delta.Y)
      local Valid = self:RectValidFunc(TreasureItem, TargetPocketData.Pocket, NewTopLeft, IWidth, IHeight, false) or false
      if Valid then
        local Grids = self:GetTargetGrids(TargetPocketData.Pocket, NewTopLeft, IWidth, IHeight)
        for _, Grid in ipairs(Grids) do
          Grid.TreasureItem = TreasureItem
        end
        TreasureItem:UpdateView({
          NewPocketData = TargetPocketData,
          NewPosition = NewTopLeft,
          NewDirection = NewDir
        })
      else
        table.insert(SecondTryPutDownItems, TreasureItem)
      end
    end
    for _, TreasureItem in ipairs(SecondTryPutDownItems) do
      local StartItemWidth, StartItemHeight = self:GetWHByDir(StartInfo.DragItem.Size, StartInfo.Direction)
      local ValidInfo = self:GetValidTopLeftInRectByTreasureItem(TreasureItem, TargetPocketData.Pocket, StartInfo.TopLeft, StartItemWidth, StartItemHeight, true)
      if ValidInfo then
        local TargetWidth, TargetHeight = self:GetWHByDir(TreasureItem.Size, ValidInfo.Direction)
        local Grids = self:GetTargetGrids(TargetPocketData.Pocket, ValidInfo.TopLeft, TargetWidth, TargetHeight)
        for _, Grid in ipairs(Grids) do
          Grid.TreasureItem = TreasureItem
        end
        TreasureItem:UpdateView({
          NewPocketData = TargetPocketData,
          NewPosition = ValidInfo.TopLeft,
          NewDirection = ValidInfo.Direction
        })
      else
        DebugPrint("lgc@PutDownEndInfoItemsToStart: GetValidTopLeftInRectByTreasureItem failed")
      end
    end
    return true
  elseif StartInfo.Type == "SystemGenerate" then
    return true
  end
  return false
end

function Component:GetValidTopLeftInRectByTreasureItem(TreasureItem, TargetPocketWidget, StartTopLeft, Width, Height, bCheckOverlap)
  if not (TreasureItem and TargetPocketWidget and StartTopLeft and Width) or not Height then
    return nil
  end
  local Dir = TreasureItem.Direction
  local TW, TH = self:GetWHByDir(TreasureItem.Size, Dir)
  for Y = StartTopLeft.Y, StartTopLeft.Y + Height - 1 do
    for X = StartTopLeft.X, StartTopLeft.X + Width - 1 do
      local TopLeft = FVector2D(X, Y)
      local Valid = self:RectValidFunc(TreasureItem, TargetPocketWidget, TopLeft, TW, TH, bCheckOverlap) or false
      if Valid then
        return {
          TopLeft = TopLeft,
          Direction = Dir,
          bSwitchDirection = false
        }
      end
    end
  end
  local AltDir = Dir == InventoryCommonConst.Direction.Horizontal and InventoryCommonConst.Direction.Vertical or InventoryCommonConst.Direction.Horizontal
  local AW, AH = self:GetWHByDir(TreasureItem.Size, AltDir)
  for Y = StartTopLeft.Y, StartTopLeft.Y + Height - 1 do
    for X = StartTopLeft.X, StartTopLeft.X + Width - 1 do
      local TopLeft = FVector2D(X, Y)
      local Valid = self:RectValidFunc(TreasureItem, TargetPocketWidget, TopLeft, AW, AH, bCheckOverlap) or false
      if Valid then
        return {
          TopLeft = TopLeft,
          Direction = AltDir,
          bSwitchDirection = true
        }
      end
    end
  end
  return nil
end

function Component:CreateNewTreasureItemToPocket(TargetPocketWidget, TreasureId, Position, bNotSearched)
  if not TargetPocketWidget or not Position then
    return false
  end
  local TreasureData = DataMgr.ExtractionTreasure[TreasureId]
  if not TreasureData then
    return false
  end
  local Size = FVector2D(1, 1)
  local Shape = TreasureData.Shape
  for i, Pos in ipairs(Shape) do
    if 1 == i then
      Size.X = Pos
    elseif 2 == i then
      Size.Y = Pos
    end
  end
  local Dir = InventoryCommonConst.Direction.Horizontal
  local Width, Height = self:GetWHByDir(Size, Dir)
  local Grids = self:GetTargetGrids(TargetPocketWidget, Position, Width, Height)
  local Overlapped = {}
  local OverlappedSet = {}
  for _, Grid in ipairs(Grids) do
    local TI = Grid and Grid.TreasureItem
    if TI and not OverlappedSet[TI] then
      OverlappedSet[TI] = true
      table.insert(Overlapped, TI)
    end
  end
  local bRectValid = self:RectValidFunc(nil, TargetPocketWidget, Position, Width, Height, false) or false
  local bCanPlace = bRectValid and 0 == #Overlapped
  if not bCanPlace then
    UIManager(self):ShowUITip("CommonToastMain", GText(InventoryCommonConst.DropFailedToastText), 2)
    return false
  end
  local Texture = TreasureData.Icon and LoadObject(TreasureData.Icon) or LoadObject("/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Coin_Other_Mod.T_Coin_Other_Mod")
  local TreasureContent = {
    TreasureId = TreasureId,
    Size = Size,
    Icon = TreasureData.Icon,
    Texture = Texture,
    Pocket = TargetPocketWidget,
    Position = Position,
    TreasureRarity = TreasureData.TreasureRarity,
    Direction = Dir,
    bNotSearched = bNotSearched
  }
  local TreasureWidget = self:NotifyCreateNewTreasureItem(TargetPocketWidget, TreasureContent)
  TreasureWidget:Init(TreasureContent)
  local MoveData = {
    bCanMove = true,
    StartInfo = {
      Type = "SystemGenerate",
      DragItem = TreasureWidget,
      PocketData = nil,
      TopLeft = nil,
      Direction = Dir
    },
    EndInfo = {
      Type = "Grid",
      PocketData = TargetPocketWidget.Data,
      TopLeft = Position,
      Direction = Dir,
      bCanPlace = true
    }
  }
  if self:ApplyItemMoveData(MoveData) then
    return TreasureWidget
  end
  return false
end

function Component:DebugPrintInventoryInfo()
  if not UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(GWorld.GameInstance) then
    return
  end
  local Lines = {}
  local OrderNames = {
    "WBP_Type01_Bag01",
    "WBP_Type01_Bag02",
    "WBP_Type01_Bag03",
    "WBP_Type01_Bag04",
    "WBP_Type02_Bag01",
    "WBP_Type02_Bag02",
    "WBP_Type02_Bag03",
    "WBP_Search_Bag"
  }
  local NameToOrder = {}
  for I, N in ipairs(OrderNames) do
    NameToOrder[N] = I
  end
  local PocketInfos = {}
  for Pocket, Cols in pairs(self.InventoryModel.Grids or {}) do
    local PName
    local Ok, Ret = pcall(function()
      return Pocket and Pocket:GetName()
    end)
    if Ok and Ret then
      PName = Ret
    else
      PName = tostring(Pocket)
    end
    local Index = NameToOrder[PName] or 1000
    table.insert(PocketInfos, {
      Pocket = Pocket,
      Name = PName,
      Index = Index
    })
  end
  table.sort(PocketInfos, function(A, B)
    if A.Index ~= B.Index then
      return A.Index < B.Index
    end
    return tostring(A.Name) < tostring(B.Name)
  end)
  for _, PI in ipairs(PocketInfos) do
    local Pocket = PI.Pocket
    local Grids = self.InventoryModel.Grids[Pocket]
    local MinX, MaxX, MinY, MaxY = math.huge, -math.huge, math.huge, -math.huge
    for X, Col in pairs(Grids or {}) do
      if type(X) == "number" then
        if X < MinX then
          MinX = X
        end
        if X > MaxX then
          MaxX = X
        end
        for Y, _ in pairs(Col or {}) do
          if type(Y) == "number" then
            if Y < MinY then
              MinY = Y
            end
            if Y > MaxY then
              MaxY = Y
            end
          end
        end
      end
    end
    if MinX == math.huge then
      MinX, MaxX, MinY, MaxY = 1, 1, 1, 1
    end
    local ItemLabel = {}
    local LabelList = {}
    
    local function NextLabel(I)
      if I <= 26 then
        return string.char(64 + I)
      end
      return tostring(I)
    end
    
    table.insert(Lines, string.format("Pocket: %s", PI.Name or "Unknown"))
    local XHead = "    "
    for X = MinX, MaxX do
      XHead = XHead .. string.format("%02d ", X)
    end
    table.insert(Lines, XHead)
    for Y = MinY, MaxY do
      local Row = string.format("%02d: ", Y)
      for X = MinX, MaxX do
        local Cell = "."
        local Grid = Grids and Grids[X] and Grids[X][Y]
        local TargetTreasureItem = Grid and Grid.TreasureItem or nil
        if TargetTreasureItem then
          local Lable = ItemLabel[TargetTreasureItem]
          if not Lable then
            Lable = NextLabel(#LabelList + 1)
            ItemLabel[TargetTreasureItem] = Lable
            table.insert(LabelList, TargetTreasureItem)
          end
          Cell = Lable
        end
        Row = Row .. string.format(" %s ", Cell)
      end
      table.insert(Lines, Row)
    end
    if #LabelList > 0 then
      table.insert(Lines, "Items:")
      for I, TreasureItem in ipairs(LabelList) do
        local Dir = TreasureItem.Direction == InventoryCommonConst.Direction.Vertical and "Vertical" or "Height"
        local Width, Height = self:GetWHByDir(TreasureItem.Size, TreasureItem.Direction)
        local TopLeft = TreasureItem.Position
        table.insert(Lines, string.format("  %s -> Id:%s Size:%dx%d Cells:%d TopLeft:(%d,%d) Dir:%s", ItemLabel[TreasureItem] or "?", tostring(TreasureItem.TreasureId or "?"), Width, Height, Width * Height, TopLeft and TopLeft.X or -1, TopLeft and TopLeft.Y or -1, Dir))
      end
    end
    table.insert(Lines, " ")
  end
  if 0 == #PocketInfos then
    table.insert(Lines, "No pocket data.")
  end
  local Prefix = "lgc@InventoryController"
  for _, L in ipairs(Lines) do
    local Msg = Prefix .. " " .. L
    if DebugPrint then
      DebugPrint(Msg)
    else
      print(Msg)
    end
  end
end

function Component:GetWHByDir(Size, Dir)
  if Dir == InventoryCommonConst.Direction.Horizontal then
    return Size.X, Size.Y
  elseif Dir == InventoryCommonConst.Direction.Vertical then
    return Size.Y, Size.X
  else
    return Size.X, Size.Y
  end
end

function Component:ComputeTopLeftFromCenter(TreasureItem, Pocket, Center, Width, Height)
  local TopLeftX = Center.X - (Width - 1) / 2
  local TopLeftY = Center.Y - (Height - 1) / 2
  local TopLeftXList = {TopLeftX}
  local TopLeftYList = {TopLeftY}
  if 0 == Width % 2 then
    table.insert(TopLeftXList, TopLeftX + 1)
  end
  if 0 == Height % 2 then
    table.insert(TopLeftYList, TopLeftY + 1)
  end
  local Result = {
    ValidResults = {},
    InvalidResults = {}
  }
  for _, x in ipairs(TopLeftXList) do
    for _, y in ipairs(TopLeftYList) do
      if x % 1 == 0.5 then
        x = x - 0.5
      end
      if y % 1 == 0.5 then
        y = y - 0.5
      end
      local IsValid = self:RectValidFunc(TreasureItem, Pocket, FVector2D(x, y), Width, Height, true) or false
      if IsValid then
        table.insert(Result.ValidResults, FVector2D(x, y))
      else
        table.insert(Result.InvalidResults, FVector2D(x, y))
      end
    end
  end
  return Result
end

function Component:RectValidFunc(DragTreasureItem, Pocket, TopLeft, Width, Height, bCheckOverlap)
  if not TopLeft or not Pocket then
    return false
  end
  local GridDatas = self.InventoryModel.Grids[Pocket.Name]
  if not GridDatas then
    return false
  end
  local MinX = TopLeft.X
  local MinY = TopLeft.Y
  local MaxX = TopLeft.X + Width - 1
  local MaxY = TopLeft.Y + Height - 1
  for X = MinX, MaxX do
    local Col = GridDatas[X]
    if not Col then
      return false
    end
    for Y = MinY, MaxY do
      local GridData = Col[Y]
      if not GridData then
        return false
      end
      local Grid = GridData and GridData.Grid
      if not Grid then
        return false
      end
    end
  end
  local OverlappedSet = {}
  local Grids = self:GetTargetGrids(Pocket, TopLeft, Width, Height)
  for _, Grid in ipairs(Grids) do
    if bCheckOverlap then
      local TargetTreasureItem = Grid and Grid.TreasureItem
      if TargetTreasureItem and not OverlappedSet[TargetTreasureItem] and DragTreasureItem ~= TargetTreasureItem then
        OverlappedSet[TargetTreasureItem] = true
        local IWidth, IHeight = self:GetWHByDir(TargetTreasureItem.Size, TargetTreasureItem.Direction)
        local ITopLeft = TargetTreasureItem.Position
        local IMinX = ITopLeft.X
        local IMinY = ITopLeft.Y
        local IMaxX = ITopLeft.X + IWidth - 1
        local IMaxY = ITopLeft.Y + IHeight - 1
        if not (MinX <= IMinX and MinY <= IMinY and MaxX >= IMaxX) or not (MaxY >= IMaxY) then
          return false
        end
      end
    elseif Grid.TreasureItem then
      return false
    end
  end
  return true
end

function Component:GetTargetGrids(Pocket, TopLeft, Width, Height)
  if nil == TopLeft then
    DebugPrint("TopLeft is nil")
    return {}
  end
  local Grids = {}
  for X = TopLeft.X, TopLeft.X + Width - 1 do
    for Y = TopLeft.Y, TopLeft.Y + Height - 1 do
      local Grid
      if self.InventoryModel.Grids[Pocket.Name] and self.InventoryModel.Grids[Pocket.Name][X] and self.InventoryModel.Grids[Pocket.Name][X][Y] then
        Grid = self.InventoryModel.Grids[Pocket.Name][X][Y].Grid
      end
      if Grid then
        table.insert(Grids, Grid)
      end
    end
  end
  return Grids
end

function Component:GetValidTopLeftByTreasureId(TargetPocketWidget, TreasureId, PreferredDirection)
  if not TargetPocketWidget or not TreasureId then
    return nil
  end
  if not TargetPocketWidget or not IsValid(TargetPocketWidget) then
    return
  end
  local GridDatas = self.InventoryModel.Grids[TargetPocketWidget.Name]
  if not GridDatas then
    return
  end
  local MinX, MaxX, MinY, MaxY = math.huge, -math.huge, math.huge, -math.huge
  for X, Col in pairs(GridDatas) do
    if type(X) == "number" then
      if X < MinX then
        MinX = X
      end
      if X > MaxX then
        MaxX = X
      end
      for Y, GridData in pairs(Col) do
        if type(Y) == "number" then
          if Y < MinY then
            MinY = Y
          end
          if Y > MaxY then
            MaxY = Y
          end
        end
      end
    end
  end
  if MinX == math.huge then
    return
  end
  local StartTopLeft = FVector2D(MinX, MinY)
  local RegionWidth = MaxX - MinX + 1
  local RegionHeight = MaxY - MinY + 1
  local TreasureData = DataMgr and DataMgr.ExtractionTreasure and DataMgr.ExtractionTreasure[TreasureId]
  if not TreasureData or not TreasureData.Shape then
    return nil
  end
  local Size = FVector2D(1, 1)
  for i, Pos in ipairs(TreasureData.Shape) do
    if 1 == i then
      Size.X = Pos
    elseif 2 == i then
      Size.Y = Pos
    end
  end
  local Dir = PreferredDirection or InventoryCommonConst.Direction.Horizontal
  local TempTreasureItem = {Size = Size, Direction = Dir}
  local ValidInfo = self:GetValidTopLeftInRectByTreasureItem(TempTreasureItem, TargetPocketWidget, StartTopLeft, RegionWidth, RegionHeight, false)
  return ValidInfo
end

function Component:ClearPocket(PocketWidget)
  if not PocketWidget or not IsValid(PocketWidget) then
    return false
  end
  local Panel = PocketWidget.Panel_Item
  if Panel and IsValid(Panel) then
    local ChildrenArr
    local Ok, Ret = pcall(function()
      return Panel:GetAllChildren()
    end)
    if Ok and Ret then
      local T = Ret.ToTable and Ret:ToTable() or nil
      ChildrenArr = T
    end
    if ChildrenArr and type(ChildrenArr) == "table" then
      for _, Child in ipairs(ChildrenArr) do
        if Child and IsValid(Child) and Child.RemoveFromParent then
          Child:RemoveFromParent()
        end
      end
    elseif Panel.ClearChildren then
      Panel:ClearChildren()
    end
  end
  local GridDatas = self.InventoryModel and self.InventoryModel.Grids and self.InventoryModel.Grids[PocketWidget.Name]
  if GridDatas then
    for X, Col in pairs(GridDatas) do
      if type(X) == "number" and type(Col) == "table" then
        for Y, GridData in pairs(Col) do
          if type(Y) == "number" and GridData then
            GridData.Grid.TreasureItem = nil
          end
        end
      end
    end
  end
  return true
end

return Component
