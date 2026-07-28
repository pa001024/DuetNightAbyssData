local M = Class({
  "BluePrints.UI.WBP.Memory.WBP_Memory_Main_C"
})

function M:Construct()
  if M.Super.Construct then
    M.Super.Construct(self)
  end
end

function M:Destruct()
  if M.Super.Destruct then
    M.Super.Destruct(self)
  end
end

function M:OnLoaded(...)
  if M.Super.OnLoaded then
    M.Super.OnLoaded(self, ...)
  end
end

function M:OnEndClose()
  if M.Super.OnEndClose then
    M.Super.OnEndClose(self)
  end
end

return M
