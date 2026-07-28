require("UnLua")
local PreviewSceneService = require("BluePrints.UI.Common.Preview.PreviewSceneService")
local PreviewCharacterHandle = require("BluePrints.UI.Common.Preview.PreviewCharacterHandle")
local PreviewPetHandle = require("BluePrints.UI.Common.Preview.PreviewPetHandle")
local PreviewAppearanceService = require("BluePrints.UI.Common.Preview.PreviewAppearanceService")
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local DisplaySpecBuilder = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplaySpecBuilder")
local DisplaySceneComposer = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplaySceneComposer")
local DisplayEditor = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayEditor")
local DisplayPersistence = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayPersistence")
local PreviewCameraService = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_PreviewCameraService")
local PreviewCameraCompatibility = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_PreviewCameraCompatibility")
local DisplaySelectionComponent = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplaySelectionComponent")
local DisplayHighlightComponent = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayHighlightComponent")
local DisplayTypes = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayTypes")
local M = {}
local PERSONAL_PREVIEW_HIDE_TAG = "PersonInfoPreviewSuspend"
local CAMERA_PREVIEW_TRANSACTION_KEY = "camera_adjust"
local WHEEL_CAMERA_PREVIEW_TRANSACTION_KEY = "camera_scroll_adjust"
local WHEEL_CAMERA_PREVIEW_COMMIT_TIMER = "PersonInfoWheelCameraPreviewCommit"
local WHEEL_CAMERA_PREVIEW_COMMIT_DELAY = 0.5

local function GetCameraInputConfig()
  return PersonInfoCommon.CameraInputConfig or {}
end

local function GetObjectNameSafe(Object)
  if not Object then
    return "None"
  end
  if Object.GetName then
    return Object:GetName()
  end
  return tostring(Object)
end

function M:Init(Params)
  Params = Params or {}
  DebugPrint(string.format("PersonInfoDisplayController: Init ui=%s sceneId=%s initialChar=%s previewMode=%s", tostring(Params.ViewUI and Params.ViewUI.GetUIConfigName and Params.ViewUI:GetUIConfigName() or nil), tostring(Params.SceneId), tostring(Params.Char and Params.Char.CharId or nil), "B"))
  self.ViewUI = Params.ViewUI
  self.InitialCharInfo = Params.Char
  self.InitialAppearanceInfo = Params.AppearanceInfo
  self.InitialAvatar = Params.Avatar
  self.InitialSceneId = Params.SceneId
  self.InitialDraft = Params.Draft
  self.SkipInitialDraftLoad = Params.SkipInitialDraftLoad == true
  self.SceneService = PreviewSceneService:New({
    ViewUI = self.ViewUI,
    PreviewSceneType = Params.EPreviewSceneType or CommonConst.EPreviewSceneType.PreviewCommon,
    PreviewSceneLocation = Params.PreviewSceneLocation,
    PreviewInstanceKey = Params.PreviewInstanceKey or "PersonInfoPageMain",
    UsePreviewRootActor = true,
    SkyBoxIndex = Params.SkyBoxIndex
  })
  self.AppearanceService = PreviewAppearanceService:New({
    ViewUI = self.ViewUI
  })
  self.SpecBuilder = DisplaySpecBuilder
  self.SceneComposer = DisplaySceneComposer
  self.SceneSpec = nil
  self.SceneDraft = nil
  self.EntityHandles = {}
  self.FocusEntityId = nil
  self.ArmoryHelper = nil
  self.PreviewCameraRuntime = nil
  self.UIName = self.ViewUI and self.ViewUI:GetUIConfigName() or "PersonInfoPageMain"
  self.Avatar = nil
  self.ArmoryPlayer = nil
  self.CurrentCharInfo = nil
  self.CurrentWeaponInfo = nil
  self.CurrentAppearanceInfo = nil
  self.ExCameraOffset = nil
  self.LastCameraTags = nil
  self._FixedCameraTransTimeOnce = nil
  self.IsControled = false
  self.IsPreviewSuspended = false
  self._NeedRefreshEnvironmentOnBecomeViewTarget = false
  self.CurrentCameraRigLocalPosition = FVector(0, 0, 0)
  self.CurrentCameraRigLocalRotation = FRotator(0, 0, 0)
  self.AppliedSceneColorIndex = nil
  self.bClosed = false
  self.bDestructed = false
  self.bActorsDestroyed = false
  self.bTryDestroyActorsWhenDestruct = false
  self.Editor = DisplayEditor:New({
    ViewUI = self.ViewUI,
    Renderer = self
  })
  self.SelectionComponent = DisplaySelectionComponent:New({
    ViewUI = self.ViewUI,
    Controller = self
  })
  self.HighlightComponent = DisplayHighlightComponent:New({
    ViewUI = self.ViewUI,
    Controller = self
  })
  self.PreviewCameraRuntime = PreviewCameraService:New({
    ViewUI = self.ViewUI,
    SceneService = self.SceneService
  })
  self.SceneService:SetPreviewLevelActorReceiver(self.PreviewCameraRuntime)
  self.PreviewCameraRuntime:BindViewTargetEvents({
    OnBecomeViewTarget = self.OnHelperBecomeViewTarget,
    OnEndViewTarget = self.OnHelperEndViewTarget
  }, self)
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

function M:OnOpened(SceneSpec)
  DebugPrint(string.format("PersonInfoDisplayController: OnOpened sceneSpec=%s editor=%s initialChar=%s initialSceneId=%s", tostring(nil ~= SceneSpec), tostring(nil ~= self.Editor), tostring(self.InitialCharInfo and self.InitialCharInfo.CharId or nil), tostring(self.InitialSceneId)))
  self:EnsureHelper()
  self._NeedRefreshEnvironmentOnBecomeViewTarget = true
  if true == self.SkipInitialDraftLoad then
    DebugPrint("PersonInfoDisplayController: OnOpened skip initial draft load")
    return
  end
  if self.Editor then
    if SceneSpec then
      DebugPrint("PersonInfoDisplayController: OnOpened use incoming SceneSpec to build draft")
      self.Editor:SetDraft(DisplayPersistence:BuildDraftFromSceneSpec(SceneSpec))
    elseif self.InitialDraft then
      DebugPrint("PersonInfoDisplayController: OnOpened use initial draft")
      self.Editor:SetDraft(self.InitialDraft)
    else
      DebugPrint("PersonInfoDisplayController: OnOpened load initial draft state")
      self.Editor:LoadInitialState({
        Char = self.InitialCharInfo,
        Avatar = self.InitialAvatar,
        AppearanceInfo = self.InitialAppearanceInfo,
        SceneId = self.InitialSceneId or DisplayConfig:GetDefaultSceneId()
      })
    end
    return
  end
  if SceneSpec then
    DebugPrint("PersonInfoDisplayController: OnOpened fallback LoadScene")
    self:LoadScene(SceneSpec)
  elseif self.InitialCharInfo then
    DebugPrint("PersonInfoDisplayController: OnOpened fallback ShowMainCharacter")
    self:ShowMainCharacter(self.InitialCharInfo, self.InitialAvatar, self.InitialAppearanceInfo)
  else
    DebugPrint("PersonInfoDisplayController: OnOpened no SceneSpec and no InitialCharInfo")
  end
end

function M:ApplyPreviewDraft(TargetDraft)
  if not self.Editor or not TargetDraft then
    return false
  end
  self.Editor:SetDraft(TargetDraft)
  return true
end

function M:OnClosed()
  if self.bClosed then
    return
  end
  self.bClosed = true
  self:ResumePreviewControl()
  if self.PreviewCameraRuntime then
    self.PreviewCameraRuntime:EndViewTarget()
  end
  if IsValid(self.ArmoryHelper) then
    if self.ArmoryHelper.UpdateDirLight then
      self.ArmoryHelper:UpdateDirLight(false)
    end
    self.ArmoryHelper:UpdatePPSetting(0)
    self.ArmoryHelper:RecorverCamera(nil, nil, 0)
  end
  if self.ViewUI and self.ViewUI.DoRecoverCamera then
    self.ViewUI:DoRecoverCamera()
  else
    local Controller = self.ViewUI and self.ViewUI.GetOwningPlayer and self.ViewUI:GetOwningPlayer() or nil
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
    if Controller and Player then
      Controller:SetViewTargetWithBlend(Player, 0, UE4.EViewTargetBlendFunction.VTBlend_Linear, 0, false)
    end
  end
  self:TryDestroyActors()
  if self.HighlightComponent then
    self.HighlightComponent:CloseFocusHighlight()
    self.HighlightComponent:ClearAllHighlight()
  end
end

function M:OnDestruct()
  if self.bDestructed then
    return
  end
  if not self.bClosed then
    self:OnClosed()
  end
  self.bDestructed = true
  if self.bTryDestroyActorsWhenDestruct then
    self.bTryDestroyActorsWhenDestruct = false
    self:TryDestroyActors()
    return
  end
  self:TryDestroyActors()
end

function M:EnsureHelper()
  if IsValid(self.ArmoryHelper) then
    DebugPrint(string.format("PersonInfoDisplayController: EnsureHelper reuse helper=%s", GetObjectNameSafe(self.ArmoryHelper)))
    return
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self.ViewUI)
  local UIManagerComp = GameInstance and GameInstance:GetGameUIManager()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
  DebugPrint(string.format("PersonInfoDisplayController: EnsureHelper uiManager=%s player=%s", tostring(nil ~= UIManagerComp), GetObjectNameSafe(Player)))
  if not UIManagerComp or not Player then
    DebugPrint("PersonInfoDisplayController: EnsureHelper aborted because uiManager or player missing")
    return
  end
  self.ArmoryHelper = UIManagerComp:CreateUIActorCameraHelper(Player)
  if self.ArmoryHelper then
    self.AppliedSceneColorIndex = nil
    self.SceneService:SetHelper(self.ArmoryHelper)
    self.ArmoryHelper:BindViewTargetEvents({
      OnBecomeViewTarget = self.OnHelperBecomeViewTarget,
      OnEndViewTarget = self.OnHelperEndViewTarget,
      OnAfterEndViewTarget = self.OnAfterHelperEndViewTarget
    }, self)
    self.ArmoryHelper.PersonalPreview = true
    self.ArmoryHelper.ArchivePreview = false
    self.ArmoryHelper:UpdatePPSetting(2)
    DebugPrint(string.format("PersonInfoDisplayController: EnsureHelper created helper=%s", GetObjectNameSafe(self.ArmoryHelper)))
  else
    DebugPrint("PersonInfoDisplayController: EnsureHelper CreateUIActorCameraHelper returned nil")
  end
end

function M:ApplySceneColor(SceneId)
  if not self.SceneService then
    return false
  end
  local SceneColorIndex = DisplayConfig:GetSceneColorIndex(SceneId)
  if self.AppliedSceneColorIndex == SceneColorIndex then
    return false
  end
  self.AppliedSceneColorIndex = SceneColorIndex
  self.SceneService:ChangeSkyBox(SceneColorIndex)
  return true
end

function M:OnHelperBecomeViewTarget(PC)
  self.IsControled = true
  if self._NeedRefreshEnvironmentOnBecomeViewTarget and self.SceneService then
    self._NeedRefreshEnvironmentOnBecomeViewTarget = false
    local NeedUpdateLighting = not self._SceneColorLightingScheduled
    self._SceneColorLightingScheduled = false
    self.SceneService:RefreshEnvironment(NeedUpdateLighting)
  end
end

function M:OnHelperEndViewTarget(PC)
  self.IsControled = false
end

function M:OnAfterHelperEndViewTarget(NewTarget)
  self:TryDestroyActors()
end

function M:TryDestroyActors()
  if self.bActorsDestroyed then
    return
  end
  if not self.bDestructed then
    self.bTryDestroyActorsWhenDestruct = true
    return
  end
  self.bActorsDestroyed = true
  if self.HighlightComponent then
    self.HighlightComponent:ClearAllHighlight()
  end
  self:ClearEntities()
  if self.PreviewCameraRuntime then
    self.PreviewCameraRuntime:Dispose()
  end
  if self.SceneService then
    self.SceneService:Dispose()
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
  if Player and Player.CharCameraComponent then
    Player.CharCameraComponent:SetComponentTickEnabled(true)
    UKismetSystemLibrary.ExecuteConsoleCommand(Player, "r.Shadow.ForceCacheUpdate 1", nil)
  end
  if IsValid(self.ArmoryHelper) then
    self.ArmoryHelper:DestroySelf()
  end
  self.ArmoryHelper = nil
end

function M:EnsureArmoryCameraStartState()
  if self.PreviewCameraRuntime and self.PreviewCameraRuntime:EnsureCameraActor() then
    return true
  end
  if not IsValid(self.ArmoryHelper) then
    return false
  end
  if self.ArmoryHelper.RecoverEndTransform and self.ArmoryHelper.StartPos and self.ArmoryHelper.EndPos then
    return true
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
  if not Player then
    return false
  end
  local CameraComponent = Player.CharCameraComponent or Player:GetComponentByClass(UCameraComponent:StaticClass())
  if not CameraComponent then
    return false
  end
  local FocusHandle = self.FocusEntityId and self:GetEntityHandle(self.FocusEntityId) or nil
  local ViewActor = FocusHandle and FocusHandle.GetActor and FocusHandle:GetActor() or self:GetPlayerActor() or Player
  self.ArmoryHelper:SetCameraStartTrans(CameraComponent:K2_GetComponentToWorld(), CameraComponent.FieldOfView, ViewActor)
  return true
end

function M:LoadScene(SceneSpec)
  self.SceneSpec = SceneSpec
  local SceneId = self:_ResolveSceneId(SceneSpec, self.SceneDraft, self.InitialSceneId)
  local EntityCount = 0
  for _, _ in pairs(SceneSpec and SceneSpec.Entities or {}) do
    EntityCount = EntityCount + 1
  end
  DebugPrint(string.format("PersonInfoDisplayController: LoadScene sceneId=%s entityCount=%s focusEntity=%s scenePath=%s", tostring(SceneId), tostring(EntityCount), tostring(SceneSpec and SceneSpec.FocusEntityId or nil), tostring(DisplayConfig:GetScenePath(SceneId))))
  self.SceneService:SetPreviewScenePath(DisplayConfig:GetScenePath(SceneId))
  self.SceneService:LoadScene(CommonConst.EPreviewSceneType.PreviewCommon)
  self._SceneColorLightingScheduled = self:ApplySceneColor(SceneId)
  self:RebuildEntities(SceneSpec and SceneSpec.Entities or {})
  if SceneSpec and SceneSpec.FocusEntityId and self:GetEntityHandle(SceneSpec.FocusEntityId) then
    self:SetFocusEntity(SceneSpec.FocusEntityId, false)
  else
    self:SetFocusEntity(nil, false)
  end
  self:ApplySceneInitialCamera(SceneId, SceneSpec and SceneSpec.Camera or nil)
  self:ApplyDraftCamera(SceneSpec and SceneSpec.Camera or nil)
  local Delay = PersonInfoCommon.OpenPageCameraDelay or 0
  
  local function DoViewTarget()
    self:ViewTarget()
  end
  
  if Delay > 0 and self.ViewUI and self.ViewUI.AddTimer then
    self.ViewUI:AddTimer(Delay, DoViewTarget, false, 0, "LoadSceneViewTarget", true)
  else
    self:ViewTarget()
  end
  DebugPrint(string.format("PersonInfoDisplayController: LoadScene finished focused=%s mainActor=%s", tostring(self.FocusEntityId), GetObjectNameSafe(self:GetMainCharacterActor())))
end

function M:LoadDraft(Draft)
  self.SceneDraft = Draft
  local SceneSpec = self.SceneComposer:BuildSceneSpec(self.ViewUI, Draft)
  local CharCount = 0
  for _, Slot in ipairs(Draft and Draft.CharacterSlots or {}) do
    if Slot and Slot.CharData then
      CharCount = CharCount + 1
    end
  end
  DebugPrint(string.format("PersonInfoDisplayController: LoadDraft sceneId=%s charCount=%s hasCamera=%s", tostring(Draft and Draft.Scene and Draft.Scene.SceneId or nil), tostring(CharCount), tostring(Draft and Draft.Camera ~= nil)))
  self:LoadScene(SceneSpec)
  if self.FocusEntityId then
    self:SetFocusEntity(self.FocusEntityId, false)
  end
  self.ArmoryPlayer = self:GetMainCharacterActor()
  DebugPrint(string.format("PersonInfoDisplayController: LoadDraft ArmoryPlayer=%s", GetObjectNameSafe(self.ArmoryPlayer)))
end

function M:ClearEntities()
  if self.HighlightComponent then
    self.HighlightComponent:ClearAllHighlight()
  end
  for _, Handle in pairs(self.EntityHandles) do
    if Handle and Handle.Dispose then
      Handle:Dispose()
    end
  end
  self.EntityHandles = {}
end

function M:RebuildEntities(EntitySpecs)
  self:ClearEntities()
  local OrderedEntitySpecs = {}
  for _, EntitySpec in pairs(EntitySpecs or {}) do
    OrderedEntitySpecs[#OrderedEntitySpecs + 1] = EntitySpec
  end
  table.sort(OrderedEntitySpecs, function(EntitySpecA, EntitySpecB)
    local IdA = EntitySpecA and EntitySpecA.Id or ""
    local IdB = EntitySpecB and EntitySpecB.Id or ""
    return tostring(IdA) < tostring(IdB)
  end)
  DebugPrint(string.format("PersonInfoDisplayController: RebuildEntities orderedCount=%s", tostring(#OrderedEntitySpecs)))
  for _, EntitySpec in ipairs(OrderedEntitySpecs) do
    if EntitySpec.Type == DisplayTypes.EntityType.Char then
      DebugPrint(string.format("PersonInfoDisplayController: RebuildEntities createChar entityId=%s charId=%s hasAppearance=%s hasWeapon=%s hasAnim=%s", tostring(EntitySpec.Id), tostring(EntitySpec.Source and EntitySpec.Source.CharData and EntitySpec.Source.CharData.CharId or nil), tostring(EntitySpec.Appearance ~= nil), tostring(EntitySpec.Source and nil ~= EntitySpec.Source.WeaponData), tostring(nil ~= EntitySpec.Anim)))
      local CharacterHandle = PreviewCharacterHandle:New({
        ViewUI = self.ViewUI,
        SceneService = self.SceneService,
        EnableReflection = PersonInfoCommon.EnablePreviewReflection,
        EnableSelectionCollision = true
      })
      CharacterHandle:Create(EntitySpec.Source and EntitySpec.Source.CharData, EntitySpec.Source and EntitySpec.Source.Avatar)
      if EntitySpec.Appearance then
        self.AppearanceService:ApplyCharacterAppearance(CharacterHandle, EntitySpec.Appearance)
      end
      if EntitySpec.Transform then
        CharacterHandle:SetTransform(EntitySpec.Transform)
      end
      self:_ApplyCharacterVisualState(CharacterHandle, EntitySpec.Source and EntitySpec.Source.WeaponData or nil, EntitySpec.Anim)
      self.EntityHandles[EntitySpec.Id] = CharacterHandle
      DebugPrint(string.format("PersonInfoDisplayController: RebuildEntities createdChar entityId=%s actor=%s", tostring(EntitySpec.Id), GetObjectNameSafe(CharacterHandle.GetActor and CharacterHandle:GetActor() or nil)))
    end
  end
  for _, EntitySpec in ipairs(OrderedEntitySpecs) do
    if EntitySpec.Type == DisplayTypes.EntityType.Pet then
      DebugPrint(string.format("PersonInfoDisplayController: RebuildEntities createPet entityId=%s owner=%s petId=%s", tostring(EntitySpec.Id), tostring(EntitySpec.OwnerEntityId), tostring(EntitySpec.Source and EntitySpec.Source.PetData and EntitySpec.Source.PetData.PetId or nil)))
      local PetHandle = PreviewPetHandle:New({
        ViewUI = self.ViewUI,
        SceneService = self.SceneService
      })
      local OwnerHandle = EntitySpec.OwnerEntityId and self.EntityHandles[EntitySpec.OwnerEntityId] or nil
      PetHandle:Create(EntitySpec.Source and EntitySpec.Source.PetData, OwnerHandle, {
        Transform = EntitySpec.Transform
      })
      self.EntityHandles[EntitySpec.Id] = PetHandle
    end
  end
  DebugPrint(string.format("PersonInfoDisplayController: RebuildEntities finished handleCount=%s", tostring(#OrderedEntitySpecs)))
end

function M:GetEntityHandle(EntityId)
  return self.EntityHandles and self.EntityHandles[EntityId]
end

function M:GetEditor()
  return self.Editor
end

function M:BeginPointerSelection(MyGeometry, PointerEvent)
  if self.SelectionComponent and self.SelectionComponent.BeginPointerPress then
    self.SelectionComponent:BeginPointerPress(MyGeometry, PointerEvent)
  end
end

function M:ClearPendingPointerSelection()
  if self.SelectionComponent and self.SelectionComponent.ClearPendingPointerPress then
    self.SelectionComponent:ClearPendingPointerPress()
  end
end

function M:CommitPointerSelection()
  if not self.SelectionComponent or not self.SelectionComponent.CommitPointerSelection then
    return nil
  end
  return self.SelectionComponent:CommitPointerSelection()
end

function M:BeginCameraPreviewTransaction()
  self:_StopWheelCameraPreviewCommitTimer()
  local Editor = self:GetEditor()
  if not Editor or not Editor.BeginPreviewTransaction then
    return false
  end
  return Editor:BeginPreviewTransaction(CAMERA_PREVIEW_TRANSACTION_KEY)
end

function M:BeginWheelCameraPreviewTransaction()
  local Editor = self:GetEditor()
  if not Editor or not Editor.BeginPreviewTransaction then
    return false
  end
  return Editor:BeginPreviewTransaction(WHEEL_CAMERA_PREVIEW_TRANSACTION_KEY)
end

function M:_RefreshCustomEditSaveState()
  local RootController = self.ActiveCustomEditRootController or self.ViewUI and self.ViewUI.GetCustomEditRootController and self.ViewUI:GetCustomEditRootController() or nil
  if not RootController then
    return
  end
  local RootViewPanel = RootController.RootViewPanel or RootController.OwnerWidget or nil
  if RootViewPanel and RootViewPanel.RefreshSaveButtonState then
    RootViewPanel:RefreshSaveButtonState()
  end
end

function M:CommitCameraPreviewTransaction()
  local Editor = self:GetEditor()
  if not (Editor and Editor.IsPreviewTransactionActive) or not Editor:IsPreviewTransactionActive(CAMERA_PREVIEW_TRANSACTION_KEY) then
    return false
  end
  local bCommitted = Editor:CommitPreviewTransaction()
  if bCommitted then
    self:_RefreshCustomEditSaveState()
  end
  return bCommitted
end

function M:CommitWheelCameraPreviewTransaction()
  self:_StopWheelCameraPreviewCommitTimer()
  local Editor = self:GetEditor()
  if not (Editor and Editor.IsPreviewTransactionActive) or not Editor:IsPreviewTransactionActive(WHEEL_CAMERA_PREVIEW_TRANSACTION_KEY) then
    return false
  end
  local bCommitted = Editor:CommitPreviewTransaction()
  if bCommitted then
    self:_RefreshCustomEditSaveState()
  end
  return bCommitted
end

function M:CancelCameraPreviewTransaction()
  self:_StopWheelCameraPreviewCommitTimer()
  local Editor = self:GetEditor()
  if not (Editor and Editor.IsPreviewTransactionActive) or not Editor:IsPreviewTransactionActive(CAMERA_PREVIEW_TRANSACTION_KEY) then
    return false
  end
  local bCanceled = Editor:CancelPreviewTransaction()
  if bCanceled then
    self:_RefreshCustomEditSaveState()
  end
  return bCanceled
end

function M:IsCameraPreviewTransactionActive()
  local Editor = self:GetEditor()
  if not Editor or not Editor.IsPreviewTransactionActive then
    return false
  end
  return Editor:IsPreviewTransactionActive(CAMERA_PREVIEW_TRANSACTION_KEY)
end

function M:IsWheelCameraPreviewTransactionActive()
  local Editor = self:GetEditor()
  if not Editor or not Editor.IsPreviewTransactionActive then
    return false
  end
  return Editor:IsPreviewTransactionActive(WHEEL_CAMERA_PREVIEW_TRANSACTION_KEY)
end

function M:_RestartWheelCameraPreviewCommitTimer()
  self:_StopWheelCameraPreviewCommitTimer()
  self.ViewUI:AddTimer(WHEEL_CAMERA_PREVIEW_COMMIT_DELAY, function()
    self:CommitWheelCameraPreviewTransaction()
  end, false, 0, WHEEL_CAMERA_PREVIEW_COMMIT_TIMER, true)
end

function M:_StopWheelCameraPreviewCommitTimer()
  self.ViewUI:RemoveTimer(WHEEL_CAMERA_PREVIEW_COMMIT_TIMER)
end

function M:GetFocusedCharacterEntityId()
  if self.FocusEntityId and self:_IsCharacterEntityId(self.FocusEntityId) and self:GetEntityHandle(self.FocusEntityId) then
    return self.FocusEntityId
  end
  for _, EntityId in ipairs(self:_GetOrderedCharacterEntityIds()) do
    if self:GetEntityHandle(EntityId) then
      return EntityId
    end
  end
  return nil
end

function M:GetMainCharacterHandle()
  local EntityId = self:GetFocusedCharacterEntityId()
  if not EntityId then
    return nil
  end
  return self:GetEntityHandle(EntityId)
end

function M:GetMainCharacterActor()
  local Handle = self:GetMainCharacterHandle()
  return Handle and Handle:GetActor() or nil
end

function M:SetFocusCharacterSlot(SlotIndex, bOpenHighlight)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    self:SetFocusEntity(nil, false)
    return
  end
  self:SetFocusEntity(self:_BuildCharacterEntityId(SlotIndex), true == bOpenHighlight)
end

function M:_RefreshFocusedCharacterSlotHighlight(SlotIndex)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return
  end
  local EntityId = self:_BuildCharacterEntityId(SlotIndex)
  if self.FocusEntityId ~= EntityId or not self.HighlightComponent then
    return
  end
  self.HighlightComponent:CloseFocusHighlight()
  self.HighlightComponent:RefreshFocusHighlight(nil, EntityId)
  self.HighlightComponent:OpenFocusHighlight()
end

function M:GetCharacterHandleBySlotIndex(SlotIndex)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return nil
  end
  return self:GetEntityHandle(self:_BuildCharacterEntityId(SlotIndex))
end

local function BuildDefaultWeaponPoseActionData(WeaponData)
  if not WeaponData then
    return nil
  end
  local PoseTag = "Melee"
  if WeaponData.HasTag and WeaponData:HasTag("Ranged") then
    PoseTag = "Ranged"
  end
  return {PoseTag = PoseTag}
end

local function ShouldPreviewDisplayWeapon(WeaponData, ActionData)
  if not WeaponData then
    return false
  end
  if ActionData and ActionData.PoseId ~= nil then
    return false
  end
  return true
end

function M:_ApplyCharacterVisualState(CharacterHandle, WeaponData, ActionData)
  if not CharacterHandle then
    return
  end
  CharacterHandle:ClearDisplayWeapon("Melee")
  CharacterHandle:ClearDisplayWeapon("Ranged")
  if CharacterHandle.ClearAllHideTags then
    CharacterHandle:ClearAllHideTags()
  end
  local bDisplayWeaponReady = false
  if ShouldPreviewDisplayWeapon(WeaponData, ActionData) then
    bDisplayWeaponReady = CharacterHandle:ChangeDisplayWeapon(WeaponData) == true
  end
  if ActionData then
    local bWeaponPoseAction = "Melee" == ActionData.PoseTag or "Ranged" == ActionData.PoseTag
    if bWeaponPoseAction and not bDisplayWeaponReady then
      CharacterHandle:StopMontage()
      return
    end
    self:_ApplyCharacterActionPreview(CharacterHandle, ActionData)
    return
  end
  if bDisplayWeaponReady then
    self:_ApplyCharacterActionPreview(CharacterHandle, BuildDefaultWeaponPoseActionData(WeaponData))
    return
  end
  self:_ApplyCharacterActionPreview(CharacterHandle, nil)
end

function M:ApplyCharacterTransform(SlotIndex, Transform, Draft)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  local CharacterHandle = self:GetCharacterHandleBySlotIndex(SlotIndex)
  if not CharacterHandle or not Transform then
    return false
  end
  if nil ~= Draft then
    self.SceneDraft = Draft
  end
  CharacterHandle:SetTransform(Transform)
  return true
end

function M:ApplyCharacterWeaponAndAction(SlotIndex, Draft)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  local CharacterHandle = self:GetCharacterHandleBySlotIndex(SlotIndex)
  if not CharacterHandle then
    return false
  end
  if nil ~= Draft then
    self.SceneDraft = Draft
  end
  local SlotDraft = Draft and Draft.CharacterSlots and Draft.CharacterSlots[SlotIndex] or nil
  if not SlotDraft or not SlotDraft.CharData then
    DebugPrint(string.format("PersonInfoDisplayController: ApplyCharacterWeaponAndAction abort slot=%s no slot draft or char", tostring(SlotIndex)))
    return false
  end
  DebugPrint(string.format("PersonInfoDisplayController: ApplyCharacterWeaponAndAction slot=%s actor=%s weaponId=%s actionPose=%s actionMode=%s", tostring(SlotIndex), GetObjectNameSafe(CharacterHandle.GetActor and CharacterHandle:GetActor() or nil), tostring(SlotDraft.WeaponData and SlotDraft.WeaponData.WeaponId or nil), tostring(SlotDraft.Action and SlotDraft.Action.PoseTag or nil), tostring(SlotDraft.Action and SlotDraft.Action.Mode or nil)))
  self:_ApplyCharacterVisualState(CharacterHandle, SlotDraft.WeaponData, SlotDraft.Action)
  if self.FocusEntityId == self:_BuildCharacterEntityId(SlotIndex) and self.HighlightComponent then
    self.HighlightComponent:RefreshFocusHighlight(self.FocusEntityId, self.FocusEntityId)
  end
  return true
end

function M:FinalizeCharacterWeaponPose(SlotIndex, Draft)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  local SlotDraft = Draft and Draft.CharacterSlots and Draft.CharacterSlots[SlotIndex] or nil
  if not (SlotDraft and SlotDraft.CharData) or not SlotDraft.WeaponData then
    return false
  end
  if SlotDraft.Action then
    return false
  end
  local CharacterHandle = self:GetCharacterHandleBySlotIndex(SlotIndex)
  if not CharacterHandle then
    return false
  end
  if nil ~= Draft then
    self.SceneDraft = Draft
  end
  self:_ApplyCharacterVisualState(CharacterHandle, SlotDraft.WeaponData, nil)
  return true
end

function M:SetFocusEntity(EntityId, bOpenHighlight)
  local OldEntityId = self.FocusEntityId
  self.FocusEntityId = EntityId
  DebugPrint(string.format("PersonInfoDisplayController: SetFocusEntity old=%s new=%s openHighlight=%s exists=%s", tostring(OldEntityId), tostring(self.FocusEntityId), tostring(true == bOpenHighlight), tostring(self.FocusEntityId ~= nil and nil ~= self:GetEntityHandle(self.FocusEntityId))))
  if self.HighlightComponent then
    self.HighlightComponent:RefreshFocusHighlight(OldEntityId, self.FocusEntityId)
    if true == bOpenHighlight then
      self.HighlightComponent:OpenFocusHighlight()
    elseif OldEntityId and OldEntityId ~= self.FocusEntityId then
      self.HighlightComponent:CloseFocusHighlight()
    end
  end
  self:SyncCameraObservedEntity(self.FocusEntityId)
end

function M:ClearFocusHighlight()
  self.FocusEntityId = nil
  if self.HighlightComponent then
    self.HighlightComponent:CloseFocusHighlight()
    self.HighlightComponent:ClearAllHighlight()
  end
end

function M:SyncCameraObservedEntity(EntityId)
  local CharacterHandle = self:GetEntityHandle(EntityId)
  if not CharacterHandle then
    if self.ArmoryHelper then
      self.ArmoryHelper:SetPlayer(nil, false)
      self.ArmoryHelper:SetViewActor(nil)
    end
    return
  end
  local Actor = CharacterHandle.GetActor and CharacterHandle:GetActor() or nil
  if not Actor then
    return
  end
  if self.ArmoryHelper then
    self.ArmoryHelper:SetPlayer(Actor)
    self.ArmoryHelper:SetViewActor(Actor)
    self.ArmoryHelper.OriginalRootTrans = Actor.Mesh and Actor.Mesh:K2_GetComponentToWorld() or Actor:GetTransform()
  end
  self:EnsureArmoryCameraStartState()
end

function M:GetOutlineCameraComponent()
  local OutlineCamera
  if self.PreviewCameraRuntime then
    if self.PreviewCameraRuntime.EnsureCameraActor then
      self.PreviewCameraRuntime:EnsureCameraActor()
    end
    if self.PreviewCameraRuntime.GetCameraComponent then
      OutlineCamera = self.PreviewCameraRuntime:GetCameraComponent()
    end
  end
  if not OutlineCamera and self.ArmoryHelper and self.ArmoryHelper.Camera then
    OutlineCamera = self.ArmoryHelper.Camera
  end
  return OutlineCamera
end

function M:ShowMainCharacter(CharData, Avatar, AppearanceInfo)
  if self.Editor then
    self.Avatar = Avatar or self.Avatar
    self.CurrentCharInfo = CharData
    self.CurrentAppearanceInfo = AppearanceInfo
    self.Editor:SetSingleCharacter(CharData, self.Avatar, AppearanceInfo)
    return
  end
  self.Avatar = Avatar or self.Avatar
  self.CurrentCharInfo = CharData
  self.CurrentAppearanceInfo = AppearanceInfo
  local SceneSpec = self.SpecBuilder:BuildSceneSpec(self.ViewUI, {
    Entities = {
      {
        Id = self:_BuildCharacterEntityId(1),
        Type = DisplayTypes.EntityType.Char,
        Source = {
          CharData = CharData,
          Avatar = self.Avatar
        },
        Appearance = AppearanceInfo,
        Anim = nil
      }
    }
  })
  self:LoadScene(SceneSpec)
  self.ArmoryPlayer = self:GetMainCharacterActor()
end

function M:ChangeMainCharacter(CharData, Avatar)
  if self.Editor then
    self.Avatar = Avatar or self.Avatar
    self.CurrentCharInfo = CharData
    local FocusSlotIndex = self:GetFocusedCharacterSlotIndex()
    if not FocusSlotIndex then
      return
    end
    self.Editor:SetCharacterToSlot(FocusSlotIndex, CharData, self.Avatar, self.CurrentAppearanceInfo)
    return
  end
  local Handle = self:GetMainCharacterHandle()
  self.Avatar = Avatar or self.Avatar
  self.CurrentCharInfo = CharData
  if not Handle then
    self:ShowMainCharacter(CharData, self.Avatar, self.CurrentAppearanceInfo)
    return
  end
  Handle:ChangeCharacter(CharData, self.Avatar, true)
  self.ArmoryPlayer = self:GetMainCharacterActor()
end

function M:ApplyMainCharacterAppearance(AppearanceInfo)
  if self.Editor then
    self.CurrentAppearanceInfo = AppearanceInfo
    local FocusSlotIndex = self:GetFocusedCharacterSlotIndex()
    if not FocusSlotIndex then
      return
    end
    self.Editor:SetCharacterAppearance(FocusSlotIndex, AppearanceInfo)
    return
  end
  local Handle = self:GetMainCharacterHandle()
  if not Handle or not AppearanceInfo then
    return
  end
  self.CurrentAppearanceInfo = AppearanceInfo
  self.AppearanceService:ApplyCharacterAppearance(Handle, AppearanceInfo)
  self.ArmoryPlayer = self:GetMainCharacterActor()
end

function M:ChangeMainCharacterWeapon(WeaponData)
  if self.Editor then
    self.CurrentWeaponInfo = WeaponData
    local FocusSlotIndex = self:GetFocusedCharacterSlotIndex()
    if not FocusSlotIndex then
      return
    end
    self.Editor:MoveCharacterWeaponToSlot(FocusSlotIndex, WeaponData)
    return
  end
  local Handle = self:GetMainCharacterHandle()
  if not Handle or not WeaponData then
    return
  end
  self.CurrentWeaponInfo = WeaponData
  Handle:ChangeDisplayWeapon(WeaponData)
  self.ArmoryPlayer = self:GetMainCharacterActor()
end

function M:PlayMainCharacterPose(PoseTag)
  if self.Editor then
    local FocusSlotIndex = self:GetFocusedCharacterSlotIndex()
    if not FocusSlotIndex then
      return
    end
    self.Editor:SetCharacterAction(FocusSlotIndex, PoseTag and {PoseTag = PoseTag} or nil)
    return
  end
  local Handle = self:GetMainCharacterHandle()
  if not Handle then
    return
  end
  if PoseTag then
    Handle:PlayMontage({PoseTag = PoseTag})
  end
end

function M:HideMainCharacter(Tag, bHide)
  local Handle = self:GetMainCharacterHandle()
  DebugPrint(string.format("PersonInfoDisplayController: HideMainCharacter tag=%s hide=%s focusEntity=%s hasHandle=%s actor=%s", tostring(Tag), tostring(true == bHide), tostring(self.FocusEntityId), tostring(nil ~= Handle), GetObjectNameSafe(Handle and Handle.GetActor and Handle:GetActor() or nil)))
  if not Handle then
    return
  end
  if bHide then
    Handle:Hide(Tag)
  else
    Handle:Show(Tag)
  end
end

function M:HideAllCharacterActors(Tag, bHide)
  for EntityId, Handle in pairs(self.EntityHandles or {}) do
    if Handle and self:_IsCharacterEntityId(EntityId) then
      if bHide and Handle.Hide then
        Handle:Hide(Tag)
      elseif not bHide and Handle.Show then
        Handle:Show(Tag)
      end
    end
  end
end

function M:OnDragViewActor(CursorDelta)
  if self.IsPreviewSuspended then
    return
  end
  local RootController = self.ActiveCustomEditRootController or self.ViewUI and self.ViewUI.GetCustomEditRootController and self.ViewUI:GetCustomEditRootController() or nil
  if RootController and RootController.IsPreviewCameraRoamEnabled and not RootController:IsPreviewCameraRoamEnabled() then
    return
  end
  if not self.ArmoryHelper then
    return
  end
  self.ArmoryHelper:OnDragViewActor(CursorDelta)
  local Handle = self:GetMainCharacterHandle()
  local ReflectionActor = Handle and Handle:GetReflectionActor() or nil
  if ReflectionActor then
    ReflectionActor:K2_SetActorRotation(self.ArmoryHelper:GetViewActorRotation(), false, nil, false)
  end
end

function M:OrbitCameraByCursorDelta(CursorDelta)
  if self.IsPreviewSuspended then
    return false
  end
  if not CursorDelta then
    return false
  end
  local Editor = self:GetEditor()
  if not Editor or not Editor.MoveCameraLocalRotation then
    return false
  end
  return Editor:MoveCameraLocalRotation(-(CursorDelta.Y or 0) * (GetCameraInputConfig().CameraDragPitchSpeed or 0.5), (CursorDelta.X or 0) * (GetCameraInputConfig().CameraDragYawSpeed or 0.5), 0, self:GetCameraLimitConfig())
end

function M:OnScrolling(DeltaMove)
  if self.IsPreviewSuspended then
    return false
  end
  local RootController = self.ActiveCustomEditRootController or self.ViewUI and self.ViewUI.GetCustomEditRootController and self.ViewUI:GetCustomEditRootController() or nil
  local bUseCustomEditRoam = RootController and RootController.IsPreviewCameraRoamEnabled ~= nil
  if bUseCustomEditRoam and not RootController:IsPreviewCameraRoamEnabled() then
    return false
  end
  if not bUseCustomEditRoam and self.PreviewCameraRuntime and self:IsEnableCameraScrolling() then
    return self.PreviewCameraRuntime:OnScrolling(DeltaMove)
  end
  if self.Editor and DeltaMove and 0 ~= DeltaMove then
    self:BeginWheelCameraPreviewTransaction()
    local DistanceDelta = (DeltaMove or 0) * (GetCameraInputConfig().CameraScrollDistanceScale or 20)
    local bHandled = self:MoveCameraByAxis(DistanceDelta, 0, 0)
    if bHandled then
      self:_RestartWheelCameraPreviewCommitTimer()
    end
    return bHandled
  end
  return false
end

function M:MoveCameraByAxis(ForwardDelta, HorizontalDelta, VerticalDelta)
  local Editor = self:GetEditor()
  if not Editor or not Editor.MoveCameraLocalPosition then
    return false
  end
  local _, LocalRotation = self:GetCameraRigLocalTransform()
  LocalRotation = LocalRotation or FRotator(0, 0, 0)
  local ForwardVector = UE4.UKismetMathLibrary.GetForwardVector(LocalRotation)
  local RightVector = UE4.UKismetMathLibrary.GetRightVector(LocalRotation)
  local UpVector = UE4.UKismetMathLibrary.GetUpVector(LocalRotation)
  local MoveVector = ForwardVector * (ForwardDelta or 0) + RightVector * (HorizontalDelta or 0) + UpVector * (VerticalDelta or 0)
  return Editor:MoveCameraLocalPosition(MoveVector.X or 0, MoveVector.Y or 0, MoveVector.Z or 0, self:GetCameraLimitConfig())
end

function M:SetPreviewEntitiesHidden(Tag, bHidden)
  for _, Handle in pairs(self.EntityHandles or {}) do
    if Handle then
      if bHidden and Handle.Hide then
        Handle:Hide(Tag)
      elseif not bHidden and Handle.Show then
        Handle:Show(Tag)
      end
    end
  end
end

function M:SuspendPreviewControl()
  if self.IsPreviewSuspended then
    return
  end
  self.IsPreviewSuspended = true
  self:SetPreviewEntitiesHidden(PERSONAL_PREVIEW_HIDE_TAG, true)
  if self.ArmoryHelper then
    self.ArmoryHelper:SetPreviewLevelActor(nil)
  end
  if self.PreviewCameraRuntime then
    self.PreviewCameraRuntime:EndViewTarget()
  end
end

function M:ResumePreviewControl()
  if not self.IsPreviewSuspended then
    return
  end
  self.IsPreviewSuspended = false
  self:SetPreviewEntitiesHidden(PERSONAL_PREVIEW_HIDE_TAG, false)
  if self.SceneService and self.SceneService:IsSceneLoaded() then
    self.SceneService:RebindPreviewLevelActor()
    self._NeedRefreshEnvironmentOnBecomeViewTarget = true
    self:ViewTarget()
    local FocusEntityId = self.FocusEntityId
    local Draft = self.Editor and self.Editor.GetDraft and self.Editor:GetDraft() or nil
    local DraftCamera = Draft and Draft.Camera or nil
    if FocusEntityId then
      self:SetFocusEntity(FocusEntityId)
    end
    if self.LastCameraTags then
      self:SetArmoryCameraTag(self.LastCameraTags[1], self.LastCameraTags[2], self.LastCameraTags[3], self.LastCameraTags[4])
    else
      self:ApplySceneInitialCamera(self:_ResolveSceneId(self.SceneSpec, Draft or self.SceneDraft, self.InitialSceneId), DraftCamera or self.SceneSpec and self.SceneSpec.Camera or nil)
      self:ApplyDraftCamera(DraftCamera or self.SceneSpec and self.SceneSpec.Camera or nil)
    end
  end
end

function M:RefreshAfterExternalPreviewClosed()
  self:ResumePreviewControl()
end

function M:GetCameraLimitConfig()
  local Draft = self.Editor and self.Editor.GetDraft and self.Editor:GetDraft() or nil
  return Draft and Draft.Camera and Draft.Camera.LimitConfig or nil
end

function M:SetAvatar(Avatar)
  self.Avatar = Avatar
  self.InitialAvatar = Avatar
end

function M:GetAvatar()
  return self.Avatar
end

function M:ChangeCharModel(CharData)
  self:ChangeMainCharacter(CharData, self.Avatar)
end

function M:ChangeCharAppearance(AppearanceInfo)
  self:ApplyMainCharacterAppearance(AppearanceInfo)
end

function M:ApplyAppearanceSuit(AppearanceInfo)
  self:ApplyMainCharacterAppearance(AppearanceInfo)
end

function M:ChangeWeaponModel(WeaponData)
  self:ChangeMainCharacterWeapon(WeaponData)
end

function M:ChangePlayerWeapon(WeaponData, PlayerCharacter)
  if PlayerCharacter and PlayerCharacter ~= self:GetMainCharacterActor() then
    return
  end
  self:ChangeMainCharacterWeapon(WeaponData)
end

function M:GetFocusedCharacterSlotIndex()
  local EntityId = self:GetFocusedCharacterEntityId()
  if not EntityId then
    return nil
  end
  local SlotIndex = string.match(EntityId, "^char_slot_(%d+)$")
  if SlotIndex then
    return tonumber(SlotIndex)
  end
  return nil
end

function M:GetPlayerActor()
  return self:GetMainCharacterActor()
end

function M:HidePlayerActor(Tag, IsHidden)
  self:HideMainCharacter(Tag, IsHidden)
end

function M:CalcArmoryCameraTag(Type, Tag, Behavior, ExtraTag)
  local CameraTag1, CameraTag2, CameraTag3, CameraTag4 = "", "", "", ""
  CameraTag3 = ExtraTag or CameraTag3
  if Type == CommonConst.ArmoryType.Char then
    CameraTag1 = Type
    CameraTag2 = Behavior
    if Behavior == CommonConst.ArmoryType.Mod then
      CameraTag3 = nil
    elseif Behavior == CommonConst.ArmoryTag.Appearance then
      if not Tag or Tag == CommonConst.ArmoryType.Char then
        CameraTag2 = Behavior
      else
        CameraTag2 = Tag
        CameraTag3 = ExtraTag or ""
      end
    elseif Behavior == CommonConst.ArmoryTag.Files then
      CameraTag2 = Behavior
    elseif Behavior == CommonConst.ArmoryTag.Char then
      CameraTag2 = nil
    end
  elseif Type == CommonConst.ArmoryType.Weapon then
    CameraTag1 = Type
    CameraTag2 = Tag
    CameraTag3 = Behavior
  else
    CameraTag1 = CommonConst.ArmoryType.Char
  end
  return CameraTag1, CameraTag2, CameraTag3, CameraTag4
end

function M:GetCameraData()
  local SystemUI = DataMgr.SystemUI
  local CameraDataConfig = {
    [SystemUI.PersonInfoPageMain.UIName] = DataMgr.PersonalPageCameraData
  }
  if CameraDataConfig[self.UIName] then
    return CameraDataConfig[self.UIName]
  end
  return DataMgr.PersonalPageCameraData or DataMgr.ArmoryCameraData
end

function M:SetExCameraOffset(Offset)
  self.ExCameraOffset = Offset
end

function M:EnableCameraScrolling(bEnable)
  if self.PreviewCameraRuntime then
    self.PreviewCameraRuntime.EnableCameraScrolling = bEnable
  end
end

function M:IsEnableCameraScrolling()
  return self.PreviewCameraRuntime and self.PreviewCameraRuntime.EnableCameraScrolling
end

function M:FixedCameraTransTimeOnce(Time)
  self._FixedCameraTransTimeOnce = Time
end

function M:SetArmoryCameraTag(Tag1, Tag2, Tag3, Tag4)
  if not self.PreviewCameraRuntime then
    return
  end
  self:EnsureArmoryCameraStartState()
  self.LastCameraTags = {
    Tag1 or "",
    Tag2 or "",
    Tag3 or "",
    Tag4 or ""
  }
  local PlayerActor = self:GetPlayerActor()
  local CameraData = self:GetCameraData()
  local ExplicitTag4 = ""
  local DefaultTag4 = ""
  if PlayerActor then
    Tag1 = Tag1 or ""
    Tag2 = "0" == Tag2 and "_" .. PlayerActor.PlayerAnimInstance.IdleTag or Tag2 and "" ~= Tag2 and "_" .. Tag2 or ""
    Tag3 = Tag3 and "" ~= Tag3 and "_" .. Tag3 or ""
    ExplicitTag4 = Tag4 and "" ~= Tag4 and "_" .. Tag4 or ""
    DefaultTag4 = "_" .. PlayerActor:GetBattleCharBodyType()
  end
  local Tag = (Tag1 or "") .. (Tag2 or "") .. (Tag3 or "") .. (ExplicitTag4 or "")
  local Data = CameraData and CameraData[Tag]
  if not Data and "" == ExplicitTag4 and "" ~= DefaultTag4 then
    Tag = (Tag1 or "") .. (Tag2 or "") .. (Tag3 or "") .. (DefaultTag4 or "")
    Data = CameraData and CameraData[Tag]
  end
  if not Data then
    Tag = "Default"
    Data = CameraData and CameraData[Tag]
  end
  if not Data then
    return
  end
  local Location = FVector(Data.Location[1], Data.Location[2], Data.Location[3])
  local Rotation = FRotator(Data.Rotation[2], Data.Rotation[3], Data.Rotation[1])
  local OffsetVector = FVector(0, 0, 0)
  local OffsetRotator = FRotator(0, 0, 0)
  local CurrentRoleId = PlayerActor and PlayerActor.CurrentRoleId or 0
  if Data.LocationOffset then
    local OffsetData = Data.LocationOffset[CurrentRoleId]
    if OffsetData then
      OffsetVector = FVector(OffsetData[1], OffsetData[2], OffsetData[3])
    end
  end
  if Data.RotationOffset then
    local OffsetData = Data.RotationOffset[CurrentRoleId]
    if OffsetData then
      OffsetRotator = OffsetRotator + FRotator(OffsetData[2], OffsetData[3], OffsetData[1])
    end
  end
  if self.ExCameraOffset then
    OffsetVector = OffsetVector + self.ExCameraOffset
    self.ExCameraOffset = nil
  end
  Location = Location + OffsetVector
  Rotation = Rotation + OffsetRotator
  local Time = self._FixedCameraTransTimeOnce or Data.Time or 0
  self._FixedCameraTransTimeOnce = nil
  PreviewCameraCompatibility:ApplyTaggedCamera({
    Controller = self,
    CameraRuntime = self.PreviewCameraRuntime,
    Data = Data,
    OffsetVector = OffsetVector,
    OffsetRotator = OffsetRotator,
    Time = Time
  })
  self.AppliedDraftCameraOffset = nil
  self.AppliedDraftCameraRotation = nil
  local Draft = self.Editor and self.Editor.GetDraft and self.Editor:GetDraft() or nil
  self:ApplyDraftCamera(Draft and Draft.Camera or self.SceneDraft and self.SceneDraft.Camera or self.SceneSpec and self.SceneSpec.Camera or nil)
end

function M:SetArmoryMontageTag(Tag)
  self:PlayMainCharacterPose(Tag)
end

function M:SetMontageAndCamera(Type, Tag, Behavior, ExtraTag)
  local PoseTag
  if nil == Type or Type == CommonConst.ArmoryType.Char then
    PoseTag = nil
  elseif Type == CommonConst.ArmoryType.Weapon then
    PoseTag = Tag or "Armory"
  end
  if PoseTag then
    self:SetArmoryMontageTag(PoseTag)
  end
  local Draft = self.Editor and self.Editor.GetDraft and self.Editor:GetDraft() or nil
  if Draft and Draft.Camera and Draft.Camera.HasCustomCamera then
    self:ApplyDraftCamera(Draft.Camera)
    return
  end
  self:ApplySceneInitialCamera(self:_ResolveSceneId(self.SceneSpec, self.SceneDraft, self.InitialSceneId), Draft and Draft.Camera or nil)
end

function M:ViewTarget()
  if self.IsPreviewSuspended then
    DebugPrint("PersonInfoDisplayController: ViewTarget skipped because preview suspended")
    return
  end
  if self.IsControled then
    DebugPrint("PersonInfoDisplayController: ViewTarget skipped because already controlled")
    return
  end
  if not self.PreviewCameraRuntime then
    DebugPrint("PersonInfoDisplayController: ViewTarget skipped because PreviewCameraRuntime missing")
    return
  end
  DebugPrint("PersonInfoDisplayController: ViewTarget use independent preview camera")
  self.PreviewCameraRuntime:ViewTarget()
end

function M:_GetOrderedCharacterEntityIds()
  local EntityIds = {}
  for EntityId, Handle in pairs(self.EntityHandles or {}) do
    if Handle and self:_IsCharacterEntityId(EntityId) then
      EntityIds[#EntityIds + 1] = EntityId
    end
  end
  table.sort(EntityIds)
  return EntityIds
end

function M:_BuildCharacterEntityId(SlotIndex)
  return "char_slot_" .. tostring(SlotIndex)
end

function M:PreviewCharacterChooseSlot(SlotIndex, CharData, Avatar, AppearanceInfo, ReferenceSlotDraft)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 or not CharData then
    return false
  end
  local EntityId = self:_BuildCharacterEntityId(SlotIndex)
  local CharacterHandle = self:GetEntityHandle(EntityId)
  local SceneId = self:_ResolveSceneId(self.SceneSpec, self.SceneDraft, self.InitialSceneId)
  local SlotTransform = ReferenceSlotDraft and ReferenceSlotDraft.Transform or nil
  SlotTransform = SlotTransform or DisplayConfig:GetDefaultCharacterTransform(SlotIndex, SceneId)
  self.Avatar = Avatar or self.Avatar
  self.CurrentCharInfo = CharData
  self.CurrentAppearanceInfo = AppearanceInfo
  if not CharacterHandle then
    CharacterHandle = PreviewCharacterHandle:New({
      ViewUI = self.ViewUI,
      SceneService = self.SceneService,
      EnableReflection = PersonInfoCommon.EnablePreviewReflection,
      EnableSelectionCollision = true
    })
    CharacterHandle:Create(CharData, self.Avatar)
    self.EntityHandles[EntityId] = CharacterHandle
  else
    CharacterHandle:ChangeCharacter(CharData, self.Avatar, true)
    if CharacterHandle.ClearAllHideTags then
      CharacterHandle:ClearAllHideTags()
    end
  end
  if SlotTransform then
    CharacterHandle:SetTransform(SlotTransform)
  end
  CharacterHandle:StopMontage()
  if AppearanceInfo then
    self.AppearanceService:ApplyCharacterAppearance(CharacterHandle, AppearanceInfo)
  end
  self:_RefreshFocusedCharacterSlotHighlight(SlotIndex)
  self.ArmoryPlayer = self:GetMainCharacterActor()
  return true
end

function M:RestoreCharacterChooseSlotPreview(SlotIndex, SlotDraft)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  local EntityId = self:_BuildCharacterEntityId(SlotIndex)
  local CharacterHandle = self:GetEntityHandle(EntityId)
  DebugPrint(string.format("PersonInfoDeleteChar: restore preview slot=%s entity=%s hasHandle=%s draftUuid=%s", tostring(SlotIndex), tostring(EntityId), tostring(nil ~= CharacterHandle), tostring(SlotDraft and SlotDraft.CharData and SlotDraft.CharData.Uuid or nil)))
  if not SlotDraft or not DisplayDraft:IsValidCharacterData(SlotDraft.CharData) then
    if CharacterHandle and CharacterHandle.Dispose then
      DebugPrint(string.format("PersonInfoDeleteChar: dispose handle slot=%s entity=%s actor=%s", tostring(SlotIndex), tostring(EntityId), tostring(CharacterHandle.GetActor and CharacterHandle:GetActor() or nil)))
      CharacterHandle:Dispose()
    end
    self.EntityHandles[EntityId] = nil
    if self.FocusEntityId == EntityId then
      self:SetFocusEntity(nil, false)
    end
    if self.ArmoryPlayer and CharacterHandle and self.ArmoryPlayer == CharacterHandle:GetActor() then
      self.ArmoryPlayer = self:GetMainCharacterActor()
    end
    DebugPrint(string.format("PersonInfoDeleteChar: restore empty success slot=%s entity=%s", tostring(SlotIndex), tostring(EntityId)))
    return true
  end
  local bSuccess = self:PreviewCharacterChooseSlot(SlotIndex, SlotDraft.CharData, SlotDraft.Avatar, SlotDraft.Appearance)
  if not bSuccess then
    DebugPrint(string.format("PersonInfoDeleteChar: restore filled preview failed slot=%s entity=%s draftUuid=%s", tostring(SlotIndex), tostring(EntityId), tostring(SlotDraft and SlotDraft.CharData and SlotDraft.CharData.Uuid or nil)))
    return false
  end
  CharacterHandle = self:GetEntityHandle(EntityId)
  if not CharacterHandle then
    return false
  end
  if SlotDraft.Transform then
    CharacterHandle:SetTransform(SlotDraft.Transform)
  end
  self:_ApplyCharacterVisualState(CharacterHandle, SlotDraft.WeaponData, SlotDraft.Action)
  self:_RefreshFocusedCharacterSlotHighlight(SlotIndex)
  DebugPrint(string.format("PersonInfoDeleteChar: restore filled success slot=%s entity=%s draftUuid=%s", tostring(SlotIndex), tostring(EntityId), tostring(SlotDraft and SlotDraft.CharData and SlotDraft.CharData.Uuid or nil)))
  return true
end

function M:_ApplyCharacterActionPreview(CharacterHandle, ActionData)
  if not CharacterHandle then
    return
  end
  if not ActionData then
    CharacterHandle:StopMontage()
    return
  end
  DebugPrint(string.format("PersonInfoDisplayController: ApplyCharacterActionPreview actor=%s mode=%s poseId=%s releaseWheel=%s montage=%s document=%s poseName=%s", tostring(GetObjectNameSafe(CharacterHandle.GetActor and CharacterHandle:GetActor() or nil)), tostring(ActionData.Mode), tostring(ActionData.PoseId), tostring(ActionData.ReleaseWheel), tostring(ActionData.MontagePath), tostring(ActionData.Document), tostring(ActionData.PoseName)))
  local bUseSequence = ActionData.Mode == DisplayTypes.AnimMode.Sequence or ActionData.Mode == nil and ActionData.Document and ActionData.PoseName
  if bUseSequence then
    CharacterHandle:PlayAnimSequence(ActionData)
    return
  end
  CharacterHandle:PlayMontage(ActionData)
end

function M:_IsCharacterEntityId(EntityId)
  return string.match(EntityId or "", "^char_slot_%d+$") ~= nil
end

function M:_BuildCameraOffsetVector(CameraData)
  local Offset = CameraData and CameraData.Offset or nil
  if not Offset then
    return nil
  end
  local Horizontal = Offset.Horizontal or 0
  local Vertical = Offset.Vertical or 0
  if 0 == Horizontal and 0 == Vertical then
    return nil
  end
  return FVector(0, Horizontal, Vertical)
end

function M:_BuildCameraDistanceVector(CameraRotation, Distance)
  if not Distance or 0 == Distance then
    return nil
  end
  local ForwardVector = UE4.UKismetMathLibrary.GetForwardVector(CameraRotation or FRotator(0, 0, 0))
  return ForwardVector * Distance
end

function M:_BuildWorldCameraOffset(CameraRotation, CameraOffset)
  if not CameraOffset then
    return nil
  end
  local Horizontal = CameraOffset.Y or 0
  local Vertical = CameraOffset.Z or 0
  if 0 == Horizontal and 0 == Vertical then
    return CameraOffset
  end
  local RightVector = UE4.UKismetMathLibrary.GetRightVector(CameraRotation or FRotator(0, 0, 0))
  local UpVector = UE4.UKismetMathLibrary.GetUpVector(CameraRotation or FRotator(0, 0, 0))
  return RightVector * Horizontal + UpVector * Vertical
end

function M:_BuildWorldTransformFromRelative(RootTransform, RelativeLocation, RelativeRotation)
  if not RootTransform then
    return RelativeLocation, RelativeRotation
  end
  local WorldLocation = RelativeLocation and UE4.UKismetMathLibrary.TransformLocation(RootTransform, RelativeLocation) or nil
  local WorldRotation = RelativeRotation and UE4.UKismetMathLibrary.TransformRotation(RootTransform, RelativeRotation) or nil
  return WorldLocation, WorldRotation
end

function M:_ResolveSceneId(SceneSpec, Draft, FallbackSceneId)
  local SceneData = SceneSpec and SceneSpec.Scene or nil
  local DraftScene = Draft and Draft.Scene or nil
  return SceneData and SceneData.SceneId or DraftScene and DraftScene.SceneId or FallbackSceneId or DisplayConfig:GetDefaultSceneId()
end

function M:GetCameraRigLocalTransform()
  if self.PreviewCameraRuntime and self.PreviewCameraRuntime.GetRelativeTransform then
    local CameraTransform = self.PreviewCameraRuntime:GetRelativeTransform()
    if CameraTransform then
      self.CurrentCameraRigLocalPosition = CameraTransform.Translation or self.CurrentCameraRigLocalPosition or FVector(0, 0, 0)
      self.CurrentCameraRigLocalRotation = CameraTransform.Rotation and CameraTransform.Rotation:ToRotator() or self.CurrentCameraRigLocalRotation or FRotator(0, 0, 0)
    end
  end
  return self.CurrentCameraRigLocalPosition or FVector(0, 0, 0), self.CurrentCameraRigLocalRotation or FRotator(0, 0, 0)
end

function M:ClampCameraRigLocalTransform(LocalPosition, LocalRotation, LimitConfig)
  LocalPosition = LocalPosition or FVector(0, 0, 0)
  LocalRotation = LocalRotation or FRotator(0, 0, 0)
  if type(LimitConfig) ~= "table" then
    return LocalPosition, LocalRotation
  end
  local ClampedPosition = FVector(LocalPosition.X or 0, LocalPosition.Y or 0, LocalPosition.Z or 0)
  local ClampedRotation = FRotator(LocalRotation.Pitch or 0, LocalRotation.Yaw or 0, LocalRotation.Roll or 0)
  if LimitConfig.DistanceMin ~= nil then
    ClampedPosition.X = math.max(LimitConfig.DistanceMin, ClampedPosition.X)
  end
  if nil ~= LimitConfig.DistanceMax then
    ClampedPosition.X = math.min(LimitConfig.DistanceMax, ClampedPosition.X)
  end
  if nil ~= LimitConfig.HorizontalMin then
    ClampedPosition.Y = math.max(LimitConfig.HorizontalMin, ClampedPosition.Y)
  end
  if nil ~= LimitConfig.HorizontalMax then
    ClampedPosition.Y = math.min(LimitConfig.HorizontalMax, ClampedPosition.Y)
  end
  if nil ~= LimitConfig.VerticalMin then
    ClampedPosition.Z = math.max(LimitConfig.VerticalMin, ClampedPosition.Z)
  end
  if nil ~= LimitConfig.VerticalMax then
    ClampedPosition.Z = math.min(LimitConfig.VerticalMax, ClampedPosition.Z)
  end
  if nil ~= LimitConfig.PitchMin then
    ClampedRotation.Pitch = math.max(LimitConfig.PitchMin, ClampedRotation.Pitch)
  end
  if nil ~= LimitConfig.PitchMax then
    ClampedRotation.Pitch = math.min(LimitConfig.PitchMax, ClampedRotation.Pitch)
  end
  if nil ~= LimitConfig.YawMin then
    ClampedRotation.Yaw = math.max(LimitConfig.YawMin, ClampedRotation.Yaw)
  end
  if nil ~= LimitConfig.YawMax then
    ClampedRotation.Yaw = math.min(LimitConfig.YawMax, ClampedRotation.Yaw)
  end
  return ClampedPosition, ClampedRotation
end

function M:SyncCameraRigToArmoryHelper(LocalPosition, LocalRotation)
  if not self.PreviewCameraRuntime then
    return false
  end
  return self.PreviewCameraRuntime:SetRelativeTransform(LocalPosition or FVector(0, 0, 0), LocalRotation or FRotator(0, 0, 0))
end

function M:SetCameraRigLocalTransform(LocalPosition, LocalRotation, bSyncToHelper)
  LocalPosition = LocalPosition or FVector(0, 0, 0)
  LocalRotation = LocalRotation or FRotator(0, 0, 0)
  LocalPosition, LocalRotation = self:ClampCameraRigLocalTransform(LocalPosition, LocalRotation, self:GetCameraLimitConfig())
  self.CurrentCameraRigLocalPosition = LocalPosition
  self.CurrentCameraRigLocalRotation = LocalRotation
  if false == bSyncToHelper then
    return true
  end
  return self:SyncCameraRigToArmoryHelper(LocalPosition, LocalRotation)
end

function M:_BuildLocalCameraTransformFromDraft(CameraData)
  if not CameraData then
    return self:GetCameraRigLocalTransform()
  end
  if CameraData.LocalPosition or CameraData.LocalRotation then
    local LocalPositionData = CameraData.LocalPosition or {}
    local LocalRotationData = CameraData.LocalRotation or {}
    return FVector(LocalPositionData.X or 0, LocalPositionData.Y or 0, LocalPositionData.Z or 0), FRotator(LocalRotationData.Pitch or 0, LocalRotationData.Yaw or 0, LocalRotationData.Roll or 0)
  end
  return FVector(CameraData.Distance or 0, CameraData.Offset and CameraData.Offset.Horizontal or 0, CameraData.Offset and CameraData.Offset.Vertical or 0), FRotator(CameraData.Rotation and CameraData.Rotation.Pitch or 0, CameraData.Rotation and CameraData.Rotation.Yaw or 0, 0)
end

function M:_ApplyDraftCameraB(CameraData)
  if not self.PreviewCameraRuntime then
    return false
  end
  if CameraData and CameraData.ServerPosition and CameraData.ServerRotation then
    local RelativeLocation = FVector(CameraData.ServerPosition[1] or 0, CameraData.ServerPosition[2] or 0, CameraData.ServerPosition[3] or 0)
    local RelativeRotation = FRotator(CameraData.ServerRotation[2] or 0, CameraData.ServerRotation[3] or 0, CameraData.ServerRotation[1] or 0)
    return self:SetCameraRigLocalTransform(RelativeLocation, RelativeRotation, true)
  end
  local LocalPosition, LocalRotation = self:_BuildLocalCameraTransformFromDraft(CameraData)
  return self:SetCameraRigLocalTransform(LocalPosition, LocalRotation, true)
end

function M:_ApplySceneInitialCameraB(SceneId, CameraData)
  if not self.PreviewCameraRuntime then
    return false
  end
  if CameraData and CameraData.HasCustomCamera then
    return false
  end
  local SceneCameraTransform = DisplayConfig:GetSceneInitialCameraTransform(SceneId)
  if not SceneCameraTransform then
    return false
  end
  local SceneLocation = SceneCameraTransform.Location or FVector(0, 0, 0)
  local SceneRotation = SceneCameraTransform.Rotation or FRotator(0, 0, 0)
  return self:SetCameraRigLocalTransform(SceneLocation, SceneRotation, true)
end

function M:_PanCameraByRotationB(PitchDelta, YawDelta)
  if (not PitchDelta or 0 == PitchDelta) and (not YawDelta or 0 == YawDelta) then
    return false
  end
  local LocalPosition, LocalRotation = self:GetCameraRigLocalTransform()
  LocalRotation = FRotator((LocalRotation.Pitch or 0) + (PitchDelta or 0), (LocalRotation.Yaw or 0) + (YawDelta or 0), LocalRotation.Roll or 0)
  return self:SetCameraRigLocalTransform(LocalPosition, LocalRotation, true)
end

function M:_PanCameraByOffsetB(CameraOffset)
  if not CameraOffset then
    return false
  end
  local LocalPosition, LocalRotation = self:GetCameraRigLocalTransform()
  LocalPosition = FVector(LocalPosition.X or 0, (LocalPosition.Y or 0) + (CameraOffset.Y or 0), (LocalPosition.Z or 0) + (CameraOffset.Z or 0))
  return self:SetCameraRigLocalTransform(LocalPosition, LocalRotation, true)
end

function M:_PanCameraByDistanceB(DistanceDelta)
  if not DistanceDelta or 0 == DistanceDelta then
    return false
  end
  local LocalPosition, LocalRotation = self:GetCameraRigLocalTransform()
  LocalPosition = FVector((LocalPosition.X or 0) + DistanceDelta, LocalPosition.Y or 0, LocalPosition.Z or 0)
  return self:SetCameraRigLocalTransform(LocalPosition, LocalRotation, true)
end

function M:GetCameraLimitConfig()
  local Draft = self.Editor and self.Editor.GetDraft and self.Editor:GetDraft() or nil
  return Draft and Draft.Camera and Draft.Camera.LimitConfig or nil
end

function M:ApplyDraftCamera(CameraData)
  return self:_ApplyDraftCameraB(CameraData)
end

function M:ApplySceneInitialCamera(SceneId, CameraData)
  return self:_ApplySceneInitialCameraB(SceneId, CameraData)
end

function M:PanCameraByRotation(PitchDelta, YawDelta)
  return self:_PanCameraByRotationB(PitchDelta, YawDelta)
end

function M:PanCameraByOffset(CameraOffset)
  return self:_PanCameraByOffsetB(CameraOffset)
end

function M:PanCameraByDistance(DistanceDelta)
  return self:_PanCameraByDistanceB(DistanceDelta)
end

return M
