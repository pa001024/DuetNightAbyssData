require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Construct()
  self.Btn_Click:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
  self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
  self.Btn_Click.OnClicked:Add(self, self.OnMouseButtonDown)
end

function M:OnPressed()
  Utils.ScreenPrint("pressed")
end

function M:OnBtnPressed()
  self.bPressed = true
  Utils.ScreenPrint("BtnPressed")
end

function M:OnBtnReleased()
  self.bPressed = false
  Utils.ScreenPrint("BtnReleased")
end

function M:TestClick()
  Utils.ScreenPrint("2")
end

function M:OnListItemObjectSet(Content)
  self.UnitId = Content.UnitId
  self.Count = Content.Count
  self.PlacedCallBack = Content.PlacedCallBack
  ScreenPrint("444")
  ScreenPrint(self.PlacedCallBack)
  local Name = Content.Name
  local IconPath = Content.Icon
  local Count = Content.Count
  UResourceLibrary.LoadObjectAsync(self, IconPath, {
    self,
    function(_, Icon)
      self.Icon:SetBrushResourceObject(Icon)
    end
  })
  self.Text_Name:SetText(GText(Name))
  if Count <= 1 then
    self:PlayAnimation(self.Lock)
    return
  end
  self:PlayAnimation(self.In)
  self.Text_Num:SetText(tostring(Count))
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  Utils.ScreenPrint("OnMouseButtonDown")
  if self.ItemDetailsMenuAnchor then
    local Content = {
      ItemType = "GuildConstruct",
      bHideGamePad = true,
      UnitId = self.UnitId,
      LeftNum = self.Count,
      PlacedNum = 8,
      MenuPlacement = EMenuPlacement.MenuPlacement_AboveAnchor,
      PlaceCallback = self.PlacedCallBack
    }
    ScreenPrint(Content.PlaceCallback)
    self.ItemDetailsMenuAnchor:OpenItemDetailsWidget(false, Content)
  end
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
