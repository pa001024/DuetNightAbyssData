require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Appearance.WBP_Appearance_MainWidget_Base_C"
})

function M:Init(Params)
end

function M:OnTabChangeToOther()
  self:PlayOutAnim()
end

function M:OnTabChangeToSelf()
  self:PlayInAnim()
end

function M:OnClose()
  self:PlayOutAnim()
end

function M:PlayInAnim()
  self:StopAnimation(self.Out)
  self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
  self:StopAnimation(self.In)
  self:PlayAnimation(self.Out)
end

return M
