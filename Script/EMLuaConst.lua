local EMLuaConst = {
  EMRandomSubSystem_MaxNumber = 10000,
  EMRandomSubSystem_MaxNumberPerTick = 1000,
  EMRandomSubSystem_TickInterval = 5,
  WindowMinimizedFrameRate = 15
}
local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName()
EMLuaConst.EnableClientRpcDelay = Const.EnableClientRpcDelay
EMLuaConst.HideNormalMonsterBuffIcon = Const.HideNormalMonsterBuffIcon
EMLuaConst.PushMonsterOptimizationLevel = Const.PushMonsterOptimizationLevel
EMLuaConst.BeginRagdollExecutePreFrame_PC = Const.BeginRagdollExecutePreFrame_PC
EMLuaConst.BeginRagdollExecutePreFrame_IOS = Const.BeginRagdollExecutePreFrame_IOS
EMLuaConst.BeginRagdollExecutePreFrame_Android = Const.BeginRagdollExecutePreFrame_Android
EMLuaConst.bPlayerMoveDefferUpdateOverlap = true
EMLuaConst.bEnableAsyncTravelDelay = false
EMLuaConst.bDisableOcclusionInTalk = false
EMLuaConst.KawaiiPhysicsUseSIMD = 0
EMLuaConst.bAIDebugLog = false
if "Android" == PlatformName or "OpenHarmony" == PlatformName then
  EMLuaConst.bPlayerPreloadSummon = Const.PlayerPreloadSummon_Android
  EMLuaConst.bSummonDeadCache = Const.SummonDeadCache_Android
  EMLuaConst.NPCDeadCache = Const.NPCDeadCache_Andriod
elseif "IOS" == PlatformName then
  EMLuaConst.bPlayerPreloadSummon = Const.PlayerPreloadSummon_IOS
  EMLuaConst.bSummonDeadCache = Const.SummonDeadCache_IOS
  EMLuaConst.NPCDeadCache = Const.NPCDeadCache_IOS
  EMLuaConst.bDisableOcclusionInTalk = true
else
  EMLuaConst.bPlayerPreloadSummon = Const.PlayerPreloadSummon_Windows
  EMLuaConst.bSummonDeadCache = Const.SummonDeadCache_Windows
  EMLuaConst.NPCDeadCache = Const.NPCDeadCache_Win
end
EMLuaConst.bALSameLM = Const.bALSameLM
EMLuaConst.bCNPCDelHide = Const.CNPCDelHide
EMLuaConst.bPhantomWCDungeonBornAdjust = false
EMLuaConst.UpdateAllMonsterDead = true
EMLuaConst.bEnablePhysBodyCrashCheck = true
EMLuaConst.bEnableCreateUnitContextCache = true
if "Android" == PlatformName or "IOS" == PlatformName or "OpenHarmony" == PlatformName then
  EMLuaConst.bCustomNPCUseSignificanceOpt = false
end
EMLuaConst.bCustomNPCMoveBalanceTick = Const.bCustomNPCMoveBalanceTick
EMLuaConst.bSingleLoadCNPCHair = true
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
EMLuaConst.EnableHitDelay = true
EMLuaConst.IsOpenCNPCForceShow = Const.IsOpenCNPCForceShow
EMLuaConst.IsOpenCNPCGenPriority = Const.IsOpenCNPCGenPriority
EMLuaConst.IsOpenFlexibleCppOpt = Const.IsOpenFlexibleCppOpt
EMLuaConst.IsOpenFlexibleShowHideCppOpt = Const.IsOpenFlexibleShowHideCppOpt
EMLuaConst.IsOpenNpcInitOpt = Const.IsOpenNpcInitOpt
EMLuaConst.IsOpenNpcGetBattleCharTag = Const.IsOpenNpcGetBattleCharTag
EMLuaConst.IsNpcUseNavFixPawnLoc = Const.IsNpcUseNavFixPawnLoc
EMLuaConst.IsOpenCustomNPCCategory = Const.IsOpenCustomNPCCategory
EMLuaConst.IsOpenEscortNPCPhantomOpt = Const.IsOpenEscortNPCPhantomOpt
EMLuaConst.CNPCOptimizeSpecialLevelName = Const.CNPCOptimizeSpecialLevelName
EMLuaConst.CNPCOptimizeSpecialLevelName1 = Const.CNPCOptimizeSpecialLevelName1
EMLuaConst.CNPCOptimizeSpecialLevelName2 = Const.CNPCOptimizeSpecialLevelName2
EMLuaConst.CNPCOptimizeSpecialLevelName3 = Const.CNPCOptimizeSpecialLevelName3
EMLuaConst.IsOpenCustomNPCDisableCollision = Const.IsOpenCustomNPCDisableCollision
EMLuaConst.IsOpenEXStationCNPCSignifance = Const.IsOpenEXStationCNPCSignifance
EMLuaConst.IsOpenNpcLoadBTAsync = Const.IsOpenNpcLoadBTAsync
EMLuaConst.IsOpenNpcGetPatrolTrigger = Const.IsOpenNpcGetPatrolTrigger
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
EMLuaConst.bEnableWeaponSkinKillFX = false
EMLuaConst.bMonsterInitByPropertySync = Const.bMonsterInitByPropertySync
EMLuaConst.IsOpenNetMultiClientOnly = Const.IsOpenNetMultiClientOnly
EMLuaConst.OpenLookAtProtect = Const.OpenLookAtProtect
EMLuaConst.OpenATKCalcOpt = false
EMLuaConst.AntiCheat_MonsterGatherWhiteListChars = {1502}
EMLuaConst.OpenCheckHPLock = true
EMLuaConst.DungeonCheckMonsterZLocDist = 40000.0
EMLuaConst.SyncNavModiferCullIsolatedTileNums = 1
EMLuaConst.bEnableAndroidBackgroundLua = false
EMLuaConst.bEnableIOSBackgroundLua = false
EMLuaConst.IsShowRayCreature = Const.IsShowRayCreature
EMLuaConst.bUseBodyMeshAsVirtualBoneSource = Const.bUseBodyMeshAsVirtualBoneSource
EMLuaConst.IsOpenBulletCreature = Const.IsOpenBulletCreature
EMLuaConst.IsOpenSkillCreature = Const.IsOpenSkillCreature
EMLuaConst.IsOpenCreatureECS = Const.IsOpenCreatureECS
EMLuaConst.MaxFilterDisSquare = 225000000
EMLuaConst.UseTaskGraphDamageCompute = true
EMLuaConst.UseTaskGraphDamageComputeDebugDelay = false
EMLuaConst.BatchTaskFlushThreshold = 10
EMLuaConst.bOpenComputeBattleAchievement = false
EMLuaConst.bOpenTaskGraphBattleAchievement = false
EMLuaConst.OpenComputeInteractive = true
EMLuaConst.UseFightAttrWorkerDelta = true
EMLuaConst.MaxBatteryOneChar = Const.MaxBatteryOneChar
EMLuaConst.MaxCrackKeyOneChar = Const.MaxCrackKeyOneChar
EMLuaConst.PickAllDropWithoutFly = false
EMLuaConst.DungeonFrameLoadBreakableItemMaxNum = Const.DungeonFrameLoadBreakableItemMaxNum
EMLuaConst.bEnablePlayerRootMotionOptimizations = Const.bEnablePlayerRootMotionOptimizations
EMLuaConst.OpenCritCompute = true
EMLuaConst.OpenHatredCompute = true
EMLuaConst.OpenAccessoryDrop = true
EMLuaConst.bIsEnableHotUpdate = true
EMLuaConst.HotUpdateServerIdStr = "Default"
EMLuaConst.PCInterativeTickCount = 5
EMLuaConst.MobileInterativeTickCount = 3
EMLuaConst.bEnableHideRegionPlayer = true
EMLuaConst.RagdollClientMotorsAngularDriveParams = 1000
EMLuaConst.RagdollForceExitTime = 15
EMLuaConst.RagdollForceExitTimeShort = 5
EMLuaConst.RagdollForceExitTimeShortUnitId = 10005001
EMLuaConst.bEnableNotifyAllClientLand = false
EMLuaConst.FootstepFXSlowSpeed = Const.FootstepFXSlowSpeed
EMLuaConst.FootstepFXFastSpeed = Const.FootstepFXFastSpeed
EMLuaConst.FootstepDeepWaterRatio = Const.WaterDepth
EMLuaConst.SkillPlaySeUseHitLocation = true
EMLuaConst.EventCallbackStop = true
EMLuaConst.HighFrequencyCheckGCInterval = 2
EMLuaConst.bEnableClientMonsterOptimization = true
EMLuaConst.bEnableRegionDeferredDestroy = false
EMLuaConst.RegionDeferredDestroyMaxPerFrame = 8
EMLuaConst.RegionDeferredDestroyTimeBudgetMs = 2.0
EMLuaConst.bSplitFrame_RefreshBloodBar = true
EMLuaConst.SplitFrame_RefreshBloodBar_MaxTimes = 16
EMLuaConst.bEnableRagdollBudgetSubsystem = true
EMLuaConst.bEnableRagdollBudgetSubsystemTick = false
EMLuaConst.bAutoChoosePhysicsAssetForOptimization = true
EMLuaConst.bForceChoosePhysicsAssetOriginal = false
EMLuaConst.bForceChoosePhysicsAssetLite = false
EMLuaConst.bForceChoosePhysicsAssetMinimal = false
EMLuaConst.NumThreshold1 = 10
EMLuaConst.DistanceThreshold1 = 2000
EMLuaConst.NumThreshold2 = 20
EMLuaConst.DistanceThreshold1 = 4000
EMLuaConst.RagdollBudgetTickInterval = 5
EMLuaConst.bSync_RagdollGetUpResetCapsuleLocation = false
EMLuaConst.bEnableMeshPhysicsBudgetSubsystem = false
EMLuaConst.MeshPhysicsBudgetTickInterval = 1.0
EMLuaConst.MeshPhysicsBudgetDistanceThreshold = 5000.0
EMLuaConst.MeshPhysicsBudgetChunkSize = 5000.0
EMLuaConst.bConditionalSkipMonsterReplicationInDS = true
EMLuaConst.ConditionalCtrlMonsterTickIntervalInDS = 0.5
EMLuaConst.bEnablePCGlobalAnimCache = false
EMLuaConst.bEnableRegionAnimCache = true
EMLuaConst.bEnableAnimCacheAsyncLoad = true
EMLuaConst.bEnableSummonAnimCache = true
EMLuaConst.bEnableDSAnimCache = true
EMLuaConst.bMonEnableExecuteInLuaDelegate = false
EMLuaConst.bNpcEnableExecuteInLuaDelegate = false
EMLuaConst.bNpcOpenCustomNpcMoveCheck = true
EMLuaConst.bEnableAnimCacheCopyOpt = true
EMLuaConst.bEnableAnimCacheRootMotion = true
EMLuaConst.RootMotionSampleInterval = 1
EMLuaConst.bMoveOpt_SkipSlideMove = true
EMLuaConst.bMoveOpt_SkipRVONavigationCheck = true
EMLuaConst.bMoveOpt_SweepIgnoreStatic = false
EMLuaConst.bAsyncMonMovement = false
EMLuaConst.bAsyncMonMoveTickInPhysThread = false
EMLuaConst.bEnableRegionPlayerUnitBudget = true
EMLuaConst.HookEllipsePCX = 0.74
EMLuaConst.HookEllipsePCY = 0.82
EMLuaConst.HookEllipseMoblieX = 0.82
EMLuaConst.HookEllipseMoblieY = 0.95
EMLuaConst.bShouldMobileReplacePath = true
EMLuaConst.MapPCReplacePath = "Maps"
EMLuaConst.MapMobileReplacePath = "Maps_Phone"
EMLuaConst.bConditionalSkipMonsterReplication = true
EMLuaConst.RegionOnlineNearbyMaxCount = 50
EMLuaConst.RegionOnlineNearbyMaxDist = 10000
EMLuaConst.MaxKawaiiMember = 20
EMLuaConst.KawaiiLevelMap = {
  FromOtherWorld = 0,
  Phantom = 0,
  OtherPlayer = 0,
  Npc = 0
}
local KawaiiLODLevelArray = TArray(0)
KawaiiLODLevelArray:Add(4)
KawaiiLODLevelArray:Add(4)
KawaiiLODLevelArray:Add(3)
KawaiiLODLevelArray:Add(1)
EMLuaConst.KawaiiLODLevelArray = KawaiiLODLevelArray
EMLuaConst.bEnableCommonUROFromOtherWorld = true
EMLuaConst.bEnableCommonUROPhantom = true
EMLuaConst.bEnableCommonURONormalMonster = true
EMLuaConst.bEnableCommonURONPC = true
EMLuaConst.bEnableCommonUROSummonMonster = true
EMLuaConst.bEnableCommonUROOtherPlayer = true
EMLuaConst.bShowGuildConstructActorDebug = true
EMLuaConst.bOpenComputeDotBuff = false
EMLuaConst.OpenComputeJumpWord = true
EMLuaConst.OpenHatredCompute = true
EMLuaConst.OpenAccessoryDrop = false
EMLuaConst.OpenShieldRecoverThreadTimer = false
EMLuaConst.OpenFightAttrWorker = true
EMLuaConst.OpenGetEventByIDCompute = true
EMLuaConst.EnablePSODiskCache = true
EMLuaConst.PSOFlushThreshold = 10
EMLuaConst.ShouldCombinePartMesh = false
EMLuaConst.bAIComputeSlipVector_UseIteration = true
EMLuaConst.AIComputeSlipVector_MaxIterationTime = 5
EMLuaConst.bOptimizeDeadRPC = false
EMLuaConst.bEnableCustomTitleBar = true
EMLuaConst.TitleBarHeight = 30
EMLuaConst.ForceUseCustomTitleBar = false
EMLuaConst.WindowMinHeightPercent = 0.2
EMLuaConst.WindowMinHeightMinPx = 200
EMLuaConst.WindowResizeDebounceDelay = 0.3
EMLuaConst.WindowMovedDebounceDelay = 0.3
EMLuaConst.bUseLineTraceForSkillMove = true
EMLuaConst.bSupportPreloadFromLua = false
EMLuaConst.bTacmapUseTopN = true
EMLuaConst.EveCopyCreatureMaxCount = 5
EMLuaConst.CopyModeScanRadius = 3000.0
EMLuaConst.CopyModeMaxMeshHalfExtent = 500.0
EMLuaConst.CopyModeRayALength = 10000.0
EMLuaConst.CopyModeRayBLength = 2000.0
EMLuaConst.bEnableMountPassenger = false
local MonsterOptConfig = UE4.FMonsterOptConfig()
MonsterOptConfig.bUseMonsterWeaponBase = true
MonsterOptConfig.bOptCloseAccessories = true
MonsterOptConfig.bOptCloseRagdoll = false
MonsterOptConfig.bUseSimpleAnimGraph = false
MonsterOptConfig.bUseMonsterWeaponPool = Const.bUseMonsterWeaponPool
MonsterOptConfig.bBillboardHiddenWhileOccluded = true
EMLuaConst.MonsterOptConfig = MonsterOptConfig
local PlayerAnimUpdateRateConfig = UE4.FPlayerAnimUpdateRateConfig()
PlayerAnimUpdateRateConfig.bEnable = true
PlayerAnimUpdateRateConfig.bUseLODMap = false
PlayerAnimUpdateRateConfig.bUseMinLOD = false
PlayerAnimUpdateRateConfig.bUseDistanceMap = true
PlayerAnimUpdateRateConfig.bSleepSkip = false
PlayerAnimUpdateRateConfig.NonRenderedUpdateRate = 8
PlayerAnimUpdateRateConfig.MaxEvalRateForInterpolation = 9
local DistanceRule025 = UE4.FPlayerURODistanceRateRule()
DistanceRule025.ScreenSizeThreshold = 0.015625
DistanceRule025.FrameSkipCount = 1
PlayerAnimUpdateRateConfig.DistanceRules:Add(DistanceRule025)
local DistanceRule020 = UE4.FPlayerURODistanceRateRule()
DistanceRule020.ScreenSizeThreshold = 0.01
DistanceRule020.FrameSkipCount = 3
PlayerAnimUpdateRateConfig.DistanceRules:Add(DistanceRule020)
local DistanceRule010 = UE4.FPlayerURODistanceRateRule()
DistanceRule010.ScreenSizeThreshold = 0.0025
DistanceRule010.FrameSkipCount = 5
PlayerAnimUpdateRateConfig.DistanceRules:Add(DistanceRule010)
local DistanceRule005 = UE4.FPlayerURODistanceRateRule()
DistanceRule005.ScreenSizeThreshold = 6.25E-4
DistanceRule005.FrameSkipCount = 7
PlayerAnimUpdateRateConfig.DistanceRules:Add(DistanceRule005)
EMLuaConst.PlayerAnimUpdateRateConfig = PlayerAnimUpdateRateConfig
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
