local Player = require("BluePrints.DungeonObject.Entity.Player")
local PlayerManager = DungeonClass.Class()

function PlayerManager:BeginPlay()
  self:InitReplicatedProperties(self, "Players", {})
end

function PlayerManager:AddPlayer(AvatarEid)
  self.Players[AvatarEid] = Player(self)
  self.Players = self.Players
end

function PlayerManager:RemovePlayer(AvatarEid)
  if not self.Players[AvatarEid] then
    return
  end
  self.Players[AvatarEid] = nil
  self.Players = self.Players
end

function PlayerManager:GetPlayer(AvatarEid)
  return self.Players[AvatarEid]
end

function PlayerManager:PlayerIterator()
  return pairs(self.Players)
end

function PlayerManager:PlayerCount()
  return CommonUtils.Size(self.Players)
end

return PlayerManager
