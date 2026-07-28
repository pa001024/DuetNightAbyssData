require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditScenePageBase"
})
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditScence_P_GamepadComp"
}
AssembleComponents(M)
return M
