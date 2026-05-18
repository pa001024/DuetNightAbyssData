local Component = {}
local StateNames = {
  PC = "PC",
  Main = "Main",
  Sort = "Sort",
  Item = "Item"
}

local function GetWidgetVisibility(IsVisible)
  if IsVisible then
    return UIConst.VisibilityOp.SelfHitTestInvisible
  end
  return UIConst.VisibilityOp.Collapsed
end

function Component:Construct()
  local PCState = {
    Enter = function()
      self:EnterMountPCState()
    end,
    Leave = function()
      self:LeaveMountPCState()
    end
  }
  local MainState = {
    Enter = function()
      self:EnterMountMainState()
    end,
    Leave = function()
      self:LeaveMountMainState()
    end
  }
  local SortState = {
    Enter = function()
      self:EnterMountSortState()
    end,
    Leave = function()
      self:LeaveMountSortState()
    end
  }
  local ItemState = {
    Enter = function()
      self:EnterMountItemState()
    end,
    Leave = function()
      self:LeaveMountItemState()
    end,
    CanReach = function()
      return self:CanReachMountItemState()
    end
  }
  self.MountInputStates = {
    [StateNames.PC] = PCState,
    [StateNames.Main] = MainState,
    [StateNames.Sort] = SortState,
    [StateNames.Item] = ItemState
  }
  self.MountInputStateType = nil
end

function Component:InitMountGamepadWidgets()
  if self.Key_Method and self.Key_Method.CreateCommonKey and not self.bMountMethodKeyInited then
    self.bMountMethodKeyInited = true
    self.Key_Method:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Menu"}
      }
    })
  end
  self:UpdateMountMethodKeyVisibility()
end

function Component:UpdateMountMethodKeyVisibility()
  if not self.Key_Method then
    return
  end
  local IsVisible = self.IsGamepadInput and self.MountInputStateType == StateNames.Main and self:CanReachMountItemState() and self.Parent and not self.Parent.bSelfHidden
  self.Key_Method:SetVisibility(GetWidgetVisibility(IsVisible))
end

function Component:EnterMountPCState()
  self:UpdateMountBottomKeyInfo()
end

function Component:LeaveMountPCState()
end

function Component:EnterMountMainState()
  self:UpdateMountBottomKeyInfo()
  self:RefreshMountGamepadFocus()
end

function Component:LeaveMountMainState()
end

function Component:EnterMountSortState()
  self:UpdateMountBottomKeyInfo()
  self:RefreshMountGamepadFocus()
end

function Component:LeaveMountSortState()
end

function Component:EnterMountItemState()
  if self.Common_Sort_List and self.Common_Sort_List.SetControllerKeyHidden then
    self.Common_Sort_List:SetControllerKeyHidden(true)
  end
  self:UpdateMountBottomKeyInfo()
  self:RefreshMountGamepadFocus()
end

function Component:LeaveMountItemState()
  if self.Common_Sort_List and self.Common_Sort_List.SetControllerKeyHidden then
    self.Common_Sort_List:SetControllerKeyHidden(false)
  end
end

function Component:CanReachMountItemState()
  if not self.bCanShowMethodDetail then
    return false
  end
  if not self.AllMethodSubWidgetList or #self.AllMethodSubWidgetList <= 0 then
    return false
  end
  return true
end

function Component:UpdateMountInputState(StateType)
  if not self.MountInputStates or not self.MountInputStates[StateType] then
    return
  end
  if self.MountInputStateType == StateType then
    return
  end
  local NextState = self.MountInputStates[StateType]
  local CanReach = true
  if NextState.CanReach then
    CanReach = NextState.CanReach()
  end
  if not CanReach then
    return
  end
  if self.MountInputStateType and self.MountInputStates[self.MountInputStateType] and self.MountInputStates[self.MountInputStateType].Leave then
    self.MountInputStates[self.MountInputStateType].Leave()
  end
  self.MountInputStateType = StateType
  NextState.Enter()
end

function Component:OnMountInputTypeChanged(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamepadInput then
    self:UpdateMountInputState(StateNames.Main)
  else
    self:UpdateMountInputState(StateNames.PC)
  end
  self:UpdateMountBottomKeyInfo()
end

function Component:OnMountHideStateChanged()
  if self.Parent and self.Parent.bSelfHidden then
    self.Parent.IMG_Click:SetFocus()
  else
    self:RefreshMountGamepadFocus()
  end
  self:UpdateMountBottomKeyInfo()
end

function Component:OnSortBackToMainState()
  self:UpdateMountInputState(StateNames.Main)
end

function Component:OnMountInfoChanged()
  if self.MountInputStateType == StateNames.Item and not self:CanReachMountItemState() then
    self:UpdateMountInputState(StateNames.Main)
  end
  self:UpdateMountBottomKeyInfo()
end

function Component:RefreshMountGamepadFocus()
  if not (self.IsGamepadInput and self.Parent) or self.Parent.bSelfHidden then
    return
  end
  if self.MountInputStateType == StateNames.Sort then
    self.Common_Sort_List:SetFocus()
    return
  end
  if self.MountInputStateType == StateNames.Item and self:CanReachMountItemState() then
    self.AllMethodSubWidgetList[1]:SetFocus()
    return
  end
  if self.ListView_Items then
    self.ListView_Items:SetFocus()
  end
end

function Component:UpdateMountBottomKeyInfo()
  if not self.Parent then
    return
  end
  self:UpdateMountMethodKeyVisibility()
  local BottomKeyInfo
  if self.MountInputStateType == StateNames.Item and self.IsGamepadInput then
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure"),
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
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
            Text = CommonUtils:GetKeyText("R"),
            ClickCallback = self.ToggleRiderMount,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "RS",
            Owner = self
          }
        },
        Desc = GText("UI_CTL_Ride")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = CommonUtils:GetKeyText("U"),
            ClickCallback = self.ToggleHideUI,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "X",
            Owner = self
          }
        },
        Desc = GText("UI_Dye_HideUI")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = CommonUtils:GetKeyText("Mouse_Button"),
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Or",
            ImgShortPath = "RT",
            Owner = self
          },
          GamePadSubKeyInfoList = {
            {
              Type = "Img",
              ImgShortPath = "LT",
              Owner = self
            },
            {
              Type = "Img",
              ImgShortPath = "RT",
              Owner = self
            }
          }
        },
        Desc = GText("UI_Dye_Zoom")
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "RH",
            Owner = self
          }
        },
        Desc = GText("UI_CTL_RotatePreview")
      },
      self.Parent.ESCKeyInfoList
    }
  end
  if self.UpdateBottomKeyInfo then
    self:UpdateBottomKeyInfo(BottomKeyInfo)
    return
  end
  if self.Parent.Com_Tab and self.Parent.Com_Tab.UpdateBottomKeyInfo then
    self.Parent.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
  end
end

function Component:ScrollMountCamera(DeltaMove)
  if self.ActorController then
    self.ActorController:OnScrolling(DeltaMove)
  end
end

function Component:HandleMountTriggerAnalogInput(InKeyName, InAnalogInputEvent)
  if not InAnalogInputEvent then
    return false
  end
  local AnalogValue = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  if not AnalogValue or math.abs(AnalogValue) <= 0.1 then
    return false
  end
  if InKeyName == UIConst.GamePadKey.LeftTriggerAnalog then
    self:ScrollMountCamera(AnalogValue)
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightTriggerAnalog then
    self:ScrollMountCamera(-AnalogValue)
    return true
  end
  return false
end

function Component:HandleMountGamepadInput(InKeyName, InAnalogInputEvent)
  if self.Parent and self.Parent.bSelfHidden then
    if InKeyName == UIConst.GamePadKey.FaceButtonLeft or InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:ToggleHideUI()
      return true
    end
    return false
  end
  if self.MountInputStateType == StateNames.Item then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:UpdateMountInputState(StateNames.Main)
      return true
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self:ToggleHideUI()
    return true
  end
  if InKeyName == Const.GamepadLeftThumbstick then
    self:UpdateMountInputState(StateNames.Sort)
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.MountInputStateType == StateNames.Main then
      self.Parent:OnBackKeyDown()
    else
      self:UpdateMountInputState(StateNames.Main)
    end
    return true
  end
  if InKeyName == Const.GamepadRightThumbstick then
    self:ToggleRiderMount()
    return true
  end
  if InKeyName == Const.GamepadSpecialRight then
    self:UpdateMountInputState(StateNames.Item)
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold then
    self:ScrollMountCamera(1)
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
    self:ScrollMountCamera(-1)
    return true
  end
  if self:HandleMountTriggerAnalogInput(InKeyName, InAnalogInputEvent) then
    return true
  end
  if "Gamepad_RightX" == InKeyName and InAnalogInputEvent and self.ActorController then
    local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
    self.ActorController:OnDragViewActor({X = DeltaX})
    return true
  end
  return false
end

function Component:HandleMountKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == EKeys.Escape.KeyName then
    self.Parent:OnBackKeyDown()
    return UIUtils.Handled, true
  end
  if "R" == InKeyName then
    self:ToggleRiderMount()
    return UIUtils.Handled, true
  end
  if "U" == InKeyName then
    self:ToggleHideUI()
    return UIUtils.Handled, true
  end
  if self:HandleMountGamepadInput(InKeyName) then
    return UIUtils.Handled, true
  end
  return UIUtils.Unhandled, false
end

function Component:HandleMountKeyUp(MyGeometry, InKeyEvent)
  return UIUtils.Unhandled, false
end

function Component:HandleMountRepeatKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:HandleMountGamepadInput(InKeyName) then
    return UIUtils.Handled, true
  end
  return UIUtils.Unhandled, false
end

function Component:HandleMountAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:HandleMountGamepadInput(InKeyName, InAnalogInputEvent) then
    return UIUtils.Handled, true
  end
  return UIUtils.Unhandled, false
end

function Component:OnMountBackgroundClicked()
  self:RefreshMountGamepadFocus()
end

function Component:HandleMountFocusReceived(MyGeometry, InFocusEvent)
  self:RefreshMountGamepadFocus()
  return UIUtils.Handled
end

return Component
