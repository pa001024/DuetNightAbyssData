require("UnLua")
local M = Class({
  "BluePrints.Common.TimerMgr"
})
local AsyncMsg = CommonConst.DungeonSyncMsg
local DAMAGE_REPORT_INTERVAL = 0.3
local DAMAGE_REPORT_TIMER_KEY = "AsyncCombat_DamageReport"
local MATCH_TIMER_KEY = "AsyncCombat_MatchTimer"
local MATCH_TIMER_INTERVAL = 1

function M:InitAsyncCombatComponent()
  self.GameMode = self:GetOwner()
  if not self.GameMode.PreInitInfo then
    DebugPrint("AsyncCombatComponent: 服务器传入数据为空！")
    return
  end
  self.RoomConfId = self.GameMode.PreInitInfo.RoomConfId or 0
  self.BossCurStep = self.GameMode.PreInitInfo.CurStep or 0
  self.IsSingleMode = self.GameMode.PreInitInfo.bSingleMode or false
  self.SingleModeInheritedDamage = (self.GameMode.PreInitInfo.Damage or 0) + (self.GameMode.PreInitInfo.SingleModeDamage or 0)
  self.SingleModeTotalHp = self.GameMode.PreInitInfo.RoomTotalHp or 0
  self.SingleModeDamage = 0
  self.IsSingleModeContributionReached = false
  self.IsRoomFinished = false
  DebugPrint("AsyncCombatComponent: Init_BossCurStep", self.BossCurStep, "RoomConfId", self.RoomConfId, "IsSingleMode", self.IsSingleMode)
  self.IsSingleModeBossSpawned = false
  self.AsyncCombatInfo = DataMgr.AsyncCombat[self.RoomConfId]
  if not self.AsyncCombatInfo then
    DebugPrint("AsyncCombatComponent: 读表数据为空！RoomConfId", self.RoomConfId)
    return
  end
  self.BossCreatorId = self.AsyncCombatInfo.BossCreatorID
  self.BossUnitIds = self.AsyncCombatInfo.BossUnitID
  self.SingleModeBossUnitId = self.AsyncCombatInfo.SingleModeBossUnitID
  EventManager:AddEvent(EventID.OnRepClientDungeonMessage, self, self.OnRepClientDungeonMessage)
  self.BossIsDead = false
  self.CurBossEid = nil
  self.ActiveBossStep = 0
  self.ReportedDamageTotal = 0
  self.AppliedOthersDamage = 0
  self.CurBossId = nil
  self.BossDamageTrackingEid = nil
  self.BossDamageTrackingBossId = nil
  self.BossDamageTrackingStep = nil
  self.TimeBuffConfig = nil
  self.MatchStartTime = nil
  self.CurTimeBuffId = nil
  self:ParseTimeBuffConfig()
  self:PublishSingleModeProgress()
end

function M:InitAsyncCombatBaseInfo()
  self:CreateBoss()
  self:TryStartMatchTimer()
end

function M:CustomFinishInfo(_, IsWin)
  if self.IsSingleMode then
    self:StopBossDamageTracking(false)
  end
  return {
    SingleModeDamage = self.SingleModeDamage or 0
  }
end

function M:CreateBoss()
  if self.IsSingleMode and self.IsSingleModeBossSpawned then
    DebugPrint("ljl@ AsyncCombat CreateBoss skipped single mode already spawned")
    return
  end
  local CurUnitId = self.BossUnitIds[self.BossCurStep]
  if self.IsSingleMode then
    CurUnitId = self.SingleModeBossUnitId
  end
  if not CurUnitId then
    return
  end
  local Creator = self.GameMode.EMGameState.StaticCreatorMap:Find(self.BossCreatorId)
  if not IsValid(Creator) then
    DebugPrint("ljl@ AsyncCombat CreateBoss failed to find creator", "CreatorId", self.BossCreatorId)
    return
  end
  Creator.UnitId = CurUnitId
  local CreatorIdArray = TArray(0)
  CreatorIdArray:Add(self.BossCreatorId)
  self.GameMode:TriggerActiveStaticCreator(CreatorIdArray, "AsyncCombatBoss")
  if self.IsSingleMode then
    self.IsSingleModeBossSpawned = true
  end
end

function M:OnRepClientDungeonMessage(MessageName, ...)
  DebugPrint("AsyncCombatComponent:OnRepClientDungeonMessage", MessageName)
  if self.IsSingleMode and (MessageName == AsyncMsg.AsyncCombatBattleStateUpdate or MessageName == AsyncMsg.AsyncCombatBossDead or MessageName == AsyncMsg.AsyncCombatRoomStateUpdate) then
    return
  end
  if MessageName == AsyncMsg.AsyncCombatBattleStateUpdate then
    local Data = (...)
    self:ApplyBossHP(Data.BossRemainHp)
  elseif MessageName == AsyncMsg.AsyncCombatBossDead then
    local Data = (...)
    self:OnBossDeadFromServer()
    self:OnRep_CurStep(Data.NextStep)
  elseif MessageName == AsyncMsg.AsyncCombatRoomStateUpdate then
    local Data = (...)
    self:OnRep_CurStep(Data.CurStep)
  elseif MessageName == AsyncMsg.AsyncCombatRoomPass then
    if self.GameMode.AlreadyInit then
      self:OnRoomPass()
    elseif not self.IsPendingRoomEnd then
      self.IsPendingRoomEnd = true
      self.GameMode.EMGameState:RegisterGameModeEvent("OnInit", self, function()
        self:OnRoomPass()
      end)
    end
  elseif MessageName == AsyncMsg.AsyncCombatRoomClose then
    if self.GameMode.AlreadyInit then
      self:OnRoomClose()
    elseif not self.IsPendingRoomEnd then
      self.IsPendingRoomEnd = true
      self.GameMode.EMGameState:RegisterGameModeEvent("OnInit", self, function()
        self:OnRoomClose()
      end)
    end
  elseif MessageName == AsyncMsg.AsyncCombatExtraRoomClose then
    local Data = (...)
    local CurrentRoomUniId = self.GameMode.PreInitInfo and self.GameMode.PreInitInfo.RoomUniId
    if not (Data and CurrentRoomUniId) or Data.RoomUniId ~= CurrentRoomUniId then
      return
    end
    DebugPrint("AsyncCombatComponent: Extra room closed", "RoomUniId", Data.RoomUniId)
    if self.GameMode.AlreadyInit then
      self:OnRoomClose()
    elseif not self.IsPendingRoomEnd then
      self.IsPendingRoomEnd = true
      self.GameMode.EMGameState:RegisterGameModeEvent("OnInit", self, function()
        self:OnRoomClose()
      end)
    end
  end
end

function M:OnRep_CurStep(NewCurStep)
  if NewCurStep <= self.BossCurStep then
    return
  end
  self.BossCurStep = NewCurStep
  DebugPrint("AsyncCombatComponent: Update BossCurStep", self.BossCurStep)
  if not self.GameMode.AlreadyInit then
    return
  end
  self:CreateBoss()
end

function M:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
  if "AsyncCombatBoss" == EventName then
    local SpawnStep = self:GetBossStepByUnitId(UnitId)
    if SpawnStep and SpawnStep < self.ActiveBossStep then
      self:KillBossByDeath(Eid)
      return
    end
    EventManager:FireEvent(EventID.OnRepClientDungeonMessage, "BossCreated")
    self:StopBossDamageTracking(false)
    if self.CurBossEid and self.CurBossEid ~= Eid then
      self:KillBossByDeath(self.CurBossEid)
    end
    self.CurBossEid = Eid
    self.CurBossId = CreatorId
    self.ActiveBossStep = SpawnStep or self.ActiveBossStep
    self.BossIsDead = false
    self.ReportedDamageTotal = 0
    self.AppliedOthersDamage = 0
    local BossEntity = Battle(self):GetEntity(Eid)
    if not IsValid(BossEntity) then
      return
    end
    self:StartBossDamageTracking(Eid)
    if self.IsSingleMode then
      return
    end
    local Avatar = GWorld:GetAvatar()
    Avatar:SyncToServerDungeonMessage(AsyncMsg.AsyncCombatQueryState, {Type = "Battle"})
  end
end

function M:GetBossStepByUnitId(UnitId)
  if not self.BossUnitIds then
    return nil
  end
  for Step, Uid in ipairs(self.BossUnitIds) do
    if Uid == UnitId then
      return Step
    end
  end
  return nil
end

function M:KillBossByDeath(BossEid)
  local BossEntity = Battle(self):GetEntity(BossEid)
  if not IsValid(BossEntity) then
    return false
  end
  local CurHp = BossEntity:GetAttr("Hp")
  if CurHp > 0 then
    BossEntity:AddHp(-CurHp)
  end
  Battle(self):BattleOnDead(BossEid, self:GetMainControlPlayerEid(), 0, EDeathReason.AsyncCombatServer)
  return true
end

function M:OnUnitDeadEvent(MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
  if not IsValid(MonsterC) then
    return
  end
  local IsCurrentBoss = self.IsSingleMode and MonsterC.Eid == self.CurBossEid
  if not self.IsSingleMode then
    local CurUnitId = self.BossUnitIds[self.BossCurStep]
    IsCurrentBoss = CurUnitId == MonsterC.UnitId
  end
  if IsCurrentBoss then
    self.BossIsDead = true
    self:StopBossDamageTracking(false)
    if self.IsSingleMode and not self.IsSingleModeContributionReached then
      self:OnRoomPass()
    end
  end
end

function M:ReceiveEndPlay(...)
  self.Overridden.ReceiveEndPlay(self, ...)
  EventManager:RemoveEvent(EventID.OnRepClientDungeonMessage, self)
  EventManager:RemoveEvent(EventID.CloseLoading, self)
  self:StopBossDamageTracking(false)
  self:StopTimeBuff()
end

function M:ApplyBossHP(BossRemainHp)
  if self.BossIsDead then
    return
  end
  local BossEntity = Battle(self):GetEntity(self.CurBossEid)
  if not IsValid(BossEntity) then
    return
  end
  local LocalMaxHp = BossEntity:GetAttr("MaxHp")
  local TotalDamageFromAll = LocalMaxHp - BossRemainHp
  local OthersTotal = math.max(0, TotalDamageFromAll - self.ReportedDamageTotal)
  local OthersDelta = OthersTotal - self.AppliedOthersDamage
  if OthersDelta > 0 then
    local CurHp = BossEntity:GetAttr("Hp")
    OthersDelta = math.min(OthersDelta, CurHp - 1)
    if OthersDelta <= 0 then
      return
    end
    BossEntity:AddHp(-OthersDelta)
    self.AppliedOthersDamage = OthersTotal
  end
end

function M:StartBossDamageTracking(BossEid)
  if not BossEid or 0 == BossEid then
    return
  end
  self.BossDamageTrackingEid = BossEid
  self.BossDamageTrackingBossId = self.BossUnitIds[self.BossCurStep or 1] or 0
  self.BossDamageTrackingStep = self.BossCurStep
  Battle(self):ActivateAsyncCombatDamageTracker(BossEid)
  self:AddTimer(DAMAGE_REPORT_INTERVAL, function()
    self:ReportAccumulatedDamage()
  end, true, DAMAGE_REPORT_INTERVAL, DAMAGE_REPORT_TIMER_KEY)
end

function M:ReportAccumulatedDamage(bIgnoreBossDead)
  if self.BossIsDead and not bIgnoreBossDead then
    return
  end
  local TrackingEid = self.BossDamageTrackingEid
  if not TrackingEid then
    return
  end
  if self.IsSingleMode then
    self:ConsumeSingleModeDamage(true)
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Damage = Battle(self):ConsumeAsyncCombatDamage(TrackingEid)
  if Damage <= 0 then
    return
  end
  Avatar:SyncToServerDungeonMessage(AsyncMsg.AsyncCombatBossDamage, {
    Damage = Damage,
    BossId = self.BossDamageTrackingBossId,
    CurStep = self.BossDamageTrackingStep
  })
  self.ReportedDamageTotal = self.ReportedDamageTotal + Damage
end

function M:GetSingleModeProgressSnapshot()
  if not self.IsSingleMode then
    return nil
  end
  local MyDamage = (self.SingleModeInheritedDamage or 0) + (self.SingleModeDamage or 0)
  local RoomTotalHp = self.SingleModeTotalHp or 0
  local Progress = RoomTotalHp > 0 and math.min(100, MyDamage / RoomTotalHp * 100) or 0
  local RequiredProgress = DataMgr.AsyncCombatEventConstant.AsyncCombat_BaseContributionRequire.ConstantValue / 100
  return {
    MyDamage = MyDamage,
    RoomTotalHp = RoomTotalHp,
    Progress = Progress,
    RequiredProgress = RequiredProgress
  }
end

function M:PublishSingleModeProgress()
  local Snapshot = self:GetSingleModeProgressSnapshot()
  if not Snapshot then
    return
  end
  EventManager:FireEvent(EventID.OnAsyncCombatSingleModeProgressUpdate, Snapshot)
end

function M:ConsumeSingleModeDamage(bCheckContribution)
  if not self.IsSingleMode or not self.BossDamageTrackingEid then
    return 0
  end
  local Damage = Battle(self):ConsumeAsyncCombatDamage(self.BossDamageTrackingEid)
  if Damage <= 0 then
    return 0
  end
  self.SingleModeDamage = (self.SingleModeDamage or 0) + Damage
  self:PublishSingleModeProgress()
  if bCheckContribution then
    self:TryFinishSingleMode()
  end
  return Damage
end

function M:TryFinishSingleMode()
  if not self.IsSingleMode or self.IsSingleModeContributionReached then
    return
  end
  if not self.SingleModeTotalHp or self.SingleModeTotalHp <= 0 then
    return
  end
  local TotalDamage = (self.SingleModeInheritedDamage or 0) + (self.SingleModeDamage or 0)
  if not CommonUtils.IsReachBaseContribution(TotalDamage, self.SingleModeTotalHp) then
    return
  end
  self.IsSingleModeContributionReached = true
  self:StopBossDamageTracking(true)
  self:OnRoomPass()
end

function M:StopBossDamageTracking(bSkipFlush)
  self:RemoveTimer(DAMAGE_REPORT_TIMER_KEY)
  local TrackingEid = self.BossDamageTrackingEid
  if not TrackingEid then
    return
  end
  if not bSkipFlush then
    if self.IsSingleMode then
      self:ConsumeSingleModeDamage(false)
    else
      self:ReportAccumulatedDamage(true)
    end
  end
  Battle(self):DeactivateAsyncCombatDamageTracker(TrackingEid)
  self.BossDamageTrackingEid = nil
  self.BossDamageTrackingBossId = nil
  self.BossDamageTrackingStep = nil
end

function M:GetMainControlPlayerEid()
  local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsValid(MainPlayer) then
    return MainPlayer.Eid or 0
  end
  return 0
end

function M:OnBossDeadFromServer()
  if self.BossIsDead then
    return
  end
  local BossEntity = Battle(self):GetEntity(self.CurBossEid)
  if not IsValid(BossEntity) then
    self:StopBossDamageTracking(false)
    self.BossIsDead = true
    return
  end
  if BossEntity:IsDead() or BossEntity:GetAttr("Hp") <= 0 then
    self:StopBossDamageTracking(false)
    self.BossIsDead = true
    return
  end
  self:StopBossDamageTracking(false)
  self.BossIsDead = true
  local CurHp = BossEntity:GetAttr("Hp")
  if CurHp > 0 then
    BossEntity:AddHp(-CurHp)
  end
  Battle(self):BattleOnDead(self.CurBossEid, self:GetMainControlPlayerEid(), 0, EDeathReason.AsyncCombatServer)
end

function M:OnRoomPass()
  if self.IsSingleMode then
    if self.IsRoomFinished then
      return
    end
    self.IsRoomFinished = true
  end
  self.GameMode:TriggerDungeonWin()
  self:StopBossDamageTracking(false)
end

function M:OnRoomClose()
  if self.IsSingleMode then
    if self.IsRoomFinished then
      return
    end
    self.IsRoomFinished = true
  end
  self.GameMode:TriggerDungeonFailed()
  self:StopBossDamageTracking(false)
  self:StopTimeBuff()
end

function M:ParseTimeBuffConfig()
  local RawConfig = self.AsyncCombatInfo and self.AsyncCombatInfo.DungeonBuff
  if not RawConfig or "" == RawConfig then
    DebugPrint("lkh@ AsyncCombat ParseTimeBuffConfig: no config")
    return
  end
  self.TimeBuffConfig = {}
  for Pair in string.gmatch(RawConfig, "([^,]+)") do
    local TimeStr, BuffIdStr = string.match(Pair, "(%d+):(%d+)")
    if TimeStr and BuffIdStr then
      table.insert(self.TimeBuffConfig, {
        time = tonumber(TimeStr),
        buffId = tonumber(BuffIdStr)
      })
    end
  end
  table.sort(self.TimeBuffConfig, function(a, b)
    return a.time < b.time
  end)
  DebugPrint("lkh@ AsyncCombat ParseTimeBuffConfig done", "count", #self.TimeBuffConfig)
end

function M:TryStartMatchTimer()
  if self.MatchStartTime then
    return
  end
  if not self.TimeBuffConfig or 0 == #self.TimeBuffConfig then
    DebugPrint("lkh@ AsyncCombat TryStartMatchTimer skipped: no TimeBuffConfig")
    return
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local LoadingUI = GameInstance and GameInstance:GetLoadingUI()
  if LoadingUI and LoadingUI.bIsInLoading then
    EventManager:RemoveEvent(EventID.CloseLoading, self)
    EventManager:AddEvent(EventID.CloseLoading, self, self.OnCloseLoadingStartMatchTimer)
    DebugPrint("lkh@ AsyncCombat TryStartMatchTimer wait CloseLoading")
    return
  end
  self:StartMatchTimer()
end

function M:OnCloseLoadingStartMatchTimer(...)
  EventManager:RemoveEvent(EventID.CloseLoading, self)
  DebugPrint("lkh@ AsyncCombat OnCloseLoadingStartMatchTimer")
  self:StartMatchTimer()
end

function M:StartMatchTimer()
  if self.MatchStartTime then
    DebugPrint("lkh@ AsyncCombat StartMatchTimer already started")
    return
  end
  if not self.TimeBuffConfig or 0 == #self.TimeBuffConfig then
    DebugPrint("lkh@ AsyncCombat StartMatchTimer skipped: no TimeBuffConfig")
    return
  end
  self.MatchStartTime = self.GameMode.EMGameState.ReplicatedAudioTimeSeconds
  DebugPrint("lkh@ AsyncCombat StartMatchTimer", "MatchStartTime", self.MatchStartTime)
  self:OnMatchTimerTick()
  self:AddTimer(MATCH_TIMER_INTERVAL, function()
    self:OnMatchTimerTick()
  end, true, MATCH_TIMER_INTERVAL, MATCH_TIMER_KEY)
end

function M:OnMatchTimerTick()
  if not self.MatchStartTime or not self.TimeBuffConfig then
    return
  end
  local Elapsed = self.GameMode.EMGameState.ReplicatedAudioTimeSeconds - self.MatchStartTime
  local NewBuffId = self:GetBuffIdByTime(Elapsed)
  DebugPrint("lkh@ TIME DEBUG", "AudioTimeSeconds", self.GameMode.EMGameState.ReplicatedAudioTimeSeconds, "MatchStartTime", self.MatchStartTime, "Elapsed", Elapsed)
  if NewBuffId and NewBuffId ~= self.CurTimeBuffId then
    DebugPrint("lkh@ AsyncCombat OnMatchTimerTick switch", "Elapsed", Elapsed, "OldBuffId", self.CurTimeBuffId, "NewBuffId", NewBuffId)
    self:SwitchTimeBuff(NewBuffId)
  end
end

function M:GetBuffIdByTime(Elapsed)
  if not self.TimeBuffConfig or 0 == #self.TimeBuffConfig then
    return nil
  end
  local Result
  for _, Entry in ipairs(self.TimeBuffConfig) do
    if Elapsed >= Entry.time then
      Result = Entry.buffId
    else
      break
    end
  end
  return Result
end

function M:SwitchTimeBuff(NewBuffId)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    DebugPrint("lkh@ AsyncCombat SwitchTimeBuff skipped: no player")
    return
  end
  if self.CurTimeBuffId then
    Battle(self):RemoveBuffFromTarget(Player, Player, self.CurTimeBuffId, false, -1)
  end
  Battle(self):AddBuffToTarget(Player, Player, NewBuffId, -1, 0, nil, 1)
  local PhantomTeammates = Player:GetPhantomTeammates()
  for _, Phantom in pairs(PhantomTeammates) do
    if IsValid(Phantom) and Phantom ~= Player then
      if self.CurTimeBuffId then
        Battle(self):RemoveBuffFromTarget(Phantom, Phantom, self.CurTimeBuffId, false, -1)
      end
      Battle(self):AddBuffToTarget(Player, Phantom, NewBuffId, -1, 0, nil, 1)
    end
  end
  DebugPrint("lkh@ AsyncCombat SwitchTimeBuff", "OldBuffId", self.CurTimeBuffId, "NewBuffId", NewBuffId)
  self.CurTimeBuffId = NewBuffId
end

function M:StopTimeBuff()
  self:RemoveTimer(MATCH_TIMER_KEY)
  if self.CurTimeBuffId then
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if IsValid(Player) then
      Battle(self):RemoveBuffFromTarget(Player, Player, self.CurTimeBuffId, false, -1)
      local PhantomTeammates = Player:GetPhantomTeammates()
      for _, Phantom in pairs(PhantomTeammates) do
        if IsValid(Phantom) and Phantom ~= Player then
          Battle(self):RemoveBuffFromTarget(Phantom, Phantom, self.CurTimeBuffId, false, -1)
        end
      end
    end
    DebugPrint("lkh@ AsyncCombat StopTimeBuff removed", "BuffId", self.CurTimeBuffId)
  end
  self.MatchStartTime = nil
  self.CurTimeBuffId = nil
end

function M:OnPlayerEnter(PlayerEid)
  if not self.CurTimeBuffId then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    DebugPrint("lkh@ AsyncCombat OnPlayerEnter invalid player", "PlayerEid", PlayerEid)
    return
  end
  Battle(self):AddBuffToTarget(Player, Player, self.CurTimeBuffId, -1, 0, nil, 1)
  local PhantomTeammates = Player:GetPhantomTeammates()
  for _, Phantom in pairs(PhantomTeammates) do
    if IsValid(Phantom) and Phantom ~= Player then
      Battle(self):AddBuffToTarget(Player, Phantom, self.CurTimeBuffId, -1, 0, nil, 1)
    end
  end
  DebugPrint("lkh@ AsyncCombat OnPlayerEnter addBuff", "PlayerEid", PlayerEid, "BuffId", self.CurTimeBuffId)
end

return M
