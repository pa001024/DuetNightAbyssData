require("UnLua")
local UIUtils = require("Utils.UIUtils")
local MiscUtils = require("Utils.MiscUtils")
local GREY_TITLE_FONT_MATERIAL_PATH = "MaterialInstanceConstant'/Game/UI/WBP/Common/VX/Common/MI_Com_TagWord_Grey.MI_Com_TagWord_Grey'"
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local StickerPreviewHost = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditStickerPreviewHost")
StickerPreviewHost.BindMethods(M)
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditPageHostComponent"
}
M.MainTabNameList = {
  [1] = "Char",
  [2] = "Pet",
  [3] = "Item",
  [4] = "Scene",
  [5] = "Other"
}
M.MainTabConfigList = {
  [1] = {
    Name = "Char",
    TextKey = "UI_Armory_Char",
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Personal_Avatar",
    TabId = 1
  },
  [2] = {
    Name = "Pet",
    TextKey = "UI_Pet",
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Pet",
    TabId = 2
  },
  [3] = {
    Name = "Item",
    TextKey = "UI_PersonInfo_CustomItem",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Personal_Object.T_Tab_Personal_Object'",
    TabId = 3
  },
  [4] = {
    Name = "Scene",
    TextKey = "UI_PersonalPage_Scene",
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Personal_Scence",
    TabId = 4
  },
  [5] = {
    Name = "Other",
    TextKey = "UI_PersonalPage_Others",
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_System",
    TabId = 5
  }
}

function M:InitMainPage(EditRootController)
  self.EditRootController = EditRootController
  self.bHiddenUI = self.bHiddenUI == true
  self.IsBindingFinished = false
  self.IsRefreshingMainTabSelection = false
  self.MainTabSelectedIndex = nil
  self.BottomKeyPlanIndex = nil
  self.CharacterSlotItemContents = {}
  self.CharacterSlotEntryWidgetMap = {}
  self.SlotListChangeAnimToken = 0
  self.PendingSlotListChangeAnim = nil
  self.IsHudBubbleInitialized = false
  self.IsAddCharacterBubbleShowing = false
  self.IsChangePetBubbleInitialized = false
  self.IsAddPetBubbleShowing = false
  self.SideBtnIndex = nil
  self.bCharacterSlotSwitchGamepadKeyInitialized = false
  self.StickersEditWidget = nil
  self.bStickerEditActive = false
  self._bStickerEditTabSingleMode = false
  self.ConfirmedStickerWidget = nil
  self:BindRootPageEvents()
  if self.Com_HudBubble then
    self.Com_HudBubble:PlayHorizontalLoopAnimation()
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.In)
end

function M:BindRootPageEvents()
  if self.IsBindingFinished then
    return
  end
  self:_InitMainTab()
  self:_BindCommonActionButtons()
  self:_InitCommonButtonText()
  self:_BindCharacterSlotListEvents()
  self:_BindSceneTabReddot()
  self.IsBindingFinished = true
end

function M:RefreshView()
  if not self.EditRootController then
    return
  end
  self:_EnsureMainTabConfigCurrent()
  self:_EnsureCharacterSlotListInitialized()
  self:RefreshTabState()
  self:RefreshSlotAreaState()
  self:RefreshCommonActionState()
  self:RefreshTitleText()
  if self.bHiddenUI then
    self:PlayAnimation("HideUi")
  end
end

function M:RefreshTabState()
  if not self.EditRootController then
    return
  end
  local bIsChoosePage = self.EditRootController:IsChoosePageActive()
  local bIsStickerEditPage = self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive()
  local bShowTab = not bIsChoosePage
  self:SetRootTabVisibility(bShowTab)
  if bShowTab and not bIsStickerEditPage then
    self:_RefreshMainTabSelection()
  end
  self:_ApplyStickerEditTabMode(true == bIsStickerEditPage)
  self:RefreshSceneTabReddot()
end

function M:RefreshSlotAreaState()
  if not self.EditRootController then
    return
  end
  local bShowSlots = self.EditRootController:ShouldShowSlotArea()
  if self.EditRootController:IsScenePageActive() and self.List_Model and UIConst.VisibilityOp.Hidden then
    self.List_Model:SetVisibility(UIConst.VisibilityOp.Hidden)
  else
    self:SetRootSlotAreaVisibility(bShowSlots)
  end
  if not bShowSlots then
    return
  end
  if self.EditRootController:ShouldShowItemSlotArea() then
    self:_RefreshItemSlotList()
  elseif self.EditRootController:IsPetPageActive() then
    self:_RefreshPetSlotList()
  else
    self:_RefreshCharacterSlotList()
  end
end

function M:RefreshCommonActionState()
  if not self.EditRootController then
    return
  end
  local bIsStickerEditPage = self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive() == true
  if self.WS_Title then
    self:_SetWidgetVisibility(self.WS_Title, true)
  end
  if bIsStickerEditPage then
    self:_ApplyStickerEditActionButtons()
    self:_RefreshTitleConfirmButtonState()
    self:_RefreshBottomKeyInfo()
    if self.RefreshCustomEditGamepadPageState then
      self:RefreshCustomEditGamepadPageState()
    end
    return
  end
  local bIsChooseConfirmMode = self.EditRootController:IsChooseConfirmMode()
  local bShowSaveButton = true
  local bCanSave
  if bIsChooseConfirmMode then
    bCanSave = self.EditRootController:CanConfirmChoosePage()
  else
    bCanSave = self.EditRootController:CanSaveEdit()
  end
  self:_SetButtonVisibility(self.Btn_Save, bShowSaveButton)
  self:_SetButtonEnabled(self.Btn_Save, bCanSave and not self.EditRootController:IsSavingEdit())
  self:_RefreshSideBtnState(self:_ResolveSideBtnIndex())
  self:_RefreshCommonButtonText()
  self:_RefreshTitleConfirmButtonState()
  self:RefreshSceneResetButtonState()
  self:_RefreshCommonTitleState()
  self:_RefreshCommonInfoState()
  self:_RefreshAddCharacterBubbleState()
  self:_RefreshBottomKeyInfo()
  if self.RefreshCustomEditGamepadPageState then
    self:RefreshCustomEditGamepadPageState()
  end
end

function M:_ApplyStickerEditActionButtons()
  if self.WS_Title then
    self.WS_Title:SetActiveWidgetIndex(1)
  end
  self:_RefreshSideBtnState(3)
  self:_SetButtonVisibility(self.Btn_Save, true)
  self:_SetButtonEnabled(self.Btn_Save, true)
  if self.Btn_Save and self.Btn_Save.SetText then
    self.Btn_Save:SetText(GText("UI_PATCH_ENSURE"))
  end
  self:RefreshStickerResetButtonState()
end

function M:_ResolveSideBtnIndex()
  if not self.EditRootController then
    return nil
  end
  if self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive() == true then
    return 3
  end
  if self.EditRootController:IsChoosePageActive() then
    return nil
  end
  local ActiveMainTabName = self.EditRootController:GetActiveMainTabName()
  if "Scene" == ActiveMainTabName then
    return 3
  end
  if "Pet" == ActiveMainTabName then
    return 1
  end
  if "Item" == ActiveMainTabName then
    return 2
  end
  if "Char" == ActiveMainTabName then
    return 0
  end
  return nil
end

function M:_RefreshSideBtnState(SideBtnIndex)
  self.SideBtnIndex = SideBtnIndex
  if not self.WS_SideBtn then
    return
  end
  if nil == SideBtnIndex then
    self:_SetWidgetVisibility(self.WS_SideBtn, false)
    return
  end
  self:_SetWidgetVisibility(self.WS_SideBtn, true)
  self.WS_SideBtn:SetActiveWidgetIndex(SideBtnIndex)
end

function M:RefreshSaveButtonState()
  if not self.EditRootController then
    return
  end
  if self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive() then
    self:_SetButtonVisibility(self.Btn_Save, true)
    self:_SetButtonEnabled(self.Btn_Save, true)
    if self.Btn_Save and self.Btn_Save.SetText then
      self.Btn_Save:SetText(GText("UI_PATCH_ENSURE"))
    end
    self:_RefreshTitleConfirmButtonState()
    return
  end
  local bIsChooseConfirmMode = self.EditRootController:IsChooseConfirmMode()
  local bCanSave
  if bIsChooseConfirmMode then
    bCanSave = self.EditRootController:CanConfirmChoosePage()
  else
    bCanSave = self.EditRootController:CanSaveEdit()
  end
  self:_SetButtonVisibility(self.Btn_Save, true)
  self:_SetButtonEnabled(self.Btn_Save, bCanSave and not self.EditRootController:IsSavingEdit())
  self:_RefreshTitleConfirmButtonState()
end

function M:OnTabItemSelected(TabWidget, TabData)
  if self.IsRefreshingMainTabSelection then
    return
  end
  local TabName = TabData and TabData.Name or nil
  if not TabName and TabWidget then
    TabName = TabWidget.Name or TabWidget.TabName
  end
  if TabName then
    self:OnClickMainTab(TabName)
  end
end

function M:OnClickMainTab(TabName)
  self.EditRootController:SetActiveMainTab(TabName)
end

function M:OnClickSave()
  DebugPrint("[PersonInfoSaveTrace][MainPage.OnClickSave]\n" .. tostring(UBattleFunctionLibrary.GetTraceStack(30)))
  if self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive() then
    if self.EditRootController.ConfirmStickerEditAndReturn then
      self.EditRootController:ConfirmStickerEditAndReturn()
    end
    return
  end
  if self.EditRootController:IsChooseConfirmMode() then
    self.EditRootController.ChoosePagePanel:OnClickConfirmChoose()
    return
  end
  self.EditRootController:SaveEditAndClose()
end

function M:OnClickSaveForbidden()
  if self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive() then
    return
  end
  if self.EditRootController:IsChooseConfirmMode() then
    local ChoosePagePanel = self.EditRootController.ChoosePagePanel
    if ChoosePagePanel and ChoosePagePanel.OnClickConfirmChooseForbidden then
      ChoosePagePanel:OnClickConfirmChooseForbidden()
    end
    return
  end
  if self.EditRootController:IsSavingEdit() then
    return
  end
  if not self.EditRootController:CanSaveEdit() then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonalPage_NoChanges"))
  end
end

function M:OnClickStickerEditReset()
  if not (self.EditRootController and self.EditRootController.IsStickerEditPageActive) or not self.EditRootController:IsStickerEditPageActive() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  if self.EditRootController.ResetStickerEdit then
    self.EditRootController:ResetStickerEdit()
  end
  self:RefreshStickerResetButtonState()
end

function M:OnClickStickerEditResetForbidden()
  if not (self.EditRootController and self.EditRootController.IsStickerEditPageActive) or not self.EditRootController:IsStickerEditPageActive() then
    return
  end
  UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonalPage_RestoredDefault"))
end

function M:OnStickerEditTransformChanged()
  self:RefreshStickerResetButtonState()
  self:RefreshSaveButtonState()
end

function M:RefreshStickerResetButtonState()
  if not self.Btn_Reset then
    return
  end
  if not (self.EditRootController and self.EditRootController.IsStickerEditPageActive) or not self.EditRootController:IsStickerEditPageActive() then
    return
  end
  local bAtDefault = true
  if self.EditRootController.IsStickerEditAtDefaultTransform then
    bAtDefault = self.EditRootController:IsStickerEditAtDefaultTransform()
  end
  self:_SetButtonEnabled(self.Btn_Reset, not bAtDefault)
end

function M:OnClickResetButton()
  if self.EditRootController and self.EditRootController.IsScenePageActive and self.EditRootController:IsScenePageActive() then
    self:OnClickSceneEditReset()
    return
  end
  self:OnClickStickerEditReset()
end

function M:OnClickResetButtonForbidden()
  if self.EditRootController and self.EditRootController.IsScenePageActive and self.EditRootController:IsScenePageActive() then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonalPage_NoLightAdjust"))
    return
  end
  self:OnClickStickerEditResetForbidden()
end

function M:OnClickSceneEditReset()
  if not self.EditRootController or not self.EditRootController.ScenePagePanel then
    return
  end
  local ScenePagePanel = self.EditRootController.ScenePagePanel
  if not ScenePagePanel.ResetSceneLightToDefault then
    return
  end
  local bReset = ScenePagePanel:ResetSceneLightToDefault()
  if not bReset then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonalPage_ResetDefault"))
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  self:RefreshSceneResetButtonState()
end

function M:RefreshSceneResetButtonState()
  if not self.Btn_Reset then
    return
  end
  if not (self.EditRootController and self.EditRootController.IsScenePageActive) or not self.EditRootController:IsScenePageActive() then
    return
  end
  local bAtDefault = true
  local ScenePagePanel = self.EditRootController.ScenePagePanel
  if ScenePagePanel and ScenePagePanel._IsSceneLightAtDefault then
    bAtDefault = ScenePagePanel:_IsSceneLightAtDefault()
  end
  self:_SetButtonEnabled(self.Btn_Reset, not bAtDefault)
end

function M:OnClickAdd()
  if self.EditRootController:IsItemMainPageActive() then
    self.EditRootController:OpenItemChoosePage()
    return
  end
  self.EditRootController:OpenCharacterChoosePage()
end

function M:OnClickChangePet()
  if not self.EditRootController then
    return
  end
  self.EditRootController:OpenPetChoosePage()
end

function M:SetRootTabVisibility(bVisible)
  local Visibility = bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  self.Com_Tab:SetVisibility(Visibility)
end

function M:SetRootSlotAreaVisibility(bVisible)
  local Visibility = bVisible and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed
  self.List_Model:SetVisibility(Visibility)
end

function M:RefreshTitleText()
  local TitleViewData
  if self.EditRootController and self.EditRootController.IsChoosePageActive and self.EditRootController:IsChoosePageActive() and self.EditRootController.BuildChoosePreviewTitleViewData then
    local SelectedContent
    local ChoosePagePanel = self.EditRootController.ChoosePagePanel
    if ChoosePagePanel and ChoosePagePanel.GetSelectedContent then
      SelectedContent = ChoosePagePanel:GetSelectedContent()
    end
    TitleViewData = self.EditRootController:BuildChoosePreviewTitleViewData(SelectedContent)
  else
    TitleViewData = self.EditRootController:BuildEditTitleViewData()
  end
  self:_RefreshEditTitleCard(TitleViewData)
end

function M:RefreshSelectedCharacterSlotContext()
  if self.EditRootController and self.EditRootController:ShouldShowItemSlotArea() then
    self:_ApplyCharacterSlotSelectionLocally(self.EditRootController:GetSelectedItemSlotIndex())
  elseif self.EditRootController and self.EditRootController:IsPetPageActive() then
    self:_ApplyCharacterSlotSelectionLocally(self.EditRootController:GetSelectedPetSlotIndex())
  else
    self:_RefreshCharacterSlotSelection()
  end
  if self.RefreshCustomEditGamepadPageState then
    self:RefreshCustomEditGamepadPageState()
  end
end

function M:_InitMainTab()
  local Tabs = {}
  for Index, TabConfig in ipairs(M.MainTabConfigList) do
    Tabs[Index] = {
      Text = TabConfig.TextKey and GText(TabConfig.TextKey) or TabConfig.Text or "",
      IconPath = TabConfig.IconPath,
      Name = TabConfig.Name,
      TabId = TabConfig.TabId
    }
  end
  local TabConfigData = {
    TitleName = GText("UI_PersonalPage_Customize"),
    LeftKey = "Q",
    RightKey = "E",
    StyleName = "TextImage",
    Tabs = Tabs,
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BottomKeyInfo = self:_BuildBottomKeyInfo(),
    OwnerPanel = self,
    BackCallback = self.OnReturnKeyDown
  }
  self.Com_Tab:Init(TabConfigData)
  self.Com_Tab:BindEventOnTabSelected(self, self.OnTabItemSelected)
end

function M:_EnsureMainTabConfigCurrent()
  local CurrentTabs = self.Com_Tab and self.Com_Tab.Tabs or nil
  if type(CurrentTabs) ~= "table" then
    return
  end
  local bConfigChanged = #CurrentTabs ~= #M.MainTabConfigList
  if not bConfigChanged then
    for TabIndex, TabConfig in ipairs(M.MainTabConfigList) do
      if not CurrentTabs[TabIndex] or CurrentTabs[TabIndex].Name ~= TabConfig.Name then
        bConfigChanged = true
        break
      end
    end
  end
  if not bConfigChanged then
    return
  end
  self.MainTabSelectedIndex = nil
  self.BottomKeyPlanIndex = nil
  self:_InitMainTab()
end

function M:_RefreshMainTabSelection()
  local ActiveTabName = self.EditRootController:GetActiveMainTabName()
  for TabIndex, TabConfig in ipairs(M.MainTabConfigList) do
    if TabConfig.Name == ActiveTabName then
      if self.MainTabSelectedIndex == TabIndex then
        return
      end
      self.IsRefreshingMainTabSelection = true
      self.Com_Tab:SelectTab(TabIndex)
      self.IsRefreshingMainTabSelection = false
      self.MainTabSelectedIndex = TabIndex
      return
    end
  end
end

function M:_BindCommonActionButtons()
  self:_BindButtonClick(self.Btn_Save, self.OnClickSave)
  if self.Btn_Add then
    self:_BindButtonClick(self.Btn_Add, self.OnClickAdd)
  end
  if self.Btn_ChangeSubject then
    self:_BindButtonClick(self.Btn_ChangeSubject, self.OnClickAdd)
  end
  if self.Btn_ChangePet then
    self:_BindButtonClick(self.Btn_ChangePet, self.OnClickChangePet)
  end
  if self.Btn_Reset then
    self:_BindButtonClick(self.Btn_Reset, self.OnClickResetButton)
  end
  local TitleConfirmButton = self:_GetTitleConfirmButton()
  if TitleConfirmButton then
    self:_BindButtonClick(TitleConfirmButton, self.OnClickTitleConfirm)
  end
end

function M:_InitCommonButtonText()
  self.Btn_Save:SetText(GText("UI_PersonalPage_SaveEdit"))
  self.Btn_Save:BindForbidStateExecuteEvent(self, self.OnClickSaveForbidden)
  if self.Btn_Reset and self.Btn_Reset.BindForbidStateExecuteEvent then
    self.Btn_Reset:BindForbidStateExecuteEvent(self, self.OnClickResetButtonForbidden)
  end
  if self.Btn_Save and self.Btn_Save.SetDefaultGamePadImg then
    self.Btn_Save:SetDefaultGamePadImg("Y")
  elseif self.Btn_Save and self.Btn_Save.SetGamePadImg then
    self.Btn_Save:SetGamePadImg("Y")
  end
  self:_InitTitleConfirmButton()
end

function M:_RefreshCommonButtonText()
  if self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive() then
    self.Btn_Save:SetText(GText("UI_PATCH_ENSURE"))
    return
  end
  if self.EditRootController:IsChooseConfirmMode() then
    self.Btn_Save:SetText(GText("UI_PersonalPage_ConfirmSelect"))
  else
    self.Btn_Save:SetText(GText("UI_PersonalPage_SaveEdit"))
  end
end

function M:_GetTitleConfirmButton()
  local TitleCard = self.Edit_Title
  if not TitleCard then
    return nil
  end
  return TitleCard.Btn_Confirm
end

function M:GetActiveCommonConfirmButton()
  if self.EditRootController and self.EditRootController.ShouldUseCharacterInfoSwitcher and self.EditRootController:ShouldUseCharacterInfoSwitcher() then
    local TitleConfirmButton = self:_GetTitleConfirmButton()
    if TitleConfirmButton then
      return TitleConfirmButton
    end
  end
  return self.Btn_Save
end

function M:_InitTitleConfirmButton()
  local TitleConfirmButton = self:_GetTitleConfirmButton()
  if not TitleConfirmButton then
    return
  end
  if TitleConfirmButton.SetText then
    TitleConfirmButton:SetText(GText("UI_PersonalPage_ConfirmSelect"))
  end
  if TitleConfirmButton.BindForbidStateExecuteEvent then
    TitleConfirmButton:BindForbidStateExecuteEvent(self, self.OnClickTitleConfirmForbidden)
  end
  if TitleConfirmButton.SetDefaultGamePadImg then
    TitleConfirmButton:SetDefaultGamePadImg("Y")
  elseif TitleConfirmButton.SetGamePadImg then
    TitleConfirmButton:SetGamePadImg("Y")
  end
end

function M:_RefreshTitleConfirmButtonState()
  local TitleConfirmButton = self:_GetTitleConfirmButton()
  if not TitleConfirmButton then
    return
  end
  local bShowTitleConfirm = self.EditRootController and self.EditRootController.ShouldUseCharacterInfoSwitcher and self.EditRootController:ShouldUseCharacterInfoSwitcher() == true
  local bCanConfirm = bShowTitleConfirm and self.EditRootController.CanConfirmChoosePage and true == self.EditRootController:CanConfirmChoosePage() and not self.EditRootController:IsSavingEdit()
  self:_SetButtonVisibility(TitleConfirmButton, bShowTitleConfirm)
  self:_SetButtonEnabled(TitleConfirmButton, bCanConfirm)
  if TitleConfirmButton.SetText then
    TitleConfirmButton:SetText(GText("UI_PersonalPage_ConfirmSelect"))
  end
end

function M:OnClickTitleConfirm()
  if not self.EditRootController or not self.EditRootController.ChoosePagePanel then
    return
  end
  self.EditRootController.ChoosePagePanel:OnClickConfirmChoose()
end

function M:OnClickTitleConfirmForbidden()
  if not self.EditRootController or not self.EditRootController.ChoosePagePanel then
    return
  end
  if self.EditRootController.ChoosePagePanel.OnClickConfirmChooseForbidden then
    self.EditRootController.ChoosePagePanel:OnClickConfirmChooseForbidden()
  end
end

function M:_RefreshCommonTitleState()
  local ActiveIndex = self.EditRootController:ShouldUseCharacterInfoSwitcher() and 0 or 1
  self.WS_Title:SetActiveWidgetIndex(ActiveIndex)
end

function M:_ApplyStickerEditTabMode(bActive)
  if not self.Com_Tab then
    return
  end
  local AdjustTitle = GText("UI_PersonalPage_AdjustSticker")
  if bActive then
    if type(self.Com_Tab.EnterViewSingleMode) == "function" then
      self.Com_Tab:EnterViewSingleMode(AdjustTitle)
    end
    self._bStickerEditTabSingleMode = true
    if self.Com_Tab.Title_Tab then
      self.Com_Tab.Title_Tab:SetText(AdjustTitle)
    end
    if "function" == type(self.Com_Tab.UpdateTopTitle) then
      self.Com_Tab:UpdateTopTitle(AdjustTitle)
    end
    return
  end
  if (self._bStickerEditTabSingleMode or self.Com_Tab.IsInViewSingleMode) and "function" == type(self.Com_Tab.LeaveViewSingleMode) then
    self.Com_Tab:LeaveViewSingleMode()
  end
  self._bStickerEditTabSingleMode = false
  if "function" == type(self.Com_Tab.UpdateTopTitle) then
    self.Com_Tab:UpdateTopTitle(GText("UI_PersonalPage_Customize"))
  end
end

function M:_RefreshBottomKeyInfo()
  if not self.Com_Tab or type(self.Com_Tab.UpdateBottomKeyInfo) ~= "function" then
    return
  end
  local BottomKeyInfo = self:_BuildBottomKeyInfo()
  local PlanIndex = self:_BuildBottomKeyPlanIndex()
  if self.BottomKeyPlanIndex == PlanIndex then
    return
  end
  self.BottomKeyPlanIndex = PlanIndex
  self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function M:_BindSceneTabReddot()
  ReddotManager.AddListenerEx("PersonalInfoScene", self, self.OnSceneTabReddotChanged)
end

function M:OnSceneTabReddotChanged(Count, RdType)
  self.SceneTabReddotCount = Count or 0
  self.SceneTabReddotType = RdType
  self:RefreshSceneTabReddot()
end

function M:RefreshSceneTabReddot()
  if not self.Com_Tab then
    return
  end
  local Count = self.SceneTabReddotCount or 0
  local RdType = self.SceneTabReddotType
  local bShowNew = Count > 0 and RdType == EReddotType.New
  local bShowNormal = Count > 0 and RdType == EReddotType.Normal
  local bShowGray = Count > 0 and RdType == EReddotType.Gray
  self.Com_Tab:ShowTabRedDotByTabId(4, bShowNew, bShowNormal, bShowGray)
end

function M:OnReturnKeyDown()
  if not self.EditRootController then
    return
  end
  if self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive() then
    self.EditRootController:CloseStickerEditAndReturn()
    return
  end
  self.EditRootController:RequestCloseEdit()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if not self.EditRootController then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bIsControlDown = UE4.UKismetInputLibrary.InputEvent_IsControlDown(InKeyEvent)
  local bIsStickerEditPage = self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive() == true
  local bCanHandleMainPageShortcut = not self.EditRootController:IsChoosePageActive() and not bIsStickerEditPage
  if not bCanHandleMainPageShortcut and self.EditRootController:IsChoosePageActive() then
    local ChoosePagePanel = self.EditRootController.ChoosePagePanel
    if ChoosePagePanel and ChoosePagePanel.Handle_ChoosePageForwardedKeyDown and ChoosePagePanel:Handle_ChoosePageForwardedKeyDown(InKeyName) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  if bIsStickerEditPage and "U" == InKeyName then
    self:OnHideUIClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if bCanHandleMainPageShortcut and self.OnCameraRoamKeyDown and self:OnCameraRoamKeyDown(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if bCanHandleMainPageShortcut and bIsControlDown and "Z" == InKeyName then
    self:OnClickUndo()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if bCanHandleMainPageShortcut and bIsControlDown and "Y" == InKeyName then
    self:OnClickRedo()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if bCanHandleMainPageShortcut and "R" == InKeyName then
    self:OnClickResetCamera()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if bCanHandleMainPageShortcut and "U" == InKeyName then
    self:OnHideUIClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if bCanHandleMainPageShortcut and "Q" == InKeyName then
    self:_SwitchMainTabByOffset(-1)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if bCanHandleMainPageShortcut and "E" == InKeyName then
    self:_SwitchMainTabByOffset(1)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if "Escape" == InKeyName then
    if self.EditRootController:IsChoosePageActive() then
      self.EditRootController:CloseChoosePageAndReturn()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if bIsStickerEditPage then
      self.EditRootController:CloseStickerEditAndReturn()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    self:OnReturnKeyDown()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:_BuildBottomKeyInfo()
  if self.EditRootController and self.EditRootController:IsChoosePageActive() then
    return {}
  end
  if self.EditRootController and self.EditRootController.IsSceneTipsOpened and self.EditRootController:IsSceneTipsOpened() then
    return {}
  end
  if self.EditRootController and self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive() then
    return {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "U",
            ClickCallback = self.OnHideUIClick,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.RightThumb,
            ClickCallback = self.OnHideUIClick,
            Owner = self
          }
        },
        Desc = GText("UI_Dye_HideUI")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
  end
  local BottomKeyInfo = {
    {
      KeyInfoList = {
        {Type = "Or"},
        SubKeyInfoList = {
          {
            Type = "Text",
            Text = "W",
            Owner = self
          },
          {
            Type = "Text",
            Text = "A",
            Owner = self
          },
          {
            Type = "Text",
            Text = "S",
            Owner = self
          },
          {
            Type = "Text",
            Text = "D",
            Owner = self
          }
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "Direction",
          Owner = self
        }
      },
      Desc = GText("UI_PersonalPage_MoveCamera")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "MouseScroll",
          Owner = self
        }
      },
      GamePadInfoList = {
        {Type = "Or"},
        GamePadSubKeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "LT",
            Owner = self
          },
          {
            Type = "Img",
            ImgShortPath = "RT",
            Owner = self
          }
        }
      },
      Desc = GText("UI_Dye_Zoom")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "RightMouseButton",
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "RH",
          Owner = self
        }
      },
      Desc = GText("UI_PersonalPage_AdjustView")
    },
    {
      KeyInfoList = {
        {Type = "Add"},
        SubKeyInfoList = {
          {
            Type = "Text",
            Text = "LeftControl",
            ClickCallback = self.OnClickUndo,
            Owner = self
          },
          {
            Type = "Text",
            Text = "Z",
            ClickCallback = self.OnClickUndo,
            Owner = self
          }
        }
      },
      GamePadInfoList = {
        {Type = "Add"},
        GamePadSubKeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.SpecialLeft,
            ClickCallback = self.OnClickUndo,
            Owner = self
          },
          {
            Type = "Img",
            ImgShortPath = "X",
            ClickCallback = self.OnClickUndo,
            Owner = self
          }
        }
      },
      Desc = GText("UI_PersonalPage_Undo")
    },
    {
      KeyInfoList = {
        {Type = "Add"},
        SubKeyInfoList = {
          {
            Type = "Text",
            Text = "LeftControl",
            ClickCallback = self.OnClickRedo,
            Owner = self
          },
          {
            Type = "Text",
            Text = "Y",
            ClickCallback = self.OnClickRedo,
            Owner = self
          }
        }
      },
      GamePadInfoList = {
        {Type = "Add"},
        GamePadSubKeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.SpecialLeft,
            ClickCallback = self.OnClickRedo,
            Owner = self
          },
          {
            Type = "Img",
            ImgShortPath = "Y",
            ClickCallback = self.OnClickRedo,
            Owner = self
          }
        }
      },
      Desc = GText("UI_PersonalPage_Redo")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "R",
          ClickCallback = self.OnClickResetCamera,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "LS",
          ClickCallback = self.OnClickResetCamera,
          Owner = self
        }
      },
      Desc = GText("UI_PersonalPage_ResetCamera")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "U",
          ClickCallback = self.OnHideUIClick,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightThumb,
          ClickCallback = self.OnHideUIClick,
          Owner = self
        }
      },
      Desc = GText("UI_Dye_HideUI")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  return BottomKeyInfo
end

function M:_BuildBottomKeyPlanIndex()
  local ActiveTabName = self.EditRootController and self.EditRootController:GetActiveMainTabName() or "None"
  local bIsChoosePageActive = self.EditRootController and self.EditRootController:IsChoosePageActive() == true
  local bIsStickerEditPageActive = self.EditRootController and self.EditRootController.IsStickerEditPageActive and true == self.EditRootController:IsStickerEditPageActive()
  local bIsHiddenUI = true == self.bHiddenUI
  local bIsSceneTipsOpened = self.EditRootController and self.EditRootController.IsSceneTipsOpened and true == self.EditRootController:IsSceneTipsOpened()
  return string.format("%s|%s|%s|%s|%s", tostring(ActiveTabName), tostring(bIsChoosePageActive), tostring(bIsStickerEditPageActive), tostring(bIsHiddenUI), tostring(bIsSceneTipsOpened))
end

function M:OnClickUndo()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  self.EditRootController:UndoEdit()
end

function M:OnClickRedo()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  self.EditRootController:RedoEdit()
end

function M:OnClickResetCamera()
  local _, bEnabled = self.EditRootController:GetMobileResetCameraState()
  if not bEnabled then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonalPage_DefaultCamera"))
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  if self.EditRootController:ResetCameraToSceneDefault() then
    self:RefreshCommonActionState()
  end
end

function M:OnHideUIClick()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  if self.bHiddenUI then
    self:PlayAnimation(self.ShowUi)
  else
    self:PlayAnimation(self.HideUi)
  end
  self.bHiddenUI = not self.bHiddenUI
  self.bIsCustomEditUIHidden = self.bHiddenUI
  if self.CurInputDeviceType == ECommonInputType.Gamepad and self.GameInputModeSubsystem and self.GameInputModeSubsystem.SetNavigateWidgetOpacity then
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(self.bHiddenUI and 0 or 1)
  end
end

function M:_GetCurrentMainTabIndex()
  if not self.EditRootController then
    return 1
  end
  local ActiveTabName = self.EditRootController:GetActiveMainTabName()
  for TabIndex, TabConfig in ipairs(M.MainTabConfigList) do
    if TabConfig.Name == ActiveTabName then
      return TabIndex
    end
  end
  return 1
end

function M:_SwitchMainTabByOffset(Offset)
  if not self.EditRootController then
    return
  end
  local TabCount = #M.MainTabConfigList
  if TabCount <= 0 then
    return
  end
  local CurrentIndex = self:_GetCurrentMainTabIndex()
  local TargetIndex = CurrentIndex + Offset
  if TargetIndex < 1 or TabCount < TargetIndex then
    return
  end
  local TabConfig = M.MainTabConfigList[TargetIndex]
  if TabConfig then
    self:OnClickMainTab(TabConfig.Name)
  end
end

function M:_BindButtonClick(ButtonWidget, Callback)
  ButtonWidget:UnBindEventOnClickedByObj(self)
  ButtonWidget:BindEventOnClicked(self, Callback)
end

function M:TriggerCommonButtonClick(ButtonWidget)
  if not ButtonWidget then
    return false
  end
  ButtonWidget:OnBtnPressed()
  ButtonWidget:OnBtnClicked()
  return true
end

function M:_SetWidgetVisibility(Widget, bVisible)
  local Visibility = bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  Widget:SetVisibility(Visibility)
end

function M:_SetButtonVisibility(ButtonWidget, bVisible)
  self:_SetWidgetVisibility(ButtonWidget, bVisible)
end

function M:_SetButtonEnabled(ButtonWidget, bEnabled)
  ButtonWidget:ForbidBtn(not bEnabled)
end

function M:_RefreshCharacterSlotList()
  self:_CancelPendingSlotListChangeAnimation()
  local SlotViewList = self.EditRootController:BuildCharacterSlotViewList()
  self.CharacterSlotItemContents = {}
  self.CharacterSlotEntryWidgetMap = {}
  self.List_Model:ClearListItems()
  for SlotIndex, SlotViewData in ipairs(SlotViewList) do
    local Content = self:_BuildCharacterSlotItemContent(SlotViewData, SlotIndex)
    self.CharacterSlotItemContents[#self.CharacterSlotItemContents + 1] = Content
    self.List_Model:AddItem(Content)
  end
end

function M:_RefreshItemSlotList()
  local SlotViewList = self.EditRootController:BuildItemSlotViewList()
  if self.CharacterSlotItemContents and #self.CharacterSlotItemContents == #SlotViewList and self.CharacterSlotItemContents[1] and self.CharacterSlotItemContents[1].SlotKind == "Item" then
    for SlotIndex, SlotViewData in ipairs(SlotViewList) do
      local Content = self.CharacterSlotItemContents[SlotIndex]
      if Content then
        self:_ApplyCharacterSlotItemContent(Content, SlotViewData, SlotIndex)
        local EntryWidget = self.CharacterSlotEntryWidgetMap and self.CharacterSlotEntryWidgetMap[SlotIndex] or nil
        if IsValid(EntryWidget) then
          self:_RefreshCharacterSlotEntryWidget(EntryWidget, Content)
        end
      end
    end
    return
  end
  self:_CancelPendingSlotListChangeAnimation()
  self.CharacterSlotItemContents = {}
  self.CharacterSlotEntryWidgetMap = {}
  self.List_Model:ClearListItems()
  for SlotIndex, SlotViewData in ipairs(SlotViewList) do
    local Content = self:_BuildCharacterSlotItemContent(SlotViewData, SlotIndex)
    self.CharacterSlotItemContents[#self.CharacterSlotItemContents + 1] = Content
    self.List_Model:AddItem(Content)
  end
end

function M:_RefreshPetSlotList()
  self:_CancelPendingSlotListChangeAnimation()
  local SlotViewList = self.EditRootController:BuildPetSlotViewList()
  self.CharacterSlotItemContents = {}
  self.CharacterSlotEntryWidgetMap = {}
  self.List_Model:ClearListItems()
  for SlotIndex, SlotViewData in ipairs(SlotViewList) do
    local Content = self:_BuildCharacterSlotItemContent(SlotViewData, SlotIndex)
    self.CharacterSlotItemContents[#self.CharacterSlotItemContents + 1] = Content
    self.List_Model:AddItem(Content)
  end
end

function M:_GetExpectedSlotKind()
  if not self.EditRootController or not self.EditRootController.GetExpectedSlotKind then
    return nil
  end
  return self.EditRootController:GetExpectedSlotKind()
end

function M:_EnsureCharacterSlotListInitialized()
  if not self.EditRootController then
    return
  end
  local ExpectedSlotKind = self:_GetExpectedSlotKind()
  if not ExpectedSlotKind then
    return
  end
  local FirstContent = self.CharacterSlotItemContents and self.CharacterSlotItemContents[1] or nil
  local bListEmpty = self.CharacterSlotItemContents == nil or #self.CharacterSlotItemContents <= 0
  local bSlotKindMismatch = nil ~= FirstContent and FirstContent.SlotKind ~= ExpectedSlotKind
  if bListEmpty or bSlotKindMismatch then
    if "Item" == ExpectedSlotKind then
      self:_RefreshItemSlotList()
    elseif "Pet" == ExpectedSlotKind then
      self:_RefreshPetSlotList()
    else
      self:_RefreshCharacterSlotList()
    end
  end
end

function M:RefreshCharacterSlotItem(SlotIndex)
  if not self.EditRootController or type(SlotIndex) ~= "number" then
    return
  end
  if self:_GetExpectedSlotKind() ~= "Char" then
    return
  end
  local Content = self.CharacterSlotItemContents and self.CharacterSlotItemContents[SlotIndex] or nil
  if not Content or "Char" ~= Content.SlotKind then
    self:_RefreshCharacterSlotList()
    return
  end
  local SlotViewData = self.EditRootController:BuildCharacterSlotViewData(SlotIndex)
  if not SlotViewData then
    return
  end
  self:_ApplyCharacterSlotItemContent(Content, SlotViewData, SlotIndex)
  local EntryWidget = self.CharacterSlotEntryWidgetMap and self.CharacterSlotEntryWidgetMap[SlotIndex] or nil
  if IsValid(EntryWidget) then
    self:_RefreshCharacterSlotEntryWidget(EntryWidget, Content)
  end
end

function M:RefreshItemSlotItem(SlotIndex)
  if not self.EditRootController or type(SlotIndex) ~= "number" then
    return
  end
  if self:_GetExpectedSlotKind() ~= "Item" then
    return
  end
  local Content = self.CharacterSlotItemContents and self.CharacterSlotItemContents[SlotIndex] or nil
  if not Content or "Item" ~= Content.SlotKind then
    self:_RefreshItemSlotList()
    return
  end
  local SlotViewData = self.EditRootController:BuildItemSlotViewData(SlotIndex)
  if not SlotViewData then
    return
  end
  self:_ApplyCharacterSlotItemContent(Content, SlotViewData, SlotIndex)
  local EntryWidget = self.CharacterSlotEntryWidgetMap and self.CharacterSlotEntryWidgetMap[SlotIndex] or nil
  if IsValid(EntryWidget) then
    self:_RefreshCharacterSlotEntryWidget(EntryWidget, Content)
  end
end

function M:RefreshItemSlotSelection()
  if self:_GetExpectedSlotKind() ~= "Item" then
    return
  end
  self:_ApplyCharacterSlotSelectionLocally(self.EditRootController:GetSelectedItemSlotIndex())
end

function M:RefreshPetSlotItem(SlotIndex)
  if not self.EditRootController or type(SlotIndex) ~= "number" then
    return
  end
  if self:_GetExpectedSlotKind() ~= "Pet" then
    return
  end
  local Content = self.CharacterSlotItemContents and self.CharacterSlotItemContents[SlotIndex] or nil
  if not Content or "Pet" ~= Content.SlotKind then
    self:_RefreshPetSlotList()
    return
  end
  local SlotViewData = self.EditRootController:BuildPetSlotViewData(SlotIndex)
  if not SlotViewData then
    return
  end
  self:_ApplyCharacterSlotItemContent(Content, SlotViewData, SlotIndex)
  local EntryWidget = self.CharacterSlotEntryWidgetMap and self.CharacterSlotEntryWidgetMap[SlotIndex] or nil
  if IsValid(EntryWidget) then
    self:_RefreshCharacterSlotEntryWidget(EntryWidget, Content)
  end
end

function M:_RefreshCharacterSlotSelection()
  local SelectedSlotIndex = self.EditRootController:GetSelectedCharacterSlotIndex()
  self:_ApplyCharacterSlotSelectionLocally(SelectedSlotIndex)
end

function M:ClearCharacterSlotSelection()
  self:_ApplyCharacterSlotSelectionLocally(nil)
  if self.List_Model and self.List_Model.BP_ClearSelection then
    self.List_Model:BP_ClearSelection()
  end
end

function M:OnClickCharacterSlotItem(Content)
  self:OnCharacterSlotEntryClicked(Content, nil)
end

function M:_BuildCurrentTitleText()
  if not self.EditRootController then
    return GText("UI_PersonalPage_Customize")
  end
  if self.EditRootController.IsStickerEditPageActive and self.EditRootController:IsStickerEditPageActive() then
    return GText("UI_PersonalPage_AdjustSticker")
  end
  if self.EditRootController:IsChoosePageActive() then
    local ChooseMode = self.EditRootController.ActiveChooseMode
    if "Character" == ChooseMode then
      return GText("UI_PersonalPage_SelectChar")
    end
    if "Weapon" == ChooseMode then
      return GText("UI_PersonalPage_SetWeapon")
    end
    if "Action" == ChooseMode then
      return GText("UI_PersonalPage_SetAction")
    end
    if "Item" == ChooseMode then
      return GText("UI_PersonInfo_CustomItem")
    end
  end
  if self.EditRootController:GetActiveMainTabName() == "Scene" then
    return GText("UI_PersonalPage_Scene")
  end
  if self.EditRootController:GetActiveMainTabName() == "Other" then
    return GText("UI_PersonalPage_Others")
  end
  if self.EditRootController:GetActiveMainTabName() == "Pet" then
    return GText("UI_Pet")
  end
  if "Item" == self.EditRootController:GetActiveMainTabName() then
    return GText("UI_PersonInfo_CustomItem")
  end
  return GText("UI_PersonalPage_Customize")
end

function M:_RefreshEditTitleCard(TitleViewData)
  local TitleCard = self.Edit_Title
  self:_SetTitleCardMainTitle(TitleCard, TitleViewData.MainTitle or self:_BuildCurrentTitleText())
  self:_SetTextWidgetText(TitleCard.Text_CharName, TitleViewData.CharName or "")
  self:_SetTextWidgetText(TitleCard.Text_ActionType, TitleViewData.InfoTypeText or TitleViewData.ActionTypeText or "")
  self:_SetTextWidgetText(TitleCard.Text_Desc, TitleViewData.DescText or TitleViewData.InfoDescText or TitleViewData.WarningText or TitleViewData.ActionTypeText or "")
  self:_SetWidgetVisibility(TitleCard.Panel_Name_Char, TitleViewData.ShowCharPanel == true)
  self:_SetWidgetVisibility(TitleCard.Panel_Action, true == TitleViewData.ShowActionPanel)
  self:_SetWidgetVisibility(TitleCard.Group_Warning, true == TitleViewData.ShowWarning)
  self:_SetWidgetVisibility(TitleCard.Image_Element, true == TitleViewData.ShowElement)
  self:_SetWidgetVisibility(TitleCard.Com_QualityTag, true == TitleViewData.ShowQuality)
  self:_SetBrushWidgetResource(TitleCard.Image_Element, TitleViewData.AttributeIcon)
  self:_RefreshQualityTag(TitleCard.Com_QualityTag, TitleViewData.Rarity, true == TitleViewData.ShowQuality)
  if TitleCard.WS_Action then
    local ActiveIndex = TitleViewData.ActionSwitcherIndex or TitleViewData.ShowActionPanel and 1 or 0
    TitleCard.WS_Action:SetActiveWidgetIndex(ActiveIndex)
  end
end

function M:_SetTitleCardMainTitle(TitleCard, TitleText)
  local CommonTitle = TitleCard and TitleCard.Common_TItle or nil
  local MainTitleText = CommonTitle and CommonTitle.Text_MainTitle or nil
  if not MainTitleText then
    return
  end
  local ResolvedTitleText = TitleText or ""
  MainTitleText:SetText(ResolvedTitleText)
  self:_ApplyTitleCardMainTitleStyle(CommonTitle, ResolvedTitleText)
end

function M:_ApplyTitleCardMainTitleStyle(CommonTitle, TitleText)
  local MainTitleText = CommonTitle and CommonTitle.Text_MainTitle or nil
  if not MainTitleText then
    return
  end
  local bUseGreyStyle = self:_ShouldUseGreyMainTitleStyle(TitleText)
  local TargetFont = bUseGreyStyle and CommonTitle and CommonTitle.Font_Grey or nil
  if TargetFont then
    MainTitleText:SetFont(TargetFont)
    return
  end
  if bUseGreyStyle then
    local GreyMaterial = self:_GetGreyTitleFontMaterial()
    if GreyMaterial then
      local GreyFontInfo = MainTitleText.Font
      GreyFontInfo.FontMaterial = GreyMaterial
      MainTitleText:SetFont(GreyFontInfo)
      return
    end
    MainTitleText:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("8D8D8DFF"))
    return
  end
  if CommonTitle.Font_Gold then
    MainTitleText:SetFont(CommonTitle.Font_Gold)
    return
  end
  MainTitleText:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFFFF"))
end

function M:_ShouldUseGreyMainTitleStyle(TitleText)
  return TitleText == GText("UI_PersonalPage_NoWeapon") or TitleText == GText("UI_PersonalPage_DefaultAction")
end

function M:_GetGreyTitleFontMaterial()
  if self.TitleGreyFontMaterial == nil then
    self.TitleGreyFontMaterial = LoadObject(GREY_TITLE_FONT_MATERIAL_PATH)
  end
  return self.TitleGreyFontMaterial
end

function M:_SetTextWidgetText(TextWidget, Text)
  TextWidget:SetText(Text or "")
end

function M:_SetBrushWidgetResource(ImageWidget, ResourceObject)
  ImageWidget:SetBrushResourceObject(ResourceObject)
end

function M:_RefreshQualityTag(QualityTagWidget, Rarity, bVisible)
  self:_SetWidgetVisibility(QualityTagWidget, true == bVisible)
  if bVisible and Rarity then
    QualityTagWidget:Init(Rarity)
  end
end

function M:_RefreshCommonInfoState()
end

function M:_InitAddCharacterBubble()
  if self.IsHudBubbleInitialized then
    return
  end
  self.IsHudBubbleInitialized = true
  if self.Com_HudBubble then
    self.Com_HudBubble:Init({
      Text = GText("UI_PersonalPage_AddChar")
    })
    self.Com_HudBubble:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Com_HudBubble:StopAllAnimations()
    self.Com_HudBubble:PlayHorizontalLoopAnimation()
  end
  if self.Com_HudBubble_ChangeSubject then
    self.Com_HudBubble_ChangeSubject:Init({
      Text = GText("UI_PersonInfo_AddItem")
    })
    self.Com_HudBubble_ChangeSubject:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Com_HudBubble_ChangeSubject:StopAllAnimations()
    self.Com_HudBubble_ChangeSubject:PlayHorizontalLoopAnimation()
  end
end

function M:_InitChangePetBubble()
  if self.IsChangePetBubbleInitialized or not self.Com_HudBubble_ChangePet then
    return
  end
  self.IsChangePetBubbleInitialized = true
  self.Com_HudBubble_ChangePet:Init({
    Text = GText("UI_PersonalPage_AddGeniemon")
  })
  self.Com_HudBubble_ChangePet:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Com_HudBubble_ChangePet:StopAllAnimations()
  self.Com_HudBubble_ChangePet:PlayHorizontalLoopAnimation()
end

function M:_ShouldShowAddCharacterBubble()
  if not self.EditRootController then
    return false
  end
  local ActiveMainTabName = self.EditRootController:GetActiveMainTabName()
  if "Char" ~= ActiveMainTabName and "Item" ~= ActiveMainTabName then
    return false
  end
  if self.EditRootController:IsChoosePageActive() then
    return false
  end
  if "Item" == ActiveMainTabName then
    return not self:_HasAnyItemSlotFilled()
  end
  return not self:_HasAnyCharacterSlotFilled()
end

function M:_ShouldShowAddPetBubble()
  if not self.EditRootController then
    return false
  end
  if self.EditRootController:GetActiveMainTabName() ~= "Pet" then
    return false
  end
  if self.EditRootController:IsChoosePageActive() then
    return false
  end
  return not self:_HasAnyPetSlotFilled()
end

function M:_HasAnyPetSlotFilled()
  for _, SlotContent in ipairs(self.CharacterSlotItemContents or {}) do
    if SlotContent.SlotKind == "Pet" and SlotContent.HasCharacter == true then
      return true
    end
  end
  local SlotViewList = self.EditRootController and self.EditRootController.BuildPetSlotViewList and self.EditRootController:BuildPetSlotViewList() or nil
  for _, SlotViewData in ipairs(SlotViewList or {}) do
    if SlotViewData.HasCharacter == true then
      return true
    end
  end
  return false
end

function M:_HasAnyItemSlotFilled()
  for _, SlotContent in ipairs(self.CharacterSlotItemContents or {}) do
    if SlotContent.SlotKind == "Item" and SlotContent.HasItem == true then
      return true
    end
  end
  local SlotViewList = self.EditRootController and self.EditRootController.BuildItemSlotViewList and self.EditRootController:BuildItemSlotViewList() or nil
  for _, SlotViewData in ipairs(SlotViewList or {}) do
    if SlotViewData.HasItem == true then
      return true
    end
  end
  return false
end

function M:_HasAnyCharacterSlotFilled()
  for _, SlotContent in ipairs(self.CharacterSlotItemContents or {}) do
    if SlotContent.HasCharacter == true then
      return true
    end
  end
  local SlotViewList = self.EditRootController and self.EditRootController:BuildCharacterSlotViewList() or nil
  for _, SlotViewData in ipairs(SlotViewList or {}) do
    if SlotViewData.HasCharacter == true then
      return true
    end
  end
  return false
end

function M:_RefreshAddCharacterBubbleState()
  local ActiveMainTabName = self.EditRootController and self.EditRootController:GetActiveMainTabName() or nil
  local bShouldShowAddBubble = self:_ShouldShowAddCharacterBubble()
  self:_InitAddCharacterBubble()
  local ActiveBubble = self.Com_HudBubble
  local ActiveTextKey = "UI_PersonalPage_AddChar"
  local ActiveFlagName = "IsAddCharacterBubbleShowing"
  local InactiveBubble = self.Com_HudBubble_ChangeSubject
  local InactiveFlagName = "IsAddItemBubbleShowing"
  if "Item" == ActiveMainTabName then
    ActiveBubble = self.Com_HudBubble_ChangeSubject
    ActiveTextKey = "UI_PersonInfo_AddItem"
    ActiveFlagName = "IsAddItemBubbleShowing"
    InactiveBubble = self.Com_HudBubble
    InactiveFlagName = "IsAddCharacterBubbleShowing"
  end
  self:_SetAddBubbleShowing(ActiveBubble, bShouldShowAddBubble, ActiveTextKey, ActiveFlagName)
  self:_SetAddBubbleShowing(InactiveBubble, false, ActiveTextKey, InactiveFlagName)
  self:_InitChangePetBubble()
  self:_SetAddBubbleShowing(self.Com_HudBubble_ChangePet, self:_ShouldShowAddPetBubble(), "UI_PersonalPage_AddGeniemon", "IsAddPetBubbleShowing")
end

function M:_SetAddBubbleShowing(BubbleWidget, bShouldShow, TextKey, ShowingFlagName)
  if not BubbleWidget then
    return
  end
  if bShouldShow then
    if BubbleWidget.StopAllAnimations then
      BubbleWidget:StopAllAnimations()
    end
    if BubbleWidget.Text_Bubble then
      BubbleWidget.Text_Bubble:SetText(GText(TextKey))
    end
    if BubbleWidget.SetRenderOpacity then
      BubbleWidget:SetRenderOpacity(1)
    end
    BubbleWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if not self[ShowingFlagName] then
      BubbleWidget:PlayHorizontalLoopAnimation()
      self[ShowingFlagName] = true
    end
    return
  end
  if not self[ShowingFlagName] then
    return
  end
  self[ShowingFlagName] = false
  if BubbleWidget.StopAllAnimations then
    BubbleWidget:StopAllAnimations()
  end
  if BubbleWidget.PlayOutAnimation then
    BubbleWidget:PlayOutAnimation()
  end
  if BubbleWidget.SetRenderOpacity then
    BubbleWidget:SetRenderOpacity(0)
  end
  BubbleWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:_CancelPendingSlotListChangeAnimation()
  self.PendingSlotListChangeAnim = nil
  self.SlotListChangeAnimToken = (self.SlotListChangeAnimToken or 0) + 1
end

function M:_GetPendingSlotListChangeExpectedCount()
  local Contents = self.CharacterSlotItemContents
  return Contents and #Contents or 0
end

function M:PlaySlotListChangeAnimation(Options)
  Options = Options or {}
  if not IsValid(self) then
    return
  end
  if Options.ClearSlotSelection == true then
    self:ClearCharacterSlotSelection()
  end
  if self.Change and self.PlayAnimation then
    if self.StopAnimation then
      self:StopAnimation(self.Change)
    end
    self:PlayAnimation(self.Change)
  end
  if self.Change_List and self.PlayAnimation then
    if self.StopAnimation then
      self:StopAnimation(self.Change_List)
    end
    self:PlayAnimation(self.Change_List)
  end
end

function M:_CollectAlreadyReadySlotEntriesForChangeAnim()
  local Pending = self.PendingSlotListChangeAnim
  if not Pending then
    return
  end
  for SlotIndex, EntryWidget in pairs(self.CharacterSlotEntryWidgetMap or {}) do
    if type(SlotIndex) == "number" and IsValid(EntryWidget) then
      Pending.ReadyMap[SlotIndex] = true
    end
  end
  if not self.List_Model or not self.List_Model.GetDisplayedEntryWidgets then
    return
  end
  local DisplayedEntries = self.List_Model:GetDisplayedEntryWidgets()
  if DisplayedEntries and DisplayedEntries.ToTable then
    DisplayedEntries = DisplayedEntries:ToTable() or {}
  end
  for _, EntryWidget in pairs(DisplayedEntries or {}) do
    if IsValid(EntryWidget) and EntryWidget.Content and "number" == type(EntryWidget.Content.SlotIndex) then
      Pending.ReadyMap[EntryWidget.Content.SlotIndex] = true
    end
  end
end

function M:_TryFlushPendingSlotListChangeAnimation()
  local Pending = self.PendingSlotListChangeAnim
  if not Pending then
    return
  end
  if not IsValid(self) then
    self.PendingSlotListChangeAnim = nil
    return
  end
  if Pending.Token ~= self.SlotListChangeAnimToken then
    self.PendingSlotListChangeAnim = nil
    return
  end
  local ReadyCount = 0
  for _ in pairs(Pending.ReadyMap or {}) do
    ReadyCount = ReadyCount + 1
  end
  if ReadyCount < Pending.ExpectedCount then
    return
  end
  local Options = Pending.Options
  self.PendingSlotListChangeAnim = nil
  self:PlaySlotListChangeAnimation(Options)
end

function M:_MarkSlotEntryReadyForChangeAnim(Content)
  local Pending = self.PendingSlotListChangeAnim
  if not (Pending and Content) or type(Content.SlotIndex) ~= "number" then
    return
  end
  if Pending.Token ~= self.SlotListChangeAnimToken then
    return
  end
  Pending.ReadyMap[Content.SlotIndex] = true
  self:_TryFlushPendingSlotListChangeAnimation()
end

function M:RequestPlaySlotListChangeAnimation(Options)
  if not IsValid(self) then
    return
  end
  Options = Options or {}
  self:_CancelPendingSlotListChangeAnimation()
  local ExpectedCount = self:_GetPendingSlotListChangeExpectedCount()
  if ExpectedCount <= 0 or not self.List_Model then
    self:PlaySlotListChangeAnimation(Options)
    return
  end
  self.SlotListChangeAnimToken = (self.SlotListChangeAnimToken or 0) + 1
  self.PendingSlotListChangeAnim = {
    Token = self.SlotListChangeAnimToken,
    ExpectedCount = ExpectedCount,
    ReadyMap = {},
    Options = Options
  }
  self:_CollectAlreadyReadySlotEntriesForChangeAnim()
  self:_TryFlushPendingSlotListChangeAnimation()
end

function M:_BindCharacterSlotListEvents()
  self.List_Model.BP_OnItemClicked:Clear()
  self.List_Model.BP_OnItemClicked:Add(self, self.OnClickCharacterSlotItem)
  self.List_Model.BP_OnItemSelectionChanged:Clear()
  self.List_Model.BP_OnItemSelectionChanged:Add(self, self.OnCharacterSlotItemSelectionChanged)
  self.List_Model.BP_OnEntryInitialized:Clear()
  self.List_Model.BP_OnEntryInitialized:Add(self, self.OnCharacterSlotEntryInitialized)
end

function M:_BuildCharacterSlotItemContent(SlotViewData, SlotIndex)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  self:_ApplyCharacterSlotItemContent(Content, SlotViewData, SlotIndex)
  Content.OwnerPage = self.RootViewPanel or self
  return Content
end

function M:OnCharacterSlotItemSelectionChanged(Content, IsSelected)
  if not Content or true ~= IsSelected then
    return
  end
  if Content.SlotKind == "Item" then
    if true == Content.CanInteract then
      self.EditRootController:SetSelectedItemSlotIndex(Content.SlotIndex, {
        OpenHighlight = true == Content.HasItem
      })
    end
    return
  end
  if true ~= Content.HasCharacter or true ~= Content.CanInteract then
    return
  end
  self:_ApplyCharacterSlotSelectionLocally(Content.SlotIndex)
end

function M:OnCharacterSlotEntryInitialized(Content, EntryWidget)
  if not Content or not EntryWidget then
    return
  end
  if not IsValid(self) or not IsValid(EntryWidget) then
    return
  end
  self:RegisterCharacterSlotEntry(EntryWidget, Content)
end

function M:GetGamepadDefaultFocusTarget()
  if not self.EditRootController or self.EditRootController:IsChoosePageActive() then
    return nil
  end
  local ActiveTabName = self.EditRootController:GetActiveMainTabName()
  if "Char" == ActiveTabName or "Pet" == ActiveTabName or "Item" == ActiveTabName then
    local SlotIndex = "Pet" == ActiveTabName and self.EditRootController:GetSelectedPetSlotIndex() or "Item" == ActiveTabName and self.EditRootController:GetSelectedItemSlotIndex() or self.EditRootController:GetSelectedCharacterSlotIndex()
    local EntryWidget = self.CharacterSlotEntryWidgetMap and self.CharacterSlotEntryWidgetMap[SlotIndex] or nil
    local Content = self.CharacterSlotItemContents and self.CharacterSlotItemContents[SlotIndex] or nil
    local bCanFocusSlot = false
    if IsValid(EntryWidget) and Content and Content.CanInteract == true then
      if "Pet" == ActiveTabName then
        bCanFocusSlot = true
      else
        bCanFocusSlot = true == Content.HasCharacter or true == Content.HasItem
      end
    end
    if bCanFocusSlot then
      return EntryWidget
    end
  end
  return self
end

function M:_ApplyCharacterSlotItemContent(Content, SlotViewData, SlotIndex)
  Content.SlotIndex = SlotViewData and SlotViewData.SlotIndex or SlotIndex
  Content.SlotKind = SlotViewData and SlotViewData.SlotKind or "Char"
  Content.HasCharacter = SlotViewData and SlotViewData.HasCharacter == true or false
  Content.CharData = SlotViewData and SlotViewData.CharData or nil
  Content.PetData = SlotViewData and SlotViewData.PetData or nil
  Content.HasItem = SlotViewData and true == SlotViewData.HasItem or false
  Content.ItemData = SlotViewData and SlotViewData.ItemData or nil
  Content.Name = SlotViewData and SlotViewData.Name or ""
  Content.LevelText = SlotViewData and SlotViewData.LevelText or ""
  Content.IsSelected = SlotViewData and true == SlotViewData.IsSelected or false
  Content.Icon = SlotViewData and SlotViewData.Icon or nil
  Content.Rarity = SlotViewData and SlotViewData.Rarity or nil
  Content.CanInteract = SlotViewData and true == SlotViewData.CanInteract or false
  Content.ShowAddIcon = SlotViewData and true == SlotViewData.ShowAddIcon or false
  Content.ShowLockIcon = SlotViewData and true == SlotViewData.ShowLockIcon or false
  Content.UseChoosePageStyle = SlotViewData and true == SlotViewData.UseChoosePageStyle or false
end

function M:RegisterCharacterSlotEntry(EntryWidget, Content)
  if not Content or type(Content.SlotIndex) ~= "number" or not IsValid(EntryWidget) then
    return
  end
  if not IsValid(self) then
    return
  end
  self.CharacterSlotEntryWidgetMap[Content.SlotIndex] = EntryWidget
  self:_RefreshCharacterSlotEntryWidget(EntryWidget, Content)
  self:_MarkSlotEntryReadyForChangeAnim(Content)
end

function M:UnregisterCharacterSlotEntry(EntryWidget, Content)
  local SlotIndex = Content and Content.SlotIndex or nil
  if not SlotIndex then
    return
  end
  if self.CharacterSlotEntryWidgetMap[SlotIndex] == EntryWidget then
    self.CharacterSlotEntryWidgetMap[SlotIndex] = nil
  end
end

function M:_ApplyCharacterSlotSelectionLocally(SelectedSlotIndex)
  local bHasValidSelectedSlot = type(SelectedSlotIndex) == "number" and SelectedSlotIndex > 0
  local PreviousSelectedSlotIndex, PreviousSelectedSlotContent, SelectedSlotContent
  for _, SlotContent in ipairs(self.CharacterSlotItemContents or {}) do
    if SlotContent.IsSelected == true then
      PreviousSelectedSlotIndex = SlotContent.SlotIndex
      PreviousSelectedSlotContent = SlotContent
    end
    SlotContent.IsSelected = bHasValidSelectedSlot and SlotContent.SlotIndex == SelectedSlotIndex
    if bHasValidSelectedSlot and SlotContent.SlotIndex == SelectedSlotIndex then
      SelectedSlotContent = SlotContent
    end
  end
  local PreviousEntryWidget = PreviousSelectedSlotIndex and self.CharacterSlotEntryWidgetMap and self.CharacterSlotEntryWidgetMap[PreviousSelectedSlotIndex] or nil
  if PreviousEntryWidget and PreviousSelectedSlotContent then
    self:_RefreshCharacterSlotEntryWidget(PreviousEntryWidget, PreviousSelectedSlotContent)
  end
  if PreviousSelectedSlotIndex ~= SelectedSlotIndex then
    local SelectedEntryWidget = self.CharacterSlotEntryWidgetMap and self.CharacterSlotEntryWidgetMap[SelectedSlotIndex] or nil
    if SelectedEntryWidget and SelectedSlotContent then
      self:_RefreshCharacterSlotEntryWidget(SelectedEntryWidget, SelectedSlotContent)
    end
  end
end

function M:OnCharacterSlotEntryClicked(Content, EntryWidget)
  if not (self.EditRootController and Content and Content.SlotIndex) or Content.CanInteract ~= true then
    return
  end
  self:OnCharacterSlotEntryFocused(Content, EntryWidget)
end

function M:OnCharacterSlotEntryFocused(Content, EntryWidget)
  if not (self.EditRootController and Content and Content.SlotIndex) or Content.CanInteract ~= true then
    return
  end
  self:_ApplyCharacterSlotSelectionLocally(Content.SlotIndex)
  if Content.SlotKind == "Item" then
    self.EditRootController:SetSelectedItemSlotIndex(Content.SlotIndex, {
      OpenHighlight = true == Content.HasItem
    })
    return
  end
  if Content.SlotKind == "Pet" or self.EditRootController:IsPetPageActive() then
    self.EditRootController:SetSelectedPetSlotIndex(Content.SlotIndex, {
      OpenHighlight = true == Content.HasCharacter,
      OpenDetail = true == Content.HasCharacter and true == self.EditRootController:IsPetMainPageActive()
    })
    return
  end
  self.EditRootController:SetSelectedCharacterSlotIndex(Content.SlotIndex, {
    OpenHighlight = true == Content.HasCharacter,
    OpenDetail = false
  })
end

function M:_RefreshCharacterSlotEntryWidget(EntryWidget, Content)
  EntryWidget.Content = Content
  EntryWidget:RefreshEntry()
  self:_RefreshCharacterSlotEntryInteractState(EntryWidget, Content)
end

function M:_RefreshCharacterSlotEntryInteractState(EntryWidget, Content)
  if not EntryWidget then
    return
  end
  local bCanInteract = Content and Content.CanInteract == true
  local Visibility = Content and true == Content.IsSelected and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Visible
  EntryWidget:SetVisibility(Visibility)
end

function M:PlayAnimation(AnimationName)
  self.Overridden.PlayAnimation(self, AnimationName)
  MiscUtils.GreenPrint(AnimationName:GetName())
end

local STICKERS_EDIT_BP_PATH = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Widget/EditModel/WBP_PersonalInfo_EditModel_StickersEdit.WBP_PersonalInfo_EditModel_StickersEdit'"

function M:ShowStickerEditWidget(StickerViewData)
  if not self.Group_Stickers then
    return
  end
  self:ClearConfirmedStickerPreview()
  local EditWidget = self.StickersEditWidget
  if not EditWidget or not IsValid(EditWidget) then
    EditWidget = UIManager(self):CreateWidget(STICKERS_EDIT_BP_PATH)
    if not EditWidget then
      return
    end
    self.Group_Stickers:ClearChildren()
    self.Group_Stickers:AddChildToCanvas(EditWidget)
    self:_ApplyStickerEditCanvasCenter(EditWidget)
    self.StickersEditWidget = EditWidget
  end
  if EditWidget.InitStickerEdit then
    EditWidget:InitStickerEdit(StickerViewData, self)
  elseif EditWidget.RefreshStickerEdit then
    EditWidget:RefreshStickerEdit(StickerViewData)
  end
  EditWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Group_Stickers:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.bStickerEditActive = true
end

function M:HideStickerEditWidget()
  if self.StickersEditWidget and IsValid(self.StickersEditWidget) then
    self.StickersEditWidget:RemoveFromParent()
  end
  self.StickersEditWidget = nil
  self.ConfirmedStickerWidget = nil
  if self.Group_Stickers then
    self.Group_Stickers:ClearChildren()
    self.Group_Stickers:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.bStickerEditActive = false
end

function M:_ApplyStickerEditCanvasCenter(EditWidget)
  if not EditWidget then
    return
  end
  local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(EditWidget)
  if not Slot then
    return
  end
  local Anchors = UE4.FAnchors()
  Anchors.Minimum = FVector2D(0.5, 0.5)
  Anchors.Maximum = FVector2D(0.5, 0.5)
  Slot:SetAnchors(Anchors)
  Slot:SetAlignment(FVector2D(0.5, 0.5))
  Slot:SetPosition(FVector2D(0, 0))
  if Slot.SetAutoSize then
    Slot:SetAutoSize(true)
  end
end

AssembleComponents(M)
return M
