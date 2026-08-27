require("UnLua")
local M = {}
M.__index = M
M.Layout = {
  MetricWithStars = "MetricWithStars"
}
M.StarState = {
  Normal = "Normal",
  Reached = "Reached",
  Lost = "Lost"
}
local LayoutProfiles = {
  MetricWithStars = {
    GroupScore = ESlateVisibility.SelfHitTestInvisible,
    GroupRank = ESlateVisibility.Collapsed,
    GroupTempleGoal = ESlateVisibility.SelfHitTestInvisible,
    GoalList = ESlateVisibility.SelfHitTestInvisible
  }
}

local function SetVisibility(Widget, Visibility)
  if Widget then
    Widget:SetVisibility(Visibility)
  end
end

local function StopAnimation(Owner, Animation)
  if Owner and Animation then
    EMUIAnimationSubsystem:EMStopAnimation(Owner, Animation)
  end
end

function M:New(Owner)
  return setmetatable({Owner = Owner}, self)
end

function M:Reset()
  local Owner = self.Owner
  if not Owner then
    return
  end
  StopAnimation(Owner, Owner.Point_Add)
  StopAnimation(Owner, Owner.Point_Minus)
  StopAnimation(Owner, Owner.Time_Add)
  StopAnimation(Owner, Owner.Time_Minus)
  StopAnimation(Owner, Owner.Rank_In)
  SetVisibility(Owner.Group_Score, ESlateVisibility.Collapsed)
  SetVisibility(Owner.Group_Rank, ESlateVisibility.Collapsed)
  SetVisibility(Owner.Group_TempleGoal, ESlateVisibility.Collapsed)
  SetVisibility(Owner.VB_Item, ESlateVisibility.Collapsed)
  if Owner.Text_ScoreTitle then
    Owner.Text_ScoreTitle:SetText("")
  end
  if Owner.Text_ScoreNum then
    Owner.Text_ScoreNum:SetText("")
  end
  if Owner.Text_ScoreNumChange then
    Owner.Text_ScoreNumChange:SetText("")
  end
  for i = 1, 3 do
    local Item = Owner["TempleItem_" .. i]
    if Item then
      SetVisibility(Item, ESlateVisibility.SelfHitTestInvisible)
      Item:PlayNormalAnimation()
    end
  end
end

function M:ApplyLayout(LayoutName)
  local Owner = self.Owner
  local Profile = LayoutProfiles[LayoutName]
  if not Owner or not Profile then
    DebugPrint("DungeonRightUIView: 未注册的布局", LayoutName)
    return false
  end
  SetVisibility(Owner.Group_Score, Profile.GroupScore)
  SetVisibility(Owner.Group_Rank, Profile.GroupRank)
  SetVisibility(Owner.Group_TempleGoal, Profile.GroupTempleGoal)
  SetVisibility(Owner.VB_Item, Profile.GoalList)
  return true
end

function M:SetMetricTitle(Text)
  if self.Owner and self.Owner.Text_ScoreTitle then
    self.Owner.Text_ScoreTitle:SetText(Text)
  end
end

function M:SetMetricValue(Value)
  if self.Owner and self.Owner.Text_ScoreNum then
    self.Owner.Text_ScoreNum:SetText(Value)
  end
end

function M:SetGoalText(Index, Text)
  local Owner = self.Owner
  local Item = Owner and Owner["TempleItem_" .. Index]
  if Item then
    Item:SetTargetInfo(Text)
  end
end

function M:SetGoalVisible(Index, bVisible)
  local Owner = self.Owner
  local Item = Owner and Owner["TempleItem_" .. Index]
  SetVisibility(Item, bVisible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function M:SetGoalStarVisible(Index, bVisible)
  local Owner = self.Owner
  local Item = Owner and Owner["TempleItem_" .. Index]
  if Item and Item.SetStarVisible then
    Item:SetStarVisible(bVisible)
  end
end

function M:SetGoalListVisible(bVisible)
  local Owner = self.Owner
  SetVisibility(Owner and Owner.VB_Item, bVisible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function M:SetStarState(Index, State, IsHardMode)
  local Owner = self.Owner
  local Item = Owner and Owner["TempleItem_" .. Index]
  if not Item then
    return
  end
  if State == self.StarState.Reached then
    Item:PlayStarAnimation(true == IsHardMode)
  elseif State == self.StarState.Lost then
    Item:PlayLossAnimation(true == IsHardMode)
  else
    Item:PlayNormalAnimation()
  end
end

function M:PlayMetricDelta(Delta)
  local Owner = self.Owner
  if not (Owner and Delta) or 0 == Delta then
    return
  end
  if Delta > 0 then
    if Owner.Text_ScoreNumChange then
      Owner.Text_ScoreNumChange:SetText("+" .. Delta)
    end
    if Owner.Point_Add then
      EMUIAnimationSubsystem:EMPlayAnimation(Owner, Owner.Point_Add)
    end
    AudioManager(Owner):PlayUISound(Owner, "event:/ui/common/sp_score_add", nil, nil)
  else
    if Owner.Text_ScoreNumChange then
      Owner.Text_ScoreNumChange:SetText(Delta)
    end
    if Owner.Point_Minus then
      EMUIAnimationSubsystem:EMPlayAnimation(Owner, Owner.Point_Minus)
    end
    AudioManager(Owner):PlayUISound(Owner, "event:/ui/common/sp_score_dec", nil, nil)
  end
end

function M:PlayStarSound(IsReached)
  local Owner = self.Owner
  if Owner then
    local EventPath = IsReached and "event:/ui/common/sp_goal_enable" or "event:/ui/common/sp_goal_disable"
    AudioManager(Owner):PlayUISound(Owner, EventPath, nil, nil)
  end
end

function M:FormatTime(Time)
  if self.Owner then
    return self.Owner:GetTimeStr(Time)
  end
  return ""
end

function M:Release()
  self.Owner = nil
end

return M
