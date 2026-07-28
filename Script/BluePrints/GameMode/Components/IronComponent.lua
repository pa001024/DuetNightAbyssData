require("UnLua")
require("Const")
local IronComponent = {}

function IronComponent:IsIronDungeon()
  if self.IsDungeonTypeIron == nil then
    local DungeonInfo = DataMgr.IronSurvivalDungeon[self.DungeonId]
    self.IsDungeonTypeIron = nil ~= DungeonInfo
  end
  return self.IsDungeonTypeIron
end

function IronComponent:TryIronDungeonCustomFinish(IsWin, AvatarEids, PlayerEndReason)
  if not self:IsIronDungeon() then
    return false
  end
  if nil == AvatarEids then
    return false
  end
  local HasTeamLeader = self:HasTeamLeaderByAvatarEids(AvatarEids)
  if HasTeamLeader then
    if "Vote" == PlayerEndReason then
      if self:CheckServerDungeonEnable() then
        self:NotifyServerGameEnd(true, "Vote")
      else
        self:TriggerDungeonWin()
      end
    elseif self:CheckServerDungeonEnable() then
      self:NotifyServerGameEnd(false, "TeamLeaderLeave")
    else
      self:TriggerDungeonFailed()
    end
    return true
  else
    return false
  end
end

function IronComponent:HasTeamLeaderByAvatarEids(AvatarEids)
  if type(AvatarEids) == "table" then
    for _, AvatarEid in pairs(AvatarEids) do
      if self:IsTeamLeaderByAvatarEid(AvatarEid) then
        return true
      end
    end
  else
    return self:IsTeamLeaderByAvatarEid(AvatarEids)
  end
end

function IronComponent:IsTeamLeaderByAvatarEid(AvatarEid)
  local IsTeamLeader = false
  if self.TicketLeaderAvatarEid ~= nil then
    IsTeamLeader = self.TicketLeaderAvatarEid == AvatarEid
  else
    local AvatarInfo = self.AvatarInfos and self.AvatarInfos[AvatarEid]
    if AvatarInfo then
      IsTeamLeader = AvatarInfo.PlayerInfo and nil ~= AvatarInfo.PlayerInfo.TicketLeaderEid
    end
  end
  DebugPrint("IsTeamLeaderByAvatarEid", IsTeamLeader, AvatarEid)
  return IsTeamLeader
end

function IronComponent:OnNotifyGameModeDungeonEvent_SetTicketLeaderEid(AvatarEidStr)
  self.TicketLeaderAvatarEid = AvatarEidStr
  DebugPrint("BP_EMGameMode_C:OnNotifyGameModeDungeonEvent_SetTicketLeaderEid   AvatarEidStr", AvatarEidStr)
end

function IronComponent:OnNotifyGameModeDungeonEvent_SetIronTicketId(IronTicketId)
  self.IronTicketId = IronTicketId
  DebugPrint("BP_EMGameMode_C:OnNotifyGameModeDungeonEvent_IronTicketId   IronTicketId", IronTicketId)
end

function IronComponent:CheckIronDungeonIsMaxLevel()
  if not self:IsIronDungeon() then
    return false
  end
  local IronTicketId = self:GetIronTicketId()
  if not IronTicketId then
    return false
  end
  local MaxLevel = self:GetMaxLevelByTicketId(IronTicketId)
  if not MaxLevel then
    return false
  end
  self.EMGameState:SetIronDungeonMaxLevel(MaxLevel)
  if not DataMgr.Dungeon[self.DungeonId] then
    return false
  end
  local FixLevel = DataMgr.Dungeon[self.DungeonId].DungeonFixLevel or 0
  if MaxLevel < self.EMGameState.GameModeLevel + FixLevel then
    if self:CheckServerDungeonEnable() then
      self:NotifyServerGameEnd(true, "MaxLevel")
    else
      self:TriggerDungeonWin()
    end
    return true
  end
end

function IronComponent:GetIronTicketId()
  if self:CheckServerDungeonEnable() then
    return self.IronTicketId
  end
  if self.IronTicketId == nil then
    if IsStandAlone(self) then
      if self.PreInitInfo and nil ~= self.PreInitInfo.IronTicketConfId then
        self.IronTicketId = self.PreInitInfo.IronTicketConfId
      end
    elseif IsDedicatedServer(self) then
      for _, AvatarInfo in pairs(self.AvatarInfos or {}) do
        if AvatarInfo.PlayerInfo and nil ~= AvatarInfo.PlayerInfo.TicketConfId then
          self.IronTicketId = AvatarInfo.PlayerInfo.TicketConfId
          break
        end
      end
    end
  end
  return self.IronTicketId
end

function IronComponent:GetMaxLevelByTicketId(TicketId)
  local IronDungeonInfo = DataMgr.IronSurvivalDungeon[self.DungeonId]
  if not IronDungeonInfo then
    return
  end
  for Index, Id in pairs(IronDungeonInfo.IronTicketId or {}) do
    if Id == TicketId then
      local MaxLevel = IronDungeonInfo.AvaliableTicketLevel and IronDungeonInfo.AvaliableTicketLevel[Index]
      return MaxLevel
    end
  end
  return
end

return IronComponent
