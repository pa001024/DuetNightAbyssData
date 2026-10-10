require("UnLua")
local BP_MirrorMechanism_C = Class("BluePrints.Item.Chest.BP_MechanismBase_C")
local MirrorMechState = {Idle = 1900510, Switching = 1900511}

function BP_MirrorMechanism_C:OnEnterState(NowStateId)
  self.Overridden.OnEnterState(self, NowStateId)
  if NowStateId == MirrorMechState.Switching then
    local SwitchComp = self:GetComponentByClass(UE4.UMirrorSwitchComponent.StaticClass())
    if SwitchComp then
      local Reason = SwitchComp:TriggerSwitchWorld(0)
      if Reason ~= CommonConst.MirrorSwitchFailReason.Success then
        DebugPrint("[MirrorWorld] 切换世界失败, Reason =", Reason)
      end
    else
      GWorld.logger.error("[MirrorWorld] 镜子机关 " .. self:GetName() .. " 未挂载 BP_MirrorSwitchComponent")
    end
    self:AddTimer(1, function()
      self:ChangeState("Manual", 0, MirrorMechState.Idle)
    end)
  end
end

return BP_MirrorMechanism_C
