local UnLua = require("UnLua")
local UIUtils = require("Utils.UIUtils")
local PersonalInfoUtils = require("Utils.PersonalInfoUtils")
local M = Class("BluePrints.Common.MVC.Model")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local ARMORY_FORBID_ICON = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Forbid.T_Armory_Forbid"
local DisplayTypes = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayTypes")

function M:Init()
  M.Super.Init(self)
  self._Avatar = nil
  self:GetAvatar()
end

function M:GetWeaponItemsData(WeaponTag)
  local Avatar = self._Avatar
  self[WeaponTag .. "ItemContentsMap"] = {}
  self[WeaponTag .. "ItemContentsArray"] = {}
  local ItemContentsMap = self[WeaponTag .. "ItemContentsMap"]
  local ItemContentsArray = self[WeaponTag .. "ItemContentsArray"]
  local Obj
  for Uuid, Weapon in pairs(Avatar.Weapons) do
    if Weapon:HasTag(WeaponTag) then
      Obj = ArmoryUtils:NewCharOrWeaponItemContent(Weapon, CommonConst.ArmoryType.Weapon, self.WeaponTag, true)
      table.insert(ItemContentsArray, Obj)
      ItemContentsMap[Uuid] = Obj
    end
  end
  return ItemContentsArray
end

function M:GetCharItemsData()
  local Avatar = self._Avatar
  self.CharItemContentsMap = {}
  self.CharItemContentsArray = {}
  local Obj
  for Uuid, Char in pairs(Avatar.Chars) do
    Obj = ArmoryUtils:NewCharOrWeaponItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char, true)
    Obj.IsNew = false
    self.CharItemContentsMap[Uuid] = Obj
    table.insert(self.CharItemContentsArray, Obj)
  end
  return self.CharItemContentsArray
end

function M:GetMeleeItemsData()
  return self:GetWeaponItemsData("Melee")
end

function M:GetRangedItemsData()
  return self:GetWeaponItemsData("Ranged")
end

function M:InitEditData(EditPage)
  if not self._Avatar then
    self._Avatar = GWorld:GetAvatar()
  end
  EditPage.MeleeItemContentsCache:Clear()
  EditPage.RangedItemContentsCache:Clear()
  EditPage.CharItemContentsCache:Clear()
  local MeleeItems = self:GetMeleeItemsData()
  if MeleeItems then
    for i = 1, #MeleeItems do
      local Item = MeleeItems[i]
      if Item then
        EditPage.MeleeItemContentsCache:Add(Item)
      else
        DebugPrint("Invalid MeleeItem at index:" .. tostring(i))
      end
    end
  end
  local RangedItems = self:GetRangedItemsData()
  if RangedItems then
    for i = 1, #RangedItems do
      local Item = RangedItems[i]
      if Item then
        EditPage.RangedItemContentsCache:Add(Item)
      else
        DebugPrint("Invalid RangedItem at index:" .. tostring(i))
      end
    end
  end
  local CharItems = self:GetCharItemsData()
  if CharItems then
    for i = 1, #CharItems do
      local Item = CharItems[i]
      if Item then
        EditPage.CharItemContentsCache:Add(Item)
      else
        DebugPrint("Invalid CharItem at index:" .. tostring(i))
      end
    end
  end
end

function M:Destory()
  M.Super.Destory(self)
end

function M:GetCustomEditCharacterItems()
  local Avatar = self._Avatar or GWorld:GetAvatar()
  local ItemContents = {}
  local ItemContentsMap = {}
  for Uuid, Char in pairs(Avatar.Chars or {}) do
    local Content = ArmoryUtils:NewCharOrWeaponItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char, true)
    Content.IsNew = false
    Content.EditChooseMode = "Character"
    ItemContents[#ItemContents + 1] = Content
    ItemContentsMap[Uuid] = Content
  end
  ArmoryUtils:SortItemContents(ItemContents, {
    "Rarity",
    "Level",
    "UnitId"
  }, CommonConst.DESC)
  self.CustomEditCharacterItemContents = ItemContents
  self.CustomEditCharacterItemContentsMap = ItemContentsMap
  return ItemContents
end

function M:GetCustomEditWeaponItems(WeaponTag)
  local Avatar = self._Avatar or GWorld:GetAvatar()
  local ItemContents = {}
  local ItemContentsMap = {}
  ItemContents[#ItemContents + 1] = self:_BuildCustomEditEmptyWeaponContent(WeaponTag)
  for Uuid, Weapon in pairs(Avatar.Weapons or {}) do
    if Weapon:HasTag(WeaponTag) then
      local Content = ArmoryUtils:NewCharOrWeaponItemContent(Weapon, CommonConst.ArmoryType.Weapon, WeaponTag, true)
      Content.EditChooseMode = "Weapon"
      ItemContents[#ItemContents + 1] = Content
      ItemContentsMap[Uuid] = Content
    end
  end
  ArmoryUtils:SortItemContents(ItemContents, {
    "Rarity",
    "Level",
    "UnitId"
  }, CommonConst.DESC)
  self[WeaponTag .. "CustomEditWeaponItemContents"] = ItemContents
  self[WeaponTag .. "CustomEditWeaponItemContentsMap"] = ItemContentsMap
  return ItemContents
end

function M:GetCustomEditActionItems()
  local Avatar = self._Avatar or GWorld:GetAvatar()
  local ItemContents = {}
  local GestureTable = DataMgr.CustomGesture or {}
  ItemContents[#ItemContents + 1] = self:_BuildCustomEditDefaultActionContent()
  for PoseId, GestureConfig in pairs(GestureTable) do
    if PersonalInfoUtils:CheckPoseEnough(Avatar, PoseId) then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.PoseId = PoseId
      Content.UnitId = PoseId
      Content.Tag = GestureConfig.GestureTag or "Pose"
      Content.EditChooseMode = "Action"
      Content.ActionCategory = self:_ResolveCustomEditActionCategory(GestureConfig)
      Content.UnitName = self:_GetCustomEditActionDisplayName(PoseId, Content.ActionCategory)
      Content.Icon = self:_GetCustomEditActionIcon(PoseId)
      Content.Rarity = self:_GetCustomEditActionRarity(PoseId) or 0
      Content.ResourceId = self:_GetCustomEditActionResourceId(PoseId)
      ItemContents[#ItemContents + 1] = Content
    end
  end
  table.sort(ItemContents, function(A, B)
    local ARarity = A.Rarity or 0
    local BRarity = B.Rarity or 0
    if ARarity == BRarity then
      return (A.UnitId or 0) < (B.UnitId or 0)
    end
    return ARarity > BRarity
  end)
  self.CustomEditActionItemContents = ItemContents
  return ItemContents
end

function M:_GetCustomEditActionDisplayName(PoseId, ActionCategory)
  local Resource = self:_GetCustomEditActionResource(PoseId)
  if Resource and Resource.ResourceName then
    return GText(Resource.ResourceName)
  end
  local GestureConfig = PoseId and DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
  if GestureConfig and GestureConfig.Name and GestureConfig.Name ~= "" then
    return GText(GestureConfig.Name)
  end
  if "Display" == ActionCategory or "Dynamic" == ActionCategory then
    return string.format("%s#%d", GText("UI_PersonalPage_DynamicAction"), PoseId)
  end
  RedPrint(string.format("静态动作(待配表)#%d", PoseId))
  return " "
end

function M:_GetCustomEditActionIcon(PoseId)
  local GestureConfig = PoseId and DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
  if GestureConfig and GestureConfig.Icon and GestureConfig.Icon ~= "" then
    return GestureConfig.Icon
  end
  if GestureConfig and GestureConfig.IconPath and "" ~= GestureConfig.IconPath then
    return GestureConfig.IconPath
  end
  local Resource = self:_GetCustomEditActionResource(PoseId)
  return Resource and Resource.Icon or nil
end

function M:_GetCustomEditActionRarity(PoseId)
  local Resource = self:_GetCustomEditActionResource(PoseId)
  return Resource and Resource.Rarity or nil
end

function M:_GetCustomEditActionResourceId(PoseId)
  local Resource = self:_GetCustomEditActionResource(PoseId)
  return Resource and Resource.ResourceId or nil
end

function M:_GetCustomEditActionResource(PoseId)
  local ResourceId = self:_MapCustomEditPoseIdToResourceId(PoseId)
  if not ResourceId then
    return nil
  end
  return DataMgr.Resource and DataMgr.Resource[ResourceId] or nil
end

function M:_MapCustomEditPoseIdToResourceId(PoseId)
  local GestureConfig = PoseId and DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
  if not GestureConfig then
    return nil
  end
  local ReleaseWheel = GestureConfig.ReleaseWheel
  if ReleaseWheel and 0 ~= ReleaseWheel then
    return ReleaseWheel
  end
  return nil
end

function M:BuildCustomEditActionData(Content)
  if not Content then
    return nil
  end
  if Content.IsDefaultAction == true then
    return nil
  end
  if not Content.PoseId then
    return nil
  end
  local GestureConfig = DataMgr.CustomGesture and DataMgr.CustomGesture[Content.PoseId] or nil
  if not GestureConfig then
    return nil
  end
  local ReleaseWheel = GestureConfig.ReleaseWheel
  if ReleaseWheel and 0 ~= ReleaseWheel then
    local Resource = DataMgr.Resource and DataMgr.Resource[ReleaseWheel] or nil
    return {
      PoseId = Content.PoseId,
      Mode = DisplayTypes.AnimMode.Montage,
      GestureTag = GestureConfig.GestureTag or "Gesture",
      ReleaseWheel = ReleaseWheel,
      ResourceId = ReleaseWheel,
      MontagePath = Resource and Resource.PlayAnim or nil
    }
  end
  return {
    PoseId = Content.PoseId,
    Mode = DisplayTypes.AnimMode.Sequence,
    GestureTag = GestureConfig.GestureTag or Content.Tag or "Pose",
    Document = GestureConfig.Document,
    PoseName = GestureConfig.PoseName
  }
end

function M:_BuildCustomEditEmptyWeaponContent(WeaponTag)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.EditChooseMode = "Weapon"
  Content.IsEmptyWeapon = true
  Content.WeaponTag = WeaponTag
  Content.CanInteract = true
  Content.Icon = ARMORY_FORBID_ICON
  Content.UnitName = GText("UI_PersonalPage_NoWeapon")
  Content.Rarity = -1
  Content.SortPriority = -1
  Content.UnitId = -1
  return Content
end

function M:_BuildCustomEditDefaultActionContent()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.EditChooseMode = "Action"
  Content.IsDefaultAction = true
  Content.Icon = ARMORY_FORBID_ICON
  Content.UnitName = GText("UI_PersonalPage_DefaultAction")
  Content.Tag = "Default"
  Content.ActionCategory = "All"
  Content.Rarity = -1
  Content.UnitId = -1
  return Content
end

function M:_ResolveCustomEditActionCategory(GestureConfig)
  if not GestureConfig then
    return "Static"
  end
  if GestureConfig.ReleaseWheel and 0 ~= GestureConfig.ReleaseWheel then
    return "Display"
  end
  if GestureConfig.GestureTag == "Gesture" then
    return "Display"
  end
  return "Static"
end

return M
