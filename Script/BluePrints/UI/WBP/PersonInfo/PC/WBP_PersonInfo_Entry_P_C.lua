require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C", "BluePrints.Common.TimerMgr")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = require("BluePrints.UI.WBP.PersonInfo.PersonInfoModel")
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Base.PersonInfoEntryBaseView",
  "BluePrints.UI.WBP.PersonInfo.Base.PersonInfoScreenshotComponent",
  "BluePrints.UI.KeyInputComponent"
}
local SCREENSHOT_KEY_NAME = "F"
local SCREENSHOT_DESC_TEXT = "UI_DynInteract_4"
local GUILD_DETAIL_LONG_PRESS_DURATION = 1

local function BuildVisitorMainPageBottomKeys(Owner)
  return {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "U",
          ClickCallback = Owner.OnUKeyDown,
          Owner = Owner
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "RS",
          ClickCallback = Owner.OnUKeyDown,
          Owner = Owner
        }
      },
      Desc = GText("UI_Dye_HideUI"),
      bLongPress = false
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = Owner.OnReturnKeyDown,
          Owner = Owner
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = Owner.OnReturnKeyDown,
          Owner = Owner
        }
      },
      Desc = GText("UI_BACK")
    }
  }
end

local function BuildMainPageBottomKeys(Owner, bCanEdit)
  if not PersonInfoModel:IsOwener() then
    return BuildVisitorMainPageBottomKeys(Owner)
  end
  local Keys = {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "U",
          ClickCallback = Owner.OnUKeyDown,
          Owner = Owner
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "RS",
          ClickCallback = Owner.OnUKeyDown,
          Owner = Owner
        }
      },
      Desc = GText("UI_Dye_HideUI"),
      bLongPress = false
    },
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "RB",
          ClickCallback = Owner.OnScreenshotKeyDown,
          Owner = Owner
        }
      },
      KeyInfoList = {
        {
          Type = "Text",
          Text = SCREENSHOT_KEY_NAME,
          ClickCallback = Owner.OnScreenshotKeyDown,
          Owner = Owner
        }
      },
      Desc = GText(SCREENSHOT_DESC_TEXT),
      bLongPress = false
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = Owner.OnReturnKeyDown,
          Owner = Owner
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = Owner.OnReturnKeyDown,
          Owner = Owner
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  if bCanEdit then
    table.insert(Keys, #Keys, {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = Owner
        }
      },
      Desc = GText("UI_Tips_Ensure"),
      bLongPress = false
    })
  end
  return Keys
end

local function BuildMainPageTabConfig(Owner, BottomKeyInfo)
  return {
    LeftKey = "NotShow",
    RightKey = "NotShow",
    Tabs = Owner.AllTabInfo,
    DynamicNode = {
      "Back",
      "Tip",
      "BottomKey"
    },
    BottomKeyInfo = BottomKeyInfo,
    StyleName = "Text",
    OwnerPanel = Owner,
    TitleName = GText("UI_PersonInfo_Name"),
    BackCallback = Owner.OnReturnKeyDown
  }
end

function M:InitTabInfo()
  if not PersonInfoModel:IsOwener() then
    self:InitTabOthers()
  else
    self:InitTabWithChar()
  end
end

function M:InitTabOthers()
  local TabWithoutChar = BuildMainPageTabConfig(self, BuildVisitorMainPageBottomKeys(self))
  self.Com_Tab:Init(TabWithoutChar)
  self.KeyAindex = nil
end

function M:InitTabWithChar()
  PersonInfoController:SetMainPageUIHidden(false)
  self.MainPageBottomKeyInfo = BuildMainPageBottomKeys(self, true)
  local TabWithChar = BuildMainPageTabConfig(self, self.MainPageBottomKeyInfo)
  self.Com_Tab:Init(TabWithChar)
  self.KeyAindex = 3
  self.MainPageBottomHideUIKeyIndex = 1
  self.MainPageBottomScreenshotKeyIndex = 2
  self:RefreshMainPageBottomAByCurrentFocus()
end

function M:RefreshMainPageBottomShortcutVisibilityForEditList()
  if not PersonInfoModel:IsOwener() then
    return
  end
  if not (self.Com_Tab and self.Com_Tab.SetSingleBottomKeyInfo) or not self.Com_Tab.BottomKeyWidget then
    return
  end
  if not self.MainPageBottomKeyInfo then
    return
  end
  local bIsEditOpen = self.PersonInfoMainPage and self.PersonInfoMainPage.IsEditOpen
  local HideUIWidget = self.Com_Tab.BottomKeyWidget[self.MainPageBottomHideUIKeyIndex]
  if HideUIWidget then
    self.Com_Tab:SetSingleBottomKeyInfo(HideUIWidget, bIsEditOpen and {} or self.MainPageBottomKeyInfo[self.MainPageBottomHideUIKeyIndex] or {})
  end
  local ScreenshotWidget = self.Com_Tab.BottomKeyWidget[self.MainPageBottomScreenshotKeyIndex]
  if ScreenshotWidget then
    self.Com_Tab:SetSingleBottomKeyInfo(ScreenshotWidget, bIsEditOpen and {} or self.MainPageBottomKeyInfo[self.MainPageBottomScreenshotKeyIndex] or {})
  end
end

function M:Hideui()
  PersonInfoController:SetMainPageUIHidden(true)
  self.PersonInfoMainPage.MainPanel:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Com_Tab:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:Playanimation(self.HideUi)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem then
    GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
  end
end

function M:Recoverui()
  PersonInfoController:SetMainPageUIHidden(false)
  self.PersonInfoMainPage.MainPanel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Com_Tab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:Playanimation(self.ShowUi)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem then
    GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  end
end

function M:Close()
  M.Super.Close(self)
end

function M:Destruct()
end

function M:InitListenEvent()
end

function M:OnLoaded()
  M.Super.OnLoaded(self)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self:_InitMainPageGamepadLongPressEvent()
  self:InitTabInfo()
  self:InitListenEvent()
end

function M:RefreshBaseInfo()
  self.PersonInfoMainPage = self:CreatePersonInfoMainPage({
    PCBluePrint = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_Main_P.WBP_PersonalInfo_Main_P'"
  })
  if self.PersonInfoMainPage then
    self.PersonInfoMainPage:PlayAnimation(self.PersonInfoMainPage.In)
    if self.PersonInfoMainPage.ActorController == nil and self.PersonInfoMainPage.ModelViewIni then
      self.PersonInfoMainPage:ModelViewIni()
    end
  end
  self.PersonInfoMainPage.RootPage = self
  if PersonInfoController:IsMainPageUIHidden() then
    self:Hideui()
  else
    self:Recoverui()
  end
  self:OnMainPageLoaded()
end

function M:CreatHideUiKey(IsGamePad)
  local MyKeyInfoList = {}
  if IsGamePad then
    MyKeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.RightThumb,
        ClickCallback = self.OnUKeyDown,
        Owner = self
      }
    }
  else
    MyKeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText("U"),
        ClickCallback = self.OnUKeyDown,
        Owner = self
      }
    }
  end
end

function M:OnMainPageLoaded()
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:FreshViewByInputDevice(true)
  end
  self.PersonInfoMainPage.Btn_EditSign.OnHovered:Add(self, function()
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
      self:UpdataGamePadBottomAInfo(4)
    end
  end)
end

function M:_InitMainPageGamepadLongPressEvent()
  self:AddLongPressEvent(UIConst.GamePadKey.SpecialLeft, GUILD_DETAIL_LONG_PRESS_DURATION, self._OnGuildGamepadLongPressStart, self._OnGuildGamepadLongPressCancel, self._OnGuildGamepadLongPressEnd)
  self:AddKeyClickEvent(UIConst.GamePadKey.SpecialLeft, self._OnGuildGamepadShortClick)
end

function M:_OnGuildGamepadLongPressStart()
  if self.PersonInfoMainPage and self.PersonInfoMainPage.IsEditOpen then
    return
  end
  if self.PersonInfoMainPage and self.PersonInfoMainPage.Key_Guild then
    self.PersonInfoMainPage.Key_Guild:OnButtonPressed(false, true, 0, self:GetLongPressAnimationTime(UIConst.GamePadKey.SpecialLeft))
  end
end

function M:_OnGuildGamepadLongPressCancel()
  if self.PersonInfoMainPage and self.PersonInfoMainPage.Key_Guild then
    self.PersonInfoMainPage.Key_Guild:RemoveExecuteLogic()
    self.PersonInfoMainPage.Key_Guild:OnButtonReleased()
    self.PersonInfoMainPage.Key_Guild:StopAllAnimations()
    if self.PersonInfoMainPage.Key_Guild.Normal then
      self.PersonInfoMainPage.Key_Guild:PlayAnimation(self.PersonInfoMainPage.Key_Guild.Normal)
    end
  end
end

function M:_OnGuildGamepadLongPressEnd()
  self:_OnGuildGamepadLongPressCancel()
  if self.PersonInfoMainPage and not self.PersonInfoMainPage.IsEditOpen then
    self.PersonInfoMainPage:TryOpenGuildDetailByGamepad()
  end
end

function M:_OnGuildGamepadShortClick()
  return self:OnGamepadCopyUIDClick()
end

function M:OnGamepadCopyUIDClick()
  if self.PersonInfoMainPage and not self.PersonInfoMainPage.IsEditOpen and self.PersonInfoMainPage.OnCopyUID then
    self.PersonInfoMainPage:OnCopyUID()
    return true
  end
  return false
end

function M:OnReturnKeyDown()
  if not self:CheckIsCanCloseSelf() then
    return
  end
  self:PlayOutAnim()
end

function M:OnUKeyDown()
  local bIsHide = not PersonInfoController:IsMainPageUIHidden()
  PersonInfoController:SetMainPageUIHidden(bIsHide)
  if bIsHide then
    self:Hideui()
  else
    self:Recoverui()
  end
end

function M:_RefreshMainPageFocusAfterCustomEditClosed()
  self:FreshViewByInputDevice(self.CurInputDeviceType == ECommonInputType.Gamepad)
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  if not self.PersonInfoMainPage then
    return
  end
  self:AddTimer(0.01, function()
    if not self.PersonInfoMainPage or self.CurInputDeviceType ~= ECommonInputType.Gamepad then
      return
    end
    self.PersonInfoMainPage:FreshFocusLeaveEditListView()
    self.PersonInfoMainPage:SetOriginFocus()
  end)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  local IsFirstUpdate = self.CurInputDeviceType == nil
  self.CurInputDeviceType = CurInputType
  if PersonInfoController.CurPage == PersonInfoController.PageEnum.EditPage and IsValid(PersonInfoController.EditPage) then
    PersonInfoController.EditPage:SetFocus()
    PersonInfoController.EditPage:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  elseif PersonInfoController.CurPage == PersonInfoController.PageEnum.MainPage and IsValid(PersonInfoController.MainPage) then
    if not IsFirstUpdate and not self:HasAnyFocus() then
      return
    end
    if CurInputType == ECommonInputType.Gamepad then
      if self.PersonInfoMainPage then
        if not UIManager(self):GetUIObj("CommonDialog") then
          self.PersonInfoMainPage:SetOriginFocus()
        end
        self:FreshViewByInputDevice(true)
        self:CreatHideUiKey(true)
      end
    else
      self:CreatHideUiKey(false)
      self:FreshViewByInputDevice(false)
    end
  end
end

function M:FreshViewByInputDevice(bIsGamePad)
  if not self.PersonInfoMainPage then
    return
  end
  self.PersonInfoMainPage.CurInputDeviceType = self.CurInputDeviceType
  if bIsGamePad then
    if self.PersonInfoMainPage.EnsureMainPageGamepadWidgetsInitialized then
      self.PersonInfoMainPage:EnsureMainPageGamepadWidgetsInitialized()
    end
    if PersonInfoModel:IsOwener() then
      self.PersonInfoMainPage.Key_Controller:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
      self.PersonInfoMainPage.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.PersonInfoMainPage.Key_ControllerImg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.PersonInfoMainPage.WS_Copy:SetActiveWidgetIndex(1)
    self.PersonInfoMainPage:RefreshGuildGamepadKeyVisibility()
    self.PersonInfoMainPage:RefreshSettingGamepadKeyVisibility()
    self.PersonInfoMainPage:SetOriginFocus()
  else
    self.PersonInfoMainPage.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.PersonInfoMainPage.Key_ControllerImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.PersonInfoMainPage.WS_Copy:SetActiveWidgetIndex(0)
    self.PersonInfoMainPage:RefreshGuildGamepadKeyVisibility()
    self.PersonInfoMainPage:RefreshSettingGamepadKeyVisibility()
  end
end

function M:Handle_KeyDownOnGamePad()
  return true
end

function M:UpdataGamePadBottomAInfo(KindNum)
  local keytable = {}
  if KindNum then
    local Kind2KeyTable = {
      "UI_CTL_Add",
      "UI_Controller_CheckDetails",
      "UI_Controller_Switch",
      "UI_Tips_Ensure"
    }
    keytable = {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = self
        }
      },
      Desc = GText(Kind2KeyTable[KindNum]),
      bLongPress = false
    }
  end
  self.Com_Tab:SetSingleBottomKeyInfo(self.Com_Tab.BottomKeyWidget[self.KeyAindex], keytable)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  M.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
  if PersonInfoController.CurPage == PersonInfoController.PageEnum.EditPage and IsValid(PersonInfoController.EditPage) then
    PersonInfoController.EditPage:SetFocus()
  elseif PersonInfoController.CurPage == PersonInfoController.PageEnum.DataPage then
    PersonInfoController.DataPage:SetFocus()
  elseif self.PersonInfoMainPage then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  end
  return UIUtils.Handled
end

function M:OnAddedToFocusPath(InFocusEvent)
  self:AddTimer(0.1, function()
    if self.PersonInfoMainPage and self.CurInputDeviceType == ECommonInputType.Gamepad and not self:HasFocusedDescendants() then
      self:FocusToSavedWidget()
      self.PersonInfoMainPage:FreshFocusLeaveEditListView()
      if not self:HasFocusedDescendants() then
        self.PersonInfoMainPage:SetOriginFocus()
      end
    end
  end)
end

function M:OnItemFocus()
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:UpdataGamePadBottomAInfo(1)
  end
end

function M:OnCheckBoxFocus()
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:UpdataGamePadBottomAInfo(3)
  end
end

function M:GamePadOpenEditList()
  if not (PersonInfoModel:IsOwener() and self.PersonInfoMainPage) or self.PersonInfoMainPage.IsEditOpen then
    return false
  end
  self.PersonInfoMainPage:OnClickEdit()
  self:UpdataGamePadBottomAInfo(4)
  self:SaveCurrentFocusedWidget()
  self:AddTimer(0.1, function()
    if not self.PersonInfoMainPage then
      return
    end
    local firstUi = self.PersonInfoMainPage:GetFisrtEditItem()
    if firstUi then
      firstUi:SetFocus()
      self.PersonInfoMainPage.Edit_List:SetSelectedIndex(0)
      if self.PersonInfoMainPage.Panel_Edit:HasFocusedDescendants() then
        self.PersonInfoMainPage:FreshFocusOnEditListView()
      end
    end
  end)
  return true
end

function M:RefreshMainPageBottomAByCurrentFocus()
  if not PersonInfoModel:IsOwener() then
    return
  end
  if not self.PersonInfoMainPage then
    return
  end
  local FocusIndex = self.PersonInfoMainPage.SelectCharIndex
  local FocusWidget = FocusIndex and -1 ~= FocusIndex and self.PersonInfoMainPage["AvatarItem_" .. tostring(FocusIndex)] or nil
  local FocusContent = FocusWidget and FocusWidget.Com_Item and FocusWidget.Com_Item.Content or nil
  if FocusContent and FocusContent.Id and 0 ~= FocusContent.Id and -1 ~= FocusContent.Id then
    self:UpdataGamePadBottomAInfo(2)
  else
    self:UpdataGamePadBottomAInfo(1)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and PersonInfoController:IsMainPageUIHidden() and (InKeyName == UIConst.GamePadKey.FaceButtonRight or InKeyName == UIConst.GamePadKey.RightThumb) then
    self:Recoverui()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  if self.bScreenshotWidgetShow and IsValid(self.ScreenshotWidget) then
    self.ScreenshotWidget:OnKeyDown(MyGeometry, InKeyEvent)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    self.IsGamePad = true
    IsEventHandled = self:OnGamePadDown(InKeyName)
  else
    self.IsGamePad = false
    if "U" == InKeyName then
      self:OnUKeyDown()
      IsEventHandled = true
    end
    if InKeyName == SCREENSHOT_KEY_NAME and PersonInfoModel:IsOwener() then
      IsEventHandled = self:TryTakeScreenshot()
    end
    if "Escape" == InKeyName then
      if not PersonInfoController:IsMainPageUIHidden() then
        self:OnReturnKeyDown()
      else
        self:Recoverui()
      end
      IsEventHandled = true
    end
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  if self.bScreenshotWidgetShow and IsValid(self.ScreenshotWidget) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local Reply, IsHandled = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if self.bScreenshotWidgetShow then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnGamePadDown(InKeyName)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  local IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
  if PersonInfoController:IsMainPageUIHidden() then
    return false
  elseif self.PersonInfoMainPage and self.PersonInfoMainPage.IsEditOpen then
    if InKeyName == UIConst.GamePadKey.SpecialLeft or InKeyName == UIConst.GamePadKey.RightShoulder or InKeyName == UIConst.GamePadKey.RightThumb or InKeyName == UIConst.GamePadKey.SpecialRight or InKeyName == UIConst.GamePadKey.FaceButtonTop then
      return true
    end
  elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
    if self.PersonInfoMainPage and self.PersonInfoMainPage:CanOpenGuildDetailByGamepad() then
      return true
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.RightShoulder then
    if not PersonInfoModel:IsOwener() then
      return false
    end
    return self:TryTakeScreenshot()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    if not PersonInfoModel:IsOwener() then
      return false
    end
    PersonInfoController:OpenEditView("Char", nil)
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftThumb then
    if not PersonInfoModel:IsOwener() then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if not self.PersonInfoMainPage.IsEditOpen then
      return self:GamePadOpenEditList()
    else
      self.PersonInfoMainPage:OnClickEdit()
      if self.PersonInfoMainPage.IsEditOpen == false then
        self:FocusToSavedWidget()
        if self.PersonInfoMainPage.Panel_Edit:HasFocusedDescendants() then
          self:SetFocus()
        end
        self.PersonInfoMainPage:FreshFocusLeaveEditListView()
      end
      return true
    end
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    if not self.PersonInfoMainPage.IsEditOpen then
      self:OnUKeyDown()
      return true
    end
    return false
  elseif InKeyName == UIConst.GamePadKey.SpecialRight then
    if not self.PersonInfoMainPage.IsEditOpen then
      self.PersonInfoMainPage:OnClickOpenDataPage()
      return true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if not PersonInfoModel:IsOwener() then
      return false
    end
    self.PersonInfoMainPage:OnClickOpenCustomEditPage()
    return true
  end
  return IsEventHandled
end

function M:UpdataGamePadBottomAInfo(KindNum)
  if not self.KeyAindex then
    return
  end
  local keytable = {}
  if KindNum then
    local Kind2KeyTable = {
      "UI_CTL_Add",
      "UI_Controller_CheckDetails",
      "UI_Controller_Switch",
      "UI_Tips_Ensure"
    }
    keytable = {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = self
        }
      },
      Desc = GText(Kind2KeyTable[KindNum]),
      bLongPress = false
    }
  end
  self.Com_Tab:SetSingleBottomKeyInfo(self.Com_Tab.BottomKeyWidget[self.KeyAindex], keytable)
end

function M:Tick(MyGeometry, InDeltaTime)
  if M.Super and M.Super.Tick then
    M.Super.Tick(self, MyGeometry, InDeltaTime)
  end
end

AssembleComponents(M)
return M
