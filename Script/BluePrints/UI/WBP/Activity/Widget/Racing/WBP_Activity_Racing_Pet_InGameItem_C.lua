require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local ItemStateEnum = {Normal = 0, Empty = 1}
local RankingStateEnum = {Loser = 0, Winer = 1}

function M:Construct()
  self.ListedPlayerNum = DataMgr.RaceLotteryConstant.ShortListedPlayerNum.ConstantValue
  self.ListedPlayerNum = tonumber(self.ListedPlayerNum)
  self.WS_Index:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:OnListItemObjectSet(Content)
  self.PlayerId = Content.PlayerId
  self.No = Content.No
  self.InitSpeed = Content.InitSpeed
  self.Ranking = Content.Ranking
  self.RumorList = Content.RumorList
  if not self.PlayerId then
    self:ClearBuffMapList()
    self.WS_Item:SetActiveWidgetIndex(ItemStateEnum.Empty)
    self.Image_WinSign:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  local PlayerInfo = DataMgr.RaceLotteryPlayer[self.PlayerId]
  local PlayerName = PlayerInfo.PlayerName
  local PlayerIcon = PlayerInfo.PlayerIcon
  local IconDice = LoadObject(PlayerIcon)
  if IconDice then
    self.Image_Pet:SetBrushFromTexture(IconDice)
  end
  if self.No < 10 then
    self.No = "0" .. self.No
  end
  self.Text_Num:SetText(self.No)
  self.Text_PetName:SetText(GText(PlayerName))
  local SpeedStr = string.format("%.2f", self.InitSpeed)
  self.Text_Speed:SetText(SpeedStr)
  local RankingStr = string.format(GText("UI_RaceLottery_PlayerRaceRank"), self.Ranking)
  if self.Ranking then
    if self.Ranking <= self.ListedPlayerNum then
      self.WS_Index:SetActiveWidgetIndex(RankingStateEnum.Winer)
      self.Text_IndexWin:SetText(RankingStr)
      self.Image_WinSign:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.WS_Index:SetActiveWidgetIndex(RankingStateEnum.Loser)
      self.Text_IndexNormal:SetText(RankingStr)
      self.Image_WinSign:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  if not self.RumorList then
    self:ClearBuffMapList()
    return
  end
  self:RefreshBuffMapList(self.RumorList)
end

function M:ClearBuffMapList()
  if self.List_Positive then
    self.List_Positive:ClearListItems()
  end
  if self.List_Negative then
    self.List_Negative:ClearListItems()
  end
end

function M:RefreshBuffMapList(RumorList)
  self:ClearBuffMapList()
  local RumorInfo = DataMgr.RaceLotteryBuffMap
  if not RumorInfo then
    return
  end
  for _, RumorId in pairs(RumorList) do
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
  local Count = #BuffMap
  return Symbol, Count
end

return M
