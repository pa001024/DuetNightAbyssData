local MonthSignInController = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInController")
local TimeUtils = require("Utils.TimeUtils")
local Component = {}

function Component:MonthlyCheckGetReward(CheckCount, Callback)
  self.logger.info("MonthlyCheckGetReward", CheckCount)
  self:CallServer("MonthlyCheckGetReward", Callback, CheckCount)
end

function Component:MonthlyCheckGetTotalReward(Step, Callback)
  self.logger.info("MonthlyCheckGetTotalReward", Step)
  self:CallServer("MonthlyCheckGetTotalReward", Callback, Step)
end

function Component:_OnPropChangeMonthlyCheck()
  DebugPrint("Yihan@ _OnPropChangeMonthlyCheck")
  MonthSignInController:TryPopUpMonthSignIn()
end

function Component:EnterWorld()
  MonthSignInController:Init()
end

function Component:LeaveWorld()
  MonthSignInController:Destory()
end

return Component
