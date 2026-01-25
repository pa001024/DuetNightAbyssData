require("UnLua")
local M = Class({
  "BluePrints.Common.TimerMgr"
})

function M:InitSoloRaidComponent()
  self.GameMode = self:GetOwner()
  self.HistoryMaxScore = 0
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.RaidSeasons and Avatar.CurrentRaidSeasonId and Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId] then
    self.HistoryMaxScore = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]:GetMaxRaidScore()
  end
  DebugPrint("SoloRaidComponent:Init!", self.GameMode.DungeonId)
end

function M:InitSoloRaidBaseInfo()
end

function M:CustomFinishInfo(AvatarStr, IsWin)
  local Res = {
    HpRate = self.ResHpRate or 1,
    RaidTimeRate = self.ResModifiedTime or 0,
    RawTimeRemain = self.ResTimeRemain or 0,
    TotalDamage = Battle(self).TotalDamage
  }
  DebugPrint("SoloRaidComponent:CustomFinishInfo HpRate", Res.HpRate, "RaidTimeRate", Res.RaidTimeRate, "RawTimeRemain", Res.RawTimeRemain, "TotalDamage", Res.TotalDamage)
  return Res
end

function M:UpdateRaidResult(HpRate, TimeRemain, ModifiedTime)
  self.ResHpRate = HpRate
  self.ResTimeRemain = TimeRemain
  self.ResModifiedTime = ModifiedTime
  DebugPrint("SoloRaidComponent:UpdateRaidResult", HpRate, TimeRemain, ModifiedTime)
end

function M:GetTimeRemain()
  return self.ResTimeRemain or 0
end

function M:GetHistoryMaxScore()
  return self.HistoryMaxScore or 0
end

function M:UpdateCurScore(Rate)
  local CurScore = math.floor(self:GetMaxScore() * Rate)
  self.GameMode.EMGameState:SetRaidScore(CurScore)
end

function M:GetMaxScore()
  if self.MaxScore ~= nil then
    return self.MaxScore
  end
  local DungeonId = self.GameMode.DungeonId
  self.MaxScore = DataMgr.RaidDungeon[DungeonId].BaseRaidPoint
  return self.MaxScore
end

return M
