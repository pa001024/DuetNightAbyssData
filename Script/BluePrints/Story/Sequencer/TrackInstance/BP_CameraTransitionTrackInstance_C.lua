local M = Class()
local SettingUtils = require("Utils.SettingUtils")

function M:OnInitializeEvent()
  EventManager:AddEvent(EventID.GameViewportSizeChanged, self, self.OnViewportSizeChanged)
  EventManager:AddEvent(EventID.GameWindowActionChanged, self, self.OnWindowActionChanged)
  EventManager:AddEvent(EventID.UnLoadUI, self, self.OnUIUnLoad)
  self.RefreshRequestDelegate = {
    self,
    self.RefreshAfterResize
  }
  self.RefreshTimerHandle = nil
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if IsValid(GameMode) then
    GameMode.OnGamePauseChanged:Add(self, self.OnGamePauseChanged)
  end
end

function M:UpdateCameraTransitionUI(Camera, Section, Input)
  DebugPrint("CameraTransitionTrackInstance:UpdateCamTransWidget", Camera, self.bInitialized)
  if not IsValid(Section) then
    return
  end
  if not IsValid(self.CamTransWidget) then
    self.CamTransWidget = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/Sequence/WBP_Camera_Transition.WBP_Camera_Transition'")
    if not IsValid(self.CamTransWidget) then
      return
    end
    self.CamTransWidget:AddToViewport(-100)
  end
  self.CamTransWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if IsValid(self.CaptureComp) then
    self.CaptureComp:K2_DestroyComponent(self.CaptureComp)
    self.CaptureComp = nil
  end
  self.CaptureComp = self:CaptureCameraScene(Camera, Section.IsDynamic)
  local TalkSequenceObject = UTrackInstanceFunctionLibrary.GetTalkSequenceObject(self, Input)
  if not TalkSequenceObject or not TalkSequenceObject:IsInSkip() then
  end
end

function M:HideCameraTransitionUI()
  DebugPrint("CameraTransitionTrackInstance:HideCamTransWidget")
  if not IsValid(self.CamTransWidget) then
    return
  end
  self.CamTransWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:SetCamTransUIOffset(MinX, MinY, Width, Height, ScaleX, ScaleY)
  if not IsValid(self.CamTransWidget) or not IsValid(self.CamTransWidget.SizeBox) then
    return
  end
  local ViewportScale = UWidgetLayoutLibrary.GetViewportScale(GWorld.GameInstance)
  local TitleBarHeight = 0
  if UWindowTitleBarFunctionLibrary.IsCustomTitleBarActive() then
    TitleBarHeight = UWindowTitleBarFunctionLibrary.GetWindowTitleBarHeight() / ViewportScale
  end
  local ViewportSize = UWidgetLayoutLibrary.GetViewportSize(GWorld.GameInstance)
  local Offsets = FMargin()
  Offsets.Left = (MinX - ViewportSize.X * 0.5) / ViewportScale
  Offsets.Top = (MinY - ViewportSize.Y * 0.5) / ViewportScale - TitleBarHeight * 0.5
  Offsets.Right = Width * (ScaleX or 1) / ViewportScale
  Offsets.Bottom = Height * (ScaleY or 1) / ViewportScale
  self.CamTransWidget.SizeBox.Slot:SetOffsets(Offsets)
end

function M:GetMobileResolutionSettings()
  local GameInstance = GWorld.GameInstance
  if 0 ~= CommonUtils.TableLength(GameInstance.DynamicResolutionTags) then
    return GameInstance.DynamicResolution[1]
  end
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
  if "Android" == PlatformName or "OpenHarmony" == PlatformName then
    return {
      80,
      65,
      576
    }
  elseif "IOS" == PlatformName then
    return {
      48,
      48,
      0
    }
  end
  return nil
end

function M:GetMobileRenderTargetSize(Width, Height)
  local ResolutionInfo = self:GetMobileResolutionSettings()
  if not ResolutionInfo then
    return
  end
  local ScreenPercentage = ResolutionInfo[1]
  local bUseLowLevelScreenPercentage = UE4.UKismetSystemLibrary.GetConsoleVariableFloatValue("r.UseLowLevelScreenPercentage") > 0
  if bUseLowLevelScreenPercentage then
    ScreenPercentage = ResolutionInfo[2]
  end
  local MaxViewSize = ResolutionInfo[3]
  local RenderWidth = Width
  local RenderHeight = Height
  if ScreenPercentage > 0 then
    local ScreenScale = ScreenPercentage / 100
    RenderWidth = RenderWidth * ScreenScale
    RenderHeight = RenderHeight * ScreenScale
  end
  if MaxViewSize > 0 and MaxViewSize < RenderHeight then
    local ViewScale = MaxViewSize / RenderHeight
    RenderWidth = RenderWidth * ViewScale
    RenderHeight = RenderHeight * ViewScale
  end
  return math.floor(RenderWidth), math.floor(RenderHeight)
end

function M:RefreshCaptureComp(CaptureComp)
  if not IsValid(CaptureComp) or not IsValid(self.CamTransWidget) then
    return
  end
  local ConstrainedViewRect = self:SyncMainViewProjection(CaptureComp)
  local MinX, MinY, Width, Height = ConstrainedViewRect.X, ConstrainedViewRect.Y, ConstrainedViewRect.Z, ConstrainedViewRect.W
  if Width <= 0 or Height <= 0 then
    self:SetCamTransUIOffset(0, 0, 0, 0)
    return
  end
  local ScaleX, ScaleY = 1, 1
  local GameInstance = GWorld.GameInstance
  local DeviceType = CommonUtils.GetDeviceTypeByPlatformName(GameInstance)
  if "Mobile" == DeviceType then
    local RenderWidth, RenderHeight = self:GetMobileRenderTargetSize(Width, Height)
    if RenderWidth > 0 and RenderHeight > 0 then
      ScaleX = Width / RenderWidth
      ScaleY = Height / RenderHeight
    end
  end
  local RenderTarget = CaptureComp.TextureTarget
  if not IsValid(RenderTarget) or RenderTarget.SizeX ~= Width or RenderTarget.SizeY ~= Height then
    RenderTarget = UKismetRenderingLibrary.CreateRenderTarget2D(CaptureComp, math.floor(Width), math.floor(Height), UE4.ETextureRenderTargetFormat.RTF_RGBA16f)
    CaptureComp.TextureTarget = RenderTarget
  end
  self.CamTransWidget:SetCameraTexture(RenderTarget)
  self:SetCamTransUIOffset(MinX, MinY, Width, Height, ScaleX, ScaleY)
  CaptureComp:CaptureScene()
end

function M:CaptureCameraScene(Camera, IsDynamic)
  if not IsValid(Camera) then
    return nil
  end
  local SceneCaptureComp = NewObject(USceneCaptureComponent2D, Camera)
  SceneCaptureComp:K2_AttachToComponent(Camera.CameraComponent)
  SceneCaptureComp:K2_SetRelativeTransform(FTransform(), false, nil, false)
  URuntimeCommonFunctionLibrary.RegisterComponent(SceneCaptureComp)
  SceneCaptureComp.bAllowMainViewOnlyPasses = true
  self:SetCaptureParams(SceneCaptureComp, Camera.CameraComponent, IsDynamic)
  self:RefreshCaptureComp(SceneCaptureComp)
  return SceneCaptureComp
end

function M:RequestRefresh(Delay)
  local Now = UE4.UGameplayStatics.GetRealTimeSeconds(self)
  local ExecuteTime = Now + Delay
  if self.RefreshExecuteTime and ExecuteTime <= self.RefreshExecuteTime then
    return
  end
  if Now >= ExecuteTime then
    self:RefreshCaptureComp(self.CaptureComp)
    return
  end
  self.RefreshExecuteTime = ExecuteTime
  self.RefreshTimerHandle = URuntimeCommonFunctionLibrary.K2_SetTimerDelegate(self.RefreshRequestDelegate, Delay, false, 0)
end

function M:RefreshAfterResize()
  self.RefreshExecuteTime = nil
  self.RefreshTimerHandle = nil
  self:RefreshCaptureComp(self.CaptureComp)
end

function M:OnViewportSizeChanged()
  self:RequestRefresh(0.01)
end

function M:OnWindowActionChanged()
  self:RequestRefresh(0.4)
end

function M:OnUIUnLoad(UIName)
  if "Setting" == UIName then
    self:RequestRefresh(0.1)
  end
end

function M:OnGamePauseChanged(bPaused)
  if not bPaused then
    self:RefreshCaptureComp(self.CaptureComp)
  end
end

function M:SetCaptureParams(SceneCaptureComp, CameraComp, IsDynamic)
  if not IsValid(SceneCaptureComp) or not IsValid(CameraComp) then
    return
  end
  SceneCaptureComp.FOVAngle = CameraComp.FieldOfView
  SceneCaptureComp.OrthoWidth = CameraComp.OrthoWidth
  SceneCaptureComp.ProjectionType = CameraComp.ProjectionMode
  SceneCaptureComp.CaptureSource = ESceneCaptureSource.SCS_FinalToneCurveHDR
  SceneCaptureComp.PostProcessSettings = CameraComp.PostProcessSettings
  SceneCaptureComp.PostProcessBlendWeight = CameraComp.PostProcessBlendWeight or 1.0
  SceneCaptureComp.bEnablePostProcessSettings = true
  SceneCaptureComp.bCaptureEveryFrame = IsDynamic
  SceneCaptureComp.bCaptureOnMovement = false
  self:InitCaptureShowFlags(SceneCaptureComp)
  if URuntimeCommonFunctionLibrary.ObjIsChildOf(CameraComp, UCineCameraComponent) then
    self:SetCineCameraParams(SceneCaptureComp, CameraComp)
  end
end

function M:OnDestroyedEvent()
  EventManager:RemoveEvent(EventID.GameViewportSizeChanged, self)
  EventManager:RemoveEvent(EventID.GameWindowActionChanged, self)
  EventManager:RemoveEvent(EventID.UnLoadUI, self)
  self.RefreshExecuteTime = nil
  if self.RefreshTimerHandle and self.RefreshTimerHandle:IsValid() then
    URuntimeCommonFunctionLibrary.K2_ClearAndInvalidateTimerHandle(self, self.RefreshTimerHandle)
  end
  self.RefreshTimerHandle = nil
  self.RefreshRequestDelegate = nil
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if IsValid(GameMode) then
    GameMode.OnGamePauseChanged:Remove(self, self.OnGamePauseChanged)
  end
  if IsValid(self.CamTransWidget) then
    self.CamTransWidget:RemoveFromParent()
    self.CamTransWidget = nil
  end
  if IsValid(self.CaptureComp) then
    self.CaptureComp:K2_DestroyComponent(self.CaptureComp)
    self.CaptureComp = nil
  end
end

return M
