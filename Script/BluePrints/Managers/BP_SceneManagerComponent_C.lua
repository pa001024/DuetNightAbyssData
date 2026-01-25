require("UnLua")
require("DataMgr")
local BP_SceneManagerComponent_C = Class("BluePrints.Common.TimerMgr")
local BattleUtils = require("Utils.BattleUtils")
local Sha1 = require("sha1")
local Json = require("rapidjson")
local SDC_KEY_TIME_PRECISION = 0.3
local SDC_KEY_OVERTIME = 30.0
local SDC_KEY_REPEAT_ALERT_CNT = 5
local SDC_MIN_KEYS_THRESHOLD = 6
local SDC_KEY_ALERT_STRING = "MonitorType: ScriptDetection [KeyBoardRepeatDetection] DungeonId: %d, DungeonType = %s, RoundNum: %d, RepeatTime: %d."

function BP_SceneManagerComponent_C:DebugPrint(...)
  DebugPrint("SceneManagerComponent", ...)
end

function BP_SceneManagerComponent_C:GetExcavationABCIconPath(Index)
  return "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Digging_" .. Index .. ".T_Gp_Digging_" .. Index
end

function BP_SceneManagerComponent_C:GetSabotageABCIconPath(Index)
  return "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_DestroyTarget_" .. Index .. ".T_Gp_DestroyTarget_" .. Index
end

function BP_SceneManagerComponent_C:GetABCText(Map, Eid, Mod)
  if nil == Map then
    return ""
  end
  if nil == Map.Index[Eid] then
    Map.Index[Eid] = Map.Count
    Map.Count = (Map.Count + 1) % Mod
  end
  return string.char(string.byte("A") + Map.Index[Eid])
end

function BP_SceneManagerComponent_C:GetABCTextByMapName(Map, Eid, Mod)
  return self:GetABCText(self[Map], Eid, Mod)
end

function BP_SceneManagerComponent_C:Initialize(Initializer)
  self.LoadJsonLevelData = nil
  self.LastAssetName = ""
  self.NeedLoadAssetName = ""
  self.LoadedWorld = nil
  self.IsInLoading = false
  self.NowLoadResourceHandle = nil
  self.CurSceneGuideEids = {}
  self.IsSceneGuideShow = true
  self.LevelLoader = nil
  self.SpecialMonsterInfo = {}
  self.DungeonNetMode = CommonConst.DungeonNetMode.Standalone
  local t = FSnapShotInfo()
  self.CacheGuideInfo = {}
  self.SabotageABCMap = {
    Count = 0,
    Index = {}
  }
  self.ExcavationABCMap = {
    Count = 0,
    Index = {}
  }
  self.RegionOnlineCharacterInfo = {}
  self.CurrentCheckCountInScene = 0
end

function BP_SceneManagerComponent_C:AddRegionEvent(IsRegion)
  DebugPrint(" BP_SceneManagerComponent_C:AddRegionEvent IsRegion: ", IsRegion)
  if IsRegion then
    self:RegisterTeamEvent()
    EventManager:AddEvent(EventID.AddRegionIndicatorInfo, self, self.AddRegionOnlineCharacterInfo)
    EventManager:AddEvent(EventID.RemoveRegionIndicatorInfo, self, self.RemoveRegionOnlineCharacterInfo)
  end
end

function BP_SceneManagerComponent_C:RemoveRegionEvent()
  DebugPrint(" BP_SceneManagerComponent_C:RemoveRegionEvent")
  TeamController:UnRegisterEvent(self)
  EventManager:RemoveEvent(EventID.AddRegionIndicatorInfo, self)
  EventManager:RemoveEvent(EventID.RemoveRegionIndicatorInfo, self)
end

function BP_SceneManagerComponent_C:NotifyOnWindowResized()
  EventManager:FireEvent(EventID.OnWindowResized)
end

function BP_SceneManagerComponent_C:NotifyOnWindowMoved()
  EventManager:FireEvent(EventID.OnWindowMoved)
end

function BP_SceneManagerComponent_C:OnOtherPlayerEntityChange(Avatars)
  DebugPrint("LHQ_BP_SceneManagerComponent_C:OnOtherPlayerEntityChange")
  PrintTable(Avatars)
  if Avatars then
  end
end

function BP_SceneManagerComponent_C:GetCurSceneName()
  local World = self:GetWorld()
  return World:GetName()
end

function BP_SceneManagerComponent_C:GetTargetActorByName(ActorName)
  local AllActors = TArray(AActor)
  UE4.UGameplayStatics.GetAllActorsOfClass(self, AActor:StaticClass(), AllActors)
  local ActorTab = AllActors:ToTable()
  for i, v in pairs(ActorTab) do
    local name = v:GetName()
    if name:find(ActorName) then
      return v
    end
  end
end

function BP_SceneManagerComponent_C:GetNpcActorInSceneByID(NpcId)
  local NpcConfig = DataMgr.Npc[NpcId]
  if not NpcConfig then
    return
  end
  local NpcObjClass = UE4.UClass.Load(NpcConfig.UnitBPPath)
  local AllActors = TArray(AActor)
  UE4.UGameplayStatics.GetAllActorsOfClass(self, NpcObjClass, AllActors)
  local ActorTab = AllActors:ToTable()
  for _, v in pairs(ActorTab) do
    if NpcId == v.UnitId then
      return v
    end
  end
end

function BP_SceneManagerComponent_C:GetTargetActorInSceneByBPPath(BPPath)
  local ObjClass = UE4.UClass.Load(BPPath)
  local AllActors = TArray(AActor)
  UE4.UGameplayStatics.GetAllActorsOfClass(self, ObjClass, AllActors)
  return AllActors
end

function BP_SceneManagerComponent_C:UpdateSceneTargetDoorInfo(TargetEid, DoorName, NextLevelID)
  if not self.Guide2NextLevelIdMaps:Find(TargetEid) then
    self.Guide2NextLevelIdMaps:Add(TargetEid, NextLevelID)
  end
  if not self.Guide2InDoorNameMaps:Find(TargetEid) then
    self.Guide2InDoorNameMaps:Add(TargetEid, DoorName)
  end
  if self.Guide2NextLevelIdMaps:Find(TargetEid) then
    self.Guide2NextLevelIdMaps:Remove(TargetEid)
    self.Guide2NextLevelIdMaps:Add(TargetEid, NextLevelID)
  end
  if self.Guide2InDoorNameMaps:Find(TargetEid) then
    self.Guide2InDoorNameMaps:Remove(TargetEid)
    self.Guide2InDoorNameMaps:Add(TargetEid, DoorName)
  end
  self:UpdateGuide2LevelDoorInfo(TargetEid, DoorName, NextLevelID, "Update")
end

function BP_SceneManagerComponent_C:IsDungeonScene()
  local SceneName = self:GetCurSceneName()
  for _, ConfigData in pairs(DataMgr.Dungeon) do
    local PathConfigDataArray = Split(ConfigData.DungeonMapFile, "/")
    local PathConfigLength = #PathConfigDataArray
    local PathGameDataArray = Split(self:GetScenePathName(), "/")
    local IsPathSame = true
    for i = 1, PathConfigLength - 1 do
      if PathGameDataArray[i] ~= PathConfigDataArray[i] then
        IsPathSame = false
        break
      end
    end
    local RealNameArray = Split(PathConfigDataArray[PathConfigLength], ".")
    local NameLength = #RealNameArray
    if SceneName == RealNameArray[NameLength] and IsPathSame and type(ConfigData.DungeonLevel) == "number" then
      return true, ConfigData.IsRandom, ConfigData.DungeonType
    end
  end
  return false, false, ""
end

function BP_SceneManagerComponent_C:GetSceneLoadProgress(SceneId)
  local MapLevelConfig = DataMgr.Dungeon[SceneId]
  if nil == MapLevelConfig then
    print(self:GetLogMask(), "GetSceneLoadProgress  MapLevelConfig is nil, SceneId is ", SceneId)
    return 100
  end
  local MapLevelName = MapLevelConfig.DungeonMapFile or "/Game/Maps/Levels/TestLevel/TestScene"
  local NowProgress = UE4.UResourceLibrary.GetLoadProgress(self, MapLevelName, self:GetCurrentLoadSceneResourceId())
  return NowProgress
end

function BP_SceneManagerComponent_C:CheckPlayerIsInDefaultMainCity()
  local SceneName = self:GetCurSceneName()
  local PathConfigDataArray = Split(Const.DefaultMainCityFile, "/")
  local PathConfigLength = #PathConfigDataArray
  local PathGameDataArray = Split(self:GetScenePathName(), "/")
  local IsPathSame = true
  for i = 1, PathConfigLength - 1 do
    if PathGameDataArray[i] ~= PathConfigDataArray[i] then
      IsPathSame = false
      break
    end
  end
  local RealNameArray = Split(PathConfigDataArray[PathConfigLength], ".")
  local NameLength = #RealNameArray
  if SceneName == RealNameArray[NameLength] and IsPathSame then
    return true
  end
  return false
end

function BP_SceneManagerComponent_C:CheckIsInLevelSceneByPath(LevelPath)
  local SceneName = self:GetCurSceneName()
  local PathConfigDataArray = Split(LevelPath, "/")
  local PathConfigLength = #PathConfigDataArray
  local PathGameDataArray = Split(self:GetScenePathName(), "/")
  local IsPathSame = true
  for i = 1, PathConfigLength - 1 do
    if PathGameDataArray[i] ~= PathConfigDataArray[i] then
      IsPathSame = false
      break
    end
  end
  local RealNameArray = Split(PathConfigDataArray[PathConfigLength], ".")
  local NameLength = #RealNameArray
  if SceneName == RealNameArray[NameLength] and IsPathSame then
    return true
  end
  return false
end

function BP_SceneManagerComponent_C:CheckIsInLevelSceneBySceneId(SceneId)
  local LevelPath = DataMgr.Dungeon[SceneId].DungeonMapFile
  return self:CheckIsInLevelSceneByPath(LevelPath)
end

function BP_SceneManagerComponent_C:ReplaceGuideIcon(TargetActorEid, TargetActor, StyleNode, ImgPath)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  local GuideName = tostring(TargetActorEid)
  local GuideIcon = UIManager:GetUIObj(GuideName)
  if nil == GuideIcon then
    GuideIcon = self:GetGuideIconByEid(TargetActorEid)
  end
  if nil ~= GuideIcon then
    self:ProcessGuideIconBeforeClose(GuideIcon)
    GuideIcon:Close()
    self:UpdateSceneGuideIcon(TargetActorEid, TargetActor, nil, "Add", true, {
      GuideIconAni = UIConst.DUNGEONINDICATOR[StyleNode],
      GuideIconBPPath = "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_MainMission.T_Gp_MainMission",
      IsReplace = true
    })
  end
  self.CaptureMonsterEid = TargetActorEid
end

function BP_SceneManagerComponent_C:RecoverGuideIcon()
  local GuideName = tostring(self.CaptureMonsterEid) .. "Replace"
  RunAsyncTask(self, "RecoverGuideIcon_GetUIObjAsync" .. GuideName, function(CoroutineObj)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if not UIManager then
      return
    end
    local GuideIcon = UIManager:GetUIObjAsync(GuideName, CoroutineObj)
    if nil ~= GuideIcon then
      self:ProcessGuideIconBeforeClose(GuideIcon)
      GuideIcon:Close()
      self.CurSceneGuideEids[self.CaptureMonsterEid] = nil
      self:UpdateOneSceneGuideIcon(self.CaptureMonsterEid, true, false)
    end
  end)
end

function BP_SceneManagerComponent_C:SetGuideActorInfo(GuideInfo)
  if nil == GuideInfo then
    return
  end
  
  local function CheckEidIsValid(InEid)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local PlayerState = GameState:GetPlayerState(Player.Eid)
    if PlayerState then
      local AllPlayerGuideEids = FIntArray()
      if PlayerState.PlayerGuideEids ~= nil then
        AllPlayerGuideEids = PlayerState.PlayerGuideEids
      end
      for Index = 1, AllPlayerGuideEids.Items:Num() do
        local TargetEid = AllPlayerGuideEids.Items:GetRef(Index).IntProperty
        if InEid == TargetEid then
          return true
        end
      end
    end
    local AllCommonGuideEids = FIntArray()
    if nil ~= GameState.GuideEids then
      AllCommonGuideEids = GameState.GuideEids
    end
    for Index = 1, AllCommonGuideEids.Items:Num() do
      local TargetEid = AllCommonGuideEids.Items:GetRef(Index).IntProperty
      if InEid == TargetEid then
        return true
      end
    end
    return false
  end
  
  if CheckEidIsValid(GuideInfo.SnapShotId) == false then
    DebugPrint("BP_SceneManagerComponent_C:SetGuideActorInfo 序列化数据的SnapShotId不合法 SnapShotId: ", GuideInfo.SnapShotId)
    return
  end
  local ConfigData = DataMgr[GuideInfo.UnitType][GuideInfo.UnitId]
  local GuideOp = self.CurSceneGuideEids[GuideInfo.SnapShotId] == nil and "Add" or "Modify"
  local IsCommonEid = self:GetEidFromCommonOrPlayer(GuideInfo.SnapShotId)
  self:UpdateSceneGuideIcon(GuideInfo.SnapShotId, nil, GuideInfo.Loc, GuideOp, true, ConfigData, not IsCommonEid, true)
  DebugPrint("BP_SceneManagerComponent_C:SetGuideActorInfo GuideOp: ", GuideOp, "SnapShotId: ", GuideInfo.SnapShotId, "GuideInfo.Loc", GuideInfo.Loc)
  local SnapShotInfo = FSnapShotInfo()
  SnapShotInfo.Loc = GuideInfo.Loc
  SnapShotInfo.SnapShotId = GuideInfo.SnapShotId
  SnapShotInfo.UnitType = GuideInfo.UnitType
  SnapShotInfo.UnitId = GuideInfo.UnitId
  self.CurSceneGuideEids[GuideInfo.SnapShotId] = {
    Entity = SnapShotInfo,
    IsDataStruct = true,
    IsPlayerEid = not IsCommonEid,
    IsActive = true
  }
  if (GuideInfo.UnitType == "Monster" or GuideInfo.UnitType == "Mechanism") and self:GetLevelLoader() and self:GetLevelLoader().StartPathfindingToActorByEid and not self.PathfindingEid:FindRef(GuideInfo.SnapShotId) then
    self:GetLevelLoader():StartPathfindingToActorByEid(GuideInfo.SnapShotId)
    self.PathfindingEid:Add(GuideInfo.SnapShotId, true)
  end
end

function BP_SceneManagerComponent_C:GetCurSceneGuideEntityByEid(Eid)
  if self.CurSceneGuideEids and self.CurSceneGuideEids[Eid] then
    if self.CurSceneGuideEids[Eid].IsDataStruct then
      return self.CurSceneGuideEids[Eid].Entity, true
    else
      local TargetActor
      if Battle(self) then
        TargetActor = Battle(self):GetEntity(Eid)
      end
      return TargetActor, false
    end
  end
  return nil, false
end

function BP_SceneManagerComponent_C:GetCurSceneGuideEntityByData(CurSceneGuideData)
  if CurSceneGuideData then
    if CurSceneGuideData.IsDataStruct then
      return nil
    else
      local TargetActor
      if Battle(self) then
        TargetActor = Battle(self):GetEntity(CurSceneGuideData.Entity)
      end
      return TargetActor
    end
  end
  return nil
end

function BP_SceneManagerComponent_C:UpdateOneSceneGuideIcon(TargetEid, IsAdd, IsPlayerEid)
  DebugPrint("BP_SceneManagerComponent_C:UpdateOneSceneGuideIcon TargetEid: ", TargetEid, "IsAdd: ", IsAdd, "IsPlayerEid: ", IsPlayerEid)
  self.CurSceneGuideEids = self.CurSceneGuideEids or {}
  if true == IsAdd then
    local TargetActor
    if Battle(self) then
      TargetActor = Battle(self):GetEntity(TargetEid)
    end
    if IsValid(TargetActor) and (TargetActor.OpenState == nil or TargetActor.OpenState == false) then
      local GuideOp = self.CurSceneGuideEids[TargetEid] == nil and "Add" or "Modify"
      self:UpdateSceneGuideIcon(TargetEid, TargetActor, nil, GuideOp, true, nil, IsPlayerEid)
    else
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
      PlayerCharacter.RPCComponent:RequestGuideInfo(TargetEid)
    end
  else
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
    local PlayerState = GameState:GetPlayerState(Player.Eid)
    if PlayerState and nil ~= PlayerState.PlayerGuideEids then
      for Index = 1, PlayerState.PlayerGuideEids.Items:Num() do
        local Eid = PlayerState.PlayerGuideEids.Items:GetRef(Index).IntProperty
        if Eid == TargetEid then
          return
        end
      end
    end
    local Entity, IsDataStruct = self:GetCurSceneGuideEntityByEid(TargetEid)
    DebugPrint("UpdateOneSceneGuideIcon GetCurSceneGuideEntityByEid: ", TargetEid, "IsAdd: ", IsAdd, "IsPlayerEid: ", IsPlayerEid, "IsDataStruct", IsDataStruct)
    if not IsDataStruct and UKismetSystemLibrary.IsValid(Entity) then
      self:UpdateSceneGuideIcon(TargetEid, Entity, nil, "Delete", true, nil, IsPlayerEid)
    else
      self:UpdateSceneGuideIcon(TargetEid, nil, nil, "Delete", true, nil, IsPlayerEid)
    end
  end
end

function BP_SceneManagerComponent_C:AddOneGuideIconWithSkillEffect(TargetEid, IsPlayerEid, GuideDuration, GuideCloseRange)
  if not Battle(self) then
    return
  end
  local TargetActor = Battle(self):GetEntity(TargetEid)
  if IsValid(TargetActor) then
    local GuideOp = self.CurSceneGuideEids[TargetEid] == nil and "Add" or "Modify"
    local ConfigData = DataMgr[TargetActor.UnitType][TargetActor.UnitId]
    local NewConfigData = {
      GuideIconAni = ConfigData.GuideIconAni,
      GuideIconBPPath = ConfigData.GuideIconBPPath,
      GuideIconBPPath2 = ConfigData.GuideIconBPPath2,
      GuideDuration = GuideDuration,
      GuideCloseRange = GuideCloseRange
    }
    self:UpdateSceneGuideIcon(TargetEid, TargetActor, nil, GuideOp, true, NewConfigData, IsPlayerEid)
  end
end

function BP_SceneManagerComponent_C:CloseOneGuideIconByTargetEid(TargetEid)
  self:UpdateSceneGuideIcon(TargetEid, nil, nil, "Delete", true, nil, nil)
end

function BP_SceneManagerComponent_C:UpdateAllSceneGuideIcon()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if nil == GameState then
    return
  end
  self.CurSceneGuideEids = self.CurSceneGuideEids or {}
  local AllGuideEids = FIntArray()
  if nil ~= GameState.GuideEids then
    AllGuideEids = GameState.GuideEids
  end
  for Index = 1, AllGuideEids.Items:Num() do
    local TargetEid = AllGuideEids.Items:GetRef(Index).IntProperty
    local TargetActor
    if Battle(self) then
      TargetActor = Battle(self):GetEntity(TargetEid)
    end
    local IsCombatItemBase
    if IsValid(TargetActor) and TargetActor.IsCombatItemBase then
      IsCombatItemBase = TargetActor:IsCombatItemBase()
    end
    if IsValid(TargetActor) and (nil == TargetActor.OpenState or TargetActor.OpenState == false) and true == IsCombatItemBase then
      local GuideOp = nil == self.CurSceneGuideEids[TargetEid] and "Add" or "Modify"
      self:UpdateSceneGuideIcon(TargetEid, TargetActor, nil, GuideOp, true)
    else
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
      PlayerCharacter.RPCComponent:RequestGuideInfo(TargetEid)
    end
  end
end

function BP_SceneManagerComponent_C:UpdateAllCommonGuideIcon()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if nil == GameState then
    return
  end
  self.CurSceneGuideEids = self.CurSceneGuideEids or {}
  local CommonGuideInfos = {}
  for k, v in pairs(self.CurSceneGuideEids) do
    if not v.IsPlayerEid then
      CommonGuideInfos[k] = v
      v.IsActive = false
    end
  end
  local AllGuideEids = FIntArray()
  if nil ~= GameState.GuideEids then
    AllGuideEids = GameState.GuideEids
  end
  DebugPrint("BP_SceneManagerComponent_C:UpdateAllCommonGuideIcon AllGuideEids", AllGuideEids.Items:Num())
  for Index = 1, AllGuideEids.Items:Num() do
    local TargetEid = AllGuideEids.Items:GetRef(Index).IntProperty
    local TargetActor
    if Battle(self) then
      TargetActor = Battle(self):GetEntity(TargetEid)
    end
    if nil ~= CommonGuideInfos[TargetEid] then
      CommonGuideInfos[TargetEid].IsActive = true
    end
    if IsValid(TargetActor) and (nil == TargetActor.OpenState or false == TargetActor.OpenState) then
      local GuideOp = nil == CommonGuideInfos[TargetEid] and "Add" or "Modify"
      self:UpdateSceneGuideIcon(TargetEid, TargetActor, nil, GuideOp, true)
    else
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
      PlayerCharacter.RPCComponent:RequestGuideInfo(TargetEid)
    end
  end
  for k, v in pairs(CommonGuideInfos) do
    if v and not v.IsActive then
      local Entity = self:GetCurSceneGuideEntityByData(v)
      if UKismetSystemLibrary.IsValid(Entity) then
        self:UpdateSceneGuideIcon(k, Entity, nil, "Delete", true)
      else
        self:UpdateSceneGuideIcon(k, nil, nil, "Delete", true)
      end
    end
  end
end

function BP_SceneManagerComponent_C:UpdateAllPlayerGuideIcon()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  if nil == GameState or nil == Player then
    return
  end
  self.CurSceneGuideEids = self.CurSceneGuideEids or {}
  local PlayerGuideInfos = {}
  for k, v in pairs(self.CurSceneGuideEids) do
    if v.IsPlayerEid then
      PlayerGuideInfos[k] = v
      local GuideIcon = UIManager:GetUIObj(tostring(k))
      if GuideIcon and nil ~= GuideIcon.PlayerIndex and GuideIcon.PlayerIndex > 0 then
      else
        v.IsActive = false
      end
    end
  end
  local AllGuideEids = FIntArray()
  local PlayerState = GameState:GetPlayerState(Player.Eid)
  if nil ~= PlayerState and nil ~= PlayerState.PlayerGuideEids then
    AllGuideEids = PlayerState.PlayerGuideEids
  end
  local PlayerGuideEidsMap = {}
  for Index = 1, AllGuideEids.Items:Num() do
    local TargetEid = AllGuideEids.Items:GetRef(Index).IntProperty
    PlayerGuideEidsMap[TargetEid] = true
    local TargetActor
    if Battle(self) then
      TargetActor = Battle(self):GetEntity(TargetEid)
    end
    if nil ~= PlayerGuideInfos[TargetEid] then
      PlayerGuideInfos[TargetEid].IsActive = true
    end
    if IsValid(TargetActor) and (nil == TargetActor.OpenState or false == TargetActor.OpenState) then
      local GuideOp = nil == PlayerGuideInfos[TargetEid] and "Add" or "Modify"
      self:UpdateSceneGuideIcon(TargetEid, TargetActor, nil, GuideOp, true, nil, true)
    else
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
      PlayerCharacter.RPCComponent:RequestGuideInfo(TargetEid)
    end
  end
  for k, v in pairs(PlayerGuideInfos) do
    if v and not v.IsActive then
      local Entity = self:GetCurSceneGuideEntityByData(v)
      if UKismetSystemLibrary.IsValid(Entity) then
        self:UpdateSceneGuideIcon(k, Entity, nil, "Delete", true, nil, v.IsPlayerEid)
      else
        self:UpdateSceneGuideIcon(k, nil, nil, "Delete", true, nil, v.IsPlayerEid)
      end
    end
  end
end

function BP_SceneManagerComponent_C:RemoveGuideFromPathFinding(TargetEid)
  if self:IsExistTimer("AddGuideToPathFinding" .. TargetEid) then
    self:RemoveTimer("AddGuideToPathFinding" .. TargetEid)
  end
  if self.PathfindingEid:FindRef(TargetEid) and self:GetLevelLoader() then
    self.PathfindingEid:Add(TargetEid, nil)
    self:GetLevelLoader():StopPathfindingToActorByEid(TargetEid)
  end
  self.CurSceneGuideEids[TargetEid] = nil
  if self.Guide2NextLevelIdMaps:Find(TargetEid) then
    self.Guide2NextLevelIdMaps:Remove(TargetEid)
  end
  if self.Guide2InDoorNameMaps:Find(TargetEid) then
    self.Guide2InDoorNameMaps:Remove(TargetEid)
  end
end

function BP_SceneManagerComponent_C:GetGuideTypeByBPPath(GuideIconAni, GuideIconBPPath)
  local GuideType = UIConst.IndicatorCategoryTable[GuideIconAni]
  GuideType = GuideType or UIConst.IndicatorCategoryIconTable[GuideIconBPPath]
  if GuideType then
    return GuideType
  end
  return ""
end

function BP_SceneManagerComponent_C:GetGuideGuideAnimByBPPath(GuideIconAni, GuideIconBPPath)
  local GuideAnim = UIConst.IndicatorAnimTable[GuideIconAni]
  GuideAnim = GuideAnim or UIConst.IndicatorAnimIconTable[GuideIconBPPath]
  if GuideAnim then
    return GuideAnim
  end
  return ""
end

function BP_SceneManagerComponent_C:RegisterTeamEvent()
  TeamController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == TeamCommon.EventId.TeamOnAddPlayer then
      local Member = (...)
      self:OnTeamAddRegionOtherPlayerGuide(Member)
    elseif EventId == TeamCommon.EventId.TeamOnDelPlayer then
      local Member = (...)
      self:OnTeamRemoveRegionOtherPlayerGuide(Member)
      local TeamData = TeamController:GetModel():GetTeam()
      for _, Member in pairs(TeamData.Members) do
        self:OnTeamAddRegionOtherPlayerGuide(Member)
      end
    elseif EventId == TeamCommon.EventId.TeamOnInit then
      local Team = (...)
      for _, Member in ipairs(Team.Members) do
        self:OnTeamAddRegionOtherPlayerGuide(Member)
      end
    elseif EventId == TeamCommon.EventId.TeamLeave then
      local Team = (...)
      for _, Member in ipairs(Team.Members) do
        self:OnTeamRemoveRegionOtherPlayerGuide(Member)
      end
    end
  end)
end

function BP_SceneManagerComponent_C:AddRegionOnlineCharacterInfo(Eid, Uid, StartLoc)
  DebugPrint("AddRegionOnlineCharacterInfo Eid", Eid, "Uid", Uid, "StartLoc", StartLoc)
  self.RegionOnlineCharacterInfo[Uid] = Eid
  local DsMember, MemberIndex = TeamController:GetModel():GetTeamMember(Uid)
  if not DsMember then
    return
  end
  self:AddRegionOtherPlayerGuide(Eid, StartLoc, MemberIndex)
end

function BP_SceneManagerComponent_C:OnTeamAddRegionOtherPlayerGuide(MemberInfo)
  DebugPrint("OnTeamAddRegionOtherPlayerGuide MemberInfo.Uid", MemberInfo.Uid, "MemberInfo.Index", MemberInfo.Index)
  local MemberEid = self.RegionOnlineCharacterInfo[MemberInfo.Uid]
  if MemberEid then
    local StartLoc = FVector(0, 0, 0)
    local Player
    if Battle(self) then
      Player = Battle(self):GetEntity(MemberEid)
    end
    if Player then
      StartLoc = Player:K2_GetActorLocation()
    end
    self:AddRegionOtherPlayerGuide(MemberEid, StartLoc, MemberInfo.Index)
  end
end

function BP_SceneManagerComponent_C:AddRegionOtherPlayerGuide(Eid, StartLoc, MemberIndex)
  DebugPrint("AddRegionOtherPlayerGuide Eid: ", Eid, "StartLoc", StartLoc, "MemberIndex", MemberIndex)
  local GuideOp = self.CurSceneGuideEids[Eid] == nil and "Add" or "Modify"
  local PlayerGuideIconBPPath = self:GetPlayerGuideIcon(MemberIndex, true)
  self:UpdateSceneGuideIcon(Eid, nil, StartLoc, GuideOp, true, {
    GuideIconAni = UIConst.DUNGEONINDICATOR.Phantom,
    GuideIconBPPath = PlayerGuideIconBPPath,
    PlayerIndex = MemberIndex
  }, true)
end

function BP_SceneManagerComponent_C:RemoveRegionOnlineCharacterInfo(Uid)
  local CurrentEid = self.RegionOnlineCharacterInfo[Uid]
  DebugPrint("RemoveRegionOnlineCharacterInfo Uid", Uid, "CurrentEid", CurrentEid)
  if not CurrentEid then
    return
  end
  self.RegionOnlineCharacterInfo[Uid] = nil
  self:RemoveRegionOtherPlayerGuide(CurrentEid)
end

function BP_SceneManagerComponent_C:OnTeamRemoveRegionOtherPlayerGuide(MemberInfo)
  local MemberEid = self.RegionOnlineCharacterInfo[MemberInfo.Uid]
  DebugPrint("RemoveRegionOnlineCharacterInfo MemberInfo", MemberInfo, "MemberEid", MemberEid)
  if not MemberEid then
    return
  end
  if MemberEid then
    self:RemoveRegionOtherPlayerGuide(MemberEid)
  end
end

function BP_SceneManagerComponent_C:RemoveRegionOtherPlayerGuide(Eid)
  DebugPrint("RemoveRegionOtherPlayerGuide Eid: ", Eid)
  local DeleteName = tostring(Eid)
  RunAsyncTask(self, "RemoveRegionOtherPlayerGuide_GetUIObjAsync" .. DeleteName, function(CoroutineObj)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if not UIManager then
      return
    end
    local GuideIcon = UIManager:GetUIObjAsync(DeleteName, CoroutineObj)
    local TargetActor
    if Battle(self) then
      TargetActor = Battle(self):GetEntity(Eid)
    end
    if GuideIcon then
      if IsValid(TargetActor) then
        self:UpdateSceneGuideIcon(Eid, TargetActor, nil, "Delete", true)
      else
        self:UpdateSceneGuideIcon(Eid, nil, nil, "Delete", true)
      end
    end
  end)
end

function BP_SceneManagerComponent_C:UpdateSceneOtherPlayerGuide(Eid, OpType)
  DebugPrint("BP_SceneManagerComponent_C:UpdateSceneOtherPlayerGuide Eid: ", Eid, "OpType", OpType)
  if "Enter" == OpType then
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local MapTable = self.OtherPlayerGuideEidMaps:ToTable()
    if MapTable then
      for Index, MapEid in pairs(MapTable) do
        local BirthsLoc = FVector(0, 0, 0)
        for _, v in pairs(GameState.PlayerArray) do
          if v.Eid == MapEid then
            BirthsLoc.X = v.PlayerLoc.X
            BirthsLoc.Y = v.PlayerLoc.Y
            BirthsLoc.Z = v.PlayerLoc.Z
            break
          end
        end
        local GuideOp = self.CurSceneGuideEids[MapEid] == nil and "Add" or "Modify"
        local PlayerGuideIconBPPath = self:GetPlayerGuideIcon(Index, true)
        self:UpdateSceneGuideIcon(MapEid, nil, BirthsLoc, GuideOp, true, {
          GuideIconAni = UIConst.DUNGEONINDICATOR.Phantom,
          GuideIconBPPath = PlayerGuideIconBPPath,
          PlayerIndex = Index
        }, true)
      end
    end
  elseif "Exit" == OpType then
    local DeleteName = tostring(Eid)
    RunAsyncTask(self, "UpdateSceneOtherPlayerGuide_GetUIObjAsync" .. DeleteName, function(CoroutineObj)
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      local UIManager = GameInstance:GetGameUIManager()
      if not UIManager then
        return
      end
      local GuideIcon = UIManager:GetUIObjAsync(DeleteName, CoroutineObj)
      if GuideIcon then
        local TargetActor
        if Battle(self) then
          TargetActor = Battle(self):GetEntity(Eid)
        end
        if IsValid(TargetActor) then
          self:UpdateSceneGuideIcon(Eid, TargetActor, nil, "Delete", true)
        else
          self:UpdateSceneGuideIcon(Eid, nil, nil, "Delete", true)
        end
      end
    end)
  end
end

function BP_SceneManagerComponent_C:GetPlayerGuideIcon(PlayerIndex, IsAlive)
  if IsAlive then
    return "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Player" .. tostring(PlayerIndex) .. "A.T_Gp_Player" .. tostring(PlayerIndex) .. "A"
  else
    return "/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Player" .. tostring(PlayerIndex) .. "B.T_Gp_Player" .. tostring(PlayerIndex) .. "B"
  end
  return ""
end

function BP_SceneManagerComponent_C:UpdateAllGuideIconsByName(OpType, InEid, InName)
  if "Add" == OpType or "Modify" == OpType then
    if nil ~= InName then
      if self.GuideIcons:FindRef(InEid) then
        self.GuideIcons:Remove(InEid)
        self.GuideIcons:Add(InEid, InName)
      else
        self.GuideIcons:Add(InEid, InName)
      end
    elseif self.GuideIcons:FindRef(InEid) then
      local Name = self.GuideIcons:FindRef(InEid)
      self.GuideIcons:Remove(InEid)
      self.GuideIcons:Add(InEid, Name)
    end
  elseif "Delete" == OpType and self.GuideIcons:FindRef(InEid) then
    self.GuideIcons:Remove(InEid)
  end
end

function BP_SceneManagerComponent_C:IsExistInGuideEidArrays(TargetEid)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
  if Player then
    local PlayerState = GameState:GetPlayerState(Player.Eid)
    DebugPrint("BP_SceneManagerComponent_C:IsExistInGuideEidArrays TargetEid", TargetEid)
    if PlayerState and PlayerState.PlayerGuideEids ~= nil then
      for Index = 1, PlayerState.PlayerGuideEids.Items:Num() do
        local Eid = PlayerState.PlayerGuideEids.Items:GetRef(Index).IntProperty
        DebugPrint("IsExistInGuideEidArrays PlayerState.PlayerGuideEids Eid", Eid)
        if Eid == TargetEid then
          return true
        end
      end
    end
  end
  local AllCommonGuideEids = FIntArray()
  if nil ~= GameState.GuideEids then
    AllCommonGuideEids = GameState.GuideEids
  end
  for Index = 1, AllCommonGuideEids.Items:Num() do
    local Eid = AllCommonGuideEids.Items:GetRef(Index).IntProperty
    DebugPrint("IsExistInGuideEidArrays GameState.GuideEids Eid", Eid)
    if Eid == TargetEid then
      return true
    end
  end
  return false
end

function BP_SceneManagerComponent_C:UpdateSceneGuideIcon(TargetEid, TargetActor, TargetLocation, OpType, IsUseRealDis, ConfigData, IsPlayerEid, IsDataStruct)
  self.Overridden.UpdateSceneGuideIcon(self, TargetEid, TargetActor, TargetLocation, OpType, IsUseRealDis)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local UIManager = GameInstance:GetGameUIManager()
  local IsGuideFollowActor = true
  local IsNeedLookUpEntity = false
  local IsNeedArrow = true
  local GuideName = ""
  local GuideType, GuideUnitId = "", ""
  if nil == IsPlayerEid then
    IsPlayerEid = false
  end
  if "Add" == OpType or "Modify" == OpType then
    DebugPrint("LHQ_UpdateSceneGuideIcon Add or Modify Guide:", TargetEid, "IsPlayerEid:", IsPlayerEid, "IsDataStruct", IsDataStruct)
  elseif "Delete" == OpType then
    DebugPrint("LHQ_UpdateSceneGuideIcon Delete Guide:", TargetEid, "IsPlayerEid:", IsPlayerEid, "IsDataStruct", IsDataStruct)
    if self:IsExistInGuideEidArrays(TargetEid) then
      return
    end
  end
  if nil ~= UIManager then
    if UKismetSystemLibrary.IsValid(TargetActor) then
      if nil == ConfigData and "Delete" ~= OpType then
        ConfigData = DataMgr[TargetActor.UnitType][TargetActor.UnitId]
      end
      GuideUnitId = TargetActor.UnitId
      if nil ~= ConfigData and ConfigData.GuideIconAni then
        GuideType = self:GetGuideTypeByBPPath(ConfigData.GuideIconAni, ConfigData.GuideIconBPPath)
      end
      if "Phantom" == GuideType then
        local ExtraInfo = BattleUtils.GetExtraCreateInfo("Phantom", GuideUnitId, GuideUnitId)
        if ExtraInfo.IsHostage then
          GuideType = "Hostage"
        end
      end
      GuideName = GuideName .. tostring(TargetEid)
      if "Monster" == GuideType and TargetActor.BlockTickLod_MoveComp then
        if "Add" == OpType then
          TargetActor:BlockTickLod_MoveComp(true, Const.BlockTickLodTag.SceneGuide)
        elseif "Delete" == OpType then
          TargetActor:BlockTickLod_MoveComp(false, Const.BlockTickLodTag.SceneGuide)
        end
      end
    else
      if nil ~= ConfigData then
        GuideUnitId = ConfigData.UnitId
        GuideType = self:GetGuideTypeByBPPath(ConfigData.GuideIconAni, ConfigData.GuideIconBPPath)
      end
      IsNeedLookUpEntity = true
      GuideName = GuideName .. tostring(TargetEid)
    end
    if nil == GuideName or "" == GuideName then
      print(_G.LogTag, "Warning ======= GuideName is nil !!!", GuideName, GuideType, TargetEid, TargetActor, TargetLocation, OpType)
      self.CurSceneGuideEids[TargetEid] = nil
      return
    end
    if nil ~= ConfigData and not ConfigData.GuideIconAni and nil ~= ConfigData.GuideIconBPPath then
      return
    end
    local TargetActorLocation
    if nil ~= TargetLocation then
      TargetActorLocation = UE4.FVector(TargetLocation.X, TargetLocation.Y, TargetLocation.Z)
    end
    local NotDataStruct = not IsDataStruct
    if NotDataStruct and ("Add" == OpType or "Modify" == OpType) then
      self.CurSceneGuideEids[TargetEid] = {
        Entity = TargetEid,
        IsDataStruct = false,
        IsPlayerEid = IsPlayerEid,
        IsActive = true
      }
    end
    DebugPrint("UpdateSceneGuideIcon START UpdateSceneGuideIcon_GetUIObjAsync" .. GuideName .. OpType)
    RunAsyncTask(self, "UpdateSceneGuideIcon_GetUIObjAsync" .. GuideName .. OpType, function(CoroutineObj)
      DebugPrint("UpdateSceneGuideIcon REAL START UpdateSceneGuideIcon_GetUIObjAsync" .. GuideName .. OpType)
      local GuideIcon = UIManager:GetUIObjAsync(GuideName, CoroutineObj) or UIManager:GetUIObjAsync(GuideName .. "Replace", CoroutineObj)
      if nil == GuideIcon and "Modify" == OpType then
        GuideIcon = self:GetGuideIconByEid(TargetEid)
      end
      TargetActor = nil
      if Battle(self) then
        TargetActor = Battle(self):GetEntity(TargetEid)
      end
      DebugPrint("UpdateSceneGuideIcon  GuideName is ", GuideName, GuideType, GuideUnitId, TargetEid, TargetActor, TargetActorLocation, OpType, IsUseRealDis, GuideIcon, IsNeedArrow)
      self:AddTimer(0.2, self.UpdateMiniMapGuideIcon, false, nil, "UpdateMiniMapGuideIcon" .. GuideName .. OpType, false, GuideName, OpType, TargetEid, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity)
      if nil ~= GuideIcon then
        if "Modify" == OpType or "Add" == OpType then
          GuideIcon:Reset(TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity, false, IsUseRealDis)
          if GuideIcon.IsFromPool then
            GuideIcon.IsActiveInPoor = true
          end
          self:AddTimer(0.1, self.AddGuideToPathFindingTimerFunc, false, nil, "AddGuideToPathFinding" .. TargetEid, false, TargetEid, false)
          self:UpdateAllGuideIconsByName(OpType, TargetEid, nil)
        elseif "Delete" == OpType then
          self:ProcessGuideIconBeforeClose(GuideIcon)
          GuideIcon:Disappear()
          self:RemoveGuideFromPathFinding(TargetEid)
          self:UpdateAllGuideIconsByName(OpType, TargetEid, nil)
        end
      elseif "Add" == OpType then
        local IsGuidePlayAnim = true
        if nil ~= ConfigData and ConfigData.IsReplace then
          GuideName = GuideName .. "Replace"
          IsGuidePlayAnim = false
        end
        if "Monster" == GuideType and ConfigData.GuideIconAni == UIConst.DUNGEONINDICATOR.Annihilate_S then
          local PoolClass = GameState:GetIndicatorBaseFromPool("Monster")
          if PoolClass then
            PoolClass.IsDungeonIndicator = true
            if nil == TargetActorLocation then
              TargetActorLocation = UE4.FVector(TargetActor:K2_GetActorLocation().X, TargetActor:K2_GetActorLocation().Y, TargetActor:K2_GetActorLocation().Z)
            end
            PoolClass:Reset(TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity, false, IsUseRealDis, true)
            PoolClass.IsActiveInPoor = true
            self:ProcessGuideIconAfterLoad(PoolClass, ConfigData.GuideIconAni, TargetEid)
            self:UpdateAllGuideIconsByName(OpType, TargetEid, PoolClass:GetName())
            self:AddTimer(0.1, self.AddGuideToPathFindingTimerFunc, false, nil, "AddGuideToPathFinding" .. TargetEid, false, TargetEid, true)
          else
            local NewGuideIcon = UIManager:LoadGuideIconAsync(ConfigData.GuideIconAni, GuideName, UIConst.ZORDER_FOR_INDICATORS, CoroutineObj, TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity, false, IsUseRealDis)
            self:ProcessGuideIconAfterLoad(NewGuideIcon, ConfigData.GuideIconAni, TargetEid)
            self:UpdateAllGuideIconsByName(OpType, TargetEid, GuideName)
            TargetActor = nil
            if Battle(self) then
              TargetActor = Battle(self):GetEntity(TargetEid)
            end
            self:AddTimer(0.1, self.AddGuideToPathFindingTimerFunc, false, nil, "AddGuideToPathFinding" .. TargetEid, false, TargetEid, true)
          end
        else
          local NewGuideIcon = UIManager:LoadGuideIconAsync(ConfigData.GuideIconAni, GuideName, UIConst.ZORDER_FOR_INDICATORS, CoroutineObj, TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity, false, IsUseRealDis)
          self:ProcessGuideIconAfterLoad(NewGuideIcon, ConfigData.GuideIconAni, TargetEid)
          self:UpdateAllGuideIconsByName(OpType, TargetEid, GuideName)
          self:AddTimer(0.1, self.AddGuideToPathFindingTimerFunc, false, nil, "AddGuideToPathFinding" .. TargetEid, false, TargetEid, true)
        end
      elseif "Delete" == OpType then
        EventManager:FireEvent(EventID.RecycleClassToCachePool, TargetEid)
        DebugPrint("UpdateSceneGuideIcon Real RecycleGuideIcon TargetEid:", TargetEid)
        self:RemoveGuideFromPathFinding(TargetEid)
        self:UpdateAllGuideIconsByName(OpType, TargetEid, nil)
      end
    end)
  end
end

function BP_SceneManagerComponent_C:UpdateMiniMapGuideIcon(GuideName, OpType, TargetEid, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity)
  if "Delete" == OpType then
    if self:IsExistTimer("UpdateMiniMapGuideIcon" .. GuideName .. "Add") then
      self:RemoveTimer("UpdateMiniMapGuideIcon" .. GuideName .. "Add")
    end
    if self:IsExistTimer("UpdateMiniMapGuideIcon" .. GuideName .. "Modify") then
      self:RemoveTimer("UpdateMiniMapGuideIcon" .. GuideName .. "Modify")
    end
  end
  local TargetActor
  if Battle(self) then
    TargetActor = Battle(self):GetEntity(TargetEid)
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  local battleMain = UIManager:GetUI("BattleMain")
  if not battleMain then
    if "Delete" == OpType then
      self.CacheGuideInfo[GuideName] = nil
    else
      self.CacheGuideInfo[GuideName] = {
        TargetActor,
        TargetActorLocation,
        ConfigData,
        TargetEid,
        IsNeedArrow,
        IsGuideFollowActor,
        IsNeedLookUpEntity
      }
    end
  else
    local MiniMap = battleMain.Battle_Map
    if MiniMap then
      MiniMap:UpdateGuideIcon(self, GuideName, OpType, TargetEid, TargetActor, TargetActorLocation, ConfigData, IsNeedArrow, IsGuideFollowActor, IsNeedLookUpEntity)
    end
  end
end

function BP_SceneManagerComponent_C:AddGuideToPathFindingTimerFunc(TargetEid, RequireBlockTickLod)
  local TargetActor
  if Battle(self) then
    TargetActor = Battle(self):GetEntity(TargetEid)
  end
  self:AddGuideToPathFinding(TargetActor, TargetEid, RequireBlockTickLod)
end

function BP_SceneManagerComponent_C:ProcessGuideIconAfterLoad(NewGuideIcon, GuideIconAni, TargetEid)
  if nil == NewGuideIcon then
    local EMGameState = UE4.UGameplayStatics.GetGameState(self)
    if EMGameState then
      EMGameState:ShowDungeonError("ProcessGuideIconAfterLoad Icon加载失败 请检查配表数据 GuideIconAni: " .. GuideIconAni .. "TargetEid: " .. TargetEid, Const.DungeonErrorType.DungeonIndicator, Const.DungeonErrorTitle.Config)
    end
    DebugPrint("Error ProcessGuideIconAfterLoad NewGuideIcon == nil GuideIconAni: ", GuideIconAni, "TargetEid: ", TargetEid)
    return
  end
  NewGuideIcon.IsDungeonIndicator = true
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  if not self.GuideIconMain then
    self.GuideIconMain = UIManager:LoadUINew("GuideIconMain")
  end
  self.GuideIconMain.GuideIconMain:AddChild(NewGuideIcon)
  self.GuideIconMain:AddGuideIcon(NewGuideIcon)
  NewGuideIcon:AttachEventOnLoaded()
end

function BP_SceneManagerComponent_C:ProcessGuideIconBeforeClose(GuideIcon)
  if self.GuideIconMain then
    self.GuideIconMain:DeleteGuideIcon(GuideIcon.WidgetName)
  end
  GuideIcon:RemoveFromParent()
  GuideIcon.IsInit = true
end

function BP_SceneManagerComponent_C:ShowOrHideAllSceneGuideIcon(IsShow, OpTag)
  self.IsSceneGuideShow = IsShow
  for k, v in pairs(self.CurSceneGuideEids) do
    RunAsyncTask(self, "ShowOrHideAllSceneGuideIcon_GetUIObjAsync" .. k, function(CoroutineObj)
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      local UIManager = GameInstance:GetGameUIManager()
      if nil == UIManager then
        return
      end
      local GuideName = tostring(k)
      local GuideIcon = UIManager:GetUIObjAsync(GuideName, CoroutineObj) or UIManager:GetUIObjAsync(GuideName .. "Replace", CoroutineObj)
      if nil == GuideIcon then
        local IconName = self.GuideIcons:FindRef(k)
        if IconName then
          GuideIcon = UIManager:GetUIObj(IconName)
        end
      end
      if nil ~= GuideIcon then
        if OpTag then
          if IsShow then
            GuideIcon:Show(OpTag)
          else
            GuideIcon:Hide(OpTag)
          end
        else
          GuideIcon:SetVisibilityNotOnDoor(IsShow)
        end
      end
    end)
  end
end

function BP_SceneManagerComponent_C:ShowOrHideSceneGuideIcon(Eid, IsShow, OpTag)
  if not OpTag then
    DebugPrint("Error: OpTag == nil 本接口必须传入显隐Tag")
    return
  end
  RunAsyncTask(self, "ShowOrHideSceneGuideIcon_GetUIObjAsync" .. Eid, function(CoroutineObj)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if nil == UIManager then
      return
    end
    local GuideName = tostring(Eid)
    local GuideIcon = UIManager:GetUIObjAsync(GuideName, CoroutineObj) or UIManager:GetUIObjAsync(GuideName .. "Replace", CoroutineObj)
    if nil == GuideIcon then
      local IconName = self.GuideIcons:FindRef(Eid)
      if IconName then
        GuideIcon = UIManager:GetUIObj(IconName)
      end
    end
    if nil ~= GuideIcon then
      if IsShow then
        GuideIcon:Show(OpTag)
      else
        GuideIcon:Hide(OpTag)
      end
    end
  end)
end

function BP_SceneManagerComponent_C:ExistPathfindingEid(TargetEid)
  return self.PathfindingEid:FindRef(TargetEid)
end

function BP_SceneManagerComponent_C:ShowOrHideGuideIconByGuideName(GuideName, IsShow)
  RunAsyncTask(self, "ShowOrHideGuideIconByGuideName_GetUIObjAsync" .. GuideName, function(CoroutineObj)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if not UIManager then
      return
    end
    local GuideIcon = UIManager:GetUIObjAsync(GuideName, CoroutineObj)
    if nil ~= GuideIcon then
      GuideIcon:SetVisibilityNotOnDoor(IsShow)
    end
  end)
end

function BP_SceneManagerComponent_C:GetAllKindsOfGuide()
  local UINames = TArray("")
  for k, v in pairs(self.GuideIcons) do
    local Name = v
    if nil ~= Name then
      UINames:Add(Name)
    end
  end
  return UINames
end

function BP_SceneManagerComponent_C:GetGuideIconByEid(Eid)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  if self.GuideIcons:FindRef(Eid) then
    local Name = self.GuideIcons:FindRef(Eid)
    local GuideIcon = UIManager:GetUIObj(Name)
    if GuideIcon and GuideIcon.TargetEid == Eid then
      return GuideIcon
    end
  end
  return nil
end

function BP_SceneManagerComponent_C:RefreshAllGuideStyle()
  local FrameCount = UE4.UKismetSystemLibrary.GetFrameCount()
  if FrameCount == self.PreFrameCount then
    return
  end
  self.PreFrameCount = FrameCount
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  local UINames, GuideUIInfo = self:GetAllKindsOfGuide(), {}
  for i = 1, UINames:Length() do
    local UIName = UINames:GetRef(i)
    local TargetEid = math.tointeger(UIName)
    local GuideIcon = UIManager:GetUIObj(UIName)
    if nil == GuideIcon then
      DebugPrint("RefreshAllGuideStyle: GuideIcon为空 UIName: ", UIName)
    else
      if nil ~= GuideIcon.TargetEid then
        TargetEid = GuideIcon.TargetEid
      end
      local KeyWord = GuideIcon:GetIconPathName()
      local GuideDistance = GuideIcon:GetRealDistance()
      local IsOnDoor = GuideIcon:CaluCurGuideNeedShowPos(TargetEid)
      if "" ~= KeyWord and nil ~= KeyWord and nil ~= TargetEid and 0 ~= TargetEid then
        local NextDoorName = "NotInDoor"
        if IsOnDoor and nil ~= self.Guide2InDoorNameMaps:Find(TargetEid) then
          NextDoorName = self.Guide2InDoorNameMaps:Find(TargetEid)
        end
        if nil == GuideUIInfo[KeyWord] then
          GuideUIInfo[KeyWord] = {
            {
              UIObj = GuideIcon,
              ShowDoorName = NextDoorName,
              Index = i,
              Name = UIName,
              GuideDis = GuideDistance
            }
          }
        else
          table.insert(GuideUIInfo[KeyWord], {
            UIObj = GuideIcon,
            ShowDoorName = NextDoorName,
            Index = i,
            Name = UIName,
            GuideDis = GuideDistance
          })
        end
      end
    end
  end
  for _, v in pairs(GuideUIInfo) do
    table.sort(v, function(Data1, Data2)
      if Data1.GuideDis ~= Data2.GuideDis then
        return Data1.GuideDis < Data2.GuideDis
      else
        return Data1.Index < Data2.Index
      end
    end)
  end
  for k, v in pairs(GuideUIInfo) do
    local NeedShowMultiList = {}
    local GuideIconCount = #v
    for i = 1, GuideIconCount do
      if nil ~= v[i].ShowDoorName and "" ~= v[i].ShowDoorName then
        if nil ~= NeedShowMultiList[v[i].ShowDoorName] then
          table.insert(NeedShowMultiList[v[i].ShowDoorName], i)
        else
          NeedShowMultiList[v[i].ShowDoorName] = {i}
        end
      end
    end
    for k1, v1 in pairs(NeedShowMultiList) do
      if "NotInDoor" == k1 or #v1 <= 1 then
        for i = 1, #v1 do
          local UIObj = v[v1[i]].UIObj
          UIObj:ChangeStyle(EIndicatorStyle.Single, 1)
          UIObj:SetVisibilityOnDoor(true)
        end
      else
        for i = 1, #v1 do
          local UIObj = v[v1[i]].UIObj
          UIObj:ChangeStyle(EIndicatorStyle.Single, 1)
          UIObj:SetVisibilityOnDoor(false)
        end
        local UIObj = v[v1[1]].UIObj
        UIObj:ChangeStyle(EIndicatorStyle.Multiple, #v1)
        UIObj:SetVisibilityOnDoor(true)
      end
    end
  end
end

function BP_SceneManagerComponent_C:RealArrangeAllGuideIcons()
  self:RefreshAllGuideStyle()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
  if nil == Player then
    DebugPrint("RealArrangeAllGuideIcons: Player 不存在")
    return
  end
  local UINames = self:GetAllKindsOfGuide()
  local TempTable = UINames:ToTable()
  local GuideUIInfo = {}
  for i = 1, UINames:Length() do
    local UIName = UINames:GetRef(i)
    local TargetEid = math.tointeger(UIName)
    local GuideIcon = UIManager:GetUIObj(UIName)
    if nil == GuideIcon then
      DebugPrint("RealArrangeAllGuideIcons: GuideIcon为空 UIName: ", UIName)
    else
      if nil ~= GuideIcon.TargetEid then
        TargetEid = GuideIcon.TargetEid
      end
      local IconAniKey
      if nil ~= GuideIcon.ConfigData then
        IconAniKey = GuideIcon.ConfigData.GuideIconAni
      end
      if GuideIcon.Visibility ~= UE4.ESlateVisibility.Collapsed and nil ~= self.Guide2InDoorNameMaps:Find(TargetEid) and nil ~= TargetEid and 0 ~= TargetEid then
        local DoorName = self.Guide2InDoorNameMaps:Find(TargetEid)
        if nil ~= DoorName and "" ~= DoorName then
          if nil == GuideUIInfo[DoorName] then
            local Sign = (FVector(Player:K2_GetActorLocation().X, Player:K2_GetActorLocation().Y, 0) - FVector(GuideIcon.DoorPosition.X, GuideIcon.DoorPosition.Y, 0)):Dot(FVector(GuideIcon.DoorDirection.X, GuideIcon.DoorDirection.Y, 0))
            if Sign >= 0 then
              Sign = 1
            else
              Sign = -1
            end
            GuideUIInfo[DoorName] = {
              {
                UIObj = GuideIcon,
                Index = i,
                Category = IconAniKey,
                Order = (FVector(GuideIcon.TargetPointPos.X, GuideIcon.TargetPointPos.Y, 0) - FVector(GuideIcon.DoorPosition.X, GuideIcon.DoorPosition.Y, 0)):Cross(FVector(GuideIcon.DoorDirection.X, GuideIcon.DoorDirection.Y, 0)).Z * Sign
              }
            }
          else
            local Sign = (FVector(Player:K2_GetActorLocation().X, Player:K2_GetActorLocation().Y, 0) - FVector(GuideIcon.DoorPosition.X, GuideIcon.DoorPosition.Y, 0)):Dot(FVector(GuideIcon.DoorDirection.X, GuideIcon.DoorDirection.Y, 0))
            if Sign >= 0 then
              Sign = 1
            else
              Sign = -1
            end
            local IsExited = false
            if nil ~= GuideUIInfo[DoorName] then
              for _, v in pairs(GuideUIInfo[DoorName]) do
                if v.UIObj.ConfigData.GuideIconAni == IconAniKey then
                  IsExited = true
                  break
                end
              end
            end
            if IsExited and not GuideIcon.IsNeedMultipleShow then
              table.insert(GuideUIInfo[DoorName], {
                UIObj = GuideIcon,
                Index = i,
                Category = IconAniKey,
                Order = (FVector(GuideIcon.TargetPointPos.X, GuideIcon.TargetPointPos.Y, 0) - FVector(GuideIcon.DoorPosition.X, GuideIcon.DoorPosition.Y, 0)):Cross(FVector(GuideIcon.DoorDirection.X, GuideIcon.DoorDirection.Y, 0)).Z * Sign
              })
            elseif not IsExited then
              table.insert(GuideUIInfo[DoorName], {
                UIObj = GuideIcon,
                Index = i,
                Category = IconAniKey,
                Order = (FVector(GuideIcon.TargetPointPos.X, GuideIcon.TargetPointPos.Y, 0) - FVector(GuideIcon.DoorPosition.X, GuideIcon.DoorPosition.Y, 0)):Cross(FVector(GuideIcon.DoorDirection.X, GuideIcon.DoorDirection.Y, 0)).Z * Sign
              })
            end
          end
        end
      end
    end
  end
  for _, v in pairs(GuideUIInfo) do
    table.sort(v, function(Data1, Data2)
      if Data1.Order ~= Data2.Order then
        return Data1.Order < Data2.Order
      else
        return Data1.Index < Data2.Index
      end
    end)
  end
  for _, GuideInfos in pairs(GuideUIInfo) do
    local TotalGuideCount = #GuideInfos
    local DoorName, LevelId
    if TotalGuideCount >= 1 and GuideInfos[1].UIObj:GetVisible() and nil ~= self.Guide2InDoorNameMaps:Find(GuideInfos[1].UIObj.TargetEid) and nil ~= GuideInfos[1].UIObj.TargetEid and 0 ~= GuideInfos[1].UIObj.TargetEid then
      DoorName = self.Guide2InDoorNameMaps:Find(GuideInfos[1].UIObj.TargetEid)
      LevelId = self.Guide2NextLevelIdMaps:Find(GuideInfos[1].UIObj.TargetEid)
    end
    local TempGuideObjsTable = {}
    local CategoryCount = 0
    for k, GuideInfo in pairs(GuideInfos) do
      local GuideIcon = GuideInfo.UIObj
      local IconAniKey = GuideIcon.ConfigData.GuideIconAni
      if nil == TempGuideObjsTable[IconAniKey] then
        TempGuideObjsTable[IconAniKey] = {GuideIcon}
      else
        table.insert(TempGuideObjsTable[IconAniKey], GuideIcon)
      end
    end
    for _, _ in pairs(TempGuideObjsTable) do
      CategoryCount = CategoryCount + 1
    end
    local DoorDummyDistance = 300
    local DeltaValue = DoorDummyDistance / (CategoryCount + 1)
    local Carry = DeltaValue
    for _, IconObjs in pairs(TempGuideObjsTable) do
      local Count = #IconObjs
      if 1 == Count then
        IconObjs[1].TargetOffsetOnDoor = -(DoorDummyDistance / 2)
        IconObjs[1].TargetOffsetOnDoor = IconObjs[1].TargetOffsetOnDoor + Carry
        Carry = Carry + DeltaValue
      else
        local ShortDoorDummyDistance = 150
        local ShortDeltaValue = ShortDoorDummyDistance / (Count + 1)
        local ShortCarry = ShortDeltaValue
        local IsMultiple = true
        for _, v in pairs(IconObjs) do
          if v.IsNeedMultipleShow then
            v.TargetOffsetOnDoor = -(DoorDummyDistance / 2)
            v.TargetOffsetOnDoor = v.TargetOffsetOnDoor + Carry
            Carry = Carry + DeltaValue
          else
            IsMultiple = false
            v.TargetOffsetOnDoor = -(DoorDummyDistance / 2)
            v.TargetOffsetOnDoor = v.TargetOffsetOnDoor + Carry
            v.TargetOffsetOnDoor = v.TargetOffsetOnDoor - ShortDoorDummyDistance / 2
            v.TargetOffsetOnDoor = v.TargetOffsetOnDoor + ShortCarry
            ShortCarry = ShortDeltaValue + ShortCarry
          end
        end
        if not IsMultiple then
          Carry = Carry + DeltaValue
        end
      end
    end
  end
end

function BP_SceneManagerComponent_C:ArrangeAllGuideIcons(TargetEid, DoorName, TargetDoorLocation)
  if "NotInDoor" == DoorName then
    self.Guide2NextLevelIdMaps:Remove(TargetEid)
    self.Guide2InDoorNameMaps:Remove(TargetEid)
    self:UpdateGuide2LevelDoorInfo(TargetEid, nil, nil, "Delete")
    self:AddTimer(0.1, self.RefreshAllGuideStyle, false, 0, "RefreshAllGuideStyle")
  elseif not self:IsExistTimer("RealArrangeAllGuideIcons") then
    self:AddTimer(0.1, self.RealArrangeAllGuideIcons, false, 0, "RealArrangeAllGuideIcons")
  end
  local battleMain = UIManager(self):GetUI("BattleMain")
  if not battleMain then
    return
  end
  local MiniMap = battleMain.Battle_Map
  if MiniMap then
    MiniMap:ArrangeGuideIcons(TargetEid, TargetDoorLocation, "NotInDoor" == DoorName)
  end
end

function BP_SceneManagerComponent_C:GetIsEnableScriptDetectionCheck()
  local CurrentPlatform = CommonUtils.GetDeviceTypeByPlatformName(self)
  local CurInputType = UIUtils.UtilsGetCurrentInputType()
  local IsCloudGame = UE4.UUCloudGameInstanceSubsystem.IsCloudGame()
  return CurrentPlatform == CommonConst.CLIENT_DEVICE_TYPE.PC and CurInputType == ECommonInputType.MouseAndKeyboard and not IsCloudGame
end

function BP_SceneManagerComponent_C:StartScriptDetectionCheck(CheckType)
  local bIsInDungeon = false
  local EMGameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
  if EMGameState and EMGameState:IsInDungeon() then
    bIsInDungeon = true
  end
  if CheckType == Const.ScriptDetectionCheckType.OnMouse then
    local IsNeedOpenCheck = false
    if bIsInDungeon then
      IsNeedOpenCheck = EMGameState.GameModeType ~= "ExtermPro"
    end
    if IsNeedOpenCheck then
      self.bNeedRecordThisTurn = false
      self.CurrentMouseLocation2D = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
      self:StartScriptDetectionCheck_OnMouse()
    end
  elseif CheckType == Const.ScriptDetectionCheckType.OnKeyboard and bIsInDungeon then
    self:StartScriptDetectionCheck_OnKeyboard()
  end
end

function BP_SceneManagerComponent_C:StartScriptDetectionCheck_OnMouse()
  if not self.ScriptDetectionCheck_OnMouse_Timer then
    self.ScriptDetectionCheck_OnMouse_Timer = self:AddTimer(1.0, function()
      local IsMouseNotMoved, IsWindowsActive = true, self:IsGameWindowActivated()
      local CurrentMouseLocation2D = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
      if self.CurrentMouseLocation2D ~= nil then
        IsMouseNotMoved = UE4.UKismetMathLibrary.EqualEqual_Vector2DVector2D(self.CurrentMouseLocation2D, CurrentMouseLocation2D, 0.001)
      end
      if self.CurrentCheckCountInScene < 10 then
        if not IsMouseNotMoved and IsWindowsActive then
          self:EndScriptDetectionCheck_OnMouse(false)
        end
      else
        local IsNeedRecordThisTurn = IsMouseNotMoved or not IsMouseNotMoved and not IsWindowsActive
        self:EndScriptDetectionCheck_OnMouse(IsNeedRecordThisTurn)
      end
      self.CurrentCheckCountInScene = self.CurrentCheckCountInScene + 1
    end, true, nil, "ScriptDetectionCheck_OnMouse_Timer")
  end
end

function BP_SceneManagerComponent_C:EndScriptDetectionCheck_OnMouse(bNeedRecordThisTurn)
  if self.ScriptDetectionCheck_OnMouse_Timer then
    self.bNeedRecordThisTurn = bNeedRecordThisTurn
    self:RemoveTimer(self.ScriptDetectionCheck_OnMouse_Timer)
    self.ScriptDetectionCheck_OnMouse_Timer = nil
    self.CurrentCheckCountInScene = 0
  end
end

function BP_SceneManagerComponent_C:StartScriptDetectionCheck_OnKeyboard()
  if self.SDCKeyboardOverTimeTimer then
    self:RemoveTimer(self.SDCKeyboardOverTimeTimer)
  end
  self.SDCKeyboardOverTimeTimer = self:AddTimer(SDC_KEY_OVERTIME, function()
    self:EndScriptDetectionCheck_OnKeyboard()
  end, false)
  self.bEnableKeyboardSDC = true
  self.KeyList = {}
end

function BP_SceneManagerComponent_C:EndScriptDetectionCheck_OnKeyboard()
  if self.SDCKeyboardOverTimeTimer then
    self:RemoveTimer(self.SDCKeyboardOverTimeTimer)
    self.SDCKeyboardOverTimeTimer = nil
  end
  if self.bEnableKeyboardSDC then
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    if GameInstance and self.KeyList and #self.KeyList >= SDC_MIN_KEYS_THRESHOLD then
      local Fingerprint = self:GetKeyListFingerprints(self.KeyList)
      if Fingerprint then
        GameInstance.KeyListRecord[Fingerprint] = (GameInstance.KeyListRecord[Fingerprint] or 0) + 1
        if GameInstance.KeyListRecord[Fingerprint] >= SDC_KEY_REPEAT_ALERT_CNT then
          self:ReportScriptDetection_Keyboard(Fingerprint)
        end
      end
    end
    self.bEnableKeyboardSDC = false
    self.KeyList = nil
  end
end

function BP_SceneManagerComponent_C:ReceivedInputKey(Key, EventType)
  local KeyName = Key.KeyName
  if UIConst.MouseButton[KeyName] then
    return
  end
  if self.bEnableKeyboardSDC then
    local TimeStamp = UE4.UGameplayStatics.GetTimeSeconds(self)
    local KeyList = self.KeyList or {}
    self.KeyList = KeyList
    KeyList[#KeyList + 1] = {
      KeyName,
      EventType,
      TimeStamp
    }
  end
end

function BP_SceneManagerComponent_C:ReportScriptDetection_Keyboard(Fingerprint)
  local PlayerAvatar = GWorld:GetAvatar()
  if PlayerAvatar then
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local EMGameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
    if GameInstance and EMGameState then
      local DungeonId = EMGameState.DungeonId
      local DungeonInfo = DataMgr.Dungeon[DungeonId]
      if DungeonInfo then
        local DungeonType = DungeonInfo.DungeonType or 0
        local RoundNum = 0
        local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
        if IsValid(GameState) then
          RoundNum = GameState.DungeonProgress
        end
        local RepeatCount = GameInstance.KeyListRecord[Fingerprint] or 0
        local AlertString = string.format(SDC_KEY_ALERT_STRING, DungeonId, DungeonType, RoundNum, RepeatCount)
        self:ReportCheatMsg(CommonConst.MonitorCheatType.Keyboard, AlertString)
      end
    end
  end
end

function BP_SceneManagerComponent_C:UpdateIfRecordThisTurnValue()
  if self.CurrentMouseLocation2D == nil then
    self.bNeedRecordThisTurn = false
    return
  end
  if not self.bNeedRecordThisTurn then
    DebugPrint("ScriptDetection== UpdateIfRecordThisTurnValue: 当前结果不需要最后校验, 已经是移动过鼠标的状态了！")
    return
  end
  local CurrentMouseLocation2D = UE4.UWidgetLayoutLibrary.GetMousePositionOnViewport(self)
  self.bNeedRecordThisTurn = UE4.UKismetMathLibrary.EqualEqual_Vector2DVector2D(self.CurrentMouseLocation2D, CurrentMouseLocation2D, 0.001)
end

function BP_SceneManagerComponent_C:CheckAndSendRecordToServer_OnMouse()
  local PlayerAvatar = GWorld:GetAvatar()
  if not PlayerAvatar then
    return
  end
  if self.bNeedRecordThisTurn then
    local EMGameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    EMGameInstance.ScriptDetectionCheckRecordNum = EMGameInstance.ScriptDetectionCheckRecordNum + 1
    DebugPrint("ScriptDetection== CheckAndSendRecordToServer_OnMouse: 未检测到鼠标移动，疑似使用脚本进行游戏操作，移除检测Timer，并且记录次数：", EMGameInstance.ScriptDetectionCheckRecordNum)
    if EMGameInstance.ScriptDetectionCheckRecordNum >= 5 then
      DebugPrint("ScriptDetection== CheckAndSendRecordToServer_OnMouse: 脚本检测上报，当前累计次数超过5次")
      local AlertString = "MonitorType: ScriptDetection "
      local EMGameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
      if EMGameState then
        local DungeonId = EMGameState.DungeonId
        if DungeonId then
          AlertString = AlertString .. "DungeonID: " .. DungeonId .. "  "
          local DungeonInfo = DataMgr.Dungeon[DungeonId]
          if DungeonInfo then
            if DungeonInfo.DungeonType then
              AlertString = AlertString .. "DungeonType: " .. DungeonInfo.DungeonType .. "  "
            end
            if DungeonInfo.DungeonLevel then
              AlertString = AlertString .. "DungeonLevel: " .. DungeonInfo.DungeonLevel .. "  "
            end
          end
        end
        AlertString = AlertString .. "Detection threshold for unoperated duration: 10s  "
      end
      self:ReportCheatMsg(CommonConst.MonitorCheatType.Mouse, AlertString)
    end
  else
    DebugPrint("ScriptDetection== CheckAndSendRecordToServer_OnMouse: 检测到结束前鼠标有过移动, 判定未使用脚本进行游戏操作, 若有临时记录数据也不算次数")
  end
end

function BP_SceneManagerComponent_C:OnDungeonEnd_ToSceneManager(IsWin, BattleInfo, DungeonType)
  DebugPrint("OnDungeonEnd_ToSceneManager: 副本结束通知，当前副本类型：", DungeonType)
  if self:GetIsEnableScriptDetectionCheck() then
    if "ExtermPro" ~= DungeonType then
      self:UpdateIfRecordThisTurnValue()
      self:CheckAndSendRecordToServer_OnMouse()
    end
    self:EndScriptDetectionCheck_OnKeyboard()
  end
end

function BP_SceneManagerComponent_C:GetLogMask()
  return _G.LogTag
end

function BP_SceneManagerComponent_C:CaluCurGuideNeedShowPos(TargetEid, TargetPosition, TargetDirection)
  if self:GetLevelLoader() == nil then
    return false, nil
  end
  local GuideLevelNextLevelId = self.Guide2NextLevelIdMaps:Find(TargetEid)
  local GuideLevelInDoorName = self.Guide2InDoorNameMaps:Find(TargetEid)
  if nil ~= GuideLevelNextLevelId and nil ~= GuideLevelInDoorName then
    return self.LevelLoader.LevelPathfinding:GetTargetActorGuideLocation(GuideLevelNextLevelId, GuideLevelInDoorName, TargetPosition, TargetDirection)
  end
  return false
end

function BP_SceneManagerComponent_C:AddFoorBox(FoorBox)
  if not self.FloorBoxArray then
    self.FloorBoxArray = {}
  end
  table.insert(self.FloorBoxArray, FoorBox)
end

function BP_SceneManagerComponent_C:AddMinimapDoor(Door)
  if not self.MinimapDoorArray then
    self.MinimapDoorArray = {}
  end
  table.insert(self.MinimapDoorArray, Door)
end

function BP_SceneManagerComponent_C:DelaySetFullScreen_Lua(Resolution, WindowMode)
  self:AddTimer(0.1, function()
    local GameUserSettings = UE4.UGameUserSettings:GetGameUserSettings()
    if GameUserSettings then
      DebugPrint("@zyh DelaySetFullScreen_Lua执行")
      GameUserSettings:SetFullscreenMode(WindowMode)
      GameUserSettings:ApplySettings(false)
    end
  end, false)
end

function BP_SceneManagerComponent_C:CleanSpecialMonsterInfo(Eid)
  if Eid then
    self.SpecialMonsterInfo[Eid] = nil
  end
end

function BP_SceneManagerComponent_C:GetKeyListFingerprints(KeyList)
  local SerializedStr = self:SerializeInputSequence(KeyList)
  local Fingerprint = Sha1.sha1(SerializedStr)
  return Fingerprint
end

function BP_SceneManagerComponent_C:SerializeInputSequence(KeyList)
  local t = {}
  local idx = 1
  for i, v in ipairs(KeyList) do
    local TimeDiff = 0
    if i > 1 then
      local RawDiff = v[3] - KeyList[i - 1][3]
      TimeDiff = math.floor(RawDiff / SDC_KEY_TIME_PRECISION + 0.5) * SDC_KEY_TIME_PRECISION
    end
    t[idx] = v[1]
    t[idx + 1] = v[2]
    t[idx + 2] = TimeDiff
    idx = idx + 3
  end
  return table.concat(t, "|")
end

function BP_SceneManagerComponent_C:ReportCheatMsg(CheatType, AlertString)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local JsonTable = {CheatMsg = AlertString}
  local JsonMsg = Json.encode(JsonTable)
  Avatar:CallServerMethod("SendCheatMsgToServer", CheatType, JsonMsg)
end

AssembleComponents(BP_SceneManagerComponent_C)
return BP_SceneManagerComponent_C
