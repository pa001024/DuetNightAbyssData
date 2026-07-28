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
  Utils.SetCheckedState(self.CheckBox, self.Value)
  self:Refresh()
end

function M:Refresh()
  self:RefreshValue()
  self:RefreshNewState()
end

function M:RefreshValue()
  if self.OwnerPanel and self.Config then
    self.Value = self.OwnerPanel:GetValue(self.Config)
    Utils.SetCheckedState(self.CheckBox, self.Value)
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
      Utils.SetCheckedState(self.CheckBox, self.Value)
      return false
    end
  end
  self:ClearNew()
  Utils.SetCheckedState(self.CheckBox, self.Value)
  return true
end

function M:HandleConfirm()
  local NewValue = Utils.GetChecked(self.CheckBox) ~= true
  self:OnCheckStateChanged(NewValue)
  return true
end

return M
