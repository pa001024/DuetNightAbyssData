require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Team.View.WBP_Team_Board_BaseCompoment",
  "BluePrints.UI.WBP.Team.View.WBP_Team_Board_GamePadCompoment",
  "BluePrints.UI.UI_PC.Common.LSFocusComp"
}

function M:Tick(MyGeometry, InDeltaTime)
  if self.OnRecruitTick then
    self:OnRecruitTick()
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  return self:OnTeamBoardPreviewKeyDown(MyGeometry, InKeyEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  return self:OnTeamBoardKeyDown(MyGeometry, InKeyEvent)
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  return self:OnTeamBoardKeyUp(MyGeometry, InKeyEvent)
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  if self.TeamHeadUI then
    self.TeamHeadUI:OnFocusLost()
  end
end

AssembleComponents(M)
return M
