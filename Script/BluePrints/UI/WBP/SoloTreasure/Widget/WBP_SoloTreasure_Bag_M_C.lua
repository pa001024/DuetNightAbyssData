require("UnLua")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local M = Class("BluePrints.UI.WBP.SoloTreasure.Widget.WBP_SoloTreasure_Bag")

function M:Construct()
  self.Super.Construct(self)
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.CanvasDrag:SetVisibility(ESlateVisibility.HitTestInvisible)
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
  if not self.InventoryController or not self.InventoryController.bInit then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
  if not self.PC or not IsValid(self.PC) then
    self.PC = self:GetOwningPlayer()
  end
  local ViewportGeometry = UE4.UWidgetLayoutLibrary.GetViewportWidgetGeometry(self.PC)
  self.CurTouchPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(ViewportGeometry, ScreenSpacePosition)
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  if not self.InventoryController or not self.InventoryController.bInit then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
  if not self.PC or not IsValid(self.PC) then
    self.PC = self:GetOwningPlayer()
  end
  local ViewportGeometry = UE4.UWidgetLayoutLibrary.GetViewportWidgetGeometry(self.PC)
  self.CurTouchPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(ViewportGeometry, ScreenSpacePosition)
  self.ScreenSpacePositionTouchPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnTouchEnded(MyGeometry, InTouchEvent, bGridEnd)
  self.CurTouchPos = nil
  self.ScreenSpacePositionTouchPos = nil
  if self.InventoryController.DragWidget and self.InventoryController.bDraging then
    if self.Btn_Recycle and self.Btn_Recycle.CurState == InventoryCommonConst.RecycleBtnState.DragingOver then
      return
    end
    if not bGridEnd then
      self.InventoryController:CustomOnDragCancelled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
