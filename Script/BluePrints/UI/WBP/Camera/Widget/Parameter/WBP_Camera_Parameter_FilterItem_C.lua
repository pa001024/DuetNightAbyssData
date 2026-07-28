require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.ButtonAnimationComponent"
}

function M:Construct()
  self:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:SetTitle(Text)
  self.Text:SetText(Text)
end

function M:OnListItemObjectSet(Content)
  rawset(self, "Content", Content)
  rawset(self, "Owner", Content.Owner)
  rawset(Content, "Widget", self)
  rawset(self, "_OnAddedToFocusPath", Content.OnAddedToFocusPath)
  self:SetRedDot(Content.RedDotType)
  self:SetIsSelected(Content.IsSelected, 100)
  self:SetIcon(Content.Data.IconPath)
  self:SetName(GText(Content.Data.TextmapID))
end

function M:OnBtnClicked()
  if self.IsSelected then
    return
  end
  if not self.Content then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
  if self.Content.OnClicked then
    self.Content.OnClicked(self.Content.Owner, self.Content)
  end
end

function M:SetName(Text)
  self.Text:SetText(Text)
end

function M:SetRedDot(RedDotType)
  if RedDotType == UIConst.RedDotType.NewRedDot then
    self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetIcon(IconPath)
  if IconPath then
    self.WS_Image:SetActiveWidgetIndex(0)
    self.Image_Filter:SetBrushResourceObject(LoadObject(IconPath))
  else
    self.WS_Image:SetActiveWidgetIndex(1)
  end
end

function M:BP_OnEntryReleased()
  if rawget(self, "Content") then
    self.Content.Widget = nil
  end
end

function M:OnAddedToFocusPath()
  if self._OnAddedToFocusPath then
    self._OnAddedToFocusPath(self.Owner, self)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.Btn_Click)
end

AssembleComponents(M)
return M
