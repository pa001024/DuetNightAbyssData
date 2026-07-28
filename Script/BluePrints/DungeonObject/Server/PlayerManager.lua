local Player = require("BluePrints.DungeonObject.Entity.Player")
local PlayerManager = DungeonClass.Class()

function PlayerManager:BeginPlay()
  self:InitReplicatedProperties(self, "Players", {}, "OnRep_Players")
end

function PlayerManager:AddPlayer(AvatarEid)
  self.Players[AvatarEid] = Player(self)
  self.Players[AvatarEid]:SetAvatarEid(AvatarEid)
  self.Players = self.Players
end

function PlayerManager:GetAvatarCrossAttr(AvatarEid)
  if not IsSkynetServer() then
    local GameMode = UE.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    assert(GameMode, "GameMode is nil")
    assert(GameMode.AvatarInfos, "GameMode is nil")
    local AvatarEidStr = CommonUtils.ObjId2Str(AvatarEid)
    local Info = GameMode.AvatarInfos[AvatarEidStr]
    return Info and Info.PlayerInfo
  else
    return DungeonInstance.OwnerAvatar:GetCrossAttrs()
  end
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

function PlayerManager:ForEachPlayer(func)
  for AvatarEid, Player in self:PlayerIterator() do
    func(Player)
  end
end

return PlayerManager
