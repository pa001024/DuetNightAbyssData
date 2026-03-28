local M = Class({
  "BluePrints.UI.WBP.Activity.Widget.LimitedPrizePool.WBP_LimitedPrizePool_Gacha_Base_C"
})

function M:Construct()
  M.Super.Construct(self)
  if self.Button_Skip then
    self.Button_Skip:BindEventOnClicked(self, self.SkipToResult)
    self.Button_Skip:SetCurrentTextBlock("UI_TALK_SKIP_MOIILE")
  end
end

function M:Destruct()
  if self.Button_Skip then
    self.Button_Skip:UnBindEventOnClicked(self, self.SkipToResult)
  end
  M.Super.Destruct(self)
end

function M:Init(RewardPool, WonIndex, bIsBigPrize, AcquiredList, DrawCount, ConvertFlags, InCallback)
  M.Super.Init(self, RewardPool, WonIndex, bIsBigPrize, AcquiredList, DrawCount, ConvertFlags, InCallback)
end

return M
