require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self:Init(Content)
end

function M:Init(Content)
  self.Icon:Init(Content)
  self:InitView()
  self.Icon.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self, self.ItemMenuAnchorChanged)
  self.Icon.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self.ItemMenuAnchorChanged)
end

function M:ItemMenuAnchorChanged()
  DebugPrint("Yihan@ ItemMenuAnchorChanged", UIManager(self):IsHaveMenuAnchorOpen())
  local bIsOpen = UIManager(self):IsHaveMenuAnchorOpen()
  if not bIsOpen and UIUtils.IsKeyboardInput() then
    self:SetSelected(false)
  end
  if bIsOpen and UIUtils.IsGamepadInput() then
    self.Content.ParentWidget.Panel_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Content.ParentWidget.Panel_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:InitView()
  self:SetTextDate()
  self:SetTextNum()
  self:SetIsCanGet()
  self:SetIsReceived()
  self:SetIsImportant()
end

function M:SetTextDate()
  self.TextDate:SetText(self.Content.TextDate)
end

function M:SetTextNum()
  self.TextNum:SetText(self.Content.Count)
end

function M:SetIsCanGet()
  if self.Content.bIsCanGet then
    self.Choose:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
  else
    self.Choose:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:SetIsReceived()
  DebugPrint("Yihan@ SetIsReceived: ", self.Content.bIsGet)
  if self.Content.bIsGet then
    self.Get:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
  else
    self.Get:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:SetIsImportant()
  DebugPrint("Yihan@ SetIsReceived: ", self.Content.bIsImportant)
  local bIsImportant = self.Content.bIsImportant
  if bIsImportant then
    self:PlayAnimation(self.Big)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:SetSelected(IsSelected)
  if self.Content then
    self.Content.IsSelect = IsSelected
  end
  if not IsSelected then
    self:StopAllAnimations()
    self:PlayAnimation(self.Icon_Normal)
  end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  DebugPrint("Yihan@ OnMouseEnter: ")
  if not self.Content or self.Content.IsSelect or self.Content.IsShowTips then
    return
  end
  self.IsHovering = true
  self:StopAnimation(self.Icon_UnHover)
  self:PlayAnimation(self.Icon_Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  DebugPrint("Yihan@ OnMouseLeave: ")
  if not self.Content or self.Content.IsSelect or self.Content.IsShowTips then
    return
  end
  self.IsHovering = false
  self:StopAnimation(self.Icon_Hover)
  self:PlayAnimation(self.Icon_UnHover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  DebugPrint("Yihan@ OnMouseButtonDown: ")
  self:StopAnimation(self.Icon_Hover)
  self:PlayAnimation(self.Icon_Press)
  if UIUtils.IsGamepadInput() then
    self.Content.IsShowTips = true
    self.Content.IsSelect = true
  end
  return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  self:PlayAnimation(self.Icon_Click)
  self.Icon.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, self.Content)
  self.Content.IsShowTips = true
  self.Content.IsSelect = true
  return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Icon_UnHover and not self.IsHovering then
    self:PlayAnimationForward(self.Icon_Normal)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    DebugPrint("Yihan@ OnFocusReceived")
    self:StopAllAnimations()
    self:PlayAnimation(self.Icon_Hover)
  end
  return UIUtils.Handled
end

function M:OnFocusLost(InFocusEvent)
  if UIUtils.IsGamepadInput() then
    DebugPrint("Yihan@ OnFocusLost", self.Content.IsSelect)
    self:StopAllAnimations()
    if not self.Content.IsSelect then
      self:PlayAnimation(self.Icon_UnHover)
    end
  end
  return UIUtils.Handled
end

return M
