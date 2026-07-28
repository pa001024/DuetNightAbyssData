require("Unlua")
require("Const")
local M = Class()

function M:Initialize_Lua()
  self.CacheFrameDeltaSeconds = 0.033333
  self.bDebugBonesTrans = false
  self.bDebugCachedTrans = false
  self.DebugCacheTransType = 4
  self.BodyFilterBoneName = "Spine_02"
  self.InitialMeshTickInterval = 0.05
end

function M:AnimCachePhysErrorReset_Lua(MeshComp)
  if MeshComp then
    local Mon = MeshComp:GetOwner()
    if Mon and Mon.PhysStateErrorReset_Lua then
      Mon:PhysStateErrorReset_Lua()
    end
  end
end

return M
