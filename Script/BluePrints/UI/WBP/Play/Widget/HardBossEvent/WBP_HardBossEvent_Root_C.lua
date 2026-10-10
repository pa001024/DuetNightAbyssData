require("UnLua")
local HardBossEventController = require("BluePrints.UI.WBP.Play.Widget.HardBossEvent.HardBossEventController")
local PAGE_SELECT = 0
local PAGE_DETAIL = 1
local RESTORE_REWARD_FOCUS_TIMER = "HardBossEventRestoreRewardFocus"
local RESTORE_FOCUS_TIMER = "HardBossEventRestoreFocus"
local RESTORE_FOCUS_RETRY_TIMER = "HardBossEventRestoreFocusRetry"
local M = Class("BluePrints.UI.BP_UIState_C")

local function DisableKVActivationLeaf(Widget)
  if not IsValid(Widget) then
    return
  end
  Widget.bSupportsActivationFocus = false
  Widget.bIsBackHandler = false
  Widget.bAutoActivate = false
  if Widget.SetIsFocusable then
    Widget:SetIsFocusable(false)
  elseif Widget.bIsFocusable ~= nil then
    Widget.bIsFocusable = false
  end
  if Widget.DeactivateWidget then
    pcall(function()
      Widget:DeactivateWidget()
    end)
  end
end

function M:Initialize(Initializer)
  self.EventId = nil
  self.ActivityConfig = nil
  self.CurrentPageIndex = nil
  self.BossBackground = nil
  self.SelectPageInitialized = false
  self.TeamHeadUI = nil
  self.DetailSwitchOutPending = false
  self.GameInputModeSubsystem = nil
  self.EntryStateDispatcherBound = false
  self.SystemUIUnloadDispatcherBound = false
end

function M:OnGlobalKeyPressedForEsc(Key, AnyHandled)
  local KeyName = Key and tostring(Key.KeyName) or ""
  if self.IsBeginToClose or self.IsMarkToRemove or not self.IsInit then
    return
  end
  local IsBackKey = "Escape" == KeyName or "Android_Back" == KeyName
  local UIMgr = UIManager(self)
  if IsBackKey and UIMgr and UIMgr.IsMenuAnchorOpen and not self:IsOtherUIOnTop() then
    if AnyHandled then
      AnyHandled.bHandled = true
    end
    UE4.UWidgetBlueprintLibrary.DismissAllMenus()
    self:RestoreKeyboardFocusToPage()
    return
  end
  if not self:CanTakeOverWhenFocusLost() then
    return
  end
  if IsBackKey then
    if AnyHandled then
      AnyHandled.bHandled = true
    end
    self:OnReturnKeyDown()
  end
  self:RestoreKeyboardFocusToPage()
end

local UI_ABOVE_NOT_STACKED = {
  "ChatMain",
  "CommonDialog",
  "WalnutRewardDialog",
  "MonsterDetailInfo",
  "HardBossEventEnvironment",
  "OptionalPatch",
  "DungeonMatchTimingBar"
}

function M:IsOtherUIOnTop()
  local UIMgr = UIManager(self)
  if not UIMgr or not UIMgr.GetUIObj then
    return false
  end
  for _, UIName in ipairs(UI_ABOVE_NOT_STACKED) do
    local UI = UIMgr:GetUIObj(UIName)
    if IsValid(UI) and UI:IsVisible() and (not UI.IsInViewport or UI:IsInViewport()) then
      return true
    end
  end
  return false
end

function M:CanTakeOverWhenFocusLost()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    return false
  end
  local UIMgr = UIManager(self)
  if not UIMgr or type(UIMgr.GetCurrentState) ~= "function" or UIMgr:GetCurrentState() ~= self then
    return false
  end
  if self:HasAnyUserFocus() or self:HasFocusedDescendants() then
    return false
  end
  if "function" == type(UIMgr.GetCurrentFocusedUserWidget) and IsValid(UIMgr:GetCurrentFocusedUserWidget(0)) then
    return false
  end
  if self:IsOtherUIOnTop() then
    return false
  end
  return true
end

function M:RestoreKeyboardFocusToPage()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    return
  end
  self:RemoveTimer(RESTORE_FOCUS_TIMER)
  self:RemoveTimer(RESTORE_FOCUS_RETRY_TIMER)
  
  local function TryRestore()
    if not IsValid(self) or self.IsBeginToClose then
      return
    end
    local UIMgr = UIManager(self)
    if UIMgr and type(UIMgr.GetCurrentState) == "function" and UIMgr:GetCurrentState() ~= self then
      return
    end
    if self:HasAnyUserFocus() or self:HasFocusedDescendants() then
      return
    end
    if UIMgr and "function" == type(UIMgr.GetCurrentFocusedUserWidget) and IsValid(UIMgr:GetCurrentFocusedUserWidget(0)) then
      return
    end
    if self:IsOtherUIOnTop() then
      return
    end
    local Target
    if self.CurrentPageIndex == PAGE_SELECT and self.SelectPage then
      Target = self.SelectPage.List_Boss
    elseif self.CurrentPageIndex == PAGE_DETAIL and self.DetailPage then
      Target = self.DetailPage.ScrollBox_List
    end
    if IsValid(Target) then
      Target:SetFocus()
    end
  end
  
  self:AddTimer(0.1, TryRestore, false, 0, RESTORE_FOCUS_TIMER, true)
  self:AddTimer(0.35, TryRestore, false, 0, RESTORE_FOCUS_RETRY_TIMER, true)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  if self:IsOtherUIOnTop() then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local Target = self.GetBackgroundClickFocusTarget and self:GetBackgroundClickFocusTarget() or nil
  if IsValid(Target) then
    return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), Target)
  end
  self:RestoreKeyboardFocusToPage()
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnLoaded(EventId)
  HardBossEventController:Init(EventId)
  self.EventId, self.ActivityConfig = HardBossEventController:GetRootPageData()
  self:InitCommonTab()
  self:InitTeamInfo()
  self:ShowHardBossSelect(true)
  if not self.EntryStateDispatcherBound then
    self:AddDispatcher(EventID.EntryReceiveEnterState, self, self.OnEntryReceiveEnterState)
    self.EntryStateDispatcherBound = true
  end
  if not self.SystemUIUnloadDispatcherBound then
    self:AddDispatcher(EventID.UnLoadUI, self, self.OnSystemUIUnLoad)
    self.SystemUIUnloadDispatcherBound = true
  end
  EventManager:AddEvent(EventID.GameViewportInputKeyPressed, self, self.OnGlobalKeyPressedForEsc)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType())
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  if self.In then
    self:PlayAnimation(self.In)
  end
end

function M:InitCommonTab()
  local TitleName = self.ActivityConfig and self.ActivityConfig.EventName
  self.Tab:Init({
    LeftKey = "NotShow",
    RightKey = "NotShow",
    Tabs = {},
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BottomKeyInfo = {},
    StyleName = "Text",
    TitleName = GText(TitleName or "UI_HardBossEvent_BattleStart"),
    OwnerPanel = self,
    BackCallback = self.OnReturnKeyDown
  })
end

function M:InitTeamInfo()
  if self.TeamHeadUI then
    return
  end
  local AttachWidget = self:GetTeamHeadAttachWidget()
  if not AttachWidget then
    return
  end
  self.TeamHeadUI = TeamController:OpenHeadUI(AttachWidget)
  
  function self.TeamHeadUI.OnTeamMainFocusChanged(bFocused)
    self:SetKeyTipsVisibleByTeamFocus(bFocused)
  end
end

function M:SetKeyTipsVisibleByTeamFocus(bFocused)
  local Visibility = bFocused and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible
  local KeyWidgets = {}
  if self.Tab.Com_KeyTips then
    KeyWidgets[#KeyWidgets + 1] = self.Tab.Key_Left
    KeyWidgets[#KeyWidgets + 1] = self.Tab.Key_Right
    KeyWidgets[#KeyWidgets + 1] = self.Tab.Com_KeyTips.Panel_Key
  end
  if self.SelectPage then
    KeyWidgets[#KeyWidgets + 1] = self.SelectPage.Key_Rewards
    KeyWidgets[#KeyWidgets + 1] = self.SelectPage.Btn_Enter.Key_GamePad
  end
  for Index = 1, #KeyWidgets do
    local KeyWidget = KeyWidgets[Index]
    if IsValid(KeyWidget) then
      KeyWidget:SetVisibility(Visibility)
    end
  end
end

function M:GetTeamHeadAttachWidget()
  if not IsValid(self.Tab) then
    return nil
  end
  local AttachWidget = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and self.Tab.Panel_Team or self.Tab.Group_Team
  if IsValid(AttachWidget) then
    AttachWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  return AttachWidget
end

function M:ReleaseTeamInfo()
  if not self.TeamHeadUI then
    return
  end
  local AttachWidget = self:GetTeamHeadAttachWidget()
  if AttachWidget and TeamController:GetHeadUI(AttachWidget) == self.TeamHeadUI then
    self.TeamHeadUI:Close()
    AttachWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.TeamHeadUI = nil
end

function M:ShowHardBossSelect(IsInitial)
  if not IsInitial and self.CurrentPageIndex == PAGE_DETAIL then
    self:PlayDetailOut(function()
      self:EnterHardBossSelect(IsInitial)
    end)
    return
  end
  self:EnterHardBossSelect(IsInitial)
end

function M:EnterHardBossSelect(IsInitial)
  self.CurrentPageIndex = PAGE_SELECT
  self.WS_Page:SetActiveWidgetIndex(PAGE_SELECT)
  if IsInitial or not self.SelectPageInitialized then
    self.SelectPage:Init(self.EventId, self)
    self.SelectPageInitialized = true
  end
  self:UpdateHardBossBottomKeys()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:FocusCurrentBoss()
  end
  self:RefreshChatRender()
end

function M:ShowHardBossDetail(HardBossDungeonId)
  if not HardBossDungeonId then
    return
  end
  self.CurrentPageIndex = PAGE_DETAIL
  self.WS_Page:SetActiveWidgetIndex(PAGE_DETAIL)
  self.DetailPage:InitHardBossDetail(self, HardBossDungeonId)
  self:UpdateHardBossBottomKeys()
  self:RefreshChatRender()
  self:PlayDetailIn()
end

function M:PlayDetailIn()
  local DetailPage = self.DetailPage
  if not IsValid(DetailPage) or not DetailPage.In then
    return
  end
  if DetailPage.Out then
    DetailPage:UnbindAllFromAnimationFinished(DetailPage.Out)
    DetailPage:StopAnimation(DetailPage.Out)
  end
  self.DetailSwitchOutPending = false
  DetailPage:PlayAnimation(DetailPage.In)
end

function M:PlayDetailOut(OnFinished)
  local DetailPage = self.DetailPage
  if not IsValid(DetailPage) or not DetailPage.Out then
    OnFinished()
    return
  end
  if self.DetailSwitchOutPending then
    return
  end
  self.DetailSwitchOutPending = true
  DetailPage:UnbindAllFromAnimationFinished(DetailPage.Out)
  DetailPage:BindToAnimationFinished(DetailPage.Out, {
    self,
    function()
      self.DetailSwitchOutPending = false
      if not IsValid(self) then
        return
      end
      OnFinished()
    end
  })
  DetailPage:PlayAnimation(DetailPage.Out)
end

function M:RefreshChatRender()
  local GroupChat = self.Tab and self.Tab.Group_Chat
  if not GroupChat then
    return
  end
  local Chat = GroupChat:GetChildAt(0)
  if Chat and Chat.NotInvalidationBoxCacheForAWhile then
    Chat:NotInvalidationBoxCacheForAWhile(self)
  end
end

function M:OnBossSelected(BossConfig, IsFirstTime)
  self:RefreshBossBackground(BossConfig)
  if not IsFirstTime and self.Change then
    self:PlayAnimation(self.Change)
  end
end

function M:RefreshBossBackground(BossConfig)
  local BackgroundPath = BossConfig and BossConfig.MainIcon
  if not BackgroundPath then
    return
  end
  local Background = UIManager(self):CreateWidget(BackgroundPath, false)
  if not Background then
    return
  end
  self:StopBossBackgroundAnimation()
  self.Group_BossAnchor:ClearChildren()
  self.Group_BossAnchor:AddChild(Background)
  self.BossBackground = Background
  DisableKVActivationLeaf(Background)
  Background:SetVisibility(ESlateVisibility.Visible)
  local BackgroundSlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Background)
  if BackgroundSlot then
    BackgroundSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    BackgroundSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  end
  self:PlayBossBackgroundIn()
end

function M:PlayBossBackgroundIn()
  local BackgroundWidget = self.BossBackground and self.BossBackground.WBP_AreaCoop_LoadingBG
  if not BackgroundWidget or not BackgroundWidget.In then
    return
  end
  BackgroundWidget:UnbindAllFromAnimationFinished(BackgroundWidget.In)
  BackgroundWidget:BindToAnimationFinished(BackgroundWidget.In, {
    self,
    function()
      if BackgroundWidget.Loop then
        BackgroundWidget:PlayAnimation(BackgroundWidget.Loop)
      end
    end
  })
  BackgroundWidget:StopAllAnimations()
  BackgroundWidget:PlayAnimation(BackgroundWidget.In)
end

function M:StopBossBackgroundAnimation()
  local BackgroundWidget = self.BossBackground and self.BossBackground.WBP_AreaCoop_LoadingBG
  if not BackgroundWidget then
    return
  end
  if BackgroundWidget.In then
    BackgroundWidget:UnbindAllFromAnimationFinished(BackgroundWidget.In)
  end
  BackgroundWidget:StopAllAnimations()
end

function M:OnReturnKeyDown()
  if self.CurrentPageIndex == PAGE_DETAIL then
    self:ShowHardBossSelect(false)
    return
  end
  if self.SelectPage and self.SelectPage.HardBossFocusMode == "REWARD" then
    self.SelectPage:LeaveHardBossRewardMode()
    return
  end
  self:Close()
end

function M:Close()
  if self.IsBeginToClose then
    return
  end
  self:ReleaseTeamInfo()
  M.Super.Close(self)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  self.SelectPage:RefreshOpInfoByInputDevice(CurInputDevice)
  if CurInputDevice == ECommonInputType.Gamepad then
    self:UpdateHardBossBottomKeys()
    self:FocusCurrentBoss()
  end
end

function M:FocusCurrentBoss()
  if self.CurrentPageIndex == PAGE_SELECT and self.SelectPage then
    self.SelectPage:FocusCurrentBoss()
  end
end

function M:UpdateHardBossBottomKeys()
  if not self.Tab or self.CurrentPageIndex == nil then
    return
  end
  if type(self.Tab.UpdateBottomKeyInfo) ~= "function" then
    return
  end
  local KeyInfoList = {
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
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  }
  if self.CurrentPageIndex == PAGE_SELECT and self.SelectPage then
    if self.SelectPage.HardBossFocusMode == "BOSS" then
      table.insert(KeyInfoList, 1, {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "LS"}
        },
        Desc = GText("UI_Controller_CheckReward"),
        bLongPress = false
      })
    elseif self.SelectPage.HardBossFocusMode == "REWARD" then
      table.insert(KeyInfoList, 1, {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Controller_CheckDetails"),
        bLongPress = false
      })
    end
  end
  self.Tab:UpdateBottomKeyInfo(KeyInfoList)
end

function M:BP_GetDesiredFocusTarget()
  if self.CurrentPageIndex == PAGE_SELECT and self.SelectPage then
    local Target = self.SelectPage:GetCurrentBossFocusTarget()
    return Target
  end
  return nil
end

function M:GetBackgroundClickFocusTarget()
  if self.CurrentPageIndex == PAGE_SELECT and self.SelectPage then
    return self.SelectPage:GetCurrentBossFocusTarget()
  end
  if self.CurrentPageIndex == PAGE_DETAIL and self.DetailPage then
    return self.DetailPage.ScrollBox_List
  end
  return nil
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  self:RestoreRewardFocusAfterStackReturn(StackAction)
end

function M:OnEntryReceiveEnterState(StackAction)
  self:RestoreRewardFocusAfterStackReturn(StackAction)
end

function M:OnSystemUIUnLoad(UIName)
  if "ChatMain" == UIName then
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
      if self.CurrentPageIndex == PAGE_SELECT and self.SelectPage then
        self.SelectPage:FocusCurrentBoss()
      elseif self.CurrentPageIndex == PAGE_DETAIL and self.DetailPage then
        self.DetailPage:SelectCellFocus()
      end
    else
      self:RestoreKeyboardFocusToPage()
    end
    return
  end
  if "WalnutRewardDialog" ~= UIName then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    self:RestoreKeyboardFocusToPage()
    return
  end
  if self.CurrentPageIndex == PAGE_DETAIL and self.DetailPage then
    self.DetailPage:RestoreFocusAfterSystemUI()
    return
  end
  if not self.SelectPage or not self.SelectPage.HardBossRewardDetailOpen then
    return
  end
  self:RemoveTimer(RESTORE_REWARD_FOCUS_TIMER)
  self:AddTimer(0.1, function()
    if not IsValid(self) or self.CurrentPageIndex ~= PAGE_SELECT or not IsValid(self.SelectPage) then
      return
    end
    self.SelectPage:RestoreHardBossRewardFocusAfterDetail()
  end, false, 0, RESTORE_REWARD_FOCUS_TIMER, true)
end

function M:RestoreRewardFocusAfterStackReturn(StackAction)
  if not (1 == StackAction and self.CurrentPageIndex == PAGE_SELECT and self.SelectPage) or UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or not self.SelectPage.HardBossRewardDetailOpen then
    return
  end
  self:RemoveTimer(RESTORE_REWARD_FOCUS_TIMER)
  self:AddTimer(0.05, function()
    if IsValid(self) and self.CurrentPageIndex == PAGE_SELECT and IsValid(self.SelectPage) then
      self.SelectPage:RestoreHardBossRewardFocusAfterDetail()
    end
  end, false, 0, RESTORE_REWARD_FOCUS_TIMER, true)
end

function M:IsDetailActive()
  return self.CurrentPageIndex == PAGE_DETAIL
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.SpecialRight then
      if self.TeamHeadUI and self.TeamHeadUI.DoGamepadBtnPress then
        self.TeamHeadUI:DoGamepadBtnPress()
        return UIUtils.Handled
      end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight and self.TeamHeadUI and self.TeamHeadUI.bIsFocusable then
      self.TeamHeadUI.bIsFocusable = false
      if self.CurrentPageIndex == PAGE_SELECT then
        self:FocusCurrentBoss()
      elseif self.DetailPage and self.DetailPage.SelectCellFocus then
        self.DetailPage:SelectCellFocus()
      end
      return UIUtils.Handled
    end
    if self.CurrentPageIndex == PAGE_SELECT and self.SelectPage and self.SelectPage:HandleHardBossGamepadKey(InKeyName) then
      return UIUtils.Handled
    end
  elseif "Escape" == InKeyName or "Android_Back" == InKeyName then
    self:OnReturnKeyDown()
    return UIUtils.Handled
  end
  return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local ParentHandled = M.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.SpecialRight and self.TeamHeadUI and self.TeamHeadUI.DoGamepadBtnRelease then
    self.TeamHeadUI:DoGamepadBtnRelease()
  end
  return ParentHandled
end

function M:OnDestroyed()
  self:RemoveTimer(RESTORE_REWARD_FOCUS_TIMER)
  self:RemoveTimer(RESTORE_FOCUS_TIMER)
  self:RemoveTimer(RESTORE_FOCUS_RETRY_TIMER)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
  if self.EntryStateDispatcherBound then
    self:RemoveDispatcher(EventID.EntryReceiveEnterState)
  end
  if self.SystemUIUnloadDispatcherBound then
    self:RemoveDispatcher(EventID.UnLoadUI)
  end
  EventManager:RemoveEvent(EventID.GameViewportInputKeyPressed, self)
  self:StopBossBackgroundAnimation()
  HardBossEventController:Destory()
  self.EventId = nil
  self.ActivityConfig = nil
  self.CurrentPageIndex = nil
  self.BossBackground = nil
  self.SelectPageInitialized = false
  self.TeamHeadUI = nil
  self.GameInputModeSubsystem = nil
  self.EntryStateDispatcherBound = false
  self.SystemUIUnloadDispatcherBound = false
end

return M
