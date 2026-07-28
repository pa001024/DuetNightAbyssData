require("UnLua")
local M = {}

function M:Init(Params)
  Params = Params or {}
  self.ViewUI = Params.ViewUI
end

local function ApplyAppearanceToCharacter(Character, AppearanceInfo)
  if nil == Character or nil == Character.CharacterFashion or nil == AppearanceInfo then
    return
  end
  if Character.CurrentCompositeMesh then
    Character.CurrentCompositeMesh = nil
  end
  local ModelComp = Character:GetCharModelComponent()
  if ModelComp then
    ModelComp:LoadCurrentModel()
  end
  if Character.EMAnimInstance and Character.EMAnimInstance.CharacterTag ~= Character:GetCharacterTag() then
    Character.EMAnimInstance.CharacterTag = Character:GetCharacterTag()
  end
  Character.CharacterFashion:InitAppearanceSuit(AppearanceInfo)
  if Character.PlayerAnimInstance then
    Character.PlayerAnimInstance:SetKawiiLayerState(EKawaiiLayerState.EKLS_Armory)
  end
end

function M:ApplyCharacterAppearance(CharacterHandle, AppearanceInfo)
  if not CharacterHandle or not AppearanceInfo then
    return
  end
  local MainActor = CharacterHandle:GetActor()
  local ReflectionActor = CharacterHandle:GetReflectionActor()
  CharacterHandle.CurrentAppearanceInfo = AppearanceInfo
  ApplyAppearanceToCharacter(MainActor, AppearanceInfo)
  ApplyAppearanceToCharacter(ReflectionActor, AppearanceInfo)
  CharacterHandle:UpdateReflectionTransform()
end

function M:ApplyWeaponAppearance(CharacterHandle, WeaponData, AppearanceInfo)
  if not CharacterHandle or not WeaponData then
    return
  end
  CharacterHandle:ChangeDisplayWeapon(WeaponData)
  
  local function ChangePlayerWeaponAppearanceInternal(PlayCharacter)
    if nil == PlayCharacter then
      return
    end
    local WeaponTag = WeaponData:HasTag("Melee") and "Melee" or "Ranged"
    local Weapon = PlayCharacter[WeaponTag .. "Weapon"]
    if Weapon and AppearanceInfo then
      Weapon:InitWeaponAppearance(AppearanceInfo)
    end
  end
  
  ChangePlayerWeaponAppearanceInternal(CharacterHandle:GetActor())
  ChangePlayerWeaponAppearanceInternal(CharacterHandle:GetReflectionActor())
end

function M:ChangeHair(CharacterHandle, HairId)
  local AppearanceInfo = CharacterHandle and CharacterHandle.CurrentAppearanceInfo
  if not CharacterHandle or not AppearanceInfo then
    return
  end
  AppearanceInfo.HairId = HairId
  
  local function ChangeCharHairInternal(Character)
    local CharacterFashion = Character and Character.CharacterFashion
    if not CharacterFashion then
      return
    end
    CharacterFashion:ChangeCharHair(HairId)
  end
  
  ChangeCharHairInternal(CharacterHandle:GetActor())
  ChangeCharHairInternal(CharacterHandle:GetReflectionActor())
end

function M:ChangeHairColor(CharacterHandle, Colors)
  local AppearanceInfo = CharacterHandle and CharacterHandle.CurrentAppearanceInfo
  if not CharacterHandle or not AppearanceInfo then
    return
  end
  AppearanceInfo.HairColors = Colors
  
  local function ChangeHairColorInternal(Character)
    local CharacterFashion = Character and Character.CharacterFashion
    if not CharacterFashion then
      return
    end
    CharacterFashion:InitHairColors(Colors)
  end
  
  ChangeHairColorInternal(CharacterHandle:GetActor())
  ChangeHairColorInternal(CharacterHandle:GetReflectionActor())
end

function M:ChangeSkinColor(CharacterHandle, Colors)
  local AppearanceInfo = CharacterHandle and CharacterHandle.CurrentAppearanceInfo
  if not CharacterHandle or not AppearanceInfo then
    return
  end
  AppearanceInfo.Colors = Colors
  
  local function ChangeSkinColorInternal(Character)
    local CharacterFashion = Character and Character.CharacterFashion
    if not CharacterFashion then
      return
    end
    Character.CharacterFashion:RefreshUncoloredSkinColors(Colors)
  end
  
  ChangeSkinColorInternal(CharacterHandle:GetActor())
  ChangeSkinColorInternal(CharacterHandle:GetReflectionActor())
end

function M:ChangeAccessory(CharacterHandle, AccessoryId, AccessoryType, CustomParams)
  local AppearanceInfo = CharacterHandle and CharacterHandle.CurrentAppearanceInfo
  if not CharacterHandle or not AppearanceInfo then
    return
  end
  AppearanceInfo.AccessorySuit = AppearanceInfo.AccessorySuit or {}
  AppearanceInfo.AccessorySuit[CommonConst.NewCharAccessoryTypes[AccessoryType]] = AccessoryId
  
  local function ChangeAccessoryInternal(Character)
    if Character and Character.CharacterFashion then
      Character.CharacterFashion:ChangeAccessory(AccessoryId, AccessoryType, CustomParams)
    end
  end
  
  ChangeAccessoryInternal(CharacterHandle:GetActor())
  ChangeAccessoryInternal(CharacterHandle:GetReflectionActor())
end

function M:SetAccessoryOffset(CharacterHandle, AccessoryId, AccessoryType, Transform)
  if not CharacterHandle or not Transform then
    return
  end
  
  local function SetAccessoryOffsetInternal(Character)
    if Character then
      Character:SetAccessoryTransform(AccessoryId, AccessoryType, Transform)
    end
  end
  
  SetAccessoryOffsetInternal(CharacterHandle:GetActor())
  SetAccessoryOffsetInternal(CharacterHandle:GetReflectionActor())
end

function M:Dispose()
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

return M
