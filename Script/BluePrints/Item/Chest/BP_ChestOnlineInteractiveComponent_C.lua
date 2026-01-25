local M = Class({
  "BluePrints.Item.Chest.BP_ChestInteractiveComponent_C",
  "BluePrints.Common.TimerMgr"
})

function M:StartInteractive(PlayerActor)
  if not self.bEnter then
    return
  end
  self.CanEnd = true
  print(_G.LogTag, "LXZ StartInteractive", self:IsCanInteractive(PlayerActor), self:IsCanPlayMontage(PlayerActor), not self:IsForbidden(PlayerActor))
  if self:IsCanInteractive(PlayerActor) and self:IsCanPlayMontage(PlayerActor) and not self:IsForbidden(PlayerActor) then
    local Owner = self:GetOwner()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    print(_G.LogTag, "LXZ RequestChangeRegionOnlineItemState")
    if self.InteractiveIdx then
      Avatar:RequestChangeRegionOnlineItemState(Avatar.CurrentOnlineType, Owner.UnitId, CommonUtils.Str2ObjId(Owner.SenderId), self.InteractiveIdx, Owner.StateId)
    end
  end
end

function M:EndInteractive(PlayerActor, ReasonId)
  local Owner = self:GetOwner()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  print(_G.LogTag, "LXZ EndInteractive")
  if self.InteractiveIdx then
    print(_G.LogTag, "LXZ EndInteractive111")
    Avatar:RequestLeaveRegionOnlineItem(Avatar.CurrentOnlineType, Owner.UnitId, CommonUtils.Str2ObjId(Owner.SenderId), self.InteractiveIdx)
  end
end

function M:ForceEndInteractive(PlayerActor, ReasonId)
  local Owner = self:GetOwner()
  print(_G.LogTag, "LXZ ForceEndInteractive")
  if Owner then
    print(_G.LogTag, "LXZ ForceEndInteractive111")
    Owner:CloseMechanism(PlayerActor, self.InteractiveIdx)
  end
end

return M
