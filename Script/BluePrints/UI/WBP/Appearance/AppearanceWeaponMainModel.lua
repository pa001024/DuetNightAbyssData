local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local AppearanceUtils = require("BluePrints.UI.WBP.Appearance.AppearanceUtils")
local M = {}

function M:Destroy()
  self.View.WeaponContents:Clear()
end

function M:OnWeaponContentCreated(Obj)
  if self.Params.OnWeaponContentCreated then
    self.Params.OnWeaponContentCreated(self.View, Obj)
  end
end

function M:GetWeaponContentByUuid(Uuid)
  if self:GetCurrentMainTabName() == AppearanceUtils.AppearanceMainTabNames.Melee then
    return self:GetMeleeWeaponContentByUuid(Uuid)
  elseif self:GetCurrentMainTabName() == AppearanceUtils.AppearanceMainTabNames.Ranged then
    return self:GetRangedWeaponContentByUuid(Uuid)
  end
end

function M:GetMeleeWeaponContentByUuid(Uuid)
  return self.MeleeItemContentsMap[Uuid]
end

function M:GetRangedWeaponContentByUuid(Uuid)
  return self.RangedItemContentsMap[Uuid]
end

function M:GetWeaponContentsByWeaponId(WeaponId)
  if self:GetCurrentMainTabName() == AppearanceUtils.AppearanceMainTabNames.Melee then
    return self:GetMeleeWeaponContentsByWeaponId(WeaponId)
  elseif self:GetCurrentMainTabName() == AppearanceUtils.AppearanceMainTabNames.Ranged then
    return self:GetRangedWeaponContentsByWeaponId(WeaponId)
  end
end

function M:GetMeleeWeaponContentsByWeaponId(WeaponId)
  return self.MeleeWeaponId2Contents[WeaponId]
end

function M:GetRangedWeaponContentsByWeaponId(WeaponId)
  return self.RangedWeaponId2Contents[WeaponId]
end

function M:GetUnownedWeaponContentByWeaponId(WeaponId)
  if self:GetCurrentMainTabName() == AppearanceUtils.AppearanceMainTabNames.Melee then
    return self:GetUnownedMeleeWeaponContentByWeaponId(WeaponId)
  elseif self:GetCurrentMainTabName() == AppearanceUtils.AppearanceMainTabNames.Ranged then
    return self:GetUnownedRangedWeaponContentByWeaponId(WeaponId)
  end
end

function M:GetUnownedMeleeWeaponContentByWeaponId(WeaponId)
  return self.MeleeUnownedWeaponContentMap[WeaponId]
end

function M:GetUnownedRangedWeaponContentByWeaponId(WeaponId)
  return self.RangedUnownedWeaponContentMap[WeaponId]
end

function M:SetSelectedWeaponContent(Content)
  local OldSelectedContent = self:GetSelectedWeaponContent()
  if OldSelectedContent then
    ArmoryUtils:SetItemIsSelected(OldSelectedContent, false)
  end
  if self:GetCurrentMainTabName() == AppearanceUtils.AppearanceMainTabNames.Melee then
    self:SetSelectedMeleeWeaponContent(Content)
  elseif self:GetCurrentMainTabName() == AppearanceUtils.AppearanceMainTabNames.Ranged then
    self:SetSelectedRangedWeaponContent(Content)
  end
  ArmoryUtils:SetItemIsSelected(Content, true)
end

function M:GetSelectedWeaponContent()
  if self:GetCurrentMainTabName() == AppearanceUtils.AppearanceMainTabNames.Melee then
    return self:GetSelectedMeleeWeaponContent()
  elseif self:GetCurrentMainTabName() == AppearanceUtils.AppearanceMainTabNames.Ranged then
    return self:GetSelectedRangedWeaponContent()
  end
end

function M:SetSelectedMeleeWeaponContent(Content)
  self.SelectedMeleeWeaponContent = Content
end

function M:GetSelectedMeleeWeaponContent()
  return self.SelectedMeleeWeaponContent
end

function M:SetSelectedRangedWeaponContent(Content)
  self.SelectedRangedWeaponContent = Content
end

function M:GetSelectedRangedWeaponContent()
  return self.SelectedRangedWeaponContent
end

function M:GetSelectedWeapon()
  local Content = self:GetSelectedWeaponContent()
  if Content.IsOwned then
    local Avatar = ArmoryUtils:GetAvatar()
    return Avatar.Weapons[Content.Uuid]
  else
    return Content.Target
  end
end

function M:GetSelectedMeleeWeapon()
  return self.MeleeItemContentsMap[self:GetSelectedMeleeWeaponContent().Uuid]
end

function M:GetSelectedRangedWeapon()
  return self.RangedItemContentsMap[self:GetSelectedRangedWeaponContent().Uuid]
end

function M:IsSelectedWeaponOwned()
  return self:GetSelectedWeaponContent().IsOwned
end

function M:GetAllWeaponContent()
  return self.WeaponItemContentsMap
end

function M:GetMeleeWeaponContents()
  return self.MeleeItemContentsArray
end

function M:GetRangedWeaponContents()
  return self.RangedItemContentsArray
end

local function GetWeaponTag(Weapon)
  return Weapon:HasTag("Melee") and "Melee" or "Ranged"
end

local function AddContent(self, Weapon)
  local WeaponTag = GetWeaponTag(Weapon)
  local Obj = ArmoryUtils:NewCharOrWeaponItemContent(Weapon, CommonConst.ArmoryType.Weapon, WeaponTag, true)
  Obj.IsOwned = true
  self.View.WeaponContents:Add(Obj)
  self[WeaponTag .. "ItemContentsMap"][Weapon.Uuid] = Obj
  local WeaponId2ContentsName = WeaponTag .. "WeaponId2Contents"
  self[WeaponId2ContentsName][Weapon.WeaponId] = self[WeaponId2ContentsName][Weapon.WeaponId] or {}
  self[WeaponId2ContentsName][Weapon.WeaponId][Weapon.Uuid] = Obj
  table.insert(self[WeaponTag .. "ItemContentsArray"], Obj)
  self:OnWeaponContentCreated(Obj)
  return Obj
end

local function AddUnownedContent(self, Weapon)
  local WeaponTag = GetWeaponTag(Weapon)
  local Obj = ArmoryUtils:NewCharOrWeaponItemContent(Weapon, CommonConst.ArmoryType.Weapon, WeaponTag, true)
  Obj.bHideItemLevel = true
  Obj.IsOwned = false
  Obj.LockType = 2
  Obj.Level = nil
  self.View.WeaponContents:Add(Obj)
  self[WeaponTag .. "ItemContentsMap"][Weapon.Uuid] = Obj
  self[WeaponTag .. "UnownedWeaponContentMap"][Weapon.WeaponId] = Obj
  table.insert(self[WeaponTag .. "ItemContentsArray"], Obj)
  self:OnWeaponContentCreated(Obj)
  return Obj
end

local function UnownedContent2Content(self, UnownedContent, Weapon)
  local WeaponTag = GetWeaponTag(Weapon)
  self[WeaponTag .. "ItemContentsMap"][UnownedContent.Uuid] = nil
  if self[WeaponTag .. "UnownedWeaponContentMap"][UnownedContent.UnitId] then
    self[WeaponTag .. "UnownedWeaponContentMap"][UnownedContent.UnitId] = nil
  end
  local WeaponId2ContentsName = WeaponTag .. "WeaponId2Contents"
  if self[WeaponId2ContentsName][UnownedContent.UnitId] then
    self[WeaponId2ContentsName][UnownedContent.UnitId][UnownedContent.Uuid] = nil
  end
  local Obj = ArmoryUtils:NewCharOrWeaponItemContent(Weapon, CommonConst.ArmoryType.Weapon, WeaponTag, true, self.ReddotFrom)
  UnownedContent.Uuid = Obj.Uuid
  self[WeaponTag .. "ItemContentsMap"][UnownedContent.Uuid] = UnownedContent
  self[WeaponId2ContentsName][UnownedContent.UnitId] = self[WeaponId2ContentsName][UnownedContent.UnitId] or {}
  self[WeaponId2ContentsName][UnownedContent.UnitId][UnownedContent.Uuid] = UnownedContent
  UnownedContent.IsOwned = true
  UnownedContent.LockType = Obj.LockType
  UnownedContent.Level = Obj.Level
  UnownedContent.IsNew = Obj.IsNew
  UnownedContent.Upgradeable = Obj.Upgradeable
  UnownedContent.RedDotType = Obj.RedDotType
  UnownedContent.Target = nil
end

function M:CreateWeaponContents(Params)
  if rawget(self, "IsWeaponContentCreated") then
    return
  end
  rawset(self, "IsWeaponContentCreated", true)
  local Avatar = ArmoryUtils:GetAvatar()
  rawset(self, "MeleeItemContentsMap", {})
  rawset(self, "MeleeItemContentsArray", {})
  rawset(self, "MeleeUnownedWeaponContentMap", {})
  rawset(self, "RangedItemContentsMap", {})
  rawset(self, "RangedItemContentsArray", {})
  rawset(self, "RangedUnownedWeaponContentMap", {})
  rawset(self, "MeleeWeaponId2Contents", {})
  rawset(self, "RangedWeaponId2Contents", {})
  local OwnedWeapons = {}
  local RealAvatar = GWorld:GetAvatar()
  if RealAvatar then
    for _, value in pairs(RealAvatar.Weapons) do
      OwnedWeapons[value.WeaponId] = value
    end
  end
  
  local function InsertLogic(Weapon)
    if OwnedWeapons[Weapon.WeaponId] or Params.IsPreviewMode then
      return AddContent(self, Weapon)
    else
      return AddUnownedContent(self, Weapon)
    end
  end
  
  local Weapons = Avatar.Weapons
  if Params.WeaponUuids then
    Weapons = {}
    for _, Uuid in ipairs(Params.WeaponUuids) do
      if Avatar.Weapons[Uuid] then
        table.insert(Weapons, Avatar.Weapons[Uuid])
      end
    end
  end
  if Params.DoNotSort and Params.IsPreviewMode then
    local WeaponArray = {}
    if Params.InitialOrderWeaponUuids then
      for index, value in ipairs(Params.InitialOrderWeaponUuids) do
        table.insert(WeaponArray, Weapons[value])
      end
    else
      WeaponArray = Weapons
    end
    for _, Weapon in ipairs(WeaponArray) do
      InsertLogic(Weapon)
    end
  else
    for Uuid, Weapon in pairs(Weapons) do
      InsertLogic(Weapon)
    end
    if Params.IsPreviewMode or Params.WeaponUuids then
      return
    end
    try({
      exec = function()
        ArmoryUtils:DontResetUuid(true)
        for WeaponId, value in pairs(DataMgr.Weapon) do
          if not value.IsNotOpen and not OwnedWeapons[WeaponId] and CommonUtils.IsCurrentVersionRealease(CommonConst.DataType.Weapon, WeaponId) and (not HyperWeaponUtils.IsHyperWeapon(WeaponId) or ArmoryUtils:IsShowHyperWeapon("Melee")) then
            local DummyAvatar = ArmoryUtils:CreateNewDummyAvatar(ArmoryUtils.PreviewTargetStates.Prime, {
              WeaponIds = {WeaponId}
            })
            local _, Weapon = next(DummyAvatar.Weapons)
            local Content = InsertLogic(Weapon)
            Content.Target = Weapon
            Content.AvatarPrime = DummyAvatar
          end
        end
        ArmoryUtils:DontResetUuid(false)
      end,
      catch = function(err)
        local trace = debug.traceback()
        err = err or ""
        DebugPrint("Error: CY@ 未解锁武器信息创建失败!\n" .. err .. "\n" .. trace)
      end
    })
  end
  local CurMeleeWeaponContent = self.MeleeItemContentsMap[Avatar.MeleeWeapon]
  if CurMeleeWeaponContent then
    CurMeleeWeaponContent.bInGear = true
    self:SetSelectedMeleeWeaponContent(CurMeleeWeaponContent)
  end
  local CurRangedWeaponContent = self.RangedItemContentsMap[Avatar.RangedWeapon]
  if CurRangedWeaponContent then
    CurRangedWeaponContent.bInGear = true
    self:SetSelectedRangedWeaponContent(CurRangedWeaponContent)
  end
  self:SortWeaponContents({
    MainTabName = AppearanceUtils.AppearanceMainTabNames.Melee
  })
  self:SortWeaponContents({
    MainTabName = AppearanceUtils.AppearanceMainTabNames.Ranged
  })
end

function M:SortWeaponContents(Params)
  local AttrNames = {
    "Level",
    "SortPriority",
    "UnitId"
  }
  local MainTabName = Params.MainTabName or self:GetCurrentMainTabName()
  if MainTabName == AppearanceUtils.AppearanceMainTabNames.Melee then
    ArmoryUtils:SortItemContents(self.MeleeItemContentsArray, AttrNames, CommonConst.DESC, self:GetSelectedMeleeWeaponContent(), ArmoryUtils.IsOwnedCmpFunc)
  else
    ArmoryUtils:SortItemContents(self.RangedItemContentsArray, AttrNames, CommonConst.DESC, self:GetSelectedRangedWeaponContent(), ArmoryUtils.IsOwnedCmpFunc)
  end
end

return M
