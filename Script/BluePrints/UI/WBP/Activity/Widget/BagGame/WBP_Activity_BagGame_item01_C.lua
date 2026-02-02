require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
end

function M:Destruct()
  self.Btn_Center_L.OnClicked:Remove(self, self.OnCenterLBtnClicked)
  self.Btn_Center_R.OnClicked:Remove(self, self.OnCenterRBtnClicked)
end

function M:OnListItemObjectSet(Content)
  self.Owner = Content.Owner
  self.Content = Content
  self.Index = Content.Index
  self.Widget = self
  self:InitData(Content)
  self:InitView(Content)
  self.Btn_Center_L.OnClicked:Add(self, self.OnCenterLBtnClicked)
  self.Btn_Center_R.OnClicked:Add(self, self.OnCenterRBtnClicked)
end

function M:InitData(Content)
end

function M:InitView(Content)
  self.Panel_Center:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.PanalS:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:Set_NumandStart(Content.Id, Content.Star)
end

function M:OnCenterLBtnClicked()
  print("OnCenterLBtnClicked")
  self.Owner:ScrollToPreviousItem()
end

function M:OnCenterRBtnClicked()
  print("OnCenterRBtnClicked")
  self.Owner:ScrollToNextItem()
end

function M:PlaySelected()
  self.Panel_Center:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.PanalS:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.Change then
    self:PlayAnimation(self.Change)
  end
  self.bIsSelected = true
end

function M:PlayUnselected()
  self.Panel_Center:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.PanalS:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.Change then
    self:PlayAnimationReverse(self.Change)
  end
  self.bIsSelected = false
end

return M
