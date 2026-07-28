require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Content = Content
  if not Content then
    return
  end
  if Content.IsEmpty then
    self:ShowEmpty(true)
    return
  end
  self:ShowEmpty(false)
  local CombatChessId = Content.CombatChessId
  if not CombatChessId then
    return
  end
  local ChessData = DataMgr.CombatChessInfo[CombatChessId]
  if not ChessData then
    return
  end
  if self.Image_Icon and ChessData.MonsterIcon then
    local HeadIcon = LoadObject(ChessData.MonsterIcon)
    if HeadIcon then
      self.Image_Icon:SetBrushFromTexture(HeadIcon)
    end
  end
end

function M:ShowEmpty(bEmpty)
  if self.Image_Icon then
    self.Image_Icon:SetVisibility(bEmpty and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.Image_Mask then
    self.Image_Mask:SetVisibility(bEmpty and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if self.Image_Bg then
    self.Image_Bg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

return M
