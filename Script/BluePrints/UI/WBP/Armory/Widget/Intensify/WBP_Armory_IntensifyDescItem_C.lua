require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.IntensifyItem.Text_Ability:SetText(GText("UI_Ability"))
end

function M:OnListItemObjectSet(Content)
  if not Content.Desc then
    self.Text_Detail:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Text_Detail:SetText(Content.Desc)
  end
  if Content.bEnhanced then
    self.IntensifyItem.Num_Now:SetVisibility(UIConst.VisibilityOp.Hidden)
    self.IntensifyItem.Icon_Arrow:SetVisibility(UIConst.VisibilityOp.Hidden)
    self.IntensifyItem.Icon_Up:SetVisibility(UIConst.VisibilityOp.Hidden)
  end
  self.IntensifyItem.Text_Atrr:SetText("·" .. Content.Name)
  self.IntensifyItem.Num_Now:SetText(Content.Value)
  self.IntensifyItem.Num_Preview:SetText(Content.CmpValue)
  if self.IntensifyItem.Text_Extra_Now and self.IntensifyItem.Text_Extra_Preview then
    local ExtraLevel = Content.ExtraLevel
    if ExtraLevel and ExtraLevel > 0 and not Content.bEnhanced then
      self.IntensifyItem.Text_Extra_Now:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.IntensifyItem.Text_Extra_Now:SetText(string.format(GText("Pet_Affix_LevelAdd"), ExtraLevel))
      self.IntensifyItem.Text_Extra_Preview:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.IntensifyItem.Text_Extra_Preview:SetText(string.format(GText("Pet_Affix_LevelAdd"), ExtraLevel))
    elseif ExtraLevel and ExtraLevel > 0 and Content.bEnhanced then
      self.IntensifyItem.Text_Extra_Now:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.IntensifyItem.Text_Extra_Preview:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.IntensifyItem.Text_Extra_Preview:SetText(string.format(GText("Pet_Affix_LevelAdd"), ExtraLevel))
    elseif not ExtraLevel or ExtraLevel <= 0 then
      self.IntensifyItem.Text_Extra_Now:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

return M
