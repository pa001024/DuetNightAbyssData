local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.NameText = self.Text_Designation
  self.CustomTag = self.LimitedPrizePool_Tag
  self.RoundText = self.Text_Type
  self.TimeText = self.Text_Time
  self.BackGround = self.Image_ItemBG
end

function M:Destruct()
end

function M:OnListItemObjectSet(Content)
  local PoolData = DataMgr.LimitedPrizePool[Content.PoolId]
  if not PoolData then
    return
  end
  local RoundId = PoolData.LimitedPrizePoolId[Content.RoundNumber]
  local RoundData = DataMgr.LimitedPrizeItem[RoundId]
  if not RoundData then
    return
  end
  local bGrandPrize = 1 == Content.PrizeIndex
  local bCustomSelected = Content.SelectedIndex ~= nil and 0 ~= Content.SelectedIndex
  local Ids = RoundData.Id[Content.PrizeIndex]
  local Id
  if bCustomSelected then
    Id = Ids[Content.SelectedIndex]
  else
    Id = Ids[1]
  end
  local TypeIndex = RoundData.Type[Content.PrizeIndex]
  local Type = ItemUtils.GetItemType(TypeIndex)
  local Name = ItemUtils.GetItemName(Id, Type)
  self:SetPrizeStyle(bGrandPrize, bCustomSelected)
  self.NameText:SetText(GText(Name))
  self.RoundText:SetText(string.format(GText("UI_LimitedPrizePool_RoundNum"), Content.RoundNumber))
  self.TimeText:SetText(TimeUtils.TimeToYMDStr(Content.Time, nil, "/") .. " " .. TimeUtils.TimeToHMSStr(Content.Time, nil, ":"))
  local _, Remainder = math.modf(Content.SerialNumber / 2)
  if 0 == Remainder then
    self.BackGround:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.BackGround:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:SetPrizeStyle(bGrandPrize, bCustomSelected)
  local ColorString
  if bGrandPrize then
    ColorString = "DDB058FF"
  else
    ColorString = "FFFFFFCC"
  end
  local Color = UE4.UUIFunctionLibrary.StringToSlateColor(ColorString)
  self.NameText:SetDefaultColorAndOpacity(Color)
  self.RoundText:SetDefaultColorAndOpacity(Color)
  self.TimeText:SetDefaultColorAndOpacity(Color)
  if bCustomSelected then
    self.CustomTag:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if bGrandPrize then
      self.CustomTag.WS_Type:SetActiveWidgetIndex(0)
      self.CustomTag.Text_BigReward:SetText(GText("UI_LimitedPrizePool_ChooseTag"))
    else
      self.CustomTag.WS_Type:SetActiveWidgetIndex(1)
      self.CustomTag.Text_SmallReward:SetText(GText("UI_LimitedPrizePool_ChooseTag"))
    end
  else
    self.CustomTag:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

return M
