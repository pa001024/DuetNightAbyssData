require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Announcement.NewView.WBP_Announcement_Main_C"
})

function M:InitUIInfo(...)
  M.Super.InitUIInfo(self, ...)
  self:AddDispatcher(EventID.LoadUI, self, function(UIName)
    if UIName ~= self:GetUIConfigName() then
      self.WebContent:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end)
  self:AddDispatcher(EventID.UnLoadUI, self, function(UIName)
    if UIName ~= self:GetUIConfigName() then
      self.WebContent:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  end)
end

return M
