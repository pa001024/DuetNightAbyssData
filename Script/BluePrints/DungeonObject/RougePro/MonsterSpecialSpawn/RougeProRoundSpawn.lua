local RougeProRoundSpawn = DungeonClass.Class()
local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
RougeProRoundSpawn.__Name__ = "RougeProRoundSpawn"

function RougeProRoundSpawn:InitRougeProRoundSpawn(DungeonObj, SpawnId, MonsterSPId, ExtraParam)
  if not DungeonObj then
    return false
  end
  self.DungeonObj = DungeonObj
  local SpawnInfo = DataMgr.RougePro_MSRound[SpawnId]
  if not SpawnInfo then
    return false
  end
  self.SpawnId = SpawnId
  self.MonsterSPId = MonsterSPId
  self.ExtraParam = ExtraParam
  self.RoundTargetNum = SpawnInfo.MonsterTotalBaseNum
  self.StrongTargetNum = SpawnInfo.StrongKillCount
  self.RoundLevelFix = SpawnInfo.RoundLevelFix
  self.MonsterSpawnIds = SpawnInfo.MonsterSpawnId
  self.StrongSpawnIds = SpawnInfo.StrongLoopSpawnId
  self.CurRoundCount = 0
  self.CurStrongCount = 0
  self.CurRoundIndex = 0
  self.CurStrongIndex = 0
  self.CumulatedAddLevel = 0
  self:StartRound()
  self:StartStrong()
  self.DungeonObj:RougeProSpSpawnPrint("Start!", self)
  return true
end

function RougeProRoundSpawn:DestroyRougeProRoundSpawn()
  if self.LastSpanwnIdsCache then
    self.DungeonObj:SceneObjManagerSpawnMonsterPause(self.LastSpanwnIdsCache, true)
    self.LastSpanwnIdsCache = nil
  end
  if self.CumulatedAddLevel > 0 then
    self:ServerAddGameModeLevel(-self.CumulatedAddLevel)
  end
end

function RougeProRoundSpawn:StartRound()
  self.CurRoundCount = 0
  self.CurRoundIndex = self.CurRoundIndex + 1
  self.DungeonObj:RougeProSpSpawnPrint("StartRound. CurRoundIndex " .. self.CurRoundIndex, self)
  local ThisRoundSpawnIds = {}
  local RealIndex = (self.CurRoundIndex - 1) % #self.MonsterSpawnIds + 1
  for _, Id in pairs(self.MonsterSpawnIds[RealIndex]) do
    table.insert(ThisRoundSpawnIds, Id)
  end
  local MonsterObjAttr = RougeProSceneObjAttr()
  MonsterObjAttr:CopyFrom(self.ExtraParam)
  MonsterObjAttr:SetMonsterSpId(self.MonsterSPId)
  MonsterObjAttr:SetMonsterSpSpawnId(self.SpawnId)
  MonsterObjAttr:SetMonsterSpRoundIndex(self.CurRoundIndex)
  self.DungeonObj:SceneObjManagerSpawnMonsterTrigger(ThisRoundSpawnIds, MonsterObjAttr, false)
  self.LastSpanwnIdsCache = ThisRoundSpawnIds
end

function RougeProRoundSpawn:OnRoundEnd()
  if self.LastSpanwnIdsCache then
    self.DungeonObj:SceneObjManagerSpawnMonsterPause(self.LastSpanwnIdsCache, true)
    self.LastSpanwnIdsCache = nil
  end
  self:ServerAddGameModeLevel(self.RoundLevelFix)
  self:StartRound()
end

function RougeProRoundSpawn:ServerAddGameModeLevel(AddLevel)
  print("RougeProRoundSpawn:ServerAddGameModeLevel ", AddLevel)
  self.DungeonObj:NotifyGameModeDungeonEvent("AddGameModeLevel", AddLevel)
  self.CumulatedAddLevel = self.CumulatedAddLevel + AddLevel
end

function RougeProRoundSpawn:StartStrong()
  self.CurStrongCount = 0
  self.CurStrongIndex = self.CurStrongIndex + 1
  print("RougeProRoundSpawn Id " .. self.SpawnId .. " StartStrong. CurStrongIndex ", self.CurStrongIndex)
  local RealIndex = (self.CurStrongIndex - 1) % #self.StrongSpawnIds + 1
  local SpawnId = self.StrongSpawnIds[RealIndex]
  print("RougeProRoundSpawn:StartStrong StrongSpawnId", SpawnId)
  local MonsterObjAttr = RougeProSceneObjAttr()
  MonsterObjAttr:CopyFrom(self.ExtraParam)
  MonsterObjAttr:SetMonsterSpId(self.MonsterSPId)
  MonsterObjAttr:SetMonsterSpSpawnId(self.SpawnId)
  MonsterObjAttr:SetMonsterSpStrongIndex(self.CurStrongIndex)
  self.DungeonObj:SceneObjManagerSpawnMonsterTrigger({SpawnId}, MonsterObjAttr, false)
end

function RougeProRoundSpawn:OnMonsterDead(MonsterInfo)
  self.CurRoundCount = self.CurRoundCount + 1
  if self.CurRoundCount >= self.RoundTargetNum then
    self:OnRoundEnd()
  end
  self.CurStrongCount = self.CurStrongCount + 1
  if self.CurStrongCount >= self.StrongTargetNum then
    self:StartStrong()
  end
end

return RougeProRoundSpawn
