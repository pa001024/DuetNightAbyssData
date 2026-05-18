require("UnLua")
local WBP_SoloTreasure_CountDown_C = Class({
  "BluePrints.UI.BP_UIState_C"
})

function WBP_SoloTreasure_CountDown_C:Destruct()
  local UIBattleMain = UIManager(self):GetUI("BattleMain")
  if UIBattleMain then
    UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Visible)
    UIBattleMain.Pos_TaskBar:SetVisibility(ESlateVisibility.Visible)
    if UIBattleMain.Group_ChatEntry then
      UIBattleMain.Group_ChatEntry:SetVisibility(ESlateVisibility.Visible)
    end
    if UIBattleMain.Pos_OnlineAction then
      UIBattleMain.Pos_OnlineAction:SetVisibility(ESlateVisibility.Visible)
    end
    if UIBattleMain.Chat_Entry then
      UIBattleMain.Chat_Entry:SetVisibility(ESlateVisibility.Visible)
    end
  end
end

function WBP_SoloTreasure_CountDown_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self.IsFromLanguageChange = (...)
  if not self.IsFromLanguageChange then
    self.Main:SetRenderOpacity(0)
  end
  local UIBattleMain = UIManager(self):GetUI("BattleMain")
  if UIBattleMain then
    UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
    UIBattleMain.Pos_TaskBar:SetVisibility(ESlateVisibility.Collapsed)
    if UIBattleMain.Group_ChatEntry then
      UIBattleMain.Group_ChatEntry:SetVisibility(ESlateVisibility.Collapsed)
    end
    if UIBattleMain.Pos_OnlineAction then
      UIBattleMain.Pos_OnlineAction:SetVisibility(ESlateVisibility.Collapsed)
    end
    if UIBattleMain.Chat_Entry then
      UIBattleMain.Chat_Entry:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  EventManager:FireEvent(EventID.OnSoloTreasureScoreAndBagUI)
  EventManager:AddEvent(EventID.ShowCountDownTips, self, self.ShowCountDownTips)
  self:PlayInAnimation()
  self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
end

function WBP_SoloTreasure_CountDown_C:OnLoaded(...)
  self.DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
  if not self.DungeonId then
    Utils.ScreenPrint("WBP_SoloTreasure_CountDown_C : DungeonId is nil")
    return
  end
  self:InitData()
  self:InitText()
end

function WBP_SoloTreasure_CountDown_C:ShowCountDownTips()
  self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
end

function WBP_SoloTreasure_CountDown_C:PlayInAnimation()
  local LoadingUI = GWorld.GameInstance:GetLoadingUI()
  if LoadingUI then
    EventManager:AddEvent(EventID.CloseLoading, self, function()
      EventManager:RemoveEvent(EventID.CloseLoading, self)
      self:InitTaskStartTip()
      self:InitCountDown()
    end)
  else
    if not self.IsFromLanguageChange then
      self:InitTaskStartTip()
    end
    self:InitCountDown()
  end
end

function WBP_SoloTreasure_CountDown_C:InitData()
  self.SoloTreasureInfo = DataMgr.SoloTreasure[self.DungeonId]
  if not self.SoloTreasureInfo then
    Utils.ScreenPrint("WBP_SoloTreasure_CountDown_C: SoloTreasureInfo get fail")
    return
  end
  self.TimerHandleName = self.SoloTreasureInfo.TimerHandleName
  self.GameTotalTime = self.SoloTreasureInfo.GameTotalTime
  self.WarningTime = self.SoloTreasureInfo.WarningTime
end

function WBP_SoloTreasure_CountDown_C:InitText()
  self.Text_Evacuation:SetText(GText("UI_Extraction_GameCountdown"))
end

function WBP_SoloTreasure_CountDown_C:InitTaskStartTip()
  local Parmas = {}
  Parmas.TipType = "GameStart"
  Parmas.Owner = self
  
  function Parmas.Callback()
    self:PlayAnimation(self.In)
  end
  
  if not self.TimeTip then
    self.TimeTip = UIManager(self):LoadUINew("SoloTreasureTimeTip", Parmas)
  else
    self.TimeTip:RealLoaded(Parmas)
  end
end

function WBP_SoloTreasure_CountDown_C:InitWarningTimeTip()
  local Parmas = {}
  Parmas.TipType = "TimeWarning"
  Parmas.Owner = self
  
  function Parmas.Callback()
    self:PlayAnimation(self.In)
  end
  
  self:PlayAnimation(self.Out)
  if not self.TimeTip then
    self.TimeTip = UIManager(self):LoadUINew("SoloTreasureTimeTip", Parmas)
  else
    self.TimeTip:RealLoaded(Parmas)
  end
end

function WBP_SoloTreasure_CountDown_C:InitCountDown()
  if self.IsRed then
    return
  end
  self.Switch_TimeType:SetActiveWidgetIndex(0)
  self.IsRed = false
end

function WBP_SoloTreasure_CountDown_C:UpdateCountDownUI(DisplayRemainTime)
  if DisplayRemainTime <= 0 then
    DisplayRemainTime = 0
    self:PlayAnimation(self.Out)
    self:GameOver()
  elseif DisplayRemainTime < 10 then
    if not self.IsRed then
      self.Switch_TimeType:SetActiveWidgetIndex(1)
      self.IsRed = true
    end
    if not self:IsPlayingAnimation(self.Warning) then
      self:PlayAnimation(self.Warning)
    end
  elseif DisplayRemainTime < self.WarningTime and not self.IsRed then
    self.Switch_TimeType:SetActiveWidgetIndex(1)
    self:InitWarningTimeTip()
    self.IsRed = true
  end
  if self.IsRed then
    self.Text_TimeWarning:SetText(self:GetTimeStr_Cpp(DisplayRemainTime))
  else
    self.Text_TimeNormal:SetText(self:GetTimeStr_Cpp(DisplayRemainTime))
  end
end

function WBP_SoloTreasure_CountDown_C:GameOver()
  if self.TimeTip then
    self.TimeTip:Close()
  end
end

return WBP_SoloTreasure_CountDown_C
