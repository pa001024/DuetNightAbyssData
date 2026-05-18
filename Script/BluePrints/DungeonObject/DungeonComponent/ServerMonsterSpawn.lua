local ServerMonsterSpawn = DungeonClass.Class()
ServerMonsterSpawn.__Name__ = "ServerMonsterSpawn"
ServerMonsterSpawn.__Component__ = {}

function ServerMonsterSpawn:InitMonsterSpawn(UnitSpawnId, OnlyRelation, Manager)
  self:DebugPrint("ServerMonsterSpawn:InitMonsterSpawn UnitSpawnId " .. tostring(UnitSpawnId) .. " OnlyRelation " .. tostring(OnlyRelation))
  self.Manager = Manager
  self.UnitSpawnId = UnitSpawnId
  self.OnlyRelation = OnlyRelation
  self.Data = DataMgr.MonsterSpawn[UnitSpawnId]
  if not self.Data then
    self:DebugPrint("ServerMonsterSpawn:InitMonsterSpawn FMonsterSpawnData is nullptr, UnitSpawnId: " .. tostring(self.UnitSpawnId))
    self:TriggerDestroy(true, true)
    return
  end
  self.MonsterSpawnInfo = {}
  self.RelationSpawnInfo = {}
  if not self.Data.DetectTime or self.Data.DetectTime <= 0 then
    self:DebugPrint("ServerMonsterSpawn:InitMonsterSpawn DetectTime <= 0 , UnitSpawnId:" .. tostring(self.UnitSpawnId))
    self:TriggerDestroy(true, true)
    return
  end
  self.RealDetectTime = self.Data.DetectTime
  self:GetMultiInfoResFromClient()
end

function ServerMonsterSpawn:GetMultiInfoResFromClient()
  self.Manager:NotifyGameModeDungeonEvent("GetMultiInfoResFromClient", self.UnitSpawnId, self.OnlyRelation)
end

function ServerMonsterSpawn:OnReceiveMultiInfoRes(MultiInfoRes)
  self:DebugPrint("ServerMonsterSpawn::OnReceiveMultiInfoRes MultiInfoRes: " .. tostring(MultiInfoRes))
  self.MultiInfoRes = MultiInfoRes
  if self.InitSuccess then
    return
  end
  if self.OnlyRelation then
    self.bMainDestory = true
  else
    self.UnitSpawnTotalNum = self.Data.UnitSpawnTotalNum
    self.UnitSpawnAliveNum = self.UnitSpawnTotalNum
    self.UnitSpawningNum = 0
    self.MonsterSpawnInitInfo = {}
    self.MonsterSpawnInitInfoFix = {}
    self.MonsterSpawnInitInfoLevel = {}
    self.DetectTimeFlag = 0
    self:InitMonsterSpawnInfo()
  end
  self:InitRelationSpawn()
  self:SetLifeTime(self.Data.UnitSpawnLife)
  self.MonsterSpawnTimeHandle = self.Manager:AddLoopTimer(self.RealDetectTime, self.RealDetectTime, function()
    self:DetectMonsterSpawnInfo()
  end, nil)
  self.InitSuccess = true
end

function ServerMonsterSpawn:SetLifeTime(LifeTime)
  if nil == LifeTime or LifeTime <= 0 then
    return
  end
  self.Manager:AddTimer(LifeTime, function()
    self:TriggerDestroy(true, true)
  end, nil)
end

function ServerMonsterSpawn:InitMonsterSpawnInfo()
  if not self.Data then
    return
  end
  if not self.Data.MonsterSpawnInfos then
    return
  end
  for _, Info in pairs(self.Data.MonsterSpawnInfos) do
    self.MonsterSpawnInfo[Info.UnitId] = {}
    self.MonsterSpawnInitInfo[Info.UnitId] = Info.UnitNum
    self.MonsterSpawnInitInfoFix[Info.UnitId] = Info.UnitNumFix
    self.MonsterSpawnInitInfoLevel[Info.UnitId] = Info.UnitLevel
  end
  self:TriggerCreateMonsters()
end

function ServerMonsterSpawn:TriggerCreateMonsters()
  local DistributedInfo = self:GetCreateMonstersBaseInfo()
  local MonsterInfos = {}
  MonsterInfos.UnitSpawnId = self.UnitSpawnId
  MonsterInfos.IsRelation = false
  MonsterInfos.UnitInfos = {}
  for UnitId, UnitNum in pairs(DistributedInfo) do
    local UniqueIdsTable = {}
    for i = 1, UnitNum do
      local MonsterInfo = self.Manager:CreateMonster(UnitId, "MonsterSpawn", self.UnitSpawnId)
      table.insert(UniqueIdsTable, MonsterInfo.UniqueId)
      table.insert(self.MonsterSpawnInfo[UnitId], MonsterInfo.UniqueId)
      self:DebugPrint("HTYServerTest ServerMonsterSpawn:TriggerCreateMonsters " .. tostring(MonsterInfo.UniqueId) .. " " .. tostring(i))
    end
    MonsterInfos.UnitInfos[UnitId] = UniqueIdsTable
  end
  self.Manager:NotifyGameModeDungeonEvent("ServerMSCreateMonsters", MonsterInfos)
end

function ServerMonsterSpawn:GetCreateMonstersBaseInfo()
  local TotalNeedSpawnMonsterInfo = {}
  local RealMonsterSpawnInitInfo = self:GetRealMonsterSpawnInfo()
  local NextTriggeredCreate = self.FirstTriggeredCreate
  local FirstSpawnInfo = self:GetCreateMonsterTotalNeedNum(RealMonsterSpawnInitInfo)
  for UnitId, Infos in pairs(self.MonsterSpawnInfo) do
    local NowNum = #Infos
    local ExpectedNum = RealMonsterSpawnInitInfo[UnitId] or 0
    if NowNum < ExpectedNum then
      if not self.Data.FirstPercentFix or self.FirstTriggeredCreate == true then
        TotalNeedSpawnMonsterInfo[UnitId] = ExpectedNum - NowNum
      else
        TotalNeedSpawnMonsterInfo[UnitId] = math.ceil((ExpectedNum - NowNum) / FirstSpawnInfo[1] * FirstSpawnInfo[2])
        NextTriggeredCreate = true
      end
    end
  end
  self.FirstTriggeredCreate = NextTriggeredCreate
  return TotalNeedSpawnMonsterInfo
end

function ServerMonsterSpawn:GetRealMonsterSpawnInfo()
  local MultiPara = self:GetMultiInfoRes()
  local RefInfo = {}
  if 2 == self.DetectTimeFlag then
    RefInfo = self.MonsterSpawnInitInfoFix
  else
    RefInfo = self.MonsterSpawnInitInfo
  end
  if 1 == MultiPara then
    return RefInfo
  end
  local Res = {}
  for i, j in pairs(RefInfo) do
    Res[i] = math.ceil(j * MultiPara)
  end
  return Res
end

function ServerMonsterSpawn:GetCreateMonsterTotalNeedNum(RealMonsterSpawnInitInfo)
  local Res = {}
  local FirstNum = 0
  local TotalNeedNum = 0
  for UnitId, Infos in pairs(self.MonsterSpawnInfo) do
    if nil ~= RealMonsterSpawnInitInfo[UnitId] then
      local NowNum, ExpectedNum = #Infos, RealMonsterSpawnInitInfo[UnitId]
      if NowNum < ExpectedNum then
        TotalNeedNum = TotalNeedNum + ExpectedNum - NowNum
      end
    else
      self:DebugPrint("ServerMonsterSpawn::GetCreateMonsterTotalNeedNum   怪物刷新检测，出现不在预期内的UnitId  UnitId: " .. tostring(UnitId) .. " MonsterSpawnId " .. tostring(self.UnitSpawnId))
    end
  end
  local FirsetPercentFix = self.Data.FirstPercentFix or 0
  FirstNum = math.ceil(TotalNeedNum * FirsetPercentFix / 100)
  Res[1] = TotalNeedNum
  Res[2] = FirstNum
  return Res
end

function ServerMonsterSpawn:InitRelationSpawn()
  if not self.Data then
    return
  end
  self.RelationSpawnId = self.Data.RelationId
  if not self.RelationSpawnId then
    self:TriggerDestroy(false, true)
    return
  end
  self.RelationData = DataMgr.RelationSpawn[self.RelationSpawnId]
  if not self.RelationData then
    self:TriggerDestroy(false, true)
    return
  end
  self.RelationLength = math.min(#self.RelationData.UnitId, #self.RelationData.UnitWeight)
  self.TotalWeight = self:GetTotalWeight()
  self.RelationSpawnLevel = self.RelationData.UnitLevel or 0
  local RelationSpawnTotalNum = self.RelationData.RelationSpawnTotalNum
  if not RelationSpawnTotalNum then
    return
  end
  local RelationMultiInfo = self:GetRelationMultiInfo()
  self.RelationSpawnNum = RelationSpawnTotalNum[RelationMultiInfo]
  if not self.RelationSpawnNum then
    self:DebugPrint("ServerMonsterSpawn:InitRelationSpawn Invalid RelationSpawnTotalNum 检查一下RelationMultiInfo数量是不是填错了 RelationId: " .. tostring(self.RelationSpawnId) .. ", UnitSpawnId: " .. tostring(self.UnitSpawnId))
    return
  end
  local Info = {}
  self:RelationCreateMonsters(Info)
end

function ServerMonsterSpawn:RelationCreateMonsters(Info)
  local RelationDistributedInfo = Info
  if 0 == #Info then
    RelationDistributedInfo = self:GetRelationCMBaseInfo()
  end
  local MonsterInfos = {}
  MonsterInfos.UnitSpawnId = self.UnitSpawnId
  MonsterInfos.IsRelation = true
  MonsterInfos.UnitInfos = {}
  for UnitId, UnitNum in pairs(RelationDistributedInfo) do
    local UniqueIdsTable = {}
    for i = 1, UnitNum do
      local MonsterInfo = self.Manager:CreateMonster(UnitId, "MonsterSpawn", self.UnitSpawnId)
      table.insert(UniqueIdsTable, MonsterInfo.UniqueId)
      if not self.RelationSpawnInfo[UnitId] then
        self.RelationSpawnInfo[UnitId] = {}
      end
      table.insert(self.RelationSpawnInfo[UnitId], MonsterInfo.UniqueId)
      self:DebugPrint("ServerMonsterSpawn:RelationCreateMonsters" .. tostring(MonsterInfo.UniqueId) .. " " .. tostring(i))
    end
    MonsterInfos.UnitInfos[UnitId] = UniqueIdsTable
  end
  self.Manager:NotifyGameModeDungeonEvent("ServerMSCreateMonsters", MonsterInfos)
end

function ServerMonsterSpawn:GetRelationCMBaseInfo()
  local RelationInfo = {}
  for i = 1, self.RelationSpawnNum do
    local RelationUnitId = self:GetRelationUnitId()
    if RelationInfo[RelationUnitId] then
      RelationInfo[RelationUnitId] = RelationInfo[RelationUnitId] + 1
    else
      RelationInfo[RelationUnitId] = 1
    end
  end
  return RelationInfo
end

function ServerMonsterSpawn:GetRelationUnitId()
  local RandomValue = math.random(0, self.TotalWeight)
  local RandomCount = 0
  for i = 1, self.RelationLength do
    RandomCount = RandomCount + self.RelationData.UnitWeight[i]
    if RandomValue <= RandomCount then
      return self.RelationData.UnitId[i]
    end
  end
  return self.RelationData.UnitId[1]
end

function ServerMonsterSpawn:GetTotalWeight()
  local TotalWeight = 0
  for i = 1, self.RelationLength do
    TotalWeight = TotalWeight + self.RelationData.UnitWeight[i]
  end
  return TotalWeight
end

function ServerMonsterSpawn:GetRelationMultiInfo()
  return 1
end

function ServerMonsterSpawn:DetectMonsterSpawnInfo()
  if self.bIsPaused or self.bDestroyAll then
    return
  end
  if not self.bRelationDestory then
    self:DetectRelationSpawn()
  end
  if self.bMainDestory then
    return
  end
  local Res = self:DetectMonsterThreshold()
  self:UpdateDetectFix(Res)
end

function ServerMonsterSpawn:DetectMonsterThreshold()
  local UnitNum = self:GetMonsterSpawnInfoTotalNum()
  local TmpThreshold = self:GetMonsterThreshold()
  self:DebugPrint("ServerMonsterSpawn DetectMonsterThreshold  MonsterSpawnId:" .. tostring(self.UnitSpawnId) .. " NowNum:" .. tostring(UnitNum) .. " NowThreshold:" .. tostring(TmpThreshold))
  if UnitNum < TmpThreshold then
    self:TriggerCreateMonsters()
    self.TriggeredThreshold = true
  end
  if UnitNum <= TmpThreshold / 2 then
    return 1
  end
  return -1
end

function ServerMonsterSpawn:UpdateDetectFix(Res)
  local ClearFlag = false
  self.DetectTimeFlag = math.min(math.max(0, self.DetectTimeFlag + Res), 2)
  if 2 == self.DetectTimeFlag and self.Data.DetectTimeFix and self.Data.DetectTimeFix > 0 and self.RealDetectTime ~= self.Data.DetectTimeFix then
    self.RealDetectTime = self.Data.DetectTimeFix
    ClearFlag = true
  elseif 0 == self.DetectTimeFlag and self.Data.DetectTime and self.Data.DetectTime > 0 and self.RealDetectTime ~= self.Data.DetectTime then
    self.RealDetectTime = self.Data.DetectTime
    ClearFlag = true
  end
  if ClearFlag then
    self.Manager:RemoveTimer(self.MonsterSpawnTimeHandle)
    self.MonsterSpawnTimeHandle = self.Manager:AddLoopTimer(self.RealDetectTime, self.RealDetectTime, function()
      self:DetectMonsterSpawnInfo()
    end, nil)
    self.Manager:AddTimerHandlerToMap(self.UnitSpawnId, self.MonsterSpawnTimeHandle)
  end
end

function ServerMonsterSpawn:GetMonsterSpawnInfoTotalNum()
  local Res = 0
  for UnitId, Infos in pairs(self.MonsterSpawnInfo) do
    Res = Res + #Infos
  end
  return Res
end

function ServerMonsterSpawn:GetMonsterThreshold()
  local TmpThreshold = math.max(self.Data.Threshold * self:GetMultiInfoRes(), 0)
  if not self.Data.FirstPercentFix or self.FirstTriggeredThreshold then
    return math.ceil(TmpThreshold)
  end
  return math.ceil(TmpThreshold * self.Data.FirstPercentFix / 100)
end

function ServerMonsterSpawn:GetMultiInfoRes()
  return self.MultiInfoRes
end

function ServerMonsterSpawn:DetectRelationSpawn()
end

function ServerMonsterSpawn:IsRuleDestroy()
  return not self.bDestroyAll and self.bMainDestory and self.bRelationDestory
end

function ServerMonsterSpawn:TriggerDestroy(MainDestory, RelationDestory)
  self:DebugPrint("ServerMonsterSpawn::TriggerDestroy UnitSpawnId: " .. tostring(self.UnitSpawnId) .. " MainDestory: " .. tostring(MainDestory) .. " RelationDestory: " .. tostring(RelationDestory))
  self.bMainDestory = self.bMainDestory or MainDestory
  self.bRelationDestory = self.bRelationDestory or RelationDestory
  if self:IsRuleDestroy() then
    self.Manager:RealDestroyMonsterSpawn(self.UnitSpawnId)
  end
end

function ServerMonsterSpawn:TriggerPause()
  self:DebugPrint("ServerMonsterSpawn::TriggerPause UnitSpawnId: " .. tostring(self.UnitSpawnId))
  self.bIsPaused = true
end

function ServerMonsterSpawn:TriggerResume()
  self:DebugPrint("ServerMonsterSpawn::TriggerResume UnitSpawnId: " .. tostring(self.UnitSpawnId))
  self.bIsPaused = false
end

function ServerMonsterSpawn:TriggerMonsterDead(MonsterInfo)
  if nil == MonsterInfo then
    return
  end
  self:DebugPrint("HTYServerTest ServerMonsterSpawn::TriggerMonsterDead RelationSpawn: " .. tostring(MonsterInfo.RelationSpawn) .. " UniqueId: " .. tostring(MonsterInfo.UniqueId) .. " UnitId: " .. tostring(MonsterInfo.UnitId))
  if MonsterInfo.RelationSpawn then
    local RelationSpawnInfo = self.RelationSpawnInfo[MonsterInfo.UnitId]
    if not RelationSpawnInfo then
      return
    end
    for Index, UniqueId in pairs(RelationSpawnInfo) do
      if UniqueId == MonsterInfo.UniqueId then
        table.remove(RelationSpawnInfo, Index)
        break
      end
    end
  else
    local MonsterSpawnInfo = self.MonsterSpawnInfo[MonsterInfo.UnitId]
    if not MonsterSpawnInfo then
      return
    end
    self:ReduceMonsterSpawnInfo(MonsterInfo)
    self:UpdateMonsterSpawnAliveNum(-1)
  end
end

function ServerMonsterSpawn:ReduceMonsterSpawnInfo(MonsterInfo)
  local MonsterSpawnInfo = self.MonsterSpawnInfo[MonsterInfo.UnitId]
  if not MonsterSpawnInfo then
    return
  end
  for Index, UniqueId in pairs(MonsterSpawnInfo) do
    self:DebugPrint("ServerMonsterSpawn::ReduceMonsterSpawnInfo MonsterSpawnInfo: " .. tostring(Index) .. " UniqueId: " .. tostring(UniqueId) .. " MonsterInfo.UniqueId: " .. tostring(MonsterInfo.UniqueId))
    if UniqueId == MonsterInfo.UniqueId then
      table.remove(MonsterSpawnInfo, Index)
      break
    end
  end
end

function ServerMonsterSpawn:UpdateMonsterSpawnAliveNum(Count)
  if self.UnitSpawnAliveNum == nil or self.UnitSpawnAliveNum <= 0 then
    return
  end
  self.UnitSpawnAliveNum = self.UnitSpawnAliveNum + Count
  self:DebugPrint("ServerMonsterSpawn::UpdateMonsterSpawnAliveNum UnitSpawnId: " .. tostring(self.UnitSpawnId) .. " UnitSpawnAliveNum: " .. tostring(self.UnitSpawnAliveNum))
  if self.UnitSpawnAliveNum <= 0 then
    self:TriggerDestroy(true, false)
  end
end

function ServerMonsterSpawn:DebugPrint(Str)
  if self.Manager then
    self.Manager:DebugPrint(Str, self.UnitSpawnId)
  end
end

return ServerMonsterSpawn
