require("UnLua")
local WBP_AutoChess_MonsterEquipTips = Class("BluePrints.UI.BP_EMUserWidget_C")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local RarityToSuffix = {
  1,
  2,
  3,
  4,
  5,
  6
}

function WBP_AutoChess_MonsterEquipTips:Construct()
  self.List_Equipment:Disablescroll(true)
  if self.Key01 then
    self.Key01:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.Key02 then
    self.Key02:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function WBP_AutoChess_MonsterEquipTips:Show(EquipInfo)
  if not EquipInfo then
    DebugPrint("--------------------EquipInfo---------------------")
    return
  end
  self.CurEquipId = EquipInfo.EquipId
  self:ShowEquipInfo(EquipInfo)
  self:SetVisibility(UE4.ESlateVisibility.Visible)
end

function WBP_AutoChess_MonsterEquipTips:Hide()
  DebugPrint("[EquipTips] Hide")
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_AutoChess_MonsterEquipTips:ShowEquipInfo(EquipInfo)
  if not EquipInfo then
    return
  end
  if self.Text_Cost then
    self.Text_Cost:SetText(GText(tostring(EquipInfo.DeployCost)))
  end
  if self.Text_CostDesc then
    self.Text_CostDesc:SetText(GText("UI_AutoChess_WeaponCost"))
  end
  local EquipAttrInfo = Model:GetEquipInfoByEquipId(EquipInfo.EquipId)
  local Rarity = EquipAttrInfo.Rarity or 0
  local Suffix = RarityToSuffix[Rarity] or 0
  if self.Value_01 then
    self.Value_01:InitView(GText("UI_AutoChess_MonsterProp1"), EquipAttrInfo.Atk)
  end
  if self.Value_02 then
    self.Value_02:InitView(GText("UI_AutoChess_MonsterProp2"), EquipAttrInfo.Hp)
  end
  if self.Value_03 then
    self.Value_03:InitView(GText("UI_AutoChess_MonsterProp3"), EquipAttrInfo.Def)
  end
  if self.Value_04 then
    self.Value_04:InitView(GText("UI_AutoChess_MonsterProp4"), EquipAttrInfo.Es)
  end
  self.Text_ItemName:SetText(GText(EquipInfo.EquipName))
  local FontMat = self.Text_ItemName:GetDynamicFontMaterial()
  FontMat:SetTextureParameterValue("IconTex", self[string.format("Img_Text_%s", Suffix)])
  if 0 ~= Suffix then
    self.OutLine_Quality:SetBrushFromTexture(self[string.format("Img_Line_%s", Suffix)])
  end
  self.List_Equipment:ClearListItems()
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.EffectText = Model:CalcEquipExtraDesc(EquipInfo.EquipId)
  self.List_Equipment:AddItem(Obj)
end

return WBP_AutoChess_MonsterEquipTips
