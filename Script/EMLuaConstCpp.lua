local EMLuaConst = require("EMLuaConst")
local EMLuaConstCpp = Class()

function EMLuaConstCpp:FillVars()
  for Key, Value in pairs(EMLuaConst) do
    if "_DamageAttrThresholdSubIdToTimeThresh" ~= Key then
      self.TempVars[Key] = Value
    end
  end
  local damageAttrThreshold = self.TempVars.DamageAttrThreshold
  local subIdToTimeThresh = EMLuaConst._DamageAttrThresholdSubIdToTimeThresh
  if damageAttrThreshold and subIdToTimeThresh then
    damageAttrThreshold.SubIdToTimeThresh = subIdToTimeThresh
  end
  rawset(EMLuaConst, "EMLuaConstCpp", self)
end

return EMLuaConstCpp
