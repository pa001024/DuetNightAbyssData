require("UnLua")
local UIUtils = require("Utils.UIUtils")
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = PersonInfoController:GetModel()
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local DEFAULT_SCENE_LIGHT_EDIT_DATA = {
  Roll = 0,
  Pitch = 0,
  Yaw = 0,
  LightIntensity = 0
}
local SCENE_LIGHT_SLIDER_CONFIG_MAP = {
  LightIntensity = {
    Title = "",
    Field = "LightIntensity",
    Min = 0,
    Max = 1,
    DecimalPlaces = 1
  },
  Roll = {
    TitleKey = "UI_PersonalPage_LightAxis_X",
    Field = "Roll",
    Min = -80,
    Max = 80,
    ValueSuffix = "°"
  },
  Pitch = {
    TitleKey = "UI_PersonalPage_LightAxis_Y",
    Field = "Pitch",
    Min = -80,
    Max = 80,
    ValueSuffix = "°"
  },
  Yaw = {
    TitleKey = "UI_PersonalPage_LightAxis_Z",
    Field = "Yaw",
    Min = -80,
    Max = 80,
    ValueSuffix = "°"
  }
}
local SCENE_LIGHT_SLIDER_ORDER = {
  "Roll",
  "Pitch",
  "Yaw",
  "LightIntensity"
}

local function GetScenePageRootView(Owner)
  return Owner.EditRootController and (Owner.EditRootController.RootViewPanel or Owner.EditRootController.OwnerWidget) or nil
end

function M:_HasWidgetFocus(Widget)
  if not Widget then
    return false
  end
  return (not Widget.HasAnyUserFocus or not Widget:HasAnyUserFocus()) and (not Widget.HasFocusedDescendants or not Widget:HasFocusedDescendants()) and Widget.HasAnyFocus and Widget:HasAnyFocus()
end

function M:_GetSceneLightSliderOrder()
  return SCENE_LIGHT_SLIDER_ORDER
end

function M:_GetSceneLightSliderConfig(AxisName)
  local BaseConfig = SCENE_LIGHT_SLIDER_CONFIG_MAP[AxisName]
  if not BaseConfig then
    return nil
  end
  local SliderConfig = {}
  for Key, Value in pairs(BaseConfig) do
    SliderConfig[Key] = Value
  end
  SliderConfig.Title = BaseConfig.TitleKey and GText(BaseConfig.TitleKey) or ""
  local Range = DisplayConfig:GetSceneLightRange(self.CurrentSceneId, AxisName)
  if Range then
    SliderConfig.Min = Range.Min
    SliderConfig.Max = Range.Max
  end
  return SliderConfig
end

function M:Construct()
  self:_BindSceneTipsEvents()
end

function M:InitScenePage(EditRootController)
  self:ApplyScenePageContext(EditRootController)
  self.SceneLightSliderWidgetMap = {
    LightIntensity = self.EditModel_SliderItem_LightPower1,
    Roll = self.EditModel_SliderItem_LightAngle_1,
    Pitch = self.EditModel_SliderItem_LightAngle_2,
    Yaw = self.EditModel_SliderItem_LightAngle_3
  }
  assert(self.SceneLightSliderWidgetMap.LightIntensity, "场景编辑页缺少 LightPower1")
  assert(self.SceneLightSliderWidgetMap.Roll, "场景编辑页缺少 LightAngle_1")
  assert(self.SceneLightSliderWidgetMap.Pitch, "场景编辑页缺少 LightAngle_2")
  assert(self.SceneLightSliderWidgetMap.Yaw, "场景编辑页缺少 LightAngle_3")
  self.SceneItemContents = {}
  self.SceneEntryWidgetMap = {}
  self.SceneLightEditDataMap = {}
  self.CurrentSceneLightEditData = nil
  self.IsBindingFinished = false
  self._SceneTipsRestoreFocusWidget = nil
  self._bSceneTipsOpened = false
  self._bScenePageDestructing = false
  self:BindSceneListEvents()
  self:_InitSceneLightSliders()
  self:_InitSceneTipsWidget()
  self:_BindSceneTipsEvents()
end

function M:Destruct()
  if self._CancelSceneTipsGamepadLongPress then
    self:_CancelSceneTipsGamepadLongPress()
  end
  self._bScenePageDestructing = true
  self._SceneTipsRestoreFocusWidget = nil
  self._bSceneTipsOpened = false
  if self.ItemDetails_MenuAnchor and self.ItemDetails_MenuAnchor.SetLastFocusWidget then
    self.ItemDetails_MenuAnchor:SetLastFocusWidget(nil)
  end
  self:_HideSceneTips()
  self:_UnBindSceneTipsEvents()
  self:_UnBindSceneTipsMenuOpenChanged()
  self.EditRootController = nil
  self.SceneItemContents = nil
  self.SceneEntryWidgetMap = nil
end

function M:ApplyScenePageContext(EditRootController)
  self.EditRootController = EditRootController
end

function M:RefreshView()
  if not self.EditRootController then
    return
  end
  self:_BindSceneTipsEvents()
  self.SceneItemContents = {}
  self.SceneEntryWidgetMap = {}
  self.List_Scence:ClearListItems()
  local SceneViewList = self.EditRootController:BuildSceneSlotViewList()
  local SelectedSceneViewData
  for _, SceneViewData in ipairs(SceneViewList) do
    local Content = self:_BuildSceneItemContent(SceneViewData)
    self.SceneItemContents[#self.SceneItemContents + 1] = Content
    self.List_Scence:AddItem(Content)
    if SceneViewData.IsSelected == true then
      SelectedSceneViewData = SceneViewData
    end
  end
  self:_RefreshSceneDetail(SelectedSceneViewData)
  if self.Change_List then
    self:PlayAnimation(self.Change_List)
  end
end

function M:RefreshSelectedSceneState(SceneId, UsedSceneId)
  self:_ApplySceneSelectionLocally(SceneId, UsedSceneId)
  self:_RefreshSceneDetail(self:_FindSceneViewData(SceneId))
  self:_PreviewCurrentSceneLight()
end

function M:OnClickSceneItem(SceneId)
  if self.EditRootController then
    return self.EditRootController:SetSelectedSceneId(SceneId, true) == true
  end
  return false
end

function M:OnSceneItemClicked(Content)
  self:OnSceneEntryClicked(Content, nil)
end

function M:OnSceneItemSelectionChanged(Content, IsSelected)
end

function M:OnSceneEntryInitialized(Content, EntryWidget)
end

function M:RegisterSceneEntry(EntryWidget, Content)
  if not (EntryWidget and Content) or not Content.SceneId then
    return
  end
  self.SceneEntryWidgetMap[Content.SceneId] = EntryWidget
end

function M:UnregisterSceneEntry(EntryWidget, Content)
  local SceneId = Content and Content.SceneId or nil
  if not SceneId then
    return
  end
  if self.SceneEntryWidgetMap[SceneId] == EntryWidget then
    self.SceneEntryWidgetMap[SceneId] = nil
  end
end

function M:_ApplySceneSelectionLocally(SelectedSceneId, UsedSceneId)
  local PreviousSelectedSceneId, PreviousSelectedContent, PreviousUsedSceneId, PreviousUsedContent, SelectedContent, UsedContent
  local ResolvedUsedSceneId = UsedSceneId or self:_GetCurrentUsedSceneId()
  for _, Content in ipairs(self.SceneItemContents or {}) do
    if Content.IsSelected == true then
      PreviousSelectedSceneId = Content.SceneId
      PreviousSelectedContent = Content
    end
    if true == Content.IsUsed then
      PreviousUsedSceneId = Content.SceneId
      PreviousUsedContent = Content
    end
    Content.IsSelected = Content.SceneId == SelectedSceneId
    Content.IsUsed = Content.SceneId == ResolvedUsedSceneId
    if Content.SceneId == SelectedSceneId then
      SelectedContent = Content
    end
    if Content.SceneId == ResolvedUsedSceneId then
      UsedContent = Content
    end
  end
  local PreviousEntryWidget = PreviousSelectedSceneId and self.SceneEntryWidgetMap and self.SceneEntryWidgetMap[PreviousSelectedSceneId] or nil
  if PreviousSelectedSceneId ~= SelectedSceneId and PreviousEntryWidget and PreviousSelectedContent then
    PreviousSelectedContent.IsSelected = false
    if PreviousEntryWidget.PlaySceneSelectNormal then
      PreviousEntryWidget:PlaySceneSelectNormal()
    end
  end
  local PreviousUsedEntryWidget = PreviousUsedSceneId and self.SceneEntryWidgetMap and self.SceneEntryWidgetMap[PreviousUsedSceneId] or nil
  if PreviousSelectedSceneId ~= SelectedSceneId then
    local SelectedEntryWidget = self.SceneEntryWidgetMap and self.SceneEntryWidgetMap[SelectedSceneId] or nil
    if SelectedEntryWidget and SelectedContent then
      SelectedContent.IsSelected = true
      if SelectedEntryWidget.PlaySceneSelectClick then
        SelectedEntryWidget:PlaySceneSelectClick()
      end
    end
  end
  if PreviousUsedSceneId ~= ResolvedUsedSceneId then
    if PreviousUsedEntryWidget and PreviousUsedContent then
      PreviousUsedContent.IsUsed = false
      if PreviousUsedEntryWidget.PlaySceneUsedClear then
        PreviousUsedEntryWidget:PlaySceneUsedClear()
      end
    end
    local UsedEntryWidget = ResolvedUsedSceneId and self.SceneEntryWidgetMap and self.SceneEntryWidgetMap[ResolvedUsedSceneId] or nil
    if UsedEntryWidget and UsedContent then
      UsedContent.IsUsed = true
      if UsedEntryWidget.PlaySceneUsedApply then
        UsedEntryWidget:PlaySceneUsedApply()
      end
    end
  end
end

function M:OnSceneEntryClicked(Content, EntryWidget)
  if not Content or not Content.SceneId then
    return
  end
  self:_TryCloseSceneTips()
  if Content.IsNew == true then
    UIUtils.TrySubReddotCacheDetailNumber(Content.SceneId, "PersonalInfoScene")
    Content.IsNew = false
    if EntryWidget and EntryWidget.SetSceneNewState then
      EntryWidget:SetSceneNewState(false)
    end
    if self.EditRootController and self.EditRootController.RootViewPanel then
      self.EditRootController.RootViewPanel:RefreshSceneTabReddot()
    end
  end
  local UsedSceneId = self:_GetCurrentUsedSceneId()
  if true == Content.IsUnlocked then
    UsedSceneId = Content.SceneId
  end
  self:_ApplySceneSelectionLocally(Content.SceneId, UsedSceneId)
  local bSceneChanged = self:OnClickSceneItem(Content.SceneId)
  self:_RefreshSceneDetail(Content)
  if bSceneChanged then
    self:_PreviewCurrentSceneLight()
  end
end

function M:OnBeginTransformSliderDrag(AxisName)
  local DisplayEditor = self.EditRootController and self.EditRootController.DisplayEditor or nil
  if DisplayEditor and DisplayEditor.BeginPreviewTransaction then
    DisplayEditor:BeginPreviewTransaction("SceneLight")
  end
end

function M:OnTransformSliderValueChanged(AxisName, Value)
  local SliderConfig = self:_GetSceneLightSliderConfig(AxisName)
  if not SliderConfig or not self.CurrentSceneLightEditData then
    return
  end
  local MinValue = SliderConfig.Min or 0
  local MaxValue = SliderConfig.Max or 1
  self.CurrentSceneLightEditData[SliderConfig.Field] = MinValue + (MaxValue - MinValue) * (Value or 0)
  self.CurrentSceneLightEditData.HasUserLight = true
  if self.EditRootController and self.EditRootController.UpdateSceneLightData then
    self.EditRootController:UpdateSceneLightData(self.CurrentSceneLightEditData)
  end
  DebugPrint(string.format("PersonInfoSceneLight: slider changed axis=%s sliderValue=%s businessValue=%s", tostring(AxisName), tostring(Value), tostring(self.CurrentSceneLightEditData[SliderConfig.Field])))
  self:_RefreshSceneLightSlider(AxisName)
  self:_PreviewCurrentSceneLight()
end

function M:OnEndTransformSliderDrag(AxisName)
  local DisplayEditor = self.EditRootController and self.EditRootController.DisplayEditor or nil
  if DisplayEditor and DisplayEditor.CommitPreviewTransaction then
    DisplayEditor:CommitPreviewTransaction()
  end
  if self.EditRootController and self.EditRootController.RootViewPanel then
    self.EditRootController.RootViewPanel:RefreshSceneResetButtonState()
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bIsRepeat = UE4.UKismetInputLibrary.InputEvent_IsRepeat(InKeyEvent)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == UIConst.GamePadKey.SpecialRight and self.Handle_ScenePageGamepadKeyDown and self:Handle_ScenePageGamepadKeyDown(InKeyName, bIsRepeat) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bIsRepeat = UE4.UKismetInputLibrary.InputEvent_IsRepeat(InKeyEvent)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.Handle_ScenePageGamepadKeyDown and self:Handle_ScenePageGamepadKeyDown(InKeyName, bIsRepeat) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:BindSceneListEvents()
  if self.IsBindingFinished then
    return
  end
  self.List_Scence.BP_OnItemClicked:Clear()
  self.List_Scence.BP_OnItemClicked:Add(self, self.OnSceneItemClicked)
  self.List_Scence.BP_OnItemSelectionChanged:Clear()
  self.List_Scence.BP_OnItemSelectionChanged:Add(self, self.OnSceneItemSelectionChanged)
  self.IsBindingFinished = true
end

function M:_BuildSceneItemContent(SceneViewData)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.SceneId = SceneViewData.SceneId
  Content.Name = SceneViewData.Name
  Content.Icon = SceneViewData.Icon
  Content.IsSelected = SceneViewData.IsSelected
  Content.IsUsed = SceneViewData.IsUsed == true
  Content.IsUnlocked = true == SceneViewData.IsUnlocked
  Content.IsLocked = true == SceneViewData.IsLocked
  Content.IsNew = true == SceneViewData.IsNew
  Content.OwnerPage = self
  return Content
end

function M:_GetCurrentUsedSceneId()
  if self.EditRootController and self.EditRootController._GetUsedSceneId then
    return self.EditRootController:_GetUsedSceneId()
  end
  return nil
end

function M:_RefreshSceneEntryWidget(EntryWidget, Content)
  if not EntryWidget or not Content then
    return
  end
  EntryWidget.Content = Content
  EntryWidget:RefreshEntry()
end

function M:_InitSceneLightSliders()
  self.SceneLightSliderWidgetMap.LightIntensity:InitSliderItem(self, "LightIntensity")
  self.SceneLightSliderWidgetMap.Roll:InitSliderItem(self, "Roll")
  self.SceneLightSliderWidgetMap.Pitch:InitSliderItem(self, "Pitch")
  self.SceneLightSliderWidgetMap.Yaw:InitSliderItem(self, "Yaw")
end

function M:_RefreshSceneDetail(SceneViewData)
  if not SceneViewData then
    self.CurrentSceneLightEditData = nil
    return
  end
  self.Group_Lock:SetVisibility(SceneViewData.IsLocked == true and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  if self.Text_ScenceLock then
    self.Text_ScenceLock:SetText(GText("UI_PersonalPage_SceneLocked"))
  end
  self.CurrentSceneId = SceneViewData.SceneId
  self.Text_ScenceName:SetText(SceneViewData.Name or "")
  self.Text_TitleLight:SetText(GText("UI_PersonalPage_LightIntensity"))
  self.Text_TitleFreeLight:SetText(GText("UI_PersonalPage_LightDirection"))
  self.CurrentSceneLightEditData = self:_GetOrCreateSceneLightEditData(SceneViewData.SceneId)
  self:_RefreshSceneLightSlider("LightIntensity")
  self:_RefreshSceneLightSlider("Roll")
  self:_RefreshSceneLightSlider("Pitch")
  self:_RefreshSceneLightSlider("Yaw")
end

function M:_RefreshSceneLightSlider(AxisName)
  local SliderConfig = self:_GetSceneLightSliderConfig(AxisName)
  local SliderWidget = self:_GetSceneLightSliderWidget(AxisName)
  if not (SliderConfig and SliderWidget) or not self.CurrentSceneLightEditData then
    return
  end
  SliderWidget:RefreshSliderPresentation(SliderConfig, self.CurrentSceneLightEditData[SliderConfig.Field] or 0)
  local CurrentValue = self.CurrentSceneLightEditData[SliderConfig.Field] or 0
  local DecimalPlaces = SliderConfig.DecimalPlaces or 0
  local DisplayValue = CurrentValue
  local Format = "%." .. tostring(DecimalPlaces) .. "f"
  if 0 == DecimalPlaces then
    DisplayValue = CurrentValue >= 0 and math.floor(CurrentValue + 0.5) or math.ceil(CurrentValue - 0.5)
    Format = "%d"
  end
  SliderWidget.Text_Num:SetText(string.format(Format, DisplayValue) .. (SliderConfig.ValueSuffix or ""))
end

function M:_PreviewCurrentSceneLight()
  if not self.EditRootController or not self.CurrentSceneLightEditData then
    return
  end
  if self.CurrentSceneLightEditData.HasUserLight == true then
    self.EditRootController:PreviewSceneLight(self.CurrentSceneLightEditData)
    return
  end
  local DisplayEditor = self.EditRootController.DisplayEditor
  local Draft = DisplayEditor and DisplayEditor.GetDraft and DisplayEditor:GetDraft() or nil
  local LightParam = Draft and Draft.Scene and Draft.Scene.LightParam or nil
  if type(LightParam) == "table" and self.EditRootController.PreviewSceneLight then
    self.EditRootController:PreviewSceneLight(LightParam)
    return
  end
  self.EditRootController:ClearSceneLightPreview()
end

function M:_GetOrCreateSceneLightEditData(SceneId)
  local LightEditData = self.SceneLightEditDataMap[SceneId]
  if LightEditData then
    return LightEditData
  end
  local SavedLightData = self.EditRootController:ReadSceneLightEditData(SceneId)
  local InitialLightData = DisplayConfig:GetSceneLightInitialParams(SceneId)
  LightEditData = {
    Roll = SavedLightData and SavedLightData.Roll or InitialLightData and InitialLightData.Roll or DEFAULT_SCENE_LIGHT_EDIT_DATA.Roll,
    Pitch = SavedLightData and SavedLightData.Pitch or InitialLightData and InitialLightData.Pitch or DEFAULT_SCENE_LIGHT_EDIT_DATA.Pitch,
    Yaw = SavedLightData and SavedLightData.Yaw or InitialLightData and InitialLightData.Yaw or DEFAULT_SCENE_LIGHT_EDIT_DATA.Yaw,
    LightIntensity = SavedLightData and SavedLightData.LightIntensity or InitialLightData and InitialLightData.LightIntensity or DEFAULT_SCENE_LIGHT_EDIT_DATA.LightIntensity,
    HasUserLight = nil ~= SavedLightData
  }
  self.SceneLightEditDataMap[SceneId] = LightEditData
  return LightEditData
end

function M:RefreshSceneLightFromDraft(SceneId, bRefreshUI)
  if not SceneId or not self.SceneLightEditDataMap then
    return
  end
  self.SceneLightEditDataMap[SceneId] = nil
  if false ~= bRefreshUI then
    self:_RefreshSceneDetail(self:_FindSceneViewData(SceneId))
  end
end

function M:_FindSceneViewData(SceneId)
  for _, Content in ipairs(self.SceneItemContents or {}) do
    if Content.SceneId == SceneId then
      return Content
    end
  end
  return nil
end

function M:_GetSceneLightSliderWidget(AxisName)
  return self.SceneLightSliderWidgetMap[AxisName]
end

function M:_IsSceneLightAtDefault()
  if not self.CurrentSceneLightEditData then
    return true
  end
  local InitialLightData = DisplayConfig:GetSceneLightInitialParams(self.CurrentSceneId)
  local DefaultRef = InitialLightData or DEFAULT_SCENE_LIGHT_EDIT_DATA
  return (self.CurrentSceneLightEditData.Roll or 0) == (DefaultRef.Roll or 0) and (self.CurrentSceneLightEditData.Pitch or 0) == (DefaultRef.Pitch or 0) and (self.CurrentSceneLightEditData.Yaw or 0) == (DefaultRef.Yaw or 0) and (self.CurrentSceneLightEditData.LightIntensity or 0) == (DefaultRef.LightIntensity or 0)
end

function M:ResetSceneLightToDefault()
  if not self.CurrentSceneLightEditData then
    return false
  end
  if self:_IsSceneLightAtDefault() then
    return false
  end
  local InitialLightData = DisplayConfig:GetSceneLightInitialParams(self.CurrentSceneId)
  local DefaultRef = InitialLightData or DEFAULT_SCENE_LIGHT_EDIT_DATA
  self.CurrentSceneLightEditData.Roll = DefaultRef.Roll or 0
  self.CurrentSceneLightEditData.Pitch = DefaultRef.Pitch or 0
  self.CurrentSceneLightEditData.Yaw = DefaultRef.Yaw or 0
  self.CurrentSceneLightEditData.LightIntensity = DefaultRef.LightIntensity or 0
  self.CurrentSceneLightEditData.HasUserLight = false
  if self.EditRootController and self.EditRootController.UpdateSceneLightData then
    self.EditRootController:UpdateSceneLightData(self.CurrentSceneLightEditData)
  end
  self:_RefreshSceneLightSlider("LightIntensity")
  self:_RefreshSceneLightSlider("Roll")
  self:_RefreshSceneLightSlider("Pitch")
  self:_RefreshSceneLightSlider("Yaw")
  self:_PreviewCurrentSceneLight()
  return true
end

function M:_InitSceneTipsWidget()
  if not self.ItemDetails_MenuAnchor then
    return
  end
  if self.ItemDetails_MenuAnchor.SetAllowHover then
    self.ItemDetails_MenuAnchor:SetAllowHover(false)
  end
  self:_BindSceneTipsMenuOpenChanged()
end

function M:IsSceneTipsOpened()
  if self._bSceneTipsOpened == true then
    return true
  end
  return self.ItemDetails_MenuAnchor ~= nil and nil ~= self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor and true == self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen()
end

function M:_BindSceneTipsMenuOpenChanged()
  if self._bSceneTipsMenuOpenBound then
    return
  end
  if not self.ItemDetails_MenuAnchor or not self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor then
    return
  end
  self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self._OnSceneTipsMenuOpenChanged)
  self._bSceneTipsMenuOpenBound = true
end

function M:_UnBindSceneTipsMenuOpenChanged()
  if not self._bSceneTipsMenuOpenBound then
    return
  end
  if self.ItemDetails_MenuAnchor and self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor then
    self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self, self._OnSceneTipsMenuOpenChanged)
  end
  self._bSceneTipsMenuOpenBound = false
end

function M:_OnSceneTipsMenuOpenChanged(bIsOpen)
  self._bSceneTipsOpened = true == bIsOpen
  local RootView = GetScenePageRootView(self)
  if RootView then
    if bIsOpen then
      RootView.bIgnoreSceneTipsMenuHold = RootView.GamepadPressedKeyMap and true == RootView.GamepadPressedKeyMap[UIConst.GamePadKey.SpecialRight]
    else
      RootView.bIgnoreSceneTipsMenuHold = false
    end
  end
  if self.EditRootController and self.EditRootController.RefreshPreviewCameraRoamState then
    self.EditRootController:RefreshPreviewCameraRoamState()
  end
  self:_NotifyRootSceneTipsStateChanged()
  if not bIsOpen then
    self:_RestoreSceneTipsFocusAndCursor()
  end
end

function M:_BindSceneTipsEvents()
  if not self.Btn_Check then
    return
  end
  if self.Btn_Check.BindSingleEventOnClicked then
    self.Btn_Check:BindSingleEventOnClicked(self, self.OnClickSceneTipsCheck)
    return
  end
  if self.Btn_Check.BindEventOnClicked then
    self.Btn_Check:UnBindEventOnClickedByObj(self)
    self.Btn_Check:BindEventOnClicked(self, self.OnClickSceneTipsCheck)
  end
end

function M:_UnBindSceneTipsEvents()
  if not self.Btn_Check or not self.Btn_Check.UnBindEventOnClickedByObj then
    return
  end
  self.Btn_Check:UnBindEventOnClickedByObj(self)
end

function M:OnClickSceneTipsCheck()
  if self:IsSceneTipsOpened() then
    self:_TryCloseSceneTips()
    return
  end
  self:ShowSceneTips()
end

function M:ShowSceneTips()
  self:_InitSceneTipsWidget()
  if not self.ItemDetails_MenuAnchor then
    return
  end
  local SceneId
  if self.EditRootController and self.EditRootController._GetCurrentSceneId then
    SceneId = self.EditRootController:_GetCurrentSceneId()
  end
  local SceneViewData = self:_FindSceneViewData(SceneId)
  if not (SceneId and DataMgr.CustomScene) or not DataMgr.CustomScene[SceneId] then
    return
  end
  local bUnlocked = SceneViewData and SceneViewData.IsUnlocked == true
  if nil == SceneViewData then
    bUnlocked = true == PersonInfoModel:HasOwnedCustomDisplayScene(SceneId)
  end
  local Content = {
    ItemType = "CustomScene",
    ItemId = SceneId,
    IsUnlocked = bUnlocked,
    IsShowDetails = true,
    UIName = "PersonalEdit",
    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
    bNotFocus = true,
    HandleKeyDown = true,
    OverrideDetailsBackObj = self,
    OverrideDetailsBackEvent = self._TryCloseSceneTips,
    KeyDownEvent = {
      Obj = self,
      Callback = self._OnSceneTipsGamepadKeyDown
    }
  }
  local RestoreWidget = self:_GetSceneTipsRestoreFocusWidget()
  self._SceneTipsRestoreFocusWidget = RestoreWidget
  if self.ItemDetails_MenuAnchor.SetLastFocusWidget then
    self.ItemDetails_MenuAnchor:SetLastFocusWidget(RestoreWidget)
  end
  self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
end

function M:_GetSceneTipsRestoreFocusWidget()
  for _, AxisName in ipairs(SCENE_LIGHT_SLIDER_ORDER) do
    local SliderItem = self:_GetSceneLightSliderWidget(AxisName)
    if self:_HasWidgetFocus(SliderItem) then
      return SliderItem
    end
  end
  if self.SceneEntryWidgetMap then
    for _, EntryWidget in pairs(self.SceneEntryWidgetMap) do
      local FocusWidget = EntryWidget and EntryWidget.Btn_Area or EntryWidget
      if self:_HasWidgetFocus(EntryWidget) or self:_HasWidgetFocus(FocusWidget) then
        return FocusWidget
      end
    end
  end
  if self:_HasWidgetFocus(self.Btn_Check) then
    return self.Btn_Check
  end
  local RootView = GetScenePageRootView(self)
  if RootView then
    if self:_HasWidgetFocus(RootView.Btn_Save) then
      return RootView.Btn_Save
    end
    if self:_HasWidgetFocus(RootView.Com_Tab) then
      return RootView.Com_Tab
    end
  end
  return self:_GetSelectedSceneEntryFocusWidget()
end

function M:_GetSelectedSceneEntryFocusWidget()
  local SelectedContent
  if self.List_Scence and self.List_Scence.BP_GetSelectedItem then
    SelectedContent = self.List_Scence:BP_GetSelectedItem()
  end
  if not SelectedContent then
    for _, Content in ipairs(self.SceneItemContents or {}) do
      if Content.IsSelected == true then
        SelectedContent = Content
        break
      end
    end
  end
  if not SelectedContent then
    return nil
  end
  local EntryWidget = self.SceneEntryWidgetMap and self.SceneEntryWidgetMap[SelectedContent.SceneId] or nil
  return EntryWidget and EntryWidget.Btn_Area or EntryWidget
end

function M:_RestoreSceneTipsFocusAndCursor()
  local RestoreWidget = self._SceneTipsRestoreFocusWidget
  self._SceneTipsRestoreFocusWidget = nil
  if self._bScenePageDestructing then
    return
  end
  if RestoreWidget and IsValid(RestoreWidget) and RestoreWidget.SetFocus then
    RestoreWidget:SetFocus()
  elseif self._FocusSelectedSceneItem then
    self:_FocusSelectedSceneItem(false)
  else
    local FallbackWidget = self:_GetSelectedSceneEntryFocusWidget()
    if FallbackWidget and FallbackWidget.SetFocus then
      FallbackWidget:SetFocus()
    end
  end
  local RootView = GetScenePageRootView(self)
  local Subsystem = RootView and RootView.GameInputModeSubsystem or self.GameInputModeSubsystem
  if Subsystem and Subsystem.UpdateCurrentFocusWidgetPos then
    Subsystem:UpdateCurrentFocusWidgetPos()
  end
end

function M:_TryCloseSceneTips()
  if not self:IsSceneTipsOpened() then
    return false
  end
  self:_HideSceneTips()
  return true
end

function M:_HideSceneTips()
  local bMenuOpen = self:IsSceneTipsOpened()
  if self.ItemDetails_MenuAnchor and self.ItemDetails_MenuAnchor.CloseItemDetailsWidget then
    self.ItemDetails_MenuAnchor:CloseItemDetailsWidget(true)
  end
  if bMenuOpen then
    return
  end
  self._bSceneTipsOpened = false
  local RootView = GetScenePageRootView(self)
  if RootView then
    RootView.bIgnoreSceneTipsMenuHold = false
  end
  if self.EditRootController and self.EditRootController.RefreshPreviewCameraRoamState then
    self.EditRootController:RefreshPreviewCameraRoamState()
  end
  self:_NotifyRootSceneTipsStateChanged()
  self:_RestoreSceneTipsFocusAndCursor()
end

function M:_NotifyRootSceneTipsStateChanged()
  local RootView = GetScenePageRootView(self)
  if not RootView then
    return
  end
  RootView.BottomKeyPlanIndex = nil
  if RootView._RefreshBottomKeyInfo then
    RootView:_RefreshBottomKeyInfo()
  end
  if RootView.RefreshCustomEditGamepadPageState then
    RootView:RefreshCustomEditGamepadPageState()
  end
end

function M:_OnSceneTipsGamepadKeyDown(MyGeometry, InKeyEvent, Params)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled(), false
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local RootView = GetScenePageRootView(self)
  if InKeyName == UIConst.GamePadKey.SpecialRight and RootView and RootView.bIgnoreSceneTipsMenuHold then
    return UE4.UWidgetBlueprintLibrary.Handled(), true
  end
  self:_TryCloseSceneTips()
  return UE4.UWidgetBlueprintLibrary.Handled(), true
end

return M
