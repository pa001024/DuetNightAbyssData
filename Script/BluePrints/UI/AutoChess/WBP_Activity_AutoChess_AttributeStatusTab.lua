require("UnLua")
local UIUtils = require("Utils.UIUtils")
local AutoChessConst = require("BluePrints.UI.AutoChess.AutoChessConst")
local AutoChessDataModel = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local View = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function View:Construct()
  self.Selected = false
  self.Hovered = false
  self.BtnArea.OnHovered:Add(self, self.OnHover)
  self.BtnArea.OnUnhovered:Add(self, self.OnUnHover)
  self.BtnArea.OnPressed:Add(self, self.OnPress)
  self.BtnArea.OnReleased:Add(self, self.OnReleased)
  self.BtnArea.OnClicked:Add(self, self.OnClick)
end

function View:InitInfo(ParentWidget, PositionId)
  self.ParentWidget = ParentWidget
  self.PositionId = PositionId
end

function View:OnHover()
  self.Hovered = true
  if self.Selected then
    return
  end
  self:PlayAnimation(self.Hover)
end

function View:OnUnHover()
  self.Hovered = false
  if self.Selected then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.UnHover)
  self:PlayAnimation(self.Normal)
end

function View:OnPress()
  if self.Selected then
    return
  end
  self:PlayAnimation(self.Press)
end

function View:OnReleased()
  if self.Selected then
    return
  end
  if self.Hovered then
    self:PlayAnimation(self.Click)
  else
    self:PlayAnimation(self.Normal)
  end
end

function View:OnClick()
  if self.ParentWidget and self.ParentWidget.OnAttributeTabClicked then
    self.ParentWidget:OnAttributeTabClicked(self)
  end
end

function View:SetSelected(flag)
  self.Selected = flag
  if not flag then
    self:PlayAnimation(self.Normal)
  end
end

return View
