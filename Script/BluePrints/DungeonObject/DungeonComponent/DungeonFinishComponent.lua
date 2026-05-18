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

function DungeonFinishComponent:OnNotifyServerDungeonEvent_TriggerPlayerEnd(IsWin, AvatarEids, GameEndReason)
  print("ljl@ TriggerPlayerEnd IsWin", IsWin, "AvatarEids", table.concat(AvatarEids, ", "), "GameEndReason", GameEndReason)
  self:TryPlayerFinish(IsWin, AvatarEids, GameEndReason)
end

function DungeonFinishComponent:TryPlayerFinish(IsWin, AvatarEids, GameEndReason)
  local AllowedFinishAvatarEids = {}
  if self.CheckPlayerAllowedFinish then
    for _, AvatarEid in pairs(AvatarEids) do
      if self.CheckPlayerAllowedFinish(IsWin, AvatarEid, GameEndReason) then
        table.insert(AllowedFinishAvatarEids, AvatarEid)
      end
    end
  end
  print("ljl@ DungeonFinishComponent TryPlayerFinish AllowedFinishAvatarEids", table.concat(AllowedFinishAvatarEids, ", "), "IsWin", IsWin, "GameEndReason", GameEndReason)
  for _, AvatarEid in pairs(AllowedFinishAvatarEids) do
    self:DungeonFinish(IsWin, AvatarEid)
  end
  self:NotifyGameModeDungeonEvent("OnServerPlayerEnd", IsWin, AllowedFinishAvatarEids, GameEndReason)
  return AllowedFinishAvatarEids
end

DungeonClass.AssembleComponents(DungeonFinishComponent)
return DungeonFinishComponent
