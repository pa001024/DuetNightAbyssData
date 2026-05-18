local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local ClientEventUtils = require("BluePrints.Common.ClientEvent.ClientEventUtils")
local GuidePointLocData = require("BluePrints.UI.TaskPanel/QuestGuidePointLocData")
local PickUpInteractiveNode = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")
local QuestNodeUtils = require("StoryCreator.StoryLogic.QuestNodeUtils")
local TalkCameraManager_C = require("BluePrints.Story.Talk.Controller.TalkCameraManager")

function PickUpInteractiveNode:Init()
  self.StaticCreatorId = 0
  self.UnitId = 0
  self.bGuideUIEnable = false
  self.GuideType = "P"
  self.GuidePointName = ""
  self.StaticCreatorArray = TArray(0)
  self.Player = nil
  self.GameState = nil
  self.LongPressTime = 0
  self.MontageName = ""
  self.bFocusEnable = false
  self.SequencePath = ""
  self.Pickup = nil
end

function PickUpInteractiveNode:Execute(Callback)
  DebugPrint("------------ PickUpInteractiveNode ------------------")
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  self.StaticCreatorArray:Add(self.StaticCreatorId)
  QuestNodeUtils.STLTriggerActiveStaticCreator(self, self.StaticCreatorArray)
  
  local function SuccessCallback()
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local IndicatorName = "TaskIndicator_" .. self.Key
    local UIObj = UIManager:GetUIObj(IndicatorName)
    if UIObj and UIObj.GuideInfoCache then
      local TargetKey = UIObj.GuideInfoCache.PointOrStaticCreatorName
      if TargetKey and GuidePointLocData[TargetKey] then
        MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
      end
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    GameMode:RemovePickUpSuccessCallback(self.UnitId, self.NodeId)
    Callback(nil)
  end
  
  GameMode:AddPickUpSuccessCallback(self.UnitId, self.NodeId, SuccessCallback)
  EventManager:AddEvent(EventID.OnManualPickUpReady, self, self.OnManualPickUpReady)
  self.Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  self:AddGuide()
end

function PickUpInteractiveNode:OnCancelTrack()
end

function PickUpInteractiveNode:OnChooseTrack()
end

function PickUpInteractiveNode:AddGuide()
  if self.bGuideUIEnable then
    local GuideType = self.GuideType
    local GuidePointName = self.GuidePointName
    if self.GuideType == "" or self.GuidePointName == "" and #self.StaticCreatorIdList > 0 then
      GuideType = "Drop"
      self.GuideType = GuideType
      self.GameState = UGameplayStatics.GetGameState(GWorld.GameInstance)
      if 1 == #self.StaticCreatorIdList then
        local StaticCreator = self.GameState:GetStaticCreatorInfo(self.StaticCreatorIdList[1])
        if StaticCreator then
          GuidePointName = StaticCreator.DisplayName
          self.GuidePointName = GuidePointName
        end
      else
        for _, StaticCreatorId in pairs(self.StaticCreatorIdList) do
          local StaticCreator = self.GameState:GetStaticCreatorInfo(StaticCreatorId)
          if StaticCreator then
            table.insert(self.GuideCreator, StaticCreator)
          end
        end
        return
      end
    end
    MissionIndicatorManager:ActiveMissionIndicatorByNode(self)
  end
end

function PickUpInteractiveNode:Clear()
  if IsValid(self.CameraSequenceActor) then
    self.CameraSequenceActor:K2_DestroyActor()
    self.CameraSequenceActor = nil
  end
  if IsValid(self.TalkPawn) then
    self.TalkPawn:K2_DestroyActor()
    self.TalkPawn = nil
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  GameMode:TriggerInactiveStaticCreator(self.StaticCreatorArray)
  GameMode:RemovePickUpSuccessCallback(self.UnitId, self.NodeId)
  if self.bGuideUIEnable then
    MissionIndicatorManager:ReactiveMissionIndicatorByNode(self)
  end
  EventManager:RemoveEvent(EventID.OnManualPickUpReady, self)
end

function PickUpInteractiveNode:OnManualPickUpReady(Pickup)
  if Pickup.CreatorId == self.StaticCreatorId then
    Pickup.PickUpInteractiveComponent.InteractiveTime = self.LongPressTime
    Pickup.PickUpInteractiveComponent.MontageName = self.MontageName
    Pickup.PickUpInteractiveComponent.OnPickupPressed = {
      self,
      self.OnPickupPressed
    }
    Pickup.PickUpInteractiveComponent.OnPickupReleased = {
      self,
      self.OnPickupReleased
    }
    self.Pickup = Pickup
  end
end

function PickUpInteractiveNode:OnPickupPressed()
  DebugPrint("PickUpInteractiveNode Start")
  if self.SequencePath == "" and self.bFocusEnable then
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    local PlayerCameraManager = UE4.UGameplayStatics.GetPlayerCameraManager(GWorld.GameInstance, 0)
    local CurrentCameraLoc = PlayerCameraManager:GetCameraLocation()
    local CurrentCameraRot = PlayerCameraManager:GetCameraRotation()
    if not IsValid(self.TalkPawn) then
      local TalkPawnClass = LoadClass("/Game/BluePrints/Story/Talk/Base/BP_TalkPlayerPawn.BP_TalkPlayerPawn_C")
      self.TalkPawn = GWorld.GameInstance:GetWorld():SpawnActor(TalkPawnClass, UE4.UKismetMathLibrary.MakeTransform(CurrentCameraLoc, CurrentCameraRot, FVector(1)))
    end
    local PlayerLoc = self.Player:k2_GetActorLocation()
    local PickupLoc = self.Pickup:k2_GetActorLocation()
    FVector.Sub(CurrentCameraLoc, PlayerLoc)
    CurrentCameraLoc:Set(CurrentCameraLoc.X, CurrentCameraLoc.Y, 0)
    CurrentCameraLoc:Normalize()
    CurrentCameraLoc = CurrentCameraLoc * self.Player.CharSpringArmComponent.BaseTargetArmLength
    FVector.Add(CurrentCameraLoc, PlayerLoc)
    local PlayerForward = UKismetMathLibrary.Subtract_VectorVector(PickupLoc, PlayerLoc)
    local ProceduralCameraData = DataMgr.FreeCamera[1]
    local TargetLoc = URuntimeCommonFunctionLibrary.CalculateProceduralLocation(PlayerLoc, PlayerForward, CurrentCameraLoc, PickupLoc, ProceduralCameraData.PushDistance, ProceduralCameraData.PullDistance, ProceduralCameraData.BlockRange, ProceduralCameraData.IfBlockThenRot, ProceduralCameraData.CameraHeight)
    local TempRot = UKismetMathLibrary.MakeRotFromX(FVector(PlayerForward.X, PlayerForward.Y, 0))
    TargetLoc = UKismetMathLibrary.GreaterGreater_VectorRotator(TargetLoc, TempRot)
    FVector.Add(PlayerLoc, PickupLoc)
    FVector.Add(TargetLoc, PlayerLoc / 2)
    self.TalkPawn:SetCameraLoc(TargetLoc)
    USequenceFunctionLibrary.SetViewTargetWithBlend(PlayerController, self.TalkPawn, self.LongPressTime, UE4.EViewTargetBlendFunction.VTBlend_EaseInOut, 2)
  elseif self.SequencePath ~= "" then
    if not IsValid(self.CameraSequenceActor) then
      self.CameraSequenceActor = GWorld.GameInstance:GetWorld():SpawnActor(ALevelSequenceActor)
      local Sequence = UE4.LoadObject(self.SequencePath)
      if not Sequence then
        return
      end
      self.CameraSequenceActor:SetSequence(Sequence)
      self.CameraSequenceActor.bOverrideInstanceData = 1
      self.CameraSequenceActor.DefaultInstanceData.TransformOrigin = FTransform()
    end
    if not IsValid(self.CameraSequenceActor) then
      local Message = string.format("%s start failed, CameraSequenceActor is invalid", self:GetName())
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "任务交互节点", Message)
      return
    end
    self.CameraSequenceActor.SequencePlayer:Play()
  end
end

function PickUpInteractiveNode:OnPickupReleased()
  DebugPrint("PickUpInteractiveNode End")
  if self.SequencePath == "" then
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    USequenceFunctionLibrary.SetViewTarget(PlayerController, self.Player)
  elseif self.CameraSequenceActor then
    self.CameraSequenceActor.SequencePlayer:Stop()
  end
end

function PickUpInteractiveNode:AdaptCameraComponent(CameraComponent)
  if not IsValid(CameraComponent) then
    return
  end
  local AspectRatio, FOV, bConstrainAspectRatio = CommonUtils:GetCurrentAspectRatioAndFOV()
  if URuntimeCommonFunctionLibrary.ObjIsChildOf(CameraComponent, UCineCameraComponent) then
    local CineCameraComponent = CameraComponent
    if IsValid(CineCameraComponent) then
      local DesiredHeight = CineCameraComponent.Filmback.SensorWidth / AspectRatio
      CineCameraComponent.bConstrainAspectRatio = false
      CineCameraComponent:SetFieldOfView(FOV)
      CineCameraComponent.Filmback.SensorHeight = DesiredHeight
    end
  elseif URuntimeCommonFunctionLibrary.ObjIsChildOf(CameraComponent, UCameraComponent) then
    CameraComponent.bConstrainAspectRatio = false
    CameraComponent:SetFieldOfView(FOV)
    CameraComponent:SetAspectRatio(AspectRatio)
  end
end

return PickUpInteractiveNode
