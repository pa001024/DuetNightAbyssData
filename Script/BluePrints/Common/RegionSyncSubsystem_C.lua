require("Unlua")
require("Const")
local EMCache = require("EMCache.EMCache")
local M = Class()

function M:SetOnlyShowTeammateFromCache()
  self:SetOnlyShowTeammate(EMCache:Get("HidePlayer"))
end

function M:GetPreloadAssetPathFromLua(InObjId, PrelaodInfo)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    print(_G.LogTag, "RegionPlayerInitInfo Avatar is nil")
    return
  end
  if not Avatar.OtherRoleInfo then
    print(_G.LogTag, "RegionPlayerInitInfo Avatar.TempRoleInfo is nil")
    return
  end
  if not CommonUtils.IsObjIdStr(InObjId) then
    print(_G.LogTag, "RegionPlayerInitInfo ObjId is  not a Legal ObjIdStr")
    return
  end
  local LuaObjId = CommonUtils.Str2ObjId(InObjId)
  local RoleInfo = Avatar.OtherRoleInfo[LuaObjId]
  if not RoleInfo then
    print(_G.LogTag, "RegionPlayerInitInfo RoleInfo is nil")
    return
  end
  PrelaodInfo.RoleId = RoleInfo.RoleId
  PrelaodInfo.SkinId = RoleInfo.SkinId
  if RoleInfo.AppearanceSuit then
    print(_G.LogTag, "RegionPlayerInitInfo AppearanceSuitInfo")
    local AppearanceSuitInfo = RoleInfo.AppearanceSuit
    local AccessorySuit = AppearanceSuitInfo.AccessorySuit or {}
    local PartMeshAccessoryId, _ = self:GetOwnerPartMeshInfo(RoleInfo)
    PrelaodInfo.AccessoryIds:Add(PartMeshAccessoryId)
    for _, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes) do
      local AccessoryId = AccessorySuit[AccessoryTypeIdx]
      if AccessoryId and AccessoryId ~= PartMeshAccessoryId then
        PrelaodInfo.AccessoryIds:Add(AccessoryId)
      end
    end
  end
  if RoleInfo.RangedWeapon then
    local RangedWeapon = RoleInfo.RangedWeapon
    local RangedWeaponId = RangedWeapon.WeaponId
    local RangedWeaponSkinId = 0
    if RangedWeapon.AppearanceInfo then
      local AppearanceInfo = RangedWeapon.AppearanceInfo
      RangedWeaponSkinId = AppearanceInfo.SkinId
      if AppearanceInfo.AccessoryId > 0 then
        PrelaodInfo.AccessoryIds:Add(AppearanceInfo.AccessoryId)
      end
    end
    PrelaodInfo.RangedWeaponId = RangedWeaponId
    PrelaodInfo.RangedWeaponSkinId = RangedWeaponSkinId
  end
  if RoleInfo.MeleeWeapon then
    local MeleeWeapon = RoleInfo.MeleeWeapon
    local MeleeWeaponId = MeleeWeapon.WeaponId
    local MeleeWeaponSkinId = 0
    if MeleeWeapon.AppearanceInfo then
      local AppearanceInfo = MeleeWeapon.AppearanceInfo
      MeleeWeaponSkinId = AppearanceInfo.SkinId
      if AppearanceInfo.AccessoryId > 0 then
        PrelaodInfo.AccessoryIds:Add(AppearanceInfo.AccessoryId)
      end
    end
    PrelaodInfo.MeleeWeaponId = MeleeWeaponId
    PrelaodInfo.MeleeWeaponSkinId = MeleeWeaponSkinId
  end
end

function M:GetOwnerPartMeshInfo(RoleInfo)
  local _SkinId = RoleInfo.SkinId or RoleInfo.RoleId
  if not _SkinId then
    return
  end
  for AccessoryId, value in pairs(DataMgr.CharPartMesh) do
    if value.PartName == "PartMesh" then
      local SkinIds = value.Skin or {}
      for _, Id in pairs(SkinIds) do
        if Id == _SkinId then
          return AccessoryId, value.AccessoryType
        end
      end
    end
  end
end

function M:DebugPrintRoleInfo(InObjId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    print(_G.LogTag, "RegionPlayerInitInfo Avatar is nil")
    return
  end
  if not Avatar.OtherRoleInfo then
    print(_G.LogTag, "RegionPlayerInitInfo Avatar.TempRoleInfo is nil")
    return
  end
  if not CommonUtils.IsObjIdStr(InObjId) then
    print(_G.LogTag, "RegionPlayerInitInfo ObjId is  not a Legal ObjIdStr")
    return
  end
  local LuaObjId = CommonUtils.Str2ObjId(InObjId)
  local RoleInfo = Avatar.OtherRoleInfo[LuaObjId]
  if not RoleInfo then
    print(_G.LogTag, "RegionPlayerInitInfo RoleInfo is nil")
    return
  end
  PrintTalbe({RegionOnline_RoleInfo = RoleInfo}, 100)
end

function M:IsPreloadAssetReady()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not GameState then
    return true
  end
  local PreloadReady = GameState:IsPreloadGameAssetsReady()
  if nil == PreloadReady then
    return false
  end
  return PreloadReady
end

function M:AfterBornNewChar(ObjId, BornedChar)
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return
  end
  local RealObjId = CommonUtils.Str2ObjId(ObjId)
  local RoleInfo = Avatar.OtherRoleInfo[RealObjId]
  if nil == RoleInfo then
    return
  end
  Avatar:InitOnlineStateAfterBorn(RealObjId, RoleInfo)
end

return M
