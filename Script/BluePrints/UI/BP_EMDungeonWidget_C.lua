local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:InitDungeonWidget()
  self:InitListenEvent()
end

function M:InitListenEvent()
end

function M:AddToBattleMain(PosName, PosType)
  if not PosName or not PosType then
    return
  end
  local Res = self:TryAddToBattleMain(PosName, PosType)
  if Res then
    return
  end
  self:AddTimer(0.1, function()
    local Res1 = self:TryAddToBattleMain(PosName, PosType)
    if Res1 then
      self:RemoveTimer("AddSelfToBattleMain")
    end
  end, true, 0, "AddSelfToBattleMain")
end

function M:TryAddToBattleMain(PosName, PosType)
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if not BattleMainUI then
    return false
  end
  BattleMainUI[PosName]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  if "Overlay" == PosType then
    BattleMainUI[PosName]:AddChildToOverlay(self)
  elseif "SizeBox" == PosType then
    BattleMainUI[PosName]:AddChild(self)
  end
  return true
end

AssembleComponents(M)
return M
