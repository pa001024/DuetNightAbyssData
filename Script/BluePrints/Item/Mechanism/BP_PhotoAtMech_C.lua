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
  EventManager:RemoveEvent(EventID.OnInitScreenshotParams, self)
  EventManager:RemoveEvent(EventID.OnScreenshotToken, self)
end

function BP_PhotoAtMech_C:OpenPhotoCamera()
  if not DataMgr.PhotoCamera[self.PhotoAtPlaceId] then
    DebugPrint("yly BP_PhotoAtMech_C:OpenPhotoCamera PhotoAtPlaceId: ", self.PhotoAtPlaceId, " not found!")
    self:ReturnToReady()
    return
  end
  EventManager:AddEvent(EventID.OnInitScreenshotParams, self, self.OnInitScreenshotParams)
  EventManager:AddEvent(EventID.OnScreenshotToken, self, self.OnScreenshotToken)
  local UIMgr = GWorld.GameInstance:GetGameUIManager()
  if not UIMgr then
    self:ReturnToReady()
    return
  end
  UIMgr:LoadUINew("PhotoCameraMain")
end

function BP_PhotoAtMech_C:OnInitScreenshotParams(InOutParams)
  local CameraData = DataMgr.PhotoCamera[self.PhotoAtPlaceId]
  if not CameraData then
    return
  end
  if CameraData.IsSetParams then
    InOutParams.FocalLength = CameraData.FocalLength
  end
  if CameraData.LookAtTarget and CameraData.LookAtTarget ~= "" then
    InOutParams.LookAtTargetName = CameraData.LookAtTarget
  end
  InOutParams.StartPos = CameraData.StartPos or ""
  InOutParams.bStartHiddenRole = CameraData.IsStartHiddenRole
  InOutParams.bForceGamePause = CameraData.IsStartPause
  InOutParams.bLockGamePause = CameraData.IsLockPause
  InOutParams.LockHiddenList = {
    CameraData.IsLockHiddenRole and UIConst.PhotoCameraHiddenButton.Role or nil
  }
  
  function InOutParams.CloseCallback(Params)
    self:ReturnToReady()
  end
end

function BP_PhotoAtMech_C:OnScreenshotToken()
end

return BP_PhotoAtMech_C
