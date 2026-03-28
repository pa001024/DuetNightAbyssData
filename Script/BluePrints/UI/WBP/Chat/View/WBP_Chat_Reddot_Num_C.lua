require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Play_Refresh()
  if not self.RefreshCallBack then
    return
  end
  self.RefreshCallBack(self)
end

return M
