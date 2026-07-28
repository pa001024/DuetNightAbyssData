local GameModeRougeProRewardDropBox = DungeonClass.Class()

function GameModeRougeProRewardDropBox:Init_GameMode()
  self.GameMode = self.DungeonObject.GameMode
  self.GameState = self.GameMode.EMGameState
  self.CProperty = self.DungeonObject.CProperty
  self.Chest = self.GameState.CombatItemUniqueMap:Find(self.UniqueId)
  if self.Chest then
    self:UpdateReplicationStatus()
  end
  for _, OwnerAvatarEid in pairs(self.OwnerAvatarEids) do
    self.CProperty:AddChestInfo(self.UniqueId, OwnerAvatarEid)
  end
end

function GameModeRougeProRewardDropBox:OnRougeProChestReady(Chest)
  self.Chest = Chest
  if self.Chest then
    self:UpdateReplicationStatus()
  end
end

function GameModeRougeProRewardDropBox:UpdateReplicationStatus()
  if 1 == #self.OwnerAvatarEids then
    local OwnerAvatarEid = self.OwnerAvatarEids[1]
    self.Chest:SetReplicatedToSingleClient(true, OwnerAvatarEid)
    self:GameModeRougeProEventPrint("SetReplicatedToSingleClient Uid", self.UniqueId, "AvatarEid", OwnerAvatarEid, "UnitId", self.Chest.UnitId, "Eid", self.Chest.Eid)
  end
end

function GameModeRougeProRewardDropBox:GiveUpRewardBox()
  self.DungeonObject:NotifyServerDungeonEvent("GiveUpRewardBox", self.UniqueId)
end

function GameModeRougeProRewardDropBox:GameModeRougeProEventPrint(...)
  print("[GameModeRougeProRewardDropBox] UniqueId", self.UniqueId, ...)
end

return GameModeRougeProRewardDropBox
