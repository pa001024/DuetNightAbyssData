require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(Parent)
  self.Parent = Parent
end

function M:Change_List()
  self.Parent:UpdatePage()
end

return M
