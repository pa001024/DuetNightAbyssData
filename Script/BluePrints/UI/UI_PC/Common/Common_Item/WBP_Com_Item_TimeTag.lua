require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:SetUpTimeTag(TimeTagList)
  for _, TimeTagUI in pairs(self.HB_TimeTag:GetAllChildren()) do
    TimeTagUI:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  for i, TimeTag in ipairs(TimeTagList) do
    local TimeTagUI = self.HB_TimeTag:GetChildAt(i - 1)
    TimeTagUI:SetVisibility(UIConst.VisibilityOp.Visible)
    TimeTagUI.WS_DayAndNight:SetActiveWidgetIndex(TimeTag - 1)
  end
end

return M
