require("UnLua")
local InvestigationUtils = require("BluePrints.UI.WBP.Investigation.InvestigationUtils")
local EPanelState = InvestigationUtils.EPanelState
local M = Class("BluePrints.UI.WBP.Investigation.WBP_Investigation_Observation_C")

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:InitShortCuts()
  self:RefreshShortcutInfo()
end

function M:Tick(MyGeometry, InDeltaTime)
  M.Super.Tick(self, MyGeometry, InDeltaTime)
  self:SnapAimToCheckpoint(self.MobilePlayerInputX, self.MobilePlayerInputY)
  self.MobilePlayerInputX = nil
  self.MobilePlayerInputY = nil
end

function M:InitShortCuts()
  self.Button_Hide:BindEventOnClicked(self, self.OnHideClicked)
  self.Button_Skip:BindEventOnClicked(self, self.OnSkipClicked)
  self.Button_Auto:BindEventOnClicked(self, self.OnAutoPlayClicked)
  self.InteractiveItem:BindEventOnClicked(self, self.OnAimClicked)
  self.Btn_Esc:InitInterface("/Game/UI/Texture/Dynamic/Atlas/Entrance/T_Entrance_Quit.T_Entrance_Quit")
  self.Btn_Esc:RebindClickEvent(self, self.OnExitClicked)
end

function M:RefreshShortcutInfo()
  self.Button_Hide:SetCurrentTextBlock("UI_Dye_HideUI")
  self.Button_Auto:SetCurrentTextBlock("UI_TALK_AUTO_1")
  self.Button_Skip:SetCurrentTextBlock("UI_TALK_SKIP_MOIILE")
  self.Btn_Esc:InitInterface("/Game/UI/Texture/Dynamic/Atlas/Entrance/T_Entrance_Quit.T_Entrance_Quit")
end

function M:ChangeAutoPlayUI(bAutoPlay)
  if bAutoPlay then
    self.WS_Icon:SetActiveWidgetIndex(1)
    self.Button_Auto:SetCurrentTextBlock("UI_TALK_AUTO_2")
  else
    self.WS_Icon:SetActiveWidgetIndex(0)
    self.Button_Auto:SetCurrentTextBlock("UI_TALK_AUTO_1")
  end
end

function M:OnHideClicked()
  self:TogglePanelHidden()
end

function M:ApplyPanelState(bUseCamera)
  M.Super.ApplyPanelState(self, bUseCamera)
  self.bShowAim = self.PanelState == EPanelState.Normal
  self.bHasShownAim = false
  self.InteractiveItem:SetVisibility(ESlateVisibility.Collapsed)
  self.InteractiveItem:SwitchNormalAnimation()
end

function M:RefreshCheckpointAimState()
  M.Super.RefreshCheckpointAimState(self)
  if not self.bShowAim then
    return
  end
  if self.CurrentAimCheckpointIndex then
    if not self.bHasShownAim and self.bShowAim then
      self.bHasShownAim = true
      self.InteractiveItem:SetVisibility(ESlateVisibility.Visible)
      self.InteractiveItem:PlayInAnimation()
    end
  elseif self.bHasShownAim then
    self.bHasShownAim = false
    self.InteractiveItem:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:UpdateKeyState(State, bUseCamera)
  if State == EPanelState.Loading then
    self.Button_Hide:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Esc:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_Auto:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_Skip:SetVisibility(ESlateVisibility.Collapsed)
  elseif State == EPanelState.Hidden then
    self.Button_Hide:SetVisibility(ESlateVisibility.Visible)
    self.Btn_Esc:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_Auto:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_Skip:SetVisibility(ESlateVisibility.Collapsed)
  elseif State == EPanelState.Dialog then
    if bUseCamera then
      self.Button_Hide:SetVisibility(ESlateVisibility.Collapsed)
      self.Btn_Esc:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.Button_Hide:SetVisibility(ESlateVisibility.Visible)
      self.Btn_Esc:SetVisibility(ESlateVisibility.Visible)
    end
    self.Button_Auto:SetVisibility(ESlateVisibility.Visible)
    self.Button_Skip:SetVisibility(ESlateVisibility.Visible)
  elseif State == EPanelState.Normal then
    self.Button_Hide:SetVisibility(ESlateVisibility.Visible)
    self.Btn_Esc:SetVisibility(ESlateVisibility.Visible)
    self.Button_Auto:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_Skip:SetVisibility(ESlateVisibility.Collapsed)
  elseif State == EPanelState.Completed then
    self.Button_Hide:SetVisibility(ESlateVisibility.Visible)
    self.Btn_Esc:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_Auto:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_Skip:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnTouchStarted(_, TouchEvent)
  self:BeginRotate()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchMoved(_, TouchEvent)
  if not self.bRotating then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local ScreenPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(TouchEvent)
  if not self.LastMousePos then
    self.LastMousePos = ScreenPos
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local MoveDelta = ScreenPos - self.LastMousePos
  self.LastMousePos = ScreenPos
  self:ProcessRotateInput(MoveDelta.X, -MoveDelta.Y)
  self.MobilePlayerInputX = MoveDelta.X
  self.MobilePlayerInputY = -MoveDelta.Y
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchEnded(_, TouchEvent)
  self:EndRotate()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

return M
