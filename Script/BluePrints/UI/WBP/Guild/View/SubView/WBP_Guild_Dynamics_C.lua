require("UnLua")
local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local GuildDatas = require("BluePrints.UI.WBP.Guild.Common.GuildDatas")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local GuildMessageTypeAlias = {
  ChangedDecl = "ChangedDecl"
}

local function TrimString(Value)
  if type(Value) ~= "string" then
    return Value
  end
  return (Value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function SafeStringFormat(Template, ...)
  local bSuccess, Result = pcall(string.format, Template, ...)
  if bSuccess then
    return Result
  end
  return Template
end

M.TabDefs = {
  {
    TabId = 1,
    Name = GText("UI_GrowthRecords"),
    bIsLocked = false
  },
  {
    TabId = 2,
    Name = GText("UI_DevelopmentProgress"),
    bIsLocked = true
  },
  {
    TabId = 3,
    Name = GText("UI_EventHistory"),
    bIsLocked = true
  }
}

function M:Initialize(Initializer)
  rawset(self, "SelectedTabId", nil)
  rawset(self, "GuildFullInfo", nil)
  rawset(self, "MemberNameCache", {})
  rawset(self, "PendingMemberNameQuery", {})
  rawset(self, "FailedMemberNameQuery", {})
end

function M:Construct()
  self.Super.Construct(self)
  self.Btn_Close:Init("Close", self, self.Close)
  self.List_Tab.BP_OnItemSelectionChanged:Add(self, self.OnSelectTabChanged)
  self.List_Message.bIsFocusable = true
  self.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:Destruct()
  self.Super.Destruct(self)
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self:Init()
end

function M:Close()
  if self.Out then
    self:PlayAnimation(self.Out, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1)
  else
    self.Super.Close(self)
  end
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Out then
    self.Super.Close(self)
  end
end

function M:Init()
  self:InitListTab()
  if self.In then
    self:PlayAnimation(self.In, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1)
  end
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnGetGuildInfo then
      self:OnGetGuildInfo(...)
    end
  end)
end

function M:InitListTab()
  self.List_Tab:ClearListItems()
  local ClassPath = "/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C"
  for _, TabDef in ipairs(self.TabDefs) do
    local Obj = NewObject(UE4.LoadClass(ClassPath))
    Obj.Root = self
    Obj.TabId = TabDef.TabId
    Obj.TabName = TabDef.Name
    Obj.bIsLocked = TabDef.bIsLocked
    self.List_Tab:AddItem(Obj)
  end
  self:AddTimer(0.01, function()
    self.List_Tab:ScrollIndexIntoView(0)
    self:AddTimer(0.01, function()
      local Item = self.List_Tab:GetItemAt(0)
      if Item and Item.Entry then
        Item.Entry:OnCellClicked()
      end
      self:AddTimer(0.05, function()
        self:SetLockedTabNavigation()
      end, false, 0, "SetLockedNav", true)
    end, false, 0, "SelectFirstTab", true)
  end, false, 0, "ScrollToFirstTab", true)
end

function M:OnSelectTabChanged(SelectItem)
  if not SelectItem then
    return
  end
  if self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and SelectItem.Entry then
    SelectItem.Entry:OnCellClicked()
  end
end

function M:SetLockedTabNavigation()
  local ValidEntries = {}
  for i, TabDef in ipairs(self.TabDefs) do
    if not TabDef.bIsLocked then
      local Item = self.List_Tab:GetItemAt(i - 1)
      if Item and Item.Entry then
        table.insert(ValidEntries, {
          Index = i,
          Entry = Item.Entry
        })
      end
    end
  end
  for i, Valid in ipairs(ValidEntries) do
    if Valid.Entry.SetNavigationRule then
      if 1 == #ValidEntries then
        Valid.Entry:SetNavigationRule(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
        Valid.Entry:SetNavigationRule(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
      else
        local PrevEntry = ValidEntries[1 == i and #ValidEntries or i - 1].Entry
        Valid.Entry:SetNavigationRule(UE4.EUINavigation.Up, UE4.EUINavigationRule.Explicit, PrevEntry)
        local NextEntry = ValidEntries[i == #ValidEntries and 1 or i + 1].Entry
        Valid.Entry:SetNavigationRule(UE4.EUINavigation.Down, UE4.EUINavigationRule.Explicit, NextEntry)
      end
    end
  end
end

function M:OnTabSelected(TabId)
  if self.SelectedTabId == TabId then
    return
  end
  self.SelectedTabId = TabId
  self:RefreshContent()
end

function M:RefreshContent()
  local CurrGuild = GuildController:GetModel():GetCurrGuild()
  self.GuildFullInfo = CurrGuild
  if not CurrGuild then
    self.Panel_Content:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.Panel_Content:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  if 1 == self.SelectedTabId then
    self:RefreshMessages(CurrGuild.GuildMessages)
  end
  if self.Refresh then
    self:PlayAnimation(self.Refresh)
  end
end

function M:RefreshMessages(GuildMessages)
  self.List_Message:ClearListItems()
  if not GuildMessages or 0 == #GuildMessages then
    return
  end
  local SortedMessages = {}
  for _, Msg in ipairs(GuildMessages) do
    table.insert(SortedMessages, Msg)
  end
  table.sort(SortedMessages, function(a, b)
    return (a.Time or 0) > (b.Time or 0)
  end)
  local DateGroups = {}
  local DateOrder = {}
  for _, Msg in ipairs(SortedMessages) do
    local DateStr = self:FormatTime(Msg.Time)
    if not DateGroups[DateStr] then
      DateGroups[DateStr] = {}
      table.insert(DateOrder, DateStr)
    end
    table.insert(DateGroups[DateStr], Msg)
  end
  local ClassPath = "/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C"
  for _, DateStr in ipairs(DateOrder) do
    local Obj = NewObject(UE4.LoadClass(ClassPath))
    Obj.Root = self
    Obj.DateText = DateStr
    Obj.Messages = DateGroups[DateStr]
    self.List_Message:AddItem(Obj)
  end
  self:AddTimer(0.05, function()
    self:UpdateScrollbarVisibility()
    local bIsGamepad = self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad
    if bIsGamepad then
      self:UpdateKey01Visibility()
      self:SetDefaultFocus()
    elseif self.List_Message and self.List_Message:IsVisible() then
      self.List_Message:SetFocus()
    end
  end, false, 0, "AfterRefreshMessages", true)
end

function M:OnGetGuildInfo(GuildFullInfo)
  if not GuildFullInfo then
    return
  end
  self.GuildFullInfo = GuildFullInfo
  self:RefreshContent()
end

function M:GetMemberNameFromCache(Uid)
  Uid = tonumber(Uid) or 0
  if Uid <= 0 then
    return nil
  end
  local CachedName = self.MemberNameCache and self.MemberNameCache[Uid]
  if CachedName and "" ~= CachedName then
    return CachedName
  end
  return nil
end

function M:CacheMemberName(Uid, MemberName)
  Uid = tonumber(Uid) or 0
  if Uid <= 0 then
    return
  end
  if type(MemberName) ~= "string" or "" == MemberName then
    return
  end
  self.MemberNameCache = self.MemberNameCache or {}
  self.MemberNameCache[Uid] = MemberName
end

function M:RequestMemberName(Uid)
  Uid = tonumber(Uid) or 0
  if Uid <= 0 then
    return
  end
  self.MemberNameCache = self.MemberNameCache or {}
  self.PendingMemberNameQuery = self.PendingMemberNameQuery or {}
  self.FailedMemberNameQuery = self.FailedMemberNameQuery or {}
  if self.MemberNameCache[Uid] or self.PendingMemberNameQuery[Uid] or self.FailedMemberNameQuery[Uid] then
    return
  end
  self.PendingMemberNameQuery[Uid] = true
  local Avatar = GuildController and GuildController:GetAvatar()
  if not Avatar or not Avatar.QueryGuildMemberInfo then
    self.PendingMemberNameQuery[Uid] = nil
    self.FailedMemberNameQuery[Uid] = true
    return
  end
  Avatar:QueryGuildMemberInfo(function(Ret, MemberInfos)
    self.PendingMemberNameQuery[Uid] = nil
    if Ret ~= ErrorCode.RET_SUCCESS then
      self.FailedMemberNameQuery[Uid] = true
      return
    end
    local MemberInfo = MemberInfos and (MemberInfos[Uid] or MemberInfos[tostring(Uid)]) or nil
    local MemberName = MemberInfo and (MemberInfo.Nickname or MemberInfo.Name) or nil
    if MemberName and "" ~= MemberName then
      self:CacheMemberName(Uid, MemberName)
      self.FailedMemberNameQuery[Uid] = nil
      if 1 == self.SelectedTabId then
        self:RefreshContent()
      end
    else
      self.FailedMemberNameQuery[Uid] = true
    end
  end, {Uid})
end

function M:GetMemberDisplayName(Uid)
  Uid = tonumber(Uid) or 0
  if Uid <= 0 then
    return ""
  end
  local CurrGuild = GuildController:GetModel():GetCurrGuild()
  local Member = CurrGuild and CurrGuild.GetMemberByUid and CurrGuild:GetMemberByUid(Uid) or nil
  local MemberName = Member and (Member.Nickname or Member.Name) or nil
  if MemberName and "" ~= MemberName then
    self:CacheMemberName(Uid, MemberName)
    return MemberName
  end
  MemberName = self:GetMemberNameFromCache(Uid)
  if MemberName then
    return MemberName
  end
  self:RequestMemberName(Uid)
  return tostring(Uid)
end

function M:GetGuildTitleDisplayName(Title)
  Title = tonumber(Title) or 0
  if Title <= 0 then
    return tostring(Title)
  end
  local GuildTitleData = DataMgr.GuildTitle and DataMgr.GuildTitle[Title]
  local TitleName = GuildTitleData and GuildTitleData.TitleName
  if TitleName and "" ~= TitleName then
    return GText(TitleName)
  end
  return tostring(Title)
end

function M:FormatMessageText(MessageData)
  if not MessageData then
    return ""
  end
  local RawMsgType = TrimString(MessageData.Type)
  local MsgType = RawMsgType
  if type(RawMsgType) == "string" then
    MsgType = GuildMessageTypeAlias[RawMsgType] or RawMsgType
  end
  local FormatText = MessageData.FormatText or {}
  local Config = not DataMgr.GuildMessage or DataMgr.GuildMessage[MsgType] or DataMgr.GuildMessage[MessageData.Type]
  local Template = Config and Config.Content and GText(Config.Content) or nil
  if Template then
    if "GuildCreateSuccess" == RawMsgType then
      return Template
    elseif "ChangeGuildName" == RawMsgType then
      return SafeStringFormat(Template, tostring(FormatText.NewName or FormatText.OldName or ""))
    elseif "ChangedDecl" == RawMsgType then
      return SafeStringFormat(Template, self:GetMemberDisplayName(FormatText.EditorUid))
    elseif "ChangedLogo" == RawMsgType then
      return SafeStringFormat(Template, self:GetMemberDisplayName(FormatText.EditorUid))
    elseif "JoinMember" == RawMsgType then
      return SafeStringFormat(Template, self:GetMemberDisplayName(FormatText.Uid))
    elseif "LeaveMember" == RawMsgType then
      return SafeStringFormat(Template, self:GetMemberDisplayName(FormatText.Uid))
    elseif "KickMember" == RawMsgType then
      return SafeStringFormat(Template, self:GetMemberDisplayName(FormatText.RequestUid), self:GetMemberDisplayName(FormatText.TargetUid))
    elseif "SetOwner" == RawMsgType then
      return SafeStringFormat(Template, self:GetMemberDisplayName(FormatText.RequestUid), self:GetMemberDisplayName(FormatText.TargetUid))
    elseif "SetPermissionSwitch" == RawMsgType then
      return SafeStringFormat(Template, self:GetMemberDisplayName(FormatText.RequestUid))
    elseif "SetTitle" == RawMsgType then
      return SafeStringFormat(Template, self:GetMemberDisplayName(FormatText.RequestUid), self:GetMemberDisplayName(FormatText.TargetUid), self:GetGuildTitleDisplayName(FormatText.Title))
    end
    local Result = Template
    for Key, Value in pairs(FormatText) do
      Result = string.gsub(Result, "{" .. Key .. "}", tostring(Value))
    end
    local FormatArgs = {}
    local IndexedArgs = {}
    local Indexes = {}
    for _, Value in ipairs(FormatText) do
      table.insert(FormatArgs, tostring(Value))
    end
    if 0 == #FormatArgs then
      for Key, Value in pairs(FormatText) do
        local Index = tonumber(Key)
        if Index then
          IndexedArgs[Index] = tostring(Value)
          table.insert(Indexes, Index)
        end
      end
      table.sort(Indexes)
      for _, Index in ipairs(Indexes) do
        table.insert(FormatArgs, IndexedArgs[Index])
      end
    end
    if #FormatArgs > 0 then
      return SafeStringFormat(Result, table.unpack(FormatArgs))
    end
    return Result
  end
  if FormatText then
    local Parts = {}
    for _, Value in pairs(FormatText) do
      table.insert(Parts, tostring(Value))
    end
    if #Parts > 0 then
      return table.concat(Parts, " ")
    end
  end
  return ""
end

function M:FormatTime(TimeStamp)
  if not TimeStamp or 0 == TimeStamp then
    return ""
  end
  local Now = os.time()
  local Date = os.date("*t", TimeStamp)
  local Today = os.date("*t", Now)
  if Date.year == Today.year and Date.month == Today.month and Date.day == Today.day then
    return GText("UI_Today")
  end
  return string.format("%d-%d-%d", Date.year, Date.month, Date.day)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local bIsUp = "Gamepad_DPad_Up" == InKeyName or "Gamepad_LeftStick_Up" == InKeyName
    local bIsDown = "Gamepad_DPad_Down" == InKeyName or "Gamepad_LeftStick_Down" == InKeyName
    if (bIsUp or bIsDown) and self:TryBlockNavigateToLockedTab(bIsDown) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:TryBlockNavigateToLockedTab(bNavigateDown)
  if not self.SelectedTabId then
    return false
  end
  local CurIndex
  for i, TabDef in ipairs(self.TabDefs) do
    if TabDef.TabId == self.SelectedTabId then
      CurIndex = i
      break
    end
  end
  if nil == CurIndex then
    return false
  end
  local TargetIndex
  if bNavigateDown then
    if CurIndex >= #self.TabDefs then
      TargetIndex = 1
    else
      TargetIndex = CurIndex + 1
    end
  elseif CurIndex <= 1 then
    TargetIndex = #self.TabDefs
  else
    TargetIndex = CurIndex - 1
  end
  if TargetIndex < 1 or TargetIndex > #self.TabDefs then
    return false
  end
  local TargetTab = self.TabDefs[TargetIndex]
  if TargetTab.bIsLocked then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildSystemNotAvailable"))
    return true
  end
  return false
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Right" == InKeyName then
      self:Close()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif "Escape" == InKeyName then
    self:Close()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if not self.List_Message or not InAnalogInputEvent then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_LeftY" == InKeyName then
    local AnalogValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    if math.abs(AnalogValue) < 0.5 then
      self.bLeftStickNavBlocked = false
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if self.bLeftStickNavBlocked then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local bIsDown = AnalogValue > 0
    if self:TryBlockNavigateToLockedTab(bIsDown) then
      self.bLeftStickNavBlocked = true
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  if "Gamepad_RightY" == InKeyName then
    local AnalogValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    if math.abs(AnalogValue) < 0.2 then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local Delta = -1 * AnalogValue * 10
    local CurrentOffset = self.Scroll:GetScrollOffset()
    self.Scroll:ForceLayoutPrepass()
    local MaxOffset = self.Scroll:GetScrollOffsetOfEnd()
    if not MaxOffset or MaxOffset <= 0 then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local NextOffset = math.clamp(CurrentOffset + Delta, 0, MaxOffset)
    self.Scroll:SetScrollOffset(NextOffset)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:UpdateScrollbarVisibility()
  self.Scroll:ForceLayoutPrepass()
  local MaxOffset = self.Scroll:GetScrollOffsetOfEnd()
  local bIsGamepad = self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad
  if bIsGamepad and MaxOffset > 0 then
    self.Scroll:SetAlwaysShowScrollbar(true)
  else
    self.Scroll:SetAlwaysShowScrollbar(false)
  end
end

function M:UpdateKey01Visibility()
  if self.Scroll:GetScrollOffsetOfEnd() > 0 then
    self.Key_01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Key_01:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Touch then
    self:SetupTouchView()
  elseif CurInputType == ECommonInputType.MouseAndKeyboard then
    self:SetupKeyboardView()
  else
    self:SetupGamepadView()
  end
end

function M:SetupTouchView()
  self.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Key_01:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Key_02:SetVisibility(UE4.ESlateVisibility.Collapsed)
  if self.List_Message then
    self.List_Message.bIsFocusable = false
  end
end

function M:SetupKeyboardView()
  self.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Key_01:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Key_02:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = "Esc"}
    },
    bLongPress = false,
    Desc = GText("UI_BACK")
  })
  self.Key_02:AddExecuteLogic(self, self.Close)
  self.Key_02:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  if self.List_Message then
    self.List_Message.bIsFocusable = true
  end
  self:AddTimer(0.05, function()
    self:UpdateScrollbarVisibility()
    if self.List_Message and self.List_Message:IsVisible() then
      self.List_Message:SetFocus()
    end
  end, false, 0, "SetupKeyboardViewDelay", true)
end

function M:SetupGamepadView()
  self.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  if self.List_Message then
    self.List_Message.bIsFocusable = false
  end
  self.Key_01:CreateCommonKey({
    KeyInfoList = {
      {ImgShortPath = "RV", Type = "Img"}
    },
    Desc = GText("UI_CTL_Rougelike_SlideItems")
  })
  self.Key_02:CreateCommonKey({
    KeyInfoList = {
      {ImgShortPath = "B", Type = "Img"}
    },
    bLongPress = false,
    Desc = GText("UI_BACK")
  })
  self.Key_02:AddExecuteLogic(self, self.Close)
  self.Key_02:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:AddTimer(0.05, function()
    self:UpdateScrollbarVisibility()
    self:UpdateKey01Visibility()
    self:SetDefaultFocus()
  end, false, 0, "SetupGamepadViewDelay", true)
end

function M:OnInputMethodChanged()
  if not self.GameInputModeSubsystem then
    return
  end
  if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
    self:SetDefaultFocus()
  end
end

function M:SetDefaultFocus()
  local PC = UE4.UGameplayStatics.GetPlayerController(self, 0)
  if not PC then
    return
  end
  if not self:HasAnyUserFocus(PC) and not self:HasFocusedDescendants() then
    self:SetUserFocus(PC)
  end
  local SelectedIndex = 0
  if self.SelectedTabId then
    for i, TabDef in ipairs(self.TabDefs) do
      if TabDef.TabId == self.SelectedTabId then
        SelectedIndex = i - 1
        break
      end
    end
  end
  local TabItem = self.List_Tab:GetItemAt(SelectedIndex)
  if TabItem and TabItem.Entry then
    TabItem.Entry:SetUserFocus(PC)
  end
end

return M
