require("UnLua")
local MiscUtils = require("Utils.MiscUtils")
local PreviewLevelHandoffMask = require("BluePrints.UI.Common.Preview.PreviewLevelHandoffMask")
local PREVIEW_ROOT_BP_PATH = "/Game/BluePrints/UI/PersonalPreview/BP_PreviewSceneRoot.BP_PreviewSceneRoot_C"
local UI_ART_NS_ACTOR_BP_PATH = "/Game/UI/Blueprint/BP_UIArt_NSActor.BP_UIArt_NSActor_C"
local UI_ART_NS_COMPONENT_NAME = "NS_XK_dimian_2"
local ESceneState = {
  Idle = 0,
  Loading = 1,
  Loaded = 2
}
local TIMER_NAME_DELAY_CALL_SCENE_LOADED = "DelayCallSceneLoaded"
local TIMER_NAME_REFRESH_ENVIRONMENT = "RefreshEnvironment"
local TIMER_NAME_RECOVER_ENVIRONMENT_AFTER_UNLOAD = "RecoverEnvironmentAfterUnload"
local M = {}

function M:Init(Params)
  Params = Params or {}
  self.ViewUI = Params.ViewUI
  self.PreviewSceneType = Params.PreviewSceneType
  self.PreviewSceneLocation = Params.PreviewSceneLocation
  self.PreviewScenePath = Params.PreviewScenePath
  self.PreviewInstanceKey = Params.PreviewInstanceKey
  self.PreviewLevelNameOverride = Params.PreviewLevelNameOverride
  self.UsePreviewRootActor = Params.UsePreviewRootActor == true
  self.SkyBoxIndex = Params.SkyBoxIndex or 0
  self.ArmoryHelper = nil
  self.PreviewSceneTrans = nil
  self.PreviewRootActor = nil
  self.PreviewLevelActorReceiver = nil
  self.SceneState = ESceneState.Idle
  self.bPendingLightingUpdate = false
  self.UserLightData = nil
  self.SceneCoroutineMap = {}
  self.SceneCoroutineArray = {}
end

local function EnsureSpawnedActorRootComponent(Actor)
  if not Actor then
    return
  end
  if Actor:K2_GetRootComponent() or not Actor.AddComponentByClass then
    return
  end
  local RootComponent = Actor:AddComponentByClass(USceneComponent:StaticClass(), false, FTransform(), false)
  if RootComponent then
    if URuntimeCommonFunctionLibrary and URuntimeCommonFunctionLibrary.RegisterComponent then
      URuntimeCommonFunctionLibrary.RegisterComponent(RootComponent)
    end
    if Actor.SetRootComponent then
      Actor:SetRootComponent(RootComponent)
    elseif Actor.RootComponent == nil then
      Actor.RootComponent = RootComponent
    end
  end
end

local function SpawnPreviewRootActor(ViewUI, Transform)
  local World = ViewUI and ViewUI:GetWorld() or nil
  if not World then
    return nil
  end
  local SpawnTransform = Transform or FTransform()
  local RootActorClass = LoadClass(PREVIEW_ROOT_BP_PATH) or AActor:StaticClass()
  local RootActor = World:SpawnActor(RootActorClass, SpawnTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
  if not RootActor then
    return nil
  end
  if RootActorClass == AActor:StaticClass() then
    EnsureSpawnedActorRootComponent(RootActor)
  end
  if RootActor.SetActorLabel then
    RootActor:SetActorLabel("PreviewSceneRoot")
  end
  if RootActor.SetActorEnableCollision then
    RootActor:SetActorEnableCollision(false)
  end
  if RootActor.SetActorTickEnabled then
    RootActor:SetActorTickEnabled(false)
  end
  if RootActor.SetCanBeDamaged then
    RootActor:SetCanBeDamaged(false)
  end
  if RootActor.SetIsTemporarilyHiddenInEditor then
    RootActor:SetIsTemporarilyHiddenInEditor(true)
  end
  RootActor:K2_SetActorTransform(SpawnTransform, false, nil, false)
  return RootActor
end

local function AddPreviewScenePathCandidate(Candidates, CandidateMap, Path)
  if type(Path) ~= "string" or "" == Path then
    return
  end
  if CandidateMap[Path] then
    return
  end
  CandidateMap[Path] = true
  table.insert(Candidates, Path)
end

local function TrimPreviewScenePath(Path)
  if type(Path) ~= "string" then
    return nil
  end
  return string.gsub(string.gsub(Path, "^['\"]", ""), "['\"]$", "")
end

local function BuildPreviewScenePathCandidates(Path)
  local Candidates = {}
  local CandidateMap = {}
  local TrimmedPath = TrimPreviewScenePath(Path)
  AddPreviewScenePathCandidate(Candidates, CandidateMap, Path)
  AddPreviewScenePathCandidate(Candidates, CandidateMap, TrimmedPath)
  if type(TrimmedPath) ~= "string" or "" == TrimmedPath then
    return Candidates
  end
  local PackagePath, AssetName = string.match(TrimmedPath, "^(.-)%.([^%.]+)$")
  if PackagePath and AssetName then
    AddPreviewScenePathCandidate(Candidates, CandidateMap, TrimmedPath .. "'")
    AddPreviewScenePathCandidate(Candidates, CandidateMap, PackagePath)
    AddPreviewScenePathCandidate(Candidates, CandidateMap, PackagePath .. "." .. AssetName .. "'")
  end
  return Candidates
end

local function SanitizePreviewInstanceKey(InstanceKey)
  if type(InstanceKey) ~= "string" then
    return nil
  end
  local TrimmedKey = string.match(InstanceKey, "^%s*(.-)%s*$")
  if not TrimmedKey or "" == TrimmedKey then
    return nil
  end
  local SafeKey = string.gsub(TrimmedKey, "[^%w_]+", "_")
  SafeKey = string.gsub(SafeKey, "_+", "_")
  SafeKey = string.gsub(SafeKey, "^_+", "")
  SafeKey = string.gsub(SafeKey, "_+$", "")
  if "" == SafeKey then
    return nil
  end
  return SafeKey
end

local function CalcPreviewInstanceLocationOffset(InstanceKey)
  local SafeKey = SanitizePreviewInstanceKey(InstanceKey)
  if not SafeKey then
    return 0
  end
  local HashValue = 0
  for Index = 1, string.len(SafeKey) do
    HashValue = (HashValue * 131 + string.byte(SafeKey, Index)) % 97
  end
  return (HashValue + 1) * 5000
end

local function TryLoadPreviewLevel(WorldLoader, PreviewLevelName, PathCandidates, Callback, PreviewLevelLocation)
  for _, CandidatePath in ipairs(PathCandidates or {}) do
    local bSuccess = WorldLoader:LoadPreviewLevel(PreviewLevelName, CandidatePath, Callback, PreviewLevelLocation, FRotator(0, 0, 0))
    if bSuccess then
      return true, CandidatePath
    end
  end
  return false, nil
end

function M:SetPreviewScenePath(Path)
  self.PreviewScenePath = Path
end

function M:GetPreviewLevelName()
  if type(self.PreviewLevelNameOverride) == "string" and self.PreviewLevelNameOverride ~= "" then
    return self.PreviewLevelNameOverride
  end
  local SafeInstanceKey = SanitizePreviewInstanceKey(self.PreviewInstanceKey)
  if SafeInstanceKey then
    return "PreviewLevel" .. tostring(self.PreviewSceneType) .. "_" .. SafeInstanceKey
  end
  return "PreviewLevel" .. tostring(self.PreviewSceneType)
end

local PreviewSceneLoaded = {}

local function IncreasePreviewSceneRefCount(PreviewLevelName)
  PreviewSceneLoaded[PreviewLevelName] = PreviewSceneLoaded[PreviewLevelName] or 0
  PreviewSceneLoaded[PreviewLevelName] = PreviewSceneLoaded[PreviewLevelName] + 1
end

local function DecreasePreviewSceneRefCount(PreviewLevelName)
  if PreviewSceneLoaded[PreviewLevelName] then
    PreviewSceneLoaded[PreviewLevelName] = PreviewSceneLoaded[PreviewLevelName] - 1
    if PreviewSceneLoaded[PreviewLevelName] <= 0 then
      PreviewSceneLoaded[PreviewLevelName] = nil
    end
  end
end

local function IsPreviewSceneHasRef(PreviewLevelName)
  return PreviewSceneLoaded[PreviewLevelName] and PreviewSceneLoaded[PreviewLevelName] > 0
end

local function HadAnyPreviewScene()
  return next(PreviewSceneLoaded) ~= nil
end

local function GetLevelScriptActor(WorldLoader, PreviewLevelName)
  local PreviewLevelStreaming = WorldLoader[PreviewLevelName]
  if not PreviewLevelStreaming then
    return
  end
  local PreviewLevel = PreviewLevelStreaming:GetLoadedLevel()
  if not PreviewLevel then
    return
  end
  return PreviewLevel.LevelScriptActor
end

local function RemoveSceneCoroutine(self, CoroutineName)
  local Idx = self.SceneCoroutineMap[CoroutineName]
  if Idx then
    table.remove(self.SceneCoroutineArray, Idx)
    self.SceneCoroutineMap[CoroutineName] = nil
    for Name, Index in pairs(self.SceneCoroutineMap) do
      if Index > Idx then
        self.SceneCoroutineMap[Name] = Index - 1
      end
    end
  end
end

local function AddSceneCoroutine(self, CoroutineName, Co)
  RemoveSceneCoroutine(self, CoroutineName)
  table.insert(self.SceneCoroutineArray, Co)
  self.SceneCoroutineMap[CoroutineName] = #self.SceneCoroutineArray
end

local function FindSceneCoroutine(self, CoroutineName)
  local Idx = self.SceneCoroutineMap[CoroutineName]
  if Idx then
    return self.SceneCoroutineArray[Idx]
  end
end

function M:SetHelper(Helper)
  self.ArmoryHelper = Helper
end

function M:SetPreviewLevelActorReceiver(Receiver)
  self.PreviewLevelActorReceiver = Receiver
end

function M:GetHelper()
  return self.ArmoryHelper
end

function M:GetPreviewSceneTrans()
  return self.PreviewSceneTrans
end

function M:GetPreviewRootActor()
  return self.PreviewRootActor
end

function M:SpawnPreviewEffectCreature(EffectCreatureId, SpawnHostActor)
  if not EffectCreatureId then
    return nil
  end
  if IsValid(SpawnHostActor) and SpawnHostActor.CreateEffectCreature then
    return SpawnHostActor:CreateEffectCreature(EffectCreatureId, FTransform(), false, "")
  end
  local EffectCreatureData = DataMgr and DataMgr.EffectCreature and DataMgr.EffectCreature[EffectCreatureId] or nil
  local EffectCreaturePath = EffectCreatureData and EffectCreatureData.EffectCreaturePath or nil
  if type(EffectCreaturePath) ~= "string" or "" == EffectCreaturePath then
    DebugPrint(string.format("PreviewSceneService: standalone effect creature path missing id=%s", tostring(EffectCreatureId)))
    return nil
  end
  if string.sub(EffectCreaturePath, -2) ~= "_C" then
    EffectCreaturePath = EffectCreaturePath .. "_C"
  end
  local World = self.ViewUI and self.ViewUI:GetWorld() or nil
  local EffectCreatureClass = World and LoadClass(EffectCreaturePath) or nil
  if not EffectCreatureClass then
    DebugPrint(string.format("PreviewSceneService: standalone effect creature class missing id=%s path=%s", tostring(EffectCreatureId), EffectCreaturePath))
    return nil
  end
  local EffectCreature = World:SpawnActor(EffectCreatureClass, FTransform(), UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
  if not IsValid(EffectCreature) then
    DebugPrint(string.format("PreviewSceneService: standalone effect creature spawn failed id=%s", tostring(EffectCreatureId)))
    return nil
  end
  EffectCreature:SetActorHiddenInGame(true)
  EffectCreature:SetActorEnableCollision(false)
  if self.PreviewRootActor and EffectCreature.SetOwner then
    EffectCreature:SetOwner(self.PreviewRootActor)
  end
  EffectCreature.EffectCreatureId = EffectCreatureId
  EffectCreature.ReplaceSkinEffectCreatureId = EffectCreatureId
  EffectCreature.SkillSpeed = 1
  EffectCreature.LoadTime = 0
  EffectCreature:Active()
  EffectCreature:SetTickableWhenPaused(true)
  if EffectCreature.SkeletalMesh and EffectCreature.SkeletalMesh.SetTickableWhenPaused then
    EffectCreature.SkeletalMesh:SetTickableWhenPaused(true)
  end
  EffectCreature:LoadEffectCreatureResource()
  EffectCreature:PlayCreateSe()
  if EffectCreature.OnBeginPlay then
    EffectCreature:OnBeginPlay()
  end
  DebugPrint(string.format("PreviewSceneService: standalone effect creature created id=%s actor=%s", tostring(EffectCreatureId), tostring(EffectCreature.GetName and EffectCreature:GetName() or EffectCreature)))
  return EffectCreature
end

local function BindPreviewLevelActor(self, PreviewLevelActor)
  if IsValid(self.ArmoryHelper) then
    self.ArmoryHelper:SetPreviewLevelActor(PreviewLevelActor)
  end
  if self.PreviewLevelActorReceiver and self.PreviewLevelActorReceiver.SetPreviewLevelActor then
    self.PreviewLevelActorReceiver:SetPreviewLevelActor(PreviewLevelActor)
  end
  if PreviewLevelActor and self.SceneState ~= ESceneState.Idle then
    self.SceneState = ESceneState.Loaded
    self:NotifyHelperUpdateLighting()
  end
end

function M:RebindPreviewLevelActor()
  if not self.PreviewLevelName then
    return nil
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self.ViewUI)
  local WorldLoader = GameMode and GameMode:GetLevelLoader()
  if not WorldLoader then
    return nil
  end
  local PreviewLevelActor = GetLevelScriptActor(WorldLoader, self.PreviewLevelName)
  if not PreviewLevelActor then
    return nil
  end
  BindPreviewLevelActor(self, PreviewLevelActor)
  return PreviewLevelActor
end

function M:IsSceneLoaded()
  return self.SceneState ~= ESceneState.Idle
end

function M:IsSceneLoading()
  return self.SceneState == ESceneState.Loading
end

function M:IsSceneReady()
  return self.SceneState == ESceneState.Loaded
end

function M:LoadScene(SceneType)
  if HadAnyPreviewScene() then
    self.PreviewSceneType = self.PreviewSceneType or CommonConst.EPreviewSceneType.PreviewCommon
  end
  self.PreviewSceneType = SceneType or self.PreviewSceneType
  local DefaultPath = CommonConst.PreviewScenePaths[self.PreviewSceneType]
  local Path = self.PreviewScenePath or DefaultPath
  if not Path and not DefaultPath then
    PreviewLevelHandoffMask.Hide(self.ViewUI)
    return
  end
  if not self.PreviewSceneLocation then
    local Loc = 180000 + self.PreviewSceneType * 1000
    Loc = Loc + CalcPreviewInstanceLocationOffset(self.PreviewInstanceKey)
    self.PreviewSceneLocation = FVector(Loc, Loc, Loc)
  end
  local PreviewLevelLocation = self.PreviewSceneLocation
  local GameMode = UE4.UGameplayStatics.GetGameMode(self.ViewUI)
  local WorldLoader = GameMode and GameMode:GetLevelLoader()
  if not WorldLoader then
    PreviewLevelHandoffMask.Hide(self.ViewUI)
    return
  end
  local TargetTrans = FTransform()
  TargetTrans.Translation = PreviewLevelLocation
  TargetTrans.Rotation = FRotator(0, 0, 0):ToQuat()
  TargetTrans.Scale3D = FVector(1, 1, 1)
  self.PreviewSceneTrans = TargetTrans
  if self.UsePreviewRootActor then
    if not IsValid(self.PreviewRootActor) then
      self.PreviewRootActor = SpawnPreviewRootActor(self.ViewUI, TargetTrans)
    elseif self.PreviewRootActor then
      self.PreviewRootActor:K2_SetActorTransform(TargetTrans, false, nil, false)
    end
    if self.PreviewRootActor and self.PreviewRootActor.SetActorLabel then
      self.PreviewRootActor:SetActorLabel((self:GetPreviewLevelName() or "PreviewLevel") .. "_Root")
    end
  elseif IsValid(self.PreviewRootActor) then
    self.PreviewRootActor:K2_DestroyActor()
    self.PreviewRootActor = nil
  end
  local PreviewLevelName = self:GetPreviewLevelName()
  if self.PreviewLevelName == PreviewLevelName then
    if self:IsSceneLoading() then
      return
    end
    if self:IsSceneReady() then
      self:OnPreviewSceneLoaded()
      return
    end
  end
  if self.SceneState ~= ESceneState.Idle and self.PreviewLevelName and self.PreviewLevelName ~= PreviewLevelName then
    self:UnloadScene()
  end
  self.SceneState = ESceneState.Loading
  
  local function BindPreviewLevelActorDelayed()
    if not IsValid(self.ViewUI) then
      return
    end
    self.ViewUI:AddTimer(0.1, function()
      if not IsValid(self.ViewUI) or self.SceneState ~= ESceneState.Loading then
        return
      end
      BindPreviewLevelActor(self, GetLevelScriptActor(WorldLoader, PreviewLevelName))
      self:OnPreviewSceneLoaded()
    end, false, 0, TIMER_NAME_DELAY_CALL_SCENE_LOADED, true)
  end
  
  if not IsPreviewSceneHasRef(PreviewLevelName) then
    local function OnPreviewLevelLoaded()
      BindPreviewLevelActorDelayed()
    end
    
    local LoadedPath
    local bSuccess = false
    bSuccess, LoadedPath = TryLoadPreviewLevel(WorldLoader, PreviewLevelName, BuildPreviewScenePathCandidates(Path), OnPreviewLevelLoaded, PreviewLevelLocation)
    if not bSuccess and DefaultPath and DefaultPath ~= Path then
      bSuccess, LoadedPath = TryLoadPreviewLevel(WorldLoader, PreviewLevelName, BuildPreviewScenePathCandidates(DefaultPath), OnPreviewLevelLoaded, PreviewLevelLocation)
    end
    if bSuccess then
      self.PreviewScenePath = LoadedPath or Path
      self.PreviewLevelName = PreviewLevelName
      IncreasePreviewSceneRefCount(PreviewLevelName)
    else
      self.PreviewSceneTrans = nil
      self.SceneState = ESceneState.Idle
      self:AbortDeferredSceneBehavior()
      PreviewLevelHandoffMask.Hide(self.ViewUI)
    end
  else
    IncreasePreviewSceneRefCount(PreviewLevelName)
    self.PreviewLevelName = PreviewLevelName
    BindPreviewLevelActorDelayed()
  end
end

function M:UnloadScene(bKeepWorldLoaded)
  if self.SceneState == ESceneState.Idle then
    return
  end
  local PreviewLevelName = self.PreviewLevelName or self:GetPreviewLevelName()
  self.SceneState = ESceneState.Idle
  self.bPendingLightingUpdate = false
  DecreasePreviewSceneRefCount(PreviewLevelName)
  if IsPreviewSceneHasRef(PreviewLevelName) then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self.ViewUI)
  local WorldLoader = GameMode and GameMode:GetLevelLoader()
  if not WorldLoader then
    return
  end
  self:DisableEnvirSystem(true)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
  local ViewController = UE4.UGameplayStatics.GetPlayerController(self.ViewUI, 0)
  local Controller = ViewController or self.ArmoryHelper and UE4.UGameplayStatics.GetPlayerController(self.ArmoryHelper, 0)
  if not bKeepWorldLoaded then
    if ViewController and IsValid(Player) and ViewController:GetViewTarget() ~= Player then
      ViewController:SetViewTargetWithBlend(Player, 0, UE4.EViewTargetBlendFunction.VTBlend_Linear, 0, false)
    end
    if Controller then
      UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(Controller)
    end
  end
  WorldLoader:UnloadPreviewLevel(PreviewLevelName, bKeepWorldLoaded)
  BindPreviewLevelActor(self, nil)
  if self.ArmoryHelper then
    self.ArmoryHelper:OnPreviewSceneUnloaded()
  end
  if IsValid(self.PreviewRootActor) then
    self.PreviewRootActor:K2_DestroyActor()
  end
  self.PreviewRootActor = nil
  self.PreviewLevelName = nil
  if self.ArmoryHelper then
    self.ArmoryHelper:AddTimer(0.03, function()
      local EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(self.ViewUI, UE4.AEnvironmentManager:StaticClass())
      if EnvironmentManager then
        EnvironmentManager:Refresh(true)
      end
      local PlayerController = UE4.UGameplayStatics.GetPlayerController(self.ArmoryHelper, 0)
      if PlayerController then
        UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(PlayerController)
      end
    end, false, 0, TIMER_NAME_RECOVER_ENVIRONMENT_AFTER_UNLOAD, true)
  end
end

function M:GetEnvirSystemActor()
  local PreviewLevelActor
  if self.ArmoryHelper and self.ArmoryHelper.GetPreviewLevelActor then
    PreviewLevelActor = self.ArmoryHelper:GetPreviewLevelActor()
  end
  if not PreviewLevelActor and self.PreviewLevelActorReceiver and self.PreviewLevelActorReceiver.GetPreviewLevelActor then
    PreviewLevelActor = self.PreviewLevelActorReceiver:GetPreviewLevelActor()
  end
  local EnvirSystemActor = PreviewLevelActor and PreviewLevelActor.GetEnvirSystemActor and PreviewLevelActor:GetEnvirSystemActor()
  return EnvirSystemActor
end

function M:IsLightingTargetReady()
  if not self:IsSceneReady() or not IsValid(self.ArmoryHelper) then
    return false
  end
  local PreviewLevelActor = self.ArmoryHelper:GetPreviewLevelActor()
  if not PreviewLevelActor then
    return false
  end
  if PreviewLevelActor.GetGroundActor then
    return PreviewLevelActor:GetGroundActor() ~= nil
  end
  return true
end

function M:WaitForPreviewSceneLoadFinished()
  if self:IsSceneLoading() then
    if coroutine.isyieldable() then
      coroutine.yield()
    else
      return
    end
  end
  return true
end

function M:DoSomethingWithScene(BehaviorName, Func, ...)
  local Co = FindSceneCoroutine(self, BehaviorName)
  if Co then
    local Status = coroutine.status(Co)
    if "running" == Status or "suspended" == Status then
      coroutine.close(Co)
      RemoveSceneCoroutine(self, BehaviorName)
    end
  end
  Co = coroutine.create(Func)
  AddSceneCoroutine(self, BehaviorName, Co)
  coroutine.resume(Co, ...)
end

function M:DoDeferredSceneBehavior()
  local SceneCoroutineArray = {}
  for _, Value in ipairs(self.SceneCoroutineArray) do
    table.insert(SceneCoroutineArray, Value)
  end
  self.SceneCoroutineArray = {}
  self.SceneCoroutineMap = {}
  for _, Co in ipairs(SceneCoroutineArray) do
    coroutine.resume(Co)
  end
end

function M:AbortDeferredSceneBehavior()
  local SceneCoroutineArray = self.SceneCoroutineArray
  self.SceneCoroutineArray = {}
  self.SceneCoroutineMap = {}
  for _, Co in ipairs(SceneCoroutineArray) do
    if coroutine.status(Co) == "suspended" then
      coroutine.close(Co)
    end
  end
end

function M:StartPreviewBGAnimation(PreviewBGPos, Time)
  local function StartPreviewBGAnimationInternal()
    local bSuccess = self:WaitForPreviewSceneLoadFinished()
    
    if not bSuccess then
      return
    end
    local TargetBGLoc
    if PreviewBGPos then
      TargetBGLoc = FVector(PreviewBGPos[1], PreviewBGPos[2], PreviewBGPos[3])
    else
      TargetBGLoc = FVector(0, 0, 0)
    end
    if self.ArmoryHelper then
      self.ArmoryHelper:StartPreviewBGAnimation(TargetBGLoc, Time)
    end
  end
  
  self:DoSomethingWithScene("StartPreviewBGAnimation", StartPreviewBGAnimationInternal)
end

function M:DisableEnvirSystem(bDisable)
  local function DisableEnvirSystemInternal()
    local bSuccess = self:WaitForPreviewSceneLoadFinished()
    
    if not bSuccess then
      return
    end
    local EnvirSystemActor = self:GetEnvirSystemActor()
    if EnvirSystemActor then
      EnvirSystemActor.Disable = bDisable
    end
  end
  
  self:DoSomethingWithScene("DisableEnvirSystem", DisableEnvirSystemInternal)
end

function M:RefreshEnvironment()
  if not IsValid(self.ArmoryHelper) then
    return
  end
  self.ArmoryHelper:AddTimer(0.03, function()
    if not IsValid(self.ViewUI) or not IsValid(self.ArmoryHelper) then
      return
    end
    local EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(self.ViewUI, UE4.AEnvironmentManager:StaticClass())
    if EnvironmentManager then
      self:DisableEnvirSystem(true)
      local Controller = UE4.UGameplayStatics.GetPlayerController(self.ArmoryHelper, 0)
      if Controller then
        UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(Controller)
      end
      EnvironmentManager:Refresh(true)
      self:NotifyHelperUpdateLighting()
      self:RefreshUIArtNiagara()
    end
  end, false, 0, TIMER_NAME_REFRESH_ENVIRONMENT, true)
end

function M:NotifyHelperUpdateLighting()
  if not IsValid(self.ArmoryHelper) then
    return
  end
  if not self:IsLightingTargetReady() then
    self.bPendingLightingUpdate = true
    return
  end
  self.bPendingLightingUpdate = false
  self.ArmoryHelper.SkyBoxIndex = self.SkyBoxIndex or 0
  self.ArmoryHelper:UpdateDirLight(true)
  self.ArmoryHelper:UpdateLighting()
  self:ApplyUserLight()
end

function M:SetUserLight(LightEditData)
  LightEditData = LightEditData or {}
  local Direction = LightEditData and LightEditData.Direction or {}
  self.UserLightData = {
    Roll = Direction[1] or LightEditData.Roll or 0,
    Pitch = Direction[2] or LightEditData.Pitch or 0,
    Yaw = Direction[3] or LightEditData.Yaw or 0,
    LightIntensity = LightEditData.Intensity or LightEditData.LightIntensity or 0
  }
  self:NotifyHelperUpdateLighting()
end

function M:ClearUserLight()
  self.UserLightData = nil
  self:NotifyHelperUpdateLighting()
end

function M:ApplyUserLight()
  if not IsValid(self.ArmoryHelper) or not self.UserLightData then
    return
  end
  self.ArmoryHelper:SetUserLight(self.UserLightData.Roll, self.UserLightData.Pitch, self.UserLightData.Yaw, self.UserLightData.LightIntensity)
end

function M:RefreshUIArtNiagara()
  if not IsValid(self.ViewUI) then
    return
  end
  local ActorClass = LoadClass(UI_ART_NS_ACTOR_BP_PATH)
  if not ActorClass then
    return
  end
  local Actors = UE4.UGameplayStatics.GetAllActorsOfClass(self.ViewUI, ActorClass)
  if not Actors then
    return
  end
  local ActorArray = Actors.ToTable and Actors:ToTable() or Actors
  if not ActorArray then
    return
  end
  for _, Actor in ipairs(ActorArray) do
    local NiagaraComponent = Actor and Actor[UI_ART_NS_COMPONENT_NAME]
    if NiagaraComponent then
      NiagaraComponent:SetComponentTickEnabled(true)
      NiagaraComponent:SetTickableWhenPaused(true)
      NiagaraComponent:SetForceSolo(true)
      UE4.UCharacterFunctionLibrary.DeactivateNiagaraImmediately(NiagaraComponent)
      NiagaraComponent:Activate(true)
    end
  end
end

function M:ChangeSkyBox(Index)
  if not IsValid(self.ArmoryHelper) then
    return
  end
  self.SkyBoxIndex = Index or 0
  self.ArmoryHelper.SkyBoxIndex = self.SkyBoxIndex
  
  local function CallSkyBoxChanged()
    local bSuccess = self:WaitForPreviewSceneLoadFinished()
    if not bSuccess then
      return
    end
    self:NotifyHelperUpdateLighting()
  end
  
  self:DoSomethingWithScene("OnSkyBoxIndexChange", CallSkyBoxChanged)
end

function M:OnPreviewSceneLoaded()
  PreviewLevelHandoffMask.Hide(self.ViewUI)
  self:DoDeferredSceneBehavior()
  self:RefreshUIArtNiagara()
  if self.bPendingLightingUpdate then
    self:NotifyHelperUpdateLighting()
  end
end

function M:Dispose()
  self:UnloadScene()
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

return M
