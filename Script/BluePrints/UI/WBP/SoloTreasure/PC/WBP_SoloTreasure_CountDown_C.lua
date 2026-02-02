require("UnLua")
local WBP_SoloTreasure_CountDown_C = Class({
  "BluePrints.UI.BP_UIState_C"
})

function WBP_SoloTreasure_CountDown_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self.Main:SetRenderOpacity(0)
  local UIBattleMain = UIManager(self):GetUI("BattleMain")
  if UIBattleMain then
    UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
    UIBattleMain.Pos_TaskBar:SetVisibility(ESlateVisibility.Collapsed)
    UIBattleMain.HBox:SetVisibility(ESlateVisibility.Collapsed)
  end
  EventManager:FireEvent(EventID.OnSoloTreasureScoreAndBagUI)
  self:PlayInAnimation()
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

function WBP_SoloTreasure_CountDown_C:PlayInAnimation()
  local LoadingUI = GWorld.GameInstance:GetLoadingUI()
  if LoadingUI then
    EventManager:AddEvent(EventID.CloseLoading, self, function()
      EventManager:RemoveEvent(EventID.CloseLoading, self)
      self:InitTaskStartTip()
      self:InitCountDown()
    end)
  else
    self:InitTaskStartTip()
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
  self.Text_Evacuation:SetText("撤离剩余（待包装）")
end

function WBP_SoloTreasure_CountDown_C:InitTaskStartTip()
  local Parmas = {}
  Parmas.TipType = "GameStart"
  Parmas.Owner = self
  Parmas.GameTotalTime = self.GameTotalTime
  
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
  Parmas.WarningTime = self.WarningTime
  
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
  self.Switch_TimeType:SetActiveWidgetIndex(0)
  self.IsRed = false
  self:AddTimer(1, self.UpdateCountDownUI, true, 0, "CountDown", true)
end

function WBP_SoloTreasure_CountDown_C:UpdateCountDownUI()
  local DisplayRemainTime = CommonUtils.GetClientTimerStructRemainTime(self.TimerHandleName)
  if DisplayRemainTime <= 0 then
    DisplayRemainTime = 0
    self:RemoveTimer("CountDown")
    self:PlayAnimation(self.Out)
    self:GameOver()
  elseif DisplayRemainTime < 10 then
    if not self.IsRed then
      self.Switch_TimeType:SetActiveWidgetIndex(1)
      self.IsRed = true
    end
    self:PlayAnimation(self.Warning)
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
