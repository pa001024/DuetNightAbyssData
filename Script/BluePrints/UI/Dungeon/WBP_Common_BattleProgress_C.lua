require("UnLua")
local M = Class("BluePrints.UI.BP_EMDungeonWidget_C")
local PROGRESS_BAR_WIDTH = 426
local WARNING_TIME = 10
local StyleToVisibility = {
  EStandard = true,
  ELeftOnly = false,
  EClassic = false,
  EClassicTime = false
}

function M:InitWidgetUI()
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  assert(BattleMain, "WBP_Activity_GuideWar_Progress 加载时拿不到BattleMain！")
  BattleMain.Pos_Abyss_CountDown_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  BattleMain.Pos_Abyss_CountDown_1:AddChildToOverlay(self)
  self:InitCountDown()
  self:UpdateGameStateOnRepInfo()
end

function M:UpdateGameStateOnRepInfo()
  self:OnRepBattleProgressInfo(self.GameState.BattleProgressInfo)
  self:OnRepBattleProgressNum(self.GameState.BattleProgressNum, self.GameState.BattleProgressInfo.MaxProgressNum)
end

function M:OnRepBattleProgressInfo(BattleProgressInfo)
  local StyleName = EBattleProgressStyle:GetNameByValue(BattleProgressInfo.Style)
  local IsActive = StyleToVisibility[StyleName] or false
  self:SetWidgetActive(IsActive)
end

function M:InitUi()
  self.CurTimerHandle = ""
  self:InitListenEvent()
  local Progress = 0
  self.Bar_Progress:SetPercent(Progress)
  local IconEnemyX = PROGRESS_BAR_WIDTH * Progress - PROGRESS_BAR_WIDTH
  self.Icon_Enemy:SetRenderTranslation(FVector2D(IconEnemyX, 0))
  self.IsSuccess = false
  self.GameState = UE4.UGameplayStatics.GetGameState(self)
end

function M:InitListenEvent()
  self:AddDispatcher(EventID.OnRepBattleProgressInfo, self, self.OnRepBattleProgressInfo)
  self:AddDispatcher(EventID.OnRepBattleProgressNum, self, self.OnRepBattleProgressNum)
end

function M:InitCountDown()
  self:InitUi()
  self.CurTimerHandle = Const.BattleProgressTimerHandle
  self:StopAnimation(self.Success)
  self:PlayAnimation(self.In)
end

function M:UpdateCountDownProgress()
  local DisplayRemainTime = CommonUtils.GetClientTimerStructRemainTime(self.CurTimerHandle)
  if DisplayRemainTime < 0 then
    DisplayRemainTime = 0
  end
  local currentTimeText = self:GetTimeStr(DisplayRemainTime)
  self.Text_Time:SetText(currentTimeText)
  if DisplayRemainTime <= WARNING_TIME then
    if not self.LastWarningTimeText then
      self.LastWarningTimeText = currentTimeText
      AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
    end
    if currentTimeText ~= self.LastWarningTimeText then
      AudioManager(self):PlayUISound(self, "event:/ui/common/countdown_warning", nil, nil)
      self.LastWarningTimeText = currentTimeText
    end
    if not self:IsAnimationPlaying(self.Warning) then
      self:PlayAnimation(self.Warning, 0, 0, UE4.EUMGSequencePlayMode.Forward, 1, true)
    end
  elseif DisplayRemainTime <= 0 then
    if self.IsSuccess then
      self:StopAnimation(self.Warning)
      self:PlayAnimation(self.Success)
    else
      self:PlayAnimation(self.Fail)
    end
  elseif DisplayRemainTime > WARNING_TIME then
    self:StopAnimation(self.Warning)
    self.LastWarningTimeText = nil
  end
  local TimeProgress = (self.TotalTime - DisplayRemainTime) / self.TotalTime
  local IconTimeX = PROGRESS_BAR_WIDTH * TimeProgress
  self.Icon_Line:SetRenderTranslation(FVector2D(IconTimeX, 0))
  self.Icon_Clock:SetRenderTranslation(FVector2D(IconTimeX, 0))
end

function M:OnRepBattleProgressNum(BattleProgressNum, MaxProgressNum)
  local Progress = BattleProgressNum / MaxProgressNum
  self.Bar_Progress:SetPercent(Progress)
  local IconEnemyX = PROGRESS_BAR_WIDTH * Progress - PROGRESS_BAR_WIDTH
  self.Icon_Enemy:SetRenderTranslation(FVector2D(IconEnemyX, 0))
  if MaxProgressNum <= BattleProgressNum then
    self.IsSuccess = true
    self:PlayAnimation(self.Success)
  end
end

function M:Destruct()
  self:RemoveTimer("UpdateCountDownProgress")
  self:RemoveDispatcher(EventID.OnRepBattleProgressInfo)
  self:RemoveDispatcher(EventID.OnRepBattleProgressNum)
  self.Super.Destruct(self)
end

function M:SetWidgetActive(IsActive)
  if IsActive then
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self:SetUpdateTimerActive(IsActive)
end

function M:SetUpdateTimerActive(IsActive)
  if IsActive then
    local Info = self.GameState.ClientTimerStruct:GetTimerInfo(self.CurTimerHandle)
    self.TotalTime = Info.Time
    self:AddTimer(0.1, self.UpdateCountDownProgress, true, 0, "UpdateCountDownProgress")
    AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_challenge_progressbar_show", nil, nil)
  else
    self:RemoveTimer("UpdateCountDownProgress")
  end
end

return M
