require("UnLua")
local BP_ExtractionContainer_C = Class("BluePrints.Item.Chest.BP_MechanismBase_C")

function BP_ExtractionContainer_C:GetCanOpen(PlayerEid)
  DebugPrint("gmy@BP_ExtractionContainer_C BP_ExtractionContainer_C:GetCanOpen", PlayerEid)
  if self.OpenState then
    self.CanOpen = false
    return
  end
  self.CanOpen = true
end

function BP_ExtractionContainer_C:OpenMechanism(PlayerId)
  DebugPrint("gmy@BP_ExtractionContainer_C BP_ExtractionContainer_C:OpenMechanism", PlayerId)
end

function BP_ExtractionContainer_C:CloseMechanism(PlayerId, IsSuccess)
  DebugPrint("gmy@BP_ExtractionContainer_C BP_ExtractionContainer_C:CloseMechanism", PlayerId, IsSuccess)
  self:BroadcastCloseMechanism(PlayerId)
end

return BP_ExtractionContainer_C
