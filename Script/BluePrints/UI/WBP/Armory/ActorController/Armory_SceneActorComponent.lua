local M = {}

function M:Init()
  self.SceneCoroutineMap = {}
  self.SceneCoroutineArray = {}
end

local PreviewSceneLoaded = {}

local function IncreacePreviewSceneRefCount(PreviewLevelName)
  PreviewSceneLoaded[PreviewLevelName] = PreviewSceneLoaded[PreviewLevelName] or 0
  PreviewSceneLoaded[PreviewLevelName] = PreviewSceneLoaded[PreviewLevelName] + 1
end

local function DecreacePreviewSceneRefCount(PreviewLevelName)
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

local function _RemoveSceneCoroutine(self, CoroutineName)
  local Idx = self.SceneCoroutineMap[CoroutineName]
  if Idx then
    table.remove(self.SceneCoroutineArray, Idx)
  end
end

local function _AddSceneCoroutine(self, CoroutineName, Co)
  _RemoveSceneCoroutine(self, CoroutineName)
  table.insert(self.SceneCoroutineArray, Co)
  self.SceneCoroutineMap[CoroutineName] = #self.SceneCoroutineArray
end

local function _FindSceneCoroutine(self, CoroutineName)
  local Idx = self.SceneCoroutineMap[CoroutineName]
  if Idx then
    return self.SceneCoroutineArray[Idx]
  end
end

local function _HadAnyPreviewScene()
  return next(PreviewSceneLoaded) ~= nil
end

function M:GetPreviewSceneTrans()
  return self.PreviewSceneTrans
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

function M:TryLoadPreviewScene(SceneType)
  if _HadAnyPreviewScene() then
    self.EPreviewSceneType = self.EPreviewSceneType or CommonConst.EPreviewSceneType.PreviewCommon
  end
  self.EPreviewSceneType = SceneType or self.EPreviewSceneType
  local Path = CommonConst.PreviewScenePaths[self.EPreviewSceneType]
  if not Path then
    return
  end
  if not self.PreviewSceneLocation then
    local Loc = 180000 + self.EPreviewSceneType * 1000
    self.PreviewSceneLocation = FVector(Loc, Loc, Loc)
  end
  local PreviewLevelLocation = self.PreviewSceneLocation
  local GameMode = UE4.UGameplayStatics.GetGameMode(self.ViewUI)
  local WorldLoader = GameMode:GetLevelLoader()
  local TargetTrans
  if WorldLoader then
    TargetTrans = FTransform()
    TargetTrans.Translation = PreviewLevelLocation
    TargetTrans.Rotation = FRotator(0, 0, 0):ToQuat()
    self.PreviewSceneTrans = TargetTrans
    local PreviewLevelName = "PreviewLevel" .. self.EPreviewSceneType
    self.IsPreviewSceneLoading = true
    if not IsPreviewSceneHasRef(PreviewLevelName) then
      local bSuccess = WorldLoader:LoadPreviewLevel(PreviewLevelName, Path, function()
        self.ViewUI:AddTimer(0.1, function()
          self.ArmoryHelper:SetPreviewLevelActor(GetLevelScriptActor(WorldLoader, PreviewLevelName))
          self.ArmoryHelper:OnPreviewSceneLoaded()
          self:OnPreviewSceneLoaded()
        end)
      end, PreviewLevelLocation, FRotator(0, 0, 0))
      if bSuccess then
        self.PreviewLevelName = PreviewLevelName
        IncreacePreviewSceneRefCount(PreviewLevelName)
        self.bPreviewSceneLoaded = true
      else
        self.PreviewSceneTrans = nil
      end
    else
      IncreacePreviewSceneRefCount(PreviewLevelName)
      self.bPreviewSceneLoaded = true
      self.PreviewLevelName = PreviewLevelName
      self.ArmoryHelper:AddTimer(0.1, function()
        if IsValid(self.ArmoryHelper) then
          self.ArmoryHelper:SetPreviewLevelActor(GetLevelScriptActor(WorldLoader, PreviewLevelName))
          self.ArmoryHelper:OnPreviewSceneLoaded()
        end
        self:OnPreviewSceneLoaded()
      end, false, 0, "DelayCallSceneLoaded", true)
    end
  end
end

function M:UnloadPreviewScene()
  if self.bPreviewSceneLoaded then
    local PreviewLevelName = "PreviewLevel" .. self.EPreviewSceneType
    self.bPreviewSceneLoaded = false
    DecreacePreviewSceneRefCount(PreviewLevelName)
    if not IsPreviewSceneHasRef(PreviewLevelName) then
      local GameMode = UE4.UGameplayStatics.GetGameMode(self.ViewUI)
      local WorldLoader = GameMode:GetLevelLoader()
      if WorldLoader then
        self:DisableEnvirSystem(true)
        local Controller = UE4.UGameplayStatics.GetPlayerController(self.ArmoryHelper, 0)
        if Controller then
          UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(Controller)
        end
        WorldLoader:UnloadPreviewLevel("PreviewLevel" .. self.EPreviewSceneType)
        if IsValid(self.ArmoryHelper) then
          self.ArmoryHelper:SetPreviewLevelActor(nil)
          self.ArmoryHelper:OnPreviewSceneUnloaded()
        end
        DebugPrint("CY@ OnPreviewSceneUnloaded", self.ObjId)
      end
    end
  end
end

function M:RefreshEnvironment(NeedUpdataLighting)
  self.ArmoryHelper:AddTimer(0.03, function()
    local EnvironmentManager = UE4.UGameplayStatics.GetActorOfClass(self.ViewUI, UE4.AEnvironmentManager:StaticClass())
    if EnvironmentManager then
      self:DisableEnvirSystem(true)
      local Controller = UE4.UGameplayStatics.GetPlayerController(self.ArmoryHelper, 0)
      if Controller then
        UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(Controller)
      end
      EnvironmentManager:Refresh(true)
      DebugPrint("CY@ RefreshEnvironment", self.ObjId)
      if NeedUpdataLighting then
        self:DelayUpdateSceneLighting()
      end
    end
  end, false, 0, "RefreshEnvironment", true)
end

function M:CancelRefreshEnvironment()
  self.ArmoryHelper:RemoveTimer("RefreshEnvironment")
end

function M:GetEnvirSystemActor()
  if IsValid(self.ArmoryHelper) then
    local PreviewLevelActor = self.ArmoryHelper:GetPreviewLevelActor()
    local EnvirSystemActor = PreviewLevelActor and PreviewLevelActor.GetEnvirSystemActor and PreviewLevelActor:GetEnvirSystemActor()
    return EnvirSystemActor
  end
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

function M:StartPreviewBGAnimation(PreviewBGPos, Time)
  local function _StartPreviewBGAnimation(...)
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
    self.ArmoryHelper:StartPreviewBGAnimation(TargetBGLoc, Time)
  end
  
  self:DoSomethingWithScene("StartPreviewBGAnimation", _StartPreviewBGAnimation)
end

function M:DisableEnvirSystem(bDisable)
  local function _DisableEnvirSystem(...)
    local bSuccess = self:WaitForPreviewSceneLoadFinished()
    
    if not bSuccess then
      return
    end
    local EnvirSystemActor = self:GetEnvirSystemActor()
    if EnvirSystemActor then
      EnvirSystemActor.Disable = bDisable
    end
  end
  
  self:DoSomethingWithScene("DisableEnvirSystem", _DisableEnvirSystem)
end

function M:ChangeSkyBoxColor(Index)
  if not self.ArmoryHelper then
    return
  end
  self.SkyBoxIndex = Index or 0
  self.ArmoryHelper.SkyBoxIndex = self.SkyBoxIndex
  
  local function _CallSkyBoxChanged(...)
    local bSuccess = self:WaitForPreviewSceneLoadFinished()
    if not bSuccess then
      return
    end
    self:DelayUpdateSceneLighting()
    DebugPrint("CY@ SkyBoxColorChanged", self.ObjId, self.ArmoryHelper.SkyBoxIndex)
  end
  
  self:DoSomethingWithScene("OnSkyBoxIndexChange", _CallSkyBoxChanged)
end

function M:DoSomethingWithScene(BehaviorName, Func, ...)
  local Co = _FindSceneCoroutine(self, BehaviorName)
  if Co then
    local Status = coroutine.status(Co)
    if "running" == Status or "suspended" == Status then
      coroutine.close(Co)
      _RemoveSceneCoroutine(self, BehaviorName)
    end
  end
  Co = coroutine.create(Func)
  _AddSceneCoroutine(self, BehaviorName, Co)
  coroutine.resume(Co, ...)
end

function M:DoDeferedSceneBehavior()
  local SceneCoroutineArray = {}
  for _, value in ipairs(self.SceneCoroutineArray) do
    table.insert(SceneCoroutineArray, value)
  end
  self.SceneCoroutineArray = {}
  self.SceneCoroutineMap = {}
  for _, Co in ipairs(SceneCoroutineArray) do
    coroutine.resume(Co)
  end
end

function M:IsSceneActorLoading()
  return self.IsPreviewSceneLoading
end

function M:OnPreviewSceneLoaded()
  self:DisableEnvirSystem(false)
  self.IsPreviewSceneLoading = false
  self:DoDeferedSceneBehavior()
  if not self.IsPlayingSequence then
    self:UpdateSceneLighting()
  end
end

function M:UpdateSceneLighting()
  local function _NotifyPreviewSceneUpdateLight(...)
    local bSuccess = self:WaitForPreviewSceneLoadFinished()
    
    if not bSuccess then
      return
    end
    UKismetSystemLibrary.ExecuteConsoleCommand(self.ViewUI, "r.Shadow.ForceCacheUpdate 1", nil)
    
    local function _CallBP_WaitForWeaponLoading()
      if self.IsArmoryWeaponLoading then
        self:GetWeaponActor()
      end
      self:DelayUpdateSceneLighting()
    end
    
    self:DoSomethingWithWeapon("CallBP_WaitForWeaponLoading", _CallBP_WaitForWeaponLoading)
    
    local function _CallBP_WaitForPlayerLoading()
      if self.IsArmoryPlayerLoading then
        self:GetPlayerActor()
      end
      self:DelayUpdateSceneLighting()
    end
    
    self:DoSomethingWithPlayer("CallBP_WaitForPlayerLoading", _CallBP_WaitForPlayerLoading)
  end
  
  self:DoSomethingWithScene("NotifyPreviewSceneUpdateLight", _NotifyPreviewSceneUpdateLight)
end

function M:DelayUpdateSceneLighting()
  self.ArmoryHelper:AddTimer(0.03, function()
    self:NotifyHelperUpdateLighting()
  end, false, 0, "DelayUpdateSceneLighting", true)
end

function M:CancelUpdateSceneLighting()
  self.ArmoryHelper:RemoveTimer("DelayUpdateSceneLighting")
end

function M:NotifyHelperUpdateLighting()
  if self.IsArmoryWeaponLoading or self.IsArmoryPlayerLoading then
    return
  end
  if IsValid(self.ArmoryHelper) then
    self.ArmoryHelper.SkyBoxIndex = self.SkyBoxIndex or 0
    self.ArmoryHelper:UpdateDirLight(true)
    if self.bPreviewSceneLoaded then
      self.ArmoryHelper:UpdateLighting()
    end
    DebugPrint("CY@ HelperUpdateLighting", self.ObjId, self.bPreviewSceneLoaded)
  end
end

function M:SwitchArmoryCamera(IsArmoryCamera)
  if IsArmoryCamera then
    self.ArmoryHelper:UpdateDirLight(true)
  end
end

function M:Component_OnClosed()
  self.ArmoryHelper:UpdateDirLight(false)
end

function M:Component_DestroyActors()
  self:UnloadPreviewScene()
end

function M:Component_AfterDestroyActors()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if Player then
    Player.CharCameraComponent:SetComponentTickEnabled(true)
    if self.EPreviewSceneType then
      UKismetSystemLibrary.ExecuteConsoleCommand(Player, "r.Shadow.ForceCacheUpdate 1", nil)
    end
  end
end

return M
