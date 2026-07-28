require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.LeftOption = Content.LeftOption
  self.RightOption = Content.RightOption
  self.ParentWidget = Content.ParentWidget
  self.Text_L:SetText(GText(self.LeftOption.Label))
  self.Text_R:SetText(GText(self.RightOption.Label))
  self.Btn_Click.OnClicked:Clear()
  self.Btn_Click.OnClicked:Add(self, self.OnSwitchClicked)
  self.SelectedIndex = 1
  if self.RightOption.State == true then
    self.SelectedIndex = 2
  end
  self:PlaySwitchAnim(self.SelectedIndex)
end

function M:PlaySwitchAnim(SelectedIndex)
  self:StopAllAnimations()
  if 1 == SelectedIndex then
    self:PlayAnimation(self.Switch_Right, 0, 1, UE4.EUMGSequencePlayMode.Reverse)
  else
    self:PlayAnimation(self.Switch_Right)
  end
end

function M:OnSwitchClicked()
  self.SelectedIndex = 1 == self.SelectedIndex and 2 or 1
  self:PlaySwitchAnim(self.SelectedIndex)
  self.ParentWidget:OnSwitchClicked(self.LeftOption, self.RightOption, self.SelectedIndex)
end

return M
