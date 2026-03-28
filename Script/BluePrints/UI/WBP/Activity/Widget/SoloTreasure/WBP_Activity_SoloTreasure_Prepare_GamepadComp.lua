local Component = {}

function Component:InitGamePad()
  if ModController:IsMobile() then
    return
  end
  self.Btn_Start.Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.Btn_Clear.Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    }
  })
  self.Listing.Key_Controller_L:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LB"}
    }
  })
  self.Listing.Key_Controller_R:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RB"}
    }
  })
  self.Listing.Key_L:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = "Q"}
    }
  })
  self.Listing.Key_R:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = "E"}
    }
  })
  self.Preview.Btn_Bag.Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  self.CurInputDeviceType = CurInputDevice
  if CurInputDevice == ECommonInputType.Touch then
    self.Listing.Switch_Mode_L:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Listing.Switch_Mode_R:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
  if self.IsUseGamePad then
    self.Btn_Clear.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Start.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Btn_Clear.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Start.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self:GetVisibility() == UE4.ESlateVisibility.Collapsed then
    return
  end
  self:SetDefaultFocus()
end

function Component:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightY" == InKeyName then
    if not IsValid(self.Preview) then
      return
    end
    local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 30
    local CurScrollOffset = self.Preview.EMScrollBox_1:GetScrollOffset()
    local ScrollOffset = math.clamp(CurScrollOffset - a, 0, self.Preview.EMScrollBox_1:GetScrollOffsetOfEnd())
    self.Preview.EMScrollBox_1:SetScrollOffset(ScrollOffset)
  end
  return UWidgetBlueprintLibrary.Unhandled()
end

function Component:HandleGamepadInput(InKeyName)
  local IsHandled = false
  DebugPrint("jly     FocusMode: " .. self.FocusMode)
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
    if "Gamepad_Special_Right" == InKeyName then
      self:OnClearClicked()
      IsHandled = true
    elseif "Gamepad_FaceButton_Left" == InKeyName then
      self:OnStartClicked()
      IsHandled = true
    elseif "Gamepad_FaceButton_Top" == InKeyName then
      if self.FocusWidget then
        self.FocusWidget:OnMinusClicked()
      end
      IsHandled = true
    elseif "Gamepad_FaceButton_Right" == InKeyName then
      self:OnReturnKeyDown()
      IsHandled = true
    elseif "Gamepad_RightThumbstick" == InKeyName then
      if self.Root.Com_Tab.WBP_Com_Tab_ResourceBar then
        self.Root.Com_Tab.WBP_Com_Tab_ResourceBar:SetFocus()
      end
      IsHandled = true
      self:ChangeFocusMode(5)
      self.Root.Com_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(self.FocusWidget)
      self.Root.Com_Tab.WBP_Com_Tab_ResourceBar:SetGetReplyOnBack(function()
        self:ChangeFocusMode(1)
      end)
    end
  elseif 2 == self.FocusMode then
    if "Gamepad_FaceButton_Right" == InKeyName then
      self.FocusWidget:SetFocus()
      IsHandled = true
      self:ChangeFocusMode(1)
    end
  elseif 3 == self.FocusMode then
    if "Gamepad_FaceButton_Right" == InKeyName then
      self.FocusWidget:SetFocus()
      IsHandled = true
      self:ChangeFocusMode(1)
    end
  elseif 4 == self.FocusMode then
    if "Gamepad_FaceButton_Right" == InKeyName then
      IsHandled = true
      self.List_Select:SetFocus()
      self:ChangeFocusMode(2)
    end
  elseif 6 == self.FocusMode then
    if "Gamepad_FaceButton_Right" == InKeyName then
      IsHandled = true
      self.Build.Bag.Btn_Click:SetFocus()
      self:ChangeFocusMode(1)
      self.Build.Bag:SetVisibility(UE4.ESlateVisibility.Visible)
    elseif "Gamepad_FaceButton_Left" == InKeyName then
      IsHandled = true
      self:OnPreviewBagClicked()
    end
  elseif 7 == self.FocusMode then
    if "Gamepad_FaceButton_Right" == InKeyName then
      IsHandled = true
      self:CloseTips()
      self:ChangeFocusMode(2)
      self.Listing.TileView_Select_Role:SetFocus()
    elseif "Gamepad_FaceButton_Left" == InKeyName then
      IsHandled = true
      if self.CurGamepadArea == "Tip" then
        if self.CurSlotType == "Pet" then
          self:MakeSureCallback()
        elseif self.SquadItemTip then
          self:MakeSureCallback(self.SquadItemTip.Edit_Tips.SelectModIndex)
        end
      end
      self:ChangeFocusMode(2)
      self.Listing.TileView_Select_Role:SetFocus()
    elseif "Gamepad_Special_Left" == InKeyName then
      IsHandled = true
      self:GoToArmory()
    end
  end
  return IsHandled
end

function Component:SetDefaultFocus()
  self:ChangeFocusMode(1)
  self.FocusWidget = self.Build.Character
  self.Build.Character:SetFocus()
end

function Component:RestoreFocusOnReturn()
  if 6 == self.FocusMode then
    local TargetIndex = self.LastSelectedBagItemUIIndex
    if not TargetIndex and self.ChooseBagContent then
      TargetIndex = self.ChooseBagContent.Index
    end
    if not TargetIndex and self.TeamInfos then
      TargetIndex = self.TeamInfos.BagIndex
    end
    TargetIndex = TargetIndex or 1
    self:AddTimer(0.1, function()
      local BagContent = self.List_Bag:GetItemAt(TargetIndex - 1)
      if BagContent and not BagContent.IsEmpty and BagContent.UI then
        BagContent.UI:SetFocus()
        self.List_Bag:NavigateToIndex(TargetIndex - 1)
      else
        self.List_Bag:SetFocus()
      end
    end)
  elseif 7 == self.FocusMode then
    self:ChangeFocusMode(2)
    self:AddTimer(0.2, function()
      self.FocusWidget:SetFocus()
    end)
  end
end

function Component:UpdateBottomKeyInfo(FocusMode)
  if ModController:IsMobile() then
    return
  end
  local BottomKeyInfo = {}
  if 1 == FocusMode then
    if not self.FocusWidget.IsEmpty then
      BottomKeyInfo = {
        {
          GamePadInfoList = {
            {Type = "Img", ImgShortPath = "Y"}
          },
          Desc = GText("UI_CTL_Clear"),
          bLongPress = false
        },
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
    else
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
  elseif 6 == FocusMode then
    if self.Preview.EMScrollBox_1:GetScrollOffsetOfEnd() > 0 then
      BottomKeyInfo = {
        {
          GamePadInfoList = {
            {Type = "Img", ImgShortPath = "RV"}
          },
          Desc = GText("UI_Controller_Slide"),
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
    else
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
    end
  elseif 7 == FocusMode then
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_CTL_Select"),
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

function Component:UpdateGamepadKeyInfoByHasItem(HasItem)
  local BottomKeyInfo = {}
  if HasItem then
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "Y"}
        },
        Desc = GText("UI_CTL_Clear"),
        bLongPress = false
      },
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
  else
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
  if 1 == FocusMode and self.IsUseGamePad then
    self.Btn_Start.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Clear.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Listing.Sort:SetControllerKeyHidden(true)
  else
    self.Btn_Start.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Clear.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if 2 == FocusMode and self.IsUseGamePad then
    self.Listing.Sort:SetControllerKeyHidden(false)
  end
  if 6 == FocusMode then
    self.Preview.Btn_Bag.Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Preview.Btn_Bag.Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function Component:ChangeFocusMode(FocusMode)
  self.FocusMode = FocusMode
  self:UpdateBottomKeyInfo(self.FocusMode)
  self:UpdateGamepadKeyInfo(self.FocusMode)
end

function Component:InitNavigation()
  self.List_Select:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function()
      self:ChangeFocusMode(3)
      return self.EMListView_Filter
    end
  })
  self.EMListView_Filter:SetNavigationRuleCustom(EUINavigation.Right, {
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
end

function Component:SetFocus_Lua()
  if 4 == self.FocusMode then
    self:ChangeFocusMode(2)
    self.List_Select:SetFocus()
    return
  end
end

return Component
