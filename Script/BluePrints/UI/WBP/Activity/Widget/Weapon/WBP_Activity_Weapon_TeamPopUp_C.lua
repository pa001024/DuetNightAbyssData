require("UnLua")
local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  if not Params then
    return
  end
  self.EventId = Params.EventId
  self.bShowEffects = true
  if IsValid(self.SwitchCheck) then
    self.SwitchCheck:SetChecked(true)
    self.SwitchCheck:AddEventOnCheckStateChanged(self, self.OnToggleChanged)
  end
  if IsValid(self.TextTips) then
    self.TextTips:SetText(GText("UI_WeaponVerify_ShowLevelBuff"))
  end
  self:RefreshList()
  self:InitGamepadKeys()
  if IsValid(self.ListRoom) then
    self.ListRoom:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.ListRoom:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.ListRoom:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.ListRoom:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.ListRoom:SetFocus()
  end
end

function M:InitGamepadKeys()
  self:ShowGamepadCloseBtn(true)
  self:RefreshToggleKeyImg(UIUtils.IsGamepadInput())
end

function M:RefreshToggleKeyImg(IsUseGamePad)
  if not IsValid(self.WBP_Com_KeyImg) then
    return
  end
  if IsUseGamePad then
    self.WBP_Com_KeyImg:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
    self.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.HitTestInvisible)
  else
    self.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:InitGamepadView()
  self:RefreshToggleKeyImg(true)
  self:HideDisplayedResetGamepadIcons()
  self:FocusListDeferred()
end

function M:InitKeyboardView()
  self:RefreshToggleKeyImg(false)
  self:HideDisplayedResetGamepadIcons()
end

function M:OnDestroyed()
  if IsValid(self.SwitchCheck) then
    self.SwitchCheck:RemoveEventOnCheckStateChanged(self)
  end
  M.Super.OnDestroyed(self)
end

function M:OnContentFocusReceived(_, _)
  if UIUtils.IsGamepadInput() and IsValid(self.ListRoom) and not self.ListRoom:HasAnyUserFocus() and not self.ListRoom:HasFocusedDescendants() then
    self:HideDisplayedResetGamepadIcons()
    local Idx = self.GamepadFocusedIndex or 0
    self.ListRoom:NavigateToIndex(Idx)
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:FocusListDeferred()
  self:AddTimer(0.05, function()
    if not IsValid(self.ListRoom) then
      return
    end
    local Num = self.ListRoom:GetNumItems()
    if Num <= 0 then
      return
    end
    self:HideDisplayedResetGamepadIcons()
    local Idx = self.GamepadFocusedIndex or 0
    if Idx < 0 or Num <= Idx then
      Idx = 0
    end
    self.ListRoom:NavigateToIndex(Idx)
    self.ListRoom:SetFocus()
  end, false)
end

function M:HideDisplayedResetGamepadIcons()
  if not IsValid(self.ListRoom) then
    return
  end
  local Entries = self.ListRoom:GetDisplayedEntryWidgets()
  if not Entries then
    return
  end
  for _, Entry in pairs(Entries) do
    if IsValid(Entry) and Entry.SetResetGamepadVisible then
      Entry.bHasGamepadFocus = false
      Entry:SetResetGamepadVisible(false)
    end
  end
end

function M:HandleGamepadKey(InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.SpecialRight or InKeyName == Const.GamepadSpecialRight then
      local NewState = not self.bShowEffects
      if IsValid(self.SwitchCheck) then
        self.SwitchCheck:SetChecked(NewState)
      end
      self:OnToggleChanged(NewState)
      return true
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom or InKeyName == Const.GamepadFaceButtonDown then
      local Item = self.GamepadFocusedItem
      if IsValid(Item) and Item.CanReset and Item:CanReset() then
        Item:OnBtnResClicked()
      end
      return true
    end
  end
  return false
end

function M:OnContentPreviewKeyDown(_, InKeyEvent)
  return self:HandleGamepadKey(InKeyEvent)
end

function M:OnToggleChanged(bChecked)
  if self.bShowEffects == bChecked then
    return
  end
  self.bShowEffects = bChecked
  self:RefreshList()
end

function M:RefreshList()
  if not IsValid(self.ListRoom) then
    return
  end
  self.ListRoom:ClearListItems()
  for _, Cfg in ipairs(Model.GetLevelList(self.EventId)) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.EventId = self.EventId
    Content.DungeonId = Cfg.EventLevelId
    Content.IndexText = Model.GetLevelNumber(Cfg.EventLevelId)
    Content.bShowEffects = self.bShowEffects
    Content.Owner = self
    self.ListRoom:AddItem(Content)
  end
end

function M:RequestReset(DungeonId)
  UIManager(self):ShowCommonPopupUI_Push(100409, {
    DungeonId = DungeonId,
    ShortText = GText("UI_WeaponVerify_Reset_tips1"),
    RightCallbackFunction = function()
      Model.ResetDungeon(self.EventId, DungeonId, function(ErrCode)
        if 0 ~= ErrCode then
          UIManager(self):ShowError(ErrCode, 1.0, "CommonToastMain")
          return
        end
        self:RefreshList()
        local LevelName = Model.GetLevelName(DungeonId)
        UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_WeaponVerify_ResetFinish"), LevelName), 1.5)
        if UIUtils.IsGamepadInput() then
          self:FocusListDeferred()
        end
      end)
    end
  })
end

return M
