local MonthSignInController = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInController")
local TimeUtils = require("Utils.TimeUtils")
local Component = {}

function Component:MonthlyCheckGetTotalReward(Step, Callback)
  self.logger.info("MonthlyCheckGetTotalReward", Step)
  self:CallServer("MonthlyCheckGetTotalReward", Callback, Step)
end

function Component:MonthlyCheckUpdatePopupTime(Callback)
  self.logger.info("MonthlyCheckUpdatePopupTime")
  Callback = Callback or function()
  end
  self:CallServer("MonthlyCheckUpdatePopupTime", Callback)
end

function Component:_OnPropChangeMonthlyCheck()
  local LoginMainPage = UIManager(self):GetUIObj("LoginMainPage")
  if not LoginMainPage then
    MonthSignInController:TryPopUpMonthSignIn()
  end
end

function Component:EnterWorld()
  MonthSignInController:Init()
end

function Component:LeaveWorld()
  MonthSignInController:Destory()
end

return Component
