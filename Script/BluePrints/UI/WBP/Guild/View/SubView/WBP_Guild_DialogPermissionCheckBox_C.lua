require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local WsInteractive = 0
local WsReadOnlyCheck = 1
local WsDash = 2

function M:ApplyCheckSwitchSnap(checked)
  if not self.Check_Switch or not self.Check_Normal then
    return
  end
  if checked then
    self:PlayAnimation(self.Check_Switch, self.Check_Switch:GetEndTime())
  else
    self:PlayAnimation(self.Check_Normal, 0)
  end
end

function M:PlayCheckSwitchToggle(checked)
  if not self.Check_Switch or not self.Check_Normal then
    return
  end
  if checked then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
    self:PlayAnimation(self.Check_Switch)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    self:PlayAnimation(self.Check_Normal)
  end
end

function M:Construct()
  self._Checked = false
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnBtnClick)
end

function M:OnBtnClick()
  if not self._Interactive then
    return
  end
  local nextChecked = not self._Checked
  self:PlayCheckSwitchToggle(nextChecked)
  self._Checked = nextChecked
  if self._ToggleHandler then
    self._ToggleHandler()
  end
end

function M:SetCellState(interactive, showDash, checked)
  checked = true == checked
  self._Interactive = true == interactive
  if self.Btn_Click and self.Btn_Click.SetForbidden then
    self.Btn_Click:SetForbidden(not self._Interactive)
  end
  if not self.WS_Type or not self.WS_Type.SetActiveWidgetIndex then
    return
  end
  if showDash then
    self.WS_Type:SetActiveWidgetIndex(WsDash)
    return
  end
  if self._Interactive then
    self.WS_Type:SetActiveWidgetIndex(WsInteractive)
    self._Checked = checked
    self:ApplyCheckSwitchSnap(checked)
  else
    self._Checked = checked
    if checked then
      self.WS_Type:SetActiveWidgetIndex(WsReadOnlyCheck)
    else
      self.WS_Type:SetActiveWidgetIndex(WsDash)
    end
  end
end

function M:SetToggleHandler(handler)
  self._ToggleHandler = handler
end

function M:GetFocusButton()
  return self.Btn_Click
end

return M
