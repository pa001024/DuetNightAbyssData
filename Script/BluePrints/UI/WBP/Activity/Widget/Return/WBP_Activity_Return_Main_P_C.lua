require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Activity.Widget.Return.ActivityReturnMainBase"
})

function M:Construct(...)
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self:BindToAnimationFinished(self.In, {
    self,
    function()
      if self.CurSubTab then
        self.CurSubTab:SetFocus()
      end
    end
  })
  self:UpdateComTab("SubTab")
end

function M:Destruct(...)
end

function M:UpdateComTab(TargetState)
  if self.CurBottomKeyState == TargetState then
    return
  end
  if "SevenDayReward" == TargetState then
    local BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Text",
            Text = "A",
            ClickCallback = nil,
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckDetails")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    self.Com_Tab_P:UpdateBottomKeyInfo(BottomKeyInfo)
  elseif "SubTab" == TargetState then
    local BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Text",
            Text = "A",
            ClickCallback = nil,
            Owner = self
          }
        },
        Desc = GText("UI_Controller_Check")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    self.Com_Tab_P:UpdateBottomKeyInfo(BottomKeyInfo)
  elseif "PC" == TargetState then
    local BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    self.Com_Tab_P:UpdateBottomKeyInfo(BottomKeyInfo)
  end
  self.CurBottomKeyState = TargetState
end

function M:OnReturnKeyDown()
  if self.bIsSubWidgetFocused and UIUtils.IsGamepadInput() then
    self.CurSubTab:SetFocus()
    self.bIsSubWidgetFocused = false
    self:UpdateComTab("SubTab")
  else
    self:CloseSelf()
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) or InKeyName ~= Const.GamepadFaceButtonDown or self:HasAnyUserFocus() then
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == Const.GamepadFaceButtonRight then
      IsEventHandled = true
      self:OnReturnKeyDown()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop and self.CurChildWidget and self.CurChildWidget.ActivityReturnType == "InviteCode" then
      IsEventHandled = true
      self.CurChildWidget:OpenReturnInviteCode()
    end
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:OnReturnKeyDown()
  end
  IsEventHandled = IsEventHandled or self.CurChildWidget:OnKeyDown(MyGeometry, InKeyEvent)
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnAddedToFocusPath()
  self.IsInFocusPath = true
end

function M:OnRemovedFromFocusPath()
  self.IsInFocusPath = false
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:RefreshOpInfoByInputDevice(ECommonInputType.Gamepad)
  elseif UIUtils.UtilsGetCurrentInputType() == ECommonInputType.MouseAndKeyboard then
    self:RefreshOpInfoByInputDevice(ECommonInputType.MouseAndKeyboard)
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Gamepad then
    if not self.CurChildWidget or not self.CurChildWidget.HandleFocus then
      self.bIsSubWidgetFocused = false
      self.CurSubTab:SetFocus()
      self:UpdateComTab("SubTab")
    end
  else
    self:UpdateComTab("PC")
  end
  if self.CurChildWidget and self.CurChildWidget.RefreshOpInfoByInputDevice then
    self.CurChildWidget:RefreshOpInfoByInputDevice()
  end
end

function M:OnSubTabNavigationRight()
  if self.CurChildWidget and self.CurChildWidget.OnSubTabNavigationRight then
    self.CurChildWidget:OnSubTabNavigationRight()
    self.bIsSubWidgetFocused = true
    self:UpdateComTab("SevenDayReward")
  end
end

return M
