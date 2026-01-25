require("UnLua")
local WBP_CoDefencePoint_C = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function WBP_CoDefencePoint_C:Construct()
  self.State = {
    {
      "Node",
      self.Panel_Node
    },
    {
      "Normal",
      self.Panel_Normal
    },
    {
      "Open",
      self.Panel_Open
    },
    {
      "CountDown",
      self.Panel_CountDown
    },
    {
      "Complete",
      self.Panel_Complete
    },
    {
      "Destroy",
      self.Panel_Destroy
    }
  }
end

function WBP_CoDefencePoint_C:InitWidget(Owner, PointIdnex)
  self.Owner = Owner
  self.CurState = ""
  self:SetPointState("Node")
  self.MyIndex = PointIdnex
  self.MyCountDown = 60
  self.IsDestroy = false
end

function WBP_CoDefencePoint_C:StateIndex2StateStr(StateIndex)
  for key, value in pairs(self.State) do
    if key == StateIndex then
      return value[1]
    end
  end
end

function WBP_CoDefencePoint_C:SetPointState(StateStr, TimerHandleName, CountDownTextmap)
  if not StateStr then
    DebugPrint("thy    StateStr 是 nil，检查蓝图传入的状态索引")
    return
  end
  if self.CurState == StateStr then
    return
  end
  if "" == TimerHandleName then
    TimerHandleName = nil
  end
  for key, value in pairs(self.State) do
    if value[1] == StateStr then
      value[2]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.CurPointState = StateStr
      if self[StateStr .. "_In"] then
        self:PlayAnimation(self[StateStr .. "_In"])
      end
    else
      value[2]:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  if "CountDown" == StateStr and TimerHandleName then
    self.CurTimerHandle = TimerHandleName
    self:AddTimer(0.1, self.UpdateCountDownUI, true, 0, "CountDown", true, CountDownTextmap)
  elseif "Destroy" == StateStr and not self.IsDestroy then
    self.IsDestroy = true
  end
  self.CurState = StateStr
end

function WBP_CoDefencePoint_C:UpdateCountDownUI(CountDownTextmap)
  local DisplayRemainTime = CommonUtils.GetClientTimerStructRemainTime(self.CurTimerHandle)
  if DisplayRemainTime < 0 then
    DisplayRemainTime = 0
  end
  self:UpdateColoBarProgress(DisplayRemainTime)
  self.Text_CountDown:SetText(string.format(GText(CountDownTextmap), self.Owner:GetTimeStr_Cpp(DisplayRemainTime)))
end

function WBP_CoDefencePoint_C:UpdateColoBarProgress(DisplayRemainTime)
  if not self.ColorBarProgress then
    self.ColorBarProgress = self.BG_Bar_Color:GetDynamicMaterial()
  end
  local Percent = DisplayRemainTime / self.MyCountDown
  self.ColorBarProgress:SetScalarParameterValue("Percent", 1 - Percent)
end

function WBP_CoDefencePoint_C:SetCountDownImagePercet(Percent)
  if self.CurPointState ~= "CountDown" then
    return
  end
  if self.CountDownDynamicMaterial == nil then
    self.CountDownDynamicMaterial = self.BG_Bar_Color:GetDynamicMaterial()
  end
  self.CountDownDynamicMaterial:SetScalarParameterValue("Percent", Percent)
end

return WBP_CoDefencePoint_C
