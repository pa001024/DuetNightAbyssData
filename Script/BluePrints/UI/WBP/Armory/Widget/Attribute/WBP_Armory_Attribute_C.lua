require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
end

function M:Init(Content)
  if nil == Content then
    return
  end
  rawset(self, "Content", Content)
  Content.Widget = self
  rawset(self, "_OnClicked", Content.OnClicked)
  rawset(self, "Owner", Content.Owner)
  if Content.IsSelected then
    self:StopAllAnimations()
    self:PlayAnimation(self.Select)
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:SetIsSelected(IsSelected)
  if IsSelected then
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn.UnhoverAnimName = ""
    self:StopAllAnimations()
    self:PlayAnimation(self.Select_In)
  else
    self.Btn.UnhoverAnimName = "UnHover"
    self:StopAnimation(self.Select_In)
    self:PlayAnimation(self.UnSelect)
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:OnBtnClicked()
  if self._OnClicked then
    self._OnClicked(self.Owner, self.Content)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.Btn)
end

return M
