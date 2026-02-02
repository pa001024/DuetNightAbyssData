require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitContent(Parms)
  local ItemConditions = Parms.ItemConditions
  if ItemConditions then
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    local total = #ItemConditions
    local idx = 0
    for _, Condition in ipairs(ItemConditions) do
      idx = idx + 1
      local Item = NewObject(UIUtils.GetCommonItemContentClass())
      local Name = DataMgr.Condition[Condition] and DataMgr.Condition[Condition].ConditionText or ""
      local IsValid = Avatar:CheckCondition({Condition})
      Item.Name = GText(Name)
      Item.Num1 = IsValid and 1 or 0
      Item.Num2 = 1
      Item.IsValid = IsValid
      Item.Index = idx
      Item.Total = total
      self.List_Condition:AddItem(Item)
    end
    return
  end
  local FriendId = Parms.FriendId
  local Items = {}
  do
    local Item = NewObject(UIUtils.GetCommonItemContentClass())
    local Level = GWorld:GetAvatar().Level
    local NeedLevel = GiftModel:GetGiftLevel()
    Item.Name = "UI_SendGift_Condition1"
    Item.Num1 = Level
    Item.Num2 = NeedLevel
    if Level < NeedLevel then
      Item.IsValid = false
    end
    table.insert(Items, Item)
  end
  if FriendId then
    local Item = NewObject(UIUtils.GetCommonItemContentClass())
    Item.Name = "UI_SendGift_Condition2"
    Item.Num1 = GiftModel:GetFriendDay(FriendId)
    Item.Num2 = GiftModel:GetGiftNeedFriendTime()
    if Item.Num1 < Item.Num2 then
      Item.IsValid = false
    end
    table.insert(Items, Item)
  end
  do
    local Item = NewObject(UIUtils.GetCommonItemContentClass())
    local LeftCount, GiftCountPerMonth = GiftModel:GetTotalGiftCount()
    Item.Name = "UI_SendGift_Condition3"
    Item.Num1 = LeftCount
    Item.Num2 = GiftCountPerMonth
    if LeftCount <= 0 then
      Item.IsValid = false
    end
    table.insert(Items, Item)
  end
  local total = #Items
  for i, Item in ipairs(Items) do
    Item.Index = i
    Item.Total = total
    self.List_Condition:AddItem(Item)
  end
end

function M:Construct()
end

return M
