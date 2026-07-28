local ServerGroupMonsterSpawn = DungeonClass.Class("BluePrints.DungeonObject.DungeonComponent.ServerMonsterSpawn")
ServerGroupMonsterSpawn.__Name__ = "ServerGroupMonsterSpawn"
ServerGroupMonsterSpawn.__Component__ = {}

function ServerGroupMonsterSpawn:InitMonsterSpawn(UnitSpawnId, OnlyRelation, Manager)
  self.Manager = Manager
  self:DebugPrint("ServerGroupMonsterSpawn:InitMonsterSpawn UnitSpawnId " .. tostring(UnitSpawnId) .. " OnlyRelation " .. tostring(OnlyRelation))
  self.UnitSpawnId = UnitSpawnId
  self.OnlyRelation = false
  self.IsServerInit = true
  self.Data = DataMgr.MonsterSpawn[self.UnitSpawnId]
  if not self.Data then
    self:DebugPrint("ServerGroupMonsterSpawn:InitMonsterSpawn FMonsterSpawnData is nullptr, UnitSpawnId: " .. tostring(self.UnitSpawnId))
    self:TriggerDestroy(true, true)
    return
  end
  self.GroupSpawnId = self.Data.GroupSpawnId
  self.GroupSpawnData = DataMgr.MonsterGroupSpawn[self.GroupSpawnId]
  if not self.GroupSpawnData then
    self:DebugPrint("ServerGroupMonsterSpawn:InitMonsterSpawn GroupSpawnData is nullptr, UnitSpawnId: " .. tostring(self.UnitSpawnId) .. ", GroupSpawnId: " .. tostring(self.GroupSpawnId))
    self:TriggerDestroy(true, true)
    return
  end
  self:TriggerDestroy(false, true)
  self.MonsterSpawnInfo = {}
  self.RelationSpawnInfo = {}
  self.UnitSpawnTotalNum = -1
  self.UnitSpawnAliveNum = self.UnitSpawnTotalNum
  self.UnitSpawningNum = 0
  self.MonsterGroupIds = self.GroupSpawnData.MonsterGroupIds or {}
  self.GroupLimit = self.GroupSpawnData.GroupLimit or 0
  self.GroupThreshold = self.GroupSpawnData.GroupThreshold or 0
  self.GroupDetectTime = self.GroupSpawnData.GroupDetectTime or 0
  self.GroupDetectDelayTime = self.GroupSpawnData.GroupDetectDelayTime or 0
  self.GroupReplenishInterval = self.GroupSpawnData.GroupReplenishInterval or 0
  self.CloseGroupReplenish = self.GroupSpawnData.CloseGroupReplenish or false
  self.MultiInfoRes = 1
  self:InitGroupMonsterSpawnInfo()
  self:TriggerFirstGroupSpawn()
  self.InitSuccess = true
end

function ServerGroupMonsterSpawn:InitGroupMonsterSpawnInfo()
  self:DebugPrint("ServerGroupMonsterSpawn:InitGroupMonsterSpawnInfo UnitSpawnId " .. tostring(self.UnitSpawnId))
  self.MonsterGroupInfos = {}
  self.GroupNumber = {}
  self.GroupWeight = {}
  self.GroupLevel = {}
  self.GroupTotalWeight = 0
  for Index, GroupId in ipairs(self.MonsterGroupIds) do
    local MonsterGroupData = DataMgr.MonsterGroup[GroupId]
    local GroupInfo = {
      GroupId = GroupId,
      UnitIds = {},
      UnitProbs = {}
    }
    for _, Info in pairs(MonsterGroupData.MemberSpawnProb or {}) do
      local UnitId = Info.UnitId
      self.MonsterSpawnInfo[UnitId] = {}
      table.insert(GroupInfo.UnitIds, UnitId)
      table.insert(GroupInfo.UnitProbs, Info.UnitProb or 0)
    end
    self.MonsterGroupInfos[GroupId] = GroupInfo
    local GroupNumberList = self.GroupSpawnData.GroupNumber
    local GroupWeightList = self.GroupSpawnData.GroupWeight
    local GroupLevelList = self.GroupSpawnData.GroupLevel
    if GroupNumberList and nil ~= GroupNumberList[Index] and GroupWeightList and nil ~= GroupWeightList[Index] and GroupLevelList and nil ~= GroupLevelList[Index] then
      self.GroupNumber[GroupId] = GroupNumberList[Index]
      self.GroupWeight[GroupId] = GroupWeightList[Index]
      self.GroupTotalWeight = self.GroupTotalWeight + GroupWeightList[Index]
      self.GroupLevel[GroupId] = GroupLevelList[Index]
    else
      self:DebugPrint("AGroupMonsterSpawn::InitGroupMonsterSpawnInfo 组刷怪规则List参数没有和怪物组一一对应, GroupSpawnId:" .. tostring(self.GroupSpawnId))
      self:TriggerDestroy(true, true)
      return
    end
  end
end

function ServerGroupMonsterSpawn:GetStartTotalNeedSpawnMonsterInfo(TotalNeedSpawnMonsterInfo, GroupId)
  self:DebugPrint("ServerGroupMonsterSpawn:GetStartTotalNeedSpawnMonsterInfo GroupId: " .. tostring(GroupId))
  local GroupInfo = self.MonsterGroupInfos[GroupId]
  if not GroupInfo then
    return
  end
  for _, UnitId in ipairs(GroupInfo.UnitIds) do
    TotalNeedSpawnMonsterInfo[UnitId] = (TotalNeedSpawnMonsterInfo[UnitId] or 0) + 1
  end
end

function ServerGroupMonsterSpawn:GetStartCreateMonstersBaseInfo(GroupId)
  local TotalNeedSpawnMonsterInfo = {}
  self:GetStartTotalNeedSpawnMonsterInfo(TotalNeedSpawnMonsterInfo, GroupId)
  if not next(TotalNeedSpawnMonsterInfo) then
    self:DebugPrint("ServerGroupMonsterSpawn:GetStartCreateMonstersBaseInfo 没有初始要生成的怪物 MonsterSpawnId: " .. tostring(self.UnitSpawnId) .. " GroupSpawnId: " .. tostring(self.GroupSpawnId))
    return {}
  end
  return TotalNeedSpawnMonsterInfo
end

function ServerGroupMonsterSpawn:TriggerFirstGroupSpawn()
  local GroupBatchInfos = {}
  for _, GroupId in ipairs(self.MonsterGroupIds) do
    local CurrentGroupNumber = self.GroupNumber[GroupId] or 0
    for _ = 1, CurrentGroupNumber do
      local DistributedInfo = self:GetStartCreateMonstersBaseInfo(GroupId)
      if DistributedInfo and next(DistributedInfo) then
        local UnitInfos = self:CreateUnitInfosFromDistributedInfo(DistributedInfo, GroupId)
        table.insert(GroupBatchInfos, {GroupId = GroupId, UnitInfos = UnitInfos})
      end
    end
  end
  if #GroupBatchInfos > 0 then
    self:NotifyFirstGroupCreateMonsters(GroupBatchInfos)
  end
  if self.CloseGroupReplenish then
    return
  end
  if self.GroupDetectDelayTime > 0 then
    self:DebugPrint("ServerGroupMonsterSpawn:TriggerFirstGroupSpawn 延迟开始检测 UnitSpawnId: " .. tostring(self.UnitSpawnId) .. " GroupSpawnId: " .. tostring(self.GroupSpawnId) .. " GroupDetectDelayTime: " .. tostring(self.GroupDetectDelayTime))
    self.Manager:AddTimer(self.GroupDetectDelayTime, function()
      self:StartDetectGroupMonsterSpawn()
    end, nil)
  else
    self:DebugPrint("ServerGroupMonsterSpawn:TriggerFirstGroupSpawn 直接开始检测 UnitSpawnId: " .. tostring(self.UnitSpawnId) .. " GroupSpawnId: " .. tostring(self.GroupSpawnId))
    self:StartDetectGroupMonsterSpawn()
  end
end

function ServerGroupMonsterSpawn:StartDetectGroupMonsterSpawn()
  self:DebugPrint("ServerGroupMonsterSpawn:StartDetectGroupMonsterSpawn MonsterSpawnId: " .. tostring(self.UnitSpawnId) .. " GroupSpawnId: " .. tostring(self.GroupSpawnId))
  if self.GroupDetectTimeHandle then
    self.Manager:RemoveTimer(self.GroupDetectTimeHandle)
  end
  self.GroupDetectTimeHandle = self.Manager:AddLoopTimer(self.GroupDetectTime, self.GroupDetectTime, function()
    self:RealDetectGroupMonsterSpawn()
  end, nil)
  self.Manager:AddTimerHandlerToMap(self.UnitSpawnId, self.GroupDetectTimeHandle)
end

function ServerGroupMonsterSpawn:RealDetectGroupMonsterSpawn()
  if self.bIsPaused or self.bDestroyAll then
    return
  end
  local UnitNum = self:GetMonsterSpawnInfoTotalNum()
  self:DebugPrint("ServerGroupMonsterSpawn:RealDetectGroupMonsterSpawn MonsterSpawnId: " .. tostring(self.UnitSpawnId) .. " GroupSpawnId: " .. tostring(self.GroupSpawnId) .. " NowNum: " .. tostring(UnitNum) .. " GroupThreshold: " .. tostring(self.GroupThreshold))
  if UnitNum <= self.GroupThreshold then
    if self.GroupDetectTimeHandle then
      self.Manager:RemoveTimer(self.GroupDetectTimeHandle)
    end
    self.GroupDetectTimeHandle = self.Manager:AddLoopTimer(self.GroupReplenishInterval, self.GroupReplenishInterval, function()
      self:ReplenishGroupMonster()
    end, nil)
    self.Manager:AddTimerHandlerToMap(self.UnitSpawnId, self.GroupDetectTimeHandle)
    self:ReplenishGroupMonster()
  end
end

function ServerGroupMonsterSpawn:ReplenishGroupMonster()
  if self.bIsPaused or self.bDestroyAll then
    return
  end
  local UnitNum = self:GetMonsterSpawnInfoTotalNum()
  self:DebugPrint("ServerGroupMonsterSpawn:ReplenishGroupMonster MonsterSpawnId: " .. tostring(self.UnitSpawnId) .. " GroupSpawnId: " .. tostring(self.GroupSpawnId) .. " NowNum: " .. tostring(UnitNum) .. " GroupLimit: " .. tostring(self.GroupLimit))
  if UnitNum >= self.GroupLimit then
    self:StartDetectGroupMonsterSpawn()
    return
  end
  self:TriggerCreateMonsters()
end

function ServerGroupMonsterSpawn:GetGroupMonsterLevel(GroupId)
  if not self.Data.RegularLevel then
    return self.GroupLevel[GroupId] or 0
  end
  return math.max(self.GroupLevel[GroupId] or 1, 1)
end

function ServerGroupMonsterSpawn:GetTotalNeedSpawnMonsterInfo(TotalNeedSpawnMonsterInfo)
  local RandomValue = math.random(1, self.GroupTotalWeight)
  local RandomCount = 0
  local MonsterGroupId = self.MonsterGroupIds[1]
  for _, CurrentMonsterGroupId in ipairs(self.MonsterGroupIds) do
    RandomCount = RandomCount + self.GroupWeight[CurrentMonsterGroupId]
    if RandomValue <= RandomCount then
      MonsterGroupId = CurrentMonsterGroupId
      break
    end
  end
  self:DebugPrint("ServerGroupMonsterSpawn:GetTotalNeedSpawnMonsterInfo MonsterGroupId: " .. tostring(MonsterGroupId))
  self.CurrentGroupId = MonsterGroupId
  local GroupInfo = self.MonsterGroupInfos[MonsterGroupId]
  if not GroupInfo then
    return
  end
  for IdIndex, UnitId in ipairs(GroupInfo.UnitIds) do
    local Prob = GroupInfo.UnitProbs[IdIndex] or 0
    if Prob >= math.random() then
      TotalNeedSpawnMonsterInfo[UnitId] = (TotalNeedSpawnMonsterInfo[UnitId] or 0) + 1
    end
  end
end

function ServerGroupMonsterSpawn:GetCreateMonstersBaseInfo()
  local TotalNeedSpawnMonsterInfo = {}
  self:GetTotalNeedSpawnMonsterInfo(TotalNeedSpawnMonsterInfo)
  if not next(TotalNeedSpawnMonsterInfo) then
    self:DebugPrint("ServerGroupMonsterSpawn:GetCreateMonstersBaseInfo 本轮没有概率生成的怪物 MonsterSpawnId: " .. tostring(self.UnitSpawnId) .. " GroupSpawnId: " .. tostring(self.GroupSpawnId))
    return {}
  end
  return TotalNeedSpawnMonsterInfo
end

function ServerGroupMonsterSpawn:TriggerCreateMonsters()
  local DistributedInfo = self:GetCreateMonstersBaseInfo()
  if not DistributedInfo or not next(DistributedInfo) then
    return
  end
  self:GroupCreateMonsters(DistributedInfo, false, self.CurrentGroupId)
end

function ServerGroupMonsterSpawn:CreateUnitInfosFromDistributedInfo(DistributedInfo, GroupId)
  local UnitInfos = {}
  for UnitId, UnitNum in pairs(DistributedInfo) do
    local UniqueIdsTable = {}
    for i = 1, UnitNum do
      local MonsterInfo = self.Manager:CreateMonster(UnitId, "MonsterSpawn", self.UnitSpawnId)
      table.insert(UniqueIdsTable, MonsterInfo.UniqueId)
      table.insert(self.MonsterSpawnInfo[UnitId], MonsterInfo.UniqueId)
      self:DebugPrint("ServerGroupMonsterSpawn:CreateUnitInfosFromDistributedInfo GroupId: " .. tostring(GroupId) .. " UniqueId: " .. tostring(MonsterInfo.UniqueId) .. " UnitId: " .. tostring(UnitId) .. " " .. tostring(i))
    end
    UnitInfos[UnitId] = UniqueIdsTable
  end
  return UnitInfos
end

function ServerGroupMonsterSpawn:NotifyFirstGroupCreateMonsters(GroupBatchInfos)
  local MonsterInfos = {
    UnitSpawnId = self.UnitSpawnId,
    IsRelation = false,
    IsGroupSpawn = true,
    IsFirstSpawn = true,
    GroupBatchInfos = GroupBatchInfos
  }
  self.Manager:NotifyGameModeDungeonEvent("ServerMSCreateMonsters", MonsterInfos)
end

function ServerGroupMonsterSpawn:GroupCreateMonsters(DistributedInfo, IsFirstSpawn, GroupId)
  if not DistributedInfo or not next(DistributedInfo) then
    return
  end
  if not GroupId then
    self:DebugPrint("ServerGroupMonsterSpawn:GroupCreateMonsters GroupId is nil, UnitSpawnId: " .. tostring(self.UnitSpawnId))
    return
  end
  local MonsterInfos = {
    UnitSpawnId = self.UnitSpawnId,
    IsRelation = false,
    IsGroupSpawn = true,
    IsFirstSpawn = IsFirstSpawn,
    CurrentGroupId = GroupId,
    UnitInfos = self:CreateUnitInfosFromDistributedInfo(DistributedInfo, GroupId)
  }
  self.Manager:NotifyGameModeDungeonEvent("ServerMSCreateMonsters", MonsterInfos)
end

return ServerGroupMonsterSpawn
