require("UnLua")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local M = Class("BluePrints.UI.BP_UIState_C")

local function GetMainPageView(self)
  local MainPage = not self.PersonInfoMainPage and not self.OwnerMainPage and PersonInfoController.MainPage and PersonInfoController.MainPage.PersonInfoMainPage
  return MainPage
end

local function GetActorController(self)
  local MainPage = GetMainPageView(self)
  return MainPage and MainPage.ActorController or nil
end

function M:InitShotContext(Params)
  Params = Params or {}
  self.OwnerMainPage = Params.OwnerMainPage
  self.OnScreenshotFinishedCallback = Params.OnScreenshotFinished
  self.OnScreenshotFailedCallback = Params.OnScreenshotFailed
end

function M:ClearShotContext()
  self.OwnerMainPage = nil
  self.OnScreenshotFinishedCallback = nil
  self.OnScreenshotFailedCallback = nil
end

function M:GetCameraComponent()
  local ActorController = GetActorController(self)
  local CameraRuntime = ActorController and ActorController.PreviewCameraRuntime or nil
  if CameraRuntime and CameraRuntime.EnsureCameraActor and CameraRuntime:EnsureCameraActor() then
    local CameraComponent = CameraRuntime.GetCameraComponent and CameraRuntime:GetCameraComponent() or nil
    if IsValid(CameraComponent) then
      return CameraComponent
    end
  end
  local Helper = ActorController and ActorController.ArmoryHelper or nil
  local HelperCamera = Helper and Helper.Camera or nil
  if IsValid(HelperCamera) then
    return HelperCamera
  end
  return nil
end

function M:StartPersonInfoScreenshot(Width, Height, Scale)
  local ActorController = GetActorController(self)
  if not ActorController then
    return false
  end
  local CaptureComponent = ActorController.Camera and ActorController.Camera.SceneCaptureComponent2D or nil
  self.bNeedCaptureActors = nil ~= CaptureComponent
  self:SetSceneCaptureComponent(CaptureComponent)
  return self:ScreenshotCPP(Width, Height, Scale or 1.0)
end

function M:BP_OnScreenshotFinished(Image)
  self.bNeedCaptureActors = false
  self:SetSceneCaptureComponent(nil)
  if IsValid(Image) then
    if self.OnScreenshotFinishedCallback then
      self.OnScreenshotFinishedCallback(self, Image)
    end
    return
  end
  if self.OnScreenshotFailedCallback then
    self.OnScreenshotFailedCallback(self)
  end
end

return M
