require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")

function M:Construct()
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnGuildEditDeclaration then
      self:OnGuildEditDeclarationSucceed(...)
    end
  end)
end

function M:Destruct()
  GuildController:UnRegisterEvent(self)
end

function M:InitView(GuildInfo)
  self.CurrGuildInfo = GuildInfo
  if not self.CurrGuildInfo then
    return
  end
  self.GuildId = self.CurrGuildInfo.GuildId
  self.Text_GuildName:SetText(GText(self.CurrGuildInfo.Name or ""))
  self.Text_IntroTitle:SetText(GText("UI_GuildDeclaration"))
  self.Text_Intro:SetText(GText(self.CurrGuildInfo.Declaration or ""))
  self.GuildInfo:InitView(self, self.CurrGuildInfo, function()
    self:CancelFocusListBtn()
  end)
  self.UserActivity:InitView(self, self.CurrGuildInfo)
  self.Btn_Confirm:SetText(GText("UI_GuildTerritory"))
  self.Btn_Confirm:BindForbidStateExecuteEvent(self, self.OnBtnConfirmClicked)
  self.Btn_Confirm:ForbidBtn(true)
  self.Btn_Confirm:LockBtn(true)
  self.Btn_Confirm:SetDefaultGamePadImg("RS")
  self:RefreshOpInfoByInputDevice()
  self:InitEditIntro()
  self:InitFunctionList()
  self:InitGamepad()
end

function M:InitFunctionList()
  local FunctionList = {
    {
      Name = "Btn_Dynamics",
      Text = "UI_GuildActivityFeed",
      OnClick = self.OnBtnDynamicsClicked
    }
  }
  self.List_Function:ClearListItems()
  for _, Function in ipairs(FunctionList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ParentWidget = self
    Content.Text = Function.Text
    Content.bGamepadIconVisible = false
    Content.OnClickFunction = Function.OnClick
    self.List_Function:AddItem(Content)
  end
end

function M:InitGamepad()
  if not UIUtils.IsGamepadInput() then
    return
  end
  self.Controller_Function:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "A",
        Owner = self
      }
    }
  })
  self.Btn_Confirm:SetGamePadImg("RS")
  self.bShoulFocusToLastFocusedWidget = false
  self:SetIsShowNavigateGuide(false)
  self:SetIsDealWithVirtualAccept(true)
end

function M:RefreshUIInfo()
  self.GuildInfo:SetEditPanelVisible(false)
end

function M:OnBtnDynamicsClicked()
  UIManager(self):LoadUINew("GuildDynamics")
end

function M:OnBtnConfirmClicked()
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildSystemNotAvailable"))
end

function M:InitEditIntro()
  local Avatar = GWorld:GetAvatar()
  local MemberInfo = GuildController:GetModel():GetCurrMember(Avatar.Uid)
  if MemberInfo and DataMgr.GuildTitle[MemberInfo.Title].ModifyDeclaration then
    self.EditIntroAuthority = true
    self.Btn_EditIntro.OnClicked:Add(self, self.OpenEditGuildDeclarationDialog)
    self.Btn_EditIntro:SetForbidden(false)
  else
    self.EditIntroAuthority = false
    self.Btn_EditIntro:SetForbidden(true)
  end
  self:InitNavigation()
end

function M:RefreshEditIntroAuthority(IsPermitted)
  self.Btn_EditIntro.OnClicked:Remove(self, self.OpenEditGuildDeclarationDialog)
  if IsPermitted then
    self.EditIntroAuthority = true
    self.Btn_EditIntro.OnClicked:Add(self, self.OpenEditGuildDeclarationDialog)
    self.Btn_EditIntro:SetForbidden(false)
  else
    self.EditIntroAuthority = false
    self.Btn_EditIntro.OnClicked:Remove(self, self.OpenEditGuildDeclarationDialog)
    self.Btn_EditIntro:SetForbidden(true)
  end
end

function M:OpenEditGuildDeclarationDialog()
  if not self.CurrGuildInfo then
    return
  end
  self.GuildDeclarationEditDialog = UIManager(self):ShowCommonPopupUI(100363, {
    MultilineType = 0,
    IsMultiLine = true,
    DefaultText = self.CurrGuildInfo.Declaration or "",
    EditTextConfig = {
      Owner = self,
      Events = {
        OnTextChanged = function(self, Text)
          if "" == Text or " " == Text then
            self.GuildDeclarationEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(true)
          else
            self.GuildDeclarationEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(false)
          end
        end
      },
      TextLimit = GuildCommon.GuildDeclMaxLen,
      HintText = GText("UI_Chat_InputHint"),
      bLimitSpaces = true,
      bLimitBr = true,
      Text = self.CurrGuildInfo.Declaration or "",
      bNeedCheckStringSensitive = true,
      OnCheckStringSensitive = function(_, bSuccess, Name)
        if bSuccess then
          Name = Name or ""
          if "" ~= Name then
            GuildController:SendGuildEditDeclaration(Name)
            self.NeedShowEditIntroSuccessTip = true
          else
          end
        end
      end
    }
  }, self)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
end

function M:OnGuildEditDeclarationSucceed(Ret)
  if self.NeedShowEditIntroSuccessTip then
    self.NeedShowEditIntroSuccessTip = false
  else
    return
  end
  if Ret and Ret ~= ErrorCode.RET_SUCCESS then
    return
  end
  local GuildData = GuildController:GetModel():GetCurrGuild()
  if not GuildData then
    return
  end
  self.CurrGuildInfo = GuildData
  self.Text_Intro:SetText(GText(GuildData.Declaration or ""))
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_EditSuccessful"))
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if UIUtils.IsGamepadInput() then
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
end

function M:InitGamepadView()
  self:SetAutoFocus()
  self:SetGamepadIconVisibility(true)
  self:UpdateParentComTab()
end

function M:UpdateParentComTab()
  if not self.ParentWidget then
    return
  end
  if UIUtils.HasAnyFocus(self.List_Function) then
    local BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure")
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    self.ParentWidget:UpdateComTab(BottomKeyInfo)
  else
    local BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    self.ParentWidget:UpdateComTab(BottomKeyInfo)
  end
end

function M:InitKeyboardView()
  self:SetGamepadIconVisibility(false)
end

function M:_OnPagePoped()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonDown and self:HasAnyUserFocus() then
    self.List_Function:SetFocus()
    self:UpdateParentComTab()
    self:SetGamepadIconVisibility(false)
    self.WidgetFocus = self.List_Function
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UIUtils.IsGamepadInput() then
    IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  else
    IsHandled = self:Handle_KeyDownOnKeyboard(InKeyName)
  end
  return IsHandled
end

function M:Handle_KeyDownOnKeyboard(InKeyName)
  local IsHandled = false
  if "Escape" == InKeyName and self.GuildInfo.IsEditOpen then
    self.GuildInfo:SetEditPanelVisible(false)
    IsHandled = true
  end
  return IsHandled
end

function M:CancelFocusListBtn()
  if self.WidgetFocus then
    self.WidgetFocus = false
    self:SetGamepadIconVisibility(true)
    self.GuildInfo:SetEditPanelVisible(false)
    self:UpdateParentComTab()
  end
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  local IsHandled = false
  if self.WidgetFocus then
    if "Gamepad_FaceButton_Right" == InKeyName then
      self:SetFocus()
      self:CancelFocusListBtn()
      IsHandled = true
    end
  elseif "Gamepad_Special_Left" == InKeyName then
    self.GuildInfo:Copy()
    IsHandled = true
  elseif "Gamepad_RightThumbstick" == InKeyName then
    self:OnBtnConfirmClicked()
    IsHandled = true
  elseif "Gamepad_LeftThumbstick" == InKeyName then
    if self.GuildInfo.Btn_Edit:IsVisible() then
      self.GuildInfo:OnBtnEditClicked()
      self.GuildInfo.List_Edit:SetFocus()
      self.GuildInfo.List_Edit:NavigateToIndex(0)
      self.WidgetFocus = true
      self:SetGamepadIconVisibility(false)
      IsHandled = true
    end
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    self.UserActivity:OnBtnClick()
    IsHandled = true
  elseif "Gamepad_FaceButton_Left" == InKeyName and self.ParentWidget and self.ParentWidget.Entrance_Shop then
    self.ParentWidget.Entrance_Shop:SetFocus()
    self.WidgetFocus = true
    self:SetGamepadIconVisibility(false)
    IsHandled = true
  end
  return IsHandled
end

function M:InitNavigation()
  self.List_Function:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Function:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Function:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Function:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Btn_EditIntro:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Btn_EditIntro:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Btn_EditIntro:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  if not self.EditIntroAuthority then
    self.Btn_EditIntro:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  end
  self.ParentWidget.Entrance_Shop:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.ParentWidget.Entrance_Shop:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.ParentWidget.Entrance_Shop:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.ParentWidget.Entrance_Visit:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.ParentWidget.Entrance_Visit:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.ParentWidget.Entrance_Visit:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:SetGamepadIconVisibility(Visable)
  self.UserActivity:SetGamepadIconVisibility(Visable)
  self.GuildInfo:SetGamepadIconVisibility(Visable)
  self.Btn_Confirm:SetGamepadIconVisibility(Visable)
  self.ParentWidget:SetGamepadIconVisibility(Visable)
  if self.Panel_Controller_Function then
    self.Panel_Controller_Function:SetVisibility(Visable and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
end

function M:OnContentFocusReceived(MyGeometry, InFocusEvent)
  self:SetAutoFocus()
  return UIUtils.Handled
end

function M:SetAutoFocus()
  local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
  if CommonDialog then
    CommonDialog:SetFocus()
  else
    self:SetFocus()
  end
  self.WidgetFocus = false
end

function M:PlayInAnim()
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/association_mainpage_in", nil, nil)
end

return M
