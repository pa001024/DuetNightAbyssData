require("UnLua")
require("BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_Base_C")
local M = Class({
  "BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_Base_C"
})
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditModel_P_GamepadComp"
}
AssembleComponents(M)
return M
