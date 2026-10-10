require("UnLua")
local Component = {}

function Component:OnCharacterContentClicked(Content)
  if not self:_IsValidChooseContent(Content) then
    return
  end
  self:SetSelectedContent(Content)
  self:_OpenCharacterTips(Content)
end

return Component
