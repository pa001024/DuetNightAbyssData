require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
M.TipsEnabled = false
M.IsPinned = false
M.IsMaximized = false
M.ToastState = "Idle"
M.ToastWaitHandle = nil
M.PendingToastText = nil
M.HoverPinnedState = nil
M.HoverSessionActive = false

function M:GetPinAnim(Base)
  local name = (self.IsPinned and "Pin_Up_" or "Pin_") .. Base
  return self[name]
end

function M:StopPinAnimations()
  local function stop(a)
    if a then
      self:StopAnimation(a)
    end
  end
  
  stop(self.Pin_Click)
  stop(self.Pin_Press)
  stop(self.Pin_Hover)
  stop(self.Pin_UnHover)
  stop(self.Pin_Up_Click)
  stop(self.Pin_Up_Press)
  stop(self.Pin_Up_Hover)
  stop(self.Pin_Up_UnHover)
end

function M:PlayPinAnim(Base)
  local anim = self:GetPinAnim(Base)
  if not anim then
    return
  end
  self:StopPinAnimations()
  self:PlayAnimation(anim)
end

function M:OnPinHovered()
  if not self.TipsEnabled then
    self:EnableTips()
  end
  self.HoverPinnedState = self.IsPinned
  self.HoverSessionActive = true
  self:PlayPinAnim("Hover")
end

function M:OnPinUnhovered()
  if not self.HoverSessionActive then
    self.HoverPinnedState = nil
    return
  end
  if self.HoverPinnedState ~= nil and self.HoverPinnedState ~= self.IsPinned then
    self.HoverPinnedState = nil
    self.HoverSessionActive = false
    self:StopPinAnimations()
    self:PlayPinAnim("Normal")
    return
  end
  self.HoverPinnedState = nil
  self.HoverSessionActive = false
  if self:GetPinAnim("UnHover") then
    self:PlayPinAnim("UnHover")
  else
    self:PlayPinAnim("Normal")
  end
end

function M:OnPinPressed()
  self:PlayPinAnim("Press")
end

function M:OnPinReleased()
  self:PlayPinAnim("Normal")
end

function M:SetToolTips()
  if self.Btn_PinBtn then
    local key = self.IsPinned and "UI_Windows_Unpin" or "UI_Windows_PinToTop"
    UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_PinBtn, GText(key))
  end
  if self.Btn_MinBtn then
    UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_MinBtn, GText("UI_Windows_Minimize"))
  end
  if self.Btn_FullBtn then
    local showRestore = UE.UWindowTitleBarFunctionLibrary.ShouldShowRestoreIcon()
    local key = showRestore and "UI_Windows_RestoreDownward" or "UI_Windows_Maximize"
    UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_FullBtn, GText(key))
  end
  if self.Btn_Close then
    UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_Close, GText("UI_Windows_Close"))
  end
end

function M:EnableTips()
  self:SetToolTips()
  self.TipsEnabled = true
end

function M:DisableTips()
  if self.Btn_PinBtn then
    UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_PinBtn, GText())
  end
  if self.Btn_MinBtn then
    UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_MinBtn, GText())
  end
  if self.Btn_FullBtn then
    UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_FullBtn, GText())
  end
  if self.Btn_Close then
    UE.UWindowTitleBarFunctionLibrary.SetAntiScaledToolTip(self.Btn_Close, GText())
  end
  self.TipsEnabled = false
end

function M:Construct()
  if self.Text_GameTitle then
    self.Text_GameTitle:SetText(GText("UI_Windows_GameName"))
  end
  if self.Btn_PinBtn and self.Btn_PinBtn.OnClicked then
    self.Btn_PinBtn.OnClicked:Clear()
    self.Btn_PinBtn.OnHovered:Clear()
    self.Btn_PinBtn.OnUnhovered:Clear()
    self.Btn_PinBtn.OnPressed:Clear()
    self.Btn_PinBtn.OnReleased:Clear()
    self.Btn_PinBtn.OnClicked:Add(self, self.OnPinClicked)
    if self.Btn_PinBtn.OnHovered then
      self.Btn_PinBtn.OnHovered:Add(self, self.OnPinHovered)
    end
    if self.Btn_PinBtn.OnUnhovered then
      self.Btn_PinBtn.OnUnhovered:Add(self, self.OnPinUnhovered)
    end
    if self.Btn_PinBtn.OnPressed then
      self.Btn_PinBtn.OnPressed:Add(self, self.OnPinPressed)
    end
    if self.Btn_PinBtn.OnReleased then
      self.Btn_PinBtn.OnReleased:Add(self, self.OnPinReleased)
    end
  end
  if self.Btn_MinBtn then
    self.Btn_MinBtn.OnClicked:Add(self, self.OnMinimizeClicked)
  end
  if self.Btn_FullBtn and self.Btn_FullBtn.OnClicked then
    self.Btn_FullBtn.OnClicked:Clear()
    self.Btn_FullBtn.OnHovered:Clear()
    self.Btn_FullBtn.OnUnhovered:Clear()
    self.Btn_FullBtn.OnPressed:Clear()
    self.Btn_FullBtn.OnReleased:Clear()
    self.Btn_FullBtn.OnClicked:Add(self, self.OnMaximizeClicked)
    if self.Btn_FullBtn.OnHovered then
      self.Btn_FullBtn.OnHovered:Add(self, self.OnFullHovered)
    end
    if self.Btn_FullBtn.OnUnhovered then
      self.Btn_FullBtn.OnUnhovered:Add(self, self.OnFullUnhovered)
    end
    if self.Btn_FullBtn.OnPressed then
      self.Btn_FullBtn.OnPressed:Add(self, self.OnFullPressed)
    end
    if self.Btn_FullBtn.OnReleased then
      self.Btn_FullBtn.OnReleased:Add(self, self.OnFullReleased)
    end
  end
  if self.Btn_Close then
    self.Btn_Close.OnClicked:Add(self, self.OnCloseClicked)
  end
  local isMax = UE.UWindowTitleBarFunctionLibrary.IsGameWindowMaximized()
  self.IsMaximized = isMax and true or false
  self.IsPinned = self.IsPinned and true or false
  if self.WidgetSwitcher_Max then
    self.WidgetSwitcher_Max:SetActiveWidgetIndex(self.IsMaximized and 1 or 0)
  end
  if self.Group_TopTips then
    self.Group_TopTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:EnableTips()
  if self.Tips_In then
    self:BindToAnimationFinished(self.Tips_In, {
      self,
      self.OnTipsInFinished
    })
  end
  if self.Tips_Out then
    self:BindToAnimationFinished(self.Tips_Out, {
      self,
      self.OnTipsOutFinished
    })
  end
  local Root = UE.UWindowTitleBarFunctionLibrary.GetWindowTitleBarRootWidget()
  if Root then
    if Root.WidgetTree and Root.WidgetTree.RootWidget then
      Root.WidgetTree.RootWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    if Root.OnWindowMaximizeStateChanged then
      Root.OnWindowMaximizeStateChanged:Add(self, self.OnWindowMaximizeStateChanged)
    end
  end
end

function M:OnPinClicked()
  self.HoverSessionActive = false
  self.HoverPinnedState = nil
  local willPin = not self.IsPinned
  self.IsPinned = willPin
  if willPin then
    AudioManager(self):PlayUISound(self, "event:/ui/common/pin", nil, nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/pin_cancel", nil, nil)
  end
  if self.Pin_Click then
    self:StopPinAnimations()
    if willPin then
      self:PlayAnimation(self.Pin_Click)
    else
      self:PlayAnimationReverse(self.Pin_Click)
    end
  end
  UE.UWindowTitleBarFunctionLibrary.ToggleAlwaysOnTopGameWindow()
  if self.TipsEnabled then
    self:SetToolTips()
  end
  local key = self.IsPinned and "UI_Windows_Toast_PinToTop" or "UI_Windows_Toast_Unpin"
  self:ShowTopToast(key)
end

function M:OnMinimizeClicked()
  if self.TipsEnabled then
    self:DisableTips()
  end
  UE.UWindowTitleBarFunctionLibrary.MinimizeGameWindow()
end

function M:OnMaximizeClicked()
  if not self.TipsEnabled then
    self:EnableTips()
  end
  UE.UWindowTitleBarFunctionLibrary.ToggleMaximizeRestoreGameWindow()
end

function M:OnWindowMaximizeStateChanged(bMaximized)
  self.IsMaximized = bMaximized and true or false
  if self.WidgetSwitcher_Max then
    self.WidgetSwitcher_Max:SetActiveWidgetIndex(self.IsMaximized and 1 or 0)
  end
  if self.TipsEnabled then
    self:SetToolTips()
  end
end

function M:OnCloseClicked()
  if self.TipsEnabled then
    self:DisableTips()
  end
  UE.UWindowTitleBarFunctionLibrary.CloseGameWindow()
end

function M:ShowTopToast(Key)
  if not (self.Text_TopTips and self.Tips_In) or not self.Tips_Out then
    return
  end
  local Text = GText(Key)
  if self.ToastState == "Idle" then
    if self.Group_TopTips then
      self.Group_TopTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.Text_TopTips:SetText(Text)
    self:PlayAnimation(self.Tips_In)
    self.ToastState = "In"
    return
  end
  if self.ToastState == "In" or self.ToastState == "Wait" then
    self:RemoveTimer("TopToastAutoOut", true)
    self.PendingToastText = Text
    self:PlayAnimation(self.Tips_Out)
    self.ToastState = "Out"
    return
  end
  if self.ToastState == "Out" then
    self.PendingToastText = Text
    return
  end
end

function M:OnTipsInFinished()
  self.ToastState = "Wait"
  self:AddTimer(2.0, function(self)
    if self.ToastState == "Wait" then
      self:PlayAnimation(self.Tips_Out)
      self.ToastState = "Out"
    end
  end, false, 0, "TopToastAutoOut", true)
end

function M:OnTipsOutFinished()
  if self.PendingToastText then
    if self.Group_TopTips then
      self.Group_TopTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.Text_TopTips:SetText(self.PendingToastText)
    self.PendingToastText = nil
    self:PlayAnimation(self.Tips_In)
    self.ToastState = "In"
  else
    if self.Group_TopTips then
      self.Group_TopTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.ToastState = "Idle"
  end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  return UE.UWidgetBlueprintLibrary.Unhandled()
end

function M:GetFullAnim(Base)
  local showRestore = UE.UWindowTitleBarFunctionLibrary.ShouldShowRestoreIcon()
  local prefix = showRestore and "Full_Window_" or "Full_Max_"
  return self[prefix .. Base]
end

function M:StopFullAnimations()
  local function stop(a)
    if a then
      self:StopAnimation(a)
    end
  end
  
  stop(self.Full_Max_Click)
  stop(self.Full_Max_Press)
  stop(self.Full_Max_Hover)
  stop(self.Full_Max_UnHover)
  stop(self.Full_Window_Click)
  stop(self.Full_Window_Press)
  stop(self.Full_Window_Hover)
  stop(self.Full_Window_UnHover)
end

function M:PlayFullAnim(Base)
  local anim = self:GetFullAnim(Base)
  if not anim then
    return
  end
  self:StopFullAnimations()
  self:PlayAnimation(anim)
end

function M:OnFullHovered()
  if self.TipsEnabled then
    self:SetToolTips()
  end
  self:PlayFullAnim("Hover")
end

function M:OnFullUnhovered()
  local anim = self:GetFullAnim("UnHover")
  if anim then
    self:PlayFullAnim("UnHover")
  else
    self:PlayFullAnim("Normal")
  end
end

function M:OnFullPressed()
  self:PlayFullAnim("Press")
end

function M:OnFullReleased()
  self:PlayFullAnim("Normal")
end

return M
