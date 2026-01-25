require("UnLua")
local CommonConst = require("CommonConst")
local ItemUtils = require("Utils.ItemUtils")
local CommonUtils = require("Utils.CommonUtils")
local msgpack = require("msgpack_core")
local ClientEventUtils = require("BluePrints.Common.ClientEvent.ClientEventUtils")
local MiscUtils = require("Utils.MiscUtils")
local BP_EMGameMode_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.GameMode.Components.AIBattleMgr",
  "BluePrints.GameMode.Components.HardBossComponent",
  "BluePrints.GameMode.Components.AbyssComponent",
  "BluePrints.GameMode.Components.ProgressSnapShotComponent",
  "BluePrints.GameMode.Components.GameModeLogin",
  "BluePrints.GameMode.Components.RewardComponent",
  "BluePrints.GameMode.Components.GameModeEventComponent",
  "BluePrints.GameMode.Components.RougeLikeComponent",
  "BluePrints.GameMode.Components.GameModeRegionMgr",
  "BluePrints.GameMode.Components.GameModeQuestMgr",
  "BluePrints.GameMode.Components.WalnutComponent",
  "BluePrints.GameMode.Components.TicketComponent",
  "BluePrints.GameMode.Components.RewardGenComponent",
  "BluePrints.GameMode.Components.DungeonDeliveryComponent"
})
BP_EMGameMode_C._components = {}

function BP_EMGameMode_C:InitGameModeInfo(DungeonId)
  self.PreInitInfo = GWorld.GameInstance:ConsumeGameModePreInitInfo()
  self:SetGameModeBaseInfo(DungeonId)
  self.EMGameState:InitGameStateInfo()
  self.MonsterCacheNum = 10
  self.CacheAvatarToItems = {}
  self.GMMonsterBuff = {}
  self.MiniGameFailedTime = {}
  self.DropRule = {}
  self:InitFixedCreator()
  self:InitAIBattleMgr()
  self:InitRewardParams()
  self.bEnableMonsterCollisionPush = true
  self.NeedToWaitForOthers = false
  local DSEntity = GWorld:GetDSEntity()
  if DSEntity and DSEntity.bBlock then
    self:BlockEntrance()
  else
    self.bBlock = false
  end
  self.BattleAvatars = {}
end

function BP_EMGameMode_C:SetGameModeBaseInfo(DungeonId)
  local Avatar = GWorld:GetAvatar()
  if Avatar and self:IsInRegion() then
    print(_G.LogTag, "Init Region")
    self.DungeonId = -1
    self.RegionId = Avatar:GetSubRegionId2RegionId(Avatar.CurrentRegionId)
    self:UpdateRegionGameModeLevel()
    self.EMGameState:SetGameModeType("Region")
    self:UpdateQuestArtLevel()
    self.EMGameState.CurDungeonUIParamID = 0
    self:SetGameStatePetRandomDailyCount()
  elseif self:IsInDungeon() then
    print(_G.LogTag, "Init Dungeon")
    local DungeonInfo = DataMgr.Dungeon[DungeonId]
    if not DungeonInfo then
      return
    end
    self.DungeonId = DungeonId
    local Level = DungeonInfo.DungeonLevel or 1
    self.BattleProgressLevel = DungeonInfo.DungeonFixLevel or 0
    self:SetGameModeLevel(Level)
    self.CommonAlertDisable = DungeonInfo.AlertDisable or self.CommonAlertDisable
    self.EMGameState:SetGameModeType("Blank")
    if DungeonInfo.DungeonType and DungeonInfo.DungeonType ~= "" then
      self.EMGameState:SetGameModeType(DungeonInfo.DungeonType)
    end
    self:InitDungeonComponent()
    if DungeonInfo.EnableTacmap then
      self:InitTacMapManager()
    end
    self:InitGameModeTypeInfo()
    self:InitEmergencyMonster()
    self:InitBPVars(DungeonInfo)
    if not IsDedicatedServer(self) then
      self:InitDungeonRandomEvent()
    end
  else
    DebugPrint("BP_EMGameMode_C: Warning!!! DungeonId 为", DungeonId)
  end
end

function BP_EMGameMode_C:InitGameModeTypeInfo()
  if not self:CheckGameModeEnable() then
    return
  end
  if self.EMGameState.GameModeType == "Blank" then
    return
  end
  if not self:GetDungeonComponent() then
    return
  end
  local FunName = "Init" .. self.EMGameState.GameModeType .. "Component"
  if self:GetDungeonComponent() ~= nil and self:GetDungeonComponent()[FunName] ~= nil then
    self:GetDungeonComponent()[FunName](self:GetDungeonComponent())
  end
end

function BP_EMGameMode_C:InitTacMapManager()
  self.TacMapManager = nil
  if not self:GetLevelLoader() then
    return
  end
  local TacMapManagerClass = LoadClass("/Game/BluePrints/Common/Level/BP_TacmapManagerNew.BP_TacmapManagerNew_C")
  self.TacMapManager = NewObject(TacMapManagerClass, self)
  self.TacMapManager:Init(self.levelLoader)
end

function BP_EMGameMode_C:TryRegisterPlayerToTacmap()
  local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
  if not (DungeonInfo and DungeonInfo.EnableTacmap) or not self.TacMapManager then
    return
  end
  for i = 0, self:GetPlayerNum() - 1 do
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, i)
    self.TacMapManager:RegisterPlayer(PlayerCharacter, i + 1)
  end
end

function BP_EMGameMode_C:GMInitGameModeInfo(Id)
  self:InitGameModeInfo(Id)
end

function BP_EMGameMode_C:ResetRemainTriggerAlertCD()
  self.RemainTriggerAlertCD = DataMgr.GlobalConstant.GameModeAlertCD.ConstantValue or 30
end

function BP_EMGameMode_C:ReceiveBeginPlay()
  self.LevelGameMode = UE4.UGameplayStatics.GetGameMode(self)
  if self:IsSubGameMode() then
    return
  end
  self:SetActorTickInterval(1.0)
  self:AIBattleMgrReceiveBeginPlay()
  self:BindTalkSubsystem()
  self.GameModeIndex = GWorld:AddGameMode(self)
end

function BP_EMGameMode_C:ReceiveEndPlay(EndPlayReason)
  if self:IsSubGameMode() then
    return
  end
  self.Overridden.ReceiveEndPlay(self, EndPlayReason)
  self.OnDestroyDelegates:Broadcast()
  self:UnbindTalkSubsystem()
  GWorld:RemoveGameMode(self.GameModeIndex)
end

function BP_EMGameMode_C:BindTalkSubsystem()
  local TalkSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UTalkSubsystem)
  if not IsValid(TalkSubsystem) then
    return
  end
  if self.OnGamePauseChanged then
    self.OnGamePauseChanged:Add(TalkSubsystem, TalkSubsystem.OnGamePauseChanged)
  end
end

function BP_EMGameMode_C:UnbindTalkSubsystem()
  local TalkSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UTalkSubsystem)
  if not IsValid(TalkSubsystem) then
    return
  end
  if self.OnGamePauseChanged then
    self.OnGamePauseChanged:Remove(TalkSubsystem, TalkSubsystem.OnGamePauseChanged)
  end
end

function BP_EMGameMode_C:GetPlayerLevel()
  return GWorld:GetAvatar() and GWorld:GetAvatar().Level or 0
end

function BP_EMGameMode_C:GetTargetPlayerNum()
  return CommonUtils.Size(self.AvatarInfos)
end

function BP_EMGameMode_C:IsNeedToWaitForOthers()
  return self.NeedToWaitForOthers
end

function BP_EMGameMode_C:ReceiveTick(DeltaSeconds)
  self:TickAIBattleMgr(DeltaSeconds)
  self:TickGenReward(DeltaSeconds)
end

function BP_EMGameMode_C:GetAlreadyInit()
  return self.AlreadyInit
end

function BP_EMGameMode_C:SetRegionSpecialQuest(Value, UIParamID)
  assert(self:IsInRegion(), "SetRegionSpecialQuest 只能在区域内调用")
  self.EMGameState.CurDungeonUIParamID = UIParamID
  local TypeName = ERegionSpecialQuestType:GetNameByValue(Value)
  self:InitRegionDungeonComponent(TypeName)
  self.LevelGameMode:InitRegionSpecialQuestGameModeComponent()
  self.EMGameState:SetDungeonUIState(Const.EDungeonUIState.None)
  self.EMGameState:LoadDungeonUI(TypeName)
  DebugPrint("SetRegionSpecialQuest 特殊任务GameModeComponent初始化 特殊任务:", TypeName)
end

function BP_EMGameMode_C:ResetRegionSpecialQuest()
  DebugPrint("ResetRegionSpecialQuest 特殊任务GameModeComponent重置 特殊任务:", self.LevelGameMode.RegionSpecialQuest)
  self.EMGameState:UnloadDungeonUI(self.LevelGameMode.RegionSpecialQuest)
  self.LevelGameMode:ClearRegionSpecialQuestGameModeComponent()
  self:ClearRegionDungeonComponent()
  self.EMGameState.CurDungeonUIParamID = 0
end

function BP_EMGameMode_C:InitRegionSpecialQuestGameModeComponent()
  if self.RegionSpecialQuest == nil then
    return
  end
  local FunName = "Init" .. self.RegionSpecialQuest .. "Component"
  self:TriggerDungeonComponentFun(FunName)
end

function BP_EMGameMode_C:ClearRegionSpecialQuestGameModeComponent()
  if self.RegionSpecialQuest == nil then
    return
  end
  local FunName = "Clear" .. self.RegionSpecialQuest .. "Component"
  self:TriggerDungeonComponentFun(FunName)
end

function BP_EMGameMode_C:ShowTrialTask(TaskIndex)
  self:TriggerDungeonComponentFun("ShowTrialTask", TaskIndex)
end

function BP_EMGameMode_C:OnInit()
  if not self:CheckGameModeEnable() then
    return
  end
  if self:IsSubGameMode() then
    return
  end
  self:RegionOnInit()
  DebugPrint("GameMode进行激活 OnInit")
  GWorld:DSBLog("Info", "GameMode:OnInit", "GameMode")
  self:AddDungeonEvent("OnInit")
  self.AlreadyInit = true
  if IsDedicatedServer(self) then
    GWorld.GameInstance:SetFixedFrameRate(20)
  end
  self:TryRegisterPlayerToTacmap()
  self.CharExpGetInBattle = 0
  if self:IsInDungeon() and self:NeedProgressRecover() then
    self:InitBPBornActor()
    self:TriggerProgressRecover()
  else
    self:InitDungeonBaseInfo()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
      TaskUtils:UpdatePlayerSubRegionIdInfo(Avatar.CurrentRegionId)
      Avatar:CombineAddRegionData(true)
      self:AddTimer(0.1, function()
        local Avatar1 = GWorld:GetAvatar()
        if Avatar1 and Avatar1.CombineAdd and self:IsInRegion() then
          Avatar1:CombineAddRegionData(false)
        end
      end)
    end
    self:InitBPBornActor()
    self:InitCustomActor()
    self:InitAutoActiveStaticCreator()
    if Avatar and self:IsInRegion() then
      Avatar:CombineAddRegionData(false)
    end
    self.Overridden.OnInit(self)
  end
  if self:IsInDungeon() and self.DungeonId and self.DungeonId > 0 then
    self:SetDungeonBGMState(0)
  end
  self.OnInitDelegates:Broadcast()
  ClientEventUtils:ClearCurrentDoingDynamicEvent(true, true)
end

function BP_EMGameMode_C:InitDungeonBaseInfo()
  if self:IsSubGameMode() or self:IsInRegion() then
    return
  end
  if self.EMGameState.GameModeType == "Blank" then
    return
  end
  if not self:GetDungeonComponent() then
    return
  end
  local FunName = "Init" .. self.EMGameState.GameModeType .. "BaseInfo"
  if self:GetDungeonComponent() ~= nil and self:GetDungeonComponent()[FunName] ~= nil then
    self:GetDungeonComponent()[FunName](self:GetDungeonComponent())
  end
end

function BP_EMGameMode_C:RegionOnInit()
  if self:IsInRegion() then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:HandleTryInitRegionInfo()
    end
    if not self.EMGameState:RegionNeedPreCreateUnit() then
      self:GetRegionDataMgrSubSystem():OnInitRecoverRegionData(false)
    end
  end
end

function BP_EMGameMode_C:OnQuestComplete(QuestChainId, QuestId)
  self.Overridden.OnQuestComplete(self, QuestChainId, QuestId)
  local Components = self:K2_GetComponentsByClass(UAfterQuestFinishEventComponent.StaticClass())
  for _, Component in pairs(Components:ToTable()) do
    if Component.QuestId == QuestId then
      Component.AfterQuestFinish:Broadcast()
    end
  end
end

function BP_EMGameMode_C:TriggerOnQuestCompleteComponent()
  local Components = self:K2_GetComponentsByClass(UAfterQuestFinishEventComponent.StaticClass())
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  for _, Component in pairs(Components:ToTable()) do
    if Avatar:IsQuestFinished(Component.QuestId) or Avatar:IsQuestAssumeFinished(Component.QuestId) then
      Component.AfterQuestFinish:Broadcast()
    end
  end
end

function BP_EMGameMode_C:OnBigWorldActive()
  self.Overridden.OnBigWorldActive(self)
  self:TriggerOnQuestCompleteComponent()
end

function BP_EMGameMode_C:MainGameModeOnBigWorldActive()
  if self:IsSubGameMode() then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local ActiveExploreInfo = {}
  for _, ExploreGroup in pairs(self.EMGameState.ExploreGroupMap:ToTable()) do
    if ExploreGroup.AutoActive then
      local SubRegionId = self:GetRegionIdByLocation(ExploreGroup:K2_GetActorLocation())
      local ExploreId = ExploreGroup:GetExploreGroupId()
      if not DataMgr.SubRegion[SubRegionId] then
        GWorld.logger.error("ZJT_ 哦我的上帝，这里有一个探索组" .. ExploreId .. "被丢弃在区域外" .. SubRegionId .. "找不到它所在的区域")
      elseif ActiveExploreInfo[ExploreGroup:GetExploreGroupId()] then
        GWorld.logger.error("ZJT_ 哦我的上帝，这里有一个探索组居然重复掉了" .. ExploreId .. ":SubRegionId:" .. SubRegionId .. "所在的区域")
      else
        local Explore = Avatar.Explores[ExploreId]
        if Explore then
          if Explore:IsDoing() then
            if Explore.RegionId ~= SubRegionId then
              GWorld.logger.error("ZJT_ 哦我的上帝，这里有一个探索组居然重复掉了 不同区域: " .. ExploreId .. ": 本次激活 SubRegionId:" .. SubRegionId .. "所在的区域" .. "上次激活：" .. Explore.RegionId .. " 所在区域！")
            end
          elseif Explore:IsInActive() then
            ActiveExploreInfo[ExploreId] = SubRegionId
          end
        else
          ActiveExploreInfo[ExploreId] = SubRegionId
        end
        ExploreGroup:InitSetExploreGroupStatus_Active()
      end
    end
  end
  if Avatar then
    Avatar:ExploreIdsActive(ActiveExploreInfo)
  end
  self:TriggerOnQuestCompleteComponent()
end

function BP_EMGameMode_C:OnBattle()
  if not self:IsSubGameMode() then
    self.OnBattleDelegates:Broadcast()
    self:TriggerDungeonComponentFun("OnBattle")
  end
  self.Overridden.OnBattle(self)
end

function BP_EMGameMode_C:OnPlayerEnter(Eid)
  if not self:IsSubGameMode() and Eid > 0 then
    self:TriggerDungeonComponentFun("OnPlayerEnter", Eid)
  end
  self.Overridden.OnPlayerEnter(self, Eid)
end

function BP_EMGameMode_C:OnPause()
  if not self:IsSubGameMode() then
    self.OnPauseDelegates:Broadcast()
  end
  self.Overridden.OnPause(self)
end

function BP_EMGameMode_C:OnAlert()
  if not self:IsSubGameMode() then
    self.OnAlertDelegates:Broadcast()
  end
  self.Overridden.OnAlert(self)
end

function BP_EMGameMode_C:OnEnterCommonAlert()
  if not self:IsSubGameMode() then
    self.OnEnterCommonAlertDelegates:Broadcast()
  end
  self.Overridden.OnEnterCommonAlert(self)
end

function BP_EMGameMode_C:OnExitCommonAlert()
  if not self:IsSubGameMode() then
    self.OnExitCommonAlertDelegates:Broadcast()
  end
  self.Overridden.OnExitCommonAlert(self)
end

function BP_EMGameMode_C:OnResumeBattleEntities()
  if not self:IsSubGameMode() then
    self.OnResumeBattleEntitiesDelegates:Broadcast()
  end
  self.Overridden.OnResumeBattleEntities(self)
end

function BP_EMGameMode_C:OnPauseBattleEntities(Reason)
  if not self:IsSubGameMode() then
    self.OnPauseBattleEntitiesDelegates:Broadcast()
  end
  self.Overridden.OnPauseBattleEntities(self, Reason)
end

function BP_EMGameMode_C:OnBossDead(Monster)
  self.Overridden.OnBossDead(self, Monster)
  self:TriggerBPGameModeEvent("OnBossDead", Monster)
end

function BP_EMGameMode_C:OnEnd(Result)
  if not self:IsSubGameMode() then
    self.OnEndDelegates:Broadcast(Result)
    self.EMGameState:ClearGuideEid()
    local FunName = "Trigger" .. self.EMGameState.GameModeType .. "OnEnd"
    self:TriggerDungeonComponentFun(FunName)
    self:RemoveDungeonEvent("OnInit")
    self.CharExpGetInBattle = 0
    for _, PlayerCharacter in pairs(self:GetAllPlayer()) do
      local NextRecoveryState = PlayerCharacter:IsDead() and UE4.ETeamRecoveryState.RealDead or UE4.ETeamRecoveryState.Alive
      PlayerCharacter:HandleRemoveModPassives()
      PlayerCharacter:TryLeaveDying(NextRecoveryState)
    end
  end
  self.Overridden.OnEnd(self, Result)
end

function BP_EMGameMode_C:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType)
  if not self:IsSubGameMode() then
    self:TriggerDungeonComponentFun("OnStaticCreatorEvent", EventName, Eid, UnitId, UnitType)
  end
  self.Overridden.OnStaticCreatorEvent(self, EventName, Eid, UnitId, UnitType)
end

function BP_EMGameMode_C:OnUnitDeadEvent(MonsterC)
  if not self:IsSubGameMode() then
    self:TriggerDungeonComponentFun("OnUnitDeadEvent", MonsterC)
    self:TriggerDungeonAchieve("OnMonsterDeadAchieve", MonsterC, -1)
  end
end

function BP_EMGameMode_C:OnUnitDestoryEvent(MonsterC, CombatItemBase, DestroyReason)
  if not self:IsSubGameMode() then
    self:TriggerDungeonComponentFun("OnUnitDestoryEvent", MonsterC, CombatItemBase)
  end
  if MonsterC then
    self:TriggerSTLEvent("OnSTLActorDestroyed", MonsterC, DestroyReason)
  elseif CombatItemBase then
    self:TriggerSTLEvent("OnSTLActorDestroyed", CombatItemBase, DestroyReason)
  else
    DebugPrint("BP_EMGameMode_C:OnUnitDestoryEvent 传入的Monster和CombatItemBase均为空！")
  end
end

function BP_EMGameMode_C:OnCombatPropDeadEvent(CombatProp)
  if not self:IsSubGameMode() then
    self:TriggerDungeonComponentFun("OnCombatPropDeadEvent", CombatProp)
  end
end

function BP_EMGameMode_C:STLPostStaticCreatorEvent(Actor, Info)
  if self:IsInDungeon() then
    return
  end
  if Info.Creator and 0 == Actor.RandomCreatorId and 0 ~= Actor.CreatorId then
    self:TriggerSTLEvent("STLPostStaticCreatorEvent", Actor)
  end
end

function BP_EMGameMode_C:ClearDelayMonster()
  if self:IsInRegion() then
    return
  end
  local EventMgr = self.EMGameState.EventMgr
  EventMgr.FramingCreateUintQueue.Monster = {}
  EventMgr.LoadingClassMonsterQueue = {}
end

function BP_EMGameMode_C:STLRegisterKillMonsterNode(KillMonsterNode)
  if not self.KillMonsterNodeMap then
    self.KillMonsterNodeMap = {}
  end
  if _G.next(self.KillMonsterNodeMap) == nil then
    self.EMGameState:RegisterGameModeEvent("OnDead", self, self.STLOnMonsterKilled)
    DebugPrint("KillMonsterNode: 注册OnDead事件")
  end
  self.KillMonsterNodeMap[KillMonsterNode.Key] = KillMonsterNode
  DebugPrint("KillMonsterNode: 注册到GameMode. Key", KillMonsterNode.Key)
end

function BP_EMGameMode_C:STLUnRegisterKillMonsterNode(KillMonsterNodeKey)
  if not self.KillMonsterNodeMap then
    return
  end
  self.KillMonsterNodeMap[KillMonsterNodeKey] = nil
  DebugPrint("KillMonsterNode: 从GameMode移除. Key", KillMonsterNodeKey)
  if nil == _G.next(self.KillMonsterNodeMap) then
    self.EMGameState:RemoveGameModeEvent("OnDead", self, self.STLOnMonsterKilled)
    DebugPrint("KillMonsterNode: 注销OnDead事件")
  end
end

function BP_EMGameMode_C:STLOnMonsterKilled(Monster)
  if not self.KillMonsterNodeMap then
    return
  end
  local DeepCopy_KillMonsterNodeMap = self:STLTableDeepCopy(self.KillMonsterNodeMap)
  for Key, KillMonsterNode in pairs(DeepCopy_KillMonsterNodeMap) do
    DebugPrint("KillMonsterNode: 怪物被击杀，Node Key", Key)
    KillMonsterNode:OnMonsterKilledByNums(Monster)
  end
end

function BP_EMGameMode_C:STLRegisterKillMonsterNode_Creator(KillMonsterNode)
  if not self.KillMonsterNodeMap_Creator then
    self.KillMonsterNodeMap_Creator = {}
  end
  if _G.next(self.KillMonsterNodeMap_Creator) == nil then
    self.EMGameState:RegisterGameModeEvent("OnDeadStaticUnit", self, self.STLOnMonsterKilled_Creator)
    DebugPrint("KillMonsterNode_Creator: 注册OnDead事件")
  end
  self.KillMonsterNodeMap_Creator[KillMonsterNode.Key] = KillMonsterNode
  DebugPrint("KillMonsterNode_Creator: 注册到GameMode. Key", KillMonsterNode.Key)
end

function BP_EMGameMode_C:STLUnRegisterKillMonsterNode_Creator(KillMonsterNodeKey)
  if not self.KillMonsterNodeMap_Creator then
    return
  end
  self.KillMonsterNodeMap_Creator[KillMonsterNodeKey] = nil
  DebugPrint("KillMonsterNode_Creator: 从GameMode移除. Key", KillMonsterNodeKey)
  if nil == _G.next(self.KillMonsterNodeMap_Creator) then
    self.EMGameState:RemoveGameModeEvent("OnDeadStaticUnit", self, self.STLOnMonsterKilled_Creator)
    DebugPrint("KillMonsterNode_Creator: 注销OnDead事件")
  end
end

function BP_EMGameMode_C:STLOnMonsterKilled_Creator(Monster)
  if not self.KillMonsterNodeMap_Creator then
    return
  end
  local DeepCopy_KillMonsterNodeMap_Creator = self:STLTableDeepCopy(self.KillMonsterNodeMap_Creator)
  for Key, KillMonsterNode in pairs(DeepCopy_KillMonsterNodeMap_Creator) do
    DebugPrint("KillMonsterNode_Creator: 怪物被击杀，Node Key", Key)
    KillMonsterNode:OnMonsterKilledByCreatorId(Monster)
  end
end

function BP_EMGameMode_C:STLTableDeepCopy(table)
  local res = {}
  for k, v in pairs(table) do
    res[k] = v
  end
  return res
end

function BP_EMGameMode_C:OnCustomEvent(EventName, Channel)
  if not self:IsSubGameMode() then
    self.OnCustomEventDelegates:Broadcast(EventName, Channel)
  end
  self.Overridden.OnCustomEvent(self, EventName, Channel)
  self:TriggerBPGameModeEvent("OnCustomEvent", EventName)
end

function BP_EMGameMode_C:OnTriggerAOIBase(TriggerEventId, TriggerBase, EMActorEid, TriggerType)
  if not self:IsSubGameMode() then
    self:TriggerSTLEvent("OnTriggerAOIBase", TriggerEventId, TriggerBase, EMActorEid, TriggerType)
  end
  self.Overridden.OnTriggerAOIBase(self, TriggerEventId, TriggerBase, EMActorEid, TriggerType)
  self:TriggerBPGameModeEvent("OnTriggerAOIBase", TriggerEventId, TriggerBase, EMActorEid, TriggerType)
end

function BP_EMGameMode_C:ChangeAOITriggerCollision(CreatorIds, IsEnabled)
  for i, v in pairs(CreatorIds) do
    local Creator = self.EMGameState.StaticCreatorMap:Find(v)
    if Creator and Creator.ChildEids:Length() > 0 then
      local Mechanism = Battle(self):GetEntity(Creator.ChildEids[1])
      if Mechanism and Mechanism.CollisionComponent then
        local CollisionType = IsEnabled and ECollisionEnabled.QueryOnly or ECollisionEnabled.NoCollision
        Mechanism.CollisionComponent:SetCollisionEnabled(CollisionType)
      end
    end
  end
end

function BP_EMGameMode_C:BpAddTimer(TimerHandleName, Time, IsRealTime, Channel)
  DebugPrint("BpTimerDebug: BpAddTimer", TimerHandleName, Time, IsRealTime, Channel)
  self:AddTimer(Time, self.BpOnTimerEnd, false, 0, TimerHandleName, IsRealTime, TimerHandleName)
  self:AddClientTimerStruct(self, TimerHandleName, Time, IsRealTime)
  if Channel == Const.GameModeEventServerClient then
    self:AddDungeonEvent(TimerHandleName)
  end
end

function BP_EMGameMode_C:BpDelTimer(TimerHandleName, IsRealTime, Channel)
  DebugPrint("BpTimerDebug: BpDelTimer", TimerHandleName, IsRealTime, Channel)
  self:RemoveTimer(TimerHandleName, IsRealTime)
  local FuncName = "BpOnTimerDel_" .. TimerHandleName
  if self[FuncName] then
    self[FuncName](self)
  end
  if TimerHandleName == Const.BattleProgressTimerHandle and self.BP_BattleProgressComponent then
    self.BP_BattleProgressComponent:OnTimerDel()
  end
  self:RemoveClientTimerStruct(TimerHandleName)
  if Channel == Const.GameModeEventServerClient then
    self:RemoveDungeonEvent(TimerHandleName)
  end
end

function BP_EMGameMode_C:BpResetTimer(TimerHandleName, NewTime, IsRealTime, Channel)
  DebugPrint("BpTimerDebug: BpResetTimer", TimerHandleName, NewTime, IsRealTime, Channel)
  self:RemoveTimer(TimerHandleName, IsRealTime)
  self:AddTimer(NewTime, self.BpOnTimerEnd, false, 0, TimerHandleName, IsRealTime, TimerHandleName)
  self:RemoveClientTimerStruct(TimerHandleName)
  if Channel == Const.GameModeEventServerClient then
    self:AddClientTimerStruct(self, TimerHandleName, NewTime, IsRealTime)
  end
end

function BP_EMGameMode_C:BpOnTimerEnd(TimerHandleName)
  DebugPrint("BpTimerDebug: BpOnTimerEnd", TimerHandleName)
  self.Overridden.BpOnTimerEnd(self, TimerHandleName)
  self:TriggerBPGameModeEvent("BpOnTimerEnd", TimerHandleName)
  local FuncName = "BpOnTimerEnd_" .. TimerHandleName
  if self[FuncName] then
    self[FuncName](self)
  end
  self.LevelGameMode:TriggerDungeonComponentFun(FuncName)
  if TimerHandleName == Const.BattleProgressTimerHandle and self.BP_BattleProgressComponent then
    self.BP_BattleProgressComponent:OnTimerEnd()
  end
  self:RemoveClientTimerStruct(TimerHandleName)
  self:RemoveDungeonEvent(TimerHandleName)
end

function BP_EMGameMode_C:BpGetRemainTime(TimerHandleName)
  local RawRemainTime = CommonUtils.GetClientTimerStructRemainTime(TimerHandleName)
  if not RawRemainTime then
    return 0
  end
  return RawRemainTime
end

function BP_EMGameMode_C:SetClientDungeonUIState(DungeonUIState)
  local OldState = self.EMGameState.DungeonUIState
  self.EMGameState.DungeonUIState = DungeonUIState
  self.EMGameState:MarkDungeonUIStateAsDirtyData()
  if IsStandAlone(self) and OldState ~= DungeonUIState then
    self.EMGameState:OnRep_DungeonUIState()
  end
end

function BP_EMGameMode_C:NotifyClientShowSurvivalProBuffInfo(PathIconList, TextMapList, Duration)
  self.EMGameState.SurvivalProBuffInfo.PathIconList = PathIconList
  self.EMGameState.SurvivalProBuffInfo.TextMapList = TextMapList
  self.EMGameState.SurvivalProBuffInfo.Duration = Duration
  self.EMGameState:MarkSurvivalProBuffInfoAsDirtyData()
  self:AddDungeonEvent("UpdateSurvivalProBuffInfo")
end

function BP_EMGameMode_C:NotifyClientShowDungeonToast(TextMapIndex, Duration, ToastType, ColorEnum)
  self.EMGameState:MulticastClientShowDungeonToast(TextMapIndex, Duration, ToastType, ColorEnum)
  return TextMapIndex
end

function BP_EMGameMode_C:InitBPBornActor()
  if 0 == self.BPBornActor:Num() then
    return
  end
  for i, v in pairs(self.BPBornActor:ToTable()) do
    if IsValid(v) then
      if UE4.UGameplayStatics.GetGameState(v) and not v.ServerInitSuccess then
        if not v.TryInitActorInfo then
          DebugPrint("ERROR TryInitActorInfo:", v:GetName())
        else
          v:TryInitActorInfo("OnInit")
        end
      elseif not UE4.UGameplayStatics.GetGameState(v) then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
          local ct = {
            "报错文本:\n\t",
            "机关名称：",
            v:GetName(),
            "\n"
          }
          local FinalMsg = table.concat(ct)
          Avatar:SendToFeiShuForRegionMgr(FinalMsg, "BPBorn初始化报错 | 未获取到GameState")
        else
          DebugPrint("Error: InitBPBornActor, NoGameState From This :", v:GetName())
        end
      end
    end
  end
end

function BP_EMGameMode_C:InitCustomActor()
  for i, ClanManager in pairs(self.EMGameState.ClanManagerMap) do
    ClanManager:InitClan()
  end
end

function BP_EMGameMode_C:InitAutoActiveStaticCreator()
  self:TriggerActiveStaticCreator(self.EMGameState.AutoActiveStaticIds)
  self:TriggerActiveAutoPrivateStaticCreator()
  self:TriggerFlexibleActiveStaticCreator()
end

function BP_EMGameMode_C:GetIsOpenWroldRegion()
  return GWorld:GetWorldRegionState()
end

function BP_EMGameMode_C:IsCanTriggerRandomStaticCreator(RuleId, Id)
  if not GWorld:GetWorldRegionState() then
    return true
  end
  if IsStandAlone(self) then
    local Avatar = GWorld:GetAvatar()
    if Avatar and self:GetRegionDataMgrSubSystem():IsRandomIdControlByCacheNew(RuleId, Id) then
      return false
    end
  end
  return true
end

function BP_EMGameMode_C:OnPlayersDungeonEnd(AvatarEids)
  local function func(AvatarEid)
    local PlayerController = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerByAvatarEid(GWorld.GameInstance, AvatarEid)
    
    if PlayerController then
      local Player = PlayerController:GetMyPawn()
      if Player then
        DebugPrint("Tianyi@ On Player Leave Dungeon")
        Player:RawRemoveAllBuff(true)
        Player:HandleRemoveModPassives()
        Player:ClearSummons(false)
        if self:IsInDungeon() then
          UE4.UPhantomFunctionLibrary.CancelAllPhantomFromOwner(Player, EDestroyReason.PhantomExitDungeon)
        end
        local NextRecoveryState = Player:IsDead() and UE4.ETeamRecoveryState.RealDead or UE4.ETeamRecoveryState.Alive
        Player:TryLeaveDying(NextRecoveryState)
        if not Player:IsDead() then
          Player:ResetIdle()
        end
        local FunName = "Trigger" .. self.EMGameState.GameModeType .. "PlayerDungeonEnd"
        self:TriggerDungeonComponentFun(FunName, Player)
      end
    end
  end
  
  if AvatarEids and 0 ~= #AvatarEids then
    for _, AvatarEid in ipairs(AvatarEids) do
      func(AvatarEid)
    end
  else
    for AvatarEid, _ in pairs(self.LevelGameMode.AvatarInfos) do
      func(AvatarEid)
    end
  end
end

function BP_EMGameMode_C:TriggerFallingCallable(OtherActor, DefaultTransform, MaxDis, DefaultEnable, FallTrigger, TriggerFallingScreenColor)
  if not IsValid(OtherActor) then
    return
  end
  if OtherActor.TriggerFallingCallable then
    OtherActor:TriggerFallingCallable(self, DefaultTransform, MaxDis, DefaultEnable, FallTrigger, TriggerFallingScreenColor)
  else
    ScreenPrint(string.format("This OtherActor has not function called TriggerFallingCallable.  ActorName:  %s,  UnitId:  %d,  Eid:  %d,  CreatorId:  %d", OtherActor:GetName() or "nil", OtherActor.UnitId or -1, OtherActor.Eid or -1, OtherActor.CreatorId or -1))
  end
end

function BP_EMGameMode_C:TriggerWaterFallingCallable(OtherActor, DefaultTransform, MaxDis, DefaultEnable)
  if not IsValid(OtherActor) then
    return
  end
  if OtherActor.TriggerWaterFallingCallable then
    OtherActor:TriggerWaterFallingCallable(self, DefaultTransform, MaxDis, DefaultEnable)
  else
    ScreenPrint(string.format("This OtherActor has not function called TriggerWaterFallingCallable.  ActorName:  %s,  UnitId:  %d,  Eid:  %d,  CreatorId:  %d", OtherActor:GetName() or "nil", OtherActor.UnitId or -1, OtherActor.Eid or -1, OtherActor.CreatorId or -1))
  end
end

function BP_EMGameMode_C:SpawnDefaultPawnAtTransform(NewPlayer, SpawnTransform)
  DebugPrint("BP_EMGameMode_C:SpawnDefaultPawnAtTransform", SpawnTransform)
  local PawnClass = self:GetDefaultPawnClassForController(NewPlayer)
  local Instigator = self:GetInstigator()
  local DefaultPawn = UE4.URuntimeCommonFunctionLibrary.SpawnDefaultPawn(NewPlayer, PawnClass, SpawnTransform, Instigator)
  return DefaultPawn
end

function BP_EMGameMode_C:GetCurrentQuestId()
  local Avatar = GWorld:GetAvatar()
  local QuestIdArr = UE4.TArray(0)
  if not Avatar then
    return QuestIdArr
  end
  local Table = Avatar:GetQuestDoing()
  for _, value in pairs(Table) do
    QuestIdArr:Add(value)
  end
  return QuestIdArr
end

function BP_EMGameMode_C:SwitchToQuestRole(QuestRoleID, bPlayFX)
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return
  end
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  PlayerCharacter:RecoverBanSkills()
  local PlayerController = PlayerCharacter:GetController()
  
  local function PlayChangeRoleEffect()
    PlayerCharacter:ChangeRoleEffect()
    local BodyType = PlayerCharacter:GetBattleCharBodyType()
    PlayerCharacter.FXComponent:PlayEffectByIDParams(401, {
      NotAttached = true,
      scale = Const.BattleCharTagVXScaleTable[BodyType]
    })
  end
  
  if 0 == QuestRoleID then
    local CharacterUuid = Avatar.CurrentChar
    local CharacterID = Avatar.Chars[CharacterUuid].CharId
    local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
    PlayerCharacter:ChangeRole(CharacterID, AvatarInfo)
    if bPlayFX then
      PlayChangeRoleEffect()
    end
    if PlayerCharacter.RangedWeapon and 0 == PlayerCharacter.RangedWeapon:GetAttr("MagazineBulletNum") then
      PlayerCharacter.RangedWeapon:SetWeaponState("NoBullet", true)
    end
    EventManager:FireEvent(EventID.OnSwitchRole, CharacterUuid)
    return
  end
  local RoleInfo = DataMgr.QuestRoleInfo[QuestRoleID]
  if not RoleInfo then
    local Message = "QuestRoleId不存在" .. "\n\t在调用SwitchToQuestRole的时候，传入的参数QuestRoleId 【" .. tostring(QuestRoleID) .. "】 在QuestRoleInfo表中不存在，请查阅QuestRoleInfo表格"
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "QuestRoleId不存在", Message)
    return
  end
  local AvatarInfo = AvatarUtils:GetBattleInfoByQuestRoleId(QuestRoleID, Avatar)
  if AvatarInfo.RoleInfo then
    AvatarInfo.RoleInfo.AvatarQuestRoleID = QuestRoleID
  end
  PlayerCharacter:ChangeRole(nil, AvatarInfo)
  if bPlayFX then
    PlayChangeRoleEffect()
  end
  if PlayerCharacter.RangedWeapon and 0 == PlayerCharacter.RangedWeapon:GetAttr("MagazineBulletNum") then
    PlayerCharacter.RangedWeapon:SetWeaponState("NoBullet", true)
  end
  EventManager:FireEvent(EventID.OnSwitchRole)
end

function BP_EMGameMode_C:SetNpcPatrol(NpcId, PatrolId)
  local NpcPlayerCharacter = self.EMGameState.NpcCharacterMap:Find(NpcId)
  if not IsValid(NpcPlayerCharacter) then
    print(_G.LogTag, "NpcMap no-exist this Npc", NpcId)
    return
  end
  NpcPlayerCharacter.PatrolId = PatrolId
end

function BP_EMGameMode_C:TriggerMechanism(StaticCreatorId, StateId, PrivateEnable, QuestId)
  if true == PrivateEnable and not self:IsSubGameMode() then
    self.EMGameState:ShowDungeonError("TriggerMechanism PrivateEnable is true but IsSubGameMode:" .. self:GetName(), Const.DungeonErrorType.GameMode, Const.DungeonErrorTitle.Other)
    return
  end
  local StaticCreator = self.EMGameState:GetStaticCreatorInfo(StaticCreatorId, PrivateEnable, self.LevelName)
  if not IsValid(StaticCreator) then
    return
  end
  local NeedUpdateRegionData = true
  if StaticCreator.ChildEids:Length() >= 2 then
    DebugPrint("Warning: 这个StaticCreator刷新了多个机关", StaticCreator.ChildEids:Length())
  end
  local bCanChange = false
  if StaticCreator.ChildEids:Length() > 0 then
    for i = 1, StaticCreator.ChildEids:Length() do
      local Info = Battle(self):GetEntity(StaticCreator.ChildEids:GetRef(i))
      if IsValid(Info) then
        print(_G.LogTag, "LXZ TriggerMechanism444", Info:GetName())
        if Info:IsCombatItemBase() then
          bCanChange = true
          Info:ChangeState("Manual", 0, StateId)
          if Info.RegionDataType == ERegionDataType.RDT_CommonQuestData then
            Info.QuestId = QuestId
          end
        end
      else
        local NowStateId = self.EMGameState.MechanismStateIdMap:Find(StaticCreatorId)
        local MechanismStateData = DataMgr.MechanismState[NowStateId]
        if MechanismStateData then
          for i, v in pairs(MechanismStateData.StateEvent) do
            if v.NextStateId == StateId and "Manual" == v.TypeNextState.Type then
              bCanChange = true
              break
            end
          end
        end
      end
    end
  elseif StaticCreator.CreatedWorldRegionEid ~= "" then
    local LuaTableIndex, HasData = self:GetRegionDataMgrSubSystem():TryGetLuaDataIndex(StaticCreator.CreatedWorldRegionEid)
    if HasData then
      local NowStateId = self:GetRegionDataMgrSubSystem():GetStateIdByWorldRegionEid(LuaTableIndex)
      if -1 == NowStateId then
        NowStateId = DataMgr.Mechanism[StaticCreator.UnitId].FirstStateId
      end
      local MechanismStateData = DataMgr.MechanismState[NowStateId]
      if MechanismStateData then
        for i, v in pairs(MechanismStateData.StateEvent) do
          if v.NextStateId == StateId and "Manual" == v.TypeNextState.Type then
            bCanChange = true
          end
        end
      end
    end
  end
  if StaticCreator.CreatedWorldRegionEid ~= "" and bCanChange then
    self:GetRegionDataMgrSubSystem():ChangeState(StaticCreator.CreatedWorldRegionEid, StateId)
  end
end

function BP_EMGameMode_C:TriggerMechanismArray(StaticCreatorIds, StateId, PrivateEnable, QuestId)
  for i, v in pairs(StaticCreatorIds) do
    self:TriggerMechanism(v, StateId, PrivateEnable, QuestId)
  end
end

function BP_EMGameMode_C:TriggerPetStateChange(StaticCreatorId, TargetState, PrivateEnable)
  if true == PrivateEnable and not self:IsSubGameMode() then
    self.EMGameState:ShowDungeonError("TriggerPetStateChange PrivateEnable is true but IsSubGameMode: " .. self:GetName(), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
    return
  end
  local StaticCreator = self.EMGameState:GetStaticCreatorInfo(StaticCreatorId, PrivateEnable, self.LevelName)
  if not IsValid(StaticCreator) then
    self.EMGameState:ShowDungeonError("TriggerPetStateChange Can Not Find StaticCreator: " .. StaticCreatorId .. " PrivateEnable: " .. PrivateEnable, Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
    return
  end
  for i = 1, StaticCreator.ChildEids:Length() do
    local Info = Battle(self):GetEntity(StaticCreator.ChildEids:GetRef(i))
    if IsValid(Info) and Info:IsPetNpc() then
      Info:SetInteractiveState(TargetState)
    end
  end
end

function BP_EMGameMode_C:PetPlayFailureMontage(StaticCreatorId, PrivateEnable)
  self.LevelGameMode:AddDungeonEvent("PetPlayFailureMontage")
end

function BP_EMGameMode_C:TriggerPetMechanismState(StateId, PrivateEnable, QuestId)
  if self:IsSubGameMode() then
    self.EMGameState:ShowDungeonError("在子GameMode使用了TriggerPetMechanismState: " .. self:GetName(), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
    return
  end
  if not IsValid(self.RandomPetCreator) then
    self.EMGameState:ShowDungeonError("TriggerPetMechanismState RandomPetCreator无效: " .. self:GetName(), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
  end
  self:TriggerMechanism(self.RandomPetCreator.StaticCreatorId, StateId, PrivateEnable, QuestId)
end

function BP_EMGameMode_C:TriggerPetStateChangeMain(TargetState, PrivateEnable)
  if self:IsSubGameMode() then
    self.EMGameState:ShowDungeonError("在子GameMode使用了TriggerPetStateChangeMain: " .. self:GetName(), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
    return
  end
  if not IsValid(self.RandomPetCreator) then
    self.EMGameState:ShowDungeonError("TriggerPetStateChangeMain RandomPetCreator无效: " .. self:GetName(), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
  end
  for i = 1, self.RandomPetCreator.ChildEids:Length() do
    local Info = Battle(self):GetEntity(self.RandomPetCreator.ChildEids:GetRef(i))
    if IsValid(Info) and Info:IsPetNpc() then
      Info:SetInteractiveState(TargetState)
    end
  end
end

function BP_EMGameMode_C:PetPlayFailureMontageMain(PrivateEnable)
  self.LevelGameMode:AddDungeonEvent("PetPlayFailureMontage")
end

function BP_EMGameMode_C:OnTriggerMechanismManualItem(ManualCombatId, ComponentStateId, StateId, QuestId)
  if self:IsSubGameMode() and not self:IsInRegion() then
    print(_G.LogTag, "LXZ OnTriggerMechanismManualItem", ComponentStateId)
    return
  end
  for i = 1, ManualCombatId:Length() do
    local CombatItem = self.EMGameState.ManualActiveCombat:Find(ManualCombatId[i])
    if not IsValid(CombatItem) then
      GWorld.logger.error("哦我的上帝，这里有一个ManualItemId" .. ManualCombatId[i] .. "找不到它亲爱的机关实体，亲爱的策划能改一下gamemode配置吗")
    end
    if IsValid(CombatItem) then
      if CombatItem.ChangeToState then
        CombatItem:ChangeToState(StateId)
      end
      if 0 ~= ComponentStateId then
        CombatItem:ChangeState("Manual", 0, ComponentStateId)
      end
      if CombatItem.RegionDataType == ERegionDataType.RDT_QuestCommonData then
        CombatItem.QuestId = QuestId
      end
    end
  end
end

function BP_EMGameMode_C:OnTriggerMechanismMonsterNest(ManualId, MonsterNum, MonsterSpawnInterval, MonsterUnitIdArr, MonsterUnitType, MonsterPresetTarget, MonsterPresetTargetId)
  if self:IsSubGameMode() then
    return
  end
  for key, value in pairs(ManualId) do
    local CombatItem = self.EMGameState.ManualActiveCombat:Find(value)
    if not IsValid(CombatItem) then
      GWorld.logger.error("哦我的上帝，这里有一个ManualItemId" .. ManualId .. "找不到它亲爱的机关实体，亲爱的策划能改一下gamemode配置吗")
    end
    CombatItem.MonsterNum = MonsterNum
    CombatItem.MonsterSpawnInterval = MonsterSpawnInterval
    CombatItem.MonsterUnitId = MonsterUnitIdArr
    CombatItem.MonsterUnitType = MonsterUnitType
    CombatItem.MonsterPresetTarget = MonsterPresetTarget
    CombatItem.MonsterPresetTargetId = MonsterPresetTargetId
    DebugPrint("thy      OnTriggerMechanismMonsterNest")
  end
end

function BP_EMGameMode_C:GetHLODDistance(ScalabilityLevel)
  if not Const.bOverrideHLODDistance then
    return -1
  end
  local Distance = 5000
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
  if "Android" == PlatformName then
    Distance = Const.HLODDistanceAndroid[ScalabilityLevel] or Distance
  else
    Distance = Const.HLODDistanceDefault[ScalabilityLevel] or Distance
  end
  DebugPrint("BP_EMGameMode_C:GetHLODDistance PlatformName: ", PlatformName, "Distance: ", Distance)
  return Distance
end

function BP_EMGameMode_C:OnTriggerDestroyMonsterInMonsterNest(ManualCombatId)
  if self:IsSubGameMode() then
    return
  end
  for i = 1, ManualCombatId:Length() do
    local MonsterNest = self.EMGameState.ManualActiveCombat:Find(ManualCombatId[i])
    if not IsValid(MonsterNest) or not MonsterNest:IsCombatItemBase("MonsterNest") then
      GWorld.logger.error("哦我的上帝，这里有一个ManualItemId" .. ManualCombatId[i] .. "找不到它亲爱的MonsterNest，亲爱的策划能改一下gamemode配置吗")
    end
    if IsValid(MonsterNest) then
      MonsterNest:DestroyAllMonster()
    end
  end
end

function BP_EMGameMode_C:InitBPVars(DungeonInfo)
  if GWorld.GameInstance:IsInTempScene() then
    DebugPrint("BP_EMGameMode_C 结算场景 不初始化策划配表赋值蓝图变量")
    return
  end
  local BPOverrideVars = DungeonInfo.BPOverrideVars
  if not BPOverrideVars then
    return
  end
  for VarName, VarValue in pairs(BPOverrideVars) do
    if nil ~= self[VarName] then
      self[VarName] = VarValue
      DebugPrint("BP_EMGameMode_C 初始化策划配表赋值蓝图变量: ", VarName, VarValue)
    else
      ScreenPrint("BP_EMGameMode_C 初始化策划配表赋值蓝图变量: 不存在的变量 " .. VarName)
    end
  end
end

function BP_EMGameMode_C:InitEmergencyMonster()
  self.NeedTreasureMonster = false
  self.TreasureMonsterCreated = false
  self.NeedButcherMonster = false
  self.ButcherMonsterCreated = false
  self.NeedPetMonster = false
  self.PetMonsterCreated = false
  self.TreasureMonsterSpawnInterval = 3
  self.ButcherMonsterSpawnInterval = 5
  self.EmergencyMonsterSpawnLoc = {
    RandomTime = 5,
    MaxDistance = 1000,
    MaxZDistance = 500
  }
end

function BP_EMGameMode_C:GetCreateEmergencyMonsterInterval(MonsterType)
  return self[MonsterType .. "MonsterSpawnInterval"]
end

function BP_EMGameMode_C:GetNeedCreateEmergencyMonster(MonsterType)
  return self["Need" .. MonsterType .. "Monster"] == true and self[MonsterType .. "MonsterCreated"] == false
end

function BP_EMGameMode_C:InitCreateEmergencyMonsterProb(MonsterType, Component, DungeonInfo)
  if nil == Component then
    DebugPrint("InitCreateEmergencyMonsterProb: GameMode Componet 不存在！")
    return
  end
  if nil == DungeonInfo then
    DebugPrint("InitCreateEmergencyMonsterProb: DungeonInfo 不存在！")
    return
  end
  local ProbabilityInfo = DungeonInfo[MonsterType .. "MonsterSpawnProbability"]
  if nil == ProbabilityInfo then
    DebugPrint("InitCreateEmergencyMonsterProb: " .. MonsterType .. "怪信息不存在！")
    return
  end
  Component["Current" .. MonsterType .. "MonsterProb"] = ProbabilityInfo[1]
end

function BP_EMGameMode_C:CreateEmergencyMonsterEachWave(MonsterType, Component, DungeonInfo)
  if nil == Component then
    return
  end
  if nil == DungeonInfo then
    return
  end
  local ProbabilityInfo = DungeonInfo[MonsterType .. "MonsterSpawnProbability"]
  if nil == ProbabilityInfo then
    return
  end
  local MonsterSpawnMinWave = DungeonInfo[MonsterType .. "MonsterSpawnMinWave"]
  if nil == MonsterSpawnMinWave then
    return
  end
  if self:GetNeedCreateEmergencyMonster(MonsterType) == false then
    return
  end
  local WaveIndex = Component:GetWaveIndex()
  if WaveIndex and MonsterSpawnMinWave > WaveIndex then
    return
  end
  local ProbName = "Current" .. MonsterType .. "MonsterProb"
  if nil == Component[ProbName] then
    return
  end
  if math.random() > Component[ProbName] then
    Component[ProbName] = Component[ProbName] + ProbabilityInfo[2]
    return
  end
  self:TryCreateEmergencyMonster(MonsterType)
end

function BP_EMGameMode_C:TryCreateEmergencyMonster(MonsterType)
  local GameModeData = DataMgr[self.EMGameState.GameModeType]
  if nil == GameModeData then
    return
  end
  local DungeonData = GameModeData[self.DungeonId]
  if nil == DungeonData then
    return
  end
  local SpecialMonsterId = DungeonData[MonsterType .. "MonsterId"]
  if nil == SpecialMonsterId then
    return
  end
  local LevelLoader = self.LevelGameMode:GetLevelLoader()
  if nil == LevelLoader then
    return
  end
  local OneRandomPlayer = self:GetOneRandomPlayer()
  if not IsValid(OneRandomPlayer) then
    DebugPrint("TryCreateEmergencyMonster, 玩家不存在, 本次不创建！")
    return
  end
  local PlayerLocation = self:GetOneRandomPlayer().CurrentLocation
  local TargetLocation = UKismetMathLibrary.Vector_Zero()
  local LocationValid = false
  for i = 1, self.EmergencyMonsterSpawnLoc.RandomTime do
    if UNavigationSystemV1.K2_GetRandomLocationInNavigableRadius(self, PlayerLocation, TargetLocation, self.EmergencyMonsterSpawnLoc.MaxDistance) == true and math.abs(PlayerLocation.Z - TargetLocation.Z) <= self.EmergencyMonsterSpawnLoc.MaxZDistance and LevelLoader:GetLevelIdByLocation(PlayerLocation) == LevelLoader:GetLevelIdByLocation(TargetLocation) and UNavigationFunctionLibrary.CheckTwoPosHasPath(PlayerLocation, TargetLocation, self) == EPathConnectType.HasPath then
      LocationValid = true
      break
    end
  end
  if false == LocationValid then
    TargetLocation = self:GetMonsterCustomLoc(nil)
  end
  if false == UKismetMathLibrary.EqualEqual_VectorVector(TargetLocation, UKismetMathLibrary.Vector_Zero(), 0.001) then
    local Context = AEventMgr.CreateUnitContext()
    Context.UnitType = "Monster"
    Context.UnitId = SpecialMonsterId
    Context.Loc = TargetLocation
    Context.IntParams:Add("Level", self:GetFixedGamemodeLevel())
    Context.MonsterSpawn = self.LevelGameMode.FixedMonsterSpawn
    self.EMGameState.EventMgr:CreateUnitNew(Context, false)
    self[MonsterType .. "MonsterCreated"] = true
  end
end

function BP_EMGameMode_C:OnRandomCreateSpawn(RandomCreateId, StateId)
end

function BP_EMGameMode_C:ShowMessage(MessageId, LastTime)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManger = GameInstance:GetGameUIManager()
  if nil == UIManger then
    return
  end
  if nil ~= MessageId and nil ~= LastTime then
    local GuideTextPanel = UIManger:GetUIObj("GuideTextFloat")
    if nil == GuideTextPanel then
      GuideTextPanel = UIManger:LoadUI(UIConst.GUIDETEXTFLOAT, "GuideTextFloat", UIConst.ZORDER_FOR_COMMON_TIP)
    end
    GuideTextPanel:AddGuideMessage(MessageId, LastTime)
  end
end

function BP_EMGameMode_C:HideMessage(MessageId)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManger = GameInstance:GetGameUIManager()
  local GuideTextPanel = UIManger:GetUIObj("GuideTextFloat")
  if nil == UIManger or nil == GuideTextPanel then
    return
  end
  GuideTextPanel:DeleteGuideMessage(MessageId)
end

function BP_EMGameMode_C:GetItemType(UnitId)
  if not DataMgr.Mechanism[UnitId] then
    return ""
  end
  local Type = DataMgr.Mechanism[UnitId].UnitRealType
  return Type
end

function BP_EMGameMode_C:UpdateDungeonProgress()
  self.EMGameState:SetDungeonProgress(self.EMGameState.DungeonProgress + 1)
  DebugPrint("DungeonProgress 副本轮次 +1，当前轮次:", self.EMGameState.DungeonProgress)
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if PlayerCharacter and PlayerCharacter.BattleAchievement then
    PlayerCharacter.BattleAchievement:UpdateTopProcessedValue()
  end
  self:TriggerUploadDungeonAchievement()
  if IsDedicatedServer(self) then
    if GWorld.bDebugServer then
      return
    end
    local DSEntity = GWorld:GetDSEntity()
    if DSEntity then
      DSEntity:UpdateDungeonProgress()
    end
  else
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:UpdateDungeonProgress()
    end
  end
end

function BP_EMGameMode_C:ExecuteLogicBetweenRounds()
  if self:IsWalnutDungeon() then
    self:TriggerShowWalnutReward()
  else
    self:ExecuteLogicStartDungeonVote()
  end
end

function BP_EMGameMode_C:ExecuteLogicStartDungeonVote()
  self:UpdateDungeonProgress()
  if self:CheckDungeonProgressIsMaxRound() then
    return
  end
  self:TriggerDungeonComponentFun("TriggerDungeonVoteBegin")
  self:SetGamePaused("GameModeState", true)
end

function BP_EMGameMode_C:ExecuteNextStepOfDungeonVote()
  if self:IsTicketDungeon() then
    self:TriggerShowTicket()
  else
    self:ExecuteNextStepOfTicket()
  end
end

function BP_EMGameMode_C:ExecuteNextStepOfTicket()
  self.EMGameState.IsInSelectTicket = false
  self.EMGameState.NextTicketPlayer:Clear()
  UE.UMapSyncHelper.SyncMap(self.EMGameState, "NextTicketPlayer")
  if self:IsWalnutDungeon() then
    self:TriggerShowNextWalnut()
  else
    self:TriggerActiveGameModeState(Const.StateBattleProgress)
  end
end

function BP_EMGameMode_C:BpOnTimerEnd_OnDungeonVoteBegin()
  self.EMGameState:DealDungeonVoteResult()
end

function BP_EMGameMode_C:BpOnTimerEnd_SelectTicket()
  self.EMGameState:DealDungeonTicketResult()
end

function BP_EMGameMode_C:IsEndlessDungeon()
  if self.IsDungeonTypeEndless == nil then
    local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
    if DungeonInfo then
      self.IsDungeonTypeEndless = DungeonInfo.DungeonWinMode == CommonConst.DungeonWinMode.Endless
    end
  end
  return self.IsDungeonTypeEndless
end

function BP_EMGameMode_C:DungeonFinish_OnPlayerRealDead(AvatarEids)
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar:IsInRougeLike() then
    DebugPrint("EMGameMode:DungeonFinish_OnPlayerRealDead RougeLike")
    self:FinishRougeLike(false, AvatarEids)
  elseif self:IsAbyssDungeon() then
    local IsReEntering = self:TriggerDungeonComponentFun("IsReEnteringAbyss")
    DebugPrint("EMGameMode:DungeonFinish_OnPlayerRealDead Abyss IsReEntering", IsReEntering)
    if IsReEntering then
      return
    end
    self:TriggerPlayerFailed(AvatarEids)
  else
    DebugPrint("EMGameMode:DungeonFinish_OnPlayerRealDead Default")
    self:TriggerPlayerFailed(AvatarEids)
  end
end

function BP_EMGameMode_C:IsDungeonInSettlement()
  if not self.EMGameState:CheckGameModeStateEnable() then
    DebugPrint("BP_EMGameMode_C:副本状态不正确 多次触发副本结算")
    return true
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar:IsInHardBoss() and self.LevelGameMode.IsInHardBossSettlement then
    DebugPrint("BP_EMGameMode_C:正处于mycs 多次触发副本结算")
    return true
  end
  return false
end

function BP_EMGameMode_C:TriggerDungeonWin()
  DebugPrint("BP_EMGameMode_C:TriggerDungeonWin 副本胜利")
  if self:IsDungeonInSettlement() then
    return
  end
  self.LevelGameMode:TriggerDungeFinish(true)
end

function BP_EMGameMode_C:TriggerDungeonFailed()
  DebugPrint("BP_EMGameMode_C:TriggerDungeonFailed 副本失败")
  if self:IsDungeonInSettlement() then
    return
  end
  self.LevelGameMode:TriggerDungeFinish(false)
end

function BP_EMGameMode_C:TriggerExitDungeon(IsWin)
  DebugPrint("BP_EMGameMode_C:TriggerExitDungeon: Exit Battle + HardBoss", IsWin)
  if self:IsDungeonInSettlement() then
    return
  end
  self.LevelGameMode:TriggerDungeFinish(IsWin)
end

function BP_EMGameMode_C:TriggerPlayerWin(AvatarEids, PlayerEids)
  DebugPrint("BP_EMGameMode_C:TriggerPlayerWin 玩家成功 撤离")
  if self:IsDungeonInSettlement() then
    return
  end
  if IsStandAlone(self) then
    self:TriggerBattleAchievementUploadOnDungeonEnd(true)
    self:TriggerDungeonOnEnd(true)
  end
  self:TriggerUploadDungeonAchievement(PlayerEids)
  self.LevelGameMode:TriggerPlayerFinish(true, AvatarEids)
end

function BP_EMGameMode_C:TriggerPlayerFailed(AvatarEids)
  DebugPrint("BP_EMGameMode_C:TriggerPlayerFailed 玩家失败 撤离")
  if self:IsDungeonInSettlement() then
    return
  end
  if IsStandAlone(self) then
    self:TriggerBattleAchievementUploadOnDungeonEnd(false)
    self:TriggerDungeonOnEnd(false)
  end
  self.LevelGameMode:TriggerPlayerFinish(false, AvatarEids)
end

function BP_EMGameMode_C:ForceFinishPlayerByFailed(AvatarEids)
  DebugPrint("BP_EMGameMode_C:ForceFinishPlayerByFailed 强制玩家以失败结算")
  self.LevelGameMode:TriggerPlayerFinish(false, AvatarEids)
end

function BP_EMGameMode_C:TriggerDungeFinish(IsWin)
  GWorld:DSBLog("Info", "TriggerDungeFinish IsWin:" .. tostring(IsWin), "GameMode")
  self:TriggerDungeonOnEnd(IsWin)
  if IsWin and self:IsWalnutDungeon() and not self:IsEndlessDungeon() then
    self:ExecuteWalutLogicOnEnd()
  else
    self:TriggerRealDungeFinish(IsWin)
  end
end

function BP_EMGameMode_C:TriggerRealDungeFinish(IsWin)
  local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
  if IsWin then
    if DungeonInfo and DungeonInfo.DungeonWinMode == CommonConst.DungeonWinMode.Single then
      self:UpdateDungeonProgress()
    end
    if DungeonInfo and DungeonInfo.DungeonWinMode == CommonConst.DungeonWinMode.Disable then
      local RewardLevel = self:GetDungeonComponent().RewardLevel
      if RewardLevel then
        for i = 1, RewardLevel do
          self:UpdateDungeonProgress()
        end
      end
    end
    self:TriggerUploadDungeonAchievement()
  end
  self:TriggerBattleAchievementUploadOnDungeonEnd(IsWin)
  self:TriggerPlayerFinish(IsWin)
end

function BP_EMGameMode_C:TriggerPlayerFinish(IsWin, AvatarEids)
  GWorld:DSBLog("Info", "TriggerPlayerFinish IsWin:" .. tostring(IsWin), "GameMode")
  DebugPrint("TriggerPlayerFinish 玩家结算，结算状态：", IsWin)
  if IsStandAlone(self) or MiscUtils.IsListenServer(self) then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      print(_G.LogTag, "CollectAlertBaseInfo Server TriggerPlayerFinish", IsWin, self.DungeonId)
      self:TriggerPlayerFinishDungeon(IsWin)
      Avatar:BattleFinish(IsWin)
    end
    self:NotifyClientGameEnd(IsWin, AvatarEids)
    self:OnPlayersDungeonEnd(AvatarEids)
  elseif IsDedicatedServer(self) then
    print(_G.LogTag, "Server TriggerPlayerFinish", IsWin)
    if GWorld.bDebugServer then
      return
    end
    local DSEntity = GWorld:GetDSEntity()
    if DSEntity then
      DSEntity:BattleFinish(IsWin, AvatarEids)
    end
  end
end

function BP_EMGameMode_C:SendTimeDistCheatalert(PlayerChar, DungeonSpendTime, DungeonMoveDistance, MonitorType, SubId, DisThresh, TimeThresh)
  local AlertString = "检测到非法信息:  "
  local BaseAlertInfo = self:CollectAlertBaseInfo(PlayerChar)
  if BaseAlertInfo.DungeonId then
    AlertString = AlertString .. "副本ID: " .. BaseAlertInfo.DungeonId .. "  "
  end
  if BaseAlertInfo.DungeonLevel then
    AlertString = AlertString .. "副本等级: " .. BaseAlertInfo.DungeonLevel .. "  "
  end
  if BaseAlertInfo.CharLevel then
    AlertString = AlertString .. "角色等级: " .. BaseAlertInfo.CharLevel .. "  "
  end
  if MonitorType then
    AlertString = AlertString .. "MonitorType: " .. MonitorType .. "  "
  end
  if SubId then
    AlertString = AlertString .. "SubID: " .. SubId .. "  "
  end
  if DungeonSpendTime then
    AlertString = AlertString .. "副本耗时: " .. DungeonSpendTime .. "  "
  end
  if TimeThresh then
    AlertString = AlertString .. "时间阈值: " .. TimeThresh .. "  "
  end
  if DungeonMoveDistance then
    AlertString = AlertString .. "主控角色移动距离: " .. DungeonMoveDistance .. "  "
  end
  if DisThresh then
    AlertString = AlertString .. "距离阈值: " .. DisThresh .. "  "
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  print(_G.LogTag, "SendTimeDistCheatalert", AlertString)
  Avatar:SendToFeishuForCombatMonitor(AlertString)
end

function BP_EMGameMode_C:CollectAlertBaseInfo(PlayerChar)
  local AlertInfo = {}
  if not self.LevelGameMode then
    print(_G.LogTag, "CollectAlertBaseInfo LevelGameMode is nil")
    return AlertInfo
  end
  AlertInfo.DungeonId = self.LevelGameMode.DungeonId
  local DungeonInfo = DataMgr.Dungeon[AlertInfo.DungeonId]
  if not DungeonInfo then
    print(_G.LogTag, "CollectAlertBaseInfo DungeonInfo is nil", AlertInfo.DungeonId, self.DungeonId)
    return AlertInfo
  end
  AlertInfo.DungeonLevel = DungeonInfo.DungeonLevel or 1
  AlertInfo.CharLevel = PlayerChar:GetAttr("Level") or 0
  print(_G.LogTag, "CollectAlertBaseInfo", AlertInfo.DungeonId, AlertInfo.DungeonLevel, AlertInfo.CharLevel, PlayerChar:GetAttr("Level"))
  return AlertInfo
end

function BP_EMGameMode_C:NotifyClientFightAttributeData(PlayerCharacter)
  if not IsDedicatedServer(self) then
    return
  end
  local FightAttributeSet = PlayerCharacter and PlayerCharacter:GetFightAttributeSet()
  if not FightAttributeSet then
    return
  end
  for i = 1, self:GetPlayerNum() do
    local ControllerIndex = i - 1
    local Controller = UE4.UGameplayStatics.GetPlayerController(self, ControllerIndex)
    local Teammate = Controller:GetMyPawn()
    if Teammate and Teammate.Eid ~= PlayerCharacter.Eid then
      local TeammateInfo = FTeammateAttrInfo()
      TeammateInfo.TeammateEid = Teammate.Eid
      TeammateInfo.FinalDamage = Teammate:GetFinalDamage()
      TeammateInfo.TotalKillCount = Teammate:GetTotalKillCount()
      TeammateInfo.TakedDamage = Teammate:GetTakedDamage()
      TeammateInfo.GiveHealing = Teammate:GetGiveHealing()
      TeammateInfo.MaxDamage = Teammate:GetMaxDamage()
      TeammateInfo.BreakableItemCount = Teammate:GetBreakableItemCount()
      TeammateInfo.MaxComboCount = Teammate:GetMaxComboCount()
      local PhantomAttrInfos = Teammate:GetPhantomAttrInfos()
      if PhantomAttrInfos:Num() > 0 then
        TeammateInfo.PhantomAttrInfo = PhantomAttrInfos[1]
      end
      FightAttributeSet:AddTeammateDamageInfos(TeammateInfo)
    end
  end
  FightAttributeSet:RefreshFightAttributeData()
end

function BP_EMGameMode_C:NotifyClientGameEnd(IsWin, AvatarEids)
  if not AvatarEids or 0 == #AvatarEids then
    for i = 1, self:GetPlayerNum() do
      local ControllerIndex = i - 1
      local Controller = UE4.UGameplayStatics.GetPlayerController(self, ControllerIndex)
      if not Controller then
        error("Controller is Not Exist")
      end
      local Avatar = GWorld:GetAvatar()
      if IsWin and (not Avatar or not Avatar:IsInHardBoss()) then
        self:UpdatePlayerCharacterEndPointInfo(ControllerIndex, Controller)
        DebugPrint("StartAndEndPoint AllSuccess UpdatePlayerCharacterEndPointInfo")
      end
      local MyPawn = Controller:GetMyPawn()
      if IsStandAlone(self) then
        DebugPrint("StartAndEndPoint AllSuccess NotifyClientGameEnd_Lua")
        Controller:NotifyClientGameEnd_Lua(IsWin, self:GetScenePlayersInfo(MyPawn))
      else
        DebugPrint("StartAndEndPoint AllSuccess NotifyClientGameEnd")
        self:NotifyClientFightAttributeData(MyPawn)
        Controller:NotifyClientGameEnd(IsWin, self:GetScenePlayersInfo(MyPawn))
      end
    end
  else
    local function EndAvatar(AvatarEid)
      local Controller = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerByAvatarEid(self, AvatarEid)
      
      if not Controller then
        DebugPrint("Controller is Not Exist")
        return
      end
      if IsWin then
        local ControllerIndex = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerIndex(self, Controller)
        self:UpdatePlayerCharacterEndPointInfo(ControllerIndex, Controller)
        DebugPrint("StartAndEndPoint PartSuccess UpdatePlayerCharacterEndPointInfo")
      end
      DebugPrint("StartAndEndPoint PartSuccess NotifyClientGameEnd")
      local MyPawn = Controller:GetMyPawn()
      self:NotifyClientFightAttributeData(MyPawn)
      Controller:NotifyClientGameEnd(IsWin, self:GetScenePlayersInfo(MyPawn))
    end
    
    for _, AvatarEid in ipairs(AvatarEids) do
      EndAvatar(AvatarEid)
    end
  end
end

function BP_EMGameMode_C:SimplifyInfoForInit(InfoForInit)
  if nil == InfoForInit then
    DebugPrint("Error SimplifyInfoForInit InfoForInit is nil")
    return InfoForInit
  end
  InfoForInit.FromOtherWorld = true
  return InfoForInit
end

function BP_EMGameMode_C:GetScenePlayersInfo(MainPlayer)
  local PlayersInfo = {}
  if self.EMGameState.GameModeType == "Party" then
    local Ordinal = self.EMGameState.PartyPlayerOrdinal
    for i = 1, Ordinal:Length() do
      local TargetEid = Ordinal[i]
      local TargetCharacter = Battle(self):GetEntity(TargetEid)
      if TargetCharacter then
        local bIsPhantom = TargetCharacter:IsPhantom()
        PlayersInfo[#PlayersInfo + 1] = self:SimplifyInfoForInit(TargetCharacter.InfoForInit)
        PlayersInfo[#PlayersInfo].IsDungeonEnd = true
        PlayersInfo[#PlayersInfo].IsPhantom = bIsPhantom
        local PlayerWeapon = TargetCharacter:GetCurrentWeapon()
        if PlayerWeapon then
          PlayersInfo[#PlayersInfo].CurrentWeaponType = PlayerWeapon:GetWeaponType()
          PlayersInfo[#PlayersInfo].CurrentWeaponMeleeOrRanged = PlayerWeapon:GetWeaponMeleeOrRanged()
        end
        if MainPlayer.Eid == TargetEid then
          PlayersInfo[#PlayersInfo].IsMainPlayer = true
        else
          PlayersInfo[#PlayersInfo].IsMainPlayer = false
          PlayersInfo[#PlayersInfo].IsSettlementOtherRole = true
        end
      end
    end
  else
    PlayersInfo[1] = self:SimplifyInfoForInit(MainPlayer.InfoForInit)
    PlayersInfo[1].IsDungeonEnd = true
    PlayersInfo[1].IsMainPlayer = true
    PlayersInfo[1].IsDead = MainPlayer:IsDead()
    local MainPlayerWeapon = MainPlayer:GetCurrentWeapon()
    if MainPlayerWeapon then
      PlayersInfo[1].CurrentWeaponType = MainPlayerWeapon:GetWeaponType()
      PlayersInfo[1].CurrentWeaponMeleeOrRanged = MainPlayerWeapon:GetWeaponMeleeOrRanged()
    end
    print(_G.LogTag, "GetScenePlayersInfo", MainPlayer:GetAllTeammates():Length())
    for _, v in pairs(MainPlayer:GetAllTeammates()) do
      if v ~= MainPlayer then
        local InitInfo = v.InfoForInit
        if nil == InitInfo then
          local Context = v.CreateUnitContextCopy
          InitInfo = Context:GetLuaTable("AvatarInfo")
        end
        local bIsPhantom = v:IsPhantom()
        PlayersInfo[#PlayersInfo + 1] = self:SimplifyInfoForInit(InitInfo)
        PlayersInfo[#PlayersInfo].IsDungeonEnd = true
        PlayersInfo[#PlayersInfo].IsPhantom = bIsPhantom
        PlayersInfo[#PlayersInfo].IsMainPlayer = false
        PlayersInfo[#PlayersInfo].IsSettlementOtherRole = true
        PlayersInfo[#PlayersInfo].IsDead = v:IsDead()
        local CurrentPlayerWeapon = v:GetCurrentWeapon()
        if CurrentPlayerWeapon then
          PlayersInfo[#PlayersInfo].CurrentWeaponType = CurrentPlayerWeapon:GetWeaponType()
          PlayersInfo[#PlayersInfo].CurrentWeaponMeleeOrRanged = CurrentPlayerWeapon:GetWeaponMeleeOrRanged()
        end
      end
    end
  end
  local MsgStr = msgpack.pack(PlayersInfo)
  local RewardsMessage = FMessage()
  RewardsMessage:SetBytes(MsgStr, #MsgStr)
  return RewardsMessage
end

function BP_EMGameMode_C:TriggerEnterEndPlayer(AvatarEidStr)
  local PlayerController = UE4.URuntimeCommonFunctionLibrary.GetPlayerControllerByAvatarEid(self, AvatarEidStr)
  if PlayerController and PlayerController:IsPlayEnd() then
    DebugPrint("TriggerEnterEndPlayer 玩家已结算：", AvatarEidStr)
    local DSEntity = GWorld:GetDSEntity()
    assert(DSEntity)
    local LeaveResult = rawget(DSEntity.HasLeaveAvatars, AvatarEidStr)
    self:NotifyClientGameEnd(LeaveResult, {AvatarEidStr})
  else
    DebugPrint("TriggerEnterEndPlayer 副本已结束但玩家未结算：", AvatarEidStr)
    self:ForceFinishPlayerByFailed({AvatarEidStr})
  end
end

function BP_EMGameMode_C:OnMiniGameSuccess(MiniGameType, CreatorId)
  self.Overridden.OnMiniGameSuccess(self, MiniGameType, CreatorId)
  self:TriggerDungeonComponentFun("OnMiniGameSuccess", MiniGameType, CreatorId)
end

function BP_EMGameMode_C:OnDefenceCoreActive(DefenceCore)
  self.Overridden.OnDefenceCoreActive(self, DefenceCore)
  self:TriggerDungeonComponentFun("OnDefenceCoreActive", DefenceCore)
end

function BP_EMGameMode_C:OnMiniGameFail(MiniGameType, CreatorId)
  if not self:IsSubGameMode() then
    if not self.MiniGameFailedTime[MiniGameType] then
      self.MiniGameFailedTime[MiniGameType] = 0
    end
    self.MiniGameFailedTime[MiniGameType] = self.MiniGameFailedTime[MiniGameType] + 1
  end
  self.Overridden.OnMiniGameFail(self, MiniGameType, CreatorId)
end

function BP_EMGameMode_C:OnDefenceCoreDead(Eid)
  self.Overridden.OnDefenceCoreDead(self, Eid)
end

function BP_EMGameMode_C:ChangeFallTriggersActive(FallTriggerIds, Active)
  for i, FallTriggerId in pairs(FallTriggerIds) do
    for j, FallTrigger in pairs(self.EMGameState.FallTriggersArray) do
      if FallTrigger.FallTriggerId == FallTriggerId then
        FallTrigger.Active = Active
      end
    end
  end
end

function BP_EMGameMode_C:AsyncLoadTargetLevel(LoadLevel, NewTargetPointName)
  local function Callback()
    LoadLevel:AsyncPrintHello()
  end
  
  local NewTargetPoint = self.EMGameState:GetTargetPoint(NewTargetPointName)
  if not IsValid(NewTargetPoint) then
    self:AddTimer(0.1, Callback)
    return
  end
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not self:GetLevelLoader() then
    self:AddTimer(0.1, Callback)
    return
  end
  local TargetLevelId = self:GetLevelLoader():GetLevelIdByLocation(NewTargetPoint:K2_GetActorLocation())
  local CurrentLevelId = self:GetLevelLoader():GetLevelIdByLocation(PlayerCharacter:K2_GetActorLocation())
  if not (TargetLevelId and CurrentLevelId) or TargetLevelId == CurrentLevelId then
    self:AddTimer(0.1, Callback)
    return
  end
  local LevelLoader = self:GetLevelLoader()
  
  local function LoadLevelCallBack()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    GameInstance:CloseLoadingUI()
    LoadLevel:AsyncPrintHello()
    if LevelLoader then
      LevelLoader:RemoveArtLevelLoadedCompleteCallback(TargetLevelId)
    end
  end
  
  LevelLoader:BindArtLevelLoadedCompleteCallback(TargetLevelId, LoadLevelCallBack)
  LevelLoader:LoadArtLevel(TargetLevelId)
end

function BP_EMGameMode_C:SetActorLocationAndRotationByTransform(UnitId, Transform, bIsForceIdle, bDoCorrect)
  bDoCorrect = bDoCorrect or false
  local PlayerCharacter, FinalLocation
  if 0 == UnitId then
    PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  else
    PlayerCharacter = self.EMGameState.NpcCharacterMap:FindRef(UnitId)
  end
  if not IsValid(PlayerCharacter) then
    print(_G.LogTag, " ZJT_PlayerCharacter Or NewTargetPoint Is NUll !")
    return false
  end
  local TargetPointLoc = Transform.Translation
  local TargetPointRot = Transform.Rotation:ToRotator()
  FinalLocation = TargetPointLoc
  if bDoCorrect then
    local CapsuleHalfHeight = PlayerCharacter.CapsuleComponent:GetScaledCapsuleHalfHeight()
    local CapsuleRadius = PlayerCharacter.CapsuleComponent:GetScaledCapsuleRadius()
    local HitResult = FHitResult()
    local LineHitResult = FHitResult()
    local StartPos = TargetPointLoc + FVector(0, 0, CapsuleHalfHeight)
    local EndPos = TargetPointLoc + FVector(0, 0, -2 * CapsuleHalfHeight)
    local bHit = UE4.UKismetSystemLibrary.CapsuleTraceSingle(self, StartPos, EndPos, CapsuleRadius, CapsuleHalfHeight, ETraceTypeQuery.TraceScene, false, nil, 0, HitResult, true)
    if bHit then
      local tmp = FVector(HitResult.Location.X, HitResult.Location.Y, HitResult.ImpactPoint.Z + CapsuleHalfHeight + 2)
      FinalLocation = tmp
    end
  end
  if bIsForceIdle and not PlayerCharacter:IsDead() then
    self:SetPlayerCharacterForceIdle(PlayerCharacter)
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode:GetLevelLoader() then
    local TargetLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(TargetPointLoc)
    local CurrentLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(PlayerCharacter:K2_GetActorLocation())
    PlayerCharacter:K2_SetActorLocationAndRotation(FinalLocation, TargetPointRot, false, nil, false)
    if TargetLevelId and CurrentLevelId and CurrentLevelId ~= TargetLevelId then
      GameMode:GetLevelLoader():UnloadArtLevel(CurrentLevelId)
    end
  else
    PlayerCharacter:K2_SetActorLocationAndRotation(FinalLocation, TargetPointRot, false, nil, false)
  end
  return true
end

function BP_EMGameMode_C:EMSetActorLocationAndRotation(UnitId, NewTargetPointName, bIsForceIdle, bDoCorrect)
  bDoCorrect = bDoCorrect or false
  local PlayerCharacter, NewTargetPoint, FinalLocation
  print(_G.LogTag, " ZJT_ EMSetActorLocationAndRotation ", UnitId, NewTargetPointName, bIsForceIdle)
  if "" == NewTargetPointName then
    return false
  end
  NewTargetPoint = self.EMGameState:GetTargetPoint(NewTargetPointName)
  if not NewTargetPoint then
    return false
  end
  if 0 == UnitId then
    PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  else
    PlayerCharacter = self.EMGameState.NpcCharacterMap:FindRef(UnitId)
  end
  if not IsValid(PlayerCharacter) or not IsValid(NewTargetPoint) then
    print(_G.LogTag, " ZJT_PlayerCharacter Or NewTargetPoint Is NUll !")
    return false
  end
  local TargetPointLoc = NewTargetPoint:K2_GetActorLocation()
  FinalLocation = TargetPointLoc
  if bDoCorrect then
    local CapsuleHalfHeight = PlayerCharacter.CapsuleComponent:GetScaledCapsuleHalfHeight()
    local CapsuleRadius = PlayerCharacter.CapsuleComponent:GetScaledCapsuleRadius()
    local HitResult = FHitResult()
    local LineHitResult = FHitResult()
    local StartPos = TargetPointLoc + FVector(0, 0, CapsuleHalfHeight)
    local EndPos = TargetPointLoc + FVector(0, 0, -2 * CapsuleHalfHeight)
    local bHit = UE4.UKismetSystemLibrary.CapsuleTraceSingle(self, StartPos, EndPos, CapsuleRadius, CapsuleHalfHeight, ETraceTypeQuery.TraceScene, false, nil, 0, HitResult, true)
    if bHit then
      local tmp = FVector(HitResult.Location.X, HitResult.Location.Y, HitResult.ImpactPoint.Z + CapsuleHalfHeight + 2)
      FinalLocation = tmp
    end
  end
  if bIsForceIdle and not PlayerCharacter:IsDead() then
    self:SetPlayerCharacterForceIdle(PlayerCharacter)
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode:GetLevelLoader() then
    local TargetLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(NewTargetPoint:K2_GetActorLocation())
    local CurrentLevelId = GameMode:GetLevelLoader():GetLevelIdByLocation(PlayerCharacter:K2_GetActorLocation())
    PlayerCharacter:K2_SetActorLocationAndRotation(FinalLocation, NewTargetPoint:K2_GetActorRotation(), false, nil, false)
    if TargetLevelId and CurrentLevelId and CurrentLevelId ~= TargetLevelId then
      GameMode:GetLevelLoader():UnloadArtLevel(CurrentLevelId)
    end
  else
    PlayerCharacter:K2_SetActorLocationAndRotation(FinalLocation, NewTargetPoint:K2_GetActorRotation(), false, nil, false)
  end
  return true
end

function BP_EMGameMode_C:SetPlayerCharacterForceIdle(PlayerCharacter)
  PlayerCharacter:ResetIdle()
  PlayerCharacter:DisableInput(UE4.UGameplayStatics.GetPlayerController(self, 0))
  
  local function EnablePlayerInput()
    PlayerCharacter:EnableInput(UE4.UGameplayStatics.GetPlayerController(self, 0))
  end
  
  self:AddTimer(0.2, EnablePlayerInput)
end

function BP_EMGameMode_C:GetRespawnRuleName(Target)
  DebugPrint("Tianyi@ GetRespawnRuleName begin")
  local RespawnRuleName = "Default"
  local CurrentDungeonId = self.DunegeonId
  if not CurrentDungeonId then
    DebugPrint("Tianyi@ GetRespawnRuleName: CurrentDungeonId is nil, Try to get it from gameinstance")
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    CurrentDungeonId = GameInstance:GetCurrentDungeonId()
  end
  if IsDedicatedServer(self) then
    local DungeonData = DataMgr.Dungeon[CurrentDungeonId]
    if DungeonData and DungeonData.RespawnRule then
      RespawnRuleName = DungeonData.RespawnRule
    end
    return RespawnRuleName
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint("Tianyi@ GetRespawnRuleName: Avatar is nil")
    return RespawnRuleName
  end
  if Target and Target.IsHostage then
    RespawnRuleName = "Hostage"
    return RespawnRuleName
  end
  if Avatar:IsInDungeon2() then
    if not CurrentDungeonId then
      DebugPrint("GetRespawnRuleName: Tianyi@ DungeonId is nil")
      return RespawnRuleName
    end
    local DungeonData = DataMgr.Dungeon[CurrentDungeonId]
    if DungeonData and DungeonData.RespawnRule then
      RespawnRuleName = DungeonData.RespawnRule
    end
  elseif Avatar:IsInBigWorld() then
    DebugPrint("Tianyi@ GetRespawnRuleName: Player in bigworld")
    if Avatar:IsInHardBoss() then
      RespawnRuleName = "HardBoss"
    else
      RespawnRuleName = "CommonRegion"
    end
  end
  DebugPrint("Tianyi@ GetRespawnRuleName: RespawnRuleName = " .. RespawnRuleName)
  return RespawnRuleName
end

function BP_EMGameMode_C:GetRespawnRule(Target, TargetRespawnRule)
  local RespawnRule
  if TargetRespawnRule then
    RespawnRule = DataMgr.RespawnRule[TargetRespawnRule]
    return RespawnRule or DataMgr.RespawnRule.CommonSolo
  end
  return DataMgr.RespawnRule[self:GetRespawnRuleName(Target)]
end

function BP_EMGameMode_C:InitEntityRecoveryData(Entity)
  Entity:ClearSkillRecoverTargets()
  Entity:SetAttr("AdditionalRecoverTime", 0)
  if Entity:IsPlayer() then
    self:InitPlayerReocveryData(Entity)
  elseif Entity:IsPhantom() then
    self:InitPhantomRecoveryData(Entity)
  end
end

function BP_EMGameMode_C:CheckEntityCanRecover(Entity)
  if Entity:IsPlayer() then
    return self:CheckPlayerCanRecover(Entity)
  elseif Entity:IsPhantom() then
    return self:CheckPhantomCanRecover(Entity)
  elseif Entity:IsMonster() then
    return self:CheckMonsterCanRecover(Entity)
  else
    return true
  end
end

function BP_EMGameMode_C:CheckPlayerCanRecover(Player)
  local RecoveryCount = Player:GetRecoveryCount()
  local RecoveryMaxCount = Player:GetRecoveryMaxCount()
  return RecoveryMaxCount < 0 or RecoveryCount < RecoveryMaxCount
end

function BP_EMGameMode_C:CheckPhantomCanRecover(Phantom)
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar:IsRealInBigWorld() and not Avatar:IsInHardBoss() then
    return false
  end
  local RecoveryCount = Phantom:GetRecoveryCount()
  local RecoveryMaxCount = Phantom:GetRecoveryMaxCount()
  return RecoveryMaxCount < 0 or RecoveryCount < RecoveryMaxCount
end

function BP_EMGameMode_C:CheckMonsterCanRecover(Monster)
  return true
end

function BP_EMGameMode_C:TriggerGenerateReward(RewardId, Reason, Transform, ExtraInfo)
  if RewardId.ToTable then
    RewardId = RewardId:ToTable()
  end
  self.EMGameState.EventMgr:TriggerGenerateReward(RewardId, Reason, Transform, ExtraInfo)
end

function BP_EMGameMode_C:ActiveMonsterBuff(BuffList, BuffNum)
  if not self.MonsterAddBuffRule then
    self.MonsterAddBuffRule = {}
  end
  table.insert(self.MonsterAddBuffRule, {BuffList = BuffList, BuffNum = BuffNum})
end

function BP_EMGameMode_C:DestroyMonsterBuff()
  self.MonsterAddBuffRule = nil
end

function BP_EMGameMode_C:TriggerMechanismFieldCreature(TrapArrayId, Grade, TrapState, TrapType, Scale)
  for i = 1, TrapArrayId:Length() do
    local ManualItemId = TrapArrayId:GetRef(i)
    local FieldCreatureMechan = self.EMGameState.FeildCreatureMap:FindRef(ManualItemId)
    if not FieldCreatureMechan then
      print(_G.LogTag, "ZJT_ TriggerMechanismFieldCreature ", ManualItemId, Grade, TrapState, TrapType, Scale)
    else
      FieldCreatureMechan:SetFieldCreateMechanismInfo(TrapState, TrapType, Scale, Grade)
    end
  end
end

function BP_EMGameMode_C:HideUIInScreen(UIPath, IsHide)
  if not self.EMGameState then
    return
  end
  self.EMGameState:HideUIInScreen(UIPath, IsHide)
end

function BP_EMGameMode_C:SetContinuedPCGuideVisibility(ActionName, IsHide)
  if not self.EMGameState then
    return
  end
  self.EMGameState:RealSetContinuedPCGuideVisibility(ActionName, IsHide)
end

function BP_EMGameMode_C:UpdatePlayerCharacterEndPointInfo(PlayerControllerIndex, PlayerController)
  PlayerController = PlayerController or UE4.UGameplayStatics.GetPlayerController(PlayerControllerIndex)
  local PlayerCharacter = PlayerController:GetMyPawn()
  local EndPointActor = self.EMGameState.EndPointActor
  if not IsValid(EndPointActor) then
    DebugPrint("StartAndEndPoint No End EndPoint")
    PlayerCharacter:SetEndPointInfo(true, nil, nil)
    return
  end
  local EndPointTransform = EndPointActor:GetTransform(PlayerControllerIndex)
  local EndPointLocation = EndPointTransform.Translation
  local EndPointRotation = FRotator(EndPointTransform.Rotation)
  local Dis = (PlayerCharacter:K2_GetActorLocation() - EndPointLocation):Size()
  if Dis <= 1000 then
    PlayerCharacter:SetEndPointInfo(true, EndPointLocation, EndPointRotation)
  else
    PlayerCharacter:SetEndPointInfo(false, EndPointLocation, EndPointRotation)
  end
end

function BP_EMGameMode_C:AddPickUpSuccessCallback(ItemId, CallbackKey, Callback)
  if not self.PickUpSuccessCallback then
    self.PickUpSuccessCallback = {}
  end
  if not self.PickUpSuccessCallback[ItemId] then
    self.PickUpSuccessCallback[ItemId] = {}
  end
  self.PickUpSuccessCallback[ItemId][CallbackKey] = Callback
end

function BP_EMGameMode_C:RemovePickUpSuccessCallback(ItemId, CallbackKey)
  if self.PickUpSuccessCallback and self.PickUpSuccessCallback[ItemId] then
    self.PickUpSuccessCallback[ItemId][CallbackKey] = nil
  end
end

function BP_EMGameMode_C:AddMiniGameSuccessCallback(DisplayName, Callback)
  if not self.MiniGameSuccessCallback then
    self.MiniGameSuccessCallback = {}
  end
  self.MiniGameSuccessCallback[DisplayName] = Callback
end

function BP_EMGameMode_C:RemoveMiniGameSuccessCallback(DisplayName, Callback)
  if self.MiniGameSuccessCallback then
    self.MiniGameSuccessCallback[DisplayName] = nil
  end
end

function BP_EMGameMode_C:RunStory(StoryPath, QuestId, EndCallback, StopCallback)
  DebugPrint("StoryPathStoryPathStoryPathStoryPath", StoryPath)
  GWorld.StoryMgr:RunStory(StoryPath, QuestId, nil, EndCallback, StopCallback)
end

function BP_EMGameMode_C:PickUpForAllPlayers(FunctionName, PickUpCount, UseParam, UnitId, Transform, AvatarEid, bExtra)
  for i = 0, self:GetPlayerNum() - 1 do
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, i)
    local PlayerCharacter = PlayerController:GetMyPawn()
    PlayerCharacter[FunctionName](PlayerCharacter, PickUpCount, UseParam, UnitId, Transform, AvatarEid, bExtra)
  end
end

function BP_EMGameMode_C:CollectGameModeTimerHandle(Handle)
  if not self.GameModeTimerSet then
    self.GameModeTimerSet = UE4.TSet(UE4.FTimerHandle())
  end
  self.GameModeTimerSet:Add(Handle)
end

function BP_EMGameMode_C:PauseGameModeTimer()
  self.CurPauseGameModeTimerMap = {}
  if self.GameModeTimerSet and self.GameModeTimerSet:Num() > 0 then
    local DelArray = {}
    local TmpArray = self.GameModeTimerSet:ToArray()
    for i = 1, TmpArray:Num() do
      local Handle = TmpArray[i]
      if not UE4.UKismetSystemLibrary.K2_TimerExistsHandle(self, Handle) then
        table.insert(DelArray, Handle)
      else
        self.CurPauseGameModeTimerMap[Handle] = true
        UE4.UKismetSystemLibrary.K2_PauseTimerHandle(self, Handle)
        UE4.UKismetSystemLibrary.K2_TimerExistsHandle(self, Handle)
      end
    end
    for i = 1, #DelArray do
      self.GameModeTimerSet:Remove(DelArray[i])
    end
  end
end

function BP_EMGameMode_C:UnPauseGameModeTimer()
  if self.CurPauseGameModeTimerMap == nil or IsEmptyTable(self.CurPauseGameModeTimerMap) then
    return
  end
  for Handle, _ in pairs(self.CurPauseGameModeTimerMap) do
    if UE4.UKismetSystemLibrary.K2_TimerExistsHandle(self, Handle) then
      UE4.UKismetSystemLibrary.K2_UnPauseTimerHandle(self, Handle)
    end
  end
  self.CurPauseGameModeTimerMap = {}
end

function BP_EMGameMode_C:GetActor2ManualId(ManualItemId)
  local ManualItemActor = self.LevelGameMode.BPBornRegionActor:FindRef(ManualItemId)
  return ManualItemActor
end

function BP_EMGameMode_C:TriggerMechanismWindCreator(ManualArrayId, Grade, IsActive)
  for i = 1, ManualArrayId:Length() do
    local ManualItemId = ManualArrayId:GetRef(i)
    local WindCreatorMechanism = self.LevelGameMode.BPBornRegionActor:FindRef(ManualItemId)
    if WindCreatorMechanism then
      WindCreatorMechanism:SetWindCreator(Grade, IsActive)
    else
      print(_G.LogTag, "ZJT_ TriggerMechanismWindCreator ", Grade, IsActive)
    end
  end
end

function BP_EMGameMode_C:EMActorDestroy_Lua(Actor, DestroyReason)
  Actor:EMActorDestroy(DestroyReason)
end

function BP_EMGameMode_C:GetMonsterCustomLoc(Monster)
  if self:IsInRegion() then
    DebugPrint("Error!!! 区域出现Boss被卸载瞬移！请检查！ ViewLocation : ", URuntimeCommonFunctionLibrary.GetViewPortLocation(Monster))
    return FVector(0, 0, 0)
  end
  local PlayerTarget
  if IsValid(Monster) and IsValid(Monster.BBTarget) then
    PlayerTarget = Monster.BBTarget
  else
    PlayerTarget = self:GetOneRandomPlayer()
  end
  if self.TacMapManager then
    local PresetTargetsInfo = {}
    PresetTargetsInfo[PlayerTarget] = 1
    local ResLocs = self.TacMapManager:GetSpawnPoints({
      PresetTargets = PresetTargetsInfo,
      Mode = "Player",
      UnitSpawnRadiusMin = 1000,
      UnitSpawnRadiusMax = 5000,
      RandomSpawn = true,
      FilterReachable = true
    })
    if 0 == ResLocs[PlayerTarget].Num then
      return FVector(0, 0, 0)
    end
    return ResLocs[PlayerTarget][1]
  else
    local CheckInfo = FPointCheckInfo()
    CheckInfo:SetCheckInfo(1000, 5000, true, true, true)
    local ResLoc = self.FixedMonsterSpawn:GetSpawnPointLocations(PlayerTarget, CheckInfo)
    if 0 == ResLoc:Num() then
      return FVector(0, 0, 0)
    end
    return ResLoc[1]
  end
end

function BP_EMGameMode_C:UploadTargetValues(TargetValues, AvatarEid)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:TriggerTarget(TargetValues)
    return
  end
  local DSEntity = GWorld:GetDSEntity()
  if DSEntity then
    DSEntity:TriggerTarget(TargetValues, AvatarEid)
  end
end

function BP_EMGameMode_C:GetAvatarInfo(Eid)
  if IsStandAlone(self) or MiscUtils.IsListenServer(self) then
    return GWorld:GetAvatar()
  elseif IsDedicatedServer(self) then
    if Eid then
      return self.AvatarInfos[Eid].PlayerInfo
    end
    for AvatarEid, AvatarBattleInfo in pairs(self.AvatarInfos) do
      if AvatarBattleInfo then
        return AvatarBattleInfo.PlayerInfo
      end
    end
  end
end

function BP_EMGameMode_C:TriggerSpawnPet()
  if self.EMGameState.PetDefenceFail == true then
    self.EMGameState:ShowDungeonError("TriggerSpawnPet 宠物防御已经失败，不再创建", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Process)
    return
  end
  if not self.RandomPetCreator or not IsValid(self.RandomPetCreator) then
    local PetCreatorInfos = self:GetPetStaticCreatorInfo()
    if 0 == PetCreatorInfos:Num() then
      self.EMGameState:ShowDungeonError("TriggerSpawnPet 当前拼接副本内找不到宠物静态点，请检查配置！", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.Config)
      return
    end
    self.RandomPetCreator = self:GetPetCreatorNearestToFirstPlayer(PetCreatorInfos)
    if not IsValid(self.RandomPetCreator) then
      self.EMGameState:ShowDungeonError("TriggerSpawnPet 选择宠物静态点失败！", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
      return
    end
  end
  local SubLevelName = self:GetActorLevelName(self.RandomPetCreator)
  local SubGameMode = self.SubGameModeInfo:FindRef(SubLevelName)
  if not IsValid(SubGameMode) then
    self.EMGameState:ShowDungeonError("TriggerSpawnPet 创建宠物静态点找不到SubGameMode StaticCreatorId: " .. self.RandomPetCreator.StaticCreatorId .. "SubLevelName: " .. tostring(SubLevelName), Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
    return
  end
  SubGameMode.PetActiveLevel = true
  SubGameMode.RandomPetDefenceCoreId = self.DungeonRandomEventDefenceCoreId
  SubGameMode.RandomPetId = self.DungeonRandomEventPetId
  self.RandomPetCreator.UnitId = self.DungeonRandomEventPetId
  self.RandomPetCreator.UnitType = "Pet"
  DebugPrint("BP_EMGameMode_C:TriggerSpawnPet 创建宠物 StaticCreatorId", self.RandomPetCreator.StaticCreatorId, "UnitId", self.RandomPetCreator.UnitId)
  self:TriggerActiveCustomStaticCreator(self.RandomPetCreator.StaticCreatorId, "DungeonPetSpawn", true, SubLevelName)
  self.RandomPetCreator.UnitId = self.DungeonRandomEventDefenceCoreId
  self.RandomPetCreator.UnitType = "Mechanism"
  DebugPrint("BP_EMGameMode_C:TriggerSpawnPet 创建宠物防御核心 StaticCreatorId", self.RandomPetCreator.StaticCreatorId, "UnitId", self.RandomPetCreator.UnitId)
  self:TriggerActiveCustomStaticCreator(self.RandomPetCreator.StaticCreatorId, "DungeonPetDefSpawn", true, SubLevelName)
  self.PetMonsterCreated = true
end

function BP_EMGameMode_C:GetPetCreatorNearestToExit(PetCreatorInfos)
  local LevelLoader = self:GetLevelLoader()
  if not LevelLoader then
    self.EMGameState:ShowDungeonError("TriggerSpawnPet 拿不到LevelLoader", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
    return nil
  end
  local ExitLevelLoc = LevelLoader:GetExitLevelLocation()
  local MinSquaredDis = math.huge
  local NearestCreator
  for i = 1, PetCreatorInfos:Num() do
    local Creator = PetCreatorInfos[i]
    if Creator then
      local CreatorLoc = Creator:K2_GetActorLocation()
      local SquaredDis = UE4.UKismetMathLibrary.Vector_DistanceSquared(ExitLevelLoc, CreatorLoc)
      if MinSquaredDis > SquaredDis then
        MinSquaredDis = SquaredDis
        NearestCreator = Creator
      end
    end
  end
  return NearestCreator
end

function BP_EMGameMode_C:GetPetCreatorNearestToFirstPlayer(PetCreatorInfos)
  local LevelLoader = self:GetLevelLoader()
  if not LevelLoader then
    self.EMGameState:ShowDungeonError("TriggerSpawnPet 拿不到LevelLoader", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
    return nil
  end
  local Players = self:GetAllPlayer()
  if not Players or Players:Length() <= 0 then
    self.EMGameState:ShowDungeonError("TriggerSpawnPet 获取不到Players", Const.DungeonErrorType.Pet, Const.DungeonErrorTitle.FindObject)
    return nil
  end
  local Player = Players:GetRef(1)
  local PlayerLoc = Player:K2_GetActorLocation()
  local MinSquaredDis = math.huge
  local NearestCreator
  for i = 1, PetCreatorInfos:Num() do
    local Creator = PetCreatorInfos[i]
    if Creator then
      local CreatorLoc = Creator:K2_GetActorLocation()
      local SquaredDis = UE4.UKismetMathLibrary.Vector_DistanceSquared(PlayerLoc, CreatorLoc)
      if MinSquaredDis > SquaredDis then
        MinSquaredDis = SquaredDis
        NearestCreator = Creator
      end
    end
  end
  return NearestCreator
end

function BP_EMGameMode_C:ShowPetDefenseDynamicEvent(EventName, EventDescribe, EventSuccess, EventFail)
  self.EMGameState:SetPetEventName(EventName)
  self.EMGameState:SetPetEventDescribe(EventDescribe)
  self.EMGameState:SetPetEventSuccess(EventSuccess)
  self.EMGameState:SetPetEventFail(EventFail)
  self.LevelGameMode:AddDungeonEvent("ShowPetDefenseDynamicEvent")
end

function BP_EMGameMode_C:ShowPetDefenseProgress(EventName, EventDescribe, EventSuccess, EventFail)
  self.EMGameState:SetPetEventName(EventName)
  self.EMGameState:SetPetEventDescribe(EventDescribe)
  if self:IsSubGameMode() then
    self.EMGameState:SetPetDefenceCoreId(self.RandomPetDefenceCoreId)
    self.EMGameState:SetPetId(self.RandomPetId)
  else
    self.EMGameState:SetPetDefenceCoreId(self.DungeonRandomEventDefenceCoreId)
    self.EMGameState:SetPetId(self.DungeonRandomEventPetId)
  end
  self.EMGameState:SetPetEventSuccess(EventSuccess)
  self.EMGameState:SetPetEventFail(EventFail)
  self.LevelGameMode:AddDungeonEvent("ShowPetDefenseProgress")
end

function BP_EMGameMode_C:HidePetDefenseProgress(Success)
  self.EMGameState:SetPetSuccess(Success)
  self.EMGameState:SetPetDefenceFail(not Success)
  self.LevelGameMode:RemoveDungeonEvent("ShowPetDefenseDynamicEvent")
  self.LevelGameMode:RemoveDungeonEvent("ShowPetDefenseProgress")
  self.LevelGameMode:RemoveDungeonEvent("PetPlayFailureMontage")
  if Success then
    self.EMGameState:PetAddGuideAllPlayer()
  end
end

function BP_EMGameMode_C:UpdatePetDefenseProgress()
  if IsStandAlone(self) then
    self.EMGameState:OnRep_PetDefenceKilled()
  end
end

function BP_EMGameMode_C:HandleJoinMidwayDungeonRandomEvent(AvatarBattleInfos)
  DebugPrint("[BP_EMGameMode_C:HandleJoinMidwayDungeonRandomEvent] Start")
  local DSEntity = GWorld:GetDSEntity()
  if not DSEntity then
    DebugPrint("[BP_EMGameMode_C:HandleJoinMidwayDungeonRandomEvent] not find DSEntity")
    return
  end
  if self.DungeonRandomEventPetId then
    DebugPrint("HandleJoinMidwayDungeonRandomEvent Pet ", self.DungeonRandomEventPetId)
    for AvatarEid, Info in pairs(AvatarBattleInfos or {}) do
      DebugPrint("CallServerMethod DungeonEventRealHappendPet ", CommonUtils.ObjId2Str(AvatarEid))
      DSEntity:SendAvatar(AvatarEid, "DungeonEventRealHappendPet", self.DungeonRandomEventPetId)
    end
  end
  DebugPrint("[BP_EMGameMode_C:HandleJoinMidwayDungeonRandomEvent] End")
  return
end

function BP_EMGameMode_C:InitDungeonRandomEvent(AvatarBattleInfos)
  if self.HasInitDungeonEvent then
    self:HandleJoinMidwayDungeonRandomEvent(AvatarBattleInfos)
    return
  end
  self.HasInitDungeonEvent = true
  DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] Start")
  local Avatar = self:GetAvatarInfo()
  if not Avatar then
    DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] not find avatar")
    return
  end
  local EventId = Avatar.DungeonRandomEvent.CurrentEventId
  local RandomEventExcel = DataMgr.DungeonRandomEvent[EventId]
  if not RandomEventExcel then
    DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] not find event excel <EventId>", EventId)
    return
  end
  local EventType = RandomEventExcel.EventType
  local EventDetail = Avatar.DungeonRandomEvent[EventType]
  DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] <EventId,EventType>", EventId, EventType)
  if 0 == EventId then
    DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] not happen event")
    return
  end
  if not EventDetail then
    DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] not find event detail <EventId,EventType>", EventId, EventType)
    return
  end
  if self["InitDungeonRandomEvent" .. EventType] then
    self["InitDungeonRandomEvent" .. EventType](self, EventDetail)
  else
    DebugPrint("[BP_EMGameMode_C:InitDungeonEvent] not find event type")
  end
  local DSEntity = GWorld:GetDSEntity()
  if DSEntity then
    DSEntity:ServerMulticast("DungeonEventRealHappend", EventId, Avatar.Uid)
  else
    Avatar:CallServerMethod("DungeonEventRealHappend", EventId)
  end
end

function BP_EMGameMode_C:InitDungeonRandomEventPet(Detail)
  DebugPrint("[BP_EMGameMode_C:InitDungeonRandomEventPet] Start <PetId>", Detail.PetId)
  local DSEntity = GWorld:GetDSEntity()
  if DSEntity then
    DSEntity:ServerMulticast("DungeonEventRealHappendPet", Detail.PetId)
  end
  if 0 == Detail.PetId then
    DebugPrint("[BP_EMGameMode_C:InitDungeonRandomEventPet] PetId为0")
    return
  end
  self.NeedPetMonster = true
  self.DungeonRandomEventPetId = Detail.PetId
  if not DataMgr.Pet[Detail.PetId] then
    ScreenPrint("[BP_EMGameMode_C:InitDungeonRandomEventPet] 传入的PetId不存在于Pet表中", Detail.PetId)
    return
  end
  self.DungeonRandomEventDefenceCoreId = DataMgr.Pet[Detail.PetId].DefenceCoreID
end

function BP_EMGameMode_C:InitDungeonRandomEventTreasure(Detail)
  DebugPrint("[BP_EMGameMode_C:InitDungeonRandomEventTreasure] Start")
  self.NeedTreasureMonster = true
end

function BP_EMGameMode_C:InitDungeonRandomEventButcher(Detail)
  DebugPrint("[BP_EMGameMode_C:InitDungeonRandomEventButcher] Start")
  self.NeedButcherMonster = true
end

function BP_EMGameMode_C:JudgeEscapeMechanismArray(mechanisms)
  if mechanisms:Num() <= 0 then
    DebugPrint("Error: 找不到撤离机关。")
  elseif mechanisms:Num() > 1 then
    DebugPrint("Warning: 找到了多于一个撤离机关。")
  end
end

function BP_EMGameMode_C:GetEscapeMechanismLocation()
  local Mechanisms = self.EMGameState.MechanismMap:FindRef("ExitTrigger")
  if nil ~= Mechanisms then
    Mechanisms = Mechanisms.Array
    self:JudgeEscapeMechanismArray(Mechanisms)
    for _, Mechanism in pairs(Mechanisms:ToTable()) do
      return Mechanism:K2_GetActorLocation()
    end
  else
    Mechanisms = TArray(FSnapShotInfo())
    local levelLoader = self:GetLevelLoader()
    if nil ~= levelLoader then
      do
        local Results = TArray(FSnapShotInfo())
        self:GetCustomDungeonSnapShotData(Results, levelLoader.exitLevelID)
        for _, Result in pairs(Results) do
          if Result.UnitType == "Mechanism" and nil ~= DataMgr.Mechanism[Result.UnitId] and "ExitTrigger" == DataMgr.Mechanism[Result.UnitId].UnitRealType then
            Mechanisms:Add(Result)
          end
        end
      end
    end
    self:JudgeEscapeMechanismArray(Mechanisms)
    for _, Mechanism in pairs(Mechanisms:ToTable()) do
      return Mechanism.Loc
    end
  end
  return nil
end

function BP_EMGameMode_C:GetEscapeMechanismActor()
  local Mechanisms = self.EMGameState.MechanismMap:FindRef("ExitTrigger")
  if nil == Mechanisms then
    DebugPrint("Error: 找不到撤离机关。")
    return nil
  end
  Mechanisms = Mechanisms.Array
  self:JudgeEscapeMechanismArray(Mechanisms)
  for _, Mechanism in pairs(Mechanisms:ToTable()) do
    return Mechanism
  end
  return nil
end

function BP_EMGameMode_C:GetPickupUnitPreloadTable()
  if self.EMGameState.GameModeType == "Blank" then
    return nil
  end
  local ComponentName = "BP_" .. self.EMGameState.GameModeType .. "Component"
  if self:GetDungeonComponent() ~= nil and nil ~= self:GetDungeonComponent().GetPickupUnitPreloadTable then
    return self:GetDungeonComponent():GetPickupUnitPreloadTable()
  end
  return nil
end

function BP_EMGameMode_C:GetAvatarBuffs(AvatarEid)
  for AvatarEid, AvatarInfo in pairs(self.AvatarInfos) do
    DebugPrint("Tianyi@ AvatarEid = " .. AvatarEid)
    local AvatarBuffs = AvatarInfo.Buffs
    for _, BuffInfo in pairs(AvatarBuffs) do
      DebugPrint("Tianyi@ BuffInfo: " .. BuffInfo.BuffId .. " StartTime: " .. BuffInfo.StartTime .. " Duration: " .. BuffInfo.Duration)
    end
  end
end

function BP_EMGameMode_C:TriggerBattleAchievementUploadOnDungeonEnd(IsWin)
  if IsStandAlone(self) then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
      local EndTag = "Dungeon"
      local EndId = self.LevelGameMode.DungeonId
      if Avatar:IsInHardBoss() then
        EndTag = "HardBoss"
        EndId = self.LevelGameMode.EMGameState.HardBossInfo.DifficultyId
      end
      PlayerCharacter.BattleAchievement:OnDungeonEnd(PlayerCharacter, EndTag, EndId, IsWin)
    end
  end
end

function BP_EMGameMode_C:NotifyGameModePlayerDead(Player)
  self:TriggerDungeonComponentFun("OnPlayerDead")
  self:PlayerOnDead(Player)
end

function BP_EMGameMode_C:DestroyActorsByUnitLabels_Lua(UnitLabels)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    for _, UnitLabel in pairs(UnitLabels:ToTable()) do
      Avatar:RegionActorDataDeadByUnitLabel(UnitLabel.UnitId, UnitLabel.UnitType)
    end
  end
end

function BP_EMGameMode_C:GetRegionIdByLocation(...)
  local LevelLoader = self:GetLevelLoader()
  if not LevelLoader then
    return
  end
  return LevelLoader:GetRegionIdByLocation(...)
end

function BP_EMGameMode_C:ActivateDynamicQuestEvent()
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.DynamicQuests and #Avatar.DynamicQuests then
    for _, DynamicQuest in pairs(Avatar.DynamicQuests) do
      if DynamicQuest:IsActive() then
        if not ClientEventUtils:CheckDynamicEventStarted(DynamicQuest.DynamicQuestId) then
          ClientEventUtils:StartDynamicEvent(DynamicQuest.DynamicQuestId)
        else
          local CurrentEvent = ClientEventUtils:GetCurrentActiveDynamicEvent(DynamicQuest.DynamicQuestId)
          if CurrentEvent then
            CurrentEvent:ActivateTrigger()
          end
        end
      end
    end
  end
end

function BP_EMGameMode_C:IsRegionAllReady()
  local RegionDataMgrSubSystem = self:GetRegionDataMgrSubSystem()
  if not RegionDataMgrSubSystem then
    return false
  end
  return RegionDataMgrSubSystem:IsRegionAllReady()
end

function BP_EMGameMode_C:TriggerTarget(TargetId, UniqueAttr, PlayerEid)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:ServerTargetFinish(TargetId, UniqueAttr, 1)
  end
  local DSEntity = GWorld:GetDSEntity()
  if DSEntity then
    if -1 == PlayerEid then
      DSEntity:ServerMulticast("ServerTargetFinish", TargetId, UniqueAttr, 1, {})
    else
      local AvatarEid = Battle(self):GetEntity(PlayerEid):GetOwner().AvatarId
      DSEntity:SendAvatar(AvatarEid, "ServerTargetFinish", TargetId, UniqueAttr, 1, {})
    end
  end
end

function BP_EMGameMode_C:ActiveNewTargetPointAOITrigger_Region(Type)
  if Type ~= Const.Hijack then
    GWorld.logger.error("ActiveNewTargetPointAOITrigger_Region 接口当前只支持 Hijack Type")
    return
  end
  if self.EMGameState == nil or nil == self.EMGameState.HijackPathInfo then
    return
  end
  if not self.NewTargetPointAOITriggerList then
    self.NewTargetPointAOITriggerList = {}
  end
  self.NewTargetPointAOITriggerList[Type] = {}
  for _, Path in pairs(self.EMGameState.HijackPathInfo) do
    for _, Point in pairs(Path) do
      if IsAuthority(self) and -1 ~= Point.SpawnTriggerBoxId and Point.SpawnBoxType == ENTPSpawnBoxType.GamemodeEvent then
        Point:SpawnTriggerBox()
        table.insert(self.NewTargetPointAOITriggerList[Type], Point)
      end
    end
  end
end

function BP_EMGameMode_C:DisactiveNewTargetPointAOITrigger_Region(Type)
  if not self.NewTargetPointAOITriggerList or not self.NewTargetPointAOITriggerList[Type] then
    return
  end
  for _, Point in pairs(self.NewTargetPointAOITriggerList[Type]) do
    Point:DestroyTriggerBox(EDestroyReason.SpecialQuestClear)
  end
end

function BP_EMGameMode_C:OnAllPlayersVoted()
  self:TriggerDungeonComponentFun("OnAllPlayersVoted")
end

function BP_EMGameMode_C:InitMonsterFramingNodeSetting(Setting)
  Setting.Type = EFramingType.ByReplicateNum
  Setting.DistanceToCull = 4500
  Setting.DistanceToCull_FastShare = 15000
  Setting.PreFrameReplicateNum = 30
  Setting.PreFrameReplicateMovementNum = 15
  Setting.SkipFullReplicationFactor = 0.5
  Setting.SkipMovementReplicationFactor = 1.0
end

function BP_EMGameMode_C:GetPlayerEidByAvatarEidStr(AvatarEidStr)
  local PlayerState = UE4.URuntimeCommonFunctionLibrary.GetPlayerStateByAvatarEid(GWorld.GameInstance, AvatarEidStr)
  if PlayerState then
    return PlayerState.Eid
  else
    DebugPrint("BP_EMGameMode_C: AvatarEidStr", AvatarEidStr, "拿不到对应的PlayerState!")
  end
end

function BP_EMGameMode_C:SetGameStatePetRandomDailyCount()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local CurPetCount = 0
  local AvatarTryPetDict = Avatar.Region2TryPetCount
  for _, Count in pairs(AvatarTryPetDict) do
    CurPetCount = CurPetCount + Count
  end
  self.EMGameState.RegionRandomPetLimitedDailyCount = DataMgr.GlobalConstant.PetRareDailyLimit.ConstantValue - CurPetCount
end

function BP_EMGameMode_C:GetRegionCharAvgLevel()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return 99
  end
  if not Avatar.Chars then
    return 99
  end
  local MyHeap = {}
  local HeapMaxSize = 3
  
  local function TryPushHeap(value)
    if #MyHeap < HeapMaxSize then
      table.insert(MyHeap, value)
    else
      local MinValue = math.min(table.unpack(MyHeap))
      if value > MinValue then
        for i, v in ipairs(MyHeap) do
          if v == MinValue then
            MyHeap[i] = value
            break
          end
        end
      end
    end
  end
  
  for _, Char in pairs(Avatar.Chars) do
    if Char and Char.Level then
      TryPushHeap(Char.Level)
    end
  end
  local Sum = 0
  for _, Level in pairs(MyHeap) do
    Sum = Sum + Level
  end
  local Res = math.floor(Sum / #MyHeap)
  DebugPrint("BP_EMGameMode_C:GetRegionCharAvgLevel", Res)
  return Res
end

function BP_EMGameMode_C:UpdateServerTimeOfDay(TimeOfDay)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:SetTimeOfDay(TimeOfDay)
end

function BP_EMGameMode_C:GetServerTimeOfDay()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return 12
  end
  return Avatar.TimeOfDay
end

function BP_EMGameMode_C:SetPlayerInvincible(Player, IsInvincible)
  if not IsValid(Player) then
    return
  end
  DebugPrint("BP_EMGameMode_C: SetPlayerInvincible", IsInvincible, "PlayerEid:", Player.Eid)
  if IsInvincible then
    Battle(self):AddBuffToTarget(Player, Player, Const.InvincibleBuffId, -1)
  else
    Battle(self):RemoveBuffFromTarget(Player, Player, Const.InvincibleBuffId, false, -1)
  end
end

function BP_EMGameMode_C:PausePhantomBTByPlayer(Player, IsPause, Reason)
  if not IsValid(Player) then
    return
  end
  Reason = Reason or "GameModePauseBT"
  DebugPrint("BP_EMGameMode_C: StopPhantomBTByPlayer", IsPause, "PlayerEid:", Player.Eid)
  local PhantomTeammates = Player:GetPhantomTeammates(false, true)
  for _, Phantom in pairs(PhantomTeammates) do
    if IsValid(Phantom) then
      if IsPause then
        Phantom:PauseBT(Reason)
      else
        Phantom:ResumeBT(Reason)
      end
    end
  end
end

AssembleComponents(BP_EMGameMode_C)
return BP_EMGameMode_C
