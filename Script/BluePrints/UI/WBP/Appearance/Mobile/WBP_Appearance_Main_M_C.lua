require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Appearance.WBP_Appearance_Main_Base_C"
})

function M:Construct()
  M.Super.Construct(self)
  self.Btn_Visible:Init({
    ClickCallback = self.OnHideUIKeyDown,
    OwnerWidget = self
  })
end

return M
