local EMLuaConst = {
  EMRandomSubSystem_MaxNumber = 10000,
  EMRandomSubSystem_MaxNumberPerTick = 1000,
  EMRandomSubSystem_TickInterval = 5
}
local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName()
EMLuaConst.EnableClientRpcDelay = Const.EnableClientRpcDelay
EMLuaConst.PushMonsterOptimizationLevel = Const.PushMonsterOptimizationLevel
EMLuaConst.BeginRagdollExecutePreFrame_PC = Const.BeginRagdollExecutePreFrame_PC
EMLuaConst.BeginRagdollExecutePreFrame_IOS = Const.BeginRagdollExecutePreFrame_IOS
EMLuaConst.BeginRagdollExecutePreFrame_Android = Const.BeginRagdollExecutePreFrame_Android
EMLuaConst.bPlayerMoveDefferUpdateOverlap = true
if "Android" == PlatformName then
  EMLuaConst.bPlayerPreloadSummon = Const.PlayerPreloadSummon_Android
  EMLuaConst.bSummonDeadCache = Const.SummonDeadCache_Android
  EMLuaConst.NPCDeadCache = Const.NPCDeadCache_Andriod
elseif "IOS" == PlatformName then
  EMLuaConst.bPlayerPreloadSummon = Const.PlayerPreloadSummon_IOS
  EMLuaConst.bSummonDeadCache = Const.SummonDeadCache_IOS
  EMLuaConst.NPCDeadCache = Const.NPCDeadCache_IOS
else
  EMLuaConst.bPlayerPreloadSummon = Const.PlayerPreloadSummon_Windows
  EMLuaConst.bSummonDeadCache = Const.SummonDeadCache_Windows
  EMLuaConst.NPCDeadCache = Const.NPCDeadCache_Win
end
EMLuaConst.bALSameLM = Const.bALSameLM
EMLuaConst.bCNPCDelHide = Const.CNPCDelHide
if "Android" == PlatformName or "IOS" == PlatformName then
  EMLuaConst.bCustomNPCUseSignificanceOpt = false
end
EMLuaConst.AndroidPreloadCoefficient = 1.2
EMLuaConst.PcPreloadCoefficient = 1.0
EMLuaConst.IosPreloadCoefficient = 1.0
EMLuaConst.RegionPreloadSupportSceneId = Const.RegionPreloadSupportSceneId
EMLuaConst.RegionStoryPreloadSupportSceneId = Const.RegionStoryPreloadSupportSceneId
EMLuaConst.EnableCacheSummonID = Const.EnableCacheSummonID
EMLuaConst.SkillCreatureSpeed = Const.SkillCreatureSpeed
EMLuaConst.DecalHeight = 2000
EMLuaConst.DefaultSkillLevel = Const.DefaultSkillLevel
EMLuaConst.DefaultSkillGrade = Const.DefaultSkillGrade
EMLuaConst.DefaultPhantomSkillLevel = Const.DefaultPhantomSkillLevel
EMLuaConst.DefaultPhantomSkillGrade = Const.DefaultPhantomSkillGrade
EMLuaConst.ChargingFPS = 27
EMLuaConst.CheckTimeAccelerationInterval = CommonConst.CheckTimeAccelerationInterval
EMLuaConst.bShowDamageDetails = Const.bShowDamageDetails
EMLuaConst.SkillFeatureEndCameraBlendType = EViewTargetBlendFunction.VTBlend_Linear
EMLuaConst.EnableHitDelay = false
EMLuaConst.IsOpenNpcInitOpt = Const.IsOpenNpcInitOpt
EMLuaConst.IsNpcUseNavFixPawnLoc = Const.IsNpcUseNavFixPawnLoc
EMLuaConst.EnableDynamicAIController = Const.EnableDynamicAIController
EMLuaConst.EnableMonDeathOptimization = Const.bEnableMonDeathOptimization
EMLuaConst.FlyAIControllerPath = Const.FlyAIControllerPath
EMLuaConst.MonsterNeedCache = Const.MonsterNeedCache
EMLuaConst.bSpawnAIUnitAddToEventQueue = Const.bSpawnAIUnitAddToEventQueue
EMLuaConst.RegionPlayerInterType = "Biography"
EMLuaConst.RegionPlayerInterId = 100032
EMLuaConst.bCloseWeaponMovementSync = Const.bCloseWeaponMovementSync
EMLuaConst.bCloseBodyAccessoryItemMovementSync = Const.bCloseBodyAccessoryItemMovementSync
EMLuaConst.bWeaponAndAccessoryItemHcc = Const.bWeaponAndAccessoryItemHcc
EMLuaConst.bMonsterInitByPropertySync = Const.bMonsterInitByPropertySync
EMLuaConst.IsOpenNetMultiClientOnly = Const.IsOpenNetMultiClientOnly
EMLuaConst.OpenLookAtProtect = Const.OpenLookAtProtect
EMLuaConst.bOpenPropertyEncryption = true
EMLuaConst.AntiCheat_MonsterGatherWhiteListChars = {1502}
EMLuaConst.OpenCheckHPLock = false
EMLuaConst.bOpenComputeDotBuff = false
EMLuaConst.DungeonCheckMonsterZLocDist = 40000.0
EMLuaConst.SyncNavModiferCullIsolatedTileNums = 1
EMLuaConst.bEnableAndroidBackgroundLua = false
EMLuaConst.bEnableIOSBackgroundLua = true
EMLuaConst.IsShowRayCreature = Const.IsShowRayCreature
EMLuaConst.IsOpenBulletCreature = Const.IsOpenBulletCreature
EMLuaConst.IsOpenSkillCreature = Const.IsOpenSkillCreature
EMLuaConst.IsOpenCreatureECS = Const.IsOpenCreatureECS
EMLuaConst.MaxFilterDisSquare = 225000000
EMLuaConst.bOpenComputeBattleAchievement = false
EMLuaConst.MaxBatteryOneChar = Const.MaxBatteryOneChar
EMLuaConst.MaxCrackKeyOneChar = Const.MaxCrackKeyOneChar
EMLuaConst.DungeonFrameLoadBreakableItemMaxNum = Const.DungeonFrameLoadBreakableItemMaxNum
EMLuaConst.bEnablePlayerRootMotionOptimizations = Const.bEnablePlayerRootMotionOptimizations
EMLuaConst.OpenCritCompute = true
EMLuaConst.OpenHatredCompute = true
EMLuaConst.bIsEnableHotUpdate = true
EMLuaConst.HotUpdateServerIdStr = "Default"
EMLuaConst.PCInterativeTickCount = 5
EMLuaConst.MobileInterativeTickCount = 3
EMLuaConst.bEnableHideRegionPlayer = true
EMLuaConst.RagdollClientMotorsAngularDriveParams = 1000
EMLuaConst.LowMemoryDeviceNPCOptimize = Const.LowMemoryDeviceNPCOptimize
EMLuaConst.FootstepFXSlowSpeed = Const.FootstepFXSlowSpeed
EMLuaConst.FootstepFXFastSpeed = Const.FootstepFXFastSpeed
EMLuaConst.OnlineNPCCreateOptimize = Const.OnlineNPCCreateOptimize
EMLuaConst.LimitCreateCharacterNum_Low = 0
EMLuaConst.HighFrequencyCheckGCInterval = 2
EMLuaConst.bEnableClientMonsterOptimization = true
EMLuaConst.RegionSyncSubsysEnable = true
EMLuaConst.bSplitFrame_RefreshBloodBar = true
EMLuaConst.SplitFrame_RefreshBloodBar_MaxTimes = 16
EMLuaConst.bAutoChoosePhysicsAssetForOptimization = true
EMLuaConst.bForceChoosePhysicsAssetOriginal = false
EMLuaConst.bForceChoosePhysicsAssetLite = false
EMLuaConst.bForceChoosePhysicsAssetMinimal = false
EMLuaConst.bEnablePCGlobalAnimCache = false
EMLuaConst.bEnableRegionAnimCache = true
EMLuaConst.bEnableAnimCacheAsyncLoad = false
EMLuaConst.bEnableSummonAnimCache = true
EMLuaConst.bMonEnableExecuteInLuaDelegate = false
EMLuaConst.bEnableAnimCacheRootMotion = true
EMLuaConst.RootMotionSampleInterval = 1
EMLuaConst.bMoveOpt_SkipSlideMove = true
EMLuaConst.bMoveOpt_SkipRVONavigationCheck = true
EMLuaConst.bMoveOpt_SweepIgnoreStatic = false
EMLuaConst.bAsyncMonMovement = false
EMLuaConst.bAsyncMonMoveTickInPhysThread = false
EMLuaConst.EnableComputeThreadTick = true
EMLuaConst.bEnableRegionPlayerUnitBudget = true
EMLuaConst.bEnableLimitCreateCharacterNumDefault = false
EMLuaConst.HookEllipsePCX = 0.74
EMLuaConst.HookEllipsePCY = 0.82
EMLuaConst.HookEllipseMoblieX = 0.82
EMLuaConst.HookEllipseMoblieY = 0.95
EMLuaConst.bShouldMobileReplacePath = true
EMLuaConst.MapPCReplacePath = "Maps"
EMLuaConst.MapMobileReplacePath = "Maps_Phone"
EMLuaConst.bConditionalSkipMonsterReplication = true
return setmetatable({}, {
  __index = function(t, k)
    local v = rawget(EMLuaConst, k)
    if v then
      return v
    end
    local EMLuaConstCpp = rawget(t, "EMLuaConstCpp")
    return EMLuaConstCpp.TempVars[k]
  end,
  __newindex = function(t, k, v)
    EMLuaConst[k] = v
    local EMLuaConstCpp = rawget(t, "EMLuaConstCpp")
    if EMLuaConstCpp then
      EMLuaConstCpp:RefreshVars()
    end
  end,
  __pairs = function(t)
    return pairs(EMLuaConst)
  end
})
