require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditChoosePageBase"
})

function M:InitChoosePage(EditRootController, ChooseMode, Params)
  self.Super.InitChoosePage(self, EditRootController, ChooseMode, Params)
  self.Common_Sort_List:SetControllerKeyHidden(true)
end

function M:_GetChoosePageTabWidget()
  return self.Com_Tab
end

function M:OnSortListAddedToFocusPath()
  self.Common_Sort_List:SetControllerKeyHidden(true)
  if self.EMListView_Filter and UIUtils.HasAnyFocus(self.EMListView_Filter) then
    self.LastFocusList = self.EMListView_Filter
    return
  end
  self.LastFocusList = self.TileView_Select_Role
end

function M:OnSortListRemovedFromFocusPath()
  self.Common_Sort_List:SetControllerKeyHidden(true)
end

return M
