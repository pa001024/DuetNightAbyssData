require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
end

function M:InitWidgetUI(...)
  self.TextMapTitle, self.TextMapStar3, self.TextMapStar2, self.TextMapStar1, self.TimerHandle, self.TimerStar3, self.TimeStar2, self.TimeStar1 = ...
  DebugPrint("zwkkk WBP_Common_RankStar_C InitWidgetUI", self.TextMapTitle, self.TextMapStar3, self.TextMapStar2, self.TextMapStar1, self.TimerHandle, self.TimerStar3, self.TimeStar2, self.TimeStar1)
  self:SetStarType()
  self.Text_ScoreTitle:SetText(GText(self.TextMapTitle))
  self:SetRankText()
  self.RankStates = {
    false,
    false,
    false
  }
  self:CheckStar(true)
  self:AddTimer(0.2, self.CheckStar, true, 0, "CheckStar", nil, false)
end

function M:SetStarType()
  for i = 1, 3 do
    local StarItem = self["Item_" .. i]
    if StarItem then
      StarItem.StarSlot:ClearChildren()
      local Star = self:CreateWidgetNew("ItemStarSlotWuyousheng")
      StarItem.StarSlot:AddChildToOverlay(Star)
    end
  end
end

function M:SetStarTypeNormal()
  for i = 1, 3 do
    local StarItem = self["Item_" .. i]
    if StarItem then
      StarItem.StarSlot:ClearChildren()
      local Star = self:CreateWidgetNew("ItemStarSlotNormal")
      StarItem.StarSlot:AddChildToOverlay(Star)
    end
  end
end

function M:SetRankText()
  local Aim3 = string.format(GText(self.TextMapStar3), self.TimerStar3)
  self.Item_3.Text_ScoreDesc:SetText(Aim3)
  local Aim2 = string.format(GText(self.TextMapStar2), self.TimeStar2)
  self.Item_2.Text_ScoreDesc:SetText(Aim2)
  local Aim1 = string.format(GText(self.TextMapStar1), self.TimeStar1)
  self.Item_1.Text_ScoreDesc:SetText(Aim1)
end

function M:CheckStar(IsFirst)
  local ClientRemainTime = math.ceil(CommonUtils.GetClientTimerStructRemainTime(self.TimerHandle))
  if not ClientRemainTime or ClientRemainTime < 0 then
    self.RemainTime = 0
    self:RemoveTimer("CheckStar")
    return
  end
  self.RemainTime = ClientRemainTime
  self.RemainTime = math.max(0, self.RemainTime)
  self.Text_ScoreNum:SetText(self:GetTimeStr(self.RemainTime))
  for i = 1, 3 do
    local StarItem = self["Item_" .. i]
    local StarTime = 0
    if 3 == i then
      StarTime = self.TimerStar3
    elseif 2 == i then
      StarTime = self.TimeStar2
    elseif 1 == i then
      StarTime = self.TimeStar1
    end
    if StarTime <= self.RemainTime then
      if IsFirst then
        StarItem:PlayFullAnimation()
        StarItem:ShowStarLight()
      elseif not self.RankStates[i] then
        StarItem:PlayStarAnimation(true)
      end
      self.RankStates[i] = true
    else
      if IsFirst then
        StarItem:PlayNormalAnimation()
        StarItem:ShowStarGrey()
      elseif self.RankStates[i] then
        StarItem:PlayLossAnimation(false)
      end
      self.RankStates[i] = false
    end
  end
end

function M:OnTimerDel()
  self.RemainTime = 0
  self:RemoveTimer("CheckStar")
end

function M:InitWidgetUIScore(...)
  self.TextMapTitle, self.TextMapStar3, self.TextMapStar2, self.TextMapStar1, self.ScoreStar3, self.ScoreStar2, self.ScoreStar1, self.InitScore = ...
  self:AddDispatcher(EventID.UpdateRankStarScore, self, self.UpdateRankStarScore)
  self.CurrentScore = self.InitScore or 0
  self:SetStarTypeNormal()
  self.Text_ScoreTitle:SetText(GText(self.TextMapTitle))
  self:SetRankTextScore()
  self.RankStates = {
    false,
    false,
    false
  }
  self:PlayAnimation(self.Rank_In)
  self:CheckStarScore(true)
end

function M:SetRankTextScore()
  local Aim3 = string.format(GText(self.TextMapStar3), self.ScoreStar3)
  self.Item_3.Text_ScoreDesc:SetText(Aim3)
  local Aim2 = string.format(GText(self.TextMapStar2), self.ScoreStar2)
  self.Item_2.Text_ScoreDesc:SetText(Aim2)
  local Aim1 = string.format(GText(self.TextMapStar1), self.ScoreStar1)
  self.Item_1.Text_ScoreDesc:SetText(Aim1)
end

function M:UpdateRankStarScore(NewScore)
  if NewScore > self.CurrentScore then
    self:StopAnimation(self.Point_Minus)
    if not self:IsAnimationPlaying(self.Point_Add) then
      self.Text_ScoreNumChange:SetText("+" .. tostring(NewScore - self.CurrentScore))
      self.CurPlayingScore = NewScore - self.CurrentScore
      self:PlayAnimation(self.Point_Add)
    else
      self.CurPlayingScore = self.CurPlayingScore + (NewScore - self.CurrentScore)
      self.Text_ScoreNumChange:SetText("+" .. tostring(self.CurPlayingScore))
    end
  elseif NewScore < self.CurrentScore then
    self:StopAnimation(self.Point_Add)
    if not self:IsAnimationPlaying(self.Point_Minus) then
      self.Text_ScoreNumChange:SetText("-" .. tostring(self.CurrentScore - NewScore))
      self.CurPlayingScore = self.CurrentScore - NewScore
      self:PlayAnimation(self.Point_Minus)
    else
      self.CurPlayingScore = self.CurPlayingScore + (self.CurrentScore - NewScore)
      self.Text_ScoreNumChange:SetText("-" .. tostring(self.CurPlayingScore))
    end
  end
  self.CurrentScore = NewScore
  self:CheckStarScore(false)
end

function M:CheckStarScore(IsFirst)
  self.Text_ScoreNum:SetText(tostring(self.CurrentScore))
  for i = 1, 3 do
    local StarItem = self["Item_" .. i]
    local StarScore = 0
    if 3 == i then
      StarScore = self.ScoreStar3
    elseif 2 == i then
      StarScore = self.ScoreStar2
    elseif 1 == i then
      StarScore = self.ScoreStar1
    end
    if StarScore <= self.CurrentScore then
      if IsFirst then
        StarItem:PlayFullAnimation()
        StarItem:ShowStarLight()
      elseif not self.RankStates[i] then
        StarItem:PlayStarAnimation(false)
      end
      self.RankStates[i] = true
    else
      if IsFirst then
        StarItem:PlayNormalAnimation()
        StarItem:ShowStarGrey()
      elseif self.RankStates[i] then
        StarItem:PlayLossAnimation(false)
      end
      self.RankStates[i] = false
    end
  end
end

function M:Destruct()
  self:RemoveTimer("CheckStar")
  M.Super.Destruct(self)
end

return M
