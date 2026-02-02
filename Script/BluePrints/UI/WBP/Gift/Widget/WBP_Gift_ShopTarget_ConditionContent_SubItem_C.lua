require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Text_TitlePlayerData:SetText(GText(Content.Name))
  if Content.IsValid == false then
    if Content.Num1 and Content.Num2 then
      self.Text_PlayerDataNum:SetText("<W>" .. Content.Num1 .. "/" .. Content.Num2 .. "</>")
    end
  elseif Content.Num1 and Content.Num2 then
    self.Text_PlayerDataNum:SetText(Content.Num1 .. "/" .. Content.Num2)
  end
  if self.WidgetSwitcher_Bg and Content.Index ~= nil then
    local idx = Content.Index
    local total = Content.Total
    local StyleIndex
    if total and 1 == total then
      StyleIndex = 3
    elseif 1 == idx then
      StyleIndex = 2
    elseif total and idx == total then
      if 1 == total % 2 then
        StyleIndex = 3
      else
        StyleIndex = 4
      end
    elseif 1 == idx % 2 then
      StyleIndex = 0
    else
      StyleIndex = 1
    end
    self.WidgetSwitcher_Bg:SetActiveWidgetIndex(StyleIndex)
  end
end

return M
