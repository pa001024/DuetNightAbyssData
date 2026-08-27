local Player = DungeonClass.Class()
Player.__Class__ = "Player"
Player.__Component__ = {
  "BluePrints.DungeonObject.Replication.ReplicatedPropertySupport"
}

function Player:__Init__(DungeonObject)
  self.DungeonObject = DungeonObject
  self:InitReplicatedProperties(self)
  self:PostOnInit()
end

function Player:SetAvatarEid(AvatarEid)
  self.AvatarEid = AvatarEid
end

function Player:GetAvatarEid()
  return self.AvatarEid
end

function Player:PostOnInit()
end

DungeonClass.AssembleComponents(Player)
return Player
