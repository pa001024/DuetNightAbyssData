local WBP_RougeLike_Item_Select_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_RougeLike_Item_Select_C:OnLoaded(AwardList)
  self:UISetGamePaused(self.WidgetName or self.ConfigName, true)
  self.AwardList = AwardList
  self:ShowNextAward()
  for i = 1, 3 do
    local ItemWidgetName = string.format("RogueLike_Select_Item_Widget_%s", i)
    local ItemWidget = self[ItemWidgetName]
    assert(ItemWidget, string.format("RougeLike_Item_Select中找不到控件:【%s】", ItemWidgetName))
    ItemWidget:OnLoaded()
  end
end

function WBP_RougeLike_Item_Select_C:ShowNextAward()
  if next(self.AwardList) == nil then
    self:Close()
    return
  end
  self.ItemSelectInfo = self.AwardList[1]
  self.AwardType = self.ItemSelectInfo.AwardType
  local RandomId = self.ItemSelectInfo.RandomId
  assert(self.AwardType == "Blessing" or self.AwardType == "Treasure", string.format("RougeLike_Item_Select传入的Type:【%s】不是有效的Type", tostring(self.AwardType)))
  local InfoList = self.ItemSelectInfo.InfoList
  if self.ItemSelectInfo.RandomType == "Random_3" then
    for i = 1, 3 do
      local ItemWidgetName = string.format("RogueLike_Select_Item_Widget_%s", i)
      local ItemWidget = self[ItemWidgetName]
      assert(ItemWidget, string.format("RougeLike_Item_Select中找不到控件:【%s】", ItemWidgetName))
      local InfoId, InfoData = self:GetInfoDataFromItemInfo(self.AwardType, InfoList[i].ItemId)
      ItemWidget:SetInfo(self, InfoId, InfoData)
    end
  elseif self.ItemSelectInfo.RandomType == "Random_1" then
    for i = 1, 2 do
      local ItemWidgetName = string.format("RogueLike_Select_Item_Widget_%s", i)
      local ItemWidget = self[ItemWidgetName]
      assert(ItemWidget, string.format("RougeLike_Item_Select中找不到控件:【%s】", ItemWidgetName))
      ItemWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    local InfoId, InfoData = self:GetInfoDataFromItemInfo(self.AwardType, InfoList[1].ItemId)
    self.RogueLike_Select_Item_Widget_3:SetInfo(self, InfoId, InfoData)
  end
  table.remove(self.AwardList, 1)
end

function WBP_RougeLike_Item_Select_C:ChooseItem(ItemId, ChooseWidget)
  PrintTable({WBP_RougeLike_Item_Select_C = 1, ChooseItem = ItemId})
  if self.ItemSelectInfo.RandomType == "Random_3" then
    local Avatar = GWorld:GetAvatar()
    assert(Avatar, "Avatar不存在")
    if self.AwardType == "Blessing" then
      Avatar:GetBlessing(ItemId, function()
        self:ShowNextAward()
      end)
    elseif self.AwardType == "Treasure" then
      Avatar:GetTreasure(ItemId, function()
        self:ShowNextAward()
      end)
    end
  elseif self.ItemSelectInfo.RandomType == "Random_1" and GWorld.RougeLikeManager then
    local RougeLikeMgr = GWorld.RougeLikeManager
    if self.AwardType == "Blessing" then
      RougeLikeMgr:AddBlessings(ItemId)
      self:ShowNextAward()
    elseif self.AwardType == "Treasure" then
      RougeLikeMgr:AddTreasures(ItemId)
      self:ShowNextAward()
    end
  end
end

function WBP_RougeLike_Item_Select_C:GetInfoDataFromItemInfo(AwardType, ItemId)
  if "Blessing" == AwardType then
    local InfoData = DataMgr.RougeLikeBlessing[ItemId]
    assert(InfoData, string.format("传入的刻印编号【%s】不存在", ItemId))
    return InfoData.BlessingId, InfoData
  end
  if "Treasure" == AwardType then
    local InfoData = DataMgr.RougeLikeTreasure[ItemId]
    assert(InfoData, string.format("传入的宝物编号【%s】不存在", ItemId))
    return InfoData.TreasureId, InfoData
  end
end

function WBP_RougeLike_Item_Select_C:Close()
  self:UISetGamePaused(self.WidgetName or self.ConfigName, false)
  local Avatar = GWorld:GetAvatar()
  EventManager:FireEvent(EventID.OnSwitchRole, Avatar.CurrentChar)
  self.Super.Close(self)
end

return WBP_RougeLike_Item_Select_C
