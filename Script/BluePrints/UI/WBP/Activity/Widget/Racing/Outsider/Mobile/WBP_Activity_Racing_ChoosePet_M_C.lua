require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.View.RacingChoosePetBaseView"
})
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")

function M:Construct()
  self:InitBaseView()
  self.WBP_Activity_Racing_Choose_P.ParentWidget = self
  self.WBP_Activity_Racing_Pet_P.ParentWidget = self
  self:InitTab()
end

function M:InitTab()
  local TabConfigData = {
    PlatformName = "Mobile",
    TitleName = GText(RacingActivityConst.TitleNameText),
    StyleName = "Text",
    DynamicNode = {
      "ResourceBar"
    },
    BackCallback = self.Close,
    OwnerPanel = self,
    OverridenTopResouces = {
      tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
    }
  }
  self.Com_Tab:Init(TabConfigData)
end

function M:Close()
  DebugPrint("Yihan@ Close")
  if self.IsInAnimation then
    return
  end
  M.Super.Close(self)
  self:OnViewClose()
end

return M
