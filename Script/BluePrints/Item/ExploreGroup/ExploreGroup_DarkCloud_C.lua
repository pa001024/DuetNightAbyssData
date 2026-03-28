local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")

function M:GetChildCloudLoc()
  if not self.ChildCloudNum then
    self.ChildCloudNum = 0
  end
  local Locs = {}
  for i = 1, self.ChildCloudNum do
    table.insert(Locs, self["ChildCloud" .. i]:K2_GetComponentLocation())
  end
  return Locs
end

function M:GetChildCloudNum()
  return self.ChildCloudNum or 0
end

return M
