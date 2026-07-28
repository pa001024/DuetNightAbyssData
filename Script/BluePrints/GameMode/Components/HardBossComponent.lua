require("UnLua")
require("Const")
local HardBossComponent = {}

function HardBossComponent:InitHardBoss(BossBattleId, DifficultyId)
  local BossInfo = DataMgr.HardBossMain[BossBattleId]
  if nil == BossInfo then
    DebugPrint("梦魇残声BossId以及难度Id填写错误")
    return
  end
  self.LevelGameMode.BossBattleInfo = {}
  self.LevelGameMode.EMGameState.HardBossInfo = {}
  local DifficultyLevel = DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
  if nil == DifficultyLevel then
    DebugPrint("梦魇残声DifficultyLevel填写错误")
    return
  end
  for Index, StaticCreatorId in pairs(BossInfo.MonsterStaticId or {}) do
    local BossStaticCreator = self.LevelGameMode.EMGameState.StaticCreatorMap:Find(StaticCreatorId)
    if BossStaticCreator and BossInfo.MonsterId and BossInfo.MonsterId[Index] then
      BossStaticCreator.UnitType = "Monster"
      BossStaticCreator.UnitId = BossInfo.MonsterId[Index]
      BossStaticCreator.Level = DifficultyLevel - self.LevelGameMode:GetGameModeLevel()
    else
      DebugPrint("梦魇残声静态点配置错误，静态点id", StaticCreatorId)
    end
  end
  self.LevelGameMode.EMGameState.HardBossInfo.BossBattleId = BossBattleId
  self.LevelGameMode.EMGameState.HardBossInfo.DifficultyId = DifficultyId
  self.LevelGameMode.BossBattleInfo.BossStaticCreatorId = BossInfo.MonsterStaticId
  self.LevelGameMode.BossBattleInfo.AirWallStaticId = BossInfo.AirWallStaticId
  self.LevelGameMode.BossBattleInfo.GameModePath = BossInfo.GameModePath
  self.LevelGameMode.BossBattleInfo.StorylinePath = BossInfo.StorylinePath
  self.LevelGameMode.BossBattleInfo.MonsterId = BossInfo.MonsterId
  self.LevelGameMode.BossBattleInfo.CustomBossStaticCreatorId = BossInfo.CustomMonsterStaticId or {}
  self.LevelGameMode.BossBattleInfo.CustomMonsterId = BossInfo.CustomMonsterId or {}
  self.LevelGameMode.BossBattleInfo.DifficultyLevel = DifficultyLevel
  self.LevelGameMode.BossBattleInfo.HardBossBTRunning = false
  GWorld.StoryMgr:Clear()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:StopAllClientQuestChainStoryline()
  end
  self.LevelGameMode:DestroyAllMonsterSpawn()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
  Player:ChangeRole(nil, AvatarInfo)
  local PlayerPoint = self.LevelGameMode.EMGameState:GetTargetPoint(BossInfo.PosDisplayName)
  if BossInfo.PosDisplayName and PlayerPoint then
    Player:K2_SetActorLocation(PlayerPoint:k2_GetActorLocation(), false, nil, false)
    Player:K2_SetActorRotation(PlayerPoint:K2_GetActorRotation(), false)
    Controller:SetControlRotation(FRotator(0, PlayerPoint:K2_GetActorRotation().Yaw, 0))
  end
  self:HardBossClearBattleEntities(true)
  self:HardBossSetPhantomBTEnable(false)
  EventManager:FireEvent(EventID.OnSwitchWeapon)
  local UIManager = UIManager(self)
  local HomeBaseMain = UIManager:GetUI("HomeBaseMain") or UIManager:GetUI("BattleMain")
  HomeBaseMain.ListView:SetVisibility(UE4.ESlateVisibility.Collapsed)
  if HomeBaseMain.Battle_Map then
    HomeBaseMain.Battle_Map:ShowHardBoss(false)
  end
  local BattleMainUI = UIManager:GetUIObj("BattleMain")
  if BattleMainUI then
    local TaskBarWidget = BattleMainUI.Pos_TaskBar:GetChildAt(0)
    if TaskBarWidget then
      TaskBarWidget:StopAllAnimations()
      TaskBarWidget:PlayAnimation(TaskBarWidget.Out)
    end
    if BattleMainUI.Btn_Task then
      BattleMainUI.Btn_Task:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  self.LevelGameMode.IsInHardBossSettlement = false
  MissionIndicatorManager:TriggerAllIndicatorVisible(false)
  self.EMGameState.IsInSettlementScene = nil
  self:SpawnHardBossInfo()
  if self.LevelGameMode.BossBattleInfo.StorylinePath then
    local function STLCallback()
      self:InitBossBattleInfoCallBack()
    end
    
    GWorld.StoryMgr:RunStory(BossInfo.StorylinePath, nil, nil, STLCallback, STLCallback)
    return
  else
    self:InitBossBattleInfoCallBack()
  end
end

function HardBossComponent:SpawnHardBossInfo()
  local BossStaticInfo = TArray(0)
  BossStaticInfo:Add(self.LevelGameMode.BossBattleInfo.AirWallStaticId)
  for _, CreatorId in pairs(self.LevelGameMode.BossBattleInfo.BossStaticCreatorId or {}) do
    BossStaticInfo:Add(CreatorId)
  end
  self.LevelGameMode:TriggerActiveStaticCreator(BossStaticInfo)
  self.LevelGameMode:InitBossBattleSubGameMode(self.LevelGameMode.BossBattleInfo.GameModePath)
end

function HardBossComponent:InitBossBattleInfoCallBack()
  self.LevelGameMode.BossBattleInfo.HardBossBTRunning = true
  for i, Boss in pairs(self.EMGameState.BossMap) do
    if IsValid(Boss) and Boss:IsRealMonster() then
      Boss:SetActorHideTag("HardBoss", false)
      Boss:StartBT()
    end
  end
  self:HardBossSetPhantomBTEnable(true)
  self:SetHardBossStartTime()
  local MonsterId = TArray(0)
  local AirWallCreatorIds = TArray(0)
  for _, Id in pairs(self.LevelGameMode.BossBattleInfo.MonsterId or {}) do
    MonsterId:Add(Id)
  end
  AirWallCreatorIds:Add(self.LevelGameMode.BossBattleInfo.AirWallStaticId)
  self:TriggerActiveBossBattle(MonsterId, AirWallCreatorIds)
end

function HardBossComponent:EndHardBoss(IsWin)
  self:TriggerExitDungeon(IsWin)
end

function HardBossComponent:EndHardBossCallBack(IsWin)
  self.LevelGameMode.IsInHardBossSettlement = false
  self:PostCustomEvent("EndHardBossCallBack")
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  Battle(Player):ClearAllDanmaku()
  self.LevelGameMode.BossBattleInfo.HardBossBTRunning = true
  self:HardBossClearBattleEntities(false)
  self:HardBossSetPhantomBTEnable(true)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
    local PlayerController = Player:GetController()
    PlayerController:SetAvatarInfo(CommonUtils.ObjId2Str(Avatar.Eid), AvatarInfo)
  end
  local Avatar = GWorld:GetAvatar()
  local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
  Player:ChangeRole(nil, AvatarInfo)
  local UIManager = UIManager(self)
  local HomeBaseMain = UIManager:GetUI("HomeBaseMain") or UIManager:GetUI("BattleMain")
  HomeBaseMain.ListView:SetVisibility(UE4.ESlateVisibility.Visible)
  if HomeBaseMain.Battle_Map then
    HomeBaseMain.Battle_Map:ShowHardBoss(true)
  end
  local BattleMainUI = UIManager:GetUIObj("BattleMain")
  if BattleMainUI then
    local TaskBarWidget = BattleMainUI.Pos_TaskBar:GetChildAt(0)
    if TaskBarWidget then
      TaskBarWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    if BattleMainUI.Btn_Task then
      BattleMainUI.Btn_Task:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  end
  self.LevelGameMode:RecoverBossBattleSubGameMode()
  self.LevelGameMode:AllowAllFutureCreate()
  local Avatar = GWorld:GetAvatar()
  Avatar:TriggerQuestChain()
  MissionIndicatorManager:TriggerAllIndicatorVisible(true)
  self.EMGameState.IsInSettlementScene = nil
end

function HardBossComponent:QuitHardBoss()
  self.LevelGameMode.BossBattleInfo.HardBossBTRunning = false
  self:HardBossClearBattleEntities(false)
  self:HardBossSetPhantomBTEnable(false)
  self:PostCustomEvent("OnHardBossEnd")
end

function HardBossComponent:HardBossClearBattleEntities(IsBegin)
  DebugPrint("GameMode_HardBossComponent: HardBossClearBattleEntities", IsBegin)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local ForwardLocationComponent = Player:GetForwardLocationComponent()
  local Length = 0
  local AllLocations
  if ForwardLocationComponent then
    AllLocations = ForwardLocationComponent:GetAllLocations(true)
    Length = AllLocations:Length()
  end
  if not IsBegin then
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance then
      local Avatar = GWorld:GetAvatar()
      if Avatar:IsInHardBoss() then
        GameInstance:CalculatePhantom()
        GameInstance:AddOnPhantomInitReadyEvent()
      end
    end
  end
  if not IsValid(self.EMGameState.Battle) then
    ScreenPrint("************* GameMode_HardBossComponent:HardBossClearBattleEntities Battle不存在!!!!!! *************")
    Battle(self):ShowBattleError("梦魇残声清除Actor时, Battle不存在！")
    return
  end
  local Index = 0
  local Counter = 0
  local EidKeys = Battle(self):GetAllEntities():Keys()
  for _, Eid in pairs(EidKeys) do
    local Ent = Battle(self):GetEntity(Eid)
    if Ent and not Ent.BpBorn and Ent.EMActorDestroy and (not Ent.IsPlayer or not Ent:IsPlayer()) then
      if Ent.IsPhantom and Ent:IsPhantom() and not Ent:IsDead() then
        local ContextCopy = Ent.CreateUnitContextCopy
        ContextCopy.BoolParams:Add("SkipInitWaitCheck", true)
        self.EMGameState.EventMgr:RegisterCreateData(Ent.Eid, ContextCopy)
        Ent.ReInitSkipLevelEnter = true
        Ent:TryInitCharacterInfo("InitInfo")
        Index = Index + 1
        if Length >= Index then
          local Location = AllLocations:GetRef(Index)
          local HalfHeight = Ent.CapsuleComponent:GetScaledCapsuleHalfHeight()
          Location.Z = Location.Z + HalfHeight
          Ent:K2_SetActorLocation(Location, false, nil, false)
        end
      else
        Ent:EMActorDestroy(EDestroyReason.HardBossClear)
        Counter = Counter + 1
      end
    end
  end
  DebugPrint("GameMode_HardBossComponent: 是否进入:", IsBegin, "删除总数:", Counter)
end

function HardBossComponent:HardBossSetPhantomBTEnable(RunEnable)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  for _, Phantom in pairs(Player:GetPhantomTeammates()) do
    if Phantom ~= Player then
      if RunEnable then
        Phantom:StartBT()
      else
        Phantom:StopBT("HardBoss")
      end
    end
  end
end

function HardBossComponent:ActiveCustomBossCreator(Index)
  if self:IsInDungeon() then
    self.LevelGameMode:TriggerDungeonComponentFun("ActiveCustomBossCreator", Index)
    return
  end
  local CreatorId = self.LevelGameMode.BossBattleInfo.CustomBossStaticCreatorId[Index]
  local UnitId = self.LevelGameMode.BossBattleInfo.CustomMonsterId[Index]
  if not CreatorId or not UnitId then
    return
  end
  local DifficultyLevel = self.LevelGameMode.BossBattleInfo.DifficultyLevel
  local BossCreator = self.LevelGameMode.EMGameState.StaticCreatorMap:Find(CreatorId)
  if not IsValid(BossCreator) then
    return
  end
  local CreatorIds = TArray(0)
  CreatorIds:Add(CreatorId)
  BossCreator.UnitId = UnitId
  BossCreator.Level = DifficultyLevel - self.LevelGameMode:GetGameModeLevel()
  self.LevelGameMode:TriggerActiveStaticCreator(CreatorIds, "HardBossCustomBoss")
end

return HardBossComponent
