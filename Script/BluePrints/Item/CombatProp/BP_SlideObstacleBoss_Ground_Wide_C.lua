require("UnLua")
local BP_SlideObstacleBoss_Ground_Wide_C = Class({
  "BluePrints/Item/CombatProp/BP_SlideObstacleBoss_Ground_C"
})

function BP_SlideObstacleBoss_Ground_Wide_C:GetOverlapCheckComponents()
  return {
    self.HitBox,
    self.HitBox1,
    self.HitBox2
  }
end

return BP_SlideObstacleBoss_Ground_Wide_C
