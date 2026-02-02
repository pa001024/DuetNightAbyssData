require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitWidgetItem(Content)
  self.Eid = Content.Eid
  self.Name = Content.Name
  self.IconPath = Content.Icon
  self.Damage = Content.Damage
  self.Damaged = Content.Damaged
  self.Heal = Content.Heal
  self.UnitId = Content.UnitId
  self.TotalDamage = Content.TotalDamage
  self.TotalDamaged = Content.TotalDamaged
  self.TotalHeal = Content.TotalHeal
  self.BarLen = self.SizeBox_0.WidthOverride
  self.Owner = Content.Owner
  self.Index = Content.Index
  self:InitUI()
  self:PlayAnimation(self.In)
end

function M:PlayInAnimation()
  self:PlayAnimation(self.In)
end

function M:InitUI()
  self.Text_Name:SetText(GText(self.Name))
  self.Icon_Head:SetBrushFromTexture(LoadObject(self.IconPath))
  self.Text_Damage:SetText(self.Damage)
  self.Text_Injured:SetText(self.Damaged)
  self.Text_Heal:SetText(self.Heal)
  local DamageCanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bar_Damage)
  if DamageCanvasSlot then
    local PreMargin = DamageCanvasSlot:GetOffsets()
    if 0 == self.TotalDamage then
      PreMargin.Right = self.BarLen
    else
      PreMargin.Right = (1 - self.Damage / self.TotalDamage) * self.BarLen
    end
    DamageCanvasSlot:SetOffsets(PreMargin)
  end
  local DamagedCanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bar_Injured)
  if DamagedCanvasSlot then
    local PreMargin = DamagedCanvasSlot:GetOffsets()
    if 0 == self.TotalDamaged then
      PreMargin.Right = self.BarLen
    else
      PreMargin.Right = (1 - self.Damaged / self.TotalDamaged) * self.BarLen
    end
    DamagedCanvasSlot:SetOffsets(PreMargin)
  end
  local HealCanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bar_Heal)
  if HealCanvasSlot then
    local PreMargin = HealCanvasSlot:GetOffsets()
    if 0 == self.TotalHeal then
      PreMargin.Right = self.BarLen
    else
      PreMargin.Right = (1 - self.Heal / self.TotalHeal) * self.BarLen
    end
    HealCanvasSlot:SetOffsets(PreMargin)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
end

return M
