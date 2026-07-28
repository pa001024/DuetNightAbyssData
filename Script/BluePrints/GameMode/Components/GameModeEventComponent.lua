require("UnLua")
local EStorylineActorEventType = require("StoryCreator.StoryLogic.StorylineUtils").EActorEventType
local GameModeEventComponent = {}

function GameModeEventComponent:GetDungeonAchieveComponent()
  if self.DungeonAchieveComponent ~= nil then
    return self.DungeonAchieveComponent
  end
  if not self:IsInDungeon() then
    return nil
  end
  local GameState = self.EMGameState or UE4.UGameplayStatics.GetGameState(self)
  self.DungeonAchieveComponent = self["BP_" .. GameState.GameModeType .. "AchieveComponent"]
  if not self.DungeonAchieveComponent then
    self.DungeonAchieveComponent = self.BP_DungeonAchieveComponent
  end
  return self.DungeonAchieveComponent
end

function GameModeEventComponent:GetSubDungeonComponent()
  local GameState = self.EMGameState or UE4.UGameplayStatics.GetGameState(self)
  local GameModeComponentName = "BP_" .. GameState.GameModeType .. "Component"
  for LevelName, SubGameMode in pairs(self.SubGameModeInfo) do
    local SubDungeonComponent = SubGameMode[GameModeComponentName]
    if nil == SubDungeonComponent then
      DebugPrint("GameModeEventComponent Error! 神庙/派对玩法子关卡缺少神庙/派对组件，请策划检查相关配置")
    end
    return SubDungeonComponent
  end
end

function GameModeEventComponent:GetGameModeEventComponent()
  if self.GameModeEventComponent ~= nil then
    return self.GameModeEventComponent
  end
  if self:IsInDungeon() then
    self.GameModeEventComponent = self.GameModeEvent
  elseif self:IsInRegion() and self.LevelGameMode.RegionId then
    local RegionComponentName = "GameModeEvent_" .. self.LevelGameMode.RegionId
    self.GameModeEventComponent = self[RegionComponentName]
  end
  return self.GameModeEventComponent
end

function GameModeEventComponent:TriggerUploadDungeonAchievement(PlayerEids)
  local DungeonAchieveComponentTmp = self:GetDungeonAchieveComponent()
  if DungeonAchieveComponentTmp then
    local ResPlayerEids = PlayerEids or {}
    if nil == PlayerEids then
      for _, PlayerCharacter in pairs(self:GetAllPlayer()) do
        table.insert(ResPlayerEids, PlayerCharacter.Eid)
      end
    end
    DungeonAchieveComponentTmp:UploadDungeonAchievement(ResPlayerEids)
  end
end

function GameModeEventComponent:TriggerGameModeEvent(EventName, ...)
  local DungeonComponentTmp = self:GetDungeonComponent()
  if not DungeonComponentTmp then
    return
  end
  if DungeonComponentTmp[EventName] and DungeonComponentTmp[EventName]:IsBound() then
    DungeonComponentTmp[EventName]:Broadcast(...)
  end
end

function GameModeEventComponent:TriggerDungeonComponentFun(FunName, ...)
  local DungeonComponentTmp = self:GetDungeonComponent()
  if DungeonComponentTmp and DungeonComponentTmp[FunName] then
    return DungeonComponentTmp[FunName](DungeonComponentTmp, ...)
  end
  return nil
end

function GameModeEventComponent:TriggerBPGameModeEvent(Name, ...)
  if not self:GetGameModeEventComponent() then
    return
  end
  local FunName = "TriggerBPGameModeEvent_" .. Name
  if self[FunName] then
    self[FunName](self, ...)
  end
end

function GameModeEventComponent:TriggerSTLEvent(Name, ...)
  if self:IsInDungeon() then
    return
  end
  if not GWorld.StoryMgr then
    return
  end
  local FunName = "TriggerSTLEvent_" .. Name
  if self[FunName] then
    self[FunName](self, ...)
  end
end

function GameModeEventComponent:TriggerDungeonAchieve(EventName, PlayerEid, ...)
  DebugPrint("GameModeAchieve: EventName:", EventName)
  local DungeonAchieveComponentTmp = self:GetDungeonAchieveComponent()
  if not DungeonAchieveComponentTmp then
    return
  end
  if not DungeonAchieveComponentTmp[EventName] then
    return
  end
  DungeonAchieveComponentTmp[EventName](DungeonAchieveComponentTmp, PlayerEid, ...)
end

function GameModeEventComponent:TriggerDungeonAchieve_Bp(EventName, PlayerEid)
  self:TriggerDungeonAchieve(EventName, PlayerEid)
end

function GameModeEventComponent:TriggerBPGameModeEvent_OnCustomEvent(ParaName)
  local EventName = "OnCustomEvent_" .. ParaName
  local GameModeEventCompTmp = self:GetGameModeEventComponent()
  if GameModeEventCompTmp and GameModeEventCompTmp[EventName] and GameModeEventCompTmp[EventName]:IsBound() then
    GameModeEventCompTmp[EventName]:Broadcast()
  end
end

function GameModeEventComponent:TriggerBPGameModeEvent_OnTriggerAOIBase(...)
  local TriggerEventId, TriggerBase, ActorEid, TriggerType = ...
  local EventName = "OnTriggerAOIBase_" .. TriggerEventId
  local GameModeEventCompTmp = self:GetGameModeEventComponent()
  if GameModeEventCompTmp and GameModeEventCompTmp[EventName] and GameModeEventCompTmp[EventName]:IsBound() then
    GameModeEventCompTmp[EventName]:Broadcast(TriggerBase)
  end
end

function GameModeEventComponent:TriggerBPGameModeEvent_BpOnTimerEnd(ParaName)
  local EventName = "BpOnTimerEnd_" .. ParaName
  local GameModeEventCompTmp = self:GetGameModeEventComponent()
  if GameModeEventCompTmp and GameModeEventCompTmp[EventName] and GameModeEventCompTmp[EventName]:IsBound() then
    GameModeEventCompTmp[EventName]:Broadcast()
  end
end

function GameModeEventComponent:TriggerBPGameModeEvent_OnBossDead(ParaName)
  local EventName = "OnBossDead_" .. ParaName.UnitId
  local GameModeEventCompTmp = self:GetGameModeEventComponent()
  if GameModeEventCompTmp and GameModeEventCompTmp[EventName] and GameModeEventCompTmp[EventName]:IsBound() then
    GameModeEventCompTmp[EventName]:Broadcast()
  end
end

function GameModeEventComponent:TriggerSTLEvent_OnTriggerAOIBase(...)
  local TriggerEventId, TriggerBase, ActorEid, TriggerType = ...
  GWorld.StoryMgr:TryExecStorylineActorEvent(TriggerEventId, EStorylineActorEventType.OnTriggerAOIBase, {
    TriggerBase = TriggerBase,
    ActorEid = ActorEid,
    TriggerType = TriggerType
  })
end

function GameModeEventComponent:TriggerSTLEvent_STLPostStaticCreatorEvent(...)
  local Actor = (...)
  DebugPrint("STL Node TriggerSTLEvent_STLPostStaticCreatorEvent CreatorId:", Actor.CreatorId)
  GWorld.StoryMgr:TryExecStorylineActorEvent(Actor.CreatorId, EStorylineActorEventType.OnCreated, {Actor = Actor})
end

function GameModeEventComponent:TriggerSTLEvent_OnSTLActorDestroyed(...)
  local Actor, DestroyReason = ...
  GWorld.StoryMgr:TryExecStorylineActorEvent(Actor.CreatorId, EStorylineActorEventType.OnActorDestroyed, {Actor = Actor, DestroyReason = DestroyReason})
end

function GameModeEventComponent:TriggerSTLEvent_OnSTLMonsterdDeath(...)
  local MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason = ...
  GWorld.StoryMgr:TryExecStorylineActorEvent(MonsterC.CreatorId, EStorylineActorEventType.OnMonsterDeath, {
    MonsterC = MonsterC,
    KillMineRoleEid = KillMineRoleEid,
    KillMineSkillId = KillMineSkillId,
    DeathReason = DeathReason
  })
end

return GameModeEventComponent
