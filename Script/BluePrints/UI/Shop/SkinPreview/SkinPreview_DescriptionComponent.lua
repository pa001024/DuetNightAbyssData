local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = {}

function M:UpdateDescription(ItemData)
  local itemType = ItemData.ItemType
  if "Skin" == itemType then
    self:UpdateCharSkinDescription(ItemData)
  elseif "WeaponSkin" == itemType then
    self:UpdateWeaponSkinDescription(ItemData)
  elseif "CharAccessory" == itemType then
    self:UpdateCharAccessoryDescription(ItemData)
  elseif "WeaponAccessory" == itemType then
    self:UpdateWeaponAccessoryDescription(ItemData)
  elseif "Resource" == itemType then
    self:UpdateCharGestureDescription(ItemData)
  end
end

function M:UpdateCharSkinDescription(SkinInfo)
  local SkinData = DataMgr.Skin[SkinInfo.TypeId]
  if not SkinData then
    return
  end
  local CharInfo = DataMgr.Char[SkinData.CharId]
  if not CharInfo then
    return
  end
  self.Text_CharName:SetText(GText(CharInfo.CharName))
  self.Text_SkinName:SetText(GText(SkinData.SkinName))
  self.Text_Info:SetText(GText(SkinData.SkinDescribe))
  self.Tag_Quality:Init(SkinData.Rarity)
  self:UpdateSkinNameFontByRarity(SkinData.Rarity)
  self:HideZoomKey(false)
  self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.HorizontalBox_Color:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
  local ElementType = DataMgr.BattleChar[SkinData.CharId].Attribute
  if ElementType then
    local IconName = "Armory_" .. ElementType
    local AttributeIcon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
    self.Image_Element:SetBrushResourceObject(AttributeIcon)
    self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.Avatar:CheckCharEnough({
    [SkinData.CharId] = 1
  }) then
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Text_Char_None:SetText(GText("UI_SkinPreview_CharNotOwned"))
    self.Text_Char_None:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:UpdateCharAccessoryDescription(SkinInfo)
  local AccessoryData = DataMgr.CharAccessory[SkinInfo.TypeId]
  if not AccessoryData then
    return
  end
  self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap[AccessoryData.AccessoryType]))
  self.Text_SkinName:SetText(GText(AccessoryData.Name))
  self.Text_Info:SetText(GText(AccessoryData.Des))
  self.Tag_Quality:Init(AccessoryData.Rarity)
  self:UpdateSkinNameFontByRarity(AccessoryData.Rarity)
  self:HideZoomKey(false)
  self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
  self.HorizontalBox_Color:SetVisibility(ESlateVisibility.Collapsed)
  self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
  local AccessoryIconPath = ArmoryUtils:GetCharNoneAccessoryIconPaths()[AccessoryData.AccessoryType]
  if AccessoryIconPath then
    local AccessoryIcon = LoadObject(AccessoryIconPath)
    self.Image_Element:SetBrushResourceObject(AccessoryIcon)
    self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:UpdateCharGestureDescription(SkinInfo)
  local GestureData = DataMgr.Resource[SkinInfo.TypeId]
  if not GestureData or GestureData.ResourceSType ~= "GestureItem" then
    return
  end
  self.Text_CharName:SetText(GText("UI_Preview_GestureItem"))
  self.Text_SkinName:SetText(GText(GestureData.ResourceName))
  self.Text_Info:SetText(GText(GestureData.DetailDes))
  self.Tag_Quality:Init(GestureData.Rarity)
  self:UpdateSkinNameFontByRarity(GestureData.Rarity)
  self:HideZoomKey(false)
  self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
  self.HorizontalBox_Color:SetVisibility(ESlateVisibility.Collapsed)
  self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
  self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
end

function M:UpdateWeaponSkinDescription(SkinInfo)
  local WeaponSkinData = DataMgr.WeaponSkin[SkinInfo.TypeId]
  if not WeaponSkinData then
    return
  end
  self.Text_SkinName:SetText(GText(WeaponSkinData.Name))
  self.Text_Info:SetText(GText(WeaponSkinData.Dec))
  self.Tag_Quality:Init(WeaponSkinData.Rarity)
  self:UpdateSkinNameFontByRarity(WeaponSkinData.Rarity)
  self:HideZoomKey(true)
  self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
  self.HorizontalBox_Color:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Tab_Change:SetVisibility(ESlateVisibility.Collapsed)
  local WeaponTypeInfo = DataMgr.WeaponTypeContrast[WeaponSkinData.ApplicationType]
  if not WeaponTypeInfo then
    return
  end
  self.Text_CharName:SetText(string.format(GText("UI_SkinPreview_WeaponType"), GText(WeaponTypeInfo.WeaponTagTextmap)))
  if WeaponTypeInfo.Icon then
    local TagIcon = LoadObject(WeaponTypeInfo.Icon)
    self.Image_Element:SetBrushResourceObject(TagIcon)
    self.Image_Element:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Image_Element:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:UpdateWeaponAccessoryDescription(SkinInfo)
  local WeaponAccessoryData = DataMgr.WeaponAccessory[SkinInfo.TypeId]
  if not WeaponAccessoryData then
    return
  end
  self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap[SkinInfo.ItemType]))
  self.Text_SkinName:SetText(GText(WeaponAccessoryData.Name))
  self.Text_Info:SetText(GText(WeaponAccessoryData.Des))
  self.Tag_Quality:Init(WeaponAccessoryData.Rarity)
  self:UpdateSkinNameFontByRarity(WeaponAccessoryData.Rarity)
  self:HideZoomKey(true)
  self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
  self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
  self.HorizontalBox_Color:SetVisibility(ESlateVisibility.Collapsed)
  self.Tab_Change:SetVisibility(ESlateVisibility.Visible)
end

return M
