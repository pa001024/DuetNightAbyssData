require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.IsSelect = false
  self.Btn_Click.OnClicked:Add(self, function()
    self:OnCellClicked()
  end)
  self.Btn_Click.OnHovered:Add(self, self.OnCellHovered)
  self.Btn_Click.OnUnhovered:Add(self, self.OnCellUnhovered)
  self.Btn_Click.OnPressed:Add(self, self.OnCellPressed)
  self.Btn_Click.OnReleased:Add(self, self.OnCellReleased)
end

function M:Destruct()
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.Entry = self
  self.IsSelect = false
  if self.Content.Root.SelectedContent and self.Content.Root.SelectedContent.Index == self.Content.Index then
    self.IsSelect = true
  end
  self.Text_TabTitle:SetText(self.Content.Title)
  if self.Content.IsAllDone then
    self.ImageDone:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.ImageDone:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.Content.Root and self.Content.Root.RefreshTabReddot then
    self.Content.Root:RefreshTabReddot()
  end
end

function M:UnSelected()
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
  self.IsSelect = false
end

function M:Selected(NotPlaySound)
  self:PlayAnimation(self.Click)
  self.IsSelect = true
  if NotPlaySound then
    return
  end
end

function M:OnCellClicked(NotPlaySound)
  if self.IsSelect then
    if self.Content.Root and self.Content.Root.OnTabClickedWhenSelected then
      self.Content.Root:OnTabClickedWhenSelected()
    end
    return
  end
  self.Content.Root:RefreshListRewardInfo(self, NotPlaySound)
end

function M:OnCellHovered()
  if self.IsSelect then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:SetFocus()
  end
  if not self:IsAnimationPlaying(self.Click) then
    self:StopAnimation(self.Normal)
    self:PlayAnimation(self.Hover)
  end
end

function M:OnCellUnhovered()
  if self.IsSelect then
    return
  end
  if not self:IsAnimationPlaying(self.Click) then
    self:StopAnimation(self.Hover)
    self:StopAnimation(self.Press)
    self:PlayAnimation(self.UnHover)
  end
end

function M:OnCellPressed()
  if self.IsSelect then
    return
  end
  self:PlayAnimation(self.Press)
end

function M:OnCellReleased()
  if self.IsSelect then
    return
  end
  self:StopAnimation(self.Press)
  self:PlayAnimation(self.Normal)
end

return M
