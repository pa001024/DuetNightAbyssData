require("UnLua")
local M = Class()

function M:OnStateChanged(OldState, NewState)
  local WidgetComp = self.WidgetComponent
  if not WidgetComp then
    return
  end
  local UserWidget = WidgetComp:GetUserWidgetObject()
  if not UserWidget then
    return
  end
  if UserWidget.OnStateChanged then
    UserWidget:OnStateChanged(OldState, NewState)
  end
end

return M
