require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(NodeName, NodeData, bHasAddInHUDSetting, ChooseCallback, ParentWidget)
  self.NodeName = NodeName
  self.NodeData = NodeData
  self.ChooseCallback = ChooseCallback
  self.ParentWidget = ParentWidget
  self.Text_Name:SetText(self.NodeData.ShowText)
  self.CheckBox:BindEventOnClicked({
    Inst = self,
    Func = self.OnClickCheckBox
  })
  self.Com_List:BindEventOnClicked(self, self.OnClickCellItem)
  self.Com_List:SetCanCancelSelection(true)
  self.CheckBox:SetIsChecked(bHasAddInHUDSetting)
  self.Com_List:OnCellUnSelect()
end

function M:RefreshStateWhenDataChange(bHasAddInHUDSetting)
  self.CheckBox:SetIsChecked(bHasAddInHUDSetting)
  self:CancelCellSelectState()
end

function M:OnClickCheckBox(bChecked)
  if type(self.ChooseCallback) == "function" then
    self.ChooseCallback(self.ParentWidget, bChecked, self.NodeName, self)
  end
end

function M:OnClickCellItem()
  local CurChecked = self.CheckBox:IsChecked()
  self.CheckBox:SetIsChecked(not CurChecked)
end

function M:CancelCellSelectState()
  self.Com_List:OnCellUnSelect()
end

function M:ResetState()
  self.CheckBox:UnInitCommonCheckBox()
end

return M
