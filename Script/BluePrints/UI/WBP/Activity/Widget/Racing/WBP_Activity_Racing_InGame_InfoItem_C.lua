require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
end

function M:OnListItemObjectSet(Content)
  self.PlayerId = Content.PlayerId
  self.InsideBuffId = Content.InsideBuffId
  local InsideBuff = DataMgr.RaceLotteryInsideBuff[self.InsideBuffId]
  local PlayerName = DataMgr.RaceLotteryPlayer[self.PlayerId].PlayerName
  local SkillDes = string.format(GText(InsideBuff.InsideBuffDes), GText(PlayerName))
  self.Text_Info:SetText(SkillDes)
end

return M
