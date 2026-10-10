require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Common.FilterSort.WBP_Com_SortDown_C"
})

function M:SetListForbidden(bForbidden)
  self.IsListForbidden = bForbidden and true or false
  if self.IsListForbidden and self.IsListViewOpened then
    self:OnListClosed()
  end
end

function M:GetListForbidden()
  return self.IsListForbidden == true
end

function M:ListOpenBtnClicked(bForce)
  if self.IsListForbidden then
    return
  end
  M.Super.ListOpenBtnClicked(self, bForce)
end

function M:OnBtn_Filter_List_Pressed()
  if self.IsListForbidden then
    return
  end
  M.Super.OnBtn_Filter_List_Pressed(self)
end

function M:OnBtn_Filter_List_Hovered()
  if self.IsListForbidden then
    return
  end
  M.Super.OnBtn_Filter_List_Hovered(self)
end

function M:OnBtn_Filter_List_Unhovered()
  if self.IsListForbidden then
    return
  end
  M.Super.OnBtn_Filter_List_Unhovered(self)
end

return M
