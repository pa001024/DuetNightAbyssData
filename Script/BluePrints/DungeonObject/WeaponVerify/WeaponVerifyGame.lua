local WeaponVerifyGame = DungeonClass.Class()

function WeaponVerifyGame:BeginPlay()
  self:Log("WeaponVerifyGame BeginPlay", self.DungeonId)
  local WeaponVerifyInfo = DataMgr.WeaponVerify[self.DungeonId]
  if not WeaponVerifyInfo then
    self:ShowDungeonObjError("WeaponVerify 读表失败, DungeonId: " .. tostring(self.DungeonId))
    return
  end
  self.WinMode = WeaponVerifyInfo.WinMode
  self.WinTarget = WeaponVerifyInfo.WinTarget
  self.TotalTime = WeaponVerifyInfo.TotalTime
  self.BeginDelay = WeaponVerifyInfo.BeginDelay or 0
  self.WinDelay = WeaponVerifyInfo.WinDelay or 0
  self.BossCreatorIds = WeaponVerifyInfo.BossCreatorId or {}
  self.AirWallCreatorIds = WeaponVerifyInfo.AirWallCreatorId or {}
  self.MonsterSpawnIds = WeaponVerifyInfo.MonsterSpawnId or {}
  self.MonTagCountRule = WeaponVerifyInfo.MonTagCountRule or {}
  self.KillCountActive = WeaponVerifyInfo.KillCountActive or {}
  self.CurKillCount = 0
  self.IsGameEnd = false
end

function WeaponVerifyGame:OnNotifyServerDungeonEvent_OnInit()
  self:Log("WeaponVerifyGame OnInit", self.DungeonId)
  self:ActiveStaticCreator(self.AirWallCreatorIds)
  if self.BeginDelay > 0 then
    self:AddTimer(self.BeginDelay, function()
      self:RealGameStart()
    end)
  else
    self:RealGameStart()
  end
end

function WeaponVerifyGame:RealGameStart()
  print("WeaponVerifyGame RealGameStart")
  self:ActiveStaticCreator(self.BossCreatorIds)
  self:ServerTriggerCreateMonsterSpawn(self.MonsterSpawnIds, false)
  self:StartMainTimer()
end

function WeaponVerifyGame:StartMainTimer()
  local function DeleteCb()
    self:OnMainTimerDelete()
  end
  
  local function EndCb()
    self:OnMainTimerEnd()
  end
  
  self:AddSyncTimer("WeaponVerifyMain", self.TotalTime, DeleteCb, EndCb)
end

function WeaponVerifyGame:StopMainTimer()
  self:RemoveSyncTimer("WeaponVerifyMain", true, false)
end

function WeaponVerifyGame:OnMainTimerDelete()
  local ElapsedTime = self:GetTimeElapsed("WeaponVerifyMain")
  print("WeaponVerifyGame MainTimer Delete, ElapsedTime", ElapsedTime)
  local GameEndReason = 1 == self.WinMode and "KillBoss" or "KillCount"
  self:TriggerGameEnd(true, ElapsedTime, GameEndReason)
end

function WeaponVerifyGame:OnMainTimerEnd()
  print("WeaponVerifyGame MainTimer End")
  self:TriggerGameEnd(false, self.TotalTime, "TimeUp")
end

function WeaponVerifyGame:DungeonMonsterDead(MonsterInfo)
  print("WeaponVerifyGame DungeonMonsterDead UnitId", MonsterInfo.UnitId, "UniqueId", MonsterInfo.UniqueId, "CreatorId", MonsterInfo.CreatorId, "IsGameEnd", self.IsGameEnd)
  if self.IsGameEnd then
    return
  end
  if 1 == self.WinMode then
    self:DungeonMonsterDead_Boss(MonsterInfo)
  else
    self:DungeonMonsterDead_KillCount(MonsterInfo)
  end
end

function WeaponVerifyGame:DungeonMonsterDead_Boss(MonsterInfo)
  local DeadCreatorId = MonsterInfo.CreatorId
  if DeadCreatorId == self.WinTarget then
    self:StopMainTimer()
  end
end

function WeaponVerifyGame:DungeonMonsterDead_KillCount(MonsterInfo)
  local AddCount = self:CalAddCount(MonsterInfo)
  self.CurKillCount = self.CurKillCount + AddCount
  print("WeaponVerifyGame CurKillCount", self.CurKillCount, "WinTarget", self.WinTarget)
  self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnRep_KillCount", self.CurKillCount)
  local CreatorId = self.KillCountActive[self.CurKillCount]
  if CreatorId then
    self:ActiveStaticCreator({CreatorId})
  end
  if self.CurKillCount >= self.WinTarget then
    self:StopMainTimer()
  end
end

function WeaponVerifyGame:CalAddCount(MonsterInfo)
  local AddCount = 1
  local UnitId = MonsterInfo.UnitId
  local MonsterInfo = DataMgr.Monster[UnitId]
  if not MonsterInfo then
    return AddCount
  end
  local MonsterTag = MonsterInfo.GamePlayTags
  for Tag, Count in pairs(self.MonTagCountRule) do
    if CommonUtils.HasGamePlayTag(MonsterTag, Tag) then
      AddCount = Count
      break
    end
  end
  return AddCount
end

function WeaponVerifyGame:TriggerGameEnd(IsWin, ElapsedTime, GameEndReason)
  if self.IsGameEnd then
    return
  end
  self.IsGameEnd = true
  print("WeaponVerifyGame TriggerGameEnd IsWin", IsWin, "ElapsedTime", ElapsedTime)
  if IsWin then
    self:ServerTriggerDestroyAll(self.MonsterSpawnIds, false)
    self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnTriggerWinTarget", ElapsedTime)
  end
  self.GameElapsedTime = ElapsedTime or self.TotalTime
  if self.WinDelay > 0 then
    self:AddTimer(self.WinDelay, function()
      self:TryDungeonFinish(IsWin, GameEndReason)
    end)
  else
    self:TryDungeonFinish(IsWin, GameEndReason)
  end
end

function WeaponVerifyGame:CustomFinishInfo(Eid, IsWin)
  local Res = {}
  if self.IsGameEnd then
    Res.TimeElapsed = self.GameElapsedTime
  else
    Res.TimeElapsed = self:GetTimeElapsed("WeaponVerifyMain")
  end
  if Res.TimeElapsed then
    Res.TimeRemain = math.max(self.TotalTime - Res.TimeElapsed, 0)
  end
  return Res
end

function WeaponVerifyGame:CheckPlayerAllowedFinish(IsWin, AvatarEid, GameEndReason)
  if IsWin then
    return self.IsGameEnd
  else
    return true
  end
end

function WeaponVerifyGame:FillCustomGameInfo(tbl)
  table.insert(tbl, "WeaponVerify\n")
end

DungeonClass.AssembleComponents(WeaponVerifyGame)
return WeaponVerifyGame
