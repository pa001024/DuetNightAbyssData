require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Slots = {
    self.Num_01,
    self.Num_02,
    self.Num_03,
    self.Num_04,
    self.Num_05,
    self.Num_06
  }
end

function M:UpdateGrid(Str, bMasked)
  local Len = string.len(Str or "")
  for i, SlotWidget in ipairs(self.Slots) do
    if SlotWidget and SlotWidget.SetState then
      if i <= Len then
        if bMasked then
          SlotWidget:SetState("Masked")
        else
          local Char = string.sub(Str, i, i)
          SlotWidget:SetState("Visible", Char)
        end
      else
        SlotWidget:SetState("Empty")
      end
    end
  end
end

return M
