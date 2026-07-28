local GuildBossGame = DungeonClass.Class()

local function normalize_int(Value, Default)
  Value = tonumber(Value)
  if not Value then
    return Default or 0
  end
  return math.floor(Value)
end

local function normalize_number(Value, Default)
  Value = tonumber(Value)
  if not Value then
    return Default or 0
  end
  return Value
end

local function copy_list(Source)
  local Result = {}
  for _, Value in ipairs(Source or {}) do
    table.insert(Result, Value)
  end
  return Result
end

local function copy_trial_contribution(Source, FinishedTrials)
  local Result = {}
  if type(Source) == "table" then
    for TrialId, Value in pairs(Source) do
      TrialId = normalize_int(TrialId, 0)
      Value = normalize_number(Value, 0)
      if TrialId > 0 and Value > 0 then
        Result[TrialId] = (Result[TrialId] or 0) + Value
      end
    end
    return Result
  end
  local Value = normalize_number(Source, 0)
  if Value <= 0 then
    return Result
  end
  for _, TrialId in ipairs(FinishedTrials or {}) do
    TrialId = normalize_int(TrialId, 0)
    if TrialId > 0 then
      Result[TrialId] = (Result[TrialId] or 0) + Value
    end
  end
  return Result
end

local function merge_trial_contribution(OldInfo, NewInfo)
  local Result = copy_trial_contribution(NewInfo.TrialContribution, NewInfo.FinishedTrials)
  local OldContribution = copy_trial_contribution(OldInfo.TrialContribution, OldInfo.FinishedTrials)
  for TrialId, Value in pairs(OldContribution) do
    if Value > normalize_number(Result[TrialId], 0) then
      Result[TrialId] = Value
    end
  end
  return Result
end

local function resolve_guild_boss_id(self)
  local BossId = normalize_int(self.BossId, 0)
  if BossId > 0 then
    return BossId
  end
  local CustomParams = self.CustomDungeonParams
  if type(CustomParams) == "table" then
    BossId = normalize_int(CustomParams.BossId, 0)
    if BossId > 0 then
      return BossId
    end
  end
  return 0
end

local function resolve_guild_boss_time_limit(self)
  local BossId = resolve_guild_boss_id(self)
  local BossInfo = BossId > 0 and DataMgr.GuildBossInfo and DataMgr.GuildBossInfo[BossId] or nil
  return normalize_int(BossInfo and BossInfo.TimeLimit, 90)
end

local function try_cache_guild_boss_id(self, StaticCreatorIds)
  if normalize_int(self.BossId, 0) > 0 then
    return
  end
  for _, CreatorId in ipairs(StaticCreatorIds or {}) do
    CreatorId = normalize_int(CreatorId, 0)
    if CreatorId <= 0 then
    else
      for BossId, BossInfo in pairs(DataMgr.GuildBossInfo or {}) do
        if type(BossInfo) == "table" and normalize_int(BossInfo.BossCreatorID, 0) == CreatorId then
          self.BossId = normalize_int(BossInfo.ID or BossId, 0)
          return
        end
      end
    end
  end
end

function GuildBossGame:BeginPlay()
  self.GuildBossSettleInfo = {
    Damage = 0,
    TrialContribution = {}
  }
end

function GuildBossGame:EndPlay()
  self:RemoveSyncTimer("GuildBossGameTimer")
end

function GuildBossGame:BuildGuildBossSettleInfo(Info)
  Info = type(Info) == "table" and Info or {}
  local Damage = math.max(0, normalize_int(Info.Damage or Info.TotalDamage or Info.GuildBossDamage, 0))
  local FinishedTrials = copy_list(Info.FinishedTrials or Info.Trials)
  local Result = {
    GuildBossServerVerified = true,
    Damage = Damage,
    TrialContribution = copy_trial_contribution(Info.TrialContribution, FinishedTrials)
  }
  if #FinishedTrials > 0 then
    Result.FinishedTrials = FinishedTrials
  end
  return Result
end

function GuildBossGame:OnNotifyServerDungeonEvent_OnInit()
end

function GuildBossGame:OnNotifyServerDungeonEvent_ActiveStaticCreator(StaticCreatorIds)
  print("GuildBossGame:OnNotifyServerDungeonEvent_ActiveStaticCreator StaticCreatorId =", StaticCreatorIds)
  try_cache_guild_boss_id(self, StaticCreatorIds)
  self:ActiveStaticCreator(StaticCreatorIds)
end

function GuildBossGame:OnNotifyServerDungeonEvent_OnStartCountDown()
  local TimeLimit = resolve_guild_boss_time_limit(self)
  print("GuildBossGame:OnNotifyServerDungeonEvent_OnStartCountDown", TimeLimit)
  self:AddSyncTimer("GuildBossGameTimer", TimeLimit, nil, function()
    self:RemoveSyncTimer("GuildBossGameTimer")
    self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnTimeOver")
  end)
end

function GuildBossGame:OnNotifyServerDungeonEvent_GuildBossUpdateSettle(Info)
  local SettleInfo = self:BuildGuildBossSettleInfo(Info)
  local OldInfo = self.GuildBossSettleInfo or {}
  if normalize_int(OldInfo.Damage, 0) > normalize_int(SettleInfo.Damage, 0) then
    SettleInfo.Damage = normalize_int(OldInfo.Damage, 0)
  end
  if not SettleInfo.FinishedTrials and type(OldInfo.FinishedTrials) == "table" then
    SettleInfo.FinishedTrials = copy_list(OldInfo.FinishedTrials)
  end
  SettleInfo.TrialContribution = merge_trial_contribution(OldInfo, SettleInfo)
  self.GuildBossSettleInfo = SettleInfo
  return true, SettleInfo
end

function GuildBossGame:CustomFinishInfo(Eid, IsWin)
  local SettleInfo = self:BuildGuildBossSettleInfo(self.GuildBossSettleInfo)
  if true ~= IsWin then
    SettleInfo.Damage = 0
    SettleInfo.TrialContribution = {}
    SettleInfo.FinishedTrials = nil
  end
  return SettleInfo
end

DungeonClass.AssembleComponents(GuildBossGame)
return GuildBossGame
