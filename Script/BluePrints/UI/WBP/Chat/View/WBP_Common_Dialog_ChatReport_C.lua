require("UnLua")
local StringUtils = require("Utils.StringUtils")
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")
local FriendCommon = require("BluePrints.UI.WBP.Friend.FriendCommon")
local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local IllegalPhotoReportTypeIndex = 9
local NegativeAttitudeReportTypeIndex = 10
local WBP_Common_Dialog_ChatReport_C = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function WBP_Common_Dialog_ChatReport_C:Construct()
  WBP_Common_Dialog_ChatReport_C.Super.Construct(self)
  self.bTipsShowed = false
  self.TipsText = ""
  self.CheckedTypes = {}
  self.bIllegalPhotoChecked = false
  self.bNegativeAttitudeChecked = false
end

function WBP_Common_Dialog_ChatReport_C:Destruct()
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if IsValid(GameInputModeSubsystem) then
      GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
  end
end

function WBP_Common_Dialog_ChatReport_C:OnTabSelected(TabWidget, TabData)
  if TabData and TabData.TabId then
    self.CurrTabId = TabData.TabId
    self.CheckedTypes = {}
    self.bIllegalPhotoChecked = false
    self.bNegativeAttitudeChecked = false
    self:RefreshForbidBtn(true, nil)
    if self.List_Report and self.List_Report.HardRebuild then
      self.List_Report:HardRebuild(false)
    end
    self:UpdateReportList(TabData.TabId)
    self.List_Report:SetFocus()
    self.List_Report:NavigateToIndex(0)
  end
end

function WBP_Common_Dialog_ChatReport_C:UpdateReportList(TabId)
  self.List_Report:ClearListItems()
  if self.List_Report.ResetEntryWidgetPool then
    self.List_Report:ResetEntryWidgetPool()
  end
  for Id, value in pairs(DataMgr.ChatReportType) do
    if value.TabId == TabId and self:ShouldShowReportType(value, self.Params) then
      local Obj = NewObject(UIUtils.GetCommonItemContentClass())
      Obj.Owner = self
      Obj.Id = Id
      Obj.value = value
      self.List_Report:AddItem(Obj)
    end
  end
  if self.List_Report.RegenerateAllEntries then
    self.List_Report:RegenerateAllEntries()
  end
  self.List_Report:NavigateToIndex(0)
end

function WBP_Common_Dialog_ChatReport_C:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  self.ChatMessage = Params.ChatMessage
  if self.ChatMessage == nil then
    self.ChatMessage = {
      Content = "无消息举报",
      Sender = {
        Uid = Params.RealUID or Params.UID
      }
    }
  end
  self.Owner = Owner
  self.Params = Params
  self.Owner:GetButtonBar().Btn_Yes:BindEventOnReleased(self, self.OnBtnYes)
  self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(true)
  self.Owner:GetButtonBar().Btn_Quit:BindEventOnReleased(self, self.OnBtnNo)
  self.Text_Title:SetText(string.format("%s: ", GText("UI_COMMONPOP_TEXT_100090_1")))
  self.Text_PlayerName:SetText(string.format("%s ", Params.Nickname))
  self.Text_PlayerUID:SetText(string.format(" UID%s", Params.UID))
  self.Text_ReportTypeTitle:SetText(GText("UI_COMMONPOP_TEXT_100090_2"))
  local InDungeon = GWorld:GetAvatar():IsInDungeon()
  local TabConfig = {
    Tabs = {}
  }
  table.insert(TabConfig.Tabs, {
    Text = GText("UI_Report_Tab1"),
    TabId = 1
  })
  table.insert(TabConfig.Tabs, {
    Text = GText("UI_Report_Tab2"),
    TabId = 2
  })
  table.insert(TabConfig.Tabs, {
    Text = GText("UI_Report_Tab3"),
    TabId = 3
  })
  self._TabIds = {}
  for _, t in ipairs(TabConfig.Tabs) do
    table.insert(self._TabIds, t.TabId)
  end
  self.ComTab:Init(TabConfig)
  self.ComTab:BindEventOnTabSelected(self, self.OnTabSelected)
  if Params.InGameOnly then
    self.ComTab:SelectTab(3)
    self.ComTab:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.ComTab:SelectTab(1)
  end
  self.Text_ReportDescTitle:SetText(GText("UI_COMMONPOP_TEXT_100090_11"))
  Params.OwnerDialog = Owner
  local EditTextConfig = Params.EditTextConfig or {}
  EditTextConfig.Events = EditTextConfig.Events or {}
  if not EditTextConfig.Events.OnTextChanged then
    function EditTextConfig.Events.OnTextChanged(Owner, InText)
      self:RefreshForbidBtn(nil, InText)
    end
  end
  self.Com_Input_Multiline_Light:Init(EditTextConfig, Params)
  self.Btn_Yes = self.Owner:GetButtonBar().Btn_Yes
  self.Btn_Yes:SetGamePadImg("Y")
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if IsValid(GameInputModeSubsystem) then
      GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
      self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType(), GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self.GamepadAKeyIndex = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = self
        }
      },
      Desc = GText("UI_CTL_Select"),
      bLongPress = false
    })
    self.Com_Input_Multiline_Light:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.Com_Input_Multiline_Light:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  end
  self:AutoSelectReportType(Params)
  self.Owner:BroadcastDialogEvent(DialogEvent.HideDialogItem, {
    bHideDialogItem = false,
    DialogItemIndex = 3,
    bShouldPlayAnim = false
  })
  self.Owner:BroadcastDialogEvent(DialogEvent.HideDialogItem, {
    bHideDialogItem = true,
    DialogItemIndex = 1,
    bShouldPlayAnim = false
  })
  self.Owner:BroadcastDialogEvent(DialogEvent.HideDialogItem, {
    bHideDialogItem = true,
    DialogItemIndex = 2,
    bShouldPlayAnim = false
  })
  self.TipVisible = {
    [1] = false,
    [2] = false,
    [3] = true
  }
  self.Owner:AddEventListener(DialogEvent.HideDialogItem, self, self.OnDialogTipVisibilityChange)
end

function WBP_Common_Dialog_ChatReport_C:ShouldShowReportType(Data, Params)
  if Params and Params.HiddenReportIndices then
    for _, HiddenIndex in ipairs(Params.HiddenReportIndices) do
      if HiddenIndex == Data.Index then
        return false
      end
    end
  end
  if 2 == Data.TypeId then
    return Params and Params.AllowNegativeAttitude == true
  end
  return true
end

function WBP_Common_Dialog_ChatReport_C:AutoSelectReportType(Params)
  if Params.isPhotoReport then
    self.bPendingAutoSelect = true
    self.List_Report.BP_OnEntryInitialized:Add(self, self.OnReportEntryInitialized)
  end
end

function WBP_Common_Dialog_ChatReport_C:OnReportEntryInitialized(Content, EntryWidget)
  if self.bPendingAutoSelect and Content and Content.value and 1 == Content.value.TypeId then
    self.bPendingAutoSelect = false
    self.List_Report.BP_OnEntryInitialized:Remove(self, self.OnReportEntryInitialized)
    self:AddTimer(0, function()
      if IsValid(EntryWidget) and EntryWidget.WBP_Com_CheckBox_RightText then
        EntryWidget.WBP_Com_CheckBox_RightText:SetIsChecked(true, false)
        EntryWidget:OnItemSelectionChanged()
      end
    end, false, 0, self.AutoSelectReportTypeTimerKey)
  end
end

function WBP_Common_Dialog_ChatReport_C:OnTextComposing()
  if self.bTipsShowed then
    self.Owner:HideDialogTip(2, false)
    self.bTipsShowed = false
  end
end

function WBP_Common_Dialog_ChatReport_C:OnCheckTextLegality(InText)
end

function WBP_Common_Dialog_ChatReport_C:OnTextChange(InText)
  if self.Com_Input_Multiline_Light:Utf8StrLen(InText) >= self.Com_Input_Multiline_Light.TextLimit then
    self:ShowTips(InText, 1, 1.5)
  end
end

function WBP_Common_Dialog_ChatReport_C:OnDialogTipVisibilityChange(Params)
  if not Params then
    return
  end
  local Index = Params.DialogItemIndex
  local IsShow = not Params.bHideDialogItem
  if 1 == Index or 2 == Index then
    self.TipVisible = self.TipVisible or {}
    self.TipVisible[Index] = IsShow
    if IsShow then
      self.Owner:HideDialogTip(3, false)
    else
      local Tip1 = self.TipVisible[1]
      local Tip2 = self.TipVisible[2]
      if not Tip1 and not Tip2 then
        self.Owner:BroadcastDialogEvent(DialogEvent.HideDialogItem, {
          bHideDialogItem = false,
          DialogItemIndex = 3,
          bShouldPlayAnim = false
        })
      end
    end
  end
end

function WBP_Common_Dialog_ChatReport_C:OnChatItemChange(CheckState, Obj)
  if CheckState then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
    self:AddSelection(Obj)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    self:RemoveSelection(Obj)
  end
end

function WBP_Common_Dialog_ChatReport_C:AddSelection(Obj)
  if not self.CheckedTypes[Obj.Id] then
    self.CheckedTypes[Obj.Id] = true
  end
  self:RefreshForbidBtn(false, nil)
end

function WBP_Common_Dialog_ChatReport_C:RemoveSelection(Obj)
  if self.CheckedTypes[Obj.Id] then
    self.CheckedTypes[Obj.Id] = nil
  end
  if self:_isDictionaryEmpty(self.CheckedTypes) then
    self:RefreshForbidBtn(true, nil)
  end
end

function WBP_Common_Dialog_ChatReport_C:RefreshForbidBtn(IsEmptyChecked, InText)
  if nil == IsEmptyChecked then
    IsEmptyChecked = self:_isDictionaryEmpty(self.CheckedTypes)
  end
  if nil == InText then
    InText = self.Com_Input_Multiline_Light:GetText()
  end
  local IsForbidBtn = IsEmptyChecked
  self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(IsForbidBtn)
  self.Owner.ForbidRightBtn = IsForbidBtn
end

function WBP_Common_Dialog_ChatReport_C:_isDictionaryEmpty(dict)
  for _ in pairs(dict) do
    return false
  end
  return true
end

function WBP_Common_Dialog_ChatReport_C:GetCheckedTypes(CheckedTypes)
  local CheckedTypesStr = {}
  for Index, _ in pairs(CheckedTypes) do
    local TypeIndex = tonumber(Index)
    local TypeData = DataMgr.ChatReportType[TypeIndex]
    if TypeData and 1 == TypeData.TypeId then
      self.bIllegalPhotoChecked = true
      goto lbl_36
    elseif TypeData and 2 == TypeData.TypeId then
      self.bNegativeAttitudeChecked = true
      goto lbl_36
    end
    local TypeId = TypeData and TypeData.Id
    table.insert(CheckedTypesStr, TypeId)
    ::lbl_36::
  end
  return table.concat(CheckedTypesStr, "&")
end

function WBP_Common_Dialog_ChatReport_C:OnBtnYes()
  if self.Owner.ForbidRightBtn then
    UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Chat_Report_None"))
    return
  end
  local reportDesc = self.Com_Input_Multiline_Light:GetText()
  local CheckedTypesStr = self:GetCheckedTypes(self.CheckedTypes)
  local BannedHint = GText("UI_REGISTER_BANNEDINPUT")
  
  local function DoSubmitReport(ValidText)
    reportDesc = ValidText
    local SenderData
    if self.ChatMessage.Sender.all_dump then
      SenderData = self.ChatMessage.Sender:all_dump(self.ChatMessage.Sender)
    else
      SenderData = self.ChatMessage.Sender
    end
    local Msg = {
      Content = self.ChatMessage.Content,
      Sender = SenderData
    }
    
    local function InCallBack(Ret)
      self:BlockAllUIInput(false)
    end
    
    local Package = self.Owner:PackageResult()
    local IsBlackSelected = Package and Package.SelectHint and Package.SelectHint.IsSelected
    if IsBlackSelected then
      local TargetUid = FriendController:GetSocialUid(self.Params.UID, self.Params)
      local AvatarInfo = {
        Uid = TargetUid,
        RealUID = self.Params.RealUID,
        Nickname = self.Params.Nickname,
        HeadIconId = self.Params.HeadIconId,
        HeadFrameId = self.Params.HeadFrameId,
        Level = self.Params.Level
      }
      local PopupId = FriendCommon.PullBlackDialog or 100328
      local PullBlackPopupUI
      PullBlackPopupUI = UIManager(self):ShowCommonPopupUI_Suspend(PopupId, {
        SuspendAutoResume = true,
        RightCallbackFunction = function()
          PullBlackPopupUI.SuspendAutoResume = false
          DebugPrint("ReportSubmit Confirmed: types=" .. tostring(CheckedTypesStr) .. " desc=" .. tostring(reportDesc) .. " photo=" .. tostring(self.bIllegalPhotoChecked) .. " negative=" .. tostring(self.bNegativeAttitudeChecked))
          DebugPrintTable(self.CheckedTypes)
          self:BlockAllUIInput(true)
          FriendController:SendAddBlackList(TargetUid, AvatarInfo)
          if "" ~= CheckedTypesStr then
            GWorld:GetAvatar():ReportChat(CheckedTypesStr, reportDesc, Msg, InCallBack)
          end
          if self.bIllegalPhotoChecked then
            GWorld:GetAvatar():ReportPhoto(TargetUid, self.Params.Nickname, self.Params.Level, self.Params.PictureUniqueId, self.Params.Url, reportDesc, InCallBack)
          end
          if self.bNegativeAttitudeChecked then
            GWorld:GetAvatar():ReportMatch(TargetUid, self.Params.Nickname, self.Params.Level, reportDesc, InCallBack)
          end
          self.Owner.DontCloseWhenRightBtnClicked = false
        end,
        LeftCallbackFunction = function()
          PullBlackPopupUI.SuspendAutoResume = true
        end
      }, self.Owner)
    else
      local TargetUid = FriendController:GetSocialUid(self.Params.UID, self.Params)
      DebugPrint("ReportSubmit: types=" .. tostring(CheckedTypesStr) .. " desc=" .. tostring(reportDesc) .. " photo=" .. tostring(self.bIllegalPhotoChecked) .. " negative=" .. tostring(self.bNegativeAttitudeChecked))
      DebugPrintTable(self.CheckedTypes)
      self:BlockAllUIInput(true)
      if "" ~= CheckedTypesStr then
        GWorld:GetAvatar():ReportChat(CheckedTypesStr, reportDesc, Msg, InCallBack)
      end
      if self.bIllegalPhotoChecked then
        GWorld:GetAvatar():ReportPhoto(TargetUid, self.Params.Nickname, self.Params.Level, self.Params.PictureUniqueId, self.Params.Url, reportDesc, InCallBack)
      end
      if self.bNegativeAttitudeChecked then
        GWorld:GetAvatar():ReportMatch(TargetUid, self.Params.Nickname, self.Params.Level, reportDesc, InCallBack)
      end
      self.Owner.DontCloseWhenRightBtnClicked = false
      self.Owner:OnClose()
    end
  end
  
  local TrimmedDesc = string.gsub(reportDesc, "%s", "")
  if "" == TrimmedDesc then
    DoSubmitReport(reportDesc)
  else
    ChatController:CheckTextValid(reportDesc, function(bValid, Text)
      if bValid then
        DoSubmitReport(Text)
      end
    end, function(TipText)
      if #reportDesc > 0 then
        self:ShowTips("UI_REGISTER_BANNEDINPUT", 1, 0)
      end
    end, {}, true)
  end
end

function WBP_Common_Dialog_ChatReport_C:ShowTips(TipText, Style, Time)
  self.Com_Input_Multiline_Light:ShowTips(TipText, Style)
  if self.bTipsShowed and self.TipsText == TipText then
    return
  end
  self.TipsText = TipText
  if self:IsExistTimer(self.TipTimerKey) then
    self:RemoveTimer(self.TipTimerKey)
    self.Owner:HideDialogTip(1, false)
    self.Owner:HideDialogTip(2, false)
  end
  local TipIndex = 1 == Style and 1 or 2
  local Params = {
    DialogItemIndex = TipIndex,
    bHideDialogItem = false,
    bShouldPlayAnim = true,
    Tips = {TipText, TipText}
  }
  AudioManager(self):PlayUISound(self, "event:/ui/common/input_err", nil, nil)
  self.Owner:HideDialogTip(3, false)
  self.Owner:BroadcastDialogEvent("UpdateDialogTipText", Params)
  self.Owner:BroadcastDialogEvent(DialogEvent.HideDialogItem, Params)
  self.bTipsShowed = true
  self:AddTimer(1.5, function()
    if Time and 0 ~= Time then
      self.Owner:HideDialogTip(TipIndex, false)
      self.bTipsShowed = false
      self.Owner:BroadcastDialogEvent(DialogEvent.HideDialogItem, {
        bHideDialogItem = false,
        DialogItemIndex = 3,
        bShouldPlayAnim = false
      })
    end
  end, false, 0, self.TipTimerKey)
end

function WBP_Common_Dialog_ChatReport_C:CloseTip(TipText)
  local Params = {
    DialogItemIndex = 2,
    bHideDialogItem = true,
    bShouldPlayAnim = true,
    Tips = {TipText, TipText}
  }
  self.Owner:BroadcastDialogEvent(DialogEvent.HideDialogItem, Params)
  self.bTipsShowed = false
end

function WBP_Common_Dialog_ChatReport_C:OnBtnNo()
  self.Owner:OnClose()
end

function WBP_Common_Dialog_ChatReport_C:OnClose()
  self.Owner:GetButtonBar().Btn_Yes:UnbindEventOnReleased(self)
  self.Owner:GetButtonBar().Btn_Quit:UnbindEventOnReleased(self)
  if self.bPendingAutoSelect then
    self.bPendingAutoSelect = false
    self.List_Report.BP_OnEntryInitialized:Remove(self, self.OnReportEntryInitialized)
  end
end

function WBP_Common_Dialog_ChatReport_C:OnContentFocusReceived()
  self.List_Report:SetFocus()
end

function WBP_Common_Dialog_ChatReport_C:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif self.ComTab and self.ComTab:IsVisible() and self.ComTab.Handle_KeyEventOnPC then
    IsEventHandled = self.ComTab:Handle_KeyEventOnPC(InKeyName)
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  end
  return UWidgetBlueprintLibrary.UnHandled()
end

function WBP_Common_Dialog_ChatReport_C:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if InKeyName == Const.GamepadFaceButtonUp then
    if not self.Owner.ForbidRightBtn then
      self:OnBtnYes()
    end
    IsEventHandled = true
  elseif InKeyName == Const.GamepadFaceButtonLeft then
    self.Com_Input_Multiline_Light:FocusInputField()
    self:UpdateUIStyleInPlatform()
    IsEventHandled = true
  elseif InKeyName == Const.GamepadLeftThumbstick then
    IsEventHandled = false
  end
  if not IsEventHandled and self.ComTab and self.ComTab:IsVisible() and self.ComTab.Handle_KeyEventOnGamePad then
    IsEventHandled = self.ComTab:Handle_KeyEventOnGamePad(InKeyName)
  end
  return IsEventHandled
end

function WBP_Common_Dialog_ChatReport_C:OnUpdateUIStyleByInputTypeChange(CurInputDeviceType, CurGamepadName)
  if CurInputDeviceType == ECommonInputType.Gamepad then
    if self.Com_Input_Multiline_Light:HasFocusedDescendants() then
      self.Com_Input_Multiline_Light:FocusInputField()
    else
      self.List_Report:SetFocus()
    end
  end
  self.CurInputDeviceType = CurInputDeviceType
  self:UpdateUIStyleInPlatform()
end

function WBP_Common_Dialog_ChatReport_C:UpdateUIStyleInPlatform()
  if not self.GamepadAKeyIndex then
    return
  end
  local IsGamepad = self.CurInputDeviceType == ECommonInputType.Gamepad
  if IsGamepad and self.List_Report:HasFocusedDescendants() then
    self:ShowGamepadShortcut(self.GamepadAKeyIndex)
  else
    self:HideGamepadShortcut(self.GamepadAKeyIndex)
  end
end

return WBP_Common_Dialog_ChatReport_C
