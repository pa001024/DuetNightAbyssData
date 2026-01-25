local Component = {}

function Component:OpeningSequence_Lua()
  EventManager:AddEvent(EventID.OnHardBossOpeningSequencePause, self, self.OnHardBossOpeningSequencePauseCallback)
  self.IsSelfReady = false
  self.IsOtherPlayerReady = false
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
    
    self:ClientSafeRunStory(StorylinePath, 10100, STLCallback)
    return
  else
    self:OnHardBossOpeningSequencePauseCallback()
  end
end

function Component:RemoveOpeningSequence_Lua()
  self.IsOtherPlayerReady = true
  self:CheckCanPlay()
end

function Component:OnHardBossOpeningSequencePauseCallback()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  Player.RPCComponent:NotifyServerPlaySequenceFinish(Player.Eid)
  self.IsSelfReady = true
  self:CheckCanPlay()
end

function Component:CheckCanPlay()
  if self.IsSelfReady and self.IsOtherPlayerReady then
    EventManager:FireEvent(EventID.OnHardBossOpeningAllPlayerReady)
  end
end

function Component:ClientHideHardBossDgBossActor(IsHide)
  if IsHide then
    local HideSucc = self:TryHideBoss()
    if not HideSucc then
      self:AddTimer(0.1, function()
        local IsHideSucc = self:TryHideBoss()
        if IsHideSucc then
          self:RemoveTimer("HideHardBossDgBoss")
        end
      end, true, 0, "HideHardBossDgBoss", true)
    end
  else
    self:RemoveTimer("HideHardBossDgBoss")
    self:RemoveTimer("EnsureClientOpening")
    local Boss = self:GetBossMonsterByType()
    Boss:SetActorHideTag("HardBossDg", false, false, true)
  end
end

function Component:TryHideBoss()
  local Boss = self:GetBossMonsterByType()
  if not Boss then
    return false
  end
  Boss:SetActorHideTag("HardBossDg", true, false, true)
  self:AddTimer(Const.BossOpeningEnsureTime, function()
    self:ShowDungeonError("HardBossDgComponent: Client 开场动画超时触发保底！", Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Process)
    self:ClientHideHardBossDgBossActor(false)
  end, false, 0, "EnsureClientOpening", true)
  return true
end

function Component:ClientHardBossOpeningCallback()
end

function Component:GetBossMonsterByType()
  for _, Monster in pairs(self.MonsterMap) do
    if IsValid(Monster) and Monster.IsBossMonster and Monster:IsBossMonster() then
      return Monster
    end
  end
  return nil
end

return Component
