local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  if self.Text_Attribute then
    self.Text_Attribute:SetText(GText("UI_SuggestAttribute"))
  end
end

function M:SetAttrByAttrId(AttrId)
  if not self.Attribute then
    return
  end
  local AttrData = AttrId and DataMgr.Attribute[AttrId]
  if self.Text_RecommendAttribute and AttrData then
    self.Text_RecommendAttribute:SetText(GText(AttrData.Textmap))
    local Color = self["Color_" .. AttrId]
    if Color then
      self.Text_RecommendAttribute:SetColorAndOpacity(Color)
    end
  end
  local IconPath = AttrData and AttrData.Icon
  if not IconPath then
    return
  end
  local IconObj = LoadObject(IconPath)
  if IsValid(IconObj) then
    self.Attribute:SetBrushResourceObject(IconObj)
  end
  self:PlayAnimation(self.Change)
end

return M
