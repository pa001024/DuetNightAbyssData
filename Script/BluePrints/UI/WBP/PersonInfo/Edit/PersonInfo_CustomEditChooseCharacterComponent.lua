require("UnLua")
local Component = {}

function Component:IsCharacterContentEquipped(Content)
  return nil ~= Content and Content.IsChosen == true
end

function Component:CanShowCharacterMinus(Content)
  return nil ~= Content and Content.IsChosen == true
end

function Component:OnCharacterContentClicked(Content)
  if not self:_IsValidChooseContent(Content) then
    return
  end
  self:SetSelectedContent(Content)
  self.TileView_Select_Role:BP_SetSelectedItem(Content)
  self.TileView_Select_Role:BP_NavigateToItem(Content)
  self:_OpenCharacterTips(Content)
end

return Component
