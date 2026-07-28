local GameModeGuildBossGame = DungeonClass.Class()
GameModeGuildBossGame.__Component__ = {}

function GameModeGuildBossGame:BeginPlay()
  self.TriggerBoxFired = {}
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  local GuildBossComponent = GameMode and GameMode.GetDungeonComponent and GameMode:GetDungeonComponent()
  local CurrentBossUnitId = GuildBossComponent and GuildBossComponent.BossId or 0
  local BossCreatorId = GuildBossComponent and GuildBossComponent.BossCreatorID or 0
  if not CurrentBossUnitId or 0 == CurrentBossUnitId then
    local PreInit = GameMode and GameMode.PreInitInfo and GameMode.PreInitInfo.GuildBoss
    CurrentBossUnitId = PreInit and PreInit.BossId or 0
  end
  if not BossCreatorId or 0 == BossCreatorId then
    local BossData = DataMgr.GuildBossInfo[CurrentBossUnitId]
    BossCreatorId = BossData and BossData.BossCreatorID or 0
  end
  if not BossCreatorId or 0 == BossCreatorId then
    DebugPrint("BP_GuildBossComponent_C BossCreatorId is nil", "BossId", CurrentBossUnitId)
    return
  end
  self:NotifyServerDungeonEvent("ActiveStaticCreator", {BossCreatorId})
end

function GameModeGuildBossGame:OnTriggerAOIBase(TriggerEventId, TriggerBase, EMActorEid, TriggerType)
  print("GameModeGuildBossGame:OnTriggerAOIBase", TriggerEventId, EMActorEid, TriggerType)
  if "BeginOverlap" ~= TriggerType then
    return
  end
  if self.TriggerBoxFired[TriggerEventId] then
    return
  end
  self.TriggerBoxFired[TriggerEventId] = true
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not GameMode or not GameMode.OnTriggerAOIBase then
    print("GameModeGuildBossGame:OnTriggerAOIBase GameMode 或蓝图事件 EventGameMode 不存在", GameMode)
    return
  end
  GameMode:OnTriggerAOIBase(TriggerEventId)
  self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnCreateGuildBoss")
  self:NotifyGameModeDungeonEvent("DungeonComponentFun", "OnStartCountDown")
end

DungeonClass.AssembleComponents(GameModeGuildBossGame)
return GameModeGuildBossGame
