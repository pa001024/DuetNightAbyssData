require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnClicked)
  self.Btn_Click.OnHovered:Add(self, self.OnHovered)
  self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
  self.Btn_Click.OnPressed:Add(self, self.OnPressed)
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnClicked)
  self.Btn_Click.OnHovered:Remove(self, self.OnHovered)
  self.Btn_Click.OnUnhovered:Remove(self, self.OnUnhovered)
  self.Btn_Click.OnPressed:Remove(self, self.OnPressed)
end

function M:PlayBtnState(StateName)
  local Anim = self[StateName]
  if Anim then
    self:StopAllAnimations()
    self:PlayAnimation(Anim)
  end
end

function M:IsSelectedItem()
  return self.Content ~= nil and self.Content.IsSelected == true
end

function M:OnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
  if not self:IsSelectedItem() then
    self:PlayBtnState("Click")
  end
  if self.Content and self.Content.OnListItemClicked then
    self.Content.OnListItemClicked(self.Content.Owner, self.Content)
  end
end

function M:OnHovered()
  if self:IsSelectedItem() then
    return
  end
  self:PlayBtnState("Hover")
end

function M:OnUnhovered()
  if self:IsSelectedItem() then
    return
  end
  self:PlayBtnState("UnHover")
end

function M:OnPressed()
  if self:IsSelectedItem() then
    return
  end
  self:PlayBtnState("Press")
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  Content.Entry = self
  self.WS_BG:SetActiveWidgetIndex((Content.Index - 1) % 2)
  local IsAll = Content.AttrKey == nil or Content.AttrKey == "All"
  self.WS_Icon:SetActiveWidgetIndex(IsAll and 0 or 1)
  self.WS_Text:SetActiveWidgetIndex(IsAll and 0 or 1)
  if IsAll then
    self.Text_All:SetText(Content.Text)
  else
    if Content.IconPath then
      self.Image_StatesIcon:SetBrushFromTexture(LoadObject(Content.IconPath))
    end
    self.Text_States:SetText(Content.Text)
  end
  self:RefreshSelected()
end

function M:BP_OnEntryReleased()
  if self.Content then
    self.Content.Entry = nil
  end
end

function M:RefreshSelected()
  if not self.Content then
    return
  end
  self:PlayBtnState(self.Content.IsSelected and "Select" or "Normal")
end

return M
