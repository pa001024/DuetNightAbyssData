local AutoChessBuffManager = {}
local AutoChessDataModel = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local DefaultItemActorBp = "/Game/BluePrints/Combat/MechanismSummon/Monster/BP_Activity_Zizouqi.BP_Activity_Zizouqi"
local BuffFXSpawnZOffset = 50

function AutoChessBuffManager:OnBattleStartInitEquipBuff()
  local PlayerChessInfos = self:GetCurrentChessMonsterInfo(false)
  local EnemyChessInfos = self:GetCurrentChessMonsterInfo(true)
  local MissionId = self.MissionId
  
  local function AddBuffToChess(Index, ChessInfo)
    local Entity = Battle(self):GetEntity(ChessInfo.Eid)
    if not IsValid(Entity) then
      DebugPrint("AutoChess@ 找不到Eid对应单位，Index = ", Index)
      return
    end
    local EquipInfos = ChessInfo.EquipList or {}
    for _, EquipId in pairs(EquipInfos) do
      local AutoChessEquipData = DataMgr.RobotEquip[EquipId]
      if AutoChessEquipData.AttrBuffId then
        UBattleFunctionLibrary.AddBuffToTarget(Entity, Entity, AutoChessEquipData.AttrBuffId, -1, nil, nil, 1)
      end
      if AutoChessEquipData.ExtraBuffId then
        UBattleFunctionLibrary.AddBuffToTarget(Entity, Entity, AutoChessEquipData.ExtraBuffId, -1, nil, nil, 1)
      end
    end
  end
  
  for Index, ChessInfo in pairs(PlayerChessInfos) do
    AddBuffToChess(Index, ChessInfo)
  end
  for Index, ChessInfo in pairs(EnemyChessInfos) do
    AddBuffToChess(Index, ChessInfo)
  end
end

function AutoChessBuffManager:GetActiveChallengeBuffIdList()
  local ChallengeBuffIdList = {}
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.AutoChess then
    return ChallengeBuffIdList
  end
  if self.IsShareEditMode and self:IsShareEditMode() then
    local SquadIdx = AutoChessDataModel:GetEditingSuqadIndex() or 1
    local Squad = Avatar.AutoChess.SharedSquads and Avatar.AutoChess.SharedSquads[SquadIdx]
    if Squad and Squad.Buffs then
      for _, BuffId in ipairs(Squad.Buffs) do
        if AutoChessDataModel:IsWeatherBuff(BuffId) or AutoChessDataModel:IsChallengeBuff(BuffId) or AutoChessDataModel:IsFieldBuff(BuffId) then
          table.insert(ChallengeBuffIdList, BuffId)
        end
      end
    end
    return ChallengeBuffIdList
  end
  if self.IsShareChallenge then
    return self.EnemyBuffs
  end
  
  local function AppendBuffSet(BuffSet)
    if not BuffSet then
      return
    end
    for BuffId, _ in pairs(BuffSet) do
      table.insert(ChallengeBuffIdList, BuffId)
    end
  end
  
  AppendBuffSet(Avatar.AutoChess.DailyChallengeBuffs)
  AppendBuffSet(Avatar.AutoChess.ChallengeBuffs)
  return ChallengeBuffIdList
end

function AutoChessBuffManager:GetWeatherBuffIdList()
  local BuffIdList = {}
  for _, ChallengeBuffId in ipairs(self:GetActiveChallengeBuffIdList()) do
    local ChallengeBuffData = DataMgr.ChallengeBuff[ChallengeBuffId]
    if ChallengeBuffData and ChallengeBuffData.ActualBuffList and 1 == ChallengeBuffData.BuffType then
      for _, BuffId in ipairs(ChallengeBuffData.ActualBuffList) do
        table.insert(BuffIdList, BuffId)
      end
    end
  end
  return BuffIdList
end

function AutoChessBuffManager:GetChallengeBuffIdList()
  local BuffIdList = {}
  for _, ChallengeBuffId in ipairs(self:GetActiveChallengeBuffIdList()) do
    local ChallengeBuffData = DataMgr.ChallengeBuff[ChallengeBuffId]
    if ChallengeBuffData and ChallengeBuffData.ActualBuffList and 2 == ChallengeBuffData.BuffType then
      for _, BuffId in ipairs(ChallengeBuffData.ActualBuffList) do
        table.insert(BuffIdList, BuffId)
      end
    end
  end
  return BuffIdList
end

function AutoChessBuffManager:ForEachChallengeFormatItem(Callback)
  if not Callback then
    return
  end
  for _, ChallengeBuffId in ipairs(self:GetActiveChallengeBuffIdList()) do
    local ChallengeBuffData = DataMgr.ChallengeBuff[ChallengeBuffId]
    if not ChallengeBuffData or not ChallengeBuffData.AutoChessFormatId then
    else
      local ACFormations = DataMgr.AutoChessFormat[ChallengeBuffData.AutoChessFormatId]
      if not ACFormations then
      else
        for Location, Info in pairs(ACFormations) do
          if type(Location) ~= "string" or type(Info) ~= "table" or not Info.Item then
          else
            local CubeIndex = Location:match("^ACLocation(%d+)$")
            if not CubeIndex then
            else
              CubeIndex = tonumber(CubeIndex) - 1
              for _, ItemId in pairs(Info.Item) do
                Callback(CubeIndex, ItemId, ChallengeBuffId)
              end
            end
          end
        end
      end
    end
  end
end

function AutoChessBuffManager:GetCubeIndexToItemBuffIdList()
  local CubeIndexToBuffIds = {}
  self:ForEachChallengeFormatItem(function(CubeIndex, ItemId)
    local ItemBuffData = DataMgr.AutoChessItemBuff[ItemId]
    if not ItemBuffData or not ItemBuffData.BuffId then
      return
    end
    CubeIndexToBuffIds[CubeIndex] = CubeIndexToBuffIds[CubeIndex] or {}
    if type(ItemBuffData.BuffId) == "table" then
      for _, BuffId in ipairs(ItemBuffData.BuffId) do
        table.insert(CubeIndexToBuffIds[CubeIndex], BuffId)
      end
    else
      table.insert(CubeIndexToBuffIds[CubeIndex], ItemBuffData.BuffId)
    end
  end)
  return CubeIndexToBuffIds
end

function AutoChessBuffManager:AddBuffListToTarget(Entity, BuffIdOrList)
  if not IsValid(Entity) or not BuffIdOrList then
    return
  end
  if type(BuffIdOrList) == "table" then
    for _, BuffId in ipairs(BuffIdOrList) do
      UBattleFunctionLibrary.AddBuffToTarget(Entity, Entity, BuffId, -1, nil, nil, 1)
    end
  else
    UBattleFunctionLibrary.AddBuffToTarget(Entity, Entity, BuffIdOrList, -1, nil, nil, 1)
  end
end

function AutoChessBuffManager:OnBattleStartInitItemBuff()
  if self:IsLinearMission(self.MissionId) then
    DebugPrint("AutoChess@ 线性关卡不初始化道具buff")
    return
  end
  local PlayerChessInfos = self:GetCurrentChessMonsterInfo(false) or {}
  local EnemyChessInfos = self:GetCurrentChessMonsterInfo(true) or {}
  local WeatherBuffIdList = self:GetWeatherBuffIdList()
  local CubeIndexToItemBuffIdList = self:GetCubeIndexToItemBuffIdList()
  local ChallengeBuffIdList = self:GetChallengeBuffIdList()
  
  local function AddBuffToChess(CubeIndex, ChessInfo, bIsEnemy)
    if not ChessInfo or not ChessInfo.Eid then
      return
    end
    local Entity = Battle(self):GetEntity(ChessInfo.Eid)
    if not IsValid(Entity) then
      DebugPrint("AutoChess@ 找不到Eid对应单位，Index = ", CubeIndex)
      return
    end
    if self.IsShareChallenge then
      self:AddBuffListToTarget(Entity, CubeIndexToItemBuffIdList[CubeIndex])
    elseif not bIsEnemy then
      self:AddBuffListToTarget(Entity, CubeIndexToItemBuffIdList[CubeIndex])
    end
    self:AddBuffListToTarget(Entity, WeatherBuffIdList)
    self:AddBuffListToTarget(Entity, ChallengeBuffIdList)
  end
  
  for CubeIndex, ChessInfo in pairs(PlayerChessInfos) do
    AddBuffToChess(CubeIndex, ChessInfo, false)
  end
  for CubeIndex, ChessInfo in pairs(EnemyChessInfos) do
    AddBuffToChess(CubeIndex, ChessInfo, true)
  end
end

function AutoChessBuffManager:OnStartMotivateBuff()
  local PlayerChessInfos = self:GetCurrentChessMonsterInfo(false)
  local EnemyChessInfos = self:GetCurrentChessMonsterInfo(true)
  
  local function AddMotivateBuffToChess(Index, ChessInfo)
    local Entity = Battle(self):GetEntity(ChessInfo.Eid)
    if not IsValid(Entity) then
      DebugPrint("AutoChess@ 找不到Eid对应单位，Index = ", Index)
      return
    end
    local MissionData = DataMgr.AutoChessMission[self.MissionId]
    if MissionData and MissionData.RegularBuffId then
      UBattleFunctionLibrary.AddBuffToTarget(Entity, Entity, MissionData.RegularBuffId, -1, nil, nil, 1)
    end
  end
  
  for Index, ChessInfo in pairs(PlayerChessInfos) do
    AddMotivateBuffToChess(Index, ChessInfo)
  end
  for Index, ChessInfo in pairs(EnemyChessInfos) do
    AddMotivateBuffToChess(Index, ChessInfo)
  end
end

function AutoChessBuffManager:InitBuffFX()
  if self:IsLinearMission(self.MissionId) then
    DebugPrint("AutoChess@ 线性关卡不初始化buff特效")
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.AutoChess then
    return
  end
  local Formation = self.AutoChessFormation or self:GetAutoChessFormation()
  if not Formation or not IsValid(Formation) then
    return
  end
  local ChallengeBuffIdList = self:GetActiveChallengeBuffIdList()
  if 0 == #ChallengeBuffIdList then
    return
  end
  self.BuffFXActors = self.BuffFXActors or {}
  for _, ChallengeBuffId in ipairs(ChallengeBuffIdList) do
    local ChallengeBuffData = DataMgr.ChallengeBuff[ChallengeBuffId]
    if not ChallengeBuffData then
    else
      if ChallengeBuffData.ItemActorBp then
        self:SpawnChallengeBuffFX(Formation, ChallengeBuffData.ItemActorBp)
      end
      if not ChallengeBuffData.AutoChessFormatId then
      else
        local ACFormations = DataMgr.AutoChessFormat[ChallengeBuffData.AutoChessFormatId]
        if not ACFormations then
        else
          for Location, Info in pairs(ACFormations) do
            if type(Location) ~= "string" or type(Info) ~= "table" or not Info.Item then
            else
              local CubeIndex = Location:match("^ACLocation(%d+)$")
              if not CubeIndex then
              else
                CubeIndex = tonumber(CubeIndex) - 1
                for _, ItemId in pairs(Info.Item) do
                  self:SpawnBuffFXOnCube(Formation, CubeIndex, ItemId)
                end
                if self.IsShareChallenge then
                  for _, ItemId in pairs(Info.Item) do
                    self:SpawnBuffFXOnCube(Formation, CubeIndex, ItemId, true)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

function AutoChessBuffManager:ClearBuffFX()
  if not self.BuffFXActors then
    self.BuffFXActors = {}
    return
  end
  for _, FXActor in ipairs(self.BuffFXActors) do
    if IsValid(FXActor) then
      FXActor:K2_DestroyActor()
    end
  end
  self.BuffFXActors = {}
end

function AutoChessBuffManager:ResetBuffFX()
  self:ClearBuffFX()
  self:InitBuffFX()
end

function AutoChessBuffManager:SpawnChallengeBuffFX(Formation, ItemActorBp)
  if not (Formation and IsValid(Formation)) or not ItemActorBp then
    return
  end
  local Loc = Formation:K2_GetActorLocation()
  Loc.Z = Loc.Z + BuffFXSpawnZOffset
  local SpawnTransform = UE4.FTransform(Formation:K2_GetActorRotation():ToQuat(), Loc)
  self:SpawnBuffFXActor(Formation, ItemActorBp, SpawnTransform)
end

function AutoChessBuffManager:SpawnBuffFXOnCube(Formation, CubeIndex, ItemId, bIsEnemy)
  local ItemBuffData = DataMgr.AutoChessItemBuff[ItemId]
  if not ItemBuffData then
    return
  end
  local CubeActor
  if bIsEnemy then
    CubeActor = Formation.Index2EnemyCube and Formation.Index2EnemyCube[CubeIndex]
  else
    CubeActor = Formation.Index2Cube and Formation.Index2Cube[CubeIndex]
  end
  if not CubeActor or not IsValid(CubeActor) then
    return
  end
  local Loc = CubeActor:K2_GetActorLocation()
  Loc.Z = Loc.Z + BuffFXSpawnZOffset
  local SpawnTransform = UE4.FTransform(CubeActor:K2_GetActorRotation():ToQuat(), Loc)
  local ItemActorBp = ItemBuffData.ItemActorBp or DefaultItemActorBp
  self:SpawnBuffFXActor(Formation, ItemActorBp, SpawnTransform)
end

function AutoChessBuffManager:SpawnBuffFXActor(Formation, ItemActorBp, SpawnTransform)
  local ItemActorClass = LoadClass(ItemActorBp or DefaultItemActorBp)
  if not ItemActorClass then
    return
  end
  local FXActor = GWorld.GameInstance:GetWorld():SpawnActor(ItemActorClass, SpawnTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, nil, Formation, nil)
  if IsValid(FXActor) then
    table.insert(self.BuffFXActors, FXActor)
  end
end

function AutoChessBuffManager:IsLinearMission(MissionId)
  MissionId = MissionId or self.MissionId
  local MissionData = MissionId and DataMgr.AutoChessMission[MissionId]
  return nil ~= MissionData and MissionData.MissionType == AutoChessConst.LevelSelectType.Linear
end

return AutoChessBuffManager
