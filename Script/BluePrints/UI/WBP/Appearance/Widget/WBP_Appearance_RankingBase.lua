require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Appearance.Widget.WBP_Appearance_RankingPageView",
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent"
}

function M:Construct()
  M.Super.Construct(self)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "AppearanceRankingOpen", nil)
  self:PlayAnimation(self.In)
end

function M:Destruct()
  if self.ActorController then
    self.ActorController:OnDestruct()
  end
  M.Super.Destruct(self)
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  AudioManager(self):SetEventSoundParam(self, "AppearanceRankingOpen", {ToEnd = 1})
  self:PlayAnimation(self.Out)
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:AddTimer(0.2, function()
    self:Close()
  end)
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
  self:OnPointerCaptureLost()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightX" == InKeyName then
    if self.ActorController and self.EnableDrag ~= false then
      local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
      self.ActorController:OnDragViewActor({X = DeltaX})
    end
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

AssembleComponents(M)
return M
