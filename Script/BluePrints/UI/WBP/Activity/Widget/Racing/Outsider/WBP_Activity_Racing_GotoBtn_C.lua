require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:InitView()
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice()
end

function M:InitView()
end

function M:SetText(Text)
  self.Text_Btn:SetText(GText(Text))
end

function M:IsShowNew(bShow)
  self.New:SetVisibility(bShow and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  DebugPrint("Yihan@ OnMouseEnter: ")
  self.IsHovering = true
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  DebugPrint("Yihan@ OnMouseLeave: ")
  self.IsHovering = false
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  DebugPrint("Yihan@ OnMouseButtonDown: ")
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
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
