require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local WS_TYPE_MAIN = 0
local WS_TYPE_EMPTY = 1

function M:Construct()
  self:BindButtonEvents()
end

function M:Destruct()
  self:UnbindButtonEvents()
  self:StopEquippedAnims()
  self:StopFrameAnims()
  self.bEquippedVisual = nil
  self.bPreviewVisual = nil
  self.Content = nil
end

function M:BindButtonEvents()
  self:UnbindButtonEvents()
  if not self.Btn_Click then
    return
  end
  self.Btn_Click.bIsFocusable = false
  if self.Btn_Click.SetIsFocusable then
    self.Btn_Click:SetIsFocusable(false)
  end
  if self.Btn_Click.OnClicked then
    self.Btn_Click.OnClicked:Add(self, self.OnClick)
  end
  if self.Btn_Click.OnPressed then
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
  end
  if self.Btn_Click.OnHovered then
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
  end
  if self.Btn_Click.OnUnhovered then
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
  end
end

function M:UnbindButtonEvents()
  if not self.Btn_Click then
    return
  end
  if self.Btn_Click.OnClicked then
    self.Btn_Click.OnClicked:Remove(self, self.OnClick)
  end
  if self.Btn_Click.OnPressed then
    self.Btn_Click.OnPressed:Remove(self, self.OnPressed)
  end
  if self.Btn_Click.OnHovered then
    self.Btn_Click.OnHovered:Remove(self, self.OnHovered)
  end
  if self.Btn_Click.OnUnhovered then
    self.Btn_Click.OnUnhovered:Remove(self, self.OnUnhovered)
  end
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  if Content then
    Content.CurrentEntry = self
    Content.SelfWidget = self
  end
  self:Refresh()
end

function M:Refresh(bPlayAnim)
  local Content = self.Content
  local bEmpty = nil == Content or Content.bEmpty == true
  if self.Btn_Click then
    self.Btn_Click.bIsFocusable = false
    if self.Btn_Click.SetIsFocusable then
      self.Btn_Click:SetIsFocusable(false)
    end
  end
  self.bIsFocusable = not bEmpty
  self.bIsDealWithVirtualAccept = not bEmpty
  if self.SetIsFocusable then
    self:SetIsFocusable(not bEmpty)
  end
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(bEmpty and WS_TYPE_EMPTY or WS_TYPE_MAIN)
  end
  if bEmpty then
    self:SetEquipped(false, false)
    self:PlayFrameNormal(false)
    return
  end
  if self.Text_Letter then
    self.Text_Letter:SetText(Content.Letter or "")
  end
  local Parent = Content.Parent
  local EquippedLetter = Parent and Parent.EquippedLetter or ""
  local SelectedIndex = Parent and Parent.SelectedIndex or 0
  local bEquipped = Content.Letter ~= "" and Content.Letter == EquippedLetter
  local bPreview = not bEquipped and Content.Index == SelectedIndex
  self:SetEquipped(bEquipped, true == bPlayAnim)
  if bEquipped then
    self:PlayFrameNormal(false)
    return
  end
  if bPreview then
    self:PlayFrameClick(true == bPlayAnim)
    return
  end
  self:PlayFrameNormal(true == bPlayAnim)
end

function M:CanPlayHoverPress()
  if not IsValid(self) then
    return false
  end
  local Content = self.Content
  if not IsValid(Content) or Content.bEmpty then
    return false
  end
  if self.bEquippedVisual or self.bPreviewVisual then
    return false
  end
  return true
end

function M:StopFrameAnims()
  if not IsValid(self) then
    return
  end
  if self.Normal then
    self:StopAnimation(self.Normal)
  end
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  if self.UnHover then
    self:StopAnimation(self.UnHover)
  end
  if self.Press then
    self:StopAnimation(self.Press)
  end
  if self.Click then
    self:StopAnimation(self.Click)
  end
end

function M:PlayFrameAnim(Anim, bPlayAnim)
  if not Anim then
    return
  end
  if bPlayAnim then
    self:PlayAnimationForward(Anim)
    return
  end
  self:PlayAnimation(Anim)
  if self.SetAnimationCurrentTime and Anim.GetEndTime then
    self:SetAnimationCurrentTime(Anim, Anim:GetEndTime())
  end
end

function M:PlayFrameNormal(bPlayAnim)
  self.bPreviewVisual = false
  self:StopFrameAnims()
  self:PlayFrameAnim(self.Normal, bPlayAnim)
end

function M:PlayFrameClick(bPlayAnim)
  self.bPreviewVisual = true
  self:StopFrameAnims()
  self:PlayFrameAnim(self.Click, bPlayAnim)
end

function M:StopEquippedAnims()
  if not IsValid(self) then
    return
  end
  if self.Select then
    self:StopAnimation(self.Select)
  end
  if self.UnSelect then
    self:StopAnimation(self.UnSelect)
  end
end

function M:SetEquipped(bEquipped, bPlayAnim)
  if not IsValid(self) then
    return
  end
  if self.bEquippedVisual == bEquipped then
    return
  end
  self.bEquippedVisual = bEquipped
  if bEquipped then
    if self.UnSelect then
      self:StopAnimation(self.UnSelect)
    end
    if bPlayAnim and self.Select then
      self:PlayAnimation(self.Select)
      return
    end
    if self.Select then
      self:StopAnimation(self.Select)
    end
    if self.Panel_Select then
      self.Panel_Select:SetRenderOpacity(1)
      self.Panel_Select:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    return
  end
  if self.Select then
    self:StopAnimation(self.Select)
  end
  if bPlayAnim and self.UnSelect then
    self:PlayAnimation(self.UnSelect)
    return
  end
  if self.UnSelect then
    self:StopAnimation(self.UnSelect)
  end
  if self.Panel_Select then
    self.Panel_Select:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName ~= UIConst.GamePadKey.FaceButtonBottom then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if not IsValid(self) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local Content = self.Content
  if not IsValid(Content) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local Parent = Content.Parent
  if IsValid(Parent) and Parent.OnConfirmClicked then
    Parent:OnConfirmClicked()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnPressed()
  if not self:CanPlayHoverPress() then
    return
  end
  self:StopFrameAnims()
  self:PlayFrameAnim(self.Press, true)
end

function M:OnHovered()
  if not self:CanPlayHoverPress() then
    return
  end
  self:StopFrameAnims()
  self:PlayFrameAnim(self.Hover, true)
end

function M:OnUnhovered()
  if not self:CanPlayHoverPress() then
    return
  end
  self:StopFrameAnims()
  self:PlayFrameAnim(self.UnHover, true)
end

function M:OnClick()
  if not IsValid(self) then
    return
  end
  local Content = self.Content
  if not IsValid(Content) or Content.bEmpty then
    return
  end
  local Parent = Content.Parent
  if not IsValid(Parent) or not Parent.OnLetterClicked then
    return
  end
  Parent:OnLetterClicked(Content)
  if IsValid(self) then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  end
end

return M
