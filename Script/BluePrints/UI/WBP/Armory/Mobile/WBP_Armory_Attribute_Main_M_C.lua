require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Armory.Widget.Attribute.WBP_Armory_Attribute_Main_Base_C"
})

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  self.WBP_Com_Tab_M:Init({
    DynamicNode = {"Back"},
    BackCallback = self.OnBackBtnClicked,
    OwnerPanel = self,
    TitleName = GText("UI_Switch_Attribute")
  }, true)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
end

return M
