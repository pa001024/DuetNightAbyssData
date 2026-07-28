require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.ButtonAnimationComponent"
}

function M:Construct()
  rawset(self, "IsSelected", false)
end

function M:OnListItemObjectSet(Content)
  rawset(self, "Content", Content)
  rawset(Content, "Widget", self)
  rawset(self, "Owner", Content.Owner)
  rawset(self, "_OnAddedToFocusPath", Content.OnAddedToFocusPath)
  self:SetIsSelected(Content.IsSelected, 100)
  if Content.IconPath then
    self.Icon:SetBrushResourceObject(LoadObject(Content.IconPath))
  end
  self:SetRedDot(Content.RedDotType)
end

function M:SetRedDot(RedDotType)
  if RedDotType == UIConst.RedDotType.NewRedDot then
    self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:BP_OnEntryReleased()
  if rawget(self, "Content") then
    rawset(self.Content, "Widget", nil)
  end
end

function M:OnBtnClicked()
  if self.IsSelected then
    return
  end
  if not self.Content then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
  if self.Content.OnClicked then
    self.Content.OnClicked(self.Content.Owner, self.Content)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.Btn_Click)
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self._OnAddedToFocusPath then
    self._OnAddedToFocusPath(self.Owner, self, self.Content)
  end
end

AssembleComponents(M)
return M
