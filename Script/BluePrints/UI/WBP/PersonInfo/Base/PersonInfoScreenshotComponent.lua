require("UnLua")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = require("BluePrints.UI.WBP.PersonInfo.PersonInfoModel")
local Component = {}
local SCREENSHOT_AUXILIARY_WIDGETS = {
  "HideUI_Key",
  "Com_BtnCamera",
  "Com_BtnVisible"
}
local SCREENSHOT_HELPER_WIDGET_BP = "/Game/UI/WBP/PersonalInfo/CameraShotCompoment.CameraShotCompoment_C"

function Component:OnLoaded()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
end

function Component:Destruct()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  end
  if IsValid(self.ScreenshotHelperWidget) then
    self.ScreenshotHelperWidget:RemoveFromParent()
  end
  self.ScreenshotHelperWidget = nil
  self:_RestoreScreenshotAuxiliaryWidgets()
end

function Component:OnScreenshotKeyDown()
  return self:TryTakeScreenshot()
end

function Component:TryTakeScreenshot()
  if not PersonInfoModel:IsOwener() then
    return false
  end
  if self.bScreenshotInProgress then
    return true
  end
  if self.bScreenshotWidgetShow and IsValid(self.ScreenshotWidget) then
    self.ScreenshotWidget:SetFocus()
    return true
  end
  self.bScreenshotInProgress = true
  self.bScreenshotRestoreUIAfterCapture = not PersonInfoController:IsMainPageUIHidden()
  self:_RecordScreenshotAuxiliaryWidgetsVisibility()
  if self.bScreenshotRestoreUIAfterCapture and self.Hideui then
    self:Hideui()
  end
  self:_HideScreenshotAuxiliaryWidgets()
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:AddTimer(0.05, function()
    self:_StartScreenshotCapture()
  end, false, 0, "PersonInfoTakeScreenshot")
  return true
end

function Component:_StartScreenshotCapture()
  ULowEntryExtendedStandardLibrary.SetMousePositionInPercentages(1, 1)
  local HelperWidget = self:_EnsureScreenshotHelperWidget()
  if not IsValid(HelperWidget) then
    self:_OnScreenshotCaptureFailed()
    return
  end
  local Width, Height = self:_GetScreenshotCaptureSize()
  if not HelperWidget:StartPersonInfoScreenshot(Width, Height, 1.0) then
    self:_OnScreenshotCaptureFailed()
  end
end

function Component:_OnScreenshotCaptureFailed()
  self.bScreenshotInProgress = false
  self:BlockAllUIInput(false)
  if self.bScreenshotRestoreUIAfterCapture and self.Recoverui then
    self:Recoverui()
  end
  self:_RestoreScreenshotAuxiliaryWidgets()
  self.bScreenshotRestoreUIAfterCapture = false
end

function Component:ShowScreenshotWidget(Image)
  if not IsValid(self.ScreenshotWidget) then
    local HostPanel = self:_GetScreenshotHostPanel()
    if not HostPanel then
      self:_OnScreenshotCaptureFailed()
      return
    end
    self.ScreenshotWidget = UIManager(self):CreateWidget(UIConst.ScreenshotWidget)
    HostPanel:AddChildToOverlay(self.ScreenshotWidget)
    local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.ScreenshotWidget)
    if OverlaySlot then
      OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
      OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    end
  end
  if not IsValid(self.ScreenshotWidget) then
    self:_OnScreenshotCaptureFailed()
    return
  end
  local Params = {
    Image = Image,
    Parent = self,
    OnHiddenCallback = self.OnScreenshotWidgetHidden
  }
  self.ScreenshotWidget:Init(Params)
  self.bScreenshotWidgetShow = true
  self.bScreenshotInProgress = false
  self.ScreenshotWidget:SetFocus()
end

function Component:OnScreenshotWidgetHidden(bSaved)
  self.bScreenshotWidgetShow = false
  self:BlockAllUIInput(false)
  if self.bScreenshotRestoreUIAfterCapture and self.Recoverui then
    self:Recoverui()
  end
  self:_RestoreScreenshotAuxiliaryWidgets()
  self.bScreenshotRestoreUIAfterCapture = false
  if IsValid(self.ScreenshotWidget) then
    self.ScreenshotWidget:RemoveFromParent()
  end
  self.ScreenshotWidget = nil
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:SetFocus()
  end
end

function Component:_GetPreviewCameraComponent()
  local MainPage = not self.PersonInfoMainPage and PersonInfoController.MainPage and PersonInfoController.MainPage.PersonInfoMainPage
  local ActorController = MainPage and MainPage.ActorController or nil
  if not ActorController then
    DebugPrint("PersonInfoScreenshot: missing ActorController")
    return nil
  end
  local CameraRuntime = ActorController.PreviewCameraRuntime
  if CameraRuntime and CameraRuntime.EnsureCameraActor and CameraRuntime:EnsureCameraActor() then
    local CameraComponent = CameraRuntime.GetCameraComponent and CameraRuntime:GetCameraComponent() or nil
    if IsValid(CameraComponent) then
      return CameraComponent
    end
  end
  local Helper = ActorController.ArmoryHelper
  local HelperCamera = Helper and Helper.Camera or nil
  if IsValid(HelperCamera) then
    return HelperCamera
  end
  DebugPrint("PersonInfoScreenshot: preview camera component not found")
  return nil
end

function Component:_GetScreenshotHostPanel()
  if IsValid(self.ShotPage) and self.ShotPage.AddChildToOverlay then
    return self.ShotPage
  end
  if IsValid(self.Content) and self.Content.AddChildToOverlay then
    DebugPrint("PersonInfoScreenshot: ShotPage missing, fallback to Content")
    return self.Content
  end
  DebugPrint("PersonInfoScreenshot: no valid host panel for screenshot widget")
  return nil
end

function Component:_EnsureScreenshotHelperWidget()
  if IsValid(self.ScreenshotHelperWidget) then
    self.ScreenshotHelperWidget:InitShotContext({
      OwnerMainPage = self.PersonInfoMainPage,
      OnScreenshotFinished = function(_, Image)
        self:_OnScreenshotHelperFinished(Image)
      end,
      OnScreenshotFailed = function()
        self:_OnScreenshotCaptureFailed()
      end
    })
    return self.ScreenshotHelperWidget
  end
  local HostPanel = self:_GetScreenshotHostPanel()
  if not HostPanel then
    return nil
  end
  local HelperWidget = UIManager(self):CreateWidget(SCREENSHOT_HELPER_WIDGET_BP)
  if not IsValid(HelperWidget) then
    return nil
  end
  HostPanel:AddChildToOverlay(HelperWidget)
  local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(HelperWidget)
  if OverlaySlot then
    OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  end
  HelperWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  HelperWidget:InitShotContext({
    OwnerMainPage = self.PersonInfoMainPage,
    OnScreenshotFinished = function(_, Image)
      self:_OnScreenshotHelperFinished(Image)
    end,
    OnScreenshotFailed = function()
      self:_OnScreenshotCaptureFailed()
    end
  })
  self.ScreenshotHelperWidget = HelperWidget
  return HelperWidget
end

function Component:_OnScreenshotHelperFinished(Image)
  if not IsValid(Image) then
    self:_OnScreenshotCaptureFailed()
    return
  end
  self:ShowScreenshotWidget(Image)
end

function Component:_GetScreenshotCaptureSize()
  local GameUserSettings = UGameUserSettings.GetGameUserSettings()
  local ScreenResolution = GameUserSettings and GameUserSettings:GetScreenResolution() or nil
  local Width = ScreenResolution and ScreenResolution.X or 0
  local Height = ScreenResolution and ScreenResolution.Y or 0
  if Width <= 0 or Height <= 0 then
    local ViewportSize = UWidgetLayoutLibrary.GetViewportSize(self)
    Width = ViewportSize.X or 0
    Height = ViewportSize.Y or 0
  end
  local AspectRatio = 0 ~= Height and Width / Height or 1.7777777777777777
  Height = 1080
  Width = math.floor(Height * AspectRatio)
  if Height > Width then
    Width = 1080
    Height = math.floor(Width / AspectRatio)
  end
  Width = math.max(1, math.floor(Width or 0))
  Height = math.max(1, math.floor(Height or 0))
  return Width, Height
end

function Component:_HideScreenshotAuxiliaryWidgets()
  self:_RecordScreenshotAuxiliaryWidgetsVisibility()
  for _, WidgetName in ipairs(SCREENSHOT_AUXILIARY_WIDGETS) do
    local Widget = self[WidgetName]
    if IsValid(Widget) then
      Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function Component:_RecordScreenshotAuxiliaryWidgetsVisibility()
  if self.ScreenshotAuxiliaryVisibilityState then
    return
  end
  self.ScreenshotAuxiliaryVisibilityState = {}
  for _, WidgetName in ipairs(SCREENSHOT_AUXILIARY_WIDGETS) do
    local Widget = self[WidgetName]
    if IsValid(Widget) then
      self.ScreenshotAuxiliaryVisibilityState[WidgetName] = Widget:GetVisibility()
    end
  end
end

function Component:_RestoreScreenshotAuxiliaryWidgets()
  if not self.ScreenshotAuxiliaryVisibilityState then
    return
  end
  for WidgetName, Visibility in pairs(self.ScreenshotAuxiliaryVisibilityState) do
    local Widget = self[WidgetName]
    if IsValid(Widget) then
      Widget:SetVisibility(Visibility)
    end
  end
  self.ScreenshotAuxiliaryVisibilityState = nil
end

return Component
