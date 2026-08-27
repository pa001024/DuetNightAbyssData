local UIUtils = require("Utils.UIUtils")
local M = {}
local TagColumnCount = 5

local function IsGamepadInput()
  return UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
end

local function IsWidgetFocused(Widget)
  if not Widget or not IsValid(Widget) then
    return false
  end
  return Widget:HasAnyUserFocus() or Widget:HasFocusedDescendants()
end

local function SetNavigation(Source, Direction, Target)
  if not Source then
    return
  end
  if Target then
    Source:SetNavigationRuleExplicit(Direction, Target)
  else
    Source:SetNavigationRuleBase(Direction, UE4.EUINavigationRule.Stop)
  end
end

local function StopNavigation(Widget)
  if not Widget then
    return
  end
  SetNavigation(Widget, UE4.EUINavigation.Up)
  SetNavigation(Widget, UE4.EUINavigation.Down)
  SetNavigation(Widget, UE4.EUINavigation.Left)
  SetNavigation(Widget, UE4.EUINavigation.Right)
end

local function IsNormalSignWidget(Widget)
  local Data = Widget and Widget.Data
  return Data and Data.Kind ~= "Empty" and Data.Disabled ~= true
end

local function IsEditingSignWidget(Widget)
  local Data = Widget and Widget.Data
  return Data and Data.Kind == "Custom"
end

function M:InitRecruitGamepadState()
  self.RecruitSelectShortcutIndex = nil
  self.RecruitDeleteShortcutIndex = nil
  self.RecruitFocusRequestId = 0
  self.RecruitEditExitRequestId = 0
  self.RecruitFocusRestoreToken = nil
  self.CustomTagDialogFocusToken = nil
  self.FocusedRecruitSignWidget = nil
  self.bRecruitEditExitPending = false
  self.bRecruitGamepadViewActive = IsGamepadInput()
  self.RecruitKeyEditInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if self.RecruitKeyEditInputModeSubsystem then
    self.RecruitKeyEditInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshRecruitEditInputState)
    self.RecruitKeyEditInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshRecruitEditInputState)
  end
  self:RefreshRecruitEditInputState()
  if self.Key_Edit and self.Key_Edit.CreateGamepadKey then
    self.Key_Edit:CreateGamepadKey(UIConst.GamePadImgKey.RightThumb)
  end
end

function M:CleanupRecruitGamepadState()
  if self.RecruitKeyEditInputModeSubsystem then
    self.RecruitKeyEditInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshRecruitEditInputState)
  end
  self.RecruitKeyEditInputModeSubsystem = nil
  self.RecruitFocusRequestId = (self.RecruitFocusRequestId or 0) + 1
  self.RecruitEditExitRequestId = (self.RecruitEditExitRequestId or 0) + 1
  self:HideGamepadShortcut(self.RecruitSelectShortcutIndex)
  self:HideGamepadShortcut(self.RecruitDeleteShortcutIndex)
  self.RecruitSelectShortcutIndex = nil
  self.RecruitDeleteShortcutIndex = nil
  self.RecruitFocusRestoreToken = nil
  self.CustomTagDialogFocusToken = nil
  self.FocusedRecruitSignWidget = nil
  self.bRecruitEditExitPending = false
end

function M:EnsureRecruitGamepadShortcuts()
  if not self.RecruitSelectShortcutIndex then
    self.RecruitSelectShortcutIndex = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
        }
      },
      Desc = GText("UI_CTL_Select/Cancel")
    })
  end
  if not self.RecruitDeleteShortcutIndex then
    self.RecruitDeleteShortcutIndex = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft
        }
      },
      Desc = GText("UI_RegionMap_Delete")
    })
  end
end

function M:RefreshRecruitEditInputState(CurInputDevice)
  local bIsGamepad
  if nil == CurInputDevice then
    bIsGamepad = IsGamepadInput()
  else
    bIsGamepad = CurInputDevice == ECommonInputType.Gamepad
  end
  if self.Group_KeyEdit then
    local KeyEditContent = self.Group_KeyEdit:GetContent()
    if KeyEditContent then
      KeyEditContent:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.Group_KeyEdit:SetVisibility(bIsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.Btn_Edit then
    self.Btn_Edit:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:RefreshRecruitGamepadPromptState()
  self:RefreshRecruitEditInputState()
  if not self.bRecruitGamepadViewActive then
    self:HideGamepadShortcut(self.RecruitSelectShortcutIndex)
    self:HideGamepadShortcut(self.RecruitDeleteShortcutIndex)
    return
  end
  self:ShowGamepadCloseBtn(true)
  self:ChangeCloseShortKeyText(GText("UI_Tips_Close"))
  if self.bEditingCustomTags then
    self:HideGamepadShortcut(self.RecruitSelectShortcutIndex)
    self:ShowGamepadShortcut(self.RecruitDeleteShortcutIndex)
  else
    self:ShowGamepadShortcut(self.RecruitSelectShortcutIndex)
    self:HideGamepadShortcut(self.RecruitDeleteShortcutIndex)
  end
  self:SetGamepadBtnKeyVisibility(not self.bEditingCustomTags)
  for _, Widget in ipairs(self.SignWidgets or {}) do
    if Widget.SetGamepadKeyVisible then
      Widget:SetGamepadKeyVisible(not self.bEditingCustomTags)
    end
  end
end

function M:InitGamepadView()
  self.bRecruitGamepadViewActive = true
  self:EnsureRecruitGamepadShortcuts()
  self:RefreshRecruitGamepadPromptState()
  self:RefreshNavigation()
  if self.bEditingCustomTags then
    self:ScheduleCustomTagFocus(1)
  else
    self:ScheduleRecruitFocus(function()
      return self:GetRecruitDesiredFocusTarget()
    end)
  end
end

function M:InitKeyboardView()
  self.bRecruitGamepadViewActive = false
  self.RecruitFocusRequestId = (self.RecruitFocusRequestId or 0) + 1
  self:HideGamepadShortcut(self.RecruitSelectShortcutIndex)
  self:HideGamepadShortcut(self.RecruitDeleteShortcutIndex)
  self:RefreshRecruitEditInputState()
  for _, Widget in ipairs(self.SignWidgets or {}) do
    if Widget.SetGamepadKeyVisible then
      Widget:SetGamepadKeyVisible(false)
    end
  end
end

function M:OnRecruitSignItemsRefreshed()
  for _, Widget in ipairs(self.SignWidgets or {}) do
    if Widget.SetGamepadKeyVisible then
      Widget:SetGamepadKeyVisible(self.bRecruitGamepadViewActive and not self.bEditingCustomTags)
    end
  end
  self:RefreshNavigation()
  self:RefreshRecruitGamepadPromptState()
end

function M:GetNavigableSignWidget(Index)
  local Widget = self.SignWidgets and self.SignWidgets[Index]
  if self.bEditingCustomTags then
    return IsEditingSignWidget(Widget) and Widget or nil
  end
  return IsNormalSignWidget(Widget) and Widget or nil
end

function M:GetNavigableSignButton(Index)
  local Widget = self:GetNavigableSignWidget(Index)
  return Widget and Widget.Btn_Click or nil
end

function M:RefreshNavigation()
  local TargetButton = self.Com_SortDownTarget and self.Com_SortDownTarget.Btn_Filter_List
  local LevelButton = self.Com_SortDownLevel and self.Com_SortDownLevel.Btn_Filter_List
  local PublicButton = self.Com_CheckBox_Open and self.Com_CheckBox_Open.Btn_Click
  local FriendButton = self.Com_CheckBox_Friend and self.Com_CheckBox_Friend.Btn_Click
  local GuildButton = self.Com_CheckBox_Guild and self.Com_CheckBox_Guild.Btn_Click
  local EditButton = self.Btn_Edit and self.Btn_Edit.Button_Area
  local DoneButton = self.Btn_SignDone and self.Btn_SignDone.Button_Area
  for _, Button in ipairs({
    TargetButton,
    LevelButton,
    PublicButton,
    FriendButton,
    GuildButton,
    EditButton,
    DoneButton
  }) do
    StopNavigation(Button)
  end
  for _, Widget in ipairs(self.SignWidgets or {}) do
    StopNavigation(Widget and Widget.Btn_Click)
  end
  if self.bEditingCustomTags then
    local EditingWidgets = {}
    for _, Widget in ipairs(self.SignWidgets or {}) do
      if IsEditingSignWidget(Widget) then
        EditingWidgets[#EditingWidgets + 1] = Widget
      end
    end
    for Index, Widget in ipairs(EditingWidgets) do
      local PreviousButton = EditingWidgets[Index - 1] and EditingWidgets[Index - 1].Btn_Click
      local NextButton = EditingWidgets[Index + 1] and EditingWidgets[Index + 1].Btn_Click
      SetNavigation(Widget.Btn_Click, UE4.EUINavigation.Left, PreviousButton)
      SetNavigation(Widget.Btn_Click, UE4.EUINavigation.Up, PreviousButton)
      SetNavigation(Widget.Btn_Click, UE4.EUINavigation.Right, NextButton)
      SetNavigation(Widget.Btn_Click, UE4.EUINavigation.Down, NextButton)
    end
    return
  end
  SetNavigation(TargetButton, UE4.EUINavigation.Down, LevelButton)
  SetNavigation(LevelButton, UE4.EUINavigation.Up, TargetButton)
  SetNavigation(LevelButton, UE4.EUINavigation.Down, PublicButton)
  SetNavigation(PublicButton, UE4.EUINavigation.Up, LevelButton)
  SetNavigation(FriendButton, UE4.EUINavigation.Up, LevelButton)
  SetNavigation(GuildButton, UE4.EUINavigation.Up, LevelButton)
  SetNavigation(PublicButton, UE4.EUINavigation.Right, FriendButton)
  SetNavigation(FriendButton, UE4.EUINavigation.Left, PublicButton)
  SetNavigation(FriendButton, UE4.EUINavigation.Right, GuildButton)
  SetNavigation(GuildButton, UE4.EUINavigation.Left, FriendButton)
  local FirstSignButton = self:GetNavigableSignButton(1)
  local MiddleSignButton = self:GetNavigableSignButton(3) or self:GetNavigableSignButton(2) or FirstSignButton
  local LastSignButton = self:GetNavigableSignButton(5) or self:GetNavigableSignButton(4) or MiddleSignButton
  SetNavigation(PublicButton, UE4.EUINavigation.Down, FirstSignButton)
  SetNavigation(FriendButton, UE4.EUINavigation.Down, MiddleSignButton)
  SetNavigation(GuildButton, UE4.EUINavigation.Down, LastSignButton)
  for Index, Widget in ipairs(self.SignWidgets or {}) do
    if IsNormalSignWidget(Widget) then
      local Button = Widget.Btn_Click
      local Column = (Index - 1) % TagColumnCount + 1
      local UpperButton = self:GetNavigableSignButton(Index - TagColumnCount)
      UpperButton = UpperButton or Column <= 2 and PublicButton or 3 == Column and FriendButton or GuildButton
      SetNavigation(Button, UE4.EUINavigation.Left, Column > 1 and self:GetNavigableSignButton(Index - 1) or nil)
      SetNavigation(Button, UE4.EUINavigation.Right, Column < TagColumnCount and self:GetNavigableSignButton(Index + 1) or nil)
      SetNavigation(Button, UE4.EUINavigation.Up, UpperButton)
      SetNavigation(Button, UE4.EUINavigation.Down, self:GetNavigableSignButton(Index + TagColumnCount))
    end
  end
end

function M:OnRecruitSignItemFocused(Widget)
  self.FocusedRecruitSignWidget = Widget
end

function M:CaptureRecruitFocusToken()
  if IsWidgetFocused(self.Com_SortDownTarget) then
    return {Type = "Target"}
  end
  if IsWidgetFocused(self.Com_SortDownLevel) then
    return {Type = "Level"}
  end
  if IsWidgetFocused(self.Com_CheckBox_Open) then
    return {Type = "Public"}
  end
  if IsWidgetFocused(self.Com_CheckBox_Friend) then
    return {Type = "Friend"}
  end
  if IsWidgetFocused(self.Com_CheckBox_Guild) then
    return {Type = "Guild"}
  end
  for Index, Widget in ipairs(self.SignWidgets or {}) do
    if IsWidgetFocused(Widget) and Widget.Data then
      return {
        Type = "Tag",
        Kind = Widget.Data.Kind,
        Value = Widget.Data.Value,
        Index = Index
      }
    end
  end
  return {Type = "Target"}
end

function M:ResolveRecruitFocusToken(Token)
  local TokenType = Token and Token.Type
  if "Level" == TokenType then
    return self.Com_SortDownLevel and self.Com_SortDownLevel.Btn_Filter_List
  end
  if "Public" == TokenType then
    return self.Com_CheckBox_Open and self.Com_CheckBox_Open.Btn_Click
  end
  if "Friend" == TokenType then
    return self.Com_CheckBox_Friend and self.Com_CheckBox_Friend.Btn_Click
  end
  if "Guild" == TokenType then
    return self.Com_CheckBox_Guild and self.Com_CheckBox_Guild.Btn_Click
  end
  if "Tag" == TokenType then
    for _, Widget in ipairs(self.SignWidgets or {}) do
      local Data = Widget.Data
      if IsNormalSignWidget(Widget) and Data.Kind == Token.Kind and Data.Value == Token.Value then
        return Widget.Btn_Click
      end
    end
    local SamePositionWidget = Token.Index and self:GetNavigableSignWidget(Token.Index)
    if SamePositionWidget then
      return SamePositionWidget.Btn_Click
    end
    for _, Widget in ipairs(self.SignWidgets or {}) do
      if IsNormalSignWidget(Widget) then
        return Widget.Btn_Click
      end
    end
  end
  return self.Com_SortDownTarget and self.Com_SortDownTarget.Btn_Filter_List
end

function M:RestoreRecruitFocusAfterSignRefresh(Token)
  if not Token or not IsGamepadInput() then
    return
  end
  self:ScheduleRecruitFocus(function()
    return self:ResolveRecruitFocusToken(Token)
  end)
end

function M:ScheduleRecruitFocus(Resolver)
  self.RecruitFocusRequestId = (self.RecruitFocusRequestId or 0) + 1
  local RequestId = self.RecruitFocusRequestId
  
  local function ApplyFocus()
    if not IsValid(self) or self.RecruitFocusRequestId ~= RequestId or not self.bRecruitGamepadViewActive then
      return
    end
    local Widget = Resolver and Resolver() or nil
    if Widget and IsValid(Widget) then
      Widget:SetFocus()
    end
  end
  
  if self.AddDelayFrameFunc then
    self:AddDelayFrameFunc(ApplyFocus, 1)
  else
    ApplyFocus()
  end
end

function M:ScheduleCustomTagFocus(Ordinal)
  self:ScheduleRecruitFocus(function()
    local CurrentOrdinal = 0
    local Fallback
    for _, Widget in ipairs(self.SignWidgets or {}) do
      if IsEditingSignWidget(Widget) then
        CurrentOrdinal = CurrentOrdinal + 1
        Fallback = Widget.Btn_Click
        if CurrentOrdinal == Ordinal then
          return Widget.Btn_Click
        end
      end
    end
    return Fallback
  end)
end

function M:EnterCustomTagEditMode()
  if self.bEditingCustomTags then
    return false
  end
  if 0 == #(self.Draft and self.Draft.CustomTagOptions or {}) then
    self:OnSignEditForbidden()
    return false
  end
  self.RecruitEditExitRequestId = (self.RecruitEditExitRequestId or 0) + 1
  self.bRecruitEditExitPending = false
  self.RecruitFocusRestoreToken = self:CaptureRecruitFocusToken()
  self.bEditingCustomTags = true
  if self.Owner then
    self.Owner:ForbidRightBtn(true)
  end
  self:RefreshSignItems()
  if IsGamepadInput() then
    self:ScheduleCustomTagFocus(1)
  end
  return true
end

function M:RequestExitCustomTagEditMode()
  if self.bRecruitEditExitPending then
    return true
  end
  if not self.bEditingCustomTags then
    return false
  end
  if not self.AddDelayFrameFunc then
    return self:ExitCustomTagEditMode()
  end
  self.bRecruitEditExitPending = true
  self.RecruitEditExitRequestId = (self.RecruitEditExitRequestId or 0) + 1
  local RequestId = self.RecruitEditExitRequestId
  self:AddDelayFrameFunc(function()
    if not IsValid(self) or self.RecruitEditExitRequestId ~= RequestId then
      return
    end
    self.bRecruitEditExitPending = false
    self:ExitCustomTagEditMode()
  end, 1)
  return true
end

function M:ExitCustomTagEditMode()
  if not self.bEditingCustomTags then
    return false
  end
  self.RecruitEditExitRequestId = (self.RecruitEditExitRequestId or 0) + 1
  self.bRecruitEditExitPending = false
  local RestoreToken = self.RecruitFocusRestoreToken
  self.bEditingCustomTags = false
  self.FocusedRecruitSignWidget = nil
  self.RecruitFocusRestoreToken = nil
  if self.Owner then
    self.Owner:ForbidRightBtn(self.bRequestingPublish == true)
  end
  self:RefreshSignItems()
  if IsGamepadInput() then
    self:ScheduleRecruitFocus(function()
      return self:ResolveRecruitFocusToken(RestoreToken)
    end)
  end
  return true
end

function M:ActivateFocusedRoomStatus()
  for _, CheckBox in ipairs({
    self.Com_CheckBox_Open,
    self.Com_CheckBox_Friend,
    self.Com_CheckBox_Guild
  }) do
    if IsWidgetFocused(CheckBox) and CheckBox.Activate then
      CheckBox:Activate()
      return true
    end
  end
  return false
end

function M:DeleteFocusedCustomTag()
  local FocusedWidget = self.FocusedRecruitSignWidget
  if not IsEditingSignWidget(FocusedWidget) or not IsWidgetFocused(FocusedWidget) then
    FocusedWidget = nil
    for _, Widget in ipairs(self.SignWidgets or {}) do
      if IsEditingSignWidget(Widget) and IsWidgetFocused(Widget) then
        FocusedWidget = Widget
        break
      end
    end
  end
  if not FocusedWidget or not FocusedWidget.Data then
    return false
  end
  local Ordinal = 0
  for _, Widget in ipairs(self.SignWidgets or {}) do
    if IsEditingSignWidget(Widget) then
      Ordinal = Ordinal + 1
    end
    if Widget == FocusedWidget then
      break
    end
  end
  self:DeleteCustomTag(FocusedWidget.Data.Value)
  if self.bEditingCustomTags then
    local RemainingCount = #(self.Draft.CustomTagOptions or {})
    if RemainingCount > 0 then
      self:ScheduleCustomTagFocus(math.min(Ordinal, RemainingCount))
    else
      self:ScheduleRecruitFocus(function()
        return self.Btn_SignDone and self.Btn_SignDone.Button_Area
      end)
    end
  end
  return true
end

function M:GetRecruitDesiredFocusTarget()
  if self.bEditingCustomTags then
    for _, Widget in ipairs(self.SignWidgets or {}) do
      if IsEditingSignWidget(Widget) then
        return Widget.Btn_Click
      end
    end
    return self.Btn_SignDone and self.Btn_SignDone.Button_Area
  end
  return self.Com_SortDownTarget and self.Com_SortDownTarget.Btn_Filter_List
end

function M:CloseOpenedRecruitSortDowns(bRestoreFocus)
  local bClosed = false
  for _, SortDown in ipairs({
    self.Com_SortDownTarget,
    self.Com_SortDownLevel
  }) do
    if SortDown and SortDown.IsListViewOpened then
      SortDown:OnListClosed(bRestoreFocus)
      bClosed = true
    end
  end
  return bClosed
end

function M:HasOpenedRecruitSortDown()
  return self.Com_SortDownTarget and self.Com_SortDownTarget.IsListViewOpened == true or self.Com_SortDownLevel and true == self.Com_SortDownLevel.IsListViewOpened or false
end

function M:ProcessRecruitDialogGamepadKey(InKeyName)
  if self.Owner and self.Owner.ProcessGamepadKeydown then
    return self.Owner:ProcessGamepadKeydown(InKeyName) == true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    return true == self:RequestPublish()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight and self.Owner and self.Owner.OnCloseBtnClicked then
    self.Owner:OnCloseBtnClicked()
    return true
  end
  return false
end

function M:HandleRecruitGamepadKey(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return false
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.bEditingCustomTags then
    if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      self:DeleteFocusedCustomTag()
      return true
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:RequestExitCustomTagEditMode()
      return true
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom or InKeyName == UIConst.GamePadKey.RightThumb or InKeyName == UIConst.GamePadKey.SpecialRight then
      return true
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self:ActivateFocusedRoomStatus() then
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self:CloseOpenedRecruitSortDowns(true) then
      return true
    end
    return self:ProcessRecruitDialogGamepadKey(InKeyName)
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    if self:HasOpenedRecruitSortDown() then
      return true
    end
    return self:ProcessRecruitDialogGamepadKey(InKeyName)
  end
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self:CloseOpenedRecruitSortDowns(false)
    self:OpenCustomTagDialog()
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightThumb then
    self:CloseOpenedRecruitSortDowns(false)
    self:EnterCustomTagEditMode()
    return true
  end
  return false
end

function M:OnContentPreviewKeyDown(MyGeometry, InKeyEvent)
  return self:HandleRecruitGamepadKey(MyGeometry, InKeyEvent)
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  return self:HandleRecruitGamepadKey(MyGeometry, InKeyEvent)
end

function M:HandleRecruitChildPreviewKeyDown(MyGeometry, InKeyEvent)
  return self:HandleRecruitGamepadKey(MyGeometry, InKeyEvent)
end

return M
