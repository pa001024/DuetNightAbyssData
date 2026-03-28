local InventoryModel = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryModel")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local TimeUtils = require("Utils.TimeUtils")
local SoloTreasureUtils = require("Utils.SoloTreasureUtils")
local InventoryController = Class()
InventoryController._components = {
  "BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.ItemMoveComponent",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
InventoryController.bUseClientCalMovePos = true
InventoryController.bOpenClientPredict = false
InventoryController.bDraging = false
InventoryController._Adsorption = nil
InventoryController.ForceAdsorption = false
InventoryController.bForbidAdsorption = false
InventoryController._MouseIdleTime = 0
InventoryController._AdsorptionMoveDist = 0
InventoryController._AdsorptionZeroSizeTime = 0
InventoryController.bOpenItemDetails = false
InventoryController.bOpenRecycleSortDetail = false
InventoryController.bOpenSacrificePopup = false
InventoryController._SacrificePocketName = nil

function InventoryController:Init(Params)
  DebugPrint("lgc@InventoryController Init  bInit =", self.bInit)
  if not Params or not Params.bServerInit then
    if self.bInit then
      return
    end
  elseif self.bServerInit then
    return
  end
  self.InventoryModel = InventoryModel
  self.InventoryModel:Init(Params)
  local ServerEntity = GWorld:GetServerEntity()
  if not ServerEntity then
    return
  end
  self.Dungeonobject = ServerEntity:GetDungeonObject()
  if not self.Dungeonobject then
    return
  end
  self.bInit = true
  if Params.bServerInit then
    self.bServerInit = true
  end
  self:InitRecycleAndBagPocketDatas()
  self:InitEvents()
end

function InventoryController:InitRecycleAndBagPocketDatas()
  local BagInfo = DataMgr.ExtractionTreasureBag[self.InventoryModel.BagId]
  if BagInfo then
    local ShapeType = BagInfo.ShapeType and BagInfo.ShapeType + 1 or nil
    local Shape = BagInfo.Shape
    local TypeSuffix = ShapeType and string.format("%02d", ShapeType) or nil
    if TypeSuffix then
      local CurMap = {}
      local i = 1
      while Shape and Shape[i] do
        local BagSuffix = string.format("%02d", i)
        local PocketName = "WBP_Type" .. TypeSuffix .. "_Bag" .. BagSuffix
        CurMap[PocketName] = {
          Shape = Shape and Shape[i] or nil,
          SubBagIndex = i
        }
        i = i + 1
      end
      self.CurBagPocketNames = CurMap
    end
  end
  for PocketName, PocketShapeAndIndex in pairs(self.CurBagPocketNames) do
    local PocketData
    if not self.InventoryModel.Pockets[PocketName] then
      PocketData = {
        Name = PocketName,
        Size = FVector2D(PocketShapeAndIndex.Shape[1], PocketShapeAndIndex.Shape[2]),
        Parent = nil,
        Inventory = InventoryCommonConst.PocketType.Bag,
        SubBagIndex = PocketShapeAndIndex.SubBagIndex
      }
      self.InventoryModel.Pockets[PocketName] = PocketData
      self:InitGridsData(PocketData)
    end
  end
  self:UpdateRecyclePocketDatas()
end

function InventoryController:UpdateRecyclePocketDatas()
  local TargetEmpty = InventoryCommonConst.RecycleListEmptyNum
  local EmptyRecycleNames = {}
  for PocketName, PocketData in pairs(self.InventoryModel.Pockets) do
    if PocketData.bRecycle then
      local IsEmpty = false
      if not self.InventoryModel.TreasureItems[PocketName] or not next(self.InventoryModel.TreasureItems[PocketName]) then
        IsEmpty = true
      end
      if IsEmpty then
        table.insert(EmptyRecycleNames, PocketName)
      end
    end
  end
  local CurEmpty = #EmptyRecycleNames
  if TargetEmpty > CurEmpty then
    for i = 1, TargetEmpty - CurEmpty do
      self:AddEmptyRecyclePocketData()
    end
  elseif TargetEmpty < CurEmpty then
    for i = 1, CurEmpty - TargetEmpty do
      self:RemoveEmptyRecyclePocketData()
    end
  end
end

function InventoryController:OnMainWidgetLoaded(Params)
  DebugPrint("lgc@InventoryController OnMainWidgetLoaded  bInit =", self.bInit)
  self.MainWidget = Params.MainWidget
  self.LastTargetGridDatas = {}
  self.bDraging = false
  self._Adsorption = nil
  self.ForceAdsorption = false
  self.bForbidAdsorption = false
  self._MouseIdleTime = 0
  self._AdsorptionMoveDist = 0
  self._AdsorptionZeroSizeTime = 0
  self.bOpenItemDetails = false
  self.bOpenRecycleSortDetail = false
  self.bOpenSacrificePopup = false
  self._SacrificePocketName = nil
  self.SelectedItemWidget = nil
  self.SelectedGridWidget = nil
  if self.MainWidget.BagSelect_Controller then
    self.MainWidget.BagSelect_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self:InitBagPocketGridTreasureSection()
end

function InventoryController:InitBagPocketGridTreasureSection()
  if not self.MainWidget then
    return
  end
  if not self.InventoryModel.BagId then
    return
  end
  local BagInfo = DataMgr.ExtractionTreasureBag[self.InventoryModel.BagId]
  if self.CurBagPocketNames and BagInfo then
    local ShapeType = BagInfo.ShapeType
    if ShapeType then
      self.MainWidget.Switch_BagType:SetActiveWidgetIndex(ShapeType)
    end
  else
    return
  end
  self.MainWidget.DelayFrame = 5
  for PocketName, PocketShapeAndIndex in pairs(self.CurBagPocketNames) do
    if self.MainWidget[PocketName] and IsValid(self.MainWidget[PocketName]) then
      self.MainWidget:AddDelayFrameFunc(function()
        local PocketData
        if not self.InventoryModel.Pockets[PocketName] then
          PocketData = {
            Name = PocketName,
            Size = FVector2D(PocketShapeAndIndex.Shape[1], PocketShapeAndIndex.Shape[2]),
            Parent = self.MainWidget,
            Inventory = InventoryCommonConst.PocketType.Bag
          }
        end
        self.MainWidget[PocketName]:Init({
          Name = PocketName,
          Size = FVector2D(PocketShapeAndIndex.Shape[1], PocketShapeAndIndex.Shape[2]),
          Parent = self.MainWidget,
          Inventory = InventoryCommonConst.PocketType.Bag,
          PocketData = PocketData,
          SubBagIndex = PocketShapeAndIndex.SubBagIndex
        })
      end, self.MainWidget.DelayFrame, "InitPocket" .. PocketName)
      self.MainWidget.DelayFrame = self.MainWidget.DelayFrame + 1
    end
  end
end

function InventoryController:Destory()
  DebugPrint("lgc@InventoryController Destory  bInit =", self.bInit)
  if not self.bInit then
    return
  end
  self:RemoveEvents()
  InventoryModel:Destory()
  self.bInit = false
  self.bServerInit = false
  self._TreasureIconCache = nil
  self._SacrificePocketName = nil
end

function InventoryController:OnMainWidgetClosed()
  DebugPrint("lgc@InventoryController OnMainWidgetClosed  bInit =", self.bInit)
  self.MainWidget = nil
  self.LastTargetGridDatas = {}
  self.bDraging = false
  self._Adsorption = nil
  self.ForceAdsorption = false
  self.bForbidAdsorption = false
  self._MouseIdleTime = 0
  self._AdsorptionMoveDist = 0
  self._AdsorptionZeroSizeTime = 0
  self.bOpenItemDetails = false
  self.bOpenRecycleSortDetail = false
  self.bOpenSacrificePopup = false
  self._SacrificePocketName = nil
  self.SelectedItemWidget = nil
  self.SelectedGridWidget = nil
  for CurBagPocketName, CurBagPocketShapeAndIndex in pairs(self.CurBagPocketNames) do
    self:ClearPocketView(CurBagPocketName)
  end
  if self.MainWidget then
    self.MainWidget:BlockAllUIInput(false)
  end
end

function InventoryController:GetPocketWidget(PocketName)
  local PocketData = self.InventoryModel.Pockets[PocketName]
  if not (PocketName and PocketData) or not IsValid(PocketData.Pocket) then
    return
  end
  return PocketData.Pocket
end

function InventoryController:GetGridData(PocketName, Position)
  local Ret
  if PocketName and Position and self.InventoryModel.Grids[PocketName] and self.InventoryModel.Grids[PocketName][Position.X] and self.InventoryModel.Grids[PocketName][Position.X][Position.Y] then
    Ret = self.InventoryModel.Grids[PocketName][Position.X][Position.Y]
  end
  return Ret
end

function InventoryController:InitEvents()
  self:AddDispatcher(EventID.OnSoloTreasureGetTicket, self, function(_, TicketId)
    self:UpdateTreasureDatasByTicketId(TicketId)
  end)
  self:AddDispatcher(EventID.OnTreasureItemDrop, self, function()
    self:UpdateTreasureDatasByTicketId(self.Dungeonobject and self.Dungeonobject.SoloTreasureTicketId)
  end)
end

function InventoryController:RemoveEvents()
  self:RemoveDispatcher(EventID.OnSoloTreasureGetTicket, self)
end

function InventoryController:Tick(Geometry, DeltaTime)
  self:TickDragWidgetPos(Geometry, DeltaTime)
  if UIUtils.IsGamepadInput() and not self.bDraging and not self.bOpenItemDetails then
    self:TickTryAdsorptionWidget(Geometry, DeltaTime)
  else
    self._MouseIdleTime = 0
  end
end

function InventoryController:TickDragWidgetPos(Geometry, DeltaTime)
  if self.DragWidget and IsValid(self.DragWidget) and self.bDraging and self.MainWidget then
    local MousePos
    local Image = self.DragWidget.Prop_Icon
    local Brush = Image and self.DragWidget.Prop_Icon.Brush
    if UIUtils.IsMobileInput() then
      if self.MainWidget.CurTouchPos then
        MousePos = self.MainWidget.CurTouchPos or FVector2D(0, 0)
      end
    else
      MousePos = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self.MainWidget)
    end
    if not MousePos then
      return
    end
    local BrushOffset = Image.bUsing4KImageDesign and (Brush and Brush.ImageSize / 4 or FVector2D(0, 0)) or Brush and Brush.ImageSize / 2 or FVector2D(0, 0)
    MousePos = FVector2D(MousePos.X - BrushOffset.X, MousePos.Y - BrushOffset.Y)
    self.DragWidget:SetRenderTranslation(MousePos)
  end
end

function InventoryController:TickTryAdsorptionWidget(Geometry, DeltaTime)
  if not (self.MainWidget and self.MainWidget.BagSelect_Controller) or not self.MainWidget.BagSelect_Controller:IsVisible() then
    return
  end
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.bDraging then
    return
  end
  local Current = self.MainWidget.BagSelect_Controller.RenderTransform.Translation
  local Target = self.MainWidget.GamepadCursorTargetPosition
  local bCursorMoving = Current.X ~= Target.X or Current.Y ~= Target.Y
  if bCursorMoving then
    self._MouseIdleTime = 0
  else
    self._MouseIdleTime = (self._MouseIdleTime or 0) + DeltaTime
  end
  if self._Adsorption then
    local moveDist = self._AdsorptionMoveDist or 0
    local Threshold = InventoryCommonConst.AdsorptionCancelThreshold
    if moveDist > Threshold then
      local P = self._Adsorption.Priority
      local Const = InventoryCommonConst.AdsorptionPriority
      if P == Const.LOW then
        self._Adsorption = nil
        DebugPrint("lgc@Adsorption 玩家有意图移动，取消 LOW 吸附")
      elseif P == Const.HIGH then
        self._Adsorption.bApplied = false
      end
      self._AdsorptionMoveDist = 0
    end
  end
  if not self._Adsorption or not IsValid(self._Adsorption.Widget) then
    self._Adsorption = nil
    return
  end
  local Priority = self._Adsorption.Priority
  local Const = InventoryCommonConst.AdsorptionPriority
  local bForce = Priority == Const.FORCE
  local bTimeReached = (self._MouseIdleTime or 0) >= InventoryCommonConst.IdleTimeToTryAdsorption
  if not bForce and not bTimeReached then
    return
  end
  if self._Adsorption.bApplied then
    return
  end
  local CursorParentGeo = self.MainWidget.BagSelect_Controller:GetParent():GetCachedGeometry()
  local AdsGeo = self._Adsorption.Widget:GetCachedGeometry()
  local AdsAbs = UE4.UUIFunctionLibrary.GetGeometryAbsolutePosition(AdsGeo)
  local AdsSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(AdsGeo)
  if 0 == AdsSize.X and 0 == AdsSize.Y then
    self._AdsorptionZeroSizeTime = (self._AdsorptionZeroSizeTime or 0) + DeltaTime
    if self._AdsorptionZeroSizeTime > 0.3 then
      self._Adsorption = nil
      self._AdsorptionZeroSizeTime = 0
    end
    return
  end
  self._AdsorptionZeroSizeTime = 0
  local AdsCenter = FVector2D(AdsAbs.X + AdsSize.X / 2, AdsAbs.Y + AdsSize.Y / 2)
  local AdsCenterLocal = UE4.USlateBlueprintLibrary.AbsoluteToLocal(CursorParentGeo, AdsCenter)
  if not (self._halfW and self._halfH) or 0 == self._halfW or 0 == self._halfH then
    local CursorGeo = self.MainWidget.BagSelect_Controller:GetCachedGeometry()
    local CursorLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(CursorGeo)
    self._halfW = CursorLocalSize.X / 2
    self._halfH = CursorLocalSize.Y / 2
  end
  local TargetPos = self.MainWidget.GamepadCursorTargetPosition
  local Offset = FVector2D(AdsCenterLocal.X - TargetPos.X - (0 == self._halfW and 29 or self._halfW), TargetPos.Y + (0 == self._halfH and 29 or self._halfH) - AdsCenterLocal.Y)
  self.MainWidget:AddGamepadCursorOffset(Offset)
  if Priority == Const.LOW then
    self._Adsorption = nil
  elseif Priority == Const.FORCE and not self.ForceAdsorption then
    self._Adsorption = nil
  elseif Priority == Const.FORCE and self.ForceAdsorption then
  else
    self._Adsorption.bApplied = true
  end
end

function InventoryController:RequestAdsorption(TargetWidget, Priority)
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.bDraging or self.bOpenItemDetails then
    return
  end
  local P = Priority or InventoryCommonConst.AdsorptionPriority.LOW
  if P == InventoryCommonConst.AdsorptionPriority.LOW and self.bForbidAdsorption then
    return
  end
  if self._Adsorption and P < self._Adsorption.Priority then
    return
  end
  if self._Adsorption and self._Adsorption.Widget == TargetWidget and self._Adsorption.Priority == P then
    return
  end
  self._Adsorption = {
    Widget = TargetWidget,
    Priority = P,
    bApplied = false
  }
  self._AdsorptionMoveDist = 0
  self._AdsorptionZeroSizeTime = 0
end

function InventoryController:RequestAbandonAdsorption(TargetWidget, CancelMaxPriority)
  if not self._Adsorption then
    return
  end
  if self._Adsorption.Widget ~= TargetWidget then
    return
  end
  local MaxP = CancelMaxPriority or InventoryCommonConst.AdsorptionPriority.FORCE
  if MaxP >= self._Adsorption.Priority then
    self._Adsorption = nil
  end
end

function InventoryController:RequestForceAdsorption(TargetWidget)
  self.ForceAdsorption = true
  self:RequestAdsorption(TargetWidget, InventoryCommonConst.AdsorptionPriority.FORCE)
end

function InventoryController:ReleaseForceAdsorption()
  self.ForceAdsorption = false
  if self._Adsorption and self._Adsorption.Priority == InventoryCommonConst.AdsorptionPriority.FORCE then
    self._Adsorption = nil
  end
end

function InventoryController:_FindFirstTreasureInPocketsByNames(SortedPocketNames)
  for _, PocketName in ipairs(SortedPocketNames) do
    local GridDatas = self.InventoryModel.Grids[PocketName]
    if GridDatas then
      local Cells = {}
      for X, Col in pairs(GridDatas) do
        for Y, GridData in pairs(Col) do
          Cells[#Cells + 1] = {
            X = X,
            Y = Y,
            Data = GridData
          }
        end
      end
      table.sort(Cells, function(a, b)
        if a.Y ~= b.Y then
          return a.Y < b.Y
        end
        return a.X < b.X
      end)
      for _, Cell in ipairs(Cells) do
        local GridData = Cell.Data
        if GridData and GridData.TreasureData and IsValid(GridData.TreasureData.Treasure) then
          local Geo = GridData.TreasureData.Treasure:GetCachedGeometry()
          local AbsSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(Geo)
          if AbsSize.X > 0 or AbsSize.Y > 0 then
            return GridData.TreasureData.Treasure
          end
        end
      end
    end
  end
  return nil
end

function InventoryController:RequestAdsorptionToFirstTreasure()
  local Const = InventoryCommonConst
  local SacrificePocketName = self._SacrificePocketName
  local Prefix = Const.SearchPocketNamePrefix
  for PocketName in pairs(self.InventoryModel.Grids) do
    if string.sub(PocketName, 1, #Prefix) == Prefix and PocketName ~= SacrificePocketName then
      local W = self:_FindFirstTreasureInPocketsByNames({PocketName})
      if W then
        self:RequestAdsorption(W, Const.AdsorptionPriority.LOW)
        return
      end
    end
  end
  if self.bOpenSacrificePopup and SacrificePocketName then
    local SacWidget = self:_FindFirstTreasureInPocketsByNames({SacrificePocketName})
    if SacWidget then
      self:RequestAdsorption(SacWidget, Const.AdsorptionPriority.LOW)
      return
    end
  end
  local SortedBagNames = {}
  for PocketName in pairs(self.CurBagPocketNames or {}) do
    table.insert(SortedBagNames, PocketName)
  end
  table.sort(SortedBagNames, function(a, b)
    local aSuffix = tonumber(string.match(a, "_Bag(%d+)"))
    local bSuffix = tonumber(string.match(b, "_Bag(%d+)"))
    if aSuffix and bSuffix then
      return aSuffix < bSuffix
    end
    if aSuffix then
      return true
    end
    if bSuffix then
      return false
    end
    return a < b
  end)
  local BagWidget = self:_FindFirstTreasureInPocketsByNames(SortedBagNames)
  if BagWidget then
    self:RequestAdsorption(BagWidget, Const.AdsorptionPriority.LOW)
    return
  end
  if self.MainWidget and self.MainWidget.ResetCursorToCenter then
    self.MainWidget:ResetCursorToCenter()
  end
end

function InventoryController:RequestSelected(TargetWidget)
  if self.SelectedItemWidget and self.SelectedItemWidget == TargetWidget then
    return
  end
  if self.SelectedItemWidget then
    self.SelectedItemWidget:SetSelected(false)
  end
  self.SelectedItemWidget = TargetWidget
  self.SelectedItemWidget:SetSelected(true)
end

function InventoryController:RequestUnSelected(TargetWidget)
  if self.SelectedItemWidget and self.SelectedItemWidget == TargetWidget then
    self.SelectedItemWidget:SetSelected(false)
    self.SelectedItemWidget = nil
  end
end

function InventoryController:RequestSelectedGrid(TargetGrid)
  if self.SelectedGridWidget and self.SelectedGridWidget == TargetGrid then
    return
  end
  self.SelectedGridWidget = TargetGrid
end

function InventoryController:RequestUnSelectedGrid(TargetGrid)
  if self.SelectedGridWidget and self.SelectedGridWidget == TargetGrid then
    self.SelectedGridWidget = nil
  end
end

function InventoryController:RequestUpdateView(PendingUpdateData)
  if not PendingUpdateData then
    return
  end
  if PendingUpdateData.TreasureId then
    if PendingUpdateData.bInRecycleGrid and not PendingUpdateData.PutInRecycleTime then
      PendingUpdateData.PutInRecycleTime = TimeUtils.NowTimeMs()
    elseif not PendingUpdateData.bInRecycleGrid then
      PendingUpdateData.PutInRecycleTime = nil
    end
  end
  if IsValid(PendingUpdateData.Treasure) then
    PendingUpdateData.Treasure:UpdateView({
      NewPocketName = PendingUpdateData.PocketName,
      NewPosition = PendingUpdateData.Position,
      NewDirection = PendingUpdateData.Direction,
      bDrag = PendingUpdateData.bDrag,
      bInRecycleGrid = PendingUpdateData.bInRecycleGrid
    })
  elseif IsValid(PendingUpdateData.Grid) then
    PendingUpdateData.Grid:UpdateView({
      bCanMove = PendingUpdateData.bCanMove,
      bReset = PendingUpdateData.bReset
    })
  end
end

function InventoryController:CustomOnDragDetected(DragGridData, Operation)
  if not self.bDraging and self.MainWidget and self.MainWidget.CanvasDrag then
    self.DragWidget = Operation.DefaultDragVisual
    self.DragWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.MainWidget.CanvasDrag:AddChild(self.DragWidget)
    self.bDraging = true
    self.Operation = Operation
    self.StartDragGridData = DragGridData
    self.DragDetectedRequestID = self.DragDetectedRequestID or 0
    self.DragDetectedRequestID = self.DragDetectedRequestID + 1
    if self.DragDetectedRequestID >= math.maxinteger then
      self.DragDetectedRequestID = 0
    end
    EventManager:FireEvent(EventID.OnTreasureItemDragDetected, DragGridData)
    self:NotifyDragUp(DragGridData)
  end
end

function InventoryController:CustomOnDragCancelled(bDropSuccess)
  local StartDragGridData = self.StartDragGridData
  self:NotifyDragOverGrids(StartDragGridData, nil)
  self:ClearDragState()
  if not bDropSuccess then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_SpaceCannotUse"), 2)
  end
  EventManager:FireEvent(EventID.OnTreasureItemDragCancelled, StartDragGridData)
end

function InventoryController:CustomOnDragEnter(DragEnterGridData, MyGeometry, PointerEvent)
  local StartDragGridData = self.StartDragGridData
  if not StartDragGridData or not DragEnterGridData then
    return
  end
  if DragEnterGridData.bRecycle and StartDragGridData.bRecycle then
    return
  end
  self.CurDragEnterGridData = DragEnterGridData
  self:NotifyDragOverGrids(StartDragGridData, DragEnterGridData)
end

function InventoryController:CustomOnDragLeave(DragLeaveGridData, PointerEvent)
  local StartDragGridData = self.StartDragGridData
  if not StartDragGridData or not DragLeaveGridData then
    return
  end
  self:NotifyDragOverGrids(StartDragGridData, nil)
end

function InventoryController:CustomOnDrop(DropGridData)
  local StartDragGridData = self.StartDragGridData
  if not StartDragGridData or not DropGridData then
    return
  end
  local bDropSuccess = self:TryDropAndSwitchItem(StartDragGridData, DropGridData)
  if not bDropSuccess then
    EventManager:FireEvent(EventID.OnTreasureItemDragCancelled)
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_SpaceCannotUse"), 2)
  end
  return bDropSuccess
end

function InventoryController:QuickTransferFromGrid(DragGridData, QuickTransferType)
  if not DragGridData or not QuickTransferType then
    return false
  end
  local TreasureData = DragGridData and DragGridData.TreasureData or nil
  if not (TreasureData and TreasureData.Treasure) or not TreasureData.Treasure.bSearched then
    return false
  end
  local bSuccess = false
  local MoveInfo
  MoveInfo = self:GetItemMoveData(DragGridData, nil, QuickTransferType)
  if MoveInfo and MoveInfo.bCanMove then
    self.StartDragGridData = DragGridData
    bSuccess = self:TryDropAndSwitchItem(DragGridData, nil, MoveInfo)
  end
  if not bSuccess then
    local BagGridOccupancyData = self:GetBagGridOccupancyData()
    local TreasureSize = TreasureData.Size and TreasureData.Size.X * TreasureData.Size.Y or 0
    if BagGridOccupancyData and BagGridOccupancyData.OccupancyGridNum and BagGridOccupancyData.AllGridNum and BagGridOccupancyData.OccupancyGridNum + TreasureSize > BagGridOccupancyData.AllGridNum then
      UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_InsufficientSpace"), 2)
    else
      UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_SpaceCannotUse"), 2)
    end
  end
  return bSuccess
end

function InventoryController:NotifyDragUp(DragGridData)
  if not DragGridData then
    return
  end
  local Treasure = DragGridData and DragGridData.TreasureData and DragGridData.TreasureData.Treasure or nil
  if not Treasure then
    return
  end
  local UpdateParams = {
    bDrag = true,
    Treasure = Treasure,
    bInRecycleGrid = Treasure.bInRecycleGrid
  }
  self:RequestUpdateView(UpdateParams)
  self:NotifyDragOverGrids(DragGridData, DragGridData)
end

function InventoryController:NotifyDragOverGrids(DragGridData, OverDropGridData)
  if UIUtils.IsGamepadInput() then
    self.CurNotifyOverDragGridData = DragGridData
    self.CurNotifyOverDropGridData = OverDropGridData
  end
  local Cache = self._NotifyDragOverGridsCache
  if Cache and Cache.DragGridData == DragGridData and Cache.OverDropGridData == OverDropGridData then
    return
  end
  self._NotifyDragOverGridsCache = {DragGridData = DragGridData, OverDropGridData = OverDropGridData}
  local MoveInfo = self:GetItemMoveData(DragGridData, OverDropGridData)
  self.NewTargetGridDatas = {}
  local TargetDirection
  if MoveInfo.EndInfo.Type == "Grid" then
    if MoveInfo.EndInfo.TopLeft and MoveInfo.EndInfo.ValidTopLeftList[1] then
      local TopLeft = MoveInfo.EndInfo.TopLeft
      local Width, Height = self:GetWHByDir(MoveInfo.StartInfo.DragGridData.TreasureData.Size, MoveInfo.EndInfo.Direction)
      self.NewTargetGridDatas = self:GetTargetGridDatas(MoveInfo.EndInfo.PocketData.Name, TopLeft, Width, Height)
      TargetDirection = MoveInfo.EndInfo.Direction
    elseif MoveInfo.EndInfo.AllInvalidResults[1] then
      local MaxTargetGridDatas = {}
      for _, InvalidTopLeftInfo in ipairs(MoveInfo.EndInfo.AllInvalidResults) do
        local Width, Height = self:GetWHByDir(MoveInfo.StartInfo.DragGridData.TreasureData.Size, InvalidTopLeftInfo[1])
        local TargetGridDatas = self:GetTargetGridDatas(MoveInfo.EndInfo.PocketData.Name, InvalidTopLeftInfo[2], Width, Height)
        if #TargetGridDatas > #MaxTargetGridDatas then
          MaxTargetGridDatas = TargetGridDatas
          TargetDirection = InvalidTopLeftInfo[1]
        end
      end
      for _, GridData in ipairs(MaxTargetGridDatas) do
        table.insert(self.NewTargetGridDatas, GridData)
      end
    end
  end
  if TargetDirection then
    local DefaultDragVisual = MoveInfo.StartInfo.DragGridData.TreasureData and MoveInfo.StartInfo.DragGridData.TreasureData.Treasure and MoveInfo.StartInfo.DragGridData.TreasureData.Treasure.DefaultDragVisual
    local bSquare = MoveInfo.StartInfo.DragGridData.TreasureData and MoveInfo.StartInfo.DragGridData.TreasureData.Size.X == MoveInfo.StartInfo.DragGridData.TreasureData.Size.Y
    if DefaultDragVisual and not bSquare then
      if TargetDirection == InventoryCommonConst.Direction.Vertical then
        DefaultDragVisual.Prop_Icon:SetRenderTransformAngle(90)
      elseif TargetDirection == InventoryCommonConst.Direction.Horizontal then
        DefaultDragVisual.Prop_Icon:SetRenderTransformAngle(0)
      end
    end
  end
  local UpdateParams = {
    bCanMove = MoveInfo.bCanMove,
    bReset = false
  }
  for _, GridData in ipairs(self.NewTargetGridDatas) do
    if IsValid(GridData.Grid) then
      UpdateParams.Grid = GridData.Grid
      self:RequestUpdateView(UpdateParams)
      GridData.Grid.bUpdated = true
    end
  end
  UpdateParams = {bCanMove = nil, bReset = true}
  for _, GridData in ipairs(self.LastTargetGridDatas) do
    if IsValid(GridData.Grid) and not GridData.Grid.bUpdated then
      UpdateParams.Grid = GridData.Grid
      self:RequestUpdateView(UpdateParams)
    end
  end
  for _, GridData in ipairs(self.NewTargetGridDatas) do
    if IsValid(GridData.Grid) then
      GridData.Grid.bUpdated = false
    end
  end
  self.LastTargetGridDatas = self.NewTargetGridDatas
end

function InventoryController:TryDropAndSwitchItem(DragGridData, DropGridData, QuickMoveInfo)
  self:NotifyDragOverGrids(DragGridData, nil)
  self:ClearDragState()
  if self.PendingApplyMoveInfo then
    return false
  end
  local PendingApplyMoveInfo
  if not QuickMoveInfo then
    PendingApplyMoveInfo = self:GetItemMoveData(DragGridData, DropGridData)
    if PendingApplyMoveInfo and not PendingApplyMoveInfo.bCanMove then
      return false
    end
  end
  self.PendingApplyMoveInfo = QuickMoveInfo or PendingApplyMoveInfo
  if not self.PendingApplyMoveInfo.EndInfo.EffectedTreasureItemList or not self.bUseClientCalMovePos then
    local StartInfo = self.PendingApplyMoveInfo.StartInfo
    local StartGridData = StartInfo and StartInfo.DragGridData or nil
    local StartPocketData = StartInfo and StartInfo.PocketData or nil
    local EndInfo = self.PendingApplyMoveInfo.EndInfo
    local EndGridData = EndInfo and EndInfo.DropGridData or nil
    local EndPocketData = EndInfo and EndInfo.PocketData or nil
    local TargetTreasureUid
    if StartInfo and StartInfo.DragGridData and StartInfo.DragGridData.TreasureData and StartInfo.DragGridData.TreasureData.UUid then
      TargetTreasureUid = StartInfo.DragGridData.TreasureData.UUid
    end
    local IsRotate = false
    if StartInfo and EndInfo and StartInfo.Direction and EndInfo.Direction and StartInfo.Direction ~= EndInfo.Direction then
      IsRotate = true
    end
    local TargetPosition
    if EndGridData and EndInfo.TopLeft and EndPocketData and EndPocketData.Size then
      TargetPosition = self:ClientPosition2ServerPos(EndInfo.TopLeft, EndPocketData.Size)
    end
    local TargetBagIndex, TargetSubBagIndex
    if not TargetBagIndex and EndPocketData.Inventory == InventoryCommonConst.PocketType.Mechanism then
      TargetBagIndex = EndPocketData.MechanismUid
      TargetSubBagIndex = 0
    end
    if not TargetBagIndex and EndPocketData.Inventory == InventoryCommonConst.PocketType.Recycle then
      TargetBagIndex = -1
      TargetSubBagIndex = EndPocketData.RecycleIndex
    end
    if not TargetBagIndex and EndPocketData.Inventory == InventoryCommonConst.PocketType.Bag then
      TargetBagIndex = 0
      TargetSubBagIndex = EndPocketData.SubBagIndex
    end
    if not self.Dungeonobject then
      GWorld.logger.error("Dungeonobject == nil")
      return false
    end
    self.Dungeonobject:NotifyServerDungeonEvent("MoveTreasureItem", TargetTreasureUid, TargetBagIndex, TargetSubBagIndex, TargetPosition, IsRotate)
  elseif self.PendingApplyMoveInfo.EndInfo.EffectedTreasureItemList and self.bUseClientCalMovePos then
    local ServerEffectedTreasureItemList = {}
    for _, EffectedTreasureItem in ipairs(self.PendingApplyMoveInfo.EndInfo.EffectedTreasureItemList) do
      local BagIndex = -1
      local SubBagIndex = 0
      local NewPocketData = self.InventoryModel.Pockets[EffectedTreasureItem.NewPocketName]
      if string.startswith(EffectedTreasureItem.NewPocketName, InventoryCommonConst.RecyclePocketNamePrefix) then
        BagIndex = -1
        SubBagIndex = NewPocketData.RecycleIndex
      elseif string.startswith(EffectedTreasureItem.NewPocketName, InventoryCommonConst.SearchPocketNamePrefix) then
        BagIndex = NewPocketData.MechanismUid
      elseif string.startswith(EffectedTreasureItem.NewPocketName, "WBP_Type") then
        BagIndex = 0
        SubBagIndex = NewPocketData.SubBagIndex
      end
      local Rotate = EffectedTreasureItem.NewDir == InventoryCommonConst.Direction.Vertical
      local Pos = self:ClientPosition2ServerPos(EffectedTreasureItem.NewTopLeft, NewPocketData and NewPocketData.Size)
      local ServerTreasureItem = {
        Id = EffectedTreasureItem.TreasureData.TreasureId,
        UniqueId = EffectedTreasureItem.TreasureData.UUid,
        BagIndex = BagIndex,
        SubBagIndex = SubBagIndex,
        Rotate = Rotate,
        Pos = Pos
      }
      table.insert(ServerEffectedTreasureItemList, ServerTreasureItem)
    end
    local _si = self.PendingApplyMoveInfo.StartInfo
    local _st = _si and _si.TreasureData
    local _dragUuid = _st and _st.UUid
    for i, item in ipairs(ServerEffectedTreasureItemList) do
      local ef = self.PendingApplyMoveInfo.EndInfo.EffectedTreasureItemList[i]
      if item.UniqueId == _dragUuid then
        DebugPrint("lgc@InventoryController UpdateTreasureItemList [main]" .. " id=" .. tostring(item.Id) .. " uuid=" .. tostring(item.UniqueId) .. " | from pocket=" .. tostring(_si.PocketData and _si.PocketData.Name) .. " pos=(" .. tostring(_si.TopLeft and _si.TopLeft.X) .. "," .. tostring(_si.TopLeft and _si.TopLeft.Y) .. ")" .. " dir=" .. tostring(_si.Direction))
        DebugPrint("lgc@InventoryController UpdateTreasureItemList [main]" .. " -> pocket=" .. tostring(ef and ef.NewPocketName) .. " bagIdx=" .. tostring(item.BagIndex) .. " subIdx=" .. tostring(item.SubBagIndex) .. " serverPos=" .. tostring(item.Pos) .. " rotate=" .. tostring(item.Rotate))
      else
        DebugPrint("lgc@InventoryController UpdateTreasureItemList [displaced]" .. " id=" .. tostring(item.Id) .. " uuid=" .. tostring(item.UniqueId) .. " -> pocket=" .. tostring(ef and ef.NewPocketName) .. " serverPos=" .. tostring(item.Pos))
      end
    end
    self.Dungeonobject:NotifyServerDungeonEvent("UpdateTreasureItemList", ServerEffectedTreasureItemList)
  end
  if self.MainWidget then
    self.MainWidget:BlockAllUIInput(true)
    self.MainWidget:AddTimer(5, function()
      if self.MainWidget:IsAllUIInputBlocked() then
        self.MainWidget:BlockAllUIInput(false)
        self.PendingApplyMoveInfo = nil
        DebugPrint("lgc@InventoryController TimeOut UnblockAllUIInput")
      end
    end, false, 0, "UnblockAllUIInput")
  end
  local Success = false
  if self.MainWidget and self.bOpenClientPredict then
    if self.PendingApplyMoveInfo then
      Success = self:RealDropAndSwitchItem(self.PendingApplyMoveInfo)
    else
      GWorld.logger.error("RealDropAndSwitchItem 没有待处理的移动请求")
      Success = false
    end
  else
    Success = true
  end
  return Success
end

function InventoryController:RealDropAndSwitchItem(ApplyMoveInfo)
  DebugPrint("lgc@InventoryController RealDropAndSwitchItem")
  local bSuccess = self:ApplyItemMoveData(ApplyMoveInfo)
  return bSuccess
end

function InventoryController:ClearDragState()
  if self.MainWidget and IsValid(self.MainWidget) and self.StartDragGridData then
    local TreasureData = self.StartDragGridData.TreasureData
    local UpdateParams = {
      bDrag = false,
      Treasure = TreasureData and TreasureData.Treasure,
      bInRecycleGrid = TreasureData and TreasureData.Treasure and TreasureData.Treasure.bInRecycleGrid
    }
    self:RequestUpdateView(UpdateParams)
  end
  if self.DragWidget and IsValid(self.DragWidget) then
    self.DragWidget:SetVisibility(ESlateVisibility.Collapsed)
    self.DragWidget = nil
  end
  self.bDraging = false
  self.Operation = nil
  self.StartDragGridData = nil
  self._NotifyDragOverGridsCache = nil
end

function InventoryController:GamepadChangeDragWidgetDirection()
  if not (self.bDraging and self.DragWidget) or not self.MainWidget then
    return
  end
  if self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] == InventoryCommonConst.Direction.Vertical then
    self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] = InventoryCommonConst.Direction.Horizontal
  elseif self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] == InventoryCommonConst.Direction.Horizontal then
    self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] = InventoryCommonConst.Direction.Vertical
  elseif not self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] then
    local StartDragGridData = self.StartDragGridData
    local TreasureData = StartDragGridData and StartDragGridData.TreasureData or nil
    if TreasureData then
      self.MainWidget.GamepadChangeDragItemDirectionTable[self.DragDetectedRequestID] = TreasureData.Direction == InventoryCommonConst.Direction.Vertical and InventoryCommonConst.Direction.Horizontal or InventoryCommonConst.Direction.Vertical
    end
  end
  self._NotifyDragOverGridsCache = nil
  self:NotifyDragOverGrids(self.CurNotifyOverDragGridData, self.CurNotifyOverDropGridData)
end

function InventoryController:GetBagTreasureValue()
  local CurBagPocketNames = self.CurBagPocketNames or {}
  local BagTreasureValue = 0
  for PocketName, _ in pairs(CurBagPocketNames) do
    local TreasureItemDatas = self.InventoryModel.TreasureItems[PocketName]
    if TreasureItemDatas then
      for UUid, TreasureItemData in pairs(TreasureItemDatas) do
        local TreasureInfo = DataMgr.ExtractionTreasure[TreasureItemData.TreasureId]
        if TreasureInfo then
          BagTreasureValue = BagTreasureValue + TreasureInfo.TreasureValue * (tonumber(TreasureItemData.BuffLabelInfo and TreasureItemData.BuffLabelInfo.Num) or 1)
        end
      end
    end
  end
  return BagTreasureValue
end

function InventoryController:GetBagGridOccupancyData()
  local AllGridNum = 0
  local OccupancyGridNum = 0
  local CurBagPocketNames = self.CurBagPocketNames or {}
  for PocketName, _ in pairs(CurBagPocketNames) do
    local PocketGrids = self.InventoryModel.Grids[PocketName]
    if PocketGrids then
      for X, ColGrids in pairs(PocketGrids) do
        for Y, GridData in pairs(ColGrids) do
          AllGridNum = AllGridNum + 1
          if GridData.TreasureData then
            OccupancyGridNum = OccupancyGridNum + 1
          end
        end
      end
    end
  end
  return {AllGridNum = AllGridNum, OccupancyGridNum = OccupancyGridNum}
end

function InventoryController:GetValidRecycleDropGridData()
  local i = 1
  local RecyclePocketName = InventoryCommonConst.RecyclePocketNamePrefix .. i
  local RecyclePocketData = self.InventoryModel.Pockets[RecyclePocketName]
  local GridData
  if RecyclePocketData and self.InventoryModel.Grids[RecyclePocketName] then
    GridData = self.InventoryModel.Grids[RecyclePocketName][0][0]
  end
  while not GridData or GridData.TreasureData do
    i = i + 1
    if i > 500 then
      DebugPrint("lgc@GetValidRecycleDropGridData: Warning i > 500")
      return
    end
    RecyclePocketName = InventoryCommonConst.RecyclePocketNamePrefix .. i
    RecyclePocketData = self.InventoryModel.Pockets[RecyclePocketName]
    GridData = nil
    if RecyclePocketData then
      if self.InventoryModel.Grids[RecyclePocketName] then
        GridData = self.InventoryModel.Grids[RecyclePocketName][0][0]
      else
        GridData = {
          Position = FVector2D(0, 0),
          PocketData = RecyclePocketData,
          Grid = nil,
          bRecycle = true,
          TreasureData = nil,
          Inventory = InventoryCommonConst.PocketType.Recycle
        }
      end
    end
  end
  return GridData
end

function InventoryController:AddEmptyRecyclePocketData()
  local i = 1
  while true do
    local RecyclePocketName = InventoryCommonConst.RecyclePocketNamePrefix .. i
    local RecyclePocketData = self.InventoryModel.Pockets[RecyclePocketName]
    if not RecyclePocketData then
      break
    end
    i = i + 1
    if i > 500 then
      DebugPrint("lgc@AddEmptyRecyclePocketData: Warning i > 500")
      return
    end
  end
  local RecyclePocketName = InventoryCommonConst.RecyclePocketNamePrefix .. i
  local RecyclePocketData = {
    Inventory = InventoryCommonConst.PocketType.Recycle,
    Pocket = nil,
    Name = RecyclePocketName,
    bRecycle = true,
    RecycleIndex = i,
    Size = FVector2D(1, 1)
  }
  self.InventoryModel.Pockets[RecyclePocketName] = RecyclePocketData
  self:InitGridsData(RecyclePocketData)
end

function InventoryController:RemoveEmptyRecyclePocketData()
  local i = 1
  while true do
    local RecyclePocketName = InventoryCommonConst.RecyclePocketNamePrefix .. i
    local RecyclePocketData = self.InventoryModel.Pockets[RecyclePocketName]
    if RecyclePocketData then
      local GridData = self.InventoryModel.Grids[RecyclePocketName][0][0]
      if not GridData.TreasureData then
        self:ClearPocketView(RecyclePocketName)
        break
      end
    end
    i = i + 1
    if i > 500 then
      DebugPrint("lgc@RemoveEmptyRecyclePocketData: Warning i > 500")
      return
    end
  end
end

function InventoryController:InitGridsData(TargetPocketData)
  if not TargetPocketData then
    return
  end
  for X = 0, TargetPocketData.Size.X - 1 do
    for Y = 0, TargetPocketData.Size.Y - 1 do
      local Pos = FVector2D(X, Y)
      if not self.InventoryModel.Grids[TargetPocketData.Name] then
        self.InventoryModel.Grids[TargetPocketData.Name] = {}
      end
      if not self.InventoryModel.Grids[TargetPocketData.Name][X] then
        self.InventoryModel.Grids[TargetPocketData.Name][X] = {}
      end
      local GridData = {
        Grid = nil,
        Position = Pos,
        PocketData = TargetPocketData,
        Inventory = TargetPocketData.Inventory,
        TreasureData = nil,
        bRecycle = TargetPocketData.bRecycle
      }
      self.InventoryModel.Grids[TargetPocketData.Name][X][Y] = GridData
    end
  end
end

function InventoryController:GetTreasureDatasById(TreasureId)
  if not TreasureId then
    return {}
  end
  local TreasureDatas = {}
  for _, PocketData in pairs(self.InventoryModel.Pockets) do
    if PocketData.Inventory == InventoryCommonConst.PocketType.Bag then
      local TreasureItems = self.InventoryModel.TreasureItems[PocketData.Name]
      if TreasureItems and next(TreasureItems) then
        for _, TreasureItemData in pairs(TreasureItems) do
          if TreasureItemData.TreasureId == TreasureId then
            table.insert(TreasureDatas, TreasureItemData)
          end
        end
      end
    end
  end
  return TreasureDatas
end

function InventoryController:UpdateTreasureDatasByTicketId(TicketId)
  if not self.Dungeonobject then
    return
  end
  local EffectTreasureList = SoloTreasureUtils:GetTicketEffectTreasureList(self.Dungeonobject.AllItemList, TicketId)
  local TicketQuality = TicketId and DataMgr.ExtractionLottery[TicketId].Quality or 1
  for Uid, ItemData in pairs(self.Dungeonobject.AllItemList) do
    local TreasureData = self:GetCurTreasureData(Uid)
    if EffectTreasureList[Uid] and TreasureData then
      self.Dungeonobject.AllItemList[Uid].BuffLabelInfo = {
        Quality = TicketQuality,
        Num = EffectTreasureList[Uid]
      }
      TreasureData.BuffLabelInfo = {
        Quality = TicketQuality,
        Num = EffectTreasureList[Uid]
      }
      if IsValid(TreasureData.Treasure) then
        TreasureData.Treasure:SetShowBuffLabel(TreasureData.BuffLabelInfo)
      end
    elseif TreasureData and TreasureData.BuffLabelInfo then
      self.Dungeonobject.AllItemList[Uid].BuffLabelInfo = nil
      TreasureData.BuffLabelInfo = nil
      if IsValid(TreasureData.Treasure) then
        TreasureData.Treasure:SetShowBuffLabel(nil)
      end
    end
  end
end

function InventoryController:UpdateTreasureItemDataServerNew(ItemData)
  local BagIndex = ItemData.BagIndex
  local SubBagIndex = ItemData.SubBagIndex
  local PocketName, Inventory
  local bNotSearched = false
  local PocketSize
  if -1 == BagIndex then
    PocketName = InventoryCommonConst.RecyclePocketNamePrefix .. SubBagIndex
    Inventory = InventoryCommonConst.PocketType.Recycle
    PocketSize = FVector2D(1, 1)
  elseif 0 == BagIndex then
    for CurBagPocketName, CurBagPocketShapeAndIndex in pairs(self.CurBagPocketNames or {}) do
      if CurBagPocketShapeAndIndex.SubBagIndex == SubBagIndex then
        PocketName = CurBagPocketName
      end
    end
    Inventory = InventoryCommonConst.PocketType.Bag
    local BagInfo = DataMgr.ExtractionTreasureBag[self.InventoryModel.BagId]
    PocketSize = FVector2D(BagInfo.Shape[SubBagIndex][1], BagInfo.Shape[SubBagIndex][2])
  else
    PocketName = InventoryCommonConst.SearchPocketNamePrefix .. BagIndex
    Inventory = InventoryCommonConst.PocketType.Mechanism
    bNotSearched = true
    local Shape
    local MechanismEntity = self.Dungeonobject:GetCachedMechanismInfo(BagIndex)
    if not MechanismEntity then
      return
    end
    local MechanismInfo = DataMgr.ExtractionTreasureMechanism[MechanismEntity.UnitId]
    if not MechanismInfo then
      MechanismInfo = DataMgr.ExtractionTreasureGuard[MechanismEntity.UnitId]
      MechanismInfo = MechanismInfo and DataMgr.ExtractionTreasureMechanism[MechanismInfo.MechanismItemBox]
    end
    if not MechanismInfo then
      return
    end
    PocketSize = FVector2D(MechanismInfo.Shape[1], MechanismInfo.Shape[2])
  end
  local PocketData = self.InventoryModel.Pockets[PocketName] or {
    Inventory = Inventory,
    Name = PocketName,
    Size = PocketSize,
    SubBagIndex = 0 == BagIndex and SubBagIndex or nil,
    MechanismUid = BagIndex and -1 ~= BagIndex and 0 ~= BagIndex and BagIndex or nil,
    bRecycle = -1 == BagIndex,
    RecycleIndex = -1 == BagIndex and SubBagIndex or nil
  }
  local Position = self:ServerPos2ClientPosition(ItemData.Pos, PocketSize)
  local TreasureShape = DataMgr.ExtractionTreasure[tonumber(ItemData.Id)].Shape
  local TreasureSize = FVector2D(TreasureShape[1], TreasureShape[2])
  local TreasureData = {
    TreasureId = tonumber(ItemData.Id),
    Position = Position,
    Direction = ItemData.Rotate and InventoryCommonConst.Direction.Vertical or InventoryCommonConst.Direction.Horizontal,
    UUid = ItemData.UniqueId,
    bNotSearched = bNotSearched,
    Size = TreasureSize
  }
  self:CreateTreasureDataToPocket(PocketData, TreasureData)
end

function InventoryController:UpdateTreasureItemDataServer(bServerSuccess)
  if self.MainWidget then
    self.MainWidget:BlockAllUIInput(false)
  end
  if not bServerSuccess then
    if self.MainWidget and self.bOpenClientPredict then
      if self.PendingApplyMoveInfo then
        local RevertDropGridData = CommonUtils.DeepCopy(self.PendingApplyMoveInfo.StartInfo.DragGridData)
        local RevertDragGridData = CommonUtils.DeepCopy(self.PendingApplyMoveInfo.EndInfo.DropGridData)
        local RevertMoveInfo = self:GetItemMoveData(RevertDragGridData, RevertDropGridData)
        self:RealDropAndSwitchItem(RevertMoveInfo)
        DebugPrint("lgc@UpdateTreasureItemData: Client Predict Failed!! RevertRealDropAndSwitchItem")
      end
    else
      self:ClearDragState()
      self.PendingApplyMoveInfo = nil
    end
    EventManager:FireEvent(EventID.OnTreasureItemDragCancelled)
    return false
  end
  if not self.MainWidget then
    return
  end
  local bSuccess = false
  if self.PendingApplyMoveInfo then
    bSuccess = true
  end
  if self.MainWidget and self.bOpenClientPredict then
    if bSuccess then
      EventManager:FireEvent(EventID.OnTreasureItemDrop, self.PendingApplyMoveInfo)
    end
  else
    bSuccess = self:RealDropAndSwitchItem(self.PendingApplyMoveInfo)
    if bSuccess then
      EventManager:FireEvent(EventID.OnTreasureItemDrop, self.PendingApplyMoveInfo)
    end
  end
  self.PendingApplyMoveInfo = nil
end

function InventoryController:DeleteTreasureItemDataServer(ItemData)
  if not ItemData or not ItemData.UniqueId then
    return
  end
  local CurTreasureData = self:GetCurTreasureData(ItemData.UniqueId)
  if CurTreasureData then
    if self.MainWidget and IsValid(self.MainWidget) then
      local UpdateParams = {
        Treasure = CurTreasureData.Treasure
      }
      self:RequestUpdateView(UpdateParams)
    end
    self.InventoryModel.TreasureItems[CurTreasureData.PocketName][CurTreasureData.UUid] = nil
    local Width, Height = self:GetWHByDir(CurTreasureData.Size, CurTreasureData.Direction)
    local GridDatas = self:GetTargetGridDatas(CurTreasureData.PocketName, CurTreasureData.Position, Width, Height)
    for _, GridData in pairs(GridDatas or {}) do
      GridData.TreasureData = nil
    end
  else
    DebugPrint("lgc@DeleteTreasureItemDataServer: Warning CurTreasureData is nil")
  end
end

function InventoryController:GetCurTreasureData(TreasureUid)
  if not TreasureUid then
    return nil
  end
  local OldTreasureData
  local ItemData = self.Dungeonobject.AllItemList[TreasureUid]
  local PocketName
  if -1 == ItemData.BagIndex then
    PocketName = InventoryCommonConst.RecyclePocketNamePrefix .. tostring(ItemData.SubBagIndex)
  elseif 0 == ItemData.BagIndex then
    for CurBagPocketName, CurBagPocketShapeAndIndex in pairs(self.CurBagPocketNames or {}) do
      if CurBagPocketShapeAndIndex.SubBagIndex == ItemData.SubBagIndex then
        PocketName = CurBagPocketName
      end
    end
  else
    PocketName = InventoryCommonConst.SearchPocketNamePrefix .. tostring(ItemData.BagIndex)
  end
  local TreasureData = InventoryModel.TreasureItems[PocketName][TreasureUid]
  if TreasureData then
    OldTreasureData = TreasureData
  end
  return OldTreasureData
end

function InventoryController:ServerPos2ClientPosition(Pos, PocketSize)
  if not Pos or not PocketSize then
    return nil
  end
  local X = (Pos - 1) % PocketSize.X
  local Y = math.floor((Pos - 1) / PocketSize.X)
  local EndPosition = FVector2D(X, Y)
  return EndPosition
end

function InventoryController:ClientPosition2ServerPos(Position, PocketSize)
  if not Position or not PocketSize then
    return nil
  end
  local Pos = Position.X + 1 + Position.Y * PocketSize.X
  return Pos
end

function InventoryController:OnSoloTreasureTribute()
  UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_TM_17"), 2)
end

AssembleComponents(InventoryController)
return InventoryController
