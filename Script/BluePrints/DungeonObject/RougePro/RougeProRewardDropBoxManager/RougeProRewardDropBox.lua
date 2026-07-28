local RougeProRewardDropBox = DungeonClass.Class()
RougeProRewardDropBox.__Class__ = "RougeProRewardDropBox"
RougeProRewardDropBox.__Component__ = {
  "BluePrints.DungeonObject.Replication.ReplicatedPropertySupport",
  "BluePrints.DungeonObject.RougePro.GameModeRougeProComponents.GameModeRougeProRewardDropBox"
}

function RougeProRewardDropBox:__Init__(DungeonObject, UniqueId)
  self.DungeonObject = DungeonObject
  self:InitReplicatedProperties(self)
  self:InitReplicatedProperties(self, "UniqueId", UniqueId, "OnRep_UniqueId")
  self:InitReplicatedProperties(self, "OwnerAvatarEids", {}, "OnRep_OwnerAvatarEids")
  self:InitReplicatedProperties(self, "TreasureList", {}, "OnRep_TreasureList")
  self:InitReplicatedProperties(self, "RandomId", -1, "OnRep_RandomId")
  self:InitReplicatedProperties(self, "Token", 0, "OnRep_Token")
end

function RougeProRewardDropBox:FillRewardDropBox(RewardDropBoxId, DropIndex)
  local tabRougePro_RewardDropBox = DataMgr.RougePro_RewardDropBox[RewardDropBoxId]
  if nil == tabRougePro_RewardDropBox then
    return
  end
  if tabRougePro_RewardDropBox.RewardBoxTreasureRandom and tabRougePro_RewardDropBox.RewardBoxTreasureRandom[DropIndex] then
    local RandomPool = tabRougePro_RewardDropBox.RewardBoxTreasureRandom[DropIndex]
    local RewardTreasureRandom = RandomPool[math.random(1, #RandomPool)]
    self.RandomId = RewardTreasureRandom
  end
  if tabRougePro_RewardDropBox.RewardToken and tabRougePro_RewardDropBox.RewardToken[DropIndex] then
    self.Token = tabRougePro_RewardDropBox.RewardToken[DropIndex]
  end
end

function RougeProRewardDropBox:OnRep_UniqueId()
end

function RougeProRewardDropBox:OnRep_OwnerAvatarEids()
end

function RougeProRewardDropBox:OnRep_TreasureList()
end

function RougeProRewardDropBox:OnRep_RandomId()
end

function RougeProRewardDropBox:OnRep_Token()
end

DungeonClass.AssembleComponents(RougeProRewardDropBox)
return RougeProRewardDropBox
