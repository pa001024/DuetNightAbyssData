require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Item.WBP_Com_Item_Base_C"
})
M._components = {
  "BluePrints.UI.UI_PC.Common.Common_Item.Comp.WBP_Com_Item_TimeTag_Comp",
  "BluePrints.UI.UI_PC.Common.Common_Item.Comp.WBP_Com_Item_CustomTag_Comp",
  "BluePrints.UI.UI_PC.Common.Common_Item.Comp.WBP_Com_Item_Got2_Comp"
}

function M:InitData(Content)
  self.Super.InitData(self, Content)
  self.ModLevel = Content.Level
  self.ProductType = Content.ProductType
end

function M:InitCommonView()
  if self.bDontRemoveSubWidget then
    for _, Widget in pairs(self.Node_Widget:GetAllChildren()) do
      Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  else
    self.Node_Widget:ClearChildren()
    self.WidgetMap = {}
  end
  self.Super.InitCommonView(self)
end

function M:InitCompView()
  self.Super.InitCompView(self)
  self:SetCount(self.Count, self.NeedCount, self.MaxCount, self.NotCountFormat, self.bShowNotHaveStyle)
  self:SetBonus(self.BonusType, self.ExtraBonusText)
  if self.ProductType == CommonConst.ArmoryType.Mod then
    if self.ModLevel and self.ModLevel > 0 then
      self:SetItemStartLevel(self.ModLevel)
    end
  else
    self:SetName(self.ItemName)
    self:SetLevel(self.Level)
    self:SetItemStartLevel(self.StartLevelNum)
  end
  self:SetIsCanGet(self.bCanGet, self.CanGetStyle)
  self:SetOutline(self.bOutline)
  self:SetSelectNum(self.SelectNeedCount, self.SelectTotalCount)
  if self.ItemType == CommonConst.DataType.Weapon then
    self:SetWeaponPhantomIcon(self.Uuid)
  end
  self:SetItemSold(self.bSold)
  self:SetCustomTag(self.Content.bAllowCustom)
  self:SetLock(self.LockType)
  self:SetShadow(self.bShadow)
  self:SetIsGot(self.bHasGot)
  self:SetIsGot2(self.Content.bHasGot2)
  self:SetRareTag(self.bRare)
  self:SetTimeLimitData(self.TimeLimitData)
  self:SetTimeTag(self.Content.TimeTagList)
  self:SetRedDot(self.RedDotType)
end

AssembleComponents(M)
return M
