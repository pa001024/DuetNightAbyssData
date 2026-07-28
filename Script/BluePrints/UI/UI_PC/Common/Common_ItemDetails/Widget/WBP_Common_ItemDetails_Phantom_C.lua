require("UnLua")
local BattleUtils = require("Utils.BattleUtils")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:InitItemInfo(ItemType, ItemId, UnitId)
  local PlayerAvatar = GWorld:GetAvatar()
  self.ParentWidget.Text_Phantom:SetText(GText("UI_Shadow_Name"))
  local PhantomInfo = BattleUtils.ResolveCharacterAttributeSwitchPhantomData(DataMgr.Resource[ItemId])
  self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
  if PhantomInfo and PhantomInfo.FunctionDes then
    self.ParentWidget.Panel_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.ParentWidget.Text_ItemDescribe:SetText(GText(PhantomInfo.FunctionDes))
  else
    self.ParentWidget.Text_ItemDescribe:SetVisibility(ESlateVisibility.Collapsed)
  end
  local Level
  for _, v in pairs(PlayerAvatar.Chars) do
    if v.CharId == PhantomInfo.UseParam then
      Level = v.Level
    end
  end
  self.ParentWidget.Text_Level02:SetText(Level)
  local WeaponUuid = PlayerAvatar.Resources[ItemId].WeaponUuid
  self.Text_Weapon:SetText(GText("UI_Shadow_Carrying"))
  local WeaponItem = self:CreateWidgetNew("PhantomWeaponItemDetails")
  if WeaponUuid and "" ~= WeaponUuid then
    WeaponItem.Switch_Type:SetActiveWidget(WeaponItem.Panel_Material)
    local WeaponServerData = PlayerAvatar.Weapons[WeaponUuid]
    local WeaponInfo = DataMgr.Weapon[WeaponServerData.WeaponId]
    WeaponItem.Img_Weapon:SetBrushResourceObject(LoadObject(WeaponInfo.Icon))
    WeaponItem.Text_Name:SetText(GText(WeaponServerData.WeaponName))
    local FontMaterial = WeaponItem.Text_Name:GetDynamicFontMaterial()
    if 6 == WeaponInfo.WeaponRarity then
      FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_6)
    elseif 5 == WeaponInfo.WeaponRarity then
      FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_5)
    elseif 4 == WeaponInfo.WeaponRarity then
      FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_4)
    elseif 3 == WeaponInfo.WeaponRarity then
      FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_3)
    elseif 2 == WeaponInfo.WeaponRarity then
      FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_2)
    elseif 1 == WeaponInfo.WeaponRarity then
      FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_1)
    else
      FontMaterial:SetTextureParameterValue("IconTex", self.ParentWidget.Img_Text_0)
    end
    WeaponItem.Text_Level02:SetText(WeaponServerData.Level)
  else
    WeaponItem.Switch_Type:SetActiveWidget(WeaponItem.Panel_Empty)
    WeaponItem.Text_Empty:SetText(GText("UI_Armory_Weapon_NoAssist"))
  end
  self.Weapon:AddChild(WeaponItem)
end

return M
