require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local M = Class({
  "BluePrints.UI.WBP.Activity.Widget.Return.ActivityReturnBase",
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Initialize(Initializer)
  self.OwnerPlayer = nil
  self.CurActivityId = nil
  self.ParentTabId = nil
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
  self.Super.InitPage(self, ActivityId, ParentTabId, AllActivityId, ParentWidget)
end

function M:UpdatePage(OperateSrc)
  self.Super.UpdatePage(self, OperateSrc)
end

function M:Destruct()
end

return M
