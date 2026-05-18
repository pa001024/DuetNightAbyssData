local Component = {}

function Component:MonthlyCheckGetReward(CheckCount, Callback)
  self.logger.info("MonthlyCheckGetReward", CheckCount)
  self:CallServer("MonthlyCheckGetReward", Callback, CheckCount)
end

function Component:MonthlyCheckGetTotalReward(Step, Callback)
  self.logger.info("MonthlyCheckGetTotalReward", Step)
  self:CallServer("MonthlyCheckGetTotalReward", Callback, Step)
end

return Component
