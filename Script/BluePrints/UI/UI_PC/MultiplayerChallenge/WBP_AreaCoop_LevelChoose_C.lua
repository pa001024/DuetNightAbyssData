require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local MultiplayerChallengeModel = require("BluePrints.UI.UI_PC.MultiplayerChallenge.AreaCoop_LevelChoose_Model")
local MonsterUtils = require("Utils.MonsterUtils")
local GamePadComp = require("BluePrints.UI.UI_PC.MultiplayerChallenge.WBP_AreaCoop_LevelChoose_GamePadCompoment")
local PCBuildBPPath = "WidgetBlueprint'/Game/UI/WBP/Build/PC/WBP_Build_DefaultList_P.WBP_Build_DefaultList_P'"
local MobileBuildBPPath = "WidgetBlueprint'/Game/UI/WBP/Build/Mobile/WBP_Build_DefaultList_M.WBP_Build_DefaultList_M'"
M._components = {
  "BluePrints.UI.UI_PC.MultiplayerChallenge.WBP_AreaCoop_LevelChoose_GamePadCompoment"
}

function M:Initialize(Initializer)
  self.IsSoloStart = false
  self.MultiWalnut = false
  self.MultiTicket = false
  self.CurSelectedDungeonId = nil
  self.IsGamePad = false
  self.MonsterIdToItem = {}
end

function M:Construct()
  self.Super.Construct(self)
  if self.AddDispatcher then
    self:AddDispatcher(EventID.TeamMatchTimingStart, self, self.TeamMatchTimingStart)
    self:AddDispatcher(EventID.TeamMatchTimingEnd, self, self.TeamMatchTimingEnd)
    self:AddDispatcher(EventID.CurrentSquadChange, self, self.OnCurrentSquadChange)
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  if UGameInputModeSubsystem and PlayerController then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if IsValid(self.GameInputModeSubsystem) and self.RefreshOpInfoByInputDevice then
      self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
  end
  if self.In then
    self:PlayAnimation(self.In)
  end
  if self.SetFocus then
    self:SetFocus()
  end
  self:InitWidgetInfoInGamePad()
  self:StaticInit()
  self.ScrollBox_Desc:ScrollToStart()
end

function M:Destruct()
  local IsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
  local TargetGroup = IsMobile and self.Group_Mob or self.Group_PC
  TargetGroup:ClearChildren()
  self:EndInteractive()
  self.Super.Destruct(self)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:ReceiveEnterState(StackAction)
  if 1 == StackAction then
    self:AddTimer(0.1, function()
      self:SetFocus()
    end)
    self.DefaultList:RefreshData()
  end
  M.Super.ReceiveEnterState(self, StackAction)
end

function M:OnLoaded(ChallengeId)
  if type(ChallengeId) == "table" then
    if ChallengeId.ChallengeId then
      ChallengeId = ChallengeId.ChallengeId
    else
      ScreenPrint("需要传入表，包含 MultiplayerChallenge 字段")
      DebugPrintTable(ChallengeId)
    end
  end
  ChallengeId = tonumber(ChallengeId)
  self.ChallengeId = ChallengeId
  MultiplayerChallengeModel:Init(ChallengeId)
  self:RefreshBtnState(false)
  self:InitBaseInfo()
  self:InitDungeonInfo()
  self:InitTeamInfo()
end

function M:StaticInit()
  if self.Text_BossRewards then
    self.Text_BossRewards:SetText(GText("UI_HardBoss_Preview"))
  end
  if self.Common_Button_Text_PC and self.Common_Button_Text_PC.SetText then
    self.Common_Button_Text_PC:SetText(GText("UI_HardBoss_Start"))
  end
  if self.Btn_Coop and self.Btn_Coop.SetText then
    self.Btn_Coop:SetText(GText("DUNGEONMATCH_START"))
  end
  if self.Text_Monster then
    self.Text_Monster:SetText(GText("UI_DUNGEON_MonsterType"))
  end
  if self.Text_EliteTitle then
    self.Text_EliteTitle:SetText(GText("UI_Dungeon_SpecialMonster"))
  end
  if self.Common_Button_Close_PC and self.Common_Button_Close_PC.BindEventOnClicked then
    self.Common_Button_Close_PC:BindEventOnClicked(self, self.OnClickClose)
  end
  if self.Common_Button_Text_PC and self.Common_Button_Text_PC.BindEventOnClicked then
    self.Common_Button_Text_PC:BindEventOnClicked(self, self.OnClickChallenge)
    if self.Common_Button_Text_PC.BindForbidStateExecuteEvent then
      self.Common_Button_Text_PC:BindForbidStateExecuteEvent(self, self.OnClickChallengeForbid)
    end
  end
  if self.Btn_Coop and self.Btn_Coop.BindEventOnClicked then
    self.Btn_Coop:BindEventOnClicked(self, self.OnClickChallenge_Multi)
    if self.Btn_Coop.BindForbidStateExecuteEvent then
      self.Btn_Coop:BindForbidStateExecuteEvent(self, self.OnClickChallengeForbid)
    end
  end
  if self.Btn_Qa then
    self.Btn_Qa.Btn_Click.OnClicked:Add(self, self.OpenDetails)
  end
end

function M:InitTeamInfo()
  local AttachWidget = self:GetAttachWidget()
  if TeamController and TeamController.OpenHeadUI2 and not self.TeamHeadUI then
    self.TeamHeadUI = TeamController:OpenHeadUI2(AttachWidget)
    if self.TeamHeadUI then
      function self.TeamHeadUI.OnTeamMainFocusChanged(bFocused)
        local Visibility = bFocused and "Collapsed" or "SelfHitTestInvisible"
        
        local KeyWidgets = {}
        if self.Btn_Coop and self.Btn_Coop.Key_GamePad then
          table.insert(KeyWidgets, self.Btn_Coop.Key_GamePad)
        end
        if self.Common_Button_Text_PC and self.Common_Button_Text_PC.Key_GamePad then
          table.insert(KeyWidgets, self.Common_Button_Text_PC.Key_GamePad)
        end
        if self.Key_Title_Rewards then
          table.insert(KeyWidgets, self.Key_Title_Rewards)
        end
        for _, KeyWidget in ipairs(KeyWidgets) do
          if KeyWidget and KeyWidget.SetVisibility then
            KeyWidget:SetVisibility(UIConst.VisibilityOp[Visibility])
          end
        end
      end
    end
  end
end

function M:InitDungeonInfo()
  local cfg = DataMgr.MultiplayerChallenge[self.ChallengeId]
  local dungeonId
  if cfg and type(cfg.DungeonId) == "table" and #cfg.DungeonId > 0 then
    dungeonId = cfg.DungeonId[1]
  elseif cfg and type(cfg.DungeonId) == "number" then
    dungeonId = cfg.DungeonId
  end
  if dungeonId then
    self.CurSelectedDungeonId = dungeonId
    local DungeonLevel = DataMgr.Dungeon[dungeonId].DungeonLevel
    if DungeonLevel then
      self.Text_BossLv:SetText("Lv." .. DungeonLevel)
    end
    self:InitOrRefreshSquadPreset(dungeonId)
    self:RefreshMonsterInfoList(dungeonId)
    self:InitEliteItem(dungeonId)
    self:RefreshRewardsListByDungeon(dungeonId)
    if PageJumpUtils and PageJumpUtils.CheckDungeonCondition and DataMgr.Dungeon[dungeonId] then
      self.IsLocked = not PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[dungeonId].Condition)
      self:RefreshBtnState(false)
    end
  else
    DebugPrint("OnLoaded: No DungeonId configured for ChallengeId", tostring(self.ChallengeId))
  end
end

function M:InitEliteItem(DungeonId)
  if not self.EliteItem then
    return
  end
  self.EliteItem.ParentPage = self
  local DungeonData = DataMgr.Dungeon[DungeonId]
  if not DungeonData then
    self.EliteItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local MonIds = DataMgr.ModDungeon2RewardId[DungeonId]
  if not MonIds or 0 == #MonIds then
    ScreenPrint("没找到对应地牢的精英怪物ID" .. tostring(DungeonId))
    return
  end
  local MonRewardId = MonIds[1]
  if not MonRewardId then
    self.EliteItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local MonRewardData = DataMgr.ModDungeonMonReward[MonRewardId]
  if not MonRewardData then
    self.EliteItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local Content = {
    DungeonData = DungeonData,
    MonRewardData = MonRewardData,
    ParentWidget = self
  }
  self.EliteItem:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.EliteItem:OnListItemObjectSet(Content)
end

function M:GetCurDungeonId()
  return self.CurSelectedDungeonId
end

function M:OnClickChallenge()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local DungeonId = self:GetCurDungeonId()
  if not DungeonId then
    return
  end
  if not (PageJumpUtils and PageJumpUtils.CheckDungeonCondition) or not PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[DungeonId].Condition) then
    if self.OnClickChallengeForbid then
      self:OnClickChallengeForbid()
    end
    return
  end
  if Avatar:IsInTeam() then
    if TeamController and TeamController.GetModel then
      TeamController:GetModel().bPressedSolo = true
    end
    self:EnterStandalone()
  else
    self:OpenTicketDialog_Solo()
  end
end

function M:OnClickClose()
  self:OnReturnKeyDown()
end

function M:GetAttachWidget()
  local AttachWidget = self.Group_Team or self
  if AttachWidget and AttachWidget.SetVisibility then
    AttachWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  return AttachWidget
end

function M:RefreshBtnState(bInIsMatching)
  local IsMatching = bInIsMatching
  if nil == IsMatching and self.IsMatching then
    IsMatching = self:IsMatching()
  end
  local Forbid = IsMatching or self.IsLocked == true
  if self.Btn_Coop then
    self.Btn_Coop:SetVisibility(IsMatching and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.Btn_Coop.ForbidBtn then
      self.Btn_Coop:ForbidBtn(Forbid)
    end
  end
  if self.Common_Button_Text_PC then
    self.Common_Button_Text_PC:SetVisibility(IsMatching and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.Common_Button_Text_PC.ForbidBtn then
      self.Common_Button_Text_PC:ForbidBtn(Forbid)
    end
  end
  local CurSelectedDungeonId = self:GetCurDungeonId()
  if CurSelectedDungeonId then
    local CurSelectedDungeonData = DataMgr.Dungeon[CurSelectedDungeonId]
    if CurSelectedDungeonData and CurSelectedDungeonData.bDisableMatch then
      self.Btn_Coop:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
end

function M:IsMatching()
  return TeamController and TeamController:GetModel():IsMatching() or false
end

function M:TryEnterDungeon(Avatar, DungeonId, DungeonNetMode, OtherCallback, TicketId)
  if not TeamController or not TeamController:DoCheckCanEnterDungeon(DungeonId) then
    DebugPrint("DoCheckCanEnterDungeon bTeammateNotReady")
    if TeamController and TeamController:GetModel() then
      TeamController:GetModel().bPressedSolo = false
      TeamController:GetModel().bPressedMulti = false
    end
    return
  end
  DebugPrint("TryEnterDungeon ", Avatar, DungeonId, DungeonNetMode, OtherCallback, TicketId)
  Avatar:EnterDungeon(DungeonId, DungeonNetMode, OtherCallback, TicketId, self.SquadId or 0)
end

function M.HandleEnterDungeonRetCode(RetCode, ...)
  DebugPrint("EnterDungeonCallback RetCode", RetCode)
  if RetCode == ErrorCode.RET_SUCCESS then
    return true
  else
    if TeamController and TeamController.DoWhenEnterDungeonCheckFailed then
      TeamController:DoWhenEnterDungeonCheckFailed(RetCode, ...)
    end
    EventManager:FireEvent(EventID.TeamMatchTimingEnd)
    return false
  end
end

function M:OnClickChallenge_Multi()
  local Avatar = GWorld:GetAvatar()
  assert(Avatar, "NO AVATAR")
  if not Avatar:CheckUIUnlocked("Match") then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(DataMgr.UIUnlockRule.Match.UIUnlockDesc))
    return
  end
  local DungeonId = self:GetCurDungeonId()
  if not DungeonId then
    return
  end
  if not PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[DungeonId].Condition) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Tosat_Level_Locked"))
    return
  end
  if self:IsAnimationPlaying(self.Out_Loading) then
    return
  end
  self:TryEnterMultiDungeon(DungeonId)
end

function M:TryEnterMultiDungeon(DungeonId)
  TeamController:GetModel().bPressedMulti = true
  local Avatar = GWorld:GetAvatar()
  assert(Avatar, "NO AVATAR")
  self:TryEnterDungeon(Avatar, DungeonId, CommonConst.DungeonNetMode.DedicatedServer, function(RetCode, ...)
    local bCanEnter = M.HandleEnterDungeonRetCode(RetCode, ...)
    DebugPrint("@WBP_AreaCoop_LevelChoose_C:OnClickChallenge_Multi", bCanEnter)
    if bCanEnter then
      local bIsInTeam = Avatar:IsInTeam()
      if bIsInTeam then
        UIManager(self):LoadUINew("DungeonMatchTimingBar", DungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, true)
      else
        UIManager(self):LoadUINew("DungeonMatchTimingBar", DungeonId, Const.DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING_WITH_CANCEL, true)
      end
    end
  end, self.TicketId)
  self:RefreshBtnState()
end

function M:OpenTicketDialog_Solo()
  local DungeonId = self:GetCurDungeonId()
  if not DungeonId then
    return
  end
  UIManager(self):ShowCommonPopupUI(100123, {
    DungeonId = DungeonId,
    RightCallbackObj = self,
    RightCallbackFunction = function(Obj, PackageData)
      self.TicketId = PackageData and PackageData.Content_1 and PackageData.Content_1.TicketId or nil
      self:EnterStandalone()
    end,
    ForbiddenRightCallbackObj = self,
    AutoFocus = true
  }, self)
end

function M:OpenTicketDialog_Multi()
  local DungeonId = self:GetCurDungeonId()
  if not DungeonId then
    return
  end
  UIManager(self):ShowCommonPopupUI(100123, {
    DungeonId = DungeonId,
    RightCallbackObj = self,
    RightCallbackFunction = function(Obj, PackageData)
      self.TicketId = PackageData and PackageData.Content_1 and PackageData.Content_1.TicketId or nil
      self:TryEnterMultiDungeon(DungeonId)
    end,
    ForbiddenRightCallbackObj = self,
    AutoFocus = true
  }, self)
end

function M:TeamMatchTimingStart()
  if TeamController and TeamController.GetModel then
    TeamController:GetModel().bPressedSolo = true
    TeamController:GetModel().bPressedMulti = true
  end
  self:RefreshBtnState(true)
end

function M:TeamMatchTimingEnd()
  if TeamController and TeamController.GetModel then
    TeamController:GetModel().bPressedSolo = false
    TeamController:GetModel().bPressedMulti = false
  end
  self:RefreshBtnState(false)
end

function M:EnterStandalone()
  local Avatar = GWorld:GetAvatar()
  assert(Avatar, "NO AVATAR")
  local DungeonId = self:GetCurDungeonId()
  if not DungeonId then
    DebugPrint("EnterStandalone DungeonId is nil")
    return
  end
  if Avatar:IsInTeam() and TeamController and TeamController.GetModel then
    TeamController:GetModel().bPressedSolo = true
  end
  self.IsSoloStart = true
  if not TeamController or not TeamController:DoCheckCanEnterDungeon(DungeonId) then
    DebugPrint("EnterStandalone PreCheck Failed: TeammateNotReady or ConditionNotMet")
    if TeamController and TeamController:GetModel() then
      TeamController:GetModel().bPressedSolo = false
      TeamController:GetModel().bPressedMulti = false
    end
    return
  end
  self:RefreshBtnState(true)
  self:TryEnterDungeon(Avatar, DungeonId, CommonConst.DungeonNetMode.Standalone, function(RetCode, ...)
    local bCanEnter = M.HandleEnterDungeonRetCode(RetCode, ...)
    if bCanEnter then
      if Avatar:IsInTeam() then
        UIManager(self):LoadUINew("DungeonMatchTimingBar", DungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, false)
        self:RefreshBtnState(true)
      else
        self:SetDungeonExitInfo()
        self:OnReturnKeyDown()
      end
    else
      self:RefreshBtnState(false)
    end
  end)
end

function M:OnReturnKeyDown()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  if self.DefaultList and self.DefaultList.GetVisibility and self.DefaultList:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
    self.DefaultList:OnCloseSquadGamepad()
    return
  end
  self:EndInteractive()
  MultiplayerChallengeModel:Clear()
  self.TeamHeadUI:PlayAnimation(self.TeamHeadUI.Auto_Out)
  if self.Out then
    self:PlayAnimation(self.Out)
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.Out, function()
      self:Close()
    end)
  else
    self:Close()
  end
end

function M:EndInteractive()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  if not PlayerController then
    return
  end
  local Player = PlayerController:GetMyPawn()
  if not Player then
    return
  end
  local Eid = Player.MechanismEid
  local Mechanism = Battle(self):GetEntity(Eid)
  if Mechanism then
    DebugPrint("@WBP_AreaCoop_LevelChoose_C:EndInteractive")
    Mechanism:EndInteractive(Player, true)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    self.IsGamePad = true
    IsEventHandled = self:OnGamePadDown(InKeyName)
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    self.IsGamePad = false
    if "Escape" == InKeyName then
      self:OnReturnKeyDown()
      IsEventHandled = true
    elseif "N" == InKeyName then
      self.ScrollBox_Desc:ScrollWidgetIntoView(self.HB_Title_Monster)
      IsEventHandled = true
    end
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnGamePadDown(InKeyName)
  self.PressedKeys = self.PressedKeys or {}
  self.PressedKeys[InKeyName] = true
  local IsDpadUp = true == self.PressedKeys[UIConst.GamePadKey.DPadUp]
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self.Common_Button_Text_PC and self.Common_Button_Text_PC.IsForbidden then
      if self.OnClickChallengeForbid then
        self:OnClickChallengeForbid()
      end
    elseif self.OnClickChallenge then
      self:OnClickChallenge()
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    if self.Btn_Coop and self.Btn_Coop.IsForbidden then
      if self.OnClickChallengeForbid then
        self:OnClickChallengeForbid()
      end
    elseif self.OnClickChallenge_Multi then
      self:OnClickChallenge_Multi()
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftThumb then
    if self.EnterSelectMode then
      self:EnterSelectMode(self.EliteItem.List_EliteProp)
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    self:OpenDetails()
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadRight then
    if self.OnDPadRightToggleAutoSummon and (not self.IsFocusList or not self:IsFocusList()) then
      local handled = self:OnDPadRightToggleAutoSummon()
      if handled then
        return true
      end
    end
  elseif InKeyName == UIConst.GamePadKey.DPadLeft then
    local DefaultList = self.DefaultList
    if DefaultList and DefaultList.IsMenuAnchorOpen and DefaultList:IsMenuAnchorOpen() then
      return true
    end
    if self.OnDPadLeftOpenDefaultMenuAnchor and (not self.IsFocusList or not self:IsFocusList()) then
      local handled = self:OnDPadLeftOpenDefaultMenuAnchor()
      if handled then
        return true
      end
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    local DefaultList = not self.DefaultList and self.EnsurePlatformDefaultListLoaded and self:EnsurePlatformDefaultListLoaded()
    if self.DefaultList.Preview.Btn_Qa_Summon.Btn_Click:IsChecked() then
      self.DefaultList.Preview:CloseMenuAnchor()
      DefaultList:CloseMenuAnchor()
      return true
    end
    if self.OnBKeyCloseDefaultList and self:OnBKeyCloseDefaultList() then
      if self.UpdateSquadPresetBottomKey then
        self:UpdateSquadPresetBottomKey()
      end
      if self.SelectCellFocus then
        self:SelectCellFocus()
      end
      return true
    end
    if self.IsInSelectState and self.LeaveSelectMode then
      self:LeaveSelectMode()
      return true
    end
    local headFocused = false
    if self.TeamHeadUI and (self.TeamHeadUI:HasFocusedDescendants() or self.TeamHeadUI:HasAnyUserFocus()) then
      self.bShoulFocusToLastFocusedWidget = true
      headFocused = true
    end
    if headFocused then
      self:LeaveSelectMode()
      return true
    end
    if self.OnReturnKeyDown then
      self:OnReturnKeyDown()
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.SpecialRight and self.TeamHeadUI and self.TeamHeadUI.DoGamepadBtnPress then
    self.TeamHeadUI:DoGamepadBtnPress()
    return true
  end
  return false
end

function M:SelectCellFocus()
  if self.SetFocus then
    self:SetFocus()
  end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  self.PressedKeys = self.PressedKeys or {}
  self.PressedKeys[InKeyName] = false
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    if self.TeamHeadUI then
      self.TeamHeadUI:DoGamepadBtnRelease()
    end
    local DefaultList = self.DefaultList
    if DefaultList and DefaultList.OnSpecialRightUp then
      local headFocused = false
      if self.TeamHeadUI then
        if self.TeamHeadUI.HasFocusedDescendants and self.TeamHeadUI:HasFocusedDescendants() then
          headFocused = true
        elseif self.TeamHeadUI.HasAnyUserFocus and self.TeamHeadUI:HasAnyUserFocus() then
          headFocused = true
        end
      end
      if not headFocused then
        DefaultList:OnSpecialRightUp()
        if self.UpdateSquadPresetBottomKey then
          self:UpdateSquadPresetBottomKey()
        end
        if DefaultList.IsShow and DefaultList.List_Default and DefaultList.List_Default.NavigateToIndex then
          DefaultList.List_Default:NavigateToIndex(0)
          self.CurrentFocusType = "DefaultList"
        elseif self.SelectCellFocus then
          self:SelectCellFocus()
        elseif self.SetFocus then
          self:SetFocus()
        end
      end
    end
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY and self.ScrollBox_Desc and self.ScrollBox_Desc.GetScrollOffset and not self.ScrollBox_Desc:HasFocusedDescendants() then
    local Delta = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    if nil ~= Delta then
      local DeltaOffset = -1 * Delta * 20
      self:AddDeltaOffset(DeltaOffset)
    end
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:AddDeltaOffset(DeltaOffset)
  if not (self.ScrollBox_Desc and self.ScrollBox_Desc.GetScrollOffset) or not self.ScrollBox_Desc.SetScrollOffset then
    return
  end
  local CurrentOffset = self.ScrollBox_Desc:GetScrollOffset()
  local EndOffset = 0
  if self.ScrollBox_Desc.GetScrollOffsetOfEnd then
    EndOffset = self.ScrollBox_Desc:GetScrollOffsetOfEnd()
  else
    EndOffset = CurrentOffset + math.abs(DeltaOffset or 0) + 1000
  end
  local NextOffset = math.min(math.max(CurrentOffset + (DeltaOffset or 0), 0), EndOffset)
  self.ScrollBox_Desc:SetScrollOffset(NextOffset)
end

function M:InitBaseInfo()
  local TitleName = MultiplayerChallengeModel:GetTitleName()
  if self.Text_BossLevel and TitleName then
    self.Text_BossLevel:SetText(GText(TitleName))
  end
  local TeleportName = MultiplayerChallengeModel:GetTeleportName()
  if self.Text_BossName and TeleportName then
    self.Text_BossName:SetText(GText(TeleportName))
  end
  local ChallengeName = MultiplayerChallengeModel:GetChallengeName()
  if self.Text_BossDetail and ChallengeName then
    self.Text_BossDetail:SetText(GText(ChallengeName))
  end
  self:SetImageIcon()
end

function M:SetImageIcon(TexturePath)
  local IconPath = MultiplayerChallengeModel:GetChallengeIconPath()
  if nil ~= IconPath then
    local ImageObject = LoadObject(IconPath)
    if not ImageObject:IsA(UE4.UTexture2D) then
      DebugPrint("IconPath需要纹理类型: 请检查填的路径: " .. tostring(ImageObject))
      return
    end
    local ImgMat = self.Image_LinShiImage:GetDynamicMaterial()
    ImgMat:SetTextureParameterValue("IconMap", ImageObject)
  end
end

function M:OpenDetails()
  UIManager(self):LoadUINew("ItemInformation", {
    Name = MultiplayerChallengeModel:GetChallengeName(),
    Desc = MultiplayerChallengeModel:GetChallengeDes()
  }, "LevelDatail")
end

function M:ToggleSquadPresetVisible(bShow)
  local Vis = bShow and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
  if self.Group_PC then
    self.Group_PC:SetVisibility(Vis)
  end
  if self.Group_Mob then
    self.Group_Mob:SetVisibility(Vis)
  end
end

function M:EnsurePlatformDefaultListLoaded()
  local IsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
  local TargetGroup = IsMobile and self.Group_Mob or self.Group_PC
  local TargetPath = IsMobile and MobileBuildBPPath or PCBuildBPPath
  local FieldName = IsMobile and "DefaultList_Mob" or "DefaultList_PC"
  if self[FieldName] and IsValid(self[FieldName]) then
    self.DefaultList = self[FieldName]
  else
    local ClassObj = LoadClass(TargetPath)
    if not ClassObj then
      DebugPrint("EnsurePlatformDefaultListLoaded: LoadClass failed", TargetPath)
      return nil
    end
    local Widget = NewObject(ClassObj, self)
    self[FieldName] = Widget
    if Widget.IsLeft ~= nil then
      Widget.IsLeft = true
    end
    if Widget.NeedLeft then
      Widget.NeedLeft = true
    end
    if TargetGroup and TargetGroup.AddChild then
      TargetGroup:ClearChildren()
      TargetGroup:AddChild(Widget)
    else
      DebugPrint("EnsurePlatformDefaultListLoaded: TargetGroup missing or no AddChild")
    end
    self.DefaultList = Widget
    local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Widget)
    if OverlaySlot then
      OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
      OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    end
  end
  if IsMobile then
    if self.Group_PC then
      self.Group_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if self.Group_Mob then
      self.Group_Mob:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  else
    if self.Group_Mob then
      self.Group_Mob:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if self.Group_PC then
      self.Group_PC:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    if not self.DefaultList or self.DefaultList.ApplyPcUiLayout then
    end
  end
  if self.DefaultList then
    local prevCB = self.DefaultList.OnMenuOpenChangedCallBack
    
    function self.DefaultList.OnMenuOpenChangedCallBack(ownerWidget, bIsOpen)
      if self.UpdateSquadPresetBottomKey then
        self:UpdateSquadPresetBottomKey()
      end
      if type(prevCB) == "function" then
        prevCB(ownerWidget, bIsOpen)
      end
    end
    
    if self.UpdateSquadPresetBottomKey then
      self:UpdateSquadPresetBottomKey()
    end
  end
  return self.DefaultList
end

function M:InitOrRefreshSquadPreset(DungeonId)
  local DungeonInfo = DataMgr.Dungeon[DungeonId]
  if not DungeonInfo then
    return
  end
  local bSquadEnabled = DungeonInfo.Squad and true or false
  self:ToggleSquadPresetVisible(bSquadEnabled)
  if not bSquadEnabled then
    return
  end
  local DefaultList = self:EnsurePlatformDefaultListLoaded()
  if not DefaultList then
    DebugPrint("InitOrRefreshSquadPreset: DefaultList is nil")
    return
  end
  local bDisablePhantom = false
  local DungeonType = DungeonInfo.DungeonType or DungeonInfo.Type
  if "Rouge" == DungeonType then
    bDisablePhantom = true
  end
  local Avatar = GWorld:GetAvatar()
  local SquadId = 0
  if Avatar and Avatar.DungeonSquad and DungeonType and Avatar.DungeonSquad[DungeonType] then
    SquadId = Avatar.DungeonSquad[DungeonType]
  end
  self.SquadId = SquadId
  if DefaultList.Init then
    DefaultList:Init(self, bDisablePhantom, SquadId, DungeonId)
  end
  local curInput = UIUtils.UtilsGetCurrentInputType()
  if curInput == ECommonInputType.MouseAndKeyboard and self.DefaultList.ApplyPcUiLayout then
    self.DefaultList:ApplyPcUiLayout()
  elseif curInput == ECommonInputType.Gamepad and self.DefaultList.InitWidgetInfoInGamePad then
    self.DefaultList:InitWidgetInfoInGamePad()
  end
  if DefaultList then
    local prevCB = DefaultList.OnMenuOpenChangedCallBack
    
    function DefaultList.OnMenuOpenChangedCallBack(ownerWidget, bIsOpen)
      self:UpdateSquadPresetKeyTips(bIsOpen)
      if self.UpdateSquadPresetBottomKey then
        self:UpdateSquadPresetBottomKey()
      end
      if type(prevCB) == "function" then
        prevCB(ownerWidget, bIsOpen)
      end
    end
    
    local isOpen = DefaultList.IsMenuAnchorOpen and DefaultList:IsMenuAnchorOpen() or false
    self:UpdateSquadPresetKeyTips(isOpen)
    if self.UpdateSquadPresetBottomKey then
      self:UpdateSquadPresetBottomKey()
    end
  end
end

function M:RefreshMonsterInfoList(DungeonId)
  local MonsterPreview = MultiplayerChallengeModel:GetMonsterPreviewData(DungeonId)
  if not (MonsterPreview and MonsterPreview.List) or 0 == #MonsterPreview.List then
    self.ListView_Monster:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.MonsterWeaknessIcon = MonsterPreview.WeaknessIcon or {}
  self.ListView_Monster:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  if self.ListView_Monster.ClearListItems then
    self.ListView_Monster:ClearListItems()
  end
  self.MonsterIdToItem = {}
  self.DisplayMonsters = MonsterPreview.List
  self.NowSelectingIndex = 1
  local MonsterItemContentClass = LoadClass("/Game/UI/WBP/Play/Widget/Depute/MonsterInfo_Tab_Item_Content.MonsterInfo_Tab_Item_Content")
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  for _, MonsterId in ipairs(MonsterPreview.List) do
    local MonsterData = DataMgr.Monster[MonsterId]
    if MonsterData and GameState.IsUnitRelease(MonsterId) then
      local Content = NewObject(MonsterItemContentClass)
      Content.ParentWidget = self
      Content.MonsterId = MonsterId
      Content.DisableSelect = true
      Content.SoundEvent = "event:/ui/common/click_mid"
      Content.WeaknessIcon = self.MonsterWeaknessIcon[MonsterId]
      Content.NeedFocusable = true
      Content.List = self.ListView_Monster
      Content.OnAddedToFocusPathEvent = {
        Obj = Content,
        Callback = function(Content)
          self:OnItemFocus(Content)
        end
      }
      self.ListView_Monster:AddItem(Content)
    end
  end
end

function M:SelectMonsterInfoItem(MonsterId)
  UIManager(self):LoadUINew("MonsterDetailInfo", self.CurSelectedDungeonId, self, MonsterId)
end

function M:RefreshRewardsListByDungeon(DungeonId)
  if not self.ListView_Rewards then
    return
  end
  self.ListView_Rewards:ClearListItems()
  local Rewards = MultiplayerChallengeModel:GetRewardPreviewData(DungeonId)
  if not Rewards or 0 == #Rewards then
    self.Group_Title_Rewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.ListView_Rewards:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.Group_Title_Rewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.ListView_Rewards:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  for i = 1, #Rewards do
    local Info = Rewards[i]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.UIName = "AreaCoopLevelChoose"
    Content.IsShowDetails = true
    Content.Id = Info.Id
    Content.Icon = Info.Icon
    Content.Rarity = Info.Rarity
    Content.ItemType = Info.Type
    Content.NeedFocusable = true
    Content.List = self.ListView_Rewards
    Content.OnAddedToFocusPathEvent = {
      Obj = Content,
      Callback = function(Content)
        self:OnItemFocus(Content)
      end
    }
    self.ListView_Rewards:AddItem(Content)
  end
end

function M:SetTabItemSelection(Item)
  if self.SelectingItem and self.SelectingItem ~= Item and self.SelectingItem.CancelTabSelect then
    self.SelectingItem:CancelTabSelect()
  end
  self.SelectingItem = Item
end

function M:OnClickChallengeForbid()
  local DungeonId = self:GetCurDungeonId()
  if not DungeonId then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and DataMgr.Dungeon[DungeonId] and ConditionUtils and ConditionUtils.CheckCondition then
    ConditionUtils.CheckCondition(Avatar, DataMgr.Dungeon[DungeonId].Condition, true)
  else
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Tosat_Level_Locked"))
  end
end

function M:OnCurrentSquadChange(SquadId, IsComMissing, CurSelectedDungeonId)
  self.SquadId = SquadId or 0
  self.IsComMissing = IsComMissing and true or false
  if self.IsComMissing and self.DefaultList and self.DefaultList:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Squad_Miss_Challenge"))
  end
end

function M:ScrollItemIntoView(Widget)
  DebugPrint("ScrollItemIntoView")
  self.ScrollBox_Desc:ScrollWidgetIntoView(Widget)
end

function M:RefreshOpInfoByInputDevice(InputType, GamepadName)
end

function M:OnInputDeviceChanged(InputType, GamepadName)
end

function M:InitWidgetInfoInGamePad()
end

function M:SetKeyWidgetGamePadVisibility(KeyWidget, bShow)
end

function M:InitGamepadView()
end

function M:InitKeyboardView()
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateSquadPresetKeyTips(bIsOpen)
end

function M:SetDungeonExitInfo()
  local ExitDungeonInfo = {}
  ExitDungeonInfo.IsFromRegionMechanism = true
  GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
end

AssembleComponents(M)
return M
