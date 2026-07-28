require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  Params = Params or {}
  local LeftItem = Params.LeftItems and Params.LeftItems[1]
  local RightItem = Params.RightItems and Params.RightItems[1]
  self:_FillExchangeSide(self.Image_IconLeft, self.Text_ExchangeTitleLeft, LeftItem)
  self:_FillExchangeSide(self.Image_Icon_Right, self.Text_ExchangeTitleRight, RightItem)
  local TextExchange = self.Text_Exchange
  if TextExchange then
    local DynamicText
    if Params.ExchangeTitle then
      DynamicText = GText(Params.ExchangeTitle)
    else
      DynamicText = self:_BuildExchangeText(LeftItem)
    end
    if DynamicText and "" ~= DynamicText then
      TextExchange:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      TextExchange:SetText(DynamicText)
    else
      TextExchange:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
end

function M:_BuildExchangeText(LeftItem)
  if not LeftItem then
    return nil
  end
  local ItemType = LeftItem.ItemType or CommonConst.ItemType.Resource
  local ItemData = DataMgr[ItemType] and DataMgr[ItemType][LeftItem.ItemId]
  if not ItemData then
    return nil
  end
  local ResourceName = GText(ItemData.ResourceName or ItemData.Name or "")
  if "" == ResourceName then
    return nil
  end
  local Template = GText("UI_COMMONPOP_TEXT_100136")
  return string.gsub(Template, "&ResourceName&", ResourceName)
end

function M:_FillExchangeSide(IconImage, TextWidget, Item)
  if not Item then
    return
  end
  local ItemType = Item.ItemType or CommonConst.ItemType.Resource
  local TypeTable = DataMgr[ItemType]
  local ItemData = TypeTable and TypeTable[Item.ItemId]
  if not ItemData then
    DebugPrint("WBP_Shop_GachaExchangePart_C: 物品数据不存在 ItemType=", ItemType, " ItemId=", Item.ItemId)
    return
  end
  if IconImage and ItemData.Icon then
    local IconTex = LoadObject(ItemData.Icon)
    if IconTex then
      IconImage:SetBrushFromTexture(IconTex)
    end
  end
  if TextWidget then
    local Name = ItemData.ResourceName or ItemData.Name or ""
    TextWidget:SetText(GText(Name) .. " x" .. tostring(Item.Count or 0))
  end
end

return M
