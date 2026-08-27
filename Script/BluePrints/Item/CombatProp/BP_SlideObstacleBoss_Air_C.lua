require("UnLua")
local BP_SlideObstacleBoss_Air_C = Class({
  "BluePrints/Item/CombatProp/BP_SlideBlock_Air_C"
})

function BP_SlideObstacleBoss_Air_C:GetOverlapCheckComponents()
  return {
    self.HitBox_L,
    self.HitBox_R
  }
end

return BP_SlideObstacleBoss_Air_C
