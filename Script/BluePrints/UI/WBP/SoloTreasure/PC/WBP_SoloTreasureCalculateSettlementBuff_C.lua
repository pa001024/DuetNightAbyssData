require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitData(Params)
  if nil == Params then
    DebugPrint("WBP_SoloTreasure_SettlementBuff_C InitData get Params is nil")
    return
  end
  self.Description = Params.Description
  self.Quality = Params.Quality
  self:InitText()
  self:InitBuffType()
end

function M:InitText()
  if self.Description then
    self.Text_Buff:SetText(GText(self.Description))
  end
end

function M:InitBuffType()
  if self.Quality then
    self:SetBuffType(self.Quality - 1)
  end
end

return M
