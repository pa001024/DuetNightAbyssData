local Component = {}

function Component:InitGamePad()
  if ModController:IsMobile() then
    return
  end
  self.Btn_Save.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.Btn_Clear.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
  self.Btn_SwitchMod.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self.Key_Controller_L:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LB"}
    }
  })
  self.Key_Controller_R:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RB"}
    }
  })
  self.Key_L:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = "Q"}
    }
  })
  self.Key_R:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = "E"}
    }
  })
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    self.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self:SetDefaultFocus()
  self.IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
  if self.IsUseGamePad then
    self.Btn_Save.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Clear.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_SwitchMod.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Switch_Mode_L:SetActiveWidgetIndex(1)
    self.Switch_Mode_R:SetActiveWidgetIndex(1)
  else
    self.Btn_Save.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Clear.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_SwitchMod.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Switch_Mode_L:SetActiveWidgetIndex(0)
    self.Switch_Mode_R:SetActiveWidgetIndex(0)
    self.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

function Component:HandleGamepadInput(InKeyName)
  local IsHandled = false
  if self.IsTabPrimaryVisible and 1 ~= self.FocusMode then
    if "Gamepad_LeftShoulder" == InKeyName then
      self.Type_Melee:OnBtnClicked()
      IsHandled = true
      self.List_Select:NavigateToIndex(0)
      return IsHandled
    elseif "Gamepad_RightShoulder" == InKeyName then
      self.Type_Range:OnBtnClicked()
      IsHandled = true
      self.List_Select:NavigateToIndex(0)
      return IsHandled
    end
  end
  if (3 == self.FocusMode or 2 == self.FocusMode) and "Gamepad_LeftThumbstick" == InKeyName and not self.bListEmpty then
    self:ChangeFocusMode(4)
    self.Sort:SetFocus()
    IsHandled = true
    return IsHandled
  end
  if 1 == self.FocusMode then
    if "Gamepad_FaceButton_Left" == InKeyName then
      self:OnSaveClicked()
      IsHandled = true
    elseif "Gamepad_LeftThumbstick" == InKeyName then
      self:OnClearClicked()
      IsHandled = true
    elseif "Gamepad_FaceButton_Top" == InKeyName then
      self:OnSwitchModClicked()
      IsHandled = true
    elseif "Gamepad_FaceButton_Right" == InKeyName then
      self:OnReturnKeyDown()
      IsHandled = true
    end
  end
  if 2 == self.FocusMode and "Gamepad_FaceButton_Right" == InKeyName then
    self.FocusWidget:SetFocus()
    IsHandled = true
    self:ChangeFocusMode(1)
  end
  if 3 == self.FocusMode and "Gamepad_FaceButton_Right" == InKeyName then
    self.FocusWidget:SetFocus()
    IsHandled = true
    self:ChangeFocusMode(1)
  end
  if 4 == self.FocusMode and "Gamepad_FaceButton_Right" == InKeyName then
    IsHandled = true
    self.List_Select:SetFocus()
    self:ChangeFocusMode(2)
  end
  return IsHandled
end

function Component:SetDefaultFocus()
  self:ChangeFocusMode(1)
  if self.FocusWidget then
    self.FocusWidget:SetFocus()
    return
  end
  self.Character:SetFocus()
end

function Component:UpdateBottomKeyInfo(FocusMode)
  local BottomKeyInfo = {}
  if 1 == FocusMode then
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Tips_Ensure"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Root.OnReturnKeyDown,
            Owner = self.Root
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  elseif 2 == FocusMode then
    if self.CurSlotType ~= "Char" then
      BottomKeyInfo = {
        {
          KeyInfoList = {
            {
              Type = "Text",
              Text = "Esc",
              ClickCallback = self.Root.OnReturnKeyDown,
              Owner = self.Root
            }
          },
          GamePadInfoList = {
            {Type = "Img", ImgShortPath = "B"}
          },
          Desc = GText("UI_BACK"),
          bLongPress = false
        }
      }
    else
      BottomKeyInfo = {
        {
          GamePadInfoList = {
            {Type = "Img", ImgShortPath = "A"}
          },
          Desc = GText("UI_CTL_Add/Remove"),
          bLongPress = false
        },
        {
          KeyInfoList = {
            {
              Type = "Text",
              Text = "Esc",
              ClickCallback = self.Root.OnReturnKeyDown,
              Owner = self.Root
            }
          },
          GamePadInfoList = {
            {Type = "Img", ImgShortPath = "B"}
          },
          Desc = GText("UI_BACK"),
          bLongPress = false
        }
      }
    end
  elseif 3 == FocusMode then
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Root.OnReturnKeyDown,
            Owner = self.Root
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  elseif 4 == FocusMode then
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Tips_Ensure"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Root.OnReturnKeyDown,
            Owner = self.Root
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  end
  self.Root.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function Component:UpdateGamepadKeyInfo(FocusMode)
  if 1 == FocusMode then
    self.Btn_Clear.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_SwitchMod.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Save.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Sort:SetControllerKeyHidden(true)
  elseif 2 == FocusMode then
    self.Btn_Clear.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_SwitchMod.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Save.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Sort:SetControllerKeyHidden(false)
  elseif 4 == FocusMode then
    self.Btn_Clear.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_SwitchMod.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Save.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Sort:SetControllerKeyHidden(false)
  end
end

function Component:ChangeFocusMode(FocusMode)
  self.FocusMode = FocusMode
  self:UpdateBottomKeyInfo(self.FocusMode)
  self:UpdateGamepadKeyInfo(self.FocusMode)
end

function Component:InitNavigation()
  self.List_Select:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    function()
      self:ChangeFocusMode(3)
      return self.EMListView_Filter
    end
  })
  self.EMListView_Filter:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function()
      if self.bListEmpty then
        return nil
      else
        self:ChangeFocusMode(2)
        return self.List_Select
      end
    end
  })
  self:AddTimer(0.2, function()
    if self.LastWidget then
      self.LastWidget:SetAllNavigationRules(EUINavigationRule.Escape, 0)
      self.LastWidget = nil
    end
    local Index = #self.FilteredContents
    local LastItem = self.List_Select:GetItemAt(Index - 1)
    if not LastItem or not LastItem.SelfWidget then
      return
    end
    local LastWidget = LastItem.SelfWidget
    LastWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.EMListView_Filter)
    self.LastWidget = LastWidget
  end, false, 0, "DelayInitNavigation", true)
end

function Component:SetFocus_Lua()
  if 4 == self.FocusMode then
    self:ChangeFocusMode(2)
    self.List_Select:SetFocus()
    return
  end
end

return Component
