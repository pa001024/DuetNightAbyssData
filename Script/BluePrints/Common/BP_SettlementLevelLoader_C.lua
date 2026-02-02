local M = Class("BluePrints.Common.EMLevelLoader")

function M:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  self:InitEnvironment()
end

return M
