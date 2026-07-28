local GameModeRougeProChestManager = DungeonClass.Class()

function GameModeRougeProChestManager:BeginPlay()
end

function GameModeRougeProChestManager:OnRougeProChestCreated(RewardDropBox)
  if not RewardDropBox then
    return
  end
  RewardDropBox:Init_GameMode()
end

function GameModeRougeProChestManager:OnRougeProChestReady(Chest)
  if not Chest then
    return
  end
  local MechanismUid = Chest.ServerUniqueId
  local RewardDropBox = self:GetReplicatedActorByNetGuid(self.RewardDropBoxList[MechanismUid]._NetGuid)
  if not RewardDropBox then
    return
  end
  RewardDropBox:OnRougeProChestReady(Chest)
end

function GameModeRougeProChestManager:OnNotifyGameModeDungeonEvent_ClientGiveUpRewardBox(Uid)
  print("GameModeRougeProChestManager:OnNotifyGameModeDungeonEvent_ClientGiveUpRewardBox Uid", Uid)
  local ReplicatedActor = self.RewardDropBoxList[Uid]
  if not ReplicatedActor then
    return
  end
  local RewardDropBox = self:GetReplicatedActorByNetGuid(ReplicatedActor._NetGuid)
  if not RewardDropBox then
    return
  end
  RewardDropBox:GiveUpRewardBox()
end

return GameModeRougeProChestManager
