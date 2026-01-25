require("UnLua")
local OnlineActionCommon = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.BattleOnlineAction.WBP_Battle_OnlineActionBaseView"
}

function M:Construct()
  self.M = M
  self.Btn_Refresh:SetText(GText("UI_RegionOnline_Refresh"))
  self.Btn_Refuse:SetText(GText("UI_RegionOnline_RefruseAll"))
  self.Btn_Refresh.Button_Area.OnClicked:Add(self, self.OnRefreshAllKeyDown)
  self.Btn_Refuse.Button_Area.OnClicked:Add(self, self.OnRejectAllKeyDown)
end

function M:Tick(MyGeometry, InDeltaTime)
end

AssembleComponents(M)
return M
