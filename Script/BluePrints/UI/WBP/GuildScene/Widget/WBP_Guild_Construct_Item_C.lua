require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.ActorClassPath = nil
end

function M:OnListItemObjectSet(Content)
  local HeadSculpture = LoadObject(Content.IconPath)
  self.Image_Icon:SetBrushFromTexture(HeadSculpture)
  self.ActorClassPath = Content.ActorClassPath
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.RightMouseButton) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  return UE4.UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, UE4.EKeys.LeftMouseButton)
end

function M:CreatePayload()
  local Payload = NewObject(UIUtils.GetCommonItemContentClass())
  Payload.ActorClassPath = self.ActorClassPath
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
