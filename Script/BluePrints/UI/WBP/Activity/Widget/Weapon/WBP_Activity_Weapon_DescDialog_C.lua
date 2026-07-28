require("UnLua")
local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  if not Params or not IsValid(self.ListBuffDes) then
    return
  end
  self.ListBuffDes:ClearListItems()
  for _, AffixId in ipairs(Model.GetGroupAffixIds(Params.GroupId)) do
    local Cfg = Model.GetAffixCfg(AffixId)
    if Cfg then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.IconPath = Cfg.IconPath
      Content.Name = Cfg.Name and GText(Cfg.Name) or ""
      Content.Desc = Cfg.Desc and GText(Cfg.Desc) or ""
      Content.Owner = self
      self.ListBuffDes:AddItem(Content)
    end
  end
  self:ShowGamepadCloseBtn(true)
  self.ListBuffDes:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.ListBuffDes:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.ListBuffDes:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.ListBuffDes:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.ListBuffDes:SetFocus()
end

function M:InitGamepadView()
  self:FocusListDeferred()
end

function M:OnContentFocusReceived(_, _)
  if UIUtils.IsGamepadInput() and IsValid(self.ListBuffDes) and not self.ListBuffDes:HasAnyUserFocus() and not self.ListBuffDes:HasFocusedDescendants() then
    local Idx = self.GamepadFocusedIndex or 0
    self.ListBuffDes:NavigateToIndex(Idx)
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:FocusListDeferred()
  self:AddTimer(0.05, function()
    if not IsValid(self.ListBuffDes) then
      return
    end
    local Num = self.ListBuffDes:GetNumItems()
    if Num <= 0 then
      return
    end
    local Idx = self.GamepadFocusedIndex or 0
    if Idx < 0 or Num <= Idx then
      Idx = 0
    end
    self.ListBuffDes:NavigateToIndex(Idx)
    self.ListBuffDes:SetFocus()
  end, false)
end

return M
