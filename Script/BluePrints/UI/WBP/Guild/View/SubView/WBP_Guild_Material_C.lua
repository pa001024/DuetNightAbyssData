require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnClicked)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.CurrentEntry = self
  if not self.Btn_Click.OnCheckStateChanged:IsBound() then
    self.Btn_Click.OnCheckStateChanged:Add(self, self.OnSelected)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
  end
  if Content.bSelected then
    self.Btn_Click:SetChecked(true)
  else
    self.Btn_Click:SetChecked(false)
  end
  self:InitData(Content)
end

function M:OnHovered()
  if UIUtils.UtilsGetCurrentInputType() ~= UE4.ECommonInputType.Gamepad then
    return
  end
  if self.Content.Parent.IsTabRefreshing then
    return
  end
  self.Content.bSelected = true
  self:OnClicked()
  self.Btn_Click:SetChecked(true)
end

function M:OnSelected(bIsChecked)
  if not self.Content then
    DebugPrint("Content is nil, cannot clear list item object.")
    return
  end
  self.Content.bSelected = bIsChecked
  if bIsChecked then
    self.Content.Parent:OnMaterialSelected(self.Content)
  elseif self.Content.Parent.CurrentMaterialSelectedContent == self.Content then
    self:SetSelected(true)
  end
end

function M:SetSelected(bIsChecked)
  self.Btn_Click:SetChecked(bIsChecked)
end

function M:InitData(Content)
  if Content.MaterialIcon then
    self.WS_Type:SetActiveWidgetIndex(0)
    self.WS_Material:SetActiveWidgetIndex(0)
    self.Icon_Material:SetBrushResourceObject(LoadObject(Content.MaterialIcon))
  elseif Content.IsDefault then
    self.WS_Type:SetActiveWidgetIndex(0)
    self.WS_Material:SetActiveWidgetIndex(1)
  else
    self.WS_Type:SetActiveWidgetIndex(1)
  end
end

function M:OnClicked()
  self.Content.EditCallbackInfo.Func(self.Content.EditCallbackInfo.Obj, 2, self.Content.MaterialID or self.Content.FlagMaterialID)
end

return M
