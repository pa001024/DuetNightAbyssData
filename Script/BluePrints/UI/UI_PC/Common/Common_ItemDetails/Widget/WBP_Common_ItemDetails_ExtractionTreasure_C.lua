require("UnLua")
local M = Class()

function M:InitItemInfo(ItemType, ItemId, UnitId)
  local ExtractionTreasureData = DataMgr.ExtractionTreasure[ItemId]
  if not ExtractionTreasureData then
    return
  end
  local ExtractionTreasureType = ExtractionTreasureData.TreasureType
  if ExtractionTreasureType then
    local ExtractionTreasureTypeInfo = DataMgr.ExtractionTreasureType[ExtractionTreasureType]
    if ExtractionTreasureTypeInfo then
      self.Text_Type:SetText(GText(ExtractionTreasureTypeInfo.Name))
    end
  end
  local TreasureValue = ExtractionTreasureData.TreasureValue
  if TreasureValue then
    self.Text_Num:SetText(tostring(TreasureValue))
  end
  self.Text_Value:SetText(GText("单格价值(未配Textmap)"))
  local Shape = ExtractionTreasureData.Shape
  if Shape then
    local TreasureSize = ExtractionTreasureData.Shape[1] * ExtractionTreasureData.Shape[2]
    if TreasureValue and TreasureSize then
      local TreasureValuePreGrid = math.ceil(TreasureValue / TreasureSize)
      self.Num_Value:SetText(tostring(TreasureValuePreGrid))
    end
    self.Bag_Position:SetShowSize(FVector2D(ExtractionTreasureData.Shape[1], ExtractionTreasureData.Shape[2]))
  end
end

return M
