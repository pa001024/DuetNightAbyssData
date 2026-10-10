require("UnLua")
local Component = {}

function Component:OnItemContentFocused(Content)
  if not self:_IsValidChooseContent(Content) then
    return
  end
  self:ShowItemDetails(Content)
end

function Component:OnItemContentClicked(Content)
  if not self:_IsValidChooseContent(Content) then
    return
  end
  self:ShowItemDetails(Content)
  if Content.IsOwned ~= true then
    return
  end
  self:HandleUniqueSlotContentClicked(Content)
end

function Component:OnClickItemChosenMinus(Content)
  if self.ChooseMode ~= "Item" then
    return
  end
  self:HandleUniqueSlotChosenMinus(Content)
end

return Component
