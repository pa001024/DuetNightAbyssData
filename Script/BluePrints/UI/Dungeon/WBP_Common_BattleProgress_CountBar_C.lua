require("UnLua")
local M = Class("BluePrints.UI.BP_EMDungeonWidget_C")
local StyleToVisibility = {
  EStandard = {true, false},
  ELeftOnly = {true, true},
  EClassic = {true, true},
  EClassicTime = {false, false}
}

function M:InitListenEvent()
  self:AddDispatcher(EventID.OnRepBattleProgressInfo, self, self.OnRepBattleProgressInfo)
  self:AddDispatcher(EventID.OnRepBattleProgressNum, self, self.OnRepBattleProgressNum)
end

function M:InitWidgetUI()
  self:InitListenEvent()
  self.GameState = UE4.UGameplayStatics.GetGameState(self)
  self:OnRepBattleProgressInfo(self.GameState.BattleProgressInfo)
  self:OnRepBattleProgressNum(self.GameState.BattleProgressNum, self.GameState.BattleProgressInfo.MaxProgressNum)
  self:PlayAnimation(self.In)
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  BattleMain.Task:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  BattleMain.Task:AddChildToOverlay(self)
end

function M:OnRepBattleProgressInfo(BattleProgressInfo)
  local StyleName = EBattleProgressStyle:GetNameByValue(BattleProgressInfo.Style)
  local Settings = StyleToVisibility[StyleName] or {true, true}
  local IsShowSelf = Settings[1]
  local IsShowBar = Settings[2]
  self:SetBattleWidgetVisibility(IsShowSelf)
  local Text = BattleProgressInfo.DisplayText:GetRef(1) or ""
  self:InitBattleDisplayText(Text, IsShowBar)
end

function M:InitBattleDisplayText(DisplayText, IsShowBar)
  if "" == DisplayText then
    self.Text_AnnihilateTitle:SetText(GText("DUNGEON_EXTERMINATE_100"))
  else
    self.Text_AnnihilateTitle:SetText(GText(DisplayText))
  end
  if IsShowBar then
    self.Overlay_Bar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Overlay_Bar:SetVisibility(UE4.ESlateVisibility.Hidden)
  end
  self:ResetToDefaultState()
end

function M:OnRepBattleProgressNum(BattleProgressNum, MaxProgressNum)
  self.Text_AnnihilateNum:SetText(BattleProgressNum .. "/" .. MaxProgressNum)
  self.Progress_Annihilate:SetPercent(BattleProgressNum / MaxProgressNum)
  if MaxProgressNum <= BattleProgressNum then
    self:PlayAnimation(self.Complete)
    self.Group_Full:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:ResetToDefaultState()
  self.Group_Full:SetVisibility(UE4.ESlateVisibility.Hidden)
end

function M:SetBattleWidgetVisibility(IsShow)
  if IsShow then
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

return M
