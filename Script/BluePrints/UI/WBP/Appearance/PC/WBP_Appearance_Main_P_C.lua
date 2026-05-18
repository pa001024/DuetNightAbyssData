require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Appearance.WBP_Appearance_Main_Base_C"
})
M._components = {
  "BluePrints.UI.KeyInputComponent"
}

function M:Construct()
  self.IsPC = true
  self.bIsFocusable = true
  M.Super.Construct(self)
  self:SetIsShowNavigateGuide(false)
  self:CreateKeySetting()
  self:InitKeyEvents()
  self:AddInputMethodChangedListen()
end

function M:InitKeyEvents()
  self:ClearAllKeyEvents()
  self:AddKeyDownEvent(EKeys.U.KeyName, self.OnHideUIKeyDown)
  self:AddRepeatKeyDownEvent(UIConst.GamePadKey.LeftTriggerThreshold, self.OnCameraScrollBackwardKeyDown)
  self:AddRepeatKeyDownEvent(UIConst.GamePadKey.RightTriggerThreshold, self.OnCameraScrollForwardKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonLeft, self.OnHideUIKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonRight, self.OnBackKeyDown)
  self:AddKeyDownEvent(EKeys.Escape.KeyName, self.OnBackKeyDown)
  if self.bSelfHidden then
    return
  end
  self:AddTabChangeKeyEvent()
end

function M:RemoveTabChangeKeyEvent()
  self:RemoveKeyDownEvent(EKeys.Q.KeyName, self.OnMainTabLeftKeyDown)
  self:RemoveKeyDownEvent(EKeys.E.KeyName, self.OnMainTabRightKeyDown)
  self:RemoveKeyDownEvent(UIConst.GamePadKey.LeftShoulder, self.OnMainTabLeftKeyDown)
  self:RemoveKeyDownEvent(UIConst.GamePadKey.RightShoulder, self.OnMainTabRightKeyDown)
end

function M:AddTabChangeKeyEvent()
  self:AddKeyDownEvent(EKeys.Q.KeyName, self.OnMainTabLeftKeyDown)
  self:AddKeyDownEvent(EKeys.E.KeyName, self.OnMainTabRightKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.LeftShoulder, self.OnMainTabLeftKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.RightShoulder, self.OnMainTabRightKeyDown)
end

function M:OnHideUIKeyDown()
  M.Super.OnHideUIKeyDown(self)
  self:InitKeyEvents()
  if self.bSelfHidden then
    return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self), true
  end
  if self.CurMainWidget then
    return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.CurMainWidget), true
  end
end

function M:CreateKeySetting()
  self.HideUI_KeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText("U"),
        ClickCallback = self.OnHideUIKeyDown,
        Owner = self
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "X",
        ClickCallback = self.OnHideUIKeyDown,
        Owner = self
      }
    },
    Desc = GText("UI_Dye_HideUI")
  }
  self.ZoomKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = "Mouse_Button",
        Owner = self
      }
    },
    GamePadInfoList = {
      {Type = "Or"},
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
    Desc = GText("UI_Dye_Zoom"),
    bLongPress = false
  }
  self.RightThumbstickAnalogBottomKeyInfoList = {
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "RH"}
    },
    Desc = GText("UI_CTL_RotatePreview")
  }
  self.ESCKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText(EKeys.Escape.KeyName),
        ClickCallback = self.OnBackKeyDown,
        Owner = self
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        ClickCallback = self.OnBackKeyDown,
        Owner = self
      }
    },
    Desc = GText("UI_BACK")
  }
  self.BottomKeyInfoList = {
    self.HideUI_KeyInfoList,
    self.ZoomKeyInfoList,
    self.RightThumbstickAnalogBottomKeyInfoList,
    self.ESCKeyInfoList
  }
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  if self.CurMainWidget then
    self.CurMainWidget:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  end
  if not self.IsInFocusPath then
    return
  end
  if self.bSelfHidden then
    return
  end
  if self.CurMainWidget and not UIUtils.HasAnyFocus(self.CurMainWidget) then
    self.CurMainWidget:SetFocus()
  end
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
  local Reply, IsHandled
  if self.CurMainWidget and not self.bSelfHidden then
    Reply, IsHandled = self.CurMainWidget:OnParentRepeatKeyDown(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  local Reply, IsHandled = self:ProcessOnRepeatKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UIUtils.Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Reply, IsHandled
  if self.CurMainWidget and not self.bSelfHidden then
    Reply, IsHandled = self.CurMainWidget:OnParentKeyDown(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  local Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UIUtils.Handled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local Reply, IsHandled
  if self.CurMainWidget and not self.bSelfHidden then
    Reply, IsHandled = self.CurMainWidget:OnParentKeyUp(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  local Reply, IsHandled = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UIUtils.Handled
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local Reply, IsHandled
  if self.CurMainWidget and self.CurMainWidget.OnParentAnalogValueChanged then
    Reply, IsHandled = self.CurMainWidget:OnParentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    if IsHandled then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

function M:OnMainTabLeftKeyDown()
  self.Com_Tab:TabToLeft()
  return UIUtils.Handled, true
end

function M:OnMainTabRightKeyDown()
  self.Com_Tab:TabToRight()
  return UIUtils.Handled, true
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if not self.EnableDrag then
    return UIUtils.Unhandled
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightX" == InKeyName then
    if self.ActorController then
      local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
      self.ActorController:OnDragViewActor({X = DeltaX})
    end
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnCameraScrollBackwardKeyDown()
  self:ScrollCamera(1)
  return UIUtils.Handled, true
end

function M:OnCameraScrollForwardKeyDown()
  self:ScrollCamera(-1)
  return UIUtils.Handled, true
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.bSelfHidden then
    return UIUtils.Handled
  end
  if self.CurMainWidget then
    return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.CurMainWidget)
  end
  return UIUtils.Handled
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
end

AssembleComponents(M)
return M
