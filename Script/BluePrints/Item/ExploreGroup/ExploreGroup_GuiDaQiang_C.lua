local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")

function M:GetPreTransform(StaticCreatorComp)
  if 0 == StaticCreatorComp.ChildEids:Length() then
    return
  end
  local ForbidBox = Battle(self):GetEntity(StaticCreatorComp.ChildEids[1])
  if not ForbidBox or not ForbidBox.OnPreTransformPlayer then
    return
  end
  return ForbidBox:OnPreTransformPlayer()
end

function M:SetNewTransform(StaticCreatorComp, Transform)
  if 0 == StaticCreatorComp.ChildEids:Length() then
    return
  end
  local ForbidBox = Battle(self):GetEntity(StaticCreatorComp.ChildEids[1])
  if not ForbidBox or not ForbidBox.SetNewTransform then
    return
  end
  ForbidBox:SetNewTransform(Transform)
end

return M
