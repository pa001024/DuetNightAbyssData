require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  GuildController:GetModel():SetGuildEditLogoInfo()
  self.Logo:Init(GuildController:GetModel():GetGuildEditLogoInfo())
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnCreateGuild then
      self:CreateGuildSuccessful()
    end
  end)
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnGuildCreateNameDuplicate then
      local Text = ErrorCode:GetText(ErrorCode.RET_GUILD_CREATE_NAME_DUPLICATE)
      AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
      self.Input_Name:ShowTips(Text, 1, 2)
    end
  end)
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnGuildCreateNameInvalid then
      local Text = ErrorCode:GetText(ErrorCode.RET_GUILD_CREATE_NAME_INVALID)
      AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
      self.Input_Name:ShowTips(Text, 1, 2)
    end
  end)
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnGuildCreateDescInvalid then
      local Text = ErrorCode:GetText(ErrorCode.RET_GUILD_CREATE_DECL_INVALID)
      AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
      self.Input_Intro:ShowTips(Text, 1, 2)
    end
  end)
  self.Btn_Edit:SetGamePadImg("X")
  self.Btn_Edit:SetText(GText("UI_EditGuildBanner"))
  self.Btn_Edit:BindEventOnClicked(self, self.OpenEditLogoView)
  self.Text_Name:SetText(GText("UI_GuildName"))
  self.Input_Name:Init({
    bNeedPasteBtn = false,
    Owner = self,
    Events = {
      OnTextChanged = function(Owner, Text)
        local GuildName = self.Input_Name:GetText()
        local GuildIntro = self.Input_Intro:GetText()
        if "" == GuildName or "" == GuildIntro then
          self.Btn_Create:SetState(false)
        else
          self.Btn_Create:SetState(true)
        end
      end,
      OnTextLengthExceedLimit = function(Owner, Text)
        AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
      end
    },
    TextLimit = GuildCommon.GuildNameMaxLen,
    bLimitSpaces = true,
    FocusKeyName = "A",
    PasteKeyName = "RS",
    FocusKey = UIConst.GamePadImgKey.FaceButtonRight,
    BackFocusWidget = self
  })
  self.Text_Intro:SetText(GText("UI_GuildDeclaration"))
  self.Input_Intro:Init({
    bNeedPasteBtn = false,
    Owner = self,
    Events = {
      OnTextChanged = function(Owner, Text)
        local GuildName = self.Input_Name:GetText()
        local GuildIntro = self.Input_Intro:GetText()
        if "" == GuildName or "" == GuildIntro then
          self.Btn_Create:SetState(false)
        else
          self.Btn_Create:SetState(true)
        end
      end,
      OnTextLengthExceedLimit = function(Owner, Text)
        AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
      end
    },
    TextLimit = GuildCommon.GuildDeclMaxLen,
    FocusKeyName = "A",
    PasteKeyName = "RS",
    FocusKey = UIConst.GamePadImgKey.FaceButtonRight,
    BackFocusWidget = self
  })
  self.Text_Apply:SetText(GText("UI_JoinMethod"))
  self.CheckBox_Manual:BindEventOnClicked({
    Inst = self,
    Func = self.OnCheckBoxManualClick
  })
  self.CheckBox_Auto:BindEventOnClicked({
    Inst = self,
    Func = self.OnCheckBoxAutoClick
  })
  self.Btn_Create:SetData()
  self.Btn_Create:SetClickCallback({
    Obj = self,
    Func = self.CreateConfirm
  })
  self.Btn_Create:SetState(false)
  self.Text_Manual:SetText(GText("UI_ManualApproval"))
  self.Text_Auto:SetText(GText("UI_AutoApproval"))
  self.CheckBox_Manual:SetIsCheckedWithoutCallback(true)
  self.CheckBox_Auto:SetIsCheckedWithoutCallback(false)
  self.Input_Name.Text_Input:SetNavigationRuleExplicit(EUINavigation.Down, self.Input_Intro.Text_Input)
  self.Input_Intro.Text_Input:SetNavigationRuleExplicit(EUINavigation.Up, self.Input_Name.Text_Input)
  self.Input_Intro.Text_Input:SetNavigationRuleExplicit(EUINavigation.Down, self.CheckBox_Manual)
  self.CheckBox_Manual:SetNavigationRuleExplicit(EUINavigation.Up, self.Input_Intro.Text_Input)
  self.CheckBox_Manual:SetNavigationRuleExplicit(EUINavigation.Right, self.CheckBox_Auto)
  self.CheckBox_Auto:SetNavigationRuleExplicit(EUINavigation.Left, self.CheckBox_Manual)
  self.Btn_Create.Icon_Piece.ItemDetails_MenuAnchor:SetLastFocusWidget(self.Input_Name.Text_Input)
  self.CheckBox_Manual:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.CheckBox_Auto:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:OnCheckBoxManualClick(IsChecked)
  self.CheckBox_Auto:SetIsCheckedWithoutCallback(not IsChecked)
end

function M:OnCheckBoxAutoClick(IsChecked)
  self.CheckBox_Manual:SetIsCheckedWithoutCallback(not IsChecked)
end

function M:Destruct()
  GuildController:UnRegisterEvent(self)
end

function M:OpenEditLogoView()
  GuildController:OpenGuildEditView()
end

function M:CreateConfirm()
  AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_mid", nil, nil)
  if not self.Btn_Create.IsEnough then
    local ResourceName = GText(DataMgr.Resource[GuildCommon.GuildCreateItemId].ResourceName)
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonToast, string.format(GText("UI_ItemInsufficient"), ResourceName))
    return
  end
  local GuildName = self.Input_Name:GetText()
  local GuildIntro = self.Input_Intro:GetText()
  if "" == GuildName then
    AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
    self.Input_Name:ShowTips(GText("GuildCreateFillName"), 2, 2)
    return
  end
  if "" == GuildIntro then
    AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
    self.Input_Intro:ShowTips(GText("GuildCreateFillDecl"), 2, 2)
    return
  end
  if self:IsAllDigits(GuildName) then
    AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
    self.Input_Name:ShowTips(GText("GuildNameNoPureNumber"), 1, 2)
    return
  end
  local Params = {
    RightCallbackFunction = function()
      local GuildLogoInfo = GuildController:GetModel():GetGuildEditLogoInfo()
      GuildController:SendCreateGuild(GuildName, GuildIntro, self.CheckBox_Auto:IsChecked(), GuildLogoInfo)
    end,
    ShortText = string.format(GText("UI_ConfirmGuildCreation"), GuildName)
  }
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowCommonPopupUI(GuildCommon.GuildComfirmDialog, Params)
end

function M:IsAllDigits(str)
  return nil ~= str and nil ~= str:match("^%d+$")
end

function M:CreateGuildSuccessful()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildCreated"))
end

function M:RefreshGuildLogo()
  self.Logo:Init(GuildController:GetModel():GetGuildEditLogoInfo())
end

function M:SetData()
  self:PlayAnimation(self.In)
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self:OpenEditLogoView()
    IsHandled = true
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    if self.Input_Name.Text_Input:HasAnyUserFocus() then
      if self.Input_Name:GetText() ~= "" then
        self.Input_Name:DeleteText()
      end
      IsHandled = true
    elseif self.Input_Intro.Text_Input:HasAnyUserFocus() then
      if "" ~= self.Input_Intro:GetText() then
        self.Input_Intro:DeleteText()
      end
      IsHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.LeftThumb then
    self.Btn_Create:OnResourceClick()
    IsHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:CreateConfirm()
    IsHandled = true
  end
  return IsHandled
end

function M:OnContentKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if InKeyName == UIConst.GamePadKey.SpecialRight then
  end
  return IsHandled
end

function M:SetDefaultFocus()
  if UIUtils.IsGamepadInput() then
    self.Input_Name:SetFocus()
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UIUtils.Handled
end

function M:UpdateBtnCreate()
  self.Btn_Create:UpdatePrice()
  local GuildName = self.Input_Name:GetText()
  local GuildIntro = self.Input_Intro:GetText()
  if "" == GuildName or "" == GuildIntro then
    self.Btn_Create:SetState(false)
  else
    self.Btn_Create:SetState(true)
  end
end

return M
