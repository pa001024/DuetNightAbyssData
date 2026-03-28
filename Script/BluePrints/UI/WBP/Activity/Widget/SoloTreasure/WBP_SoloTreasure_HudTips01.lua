require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.Common.TimerMgr"
})

function M:Initialize(Initializer)
  DebugPrint("yly test WBP_SoloTreasure_HudTips01 Initialize")
end

function M:Construct()
  DebugPrint("yly test WBP_SoloTreasure_HudTips01 Construct")
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  DebugPrint("yly test WBP_SoloTreasure_HudTips01 InitUIInfo")
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self.showTime = DataMgr.GlobalConstant.SoloTreasureHudTips01ShowTime.ConstantValue
  self.Text_Task:SetText(GText("UI_Extraction_TM_33"))
  self.Text_Task02:SetText(GText("UI_Extraction_TM_34"))
end

function M:OnLoaded(...)
  DebugPrint("yly test WBP_SoloTreasure_HudTips01 OnLoaded")
  local LogicServerInfo = (...)
  self.gamePlayId = table.unpack(LogicServerInfo)
  DebugPrint("yly WBP_SoloTreasure_HudTips01:OnLoaded self.gameplayId =", self.gamePlayId)
  self:InitUIContent()
  self:UnbindAllFromAnimationFinished(self.In)
  self:BindToAnimationFinished(self.In, {
    self,
    function()
      self:StartCountDown()
    end
  })
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_toast_misson_start", nil, nil)
end

function M:Destruct()
  DebugPrint("yly test WBP_SoloTreasure_HudTips01 Destruct")
  if self:IsExistTimer("STHudTips01CountDown") then
    self:RemoveTimer("STHudTips01CountDown")
  end
end

function M:InitUIContent()
  self.Text_Num_1:SetText(DataMgr.SoloTreasureGamePlay[self.gamePlayId].TaskGains)
end

function M:StartCountDown()
  self.timer = self:AddTimer(self.showTime, function()
    self:CloseSelf()
  end, false, 0, "STHudTips01CountDown", false)
end

function M:CloseSelf()
  DebugPrint("yly test WBP_SoloTreasure_HudTips01 CloseSelf")
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:PlayAnimation(self.Out)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    GameMode:TriggerDungeonComponentFun("OnSetHudTipsbOnDisplay", false)
  end
end

function M:OnOutAnimationFinished()
  local BattleInfoItem = UIManager(self):_CreateWidgetNew("SoloTreasureGuardTaskHud")
  local TaskInfo = {
    GamePlayId = self.gamePlayId
  }
  BattleInfoItem:InitDungeonWidget(TaskInfo)
  self:Close()
end

return M
