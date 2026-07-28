local UIUtils = require("Utils.UIUtils")
local View = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function View:InitView(TitleName, Value, PreviewValue, bAnim)
  self:StopAllAnimations()
  self.Text_Name:SetText(TitleName)
  self.Value = Value
  if not Value or string.isempty(Value) or 0 == Value then
    self.Text_Num:SetText("-")
  elseif type(Value) == "number" then
    self.Text_Num:SetText(string.format("%.0f", Value))
  else
    self.Text_Num:SetText(Value)
  end
  self:HidePreview()
  Value = tonumber(Value)
  if PreviewValue and Value and PreviewValue ~= Value then
    self.Image_Arrow:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Num_Y:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Image_Up:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Num_Y:SetText(string.format("%.0f", PreviewValue))
    if PreviewValue > Value then
      self.Image_Up:SetBrushTintColor(self.GreenColor)
      self.Text_Num_Y:SetColorAndOpacity(self.GreenColor)
      self.Image_Up:SetRenderScale(FVector2D(1.0, 1.0))
      if bAnim then
        self:PlayAnimation(self.Add)
      end
    else
      self.Image_Up:SetBrushTintColor(self.RedColor)
      self.Text_Num_Y:SetColorAndOpacity(self.RedColor)
      self.Image_Up:SetRenderScale(FVector2D(1.0, -1.0))
      if bAnim then
        self:PlayAnimation(self.Reduce)
      end
    end
  end
end

function View:HidePreview()
  self.Text_Num_Y:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Image_Arrow:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Image_Up:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

return View
