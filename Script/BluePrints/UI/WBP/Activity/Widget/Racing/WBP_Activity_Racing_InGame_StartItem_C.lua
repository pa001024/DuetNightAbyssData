require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
end

function M:OnListItemObjectSet(Content)
  self.Content = Content or {}
  self:RefreshBaseInfo()
  self:RefreshTraitList()
  if Content.IsSelected then
    self.WS_Bg:SetActiveWidgetIndex(0)
    self:PlayAnimation(self.Mine)
  else
    self.WS_Bg:SetActiveWidgetIndex(1)
    self:PlayAnimation(self.Other)
  end
end

function M:RefreshBaseInfo()
  self.PlayerId = self.Content.PlayerId
  self.Text_Index:SetText(tostring(self.Content.Index or ""))
  local PlayerInfo = DataMgr.RaceLotteryPlayer[self.PlayerId] or {}
  local PlayerName = PlayerInfo.PlayerName and GText(PlayerInfo.PlayerName) or ""
  local IconPath = PlayerInfo.PlayerIcon
  local IconDice = LoadObject(IconPath)
  self.Image_Pet:SetBrushFromTexture(IconDice)
  self.Text_Title:SetText(PlayerName)
  self.RumorList = self.Content.RumorList or {}
end

function M:RefreshTraitList()
  self:ClearTraitList()
  local RumorInfo = DataMgr.RaceLotteryBuffMap
  if not RumorInfo then
    return
  end
  for _, RumorId in pairs(self.RumorList) do
    local BuffMapInfo = RumorInfo[RumorId]
    local BuffMap = BuffMapInfo and BuffMapInfo.BuffMap
    local Content = self:CreateBuffMapContent(BuffMap)
    if Content then
      local TargetList = Content.bPositive and self.List_Positive or self.List_Negative
      if TargetList then
        TargetList:AddItem(Content)
      end
    end
  end
end

function M:CreateBuffMapContent(BuffMap)
  local Symbol, Count = self:GetBuffMapInfo(BuffMap)
  if not Symbol or Count <= 0 then
    return nil
  end
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.BuffMap = BuffMap
  Content.BuffSymbol = Symbol
  Content.BuffCount = Count
  Content.bPositive = "+" == Symbol
  Content.IsSelected = self.Content.IsSelected
  return Content
end

function M:GetBuffMapInfo(BuffMap)
  if type(BuffMap) ~= "string" then
    return nil, 0
  end
  local Symbol = string.sub(BuffMap, 1, 1)
  if "+" ~= Symbol and "-" ~= Symbol then
    return nil, 0
  end
  return Symbol, #BuffMap
end

function M:ClearTraitList()
  if self.List_Positive then
    self.List_Positive:ClearListItems()
  end
  if self.List_Negative then
    self.List_Negative:ClearListItems()
  end
end

return M
