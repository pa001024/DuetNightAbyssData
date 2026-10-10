local Component = {}
Component.CharacterEditPanelBPPathMap = {
  P = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_EditModel_P.WBP_PersonalInfo_EditModel_P'",
  M = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Mobile/WBP_PersonalInfo_EditModel_M.WBP_PersonalInfo_EditModel_M'"
}
Component.ChoosePageBPPathMap = {
  P = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_EditChoose_P.WBP_PersonalInfo_EditChoose_P'",
  M = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Mobile/WBP_PersonalInfo_EditChoose_M.WBP_PersonalInfo_EditChoose_M'"
}
Component.ScenePageBPPathMap = {
  P = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_EditScence_P.WBP_PersonalInfo_EditScence_P'",
  M = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Mobile/WBP_PersonalInfo_EditScence_M.WBP_PersonalInfo_EditScence_M'"
}
Component.OtherPageBPPathMap = {
  P = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_EditOther_P.WBP_PersonalInfo_EditOther_P'",
  M = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Mobile/WBP_PersonalInfo_EditOther_M.WBP_PersonalInfo_EditOther_M'"
}

function Component:EnsureActiveEditSubPageCreated(EditRootController)
  if EditRootController.ActiveSubPageName == "Choose" then
    self:EnsureChoosePageCreated(EditRootController)
    return
  end
  if EditRootController.ActiveSubPageName == "Scene" then
    self:EnsureScenePageCreated(EditRootController)
    return
  end
  if EditRootController.ActiveSubPageName == "Other" or EditRootController.ActiveSubPageName == "StickerEdit" then
    self:EnsureOtherPageCreated(EditRootController)
    return
  end
  if EditRootController.ActiveSubPageName == "PetMain" then
    if EditRootController.ShouldShowPetDetailPanel and EditRootController:ShouldShowPetDetailPanel() then
      self:EnsureCharacterEditPanelCreated(EditRootController)
    end
    return
  end
  self:EnsureCharacterEditPanelCreated(EditRootController)
end

function Component:EnsureCharacterEditPanelCreated(EditRootController)
  if self:_IsPanelWidgetAlive(EditRootController.CharacterEditPanel) then
    EditRootController.CharacterEditPanel.RootEditPage = EditRootController
    return EditRootController.CharacterEditPanel
  end
  local Panel = UIManager(self):CreateWidget(self:_GetPlatformBPPath(Component.CharacterEditPanelBPPathMap, EditRootController))
  EditRootController.CharacterEditPanel = Panel
  self:_AttachPanelToHost(self.Content, Panel)
  Panel:InitCharacterEditPanel(EditRootController)
  return Panel
end

function Component:EnsureChoosePageCreated(EditRootController)
  if self:_IsPanelWidgetAlive(EditRootController.ChoosePagePanel) then
    EditRootController.ChoosePagePanel:ApplyChoosePageContext(EditRootController, EditRootController.ActiveChooseMode, EditRootController:BuildChoosePageViewData())
    return EditRootController.ChoosePagePanel
  end
  local Panel = UIManager(self):CreateWidget(self:_GetPlatformBPPath(Component.ChoosePageBPPathMap, EditRootController))
  EditRootController.ChoosePagePanel = Panel
  self:_AttachPanelToHost(self.Content, Panel)
  return Panel
end

function Component:EnsureScenePageCreated(EditRootController)
  if self:_IsPanelWidgetAlive(EditRootController.ScenePagePanel) then
    EditRootController.ScenePagePanel.EditRootController = EditRootController
    return EditRootController.ScenePagePanel
  end
  local Panel = UIManager(self):CreateWidget(self:_GetPlatformBPPath(Component.ScenePageBPPathMap, EditRootController))
  EditRootController.ScenePagePanel = Panel
  self:_AttachPanelToHost(self.Content, Panel)
  Panel:InitScenePage(EditRootController)
  return Panel
end

function Component:EnsureOtherPageCreated(EditRootController)
  if self:_IsPanelWidgetAlive(EditRootController.OtherPagePanel) then
    EditRootController.OtherPagePanel.EditRootController = EditRootController
    return EditRootController.OtherPagePanel
  end
  local Panel = UIManager(self):CreateWidget(self:_GetPlatformBPPath(Component.OtherPageBPPathMap, EditRootController))
  EditRootController.OtherPagePanel = Panel
  self:_AttachPanelToHost(self.Content, Panel)
  Panel:InitOtherPage(EditRootController)
  return Panel
end

function Component:RefreshEditSubPageVisibility(EditRootController)
  if EditRootController.CharacterEditPanel ~= nil then
    local bShowDetail = false
    if EditRootController.ShouldShowEditDetailPanel then
      bShowDetail = EditRootController:ShouldShowEditDetailPanel() == true
    else
      bShowDetail = true == EditRootController:ShouldShowCharacterDetailPanel()
    end
    self:_SetPanelVisibility(EditRootController.CharacterEditPanel, bShowDetail)
  end
  if nil ~= EditRootController.ChoosePagePanel then
    local ChoosePagePanel = self:_ResolvePanelWidget(EditRootController.ChoosePagePanel)
    local bVisible = EditRootController.ActiveSubPageName == "Choose"
    self:_SetPanelVisibility(EditRootController.ChoosePagePanel, bVisible)
    if ChoosePagePanel and not bVisible then
      ChoosePagePanel:RefreshChoosePageClickMaskState(false)
    end
  end
  if nil ~= EditRootController.ScenePagePanel then
    local ScenePagePanel = self:_ResolvePanelWidget(EditRootController.ScenePagePanel)
    local bVisible = EditRootController.ActiveSubPageName == "Scene"
    self:_SetPanelVisibility(EditRootController.ScenePagePanel, bVisible)
    if ScenePagePanel and not bVisible then
      if ScenePagePanel._CancelSceneTipsGamepadLongPress then
        ScenePagePanel:_CancelSceneTipsGamepadLongPress()
      end
      if ScenePagePanel._TryCloseSceneTips then
        ScenePagePanel:_TryCloseSceneTips()
      end
    end
  end
  if nil ~= EditRootController.OtherPagePanel then
    self:_SetPanelVisibility(EditRootController.OtherPagePanel, EditRootController.ActiveSubPageName == "Other")
  end
end

function Component:RemoveAllEditSubPages(EditRootController)
  local RootViewPanel = EditRootController and (EditRootController.RootViewPanel or EditRootController.OwnerWidget) or nil
  if RootViewPanel and RootViewPanel.HideStickerEditWidget then
    RootViewPanel:HideStickerEditWidget()
  end
  self:_RemovePanel(EditRootController.ScenePagePanel)
  self:_RemovePanel(EditRootController.OtherPagePanel)
  self:_RemovePanel(EditRootController.ChoosePagePanel)
  self:_RemovePanel(EditRootController.CharacterEditPanel)
  if EditRootController then
    EditRootController.ScenePagePanel = nil
    EditRootController.OtherPagePanel = nil
    EditRootController.ChoosePagePanel = nil
    EditRootController.CharacterEditPanel = nil
  end
end

function Component:_GetPlatformBPPath(PathMap, EditRootController)
  local PlatformKey = self:_GetPlatformKey(EditRootController)
  return PathMap[PlatformKey] or PathMap.P
end

function Component:_GetPlatformKey(EditRootController)
  local RootViewPanel = EditRootController and (EditRootController.RootViewPanel or EditRootController.OwnerWidget) or nil
  if RootViewPanel and RootViewPanel.WBP_Camera_Roll_M ~= nil then
    return "M"
  end
  return "P"
end

function Component:_AttachPanelToHost(HostContent, Panel)
  HostContent:AddChildToOverlay(Panel)
  local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Panel)
  OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
end

function Component:_RemovePanel(Panel)
  Panel = self:_ResolvePanelWidget(Panel)
  if Panel then
    Panel:RemoveFromParent()
  end
end

function Component:_SetPanelVisibility(Panel, bVisible)
  Panel = self:_ResolvePanelWidget(Panel)
  if not Panel then
    return
  end
  local Visibility = bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  Panel:SetVisibility(Visibility)
end

function Component:_ResolvePanelWidget(Panel)
  if not Panel then
    return nil
  end
  if Panel.SetVisibility then
    return IsValid(Panel) and Panel or nil
  end
  if Panel.Widget and Panel.Widget.SetVisibility then
    return IsValid(Panel.Widget) and Panel.Widget or nil
  end
  if Panel.View and Panel.View.SetVisibility then
    return IsValid(Panel.View) and Panel.View or nil
  end
  if Panel.Root and Panel.Root.SetVisibility then
    return IsValid(Panel.Root) and Panel.Root or nil
  end
  return nil
end

function Component:_IsPanelWidgetAlive(Panel)
  return self:_ResolvePanelWidget(Panel) ~= nil
end

return Component
