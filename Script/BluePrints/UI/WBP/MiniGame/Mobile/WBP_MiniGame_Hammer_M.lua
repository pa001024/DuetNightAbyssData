require("UnLua")
local M = Class("BluePrints.UI.WBP.MiniGame.WBP_MiniGame_Hammer_Base")

function M:InitPlatform()
  self.Bar.WS_Mode:SetActiveWidgetIndex(0)
  if self.Tip and self.Tip.Panel_KeyTip then
    self.Tip.Panel_KeyTip:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Bar.Panel_Key then
    self.Bar.Panel_Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self.Btn_Start.WS_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Btn_Crack.WS_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Btn_Start.Btn_Click.OnPressed:Remove(self, self.OnMobileHammerButtonPressed)
  self.Btn_Start.Btn_Click.OnPressed:Add(self, self.OnMobileHammerButtonPressed)
  self:RefreshHammerButtonEnabled()
end

function M:GetHammerStartTextMap()
  return "UI_Hammer_StartClick"
end

function M:GetHammerInputTipTextMap()
  return "UI_Hammer_InfoClickPhone"
end

function M:OnHammerButtonClicked()
  if self.bHammerGameEnded then
    return
  end
  if not self.bHammerStarted then
    self:StartHammerGame()
  end
end

function M:OnHammerGameStarted()
  M.Super.OnHammerGameStarted(self)
  self:SetHammerStartButtonTextVisible(false)
end

function M:HandleStartedHammerButton()
  if self.bHammerInputLocked then
    self:SubmitHammerInput("A")
    return
  end
  local CurrentKeys = self.CurrentComboKeys or {}
  if 0 == #CurrentKeys then
    self:SubmitHammerInput("A")
    return
  end
  if not self.bHammerInputEnabled then
    self:SubmitHammerInput(CurrentKeys[1])
    return
  end
  for _, InputKey in ipairs(CurrentKeys) do
    self:SubmitHammerInput(InputKey)
  end
end

function M:OnMobileHammerButtonPressed()
  if not self.bHammerStarted or self.bHammerGameEnded then
    return
  end
  self:HandleStartedHammerButton()
end

function M:OnHammerInputHintReady()
  self:HideHammerInputHint()
end

function M:GetHammerInputRemindAnimation()
  local Bar = self.Bar
  return Bar and Bar.Btn_Remind_M or nil
end

function M:SetHammerStartButtonTextVisible(bVisible)
  if self.Btn_Start and self.Btn_Start.Text_Button then
    self.Btn_Start.Text_Button:SetVisibility(bVisible and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
end

function M:HideHammerInputHint()
  if self.Bar and self.Bar.Panel_Key then
    self.Bar.Panel_Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self:SetHammerInputHintVisible(false)
end

function M:GetHammerHitResultAnimation(bSuccess)
  if not self.Bar then
    return
  end
  return bSuccess and self.Bar.Success_Mobile or self.Bar.Fail_Mobile
end

function M:RefreshHammerButtonEnabled()
  M.Super.RefreshHammerButtonEnabled(self)
  if self.Btn_Start and self.Btn_Start.Btn_Click then
    local bInputAvailable = self.bHammerInputEnabled and not self.bHammerInputLocked
    local bStartForbidden = self.bHammerStarted and not self.bHammerGameEnded and not bInputAvailable
    self.Btn_Start.Btn_Click:SetIsEnabled(not self.bHammerGameEnded and (not self.bHammerStarted or not self.bHammerInputLocked))
    self:SetHammerStartButtonForbidden(bStartForbidden)
  end
  self:SetHammerStartButtonTextVisible(not self.bHammerStarted)
end

function M:RefreshStartGuideAnimation()
  local bGuideEnabled = not self.bHammerGameEnded and (not self.bHammerStarted or self.bHammerInputEnabled and not self.bHammerInputLocked)
  self:SetStartGuideAnimationEnabled(bGuideEnabled)
end

function M:DestructPlatform()
  if self.Btn_Start and self.Btn_Start.Btn_Click then
    self.Btn_Start.Btn_Click.OnPressed:Remove(self, self.OnMobileHammerButtonPressed)
  end
  self:SetStartGuideAnimationEnabled(false)
end

return M
