require("UnLua")
local DungeonFactory = require("BluePrints.DungeonObject.DungeonFactory")
local SDRC = require("Datas.ServerDomLevel_data.ServerDomRandomCreator")
local RewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
local DungeonObjectComponent = {}

function DungeonObjectComponent:yxdtest(EventName)
  self:NotifyServerDungeonEvent(EventName, {})
end

function DungeonObjectComponent:InitDungeonObject(DungeonId)
  local DungeonInfo = DataMgr.Dungeon[DungeonId]
  if not DungeonInfo then
    return
  end
  local DungeonType = DungeonInfo.DungeonType
  local DungeonObject = GWorld:GetGameModeDungeonObject()
  if not DungeonObject then
    return
  end
  DungeonObject:Init({
    GameMode = self,
    Battle = Battle
  })
  self:SetServerDungeonEnable()
  DungeonObject:BeginPlay()
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.ClientDungeonObject then
    Avatar.ClientDungeonObject:BeginPlay()
  end
end

function DungeonObjectComponent:SetServerDungeonEnable()
  self.ServerDungeonEnable = true
end

function DungeonObjectComponent:CheckServerDungeonEnable()
  if self:IsInRegion() then
    return false
  end
  return self.ServerDungeonEnable
end

function DungeonObjectComponent:NotifyServerDungeonEvent(EventName, ...)
  if not self:CheckServerDungeonEnable() then
    return
  end
  DebugPrint("DungeonObjectComponent:NotifyServerDungeonEvent, EventName: ", EventName)
  local DungeonObject = GWorld:GetGameModeDungeonObject()
  if not DungeonObject then
    DebugPrint("NotifyServerDungeonEvent DungeonObject不存在")
    return
  end
  DungeonObject:NotifyServerDungeonEvent(EventName, ...)
end

function DungeonObjectComponent:NotifyServerDungeonEventWithCallback(Callback, EventName, ...)
  if not self:CheckServerDungeonEnable() then
    return
  end
  DebugPrint("DungeonObjectComponent:NotifyServerDungeonEventWithCallback, EventName: ", EventName)
  local DungeonObject = GWorld:GetGameModeDungeonObject()
  if not DungeonObject then
    DebugPrint("DungeonObjectComponent:NotifyServerDungeonEventWithCallback DungeonObject不存在")
    return
  end
  DungeonObject:NotifyServerDungeonEventWithCallback(Callback, EventName, ...)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent(EventName, ...)
  if not self:CheckServerDungeonEnable() then
    return
  end
  DebugPrint("GameMode:OnNotifyGameModeDungeonEvent, EventName: ", EventName)
  local FunName = "OnNotifyGameModeDungeonEvent_" .. EventName
  if self[FunName] then
    self[FunName](self, ...)
  end
end

function DungeonObjectComponent:IsServerControlGameLevel()
  if self.IsServerControlGameModeLevel == nil then
    local GameModeType = self.EMGameState.GameModeType
    self.IsServerControlGameModeLevel = CommonConst.ServerControlGameLevelType[GameModeType] or false
  end
  return self.IsServerControlGameModeLevel
end

function DungeonObjectComponent:TriggerDungeonObjectFunc_Cpp(FunName, EventObj)
  self:TriggerDungeonObjectFunc(FunName, EventObj)
end

function DungeonObjectComponent:TriggerDungeonObjectFunc(FunName, ...)
  if not self:CheckServerDungeonEnable() then
    return
  end
  local DungeonObject = GWorld:GetGameModeDungeonObject()
  if not DungeonObject or not DungeonObject[FunName] then
    DebugPrint("DungeonObjectComponent:TriggerDungeonObjectFunc DungeonObject不存在 或FunName不存在 FunName", FunName)
    return
  end
  return DungeonObject[FunName](DungeonObject, ...)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerActiveStaticCreator(Infos)
  DebugPrint("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerActiveStaticCreator")
  PrintTable(Infos, 10)
  if URuntimeCommonFunctionLibrary.IsWorldCompositionEnabled(self) then
    local RegionDataMgr = self:GetRegionDataMgrSubSystem()
    if not RegionDataMgr then
      DebugPrint("Error OnNotifyGameModeDungeonEvent_ServerActiveStaticCreator RegionDataMgr 不存在")
      return
    end
    for _, Info in pairs(Infos) do
      local RegionBaseData = {}
      RegionBaseData.CreatorId = Info.StaticCreatorId
      RegionBaseData.ServerUniqueId = Info.UniqueId
      RegionBaseData.UnitId = Info.UnitId
      RegionBaseData.ExtraRegionInfo = {}
      RegionDataMgr:InitSSDataFromDungeonServer(RegionBaseData)
    end
    return
  end
  local CreatorMap = TMap(0, UObject)
  local PrivateEnable, LevelName
  local DungeonObject = GWorld:GetGameModeDungeonObject()
  if DungeonObject and DungeonObject.GetPrivateEnableAndLevelName then
    PrivateEnable, LevelName = DungeonObject:GetPrivateEnableAndLevelName()
  end
  DebugPrint("GetStaticCreatorMapInfo", PrivateEnable, LevelName)
  for _, Info in pairs(Infos) do
    local Creator = self.EMGameState:GetStaticCreatorInfo(Info.StaticCreatorId, PrivateEnable, LevelName)
    if not Creator or not URuntimeCommonFunctionLibrary.IsStaticCreatorValid(Creator) then
      GWorld.logger.error(string.format("ServerActiveStaticCreator 静态点不存在或已失效，已跳过 StaticCreatorId=%s UnitId=%s UniqueId=%s", tostring(Info.StaticCreatorId), tostring(Info.UnitId), tostring(Info.UniqueId)))
    else
      Creator.UnitId = Info.UnitId or Creator.UnitId
      Creator:RealActiveStaticCreator({
        ServerUniqueId = Info.UniqueId
      })
    end
  end
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerInActivateStaticCreator(Infos)
  DebugPrint("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerInActivateStaticCreator")
  PrintTable(Infos, 10)
  local CreatorMap = TMap(0, UObject)
  local PrivateEnable, LevelName
  local DungeonObject = GWorld:GetGameModeDungeonObject()
  if DungeonObject and DungeonObject.GetPrivateEnableAndLevelName then
    PrivateEnable, LevelName = DungeonObject:GetPrivateEnableAndLevelName()
  end
  for _, StaticCreatorId in pairs(Infos) do
    local Creator = self.EMGameState:GetStaticCreatorInfo(StaticCreatorId, PrivateEnable, LevelName)
    if not Creator or not URuntimeCommonFunctionLibrary.IsStaticCreatorValid(Creator) then
      GWorld.logger.error(string.format("ServerInActivateStaticCreator 静态点不存在或已失效，已跳过 StaticCreatorId=%s", tostring(StaticCreatorId)))
    else
      Creator:DestoryOneStaticActor_Lua(EDeathReason.Disable, EDestroyReason.Flexible)
    end
  end
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerActiveRandomCreator(Infos)
  DebugPrint("gmy@DungeonObjectComponent DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerActiveRandomCreator", CommonUtils.TableToString3(Infos))
  for _, Info in pairs(Infos) do
    local RegionBaseData = {}
    RegionBaseData.ServerUniqueId = tostring(Info.UniqueId)
    RegionBaseData.UnitId = Info.UnitId
    RegionBaseData.UnitType = Info.UnitType
    RegionBaseData.RandomRuleId = Info.RandomRuleId
    RegionBaseData.RandomTableId = Info.RandomTableId
    RegionBaseData.RandomIdxInRule = Info.RandomPointIndex - 1
    RegionBaseData.ExtraRegionInfo = {}
    if SDRC[self.DungeonId] and SDRC[self.DungeonId][Info.RandomRuleId] and SDRC[self.DungeonId][Info.RandomRuleId][Info.RandomPointIndex] then
      local Data = SDRC[self.DungeonId][Info.RandomRuleId][Info.RandomPointIndex]
      local ActorLoc = Data.ActorLoc
      RegionBaseData.BornLocation = {
        X = ActorLoc.x,
        Y = ActorLoc.y,
        Z = ActorLoc.z
      }
      RegionBaseData.LevelName = Data.WCLevelName
      self:GetRegionDataMgrSubSystem():InitSSDataFromDungeonServer(RegionBaseData)
    else
      GWorld.logger.error("随机点副本区域数据初始化没有找到RandomCreator！ 已跳过：" .. "DungeonId:" .. self.DungeonId .. " RandomRuleId:" .. Info.RandomRuleId .. " RandomIdxInRule:" .. Info.RandomPointIndex)
    end
  end
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerMSCreateMonsters(MonsterInfos)
  DebugPrint("OnNotifyGameModeDungeonEvent_ServerMSCreateMonsters UnitSpawnId:", MonsterInfos.UnitSpawnId, "IsRelation:", MonsterInfos.IsRelation, "IsGroupSpawn:", MonsterInfos.IsGroupSpawn, "IsFirstSpawn:", MonsterInfos.IsFirstSpawn, "CurrentGroupId:", MonsterInfos.CurrentGroupId)
  local MonsterSpawn = self.MonsterSpawnMap:FindRef(MonsterInfos.UnitSpawnId)
  if not MonsterSpawn then
    local UnitIdArray = TArray(0)
    UnitIdArray:Add(MonsterInfos.UnitSpawnId)
    self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Create, UnitIdArray, MonsterInfos.OnlyRelation, false, true)
    MonsterSpawn = self.MonsterSpawnMap:FindRef(MonsterInfos.UnitSpawnId)
  end
  if not MonsterSpawn then
    DebugPrint("Error OnNotifyGameModeDungeonEvent_ServerMSCreateMonsters MonsterSpawn创建失败 UnitSpawnId： ", MonsterInfos.UnitSpawnId)
    return
  end
  if MonsterInfos.IsGroupSpawn then
    if MonsterInfos.IsFirstSpawn then
      local BatchArray = self:ConvertGroupBatchInfosToArray(MonsterInfos.GroupBatchInfos)
      MonsterSpawn:TriggerFirstGroupCreateMonstersByServer(BatchArray)
    else
      local InfoMap = self:ConvertMSInfosToMap(MonsterInfos)
      MonsterSpawn:TriggerGroupCreateMonstersByServer(InfoMap, MonsterInfos.CurrentGroupId or -1)
    end
  elseif MonsterInfos.IsRelation then
    local InfoMap = self:ConvertMSInfosToMap(MonsterInfos)
    MonsterSpawn:RelationCreateMonstersByServer(InfoMap)
  else
    local InfoMap = self:ConvertMSInfosToMap(MonsterInfos)
    MonsterSpawn:TriggerCreateMonstersByServer(InfoMap)
  end
end

function DungeonObjectComponent:ConvertGroupBatchInfosToArray(GroupBatchInfos)
  local BatchArray = TArray(FServerGroupMonsterBatchNotify)
  if not GroupBatchInfos then
    return BatchArray
  end
  for _, Batch in ipairs(GroupBatchInfos) do
    local NotifyBatch = FServerGroupMonsterBatchNotify()
    NotifyBatch.GroupId = Batch.GroupId
    for UnitId, UniqueIds in pairs(Batch.UnitInfos or {}) do
      local ServerMonsterInfo = FServerMonsterInfo()
      for _, Id in pairs(UniqueIds) do
        ServerMonsterInfo.UniqueIds:Add(Id)
      end
      NotifyBatch.MonsterInfos:Add(UnitId, ServerMonsterInfo)
    end
    BatchArray:Add(NotifyBatch)
  end
  return BatchArray
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerTriggerCreateMonsterSpawn(UnitSpawnIdTable, OnlyRelation)
  local UnitIdArray = TArray(0)
  for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
    UnitIdArray:Add(UnitSpawnId)
  end
  self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Create, UnitIdArray, OnlyRelation, false, true)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerTriggerDestroyMonsterSpawn(UnitSpawnIdTable)
  local UnitIdArray = TArray(0)
  for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
    UnitIdArray:Add(UnitSpawnId)
  end
  self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Destroy, UnitIdArray, false, false, true)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerTriggerDestroyAllMonsterSpawn(UnitSpawnIdTable, NormalDeath)
  local UnitIdArray = TArray(0)
  for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
    UnitIdArray:Add(UnitSpawnId)
  end
  self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.DestroyAll, UnitIdArray, false, NormalDeath, true)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerTriggerPauseMonsterSpawn(UnitSpawnIdTable)
  local UnitIdArray = TArray(0)
  for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
    UnitIdArray:Add(UnitSpawnId)
  end
  self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Pause, UnitIdArray)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerTriggerResumeAllMonsterSpawn(UnitSpawnIdTable)
  local UnitIdArray = TArray(0)
  for _, UnitSpawnId in pairs(UnitSpawnIdTable) do
    UnitIdArray:Add(UnitSpawnId)
  end
  self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Resume, UnitIdArray)
end

function DungeonObjectComponent:ConvertMSInfosToMap(MonsterInfos)
  local ServerMonsterInfoMap = TMap(0, FServerMonsterInfo)
  for UnitId, UniqueIds in pairs(MonsterInfos.UnitInfos) do
    local ServerMonsterInfo = FServerMonsterInfo()
    for _, Id in pairs(UniqueIds) do
      ServerMonsterInfo.UniqueIds:Add(Id)
    end
    ServerMonsterInfoMap:Add(UnitId, ServerMonsterInfo)
  end
  return ServerMonsterInfoMap
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_GetMultiInfoResFromClient(UnitSpawnId, OnlyRelation)
  DebugPrint("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_GetMultiInfoResFromClient UnitSpawnId:", UnitSpawnId)
  local MonsterSpawn = self.MonsterSpawnMap:FindRef(UnitSpawnId)
  if not MonsterSpawn then
    local UnitIdArray = TArray(0)
    UnitIdArray:Add(UnitSpawnId)
    self:TriggerMonsterSpawn(ETriggerMonsterSpawnType.Create, UnitIdArray, OnlyRelation, false, true)
    MonsterSpawn = self.MonsterSpawnMap:FindRef(UnitSpawnId)
  end
  if not MonsterSpawn then
    DebugPrint("Error OnNotifyGameModeDungeonEvent_ServerMSCreateMonsters MonsterSpawn创建失败 UnitSpawnId： ", UnitSpawnId)
    return
  end
  MonsterSpawn:UpdateMultiInfoResToServer(true)
end

function DungeonObjectComponent:NotifyServerMultiInfoResChange(UnitSpawnId, MultiInfoRes)
  DebugPrint("DungeonObjectComponent:NotifyServerMultiInfoResChange UnitSpawnId:", UnitSpawnId, "MultiInfoRes:", MultiInfoRes)
  self:NotifyServerDungeonEvent("MultiInfoResChange", UnitSpawnId, MultiInfoRes)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_MonsterDead(MonsterInfo)
  DebugPrint("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_MonsterDead")
  PrintTable(MonsterInfo, 10)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_CreatDrop(DropRes, OtherParams)
  DebugPrint("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_CreatDrop")
  PrintTable(DropRes, 10)
  local Transform = CommonUtils:UnSerializeFTransform(DropRes.Transform)
  local GameState = self.EMGameState
  local LevelId = self:GetItemLevelId(Transform.Translation)
  OtherParams = OtherParams or {}
  
  local function CreateDrop(DropId, Count, bExtra, UniqueIds)
    if self.LevelGameMode.DropRule[DropId] then
      return
    end
    if IsStandAlone(self) then
      DebugPrint("HandleRewardDrop in DungeonObject", DropId, Count)
      GameState.EventMgr:RealSpawnRewards_Normal_DungeonOServer(DropId, Count, Transform, DropRes.Reason, DropRes.ExtraInfo, bExtra, UniqueIds)
    elseif ItemUtils:IsServerCreate(DropId) then
      DebugPrint("DS HandleRewardDrop in DungeonObject", DropId, Count)
      GameState.EventMgr:RealSpawnRewards_Normal_DungeonOServer(DropId, Count, Transform, DropRes.Reason, DropRes.ExtraInfo, bExtra, UniqueIds)
    else
      DebugPrint("CreateDrop For Player", DropId)
      local Avatar = OtherParams.Avatar or ""
      self:PickupToSpecPlayer(DropId, Count, Avatar, DropRes.Reason, Transform, LevelId, UniqueIds, bExtra)
      self.bNeedNotifyClientCreateDrop = true
    end
  end
  
  for _, Info in pairs(DropRes.DropInfos) do
    local DropId = tonumber(Info.DropId)
    local DropCountTable = Info.DropCountTable
    local ExtraCount = RewardBox:FindCountByTag(DropCountTable, "Extra")
    if ExtraCount > 0 then
      CreateDrop(DropId, ExtraCount, true, Info.UniqueIds)
    end
    local OtherCount = RewardBox:FindCountByTag(DropCountTable, "Normal")
    if OtherCount > 0 then
      CreateDrop(DropId, OtherCount, false, Info.UniqueIds)
    end
  end
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ResolveExp(Exps, OtherParams)
  local ExpsReward = {Exps = Exps}
  self:ResolveExpInBattle(ExpsReward, OtherParams)
end

function DungeonObjectComponent:NotifyServerMonsterDead(cb, MonsterInfo)
  self:NotifyServerDungeonEventWithCallback(cb, "MonsterDead", MonsterInfo)
end

function DungeonObjectComponent:NotifyServerOnInit()
  self:NotifyServerDungeonEvent("OnInit", {})
end

function DungeonObjectComponent:NotifyServerMechanismStateChange(EventInfo)
  print(_G.LogTag, "LXZ DungeonLogic NotifyServerMechanismStateChange")
  PrintTable(EventInfo, 10)
  self:NotifyServerDungeonEvent("MechanismStateChange", EventInfo)
end

function DungeonObjectComponent:AddOccupationValue(UniqueId, AddValue)
  print(_G.LogTag, "DungeonObjectComponent:AddOccupationValue", UniqueId, AddValue)
  self:NotifyServerDungeonEvent("AddOccupationValue", UniqueId, AddValue)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_MechanismStateChange(EventInfo)
  print(_G.LogTag, "LXZ DungeonLogic OnNotifyGameModeDungeonEvent_MechanismStateChange")
  PrintTable(EventInfo, 10)
  local GameState = UGameplayStatics.GetGameState(self)
  local MechanismObj = GameState.CombatItemUniqueMap:Find(EventInfo.UniqueId)
  if MechanismObj then
    MechanismObj:DungeonServerChangeState(EventInfo)
  end
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerDestroyDropMechanism(DropMechanismInfo)
  print("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerDestroyDropMechanism")
  PrintTable(DropMechanismInfo, 10)
  if not DropMechanismInfo or not DropMechanismInfo.UniqueId then
    print("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerDestroyDropMechanism Invalid DropMechanismInfo")
    return
  end
  local SceneItem = self.EMGameState.CombatItemUniqueMap:Find(DropMechanismInfo.UniqueId)
  if not SceneItem then
    print("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerDestroyDropMechanism 找不到对应机关")
    return
  end
  SceneItem:EMActorDestroy(EDestroyReason.ServerDestroy)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerCreateDropMechanism(DropMechanismInfo)
  print("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerCreateDropMechanism")
  PrintTable(DropMechanismInfo, 10)
  if not (DropMechanismInfo and DropMechanismInfo.UnitId) or not DropMechanismInfo.UniqueId then
    print("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerCreateDropMechanism Invalid DropMechanismInfo")
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not GameState or not GameState.EventMgr then
    print("DungeonObjectComponent:OnNotifyGameModeDungeonEvent_ServerCreateDropMechanism GameState or EventMgr is nil")
    return
  end
  local TransformStr = DropMechanismInfo.Transform
  local Transform = CommonUtils:UnSerializeFTransform(TransformStr)
  if not Transform then
    print("DungeonObjectComponent: Transform反序列化失败")
    return
  end
  local SpawnLoc = CommonUtils.GetFixLocation(self, Transform.Translation, 0, 200, -1500, "TraceScene")
  local Context = AEventMgr.CreateUnitContext()
  Context.UnitType = "Mechanism"
  Context.UnitId = DropMechanismInfo.UnitId
  Context.Loc = SpawnLoc
  Context.Rotation = Transform.Rotation:ToRotator()
  Context.NameParams:Add("UniqueId", tostring(DropMechanismInfo.UniqueId))
  Context.StrParams:Add("ServerUniqueId", tostring(DropMechanismInfo.UniqueId))
  if DropMechanismInfo.MonsterUnitId then
    Context.IntParams:Add("MonsterUnitId", DropMechanismInfo.MonsterUnitId)
  end
  print(string.format("DungeonObjectComponent: 创建机关Actor - UnitId(%d), UniqueId(%s), Location(%s, %s, %s)", DropMechanismInfo.UnitId, tostring(DropMechanismInfo.UniqueId), tostring(SpawnLoc.X), tostring(SpawnLoc.Y), tostring(SpawnLoc.Z)))
  GameState.EventMgr:CreateUnitNew(Context, false)
  print(string.format("DungeonObjectComponent: 机关创建完成 - UniqueId(%s)", tostring(DropMechanismInfo.UniqueId)))
end

function DungeonObjectComponent:NotifyServerMechanismDead(EventInfo)
  DebugPrint("zwk OnNotifyGameModeDungeonEvent_MechanismDead")
  PrintTable(EventInfo, 10)
  self:NotifyServerDungeonEvent("MechanismDead", EventInfo)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_MechanismDead(EventInfo)
  DebugPrint("zwk OnNotifyGameModeDungeonEvent_MechanismDead")
  PrintTable(EventInfo, 10)
end

function DungeonObjectComponent:NotifyServerPlayerDead(AvatarEid)
  DebugPrint("cjh OnNotifyGameModeDungeonEvent_PlayerDead AvatarEid:", AvatarEid)
  self:NotifyServerDungeonEvent("PlayerDead", AvatarEid)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_PlayerDead(AvatarEid)
  DebugPrint("cjh OnNotifyGameModeDungeonEvent_PlayerDead AvatarEid:", AvatarEid)
end

function DungeonObjectComponent:NotifyServerPlayerReborn(AvatarEid)
  DebugPrint("cjh OnNotifyGameModeDungeonEvent_PlayerReborn AvatarEid:", AvatarEid)
  self:NotifyServerDungeonEvent("PlayerReborn", AvatarEid)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_PlayerReborn(AvatarEid)
  DebugPrint("cjh OnNotifyGameModeDungeonEvent_PlayerReborn AvatarEid:", AvatarEid)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_DungeonComponentFun(EventName, ...)
  if not self:CheckServerDungeonEnable() then
    return
  end
  self:TriggerDungeonComponentFun(EventName, ...)
end

function DungeonObjectComponent:NotifyServerGameEnd(IsWin, GameEndReason)
  if not self:CheckServerDungeonEnable() then
    return
  end
  local AvatarEids
  if IsStandAlone(self) then
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if PlayerCharacter and PlayerCharacter:GetOwner() then
      AvatarEids = {
        PlayerCharacter:GetOwner().AvatarEidStr
      }
    end
  elseif IsDedicatedServer(self) then
    AvatarEids = {}
    for AvatarEid, _ in pairs(self.AvatarInfos) do
      table.insert(AvatarEids, AvatarEid)
    end
  end
  DebugPrint("BP_EMGameMode_C:NotifyServerGameEnd IsWin:", IsWin, " GameEndReason:", GameEndReason)
  self:NotifyServerDungeonEvent("TriggerGameEnd", IsWin, GameEndReason, AvatarEids)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_OnServerGameEnd(IsWin, GameEndReason)
  if not self:CheckServerDungeonEnable() then
    return
  end
  DebugPrint("BP_EMGameMode_C:OnServerGameEnd IsWin:", IsWin, " GameEndReason:", GameEndReason)
  if IsWin then
    self:TriggerDungeonWin()
  else
    self:TriggerDungeonFailed()
  end
end

function DungeonObjectComponent:NotifyServerPlayerEnd(IsWin, AvatarEids, GameEndReason, Cb)
  if not self:CheckServerDungeonEnable() then
    return
  end
  DebugPrint("BP_EMGameMode_C:NotifyServerPlayerEnd IsWin:", IsWin, "AvatarEids", table.concat(AvatarEids, ", "), " GameEndReason:", GameEndReason)
  self.ServerPlayerEndCb = Cb
  self:NotifyServerDungeonEvent("TriggerPlayerEnd", IsWin, AvatarEids, GameEndReason)
end

function DungeonObjectComponent:OnNotifyGameModeDungeonEvent_OnServerPlayerEnd(IsWin, AvatarEids, GameEndReason)
  if not self:CheckServerDungeonEnable() then
    return
  end
  DebugPrint("BP_EMGameMode_C:OnServerPlayerEnd IsWin:", IsWin, "AvatarEids", table.concat(AvatarEids, ", "), " GameEndReason:", GameEndReason)
  if IsWin then
    local Eids = {}
    for _, AvatarEid in pairs(AvatarEids) do
      local Eid = self:GetPlayerEidByAvatarEidStr(AvatarEid)
      if Eid then
        table.insert(Eids, Eid)
      end
    end
    self:TriggerPlayerWin(AvatarEids, Eids, GameEndReason)
  else
    self:TriggerPlayerFailed(AvatarEids, GameEndReason)
  end
  if self.ServerPlayerEndCb then
    self.ServerPlayerEndCb(IsWin, AvatarEids, GameEndReason)
    self.ServerPlayerEndCb = nil
  end
end

function DungeonObjectComponent:TriggerTableDrivenServerEvent(EventID)
  local TableName = self.EMGameState.GameModeType .. "ServerEvent"
  if not DataMgr[TableName] then
    return
  end
  if not DataMgr[TableName][EventID] then
    return
  end
  DebugPrint("BP_EMGameMode_C:TriggerTableDrivenServerEvent   EventID:", EventID)
  self:NotifyServerDungeonEvent("TableDrivenServerEvent", EventID)
end

return DungeonObjectComponent
