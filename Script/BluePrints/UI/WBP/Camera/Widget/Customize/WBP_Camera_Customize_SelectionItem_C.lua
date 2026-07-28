require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Config = Content and Content.Config
  self.OwnerPanel = Content and Content.OwnerPanel
  self.ParentSelection = Content and Content.ParentSelection
  if self.ParentSelection then
    self.ParentSelection:RegisterEntry(Content, self)
  end
  self:Init(self.Config, self.OwnerPanel)
end

function M:Init(Config, OwnerPanel)
  self.Config = Config
  self.OwnerPanel = OwnerPanel
  Utils.SetText(self.Text or self.Text_Selection, Config and Config.Text or "")
  self:BindCheckBoxEvent()
  self:Refresh()
end

function M:BindCheckBoxEvent()
  if not self.CheckBox then
    return
  end
  if self.CheckBox.UnBindEventOnClickedByObj then
    self.CheckBox:UnBindEventOnClickedByObj(self)
  end
  if self.CheckBox.BindEventOnClicked then
    self.CheckBox:BindEventOnClicked({
      Inst = self,
      Func = self.OnCheckStateChanged
    })
    return
  end
  if self.CheckBox.AddEventOnCheckStateChanged then
    self.CheckBox:AddEventOnCheckStateChanged(self, self.OnCheckStateChanged)
  elseif self.CheckBox.OnCheckStateChanged then
    self.CheckBox.OnCheckStateChanged:Add(self, self.OnCheckStateChanged)
  end
end

function M:Refresh()
  self:RefreshValue()
  self:RefreshNewState()
  self:RefreshFocus()
end

function M:RefreshValue()
  local bSelected = self.ParentSelection and self.ParentSelection:IsOptionSelected(self.Config and self.Config.Id)
  Utils.SetCheckedState(self.CheckBox, bSelected)
end

function M:RefreshNewState()
  Utils.SetNew(self.New, self.OwnerPanel and self.OwnerPanel:IsNewVisible(self.Config and self.Config.NewKey))
end

function M:RefreshFocus()
  if self.WS_State and self.WS_State.SetActiveWidgetIndex then
    self.WS_State:SetActiveWidgetIndex(self.Content and self.Content.IsFocused and 1 or 0)
  end
end

function M:ClearNew()
  if self.OwnerPanel then
    self.OwnerPanel:ClearNew(self.Config and self.Config.NewKey)
  end
  self:RefreshNewState()
end

function M:OnCheckStateChanged(IsChecked)
  if self.ParentSelection then
    self.ParentSelection:SetOptionSelected(self.Config and self.Config.Id, true == IsChecked)
  end
  self:ClearNew()
end

function M:HandleConfirm()
  local IsChecked = self.ParentSelection and self.ParentSelection:IsOptionSelected(self.Config and self.Config.Id)
  if self.CheckBox and self.CheckBox.SetChecked then
    self.CheckBox:SetChecked(not IsChecked, true)
  elseif self.CheckBox and self.CheckBox.SetIsChecked then
    self.CheckBox:SetIsChecked(not IsChecked, true)
  else
    self:OnCheckStateChanged(not IsChecked)
  end
  return true
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self:HandleConfirm() then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
