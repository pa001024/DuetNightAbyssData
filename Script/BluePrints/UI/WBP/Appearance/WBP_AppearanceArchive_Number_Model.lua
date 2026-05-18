local AppearanceArchiveNumberModel = {}

function AppearanceArchiveNumberModel:GetSumNumberBase(Data)
  local Sum = 0
  for _, Info in pairs(Data) do
    if not Info.ExcludeCollect then
      Sum = Sum + 1
    end
  end
  return Sum
end

function AppearanceArchiveNumberModel:GetSkinSumNumber()
  return self:GetSumNumberBase(DataMgr.Skin)
end

function AppearanceArchiveNumberModel:GetCharAccessorySumNumber()
  return self:GetSumNumberBase(DataMgr.CharAccessory) + self:GetSumNumberBase(DataMgr.Hair)
end

function AppearanceArchiveNumberModel:GetWeaponSkinSumNumber()
  return self:GetSumNumberBase(DataMgr.WeaponSkin)
end

function AppearanceArchiveNumberModel:GetWeaponAccessorySumNumber()
  return self:GetSumNumberBase(DataMgr.WeaponAccessory)
end

function AppearanceArchiveNumberModel:GetMountSumNumber()
  return self:GetSumNumberBase(DataMgr.Mount)
end

function AppearanceArchiveNumberModel:GetResourceSumNumber()
  local Sum = 0
  for _, Info in pairs(DataMgr.Resource) do
    if not Info.ExcludeCollect and Info.ResourceSType == "GestureItem" then
      Sum = Sum + 1
    end
  end
  return Sum
end

function AppearanceArchiveNumberModel:GetCurrentNumber(Type)
  local Avatar = GWorld:GetAvatar()
  local CurrentNum = 0
  if Avatar and Avatar.AppearanceCollects and Avatar.AppearanceCollects[Type] and Avatar.AppearanceCollects[Type].GetAppearanceCollectCount then
    CurrentNum = Avatar.AppearanceCollects[Type]:GetAppearanceCollectCount()
  end
  return CurrentNum
end

function AppearanceArchiveNumberModel:CheckItemIsExcludedCollect(AppearanceCollectListId)
  local pos = string.find(AppearanceCollectListId, "#", 1, true)
  if pos then
    local ParentIndex = string.sub(AppearanceCollectListId, 1, pos - 1)
    local Id = tonumber(string.sub(AppearanceCollectListId, pos + 1))
    local Info = DataMgr[ParentIndex]
    if Info and Info[Id] and Info[Id].ExcludeCollect then
      return true
    end
  end
  return false
end

return AppearanceArchiveNumberModel
