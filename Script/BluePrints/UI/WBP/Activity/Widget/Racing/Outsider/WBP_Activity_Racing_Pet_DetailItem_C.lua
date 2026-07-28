require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")

function M:Init(Index, Content, PlayerId, ParentWidget)
  self.Index = Index
  self.RumorContent = Content
  self.PlayerId = PlayerId
  self.ParentWidget = ParentWidget
  self:InitView()
  self:BindButtonEvent()
end

function M:InitView()
  self.Text_Lock:SetText(string.format(GText(RacingActivityConst.SearchRumorText), tostring(self.Index)))
  self:SetIsLocked()
  if self.RumorContent then
    self.Text_Normal:SetText(string.format(GText(RacingActivityConst.RumorResultDescText), tostring(self.Index)) .. GText(self.RumorContent.MaxStake))
    self:InitPoint()
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:BindButtonEvent()
  if self.Btn_Click.OnClicked then
    self.Btn_Click.OnClicked:Remove(self, self.OnBtnClicked)
  end
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
end

function M:OnBtnClicked()
  local Params = {
    PlayerId = self.PlayerId,
    RumorCount = self.Index,
    DisplayRumorIndex = self.Index,
    LastFocusWidget = RacingOutsiderModel.CurrentFocusWidget,
    ParentWidget = self.ParentWidget.ParentWidget,
    CloseCallback = function(DisplayRumorIndex, PlayerId, RealRumorIndex)
      if self.ParentWidget and self.ParentWidget.OnRumorPopupClosed then
        self.ParentWidget:OnRumorPopupClosed(DisplayRumorIndex, PlayerId, RealRumorIndex)
      end
    end,
    CancelCallback = function()
      if self.ParentWidget and self.ParentWidget.OnRumorPopupCancel then
        self.ParentWidget:OnRumorPopupCancel()
      end
    end
  }
  if RacingOutsiderModel:GetRumorInquireCount() > 0 then
    UIManager(self):LoadUINew("ActivityRacingRumor", Params)
  else
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(RacingActivityConst.RumorCountNotEnoughText))
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
end

function M:PlayPopupCloseAnim()
  if not self.RumorContent then
    return
  end
  self.WS_DetailItem:SetActiveWidgetIndex(0)
  self:PlayAnimation(self.Unlock)
  if self.RumorContent.BuffSymbol == "+" then
    AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_challenger_state_label_unlock_positive", nil, nil)
  elseif self.RumorContent.BuffSymbol == "-" then
    AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_challenger_state_label_unlock_negative", nil, nil)
  end
end

function M:InitPoint()
  for Index = 1, 3 do
    local ItemPointWidget = self["ItemPoint_" .. Index]
    if ItemPointWidget then
      if Index > self.RumorContent.BuffCount then
        ItemPointWidget:SetVisibility(ESlateVisibility.Collapsed)
      else
        ItemPointWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.RumorContent.BuffSymbol == "+" then
          ItemPointWidget.WS_Item:SetActiveWidgetIndex(0)
        elseif self.RumorContent.BuffSymbol == "-" then
          ItemPointWidget.WS_Item:SetActiveWidgetIndex(1)
        end
      end
    end
  end
end

function M:SetIsLocked()
  if self.RumorContent then
    self.WS_DetailItem:SetActiveWidgetIndex(0)
    self.IsLocked = false
  else
    self.WS_DetailItem:SetActiveWidgetIndex(1)
    self.IsLocked = true
  end
end

function M:Destruct()
end

return M
