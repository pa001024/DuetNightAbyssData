local Component = {}
local UIUtils = require("Utils.UIUtils")
Component.FocusState = {
  Focus1 = 1,
  Focus2 = 2,
  Focus3 = 3,
  Focus4 = 4
}

function Component:CanUseDifficultyDropdown()
  return self.bHasDifficultyDropdown == true
end

function Component:CanShowRuleTip()
  return self.bCanShowRuleTip == true
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
  local StateNames = {
    [1] = "Focus1(列表)",
    [2] = "Focus2(代币栏)",
    [3] = "Focus3(难度下拉)",
    [4] = "Focus4(入口按钮)"
  }
  DebugPrint("[常驻GamepadComp] SetFocusState:", StateNames[State] or tostring(State))
  self.CurFocusState = State
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
    self:SetEntranceYBtnVisible(true)
    self:RefreshRuleTipKey()
    if self.bCanShowRV == true then
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
    self.TabConfigData.BottomKeyInfo = BottomKeyInfo
    if type(self.Root.InitOtherPageTab) == "function" then
      self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
    end
  elseif self.CurFocusState == self.FocusState.Focus2 then
    self:SetOtherKeyTipsEnabled(false)
    self:SetEntranceYBtnVisible(false)
    self:RefreshRuleTipKey()
  elseif self.CurFocusState == self.FocusState.Focus3 then
    if not self:CanUseDifficultyDropdown() then
      self:SetFocusState(self.FocusState.Focus1)
      return
    end
    self:SetOtherKeyTipsEnabled(false)
    self:SetEntranceYBtnVisible(false)
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
    self.TabConfigData.BottomKeyInfo = BottomKeyInfo
    if type(self.Root.InitOtherPageTab) == "function" then
      self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
    end
    local Bar = self.Root.Com_Tab and self.Root.Com_Tab.WBP_Com_Tab_ResourceBar
    if Bar then
      Bar:HideGamePadKey(true)
    end
  elseif self.CurFocusState == self.FocusState.Focus4 then
    self:SetOtherKeyTipsEnabled(false)
    self:SetEntranceYBtnVisible(false)
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
    self.TabConfigData.BottomKeyInfo = BottomKeyInfo
    if type(self.Root.InitOtherPageTab) == "function" then
      self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
    end
  end
end

function Component:RefreshRuleTipKey()
  local RuleTipKey = self.LevelDetails and self.LevelDetails.Controller_Qa
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
  if self.Root and self.Root.Controller_Entrance then
    self.Root.Controller_Entrance:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonTop
        }
      }
    })
  end
  self.FocusState = Component.FocusState
  self:BindDifficultyDropdownCallbacks()
end

function Component:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  DebugPrint("[常驻GamepadComp] OnUpdateUIStyleByInputTypeChange IsKeyboard:", UIUtils.IsKeyboardInput(), "IsGamepad:", UIUtils.IsGamepadInput())
  if UIUtils.IsKeyboardInput() then
    self.LevelDetails.Btn_Prepare.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:RefreshRuleTipKey()
    self:SetEntranceYBtnVisible(false)
  elseif UIUtils.IsGamepadInput() then
    local LastFocusEntry = self:GetEntryByIndex(self.CurrentIndex)
    if LastFocusEntry then
      self:SetFocusState(self.FocusState.Focus1)
      LastFocusEntry:SetFocus()
      self.List_Level:SetSelectedIndex(self.CurrentIndex - 1)
      self.List_Level:NavigateToIndex(self.CurrentIndex - 1)
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
  local IsHandled = false
  DebugPrint("[常驻GamepadComp] HandleGamepadInput key:", InKeyName, "CurFocusState:", self.CurFocusState)
  if "Gamepad_FaceButton_Bottom" == InKeyName then
    if self.CurFocusState == self.FocusState.Focus4 then
      DebugPrint("[常驻GamepadComp] A键(Focus4) -> 交给UE4焦点系统处理入口按钮点击")
    else
      DebugPrint("[常驻GamepadComp] A键 -> OnPrepareClicked")
      self:OnPrepareClicked()
      IsHandled = true
    end
  end
  if "Gamepad_FaceButton_Top" == InKeyName then
    DebugPrint("[常驻GamepadComp] Y键 -> CurFocusState:", self.CurFocusState)
    if self.CurFocusState == self.FocusState.Focus1 then
      self:EnterEntranceFocus()
    end
    IsHandled = true
  end
  if "Gamepad_LeftThumbstick" == InKeyName and self.CurFocusState == self.FocusState.Focus1 then
    DebugPrint("[常驻GamepadComp] LS键 -> CanShowRuleTip:", self:CanShowRuleTip())
    if self:CanShowRuleTip() then
      self:OnRuleTipPressed()
    end
    IsHandled = true
  end
  if "Gamepad_FaceButton_Right" == InKeyName then
    if self.CurFocusState == self.FocusState.Focus4 then
      DebugPrint("[常驻GamepadComp] B键(Focus4) -> 退出入口聚焦，返回Focus1")
      self:ExitEntranceFocus()
    else
      local Dropdown = self.LevelDetails and self.LevelDetails.Btn_Difficulty
      DebugPrint("[常驻GamepadComp] B键 -> CanUseDifficultyDropdown:", self:CanUseDifficultyDropdown())
      if self:CanUseDifficultyDropdown() and Dropdown and Dropdown.IsListViewOpened then
        DebugPrint("[常驻GamepadComp] B键 -> 关闭难度下拉，返回Focus1")
        Dropdown:OnListClosed()
        Dropdown:TryReleaseFocus()
        self:SetFocusState(self.FocusState.Focus1)
      else
        DebugPrint("[常驻GamepadComp] B键 -> PlayAnimation Out")
        self:PlayAnimation(self.Out)
      end
    end
    IsHandled = true
  end
  if "Gamepad_FaceButton_Left" == InKeyName and self.CurFocusState ~= self.FocusState.Focus4 and not self.bSeasonClosed then
    DebugPrint("[常驻GamepadComp] X键 -> CanUseDifficultyDropdown:", self:CanUseDifficultyDropdown())
    if self:CanUseDifficultyDropdown() then
      local Dropdown = self.LevelDetails and self.LevelDetails.Btn_Difficulty
      if Dropdown then
        DebugPrint("[常驻GamepadComp] X键 -> 打开难度下拉，进入Focus3")
        IsHandled = Dropdown:ReceiveKeyDown_Lua(MyGeometry, InKeyEvent)
      end
      self:SetFocusState(self.FocusState.Focus3)
    else
      DebugPrint("[常驻GamepadComp] X键 -> 当前关卡无难度下拉，忽略")
      IsHandled = true
    end
  end
  if ("Gamepad_DPad_Left" == InKeyName or "Gamepad_DPad_Right" == InKeyName) and self.CurFocusState == self.FocusState.Focus4 then
    local Dir = "Gamepad_DPad_Right" == InKeyName and 1 or -1
    DebugPrint("[常驻GamepadComp] 方向键左右 Dir:", Dir, "-> 切换入口按钮")
    self:SwitchEntranceFocus(Dir)
    IsHandled = true
  end
  if "Gamepad_RightThumbstick" == InKeyName then
    DebugPrint("[常驻GamepadComp] RS键 -> CurFocusState:", self.CurFocusState)
    if self.CurFocusState == self.FocusState.Focus3 or self.CurFocusState == self.FocusState.Focus4 then
      DebugPrint("[常驻GamepadComp] RS键 -> 当前状态不响应RS")
      IsHandled = true
    else
      DebugPrint("[常驻GamepadComp] RS键 -> 进入代币栏Focus2")
      self:ResourcesBarConfig()
    end
  end
  return IsHandled
end

function Component:OnRuleTipPressed()
  local Params = {}
  Params.ShortTextParams = "UI_SoloTreasureTicketLevelTips"
  UIManager(self):ShowCommonPopupUI(100340, Params, self)
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
  local NewOffset = math.max(0, math.min(Cur + Dir * Step, EndOffset))
  SB:SetScrollOffset(NewOffset)
end

function Component:ResourcesBarConfig()
  DebugPrint("[常驻GamepadComp] ResourcesBarConfig -> 进入Focus2")
  self:SetFocusState(self.FocusState.Focus2)
  local Bar = self.Root and self.Root.Com_Tab and self.Root.Com_Tab.WBP_Com_Tab_ResourceBar
  if not Bar then
    return
  end
  Bar:SetFocus()
  Bar:SetGetReplyOnBack(function()
    DebugPrint("[常驻GamepadComp] 代币栏返回 -> 回到Focus1，CurrentIndex:", self.CurrentIndex)
    self:SetFocusState(self.FocusState.Focus1)
    local LastFocusEntry = self:GetEntryByIndex(self.CurrentIndex)
    if LastFocusEntry then
      LastFocusEntry:SetFocus()
    end
    self:RefreshKeyTips()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end)
end

function Component:SetEntranceYBtnVisible(bVisible)
  local Ctrl = self.Root and self.Root.Controller_Entrance
  if not Ctrl then
    return
  end
  if bVisible then
    Ctrl:SetIsEnabled(true)
    Ctrl:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    Ctrl:SetIsEnabled(false)
    Ctrl:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function Component:GetEntranceWidget(Idx)
  if not self.Root then
    return nil
  end
  if 1 == Idx then
    return self.Root.Entrance_Illustrated
  elseif 2 == Idx then
    return self.Root.Entrance_Shop
  elseif 3 == Idx then
    return self.Root.Entrance_Reward
  end
  return nil
end

function Component:FocusEntranceWidget(Widget)
  if not Widget then
    return
  end
  if Widget.Btn then
    Widget.Btn:SetFocus()
  else
    Widget:SetFocus()
  end
end

function Component:EnterEntranceFocus()
  DebugPrint("[常驻GamepadComp] EnterEntranceFocus -> 进入Focus4，聚焦第一个入口按钮")
  self.EntranceFocusIndex = 1
  self:SetFocusState(self.FocusState.Focus4)
  self:FocusEntranceWidget(self:GetEntranceWidget(1))
end

function Component:ExitEntranceFocus()
  DebugPrint("[常驻GamepadComp] ExitEntranceFocus -> 退出Focus4，恢复Focus1")
  self.EntranceFocusIndex = nil
  self:SetEntranceYBtnVisible(true)
  self:SetFocusState(self.FocusState.Focus1)
  local LastEntry = self:GetEntryByIndex(self.CurrentIndex)
  if LastEntry then
    LastEntry:SetFocus()
  end
end

function Component:SwitchEntranceFocus(Dir)
  local Total = 3
  local Idx = (self.EntranceFocusIndex or 1) + Dir
  if Idx < 1 then
    Idx = Total
  end
  if Total < Idx then
    Idx = 1
  end
  self.EntranceFocusIndex = Idx
  DebugPrint("[常驻GamepadComp] SwitchEntranceFocus -> 切换到入口", Idx)
  self:FocusEntranceWidget(self:GetEntranceWidget(Idx))
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
  if not Last then
    return
  end
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

return Component
