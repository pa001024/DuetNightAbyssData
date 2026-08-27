require("UnLua")
local BP_PhotoAtMech_C = Class("BluePrints.Item.Chest.BP_MechanismBase_C")
local PhotoSpotState = {Ready = 1800200, Photographing = 1800201}

function BP_PhotoAtMech_C:AuthorityInitInfo(Info)
  BP_PhotoAtMech_C.Super.AuthorityInitInfo(self, Info)
end

function BP_PhotoAtMech_C:CommonInitInfo(Info)
  BP_PhotoAtMech_C.Super.CommonInitInfo(self, Info)
  self.PhotoAtPlaceId = self.PhotoSpotId
  if self.UnitParams and self.UnitParams.PhotoSpotId then
    self.PhotoAtPlaceId = self.UnitParams.PhotoSpotId
  end
  DebugPrint("yly BP_PhotoAtMech_C:CommonInitInfo PhotoAtPlaceId: ", self.PhotoAtPlaceId)
end

function BP_PhotoAtMech_C:ClientInitInfo(Info)
  BP_PhotoAtMech_C.Super.ClientInitInfo(self, Info)
end

function BP_PhotoAtMech_C:OnActorReady(Info)
  BP_PhotoAtMech_C.Super.OnActorReady(self, Info)
end

function BP_PhotoAtMech_C:GetCanOpen(PlayerEid)
  if self.PhotoSpotId == nil or nil == DataMgr.PhotoCamera[self.PhotoSpotId] then
    return false
  end
  if self.StateId == PhotoSpotState.Photographing then
    return false
  end
  return true
end

function BP_PhotoAtMech_C:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  if NowStateId == PhotoSpotState.Photographing then
    self:OpenPhotoCamera()
    EventManager:AddEvent(EventID.OnScreenshotToken, self, self.OnPhotoSpotShutter)
  end
end

function BP_PhotoAtMech_C:OnLeaveState(NowStateId, NextStateId)
  self.Overridden.OnLeaveState(self, NowStateId, NextStateId)
  if NowStateId == PhotoSpotState.Photographing then
    self:CleanPhotoListeners()
  end
end

function BP_PhotoAtMech_C:ReturnToReady()
  self:ChangeState("Manual", 0, PhotoSpotState.Ready)
end

function BP_PhotoAtMech_C:CleanPhotoListeners()
  EventManager:RemoveEvent(EventID.OnScreenshotToken, self)
end

local function CreateCameraParams(CameraData, InOutParams)
  InOutParams.From = "PhotoAtMech"
  if CameraData.LookAtTarget and CameraData.LookAtTarget ~= "" then
    InOutParams.LookAtTargetName = CameraData.LookAtTarget
  end
  InOutParams.TargetPointNames = CameraData.TargetPointList or {}
  if CameraData.IsSetParams then
    InOutParams.FocalLength = CameraData.FocalLength
    InOutParams.StartPos = CameraData.StartPos
    InOutParams.StartRotation = CameraData.StartRotation
  end
  InOutParams.bLockCameraPos = CameraData.IsLockCamPos
  InOutParams.LockHiddenList = {
    false,
    CameraData.IsLockHiddenRole and UIConst.PhotoCameraHiddenButton.Player or nil,
    CameraData.IsLockHiddenNPC and UIConst.PhotoCameraHiddenButton.NPC or nil,
    CameraData.IsLockHiddenMon and UIConst.PhotoCameraHiddenButton.Monster or nil,
    CameraData.IsLockHiddenPet and UIConst.PhotoCameraHiddenButton.Pet or nil
  }
  InOutParams.bStartHiddenPlayer = CameraData.IsStartHiddenRole
  InOutParams.bStartHiddenNPC = CameraData.IsStartHiddenNPC
  InOutParams.bStartHiddenMonster = CameraData.IsStartHiddenMon
  InOutParams.bStartHiddenPet = CameraData.IsStartHiddenPet
  InOutParams.bLockGamePause = CameraData.IsLockPause
  InOutParams.bForceGamePause = CameraData.IsStartPause
end

function BP_PhotoAtMech_C:DisablePlayerInput(bDisable)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if not IsValid(Player) then
    return
  end
  local PC = Player:GetController()
  if IsValid(PC) and PC:IsA(APlayerController) then
    if bDisable then
      Player:AddDisableInputTag("PhotoAtMech")
    else
      Player:RemoveDisableInputTag("PhotoAtMech")
    end
  end
end

local function ResolvePhotoSpotPointIdentity(Mech)
  if Mech.CreatorId and Mech.CreatorId > 0 then
    return CommonConst.MechanismPointType.StaticCreator, Mech.CreatorId
  end
  if Mech.ManualItemId and Mech.ManualItemId > 0 then
    return CommonConst.MechanismPointType.ManualItem, Mech.ManualItemId
  end
  return nil, nil
end

function BP_PhotoAtMech_C:OpenPhotoCamera()
  local CameraData = DataMgr.PhotoCamera[self.PhotoAtPlaceId]
  if not CameraData then
    DebugPrint("yly BP_PhotoAtMech_C:OpenPhotoCamera PhotoAtPlaceId: ", self.PhotoAtPlaceId, " not found!")
    self:ReturnToReady()
    return
  end
  
  local function ExecuteLogic()
    self:DisablePlayerInput(false)
    local UIMgr = GWorld.GameInstance:GetGameUIManager()
    if not UIMgr then
      self:ReturnToReady()
      return
    end
    local InOutParams = {}
    CreateCameraParams(CameraData, InOutParams)
    
    function InOutParams.CloseCallback(Params)
      if CameraData.MaxLoadList and next(CameraData.MaxLoadList) then
        self:HandleStaticPointActorsLOD(false, CameraData.MaxLoadList)
      end
      self:ReturnToReady()
      if Params.IsTakeAnyPhoto and Params.From == "PhotoAtMech" then
        self:OnPhotoSpotSessionShot()
      end
    end
    
    UIMgr:LoadUINew("PhotoCameraMain", InOutParams)
  end
  
  if CameraData.MaxLoadList and next(CameraData.MaxLoadList) then
    self:HandleStaticPointActorsLOD(true, CameraData.MaxLoadList)
    self:DisablePlayerInput(true)
    GWorld.GameInstance:AddTimer(0.05, ExecuteLogic)
  else
    ExecuteLogic()
  end
end

function BP_PhotoAtMech_C:HandleStaticPointActorsLOD(bSetMaxLOD, ForceMaxLodStaticPointList)
  local CameraNode = require("StoryCreator.StoryLogic.StorylineNodes.QuestNodes.CameraNode")
  CameraNode.HandleStaticPointActorsLOD(self, bSetMaxLOD, ForceMaxLodStaticPointList)
end

function BP_PhotoAtMech_C:OnPhotoSpotSessionShot()
  EventManager:FireEvent(EventID.OnPhotoSpotShot, self.CreatorId, self.ManualItemId, self.PhotoAtPlaceId)
end

function BP_PhotoAtMech_C:OnPhotoSpotShutter()
  local PointType, PointId = ResolvePhotoSpotPointIdentity(self)
  if not PointType or not PointId then
    DebugPrint("yly BP_PhotoAtMech_C:OnPhotoSpotShutter invalid identity", self.CreatorId, self.ManualItemId)
    return
  end
  DebugPrint("yly BP_PhotoAtMech_C:OnPhotoSpotShutter PointType=", PointType, " PointId=", PointId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:ServerTargetFinish(CommonConst.TargetTakePhotoCountAtPhotoSpot, -1, 1, PointType, PointId)
end

return BP_PhotoAtMech_C
