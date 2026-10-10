require("UnLua")
local M = Class()

function M:GetDSNeverDirtyAttr_Lua()
  return {
    "AttackRange_Bullet",
    "AttackRange_Normal",
    "SkillRange",
    "SupportSkillCD"
  }
end

return M
