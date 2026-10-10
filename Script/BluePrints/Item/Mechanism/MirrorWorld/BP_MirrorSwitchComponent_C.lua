require("UnLua")
local BP_MirrorSwitchComponent_C = Class("BluePrints.Item.Mechanism.MirrorWorld.MirrorComponentBase")
local FailReason = CommonConst.MirrorSwitchFailReason

function BP_MirrorSwitchComponent_C:TriggerSwitchWorld_Lua(PlayerId)
  if not IsValid(self.OwnerAreaBox) then
    return FailReason.NotInArea
  end
  return self.OwnerAreaBox:RequestSwitchWorld(PlayerId or 0)
end

function BP_MirrorSwitchComponent_C:OnMirrorWorldStateChange_Logic(NewState, OldState)
end

return BP_MirrorSwitchComponent_C
