local M = {}
local BP_UIState_C = require("BluePrints.UI.BP_UIState_C")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local TeamHallController = require("BluePrints.UI.WBP.TeamHall.TeamHallController")
local UIUtils = require("Utils.UIUtils")
local RECRUIT_TAB_INDEX = 1
local INVITE_TAB_INDEX = 2

local function GetListItemsAsTable(ListView)
  return ListView:GetListItems():ToTable()
end

local function SetWidgetVisibility(Widget, Visibility)
  if Widget and Widget.SetVisibility then
    Widget:SetVisibility(Visibility)
  end
end

local function CreateGamepadKey(KeyWidget, ImgShortPath)
  if not KeyWidget or type(KeyWidget.CreateCommonKey) ~= "function" then
    return
  end
  KeyWidget:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = ImgShortPath}
    }
  })
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.MouseAndKeyboard then
    self:FreshKeyBoardView()
  elseif CurInputDevice == ECommonInputType.Gamepad then
    self:FreshGamepadView()
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.MouseAndKeyboard then
    self:FreshKeyBoardView()
  elseif CurInputType == ECommonInputType.Gamepad then
    self:FreshGamepadView()
  end
end

function M:FreshKeyBoardView()
  self.bNeedInitialRecruitFocus = false
  self.bInitialRecruitFocusDeferred = false
  self.bNeedInitialInviteFocus = false
  self.bInitialInviteFocusDeferred = false
  self.bInviteInitialFocusCanFallbackToRoot = false
  if self.CurMainTabIndex == RECRUIT_TAB_INDEX then
    self:FreshRecruitKeyBoardView()
    return
  end
  if self.CurMainTabIndex == INVITE_TAB_INDEX then
    self:FreshInviteKeyBoardView()
    return
  end
  self:RefreshRecruitShortcutWidgetVisibility(false)
end

function M:FreshGamepadView()
  self:InitGamepadView()
  if not self:CheckNeedAutoFocusWithInputType() then
    self.bNeedInitialRecruitFocus = false
    self.bInitialRecruitFocusDeferred = false
    self.bNeedInitialInviteFocus = false
    self.bInitialInviteFocusDeferred = false
    self.bInviteInitialFocusCanFallbackToRoot = false
    self:RemoveTimer(self.InitialRecruitFocusTimerKey)
    self:RemoveTimer(self.InitialInviteFocusTimerKey)
    return
  end
  if self.CurMainTabIndex == RECRUIT_TAB_INDEX then
    self:RefreshRecruitShortcutWidgetVisibility(true)
    self:RequestInitialRecruitFocusByGamepad()
    return
  end
  if self.CurMainTabIndex == INVITE_TAB_INDEX then
    self:RefreshInviteShortcutWidgetVisibility(true)
    self:RequestInitialInviteFocusByGamepad()
    return
  end
end

function M:InitGamepadView()
  if self.HadGamePadInit then
    return
  end
  self.HadGamePadInit = true
  if self.Btn_Recruit and self.Btn_Recruit.SetGamePadImg then
    self.Btn_Recruit:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonTop)
  end
  if self.Btn_Cancel and self.Btn_Cancel.SetGamePadImg then
    self.Btn_Cancel:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonTop)
  end
  if self.Btn_Refresh and self.Btn_Refresh.SetGamePadImg then
    self.Btn_Refresh:SetGamePadImg(UIConst.GamePadImgKey.RightThumb)
  end
  if self.Sift and self.Com_CheckBox then
    CreateGamepadKey(self.Sift.Img_Key_L, UIConst.GamePadImgKey.LeftThumb)
    self:AddLSFocusTarget(nil, {
      self.Sift,
      self.Com_CheckBox
    })
    SetWidgetVisibility(self.Sift.Img_Key_L, UIConst.VisibilityOp.Collapsed)
  end
  if self.Key_Check_GamePad then
    CreateGamepadKey(self.Key_Check_GamePad, UIConst.GamePadImgKey.RightThumb)
  end
  if self.Key_GamePad then
    CreateGamepadKey(self.Key_GamePad, UIConst.GamePadImgKey.FaceButtonLeft)
    SetWidgetVisibility(self.Key_GamePad, UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshRecruitShortcutWidgetVisibility(bShow)
  local Visibility = bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  if self.Btn_Recruit and self.Btn_Recruit.SetGamepadIconVisibility then
    self.Btn_Recruit:SetGamepadIconVisibility(bShow)
  end
  if self.Btn_Cancel and self.Btn_Cancel.SetGamepadIconVisibility then
    self.Btn_Cancel:SetGamepadIconVisibility(bShow)
  end
  if self.Btn_Refresh and self.Btn_Refresh.SetGamepadIconVisibility then
    self.Btn_Refresh:SetGamepadIconVisibility(bShow)
  end
  if self.Com_CheckBox then
    SetWidgetVisibility(self.Com_CheckBox.Com_KeyImg, UIConst.VisibilityOp.Collapsed)
    if self.Com_CheckBox.Group_BG and not bShow then
      self.Com_CheckBox.Group_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  if self.Sift then
    SetWidgetVisibility(self.Sift.Controller_L, Visibility)
    SetWidgetVisibility(self.Sift.Img_Key_L, Visibility)
    if self.Sift.UpdateGamepadKeyState then
      self.Sift.CurInputDeviceType = bShow and ECommonInputType.Gamepad or ECommonInputType.MouseAndKeyboard
      self.Sift:UpdateGamepadKeyState()
    end
  end
end

function M:RefreshInviteShortcutWidgetVisibility(bShow)
  self:RefreshRecruitShortcutWidgetVisibility(false)
  if self.Key_Check_GamePad then
    local Visibility = bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
    self.Key_Check_GamePad:SetVisibility(Visibility)
  end
  self:RefreshInviteFriendEmptyStateGamepadShortcut(bShow)
end

function M:RefreshInviteFriendEmptyStateGamepadShortcut(bShow)
  SetWidgetVisibility(self.Key_GamePad, bShow and self.bInviteFriendEmptyStateActive and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshInviteFriendEmptyStateGamepadShortcutByState()
  self:RefreshInviteFriendEmptyStateGamepadShortcut(UIUtils.IsGamepadInput())
end

function M:OpenRecruitSiftBoxByGamepad()
  if not self.Sift or type(self.Sift.OpenSiftBox) ~= "function" then
    return false
  end
  self.Sift:OpenSiftBox(self.Sift.SiftModelId)
  return true
end

function M:ToggleRecruitOnlyShowNotFullByGamepad()
  if not self.Com_CheckBox or type(self.Com_CheckBox.IsChecked) ~= "function" then
    return false
  end
  self.Com_CheckBox:SetIsChecked(not self.Com_CheckBox:IsChecked())
  return true
end

function M:ExitLSFocusMode()
  self.CurrentFocusKey = nil
  if self.UpdateGamepadKeyState then
    self:UpdateGamepadKeyState()
  end
  if self.CurMainTabIndex == RECRUIT_TAB_INDEX then
    self:RefreshRecruitShortcutWidgetVisibility(true)
    self:RequestInitialRecruitFocusByGamepad()
  end
end

function M:BP_GetDesiredFocusTarget()
  if self.CurrentFocusKey ~= nil and self.Sift and self.Sift.Button_FIiliter_List then
    return self.Sift.Button_FIiliter_List
  end
  if self.CurMainTabIndex == RECRUIT_TAB_INDEX then
    if self.MineItem and self.MineItem.RecruitmentData then
      return self.MineItem
    end
    if self.List_Team then
      for _, Content in ipairs(GetListItemsAsTable(self.List_Team)) do
        if not Content.IsEmpty and Content.SelfWidget then
          return Content.SelfWidget
        end
      end
    end
  end
  return nil
end

function M:RefreshRecruitListByGamepad()
  if type(self.OnClickRefreshButton) ~= "function" then
    return false
  end
  self:OnClickRefreshButton()
  return true
end

function M:ClickRecruitButtonByGamepad()
  local HallModel = TeamHallController:GetModel()
  local bIsRecruiting = HallModel:IsRecruiting() or HallModel:HasLocalRecruitmentInfo()
  if bIsRecruiting then
    if type(self.OnClickCancelButton) ~= "function" then
      return false
    end
    self:OnClickCancelButton()
    return true
  end
  if "function" ~= type(self.OnClickRecruitButton) then
    return false
  end
  self:OnClickRecruitButton()
  return true
end

function M:OnTeamBoardPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == UIConst.GamePadKey.FaceButtonRight and self.ActiveInvitePlayerMenuItem then
      local InvitePlayerMenuItem = self.ActiveInvitePlayerMenuItem
      InvitePlayerMenuItem.Head_Anchor:Close()
      InvitePlayerMenuItem:SetFocus()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonRight and self.ActiveRecruitmentPlayerMenuItem then
      return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonRight and self:TryHandleFocusedRecruitmentBoardItemGamepadInput(InKeyName) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonRight and self.CurrentFocusKey ~= nil and (not self.Sift or not self.Sift.IsListViewOpened) then
      self:ExitLSFocusMode()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if self:OnKeyDownForLSComp(MyGeometry, InKeyEvent) then
      if InKeyName == UIConst.GamePadKey.FaceButtonRight then
        self:RefreshRecruitShortcutWidgetVisibility(true)
      elseif self.Sift then
        SetWidgetVisibility(self.Sift.Controller_L, UIConst.VisibilityOp.Collapsed)
        SetWidgetVisibility(self.Sift.Img_Key_L, UIConst.VisibilityOp.Collapsed)
      end
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if self:OnGamePadDown(InKeyName, MyGeometry, InKeyEvent) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return BP_UIState_C.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnTeamBoardKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local ParentHandled = BP_UIState_C.OnKeyUp(self, MyGeometry, InKeyEvent)
  if InKeyName == UIConst.GamePadKey.SpecialRight and self.TeamHeadUI then
    self.TeamHeadUI:DoGamepadBtnRelease()
  end
  return ParentHandled
end

function M:OnGamePadDown(InKeyName, MyGeometry, InKeyEvent)
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.TeamHeadUI and self.TeamHeadUI.bIsFocusable then
      self:RestoreTeamBoardInitialFocusByGamepad()
      self.TeamHeadUI.bIsFocusable = false
      return true
    end
    self:OnReturnKeyDown()
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftShoulder or InKeyName == UIConst.GamePadKey.RightShoulder then
    local bHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    if bHandled then
      if self.CurMainTabIndex == RECRUIT_TAB_INDEX then
        self:RefreshRecruitShortcutWidgetVisibility(true)
        self:RequestInitialRecruitFocusByGamepad()
      elseif self.CurMainTabIndex == INVITE_TAB_INDEX then
        self:RefreshInviteShortcutWidgetVisibility(true)
        self:RequestInitialInviteFocusByGamepad()
      end
    end
    return bHandled
  end
  if InKeyName == UIConst.GamePadKey.SpecialRight and self.TeamHeadUI then
    self.TeamHeadUI:DoGamepadBtnPress()
    return true
  end
  if self.CurMainTabIndex == RECRUIT_TAB_INDEX then
    return self:OnRecruitGamePadDown(InKeyName, MyGeometry, InKeyEvent)
  end
  if self.CurMainTabIndex == INVITE_TAB_INDEX then
    return self:OnInviteGamePadDown(InKeyName, MyGeometry, InKeyEvent)
  end
  return false
end

function M:RestoreTeamBoardInitialFocusByGamepad()
  if self.CurMainTabIndex == RECRUIT_TAB_INDEX then
    self:RequestInitialRecruitFocusByGamepad()
    return
  end
  if self.CurMainTabIndex == INVITE_TAB_INDEX then
    self:RequestInitialInviteFocusByGamepad()
    return
  end
  self:SetFocus()
end

function M:OnRecruitmentPlayerMenuOpenChanged(BoardItem, bOpen)
  if bOpen then
    self.ActiveRecruitmentPlayerMenuItem = BoardItem
  elseif self.ActiveRecruitmentPlayerMenuItem == BoardItem then
    self.ActiveRecruitmentPlayerMenuItem = nil
  end
end

function M:OnInvitePlayerMenuOpenChanged(BoardItem, bOpen)
  if bOpen then
    self.ActiveInvitePlayerMenuItem = BoardItem
  elseif self.ActiveInvitePlayerMenuItem == BoardItem then
    self.ActiveInvitePlayerMenuItem = nil
  end
end

function M:TryHandleFocusedRecruitmentBoardItemGamepadInput(InKeyName)
  local function TryHandleBoardItem(BoardItem)
    if BoardItem and BoardItem.Team_Head and BoardItem.Team_Head:HasGamepadHeadFocus() then
      return BoardItem.Team_Head:HandleGamepadHeadFocusInput(InKeyName)
    end
    return false
  end
  
  if TryHandleBoardItem(self.MineItem) then
    return true
  end
  for _, Content in ipairs(GetListItemsAsTable(self.List_Team)) do
    if TryHandleBoardItem(Content.SelfWidget) then
      return true
    end
  end
  return false
end

function M:FreshRecruitKeyBoardView()
  self:RefreshRecruitShortcutWidgetVisibility(false)
end

function M:RequestInitialRecruitFocusByGamepad()
  self.bNeedInitialRecruitFocus = true
  self.bInitialRecruitFocusDeferred = false
  self:RemoveTimer(self.InitialRecruitFocusTimerKey)
  self:TryFocusInitialRecruitmentByGamepad()
end

function M:RestoreRecruitPopupFocusByGamepad(FocusKey)
  if self.CurMainTabIndex ~= RECRUIT_TAB_INDEX then
    return
  end
  self.bNeedInitialRecruitFocus = false
  self.bInitialRecruitFocusDeferred = false
  self:RemoveTimer(self.InitialRecruitFocusTimerKey)
  self.CurrentFocusKey = FocusKey
  self.Sift.Button_FIiliter_List:SetFocus()
  self:RefreshRecruitShortcutWidgetVisibility(true)
  self:UpdateGamepadKeyState(FocusKey)
  SetWidgetVisibility(self.Sift.Controller_L, UIConst.VisibilityOp.Collapsed)
  SetWidgetVisibility(self.Sift.Img_Key_L, UIConst.VisibilityOp.Collapsed)
end

function M:PrepareInitialRecruitFocusAfterListRefresh()
  self.bNeedInitialRecruitFocus = true
  self.bInitialRecruitFocusDeferred = false
  self:RemoveTimer(self.InitialRecruitFocusTimerKey)
end

function M:TryFocusInitialRecruitmentByGamepad()
  DebugPrint("TryFocusInitialRecruitmentByGamepad尝试刷新聚焦")
  if not self.bNeedInitialRecruitFocus then
    return
  end
  if self.CurrentFocusKey ~= nil then
    return
  end
  if self.CurMainTabIndex ~= RECRUIT_TAB_INDEX then
    self.bNeedInitialRecruitFocus = false
    self.bInitialRecruitFocusDeferred = false
    self:RemoveTimer(self.InitialRecruitFocusTimerKey)
    return
  end
  local HallModel = TeamHallController:GetModel()
  if self.MineItem.RecruitmentData and (HallModel:IsRecruiting() or HallModel:HasLocalRecruitmentInfo() or HallModel:IsTeamInRecruiting()) then
    if not self.bInitialRecruitFocusDeferred then
      self.bInitialRecruitFocusDeferred = true
      self:RemoveTimer(self.InitialRecruitFocusTimerKey)
      self:AddTimer(0.05, function()
        if IsValid(self) then
          self:TryFocusInitialRecruitmentByGamepad()
        end
      end, false, 0, self.InitialRecruitFocusTimerKey)
      return
    end
    self.MineItem:SetFocus()
    self.bNeedInitialRecruitFocus = false
    self.bInitialRecruitFocusDeferred = false
    return
  end
  if 1 == self.WS_Detail:GetActiveWidgetIndex() then
    self:SetFocus()
    self.bNeedInitialRecruitFocus = false
    self.bInitialRecruitFocusDeferred = false
    return
  end
  local Items = GetListItemsAsTable(self.List_Team)
  local bHasContent = false
  for _, Content in ipairs(Items) do
    if not Content.IsEmpty then
      bHasContent = true
      if Content.SelfWidget then
        Content.SelfWidget:SetFocus()
        self.bNeedInitialRecruitFocus = false
        self.bInitialRecruitFocusDeferred = false
        return
      end
    end
  end
  if bHasContent and not self.bInitialRecruitFocusDeferred then
    self.bInitialRecruitFocusDeferred = true
    self:RemoveTimer(self.InitialRecruitFocusTimerKey)
    self:AddTimer(0.05, function()
      if IsValid(self) then
        self.bInitialRecruitFocusDeferred = false
        self:TryFocusInitialRecruitmentByGamepad()
      end
    end, false, 0, self.InitialRecruitFocusTimerKey)
    return
  end
  self.bNeedInitialRecruitFocus = false
  self.bInitialRecruitFocusDeferred = false
  self:SetFocus()
end

function M:OnRecruitGamePadDown(InKeyName, MyGeometry, InKeyEvent)
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold or InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
    self.bNeedInitialRecruitFocus = true
    self.bInitialRecruitFocusDeferred = false
    self:RemoveTimer(self.InitialRecruitFocusTimerKey)
    local bHandled = self.Com_TabSub:Handle_KeyEventOnGamePad(InKeyName)
    if not bHandled then
      self.bNeedInitialRecruitFocus = false
    end
    return bHandled
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.CurMainTabIndex == RECRUIT_TAB_INDEX and self.CurrentFocusKey ~= nil then
    if self.Sift and self.Sift:HasFocusedDescendants() then
      return false
    end
    return self:ToggleRecruitOnlyShowNotFullByGamepad()
  end
  if InKeyName == UIConst.GamePadKey.RightThumb then
    return self:RefreshRecruitListByGamepad()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    return self:ClickRecruitButtonByGamepad()
  end
  return false
end

function M:FreshInviteKeyBoardView()
  self:RefreshInviteShortcutWidgetVisibility(false)
end

function M:RequestInitialInviteFocusByGamepad()
  self:PrepareInitialInviteFocusAfterListRefresh()
  self:TryFocusInitialInviteByGamepad()
end

function M:PrepareInitialInviteFocusAfterListRefresh()
  self.bNeedInitialInviteFocus = true
  self.bInitialInviteFocusDeferred = false
  self.bInviteInitialFocusCanFallbackToRoot = false
  self:RemoveTimer(self.InitialInviteFocusTimerKey)
end

function M:TryFocusInitialInviteByGamepad()
  self:RefreshInviteFriendEmptyStateGamepadShortcutByState()
  if not self.bNeedInitialInviteFocus then
    return
  end
  if self.CurMainTabIndex ~= INVITE_TAB_INDEX then
    self.bNeedInitialInviteFocus = false
    self.bInitialInviteFocusDeferred = false
    self.bInviteInitialFocusCanFallbackToRoot = false
    self:RemoveTimer(self.InitialInviteFocusTimerKey)
    return
  end
  if not self.List_MyFriend then
    return
  end
  local Contents = GetListItemsAsTable(self.List_MyFriend)
  local Content = Contents[1]
  if Content then
    self.List_MyFriend:BP_CancelScrollIntoView()
    self.List_MyFriend:BP_SetSelectedItem(Content)
    self.List_MyFriend:BP_NavigateToItem(Content)
    if Content.UI and self.bInitialInviteFocusDeferred and self.List_MyFriend:BP_IsItemVisible(Content) then
      Content.UI:SetFocus()
      self.bNeedInitialInviteFocus = false
      self.bInitialInviteFocusDeferred = false
      return
    end
    self.bInitialInviteFocusDeferred = true
    self:RemoveTimer(self.InitialInviteFocusTimerKey)
    self:AddTimer(0.05, function()
      if IsValid(self) then
        self:TryFocusInitialInviteByGamepad()
      end
    end, false, 0, self.InitialInviteFocusTimerKey)
    return
  end
  if #Contents <= 0 and self.bInviteInitialFocusCanFallbackToRoot then
    self:SetFocus()
    self.bNeedInitialInviteFocus = false
    self.bInitialInviteFocusDeferred = false
    self.bInviteInitialFocusCanFallbackToRoot = false
    return
  end
  if not self.bInitialInviteFocusDeferred then
    self.bInitialInviteFocusDeferred = true
    self:RemoveTimer(self.InitialInviteFocusTimerKey)
    self:AddTimer(0.05, function()
      if IsValid(self) then
        self.bInitialInviteFocusDeferred = false
        self:TryFocusInitialInviteByGamepad()
      end
    end, false, 0, self.InitialInviteFocusTimerKey)
  end
end

function M:ToggleInviteOnlineFilterByGamepad()
  local bChecked = not self.bFilterOnline
  self.bNeedInitialInviteFocus = true
  self.CheckBox_Online:SetCheckedState(bChecked and ECheckBoxState.Checked or ECheckBoxState.Unchecked)
  self:OnOnlineCheckBoxChange(bChecked)
  return true
end

function M:OnInviteGamePadDown(InKeyName, MyGeometry, InKeyEvent)
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold or InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
    local bHandled = self.Com_TabSub:Handle_KeyEventOnGamePad(InKeyName)
    if bHandled then
      self:RequestInitialInviteFocusByGamepad()
    end
    return bHandled
  end
  if InKeyName == UIConst.GamePadKey.RightThumb then
    return self:ToggleInviteOnlineFilterByGamepad()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft and self.bInviteFriendEmptyStateActive then
    self:OnClickInviteAddFriend()
    return true
  end
  return false
end

return M
