require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function SetShown(Widget, bShown)
  if Widget then
    Widget:SetVisibility(bShown and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

local function SetCheckShown(Widget, bShown)
  if Widget then
    Widget:SetRenderOpacity(bShown and 1 or 0)
    Widget:SetVisibility(bShown and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:Construct()
  self.ButtonStateAnimationNames = {
    Normal = self.Btn_Click.NormalAnimName,
    Hover = self.Btn_Click.HoverAnimName,
    Press = self.Btn_Click.PressAnimName,
    Unhover = self.Btn_Click.UnhoverAnimName,
    Forbid = self.Btn_Click.ForbidAnimName
  }
  self.Btn_Click.AudioEventPath = "event:/ui/common/click_mid"
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
end

function M:Destruct()
  self:SetNativeStateAnimationsEnabled(true)
  self.Btn_Click.OnClicked:Remove(self, self.OnBtnClicked)
  self.Data = nil
  self.Owner = nil
  self.bSelected = nil
  self.ButtonStateAnimationNames = nil
end

function M:InitData(Data, Owner)
  self.Data = Data or {Kind = "Empty"}
  self.Owner = Owner
  if self.Data.Kind == "Add" and self.Key_Add and self.Key_Add.CreateGamepadKey then
    self.Key_Add:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
  end
  self:Refresh()
end

function M:SetGamepadKeyVisible(bVisible)
  if self.Key_Add then
    local bShow = bVisible and self.Data and self.Data.Kind == "Add"
    self.Key_Add:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:Refresh()
  local Data = self.Data or {Kind = "Empty"}
  local bSelected = Data.Selected == true
  local bForbidden = true == Data.Disabled
  local bVisualSelected = bSelected and not bForbidden and true ~= Data.Editing
  local bEmpty = Data.Kind == "Empty"
  if Data.Kind == "Preset" then
    self.WS_Item:SetActiveWidgetIndex(0)
    self.Text_Normal:SetText(Data.Text or "")
  elseif Data.Kind == "Custom" then
    self.WS_Item:SetActiveWidgetIndex(1)
    self.WS_Player:SetActiveWidgetIndex(0)
    self.Text_PlayerCreate:SetText(Data.Text or "")
  elseif Data.Kind == "Add" then
    self.WS_Item:SetActiveWidgetIndex(1)
    self.WS_Player:SetActiveWidgetIndex(1)
  else
    self.WS_Item:SetActiveWidgetIndex(2)
  end
  SetShown(self.Group_Delete, Data.Kind == "Custom" and true == Data.Editing)
  self.Btn_Click:SetIsEnabled(not bEmpty)
  self:SetSelected(bVisualSelected, bForbidden)
end

function M:SetSelected(bSelected, bForbidden)
  bForbidden = true == bForbidden
  bSelected = true == bSelected and not bForbidden
  self.bSelected = bSelected
  self:SetNativeStateAnimationsEnabled(true)
  self.Btn_Click:SetForbidden(false)
  self:SetNativeStateAnimationsEnabled(not bSelected)
  if bForbidden then
    self.Btn_Click:SetForbidden(true)
  end
  self:StopAllAnimations()
  local Animation = bForbidden and self.Fobbidden or bSelected and self.Click or self.Normal
  if Animation then
    EMUIAnimationSubsystem:SetWidgetAnimation(self, Animation)
  end
  SetCheckShown(self.Group_Check, bSelected)
end

function M:SetNativeStateAnimationsEnabled(bEnabled)
  local Names = self.ButtonStateAnimationNames
  if not Names then
    return
  end
  if bEnabled then
    self.Btn_Click.NormalAnimName = Names.Normal
    self.Btn_Click.HoverAnimName = Names.Hover
    self.Btn_Click.PressAnimName = Names.Press
    self.Btn_Click.UnhoverAnimName = Names.Unhover
    self.Btn_Click.ForbidAnimName = Names.Forbid
  else
    self.Btn_Click.NormalAnimName = ""
    self.Btn_Click.HoverAnimName = ""
    self.Btn_Click.PressAnimName = ""
    self.Btn_Click.UnhoverAnimName = ""
    self.Btn_Click.ForbidAnimName = ""
  end
end

function M:OnBtnClicked()
  if self.Data and self.Data.Kind ~= "Empty" and not self.Data.Disabled and self.Owner and self.Owner.OnRecruitSignItemClicked then
    self.Owner:OnRecruitSignItemClicked(self.Data)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.Owner and self.Owner.OnRecruitSignItemFocused then
    self.Owner:OnRecruitSignItemFocused(self)
  end
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.Btn_Click)
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self.Owner and self.Owner.OnRecruitSignItemFocused then
    self.Owner:OnRecruitSignItemFocused(self)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self.Owner and self.Owner.HandleRecruitChildPreviewKeyDown and self.Owner:HandleRecruitChildPreviewKeyDown(MyGeometry, InKeyEvent) then
    return UWidgetBlueprintLibrary.Handled()
  end
  return UWidgetBlueprintLibrary.Unhandled()
end

return M
