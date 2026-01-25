local M = Class()

function M:StartSit(Character, bImmediate)
  if not Character then
    return
  end
  DebugPrint("WXT SitSection StartSit", Character.UnitId, bImmediate)
  Character:SetSitPoseWithoutInteractive(function()
    DebugPrint("WXT SitSection StartSit ->End", Character.UnitId, bImmediate)
  end, bImmediate)
end

function M:SitEnd(Character, bImmediate)
  if not Character then
    return
  end
  DebugPrint("WXT SitSection SitEnd", Character.UnitId, bImmediate)
  Character:RealSetIdlePoseBySpecialSit(function()
    DebugPrint("WXT SitSection SitEnd ->End", Character.UnitId, bImmediate)
  end, bImmediate)
end

return M
