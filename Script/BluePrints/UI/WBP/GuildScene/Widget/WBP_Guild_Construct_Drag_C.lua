require("UnLua")
require("DataMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bIsFocusable = true
  self.Btn_Drag.bIsFocusable = true
  self.Btn_Copy.bIsFocusable = true
  self:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:RefreshData()
  if self.Btn_Drag and self.Btn_Drag.RefreshData then
    self.Btn_Drag:RefreshData()
  end
  if self.Btn_Copy and self.Btn_Copy.RefreshData then
    self.Btn_Copy:RefreshData()
  end
end

function M:InitParent(InParent)
  self.Parent = InParent
  if self.Btn_Drag.InitParent then
    self.Btn_Drag:InitParent(InParent)
  end
  if self.Btn_Copy.InitParent then
    self.Btn_Copy.InitParent(InParent)
  end
end

return M
