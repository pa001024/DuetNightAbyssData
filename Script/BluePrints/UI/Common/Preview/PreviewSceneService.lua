require("UnLua")
local PREVIEW_ROOT_BP_PATH = "/Game/BluePrints/UI/PersonalPreview/BP_PreviewSceneRoot.BP_PreviewSceneRoot_C"
local UI_ART_NS_ACTOR_BP_PATH = "/Game/UI/Blueprint/BP_UIArt_NSActor.BP_UIArt_NSActor_C"
local UI_ART_NS_COMPONENT_NAME = "NS_XK_dimian_2"
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
  self.bPreviewSceneLoaded = false
  self.IsPreviewSceneLoading = false
  self.bPendingLightingUpdate = false
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
  DebugPrint(string.format("PreviewSceneService: IncreaseRef level=%s ref=%s", tostring(PreviewLevelName), tostring(PreviewSceneLoaded[PreviewLevelName])))
end

local function DecreasePreviewSceneRefCount(PreviewLevelName)
  if PreviewSceneLoaded[PreviewLevelName] then
    PreviewSceneLoaded[PreviewLevelName] = PreviewSceneLoaded[PreviewLevelName] - 1
    DebugPrint(string.format("PreviewSceneService: DecreaseRef level=%s ref=%s", tostring(PreviewLevelName), tostring(PreviewSceneLoaded[PreviewLevelName])))
    if PreviewSceneLoaded[PreviewLevelName] <= 0 then
      PreviewSceneLoaded[PreviewLevelName] = nil
      DebugPrint(string.format("PreviewSceneService: ClearRef level=%s", tostring(PreviewLevelName)))
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

local function BindPreviewLevelActor(self, PreviewLevelActor)
  if self.ArmoryHelper then
    self.ArmoryHelper:SetPreviewLevelActor(PreviewLevelActor)
  end
  if self.PreviewLevelActorReceiver and self.PreviewLevelActorReceiver.SetPreviewLevelActor then
    self.PreviewLevelActorReceiver:SetPreviewLevelActor(PreviewLevelActor)
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
  BindPreviewLevelActor(self, PreviewLevelActor)
  return PreviewLevelActor
end

function M:IsSceneLoaded()
  return self.bPreviewSceneLoaded
end

function M:IsSceneLoading()
  return self.IsPreviewSceneLoading
end

function M:LoadScene(SceneType)
  if HadAnyPreviewScene() then
    self.PreviewSceneType = self.PreviewSceneType or CommonConst.EPreviewSceneType.PreviewCommon
  end
  self.PreviewSceneType = SceneType or self.PreviewSceneType
  local DefaultPath = CommonConst.PreviewScenePaths[self.PreviewSceneType]
  local Path = self.PreviewScenePath or DefaultPath
  if not Path and not DefaultPath then
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
  if self.bPreviewSceneLoaded and self.PreviewLevelName == PreviewLevelName then
    DebugPrint(string.format("PreviewSceneService: LoadScene skipped sameInstance level=%s", tostring(PreviewLevelName)))
    self:OnPreviewSceneLoaded()
    return
  end
  if self.bPreviewSceneLoaded and self.PreviewLevelName and self.PreviewLevelName ~= PreviewLevelName then
    DebugPrint(string.format("PreviewSceneService: LoadScene switchLevel old=%s new=%s", tostring(self.PreviewLevelName), tostring(PreviewLevelName)))
    self:UnloadScene()
  end
  self.IsPreviewSceneLoading = true
  DebugPrint(string.format("PreviewSceneService: LoadScene begin level=%s hadAny=%s hasRef=%s instanceKey=%s type=%s", tostring(PreviewLevelName), tostring(HadAnyPreviewScene()), tostring(IsPreviewSceneHasRef(PreviewLevelName)), tostring(self.PreviewInstanceKey), tostring(self.PreviewSceneType)))
  if not IsPreviewSceneHasRef(PreviewLevelName) then
    local function OnPreviewLevelLoaded()
      self.ViewUI:AddTimer(0.1, function()
        BindPreviewLevelActor(self, GetLevelScriptActor(WorldLoader, PreviewLevelName))
        
        self:OnPreviewSceneLoaded()
      end)
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
      self.bPreviewSceneLoaded = true
      DebugPrint(string.format("PreviewSceneService: LoadScene loadNewSuccess level=%s path=%s", tostring(PreviewLevelName), tostring(self.PreviewScenePath)))
    else
      self.PreviewSceneTrans = nil
      DebugPrint(string.format("PreviewSceneService: LoadScene loadNewFailed level=%s path=%s defaultPath=%s", tostring(PreviewLevelName), tostring(Path), tostring(DefaultPath)))
    end
  else
    IncreasePreviewSceneRefCount(PreviewLevelName)
    self.bPreviewSceneLoaded = true
    self.PreviewLevelName = PreviewLevelName
    DebugPrint(string.format("PreviewSceneService: LoadScene reuseLoaded level=%s", tostring(PreviewLevelName)))
    if self.ArmoryHelper then
      self.ArmoryHelper:AddTimer(0.1, function()
        BindPreviewLevelActor(self, GetLevelScriptActor(WorldLoader, PreviewLevelName))
        self:OnPreviewSceneLoaded()
      end, false, 0, "DelayCallSceneLoaded", true)
    end
  end
end

function M:UnloadScene()
  if not self.bPreviewSceneLoaded then
    DebugPrint(string.format("PreviewSceneService: UnloadScene skipped level=%s loaded=false", tostring(self.PreviewLevelName or self:GetPreviewLevelName())))
    return
  end
  local PreviewLevelName = self.PreviewLevelName or self:GetPreviewLevelName()
  DebugPrint(string.format("PreviewSceneService: UnloadScene begin level=%s", tostring(PreviewLevelName)))
  self.bPreviewSceneLoaded = false
  self.bPendingLightingUpdate = false
  DecreasePreviewSceneRefCount(PreviewLevelName)
  if IsPreviewSceneHasRef(PreviewLevelName) then
    DebugPrint(string.format("PreviewSceneService: UnloadScene keepLoaded level=%s refStillExists=true", tostring(PreviewLevelName)))
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self.ViewUI)
  local WorldLoader = GameMode and GameMode:GetLevelLoader()
  if not WorldLoader then
    return
  end
  self:DisableEnvirSystem(true)
  local Controller = self.ArmoryHelper and UE4.UGameplayStatics.GetPlayerController(self.ArmoryHelper, 0)
  if Controller then
    UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(Controller)
  end
  WorldLoader:UnloadPreviewLevel(PreviewLevelName)
  DebugPrint(string.format("PreviewSceneService: UnloadScene unloadLevel level=%s", tostring(PreviewLevelName)))
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
    end, false, 0, "RecoverEnvironmentAfterUnload", true)
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
  if not self.bPreviewSceneLoaded or not self.ArmoryHelper then
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
  if self.IsPreviewSceneLoading then
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

function M:RefreshEnvironment(NeedUpdateLighting)
  if not self.ArmoryHelper then
    return
  end
  self.ArmoryHelper:AddTimer(0.03, function()
    local EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(self.ViewUI, UE4.AEnvironmentManager:StaticClass())
    if EnvironmentManager then
      self:DisableEnvirSystem(true)
      local Controller = UE4.UGameplayStatics.GetPlayerController(self.ArmoryHelper, 0)
      if Controller then
        UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(Controller)
      end
      EnvironmentManager:Refresh(true)
      if NeedUpdateLighting then
        self:DelayUpdateLighting()
      end
    end
  end, false, 0, "RefreshEnvironment", true)
end

function M:DelayUpdateLighting()
  if not self.ArmoryHelper then
    return
  end
  self.ArmoryHelper:AddTimer(0.03, function()
    self:NotifyHelperUpdateLighting()
  end, false, 0, "DelayUpdateSceneLighting", true)
end

function M:NotifyHelperUpdateLighting()
  if not self.ArmoryHelper then
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
end

function M:RefreshUIArtNiagara()
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
  if not self.ArmoryHelper then
    return
  end
  self.SkyBoxIndex = Index or 0
  self.ArmoryHelper.SkyBoxIndex = self.SkyBoxIndex
  
  local function CallSkyBoxChanged()
    local bSuccess = self:WaitForPreviewSceneLoadFinished()
    if not bSuccess then
      return
    end
    self:DelayUpdateLighting()
  end
  
  self:DoSomethingWithScene("OnSkyBoxIndexChange", CallSkyBoxChanged)
end

function M:OnPreviewSceneLoaded()
  self.IsPreviewSceneLoading = false
  self:DoDeferredSceneBehavior()
  self:RefreshUIArtNiagara()
  if self.bPendingLightingUpdate then
    self.ArmoryHelper:RemoveTimer("DelayUpdateSceneLighting")
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
