require("UnLua")
local BP_SlideObstacleBoss_Ground_C = Class({
  "BluePrints/Item/CombatProp/BP_SlideBlock_Ground_C"
})

function BP_SlideObstacleBoss_Ground_C:GetOverlapCheckComponents()
  return {
    self.HitBox
  }
end

return BP_SlideObstacleBoss_Ground_C
