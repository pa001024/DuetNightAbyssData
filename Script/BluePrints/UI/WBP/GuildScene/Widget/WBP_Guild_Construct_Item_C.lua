require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.UnitId = nil
end

function M:OnListItemObjectSet(Content)
  self.UnitId = Content.UnitId
  local Text = DataMgr.GuildItem[self.UnitId].Name
  self.Text:SetText(Text)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.RightMouseButton) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  return UE4.UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, UE4.EKeys.LeftMouseButton)
end

function M:CreatePayload()
  local Payload = NewObject(UIUtils.GetCommonItemContentClass())
  Payload.UnitId = self.UnitId
  return Payload
end

function M:OnDragDetected(MyGeometry, PointerEvent)
  local Op = NewObject(UIUtils.GetCommonDragDropOperationClass())
  Op.Tag = "WBP_Com_Item_Universal_L_C"
  Op.DefaultDragVisual = self
  Op.Pivot = UE4.EDragPivot.MouseDown
  Op.Payload = self:CreatePayload()
  return Op
end

return M
