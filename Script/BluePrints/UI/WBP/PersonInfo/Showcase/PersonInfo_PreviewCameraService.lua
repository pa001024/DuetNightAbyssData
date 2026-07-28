require("UnLua")
local M = {}

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

local function EnsureCameraComponent(Actor)
  if not Actor then
    return nil
  end
  local CameraComponent = Actor:GetComponentByClass(UCameraComponent:StaticClass())
  if CameraComponent then
    return CameraComponent
  end
  if not Actor.AddComponentByClass then
    return nil
  end
  CameraComponent = Actor:AddComponentByClass(UCameraComponent:StaticClass(), false, FTransform(), false)
  if CameraComponent and URuntimeCommonFunctionLibrary and URuntimeCommonFunctionLibrary.RegisterComponent then
    URuntimeCommonFunctionLibrary.RegisterComponent(CameraComponent)
  end
  return CameraComponent
end

function M:Init(Params)
  Params = Params or {}
  self.ViewUI = Params.ViewUI
  self.SceneService = Params.SceneService
  self.CameraActor = nil
  self.CameraComponent = nil
  self.ViewTargetEvents = nil
  self.ViewTargetEventObj = nil
  self.IsControled = false
  self.EnableCameraScrolling = false
  self.StartPos = nil
  self.EndPos = nil
  self.StartRot = nil
  self.EndRot = nil
  self.BaseScrollLocation = nil
  self.OriginalFOV = nil
  self.CurrentFOV = nil
  self.PreviewLevelActor = nil
  self.DataForwardScrollLocation = nil
  self.DataBackwardScrollLocation = nil
  self.ForwardScrollLocation = nil
  self.BackwardScrollLocation = nil
  self.ForwardScrollDirection = nil
  self.BackwardScrollDirection = nil
  self.ForwardScrollLength = 0
  self.BackwardScrollLength = 0
  self.ScrollDirection = 0
  self.TargetScrollLength = 0
  self.ScrollAnimDuration = 0
  self.ScrollEase = 14
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

function M:BindViewTargetEvents(Events, Obj)
  self.ViewTargetEvents = Events or {}
  self.ViewTargetEventObj = Obj
end

function M:GetHelper()
  return self.SceneService and self.SceneService.GetHelper and self.SceneService:GetHelper() or nil
end

function M:SyncCameraComponentSettingsFromHelper()
  local CameraComponent = self:GetCameraComponent()
  local Helper = self:GetHelper()
  local HelperCamera = Helper and Helper.Camera or nil
  if not CameraComponent or not HelperCamera then
    return
  end
  if CameraComponent.SetConstraintAspectRatio and HelperCamera.bConstrainAspectRatio ~= nil then
    CameraComponent:SetConstraintAspectRatio(HelperCamera.bConstrainAspectRatio)
  elseif CameraComponent.bConstrainAspectRatio ~= nil and HelperCamera.bConstrainAspectRatio ~= nil then
    CameraComponent.bConstrainAspectRatio = HelperCamera.bConstrainAspectRatio
  end
  if CameraComponent.SetAspectRatio and nil ~= HelperCamera.AspectRatio then
    CameraComponent:SetAspectRatio(HelperCamera.AspectRatio)
  elseif nil ~= CameraComponent.AspectRatio and nil ~= HelperCamera.AspectRatio then
    CameraComponent.AspectRatio = HelperCamera.AspectRatio
  end
  if CameraComponent.SetFieldOfView and nil ~= HelperCamera.FieldOfView then
    CameraComponent:SetFieldOfView(HelperCamera.FieldOfView)
    self.CurrentFOV = HelperCamera.FieldOfView
    self.OriginalFOV = self.OriginalFOV or HelperCamera.FieldOfView
  end
  if nil ~= HelperCamera.ProjectionMode and CameraComponent.SetProjectionMode then
    CameraComponent:SetProjectionMode(HelperCamera.ProjectionMode)
  elseif nil ~= CameraComponent.ProjectionMode and nil ~= HelperCamera.ProjectionMode then
    CameraComponent.ProjectionMode = HelperCamera.ProjectionMode
  end
  if nil ~= HelperCamera.OrthoWidth and CameraComponent.SetOrthoWidth then
    CameraComponent:SetOrthoWidth(HelperCamera.OrthoWidth)
  elseif nil ~= CameraComponent.OrthoWidth and nil ~= HelperCamera.OrthoWidth then
    CameraComponent.OrthoWidth = HelperCamera.OrthoWidth
  end
  if nil ~= HelperCamera.PostProcessSettings then
    CameraComponent.PostProcessSettings = HelperCamera.PostProcessSettings
  end
end

function M:GetPreviewRootActor()
  return self.SceneService and self.SceneService.GetPreviewRootActor and self.SceneService:GetPreviewRootActor() or nil
end

function M:GetCameraActor()
  return self.CameraActor
end

function M:GetCameraComponent()
  if self.CameraComponent and IsValid(self.CameraComponent) then
    return self.CameraComponent
  end
  if self.CameraActor and IsValid(self.CameraActor) then
    self.CameraComponent = self.CameraActor:GetComponentByClass(UCameraComponent:StaticClass())
  end
  return self.CameraComponent
end

function M:EnsureCameraActor()
  if self.CameraActor and IsValid(self.CameraActor) then
    return self.CameraActor
  end
  local RootActor = self:GetPreviewRootActor()
  local World = self.ViewUI and self.ViewUI:GetWorld() or nil
  if not World or not RootActor then
    return nil
  end
  local SpawnTransform = RootActor:GetTransform()
  self.CameraActor = World:SpawnActor(ACameraActor:StaticClass(), SpawnTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
  if not self.CameraActor then
    return nil
  end
  EnsureSpawnedActorRootComponent(self.CameraActor)
  self.CameraActor:K2_AttachToActor(RootActor, "", UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, false)
  self.CameraActor:K2_SetActorRelativeTransform(FTransform(), false, nil, false)
  if self.CameraActor.SetActorLabel then
    self.CameraActor:SetActorLabel("PersonInfoPreviewCamera")
  end
  if self.CameraActor.SetActorEnableCollision then
    self.CameraActor:SetActorEnableCollision(false)
  end
  if self.CameraActor.SetActorTickEnabled then
    self.CameraActor:SetActorTickEnabled(false)
  end
  self.CameraComponent = EnsureCameraComponent(self.CameraActor)
  self:SyncCameraComponentSettingsFromHelper()
  return self.CameraActor
end

function M:SetPreviewLevelActor(PreviewLevelActor)
  self.PreviewLevelActor = PreviewLevelActor
end

function M:GetPreviewLevelActor()
  return self.PreviewLevelActor
end

function M:GetPreviewLevelEnvirSystemActor()
  local PreviewLevelActor = self:GetPreviewLevelActor()
  return PreviewLevelActor and PreviewLevelActor.GetEnvirSystemActor and PreviewLevelActor:GetEnvirSystemActor() or nil
end

function M:GetWorldTransform()
  local CameraActor = self:EnsureCameraActor()
  if not CameraActor then
    return nil
  end
  return CameraActor:GetTransform()
end

function M:GetRelativeTransform()
  local CameraActor = self:EnsureCameraActor()
  if not CameraActor or not CameraActor.GetActorRelativeTransform then
    return nil
  end
  return CameraActor:GetActorRelativeTransform()
end

function M:SetRelativeTransform(RelativeLocation, RelativeRotation)
  local CameraActor = self:EnsureCameraActor()
  if not CameraActor then
    return false
  end
  local Transform = FTransform()
  Transform.Translation = RelativeLocation or FVector(0, 0, 0)
  Transform.Rotation = (RelativeRotation or FRotator(0, 0, 0)):ToQuat()
  Transform.Scale3D = FVector(1, 1, 1)
  CameraActor:K2_SetActorRelativeTransform(Transform, false, nil, false)
  local CameraComponent = self:GetCameraComponent()
  local CameraRotation = RelativeRotation or FRotator(0, 0, 0)
  local CameraLocation = RelativeLocation or FVector(0, 0, 0)
  local RootTransform = self:GetPreviewRootActor() and self:GetPreviewRootActor():GetTransform() or nil
  if RootTransform then
    CameraLocation = UE4.UKismetMathLibrary.TransformLocation(RootTransform, CameraLocation)
    CameraRotation = UE4.UKismetMathLibrary.TransformRotation(RootTransform, CameraRotation)
  end
  self.StartPos = CameraLocation
  self.EndPos = CameraLocation
  self.StartRot = CameraRotation
  self.EndRot = CameraRotation
  self.BaseScrollLocation = CameraLocation
  if CameraComponent then
    CameraComponent:K2_SetWorldLocationAndRotation(CameraLocation, CameraRotation, false, nil, false)
  end
  return true
end

function M:SetFOV(FOV)
  local CameraComponent = self:GetCameraComponent()
  if not CameraComponent or not FOV then
    return
  end
  self.CurrentFOV = FOV
  self.OriginalFOV = self.OriginalFOV or FOV
  CameraComponent:SetFieldOfView(FOV)
end

function M:StartFOVAnim(FOV, Duration, Ease)
  self:SetFOV(FOV)
end

function M:SetCameraStartInfo(WorldLocation, WorldRotation, FOV)
  self.StartPos = WorldLocation
  self.EndPos = WorldLocation
  self.StartRot = WorldRotation
  self.EndRot = WorldRotation
  self.BaseScrollLocation = WorldLocation
  if FOV then
    self:SetFOV(FOV)
  end
end

function M:SetCameraScrollRange(ForwardLocation, BackwardLocation, Duration, Ease)
  self.DataForwardScrollLocation = ForwardLocation
  self.DataBackwardScrollLocation = BackwardLocation
  self.ScrollAnimDuration = Duration or 0
  self.ScrollEase = Ease or 14
  self:UpdateScrolDirection()
end

function M:UpdateScrolDirection()
  if not self.DataForwardScrollLocation or not self.BaseScrollLocation then
    return
  end
  local RootActor = self:GetPreviewRootActor()
  local RootTransform = RootActor and RootActor:GetTransform() or nil
  if RootTransform then
    self.ForwardScrollLocation = UE4.UKismetMathLibrary.TransformLocation(RootTransform, self.DataForwardScrollLocation)
    self.BackwardScrollLocation = UE4.UKismetMathLibrary.TransformLocation(RootTransform, self.DataBackwardScrollLocation)
  else
    self.ForwardScrollLocation = self.DataForwardScrollLocation
    self.BackwardScrollLocation = self.DataBackwardScrollLocation
  end
  self.ForwardScrollDirection = self.ForwardScrollLocation - self.BaseScrollLocation
  self.ForwardScrollLength = self.ForwardScrollDirection:Size()
  self.ForwardScrollDirection:Normalize()
  self.BackwardScrollDirection = self.BackwardScrollLocation - self.BaseScrollLocation
  self.BackwardScrollLength = self.BackwardScrollDirection:Size()
  self.BackwardScrollDirection:Normalize()
  self.ScrollDirection = 0
  self.TargetScrollLength = 0
end

function M:OnScrolling(DeltaScroll)
  if not (0 ~= DeltaScroll and self.EnableCameraScrolling and self.ForwardScrollLocation) or not self.BaseScrollLocation then
    return false
  end
  local Speed = 20.0
  self.TargetScrollLength = self.TargetScrollLength + DeltaScroll * Speed
  local EndValue
  if 0 == self.ScrollDirection then
    if DeltaScroll > 0 then
      self.TargetScrollLength = math.clamp(self.TargetScrollLength, 0, self.ForwardScrollLength)
      EndValue = self.BaseScrollLocation + self.ForwardScrollDirection * self.TargetScrollLength
      self.ScrollDirection = 1
    else
      self.TargetScrollLength = math.clamp(self.TargetScrollLength, -self.BackwardScrollLength, 0)
      EndValue = self.BaseScrollLocation + self.BackwardScrollDirection * -self.TargetScrollLength
      self.ScrollDirection = -1
    end
  elseif self.ScrollDirection > 0 then
    self.TargetScrollLength = math.clamp(self.TargetScrollLength, 0, self.ForwardScrollLength)
    EndValue = self.BaseScrollLocation + self.ForwardScrollDirection * self.TargetScrollLength
  else
    self.TargetScrollLength = math.clamp(self.TargetScrollLength, -self.BackwardScrollLength, 0)
    EndValue = self.BaseScrollLocation + self.BackwardScrollDirection * -self.TargetScrollLength
  end
  if 0 == self.TargetScrollLength then
    self.ScrollDirection = 0
  end
  local CameraComponent = self:GetCameraComponent()
  local CameraRotation = CameraComponent and CameraComponent:K2_GetComponentRotation() or self.EndRot
  if CameraComponent and EndValue and CameraRotation then
    CameraComponent:K2_SetWorldLocationAndRotation(EndValue, CameraRotation, false, nil, false)
    self.StartPos = EndValue
    self.EndPos = EndValue
    return true
  end
  return false
end

function M:ViewTarget()
  local CameraActor = self:EnsureCameraActor()
  local Controller = self.ViewUI and self.ViewUI:GetOwningPlayer() or UE4.UGameplayStatics.GetPlayerController(self.ViewUI, 0)
  if not Controller or not CameraActor then
    return false
  end
  self:SyncCameraComponentSettingsFromHelper()
  Controller:SetViewTargetWithBlend(CameraActor, 0, UE4.EViewTargetBlendFunction.VTBlend_Linear, 0, false)
  self.IsControled = true
  local Events = self.ViewTargetEvents or nil
  if Events and Events.OnBecomeViewTarget then
    Events.OnBecomeViewTarget(self.ViewTargetEventObj, Controller)
  end
  return true
end

function M:EndViewTarget()
  if not self.IsControled then
    return
  end
  self.IsControled = false
  local Controller = self.ViewUI and self.ViewUI:GetOwningPlayer() or UE4.UGameplayStatics.GetPlayerController(self.ViewUI, 0)
  local Events = self.ViewTargetEvents or nil
  if Events and Events.OnEndViewTarget then
    Events.OnEndViewTarget(self.ViewTargetEventObj, Controller)
  end
end

function M:Dispose()
  self:EndViewTarget()
  if self.CameraActor and IsValid(self.CameraActor) then
    self.CameraActor:K2_DestroyActor()
  end
  self.CameraActor = nil
  self.CameraComponent = nil
end

return M
