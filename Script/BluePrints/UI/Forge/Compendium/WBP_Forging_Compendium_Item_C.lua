require("UnLua")
local WBP_Forging_Compendium_Item_C = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function WBP_Forging_Compendium_Item_C:OnListItemObjectSet(Content)
  self.Content = Content
  self:Init(Content)
end

function WBP_Forging_Compendium_Item_C:Init(Content)
  self:RemoveTimer("ForgingCompendiumApplyGray")
  if not Content.IsEmpty then
    Content.IsLock = Content.IsHold ~= true
  end
  self.WBP_Archive_Item:Init(Content)
  if Content.IsEmpty then
    return
  end
  self:UpdateGrayState()
  if not Content.IsHold then
    self:AddTimer(0.05, function()
      self:UpdateGrayState()
    end, false, 0, "ForgingCompendiumApplyGray", true)
  end
end

function WBP_Forging_Compendium_Item_C:UpdateGrayState()
  if self.Content.IsHold then
    self.WBP_Archive_Item:PlayAnimation(self.WBP_Archive_Item.Gray_Normal)
  else
    self.WBP_Archive_Item:PlayAnimation(self.WBP_Archive_Item.Gray)
  end
end

function WBP_Forging_Compendium_Item_C:SetSelected(bIsSelected)
  self.WBP_Archive_Item:SetSelected(bIsSelected)
end

function WBP_Forging_Compendium_Item_C:SetNew(bIsNew)
  self.WBP_Archive_Item:SetNew(bIsNew)
end

return WBP_Forging_Compendium_Item_C
