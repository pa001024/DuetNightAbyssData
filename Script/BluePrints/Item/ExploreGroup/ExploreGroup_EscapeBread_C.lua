local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")

local function IsExploreSpline(SplineComponent)
  local Class = UExploreSplineComponent
  return Class and IsValid(SplineComponent) and SplineComponent:IsA(Class)
end

local function FindSplineOccupant(Group, SplineComponent, ExceptMechanism)
  if not IsValid(SplineComponent) then
    return nil
  end
  if IsExploreSpline(SplineComponent) then
    local Occupant = SplineComponent.MoveActor
    if IsValid(Occupant) and Occupant ~= ExceptMechanism then
      return Occupant
    end
  end
  if not Group or not Group.StaticCreatorMap then
    return nil
  end
  for _, Creator in pairs(Group.StaticCreatorMap) do
    if Creator and Creator.ChildEids and Creator.ChildEids:Length() > 0 then
      local Other = Battle(Group):GetEntity(Creator.ChildEids[1])
      if Other and Other ~= ExceptMechanism and IsValid(Other.BoundSpline) and Other.BoundSpline == SplineComponent then
        return Other
      end
    end
  end
  return nil
end

function M:BindBreadSpline(StaticCreator, SplineComponent)
  if not SplineComponent then
    print(_G.LogTag, string.format("[EscapeBreadGroup] BindBreadSpline失败：SplineComponent为空 Group=%s", self:GetName()))
    return
  end
  if not StaticCreator or 0 == StaticCreator.ChildEids:Length() then
    print(_G.LogTag, string.format("[EscapeBreadGroup] BindBreadSpline失败：StaticCreator为空或ChildEids为空(单位未创建?) Group=%s CreatorId=%s", self:GetName(), StaticCreator and tostring(StaticCreator.StaticCreatorId) or "nil"))
    return
  end
  local Mechanism = Battle(self):GetEntity(StaticCreator.ChildEids[1])
  if not Mechanism or not Mechanism.SetExploreSpline then
    print(_G.LogTag, string.format("[EscapeBreadGroup] BindBreadSpline失败：单位缺少SetExploreSpline接口 Group=%s CreatorId=%s Eid=%s", self:GetName(), tostring(StaticCreator.StaticCreatorId), tostring(StaticCreator.ChildEids[1])))
    return
  end
  if IsValid(Mechanism.BoundSpline) and Mechanism.BoundSpline == SplineComponent then
    return
  end
  local Occupant = FindSplineOccupant(self, SplineComponent, Mechanism)
  if Occupant then
    print(_G.LogTag, string.format("[EscapeBreadGroup] BindBreadSpline失败：路径已被 %s 占用 Group=%s CreatorId=%s", Occupant:GetName(), self:GetName(), tostring(StaticCreator.StaticCreatorId)))
    return
  end
  Mechanism:SetExploreSpline(SplineComponent)
end

return M
