local Component = {}

function Component:D4SeasonBuffUpgrade(Callback, D4SeasonId, D4SeasonBuffType)
  self.logger.info("D4SeasonBuffUpgrade", D4SeasonId, D4SeasonBuffType)
  Callback = Callback or function()
  end
  self:CallServer("D4SeasonBuffUpgrade", Callback, D4SeasonId, D4SeasonBuffType)
end

return Component
