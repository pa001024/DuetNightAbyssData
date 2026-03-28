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
  else
    self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
  end
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

function WBP_SoloTreasure_HudTips_C:InitText(RemainTime)
  if self.TipType == "GameStart" then
    self.Text_Task02:SetText(GText("UI_Extraction_MissionDescription"))
    self.Text_Task:SetText(self:GetTimeStr_Cpp(RemainTime))
  elseif self.TipType == "TimeWarning" then
    self.Text_Task02:SetText(GText("UI_Extraction_TimeoutWarning"))
    self.Text_Task_1:SetText(self:GetTimeStr_Cpp(RemainTime))
  else
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
end

return WBP_SoloTreasure_HudTips_C
