require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.BtnSelect.OnClicked:Add(self, self.OnClickSelected)
  self.BtnSelect.OnHovered:Add(self, self.OnHovered)
  self.BtnSelect.OnUnhovered:Add(self, self.OnUnhovered)
  self.BtnItem.OnClicked:Add(self, self.OnClickSelected)
end

function M:Destruct()
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.UI = self
  if Content.Rec ~= "Entrust" then
    self:StopAllAnimations()
    if Content.bClick then
      if self.Content.IsMultiSelectable then
        self.Content.ParentWidget:RefreshBigReward(self.Content.Id, self.Content.bClick)
      end
      self:PlayAnimation(self.Click)
    else
      self:PlayAnimation(self.Normal)
    end
  end
  if Content.Rec == "Entrust" and 0 == Content.Count then
    self:StopAllAnimations()
    self:PlayAnimation(self.Folded)
  end
  Content.bHover = false
  self.Item_S:Init(Content)
  if self.bShouldPlayNormal then
    self.Item_S.Item:StopAllAnimations()
    self.Item_S.Item:PlayAnimation(self.Item_S.Item.Normal)
    self.bShouldPlayNormal = false
  end
  if self.Content.IsMultiSelectable then
    self.Item_S:BindEvents(self, {
      OnMenuOpenChanged = self.OnStuffMenuOpenChanged
    })
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
  self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:OnClickSelected()
  if self.Content.Rec == "Reward" then
    if self.Content and self.Content.ParentWidget then
      if self.Content.ParentWidget.CurReward then
        if self.Content.ParentWidget.CurReward.UI then
          self.Content.ParentWidget.CurReward.UI:StopAllAnimations()
          self.Content.ParentWidget.CurReward.UI:PlayAnimation(self.Content.ParentWidget.CurReward.UI.Normal)
        end
        self.Content.ParentWidget.CurReward.bClick = false
      end
      if self.Content.IsMultiSelectable then
        self.Content.bClick = not self.Content.bClick
        if self.Content.bClick then
          if self.Content.ParentWidget.CurClickRewardItem and self.Content.ParentWidget.CurClickRewardItem ~= self.Content then
            self.Content.ParentWidget.CurClickRewardItem.SelfWidget:SetSelected(false)
          end
          self.Content.ParentWidget.CurClickRewardItem = self.Content
          self.Content.SelfWidget:SetSelected(false)
          self:StopAllAnimations()
          self:PlayAnimation(self.Click)
          AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
        else
          self:StopAllAnimations()
          AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
          self:PlayAnimation(self.Normal)
          AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
        end
        self.Content.ParentWidget:RefreshBigReward(self.Content.Id, self.Content.bClick)
      else
        if self.Content.ParentWidget.CurClickRewardItem and self.Content.ParentWidget.CurClickRewardItem ~= self.Content then
          self.Content.ParentWidget.CurClickRewardItem.SelfWidget:SetSelected(false)
        end
        self.Content.ParentWidget.CurClickRewardItem = self.Content
        self.Content.SelfWidget:SetSelected(false)
        self.Content.bClick = true
        self.Content.ParentWidget.CurReward = self.Content
        self.Content.ParentWidget.GamepadReward = self.Content
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
        self:PlayAnimation(self.Click)
        self.Content.ParentWidget:RefreshBigReward(self.Content.Id)
      end
    end
  elseif self.Content.Rec == "Entrust" then
    if 0 == self.Content.Count then
      UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AsyncCombat_ManualInsufficient"))
      return
    end
    if self.Content and self.Content.ParentWidget then
      if self.Content.ParentWidget.Entrust then
        if self.Content.ParentWidget.Entrust.UI and self.Content.ParentWidget.Entrust ~= self.Content then
          self.Content.ParentWidget.Entrust.UI:StopAllAnimations()
          self.Content.ParentWidget.Entrust.UI:PlayAnimation(self.Content.ParentWidget.Entrust.UI.Normal)
        end
        self.Content.ParentWidget.Entrust.bClick = false
      end
      if self.Content.ParentWidget.CurClickEntrustItem and self.Content.ParentWidget.CurClickEntrustItem ~= self.Content then
        self.Content.ParentWidget.CurClickEntrustItem.SelfWidget:SetSelected(false)
      end
      self.Content.ParentWidget.CurClickEntrustItem = nil
      if 0 ~= self.Content.Count then
        self.Content.SelfWidget:SetSelected(false)
      end
      self.Content.bClick = true
      self.Content.ParentWidget.GamepadEntrust = self.Content
      self.Content.ParentWidget.Entrust = self.Content
      self:StopAllAnimations()
      self:PlayAnimation(self.Click)
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
      self.Content.ParentWidget:UpdateSelectBtn(false)
      self.Content.ParentWidget:RefreshBigReward(nil)
    end
  end
end

function M:OnBtnItemClickSelected()
  if self.Content.Rec == "Reward" and self.Content.IsMultiSelectable and self.Item_S.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() == false then
    self.Item_S:OpenItemMenu()
  end
end

function M:OnHovered()
  if self.Content.Rec == "Entrust" and 0 == self.Content.Count then
    return
  end
  if not self.Content.bClick then
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
    self.Content.bHover = true
  end
end

function M:OnUnhovered()
  if self.Content.Rec == "Entrust" and 0 == self.Content.Count then
    return
  end
  if not self.Content.bClick and self.Content.bHover then
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
    self.Content.bHover = false
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self.UsingGamepad = false
    self.BtnItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.UsingGamepad = true
    if self.Content and self.Content.IsMultiSelectable then
      self:SetNavigationRuleCustom(EUINavigation.Up, {
        self,
        self.HandleNavigationUp
      })
      self:SetNavigationRuleCustom(EUINavigation.Down, {
        self,
        self.HandleNavigationDown
      })
    end
    self.BtnItem:SetVisibility(UE4.ESlateVisibility.Visible)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if not self.UsingGamepad then
    return UIUtils.UnHandled
  end
  if self.Content.IsMultiSelectable then
    self:SetFocus()
    return UIUtils.Handled
  end
  if self.Content.Rec == "Reward" then
    if self.Content.ParentWidget and self.Content.ParentWidget.GamepadEntrust and not self.Content.ParentWidget.GamepadEntrust.bClick and self.Content.ParentWidget.GamepadEntrust.bHover then
      self.Content.ParentWidget.GamepadEntrust.UI:PlayAnimation(self.Content.ParentWidget.GamepadEntrust.UI.UnHover)
      self.Content.ParentWidget.GamepadEntrust.bHover = false
    end
    if self.Content.ParentWidget and self.Content.ParentWidget.GamepadReward and not self.Content.ParentWidget.GamepadReward.bClick and self.Content.ParentWidget.GamepadReward.bHover then
      self.Content.ParentWidget.GamepadReward.UI:PlayAnimation(self.Content.ParentWidget.GamepadReward.UI.UnHover)
      self.Content.ParentWidget.GamepadReward.bHover = false
    end
    self.Content.ParentWidget.GamepadReward = self.Content
    if not self.Content.bClick then
      self:PlayAnimation(self.Hover)
      self.Content.bHover = true
    end
    if self.Content.ParentWidget.RefreshTips then
      self.Content.ParentWidget:RefreshTips(self.Content)
    end
  else
    if self.Content.ParentWidget and self.Content.ParentWidget.GamepadReward and not self.Content.ParentWidget.GamepadReward.bClick and self.Content.ParentWidget.GamepadReward.bHover then
      self.Content.ParentWidget.GamepadReward.UI:PlayAnimation(self.Content.ParentWidget.GamepadReward.UI.UnHover)
      self.Content.ParentWidget.GamepadReward.bHover = false
    end
    if self.Content.ParentWidget and self.Content.ParentWidget.GamepadEntrust and not self.Content.ParentWidget.GamepadEntrust.bClick and self.Content.ParentWidget.GamepadEntrust.bHover then
      self.Content.ParentWidget.GamepadEntrust.UI:PlayAnimation(self.Content.ParentWidget.GamepadEntrust.UI.UnHover)
      self.Content.ParentWidget.GamepadEntrust.bHover = false
    end
    self.Content.ParentWidget.GamepadEntrust = self.Content
    if not self.Content.bClick and 0 ~= self.Content.Count then
      self:PlayAnimation(self.Hover)
      self.Content.bHover = true
    end
    self.Content.ParentWidget:RefreshTips(self.Content)
  end
  return UIUtils.Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_LeftThumbstick" == InKeyName then
    if self.Content.IsMultiSelectable then
      return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    if self.Content.ParentWidget and self.Content.ParentWidget.RefreshTips then
      self.Content.ParentWidget:RefreshTips(self.Content)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif InKeyName == Const.GamepadRightThumbstick and self.Content.IsMultiSelectable then
    self:OnBtnItemClickSelected()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_FaceButton_Bottom" == InKeyName then
    if self.MenuIsOpen then
      return UE4.UWidgetBlueprintLibrary.Unhandled()
    else
      self:OnClickSelected()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:HandleNavigationUp()
  return self
end

function M:HandleNavigationDown()
  if self.Content and self.Content.IsMultiSelectable then
    if not self.Content.ParentWidget then
      return self
    end
    local nextWBox = self.Content.ParentWidget:GetNextWrapBox()
    self.Content.ParentWidget.Owner:HideGamepadShortcut(1)
    if nextWBox then
      if nextWBox:GetChildrenCount() > 0 then
        local nextItem = nextWBox:GetChildAt(0)
        return nextItem
      end
      return nextWBox
    end
  end
  return self
end

function M:SetUsingGamepad(UsingGamepad)
  self.UsingGamepad = UsingGamepad
  if self.UsingGamepad then
    if not self.Content.bClick then
      self:StopAllAnimations()
      self:PlayAnimation(self.Hover)
    end
  elseif not self.Content.bClick then
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
  end
end

function M:OnStuffMenuOpenChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  if not self.Content.IsMultiSelectable then
    return
  end
  self.MenuIsOpen = bIsOpen
  if bIsOpen then
    self.Content.ParentWidget.Owner:HideAllGamepadShortcut()
  else
    self.Content.ParentWidget.Owner:ShowAllGamepadShortcut()
  end
end

function M:BP_OnEntryReleased()
  if self.Item_S and self.Item_S.Item and self.Item_S.Item.Normal then
    self.bShouldPlayNormal = true
  end
end

return M
