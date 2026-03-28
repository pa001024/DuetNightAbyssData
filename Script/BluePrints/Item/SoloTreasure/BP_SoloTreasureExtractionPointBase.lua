local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.Triggers.BP_AOITriggerBox_C"
})

function M:Initialize(Initializer)
end

function M:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
end

function M:BeginOverlapExecLogic()
  DebugPrint("BeginOverlapExecLogic")
  if self.LeaveEvacuationPointTips then
    self.LeaveEvacuationPointTips:CloseUI()
    self.LeaveEvacuationPointTips = nil
  end
  self.EvacuationCountDownTips = UIManager(self):LoadUINew("SoloTreasureExtractionCountDownTips")
  if self.EvacuationCountDownTips and self.EvacuationCountDownTips.Num_Normal then
    self.EvacuationCountDownTips:PlayAnimation(self.EvacuationCountDownTips.Num_Normal)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/battle_countdown", nil, nil)
  self.EvacuationTime = DataMgr.SoloTreasure.EvacuationTime or 10
  self.PerTime = self.EvacuationTime
  self:AddTimer(0.01, function()
    if not self.EvacuationTime or not self.EvacuationCountDownTips then
      self:RemoveTimer("EvacuationTime")
      return
    end
    self.EvacuationTime = math.max(0, self.EvacuationTime - 0.01)
    if self.EvacuationCountDownTips.SetCountDownTime then
      local CountDownTime = math.ceil(self.EvacuationTime)
      if CountDownTime ~= self.PerTime then
        self.PerTime = CountDownTime
        self.EvacuationCountDownTips:SetCountDownTime(CountDownTime, CountDownTime <= 5)
      end
    end
    if self.EvacuationTime <= 0 then
      self:RemoveTimer("EvacuationTime")
      self.EvacuationCountDownTips:CloseUI()
      self.EvacuationCountDownTips = nil
      self.IsReadySettle = true
      local BagUI = UIManager(self):GetUIObj("SoloTreasureBag")
      if BagUI and BagUI.CloseSelf then
        BagUI:CloseSelf()
      end
      local GameMode = UE4.UGameplayStatics.GetGameMode(self)
      if GameMode then
        GameMode:TriggerDungeonComponentFun("FinishSolotreasure", true, "EvacuationSuccessful")
      end
      return
    end
  end, true, 0.1, "EvacuationTime", true)
end

function M:EndOverlapExecLogic()
  DebugPrint("EndOverlapExecLogic")
  self:RemoveTimer("EvacuationTime")
  if self.EvacuationCountDownTips then
    self.EvacuationCountDownTips:CloseUI()
    self.EvacuationCountDownTips = nil
  end
  if self.IsReadySettle then
    return
  end
  if self.EndOverlapUITipCD then
    return
  end
  self.EndOverlapUITipCD = true
  UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_TM_24"))
  self:AddTimer(0.1, function()
    self.EndOverlapUITipCD = false
  end, false, 5)
end

return M
