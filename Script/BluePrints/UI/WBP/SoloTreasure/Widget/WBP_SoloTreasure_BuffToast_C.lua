require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self.LotteryId = (...)
  local LotteryData = DataMgr.ExtractionLottery[self.LotteryId]
  if not LotteryData then
    DebugPrint("@zyh 没有该Id的彩票" .. self.LotteryId)
  end
  DebugPrint("彩票的品质为" .. LotteryData.Quality)
  self.ChoiceBuff:SetBuffQuality(LotteryData.Quality - 1)
  self:SetTipQuality(LotteryData.Quality - 1)
  self.Text_GetBuff:SetText(GText("UI_WhenGetLottery"))
  self:BindToAnimationFinished(self.In, {
    self,
    self.Close
  })
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_fengxiang_succeed_toast", nil, nil)
  self:AddDispatcher(EventID.OpenSoloTreasure3Choose1, self, self.Close)
end

return M
