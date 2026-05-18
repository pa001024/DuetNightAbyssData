require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_EMDungeonWidget_C"
})

function M:Initialize()
  self.Expanded = nil
  self.MemberDamageList = nil
  self.bNotShowExpansionTip = true
  self.SelfUid = nil
  self.ListItems = {}
  self.bShouldRefreshMyself = false
  self.Ranking = nil
end

function M:Construct()
  self.ListRanking:ClearListItems()
end

function M:SetMemberDamageList(MemberDamageList)
  self.MemberDamageList = MemberDamageList
end

function M:UpdateListRanking()
  if not self.MemberDamageList then
    return
  end
  if not self.SelfUid then
    local Avatar = GWorld:GetAvatar()
    if Avatar and 0 ~= Avatar.Uid then
      self.SelfUid = Avatar.Uid
    end
  end
  if self.MemberDamageList then
    for Index, MemberDamage in pairs(self.MemberDamageList) do
      if MemberDamage.Uid and MemberDamage.Uid == self.SelfUid then
        if Index ~= self.Ranking then
          self.bShouldRefreshMyself = true
        end
        self.Ranking = Index
        break
      end
    end
  end
  self.bNotShowExpansionTip = #self.MemberDamageList <= 4
  self:UpdateExpansionTipVisibility()
  self:UpdateListItemsByMemberDamageList(self.MemberDamageList)
  self:UpdateListRankingListItems()
  if not self.Expanded then
    self.ListRanking:SetScrollbarVisibility(UIConst.VisibilityOp.Visible)
    self.ListRanking:DisableScroll(false)
  else
    self.ListRanking:SetScrollbarVisibility(UIConst.VisibilityOp.Collapsed)
    self.ListRanking:DisableScroll(true)
  end
end

function M:UpdateListItemByMemberDamage(InListItem, InMemberDamage, InIndex)
  if not InListItem or not InMemberDamage then
    return
  end
  InListItem.Uid = InMemberDamage.Uid or 0
  InListItem.Damage = InMemberDamage.Damage or 0
  InListItem.RankingNum = InIndex or 1
  InListItem.Name = InMemberDamage.Name or 0
  InListItem.bMyself = InMemberDamage.Uid and self.SelfUid and InMemberDamage.Uid == self.SelfUid
end

function M:UpdateListItemsByMemberDamageList(InMemberDamageList)
  self.ListItems = self.ListItems or {}
  for Index, MemberDamage in ipairs(InMemberDamageList) do
    self.ListItems[Index] = self.ListItems[Index] or {}
    local Item = self.ListItems[Index]
    if 0 == #Item then
      Item = NewObject(UIUtils.GetCommonItemContentClass())
    end
    self:UpdateListItemByMemberDamage(Item, MemberDamage, Index)
    self.ListItems[Index] = Item
  end
end

function M:UpdateListItemByListItem(Item1, Item2)
  if not Item1 or not Item2 then
    return
  end
  Item1.Uid = Item2.Uid
  Item1.Damage = Item2.Damage
  Item1.RankingNum = Item2.RankingNum
  Item1.Name = Item2.Name
  Item1.bMyself = Item2.bMyself
end

function M:UpdateListRankingListItems()
  local Num = self.ListRanking:GetNumItems()
  if Num < #self.ListItems then
    for Index = Num + 1, #self.ListItems do
      local Item = NewObject(UIUtils.GetCommonItemContentClass())
      Item.Owner = self
      self:UpdateListItemByListItem(Item, self.ListItems[Index])
      self.ListRanking:AddItem(Item)
    end
  end
  Num = self.ListRanking:GetNumItems()
  local SelfSet = false
  local MyItem
  if not self.Expanded then
    for Index = Num, 5, -1 do
      local CPPIndex = Index - 1
      local ItemToRemove = self.ListRanking:GetItemAt(CPPIndex)
      if ItemToRemove then
        self.ListRanking:RemoveItem(ItemToRemove)
      end
    end
    for _, Item in pairs(self.ListItems) do
      if Item.bMyself then
        MyItem = Item
        break
      end
    end
    if #self.ListItems > 4 and MyItem.RankingNum > 4 then
      local InnerItem = self.ListRanking:GetItemAt(3)
      if InnerItem then
        self:UpdateListItemByListItem(InnerItem, MyItem)
      end
      SelfSet = true
    end
  end
  local InnerListItems = self.ListRanking:GetListItems()
  local Index = 1
  for _, InnerItem in pairs(InnerListItems) do
    if 4 == Index and SelfSet then
      break
    end
    self:UpdateListItemByListItem(InnerItem, self.ListItems[Index])
    Index = Index + 1
  end
  for _, Item in pairs(InnerListItems) do
    if Item.UI then
      Item.UI:UpdateDisplay()
    end
  end
end

function M:UpdateExpansionTipVisibility()
  if self.bNotShowExpansionTip then
    if self.BtnExpand then
      self.BtnExpand:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.TextRanking then
      self.TextRanking:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Button then
      self.Button:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  else
    if self.BtnExpand then
      self.BtnExpand:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.TextRanking then
      self.TextRanking:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Button then
      self.Button:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  end
end

return M
