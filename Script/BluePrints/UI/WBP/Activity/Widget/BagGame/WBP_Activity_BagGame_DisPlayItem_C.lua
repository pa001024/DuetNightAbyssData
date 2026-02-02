require("UnLua")
local ItemType = {
  Ammo = 1,
  Weapon = 2,
  Equipment = 3,
  Other = 4
}
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.WBP.Activity.Widget.BagGame.Activity_BagGame_DragComponent",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Construct()
  self.bIsDraggable = true
  self.Switch_Type:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:Destruct()
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
  if MouseButton.KeyName == "LeftMouseButton" then
    local Reply = UE4.UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, UE.EKeys.LeftMouseButton)
    return Reply
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:Init(Content, PlayScreen)
  self.Content = Content
  self.DisPlayItemId = Content.Id
  self.PlayScreen = PlayScreen
  self.Type = Content.Type
  self.ShapeOffsets = Content.ShapeOffsets or {
    {0, 0}
  }
end

function M:SetAmmoNumber(AmmoNum, AmmoMaxNumber)
  self.AmmoNumber = AmmoNum
  if self.Type == ItemType.Ammo then
    self.Text_Lable_1:SetText(AmmoNum)
  else
    self.Text_Lable_1:SetText(AmmoNum .. "/" .. AmmoMaxNumber)
  end
end

function M:SetScoreNumber(ScoreNum)
  self.Text_ScoreNum_1:SetText(ScoreNum)
end

function M:OnDragDetected(MyGeometry, PointerEvent)
  return self:OnDragDetectedComponent(MyGeometry, PointerEvent, self.DisPlayItemId, self.ShapeOffsets)
end

function M:OnDragLeave(MyGeometry, PointerEvent, Operation)
end

function M:OnDragCancelled(MyGeometry, PointerEvent, Operation)
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)
end

return M
