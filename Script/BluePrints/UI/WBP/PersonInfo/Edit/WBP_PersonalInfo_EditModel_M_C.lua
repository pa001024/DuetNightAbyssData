require("UnLua")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_Base_C")
local M = Class({
  "BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_Base_C"
})

function M:OnTouchStarted(MyGeometry, InTouchEvent)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

return M
