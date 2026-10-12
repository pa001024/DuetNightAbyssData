require("UnLua")
local ActivityUtils = require("BluePrints.UI.WBP.Activity.ActivityUtils")
local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
local M = Class({
  "BluePrints.UI.Common.WBP_Common_Activity_Settlement_C"
})

function M:InitParams(Params)
  M.Super.InitParams(self, Params)
  self:InitExtraButtonBinds()
  DebugPrint("ljl@ GuildWar_Settlement Params", CommonUtils.TableToString(Params))
end

function M:InitExtraButtonBinds()
  self.Btn_RetryFloor_S:BindEventOnClicked(self, self.OnContinueClicked)
  self.Btn_GotoFloor:BindEventOnClicked(self, self.OnBtnGotoFloorClicked)
  self.Btn_QuickGo:BindEventOnClicked({
    Inst = self,
    Func = self.OnQuickGoToggled
  })
end

function M:InitUI()
  M.Super.InitUI(self)
  self.Btn_GotoFloor:SetText(GText("Raid_Season_Floor_Enter"))
  if self.Params and self.Params.IsWin then
    self:PlayExtraTargetAndUnlockTip()
  else
    self:FillSettlementFailTips()
  end
  self:InitJumpFloorSelector()
  self:InitQuickGoVisibility()
end

function M:PlayExtraTargetAndUnlockTip()
  local DungeonId = self.Params and self.Params.DungeonId
  local PassTime = not self.Params or self.Params.PassTime or self.Params.TimeRemain
  local RaidSeasonId = self.Params and self.Params.RaidSeasonId
  local RaidSeasonConf = RaidSeasonId and DataMgr.RaidSeason and DataMgr.RaidSeason[RaidSeasonId]
  local DungeonConf = DungeonId and DataMgr.Dungeon and DataMgr.Dungeon[DungeonId]
  if not (RaidSeasonConf and DungeonConf) or not RaidSeasonConf.JumpTime then
    return
  end
  local TimeRemain = DungeonConf.BPOverrideVars.TimeLimit - (PassTime or 0)
  self.Panel_Floor:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.VB_Floor:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Num_Time:SetText(string.format("%d:%05.2f", math.floor(TimeRemain / 60), TimeRemain % 60))
  self.Text_Floor:SetText(string.format(GText("Raid_Season_Floor_Finish_Floor"), self.Params.Floor))
  self.Text_NewRecord:SetText(GText("UI_SettlementPage_NewRecord"))
  if self.Params and self.Params.IsNewRecord then
    self.Text_NewRecord:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    self.Text_NewRecord:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  local SeasonData = self:GetRaidSeasonData()
  local isPreRaid = GuildWarUtils.IsPreRaidTime()
  local CurrentUnlockFloor = SeasonData and (isPreRaid and SeasonData.PreRaidUnlockFloor or SeasonData.RaidUnlockFloor) or 0
  local CombatData = GWorld.GameInstance and GWorld.GameInstance.CombatData
  local HistoryUnlockFloor = CombatData and CombatData.HistoryMaxUnlockFloor or 0
  local bNewUnlock = CurrentUnlockFloor > HistoryUnlockFloor
  local Targets = {}
  for _, JumpTime in ipairs(RaidSeasonConf.JumpTime) do
    if JumpTime and TimeRemain >= JumpTime then
      table.insert(Targets, {
        Text = string.format("%s > %d", GText("RaidDungeon_Time_Remain"), JumpTime),
        IsFinish = true
      })
    end
  end
  local bShowExtraTarget = bNewUnlock and #Targets > 0
  if bShowExtraTarget then
    self.Settlement_ExtraTarget:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Settlement_ExtraTarget:InitExtraTargets(Targets, GText("Raid_Season_Floor_Target"))
  else
    self.Settlement_ExtraTarget:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  local UnlockFloorCount = CommonUtils.RaidSeasonGetUnlockFloorCount(RaidSeasonId, DungeonId, PassTime or 0)
  if bNewUnlock and UnlockFloorCount > 0 then
    self.Text_UnlockTip:SetText(string.format(GText("Raid_Season_Floor_Unlock_Floor"), UnlockFloorCount))
    self.Panel_UnLockTip:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    self.Panel_UnLockTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:InitJumpFloorSelector()
  self.HasJumpFloorTarget = false
  if not self.Btn_SelectFloor then
    return
  end
  local SeasonData = self:GetRaidSeasonData()
  if not SeasonData then
    return
  end
  local isPreRaid = GuildWarUtils.IsPreRaidTime()
  local MaxUnlockFloor = isPreRaid and SeasonData.PreRaidUnlockFloor or SeasonData.RaidUnlockFloor
  local PassedFloor = isPreRaid and SeasonData.PreRaidFloor or SeasonData.RaidFloor
  if not MaxUnlockFloor or MaxUnlockFloor <= 0 then
    return
  end
  local Hi = MaxUnlockFloor
  local Lo = PassedFloor or 0
  if Lo < 1 then
    Lo = 1
  end
  if Hi < Lo then
    Lo = Hi
  end
  local Options = {}
  local Cur = Hi
  while Lo <= Cur and #Options < 10 do
    table.insert(Options, {Floor = Cur})
    Cur = Cur - 1
  end
  if 0 == #Options then
    return
  end
  self.JumpFloorOptions = Options
  local CombatData = GWorld.GameInstance and GWorld.GameInstance.CombatData
  local BeforeUnlockFloor = CombatData and CombatData.HistoryMaxUnlockFloor or 0
  local HasHigherFloor = MaxUnlockFloor > (PassedFloor or 0)
  local bNewUnlock = MaxUnlockFloor > BeforeUnlockFloor
  self.HasJumpFloorTarget = HasHigherFloor and bNewUnlock
  DebugPrint("ljl@ JumpFloorTarget", "isPreRaid", isPreRaid, "MaxUnlockFloor", MaxUnlockFloor, "PassedFloor", PassedFloor, "BeforeUnlockFloor", BeforeUnlockFloor, "HasHigherFloor", HasHigherFloor, "bNewUnlock", bNewUnlock, "#Options", #Options)
  local Texts = {}
  for i, Opt in ipairs(Options) do
    Texts[i] = string.format(GText("Raid_Season_Floor_UI_Floor"), Opt.Floor)
  end
  self.Btn_SelectFloor:Init(Texts, "Menu", self)
  self.Btn_SelectFloor:BindEventOnSelectionsChanged(self, self.OnJumpFloorSelected)
  self.SelectedJumpFloorOption = Options[1]
end

function M:GetRaidSeasonData()
  if not self.Params or not self.Params.RaidSeasonId then
    return nil
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.RaidSeasons then
    return nil
  end
  return Avatar.RaidSeasons[self.Params.RaidSeasonId]
end

function M:OnJumpFloorSelected(Index)
  if self.JumpFloorOptions and self.JumpFloorOptions[Index] then
    self.SelectedJumpFloorOption = self.JumpFloorOptions[Index]
    DebugPrint("ljl@ OnJumpFloorSelected Index", Index, "Floor", self.SelectedJumpFloorOption.Floor)
  else
    return
  end
  if self.IsFocusSelectFloor then
    self:ExitSelectFloorFocus(false)
  end
end

function M:GetSelectedJumpFloor()
  return self.SelectedJumpFloorOption
end

function M:OnBtnGotoFloorClicked()
  local Opt = self:GetSelectedJumpFloor()
  if not Opt or not Opt.Floor then
    return
  end
  local isPreRaid = GuildWarUtils.IsPreRaidTime()
  local FloorType = isPreRaid and CommonConst.RaidDungeonType.Pre or CommonConst.RaidDungeonType.Formal
  local FloorId = GuildWarUtils.GetRaidFloorId(Opt.Floor, self.Params.RaidSeasonId, FloorType)
  DebugPrint("ljl@ OnBtnGotoFloorClicked FloorId", FloorId)
  if not FloorId then
    return
  end
  local RaidFloorConf = DataMgr.RaidFloor[FloorId]
  local DungeonId = RaidFloorConf and RaidFloorConf.DungeonId or self.Params.DungeonId
  self:RequestEnterDungeon(DungeonId, self.Params.ActivityId, FloorId)
end

function M:OnContinueClicked()
  local IsOpen = ActivityUtils.CheckEventIsOpen(self.Params.ActivityId, nil, false)
  if self.Params.CheckOpenActivityId then
    IsOpen = ActivityUtils.CheckEventIsOpen(self.Params.CheckOpenActivityId, nil, false)
  end
  if not IsOpen then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GameEvent_EventEnd"))
    return
  end
  self:RequestEnterDungeon(self.Params.DungeonId, self.Params.ActivityId, self.Params.FloorId)
end

function M:RequestEnterDungeon(DungeonId, EventId, FloorId)
  if self.IsEnteringDungeon then
    return
  end
  self.IsEnteringDungeon = true
  self:BlockAllUIInput(true)
  local SendSuc = GuildWarUtils.EnterGuildWarAgain(DungeonId, EventId, FloorId, function(RetCode)
    self.IsEnteringDungeon = false
    DebugPrint("ljl@ RequestEnterDungeon callback RetCode", RetCode)
    if not ErrorCode:Check(RetCode) then
      self:BlockAllUIInput(false)
      return
    end
    if self.Params.IsWin then
      self:PlayAnimation(self.Out)
    else
      self:PlayAnimation(self.Fail_Out)
    end
  end)
  if false == SendSuc then
    self.IsEnteringDungeon = false
    self:BlockAllUIInput(false)
  end
end

function M:InitQuickGoVisibility()
  self.Btn_QuickGo.Text_Button:SetText(GText("Raid_Season_Floor_Speed_Enter"))
  local IsWin = self.Params and self.Params.IsWin
  if false == IsWin or nil == IsWin then
    self:UpdateQuickGoUI(false, false)
    return
  end
  local IsChecked = EMCache:Get(GuildWarUtils.RaidQuickGoCacheKey)
  if nil == IsChecked then
    IsChecked = true
  end
  self.Btn_QuickGo:SetIsCheckedWithoutCallback(IsChecked)
  self:UpdateQuickGoUI(IsChecked, true)
end

function M:OnQuickGoToggled(IsChecked)
  DebugPrint("ljl@ OnQuickGoToggled", IsChecked)
  EMCache:Set(GuildWarUtils.RaidQuickGoCacheKey, IsChecked)
  self:UpdateQuickGoUI(IsChecked, true)
end

function M:UpdateQuickGoUI(IsChecked, bShowQuickGo)
  IsChecked = IsChecked and true or false
  if false == bShowQuickGo then
    self.Btn_QuickGo:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_SelectFloor:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:SetQuickGoButtons(false)
    self:UpdateSelectFloorKeyHints()
    return
  end
  self.Btn_QuickGo:SetVisibility(UE4.ESlateVisibility.Visible)
  self.Btn_SelectFloor:SetVisibility(UE4.ESlateVisibility.Visible)
  self:SetJumpFloorSelectorEnable(IsChecked)
  self:SetQuickGoButtons(IsChecked)
  self:UpdateQuickGoGrayState(IsChecked)
end

function M:UpdateQuickGoGrayState(bEnabled)
  self:PlayGrayStateAnim(self.Btn_QuickGo, bEnabled)
  self:PlayGrayStateAnim(self.Btn_SelectFloor, bEnabled)
end

function M:PlayGrayStateAnim(Widget, bEnabled)
  if not IsValid(Widget) then
    return
  end
  local Anim = bEnabled and Widget.Select or Widget.UnSelect
  if Anim then
    EMUIAnimationSubsystem:EMPlayAnimation(Widget, Anim)
  end
end

function M:SetJumpFloorSelectorEnable(bEnable)
  if not self.Btn_SelectFloor then
    return
  end
  self.Btn_SelectFloor:SetListForbidden(not bEnable)
  self:UpdateSelectFloorKeyHints()
end

function M:UpdateSelectFloorKeyHints()
  if not self.Btn_SelectFloor then
    return
  end
  local bAvailable = self.Btn_SelectFloor:IsVisible() and not self.Btn_SelectFloor:GetListForbidden()
  local bFocused = self.IsFocusSelectFloor or self.IsFocusList
  self.Btn_SelectFloor:HideGamePadIcon(not bAvailable or not not bFocused, "GuildWarFloor")
end

function M:SetQuickGoButtons(IsChecked)
  local HideWhenChecked = IsChecked and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.Visible
  self.Btn_Continue:SetVisibility(HideWhenChecked)
  self.Panel_Again:SetVisibility(HideWhenChecked)
  local ShowWhenChecked = IsChecked and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed
  self.Btn_RetryFloor_S:SetVisibility(ShowWhenChecked)
  self.Panel_Retry:SetVisibility(ShowWhenChecked)
  self.Btn_GotoFloor:SetVisibility(ShowWhenChecked)
  self.Panel_Goto:SetVisibility(ShowWhenChecked)
  local AlwaysShow = UE4.ESlateVisibility.Visible
  self.Btn_Exit:SetVisibility(AlwaysShow)
  self.Panel_Exit:SetVisibility(AlwaysShow)
end

function M:FillSettlementFailTips()
  self.Panel_UnLockTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Settlement_ExtraTarget:SetVisibility(UE4.ESlateVisibility.Collapsed)
  if not self.List_FailTips then
    return
  end
  local Tips = {
    "Raid_Season_Floor_Lost_Tips1",
    "Raid_Season_Floor_Lost_Tips2",
    "Raid_Season_Floor_Lost_Tips3"
  }
  self.List_FailTips:ClearListItems()
  for _, Text in ipairs(Tips) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Text = GText(Text)
    self.List_FailTips:AddItem(Content)
  end
end

function M:ApplyBtnGamePad(Btn, KeyName, bSetupImg)
  if not IsValid(Btn) then
    return
  end
  if bSetupImg then
    if Btn.SetGamePadImg then
      Btn:SetGamePadImg(KeyName)
    end
  elseif Btn.SetGamePadVisibility then
    Btn:SetGamePadVisibility(KeyName)
  end
end

function M:SetupGamepadControls()
  M.Super.SetupGamepadControls(self)
  if self.Controller_Retry and self.Controller_Retry.CreateCommonKey then
    self.Controller_Retry:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Y"}
      }
    })
  end
  self:ApplyBtnGamePad(self.Btn_GotoFloor, "X", true)
  if self.Btn_QuickGo then
    self.Btn_QuickGo:InitGamepadKey("RS")
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  M.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Gamepad then
    local bNeedReset = self.IsFocusSelectFloor or self.IsFocusList
    self.IsFocusSelectFloor = false
    self.IsFocusList = false
    if bNeedReset then
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
      self:SetFocus()
    end
  else
    self.IsFocusSelectFloor = false
    self.IsFocusList = false
  end
  if self.Panel_Controller_Retry then
    self.Panel_Controller_Retry:SetVisibility(CurInputDevice == ECommonInputType.MouseAndKeyboard and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.Visible)
  end
  if self.Controller_Retry then
    self.Controller_Retry:SetVisibility(CurInputDevice == ECommonInputType.MouseAndKeyboard and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.Visible)
  end
  self:ApplyBtnGamePad(self.Btn_GotoFloor, CurInputDevice == ECommonInputType.MouseAndKeyboard and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.Visible, false)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.IsFocusSelectFloor then
    if InKeyName == Const.GamepadFaceButtonRight then
      self:ExitSelectFloorFocus(true)
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if InKeyName == Const.GamepadFaceButtonRight or InKeyName == Const.GamepadLeftThumbstick then
    local Ret = M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
    self:UpdateExtraKeyHintsByState()
    return Ret
  end
  if self.IsFocusList then
    return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
  end
  if InKeyName == Const.GamepadSpecialRight then
    return self:HandleGamepadSelectFloor()
  elseif InKeyName == Const.GamepadRightThumbstick then
    return self:HandleGamepadQuickGoToggle()
  elseif InKeyName == Const.GamepadFaceButtonLeft then
    return self:HandleGamepadGotoFloor()
  end
  return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:IsWidgetGamepadAvailable(Widget, bCheckEnable)
  if not IsValid(Widget) or not Widget:IsVisible() then
    return false
  end
  if bCheckEnable and Widget:GetIsEnabled() == false then
    return false
  end
  return true
end

function M:HandleGamepadSelectFloor()
  if not self:IsWidgetGamepadAvailable(self.Btn_SelectFloor) or self.Btn_SelectFloor:GetListForbidden() then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  self.Btn_SelectFloor:Activate()
  self.IsFocusSelectFloor = true
  self:UpdateExtraKeyHintsByState()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:ExitSelectFloorFocus(bCloseList)
  self.IsFocusSelectFloor = false
  if bCloseList and self.Btn_SelectFloor then
    self.Btn_SelectFloor:Activate()
  end
  self:UpdateExtraKeyHintsByState()
  self:SetFocus()
end

function M:GetDesiredFocusTarget()
  return self
end

function M:UpdateExtraKeyHintsByState()
  local bGamepad = self.CurInputDeviceType == ECommonInputType.Gamepad
  local bFocused = self.IsFocusList or self.IsFocusSelectFloor
  local Op = UE4.ESlateVisibility.Collapsed
  if bGamepad and not bFocused then
    Op = UE4.ESlateVisibility.Visible
  end
  self:ApplyBtnGamePad(self.Btn_Exit, Op, false)
  self:ApplyBtnGamePad(self.Btn_Continue, Op, false)
  self:ApplyBtnGamePad(self.Btn_GotoFloor, Op, false)
  if self.Panel_Controller_Retry then
    self.Panel_Controller_Retry:SetVisibility(Op)
  end
  if self.Controller_Retry then
    self.Controller_Retry:SetVisibility(Op)
  end
  if self.Btn_QuickGo and self.Btn_QuickGo.Com_KeyImg then
    self.Btn_QuickGo.Com_KeyImg:SetVisibility(Op)
  end
  self:UpdateSelectFloorKeyHints()
end

function M:HandleGamepadQuickGoToggle()
  if not self:IsWidgetGamepadAvailable(self.Btn_QuickGo) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  self.Btn_QuickGo:Activate()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:HandleGamepadGotoFloor()
  if not self:IsWidgetGamepadAvailable(self.Btn_GotoFloor) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  self:OnBtnGotoFloorClicked()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

return M
