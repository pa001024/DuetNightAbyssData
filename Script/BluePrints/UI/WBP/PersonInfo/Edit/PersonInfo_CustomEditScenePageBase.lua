require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:InitScenePage(EditRootController)
  self:ApplyScenePageContext(EditRootController)
  self.SceneItemContents = {}
  self.SceneEntryWidgetMap = {}
  self.IsBindingFinished = false
  self:BindSceneListEvents()
end

function M:ApplyScenePageContext(EditRootController)
  self.EditRootController = EditRootController
end

function M:RefreshView()
  if not self.EditRootController then
    return
  end
  self.SceneItemContents = {}
  self.SceneEntryWidgetMap = {}
  self.List_Scence:ClearListItems()
  local SceneViewList = self.EditRootController:BuildSceneSlotViewList()
  for _, SceneViewData in ipairs(SceneViewList) do
    local Content = self:_BuildSceneItemContent(SceneViewData)
    self.SceneItemContents[#self.SceneItemContents + 1] = Content
    self.List_Scence:AddItem(Content)
  end
end

function M:RefreshSelectedSceneState(SceneId, UsedSceneId)
  self:_ApplySceneSelectionLocally(SceneId, UsedSceneId)
end

function M:OnClickSceneItem(SceneId)
  if self.EditRootController then
    self.EditRootController:SetSelectedSceneId(SceneId, true)
  end
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
  self:OnClickSceneItem(Content.SceneId)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.Handle_ScenePageGamepadKeyDown and self:Handle_ScenePageGamepadKeyDown(InKeyName) then
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

return M
