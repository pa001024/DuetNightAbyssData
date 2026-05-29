local Component = {}
local ModModel = ModController:GetModel()

function Component:InitGamePad()
  if ModController:IsMobile() then
    self.Key_Reward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Reward.Img:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:AddTimer(0.1, function()
      self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end)
  end
  if self.Key_Reward then
    self.Key_Reward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if self.CurInputDeviceType ~= ECommonInputType.Touch then
      self.Key_Reward:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "Y"}
        }
      })
    else
      self.Key_Reward.Img:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  self.Common_PolarityList_PC.Key_LT:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
  self.Key_Search:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RS"}
    }
  })
  if self.Key_Rewards then
    self.Key_Rewards:CreateGamepadKey("View")
  end
  self.Sift.Img_Key_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:InitGamePadNavigation()
end

function Component:Handle_OnGamePadDown(InKeyName)
  DebugPrint("ayff test  Handle_OnGamePadDown", InKeyName, self:GetName())
  if "Gamepad_DPad_Up" == InKeyName or "Gamepad_LeftStick_Up" == InKeyName then
    return true
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if self.IsInViewTips and self.CurItemWidget then
      DebugPrint("返回聚焦：", self.CurItemWidget:GetName())
      self.CurItemWidget:SetFocus()
      self.IsInViewTips = false
      self.Owner:SwitchComKeyTipsState(7)
    elseif self.IsInPolarityView or self.IsInSearchView then
      self.IsInPolarityView = false
      self.IsInSearchView = false
      if self.CurItemWidget then
        self.CurItemWidget:SetFocus()
      else
        self:SetFocus()
      end
      self.Owner:SwitchComKeyTipsState(7)
      self.Common_PolarityList_PC.Key_LT:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.Key_Search:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif self.Widgets[self.CurGroupIndex] and self.Widgets[self.CurGroupIndex].RewardInFocus then
      self.Widgets[self.CurGroupIndex].RewardInFocus = false
      if self.CurItemWidget then
        self.CurItemWidget:SetFocus()
        self.Widgets[self.CurGroupIndex]:SetRewardTextVisibility(true)
        self.IsInViewRewards = false
        self.Owner:SwitchComKeyTipsState(7)
      end
    else
      self.Owner:OnClose()
    end
    return true
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    self:OnClickModRewardTips()
    return true
  elseif "Gamepad_FaceButton_Left" == InKeyName then
    return true
  elseif "Gamepad_RightThumbstick" == InKeyName then
    self.IsInSearchView = true
    self.Com_Search:SetFocus()
    self.Key_Search:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.IsInPolarityView then
      self.Common_PolarityList_PC.Key_LT:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.IsInPolarityView = false
    end
    self.Owner:SwitchComKeyTipsState(8)
    return true
  elseif "Gamepad_LeftThumbstick" == InKeyName then
    self.IsInPolarityView = true
    self.Common_PolarityList_PC.List:NavigateToIndex(0)
    self.Common_PolarityList_PC.Key_LT:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.IsInSearchView then
      self.Key_Search:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Owner:SwitchComKeyTipsState(7)
      self.IsInSearchView = false
    end
    return true
  elseif "Gamepad_LeftTrigger" == InKeyName then
    self.ArchiveTab:TabToLeft()
    return true
  elseif "Gamepad_RightTrigger" == InKeyName then
    self.ArchiveTab:TabToRight()
    return true
  elseif "Gamepad_Special_Left" == InKeyName then
    if self.CanFocusTips and not self.IsInViewTips and #self.Access > 0 and not self.IsInViewRewards then
      self.IsInViewTips = true
      self.Access[1]:SetFocus()
      self.Owner:SwitchComKeyTipsState(3)
    end
    return true
  end
  return false
end

function Component:Handle_OnGamePadUp(InKeyName)
  DebugPrint("zwkkk  Handle_OnGamePadUp", InKeyName, self:GetName())
  if "Gamepad_FaceButton_Bottom" == InKeyName then
    return true
  end
  return false
end

function Component:OnResourceBarAddedToFocusPath()
  DebugPrint("zwkkkkk OnResourceBarAddedToFocusPath")
  self:EnterResourceSelectMode()
end

function Component:OnResourceBarRemovedFromFocusPath()
  DebugPrint("zwkkkkk OnResourceBarRemovedFromFocusPath")
  self:ExitResourceSelectMode()
end

function Component:EnterResourceSelectMode()
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self.ArchiveTab.Key_Left:SetVisibility(UIConst.VisibilityOp.Hidden)
    self.ArchiveTab.Key_Right:SetVisibility(UIConst.VisibilityOp.Hidden)
  end
end

function Component:ExitResourceSelectMode()
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self.ArchiveTab.Key_Left:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.ArchiveTab.Key_Right:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function Component:OnPolaritySelectionChanged(Content, bIsSelected)
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    return
  end
  if false == bIsSelected then
    return
  end
  if Content and Content.Entry and Content.Entry.OnBtnClick then
    Content.Entry:OnBtnClick(true)
  end
end

function Component:UpdateOnInputDeviceTypeChange()
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:SwitchToGamePad()
    self.List_Item.BP_OnItemSelectionChanged:Add(self, self.OnItemSelectionChange)
    self.Common_PolarityList_PC.List.BP_OnItemSelectionChanged:Remove(self, self.OnPolaritySelectionChanged)
    self.Common_PolarityList_PC.List.BP_OnItemSelectionChanged:Add(self, self.OnPolaritySelectionChanged)
  elseif self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
    self:SwitchToPC()
    self.List_Item.BP_OnItemSelectionChanged:Remove(self, self.OnItemSelectionChange)
    self.Common_PolarityList_PC.List.BP_OnItemSelectionChanged:Remove(self, self.OnPolaritySelectionChanged)
    self:AddDelayFrameFunc(function()
      self.Key_Reward.Img:SetVisibility(ESlateVisibility.Collapsed)
    end, 3, "DelaySetFocus")
  end
end

function Component:SwitchToGamePad()
  self.Key_Reward.Img:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.List_Item:SetFocus()
  self.List_Item:NavigateToIndex(0)
  self.Common_PolarityList_PC.Key_LT:SetVisibility(UIConst.VisibilityOp.Visible)
  self.IsInPolarityView = false
  if self.Key_Rewards then
    self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  self.Key_Search:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function Component:SwitchToPC()
  self.Key_Reward.Img:SetVisibility(ESlateVisibility.Collapsed)
  self.Common_PolarityList_PC.Key_LT:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.Key_Rewards then
    self.Key_Rewards:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.Key_Search:SetVisibility(ESlateVisibility.Collapsed)
end

function Component:InitGamePadNavigation()
  self.Common_PolarityList_PC:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Common_PolarityList_PC:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Common_PolarityList_PC:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Common_PolarityList_PC:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Com_Search:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Com_Search:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Com_Search:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Com_Search:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    function()
      self.Sift:SetFocus()
    end
  })
  self.Sift:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Sift:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Sift:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function()
      self.Com_Search:SetFocus()
    end
  })
  self.Sift:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

return Component
