require("UnLua")
local WBP_SoloTreasure_HudTips_C = Class({
  "BluePrints.UI.BP_UIState_C"
})

function WBP_SoloTreasure_HudTips_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self:RealLoaded(...)
end

function WBP_SoloTreasure_HudTips_C:OnLoaded(...)
end

function WBP_SoloTreasure_HudTips_C:RealLoaded(Parmas)
  self.Parmas = Parmas
  self:InitData()
  self:SwitchTipType()
  self:InitText()
  self:InitAnimation()
  self:TipPlayAnimation()
end

function WBP_SoloTreasure_HudTips_C:InitData()
  self.TipType = self.Parmas.TipType
  if not self.TipType then
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.GameTotalTime = self.Parmas.GameTotalTime
  self.WarningTime = self.Parmas.WarningTime
  self.Owner = self.Parmas.Owner
  self.Callback = self.Parmas.Callback
end

function WBP_SoloTreasure_HudTips_C:SwitchTipType()
  if self.TipType == "GameStart" then
    self.Switch_TimeType:SetActiveWidgetIndex(0)
  elseif self.TipType == "TimeWarning" then
    self.Switch_TimeType:SetActiveWidgetIndex(1)
  end
end

function WBP_SoloTreasure_HudTips_C:InitAnimation()
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      if self.Callback then
        self.Callback(self.Owner)
      end
    end
  })
  if self.TipType == "GameStart" then
    self:UnbindAllFromAnimationFinished(self.In_TimeNormal)
    self:BindToAnimationFinished(self.In_TimeNormal, {
      self,
      function()
        self:AddTimer(self.TimeInterval or 2, function()
          self:PlayAnimation(self.Out)
        end, false)
      end
    })
  elseif self.TipType == "TimeWarning" then
    self:UnbindAllFromAnimationFinished(self.In_TimeLow)
    self:BindToAnimationFinished(self.In_TimeLow, {
      self,
      function()
        self:AddTimer(self.TimeInterval or 2, function()
          self:PlayAnimation(self.Out)
        end, false)
      end
    })
  end
end

function WBP_SoloTreasure_HudTips_C:TipPlayAnimation()
  if self.TipType == "GameStart" then
    self:PlayAnimation(self.In_TimeNormal)
  elseif self.TipType == "TimeWarning" then
    self:PlayAnimation(self.In_TimeLow)
  end
end

function WBP_SoloTreasure_HudTips_C:InitText()
  if self.TipType == "GameStart" then
    self.Text_Task02:SetText("搜索并撤离(待包装)")
    self.Text_Task:SetText(self:GetTimeStr_Cpp(self.GameTotalTime))
  elseif self.TipType == "TimeWarning" then
    self.Text_Task02:SetText("超时将导致撤离失败(待包装)")
    self.Text_Task_1:SetText(self:GetTimeStr_Cpp(self.WarningTime))
  else
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
end

return WBP_SoloTreasure_HudTips_C
