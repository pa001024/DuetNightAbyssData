require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn.OnClicked:Add(self, self.OnClickDifficulty)
  self.Btn.OnHovered:Add(self, self.OnHovered)
  self.Btn.OnUnhovered:Add(self, self.OnUnhovered)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.UI = self
  self.bClick = Content.bClick == true
  if self.bClick then
    self.Content.ParentWidget.CurLevel = self.Content
    self:PlayAnimation(self.Click)
  else
    self:PlayAnimation(self.Normal)
  end
  self.TextLv:SetText(GText("UI_LEVEL_NAME") .. Content.Level)
end

function M:OnClickDifficulty()
  if self.Content and self.Content.ParentWidget then
    if self.Content.ParentWidget.CurLevel and self.Content.ParentWidget.CurLevel.UI then
      self.Content.ParentWidget.CurLevel.UI:PlayAnimation(self.Content.ParentWidget.CurLevel.UI.Normal)
      self.Content.ParentWidget.CurLevel.UI.bClick = false
    end
    self.Content.ParentWidget.CurLevel = self.Content
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
    self:PlayAnimation(self.Click)
    self.Content.ParentWidget:RefreshBigReward(self.Content.ParentWidget.CurReward.Id)
    self.bClick = true
  end
end

function M:OnHovered()
  if not self.bClick then
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
  end
end

function M:OnUnhovered()
  if not self.bClick then
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
  end
end

return M
