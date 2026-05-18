require("UnLua")
local RoomState = {
  Public = 1,
  Friend = 2,
  Guild = 3,
  Private = 4
}
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn.OnClicked:Add(self, self.OnClickSelected)
  self.Btn.OnHovered:Add(self, self.OnHovered)
  self.Btn.OnUnhovered:Add(self, self.OnUnhovered)
end

function M:Init(State, ParentWidget)
  self.State = State
  self.ParentWidget = ParentWidget
  self.bChecked = false
  self:SetChecked(false)
  self.bForbidden = false
end

function M:SetChecked(bChecked)
  if self.State == RoomState.Guild and self.bForbidden then
    return
  end
  self.bChecked = bChecked and true or false
  if self.StopAllAnimations then
    self:StopAllAnimations()
  end
  if self.bChecked then
    self:PlayAnimation(self.Click)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:NotifyParent(NewChecked)
  if self.ParentWidget and self.ParentWidget.OnRoomStateCheckChanged and self.State then
    self.ParentWidget:OnRoomStateCheckChanged(self.State, NewChecked)
  end
end

function M:OnClickSelected()
  if self.bForbidden then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AsyncCombat_NotInGuild"))
    return
  end
  local NewChecked = not self.bChecked
  self:SetChecked(NewChecked)
  if self.ParentWidget and self.ParentWidget.OnRoomStateCheckChanged and self.State then
    self:NotifyParent(NewChecked)
  end
end

function M:OnHovered()
  if self.bForbidden then
    return
  end
  if not self.bChecked then
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
  end
end

function M:OnUnhovered()
  if self.bForbidden then
    return
  end
  if not self.bChecked then
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_FaceButton_Bottom" == InKeyName then
    self:OnClickSelected()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:InitGuildButton(bInGuild)
  if bInGuild then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Forbidden)
  self.bForbidden = true
end

return M
