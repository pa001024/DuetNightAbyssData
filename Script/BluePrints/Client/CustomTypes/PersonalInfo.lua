local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local PERSONAL_INFO_UNIT_COUNT = 3
local PersonalInfoUnit = Class("PersonalInfoUnit", CustomTypes.CustomAttr)
PersonalInfoUnit.__Props__ = {
  Id = prop.prop("ObjId", "client save"),
  AppearancePlan = prop.prop("Int", "client save", -1),
  ModPlan = prop.prop("Int", "client save", 1)
}
FormatProperties(PersonalInfoUnit)

function PersonalInfoUnit:Init(Id, AppearancePlan, ModPlan)
  self.Id = Id
  self.AppearancePlan = AppearancePlan
  self.ModPlan = ModPlan
end

local PersonalInfoUnitList = Class("PersonalInfoUnitList", CustomTypes.CustomList)
PersonalInfoUnitList.ValueType = PersonalInfoUnit
local PersonalInfoCharParam = Class("PersonalInfoCharParam", CustomTypes.CustomAttr)
PersonalInfoCharParam.__Props__ = {
  CharId = prop.prop("Int", "client save"),
  AppearancePlan = prop.prop("Int", "client save", 1),
  WeaponId = prop.prop("Int", "client save"),
  PoseId = prop.prop("Int", "client save", -1),
  Position = prop.prop("FloatList", "client save"),
  Rotation = prop.prop("FloatList", "client save")
}
FormatProperties(PersonalInfoCharParam)

function PersonalInfoCharParam:Init(Info)
  if Info then
    self:Update(Info)
  end
end

function PersonalInfoCharParam:SetPosition(Position)
  if not Position then
    return
  end
  self.Position[1] = Position[1]
  self.Position[2] = Position[2]
  self.Position[3] = Position[3]
end

function PersonalInfoCharParam:SetRotation(Rotation)
  if not Rotation then
    return
  end
  self.Rotation[1] = Rotation[1]
  self.Rotation[2] = Rotation[2]
  self.Rotation[3] = Rotation[3]
end

function PersonalInfoCharParam:Update(Info)
  if not Info then
    return
  end
  self.CharId = Info.CharId
  if Info.AppearancePlan ~= nil then
    self.AppearancePlan = Info.AppearancePlan
  end
  if nil ~= Info.WeaponId then
    self.WeaponId = Info.WeaponId
  end
  self.PoseId = Info.PoseId or -1
  self:SetPosition(Info.Position)
  self:SetRotation(Info.Rotation)
end

local PersonalInfoCharParamGroup = Class("PersonalInfoCharParamGroup", CustomTypes.CustomList)
PersonalInfoCharParamGroup.ValueType = PersonalInfoCharParam
local PersonalInfoCameraParam = Class("PersonalInfoCameraParam", CustomTypes.CustomAttr)
PersonalInfoCameraParam.__Props__ = {
  Position = prop.prop("FloatList", "client save"),
  Rotation = prop.prop("FloatList", "client save")
}
FormatProperties(PersonalInfoCameraParam)

function PersonalInfoCameraParam:Init(Info)
  if Info then
    self:Update(Info)
  end
end

function PersonalInfoCameraParam:SetPosition(Position)
  if not Position then
    return
  end
  self.Position[1] = Position[1]
  self.Position[2] = Position[2]
  self.Position[3] = Position[3]
end

function PersonalInfoCameraParam:SetRotation(Rotation)
  if not Rotation then
    return
  end
  self.Rotation[1] = Rotation[1]
  self.Rotation[2] = Rotation[2]
  self.Rotation[3] = Rotation[3]
end

function PersonalInfoCameraParam:Update(Info)
  if not Info then
    return
  end
  self:SetPosition(Info.Position)
  self:SetRotation(Info.Rotation)
end

local PersonalInfoCustomDisplay = Class("PersonalInfoCustomDisplay", CustomTypes.CustomAttr)
PersonalInfoCustomDisplay.__Props__ = {
  CharParamGroup = prop.prop("PersonalInfoCharParamGroup", "client save"),
  CameraParam = prop.prop("PersonalInfoCameraParam", "client save"),
  SceneId = prop.prop("Int", "client save", 101)
}
FormatProperties(PersonalInfoCustomDisplay)

function PersonalInfoCustomDisplay:Init(Info)
  if Info then
    self:Update(Info)
  end
end

function PersonalInfoCustomDisplay:Update(Info)
  if not Info then
    return
  end
  self.SceneId = Info.SceneId
  if Info.CameraParam then
    self.CameraParam = PersonalInfoCameraParam(Info.CameraParam)
  end
  self.CharParamGroup = {}
  for _, CharParam in ipairs(Info.CharParamGroup or {}) do
    self.CharParamGroup:Append(PersonalInfoCharParam(CharParam))
  end
end

local PersonalInfo = Class("PersonalInfo", CustomTypes.CustomAttr)
PersonalInfo.__Props__ = {
  CharDisplay = prop.prop("PersonalInfoUnitList", "client save"),
  WeaponDisplay = prop.prop("PersonalInfoUnitList", "client save"),
  Visible = prop.prop("Int", "client save", 1),
  BackgroundIds = prop.prop("Int2IntDict", "client save", {}),
  CustomDisplay = prop.prop("PersonalInfoCustomDisplay", "client save")
}
FormatProperties(PersonalInfo)

function PersonalInfo:AddCharDisplay(Id, AppearancePlan, ModPlan)
  if self.CharDisplay:Length() >= PERSONAL_INFO_UNIT_COUNT then
    return false
  end
  self.CharDisplay:Append(PersonalInfoUnit(Id, AppearancePlan, ModPlan))
  return true
end

function PersonalInfo:HasCharDisplay(Id)
  for i = 1, self.CharDisplay:Length() do
    local Unit = self.CharDisplay:Get(i)
    if Unit.Id == Id then
      return true
    end
  end
  return false
end

function PersonalInfo:AddWeaponDisplay(Id, ModPlan)
  if self.WeaponDisplay:Length() >= PERSONAL_INFO_UNIT_COUNT then
    return false
  end
  self.WeaponDisplay:Append(PersonalInfoUnit(Id, -1, ModPlan))
  return true
end

function PersonalInfo:HasWeaponDisplay(Id)
  for i = 1, self.WeaponDisplay:Length() do
    local Unit = self.WeaponDisplay:Get(i)
    if Unit.Id == Id then
      return true
    end
  end
  return false
end

return {
  PersonalInfo = PersonalInfo,
  PersonalInfoUnit = PersonalInfoUnit,
  PersonalInfoUnitList = PersonalInfoUnitList,
  PersonalInfoCameraParam = PersonalInfoCameraParam,
  PersonalInfoCharParam = PersonalInfoCharParam,
  PersonalInfoCharParamGroup = PersonalInfoCharParamGroup,
  PersonalInfoCustomDisplay = PersonalInfoCustomDisplay
}
