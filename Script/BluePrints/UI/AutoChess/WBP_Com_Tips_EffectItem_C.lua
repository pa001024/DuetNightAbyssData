local UIUtils = require("Utils.UIUtils")
local View = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function View:OnListItemObjectSet(Content)
  if Content.bGreen then
    self.Switch_Type:SetActiveWidgetIndex(2)
    self.Text_Effect01_1:SetText(Content.EffectText)
  else
    self.Switch_Type:SetActiveWidgetIndex(1)
    self.Text_Effect01:SetText(Content.EffectText)
  end
  if Content.PlayAddAnim then
    self:PlayAnimation(self.Add)
  end
end

return View
