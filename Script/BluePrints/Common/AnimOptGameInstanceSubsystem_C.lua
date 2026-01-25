require("Unlua")
require("Const")
local M = Class()

function M:Initialize_Lua()
  self.SystemEnableState = 1
  self.CacheFrameDeltaSeconds = 0.033333
  self.bDebugBonesTrans = false
  self.bDebugCachedTrans = false
  self.DebugCacheTransType = 4
  self.BodyFilterBoneName = "Spine_02"
  self.InitialMeshTickInterval = 0.05
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
  if string.lower(PlatformName) == CommonConst.CHANNEL_OS.ANDROID or string.lower(PlatformName) == CommonConst.CHANNEL_OS.IOS then
    UE4.URuntimeCommonFunctionLibrary.EnableGlobalAnimCache(self, true)
  end
end

return M
