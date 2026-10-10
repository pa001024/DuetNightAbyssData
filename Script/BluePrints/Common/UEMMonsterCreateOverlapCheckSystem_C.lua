require("Unlua")
require("Const")
local M = Class()

function M:DebugPrintRegisteredNum()
  DebugPrint("[MonsterCreateOverlapCheck] RegisteredNum = " .. tostring(self:GetRegisteredNum()))
end

return M
