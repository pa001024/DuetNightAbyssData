require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice()
end

function M:Init()
  self.IsForbidden = false
end

function M:SetText(Text)
  self.Text_Btn:SetText(GText(Text))
end

function M:IsShowReddot(bShow)
  self.Reddot:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:ForbidBtn(IsForbid)
  if true == IsForbid then
    self.IsForbidden = true
    self:PlayButtonForbidAnim()
  elseif false == IsForbid then
    self.IsForbidden = false
    self:PlayButtonUnForbidAnim()
  end
end

function M:PlayButtonForbidAnim()
  self:StopAllAnimations()
  self:DestroyAllAnmations()
  self:PlayAnimation(self.Forbidden)
end

function M:PlayButtonUnForbidAnim()
  if self.IsHovering then
    self:PlayAnimation(self.Hover)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  if self.IsForbidden then
    return
  end
  self.IsHovering = true
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  if self.IsForbidden then
    return
  end
  self.IsHovering = false
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if self.IsForbidden then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  if self.IsForbidden then
    return
  end
  self:PlayAnimation(self.Click)
end

function M:AddInputMethodChangedListen()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  if UIUtils.IsGamepadInput() then
    self:InitGamepadView()
  elseif UIUtils.IsKeyboardInput() then
    self:InitKeyboardView()
  end
end

function M:InitGamepadView()
  self.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:InitKeyboardView()
  self.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

return M
