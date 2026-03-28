local M = Class("BluePrints.Item.ExploreGroup.ExploreStaticCreator_C")

function M:FireCube(YanQueCreator, CubeCreator)
  if 0 == YanQueCreator.ChildEids:Length() or 0 == CubeCreator.ChildEids:Length() then
    return
  end
  local YanQue = Battle(self):GetEntity(YanQueCreator.ChildEids[1])
  local Cube = Battle(self):GetEntity(CubeCreator.ChildEids[1])
  if not (YanQue and Cube) or not YanQue.GetFirePos then
    return
  end
  local Position = YanQue:GetFirePos()
  if YanQue:CheckCanFireCube() then
    Cube:FireCube(Position, YanQue.Eid)
  end
end

function M:ReceiveOnExploreLimitStarted(Title, Des, TotalTargetNum)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if 0 ~= GameState.ActiveLimitTimeExploreGroup then
    print(_G.LogTag, "LXZ TryActive LimitTimeExploreGroup", self.ExploreGroupId, "Failed,", GameState.ActiveLimitTimeExploreGroup, "Has Actived")
    return
  end
  GameState.ActiveLimitTimeExploreGroup = self.ExploreGroupId
  self:UpdateExploreData("bGroupInLimit", true)
  UIManager(self):LoadUINew("ExploreToastTips", "UI_Explore_Yanque_Start")
  if self.YanQue and self.YanQue.ChildEids:Length() > 0 then
    self.ProgressUI = UIManager(self):LoadUINew("YanQueProgress", self.YanQue.ChildEids[1])
  end
  self.IsHideWorldTask = false
  if "" ~= Title or "" ~= Des then
    self.IsHideWorldTask = true
    local UIObjs = MissionIndicatorManager:GetIndicatorUIObjBySTLType("Dynamic")
    if not IsEmptyTable(UIObjs) then
      for _, UI in pairs(UIObjs) do
        if UI then
          UI:Hide("ExploreLimit")
        end
      end
    end
    if not self:ShowExploreTaskPanel(Title, Des, TotalTargetNum) then
      self:AddTimer(0.1, self.ShowExploreTaskPanel, true, 0, "ShowExploreTaskPanelBindToTimer", false, Title, Des, TotalTargetNum)
    end
  end
  EventManager:AddEvent(EventID.CharDie, self, self.OnCharDie)
  self.bIsFar = false
  self.Overridden.ReceiveOnExploreLimitStarted(self, Title, Des, TotalTargetNum)
end

function M:ReceiveOnExploreGroupResetUI(bShowToast)
  M.Super.ReceiveOnExploreGroupResetUI(self, bShowToast)
  if self.ProgressUI and self.ProgressUI.OnReset then
    self.ProgressUI:OnReset()
  end
  self.bIsFar = false
end

function M:ShowWarningToast()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState then
    GameState:ShowDungeonToast_Lua(GText("UI_Explore_Yanque_LimitDiatance"), 3, EToastType.Warning)
  end
end

return M
