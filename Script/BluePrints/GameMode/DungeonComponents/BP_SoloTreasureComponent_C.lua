local TimeUtils = require("Utils.TimeUtils")
local M = Class({
  "BluePrints.Common.TimerMgr"
})

function M:InitSoloTreasureComponent()
  self.GameMode = self:GetOwner()
  local SoloTreasureInfo = DataMgr.SoloTreasure[self.GameMode.DungeonId]
  if not SoloTreasureInfo then
    return
  end
  self.GamePlayIds = SoloTreasureInfo.GamePlayId or {}
  self.GameTotalTime = SoloTreasureInfo.GameTotalTime or 0
  for _, GamePlayId in pairs(self.GamePlayIds) do
    local GamePlayInfo = DataMgr.SoloTreasureGamePlay[GamePlayId]
    if GamePlayInfo and 1 == GamePlayInfo.type then
      self:InitDefenceGameInfo(GamePlayInfo)
    end
  end
  self.GuideOrder = {}
end

function M:InitSoloTreasureBaseInfo()
end

function M:TriggerSoloTreasureOnEnd()
  self:RemoveTimer("ClientSolotreasureRemainTime")
end

function M:OnSetGameStartTime(StartGameTimestamp)
  local CurrentTimestamp = StartGameTimestamp
  local Offset = TimeUtils.NowTime() - StartGameTimestamp
  local EndGameTimestamp = StartGameTimestamp + self.GameTotalTime - Offset
  self:OnSetRemainGameTime(self.GameTotalTime)
  DebugPrint("OnSetGameStartTime")
  self:AddTimer(0.1, function()
    CurrentTimestamp = math.min(TimeUtils.NowTime(), EndGameTimestamp)
    self:OnSetRemainGameTime(EndGameTimestamp - CurrentTimestamp)
    if CurrentTimestamp == EndGameTimestamp then
      self:RemoveTimer("ClientSolotreasureRemainTime")
    end
  end, true, 0, "ClientSolotreasureRemainTime", true)
end

function M:OnSetRemainGameTime(RemainTime)
  self.GameRemainTime = RemainTime
  self:OnUpdateCountDown()
end

function M:OnGetRemainGameTime()
  return self.GameRemainTime or 0
end

function M:OnTimeOver()
  self:FinishSolotreasure(false, "TimeOver")
  UIManager(self):UnLoadUINew("DungeonLevelMapMain")
end

function M:FinishSolotreasure(IsWin, Reason)
  UIManager(self):LoadUINew("SoloTreasureFinishTip", IsWin)
  if IsWin then
    self:OnDungeonWin(Reason)
  else
    self:OnDungeonFailed(Reason)
  end
end

function M:OnDungeonWin(Reason)
  self.GameMode:NotifyServerGameEnd(true, Reason)
end

function M:OnDungeonFailed(Reason)
  self.GameMode:NotifyServerGameEnd(false, Reason)
end

function M:OnUpdateCountDown()
  local CountDownUI = UIManager(self):GetUI("SoloTreasureCountDownTip")
  if CountDownUI then
    CountDownUI:UpdateCountDownUI(self:OnGetRemainGameTime())
  end
  local TipUI = UIManager(self):GetUI("SoloTreasureTimeTip")
  if TipUI then
    TipUI:InitText(self:OnGetRemainGameTime())
  end
end

function M:OnTurnRainy()
  DebugPrint("ljl@ SoloTreasureComponent OnTurnRainy")
  self.GameMode:TriggerGameModeEvent("Event_OnTurnRainy")
  EventManager:FireEvent(EventID.FirstRain)
end

function M:OnMechanismStateChange(Mechanism, StateId, LeaveStateId)
  DebugPrint("BP_SoloTreasureComponent_C : OnMechanismStateChange")
  if not IsValid(Mechanism) then
    return
  end
  if not self.HasDefenceGame then
    return
  end
  if Mechanism.CreatorId == self.DefenceGameInteractiveStaticId and StateId == self.DefenceGameInteractiveStateId and LeaveStateId == self.DefenceGameInteractiveInitStateId then
    DebugPrint("yly BP_SoloTreasureComponent DefenceGame Begin.")
    self.GameMode:NotifyServerDungeonEvent("DefenceGameBegin", Mechanism.CreatorId, Mechanism.ServerUniqueId, self.DefenceGamePlayId)
    local MechanismIdArray = TArray(0)
    for Id, _ in pairs(self.DefenceContainerInfos) do
      MechanismIdArray:Add(Id)
    end
    self.GameMode:OpenGuideIconRegion(nil, MechanismIdArray)
    for ContainerStaticId, ContainerInfo in pairs(self.DefenceContainerInfos) do
      self.GameMode:TriggerMechanism(ContainerStaticId, 1310672)
    end
    UIManager(GWorld.GameInstance):LoadUINew("SoloTreasureHudTips01", {
      [1] = self.DefenceGamePlayId
    })
    self:OnSetHudTipsbOnDisplay(true)
    self.IsPlayingDefenceGame = true
    local CurrentTimestamp = os.time()
    local EndGameTimestamp = CurrentTimestamp + self.DefenceGameTotalTime
    self:OnSetDefenceGameRemainTime(self.DefenceGameTotalTime)
    self:AddTimer(0.1, function()
      CurrentTimestamp = math.min(os.time(), EndGameTimestamp)
      self:OnSetDefenceGameRemainTime(EndGameTimestamp - CurrentTimestamp)
      if CurrentTimestamp == EndGameTimestamp then
        self:RemoveTimer("ClientGuardTaskTimer")
      end
    end, true, 0, "ClientGuardTaskTimer", true)
  end
  local bAllContainersClaimed = true
  for ContainerStaticId, ContainerInfo in pairs(self.DefenceContainerInfos or {}) do
    if ContainerInfo.IsAlive then
      if Mechanism.CreatorId == ContainerStaticId and StateId == self.ContainerRewardsClaimedStateId then
        DebugPrint("yly\t\tOnMechanismStateChange Mechanism.CreatorId =", ContainerStaticId, " Rewards were Claimed!")
        ContainerInfo.IsRewardsClaimed = true
      end
      if not ContainerInfo.IsRewardsClaimed then
        bAllContainersClaimed = false
      end
    end
  end
  if bAllContainersClaimed then
    DebugPrint("yly\t\tOnMechanismStateChange All Containers Rewards were Claimed!")
    EventManager:FireEvent(EventID.OnAllContainersRewardsClaimed)
  end
end

function M:OnSetDefenceGameRemainTime(RemainTime)
  self.DefenceGameRemainTime = RemainTime
end

function M:OnGetDefenceGameRemainTime()
  return self.DefenceGameRemainTime or 0
end

function M:OnShowToast(ToastType)
  if self.bForbidShowToastAgain then
    return
  end
  if ToastType == Const.DefenceGameToastType.Damaged then
    if self.bHudTips01OnDisplay then
      return
    end
    if not self:IsExistTimer("TimerToastCoolDown") then
      GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_35", 2, EToastType.Warning)
      self:AddTimer(self.ToastCD + 2, function()
        DebugPrint("yly BP_SoloTreasureComponent ToastCoolDown Finished")
      end, false, 0, "TimerToastCoolDown")
    end
  elseif ToastType == Const.DefenceGameToastType.Destroyed then
    GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_39", 2, EToastType.Warning)
  elseif ToastType == Const.DefenceGameToastType.Fail then
    self.bForbidShowToastAgain = true
    if self.IsPlayerOutBoundsCauseFailed then
      GameState(self):ShowDungeonToast_Lua("UI_SoloTreasure_GuardTask_MissionFailed2", 2, EToastType.Failed)
    else
      GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_40", 2, EToastType.Failed)
    end
  elseif ToastType == Const.DefenceGameToastType.Success then
    self.bForbidShowToastAgain = true
    GameState(self):ShowDungeonToast_Lua("UI_Extraction_TM_41", 2, EToastType.Success)
  end
end

function M:OnUnitDestoryEvent(MonsterC, CombatItemBase, DestroyReason)
  DebugPrint("yly\t\tOnUnitDestoryEvent")
  if not self.HasDefenceGame then
    return
  end
  if not IsValid(CombatItemBase) then
    return
  end
  local StaticId = CombatItemBase.CreatorId
  if not StaticId then
    return
  end
  if not self.DefenceContainerInfos[StaticId] then
    return
  end
  if not self.DefenceContainerInfos[StaticId].IsAlive then
    return
  end
  self.DefenceContainerInfos[StaticId].IsAlive = false
  local bContainerKillSelf = CombatItemBase.bKillSelf
  if bContainerKillSelf then
    self.IsPlayerOutBoundsCauseFailed = true
  end
  DebugPrint("yly\tOnUnitDestoryEvent Mechanism CreatorId =", StaticId, " DefenceContainer was Destroyed! IsKillSelf=", bContainerKillSelf)
  self.GameMode:NotifyServerDungeonEvent("SpecialContainerDead", StaticId)
  if not self:IsAllDefenceContainersDead() and not bContainerKillSelf then
    DebugPrint("yly OnUnitDestoryEvent Show Container Destroyed Toast")
    self:OnShowToast(Const.DefenceGameToastType.Destroyed)
  end
end

function M:OnSetHudTipsbOnDisplay(bOnDisplay)
  self.bHudTips01OnDisplay = bOnDisplay
end

function M:InitDefenceGameInfo(GamePlayInfo)
  if not GamePlayInfo then
    return
  end
  self.ContainerRewardsClaimedStateId = 1310675
  self.DefenceGameInteractiveInitStateId = 1310711
  self.HasDefenceGame = true
  self.DefenceGamePlayId = GamePlayInfo.GamePlayId
  self.DefenceGameInteractiveStaticId = GamePlayInfo.Interactive
  self.DefenceGameInteractiveStateId = GamePlayInfo.InteractiveStateId
  self.DefenceGameTotalTime = GamePlayInfo.CountDown
  self.ToastCD = DataMgr.GlobalConstant.SoloTreasureGuardToastCD.ConstantValue
  self.bForbidShowToastAgain = false
  self:OnSetHudTipsbOnDisplay(false)
  self.IsPlayingDefenceGame = false
  self.IsPlayerOutBoundsCauseFailed = false
  self.DefenceContainerInfos = {}
  for Index, ContainerId in pairs(GamePlayInfo.Container or {}) do
    self.DefenceContainerInfos[ContainerId] = {
      IsAlive = true,
      GuideOrderId = Index,
      IsRewardsClaimed = false
    }
  end
  EventManager:AddEvent(EventID.OnPlayerNearbyGuardBounds, self, self.ShowNearbyBoundsWarn)
end

function M:IsAllDefenceContainersDead()
  if not self.HasDefenceGame then
    return true
  end
  for ContainerStaticId, ContainerInfo in pairs(self.DefenceContainerInfos or {}) do
    if ContainerInfo.IsAlive == true then
      return false
    end
  end
  return true
end

function M:RegisterGuideOrder(StaticId)
  for ContainerStaticId, value in pairs(self.DefenceContainerInfos) do
    if StaticId == ContainerStaticId then
      return value.GuideOrderId
    end
  end
  DebugPrint("BP_SoloTreasureComponent_C: RegisterGuideOrder StaticId Failed, StaticId = ", StaticId)
  return #self.DefenceContainerInfos
end

function M:DefenceGameEnd(IsWin)
  DebugPrint("ljl@ DefenceGameEnd IsWin:", IsWin)
  if IsWin then
    self:OnShowToast(Const.DefenceGameToastType.Success)
    for ContainerStaticId, ContainerInfo in pairs(self.DefenceContainerInfos) do
      if ContainerInfo.IsAlive then
        self.GameMode:TriggerMechanism(ContainerStaticId, 1310677)
      else
        self.GameMode:TriggerMechanism(ContainerStaticId, 1310676)
      end
    end
  else
    self:OnShowToast(Const.DefenceGameToastType.Fail)
  end
  self.IsPlayingDefenceGame = false
  EventManager:RemoveEvent(EventID.OnPlayerNearbyGuardBounds, self)
  EventManager:FireEvent(EventID.OnTaskEnded, IsWin)
end

function M:ShowRainToast()
  UIManager(GWorld.GameInstance):LoadUINew("LeaveSoloTreasureRainTips")
end

function M:ShowNearbyBoundsWarn()
  if self.IsPlayingDefenceGame then
    GameState(self):ShowDungeonToast_Lua("UI_SoloTreasure_GuardTask_MissionFailed_Warring", 2, EToastType.Warning)
  end
end

return M
