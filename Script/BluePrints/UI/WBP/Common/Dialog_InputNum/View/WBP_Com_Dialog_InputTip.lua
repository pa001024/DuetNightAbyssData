require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local CONST = {STATE_EMPTY = 0, STATE_SHOW = 1}

function M:Construct()
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(CONST.STATE_EMPTY)
  end
  self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:ShowMessage(Msg, IsError)
  if self.Text_Tip then
    self.Text_Tip:SetText(GText(Msg))
  end
  if IsError then
    if self.BG_Tip and self.BG_Color_Red then
      self.BG_Tip:SetColorAndOpacity(self.BG_Color_Red)
    end
    if self.Text_Tip and self.Text_Color_Red then
      self.Text_Tip:SetColorAndOpacity(self.Text_Color_Red)
    end
  else
    if self.BG_Tip and self.BG_Color_Yellow then
      self.BG_Tip:SetColorAndOpacity(self.BG_Color_Yellow)
    end
    if self.Text_Tip and self.Text_Color_Yellow then
      self.Text_Tip:SetColorAndOpacity(self.Text_Color_Yellow)
    end
  end
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(CONST.STATE_SHOW)
  end
  if self.Tips_In then
    self:StopAllAnimations()
    self:PlayAnimation(self.Tips_In)
  end
end

function M:HideMessage()
  if self.Tips_Out then
    self:StopAllAnimations()
    self:PlayAnimation(self.Tips_Out)
  elseif self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(CONST.STATE_EMPTY)
  end
  if not self.Tips_Out and self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(CONST.STATE_EMPTY)
  end
  self.HideTimerHandle = nil
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Tips_Out and self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(CONST.STATE_EMPTY)
  end
end

function M:Destruct()
end

return M
