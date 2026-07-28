local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougeProMonsterSpecialSpawnManager = DungeonClass.Class()
local RougeProRoundSpawn = require("BluePrints.DungeonObject.RougePro.MonsterSpecialSpawn.RougeProRoundSpawn")
RougeProMonsterSpecialSpawnManager.__Component__ = {}

function RougeProMonsterSpecialSpawnManager:BeginPlay()
  self.RoundSpawnMap = {}
end

function RougeProMonsterSpecialSpawnManager:TriggerRougeProMonsterSpecialSpawn(MonsterSPId, ExtraParam)
  print(string.format("TriggerRougeProMonsterSpecialSpawn MonsterSP=%s, ExtraParam=%s", tostring(MonsterSPId), CommonUtils.TableToString3(ExtraParam)))
  local tabMonsterSP = DataMgr.RougePro_MonsterSP[MonsterSPId]
  if not tabMonsterSP then
    print(string.format("TriggerRougeProMonsterSpecialSpawn MonsterSP=%s error tabMonsterSP == nil", tostring(MonsterSPId)))
    return
  end
  if tabMonsterSP.SpawnMonsterId then
    local MonsterAttr = RougeProSceneObjAttr()
    MonsterAttr:CopyFrom(ExtraParam)
    MonsterAttr:SetMonsterSpId(MonsterSPId)
    self:SceneObjManagerSpawnMonsterTrigger(tabMonsterSP.SpawnMonsterId, MonsterAttr, false)
  end
  if tabMonsterSP.StaticPointId then
    local MonsterAttr = RougeProSceneObjAttr()
    MonsterAttr:CopyFrom(ExtraParam)
    MonsterAttr:SetMonsterSpId(MonsterSPId)
    self:SceneObjManagerStaticCreatorActive(tabMonsterSP.StaticPointId, MonsterAttr)
  end
  if tabMonsterSP.RoundId then
    self:CreateRougeMonsterSp_RoundSpawn(MonsterSPId, ExtraParam)
  end
end

function RougeProMonsterSpecialSpawnManager:StopRougeProMonsterSpecialSpawn(MonsterSPId)
  local tabMonsterSP = DataMgr.RougePro_MonsterSP[MonsterSPId]
  if not tabMonsterSP then
    return
  end
  print(string.format("RemvoeRougeProMonsterSpecialSpawn MonsterSP=%s", tostring(MonsterSPId)))
  if tabMonsterSP.SpawnMonsterId then
    self:SceneObjManagerSpawnMonsterPause(tabMonsterSP.SpawnMonsterId, true)
  end
  if tabMonsterSP.StaticPointId then
    self:SceneObjManagerStaticCreatorDestroy(tabMonsterSP.StaticPointId)
  end
  if tabMonsterSP.RoundId then
    self:StopRougeMonsterSp_RoundSpawn(MonsterSPId)
  end
end

function RougeProMonsterSpecialSpawnManager:RougePro_DungeonMonsterDead(MonsterInfo)
  local SceneObjAttr = self:GetMonsterSceneObjAttr(MonsterInfo.UniqueId)
  local MonsterSpId = SceneObjAttr and SceneObjAttr:GetMonsterSpId()
  if nil == MonsterSpId then
    return
  end
  local tabRougePro_MonsterSp = DataMgr.RougePro_MonsterSP[MonsterSpId]
  if nil == tabRougePro_MonsterSp then
    return
  end
  if SceneObjAttr:GetMonsterSpSpawnId() then
    local SpawnId = SceneObjAttr:GetMonsterSpSpawnId()
    local RoundSpawnInstance = self.RoundSpawnMap[SpawnId]
    if RoundSpawnInstance then
      RoundSpawnInstance:OnMonsterDead(MonsterInfo)
    end
    local AddScore = 0
    if SceneObjAttr:GetMonsterSpRoundIndex() and tabRougePro_MonsterSp.MonsterScore and tabRougePro_MonsterSp.RoundScoreFix then
      AddScore = AddScore + tabRougePro_MonsterSp.MonsterScore * (SceneObjAttr:GetMonsterSpRoundIndex() - 1 * tabRougePro_MonsterSp.RoundScoreFix + 1)
    end
    if SceneObjAttr:GetMonsterSpStrongIndex() and tabRougePro_MonsterSp.StrongScore and tabRougePro_MonsterSp.RoundScoreFix then
      AddScore = AddScore + tabRougePro_MonsterSp.StrongScore * (SceneObjAttr:GetMonsterSpStrongIndex() - 1 * tabRougePro_MonsterSp.RoundScoreFix + 1)
    end
    self:AddTotalScore(AddScore)
    local MonsterData = DataMgr.Monster[MonsterInfo.UnitId]
    if MonsterData and MonsterData.GamePlayTags then
      for i, GamePlayTag in pairs(MonsterData.GamePlayTags) do
        self:DispatchRougeProEffectEvent("OnKillMonster", {MonsterTag = GamePlayTag})
      end
    end
    if SceneObjAttr:GetMonsterSpRoundIndex() and tabRougePro_MonsterSp.MonsterRewardDropBox then
      self:ForEachPlayer(function(Player)
        local RewardInfo = {
          RewardDropBoxId = tabRougePro_MonsterSp.MonsterRewardDropBox,
          OwnerAvatarEids = {
            Player:GetAvatarEid()
          },
          MonsterUniqueId = MonsterInfo.UniqueId,
          DropIndex = -1,
          MechanismUnitId = -1
        }
        self:CreateRewardDropBox_MonsterDrop(tabRougePro_MonsterSp.MonsterRewardDropBox, RewardInfo, MonsterInfo)
      end)
    end
    if SceneObjAttr:GetMonsterSpStrongIndex() and tabRougePro_MonsterSp.StrongRewardDropBox then
      self:ForEachPlayer(function(Player)
        local RewardInfo = {
          RewardDropBoxId = tabRougePro_MonsterSp.StrongRewardDropBox,
          OwnerAvatarEids = {
            Player:GetAvatarEid()
          },
          MonsterUniqueId = MonsterInfo.UniqueId,
          DropIndex = -1,
          MechanismUnitId = -1
        }
        self:CreateRewardDropBox_MonsterDrop(tabRougePro_MonsterSp.StrongRewardDropBox, RewardInfo, MonsterInfo)
      end)
    end
  end
  if MonsterSpId == self.CurRoundInfo.CurBossCreateRule then
    self:OnRoundBossDead()
  end
  local IsComplete = not self:IsExistMonster(function(SceneObjAttr)
    if SceneObjAttr:GetMonsterSpId() == MonsterSpId and SceneObjAttr:IsAlive() == true then
      return true
    end
  end)
  if IsComplete then
    self:OnSpecialSpawnComplete(MonsterSpId, tabRougePro_MonsterSp)
  end
end

function RougeProMonsterSpecialSpawnManager:OnSpecialSpawnComplete(MonsterSpId, tabRougePro_MonsterSp)
  if not tabRougePro_MonsterSp then
    return
  end
  if tabRougePro_MonsterSp.CompleteScore then
    self:AddTotalScore(tabRougePro_MonsterSp.CompleteScore)
  end
  if tabRougePro_MonsterSp.RewardBoxStaticPoint and tabRougePro_MonsterSp.CompleteRewardDropBox then
    self:ForEachPlayer(function(Player)
      local RewardInfo = {
        RewardDropBoxId = tabRougePro_MonsterSp.CompleteRewardDropBox,
        OwnerAvatarEids = {
          Player:GetAvatarEid()
        },
        MonsterSpId = MonsterSpId,
        DropIndex = -1,
        MechanismUnitId = -1
      }
      self:CreateRewardDropBox_StaticPoint(tabRougePro_MonsterSp.CompleteRewardDropBox, RewardInfo, tabRougePro_MonsterSp.RewardBoxStaticPoint)
    end)
  end
end

function RougeProMonsterSpecialSpawnManager:CreateRougeMonsterSp_RoundSpawn(MonsterSPId, ExtraParam)
  local tabMonsterSP = DataMgr.RougePro_MonsterSP[MonsterSPId]
  if nil == tabMonsterSP then
    return
  end
  if not tabMonsterSP.RoundId then
    return
  end
  local RoundSpawnId = tabMonsterSP.RoundId
  if self.RoundSpawnMap[RoundSpawnId] then
    return
  end
  local RoundSpawnInstance = RougeProRoundSpawn()
  local IsSucc = RoundSpawnInstance:InitRougeProRoundSpawn(self, RoundSpawnId, MonsterSPId, ExtraParam)
  if IsSucc then
    self.RoundSpawnMap[RoundSpawnId] = RoundSpawnInstance
  end
end

function RougeProMonsterSpecialSpawnManager:StopRougeMonsterSp_RoundSpawn(MonsterSPId)
  local tabMonsterSP = DataMgr.RougePro_MonsterSP[MonsterSPId]
  if nil == tabMonsterSP then
    return
  end
  if not tabMonsterSP.RoundId then
    return
  end
  local RoundSpawnId = tabMonsterSP.RoundId
  local RoundSpawnInstance = self.RoundSpawnMap[RoundSpawnId]
  if not RoundSpawnInstance then
    return
  end
  self:OnSpecialSpawnComplete(MonsterSPId, tabMonsterSP)
  RoundSpawnInstance:DestroyRougeProRoundSpawn()
  self.RoundSpawnMap[RoundSpawnId] = nil
end

function RougeProMonsterSpecialSpawnManager:RougeProSpSpawnPrint(Str, SpawnInstance)
  print("[RougeProMonsterSpecialSpawnManager] SpawnId: " .. SpawnInstance.SpawnId .. " " .. Str)
end

DungeonClass.AssembleComponents(RougeProMonsterSpecialSpawnManager)
return RougeProMonsterSpecialSpawnManager
