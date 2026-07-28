require("UnLua")
local UIUtils = require("Utils.UIUtils")
local GREY_TITLE_FONT_MATERIAL_PATH = "MaterialInstanceConstant'/Game/UI/WBP/Common/VX/Common/MI_Com_TagWord_Grey.MI_Com_TagWord_Grey'"
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditPageHostComponent"
}
M.MainTabNameList = {
  [1] = "Char",
  [2] = "Scene"
}
M.MainTabConfigList = {
  [1] = {
    Name = "Char",
    TextKey = "UI_Armory_Char",
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Personal_Avatar",
    TabId = 1
  },
  [2] = {
    Name = "Scene",
    TextKey = "UI_PersonalPage_Scene",
    IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Personal_Scence",
    TabId = 2
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
  self.IsHudBubbleInitialized = false
  self.IsAddCharacterBubbleShowing = false
  self.bCharacterSlotSwitchGamepadKeyInitialized = false
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
  local bShowTab = not self.EditRootController:IsChoosePageActive()
  self:SetRootTabVisibility(bShowTab)
  if bShowTab then
    self:_RefreshMainTabSelection()
  end
  self:RefreshSceneTabReddot()
end

function M:RefreshSlotAreaState()
  if not self.EditRootController then
    return
  end
  local bShowCharacterSlots = self.EditRootController:ShouldShowCharacterSlotArea()
  self:SetRootSlotAreaVisibility(bShowCharacterSlots)
  if bShowCharacterSlots then
    self:_RefreshCharacterSlotList()
  end
end

function M:RefreshCommonActionState()
  if not self.EditRootController then
    return
  end
  local bIsChooseConfirmMode = self.EditRootController:IsChooseConfirmMode()
  local bShowSaveButton = true
  local bCanSave
  if bIsChooseConfirmMode then
    bCanSave = self.EditRootController:CanConfirmCharacterChoosePage()
  else
    bCanSave = self.EditRootController:CanSaveEdit()
  end
  self:_SetButtonVisibility(self.Btn_Save, bShowSaveButton)
  self:_SetButtonEnabled(self.Btn_Save, bCanSave and not self.EditRootController:IsSavingEdit())
  local bShowAddButton = self.EditRootController:GetActiveMainTabName() == "Char" and not self.EditRootController:IsChoosePageActive()
  self:_SetButtonVisibility(self.Btn_Add, bShowAddButton)
  self:_SetWidgetVisibility(self.Group_Add, bShowAddButton)
  self:_RefreshCommonButtonText()
  self:_RefreshCommonTitleState()
  self:_RefreshCommonInfoState()
  self:_RefreshAddCharacterBubbleState()
  self:_RefreshBottomKeyInfo()
end

function M:RefreshSaveButtonState()
  if not self.EditRootController then
    return
  end
  local bIsChooseConfirmMode = self.EditRootController:IsChooseConfirmMode()
  local bCanSave
  if bIsChooseConfirmMode then
    bCanSave = self.EditRootController:CanConfirmCharacterChoosePage()
  else
    bCanSave = self.EditRootController:CanSaveEdit()
  end
  self:_SetButtonVisibility(self.Btn_Save, true)
  self:_SetButtonEnabled(self.Btn_Save, bCanSave and not self.EditRootController:IsSavingEdit())
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
  if self.EditRootController:IsChooseConfirmMode() then
    self.EditRootController.ChoosePagePanel:OnClickConfirmChoose()
    return
  end
  self.EditRootController:SaveEditAndClose()
end

function M:OnClickSaveForbidden()
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

function M:OnClickAdd()
  self.EditRootController:OpenCharacterChoosePage()
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
  self:_RefreshCharacterSlotSelection()
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
  self:_BindButtonClick(self.Btn_Add, self.OnClickAdd)
end

function M:_InitCommonButtonText()
  self.Btn_Save:SetText(GText("UI_PersonalPage_SaveEdit"))
  self.Btn_Save:BindForbidStateExecuteEvent(self, self.OnClickSaveForbidden)
  if self.Btn_Save and self.Btn_Save.SetDefaultGamePadImg then
    self.Btn_Save:SetDefaultGamePadImg("Y")
  elseif self.Btn_Save and self.Btn_Save.SetGamePadImg then
    self.Btn_Save:SetGamePadImg("Y")
  end
end

function M:_RefreshCommonButtonText()
  if self.EditRootController:IsChooseConfirmMode() then
    self.Btn_Save:SetText(GText("UI_PersonalPage_ConfirmSelect"))
  else
    self.Btn_Save:SetText(GText("UI_PersonalPage_SaveEdit"))
  end
end

function M:_RefreshCommonTitleState()
  local ActiveIndex = self.EditRootController:ShouldUseCharacterInfoSwitcher() and 0 or 1
  self.WS_Title:SetActiveWidgetIndex(ActiveIndex)
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
  self.Com_Tab:ShowTabRedDot(2, bShowNew, bShowNormal, bShowGray)
end

function M:OnReturnKeyDown()
  if not self.EditRootController then
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
  local bCanHandleMainPageShortcut = not self.EditRootController:IsChoosePageActive()
  if not bCanHandleMainPageShortcut then
    local ChoosePagePanel = self.EditRootController.ChoosePagePanel
    if ChoosePagePanel and ChoosePagePanel.Handle_ChoosePageForwardedKeyDown and ChoosePagePanel:Handle_ChoosePageForwardedKeyDown(InKeyName) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
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
    if self.EditRootController and self.EditRootController:IsChoosePageActive() then
      self.EditRootController:CloseChoosePageAndReturn()
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
  local bIsHiddenUI = true == self.bHiddenUI
  return string.format("%s|%s|%s", tostring(ActiveTabName), tostring(bIsChoosePageActive), tostring(bIsHiddenUI))
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

function M:_EnsureCharacterSlotListInitialized()
  if not self.EditRootController then
    return
  end
  if self.CharacterSlotItemContents == nil or #self.CharacterSlotItemContents <= 0 then
    self:_RefreshCharacterSlotList()
  end
end

function M:RefreshCharacterSlotItem(SlotIndex)
  if not self.EditRootController or type(SlotIndex) ~= "number" then
    return
  end
  local SlotViewData = self.EditRootController:BuildCharacterSlotViewData(SlotIndex)
  if not SlotViewData then
    return
  end
  local Content = self.CharacterSlotItemContents and self.CharacterSlotItemContents[SlotIndex] or nil
  if not Content then
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

function M:OnClickCharacterSlotItem(Content)
  self:OnCharacterSlotEntryClicked(Content, nil)
end

function M:_BuildCurrentTitleText()
  if not self.EditRootController then
    return GText("UI_PersonalPage_Customize")
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
  end
  if self.EditRootController:GetActiveMainTabName() == "Scene" then
    return GText("UI_PersonalPage_Scene")
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
  if self.IsHudBubbleInitialized or not self.Com_HudBubble then
    return
  end
  self.IsHudBubbleInitialized = true
  self.Com_HudBubble:Init({
    Text = GText("UI_PersonalPage_AddChar")
  })
  self.Com_HudBubble:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Com_HudBubble:StopAllAnimations()
  self.Com_HudBubble:PlayHorizontalLoopAnimation()
end

function M:_ShouldShowAddCharacterBubble()
  if not self.EditRootController then
    return false
  end
  if self.EditRootController:GetActiveMainTabName() ~= "Char" then
    return false
  end
  if self.EditRootController:IsChoosePageActive() then
    return false
  end
  return not self:_HasAnyCharacterSlotFilled()
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
  if not self.Com_HudBubble then
    return
  end
  self:_InitAddCharacterBubble()
  if self:_ShouldShowAddCharacterBubble() then
    self.Com_HudBubble.Text_Bubble:SetText(GText("UI_PersonalPage_AddChar"))
    if self.Com_HudBubble.SetRenderOpacity then
      self.Com_HudBubble:SetRenderOpacity(1)
    end
    self.Com_HudBubble:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if not self.IsAddCharacterBubbleShowing then
      self.Com_HudBubble:PlayHorizontalLoopAnimation()
      self.IsAddCharacterBubbleShowing = true
    end
    return
  end
  self.IsAddCharacterBubbleShowing = false
  if self.Com_HudBubble.StopAllAnimations then
    self.Com_HudBubble:StopAllAnimations()
  end
  if self.Com_HudBubble.PlayOutAnimation then
    self.Com_HudBubble:PlayOutAnimation()
  end
  if self.Com_HudBubble.SetRenderOpacity then
    self.Com_HudBubble:SetRenderOpacity(0)
  end
  self.Com_HudBubble:SetVisibility(UIConst.VisibilityOp.Collapsed)
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
  if true ~= Content.HasCharacter or true ~= Content.CanInteract then
    return
  end
  self:_ApplyCharacterSlotSelectionLocally(Content.SlotIndex)
end

function M:OnCharacterSlotEntryInitialized(Content, EntryWidget)
  if not Content or not EntryWidget then
    return
  end
  self:RegisterCharacterSlotEntry(EntryWidget, Content)
end

function M:GetGamepadDefaultFocusTarget()
  if not self.EditRootController or self.EditRootController:IsChoosePageActive() then
    return nil
  end
  if self.EditRootController:GetActiveMainTabName() == "Char" then
    local SlotIndex = self.EditRootController:GetSelectedCharacterSlotIndex()
    local EntryWidget = self.CharacterSlotEntryWidgetMap and self.CharacterSlotEntryWidgetMap[SlotIndex] or nil
    local Content = self.CharacterSlotItemContents and self.CharacterSlotItemContents[SlotIndex] or nil
    if IsValid(EntryWidget) and Content and Content.HasCharacter == true and true == Content.CanInteract then
      return EntryWidget
    end
  end
  return self
end

function M:_ApplyCharacterSlotItemContent(Content, SlotViewData, SlotIndex)
  Content.SlotIndex = SlotViewData and SlotViewData.SlotIndex or SlotIndex
  Content.HasCharacter = SlotViewData and SlotViewData.HasCharacter == true or false
  Content.CharData = SlotViewData and SlotViewData.CharData or nil
  Content.Name = SlotViewData and SlotViewData.Name or ""
  Content.LevelText = SlotViewData and SlotViewData.LevelText or ""
  Content.IsSelected = SlotViewData and true == SlotViewData.IsSelected or false
  Content.Icon = SlotViewData and SlotViewData.Icon or nil
  Content.CanInteract = SlotViewData and true == SlotViewData.CanInteract or false
  Content.ShowAddIcon = SlotViewData and true == SlotViewData.ShowAddIcon or false
  Content.ShowLockIcon = SlotViewData and true == SlotViewData.ShowLockIcon or false
  Content.UseChoosePageStyle = SlotViewData and true == SlotViewData.UseChoosePageStyle or false
end

function M:RegisterCharacterSlotEntry(EntryWidget, Content)
  self.CharacterSlotEntryWidgetMap[Content.SlotIndex] = EntryWidget
  self:_RefreshCharacterSlotEntryWidget(EntryWidget, Content)
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
  GreenPrint(AnimationName:GetName())
end

AssembleComponents(M)
return M
