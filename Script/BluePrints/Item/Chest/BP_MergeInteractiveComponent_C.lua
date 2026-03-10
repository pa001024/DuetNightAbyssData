require("UnLua")
local BP_MergeInteractiveComponent_C = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")

function BP_MergeInteractiveComponent_C:BtnPressed(PlayerActor)
  self:StartInteractive(PlayerActor)
end

function BP_MergeInteractiveComponent_C:BtnReleased(PlayerActor, InPressTimeSeconds)
  local Owner = self:GetOwner()
  if Owner and Owner.InteractiveType == Const.PressInteractive then
    self:EndPressInteractive(PlayerActor, false)
  elseif Owner.InteractiveType == Const.ClickInteractive then
    self:EndInteractive(PlayerActor)
  end
end

function BP_MergeInteractiveComponent_C:StartInteractive(PlayerActor)
  local Result = self:GetResult(PlayerActor)
  if not Result then
    DebugPrint("StartInteractive Result is nil")
    local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
    local InteractiveUI = UIManager:GetUIObj(UIConst.InteractiveUIName)
    if not InteractiveUI then
      return
    end
    InteractiveUI:RemoveInteractiveItem(self)
    return
  end
  Result:StartInteractive(PlayerActor)
end

function BP_MergeInteractiveComponent_C:GetResult(PlayerActor)
  local Owner = self:GetOwner()
  local Result
  local ResDis = 99999
  for i, v in pairs(Owner.MergeList) do
    local TmpActor = v:GetOwner()
    local TmpDis = self:GetDistance(TmpActor, PlayerActor)
    if nil == Result or ResDis > TmpDis then
      Result = v
      ResDis = TmpDis
    end
  end
  return Result
end

function BP_MergeInteractiveComponent_C:GetDistance(Interactive, Player)
  local CompLoc = Interactive:K2_GetActorLocation()
  local PlayerLoc = Player:K2_GetActorLocation()
  return (CompLoc - PlayerLoc):Size()
end

function BP_MergeInteractiveComponent_C:EndInteractive(PlayerActor)
  local Result = self:GetResult(PlayerActor)
  if not Result then
    DebugPrint("EndInteractive Result is nil")
    local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
    local InteractiveUI = UIManager:GetUIObj(UIConst.InteractiveUIName)
    if not InteractiveUI then
      return
    end
    InteractiveUI:RemoveInteractiveItem(self)
    return
  end
  Result:EndInteractive(PlayerActor)
end

function BP_MergeInteractiveComponent_C:EndPressInteractive(PlayerActor)
  local Result = self:GetResult(PlayerActor)
  if not Result then
    DebugPrint("EndPressInteractive Result is nil")
    local UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
    local InteractiveUI = UIManager:GetUIObj(UIConst.InteractiveUIName)
    if not InteractiveUI then
      return
    end
    InteractiveUI:RemoveInteractiveItem(self)
    return
  end
  Result:EndPressInteractive(PlayerActor)
end

function BP_MergeInteractiveComponent_C:GetRarity()
  return self.TemplateInteractiveComponent:GetRarity()
end

function BP_MergeInteractiveComponent_C:GetInteractiveIcon(PlayerActor)
  return self.TemplateInteractiveComponent:GetInteractiveIcon(PlayerActor)
end

function BP_MergeInteractiveComponent_C:IsForbidden(PlayerActor)
  return self.TemplateInteractiveComponent:IsForbidden(PlayerActor)
end

function BP_MergeInteractiveComponent_C:GetCommonUIConfirmID()
  return self.TemplateInteractiveComponent.CommonUIConfirmID
end

return BP_MergeInteractiveComponent_C
