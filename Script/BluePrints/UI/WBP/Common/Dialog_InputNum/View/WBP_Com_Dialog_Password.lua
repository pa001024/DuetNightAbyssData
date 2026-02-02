require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bIsMasked = true
  if self.Btn_Visible then
    self.Btn_Visible:BindEventOnClicked(self, self.OnEyeClick)
  end
  self:UpdateEyeIcon()
end

function M:OnListItemObjectSet(Item)
  if not Item then
    return
  end
  self.ItemData = Item.ItemData
  if self.ItemData then
    if self.ItemData.ParentPanel then
      self.ItemData.ParentPanel:RegisterRowWidget(self.ItemData.RowIndex, self)
    end
    if self.Text_Desc then
      self.Text_Desc:SetText(self.ItemData.DescText)
    end
    self:RefreshView(self.ItemData.Text)
  end
end

function M:RefreshView(Text)
  self.CachedText = Text or ""
  if self.Password and self.Password.UpdateGrid then
    self.Password:UpdateGrid(self.CachedText, self.bIsMasked)
  end
end

function M:OnEyeClick()
  self.bIsMasked = not self.bIsMasked
  self:UpdateEyeIcon()
  self:RefreshView(self.CachedText)
end

function M:UpdateEyeIcon()
  if self.WS_Visible then
    self.WS_Visible:SetActiveWidgetIndex(self.bIsMasked and 1 or 0)
  end
end

return M
