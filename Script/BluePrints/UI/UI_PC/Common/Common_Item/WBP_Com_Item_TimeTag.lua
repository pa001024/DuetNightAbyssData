require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:SetUpTimeTag(TimeTagList)
  local AllChildren = self.HB_TimeTag:GetAllChildren()
  local ChildCount = AllChildren:Length()
  for _, TimeTagUI in ipairs(AllChildren) do
    TimeTagUI:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  for i, TimeTag in ipairs(TimeTagList) do
    if i > ChildCount then
      break
    end
    local TimeTagUI = self.HB_TimeTag:GetChildAt(i - 1)
    if not TimeTagUI then
      break
    end
    TimeTagUI:SetVisibility(UIConst.VisibilityOp.Visible)
    TimeTagUI.WS_DayAndNight:SetActiveWidgetIndex(TimeTag - 1)
  end
end

return M
