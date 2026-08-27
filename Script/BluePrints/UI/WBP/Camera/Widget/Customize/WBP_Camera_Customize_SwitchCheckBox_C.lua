require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Init(Config, OwnerPanel)
  self.Config = Config
  self.OwnerPanel = OwnerPanel
  self.Value = OwnerPanel and OwnerPanel:GetValue(Config) or Config.DefaultValue
  Utils.SetText(self.Text, Config and Config.Text or "")
  if self.CheckBox and self.CheckBox.AddEventOnCheckStateChanged then
    self.CheckBox:AddEventOnCheckStateChanged(self, self.OnCheckStateChanged)
  elseif self.CheckBox and self.CheckBox.OnCheckStateChanged then
    self.CheckBox.OnCheckStateChanged:Add(self, self.OnCheckStateChanged)
  end
  self:BindSwitchClickAnimationFinished()
  Utils.SetCheckedState(self.CheckBox, self.Value)
  self:Refresh()
end

function M:BindSwitchClickAnimationFinished()
  local CheckBox = self.CheckBox
  if not (CheckBox and CheckBox.BindToAnimationFinished) or self.ClickAnimationBoundCheckBox == CheckBox then
    return
  end
  self.ClickAnimationBoundCheckBox = CheckBox
  if CheckBox.Close_Click then
    CheckBox:BindToAnimationFinished(CheckBox.Close_Click, {
      self,
      self.OnSwitchClickAnimationFinished
    })
  end
  if CheckBox.Open_Click then
    CheckBox:BindToAnimationFinished(CheckBox.Open_Click, {
      self,
      self.OnSwitchClickAnimationFinished
    })
  end
end

function M:OnSwitchClickAnimationFinished()
  local CheckBox = self.CheckBox
  if not CheckBox then
    return
  end
  if CheckBox.IsAnimationPlaying and (CheckBox.Close_Click and CheckBox:IsAnimationPlaying(CheckBox.Close_Click) or CheckBox.Open_Click and CheckBox:IsAnimationPlaying(CheckBox.Open_Click)) then
    return
  end
  local ButtonArea = CheckBox.ButtonArea
  local bHovered = ButtonArea and ButtonArea.IsHovered and ButtonArea:IsHovered() == true
  if bHovered and CheckBox.OnBtnHovered then
    CheckBox:OnBtnHovered()
  elseif CheckBox.OnBtnUnhovered then
    CheckBox:OnBtnUnhovered()
  elseif CheckBox.GetBtnNormalAnim and CheckBox.PlayAnimation then
    CheckBox:PlayAnimation(CheckBox:GetBtnNormalAnim())
  end
end

function M:Refresh()
  self:RefreshValue()
  self:RefreshNewState()
end

function M:RefreshValue()
  if self.OwnerPanel and self.Config then
    local NewValue = self.OwnerPanel:GetValue(self.Config) == true
    self.Value = NewValue
    if Utils.GetChecked(self.CheckBox) ~= NewValue then
      Utils.SetCheckedState(self.CheckBox, NewValue)
    end
  end
end

function M:RefreshNewState()
  Utils.SetNew(self.New, self.OwnerPanel and self.OwnerPanel:IsNewVisible(self.Config and self.Config.NewKey))
end

function M:ClearNew()
  if self.OwnerPanel then
    self.OwnerPanel:ClearNew(self.Config and self.Config.NewKey)
  end
  self:RefreshNewState()
end

function M:OnCheckStateChanged(IsChecked)
  local OldValue = self.OwnerPanel and self.Config and self.OwnerPanel:GetValue(self.Config)
  self.Value = true == IsChecked
  if self.OwnerPanel then
    local bSuccess = self.OwnerPanel:OnItemValueChanged(self.Config, self.Value)
    if false == bSuccess then
      self.Value = true == OldValue
      if Utils.GetChecked(self.CheckBox) ~= self.Value then
        Utils.SetCheckedState(self.CheckBox, self.Value)
      end
      return false
    end
  end
  self:ClearNew()
  return true
end

function M:HandleConfirm()
  local NewValue = Utils.GetChecked(self.CheckBox) ~= true
  self:OnCheckStateChanged(NewValue)
  return true
end

return M
