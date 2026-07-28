require("UnLua")
local M = Class("BluePrints.UI.WBP.Camera.WBP_CameraBase_C")
M.CameraCustomizePlatform = "PC"
M._components = {
  "BluePrints.UI.WBP.Camera.WBP_Camera_Main_Base_C"
}
local Handle = UE4.UWidgetBlueprintLibrary.Handled()
local Unhandle = UE4.UWidgetBlueprintLibrary.Unhandled()

function M:EnsureCameraMainInputFocus()
  self.bIsFocusable = true
  if self.SetFocus then
    self:SetFocus()
  end
  if self.GameInputModeSubsystem and self.GameInputModeSubsystem.SetTargetUIFocusWidget then
    self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
  end
end

function M:InitKeySetting()
  self.TabLeftKey = EKeys.Q.KeyName
  self.TabLeftKeyGamepad = Const.GamepadLeftShoulder
  self.TabRightKey = EKeys.E.KeyName
  self.TabRightKeyGamepad = Const.GamepadRightShoulder
  self.CameraMoveLeftKey = EKeys.A.KeyName
  self.CameraMoveRightKey = EKeys.D.KeyName
  self.CameraMoveUpKey = EKeys.W.KeyName
  self.CameraMoveDownKey = EKeys.S.KeyName
  self.CheeseKey = EKeys.F.KeyName
  self.CheeseKeyGamepad = Const.GamepadFaceButtonUp
  self.ParameterKey = EKeys.G.KeyName
  self.CameraParameterKeyGamepad = Const.GamepadLeftThumbstick
  self.HideUIKey = EKeys.U.KeyName
  self.HideUIKeyGamepad = Const.GamepadRightThumbstick
  self.PauseKey = EKeys.Y.KeyName
  self.GlobalGamePauseGamepad = Const.GamepadSpecialLeft
  self.CustomizeKey = EKeys.T.KeyName
  self.HideCharacterKey = EKeys.I.KeyName
  self.ResetCameraKey = EKeys.R.KeyName
  self.ResetCameraKeyGamepad = Const.GamepadFaceButtonLeft
  self.AddFocalLengthKey = EKeys.Add.KeyName
  self.AddFocalLengthGamepad = Const.GamepadDPadUp
  self.SubFocalLengthKey = EKeys.Subtract.KeyName
  self.SubFocalLengthGamepad = Const.GamepadDPadDown
  self.LeftMouseButton = EKeys.LeftMouseButton.KeyName
  self.Escape = EKeys.Escape.KeyName
  self.EscapeGamepad = Const.GamepadFaceButtonRight
  self.MoveCloseGamepad = Const.GamepadLeftTrigger
  self.MoveFarGamepad = Const.GamepadRightTrigger
  self.FastCloseCamera = CommonUtils:GetActionMappingKeyName("OpenCamera")
  self.KeyDownEvent = {}
  self.KeyDownEvent[self.TabLeftKey] = self.OnTabLeftKeyDown
  self.KeyDownEvent[self.TabRightKey] = self.OnTabRightKeyDown
  self.KeyDownEvent[self.TabLeftKeyGamepad] = self.OnTabLeftKeyDown
  self.KeyDownEvent[self.TabRightKeyGamepad] = self.OnTabRightKeyDown
  self.KeyDownEvent[self.CameraMoveLeftKey] = self.OnCameraMoveLeftKeyDown
  self.KeyDownEvent[self.CameraMoveRightKey] = self.OnCameraMoveRightKeyDown
  self.KeyDownEvent[self.CameraMoveUpKey] = self.OnCameraMoveUpKeyDown
  self.KeyDownEvent[self.CameraMoveDownKey] = self.OnCameraMoveDownKeyDown
  self.KeyDownEvent[self.CheeseKey] = self.OnCheeseKeyDown
  self.KeyDownEvent[self.CheeseKeyGamepad] = self.OnCheeseKeyDown
  self.KeyDownEvent[self.ParameterKey] = self.OnParameterKeyDown
  self.KeyDownEvent[self.CameraParameterKeyGamepad] = self.OnGamepadParameterKeyDown
  self.KeyDownEvent[self.HideUIKey] = self.OnHideUIKeyDown
  self.KeyDownEvent[self.HideUIKeyGamepad] = self.OnHideUIKeyDown
  self.KeyDownEvent[self.CustomizeKey] = self.OnCustomizeClicked
  self.KeyDownEvent[self.ResetCameraKey] = self.OnResetCameraKeyDown
  self.KeyDownEvent[self.ResetCameraKeyGamepad] = self.OnResetCameraKeyDown
  self.KeyDownEvent[self.AddFocalLengthKey] = self.OnAddFocalLengthKeyDown
  self.KeyDownEvent[self.AddFocalLengthGamepad] = self.OnAddFocalLengthKeyDown
  self.KeyDownEvent[self.SubFocalLengthKey] = self.OnSubFocalLengthKeyDown
  self.KeyDownEvent[self.SubFocalLengthGamepad] = self.OnSubFocalLengthKeyDown
  self.KeyDownEvent[self.Escape] = self.OnBackKeyDown
  self.KeyDownEvent[self.EscapeGamepad] = self.OnBackKeyDown
  self.KeyDownEvent[self.PauseKey] = self.OnPuaseClicked
  self.KeyDownEvent[self.GlobalGamePauseGamepad] = self.OnPuaseClicked
  self.KeyDownEvent[self.MoveCloseGamepad] = self.OnMoveCloseKeyDown
  self.KeyDownEvent[self.MoveFarGamepad] = self.OnMoveFarKeyDown
  self.KeyDownEvent[self.FastCloseCamera] = self.OnFastCloseCameraKeyDown
  self.KeyDownEvent[self.FastCloseCamera] = self.OnFastCloseCameraKeyDown
  self.KeyUpEvent = {}
  self.KeyUpEvent[self.CameraMoveLeftKey] = self.OnCameraMoveLeftKeyUp
  self.KeyUpEvent[self.CameraMoveRightKey] = self.OnCameraMoveRightKeyUp
  self.KeyUpEvent[self.CameraMoveUpKey] = self.OnCameraMoveUpKeyUp
  self.KeyUpEvent[self.CameraMoveDownKey] = self.OnCameraMoveDownKeyUp
  self.KeyUpEvent[self.AddFocalLengthKey] = self.OnAddFocalLengthKeyUp
  self.KeyUpEvent[self.AddFocalLengthGamepad] = self.OnAddFocalLengthKeyUp
  self.KeyUpEvent[self.SubFocalLengthKey] = self.OnSubFocalLengthKeyUp
  self.KeyUpEvent[self.SubFocalLengthGamepad] = self.OnSubFocalLengthKeyUp
  self.KeyUpEvent[self.MoveCloseGamepad] = self.OnMoveCloseKeyUp
  self.KeyUpEvent[self.MoveFarGamepad] = self.OnMoveFarKeyUp
end

function M:Construct()
  self.bIsFocusable = true
  self:InitKeySetting()
  self.Btn_Close.Btn_Close.OnClicked:Clear()
  self.Btn_Close.Btn_Close.OnClicked:Add(self, self.OnCameraMainCloseClicked)
  self.CameraInfo = {
    1,
    0,
    2
  }
  self.MainCameraIndex = 2
  self.IsPause = true
  self.TabConfig = {
    Tabs = {
      {
        Text = GText("UI_CameraSystem_CameraModeSelfie"),
        CameraIndex = 1
      },
      {
        Text = GText("UI_CameraSystem_CameraModeDefault"),
        CameraIndex = 0
      },
      {
        Text = GText("UI_CameraSystem_CameraModePhotography"),
        CameraIndex = 2
      },
      y
    },
    LeftKey = self.TabLeftKey,
    RightKey = self.TabRightKey,
    SoundFunc = function()
    end
  }
  self.Btn_Shoot:SetKeyInfo(self.CheeseKey, nil, UIConst.GamePadImgKey.FaceButtonTop)
  self.Btn_Parameter:SetKeyInfo(self.ParameterKey, nil, UIConst.GamePadImgKey.LeftThumb)
  self.FocalLengthChangeInterval = 0.1
  self.FocalLengthChangePressTime = 4
  self.Move_Key:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = EKeys.W.KeyName,
        Owner = self
      },
      {
        Type = "Text",
        Text = EKeys.A.KeyName,
        Owner = self
      },
      {
        Type = "Text",
        Text = EKeys.S.KeyName,
        Owner = self
      },
      {
        Type = "Text",
        Text = EKeys.D.KeyName,
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_CTL_MinGame_Move")
  })
  self.Switch_Key:CreateSubKeyDesc({
    KeyInfoList = {
      {
        Type = "Text",
        Text = EKeys.Q.KeyName,
        Owner = self
      },
      {
        Type = "Text",
        Text = EKeys.E.KeyName,
        Owner = self
      }
    },
    Type = "Or",
    SoundFunc = function()
    end,
    Desc = GText("UI_Controller_Switch")
  })
  self.Zoom_Key.IsButton = false
  self.Zoom_Key:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        ImgShortPath = "Mouse_Button",
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_Dye_Zoom")
  })
  self.HideUI_Key:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = self.HideUIKey,
        ClickCallback = self.OnHideUIKeyDown,
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_CameraSystem_HideUI")
  })
  self.Pause_Key:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = self.PauseKey,
        ClickCallback = self.OnPuaseClicked,
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_CTL_On_OffTime")
  })
  self.Reset_Key:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = self.ResetCameraKey,
        ClickCallback = self.OnResetCameraKeyDown,
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_CameraSystem_CameraReset")
  })
  self.Customize_Key:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = self.CustomizeKey,
        ClickCallback = self.OnCustomizeClicked,
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_OPTION_Resolution_Cusrtom")
  })
  self.Key_Controller_Move:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "L",
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_CTL_MinGame_Move")
  })
  self.Key_Controller_Switch:CreateSubKeyDesc({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "LB",
        Owner = self
      },
      {
        Type = "Img",
        ImgShortPath = "RB",
        Owner = self
      }
    },
    Type = "Or",
    SoundFunc = function()
    end,
    Desc = GText("UI_Controller_Switch")
  })
  self.Key_Controller_Zoom:CreateSubKeyDesc({
    KeyInfoList = {
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
    },
    Type = "Or",
    SoundFunc = function()
    end,
    Desc = GText("UI_Dye_Zoom")
  })
  self.Key_Controller_HideUI:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "RS",
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_CameraSystem_HideUI")
  })
  self.Key_Controller_Pause:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "View",
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_CTL_On_OffTime")
  })
  self.Key_Controller_Reset:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "X",
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_CameraSystem_CameraReset")
  })
  self.Key_Controller_Customize:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "A",
        Owner = self
      }
    },
    SoundFunc = function()
    end,
    Desc = GText("UI_CTL_On/Off")
  })
  self.Key_Controller_Customize:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.FocalLengthSlider = self.WBP_Camera_Bar_P
  self.RollScrollBar = self.WBP_Camera_Scale_P
  self:UnbindAllFromAnimationFinished(self.Menu_Out)
  self:BindToAnimationFinished(self.Menu_Out, {
    self,
    self.OnMenu_OutFinished
  })
  self:UnbindAllFromAnimationFinished(self.Menu_Out)
  self:BindToAnimationFinished(self.MenuPart_Out, {
    self,
    self.OnMenuPart_OutFinished
  })
  self:SetMenuWidgetVisibility(true)
  self.WidgetHideTags = {
    Top = 0,
    Bottom = 0,
    ESC = 0,
    Menu = 1
  }
  for key, value in pairs(self.WidgetHideTags) do
    self["Set" .. key .. "WidgetVisibility"](self, 0 == value)
  end
  self.WidgetHideAnims = {
    Top = {
      In = self.Hide_In,
      Out = self.Hide_Out
    },
    Bottom = {
      In = self.MenuPart_In,
      Out = self.MenuPart_Out
    },
    Menu = {
      In = self.Menu_In,
      Out = self.Menu_Out
    }
  }
  self.OperationStack = {}
  M.Super.Construct(self)
  self:InitCameraCustomizeMain()
  self:EnsureCameraMainInputFocus()
  self.Customize_Key:SetVisibility(ESlateVisibility.Collapsed)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  if self.bScreenshotWidgetShow then
    return Unhandle
  end
  local WheelDelta = UE4.UKismetInputLibrary.PointerEvent_GetWheelDelta(MouseEvent)
  self:MoveCamera(WheelDelta, 0, 0)
  return Unhandle
end

function M:OnMoveCloseKeyDown()
  self.bCameraMoveCloseKeyDown = true
end

function M:OnMoveCloseKeyUp()
  self.bCameraMoveCloseKeyDown = false
end

function M:OnMoveFarKeyDown()
  self.bCameraMoveFarKeyDown = true
end

function M:OnMoveFarKeyUp()
  self.bCameraMoveFarKeyDown = false
end

function M:OnPuaseClicked()
  local bTargetPause = UE4.UGameplayStatics.IsGamePaused(self) ~= true
  if self:NotifyGamePauseChange(bTargetPause) == false then
    return
  end
  self.IsPause = bTargetPause
end

function M:OnFastCloseCameraKeyDown()
  if self.bShowHideCharacterWidget then
    self:ToggleShowHideCharacterWidget()
  end
  self:CheckHasAnyOperationOrClose()
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if self.bScreenshotWidgetShow then
    return Unhandle
  end
  self.IsDragging = true
  local IsLeftMouseButton = UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton)
  if IsLeftMouseButton and self.KeyDownEvent[self.LeftMouseButton] then
    self.KeyDownEvent[self.LeftMouseButton](self)
  end
  return UWidgetBlueprintLibrary.CaptureMouse(Handle, self)
end

function M:OnMouseButtonUp(MyGeometry, InKeyEvent)
  self.IsDragging = false
  self.RotateCameraByPointer = false
  return UWidgetBlueprintLibrary.ReleaseMouseCapture(Handle)
end

function M:OnMouseMove(MyGeometry, InKeyEvent)
  if self.bScreenshotWidgetShow then
    self.IsDragging = false
    return Unhandle
  end
  if self.IsDragging then
    local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(InKeyEvent)
    self:RotateCamera(0, -CursorDelta.Y, CursorDelta.X)
    self.RotateCameraByPointer = self.RotateCameraByPointer or 0 ~= CursorDelta.X or 0 ~= CursorDelta.Y
  end
  return Unhandle
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self.bScreenshotWidgetShow then
    return self.ScreenshotWidget:OnPreviewKeyDown(MyGeometry, InKeyEvent) and UIUtils.Handled or UIUtils.Unhandled
  end
  if self.HandleCameraCustomizePreviewKeyDown then
    local Reply = self:HandleCameraCustomizePreviewKeyDown(MyGeometry, InKeyEvent)
    if Reply then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if self.bScreenshotWidgetShow then
    self.ScreenshotWidget:OnKeyDown(MyGeometry, InKeyEvent)
    return UIUtils.Handled
  end
  if self.bScreenshotProcessing then
    return UIUtils.Handled
  end
  local Reply = self:HandleCameraCustomizeKeyDown(MyGeometry, InKeyEvent)
  if Reply then
    return Reply
  end
  if self:IsParameterWidgetShowed() then
    local Reply, IsHandled = self.Parameter:ProcessOnKeyDown(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.KeyDownEvent[InKeyName] then
    self.KeyDownEvent[InKeyName](self)
  end
  return UIUtils.Handled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  if self.HandleCameraCustomizeKeyUp then
    local Reply = self:HandleCameraCustomizeKeyUp(MyGeometry, InKeyEvent)
    if Reply then
      return Reply
    end
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.KeyUpEvent[InKeyName] then
    self.KeyUpEvent[InKeyName](self)
    return Unhandle
  end
  return Unhandle
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
  if self.bScreenshotWidgetShow then
    self.ScreenshotWidget:OnKeyDown(MyGeometry, InKeyEvent)
    return UIUtils.Handled
  end
  if self.HandleCameraCustomizeRepeatKeyDown then
    local Reply = self:HandleCameraCustomizeRepeatKeyDown(MyGeometry, InKeyEvent)
    if Reply then
      return Reply
    end
  end
  local GamepadName = UIUtils.UtilsGetCurrentGamepadName()
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "PS" ~= GamepadName or Const.GamepadDPadUp ~= InKeyName and Const.GamepadDPadDown ~= InKeyName and Const.GamepadDPadLeft ~= InKeyName and Const.GamepadDPadRight ~= InKeyName then
    return UIUtils.Unhandled
  end
  local Reply = self:HandleCameraCustomizeKeyDown(MyGeometry, InKeyEvent)
  if Reply then
    return Reply
  end
  if self.KeyDownEvent[InKeyName] then
    self.KeyDownEvent[InKeyName](self)
  end
  return UIUtils.Handled
end

function M:OnTabLeftKeyDown()
  if self.MainCameraIndex - 1 >= 1 then
    self:ChangeCamera(self.CameraInfo[self.MainCameraIndex - 1])
    self.MainCameraIndex = self.MainCameraIndex - 1
  end
end

function M:OnTabRightKeyDown()
  if self.MainCameraIndex + 1 <= #self.CameraInfo then
    self:ChangeCamera(self.CameraInfo[self.MainCameraIndex + 1])
    self.MainCameraIndex = self.MainCameraIndex + 1
  end
end

function M:OnTabSelected(TabWidget, Tab)
  self:ChangeCamera(Tab.CameraIndex)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local HandleResult = UIUtils.Unhandled
  if self.bScreenshotWidgetShow then
    return HandleResult
  end
  if self.HandleCameraCustomizeAnalog then
    local Reply = self:HandleCameraCustomizeAnalog(MyGeometry, InAnalogInputEvent)
    if Reply then
      return Reply
    end
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local Value = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  if self.bNeedFreshGamepadAnalogValue then
    self.bCameraMoveLeftKeyDown = false
    self.bCameraMoveRightKeyDown = false
    self.bCameraMoveUpKeyDown = false
    self.bCameraMoveDownKeyDown = false
    self.bNeedFreshGamepadAnalogValue = false
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and not self.bShowHideCharacterWidget then
    if InKeyName == UIConst.GamePadKey.LeftAnalogX then
      self.bCameraMoveLeftKeyDown = Value < -0.2
      self.bCameraMoveRightKeyDown = Value > 0.2
      HandleResult = UIUtils.Handled
    end
    if InKeyName == UIConst.GamePadKey.LeftAnalogY then
      self.bCameraMoveDownKeyDown = Value < -0.2
      self.bCameraMoveUpKeyDown = Value > 0.2
      HandleResult = UIUtils.Handled
    end
    if Value > 0.2 or Value < -0.2 then
      if InKeyName == UIConst.GamePadKey.RightAnalogX then
        self.RotYaw = Value * self.RotYawGamepadCoe
        self.RotateCameraByPointer = true
        HandleResult = UIUtils.Handled
      end
      if InKeyName == UIConst.GamePadKey.RightAnalogY then
        self.RotPitch = Value * self.RotPitchGamepadCoe
        self.RotateCameraByPointer = true
        HandleResult = UIUtils.Handled
      end
    end
  end
  return HandleResult
end

function M:Tick(MyGeometry, InDeltaTime)
  if self.bCameraMoveLeftKeyDown then
    self:MoveCamera(0, -InDeltaTime, 0)
  end
  if self.bCameraMoveRightKeyDown then
    self:MoveCamera(0, InDeltaTime, 0)
  end
  if self.bCameraMoveUpKeyDown then
    self:MoveCamera(0, 0, InDeltaTime)
  end
  if self.bCameraMoveDownKeyDown then
    self:MoveCamera(0, 0, -InDeltaTime)
  end
  if self.bCameraMoveCloseKeyDown then
    self:MoveCamera(InDeltaTime * 20, 0, 0)
  end
  if self.bCameraMoveFarKeyDown then
    self:MoveCamera(-InDeltaTime * 20, 0, 0)
  end
  if self.CameraRollKeyPressedTime ~= nil and self.CameraRollKeyPressedTime >= 0.5 then
    if self.bCameraLeftRollKeyDown then
      self:RotateCameraRoll(-1)
    end
    if self.bCameraRightRollKeyDown then
      self:RotateCameraRoll(1)
    end
  elseif (self.bCameraRightRollKeyDown or self.bCameraLeftRollKeyDown) and self.CameraRollKeyPressedTime ~= nil and self.CameraRollKeyPressedTime < 0.5 then
    self.CameraRollKeyPressedTime = self.CameraRollKeyPressedTime + InDeltaTime
  end
  if nil ~= self.FocalLengthKeyPressedTime and self.FocalLengthKeyPressedTime >= 0.5 then
    if self.FocalLengthSub then
      self.FocalLengthSlider:SubValue()
    end
    if self.FocalLengthAdd then
      self.FocalLengthSlider:AddValue()
    end
  elseif (self.FocalLengthSub or self.FocalLengthAdd) and nil ~= self.FocalLengthKeyPressedTime and self.FocalLengthKeyPressedTime < 0.5 then
    self.FocalLengthKeyPressedTime = self.FocalLengthKeyPressedTime + InDeltaTime
  end
  if self.bCameraMoveLeftKeyDown or self.bCameraMoveRightKeyDown or self.bCameraMoveUpKeyDown or self.bCameraMoveDownKeyDown or self.bCameraMovedByJoyStick or self.RotateCameraByPointer then
    self.SoundFlags.Camera_Motor = true
  else
    self.SoundFlags.Camera_Motor = false
  end
  if self.RotateCameraByPointer and (0 ~= self.RotPitch or 0 ~= self.RotYaw) then
    self:RotateCamera(0, self.RotPitch, self.RotYaw)
  end
  self.RotateCameraByPointer = false
  M.Super.Tick(self, MyGeometry, InDeltaTime)
  if self.UpdateCameraCustomizeLookAtCamera then
    self:UpdateCameraCustomizeLookAtCamera()
  end
  if self.UpdateCameraCustomizeWheelActionTransition then
    self:UpdateCameraCustomizeWheelActionTransition()
  end
  self.RotPitch = 0
  self.RotYaw = 0
  self.bNeedFreshGamepadAnalogValue = true
end

function M:OnAddedToFocusPath(InFocusEvent)
  rawset(self, "bInFocusPath", true)
end

function M:OnRemovedFromFocusPath()
  rawset(self, "bInFocusPath", false)
  self:StopCameraMove()
end

function M:StopCameraMove()
  self.bCameraMoveLeftKeyDown = false
  self.bCameraMoveRightKeyDown = false
  self.bCameraMoveUpKeyDown = false
  self.bCameraMoveDownKeyDown = false
  self.bCameraMoveCloseKeyDown = false
  self.bCameraMoveFarKeyDown = false
  self:CancelFocalLengLongPress()
end

function M:OnJoyStickMove(Dir, Percent)
  self.bCameraMovedByJoyStick = not self.bLockCameraPos
  self:MoveCamera(0, Dir.X * Percent, Dir.Y * Percent)
end

function M:OnJoyStickPointerDown()
  if self.bLockCameraPos then
  end
end

function M:OnJoyStickPointerUp()
  self.bCameraMovedByJoyStick = false
end

function M:OnCameraMoveLeftKeyDown()
  self.bCameraMoveLeftKeyDown = not self.bLockCameraPos
  self:OnJoyStickPointerDown()
end

function M:OnCameraMoveLeftKeyUp()
  self.bCameraMoveLeftKeyDown = false
end

function M:OnCameraMoveRightKeyDown()
  self.bCameraMoveRightKeyDown = not self.bLockCameraPos
  self:OnJoyStickPointerDown()
end

function M:OnCameraMoveRightKeyUp()
  self.bCameraMoveRightKeyDown = false
end

function M:OnCameraMoveUpKeyDown()
  self.bCameraMoveUpKeyDown = not self.bLockCameraPos
  self:OnJoyStickPointerDown()
end

function M:OnCameraMoveUpKeyUp()
  self.bCameraMoveUpKeyDown = false
end

function M:OnCameraMoveDownKeyDown()
  self.bCameraMoveDownKeyDown = not self.bLockCameraPos
  self:OnJoyStickPointerDown()
end

function M:OnCameraMoveDownKeyUp()
  self.bCameraMoveDownKeyDown = false
end

function M:OnCheeseKeyDown()
  self:Screenshot()
end

function M:OnParameterKeyDown()
  if self.bSelfHidden then
    return
  end
  self:ToggleShowHideParameterWidget()
end

function M:OnGamepadParameterKeyDown()
  if self.bSelfHidden then
    return
  end
  self:ShowParameterWidget()
end

function M:OnCameraRollLeftKeyDown()
  self.bCameraLeftRollKeyDown = true
  self.CameraRollKeyPressedTime = 0
  self:RotateCameraRoll(-1)
end

function M:OnCameraRollLeftKeyUp()
  self.bCameraLeftRollKeyDown = false
end

function M:OnCameraRollLeftClicked()
  self:RotateCameraRoll(-1)
end

function M:OnCameraRollRightKeyDown()
  self.bCameraRightRollKeyDown = true
  self.CameraRollKeyPressedTime = 0
  self:RotateCameraRoll(1)
end

function M:OnCameraRollRightKeyUp()
  self.bCameraRightRollKeyDown = false
end

function M:OnCameraRollRightClicked()
  self:RotateCameraRoll(1)
end

function M:PushOperationStack(Operation)
  table.insert(self.OperationStack, Operation)
end

function M:PopOperationStack(Operation)
  local NewOperatoinStack = {}
  for _, value in ipairs(self.OperationStack) do
    if value ~= Operation then
      table.insert(NewOperatoinStack, value)
    end
  end
  self.OperationStack = NewOperatoinStack
end

function M:OnHideUIKeyDown()
  self:ToggleHideSelf()
end

function M:ToggleHideSelf()
  self.bSelfHidden = not self.bSelfHidden
  if self.bSelfHidden then
    AudioManager(self):PlayUISound(self, "event:/ui/common/camera_reset", "Camera_HideUI", nil)
    self:PushOperationStack("HideUI")
    self:AddWidgetHideTag("Top")
    self:AddWidgetHideTag("Bottom")
    self.Main:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Main:SetVisibility(UIConst.VisibilityOp.Visible)
    UIUtils.PlayCommonBtnSe(self)
    self:PopOperationStack("HideUI")
    self:RemoveWidgetHideTag("Top")
    self:RemoveWidgetHideTag("Bottom")
  end
end

function M:OnHideCharacterKeyDown()
  UIUtils.PlayCommonBtnSe(self)
  self:ToggleShowHideCharacterWidget()
end

function M:ToggleShowHideCharacterWidget()
  self.bShowHideCharacterWidget = not self.bShowHideCharacterWidget
  if self.bShowHideCharacterWidget then
    self:PushOperationStack("HideCharcater")
    self:RemoveWidgetHideTag("Menu")
    self:AddWidgetHideTag("Bottom")
    self.KeyDownEvent[self.ResetCameraKeyGamepad] = self.HiddenAllKeyDown
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  else
    self:PopOperationStack("HideCharcater")
    self:AddWidgetHideTag("Menu")
    self:RemoveWidgetHideTag("Bottom")
    self.KeyDownEvent[self.ResetCameraKeyGamepad] = self.OnResetCameraKeyDown
    self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
  end
end

function M:OnCloseHideModel()
  self:ToggleShowHideCharacterWidget()
end

function M:OnMenu_OutFinished()
  self.HorizontalBox:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.HorizontalBox_39:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.WBP_Camera_Scale_P:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Close:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:OnMenuPart_OutFinished()
  self.IsMenuPart_OutFinished = true
end

function M:SetWidgetsVisibilityByTag(Tag, bHitTestable)
  self["Set" .. Tag .. "WidgetVisibility"](self, bHitTestable)
end

function M:SetTopWidgetVisibility(bHitTestable)
  if bHitTestable then
    self.Btn_Shoot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Btn_Shoot:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
end

function M:SetBottomWidgetVisibility(bHitTestable)
  if bHitTestable then
    self.Zoom_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.HideUI_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Pause_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Reset_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Zoom_Key:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.HideUI_Key:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Pause_Key:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Reset_Key:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
end

function M:SetMenuWidgetVisibility(bHitTestable)
  self:SetBottomWidgetVisibility(not bHitTestable)
  if bHitTestable then
  else
  end
end

function M:SetESCWidgetVisibility(bHitTestable)
end

function M:SetMenuHideExcludeBottom()
  self:AddTimer(0.02, function()
    if self.WidgetHideTags.Bottom > 0 then
      self.Panel_Pause:SetRenderOpacity(0)
      self.WS_LeftCorner:SetRenderOpacity(0)
    end
  end, false, 0, "SetMenuHideExcludeBottom")
  self:UnbindFromAnimationFinished(self.WidgetHideAnims.Menu.Out, {
    self,
    self.SetMenuHideExcludeBottom
  })
end

function M:AddWidgetHideTag(Tag)
  if 0 == self.WidgetHideTags[Tag] then
    self:StopAnimation(self.WidgetHideAnims[Tag].In)
    self:PlayAnimation(self.WidgetHideAnims[Tag].Out)
    self:SetWidgetsVisibilityByTag(Tag, false)
  end
  self.WidgetHideTags[Tag] = self.WidgetHideTags[Tag] + 1
  if "Menu" == Tag and self.WidgetHideTags.Menu > 0 then
    self:BindToAnimationFinished(self.WidgetHideAnims[Tag].Out, {
      self,
      self.SetMenuHideExcludeBottom
    })
  end
end

function M:RemoveWidgetHideTag(Tag)
  self.WidgetHideTags[Tag] = self.WidgetHideTags[Tag] - 1
  if 0 == self.WidgetHideTags[Tag] then
    self:StopAnimation(self.WidgetHideAnims[Tag].Out)
    self:PlayAnimation(self.WidgetHideAnims[Tag].In)
    self:SetWidgetsVisibilityByTag(Tag, true)
  end
end

function M:TickFindTargets()
  M.Super.TickFindTargets(self)
  if self.InitParams and self.InitParams.IsAprilFoolsDayActivity then
    self.Btn_Shoot:StopLoopRemind()
    return
  end
  if self.bScreenshotWidgetShow or self.IsShotTargetSucceeded then
    self.Btn_Shoot:StopLoopRemind()
    return
  end
  if self.bFindTarget then
    self.Btn_Shoot:PlayLoopRemind()
  else
    self.Btn_Shoot:StopLoopRemind()
  end
end

function M:UpdateCheckBox()
  local Checked = self.CharType.All == self.CurCharHiddenState
end

function M:OnCheckBoxClicked()
  if self.CurCharHiddenState ~= self.CharType.All then
    self:SetCharHiddengState(self.CharType.All)
  else
    self:SetCharHiddengState(0)
  end
end

function M:OnResetCameraKeyDown()
  self:ResetCamera()
  if self.IsCustomizeOpened and self:IsCustomizeOpened() and self.ResetCameraCustomizeRoleRotationToDefault then
    self:ResetCameraCustomizeRoleRotationToDefault()
  end
end

function M:HiddenAllKeyDown()
end

function M:OnAddFocalLengthKeyDown()
  self.FocalLengthAdd = true
  self.FocalLengthKeyPressedTime = 0
  self.FocalLengthSlider:AddValue()
end

function M:OnAddFocalLengthKeyUp()
  self.FocalLengthAdd = false
  self.FocalLengthKeyPressedTime = 0
end

function M:CancelFocalLengLongPress()
  self.FocalLengthAdd = false
  self.FocalLengthSub = false
  self.FocalLengthKeyPressedTime = 0
  self.FocalLengthKeyPressedTime = 0
end

function M:OnSubFocalLengthKeyDown()
  self.FocalLengthSub = true
  self.FocalLengthKeyPressedTime = 0
  self.FocalLengthSlider:SubValue()
end

function M:OnSubFocalLengthKeyUp()
  self.FocalLengthSub = false
  self.FocalLengthKeyPressedTime = 0
end

function M:OnFocalLengthSliderValueChanged(Value)
  self:SetFocalLength(Value)
end

function M:OnBackKeyDown()
  if #self.OperationStack > 0 then
    if self.OperationStack[#self.OperationStack] == "HideCharcater" then
      self:OnHideCharacterKeyDown()
    elseif self.OperationStack[#self.OperationStack] == "ParameterWidget" then
      self:HideParameterWidget()
    else
      self:OnHideUIKeyDown()
    end
  else
    self:CheckHasAnyOperationOrClose()
  end
end

function M:OnGlobalGamePause()
  self:OnGamePauseBtnLockedClick()
end

function M:OnCameraMainCloseClicked()
  if self.IsCustomizeOpened and self:IsCustomizeOpened() then
    self:CloseCameraCustomizePanel()
    return
  end
  self:OnBackKeyDown()
end

function M:OnFocusLost(InFocusEvent)
end

function M:OnMouseCaptureLost()
  self.IsDragging = false
  self.RotateCameraByPointer = false
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.bIsFocusable = true
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self:EnsureCameraMainInputFocus()
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:SetLockGamePause(bNewLock)
  M.Super.SetLockGamePause(self, bNewLock)
end

function M:SetLockCameraPos(bNewLock)
  M.Super.SetLockCameraPos(self, bNewLock)
end

function M:SetLockHiddenButton(HiddenButton, bNewLock)
  M.Super.SetLockHiddenButton(self, HiddenButton, bNewLock)
  if bNewLock then
    self:SetLockHiddenAllButton(bNewLock)
  end
end

function M:SetLockAllHiddenButton(bNewLock)
  M.Super.SetLockAllHiddenButton(self, bNewLock)
  self:SetLockHiddenAllButton(bNewLock)
end

function M:GetCameraCustomizeCurrentInputType()
  if self.GameInputModeSubsystem and self.GameInputModeSubsystem.GetCurrentInputType then
    return self.GameInputModeSubsystem:GetCurrentInputType()
  end
  return UIUtils.UtilsGetCurrentInputType()
end

function M:IsCameraCustomizeHudGamepadInput()
  return self:GetCameraCustomizeCurrentInputType() == ECommonInputType.Gamepad
end

function M:SetCameraCustomizeShortcutVisible(Widget, bVisible)
  if not Widget or not Widget.SetVisibility then
    return
  end
  Widget:SetVisibility(bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:GetCameraCustomizePCShortcutWidgets()
  local Widgets = {}
  local WidgetNames = {
    "Move_Key",
    "Switch_Key",
    "Zoom_Key",
    "HideUI_Key",
    "Pause_Key",
    "Reset_Key"
  }
  for _, WidgetName in ipairs(WidgetNames) do
    if self[WidgetName] then
      table.insert(Widgets, self[WidgetName])
    end
  end
  return Widgets
end

function M:GetCameraCustomizeGamepadShortcutWidgets()
  local Widgets = {}
  local WidgetNames = {
    "Key_Controller_Move",
    "Key_Controller_Switch",
    "Key_Controller_Zoom",
    "Key_Controller_HideUI",
    "Key_Controller_Pause",
    "Key_Controller_Reset"
  }
  for _, WidgetName in ipairs(WidgetNames) do
    if self[WidgetName] then
      table.insert(Widgets, self[WidgetName])
    end
  end
  return Widgets
end

function M:IsCameraCustomizeGamepadShortcutVisibleWhenOpened(Widget)
  return Widget == self.Key_Controller_Pause or Widget == self.Key_Controller_Reset
end

function M:RefreshCameraCustomizeControllerShortcut(OpInfo)
  if not self.Key_Controller_Customize or not self.Key_Controller_Customize.SetVisibility then
    return
  end
  if not OpInfo then
    self.Key_Controller_Customize:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local Key = OpInfo.Key or "A"
  local TextKey = OpInfo.TextKey
  if self.CameraCustomizeControllerShortcutKey ~= Key or self.CameraCustomizeControllerShortcutTextKey ~= TextKey then
    self.CameraCustomizeControllerShortcutKey = Key
    self.CameraCustomizeControllerShortcutTextKey = TextKey
    if self.Key_Controller_Customize.CreateCommonKey then
      self.Key_Controller_Customize:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = Key,
            Owner = self
          }
        },
        SoundFunc = function()
        end,
        Desc = TextKey and GText(TextKey) or ""
      })
    end
  end
  self.Key_Controller_Customize:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:RefreshCameraCustomizeHudShortcutVisible()
  local bCustomizeOpened = self.IsCustomizeOpened and self:IsCustomizeOpened()
  local bGamepadInput = self:IsCameraCustomizeHudGamepadInput()
  if self.WS_RightCorner and self.WS_RightCorner.SetActiveWidgetIndex then
    self.WS_RightCorner:SetActiveWidgetIndex(bGamepadInput and 1 or 0)
  end
  for _, Widget in ipairs(self:GetCameraCustomizePCShortcutWidgets()) do
    local bBlockedPCShortcut = Widget == self.Switch_Key or Widget == self.HideUI_Key or Widget == self.Customize_Key
    self:SetCameraCustomizeShortcutVisible(Widget, not bGamepadInput and (not bCustomizeOpened or not bBlockedPCShortcut))
  end
  for _, Widget in ipairs(self:GetCameraCustomizeGamepadShortcutWidgets()) do
    local bVisible = bGamepadInput and (not bCustomizeOpened or self:IsCameraCustomizeGamepadShortcutVisibleWhenOpened(Widget))
    self:SetCameraCustomizeShortcutVisible(Widget, bVisible)
  end
  self:RefreshFocalLengthSliderKeyInfo()
  local OpInfo
  if bCustomizeOpened and bGamepadInput and self.GetCameraCustomizeFocusedControllerOpInfo then
    OpInfo = self:GetCameraCustomizeFocusedControllerOpInfo()
  end
  self:RefreshCameraCustomizeControllerShortcut(OpInfo)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputType, CurGamepadName)
  self.Key_Controller_Pause:SetVisibility(CurInputType == ECommonInputType.Gamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Hidden)
  self.WS_RightCorner:SetActiveWidgetIndex(CurInputType == ECommonInputType.Gamepad and 1 or 0)
  self:RefreshCameraCustomizeHudShortcutVisible()
  self:RefreshFocalLengthSliderKeyInfo()
  if self.bScreenshotWidgetShow and self.ScreenshotWidget then
    self.ScreenshotWidget:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  end
end

function M:RefreshFocalLengthSliderKeyInfo()
  local bGamepadInput = self.IsGamepadInput and (not self.IsCustomizeOpened or not self:IsCustomizeOpened()) and not self:IsParameterWidgetShowed()
  local Slider = self.WBP_Camera_Bar_P and self.WBP_Camera_Bar_P.Com_Slider
  Slider:UpdateUIStyleInPlatform(bGamepadInput, self.CurGamepadName)
end

function M:ShowScreenshotWidget(Image)
  M.Super.ShowScreenshotWidget(self, Image)
  if IsValid(self.ScreenshotWidget) then
    self.ScreenshotWidget:OnUpdateUIStyleByInputTypeChange(UIUtils.UtilsGetCurrentInputType())
  end
end

function M:OnScreenshotWidgetHidden(bSaved)
  M.Super.OnScreenshotWidgetHidden(self, bSaved)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  rawset(self, "IsGamepadInput", CurInputDevice == ECommonInputType.Gamepad)
  rawset(self, "CurGamepadName", CurGamepadName)
  local Widget = self:GetDesiredFocusTarget()
  if rawget(self, "bInFocusPath") then
    if Widget and not UIUtils.HasAnyFocus(Widget) then
      Widget:SetFocus()
    elseif Widget == self then
      self:SetFocus()
    end
  end
  self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Widget = self:GetDesiredFocusTarget()
  if Widget ~= self then
    return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), Widget)
  end
  return UIUtils.Handled
end

function M:GetDesiredFocusTarget()
  if self.bScreenshotWidgetShow and self.ScreenshotWidget then
    return self.ScreenshotWidget
  elseif self:IsParameterWidgetShowed() then
    return self.Parameter
  end
  return self
end

function M:NotifyGamePauseChange(IsGamePause)
  if self.CanChangeCameraCustomizePause and not self:CanChangeCameraCustomizePause(IsGamePause) then
    return false
  end
  if false == IsGamePause and self.RestoreCameraCustomizeRoleRotation then
    self:RestoreCameraCustomizeRoleRotation()
  end
  M.Super.NotifyGamePauseChange(self, IsGamePause)
  self.IsPause = true == IsGamePause
  local bSuppressPauseToast = true == self.bCameraCustomizeSuppressNextPauseStateToast
  self.bCameraCustomizeSuppressNextPauseStateToast = false
  if not bSuppressPauseToast and self.bCameraCustomizePauseToastReady and self.ShowCameraCustomizePauseStateToast then
    self:ShowCameraCustomizePauseStateToast(IsGamePause)
  else
    self.bCameraCustomizePauseToastReady = true
  end
  return true
end

function M:Close()
  if self.StopCameraCustomizeLookAtCamera then
    self:StopCameraCustomizeLookAtCamera()
  end
  if self.StopCameraCustomizeWheelAction then
    self:StopCameraCustomizeWheelAction()
  end
  if self.RestoreCameraCustomizeRoleRotation then
    self:RestoreCameraCustomizeRoleRotation()
  end
  M.Super.Close(self)
end

function M:Destruct()
  if self.StopCameraCustomizeLookAtCamera then
    self:StopCameraCustomizeLookAtCamera()
  end
  if self.StopCameraCustomizeWheelAction then
    self:StopCameraCustomizeWheelAction()
  end
  if self.RestoreCameraCustomizeRoleRotation then
    self:RestoreCameraCustomizeRoleRotation()
  end
  self:UnbindCameraCustomizeInputModeEvent()
  if self.UnbindCameraCustomizeRegionOnlineInteractionEvent then
    self:UnbindCameraCustomizeRegionOnlineInteractionEvent()
  end
  M.Super.Destruct(self)
end

AssembleComponents(M)
return M
