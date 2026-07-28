local M = {}

function M:SetIsSelected(IsSelected, Speed)
  self.IsSelected = IsSelected
  if IsSelected then
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:StopAllAnimations()
    self:PlayAnimation(self.Click, 0, 1, 0, Speed or 1)
  else
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal, 0, 1, 0, Speed or 1)
  end
end

function M:OnBtnPressed()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Touch then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnBtnReleased()
  if self.IsSelected then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Touch then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:OnBtnHovered()
  if self.IsSelected then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Touch then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
  if self.IsSelected then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Touch then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.UnHover)
end

return M
