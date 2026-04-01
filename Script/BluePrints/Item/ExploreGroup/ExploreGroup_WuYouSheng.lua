local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")

function M:SetTeleportGateTarget(StaticCreatorComp, InTransform)
  if 0 == StaticCreatorComp.ChildEids:Length() then
    return
  end
  for _, Eid in ipairs(StaticCreatorComp.ChildEids:ToTable()) do
    local Mechanism = Battle(self):GetEntity(Eid)
    if Mechanism and Mechanism.SetTeleportDestLocation then
      Mechanism:SetTeleportDestLocation(InTransform.Translation)
      Mechanism:SetTeleportDestRotation(InTransform.Rotation:ToRotator())
    end
  end
end

return M
