require("UnLua")
local Component = {}

function Component:OnPetContentClicked(Content)
  if not self:_IsValidChooseContent(Content) then
    return
  end
  self:HandleUniqueSlotContentClicked(Content)
end

function Component:OnClickPetChosenMinus(Content)
  if self.ChooseMode ~= "Pet" then
    return
  end
  self:HandleUniqueSlotChosenMinus(Content)
end

return Component
