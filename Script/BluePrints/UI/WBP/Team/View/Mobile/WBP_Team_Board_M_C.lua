require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Team.View.WBP_Team_Board_BaseCompoment"
}

function M:Tick(MyGeometry, InDeltaTime)
  if self.OnRecruitTick then
    self:OnRecruitTick()
  end
end

AssembleComponents(M)
return M
