require("UnLua")
local M = Class({
  "BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C",
  "BluePrints.Common.TimerMgr"
})

function M:StartInteractive(PlayerActor)
  if not PlayerActor then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local IsMainPlayer = MainPlayer.Eid == PlayerActor.Eid
  local Owner = self:GetOwner()
  PlayerActor.RPCComponent:InteractiveHook(PlayerActor.Eid, Owner.Eid)
  if IsMainPlayer and Avatar and Avatar.IsInRegionOnline then
    PlayerActor:ForceReSyncLocation()
    Avatar:UseGouSuoMessage(Avatar.CurrentOnlineType, Owner.CreatorId)
  end
end

function M:EndInteractive(PlayerActor)
  local Owner = self:GetOwner()
  if 0 == Owner.PlayerEids:Length() then
    return
  end
  if not PlayerActor then
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    Player.RPCComponent:DeInteractiveHook(self.PlayerEid, Owner.Eid)
  else
    PlayerActor.RPCComponent:DeInteractiveHook(PlayerActor.Eid, Owner.Eid)
    PlayerActor:ForceReSyncLocation()
  end
end

function M:ForceEndInteractive(PlayerActor)
  local Owner = self:GetOwner()
  if not PlayerActor then
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    Player.RPCComponent:DeInteractiveHook(Player.Eid, Owner.Eid)
  else
    PlayerActor.RPCComponent:DeInteractiveHookForce(PlayerActor.Eid, Owner.Eid)
  end
end

function M:IsCanInteractive(PlayerActor)
  return false
end

function M:ReceiveBeginPlay()
  self.MontageName = "Interactive_02_Montage"
end

return M
