require("UnLua")
local DisplayController = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayController")
local PreviewLevelHandoffMask = require("BluePrints.UI.Common.Preview.PreviewLevelHandoffMask")
local M = {}
local TAG = "[RankingPreviewScene]"

function M:New(ViewUI, Config)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj.ViewUI = ViewUI
  Obj.Config = Config or {}
  Obj.Controller = nil
  Obj._bInited = false
  Obj.bStackCovered = nil
  return Obj
end

function M:Init(OnReady)
  if self._bInited then
    return true
  end
  self.Controller = DisplayController:New({
    ViewUI = self.ViewUI,
    SceneId = self.Config.SceneId,
    EPreviewSceneType = self.Config.EPreviewSceneType or CommonConst.EPreviewSceneType.PreviewCommon,
    PreviewInstanceKey = self.Config.PreviewInstanceKey or "RankingPreview",
    SkyBoxIndex = self.Config.SkyBoxIndex,
    SkipInitialDraftLoad = true
  })
  self.Controller.UIName = self.Config.UIName or self.ViewUI and self.ViewUI.GetUIConfigName and self.ViewUI:GetUIConfigName() or "RankingPreview"
  if OnReady then
    local bReadyFired = false
    
    local function FireOnReady()
      if bReadyFired then
        return
      end
      bReadyFired = true
      if IsValid(self.ViewUI) and self.ViewUI._bRankingShown ~= true then
        OnReady()
      end
    end
    
    self.Controller.OnFirstBecomeViewTarget = FireOnReady
  end
  EventManager:FireEvent(EventID.OnExternalPreviewAcquired)
  self.Controller:OnOpened()
  self._bInited = true
  if self.Controller.OnFirstBecomeViewTarget and self.Controller.IsControlled then
    local Callback = self.Controller.OnFirstBecomeViewTarget
    self.Controller.OnFirstBecomeViewTarget = nil
    Callback()
  end
  return true
end

function M:Show(Draft)
  self.LastDraft = Draft
  if self.bStackCovered then
    return true
  end
  if not self._bInited then
    self:Init(nil)
  end
  if not self.Controller then
    DebugPrint(TAG .. " Show aborted: no controller")
    PreviewLevelHandoffMask.Hide(self.ViewUI)
    return false
  end
  if not Draft then
    DebugPrint(TAG .. " Show aborted: nil draft")
    PreviewLevelHandoffMask.Hide(self.ViewUI)
    return false
  end
  if not self.Controller:ApplyPreviewDraft(Draft) then
    DebugPrint(TAG .. " Show failed: ApplyPreviewDraft returned false")
    PreviewLevelHandoffMask.Hide(self.ViewUI)
    return false
  end
  local Runtime = self.Controller.PreviewCameraRuntime
  if Runtime and Runtime.OriginalFOV then
    Runtime:SetFOV(Runtime.OriginalFOV)
  end
  if not self.Controller.IsControlled then
    self.Controller:ViewTarget()
  end
  if Draft.Camera then
    self.Controller:ApplyDraftCamera(Draft.Camera)
  end
  return true
end

function M:ReleaseLevelForStack()
  self.bStackCovered = true
  local Service = self.Controller and self.Controller.SceneService
  if Service and Service.UnloadScene then
    Service:UnloadScene(true)
  end
end

function M:RestoreLevelForStack()
  self.bStackCovered = nil
  if self.LastDraft then
    self:Show(self.LastDraft)
  end
end

function M:Destroy()
  self.bStackCovered = nil
  if not self.Controller then
    return
  end
  self.Controller.OnFirstBecomeViewTarget = nil
  self.Controller:OnClosed()
  self.Controller:OnDestruct()
  self.Controller = nil
  self._bInited = false
  EventManager:FireEvent(EventID.OnExternalPreviewReleased)
end

return M
