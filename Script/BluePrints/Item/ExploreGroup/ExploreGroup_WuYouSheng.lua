local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")

function M:SetTeleportGateTarget(StaticCreatorComp, InTransform)
  if 0 == StaticCreatorComp.ChildEids:Length() then
    return
  end
  local Mechanism = Battle(self):GetEntity(StaticCreatorComp.ChildEids[1])
  if not Mechanism or not Mechanism.SetTeleportDestLocation then
    return
  end
  Mechanism:SetTeleportDestLocation(InTransform.Translation)
  Mechanism:SetTeleportDestRotation(InTransform.Rotation:ToRotator())
end

return M
