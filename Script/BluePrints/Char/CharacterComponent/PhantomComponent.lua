local BattleUtils = require("Utils.BattleUtils")
local Component = {}

function Component:UseNewCreatePhantom(RoleId, BTIndex, IsHostage, Info, ExtraInfo, Level)
  local Context = AEventMgr.CreateUnitContext()
  Context.UnitType = "Phantom"
  Context.UnitId = RoleId
  Context.IntParams:Add("RoleId", RoleId)
  Context.IntParams:Add("BTIndex", BTIndex - 1)
  Context.IntParams:Add("PhantomOwnerEid", self.Eid)
  Context.IntParams:Add("Camp", ECampName.Player)
  Context.IntParams:Add("FixLocationZ", 0)
  Context.IntParams:Add("RegionDataType", 0)
  Context.BoolParams:Add("IsHostage", IsHostage)
  if Level then
    Context.IntParams:Add("Level", Level or 1)
  end
  if ExtraInfo.SkipInitWaitCheck then
    Context.BoolParams:Add("SkipInitWaitCheck", true)
  end
  if ExtraInfo.ForceSync then
    Context.BoolParams:Add("ForceSync", true)
  end
  Context.BoolParams:Add("FixLocation", true)
  Context:AddLuaTable("AvatarInfo", Info)
  if ExtraInfo.MeleeWeapon and next(ExtraInfo.MeleeWeapon) or ExtraInfo.RangedWeapon and next(ExtraInfo.RangedWeapon) then
    Context:AddLuaTable("MeleeWeapon", ExtraInfo.MeleeWeapon)
    Context:AddLuaTable("RangedWeapon", ExtraInfo.RangedWeapon)
  end
  self:CreatePhantomNew(Context, RoleId, ExtraInfo.IsSpawnByGM ~= nil, nil ~= ExtraInfo.IsSpawnByResource, nil ~= ExtraInfo.IsSpawnBySquad, ExtraInfo.TeamIndex or 1)
end

function Component:ShowPhantomSummonMax()
  self:ClientShowToast(UIConst.Tip_CommonToast, GText("UI_Tosat_PhantomSummon_Num"))
end

function Component:CreatePhantom(RoleId, BTIndex, Info, ExtraInfo, Level)
  if not RoleId then
    return
  end
  local IsHostage = false
  local ExtraCreateInfo = BattleUtils.GetExtraCreateInfo("Phantom", RoleId, RoleId)
  if ExtraCreateInfo then
    IsHostage = ExtraCreateInfo.IsHostage
    BTIndex = BTIndex or ExtraCreateInfo.BTIndex
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:SaveCreatePhantomInfo(RoleId, BTIndex, Info, ExtraInfo, Level)
  end
  self:UseNewCreatePhantom(RoleId, BTIndex, IsHostage, Info, ExtraInfo, Level)
end

function Component:ReCreatePhantom(RoleId, BTIndex, Info, ExtraInfo, Level)
  local IsHostage = false
  local ExtraCreateInfo = BattleUtils.GetExtraCreateInfo("Phantom", RoleId, RoleId)
  if ExtraCreateInfo then
    IsHostage = ExtraCreateInfo.IsHostage
    BTIndex = BTIndex or ExtraCreateInfo.BTIndex
  end
  self:UseNewCreatePhantom(RoleId, BTIndex, IsHostage, Info, ExtraInfo, Level)
end

function Component:CreateAutoAssistPhantoms(bIgnoreCondition)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if Avatar:GetAutoPhantomForBigWorldState() then
    return
  end
  if not bIgnoreCondition and not ConditionUtils.CheckCondition(Avatar, 4490) then
    return false
  end
  local UpdateInfo = Avatar:GetFirstTwoPhantomAndWeapon()
  if not UpdateInfo then
    return
  end
  local AvatarUtils = require("BluePrints.Client.AvatarUtils")
  local Pet = Avatar.CurrentPet and Avatar.Pets[Avatar.CurrentPet] or nil
  
  local function CreateDefaultPhantom(CharEid, WeaponEid, WeaponModSuit, TeamIndex)
    if not CharEid or not WeaponEid then
      return
    end
    local Char = Avatar.Chars[CharEid]
    local Weapon = Avatar.Weapons[WeaponEid]
    if not Char or not Weapon then
      return
    end
    local PhantomInfo = AvatarUtils:GetPhantomBattleInfo(Avatar, Char, Weapon, Pet, false, nil, WeaponModSuit)
    local RoleId = PhantomInfo and PhantomInfo.RoleInfo and PhantomInfo.RoleInfo.RoleId
    if not RoleId then
      return
    end
    self:CreatePhantom(RoleId, 1, PhantomInfo, {IsSpawnBySquad = 1, TeamIndex = TeamIndex})
  end
  
  CreateDefaultPhantom(UpdateInfo.Phantom1, UpdateInfo.PhantomWeapon1, UpdateInfo.PhantomWeaponModSuit1, 1)
  CreateDefaultPhantom(UpdateInfo.Phantom2, UpdateInfo.PhantomWeapon2, UpdateInfo.PhantomWeaponModSuit2, 2)
end

function Component:TryCreateAutoAssistPhantomsForBigWorld()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or Avatar:GetAutoPhantomForBigWorldState() then
    return false
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not IsValid(GameMode) or GameMode:IsGamePaused() then
    return false
  end
  local PhantomTeammates = self:GetPhantomTeammates(false, true)
  for _, Phantom in pairs(PhantomTeammates) do
    if IsValid(Phantom) then
      return false
    end
  end
  self:CreateAutoAssistPhantoms()
  return true
end

function Component:CreatePhantomOnLevelTransition()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local PhantomCreateInfo = Avatar.PhantomCreateInfo
  if PhantomCreateInfo and next(PhantomCreateInfo) then
    for PhantomRoleId, CreateInfo in pairs(PhantomCreateInfo) do
      local CurrentCharId = BattleUtils.GetCurrentCharacterAttributeCharId(PhantomRoleId)
      self:ReCreatePhantom(CurrentCharId, CreateInfo.BTIndex, CreateInfo.Info, CreateInfo.ExtraInfo, CreateInfo.Level)
    end
    return
  end
  self:CreateAutoAssistPhantoms()
end

return Component
