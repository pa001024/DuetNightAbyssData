require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local PointStateEnum = {Positive = 0, Negative = 1}

function M:Construct()
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  local BuffMap = Content and Content.BuffMap
  local Symbol = Content and Content.BuffSymbol
  local Count = Content and Content.BuffCount
  if self.Content.IsSelected then
    self:PlayAnimation(self.White)
  else
    self:PlayAnimation(self.Black)
  end
  self:RefreshPointList(Symbol, Count)
end

function M:RefreshPointList(Symbol, Count)
  if "+" ~= Symbol and "-" ~= Symbol then
    Count = 0
  end
  local PointState = "+" == Symbol and PointStateEnum.Positive or PointStateEnum.Negative
  Count = math.min(Count or 0, 3)
  for Index = 1, 3 do
    local PointWidget = self["ItemPoint_" .. Index]
    if PointWidget then
      if Index <= Count then
        PointWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:SetPointState(PointWidget, PointState)
      else
        PointWidget:SetVisibility(ESlateVisibility.Collapsed)
      end
    end
  end
end

function M:SetPointState(PointWidget, PointState)
  if PointWidget.WS_Item then
    PointWidget.WS_Item:SetActiveWidgetIndex(PointState)
  end
end

return M
