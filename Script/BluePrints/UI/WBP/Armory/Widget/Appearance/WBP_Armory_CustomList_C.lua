require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
end

function M:Init(Params)
  rawset(self, "Owner", Params.Owner)
  rawset(self, "Params", Params)
  local AllChildren = self.ScrollBox:GetAllChildren():ToTable()
  local ChildrenNum = #AllChildren
  local Groups = Params.Groups or {}
  local GroupNumber = #Groups
  local WidgetClass = UGameplayStatics.GetObjectClass(AllChildren[1])
  local UIManager = UIManager(self)
  local ShouldKeepCount = GroupNumber > 1 and GroupNumber or 1
  if ChildrenNum > ShouldKeepCount then
    for i = ChildrenNum, ShouldKeepCount + 1, -1 do
      if i > 1 then
        AllChildren[i]:RemoveFromParent()
      end
    end
  elseif ChildrenNum < ShouldKeepCount then
    for i = ChildrenNum, ShouldKeepCount do
      self.ScrollBox:AddChild(UIManager:CreateWidget(WidgetClass, false))
    end
  end
  AllChildren = self.ScrollBox:GetAllChildren():ToTable()
  for i = 1, #AllChildren do
    if Groups[i] then
      Groups[i].Owner = Groups[i].Owner or self.Owner
      AllChildren[i]:OnListItemObjectSet(Groups[i])
      AllChildren[i]:SetVisibility(UIConst.VisibilityOp.Visible)
    else
      AllChildren[i]:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  self:InitNavigationRules()
end

function M:InitNavigationRules()
  local AllChildren = self.ScrollBox:GetAllChildren():ToTable()
  for i = 1, #AllChildren do
    if AllChildren[i - 1] and AllChildren[i - 1]:IsVisible() then
      AllChildren[i]:SetNavigationRuleCustom(EUINavigation.Up, function(Dir)
        return AllChildren[i - 1]:GetWidgetForNavDir(EUINavigation.Up)
      end)
    else
      AllChildren[i]:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Escape)
    end
    if AllChildren[i + 1] and AllChildren[i + 1]:IsVisible() then
      AllChildren[i]:SetNavigationRuleCustom(EUINavigation.Down, function(Dir)
        return AllChildren[i + 1]:GetWidgetForNavDir(EUINavigation.Down)
      end)
    else
      AllChildren[i]:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Escape)
    end
    AllChildren[i].BP_OnAddedToFocusPath:Clear()
    AllChildren[i].BP_OnAddedToFocusPath:Add(self, self.OnGroupAddedToFocusPath)
  end
end

function M:GetGroupWidget(GroupIndex)
  return self.ScrollBox:GetChildAt(GroupIndex + 1)
end

function M:GetItemWidget(GroupIndex, ItemIndex)
  local Widget = self.ScrollBox:GetChildAt(GroupIndex + 1)
  if Widget then
    return Widget:GetItemWidget(ItemIndex)
  end
end

function M:ResetValue()
  local AllChildren = self.ScrollBox:GetAllChildren():ToTable()
  for i = 1, #AllChildren do
    if AllChildren[i]:IsVisible() then
      AllChildren[i]:ResetValue()
    end
  end
end

function M:IsValueChanged()
  local AllChildren = self.ScrollBox:GetAllChildren():ToTable()
  for i = 1, #AllChildren do
    if AllChildren[i]:IsVisible() and AllChildren[i]:IsValueChanged() then
      return true
    end
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget())
end

function M:OnGroupAddedToFocusPath(GroupWidget)
  rawset(self, "FocusedGroupIndex", nil)
  local GroupIndex = self.ScrollBox:GetChildIndex(GroupWidget)
  if GroupIndex >= 0 then
    rawset(self, "FocusedGroupIndex", GroupIndex)
  end
end

function M:GetDesiredFocusTarget()
  local Widget
  if rawget(self, "FocusedGroupIndex") then
    Widget = self.ScrollBox:GetChildAt(self.FocusedGroupIndex)
  end
  Widget = Widget or self.ScrollBox:GetChildAt(0)
  return Widget:GetDesiredFocusTarget()
end

return M
