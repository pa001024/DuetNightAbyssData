require("UnLua")
local M = Class({
  "BluePrints.UI.Common.WBP_Common_Activity_Settlement_C"
})
local AutoChessConst = require("BluePrints.UI.AutoChess.AutoChessConst")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local TimeUtils = require("Utils.TimeUtils")
local AUTO_CHESS_EVENT_ID = AutoChessConst.ActiveId
local LevelState = {
  Pass = 0,
  UnPass = 1,
  UnLock = 2
}

function M:InitParams(Params)
  M.Super.InitParams(self, Params)
end

function M:IsNextButtonSupported()
  if self.Params.DungeonType ~= "AutoChess" then
    return false
  end
  return 1 == self.Params.MissionType or 2 == self.Params.MissionType
end

function M:InitNextButtonUI()
  self.Btn_Continue:SetVisibility(ESlateVisibility.Collapsed)
  self.VB_Next:SetVisibility(ESlateVisibility.Visible)
  self.Btn_ContinueSmall.Button_Area.OnClicked:Add(self, self.OnContinueClicked)
  if 1 == self.Params.MissionType then
    self.BtnRes:SetVisibility(ESlateVisibility.Visible)
    self.Btn_Next:SetText(GText("UI_AutoChess_NextMission"))
    self.Panel_Hint_1:SetVisibility(ESlateVisibility.Collapsed)
    if self.Params.IsWin then
      if self:CheckNextMissionUnlocked() then
        self.Btn_Next:SetRenderOpacity(1.0)
      else
        self.Btn_Next:SetRenderOpacity(0.5)
      end
    else
      self.Btn_Next:SetRenderOpacity(0.5)
    end
  elseif 2 == self.Params.MissionType then
    if self.Params.IsWin then
      self.BtnRes:SetVisibility(ESlateVisibility.Collapsed)
      self.Btn_Next:SetText(GText("UI_AutoChess_NextMission"))
      self.Panel_Hint_1:SetVisibility(ESlateVisibility.Collapsed)
      self.Btn_Next:SetRenderOpacity(1.0)
    else
      self.BtnRes:SetVisibility(ESlateVisibility.Visible)
      self.Btn_Next:SetText(GText("UI_AutoChess_ChangeMission"))
      self.Text_Res:SetText(string.format(GText("UI_AutoChess_Refresh2"), self.RemainRefreshCount, self.MAX_REFRESH))
      self.Panel_Hint_1:SetVisibility(ESlateVisibility.Visible)
      if self.RemainRefreshCount > 0 then
        self.Btn_Next:SetRenderOpacity(1.0)
      else
        self.Btn_Next:SetRenderOpacity(0.5)
      end
    end
  end
end

function M:InitUI()
  if self.Params.DungeonType ~= "AutoChess" then
    DebugPrint("yly WBP_Activity_AutoChess_Settlement_C InitUI: DungeonType is not AutoChess")
    return
  end
  self.MAX_REFRESH = DataMgr.GlobalConstant.AUTO_CHESS_MAX_REFRESH.ConstantValue
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.AutoChess then
    self.RemainRefreshCount = math.max(0, self.MAX_REFRESH - (Avatar.AutoChess.RefreshCount or 0))
  else
    self.RemainRefreshCount = 0
    DebugPrint("yly WBP_Activity_AutoChess_Settlement_C InitUI: Avatar.AutoChess is nil")
  end
  M.Super.InitUI(self)
  if self:IsNextButtonSupported() then
  else
    self.Btn_Continue:SetText(GText("UI_AutoChess_Restart"))
    self.Btn_Continue:SetVisibility(ESlateVisibility.Visible)
    self.BtnRes:SetVisibility(ESlateVisibility.Collapsed)
    self.VB_Next:SetVisibility(ESlateVisibility.Collapsed)
    self.VB_Score:SetVisibility(ESlateVisibility.Collapsed)
    self.SizeBox_List:SetVisibility(ESlateVisibility.Collapsed)
    self.ScorePanel:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Level:SetVisibility(ESlateVisibility.Collapsed)
    self.Settlement_RewardItem:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_FailTip:SetVisibility(ESlateVisibility.Collapsed)
    self.Static_TitleLine_1:SetVisibility(ESlateVisibility.Collapsed)
    if self.Params.IsWin then
      self.Static_TitleLine:SetVisibility(ESlateVisibility.Collapsed)
      self.Panel_FailTip:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.Static_TitleLine:SetVisibility(ESlateVisibility.Visible)
      self.Panel_FailTip:SetVisibility(ESlateVisibility.Visible)
    end
  end
  if 2 == self.Params.MissionType and self.Params.IsWin then
    local MissionId = self.Params.MissionId
    local CurLevelStar = DataMgr.AutoChessMission[MissionId].DifficultyStar
    local ExtraStar = 0
    local ChallengeBuffs = Avatar.AutoChess.ChallengeBuffs
    if ChallengeBuffs then
      for ChallengeBuffId, _ in pairs(ChallengeBuffs) do
        local BuffData = DataMgr.ChallengeBuff[ChallengeBuffId]
        if BuffData and BuffData.DifficultyStar then
          ExtraStar = ExtraStar + BuffData.DifficultyStar
        end
      end
    end
    local TotalStar = CurLevelStar + ExtraStar
    self.TipsLevel:SetContent({Level = TotalStar})
    self.TipsLevel:SetVisibility(ESlateVisibility.Visible)
  else
    self.TipsLevel:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:GetNextLinearMissionId(CurMissionId)
  if not CurMissionId then
    return nil
  end
  for MissionId, Info in pairs(DataMgr.AutoChessMission) do
    if 1 == Info.MissionType and Info.UnlockMissionId == CurMissionId then
      return MissionId
    end
  end
  return nil
end

function M:CheckNextMissionUnlocked()
  if not self.Params or not self.Params.MissionId then
    return false
  end
  local NextMissionId = self:GetNextLinearMissionId(self.Params.MissionId)
  if not NextMissionId then
    return false
  end
  local State = self:GetLinearMissionState(NextMissionId)
  return State ~= LevelState.UnLock
end

function M:OnBtnNextClicked()
  if not self:CheckActivityOpen() then
    DebugPrint("yly OnBtnNextClicked: Activity not open")
    return
  end
  if self.Params.MissionType == AutoChessConst.LevelSelectType.Linear then
    if not self.Params.IsWin then
      UIManager(self):ShowUITip("CommonToastMain", GText("UI_AutoChess_NextMissionUnreachable"))
      return
    end
    local NextMissionId = self:GetNextLinearMissionId(self.Params.MissionId)
    if not NextMissionId or not self:CheckNextMissionUnlocked() then
      UIManager(self):ShowUITip("CommonToastMain", GText("UI_AutoChess_NextMissionLock"))
      return
    end
    self:EnterAutoChessMission(NextMissionId)
  elseif self.Params.MissionType == AutoChessConst.LevelSelectType.Random then
    local Avatar = GWorld:GetAvatar()
    if not Avatar or not Avatar.AutoChess then
      return
    end
    if self.Params.IsWin then
      local MissionId = Avatar.AutoChess.RandomMissionId
      if not MissionId or MissionId <= 0 then
        DebugPrint("yly OnBtnNextClicked: RandomMissionId invalid")
        return
      end
      self:EnterAutoChessMission(MissionId)
    else
      if self.RemainRefreshCount <= 0 then
        UIManager(self):ShowUITip("CommonToastMain", GText("UI_AutoChess_CantRefresh"))
        return
      end
      Avatar:RefreshRandomMission(function(Ret)
        if Ret ~= ErrorCode.RET_SUCCESS then
          DebugPrint("yly RefreshRandomMission fail, Ret:", Ret)
          return
        end
        local NewMissionId = Avatar.AutoChess.RandomMissionId
        if not NewMissionId or NewMissionId <= 0 then
          DebugPrint("yly RefreshRandomMission: RandomMissionId invalid")
          return
        end
        self:EnterAutoChessMission(NewMissionId)
      end)
    end
  end
end

function M:CheckUnlockDay(Info)
  local UnlockDay = Info.UnlockDay
  if not UnlockDay then
    return true
  end
  local EventStartTime = DataMgr.EventMain[AUTO_CHESS_EVENT_ID].EventStartTime
  local StartTimestamp = EventStartTime:GetTime()
  local CurrentTime = TimeUtils.NowTime()
  local StartDate = os.date("*t", StartTimestamp)
  local RefreshHour = TimeUtils.RefreshHMS[1] or 5
  local RefreshMin = TimeUtils.RefreshHMS[2] or 0
  local RefreshSec = TimeUtils.RefreshHMS[3] or 0
  local FirstRefreshTime = os.time({
    year = StartDate.year,
    month = StartDate.month,
    day = StartDate.day,
    hour = RefreshHour,
    min = RefreshMin,
    sec = RefreshSec
  })
  if StartTimestamp >= FirstRefreshTime then
    FirstRefreshTime = FirstRefreshTime + 86400
  end
  local UnlockTime = FirstRefreshTime + (UnlockDay - 2) * 86400
  return CurrentTime >= UnlockTime
end

function M:GetLinearMissionState(MissionId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return LevelState.UnLock
  end
  local Info = DataMgr.AutoChessMission[MissionId]
  if not Info then
    return LevelState.UnLock
  end
  if Avatar.Dungeons[Info.DungeonId] and Avatar.Dungeons[Info.DungeonId].IsPass then
    return LevelState.Pass
  end
  local TimeUnlock = self:CheckUnlockDay(Info)
  local bPrePass = true
  if Info.UnlockMissionId then
    local PreDungeonId = DataMgr.AutoChessMission[Info.UnlockMissionId].DungeonId
    bPrePass = Avatar.Dungeons[PreDungeonId] and Avatar.Dungeons[PreDungeonId].IsPass
  end
  if not Info.UnlockDay and not Info.UnlockMissionId then
    return LevelState.UnPass
  end
  if Info.UnlockDay and not Info.UnlockMissionId then
    return TimeUnlock and LevelState.UnPass or LevelState.UnLock
  elseif not Info.UnlockDay and Info.UnlockMissionId then
    return bPrePass and LevelState.UnPass or LevelState.UnLock
  else
    return TimeUnlock and bPrePass and LevelState.UnPass or LevelState.UnLock
  end
end

function M:CheckActivityOpen()
  local IsOpen = ActivityUtils.CheckEventIsOpen(self.Params.ActivityId, nil, false)
  if self.Params.CheckOpenActivityId then
    IsOpen = ActivityUtils.CheckEventIsOpen(self.Params.CheckOpenActivityId, nil, false)
  end
  if not IsOpen then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GameEvent_EventEnd"))
    return false
  end
  return true
end

function M:EnterAutoChessMission(MissionId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Info = DataMgr.AutoChessMission[MissionId]
  if not Info then
    DebugPrint("yly EnterAutoChessMission: invalid MissionId", MissionId)
    return
  end
  local CustomParams = {}
  CustomParams.MissionId = MissionId
  local EventId = self.Params and self.Params.ActivityId or AUTO_CHESS_EVENT_ID
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if GameMode and GameMode.UnRegisterWorldTravelDelegate then
    GameMode:UnRegisterWorldTravelDelegate()
  end
  Avatar:EnterEventDungeon(function(Ret)
    if Ret and Ret == ErrorCode.RET_SUCCESS then
      DebugPrint("yly EnterAutoChessMission success")
      self:CloseSettlementUI()
    else
      DebugPrint("yly EnterAutoChessMission fail, Ret:", Ret)
      Avatar:ExitDungeonSettlement()
    end
  end, Info.DungeonId, nil, EventId, CustomParams)
end

function M:CloseSettlementUI()
  if self.Params.IsWin then
    self:PlayAnimation(self.Out)
  else
    self:PlayAnimation(self.Fail_Out)
  end
end

function M:OnAnimationFinished(InAnimation)
  M.Super.OnAnimationFinished(self, InAnimation)
end

function M:Destruct()
  M.Super.Destruct(self)
end

function M:SetupGamepadControls()
  M.Super.SetupGamepadControls(self)
  if self.KeyImg then
    self.KeyImg:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Y"}
      }
    })
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  M.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

return M
