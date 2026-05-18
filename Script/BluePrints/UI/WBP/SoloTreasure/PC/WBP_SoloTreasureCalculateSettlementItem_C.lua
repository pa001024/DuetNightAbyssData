require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Content = Content
  if self.Content.IsEmpty then
    self.Content.SelfWidget = self
    self:PlayAnimation(self.Empty)
    return
  end
  self:LoadItem(Content)
end

function M:LoadItem(Content)
  self.Content = Content
  self.ItemIndex = Content.ItemIndex
  self.IconPath = Content.Icon
  self.Rarity = Content.Rarity
  self.Value = Content.Value
  self.RealValue = Content.Value
  self.TreasureType = Content.TreasureType
  self.BuffRarity = Content.BuffRarity
  self.BuffRate = Content.BuffRate
  self.BuffType = Content.BuffType
  self.BuffParam1 = Content.BuffParam1
  self.BuffParam2 = Content.BuffParam2
  self.Owner = Content.Owner
  self.RarityToAnimation = {
    self.White_In,
    self.Green_In,
    self.Blue_In,
    self.Purple_In,
    self.Gold_In,
    self.Red_In
  }
  self.RarityToAudioSound = {
    "None",
    "event:/ui/activity/sdc_item_detect_green",
    "None",
    "event:/ui/activity/sdc_item_detect_purple",
    "event:/ui/activity/sdc_item_detect_gold",
    "event:/ui/activity/sdc_item_detect_red"
  }
  self:CalItemRealValue()
  self:InitUI()
end

function M:PlayAnimationByRarity()
  if self.RarityToAnimation[self:GetShowRarity()] then
    self:PlayAnimation(self.RarityToAnimation[self:GetShowRarity()])
    AudioManager(self):PlayUISound(self, self.RarityToAudioSound[self:GetShowRarity()], "ItemIn", nil)
  end
  if self:CheckBuffCondition() then
    self.BuffLable.Text_LableNum:SetText(string.format(GText("UI_Extraction_TM_44"), tostring(self.BuffRate)))
    self.BuffLable:SetVisibility(ESlateVisibility.Visible)
    self.BuffLable:SetLableType(self.BuffRarity - 1)
    self.BuffLable:PlayAnimation(self.BuffLable.In)
    self.Owner.WBP_Buff02:PlayAnimation(self.Owner.WBP_Buff02.Buff_Add)
  end
end

function M:GetShowRarity()
  local TreasureRarityInfo = DataMgr.ExtractionTreasureRarity
  if TreasureRarityInfo then
    return TreasureRarityInfo[self.Rarity].ShowRarity
  end
  return 2
end

function M:GetItemRealValue()
  return self.RealValue
end

function M:CalItemRealValue()
  if self:CheckBuffCondition() then
    self.RealValue = self.Value * self.BuffRate
  end
end

function M:CheckBuffCondition()
  if not self.BuffType then
    return false
  end
  if 6 == self.Rarity then
    return false
  end
  if 1 == self.BuffType then
    return self.Rarity == self.BuffParam1
  elseif 2 == self.BuffType then
    return self.TreasureType == self.BuffParam1
  else
    return false
  end
end

function M:InitUI()
  self:UpdateIcon()
  self:UpdateBg()
  self:UpdateValue()
  self:CheckPlayInAnimation()
end

function M:CheckPlayInAnimation()
  if not self.Owner then
    return
  end
  if self.Owner.CurIndex == self.ItemIndex then
    self:PlayAnimationByRarity()
    self.Owner.CurWidget = self
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:UpdateIcon()
  local Material = self.WBP_Item.Item_BG:GetDynamicMaterial()
  if Material and self.IconPath then
    Material:SetTextureParameterValue("IconMap", LoadObject(self.IconPath))
  end
end

function M:UpdateValue()
  local NumText = string.format("%s", Utils.FormatNumber(self.Value, false))
  self.Text_Num:SetText(NumText)
end

function M:UpdateBg()
  local Material = self.WBP_Item.Item_BGPanel:GetDynamicMaterial()
  if Material then
    Material:SetScalarParameterValue("Index", self:GetShowRarity())
  end
end

return M
