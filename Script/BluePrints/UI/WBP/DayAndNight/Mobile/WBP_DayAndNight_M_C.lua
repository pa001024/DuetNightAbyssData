require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.DayAndNight.DayAndNightPageBaseView"
}

function M:Construct()
  ScreenPrint("WBP_DayAndNight_M_C:Construct")
  local TabInfo = {
    Tabs = self.AllTabInfo,
    DynamicNode = {
      "Back",
      "Tip",
      "BottomKey"
    },
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    StyleName = "Text",
    OwnerPanel = self,
    TitleName = GText("UI_SetTime_Title"),
    BackCallback = self.OnReturnKeyDown
  }
  self.WBP_Com_Tab_M:Init(TabInfo)
end

AssembleComponents(M)
return M
