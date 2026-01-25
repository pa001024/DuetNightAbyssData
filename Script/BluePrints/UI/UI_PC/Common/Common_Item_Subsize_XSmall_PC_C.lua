require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Item_Subsize_Small_Base_C")

function M:PlayInAnimation()
  if self.Rarity then
    if 1 == self.Rarity then
      self:PlayAnimation(self.Reward_In_White)
    elseif 2 == self.Rarity then
      self:PlayAnimation(self.Reward_In_Green)
    elseif 3 == self.Rarity then
      self:PlayAnimation(self.Reward_In_Blue)
    elseif 4 == self.Rarity then
      self:PlayAnimation(self.Reward_In_Purple)
    elseif 5 == self.Rarity then
      self:PlayAnimation(self.Reward_In_Orange)
    else
      DebugPrint("ZDX_道具框的稀有度不符合要求")
      return
    end
  end
end

function M:IsInAnimationPlaying()
  if self:IsAnimationPlaying(self.Reward_In_Orange) or self:IsAnimationPlaying(self.Reward_In_Purple) or self:IsAnimationPlaying(self.Reward_In_Blue) or self:IsAnimationPlaying(self.Reward_In_Green) or self:IsAnimationPlaying(self.Reward_In_White) then
    return true
  end
  return false
end

return M
