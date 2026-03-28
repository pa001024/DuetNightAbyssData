local DungeonFinishComponent = DungeonClass.Class()
DungeonFinishComponent.__Component__ = {}

function DungeonFinishComponent:BeginPlay()
  print("ljl@ DungeonFinishComponent BeginPlay")
end

function DungeonFinishComponent:OnNotifyServerDungeonEvent_TriggerGameEnd(IsWin, GameEndReason)
  print("ljl@ TriggerGameEnd IsWin", IsWin, "GameEndReason", GameEndReason)
  self:TryDungeonFinish(IsWin, GameEndReason)
end

function DungeonFinishComponent:TryDungeonFinish(IsWin, GameEndReason)
  local IsAllowedFinish = true
  if self.CheckAllowedFinish then
    IsAllowedFinish = self:CheckAllowedFinish(IsWin, GameEndReason)
  end
  print("ljl@ DungeonFinishComponent TryDungeonFinish IsAllowedFinish", IsAllowedFinish, "IsWin", IsWin, "GameEndReason", GameEndReason)
  if not IsAllowedFinish then
    return IsAllowedFinish
  end
  self:DungeonFinish(IsWin)
  self:NotifyGameModeDungeonEvent("OnServerGameEnd", IsWin, GameEndReason)
  return IsAllowedFinish
end

DungeonClass.AssembleComponents(DungeonFinishComponent)
return DungeonFinishComponent
