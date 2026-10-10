local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local PERSONAL_INFO_UNIT_COUNT = 3
local CustomDisplayDefaults = {
  SceneId = 101,
  LightIntensity = 1.0,
  LightDirection = {
    0,
    0,
    0
  },
  FilterIntensity = 50,
  StickerScale = 1.0,
  PoseId = -1
}
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
  PoseId = prop.prop("Int", "client save", CustomDisplayDefaults.PoseId),
  Position = prop.prop("FloatList", "client save"),
  Rotation = prop.prop("FloatList", "client save"),
  SlotIndex = prop.prop("Int", "client save")
}
FormatProperties(PersonalInfoCharParam)

function PersonalInfoCharParam:Init(Info)
  if type(Info) ~= "table" then
    return
  end
  self:Update(Info)
end

function PersonalInfoCharParam:SetPosition(Position)
  CommonUtils.CopyListValues(self.Position, Position, 3)
end

function PersonalInfoCharParam:SetRotation(Rotation)
  CommonUtils.CopyListValues(self.Rotation, Rotation, 3)
end

function PersonalInfoCharParam:Update(Info)
  if type(Info) ~= "table" then
    return
  end
  self.CharId = Info.CharId
  self.AppearancePlan = Info.AppearancePlan
  self.WeaponId = Info.WeaponId
  self.PoseId = Info.PoseId or CustomDisplayDefaults.PoseId
  self:SetPosition(Info.Position)
  self:SetRotation(Info.Rotation)
  self.SlotIndex = Info.SlotIndex
end

local PersonalInfoCharParamGroup = Class("PersonalInfoCharParamGroup", CustomTypes.CustomList)
PersonalInfoCharParamGroup.ValueType = PersonalInfoCharParam

function PersonalInfoCharParamGroup:Update(Infos)
  self:Clear()
  if type(Infos) ~= "table" then
    return
  end
  for _, CharParam in ipairs(Infos or {}) do
    self:Append(PersonalInfoCharParam(CharParam))
  end
end

local PersonalInfoCameraParam = Class("PersonalInfoCameraParam", CustomTypes.CustomAttr)
PersonalInfoCameraParam.__Props__ = {
  Position = prop.prop("FloatList", "client save"),
  Rotation = prop.prop("FloatList", "client save")
}
FormatProperties(PersonalInfoCameraParam)

function PersonalInfoCameraParam:Init(Info)
  if type(Info) ~= "table" then
    return
  end
  self:Update(Info)
end

function PersonalInfoCameraParam:Update(Info)
  if type(Info) ~= "table" then
    return
  end
  self:SetPosition(Info.Position)
  self:SetRotation(Info.Rotation)
end

function PersonalInfoCameraParam:SetPosition(Position)
  CommonUtils.CopyListValues(self.Position, Position, 3)
end

function PersonalInfoCameraParam:SetRotation(Rotation)
  CommonUtils.CopyListValues(self.Rotation, Rotation, 3)
end

local PersonalInfoLightParam = Class("PersonalInfoLightParam", CustomTypes.CustomAttr)
PersonalInfoLightParam.__Props__ = {
  Intensity = prop.prop("Float", "client save", CustomDisplayDefaults.LightIntensity),
  Direction = prop.prop("FloatList", "client save", {
    CustomDisplayDefaults.LightDirection[1],
    CustomDisplayDefaults.LightDirection[2],
    CustomDisplayDefaults.LightDirection[3]
  })
}
FormatProperties(PersonalInfoLightParam)

function PersonalInfoLightParam:Init(Info)
  if type(Info) ~= "table" then
    return
  end
  self:Update(Info)
end

function PersonalInfoLightParam:Update(Info)
  if type(Info) ~= "table" then
    return
  end
  self.Intensity = Info.Intensity
  self:SetDirection(Info.Direction)
end

function PersonalInfoLightParam:SetDirection(Direction)
  CommonUtils.CopyListValues(self.Direction, Direction, 3)
end

local PersonalInfoPetParam = Class("PersonalInfoPetParam", CustomTypes.CustomAttr)
PersonalInfoPetParam.__Props__ = {
  UniqueId = prop.prop("Int", "client save"),
  PetId = prop.prop("Int", "client save"),
  Position = prop.prop("FloatList", "client save"),
  Rotation = prop.prop("FloatList", "client save")
}
FormatProperties(PersonalInfoPetParam)

function PersonalInfoPetParam:Init(Info)
  if type(Info) ~= "table" then
    return
  end
  self:Update(Info)
end

function PersonalInfoPetParam:Update(Info)
  if type(Info) ~= "table" then
    return
  end
  self.UniqueId = Info.UniqueId
  self.PetId = Info.PetId
  self:SetPosition(Info.Position)
  self:SetRotation(Info.Rotation)
end

function PersonalInfoPetParam:SetPosition(Position)
  CommonUtils.CopyListValues(self.Position, Position, 3)
end

function PersonalInfoPetParam:SetRotation(Rotation)
  CommonUtils.CopyListValues(self.Rotation, Rotation, 3)
end

local PersonalInfoPetParamGroup = Class("PersonalInfoPetParamGroup", CustomTypes.CustomDict)
PersonalInfoPetParamGroup.KeyType = BaseTypes.Int
PersonalInfoPetParamGroup.ValueType = PersonalInfoPetParam

function PersonalInfoPetParamGroup:Update(Infos)
  self:Clear()
  if type(Infos) ~= "table" then
    return
  end
  for i, info in pairs(Infos) do
    self:AddValue(i, PersonalInfoPetParam(info))
  end
end

local PersonalInfoStickerParam = Class("PersonalInfoStickerParam", CustomTypes.CustomAttr)
PersonalInfoStickerParam.__Props__ = {
  StickerId = prop.prop("Int", "client save"),
  Position2D = prop.prop("FloatList", "client save"),
  Scale = prop.prop("Float", "client save", CustomDisplayDefaults.StickerScale)
}
FormatProperties(PersonalInfoStickerParam)

function PersonalInfoStickerParam:Init(Info)
  if type(Info) ~= "table" then
    return
  end
  self:Update(Info)
end

function PersonalInfoStickerParam:Update(Info)
  if type(Info) ~= "table" then
    return
  end
  self.StickerId = Info.StickerId
  self:SetPosition2D(Info.Position2D)
  self.Scale = Info.Scale
end

function PersonalInfoStickerParam:SetPosition2D(Position2D)
  CommonUtils.CopyListValues(self.Position2D, Position2D, 2)
end

local PersonalInfoItemParam = Class("PersonalInfoItemParam", CustomTypes.CustomAttr)
PersonalInfoItemParam.__Props__ = {
  Id = prop.prop("Int", "client save"),
  Position = prop.prop("FloatList", "client save"),
  Rotation = prop.prop("FloatList", "client save"),
  SlotIndex = prop.prop("Int", "client save")
}
FormatProperties(PersonalInfoItemParam)

function PersonalInfoItemParam:Init(Info)
  if type(Info) ~= "table" then
    return
  end
  self:Update(Info)
end

function PersonalInfoItemParam:Update(Info)
  if type(Info) ~= "table" then
    return
  end
  self.Id = Info.Id
  self:SetPosition(Info.Position)
  self:SetRotation(Info.Rotation)
end

function PersonalInfoItemParam:SetPosition(Position)
  CommonUtils.CopyListValues(self.Position, Position, 3)
end

function PersonalInfoItemParam:SetRotation(Rotation)
  CommonUtils.CopyListValues(self.Rotation, Rotation, 3)
end

local PersonalInfoItemParamGroup = Class("PersonalInfoItemParamGroup", CustomTypes.CustomDict)
PersonalInfoItemParamGroup.KeyType = BaseTypes.Int
PersonalInfoItemParamGroup.ValueType = PersonalInfoItemParam

function PersonalInfoItemParamGroup:Update(Infos)
  self:Clear()
  if type(Infos) ~= "table" then
    return
  end
  for i, info in pairs(Infos) do
    self:AddValue(i, PersonalInfoItemParam(info))
  end
end

local PersonalInfoFilterParam = Class("PersonalInfoFilterParam", CustomTypes.CustomAttr)
PersonalInfoFilterParam.__Props__ = {
  Id = prop.prop("Int", "client save"),
  Intensity = prop.prop("Float", "client save", CustomDisplayDefaults.FilterIntensity)
}
FormatProperties(PersonalInfoFilterParam)

function PersonalInfoFilterParam:Init(Info)
  if type(Info) ~= "table" then
    return
  end
  self:Update(Info)
end

function PersonalInfoFilterParam:Update(Info)
  if type(Info) ~= "table" then
    return
  end
  self.Id = Info.Id
  self.Intensity = Info.Intensity
end

local PersonalInfoCustomDisplay = Class("PersonalInfoCustomDisplay", CustomTypes.CustomAttr)
PersonalInfoCustomDisplay.__Props__ = {
  CharParamGroup = prop.prop("PersonalInfoCharParamGroup", "client save"),
  CameraParam = prop.prop("PersonalInfoCameraParam", "client save"),
  SceneId = prop.prop("Int", "client save", CustomDisplayDefaults.SceneId),
  LightParam = prop.prop("PersonalInfoLightParam", "client save"),
  PetParamGroup = prop.prop("PersonalInfoPetParamGroup", "client save"),
  StickerParam = prop.prop("PersonalInfoStickerParam", "client save"),
  ItemParamGroup = prop.prop("PersonalInfoItemParamGroup", "client save"),
  Filter = prop.prop("PersonalInfoFilterParam", "client save")
}
FormatProperties(PersonalInfoCustomDisplay)

function PersonalInfoCustomDisplay:Init(Info)
  if type(Info) ~= "table" then
    return
  end
  self:Update(Info)
end

function PersonalInfoCustomDisplay:Update(Info)
  if type(Info) ~= "table" then
    return
  end
  self.SceneId = Info.SceneId
  self.CameraParam = PersonalInfoCameraParam(Info.CameraParam)
  self.CharParamGroup:Update(Info.CharParamGroup)
  self.LightParam = PersonalInfoLightParam(Info.LightParam)
  self.PetParamGroup:Update(Info.PetParamGroup)
  self.StickerParam = PersonalInfoStickerParam(Info.StickerParam)
  self.ItemParamGroup:Update(Info.ItemParamGroup)
  self.Filter = PersonalInfoFilterParam(Info.Filter or Info.FilterParam)
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

function PersonalInfo:UpdateCustomDisplay(CustomDisplay)
  local CustomDisplayInfo = PersonalInfoCustomDisplay()
  CustomDisplayInfo:Update(CustomDisplay)
  self.CustomDisplay = CustomDisplayInfo
end

return {
  PersonalInfo = PersonalInfo,
  PersonalInfoUnit = PersonalInfoUnit,
  PersonalInfoUnitList = PersonalInfoUnitList,
  PersonalInfoLightParam = PersonalInfoLightParam,
  PersonalInfoCameraParam = PersonalInfoCameraParam,
  PersonalInfoCharParam = PersonalInfoCharParam,
  PersonalInfoCharParamGroup = PersonalInfoCharParamGroup,
  PersonalInfoPetParam = PersonalInfoPetParam,
  PersonalInfoPetParamGroup = PersonalInfoPetParamGroup,
  PersonalInfoStickerParam = PersonalInfoStickerParam,
  PersonalInfoCustomDisplay = PersonalInfoCustomDisplay,
  PersonalInfoItemParam = PersonalInfoItemParam,
  PersonalInfoItemParamGroup = PersonalInfoItemParamGroup,
  PersonalInfoFilterParam = PersonalInfoFilterParam,
  CustomDisplayDefaults = CustomDisplayDefaults
}
