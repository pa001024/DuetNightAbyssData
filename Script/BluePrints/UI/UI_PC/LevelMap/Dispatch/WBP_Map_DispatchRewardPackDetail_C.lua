require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  local Name = ItemUtils.GetItemName(Content.Id, Content.Type)
  self.Text_Name:SetText(GText(Name))
  self.Owner = Content.Owner
  local RewardContent = NewObject(UIUtils.GetCommonItemContentClass())
  RewardContent.Id = Content.Id
  RewardContent.Count = Content.Count[1]
  RewardContent.Icon = ItemUtils.GetItemIconPath(Content.Id, Content.Type)
  RewardContent.Rarity = ItemUtils.GetItemRarity(Content.Id, Content.Type)
  RewardContent.ItemType = Content.Type
  RewardContent.IsShowDetails = true
  
  function RewardContent.AfterInitCallback(Widget)
    Widget:BindEvents(self, {
      OnMenuOpenChanged = self.OnRewardMenuOpenChanged
    })
  end
  
  self.List_Item:AddItem(RewardContent)
end

function M:OnRewardMenuOpenChanged(bIsOpen)
  if self.Owner == nil then
    return
  end
  if bIsOpen then
    self.Owner:HideAllGamepadShortcut()
  else
    self.Owner:ShowGamepadShortcut(4)
    self.Owner:ShowGamepadShortcut(5)
  end
end

return M
