require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local GuildPermissionUtils = require("BluePrints.UI.WBP.Guild.Common.GuildPermissionUtils")
local EditPermissionConfig = {
  OnClickEditGuildName = "ModifyNameEmblem",
  OnClickEditGuildDeclaration = "ModifyDeclaration",
  OnClickEditGuildBanner = "ModifyNameEmblem"
}

function M:Construct()
  self.GuildModel = GuildController:GetModel()
  self.Btn_Edit:BindEventOnClicked(self, self.OnBtnEditClicked)
  self.Btn_Copy.OnClicked:Add(self, self.Copy)
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnGuildEditName then
      self:OnGuildEditNameSucceed(...)
    elseif EventId == GuildCommon.EventID.OnGuildEditDeclaration then
      self:OnGuildEditDeclarationSucceed(...)
    elseif EventId == GuildCommon.EventID.OnGuildEditLogo then
      self:OnGuildEditLogoSucceed()
      self:InitBtnEdit()
    elseif EventId == GuildCommon.EventID.OnGetGuildInfo then
      local Info = (...)
      if self.CurrGuildInfo and self.CurrGuildInfo.GuildId == Info.GuildId then
        self:GetGuildFullInfo(Info)
      end
    elseif EventId == GuildCommon.EventID.OnRpcGuildCheckName then
      self:OnRpcGuildCheckName(...)
    end
  end)
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if GameInputModeSubsystem then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self:RefreshOpInfoByInputDevice()
  self:SetEditPanelVisible(false)
  self:InitNavigation()
  self.Btn_Edit.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
  self.Controller_Copy:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    }
  })
  self.Btn_Copy.OnClicked:Add(self, self.OnBtnCopyClicked)
  self.Btn_Copy.OnHovered:Add(self, self.OnBtnCopyHovered)
  self.Btn_Copy.OnUnhovered:Add(self, self.OnBtnCopyUnhovered)
  self.Btn_Copy.OnPressed:Add(self, self.OnBtnCopyPressed)
  self:PlayAnimation(self.In)
end

function M:Destruct()
  if self.Btn_Edit and self.Btn_Edit.UnBindEventOnClicked then
    self.Btn_Edit:UnBindEventOnClicked(self, self.OnBtnEditClicked)
  end
  self.Btn_Copy.OnClicked:Clear()
  self.Btn_Copy.OnHovered:Clear()
  self.Btn_Copy.OnUnhovered:Clear()
  self.Btn_Copy.OnPressed:Clear()
  GuildController:UnRegisterEvent(self)
  if self.ExpBarTimer then
    self:RemoveTimer(self.ExpBarTimer)
    self.ExpBarTimer = nil
  end
end

function M:InitView(ParentWidget, GuildInfo, ListBtnCloseCb)
  self.CurrGuildInfo = GuildInfo
  self.ParentWidget = ParentWidget
  self.ListBtnCloseCb = ListBtnCloseCb
  self.Text_ExpDesc:SetText(GText("UI_GuildExperience"))
  local ExpNow = GuildInfo.Exp or 0
  local GuildLevelConf = DataMgr.GuildLevel[self.CurrGuildInfo.Level]
  local ExpMax = GuildLevelConf and GuildLevelConf.GuildEXP or 0
  self.Text_ExpNow:SetText(ExpNow)
  self.Text_ExpMax:SetText(ExpMax)
  local Success = self:TrySetExpBarPercent(ExpNow, ExpMax)
  if not Success then
    self.ExpBarTimer = self:AddTimer(0.1, function()
      Success = self:TrySetExpBarPercent(ExpNow, ExpMax)
      if Success then
        self:RemoveTimer(self.ExpBarTimer)
        self.ExpBarTimer = nil
      end
    end, true, 0, "ExpBarTimer", true)
  end
  self.Text_Lv:SetText(GText("UI_LEVEL_NAME"))
  self.Text_Level:SetText(tostring(self.CurrGuildInfo.Level or 0))
  self.Text_IDDesc:SetText(GText("UI_GuildID"))
  self.Text_ID:SetText(tostring(self.CurrGuildInfo.GuildId or 0))
  self.Text_NumDesc:SetText(GText("UI_GuildMemberCount"))
  self.Text_NowNum:SetText(tostring(self.CurrGuildInfo.MemberCount or 0))
  local GuildLevelConf = DataMgr.GuildLevel[self.CurrGuildInfo.Level]
  local TotalNum = GuildLevelConf and GuildLevelConf.GuildMembersNum or 0
  self.Text_TotalNum:SetText(tostring(TotalNum))
  self.Text_ActivityDesc:SetText(GText("UI_GuildActivity"))
  self.Text_Activity:SetText(tostring(self.CurrGuildInfo.ActivityLevel or 0))
  self.Btn_Edit:SetText(GText("UI_EditGuildInfo"))
  self:InitBtnEdit()
  self.Logo:Init(self.CurrGuildInfo.LogoInfo)
  GuildController:SendGetGuildInfo(self.CurrGuildInfo.GuildId)
end

function M:GetGuildFullInfo(Info)
  self.CurrGuildInfo = Info
  local ExpNow = self.CurrGuildInfo.Exp or 0
  local GuildLevelConf = DataMgr.GuildLevel[self.CurrGuildInfo.Level]
  local ExpMax = GuildLevelConf and GuildLevelConf.GuildEXP or 0
  self.Text_ExpNow:SetText(ExpNow)
  self.Text_ExpMax:SetText(ExpMax)
  local Success = self:TrySetExpBarPercent(ExpNow, ExpMax)
  if not Success then
    self.ExpBarTimer = self:AddTimer(0.1, function()
      Success = self:TrySetExpBarPercent(ExpNow, ExpMax)
      if Success then
        self:RemoveTimer(self.ExpBarTimer)
        self.ExpBarTimer = nil
      end
    end, true, 0, "ExpBarTimer", true)
  end
  self.Text_Level:SetText(tostring(self.CurrGuildInfo.Level or 0))
  self.Text_ID:SetText(tostring(self.CurrGuildInfo.GuildId or 0))
  self.Text_NowNum:SetText(tostring(self.CurrGuildInfo.MemberCount or 0))
  local GuildLevelConf = DataMgr.GuildLevel[self.CurrGuildInfo.Level]
  local TotalNum = GuildLevelConf and GuildLevelConf.GuildMembersNum or 0
  self.Text_TotalNum:SetText(tostring(TotalNum))
  self.Text_Activity:SetText(tostring(self.CurrGuildInfo.ActivityLevel or 0))
  self.Logo:Init(self.CurrGuildInfo.LogoInfo)
  self:InitBtnEdit()
end

function M:InitBtnEdit()
  local Avatar = GWorld:GetAvatar()
  local MemberInfo = GuildController:GetModel():GetCurrMember(Avatar.Uid)
  if MemberInfo.Title and MemberInfo.Title <= 2 then
    self.Btn_Edit:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.Btn_Edit:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self:InitEditList()
end

function M:OnBtnEditClicked()
  if not self.CurrGuildInfo then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_EditGuildInfo")
    return
  end
  self:SetEditPanelVisible(not self.IsEditOpen)
end

function M:TrySetExpBarPercent(ExpNow, ExpMax)
  ExpNow = self.CurrGuildInfo.Exp or ExpNow
  local GuildLevelConf = DataMgr.GuildLevel[self.CurrGuildInfo.Level]
  ExpMax = GuildLevelConf and GuildLevelConf.GuildEXP or ExpMax
  local Length = USlateBlueprintLibrary.GetLocalSize(self.Bg_Exp:GetCachedGeometry()).X
  local Percent = ExpMax > 0 and ExpNow / ExpMax or 0
  if Percent > 1 then
    Percent = 1
  end
  if Length <= 0 then
    return false
  end
  local Exp_Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bg_Exp)
  local Exp_Slot2 = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bar_Exp)
  if Exp_Slot and Exp_Slot2 then
    local NewOffset = Exp_Slot2:GetOffsets()
    NewOffset.Right = Length * (1 - Percent)
    Exp_Slot2:SetOffsets(NewOffset)
  end
  return true
end

function M:InitEditList()
  if not (self.List_Edit and self.List_Edit.ClearListItems) or not self.List_Edit.AddItem then
    return
  end
  for _, Content in pairs(self.List_Edit:GetListItems()) do
    if Content and Content.SelfWidget then
      Content.SelfWidget:UnBindEventOnClickedByObj(Content.ParentWidget)
    end
  end
  self.List_Edit:ClearListItems()
  local ListConfig = {
    {
      Text = "UI_EditGuildName",
      OnClickFunction = "OnClickEditGuildName",
      PermissionField = "ModifyNameEmblem"
    },
    {
      Text = "UI_EditGuildDeclaration",
      OnClickFunction = "OnClickEditGuildDeclaration",
      PermissionField = "ModifyDeclaration"
    },
    {
      Text = "UI_EditGuildBanner",
      OnClickFunction = "OnClickEditGuildBanner",
      PermissionField = "ModifyNameEmblem"
    }
  }
  local NameCooldownDaysLeft = self:GetGuildNameCooldownDaysLeft(self.CurrGuildInfo)
  local LogoCooldownDaysLeft = self:GetGuildLogoCooldownDaysLeft(self.CurrGuildInfo)
  for i = 1, #ListConfig do
    local MenuContent = NewObject(UIUtils.GetCommonItemContentClass())
    local ItemConfig = ListConfig[i]
    MenuContent.Id = i
    MenuContent.Text = ItemConfig.Text
    MenuContent.ParentWidget = self
    MenuContent.FunctionName = ItemConfig.OnClickFunction
    MenuContent.IsForbid = ItemConfig.Text == "UI_EditGuildName" and NameCooldownDaysLeft > 0 or ItemConfig.Text == "UI_EditGuildBanner" and LogoCooldownDaysLeft > 0 or self:HasEditPermission(ItemConfig.PermissionField) == false
    MenuContent.bGamepadIconVisible = false
    
    function MenuContent.OnClickFunction()
      self:OnListBtnClicked(MenuContent)
    end
    
    function MenuContent.OnForbiddenClickFunction()
      self:OnListBtnForbiddenClicked(MenuContent)
    end
    
    self.List_Edit:AddItem(MenuContent)
  end
end

function M:SetEditPanelVisible(bShow)
  self.IsEditOpen = true == bShow
  if not self.Panel_Edit then
    return
  end
  if self.IsEditOpen then
    self.Panel_Edit:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Panel_Edit:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:HasEditPermission(PermissionField)
  if string.isempty(PermissionField) then
    return true
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local MemberInfo = GuildController:GetModel():GetCurrMember(Avatar.Uid)
  local IsPermitted = GuildPermissionUtils.GetEffectivePermission(self.CurrGuildInfo.ClosedPermission, MemberInfo.Title, PermissionField)
  if "ModifyDeclaration" == PermissionField then
    self.ParentWidget:RefreshEditIntroAuthority(IsPermitted)
  end
  return IsPermitted
end

function M:OnListBtnClicked(Content)
  if not Content or not Content.FunctionName then
    return
  end
  if not self:HasEditPermission(Content.PermissionField or EditPermissionConfig[Content.FunctionName]) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_NoEditPermission"))
    return
  end
  if self[Content.FunctionName] then
    self[Content.FunctionName](self)
  end
end

function M:OnListBtnForbiddenClicked(Content)
  if not Content or not Content.FunctionName then
    return
  end
  if Content.FunctionName == "OnClickEditGuildName" then
    if self:HasEditPermission(EditPermissionConfig[Content.FunctionName]) == false then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_NoEditPermission"))
    else
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(GText("UI_GuildNameChangeCooldown"), tostring(DataMgr.GlobalConstant.GuildNameEditCoolDownDay.ConstantValue or 7)))
    end
  elseif Content.FunctionName == "OnClickEditGuildDeclaration" then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_NoEditPermission"))
  elseif Content.FunctionName == "OnClickEditGuildBanner" then
    if self:HasEditPermission(EditPermissionConfig[Content.FunctionName]) == false then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_NoEditPermission"))
    else
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(GText("GuildLogaChangeCD"), tostring(DataMgr.GlobalConstant.GuildLogoEditCoolDownDay and DataMgr.GlobalConstant.GuildLogoEditCoolDownDay.ConstantValue or 3)))
    end
  end
  return
end

function M:OnClickEditGuildName()
  self:OpenEditGuildNameDialog()
end

function M:OnClickEditGuildDeclaration()
  self:OpenEditGuildDeclarationDialog()
end

function M:OnClickEditGuildBanner()
  GuildController:GetModel():SetGuildEditLogoInfo(self.CurrGuildInfo.LogoInfo)
  GuildController:OpenGuildEditView({
    Func = self.ChangeGuildLogo,
    Obj = self
  })
end

function M:ChangeGuildLogo()
  local GuildLogoInfo = GuildController:GetModel():GetGuildEditLogoInfo()
  GuildController:SendGuildEditLogo(GuildLogoInfo)
end

function M:OnRpcGuildCheckName(SameName)
  self.GuildHasSameName = SameName
  self.IsCheckingName = false
  local CommonDialog = UIManager(self):GetUI("CommonDialog")
  if CommonDialog then
    CommonDialog:OnRightBtnClicked()
  end
end

function M:OnGuildEditNameSucceed(Ret)
  if Ret and Ret ~= ErrorCode.RET_SUCCESS then
    return
  end
  local GuildData = GuildController:GetModel():GetCurrGuild()
  if not GuildData then
    return
  end
  self.CurrGuildInfo = GuildData
  if self.ParentWidget then
    self.ParentWidget.CurrGuildInfo = GuildData
    if self.ParentWidget.Text_GuildName and self.ParentWidget.Text_GuildName.SetText then
      self.ParentWidget.Text_GuildName:SetText(GText(GuildData.Name or ""))
    end
  end
  self:InitEditList()
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_EditSuccessful"))
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
  if self.ParentWidget then
    self.ParentWidget.CurrGuildInfo = GuildData
    if self.ParentWidget.Text_Intro and self.ParentWidget.Text_Intro.SetText then
      self.ParentWidget.Text_Intro:SetText(GText(GuildData.Declaration or ""))
    end
  end
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_EditSuccessful"))
end

function M:OnGuildEditLogoSucceed(Ret)
  self.CurrGuildInfo = GuildController:GetModel():GetCurrGuild()
  self.Logo:Init(self.CurrGuildInfo.LogoInfo)
  self:InitEditList()
end

function M:GetGuildNameCooldownDaysLeft(GuildInfo)
  if not GuildInfo then
    GuildInfo = GuildController:GetModel():GetCurrGuild()
    if not GuildInfo then
      return 0
    end
  end
  local LastNameEditTime = tonumber(GuildInfo.LastNameEditTime) or 0
  if LastNameEditTime <= 0 then
    return 0
  end
  if LastNameEditTime > 9999999999 then
    LastNameEditTime = math.floor(LastNameEditTime / 1000)
  end
  local CooldownDay = DataMgr.GlobalConstant.GuildNameEditCoolDownDay.ConstantValue or 7
  local CooldownSeconds = CooldownDay * 24 * 60 * 60
  local NowTime = TimeUtils and TimeUtils.NowTime and TimeUtils.NowTime() or os.time()
  local RemainSeconds = LastNameEditTime + CooldownSeconds - NowTime
  if RemainSeconds <= 0 then
    return 0
  end
  return math.ceil(RemainSeconds / 86400)
end

function M:GetGuildLogoCooldownDaysLeft(GuildInfo)
  if not GuildInfo then
    GuildInfo = GuildController:GetModel():GetCurrGuild()
    if not GuildInfo then
      return 0
    end
  end
  local LastLogoEditTime = tonumber(GuildInfo.LastLogoEditTime) or 0
  if LastLogoEditTime <= 0 then
    return 0
  end
  if LastLogoEditTime > 9999999999 then
    LastLogoEditTime = math.floor(LastLogoEditTime / 1000)
  end
  local CooldownDay = DataMgr.GlobalConstant.GuildLogoEditCoolDownDay and DataMgr.GlobalConstant.GuildLogoEditCoolDownDay.ConstantValue or 3
  local CooldownSeconds = CooldownDay * 24 * 60 * 60
  local NowTime = TimeUtils and TimeUtils.NowTime and TimeUtils.NowTime() or os.time()
  local RemainSeconds = LastLogoEditTime + CooldownSeconds - NowTime
  if RemainSeconds <= 0 then
    return 0
  end
  return math.ceil(RemainSeconds / 86400)
end

function M:OpenEditGuildNameDialog()
  local GuildInfo = self.CurrGuildInfo
  if not GuildInfo then
    return
  end
  self.NeedCheckName = true
  self.GuildNameEditDialog = UIManager(self):ShowCommonPopupUI(100362, {
    EditTextConfig = {
      Text = "",
      IsMultiLine = false,
      Owner = self,
      TextLimit = GuildCommon.GuildNameMaxLen,
      bLimitSpaces = true,
      bNotAllowEmpty = true,
      ResidentTipText = string.format(GText("UI_GuildNameChangeCooldown"), tostring(DataMgr.GlobalConstant.GuildNameEditCoolDownDay.ConstantValue or 7)),
      Events = {
        OnTextChanged = function(self, Text)
          if " " == Text then
            self.GuildNameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(true)
          else
            self.GuildNameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(false)
          end
        end
      },
      bNeedCheckStringSensitive = true,
      OnCheckStringSensitive = function(_, bSuccess, Name)
        if bSuccess then
          Name = Name or ""
          if "" ~= Name then
            local SubmitName = string.gsub(Name or "", "^%s*(.-)%s*$", "%1")
            GuildController:SendGuildEditName(SubmitName)
          else
          end
        end
      end
    },
    DialogRightBtnCallback = function(Text)
      local SubmitText = string.gsub(Text or "", "^%s*(.-)%s*$", "%1")
      local InputWidget = self.GuildNameEditDialog.ContentWidgetTable.Dialog_Input_new
      if InputWidget and self:IsGuildNamePureNumberOrSymbol(SubmitText) then
        InputWidget:ShowTips(GText("GuildNameNoPureNumber"), 1)
        return false
      end
      if self.IsCheckingName then
        return false
      end
      if self.NeedCheckName then
        self.NeedCheckName = false
        self.GuildHasSameName = false
        self.IsCheckingName = true
        GuildController:SendRpcGuildCheckName(SubmitText)
        return false
      end
      if self.GuildHasSameName then
        InputWidget:ShowTips(GText("UI_GuildNameDuplicate"), 1)
        self.NeedCheckName = true
        return false
      else
        return true
      end
    end,
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = function()
      self.ParentWidget:RefreshOpInfoByInputDevice()
    end
  }, self)
end

function M:OpenEditGuildDeclarationDialog()
  if not self.CurrGuildInfo then
    return
  end
  self.GuildDeclarationEditDialog = UIManager(self):ShowCommonPopupUI(100363, {
    DefaultText = self.CurrGuildInfo.Declaration or "",
    MultilineType = 0,
    IsMultiLine = true,
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
    },
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = function()
      self.ParentWidget:RefreshOpInfoByInputDevice()
    end
  }, self)
end

function M:IsGuildNamePureNumberOrSymbol(Name)
  local TrimName = string.gsub(Name or "", "^%s*(.-)%s*$", "%1")
  if "" == TrimName then
    return false
  end
  if string.find(TrimName, "%a") then
    return false
  end
  for i = 1, #TrimName do
    local Byte = string.byte(TrimName, i)
    if Byte and Byte >= 128 then
      return false
    end
  end
  return true
end

function M:Copy()
  UE.UUIFunctionLibrary.ClipboardCopy(self.Text_ID:GetText())
  UIManager(self):ShowUITip("CommonToastMain", GText("UI_GuildIDCopied"))
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if UIUtils.IsGamepadInput() then
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
end

function M:InitGamepadView()
  self.WS_Controller_Copy:SetActiveWidgetIndex(1)
end

function M:InitKeyboardView()
  self.WS_Controller_Copy:SetActiveWidgetIndex(0)
end

function M:SetGamepadIconVisibility(Visable)
  if Visable then
    self.WS_Controller_Copy:SetActiveWidgetIndex(1)
    self.Btn_Edit:SetGamepadIconVisibility(true)
  else
    self.WS_Controller_Copy:SetActiveWidgetIndex(0)
    self.Btn_Edit:SetGamepadIconVisibility(false)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  if self.Panel_Edit:IsVisible() and self.ListBtnCloseCb then
    self.ListBtnCloseCb(self.ParentWidget)
  end
  self:SetEditPanelVisible(false)
end

function M:OnBtnCopyClicked()
  self:PlayAnimation(self.Copy_Click)
end

function M:OnBtnCopyHovered()
  self:PlayAnimation(self.Copy_Hover)
end

function M:OnBtnCopyUnhovered()
  self:PlayAnimation(self.Copy_UnHover)
end

function M:OnBtnCopyPressed()
  self:PlayAnimation(self.Copy_Press)
end

function M:InitNavigation()
  self.List_Edit:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Edit:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Edit:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Edit:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

return M
