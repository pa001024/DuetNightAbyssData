require("UnLua")
local M = Class()

function M:ReceiveBeginPlay()
  GameState(self).DungeonDeliveryPointMap:Add(self.DeliveryPointId, self)
  self.Overridden.ReceiveBeginPlay(self)
  self.NextAvailableIndex = 1
  self.PlayerToIndex = {}
end

function M:GetDeliveryInfo(PlayerEid)
  local Index = self.PlayerToIndex[PlayerEid]
  if not Index then
    if self.NextAvailableIndex > 4 then
      self.NextAvailableIndex = 1
    end
    Index = self.NextAvailableIndex
    self.PlayerToIndex[Index] = PlayerEid
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
