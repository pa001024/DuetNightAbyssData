require("UnLua")
local M = Class()

function M:InitEnterDungeon(Params)
  Params = Params or {}
  TeamController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == TeamCommon.EventId.TeamOnInit or EventId == TeamCommon.EventId.TeamLeave or EventId == TeamCommon.EventId.TeamOnChangeLeader then
      self:RefreshTeamEntryBtnState()
    end
  end)
  self:AddDispatcher(EventID.TeamMatchTimingStart, self, self.TeamMatchTimingStart)
  self:AddDispatcher(EventID.TeamMatchTimingEnd, self, self.TeamMatchTimingEnd)
  self:BindEnterDungeonButtons(Params.SoloButton, Params.MultiButton)
  self:SetEnterButtonText(Params.SoloTextKey, Params.MultiTextKey)
end

function M:BindEnterDungeonButtons(SoloButton, MultiButton)
  self.TeamEnterDungeonSoloBtn = SoloButton
  self.TeamEnterDungeonMultiBtn = MultiButton
  if SoloButton then
    if SoloButton.SetDefaultGamePadImg then
      SoloButton:SetDefaultGamePadImg("Y")
    end
    SoloButton:BindEventOnClicked(self, self.OnClickSolo)
  end
  if MultiButton then
    if MultiButton.SetDefaultGamePadImg then
      MultiButton:SetDefaultGamePadImg("X")
    end
    MultiButton:BindEventOnClicked(self, self.OnClickMulti)
  end
end

function M:SetEnterButtonText(SoloTextKey, MultiTextKey)
  if self.TeamEnterDungeonSoloBtn and SoloTextKey then
    self.TeamEnterDungeonSoloBtn:SetText(GText(SoloTextKey))
  end
  if self.TeamEnterDungeonMultiBtn and MultiTextKey then
    self.TeamEnterDungeonMultiBtn:SetText(GText(MultiTextKey))
  end
end

function M:SetEnterDungeonKeyVisible(bVisible)
  self.EnterDungeonKeyVisible = bVisible
  self:RefreshEnterDungeonKeyVisible()
end

function M:RefreshEnterDungeonKeyVisible(CurInputDevice)
  local bVisible = self.EnterDungeonKeyVisible
  if nil == bVisible then
    bVisible = true
  end
  local usingPad = (CurInputDevice or UIUtils.UtilsGetCurrentInputType()) == ECommonInputType.Gamepad
  local Vis = bVisible and usingPad and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed
  local Buttons = {
    self.TeamEnterDungeonSoloBtn,
    self.TeamEnterDungeonMultiBtn
  }
  for _, Btn in ipairs(Buttons) do
    if Btn and Btn.Key_GamePad then
      Btn.Key_GamePad:SetVisibility(Vis)
    end
  end
end

function M:DeinitEnterDungeon()
  if self.TeamEnterDungeonSoloBtn then
    self.TeamEnterDungeonSoloBtn:UnBindEventOnClickedByObj(self)
    self.TeamEnterDungeonSoloBtn = nil
  end
  if self.TeamEnterDungeonMultiBtn then
    self.TeamEnterDungeonMultiBtn:UnBindEventOnClickedByObj(self)
    self.TeamEnterDungeonMultiBtn = nil
  end
  TeamController:UnRegisterEvent(self)
  self:RemoveDispatcher(EventID.TeamMatchTimingStart)
  self:RemoveDispatcher(EventID.TeamMatchTimingEnd)
end

function M:EnsureOptionalPatchDownloaded(DungeonId)
  local DungeonId = DungeonId or self.CurSelectedDungeonId
  if not DungeonId then
    return true
  end
  local PatchCond = DataMgr.DungeonPatchCondition and DataMgr.DungeonPatchCondition[DungeonId]
  local NecessaryPatch = PatchCond and PatchCond.NecessaryPatch
  if not NecessaryPatch or 0 == #NecessaryPatch then
    return true
  end
  local HotUpdateSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.UHotUpdateSubsystem)
  if not HotUpdateSubsystem then
    return true
  end
  if NecessaryPatch and not HotUpdateSubsystem:IsAllPatchOptionalSignsDownloaded(NecessaryPatch) then
    UIManager(self):LoadUINew("OptionalPatch", NecessaryPatch)
    return false
  end
  return true
end

function M:CheckDungeonCondition(DungeonId)
  if not DungeonId or not DataMgr.Dungeon[DungeonId] then
    DebugPrint("[TeamEnter] CheckDungeonCondition invalid DungeonId:", DungeonId)
    return false
  end
  if not PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[DungeonId].Condition) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Tosat_Level_Locked"))
    return false
  end
  return true
end

function M:IsDungeonLoadingAnimPlaying()
  if self.Out_Loading and self:IsAnimationPlaying(self.Out_Loading) then
    return true
  end
  return false
end

function M:CheckMatchUnlocked(Avatar)
  if not Avatar:CheckUIUnlocked("Match") then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(DataMgr.UIUnlockRule.Match.UIUnlockDesc))
    return false
  end
  return true
end

function M:OnClickSolo(DungeonId)
  local DungeonId = DungeonId or self.CurSelectedDungeonId
  if not DungeonId then
    DebugPrint("[TeamEnter] CurSelectedDungeonId is nil")
    return
  end
  if not self:CheckDungeonCondition(DungeonId) then
    return
  end
  if self:IsDungeonLoadingAnimPlaying() then
    return
  end
  if not self:EnsureOptionalPatchDownloaded(DungeonId) then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self:RunEnterLogic(DungeonId, Avatar, true)
end

function M:OnClickMulti(DungeonId)
  local DungeonId = DungeonId or self.CurSelectedDungeonId
  if not DungeonId then
    DebugPrint("[TeamEnter] CurSelectedDungeonId is nil")
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not self:EnsureOptionalPatchDownloaded(DungeonId) then
    return
  end
  if not self:CheckMatchUnlocked(Avatar) then
    return
  end
  if not self:CheckDungeonCondition(DungeonId) then
    return
  end
  if self:IsDungeonLoadingAnimPlaying() then
    return
  end
  self:RunEnterLogic(DungeonId, Avatar, false)
end

function M:EnterStandalone(DungeonId, TicketId)
  local DungeonId = DungeonId or self.CurSelectedDungeonId
  if not DungeonId then
    DebugPrint("[TeamEnter] CurSelectedDungeonId is nil")
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_enter_level", nil, nil)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    self:TryEnterDungeon(Avatar, DungeonId, CommonConst.DungeonNetMode.Standalone, function(RetCode, ...)
      self:BlockAllUIInput(false)
      local bCanEnter = self:HandleEnterDungeonRetCode(RetCode, ...)
      if not bCanEnter then
        self:OnStandaloneEnterFailed()
      end
    end, TicketId)
    self:BlockAllUIInput(true)
    self:AddTimer(10, function()
      if self and self:IsAllUIInputBlocked() then
        self:BlockAllUIInput(false)
      end
    end)
  else
    WorldTravelSubsystem(self):ChangeDungeonByDungeonId(DungeonId, CommonConst.DungeonNetMode.Standalone)
  end
end

function M:OnStandaloneEnterFailed()
end

function M:OnPreEnterDungeonCheck(DungeonId, bIsSolo, continueCallback)
  return true
end

function M:RunEnterLogic(DungeonId, Avatar, bIsSolo)
  local bPass = self:OnPreEnterDungeonCheck(DungeonId, bIsSolo, function(bContinue)
    if bContinue then
      self:ExecuteEnterLogic(DungeonId, Avatar, bIsSolo)
    end
  end)
  if bPass then
    self:ExecuteEnterLogic(DungeonId, Avatar, bIsSolo)
  end
end

function M:ExecuteEnterLogic(DungeonId, Avatar, bIsSolo)
  if bIsSolo then
    local bIsInTeam = Avatar:IsInTeam()
    if bIsInTeam then
      self:TeamPressSolo()
      self:TryEnterDungeon(Avatar, DungeonId, CommonConst.DungeonNetMode.Standalone, function(RetCode, ...)
        self:BlockAllUIInput(false)
        local bCanEnter = self:HandleEnterDungeonRetCode(RetCode, ...)
        if bCanEnter then
          UIManager(self):LoadUINew("DungeonMatchTimingBar", DungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, false)
        end
      end)
      self:RefreshTeamEntryBtnState()
    else
      self:EnterStandalone(DungeonId)
    end
  else
    self:TryEnterMultiDungeon(Avatar, DungeonId, self.TicketId, function(bCanEnter)
      self:RefreshTeamEntryBtnState(bCanEnter)
    end)
  end
end

function M:TeamPressSolo()
  TeamController:GetModel().bPressedSolo = true
end

function M:TeamPressMulti()
  TeamController:GetModel().bPressedMulti = true
end

function M:ResetTeamPressed()
  TeamController:GetModel().bPressedSolo = false
  TeamController:GetModel().bPressedMulti = false
end

function M:TeamMatchTimingStart(arg)
  TeamController:GetModel().bPressedSolo = true
  TeamController:GetModel().bPressedMulti = true
  self:RefreshTeamEntryBtnState(arg)
end

function M:TeamMatchTimingEnd(arg)
  TeamController:GetModel().bPressedSolo = false
  TeamController:GetModel().bPressedMulti = false
  self:RefreshTeamEntryBtnState(arg)
end

function M:RefreshTeamEntryBtnState(arg)
end

function M:IsTeamMatching()
  return TeamController:GetModel():IsMatching()
end

function M:GetTeamLeaderId()
  return TeamController:GetModel():GetTeamLeaderId()
end

function M:DoCheckCanEnterDungeon(Avatar, DungeonId)
  if not TeamController:DoCheckCanEnterDungeon(DungeonId) then
    return false
  end
  return true
end

function M:GetEnterDungeonSquadId()
  return self.SquadId
end

function M:TryEnterDungeon(Avatar, DungeonId, DungeonNetMode, OtherCallback, TicketId, CustomParams)
  if self:DoCheckCanEnterDungeon(Avatar, DungeonId) then
    self:BlockAllUIInput(true)
    DebugPrint("[TeamEnter] TryEnterDungeon ", Avatar, DungeonId, DungeonNetMode, OtherCallback, TicketId)
    Avatar:EnterDungeon(DungeonId, DungeonNetMode, OtherCallback, TicketId, self:GetEnterDungeonSquadId(), CustomParams)
  else
    self:ResetTeamPressed()
    self:BlockAllUIInput(false)
  end
end

function M:TryEnterMultiDungeon(Avatar, DungeonId, TicketId, OnEntered)
  self:TeamPressMulti()
  self:TryEnterDungeon(Avatar, DungeonId, CommonConst.DungeonNetMode.DedicatedServer, function(RetCode, ...)
    local bCanEnter = self:HandleEnterDungeonRetCode(RetCode, ...)
    DebugPrint("[TeamEnter] TryEnterMultiDungeon", bCanEnter)
    self:BlockAllUIInput(false)
    if bCanEnter then
      local bIsInTeam = Avatar:IsInTeam()
      if bIsInTeam then
        UIManager(self):LoadUINew("DungeonMatchTimingBar", DungeonId, Const.DUNGEON_MATCH_BAR_STATE.SPONSOR_WAITING_CONFIRM, true)
      else
        UIManager(self):LoadUINew("DungeonMatchTimingBar", DungeonId, Const.DUNGEON_MATCH_BAR_STATE.WAITING_MATCHING_WITH_CANCEL, true)
      end
    end
    if OnEntered then
      OnEntered(bCanEnter)
    end
  end, TicketId)
end

function M:HandleEnterDungeonRetCode(RetCode, ...)
  DebugPrint("[TeamEnter] EnterDungeonCallback RetCode", RetCode)
  if RetCode == ErrorCode.RET_SUCCESS then
    return true
  else
    if RetCode == ErrorCode.RET_DUNGEON_MAX_PLAYERS then
      UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_TeamPlayerLimit"))
    elseif RetCode == ErrorCode.RET_IRONTICKET_REACH_MAX_AVAILABLE_LEVEL then
      UIManager(GWorld.GameInstance):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_MaxTicketLevel"))
    else
      local FailedMember = (...)
      if FailedMember then
        TeamController:DoWhenEnterDungeonCheckFailed(RetCode, FailedMember)
      else
        ErrorCode:Check(RetCode)
      end
    end
    EventManager:FireEvent(EventID.TeamMatchTimingEnd)
    return false
  end
end

function M:InitGamePadState()
  if not self.PressedKeys then
    self.PressedKeys = {}
  end
end

function M:OnEnterDungeonGamePadDown(InKeyName)
  if self.FocusTypeName == "RewardWidget" then
    return false
  end
  if "Gamepad_FaceButton_Left" == InKeyName then
    if self.TeamEnterDungeonMultiBtn and self.TeamEnterDungeonMultiBtn:GetVisibility() ~= ESlateVisibility.Collapsed then
      self:OnClickMulti()
    else
      return false
    end
    return true
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    if self.TeamEnterDungeonSoloBtn and self.TeamEnterDungeonSoloBtn:GetVisibility() ~= ESlateVisibility.Collapsed then
      self:OnClickSolo()
    else
      return false
    end
    return true
  end
  return false
end

function M:UpdatKeyDisplay(FocusTypeName)
end

function M:OnReturnKeyDown()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadUp(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  self:InitGamePadState()
  self.PressedKeys[InKeyName] = true
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnGamePadDown(InKeyName)
  return self:OnEnterDungeonGamePadDown(InKeyName)
end

function M:OnGamePadUp(InKeyName)
  return false
end

return M
