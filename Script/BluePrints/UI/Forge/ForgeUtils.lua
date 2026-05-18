require("UnLua")
local ForgeUtils = {}

function ForgeUtils:HandleWeaponProduct(DraftInfo, Content)
  local WeaponInfo = DataMgr.Weapon[DraftInfo.ProductId]
  Content.Icon = WeaponInfo.Icon
  Content.Rarity = WeaponInfo.WeaponRarity
  return GText(WeaponInfo.WeaponName)
end

function ForgeUtils:HandleModProduct(DraftInfo, Content)
  local ModInfo = DataMgr.Mod[DraftInfo.ProductId]
  Content.Icon = ModInfo.Icon
  Content.Rarity = ModInfo.Rarity
  return GText(ModInfo.Name)
end

function ForgeUtils:HandleResourceProduct(DraftInfo, Content)
  local ResInfo = DataMgr.Resource[DraftInfo.ProductId]
  Content.Icon = ResInfo.Icon
  Content.Rarity = ResInfo.Rarity
  return GText(ResInfo.ResourceName)
end

function ForgeUtils:HandleCharAccessoryProduct(DraftInfo, Content)
  local AccessoryInfo = DataMgr.CharAccessory[DraftInfo.ProductId]
  Content.Icon = AccessoryInfo.Icon
  Content.Rarity = AccessoryInfo.Rarity
  return GText(AccessoryInfo.Name)
end

function ForgeUtils:HandleIronTicketProduct(DraftInfo, Content)
  local IronTicketInfo = DataMgr.IronTicket[DraftInfo.ProductId]
  Content.Icon = IronTicketInfo.Icon
  Content.Rarity = IronTicketInfo.Rarity
  return GText(IronTicketInfo.Name)
end

function ForgeUtils:HandleOtherProduct(DraftInfo, Content)
  return ""
end

function ForgeUtils:ConstructItemContentFromResourceId(ResType, ResId)
  local ItemIcon = ItemUtils.GetItemIconPath(ResId, ResType)
  local ItemRarity = ItemUtils.GetItemRarity(ResId, ResType)
  local Content = {
    UIName = "ForgeMain",
    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
    Id = ResId,
    ItemType = ResType,
    Rarity = ItemRarity,
    Icon = ItemIcon
  }
  return Content
end

function ForgeUtils:ConstructItemContentFromDraftId(DraftId)
  local DraftInfo = DataMgr.Draft[DraftId]
  local Content = {
    Id = DraftInfo.ProductId,
    UIName = "ForgeMain",
    ItemType = DraftInfo.ProductType,
    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
    HandleMouseDown = true
  }
  local ProductName = ""
  if DraftInfo then
    local funcName = "Handle" .. DraftInfo.ProductType .. "Product"
    if ForgeUtils[funcName] then
      ProductName = ForgeUtils[funcName](self, DraftInfo, Content)
    end
    if DraftInfo.ProductNum and DraftInfo.ProductNum > 1 then
      ProductName = ProductName .. " x" .. tostring(DraftInfo.ProductNum)
    end
  end
  Content.ProductName = ProductName
  return Content
end

function ForgeUtils:SecondsToHMS(Second)
  local Hour = math.floor(Second / 3600)
  Second = Second % 3600
  local Minute = math.floor(Second / 60)
  Second = Second % 60
  return Hour, Minute, Second
end

function ForgeUtils:GetResourceNum(ResType, ResId)
  local PlayerAvatar = GWorld:GetAvatar()
  if "Mod" == ResType then
    return PlayerAvatar:GetModCount2ModId(ResId)
  elseif "Resource" == ResType then
    return PlayerAvatar:GetResourceNum(ResId)
  end
  return 0
end

return ForgeUtils
