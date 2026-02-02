local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.DelayFrameComponent"
})

function M:Construct()
end

function M:Destruct()
end

function M:Init(Params)
  self.TreasureItem = Params.TreasureItem and Params.TreasureItem or self.TreasureItem
  self.PocketData = Params.PocketData and Params.PocketData or self.PocketData
  self.Inventory = Params.Inventory and Params.Inventory or self.Inventory
  self.bGrid = true
  self.bNormal = true
  self:InitBtnEvents()
end

function M:InitBtnEvents()
  self.Btn.OnHovered:Add(self, self.OnBtnHovered)
  self.Btn.OnUnHovered:Add(self, self.OnBtnUnHovered)
  self.Btn.OnClicked:Add(self, self.OnBtnClicked)
end

function M:OnBtnHovered()
  local bMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
  if bMobile then
    return
  end
  if self.TreasureItem then
    self.TreasureItem:OnHovered(self)
  end
end

function M:OnBtnUnHovered()
  local bMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
  if bMobile then
    return
  end
  if self.TreasureItem then
    self.TreasureItem:OnUnHovered(self)
  end
end

function M:OnBtnClicked()
  local key = "DoubleClickTimer_" .. self:GetName()
  if self:IsExistTimer(key) then
    self:RemoveTimer(key)
    self._DoubleClickTimerKey = nil
    self:OnDoubleClicked()
    return
  end
  self._DoubleClickTimerKey = key
  local interval = 0.25
  self:AddTimer(interval, function(self)
    if self._DoubleClickTimerKey == key then
      self._DoubleClickTimerKey = nil
    end
  end, false, 0, key)
  self:OnSingleClicked()
end

function M:OnDoubleClicked()
  DebugPrint("lgc@WBP_SoloTreasure_Grid OnDoubleClicked")
  if not self.TreasureItem or not self.TreasureItem.bSearched then
    return false
  end
  return InventoryController:QuickTransferFromGrid(self)
end

function M:OnSingleClicked()
  if self.TreasureItem and self.TreasureItem.bSearched then
    self.TreasureItem:OnClicked()
  end
end

function M:OnPreviewMouseButtonDown(MyGeometry, MouseEvent)
  local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
  if MouseButton.KeyName == "LeftMouseButton" and self.TreasureItem then
    return UWidgetBlueprintLibrary.DetectDrag(UWidgetBlueprintLibrary.ReleaseMouseCapture(UWidgetBlueprintLibrary.Unhandled()), self, UE4.EKeys.LeftMouseButton)
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  DebugPrint("lgc@WBP_SoloTreasure_Grid OnMouseButtonUp", self:IsHovered())
  local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
  if MouseButton.KeyName == "RightMouseButton" then
    self:OnSingleClicked()
    local bSuccess = self:OnDoubleClicked()
    if bSuccess then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnDragDetected(MyGeometry, PointerEvent)
  local TreasureItem = self.TreasureItem
  if not TreasureItem or not TreasureItem.bSearched then
    return
  end
  local Operation = NewObject(UIUtils.GetCommonDragDropOperationClass())
  Operation.Payload = self
  if not IsValid(TreasureItem.TreasureContent.DefaultDragVisual) then
    TreasureItem:CreateDragWidget(TreasureItem.TreasureContent)
  end
  Operation.DefaultDragVisual = TreasureItem.TreasureContent.DefaultDragVisual
  if not Operation.DefaultDragVisual then
    return nil
  end
  Operation.Tag = "SoloTreasureGrid"
  Operation.Pivot = self.DragPivot or UE4.EDragPivot.CenterCenter
  Operation.Offset = self.DragOffset or Operation.Offset
  InventoryController:OnDragDetected(self, MyGeometry, PointerEvent, Operation)
  return Operation
end

function M:OnDragCancelled(PointerEvent, Operation)
  Operation = InventoryController:OnDragCancelled(self, PointerEvent, Operation)
end

function M:OnDragEnter(MyGeometry, PointerEvent, Operation)
  DebugPrint("lgc@WBP_SoloTreasure_Grid OnDragEnter", self.Btn:IsHovered())
  Operation = InventoryController:OnDragEnter(self, MyGeometry, PointerEvent, Operation)
end

function M:OnDragLeave(PointerEvent, Operation)
  DebugPrint("lgc@WBP_SoloTreasure_Grid OnDragLeave", self.Btn:IsHovered())
  Operation = InventoryController:OnDragLeave(self, PointerEvent, Operation)
  self._Quadrant = nil
end

function M:OnDragOver(MyGeometry, PointerEvent, Operation)
  local ScreenPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
  local LocalPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(MyGeometry, ScreenPos)
  local Size = UE4.USlateBlueprintLibrary.GetLocalSize(MyGeometry)
  local Center = FVector2D(Size.X / 2, Size.Y / 2)
  local RelX = LocalPos.X - Center.X
  local RelY = LocalPos.Y - Center.Y
  local NewQuadrant
  if RelX >= 0 then
    if RelY >= 0 then
      NewQuadrant = 4
    else
      NewQuadrant = 1
    end
  elseif RelY >= 0 then
    NewQuadrant = 3
  else
    NewQuadrant = 2
  end
  self.CursorPosition = FVector2D(self.Position.X + RelX, self.Position.Y + RelY)
  if self._Quadrant ~= NewQuadrant then
    self._Quadrant = NewQuadrant
    InventoryController:OnDragEnter(self, MyGeometry, PointerEvent, Operation)
  end
  return Operation
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)
  local bDropSuccess = InventoryController:OnDrop(self, MyGeometry, PointerEvent, Operation)
  return bDropSuccess
end

function M:UpdateView(UpdateParams)
  local bCanMove = UpdateParams.bCanMove
  local bReset = UpdateParams.bReset
  DebugPrint("lgc@WBP_SoloTreasure_Grid UpdateView bCanMove =", bCanMove, "bReset =", bReset)
  if bReset then
    self.bNormal = true
    self.bAble = false
    self.bDisable = false
    self:AddDelayFrameFunc(function()
      if not (self and self.bNormal and self.MaskWidget) or not self.MaskWidget.Normal then
        return
      end
      self.MaskWidget:StopAllAnimations()
      self.MaskWidget:PlayAnimation(self.MaskWidget.Normal)
    end, 2)
  elseif bCanMove and not self.bAble then
    self.bAble = true
    self.bNormal = false
    self.bDisable = false
    self:AddDelayFrameFunc(function()
      if not (self and self.bAble and self.MaskWidget) or not self.MaskWidget.Able then
        return
      end
      self.MaskWidget:StopAllAnimations()
      self.MaskWidget:PlayAnimation(self.MaskWidget.Able)
    end, 2)
  elseif not bCanMove and not self.bDisable then
    self.bDisable = true
    self.bNormal = false
    self.bAble = false
    self:AddDelayFrameFunc(function()
      if not (self and self.bDisable and self.MaskWidget) or not self.MaskWidget.DiaAble then
        return
      end
      self.MaskWidget:StopAllAnimations()
      self.MaskWidget:PlayAnimation(self.MaskWidget.DiaAble)
    end, 2)
  end
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self.TreasureItem then
    self.TreasureItem:SetFocus()
  end
end

return M
