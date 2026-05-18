require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Tag_Reward:SetVisibility(ESlateVisibility.Collapsed)
end

function M:OnListItemObjectSet(Content)
  self.TextBonus:SetText(GText(Content.RewardText))
  self.TextDetails:SetText(GText(Content.RewardTip))
  self.TextIconNum:SetText("x" .. Content.Count)
  self:SetChoose(Content.bChoose)
  self.TextNum:SetText(Content.Rate .. "%")
  local Texture = LoadObject(Content.ResourceIcon)
  if Content.ExtraRate then
    self.Tag_Reward.TextNum:SetText("+" .. Content.ExtraRate .. "%")
    self.Tag_Reward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Tag_Reward:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.Icon:SetBrushFromTexture(Texture)
end

function M:SetChoose(bChoose)
  local Visible
  if bChoose then
    self:PlayAnimation(self.Active)
  else
    self:PlayAnimation(self.Lock)
  end
end

return M
