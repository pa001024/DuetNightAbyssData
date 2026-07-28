require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Play_GetItem()
  self.OpenRewardCallbackInfo.Func(self.OpenRewardCallbackInfo.Obj)
  UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, self.Rewards, false, function()
    self.PlayOpenAnimCallbackInfo.Func(self.PlayOpenAnimCallbackInfo.Obj)
  end, self, false)
end

function M:PlayAnimationIn()
  self:PlayAnimation(self.In)
end

function M:PlayOpenAnim(Rewards, CallbackInfo, CallbackInfo2)
  self.Rewards = Rewards
  self.PlayOpenAnimCallbackInfo = CallbackInfo
  self.OpenRewardCallbackInfo = CallbackInfo2
  self:PlayAnimation(self.Open)
end

return M
