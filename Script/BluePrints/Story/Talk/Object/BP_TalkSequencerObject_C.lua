local M = Class()

function M:SetInSkip(bInSkip)
  if bInSkip then
    self:EnterSkip()
  else
    self:ExitSkip()
  end
end

function M:EnterSkip()
  self.SkipCount = (self.SkipCount or 0) + 1
end

function M:ExitSkip()
  self.SkipCount = math.max(0, (self.SkipCount or 1) - 1)
end

function M:ClearSkip()
  self.SkipCount = 0
end

function M:IsInSkip()
  return (self.SkipCount or 0) > 0
end

return M
