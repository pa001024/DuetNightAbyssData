require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:OnAnimationStarted(Animation)
  if not (Animation and self.Btn_Click) or not self.Btn_Click.GetForbidden then
    return
  end
  if not self.Btn_Click:GetForbidden() then
    return
  end
  self:StopAnimation(Animation)
end

return M
