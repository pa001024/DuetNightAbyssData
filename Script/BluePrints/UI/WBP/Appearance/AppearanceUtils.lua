local M = {}
M.AppearanceMainTabNames = {
  Char = "Char",
  Melee = "Melee",
  Ranged = "Ranged",
  Mount = "Mount",
  Gesture = "Gesture"
}

function M.GetCharAppearanceReddot(CharId)
  local Avatar = GWorld:GetAvatar()
  local CommonChar = Avatar.CommonChars[CharId]
  if not CommonChar then
    return false, false
  end
  local HasNewSkin = false
  local HasUpgradeableSkin = false
  local SkinNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. CharId
  local SkinNode = ReddotManager.GetTreeNode(SkinNodeName)
  HasNewSkin = SkinNode and SkinNode.Count > 0 or false
  local CharHairNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair .. CharId
  local CharHairNode = ReddotManager.GetTreeNode(CharHairNodeName)
  HasNewSkin = HasNewSkin or CharHairNode and CharHairNode.Count > 0 or false
  local SkinLevelUpNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. "LevelUp" .. CharId
  local SkinLevelUpNode = ReddotManager.GetTreeNode(SkinLevelUpNodeName)
  HasUpgradeableSkin = SkinLevelUpNode and SkinLevelUpNode.Count > 0 or false
  return HasNewSkin, HasUpgradeableSkin
end

function M.GetCharListReddotType(CharId, IsOwned)
  if not IsOwned then
    return nil
  end
  local HasNewSkin, HasUpgradeableSkin = M.GetCharAppearanceReddot(CharId)
  if HasUpgradeableSkin then
    return UIConst.RedDotType.CommonRedDot
  elseif HasNewSkin then
    return UIConst.RedDotType.NewRedDot
  end
  return nil
end

function M.GetWeaponListReddotType(WeaponId, IsOwned)
  if not IsOwned then
    return nil
  end
  local Data = DataMgr.Weapon[WeaponId]
  if not Data or not Data.SkinApplicationType then
    return nil
  end
  local HasNewSkin = false
  for _, value in pairs(Data.SkinApplicationType) do
    local NodeName = CommonConst.DataType.WeaponSkin .. (value or "")
    local Node = ReddotManager.GetTreeNode(NodeName)
    if Node and Node.Count > 0 then
      HasNewSkin = true
      break
    end
  end
  if not HasNewSkin then
    local BattleWeaponData = DataMgr.BattleWeapon[WeaponId]
    if BattleWeaponData and BattleWeaponData.ModApplicationType then
      local TypeArray = type(BattleWeaponData.ModApplicationType) == "table" and BattleWeaponData.ModApplicationType or {
        BattleWeaponData.ModApplicationType
      }
      for _, ApplicationType in pairs(TypeArray) do
        local WeaponStanceFXNode = ReddotManager.GetTreeNode("WeaponStanceFX" .. ApplicationType)
        if WeaponStanceFXNode and WeaponStanceFXNode.Count > 0 then
          HasNewSkin = true
          break
        end
      end
    end
  end
  if HasNewSkin then
    return UIConst.RedDotType.NewRedDot
  end
  return nil
end

function M.GetCharTabReddot()
  local HasNewAppearance = false
  local HasUpgradeableSkin = false
  local HasArchiveReward = false
  local NewCharAppearanceNode = ReddotManager.GetTreeNode("NewCharAppearance")
  HasNewAppearance = NewCharAppearanceNode and NewCharAppearanceNode.Count > 0 or false
  local CharSkinLevelUpNode = ReddotManager.GetTreeNode("CharSkinLevelUp")
  HasUpgradeableSkin = CharSkinLevelUpNode and CharSkinLevelUpNode.Count > 0 or false
  local ArchiveRewardNode = ReddotManager.GetTreeNode("AppearanceEntrance")
  HasArchiveReward = ArchiveRewardNode and ArchiveRewardNode.Count > 0 or false
  local IsNew = HasNewAppearance
  local IsCommon = HasUpgradeableSkin or HasArchiveReward
  return IsNew, IsCommon
end

function M.GetWeaponTabReddot(WeaponType)
  local NodeName = "New" .. WeaponType .. "Appearance"
  local Node = ReddotManager.GetTreeNode(NodeName)
  local WeaponAccessoryNode = ReddotManager.GetTreeNode(CommonConst.DataType.WeaponAccessory)
  local NewWeaponStanceFXCount = 0
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.Weapons then
    for Uuid, Weapon in pairs(Avatar.Weapons) do
      if Weapon:HasTag(WeaponType) then
        local BattleWeaponData = DataMgr.BattleWeapon[Weapon.WeaponId]
        if BattleWeaponData and BattleWeaponData.ModApplicationType then
          local ModApplicationType = BattleWeaponData.ModApplicationType
          for _, ApplicationType in pairs(ModApplicationType or {}) do
            local WeaponStanceFXNode = ReddotManager.GetTreeNode("WeaponStanceFX" .. ApplicationType)
            NewWeaponStanceFXCount = NewWeaponStanceFXCount + (WeaponStanceFXNode and WeaponStanceFXNode.Count or 0)
          end
        end
      end
    end
  end
  return Node and Node.Count > 0 or WeaponAccessoryNode and WeaponAccessoryNode.Count > 0 or NewWeaponStanceFXCount > 0
end

function M.UpdateSingleCharReddot(Content)
  local RedDotType = M.GetCharListReddotType(Content.UnitId, Content.IsOwned)
  Content.RedDotType = RedDotType
  if Content.Widget and Content.Widget.SetReddot then
    Content.Widget:SetReddot(RedDotType)
  end
end

function M.UpdateSingleWeaponReddot(Content)
  local RedDotType = M.GetWeaponListReddotType(Content.UnitId, Content.IsOwned)
  Content.RedDotType = RedDotType
  if Content.Widget and Content.Widget.SetReddot then
    Content.Widget:SetReddot(RedDotType)
  end
end

function M.UpdateCharListReddot(Contents)
  for _, Content in ipairs(Contents) do
    M.UpdateSingleCharReddot(Content)
  end
end

function M.UpdateWeaponListReddot(Contents)
  for _, Content in ipairs(Contents) do
    M.UpdateSingleWeaponReddot(Content)
  end
end

return M
