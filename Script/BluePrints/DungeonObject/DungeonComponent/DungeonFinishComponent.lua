local DungeonFinishComponent = DungeonClass.Class()
DungeonFinishComponent.__Component__ = {}

function DungeonFinishComponent:BeginPlay()
  print("ljl@ DungeonFinishComponent BeginPlay")
end

function DungeonFinishComponent:OnNotifyServerDungeonEvent_TriggerGameEnd(IsWin, GameEndReason, AvatarEidStrs)
  print("ljl@ TriggerGameEnd IsWin", IsWin, "GameEndReason", GameEndReason)
  self:TryDungeonFinish(IsWin, GameEndReason, AvatarEidStrs)
end

function DungeonFinishComponent:TryDungeonFinish(IsWin, GameEndReason, AvatarEidStrs)
  local IsAllowedFinish = true
  if self.CheckAllowedFinish then
    IsAllowedFinish = self:CheckAllowedFinish(IsWin, GameEndReason)
  end
  print("ljl@ DungeonFinishComponent TryDungeonFinish IsAllowedFinish", IsAllowedFinish, "IsWin", IsWin, "GameEndReason", GameEndReason)
  if not IsAllowedFinish then
    return IsAllowedFinish
  end
  if AvatarEidStrs then
    for _, AvatarEidStr in pairs(AvatarEidStrs) do
      local AvatarEid = CommonUtils.Str2ObjId(AvatarEidStr)
      self:DungeonFinish(IsWin, AvatarEid)
    end
  else
    self:DungeonFinish(IsWin)
  end
  self:NotifyGameModeDungeonEvent("OnServerGameEnd", IsWin, GameEndReason)
  return IsAllowedFinish
end

function DungeonFinishComponent:OnNotifyServerDungeonEvent_TriggerPlayerEnd(IsWin, AvatarEidStrs, GameEndReason)
  print("ljl@ TriggerPlayerEnd IsWin", IsWin, "AvatarEidStrs", table.concat(AvatarEidStrs, ", "), "GameEndReason", GameEndReason)
  self:TryPlayerFinish(IsWin, AvatarEidStrs, GameEndReason)
end

function DungeonFinishComponent:TryPlayerFinish(IsWin, AvatarEidStrs, GameEndReason)
  local AllowedFinishAvatarEidStrs = {}
  if self.CheckPlayerAllowedFinish then
    for _, AvatarEidStr in pairs(AvatarEidStrs) do
      if self.CheckPlayerAllowedFinish(IsWin, AvatarEidStr, GameEndReason) then
        table.insert(AllowedFinishAvatarEidStrs, AvatarEidStr)
      end
    end
  end
  print("ljl@ DungeonFinishComponent TryPlayerFinish AllowedFinishAvatarEidStrs", table.concat(AllowedFinishAvatarEidStrs, ", "), "IsWin", IsWin, "GameEndReason", GameEndReason)
  for _, AvatarEidStr in pairs(AllowedFinishAvatarEidStrs) do
    local AvatarEid = CommonUtils.Str2ObjId(AvatarEidStr)
    self:DungeonFinish(IsWin, AvatarEid)
  end
  self:NotifyGameModeDungeonEvent("OnServerPlayerEnd", IsWin, AllowedFinishAvatarEidStrs, GameEndReason)
  return AllowedFinishAvatarEidStrs
end

DungeonClass.AssembleComponents(DungeonFinishComponent)
return DungeonFinishComponent
