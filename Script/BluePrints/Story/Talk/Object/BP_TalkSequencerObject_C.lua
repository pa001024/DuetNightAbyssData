local M = Class()

function M:SetInSkip(bInSkip)
  self.bInSkip = bInSkip
end

function M:IsInSkip()
  return self.bInSkip
end

return M
