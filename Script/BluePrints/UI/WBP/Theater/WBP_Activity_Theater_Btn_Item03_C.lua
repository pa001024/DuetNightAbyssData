require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnListItemObjectSet(Content)
  self:Init(Content)
end

function M:Init(Content)
  self.LevelId = Content.LevelId
  self.ParentWidget = Content.ParentWidget
  self.TotalTime = Content.Time
  self.CountDownTime = Content.Time
  self.Index = Content.Index
  self.Switch_item:SetActiveWidgetIndex(0)
  self:PlayAnimation(self.Normal)
end

function M:OnLevelStart()
  self:PlayAnimation(self.Load)
  self.Text_Time:SetText(tostring(self.CountDownTime))
  self.Image_Time:GetDynamicMaterial():SetScalarParameterValue("Percent", 1)
  if self.CountDownTimer then
    self:RemoveTimer(self.CountDownTimer)
  end
  self.CountDownTimer = self:AddTimer(1.0, function()
    if self.FinishPerform then
      self.CountDownTime = 0
    else
      self.CountDownTime = self.CountDownTime - 1
    end
    self.Text_Time:SetText(tostring(self.CountDownTime))
    local Percent = self.CountDownTime / self.TotalTime
    self.Image_Time:GetDynamicMaterial():SetScalarParameterValue("Percent", Percent)
    DebugPrint("ayff Theater倒计时:" .. self.CountDownTime)
    if self.CountDownTime <= 10 and self.CountDownTime > 0 then
      self:PlayAnimation(self.Load_Countdown)
      AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning_short_reverb", nil, nil)
    elseif self.CountDownTime <= 0 then
      self:RemoveTimer(self.CountDownTimer)
      self.CountDownTimer = nil
      self:OnCountDownFinished()
    else
      self.Switch_item:SetActiveWidgetIndex(1)
    end
  end, true, 0, "LevelCountDown", true)
end

function M:OnCountDownFinished()
  self.ParentWidget:ClearPerformAction()
  if self.SuccessPerform == true then
    if not self.IsFinished then
      self:PlayAnimation(self.Success)
      self:RemoveTimer("LevelSuccessDelay")
      self.ParentWidget:RemoveTimer("TheaterPerformResultDelay")
      self.ParentWidget:PlayAnimation(self.Tips_Success)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_skill_match", nil, nil)
    self.IsFinished = true
  else
    self:PlayAnimation(self.Fail)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_skill_match_fail", nil, nil)
  end
  self.YellowBg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:SetSuccess(State)
  self.SuccessPerform = State
  if self.SuccessPerform == true then
    local DelayTime = DataMgr.TheaterConstant.TheaterPerformResultDelay.ConstantValue or 0
    self:AddTimer(DelayTime, function()
      self:PlayAnimation(self.Success_Load)
      self.Text_Time:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.IsFinished = true
    end, false, 0, "LevelSuccessDelay")
  end
end

function M:Close()
  self.ParentWidget:Close()
  self.Super.Close(self)
end

function M:Destruct()
  if self.CountDownTimer then
    self:RemoveTimer(self.CountDownTimer)
    self.CountDownTimer = nil
  end
end

return M
