require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.CoinId = Content.CoinId
  self.IncomeNum = Content.IncomeNum
  self.HitChoice = Content.HitChoice
  self.TotalChoice = Content.TotalChoice
  self.GuessTime = Content.GuessTime
  self:RefreshUIInfo()
end

function M:RefreshUIInfo()
  local CoinIcon = LoadObject(DataMgr.Resource[self.CoinId].Icon)
  self.Com_ItemIcon:Init({
    Id = self.CoinId,
    Icon = CoinIcon,
    ItemType = "Resource"
  })
  self.Text_HistoryNum:SetText(self.IncomeNum)
  self.Text_HistoryResult:SetText(self.HitChoice .. "/" .. self.TotalChoice)
  self.Text_HistoryDate:SetText(TimeUtils.TimeToYMDStr(self.GuessTime, nil, "/"))
end

return M
