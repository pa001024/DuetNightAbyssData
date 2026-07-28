require("UnLua")
local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
local UIUtils = require("Utils.UIUtils")
local LevelDetail = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WBP_Activity_Weapon_LevelDetail_C")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
  local EventId, DungeonId = ...
  self.EventId = EventId or Model.GetDefaultEventId()
  self.LevelTabWidgets = {
    self.Level01,
    self.Level02,
    self.Level03
  }
  self.bInDetail = false
  self.bIsFocusable = true
  if IsValid(self.BtnReward) then
    self.BtnReward:SetData(self.EventId, self, self.OnClickReward)
  end
  if IsValid(self.BtnImg) then
    self.BtnImg:BindEventOnClicked(self, self.OnBtnImgClicked)
  end
  self:InitCommonTab()
  self:InitGroupSwitchKeys()
  self:InitGroupTabs()
  self:SelectGroup(self:GetDefaultGroupIndex())
  if IsValid(self.ListLevel) then
    self.ListLevel:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.ListLevel:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  end
  self.Detail = LevelDetail.New(self)
  if DungeonId and self.Detail then
    self.Detail:Open(DungeonId)
  else
    self:ShowSelectPanel()
    self:PlayAnimation(self.In)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "WeaponVerifyLevelMain", nil)
end

function M:InitGroupSwitchKeys()
  if UIUtils.IsMobileInput() then
    if IsValid(self.Ws_Key_L) then
      self.Ws_Key_L:SetVisibility(ESlateVisibility.Collapsed)
    end
    if IsValid(self.Ws_Key_R) then
      self.Ws_Key_R:SetVisibility(ESlateVisibility.Collapsed)
    end
    self:RefreshAffixKey(false)
    return
  end
  if IsValid(self.Key_Left) then
    self.Key_Left:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LB"}
      },
      bAllowForbid = true
    })
  end
  if IsValid(self.Key_LeftText) then
    self.Key_LeftText:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          Text = UE4.EKeys.Q.KeyName
        }
      },
      bAllowForbid = true
    })
  end
  if IsValid(self.Key_Right) then
    self.Key_Right:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RB"}
      },
      bAllowForbid = true
    })
  end
  if IsValid(self.Key_RightText) then
    self.Key_RightText:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          Text = UE4.EKeys.E.KeyName
        }
      },
      bAllowForbid = true
    })
  end
  local PC = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.KeySubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PC)
  if IsValid(self.KeySubsystem) then
    self.KeySubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChangedForKeys)
    self:RefreshGroupSwitchKeys(self.KeySubsystem:GetCurrentInputType() == ECommonInputType.Gamepad)
  end
end

function M:OnInputMethodChangedForKeys(CurInputDevice)
  self:RefreshGroupSwitchKeys(CurInputDevice == ECommonInputType.Gamepad)
end

function M:RefreshGroupSwitchKeys(IsUseGamePad)
  local Idx = IsUseGamePad and 0 or 1
  if IsValid(self.Ws_Key_L) then
    self.Ws_Key_L:SetActiveWidgetIndex(Idx)
  end
  if IsValid(self.Ws_Key_R) then
    self.Ws_Key_R:SetActiveWidgetIndex(Idx)
  end
  if not self.bInDetail then
    self:RefreshBottomKeyTips(IsUseGamePad)
  end
  self:RefreshBtnAllKey(IsUseGamePad)
  self:RefreshAffixKey(IsUseGamePad)
  if IsValid(self.BtnReward) then
    self.BtnReward:RefreshGamepadKey(IsUseGamePad)
  end
  if not IsUseGamePad then
    self:ClearGamepadHover()
    if not self.bInDetail then
      self:FocusSelfForKeyboard()
    end
  elseif not self.bInDetail then
    self:FocusLevelListDeferred()
  end
end

function M:ClearGamepadHover()
  if self.GamepadFocusedItem and IsValid(self.GamepadFocusedItem) then
    self.GamepadFocusedItem:SetGamepadHover(false)
    self.GamepadFocusedItem = nil
  end
end

function M:FocusLevelListDeferred()
  self:AddTimer(0.05, function()
    if self.bInDetail or not IsValid(self.ListLevel) then
      return
    end
    local Num = self.ListLevel:GetNumItems()
    if Num <= 0 then
      return
    end
    local Idx = self.GamepadFocusedIndex or 0
    if Idx < 0 or Num <= Idx then
      Idx = 0
    end
    self.ListLevel:NavigateToIndex(Idx)
    self.ListLevel:SetFocus()
  end, false)
end

function M:FocusSelfForKeyboard()
  if UIUtils.IsGamepadInput() then
    return
  end
  self:AddTimer(0.05, function()
    if not IsValid(self) or self.bInDetail then
      return
    end
    self:SetFocus()
  end, false)
end

function M:RefreshBottomKeyTips(IsUseGamePad)
  if not IsValid(self.WBP_Com_Tab_P) then
    return
  end
  self.WBP_Com_Tab_P:UpdateBottomKeyInfo({
    {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Tips_Close")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.CloseSelf,
          Owner = self
        }
      },
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    }
  })
  self.WBP_Com_Tab_P:SetBottomKeyInfoVisible(true)
end

function M:GetCommonTab()
  if IsValid(self.WBP_Com_Tab_P) then
    return self.WBP_Com_Tab_P
  end
  return self.WBP_Com_Tab_M
end

function M:InitCommonTab()
  local Tab = self:GetCommonTab()
  if not IsValid(Tab) then
    return
  end
  self.ComTab = Tab
  Tab:Init({
    DynamicNode = {"Back"},
    TitleName = GText("UI_WeaponVerify_LevelPage_Des"),
    OwnerPanel = self,
    BackCallback = self.CloseSelf,
    LeftKey = "NotShow",
    RightKey = "NotShow"
  })
  local PosCommon = Tab.Pos_Common
  if IsValid(PosCommon) then
    PosCommon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    PosCommon:ClearChildren()
    self.BtnAll = UIManager(self):_CreateWidgetNew("ActivityWeaponBtnAll")
    if IsValid(self.BtnAll) then
      PosCommon:AddChild(self.BtnAll)
      if IsValid(self.BtnAll.Text_Build) then
        self.BtnAll.Text_Build:SetText(GText("UI_WeaponVerify_ShowLineup"))
      end
      if IsValid(self.BtnAll.Btn_Click) then
        self.BtnAll.Btn_Click.OnClicked:Add(self, self.OnBtnAllClicked)
      end
      self:RefreshBtnAllKey(UIUtils.IsGamepadInput())
    end
  end
end

function M:RefreshBtnAllKey(IsUseGamePad)
  if not IsValid(self.BtnAll) or not IsValid(self.BtnAll.Key_Controller) then
    return
  end
  if IsUseGamePad then
    self.BtnAll.Key_Controller:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
    self.BtnAll.Key_Controller:SetVisibility(ESlateVisibility.HitTestInvisible)
  else
    self.BtnAll.Key_Controller:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:RefreshAffixKey(IsUseGamePad)
  if not IsValid(self.WBP_Com_KeyImg) then
    return
  end
  if IsUseGamePad then
    self.WBP_Com_KeyImg:CreateGamepadKey(UIConst.GamePadImgKey.SpecialLeft)
    self.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.HitTestInvisible)
  else
    self.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:CloseSelf()
  if self.bInDetail and self.Detail then
    self.Detail:OnEscKey()
  else
    self:Close()
  end
end

function M:Close()
  AudioManager(self):SetEventSoundParam(self, "WeaponVerifyLevelMain", {ToEnd = 1})
  EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
  EventManager:FireEvent(EventID.OnReturnToActivityEntry)
  M.Super.Close(self)
end

function M:OnDestroyed()
  if IsValid(self.BtnImg) then
    self.BtnImg:UnBindEventOnClickedByObj(self)
  end
  if IsValid(self.BtnAll) and IsValid(self.BtnAll.Btn_Click) then
    self.BtnAll.Btn_Click.OnClicked:Remove(self, self.OnBtnAllClicked)
  end
  if IsValid(self.BtnAll) then
    self.BtnAll:RemoveFromParent()
  end
  if IsValid(self.KeySubsystem) then
    self.KeySubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChangedForKeys)
    self.KeySubsystem = nil
  end
  if self.Detail then
    self.Detail:Destroy()
    self.Detail = nil
  end
  Model.ClearEditSelect()
  M.Super.OnDestroyed(self)
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  if self.bInDetail and self.Detail then
    self.Detail:ReceiveEnterStateSelf(StackAction)
  end
end

function M:InitGroupTabs()
  self.GroupList = Model.GetGroupList(self.EventId)
  self.FlattenLevels = nil
  for i, Tab in ipairs(self.LevelTabWidgets) do
    local Group = self.GroupList[i]
    if Group and IsValid(Tab) then
      Tab:SetVisibility(ESlateVisibility.Visible)
      Tab:SetData({
        Index = i,
        GroupId = Group.GroupId,
        EventId = self.EventId,
        Unlocked = Model.IsGroupUnlocked(self.EventId, Group.GroupId),
        Owner = self,
        OnClick = self.OnClickGroupTab
      })
    elseif IsValid(Tab) then
      Tab:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
end

function M:GetDefaultGroupIndex()
  return 1
end

function M:OnClickGroupTab(Index, GroupId, Unlocked)
  if not Unlocked then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_WeaponVerify_Des1"), 1.5)
    return
  end
  if Index == self.CurGroupIndex then
    return
  end
  self:SelectGroup(Index)
  self:PlayChangeListAnim()
end

function M:SelectGroup(Index)
  if not self.GroupList or not self.GroupList[Index] then
    return
  end
  self.CurGroupIndex = Index
  for i, Tab in ipairs(self.LevelTabWidgets) do
    if self.GroupList[i] and IsValid(Tab) then
      Tab:SetSelected(i == Index)
    end
  end
  local Group = self.GroupList[Index]
  self:RefreshAffixTips(Group.GroupId)
  self:RefreshLevelList(Group.GroupId)
end

function M:RefreshAffixTips(GroupId)
  self.CurGroupId = GroupId
  if IsValid(self.TextTips) then
    self.TextTips:SetText(GText("UI_WeaponVerify_GroupEntry"))
  end
  if not IsValid(self.ListBuffIIcon) then
    return
  end
  self.ListBuffIIcon:ClearListItems()
  for _, AffixId in ipairs(Model.GetGroupAffixIds(GroupId)) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.AffixId = AffixId
    self.ListBuffIIcon:AddItem(Content)
  end
end

function M:OnBtnImgClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  if not self.CurGroupId then
    return
  end
  UIManager(self):ShowCommonPopupUI(100412, {
    GroupId = self.CurGroupId,
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = self.OnTeamPopUpClosed
  })
end

function M:OnBtnAllClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  UIManager(self):ShowCommonPopupUI(100411, {
    EventId = self.EventId,
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = self.OnTeamPopUpAllClosed
  })
end

function M:OnDungeonReset()
  if self.CurGroupId then
    self:RefreshLevelList(self.CurGroupId)
  end
  if self.bInDetail and self.Detail then
    self.Detail:RefreshDetail()
  end
  if IsValid(self.BtnReward) then
    self.BtnReward:Refresh()
  end
end

function M:OnTeamPopUpAllClosed()
  self:OnDungeonReset()
  self:OnTeamPopUpClosed()
end

function M:OnTeamPopUpClosed()
  if self.bInDetail then
    if self.Detail then
      self.Detail:RequestRestoreDefaultFocus()
    end
    return
  end
  if UIUtils.IsGamepadInput() then
    self:FocusLevelListDeferred()
  else
    self:FocusSelfForKeyboard()
  end
end

function M:RefreshLevelList(GroupId)
  if not IsValid(self.ListLevel) then
    return
  end
  self:ClearGamepadHover()
  self.ListLevel:ClearListItems()
  for _, Cfg in ipairs(Model.GetLevelList(self.EventId, GroupId)) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.EventId = self.EventId
    Content.DungeonId = Cfg.EventLevelId
    Content.Owner = self
    self.ListLevel:AddItem(Content)
  end
  if UIUtils.IsGamepadInput() and not self.bInDetail then
    self:FocusLevelListDeferred()
  end
end

function M:OnClickReward(EventId)
  if IsValid(self.BtnReward) then
    self.BtnReward:OpenRewardPopup(self, self.OnTeamPopUpClosed)
  end
end

function M:ShowSelectPanel()
  self.bInDetail = false
  if IsValid(self.Panel_Conten01) then
    self.Panel_Conten01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if IsValid(self.Panel_Conten02) then
    self.Panel_Conten02:SetVisibility(ESlateVisibility.Collapsed)
  end
  Model.ClearEditSelect()
  if self.Detail and self.Detail.DungeonId then
    self:SyncGroupByDungeon(self.Detail.DungeonId)
  end
  if self.CurGroupIndex then
    self:SelectGroup(self.CurGroupIndex)
  end
  self:FocusSelfForKeyboard()
  if self.Change_Out then
    self:PlayAnimation(self.Change_Out)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/wuqijiaoyan_level_info_in", nil, nil)
end

function M:ShowDetailPanel()
  self.bInDetail = true
  if IsValid(self.Panel_Conten01) then
    self.Panel_Conten01:SetVisibility(ESlateVisibility.Collapsed)
  end
  if IsValid(self.Panel_Conten02) then
    self.Panel_Conten02:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if self.Change then
    self:PlayAnimation(self.Change)
  elseif self.Detail then
    self.Detail:RefreshDetail()
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/wuqijiaoyan_level_info_in", nil, nil)
end

function M:PlayListIn()
  self.IsPlayList = true
  if not self.List_In then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.List_In)
end

function M:PlayListOut()
  self.IsPlayList = false
  if not self.List_Out then
    self.Panel_List:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.List_Out)
end

function M:PlayBuffIn()
  self.IsPlayBuff = true
  if not self.Buff_In then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Buff_In)
end

function M:PlayBuffOut()
  self.IsPlayBuff = false
  if not self.Buff_Out then
    self.Panel_Buff:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Buff_Out)
end

function M:OnAnimationFinished(Animation)
  if Animation == self.List_Out then
    if not self.IsPlayList then
      self.Panel_List:SetVisibility(ESlateVisibility.Collapsed)
    end
  elseif Animation == self.Buff_Out and not self.IsPlayBuff then
    self.Panel_Buff:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnClickLevel(DungeonId)
  if self.Detail then
    self.Detail:Open(DungeonId)
  end
end

function M:GetAdjacentDungeon(DungeonId, Step)
  if not (DungeonId and Step) or not self.GroupList then
    return nil
  end
  if not self.FlattenLevels then
    local FlattenLevels = {}
    for _, Group in ipairs(self.GroupList) do
      for _, Cfg in ipairs(Model.GetLevelList(self.EventId, Group.GroupId)) do
        table.insert(FlattenLevels, Cfg)
      end
    end
    self.FlattenLevels = FlattenLevels
  end
  for i, Cfg in ipairs(self.FlattenLevels) do
    if Cfg.EventLevelId == DungeonId then
      local Adj = self.FlattenLevels[i + Step]
      return Adj and Adj.EventLevelId or nil
    end
  end
  return nil
end

function M:SyncGroupByDungeon(DungeonId)
  if not DungeonId or not self.GroupList then
    return
  end
  local LevelCfg = Model.GetLevelCfg(DungeonId)
  if not LevelCfg then
    return
  end
  for i, Group in ipairs(self.GroupList) do
    if Group.GroupId == LevelCfg.GroupId then
      self.CurGroupId = Group.GroupId
      if i ~= self.CurGroupIndex then
        self.CurGroupIndex = i
      end
      return
    end
  end
end

function M:OnDetailRequestBack()
  self:ShowSelectPanel()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.bInDetail and self.Detail then
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if self.Detail:OnPreviewGamePadDown(InKeyName) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = true
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Top" == InKeyName then
      self:OnClickReward(self.EventId)
    elseif "Gamepad_Special_Right" == InKeyName then
      self:OnBtnAllClicked()
    elseif "Gamepad_Special_Left" == InKeyName and not self.bInDetail then
      self:OnBtnImgClicked()
    elseif "Gamepad_LeftShoulder" == InKeyName and not self.bInDetail then
      self:SwitchGroupByStep(-1)
    elseif "Gamepad_RightShoulder" == InKeyName and not self.bInDetail then
      self:SwitchGroupByStep(1)
    elseif "Gamepad_FaceButton_Right" == InKeyName then
      self:CloseSelf()
    else
      IsHandled = false
    end
  elseif "Escape" == InKeyName then
    self:CloseSelf()
  elseif "Q" == InKeyName and not self.bInDetail then
    self:SwitchGroupByStep(-1)
  elseif "E" == InKeyName and not self.bInDetail then
    self:SwitchGroupByStep(1)
  else
    IsHandled = false
  end
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return IsHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  if not IsHandled and self.bInDetail and self.Detail then
    IsHandled = self.Detail:OnGamePadDown(InKeyName)
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPreviewMouseButtonDown(MyGeometry, MouseEvent)
  if self.bInDetail and self.Detail then
    self.Detail:OnPreviewMouseButtonDown(MouseEvent)
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:SwitchGroupByStep(Step)
  if self.bInDetail then
    return
  end
  if not self.GroupList then
    return
  end
  local Count = #self.GroupList
  if Count <= 1 then
    return
  end
  local Target = (self.CurGroupIndex or 1) + Step
  if Target < 1 or Count < Target then
    return
  end
  if Target == self.CurGroupIndex then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_sub_level_btn_click", nil, nil)
  self:SelectGroup(Target)
  self:PlayChangeListAnim()
end

function M:PlayChangeListAnim()
  if not self.Change_List then
    return
  end
  self:StopAnimation(self.Change_List)
  self:PlayAnimation(self.Change_List)
end

function M:PlayChangeAnim(Step)
  if Step > 0 and self.Change_R then
    self:PlayAnimation(self.Change_R)
  elseif Step < 0 and self.Change_L then
    self:PlayAnimation(self.Change_L)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.Detail then
    self.Detail:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  end
end

function M:BP_GetDesiredFocusTarget()
  if self.bInDetail and self.Detail then
    return self.Detail:BP_GetDesiredFocusTarget()
  end
  return self
end

function M:Change_Info()
  if self.bInDetail and self.Detail then
    self.Detail:Change_Info()
  end
end

return M
