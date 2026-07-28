local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local M = Class({
  "BluePrints.Common.TimerMgr"
})
local TrialRuleHandlers = {
  Rate = function(Tracker, TrialId, RuleValue, BossTotalHp)
    BossTotalHp = BossTotalHp or 0
    if BossTotalHp <= 0 then
      return 0
    end
    local Damage = Tracker:GetTrialMatchingDamage(TrialId)
    return Damage * RuleValue / BossTotalHp
  end,
  Hit = function(Tracker, TrialId, RuleValue, BossTotalHp)
    return Tracker:GetTrialMatchingHitCount(TrialId)
  end
}

function M:InitGuildBossComponent()
  self.GameMode = self:GetOwner()
  if not self.GameMode then
    DebugPrint("BP_GuildBossComponent_C InitGuildBossComponent failed, GameMode is nil")
    return
  end
  self:InitTrialConfigs()
  local TimeLimit = 90
  if self.BossId and 0 ~= self.BossId then
    local BossInfo = DataMgr.GuildBossInfo and DataMgr.GuildBossInfo[self.BossId]
    if BossInfo and BossInfo.TimeLimit then
      TimeLimit = BossInfo.TimeLimit
    end
  end
  self.GameTotalTime = TimeLimit
  self.GameRemainTime = self.GameTotalTime
  DebugPrint("BP_GuildBossComponent_C Initialized, BossId:", self.BossId, "GameTotalTime:", self.GameTotalTime)
  EventManager:AddEvent(EventID.CloseLoading, self, self.OnCloseLoading)
end

function M:InitTrialConfigs()
  self.TypeToBuffMap = {}
  self.GuildFinishedTrials = {}
  self.ActiveTrials = {}
  local PreInit = self.GameMode and self.GameMode.PreInitInfo and self.GameMode.PreInitInfo.GuildBoss
  if not PreInit then
    DebugPrint("BP_GuildBossComponent_C InitTrialConfigs: PreInitInfo.GuildBoss 为空（未下发）")
    return
  end
  self.BossId = PreInit.BossId or 0
  self.IsAssist = PreInit.IsAssist or false
  self.BossTotalHp = PreInit.BossMaxHp or 0
  self.TrialFinishNeed = PreInit.TrialFinishNeed or {}
  DebugPrint("BP_GuildBossComponent_C InitTrialConfigs: BossId=", self.BossId, "IsAssist=", self.IsAssist, "BossTotalHp=", self.BossTotalHp)
  local BossInfo = DataMgr.GuildBossInfo and DataMgr.GuildBossInfo[self.BossId]
  if not BossInfo then
    DebugPrint("BP_GuildBossComponent_C InitTrialConfigs: 配表中未找到 BossId=", self.BossId, " 的配置")
    return
  end
  local TestTypeList = BossInfo.RandomTest or {}
  local BuffList = BossInfo.GuildWarBuff or {}
  for Index, TestType in ipairs(TestTypeList) do
    self.TypeToBuffMap[TestType] = BuffList[Index]
  end
  self.BossCreatorID = BossInfo.BossCreatorID or 0
  self.GuildBossBaseRate = BossInfo.GuildBossBaseRate or 0
  DebugPrint("BP_GuildBossComponent_C InitTrialConfigs: TestTypeList数=", #TestTypeList, "BossCreatorID=", self.BossCreatorID, "BaseRate=", self.GuildBossBaseRate)
  self.TrialConfigs = {}
  local TrialList = PreInit.TrialList or {}
  local TrialProgress = PreInit.TrialProgress or {}
  DebugPrint("BP_GuildBossComponent_C InitTrialConfigs: TrialList数=", #TrialList)
  for _, RawTrialId in ipairs(TrialList) do
    local TrialId = tonumber(RawTrialId)
    if TrialId then
      local TestConf = DataMgr.GuildWarTest and DataMgr.GuildWarTest[TrialId]
      if TestConf then
        self.TrialConfigs[TrialId] = {
          TestType = TestConf.TestType,
          CalulationRule = TestConf.CalulationRule,
          DamageCondition = TestConf.DamageCondition,
          ContributionRate = tonumber(TestConf.ContributionRate) or 1
        }
      end
      local Progress = TrialProgress[TrialId] or TrialProgress[tostring(TrialId)] or 0
      local Need = self:GetTrialFinishNeed(TrialId)
      if Need > 0 and Progress >= Need then
        table.insert(self.GuildFinishedTrials, TrialId)
      else
        table.insert(self.ActiveTrials, TrialId)
      end
    end
  end
  DebugPrint("BP_GuildBossComponent_C InitTrialConfigs: 活跃试炼数=", #self.ActiveTrials, "已完成试炼数=", #self.GuildFinishedTrials)
end

function M:GetCurrentBossId()
  if self.BossId and 0 ~= self.BossId then
    return self.BossId
  end
  local GuildBossData = GuildModel and GuildModel:GetGuildBossData()
  if GuildBossData then
    return GuildBossData:GetCurrentBossId() or 0
  end
  return 0
end

function M:OnCloseLoading()
  EventManager:RemoveEvent(EventID.CloseLoading, self)
  DebugPrint("BP_GuildBossComponent_C OnCloseLoading")
end

function M:OnStartCountDown()
  local TimeLimit = self.GameTotalTime or 90
  DebugPrint("BP_GuildBossComponent_C:OnStartCountDown TimeLimit =", TimeLimit)
  self.GameMode:BpAddTimer("GuildBossCountDownTimer", TimeLimit, false, Const.GameModeEventServerClient)
  self:AddTimer(0.1, function()
    if self.bFinished then
      return
    end
    local RemainTime = self.GameMode:BpGetRemainTime("GuildBossCountDownTimer")
    if type(RemainTime) == "number" and RemainTime >= 0 and RemainTime < 1.0E9 then
      self:OnUpdateCountDown(math.floor(RemainTime))
    end
  end, true, 0, "GuildBossCountDownTickTimer", false)
end

function M:BpOnTimerEnd_GuildBossCountDownTimer()
  DebugPrint("BP_GuildBossComponent_C BpOnTimerEnd_GuildBossCountDownTimer")
  self:OnTimeOver()
end

function M:OnCreateGuildBoss()
  local CurrentBossUnitId = self.BossId
  local BossCreatorId = self.BossCreatorID
  if not (CurrentBossUnitId and 0 ~= CurrentBossUnitId and BossCreatorId) or 0 == BossCreatorId then
    DebugPrint("BP_GuildBossComponent_C OnCreateGuildBoss: BossId/CreatorId 无效（PreInitInfo 未就绪？）")
    return
  end
  local Creator = self.GameMode.EMGameState.StaticCreatorMap:Find(BossCreatorId)
  if not IsValid(Creator) then
    DebugPrint("BP_GuildBossComponent_C CreateBoss failed to find creator", "CreatorId", BossCreatorId)
    return
  end
  Creator.UnitId = CurrentBossUnitId
  local CreatorIdArray = TArray(0)
  CreatorIdArray:Add(BossCreatorId)
  self.GameMode:TriggerActiveStaticCreator(CreatorIdArray, "GuildBoss")
  DebugPrint("BP_GuildBossComponent_C OnCreateGuildBoss: 触发创建 Boss, BossId=", CurrentBossUnitId, "CreatorId=", BossCreatorId)
end

function M:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
  if "GuildBoss" ~= EventName then
    return
  end
  DebugPrint("BP_GuildBossComponent_C OnStaticCreatorEvent: Eid=", Eid, "UnitId=", UnitId, "CreatorId=", CreatorId)
  self.BossEid = Eid
  local Boss = Battle(self):GetEntity(Eid)
  if not IsValid(Boss) then
    DebugPrint("BP_GuildBossComponent_C OnStaticCreatorEvent: Boss实体无效, Eid=", Eid)
    return
  end
  if (self.BossTotalHp or 0) <= 0 then
    self.BossTotalHp = Boss.GetAttr and Boss:GetAttr("MaxHp") or 0
    DebugPrint("BP_GuildBossComponent_C OnStaticCreatorEvent: BossTotalHp 兜底取值 =", self.BossTotalHp)
  end
  local Tracker = Battle(self):GetGuildBossDamageTracker()
  self.DamageTracker = Tracker
  if not Tracker then
    DebugPrint("BP_GuildBossComponent_C OnStaticCreatorEvent: 伤害追踪器不可用，跳过 Buff 和统计")
    return
  end
  self.AppliedBuffIds = {}
  for _, TrialId in ipairs(self.ActiveTrials) do
    local TrialConf = self.TrialConfigs and self.TrialConfigs[TrialId]
    local TestType = TrialConf and TrialConf.TestType
    local BuffEntryId = TestType and self.TypeToBuffMap[TestType]
    local BuffConf = BuffEntryId and DataMgr.GuildWarBuff and DataMgr.GuildWarBuff[BuffEntryId]
    local BuffIds = BuffConf and BuffConf.BuffID or {}
    for _, BuffId in ipairs(BuffIds) do
      if BuffId > 0 then
        Battle(self):AddBuffToTarget(Boss, Boss, BuffId, -1)
        table.insert(self.AppliedBuffIds, BuffId)
      end
    end
  end
  DebugPrint("BP_GuildBossComponent_C OnStaticCreatorEvent: 上Buff完成, AppliedBuffIds数=", #self.AppliedBuffIds, "活跃试炼数=", #self.ActiveTrials)
  Tracker:ActivateTracker(Eid)
  for _, TrialId in ipairs(self.ActiveTrials) do
    local TrialConf = self.TrialConfigs and self.TrialConfigs[TrialId]
    local Cond = TrialConf and TrialConf.DamageCondition
    if Cond then
      for CondType, CondValue in pairs(Cond) do
        Tracker:AddTrialCondition(TrialId, tostring(CondType), tostring(CondValue))
      end
    end
  end
  DebugPrint("BP_GuildBossComponent_C OnStaticCreatorEvent: 全部完成, BossEid=", self.BossEid, "BossTotalHp=", self.BossTotalHp, "活跃试炼数=", #self.ActiveTrials)
end

function M:TriggerGuildBossOnEnd()
  DebugPrint("BP_GuildBossComponent_C TriggerGuildBossOnEnd")
  self:FinishGuildBoss(true, "Exit")
end

function M:OnBossDead(Monster)
  DebugPrint("BP_GuildBossComponent_C OnBossDead")
  self:FinishGuildBoss(true, "BossDead")
end

function M:OnTimeOver()
  DebugPrint("BP_GuildBossComponent_C OnTimeOver")
  self:FinishGuildBoss(true, "TimeOver")
end

function M:StopGuildBossTimer()
  self.GameMode:BpDelTimer("GuildBossCountDownTimer", false, Const.GameModeEventServerClient)
  self:RemoveTimer("GuildBossCountDownTickTimer", false)
end

function M:FinishGuildBoss(IsWin, Reason)
  DebugPrint("BP_GuildBossComponent_C FinishGuildBoss: IsWin=", IsWin, "Reason=", Reason, "bFinished=", self.bFinished)
  if self.bFinished then
    return
  end
  self.bFinished = true
  self:StopGuildBossTimer()
  self:SyncGuildBossSettleInfo(IsWin)
  if self.DamageTracker then
    self.DamageTracker:DeactivateTracker()
  end
  if IsWin then
    self:OnDungeonWin(Reason)
  else
    self:OnDungeonFailed(Reason)
  end
end

function M:ComputeTrialContribution(TrialId)
  local Tracker = self.DamageTracker
  local TrialConf = self.TrialConfigs and self.TrialConfigs[TrialId]
  local Rule = TrialConf and TrialConf.CalulationRule
  if not Rule or not Tracker then
    return 0
  end
  for RuleKey, RuleValue in pairs(Rule) do
    local Handler = TrialRuleHandlers[RuleKey]
    if Handler then
      return Handler(Tracker, TrialId, RuleValue, self.BossTotalHp), RuleKey, RuleValue
    end
  end
  return 0
end

function M:GetTrialFinishNeed(TrialId)
  local Need = not self.TrialFinishNeed or self.TrialFinishNeed[TrialId] or self.TrialFinishNeed[tostring(TrialId)]
  return tonumber(Need) or 0
end

function M:ComputeTrialBreakProgress(TrialId, Contribution)
  local Need = self:GetTrialFinishNeed(TrialId)
  if Need <= 0 then
    return 0
  end
  local Progress = (Contribution or 0) / Need
  if Progress < 0 then
    return 0
  end
  if Progress > 1 then
    return 1
  end
  return Progress
end

function M:BuildGuildBossFinishInfo(IsWin, Source)
  DebugPrint("BP_GuildBossComponent_C BuildGuildBossFinishInfo: IsWin=", IsWin, "Source=", Source)
  local Tracker = self.DamageTracker
  local TotalDamage = Tracker and Tracker:GetTotalDamage() or 0
  local Snapshot = self:GetLiveStatsSnapshot()
  local TrialContribution = {}
  local FinishedTrials = {}
  if IsWin then
    for _, TrialId in ipairs(self.GuildFinishedTrials) do
      TrialContribution[TrialId] = -1
    end
    for _, TrialId in ipairs(self.ActiveTrials) do
      local Contribution = self:ComputeTrialContribution(TrialId)
      TrialContribution[TrialId] = Contribution
      if Contribution > 0 then
        table.insert(FinishedTrials, TrialId)
      end
    end
  end
  local Score = IsWin and math.floor(tonumber(Snapshot.LiveScore) or 0) or 0
  local Result = {
    Damage = IsWin and math.floor(tonumber(TotalDamage) or 0) or 0,
    Score = Score,
    TrialContribution = TrialContribution,
    FinishedTrials = FinishedTrials,
    CombatData = self:BuildGuildBossCombatData(Snapshot)
  }
  DebugPrint("BP_GuildBossComponent_C BuildGuildBossFinishInfo: TotalDamage=", TotalDamage, "Score=", Score, "活跃试炼数=", #self.ActiveTrials, "已完成试炼数=", #self.GuildFinishedTrials, "本局完成试炼数=", #FinishedTrials)
  return Result
end

function M:BuildGuildBossCombatData(Snapshot)
  local CombatData = {}
  Snapshot = Snapshot or self:GetLiveStatsSnapshot()
  for TrialId, TrialData in pairs(Snapshot.Trials) do
    CombatData[TrialId] = {
      TestType = TrialData.TestType,
      Broken = TrialData.Broken,
      MatchDamage = TrialData.MatchDamage or 0,
      MatchHit = TrialData.MatchHit or 0,
      Contribution = TrialData.Contribution or 0,
      BreakProgress = TrialData.BreakProgress or 0
    }
  end
  return CombatData
end

function M:GetLiveStatsSnapshot()
  local Tracker = self.DamageTracker
  local Snapshot = {
    BossEid = self.BossEid,
    BossTotalHp = self.BossTotalHp or 0,
    RemainTime = self.GameRemainTime or 0,
    TotalDamage = Tracker and Tracker:GetTotalDamage() or 0,
    Trials = {}
  }
  local ScoreContribSum = 0
  for _, TrialId in ipairs(self.ActiveTrials or {}) do
    local TrialConf = self.TrialConfigs and self.TrialConfigs[TrialId]
    local Contribution = self:ComputeTrialContribution(TrialId)
    local BreakProgress = self:ComputeTrialBreakProgress(TrialId, Contribution)
    local ContributionRate = TrialConf and TrialConf.ContributionRate or 1
    local ScoreContribution = BreakProgress * ContributionRate
    ScoreContribSum = ScoreContribSum + ScoreContribution
    Snapshot.Trials[TrialId] = {
      TestType = TrialConf and TrialConf.TestType,
      Broken = false,
      MatchDamage = Tracker and Tracker:GetTrialMatchingDamage(TrialId) or 0,
      MatchHit = Tracker and Tracker:GetTrialMatchingHitCount(TrialId) or 0,
      Contribution = Contribution,
      BreakProgress = BreakProgress,
      ContributionRate = ContributionRate,
      ScoreContribution = ScoreContribution
    }
  end
  for _, TrialId in ipairs(self.GuildFinishedTrials or {}) do
    local TrialConf = self.TrialConfigs and self.TrialConfigs[TrialId]
    Snapshot.Trials[TrialId] = {
      TestType = TrialConf and TrialConf.TestType,
      Broken = true
    }
  end
  local BaseRate = self.GuildBossBaseRate or 1
  Snapshot.GuildBossBaseRate = BaseRate
  Snapshot.LiveScore = Snapshot.TotalDamage / BaseRate + ScoreContribSum
  return Snapshot
end

function M:SyncGuildBossSettleInfo(IsWin)
  DebugPrint("BP_GuildBossComponent_C SyncGuildBossSettleInfo: IsWin=", IsWin)
  if not self.GameMode or not self.GameMode.NotifyServerDungeonEvent then
    DebugPrint("BP_GuildBossComponent_C SyncGuildBossSettleInfo: GameMode 或 NotifyServerDungeonEvent 不可用")
    return
  end
  self.GameMode:NotifyServerDungeonEvent("GuildBossUpdateSettle", self:BuildGuildBossFinishInfo(IsWin, "Sync"))
end

function M:CustomFinishInfo(AvatarStr, IsWin)
  return self:BuildGuildBossFinishInfo(IsWin, "CustomFinish")
end

function M:OnDungeonWin(Reason)
  DebugPrint("BP_GuildBossComponent_C OnDungeonWin: Reason=", Reason)
  self.GameMode:NotifyServerGameEnd(true, Reason)
end

function M:OnDungeonFailed(Reason)
  DebugPrint("BP_GuildBossComponent_C OnDungeonFailed: Reason=", Reason)
  self.GameMode:NotifyServerGameEnd(false, Reason)
end

function M:OnSyncTimerTick(GameRemainTime, TimerHandle)
  self:OnUpdateCountDown(GameRemainTime)
end

function M:OnUpdateCountDown(GameRemainTime)
  if self.bFinished then
    return
  end
  self.GameRemainTime = GameRemainTime
  local Tracker = self.DamageTracker
  if Tracker and Tracker.bStatsDirty then
    Tracker.bStatsDirty = false
    local Snapshot = self:GetLiveStatsSnapshot()
    EventManager:FireEvent(EventID.OnGuildBossStatsUpdate, Snapshot)
  end
  local BattleMain = UIManager(self):GetUI("BattleMain")
  if BattleMain then
    BattleMain:UpdateGuildBossCountDown(GameRemainTime)
  end
end

return M
