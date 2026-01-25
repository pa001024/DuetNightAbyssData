require("UnLua")
local M = Class("BluePrints.UI.BP_EMDungeonWidget_C")
local StyleToVisibility = {
  EStandard = false,
  ELeftOnly = false,
  EClassic = true,
  EClassicTime = true
}

function M:InitWidgetUI()
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  assert(BattleMain, "加载时拿不到BattleMain！")
  BattleMain.Pos_Abyss_CountDown:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  BattleMain.Pos_Abyss_CountDown:AddChildToOverlay(self)
  self.Panel_time:SetVisibility(ESlateVisibility.Collapsed)
  self.GameState = UE4.UGameplayStatics.GetGameState(self)
  self:InitListenEvent()
  self:OnRepBattleProgressInfo(self.GameState.BattleProgressInfo)
  self.CurTimerHandle = Const.BattleProgressTimerHandle
end

function M:InitListenEvent()
  self:AddDispatcher(EventID.OnRepBattleProgressInfo, self, self.OnRepBattleProgressInfo)
end

function M:OnRepBattleProgressInfo(BattleProgressInfo)
  local StyleName = EBattleProgressStyle:GetNameByValue(BattleProgressInfo.Style)
  local IsActive = StyleToVisibility[StyleName] or false
  self:SetWidgetActive(IsActive)
  local Text = BattleProgressInfo.DisplayText:GetRef(2) or ""
  self.TaskTitle:SetText(GText(Text))
end

function M:SetWidgetActive(IsActive)
  if IsActive then
    self:ShowCountDown()
  else
    self:HideCountDown()
  end
end

function M:ShowCountDown()
  self.Panel_time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:AddTimer(0.1, self.UpdateCountDownUI, true, 0, "UpdateCountDown")
  self:PlayAnimation(self.FadeIn)
end

function M:HideCountDown()
  self.Panel_time:SetVisibility(ESlateVisibility.Collapsed)
  self:RemoveTimer("UpdateCountDown")
  self:PlayAnimation(self.Out)
end

function M:UpdateCountDownUI()
  local RawDisplayRemainTime = CommonUtils.GetClientTimerStructRemainTime(self.CurTimerHandle)
  local DisplayRemainTime = math.floor(RawDisplayRemainTime)
  if DisplayRemainTime < 0 then
    DisplayRemainTime = 0
  end
  if self.LastDisplayRemainTime == DisplayRemainTime then
    return
  end
  self.LastDisplayRemainTime = DisplayRemainTime
  self.TextBlock_LeftTime:SetText(self:GetTimeStr(DisplayRemainTime))
end

return M
