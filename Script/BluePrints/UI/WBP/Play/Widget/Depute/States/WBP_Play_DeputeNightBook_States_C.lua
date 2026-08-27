require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})
local ATTR_ORDER = {
  "Water",
  "Fire",
  "Wind",
  "Thunder",
  "Light",
  "Dark"
}

function M:Construct()
  self.List_States:ClearListItems()
end

function M:Init(Owner, SelectedAttrKey)
  self.Owner = Owner
  SelectedAttrKey = SelectedAttrKey or "All"
  self.List_States:ClearListItems()
  self.SelectedContent = nil
  local AllContent = NewObject(UIUtils.GetCommonItemContentClass())
  AllContent.AttrKey = "All"
  AllContent.Text = GText("UI_ALL")
  AllContent.Index = 1
  AllContent.Owner = self
  AllContent.OnListItemClicked = self.OnListItemClicked
  AllContent.IsSelected = "All" == SelectedAttrKey
  if AllContent.IsSelected then
    self.SelectedContent = AllContent
  end
  self.List_States:AddItem(AllContent)
  for i, AttrKey in ipairs(ATTR_ORDER) do
    local AttrData = DataMgr.Attribute[AttrKey]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.AttrKey = AttrKey
    Content.Text = GText(AttrData.Textmap)
    Content.IconPath = AttrData.Icon
    Content.Index = i + 1
    Content.Owner = self
    Content.OnListItemClicked = self.OnListItemClicked
    Content.IsSelected = SelectedAttrKey == AttrKey
    if Content.IsSelected then
      self.SelectedContent = Content
    end
    self.List_States:AddItem(Content)
  end
  self:PlayOpenAnimation()
end

function M:PlayOpenAnimation()
  self.bPlayingOut = false
  self.OnCloseAnimFinished = nil
  if self.Out then
    self:StopAnimation(self.Out)
  end
  if self.In then
    self:PlayAnimation(self.In)
  end
end

function M:PlayCloseAnimation(Callback)
  if self.bPlayingOut then
    return
  end
  self.bPlayingOut = true
  self.OnCloseAnimFinished = Callback
  if not self.Out then
    self:_FinishCloseAnimation()
    return
  end
  if self.In then
    self:StopAnimation(self.In)
  end
  self:PlayAnimation(self.Out)
end

function M:_FinishCloseAnimation()
  local Callback = self.OnCloseAnimFinished
  self.OnCloseAnimFinished = nil
  self.bPlayingOut = false
  if Callback then
    Callback()
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:_FinishCloseAnimation()
  end
end

function M:OnListItemClicked(Content)
  if self.SelectedContent ~= Content then
    if self.SelectedContent and self.SelectedContent.Entry then
      self.SelectedContent.IsSelected = false
      self.SelectedContent.Entry:RefreshSelected()
    end
    Content.IsSelected = true
    if Content.Entry then
      Content.Entry:RefreshSelected()
    end
    self.SelectedContent = Content
    if self.Owner and self.Owner.OnAttrFilterSelected then
      self.Owner:OnAttrFilterSelected(Content.AttrKey)
    end
  end
  if self.Owner and self.Owner.CloseAttrFilterMenu then
    self.Owner:CloseAttrFilterMenu()
  end
end

function M:NavigateToSelected()
  if self.SelectedContent then
    self.List_States:NavigateToIndex(self.SelectedContent.Index - 1)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonRight then
    if self.Owner and self.Owner.CloseAttrFilterMenu then
      self.Owner:CloseAttrFilterMenu()
    end
    return UWidgetBlueprintLibrary.Handled()
  end
  return UWidgetBlueprintLibrary.Unhandled()
end

return M
