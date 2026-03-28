local Component = {}
Component.FocusState = {
  Focus1 = 1,
  Focus2 = 2,
  Focus3 = 3,
  Focus4 = 4,
  Focus5 = 5
}

function Component:CanUseDifficultyDropdown()
  return self.CurMode == self.DungeonMode.Repeat and self.bHasDifficultyDropdown == true
end

function Component:UpdateRVOverflowFlag()
  local OldValue = self.bCanShowRV == true
  local Scroll = self.LevelDetails and self.LevelDetails.EMScrollBox_148
  if not Scroll then
    self.bCanShowRV = false
    return OldValue ~= self.bCanShowRV
  end
  local EndOffset = 0
  if Scroll.GetScrollOffsetOfEnd then
    EndOffset = Scroll:GetScrollOffsetOfEnd()
  end
  local kRVThreshold = 8.0
  self.bCanShowRV = nil ~= EndOffset and EndOffset > kRVThreshold
  return OldValue ~= self.bCanShowRV
end

function Component:SetFocusState(State)
  self.CurFocusState = State
  DebugPrint("------------------ 当前聚焦状态：", self.CurFocusState)
  self:RefreshKeyTips()
end

function Component:RefreshKeyTips()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if not self.Root or not self.TabConfigData then
    return
  end
  local BottomKeyInfo = {}
  if self.CurFocusState == self.FocusState.Focus1 then
    self:SetOtherKeyTipsEnabled(true)
    self:RefreshRuleTipKey()
    if self.bCanShowRV == true then
      DebugPrint("------------------- 显示UI_Controller_Slide")
      table.insert(BottomKeyInfo, {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "RV"}
        },
        Desc = GText("UI_Controller_Slide"),
        bLongPress = false
      })
    end
    table.insert(BottomKeyInfo, {
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
    })
    if BottomKeyInfo then
      self.TabConfigData.BottomKeyInfo = BottomKeyInfo
      self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
    end
  elseif self.CurFocusState == self.FocusState.Focus2 then
    self:SetOtherKeyTipsEnabled(false)
    self:RefreshRuleTipKey()
  elseif self.CurFocusState == self.FocusState.Focus3 then
    if not self:CanUseDifficultyDropdown() then
      self:SetFocusState(self.FocusState.Focus1)
      return
    end
    self:SetOtherKeyTipsEnabled(false)
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Tips_Ensure"),
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
    if BottomKeyInfo then
      self.TabConfigData.BottomKeyInfo = BottomKeyInfo
      self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
    end
    local Bar = self.Root.Com_Tab.WBP_Com_Tab_ResourceBar
    Bar:HideGamePadKey(true)
  elseif self.CurFocusState == self.FocusState.Focus4 then
    self.LevelDetails.Btn_Prepare.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  elseif self.CurFocusState == self.FocusState.Focus5 then
    self.LevelDetails.Btn_Prepare.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function Component:RefreshRuleTipKey()
  local RuleTipKey = self.LevelDetails.Controller_Qa
  if not RuleTipKey then
    return
  end
  if UIUtils.IsGamepadInput() and self.CurFocusState == self.FocusState.Focus1 and self:CanShowRuleTip() then
    RuleTipKey:SetIsEnabled(true)
    RuleTipKey:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    RuleTipKey:SetIsEnabled(false)
    RuleTipKey:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function Component:SetOtherKeyTipsEnabled(bEnabled)
  if self.LevelDetails and self.LevelDetails.Btn_Prepare and self.LevelDetails.Btn_Prepare.Key_GamePad then
    if bEnabled then
      self.LevelDetails.Btn_Prepare.Key_GamePad:SetIsEnabled(true)
      self.LevelDetails.Btn_Prepare.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      self.LevelDetails.Btn_Prepare.Key_GamePad:SetIsEnabled(false)
      self.LevelDetails.Btn_Prepare.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  local Dropdown = self.LevelDetails and self.LevelDetails.Btn_Difficulty
  local Ctrl = Dropdown and Dropdown.Controller
  if Ctrl then
    if bEnabled and self:CanUseDifficultyDropdown() then
      Ctrl:SetIsEnabled(true)
      Ctrl:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      Ctrl:SetIsEnabled(false)
      Ctrl:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function Component:InitGamePad()
  self.LevelDetails.Btn_Prepare.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
      }
    }
  })
  self.LevelDetails.Controller_Qa:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.LeftThumb
      }
    }
  })
  self.FocusState = Component.FocusState
  self:BindDifficultyDropdownCallbacks()
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if UIUtils.IsKeyboardInput() then
    self.LevelDetails.Btn_Prepare.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:RefreshRuleTipKey()
  elseif UIUtils.IsGamepadInput() then
    if self.CurMode == self.DungeonMode.Repeat then
      local LastFocusEntry = self:GetEntryByIndex(self.CurrentIndex)
      if LastFocusEntry then
        self:SetFocusState(self.FocusState.Focus1)
        LastFocusEntry:SetFocus()
        self.List_Level:SetSelectedIndex(self.CurrentIndex - 1)
        self.List_Level:NavigateToIndex(self.CurrentIndex - 1)
      end
    elseif self.LevelDetails.Btn_Prepare then
      self:SetFocus()
      self.LevelDetails.Btn_Prepare.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  end
end

function Component:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if self.CurFocusState ~= self.FocusState.Focus1 then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if not self.CurrentIndex then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local Value = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  if "Gamepad_RightY" == KeyName then
    if math.abs(Value) < 0.15 then
      return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    self:ScrollMonsterDesc(-Value)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function Component:HandleGamepadInput(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local Dropdown = self.LevelDetails and self.LevelDetails.Btn_Difficulty
  local IsHandled = false
  if "Gamepad_FaceButton_Bottom" == InKeyName then
    self:OnPrepareClicked()
    DebugPrint("------------------ 按下A键 -----------------")
  end
  if "Gamepad_LeftThumbstick" == InKeyName and self.CurFocusState == self.FocusState.Focus1 then
    if self:CanShowRuleTip() then
      self:OnRuleTipPressed()
    end
    IsHandled = true
  end
  if "Gamepad_FaceButton_Right" == InKeyName then
    local Dropdown = self.LevelDetails and self.LevelDetails.Btn_Difficulty
    if self:CanUseDifficultyDropdown() and Dropdown and Dropdown.IsListViewOpened then
      Dropdown:OnListClosed()
      Dropdown:TryReleaseFocus()
      self:SetFocusState(self.FocusState.Focus1)
    else
      self:PlayAnimation(self.Out)
    end
    IsHandled = true
  end
  if "Gamepad_FaceButton_Left" == InKeyName then
    if self:CanUseDifficultyDropdown() then
      local Dropdown = self.LevelDetails and self.LevelDetails.Btn_Difficulty
      if Dropdown then
        IsHandled = Dropdown:ReceiveKeyDown_Lua(MyGeometry, InKeyEvent)
      end
      self:SetFocusState(self.FocusState.Focus3)
    else
      IsHandled = true
    end
  end
  if "Gamepad_RightThumbstick" == InKeyName then
    if self.CurFocusState == self.FocusState.Focus3 then
      IsHandled = true
    else
      self:ResourcesBarConfig(self.CurMode)
    end
  end
  return IsHandled
end

function Component:OnRuleTipPressed()
  local Params = {}
  Params.ShortTextParams = "UI_SoloTreasureTicketLevelTips"
  UIManager(self):ShowCommonPopupUI(100340, Params, self)
  DebugPrint("----------------- 打开弹窗 -----------------")
end

function Component:ScrollMonsterDesc(Dir)
  local SB = self.LevelDetails and self.LevelDetails.EMScrollBox_148
  if not SB then
    return
  end
  local Step = 40
  local Cur = SB:GetScrollOffset()
  local EndOffset = 0
  if SB.GetScrollOffsetOfEnd then
    EndOffset = SB:GetScrollOffsetOfEnd()
  end
  local NewOffset = Cur + Dir * Step
  NewOffset = math.max(0, math.min(NewOffset, EndOffset))
  SB:SetScrollOffset(NewOffset)
  DebugPrint("Scroll: Cur=", Cur, " New=", NewOffset, " End=", EndOffset)
end

function Component:ResourcesBarConfig(GameMode)
  if GameMode == self.DungeonMode.Repeat then
    self:SetFocusState(self.FocusState.Focus2)
    local Bar = self.Root and self.Root.Com_Tab and self.Root.Com_Tab.WBP_Com_Tab_ResourceBar
    if Bar then
      Bar:SetFocus()
      Bar:SetGetReplyOnBack(function()
        self:SetFocusState(self.FocusState.Focus1)
        local LastFocusEntry = self:GetEntryByIndex(self.CurrentIndex)
        if LastFocusEntry then
          LastFocusEntry:SetFocus()
        end
        self:RefreshKeyTips()
        return UWidgetBlueprintLibrary.Handled()
      end)
    end
  else
    self:SetFocusState(self.FocusState.Focus5)
    local Bar = self.Root and self.Root.Com_Tab and self.Root.Com_Tab.WBP_Com_Tab_ResourceBar
    Bar:SetFocus()
    if Bar then
      Bar:SetGetReplyOnBack(function()
        self:SetFocusState(self.FocusState.Focus4)
        self:SetFocus()
        return UWidgetBlueprintLibrary.Handled()
      end)
    end
  end
end

function Component:BindDifficultyDropdownCallbacks()
  local Dropdown = self.LevelDetails and self.LevelDetails.Btn_Difficulty
  if not Dropdown then
    return
  end
  if Dropdown.BindOnRemovedFromFocusPathEvent then
    Dropdown:BindOnRemovedFromFocusPathEvent(self, function()
      if not UIUtils.IsGamepadInput() then
        return
      end
      self:SetFocusState(self.FocusState.Focus1)
    end)
  end
end

function Component:ApplySequentialLockNavigation()
  if not self.List_Level then
    return
  end
  local Last = self.LatestUnlockedIndex
  local Total = self.List_Level:GetNumItems()
  if Last >= Total then
    DebugPrint("[NavFix] 全部关卡已解锁，无需设置导航限制")
    return
  end
  local Entry = self:GetEntryByIndex(Last)
  if not Entry then
    self.List_Level:NavigateToIndex(Last - 1)
    Entry = self:GetEntryByIndex(Last)
  end
  if not Entry then
    return
  end
  Entry:SetNavigationRuleCustom(UE4.EUINavigation.Down, function(widget)
    local LockedObj = self.List_Level:GetItemAt(Last)
    if LockedObj and self.ShowLockedToastByObj then
      self:ShowLockedToastByObj(LockedObj)
    end
    return widget
  end)
end

function Component:CanShowRuleTip()
  return self.CurMode == self.DungeonMode.Repeat and self.bCanShowRuleTip == true
end

return Component
