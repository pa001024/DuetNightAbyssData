require("UnLua")
local Base = require("BluePrints.UI.Dungeon.RightUIComp.DungeonRightUICompBase")
local M = setmetatable({}, {__index = Base})
M.Super = Base
local STAR_COUNT = 3

function M:Init(Dependencies)
  self.Super.Init(self, Dependencies)
  self.DungeonId = nil
  self.TotalTime = 0
  self.CurTime = 0
  self.CurStar = 0
  self.LevelGoals = {}
end

function M:OnActivate(Context)
  local DungeonId = Context and Context.DungeonId
  local VerifyInfo = DungeonId and DataMgr.WeaponVerify and DataMgr.WeaponVerify[DungeonId]
  local LevelInfo = DungeonId and DataMgr.WeaponVerifyEventLevel and DataMgr.WeaponVerifyEventLevel[DungeonId]
  if not VerifyInfo or not LevelInfo then
    DebugPrint("DungeonRightUIComp_WeaponVerify: 配置不存在", DungeonId)
    return false
  end
  local LevelGoals = {}
  for i = 1, STAR_COUNT do
    local GoalTime = tonumber(LevelInfo.LevelGoalRequiredTime and LevelInfo.LevelGoalRequiredTime[i])
    if not GoalTime then
      DebugPrint("DungeonRightUIComp_WeaponVerify: 星级目标配置无效", DungeonId, i)
      return false
    end
    LevelGoals[i] = GoalTime
  end
  self.DungeonId = DungeonId
  self.TotalTime = tonumber(VerifyInfo.TotalTime) or 0
  self.CurTime = self.TotalTime
  self.CurStar = 0
  self.LevelGoals = LevelGoals
  local View = self.View
  View:ApplyLayout(View.Layout.MetricWithStars)
  View:SetMetricTitle(GText("UI_TEMPLE_LIMIT_TIME"))
  View:SetMetricValue(View:FormatTime(self.CurTime))
  self:BindEvent(EventID.OnUpdateWeaponVerifyTime, self.OnTimeChanged)
  self:InitTargetInfo()
  self:InitStarState()
  return true
end

function M:InitTargetInfo()
  local View = self.View
  for i = 1, STAR_COUNT do
    local GoalTime = self.LevelGoals[i]
    if GoalTime < 0 then
      View:SetGoalText(i, GText("WeaponVerify_Target_FinishLevel"))
    else
      View:SetGoalText(i, string.format(GText("WeaponVerify_Target_LevelLimitTime"), GoalTime))
    end
  end
end

function M:OnTimeChanged(RemainTime)
  RemainTime = tonumber(RemainTime)
  if not RemainTime then
    return
  end
  self.CurTime = RemainTime
  self.View:SetMetricValue(self.View:FormatTime(RemainTime))
  self:CheckStar()
end

function M:InitStarState()
  local View = self.View
  self.CurStar = 0
  for i = 1, STAR_COUNT do
    local GoalTime = self.LevelGoals[i]
    if GoalTime < 0 or GoalTime <= self.CurTime then
      self.CurStar = i
      View:SetStarState(i, View.StarState.Reached, false)
    else
      View:SetStarState(i, View.StarState.Normal, false)
    end
  end
end

function M:CheckStar()
  local View = self.View
  local RemainTime = self.CurTime
  if self.CurStar > 0 and RemainTime < self.LevelGoals[self.CurStar] and self.LevelGoals[self.CurStar] > 0 then
    View:SetStarState(self.CurStar, View.StarState.Lost, false)
    self.CurStar = self.CurStar - 1
    View:PlayStarSound(false)
  elseif self.CurStar < STAR_COUNT and (RemainTime >= self.LevelGoals[self.CurStar + 1] or self.LevelGoals[self.CurStar + 1] < 0) then
    self.CurStar = self.CurStar + 1
    View:SetStarState(self.CurStar, View.StarState.Reached, false)
    View:PlayStarSound(true)
  end
end

function M:GetCurrentValue()
  return self.CurTime
end

return M
