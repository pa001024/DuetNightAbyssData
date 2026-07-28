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

function AppearanceArchiveNumberModel:GetServerSumNumberBase(Data)
  local Sum = 0
  for _, Info in pairs(Data) do
    if not Info.ExcludeCollectServer then
      Sum = Sum + 1
    end
  end
  return Sum
end

function AppearanceArchiveNumberModel:GetSkinSumNumber(IsServer)
  if IsServer then
    return self:GetServerSumNumberBase(DataMgr.Skin)
  else
    return self:GetSumNumberBase(DataMgr.Skin)
  end
end

function AppearanceArchiveNumberModel:GetCharAccessorySumNumber(IsServer)
  if IsServer then
    return self:GetServerSumNumberBase(DataMgr.CharAccessory) + self:GetServerSumNumberBase(DataMgr.Hair)
  else
    return self:GetSumNumberBase(DataMgr.CharAccessory) + self:GetSumNumberBase(DataMgr.Hair)
  end
end

function AppearanceArchiveNumberModel:GetWeaponSkinSumNumber(IsServer)
  if IsServer then
    return self:GetServerSumNumberBase(DataMgr.WeaponSkin)
  else
    return self:GetSumNumberBase(DataMgr.WeaponSkin)
  end
end

function AppearanceArchiveNumberModel:GetWeaponAccessorySumNumber(IsServer)
  if IsServer then
    return self:GetServerSumNumberBase(DataMgr.WeaponAccessory)
  else
    return self:GetSumNumberBase(DataMgr.WeaponAccessory)
  end
end

function AppearanceArchiveNumberModel:GetMountSumNumber(IsServer)
  if IsServer then
    return self:GetServerSumNumberBase(DataMgr.Mount)
  else
    return self:GetSumNumberBase(DataMgr.Mount)
  end
end

function AppearanceArchiveNumberModel:GetResourceSumNumber(IsServer)
  local Sum = 0
  for _, Info in pairs(DataMgr.Resource) do
    if Info.ResourceSType == "GestureItem" and (not (not IsServer or Info.ExcludeCollectServer) or not IsServer and not Info.ExcludeCollect) then
      Sum = Sum + 1
    end
  end
  return Sum
end

function AppearanceArchiveNumberModel:GetCurrentNumber(Type, IsServer)
  local Avatar = GWorld:GetAvatar()
  local CurrentNum = 0
  if Avatar and Avatar.AppearanceCollects and Avatar.AppearanceCollects[Type] then
    if IsServer then
      local AppearanceCollectList = Avatar.AppearanceCollects[Type].AppearanceCollectList or {}
      for key, _ in pairs(AppearanceCollectList) do
        CurrentNum = CurrentNum + 1
      end
    elseif Avatar.AppearanceCollects[Type].GetAppearanceCollectCount then
      CurrentNum = Avatar.AppearanceCollects[Type]:GetAppearanceCollectCount()
    end
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
