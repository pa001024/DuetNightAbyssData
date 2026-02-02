require("UnLua")
local M = Class({
  "BluePrints.UI.Shop.WBP_Shop_Base_New_C"
})
M._components = {
  "BluePrints.UI.WBP.Gift.WBP_Gift_Shop_Main_BaseView"
}

function M:Construct()
end

function M:OnLoaded(...)
  return
end

function M:InitShopTabInfo(MainTabIdx, SubTabIdx, ShopType)
  return
end

function M:OnMainTabChanged(TabWidget)
  return
end

function M:OnSubTabChanged(TabWidget)
  return
end

function M:OnClickFilterOwned()
  return
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  return
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:OnGamePadDown(InKeyName) or false
  elseif "Escape" == InKeyName then
    self:CloseSelf()
    IsHandled = true
  elseif "Q" == InKeyName then
    local prevIdx = (not (self.ShopTab and self.ShopTab.GetCurrentTabIndex) or not self.ShopTab:GetCurrentTabIndex()) and self.ShopTab and self.ShopTab.CurrentTab
    if self.ShopTab and self.ShopTab.TabToLeft then
      self.ShopTab:TabToLeft()
      IsHandled = true
    end
    local nowIdx = (not (self.ShopTab and self.ShopTab.GetCurrentTabIndex) or not self.ShopTab:GetCurrentTabIndex()) and self.ShopTab and self.ShopTab.CurrentTab
    if prevIdx and nowIdx and prevIdx ~= nowIdx then
      self:FocusListAfterRefresh(0.12)
    end
  elseif "E" == InKeyName then
    local prevIdx = (not (self.ShopTab and self.ShopTab.GetCurrentTabIndex) or not self.ShopTab:GetCurrentTabIndex()) and self.ShopTab and self.ShopTab.CurrentTab
    if self.ShopTab and self.ShopTab.TabToRight then
      self.ShopTab:TabToRight()
      IsHandled = true
    end
    local nowIdx = (not (self.ShopTab and self.ShopTab.GetCurrentTabIndex) or not self.ShopTab:GetCurrentTabIndex()) and self.ShopTab and self.ShopTab.CurrentTab
    if prevIdx and nowIdx and prevIdx ~= nowIdx then
      self:FocusListAfterRefresh(0.12)
    end
  elseif "A" == InKeyName then
    local prevIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
    if self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.TabToLeft then
      self.Common_Toggle_TabGroup_PC:TabToLeft()
      IsHandled = true
    end
    local nowIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
    if prevIdx and nowIdx and prevIdx ~= nowIdx then
      self:FocusListAfterRefresh(0.12)
    end
  elseif "D" == InKeyName then
    local prevIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
    if self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.TabToRight then
      self.Common_Toggle_TabGroup_PC:TabToRight()
      IsHandled = true
    end
    local nowIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
    if prevIdx and nowIdx and prevIdx ~= nowIdx then
      self:FocusListAfterRefresh(0.12)
    end
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if "Gamepad_LeftTrigger" == InKeyName or "Gamepad_RightTrigger" == InKeyName then
    local prevIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
    if self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.Handle_KeyEventOnGamePad then
      IsEventHandled = self.Common_Toggle_TabGroup_PC:Handle_KeyEventOnGamePad(InKeyName)
    end
    local nowIdx = self.Common_Toggle_TabGroup_PC and self.Common_Toggle_TabGroup_PC.CurrentTab
    if prevIdx and nowIdx and prevIdx ~= nowIdx then
      self:FocusListAfterRefresh(0.12)
    end
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if not UIManager(self):GetUIObj("CommonDialog") then
      self:CloseSelf()
    end
    IsEventHandled = true
  elseif "Gamepad_RightShoulder" == InKeyName or "Gamepad_LeftShoulder" == InKeyName then
    local prevIdx = (not (self.ShopTab and self.ShopTab.GetCurrentTabIndex) or not self.ShopTab:GetCurrentTabIndex()) and self.ShopTab and self.ShopTab.CurrentTab
    if self.ShopTab and self.ShopTab.Handle_KeyEventOnGamePad then
      IsEventHandled = self.ShopTab:Handle_KeyEventOnGamePad(InKeyName)
    end
    local nowIdx = (not (self.ShopTab and self.ShopTab.GetCurrentTabIndex) or not self.ShopTab:GetCurrentTabIndex()) and self.ShopTab and self.ShopTab.CurrentTab
    if prevIdx and nowIdx and prevIdx ~= nowIdx then
      self:FocusListAfterRefresh(0.12)
    end
  elseif "Gamepad_FaceButton_Left" == InKeyName then
    if self.Gift_ShopTarget and self.Gift_ShopTarget.OnClick_Change then
      self.Gift_ShopTarget:OnClick_Change()
    end
    IsEventHandled = true
  elseif self.Common_Tab and self.Common_Tab.Handle_KeyEventOnGamePad then
    IsEventHandled = self.Common_Tab:Handle_KeyEventOnGamePad(InKeyName)
  elseif self.ShopTab and self.ShopTab.Handle_KeyEventOnGamePad then
    IsEventHandled = self.ShopTab:Handle_KeyEventOnGamePad(InKeyName)
  end
  return IsEventHandled
end

function M:OnAnimationFinished(InAnimation)
  return
end

function M:CloseSelf()
  return
end

function M:InitPayGiftPage(ShopItemsData)
  return
end

function M:UpdateShopDetail(GiftSubTabId)
  return
end

AssembleComponents(M)
return M
