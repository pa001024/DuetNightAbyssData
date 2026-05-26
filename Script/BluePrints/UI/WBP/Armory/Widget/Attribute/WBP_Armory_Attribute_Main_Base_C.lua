require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  Params = Params or {}
  Params.Parent = self
  AudioManager(self):PlayUISound(self, "event:/ui/common/role_prop_change_page_in", "", nil)
  self.WBP_Armory_Attribute_Main:Init(Params)
  self.WBP_Armory_Attribute_Main:PlayInAnim()
end

function M:OnBackBtnClicked()
  self:Close()
end

return M
