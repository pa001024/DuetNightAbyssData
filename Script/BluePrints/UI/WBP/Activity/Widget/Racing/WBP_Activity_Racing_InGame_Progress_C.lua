require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:SetProgressPercent(0)
end

function M:SetProgressPercent(Value)
  self.Progress:SetPercent(Value)
end

return M
