require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.bIsFocusable = true
  self.bIsGamepadFocused = false
  self:BindTabButton()
end

function M:Destruct()
  if self.Btn_TabClick and self.Btn_TabClick.OnClicked then
    self.Btn_TabClick.OnClicked:Remove(self, self.OnCellClicked)
    self.Btn_TabClick.OnHovered:Remove(self, self.OnCellHovered)
    self.Btn_TabClick.OnUnhovered:Remove(self, self.OnCellUnhovered)
    self.Btn_TabClick.OnPressed:Remove(self, self.OnCellPressed)
    self.Btn_TabClick.OnReleased:Remove(self, self.OnCellReleased)
  end
end

function M:BindTabButton()
  if not self.Btn_TabClick then
    return
  end
  if self.Btn_TabClick.OnClicked then
    self.Btn_TabClick.OnClicked:Add(self, self.OnCellClicked)
    self.Btn_TabClick.OnHovered:Add(self, self.OnCellHovered)
    self.Btn_TabClick.OnUnhovered:Add(self, self.OnCellUnhovered)
    self.Btn_TabClick.OnPressed:Add(self, self.OnCellPressed)
    self.Btn_TabClick.OnReleased:Add(self, self.OnCellReleased)
  elseif self.Btn_TabClick.BindEventOnClicked then
    self.Btn_TabClick:BindEventOnClicked(self, self.OnCellClicked)
  end
  if self.Btn_TabClick.SetVisibility then
    self.Btn_TabClick:SetVisibility(UE4.ESlateVisibility.Visible)
  end
end

function M:OnListItemObjectSet(Content)
  if not Content then
    return
  end
  self.Content = Content
  self.Content.Entry = self
  local Title = Content.Title or ""
  if self.Text_TabLevelNormal then
    self.Text_TabLevelNormal:SetText(Title)
  end
  if self.Text_TabLevelSelect then
    self.Text_TabLevelSelect:SetText(Title)
  end
  self:RefreshState()
end

function M:RefreshState()
  if not self.Content then
    return
  end
  local IsLocked = self.Content.IsLocked == true
  local IsSelect = true == self.Content.IsSelect
  if self.Group_TabSelect then
    local VisibleType = IsSelect and UE4.ESlateVisibility.HitTestInvisible or UE4.ESlateVisibility.Collapsed
    self.Group_TabSelect:SetVisibility(VisibleType)
  end
  if self.Group_Normal then
    local VisibleType = IsSelect and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.HitTestInvisible
    self.Group_Normal:SetVisibility(VisibleType)
  end
  self:StopAllAnimations()
  if not self.bIsGamepadFocused then
    self:ResetGamepadHover()
  end
  if IsLocked then
    local Anim = IsSelect and self.Lock_Click or self.Lock_Normal
    if Anim then
      self:PlayAnimation(Anim)
    end
  else
    local Anim = IsSelect and self.Click or self.Normal
    if Anim then
      self:PlayAnimation(Anim)
    end
  end
  self:RefreshLastLineState()
end

function M:RefreshLastLineState()
  if not self.Content or self.Content.Index ~= self.Content.NumberOfChoices then
    return
  end
  if self.Image_TabLine then
    self.Image_TabLine:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.Image_TabLineSelect then
    self.Image_TabLineSelect:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:ResetGamepadHover()
  if self.GamePad_Hover then
    self:StopAnimation(self.GamePad_Hover)
  end
  if self.VX_GamePad_Hover then
    self.VX_GamePad_Hover:SetRenderOpacity(0)
    self.VX_GamePad_Hover:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:BP_OnItemSelectionChanged(bIsSelected)
  if not self.Content then
    return
  end
  local Parent = self.Content.Parent
  if bIsSelected and Parent and tostring(Parent.SelectedBossId) ~= tostring(self.Content.BossId) then
    Parent:SelectBoss(self.Content.BossId, self.Content.Index, true)
    Parent:RefreshBossListSelection()
    Parent:PlayClickRefreshAnim()
  end
  self.Content.IsSelect = Parent and tostring(Parent.SelectedBossId) == tostring(self.Content.BossId) or false
  self:RefreshState()
end

function M:OnAddedToFocusPath()
  if not UIUtils.IsGamepadInput() then
    return
  end
  self.bIsGamepadFocused = true
  if self.GamePad_Hover then
    self:StopAnimation(self.GamePad_Hover)
    self:PlayAnimation(self.GamePad_Hover)
  end
end

function M:OnRemovedFromFocusPath()
  self.bIsGamepadFocused = false
  local Parent = self.Content and self.Content.Parent or nil
  if Parent and tostring(self.Content.BossId) ~= tostring(Parent.SelectedBossId) then
    self.Content.IsSelect = false
  end
  self:ResetGamepadHover()
end

function M:OnCellClicked()
  if not self.Content then
    return false
  end
  AudioManager(self):PlayUISound(self.Btn_TabClick, "event:/ui/common/click_btn_large", nil, nil)
  if self.Content.IsSelect then
    return false
  end
  local Parent = self.Content.Parent
  if Parent and Parent.SelectBoss then
    Parent:SelectBoss(self.Content.BossId, self.Content.Index)
  end
  self:RefreshState()
  return true
end

function M:OnCellHovered()
  if not self.Content or self.Content.IsSelect then
    return
  end
  if self.Normal then
    self:StopAnimation(self.Normal)
  end
  if self.Lock_Normal then
    self:StopAnimation(self.Lock_Normal)
  end
  local Anim = self.Content.IsLocked and self.Lock_Hover or self.Hover
  if Anim then
    self:PlayAnimation(Anim)
  end
end

function M:OnCellUnhovered()
  if not self.Content or self.Content.IsSelect then
    return
  end
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  if self.Lock_Hover then
    self:StopAnimation(self.Lock_Hover)
  end
  local Anim = self.Content.IsLocked and self.Lock_UnHover or self.UnHover
  if Anim then
    self:PlayAnimation(Anim)
  end
end

function M:OnCellPressed()
  if not self.Content or self.Content.IsSelect then
    return
  end
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  if self.Lock_Hover then
    self:StopAnimation(self.Lock_Hover)
  end
  local Anim = self.Content.IsLocked and self.Lock_Press or self.Press
  if Anim then
    self:PlayAnimation(Anim)
  end
end

function M:OnCellReleased()
  if not self.Content or self.Content.IsSelect then
    return
  end
  if self.Press then
    self:StopAnimation(self.Press)
  end
  if self.Lock_Press then
    self:StopAnimation(self.Lock_Press)
  end
end

return M
