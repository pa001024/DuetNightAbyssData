local M = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")

function M:Init()
  self.bIsForceOpenCamera = false
  self.bGuideUIEnable = false
  self.GuideType = nil
  self._GuidePointName = ""
  self.TargetPointList = {}
  self.Text_TargetFound = ""
  self.Text_TargetNotFound = ""
  self.bShouldSetCameraParams = false
  self.FocalLength = 0
  self.LookAtTargetName = ""
  self.BlackScreenHandle = "CameraNode"
  self.CameraUIName = "PhotoCameraMain"
  self.StartPos = ""
  self.bLockCameraPos = false
  self.bStartHiddenRole = false
  self.bLockHiddenRole = false
  self.bLockHiddenPlayer = false
  self.bStartHiddenNPC = false
  self.bLockHiddenNPC = false
  self.bStartHiddenMonster = false
  self.bLockHiddenMonster = false
  self.bStartHiddenPet = false
  self.bLockHiddenPet = false
  self.bLockGamePause = false
  self.bForceGamePause = false
  self.ForceMaxLodStaticPointList = {}
end

function M:Execute(Callback)
  local function ExecuteLogic()
    self.Callback = Callback
    
    DebugPrint("------------ CameraNode Execute------------------")
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if not UIManager then
      Callback()
      return
    end
    EventManager:AddEvent(EventID.OnInitScreenshotParams, self, self.OnInitScreenshotParams)
    if self.bIsForceOpenCamera then
      local function OpenCamera()
        UIManager:HideCommonBlackScreen(self.BlackScreenHandle)
        
        UIManager:LoadUINew(self.CameraUIName)
      end
      
      if self.bFadeInOut then
        self:DisablePlayerInput(true)
        UIManager:ShowCommonBlackScreen({
          BlackScreenHandle = self.BlackScreenHandle,
          InAnimationObj = self,
          InAnimationCallback = OpenCamera,
          InAnimationPlayTime = 1
        })
      else
        OpenCamera()
      end
    end
  end
  
  if self.ForceMaxLodStaticPointList and next(self.ForceMaxLodStaticPointList) then
    self:HandleStaticPointActorsLOD(true)
    GWorld.GameInstance:AddTimer(0.05, ExecuteLogic)
  else
    ExecuteLogic()
  end
end

function M:DisablePlayerInput(bDisable)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if not IsValid(Player) then
    return
  end
  local PC = Player:GetController()
  if IsValid(PC) and PC:IsA(APlayerController) then
    if bDisable then
      Player:AddDisableInputTag("CameraNode")
    else
      Player:RemoveDisableInputTag("CameraNode")
    end
  end
end

function M:OnInitScreenshotParams(InOutParams)
  InOutParams.TargetPointNames = self.TargetPointList
  InOutParams.Text_TargetFound = GText(self.Text_TargetFound)
  if not self.Text_TargetFound or self.Text_TargetFound == "" then
    InOutParams.Text_TargetFound = GText("UI_CameraSystem_QuestSucc_Default")
  end
  InOutParams.Text_TargetNotFound = GText(self.Text_TargetNotFound)
  if not self.Text_TargetNotFound or "" == self.Text_TargetNotFound then
    InOutParams.Text_TargetNotFound = GText("UI_CameraSystem_QuestFailed_Default")
  end
  InOutParams.StartPos = self.StartPos
  InOutParams.bLockCameraPos = self.bLockCameraPos
  InOutParams.LockHiddenList = {
    self.bLockHiddenRole and UIConst.PhotoCameraHiddenButton.Role or nil,
    self.bLockHiddenPlayer and UIConst.PhotoCameraHiddenButton.Player or nil,
    self.bLockHiddenNPC and UIConst.PhotoCameraHiddenButton.NPC or nil,
    self.bLockHiddenMonster and UIConst.PhotoCameraHiddenButton.Monster or nil,
    self.bLockHiddenPet and UIConst.PhotoCameraHiddenButton.Pet or nil
  }
  InOutParams.bStartHiddenRole = self.bStartHiddenRole
  InOutParams.bStartHiddenPlayer = self.bStartHiddenPlayer
  InOutParams.bStartHiddenNPC = self.bStartHiddenNPC
  InOutParams.bStartHiddenMonster = self.bStartHiddenMonster
  InOutParams.bStartHiddenPet = self.bStartHiddenPet
  InOutParams.bLockGamePause = self.bLockGamePause
  InOutParams.bForceGamePause = self.bForceGamePause
  if self.bGuideUIEnable then
    MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    if UIManager then
      local TaskIndicator = UIManager:GetUIObj("TaskIndicator_" .. self.Key)
      if TaskIndicator then
        TaskIndicator:Show("UIPopUp")
      end
    end
  end
  if self.bShouldSetCameraParams then
    InOutParams.FocalLength = self.FocalLength
  end
  if self.LookAtTargetName and "" ~= self.LookAtTargetName then
    InOutParams.LookAtTargetName = self.LookAtTargetName
  end
  
  function InOutParams.CloseCallback(Params)
    if self.bIsForceOpenCamera and self.bFadeInOut then
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      if UIManager then
        UIManager:ShowCommonBlackScreen({
          BlackScreenHandle = self.BlackScreenHandle,
          OutAnimationObj = self,
          OutAnimationCallback = function()
            self:OnCameraUIClosed(Params)
          end,
          OutAnimationPlayTime = 1,
          IsPlayOutWhenLoaded = true
        })
      end
    else
      self:OnCameraUIClosed(Params)
    end
  end
end

function M:OnCameraUIClosed(Params)
  self:DisablePlayerInput(false)
  self:HandleStaticPointActorsLOD(false)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  if UIManager then
    local TaskIndicator = UIManager:GetUIObj("TaskIndicator_" .. self.Key)
    if TaskIndicator then
      TaskIndicator:Hide("UIPopUp")
    end
  end
  if not Params.IsSucceeded then
    return
  end
  self.Callback("Success")
  self:Clear()
  self.Cleared = true
end

function M:Clear()
  if self.Cleared then
    return
  end
  self.Cleared = true
  EventManager:RemoveEvent(EventID.OnInitScreenshotParams, self)
  if self.bGuideUIEnable then
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
end

function M:HandleStaticPointActorsLOD(bSetMaxLOD)
  if bSetMaxLOD then
    if not self.ForceMaxLodStaticPointList or not next(self.ForceMaxLodStaticPointList) then
      return
    end
    self.SavedLodActors = {}
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if not IsValid(GameState) then
      return
    end
    local MaxLod = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" and 1 or 1
    for _, StaticCreatorId in pairs(self.ForceMaxLodStaticPointList) do
      local CreatorInfo = GameState:GetStaticCreatorInfo(StaticCreatorId)
      if IsValid(CreatorInfo) then
        local Actors = UE4.URuntimeCommonFunctionLibrary.GetStaticCreatorChildActors(GWorld.GameInstance, CreatorInfo)
        for _, Actor in pairs(Actors) do
          if IsValid(Actor) and IsValid(Actor.Mesh) and type(Actor.Mesh.SetForcedLOD) == "function" then
            local OriginalLOD = Actor.Mesh:GetForcedLOD()
            self.SavedLodActors[Actor] = OriginalLOD
            Actor.Mesh:SetForcedLOD(MaxLod)
            DebugPrint("lgc@HandleStaticPointActorsLOD(Set): StaticCreatorId = " .. tostring(StaticCreatorId) .. ", Actor = " .. Actor:GetName() .. ", OriginalLOD = " .. tostring(OriginalLOD) .. ", NewLOD = " .. tostring(MaxLod))
          end
        end
        if not Actors or 0 == Actors:Num() then
          DebugPrint("lgc@HandleStaticPointActorsLOD(Set): 没有找到静态刷新点ID = " .. tostring(StaticCreatorId) .. " 对应的Actors")
        end
      else
        DebugPrint("lgc@HandleStaticPointActorsLOD(Set): 找不到静态刷新点ID = " .. tostring(StaticCreatorId))
      end
    end
  else
    if not self.SavedLodActors or not next(self.SavedLodActors) then
      return
    end
    for Actor, OriginalLOD in pairs(self.SavedLodActors) do
      if IsValid(Actor) and IsValid(Actor.Mesh) and type(Actor.Mesh.SetForcedLOD) == "function" then
        Actor.Mesh:SetForcedLOD(OriginalLOD)
        DebugPrint("lgc@HandleStaticPointActorsLOD(Restore): Actor = " .. Actor:GetName() .. ", RestoredLOD = " .. tostring(OriginalLOD))
      end
    end
    self.SavedLodActors = {}
  end
end

return M
