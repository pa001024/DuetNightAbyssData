require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Content = Content
  if not Content then
    DebugPrint("WeatherItem Content is nil")
    return
  end
  self.Content.CurrentEntry = self
  self:BindClickEvent()
  self:RefreshDisplay()
  self:SetSelected(self.Content.bSelected)
end

function M:BindClickEvent()
  if self.bClickEventBound or not self.BtnArea then
    return
  end
  self.BtnArea.OnCheckStateChanged:Add(self, self.OnBtnAreaClicked)
  self.bClickEventBound = true
end

function M:OnBtnAreaClicked()
  if not self.Content then
    return
  end
  if self.Content.Parent and self.Content.Parent.OnWeatherItemClicked then
    self.Content.Parent:OnWeatherItemClicked(self.Content)
  end
end

function M:RefreshDisplay()
  if not self.Content then
    return
  end
  if self.Image_Icon and self.Content.Path then
    local IconObj = LoadObject(self.Content.Path)
    if IconObj then
      self.Image_Icon:SetBrushResourceObject(IconObj)
    end
  end
  local bLocked = self.Content.bLocked or false
  if self.Image_Lock then
    self.Image_Lock:SetVisibility(bLocked and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
  end
end

function M:SetSelected(bSelected)
  if not self.Content then
    return
  end
  self.Content.bSelected = bSelected
  if bSelected then
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.BtnArea:SetCheckedNoNotify(bSelected)
end

return M
