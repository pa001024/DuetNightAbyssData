require("UnLua")
local M = Class()

function M:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  if not IsAuthority(self) then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  local LevelName = ""
  if self.PrivateEnable then
    LevelName = GameMode:GetActorLevelName(self)
  end
  self.RealDeliveryPointId = GameMode:GetRealDeliveryPointId(self.PrivateEnable, self.DeliveryPointId, LevelName)
  GameMode.EMGameState.DungeonDeliveryPointMap:Add(self.RealDeliveryPointId, self)
  self.NextAvailableIndex = 1
  self.PlayerToIndex = {}
  DebugPrint("BP_DungeonDeliveryPoint_C DeliveryPointId", self.DeliveryPointId, "LevelName", LevelName, "RealDeliveryPointId", self.RealDeliveryPointId)
  GWorld:DSBLog("Info", "BP_DungeonDeliveryPoint_C: DeliveryPoint " .. self.DeliveryPointId .. ", LevelName " .. LevelName .. ", RealDeliveryPointId " .. self.RealDeliveryPointId, "GameMode")
end

function M:ReceiveEndPlay(...)
  self.Overridden.ReceiveEndPlay(self, ...)
  if not IsAuthority(self) then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  GameMode.EMGameState.DungeonDeliveryPointMap:Remove(self.RealDeliveryPointId)
end

function M:GetDeliveryInfo(PlayerEid)
  local Index = self.PlayerToIndex[PlayerEid]
  if not Index then
    if self.NextAvailableIndex > 4 then
      self.NextAvailableIndex = 1
    end
    Index = self.NextAvailableIndex
    self.PlayerToIndex[PlayerEid] = Index
    self.NextAvailableIndex = self.NextAvailableIndex + 1
  end
  local Point = self.PointArray[Index]
  if not Point then
    return nil, nil
  end
  local TargetTransform = Point:K2_GetComponentToWorld()
  return TargetTransform.Translation, TargetTransform.Rotation:ToRotator()
end

return M
