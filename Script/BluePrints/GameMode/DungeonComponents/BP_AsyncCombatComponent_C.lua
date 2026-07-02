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
  DebugPrint("AsyncCombatComponent: Init_BossCurStep", self.BossCurStep)
  self.AsyncCombatInfo = DataMgr.AsyncCombat[self.RoomConfId]
  if not self.AsyncCombatInfo then
    DebugPrint("AsyncCombatComponent: 读表数据为空！RoomConfId", self.RoomConfId)
    return
  end
  self.BossCreatorId = self.AsyncCombatInfo.BossCreatorID
  self.BossUnitIds = self.AsyncCombatInfo.BossUnitID
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
  DebugPrint("lgc@ AsyncCombat Init", "RoomConfId", self.RoomConfId, "BossCurStep", self.BossCurStep)
end

function M:InitAsyncCombatBaseInfo()
  self:CreateBoss()
  self:TryStartMatchTimer()
end

function M:CreateBoss()
  local CurUnitId = self.BossUnitIds[self.BossCurStep]
  if not CurUnitId then
    DebugPrint("lgc@ AsyncCombat CreateBoss skipped", "BossCurStep", self.BossCurStep)
    return
  end
  DebugPrint("lgc@ AsyncCombat CreateBoss", "BossCurStep", self.BossCurStep, "CreatorId", self.BossCreatorId, "UnitId", CurUnitId)
  local Creator = self.GameMode.EMGameState.StaticCreatorMap:Find(self.BossCreatorId)
  if not IsValid(Creator) then
    DebugPrint("ljl@ AsyncCombat CreateBoss failed to find creator", "CreatorId", self.BossCreatorId)
    return
  end
  Creator.UnitId = CurUnitId
  local CreatorIdArray = TArray(0)
  CreatorIdArray:Add(self.BossCreatorId)
  self.GameMode:TriggerActiveStaticCreator(CreatorIdArray, "AsyncCombatBoss")
end

function M:OnRepClientDungeonMessage(MessageName, ...)
  DebugPrint("AsyncCombatComponent:OnRepClientDungeonMessage", MessageName)
  if MessageName == AsyncMsg.AsyncCombatBattleStateUpdate then
    local Data = (...)
    DebugPrint("lgc@ AsyncCombat BattleStateUpdate", "BossRemainHp", Data and Data.BossRemainHp)
    self:ApplyBossHP(Data.BossRemainHp)
  elseif MessageName == AsyncMsg.AsyncCombatBossDead then
    local Data = (...)
    DebugPrint("lgc@ AsyncCombat BossDead message", "NextStep", Data and Data.NextStep, "NextBossId", Data and Data.NextBossId)
    self:OnBossDeadFromServer()
    self:OnRep_CurStep(Data.NextStep)
  elseif MessageName == AsyncMsg.AsyncCombatRoomStateUpdate then
    DebugPrint("lgc@ AsyncCombat: RoomStateUpdate", ...)
    local Data = (...)
    self:OnRep_CurStep(Data.CurStep)
  elseif MessageName == AsyncMsg.AsyncCombatRoomPass then
    if self.GameMode.AlreadyInit then
      self:OnRoomPass()
    elseif not self.IsPendingRoomEnd then
      self.IsPendingRoomEnd = true
      DebugPrint("lgc@ AsyncCombat: AsyncCombatRoomPass, Register to OnInit")
      self.GameMode.EMGameState:RegisterGameModeEvent("OnInit", self, function()
        self:OnRoomPass()
      end)
    end
  elseif MessageName == AsyncMsg.AsyncCombatRoomClose then
    if self.GameMode.AlreadyInit then
      self:OnRoomClose()
    elseif not self.IsPendingRoomEnd then
      self.IsPendingRoomEnd = true
      DebugPrint("lgc@ AsyncCombat: AsyncCombatRoomClose, Register to OnInit")
      self.GameMode.EMGameState:RegisterGameModeEvent("OnInit", self, function()
        self:OnRoomClose()
      end)
    end
  end
end

function M:OnRep_CurStep(NewCurStep)
  if NewCurStep <= self.BossCurStep then
    DebugPrint("lgc@ AsyncCombat OnRep_CurStep ignored NewStep", NewCurStep, "CurStep", self.BossCurStep)
    return
  end
  DebugPrint("lgc@ AsyncCombat OnRep_CurStep", "OldStep", self.BossCurStep, "NewStep", NewCurStep)
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
      DebugPrint("lgc@ AsyncCombat OnStaticCreatorEvent kill stale boss", "Eid", Eid, "SpawnStep", SpawnStep, "ActiveBossStep", self.ActiveBossStep)
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
    DebugPrint("lgc@ AsyncCombat BossCreated", "Eid", Eid, "UnitId", UnitId, "UnitType", UnitType, "CreatorId", CreatorId, "BossCurStep", self.BossCurStep)
    local BossEntity = Battle(self):GetEntity(Eid)
    if not IsValid(BossEntity) then
      DebugPrint("lgc@ AsyncCombat BossCreated invalid entity", "Eid", Eid)
      return
    end
    self:StartBossDamageTracking(Eid)
    local Avatar = GWorld:GetAvatar()
    DebugPrint("lgc@ AsyncCombat QueryState", "BossEid", self.CurBossEid, "BossId", self.CurBossId, "BossCurStep", self.BossCurStep)
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
    DebugPrint("lgc@ AsyncCombat KillBossByDeath skip invalid", "BossEid", BossEid)
    return false
  end
  local CurHp = BossEntity:GetAttr("Hp")
  if CurHp > 0 then
    BossEntity:AddHp(-CurHp)
  end
  Battle(self):BattleOnDead(BossEid, self:GetMainControlPlayerEid(), 0, EDeathReason.AsyncCombatServer)
  DebugPrint("lgc@ AsyncCombat KillBossByDeath", "BossEid", BossEid)
  return true
end

function M:OnUnitDeadEvent(MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
  if not IsValid(MonsterC) then
    return
  end
  local CurUnitId = self.BossUnitIds[self.BossCurStep]
  if CurUnitId == MonsterC.UnitId then
    DebugPrint("lgc@ AsyncCombat OnUnitDeadEvent", "MonsterEid", MonsterC.Eid, "UnitId", MonsterC.UnitId, "BossCurStep", self.BossCurStep, "DeathReason", DeathReason)
    self.BossIsDead = true
    self:StopBossDamageTracking(false)
  end
end

function M:ReceiveEndPlay(...)
  DebugPrint("lgc@ AsyncCombat ReceiveEndPlay", "CurBossEid", self.CurBossEid, "TrackingEid", self.BossDamageTrackingEid)
  self.Overridden.ReceiveEndPlay(self, ...)
  EventManager:RemoveEvent(EventID.OnRepClientDungeonMessage, self)
  EventManager:RemoveEvent(EventID.CloseLoading, self)
  self:StopBossDamageTracking(false)
  self:StopTimeBuff()
end

function M:ApplyBossHP(BossRemainHp)
  if self.BossIsDead then
    DebugPrint("lgc@ AsyncCombat ApplyBossHP skipped dead", "BossRemainHp", BossRemainHp, "CurBossEid", self.CurBossEid)
    return
  end
  local BossEntity = Battle(self):GetEntity(self.CurBossEid)
  if not IsValid(BossEntity) then
    DebugPrint("lgc@ AsyncCombat ApplyBossHP invalid entity", "CurBossEid", self.CurBossEid, "BossRemainHp", BossRemainHp)
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
    DebugPrint("lgc@ AsyncCombat ApplyBossHP", "BossRemainHp", BossRemainHp, "LocalMaxHp", LocalMaxHp, "ReportedDamageTotal", self.ReportedDamageTotal, "AppliedOthersDamage", self.AppliedOthersDamage, "OthersDelta", OthersDelta)
  else
    DebugPrint("lgc@ AsyncCombat ApplyBossHP no delta", "BossRemainHp", BossRemainHp, "ReportedDamageTotal", self.ReportedDamageTotal, "AppliedOthersDamage", self.AppliedOthersDamage)
  end
end

function M:StartBossDamageTracking(BossEid)
  if not BossEid or 0 == BossEid then
    DebugPrint("lgc@ AsyncCombat StartBossDamageTracking skipped", "BossEid", BossEid)
    return
  end
  self.BossDamageTrackingEid = BossEid
  self.BossDamageTrackingBossId = self.BossUnitIds[self.BossCurStep or 1] or 0
  self.BossDamageTrackingStep = self.BossCurStep
  DebugPrint("lgc@ AsyncCombat StartBossDamageTracking", "BossEid", BossEid, "BossId", self.BossDamageTrackingBossId, "BossCurStep", self.BossDamageTrackingStep, "Interval", DAMAGE_REPORT_INTERVAL)
  Battle(self):ActivateAsyncCombatDamageTracker(BossEid)
  self:AddTimer(DAMAGE_REPORT_INTERVAL, function()
    self:ReportAccumulatedDamage()
  end, true, DAMAGE_REPORT_INTERVAL, DAMAGE_REPORT_TIMER_KEY)
end

function M:ReportAccumulatedDamage(bIgnoreBossDead)
  if self.BossIsDead and not bIgnoreBossDead then
    DebugPrint("lgc@ AsyncCombat ReportAccumulatedDamage skipped dead", "TrackingEid", self.BossDamageTrackingEid)
    return
  end
  local TrackingEid = self.BossDamageTrackingEid
  if not TrackingEid then
    DebugPrint("lgc@ AsyncCombat ReportAccumulatedDamage skipped no tracking eid")
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint("lgc@ AsyncCombat ReportAccumulatedDamage skipped no avatar", "TrackingEid", TrackingEid)
    return
  end
  local Damage = Battle(self):ConsumeAsyncCombatDamage(TrackingEid)
  if Damage <= 0 then
    DebugPrint("lgc@ AsyncCombat ReportAccumulatedDamage empty", "TrackingEid", TrackingEid, "BossId", self.BossDamageTrackingBossId, "BossCurStep", self.BossDamageTrackingStep)
    return
  end
  DebugPrint("lgc@ AsyncCombat ReportAccumulatedDamage send", "TrackingEid", TrackingEid, "Damage", Damage, "BossId", self.BossDamageTrackingBossId, "BossCurStep", self.BossDamageTrackingStep, "IgnoreBossDead", bIgnoreBossDead)
  Avatar:SyncToServerDungeonMessage(AsyncMsg.AsyncCombatBossDamage, {
    Damage = Damage,
    BossId = self.BossDamageTrackingBossId,
    CurStep = self.BossDamageTrackingStep
  })
  self.ReportedDamageTotal = self.ReportedDamageTotal + Damage
  DebugPrint("lgc@ AsyncCombat ReportAccumulatedDamage done", "TrackingEid", TrackingEid, "ReportedDamageTotal", self.ReportedDamageTotal)
end

function M:StopBossDamageTracking(bSkipFlush)
  DebugPrint("lgc@ AsyncCombat StopBossDamageTracking", "TrackingEid", self.BossDamageTrackingEid, "BossId", self.BossDamageTrackingBossId, "BossCurStep", self.BossDamageTrackingStep, "SkipFlush", bSkipFlush)
  self:RemoveTimer(DAMAGE_REPORT_TIMER_KEY)
  local TrackingEid = self.BossDamageTrackingEid
  if not TrackingEid then
    DebugPrint("lgc@ AsyncCombat StopBossDamageTracking skipped no tracking eid")
    return
  end
  if not bSkipFlush then
    self:ReportAccumulatedDamage(true)
  end
  Battle(self):DeactivateAsyncCombatDamageTracker(TrackingEid)
  DebugPrint("lgc@ AsyncCombat StopBossDamageTracking done", "TrackingEid", TrackingEid)
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
    DebugPrint("lgc@ AsyncCombat OnBossDeadFromServer ignored", "CurBossEid", self.CurBossEid)
    return
  end
  DebugPrint("lgc@ AsyncCombat OnBossDeadFromServer", "CurBossEid", self.CurBossEid, "CurBossId", self.CurBossId, "BossCurStep", self.BossCurStep)
  local BossEntity = Battle(self):GetEntity(self.CurBossEid)
  if not IsValid(BossEntity) then
    DebugPrint("lgc@ AsyncCombat OnBossDeadFromServer invalid entity", "CurBossEid", self.CurBossEid)
    self:StopBossDamageTracking(false)
    self.BossIsDead = true
    return
  end
  if BossEntity:IsDead() or BossEntity:GetAttr("Hp") <= 0 then
    DebugPrint("lgc@ AsyncCombat OnBossDeadFromServer local already dead", "CurBossEid", self.CurBossEid)
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
  DebugPrint("lgc@ AsyncCombat BattleOnDead", "CurBossEid", self.CurBossEid, "KillerEid", self:GetMainControlPlayerEid())
  Battle(self):BattleOnDead(self.CurBossEid, self:GetMainControlPlayerEid(), 0, EDeathReason.AsyncCombatServer)
end

function M:OnRoomPass()
  self.GameMode:TriggerDungeonWin()
  DebugPrint("lgc@ AsyncCombat OnRoomPass", "CurBossEid", self.CurBossEid, "BossCurStep", self.BossCurStep)
  self:StopBossDamageTracking(false)
end

function M:OnRoomClose()
  self.GameMode:TriggerDungeonFailed()
  DebugPrint("lgc@ AsyncCombat OnRoomClose", "CurBossEid", self.CurBossEid, "BossCurStep", self.BossCurStep)
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
