require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function M:Construct()
  self.Super.Construct(self, self.Btn_Click)
end

function M:Destruct()
  self.Super.Destruct(self)
end

function M:SwitchNormalAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

return M
