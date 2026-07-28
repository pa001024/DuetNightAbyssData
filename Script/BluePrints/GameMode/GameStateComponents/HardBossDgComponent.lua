local Component = {}

function Component:OpeningSequence_Lua()
  self:ClientHideHardBossDgActor(true, "AirWall")
  local HardBossInfo = DataMgr.HardBossDg[self.DungeonId]
  local HardBossMainInfo = DataMgr.HardBossMain[HardBossInfo.HardBossId]
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  GameState.HardBossInfo = {}
  GameState.HardBossInfo.BossBattleId = HardBossInfo.HardBossId
  GameState.HardBossInfo.DifficultyId = HardBossInfo.DifficultyId
  local StorylinePath = HardBossMainInfo.StorylinePath
  if StorylinePath then
    local function STLCallback()
      self:ClientHardBossOpeningCallback()
    end
    
    self:ClientSafeRunStory(StorylinePath, STLCallback)
    return
  else
    self:ClientHardBossOpeningCallback()
  end
end

function Component:RemoveOpeningSequence_Lua()
end

function Component:ClientHardBossOpeningCallback()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  Player.RPCComponent:NotifyServerPlaySequenceFinish(Player.Eid)
  self:ClientHideHardBossDgActor(false, "AirWall")
end

function Component:ClientHideHardBossDgActor(IsHide, ActorType)
  local TimerHandle = "HideHardBossDgBoss_" .. ActorType
  if IsHide then
    local HideSucc = self:TryHideActor(true, ActorType)
    if not HideSucc then
      self:AddTimer(0.1, function()
        local IsHideSucc = self:TryHideActor(true, ActorType)
        if IsHideSucc then
          self:RemoveTimer(TimerHandle)
        end
      end, true, 0, TimerHandle, true)
    end
  else
    self:RemoveTimer(TimerHandle)
    self:TryHideActor(false, ActorType)
  end
end

function Component:TryHideActor(IsHide, ActorType)
  if "Boss" == ActorType then
    local Boss = self:GetBossMonsterByType()
    if not Boss then
      return false
    end
    Boss:SetActorHideTag("HardBossDg", IsHide, false, true)
  elseif "AirWall" == ActorType then
    local AirWall = self:GetAirWallByUnitId()
    if not AirWall then
      return false
    end
    AirWall:SetActorHideTag("HardBossDg", IsHide)
  end
  return true
end

function Component:GetBossMonsterByType()
  for _, Monster in pairs(self.MonsterMap) do
    if IsValid(Monster) and Monster.IsBossMonster and Monster:IsBossMonster() then
      return Monster
    end
  end
  return nil
end

function Component:GetAirWallByUnitId()
  for _, CombatItem in pairs(self.CombatItemMap) do
    if IsValid(CombatItem) and CombatItem.UnitId == Const.HardBossDgPrepareAirwallId then
      return CombatItem
    end
  end
  return nil
end

return Component
