require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Block.OnClicked:Add(self, self.OnClicked)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.CurrentEntry = self
  if not self.Btn_Block.OnCheckStateChanged:IsBound() then
    self.Btn_Block.OnCheckStateChanged:Add(self, self.OnSelected)
    self.Btn_Block.OnHovered:Add(self, self.OnHovered)
  end
  if Content.bSelected then
    self:SetSelected(true)
    self:SetFocus()
  else
    self:SetSelected(false)
  end
  self:InitData(Content)
end

function M:OnHovered()
  if UIUtils.UtilsGetCurrentInputType() ~= UE4.ECommonInputType.Gamepad then
    return
  end
  if self.Content.Parent.IsTabRefreshing then
    return
  end
  self.Content.bSelected = true
  self:OnClicked()
  self:SetSelected(true)
end

function M:OnSelected(bIsChecked)
  if not self.Content then
    DebugPrint("Content is nil, cannot clear list item object.")
    return
  end
  self.Content.bSelected = bIsChecked
  if bIsChecked then
    self.Content.Parent:OnColorSelected(self.Content)
    self.Btn_Block:SetIsEnabled(false)
  else
    local IsSelected = false
    if self.Content.Parent.CurrentColorSelectedContent == self.Content then
      IsSelected = true
      self:SetSelected(true)
    end
    if not IsSelected then
      self.Btn_Block:SetIsEnabled(true)
    end
  end
end

function M:SetSelected(bIsChecked)
  if bIsChecked then
    self.Btn_Block:SetChecked(bIsChecked)
  else
    self.Btn_Block:SetChecked(bIsChecked)
    self:PlayAnimation(self.Normal)
  end
end

function M:InitData(Content)
  local ColorIcon = Content.ColorIcon or Content.FlagColorIcon
  if ColorIcon then
    self.WS_Type:SetActiveWidgetIndex(0)
    self.Block:SetBrushResourceObject(LoadObject(ColorIcon))
  else
    self.WS_Type:SetActiveWidgetIndex(1)
  end
end

function M:OnClicked()
  local ColorId = self.Content.ColorID or self.Content.FlagColorID
  self.Content.EditCallbackInfo.Func(self.Content.EditCallbackInfo.Obj, 1, ColorId)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_color", nil, nil)
end

return M
