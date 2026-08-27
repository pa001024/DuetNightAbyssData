require("UnLua")
local Base = require("BluePrints.UI.Dungeon.RightUIComp.DungeonRightUICompBase")
local M = setmetatable({}, {__index = Base})
M.Super = Base
local EVENT_SCORE_CHANGED = EventID.OnShootTargetScoreChanged
local EVENT_ENTER = EventID.OnShootTargetEnter
local DEFAULT_RATING_RANGE = {
  30,
  60,
  100
}
local STAR_COUNT = 3

local function AddTextHint(TextHints, TextKey)
  if nil == TextKey or #TextHints >= STAR_COUNT then
    return
  end
  TextKey = tostring(TextKey):match("^%s*(.-)%s*$")
  if "" ~= TextKey and "-1" ~= TextKey then
    table.insert(TextHints, TextKey)
  end
end

local function ParseTextHints(TextHint)
  if nil == TextHint then
    return nil
  end
  local TextHints = {}
  if type(TextHint) == "table" then
    for i = 1, STAR_COUNT do
      AddTextHint(TextHints, TextHint[i])
    end
  else
    local RawTextHint = tostring(TextHint)
    if "" == RawTextHint or "-1" == RawTextHint then
      return nil
    end
    for TextKey in string.gmatch(RawTextHint, "[^,，]+") do
      AddTextHint(TextHints, TextKey)
    end
  end
  return #TextHints > 0 and TextHints or nil
end

function M:Init(Dependencies)
  self.Super.Init(self, Dependencies)
  self.Score = 0
  self.CurStar = 0
  self.bShowStars = true
  self.TextHints = nil
  self.RatingRange = {
    DEFAULT_RATING_RANGE[1],
    DEFAULT_RATING_RANGE[2],
    DEFAULT_RATING_RANGE[3]
  }
end

function M:SetRatingRange(RatingRange, TextHint2)
  self.TextHints = ParseTextHints(TextHint2)
  self.bShowStars = type(RatingRange) ~= "table" or -1 ~= tonumber(RatingRange[1])
  if not self.bShowStars then
    self.RatingRange = {}
    return
  end
  local NewRange = {}
  for i = 1, STAR_COUNT do
    local Value = RatingRange and tonumber(RatingRange[i])
    if not Value then
      NewRange = {}
      break
    end
    NewRange[i] = Value
  end
  self.bShowStars = true
  if #NewRange == STAR_COUNT then
    self.RatingRange = NewRange
  else
    self.RatingRange = {
      DEFAULT_RATING_RANGE[1],
      DEFAULT_RATING_RANGE[2],
      DEFAULT_RATING_RANGE[3]
    }
  end
end

function M:OnActivate(Context)
  local View = self.View
  View:ApplyLayout(View.Layout.MetricWithStars)
  View:SetMetricTitle(GText("UI_TEMPLE_TOTAL_SCORE") .. ": ")
  View:SetMetricValue(0)
  self:BindEvent(EVENT_SCORE_CHANGED, self.OnScoreChanged)
  self:BindEvent(EVENT_ENTER, self.OnEnter)
  self:InitTargetInfo()
  return true
end

function M:InitTargetInfo()
  local View = self.View
  local GoalCount = self.TextHints and math.min(#self.TextHints, STAR_COUNT) or self.bShowStars and STAR_COUNT or 0
  View:SetGoalListVisible(GoalCount > 0)
  for i = 1, STAR_COUNT do
    local bGoalVisible = i <= GoalCount
    View:SetGoalVisible(i, bGoalVisible)
    View:SetGoalStarVisible(i, bGoalVisible and self.bShowStars)
    if bGoalVisible then
      local GoalText = self.TextHints and GText(self.TextHints[i]) or GText("UI_TEMPLE_SUCRULE_SCORE") .. self.RatingRange[i]
      View:SetGoalText(i, GoalText)
      if self.bShowStars then
        View:SetStarState(i, View.StarState.Normal, false)
      end
    end
  end
  self:RefreshStar()
end

function M:OnScoreChanged(NewScore)
  NewScore = tonumber(NewScore)
  if not NewScore then
    return
  end
  local Dif = NewScore - self.Score
  self.View:PlayMetricDelta(Dif)
  self.Score = math.max(0, NewScore)
  self.View:SetMetricValue(self.Score)
  self:CheckStar()
end

function M:OnEnter(RatingRange, TextHint2)
  self:SetRatingRange(RatingRange, TextHint2)
  self.Score = 0
  self.CurStar = 0
  self.View:SetMetricValue(self.Score)
  self:InitTargetInfo()
end

function M:RefreshStar()
  local View = self.View
  self.CurStar = 0
  if not self.bShowStars then
    return
  end
  for i = 1, STAR_COUNT do
    if self.Score >= self.RatingRange[i] then
      self.CurStar = i
      View:SetStarState(i, View.StarState.Reached, false)
    else
      View:SetStarState(i, View.StarState.Normal, false)
    end
  end
end

function M:CheckStar()
  if not self.bShowStars then
    return
  end
  local View = self.View
  local TargetStar = 0
  for i = 1, STAR_COUNT do
    if self.Score < self.RatingRange[i] then
      break
    end
    TargetStar = i
  end
  while TargetStar < self.CurStar do
    View:SetStarState(self.CurStar, View.StarState.Lost, false)
    self.CurStar = self.CurStar - 1
    View:PlayStarSound(false)
  end
  while TargetStar > self.CurStar do
    self.CurStar = self.CurStar + 1
    View:SetStarState(self.CurStar, View.StarState.Reached, false)
    View:PlayStarSound(true)
  end
end

function M:GetCurrentValue()
  return self.Score
end

return M
