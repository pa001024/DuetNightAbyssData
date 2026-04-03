require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function M:SetText(Text)
  self.Text_Cell:SetText(Text)
end

function M:BindOnClick(BindObj, OnClick)
  self.BindObj = BindObj
  self.OnClick = OnClick
end

function M:Construct()
  M.Super.Construct(self, self.Button_Area)
  self.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Button_Area.OnClicked:Add(self, self.BtnAreaOnClicked)
  self.Button_Forbid.OnClicked:Add(self, self.BtnAreaOnClicked)
  self.bForbidden = false
  ChatController:UnRegisterEvent(self.Key_Text)
  self.Key_Text:SetForbidKey(false)
end

function M:BtnAreaOnClicked()
  if self.OnClick and self.BindObj then
    self.OnClick(self.BindObj)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
end

function M:OnListItemObjectSet(Content)
  Content.UI = self
  self.IsEnter = nil
  self.Owner = Content.Owner
  self.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
  self:SetText(Content.Text)
  self:BindOnClick(Content.Owner, Content.Callback)
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    self.Key_Text:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = self
        }
      }
    })
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if IsValid(GameInputModeSubsystem) then
      GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
      self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
      self:UpdateUIStyleInPlatform()
    end
  end
end

function M:PlayBtnAnim(Anim)
  self:StopAllAnimations()
  self:PlayAnimation(Anim)
end

function M:Destruct()
  self.BindObj = nil
  self.OnClick = nil
  self.bForbidden = nil
  self.Button_Area.OnClicked:Remove(self, self.BtnAreaOnClicked)
  self.Button_Forbid.OnClicked:Remove(self, self.BtnAreaOnClicked)
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if IsValid(GameInputModeSubsystem) then
      GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
  end
end

function M:SetForbidden()
  if self.bForbidden then
    return
  end
  self.bForbidden = true
  self.Button_Area:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Button_Forbid:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Button_Area:SetForbidden(true)
  self:StopAllAnimations()
  self:PlayAnimation(self.Forbidden)
  self.Key_Text:SetForbidKey(true)
end

function M:SetNormal()
  if not self.bForbidden then
    return
  end
  self.bForbidden = false
  self.Button_Forbid:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Button_Area:SetForbidden(false)
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
  self.Key_Text:SetForbidKey(false)
end

function M:IsChatBtnForbidden()
  return self.bForbidden
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self:UpdateUIStyleInPlatform()
end

function M:UpdateUIStyleInPlatform()
  local IsShow = self.IsEnter and self.CurInputDeviceType == ECommonInputType.Gamepad
  self.Key_Text:SetVisibility(IsShow and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self.IsEnter = true
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return UIUtils.Handle
  end
  if self.Owner.CurrSelectItem then
    self.Owner.CurrSelectItem:UnSelect()
  end
  self:Select()
  self.Owner.CurrSelectItem = self
  return UIUtils.Handle
end

function M:Select()
  self.IsEnter = true
  self:UpdateUIStyleInPlatform()
end

function M:UnSelect()
  self.IsEnter = false
  self:UpdateUIStyleInPlatform()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == Const.GamepadFaceButtonDown then
    self:BtnAreaOnClicked()
    local Handled = UWidgetBlueprintLibrary.Handled()
    local Owner = self.Owner and self.Owner.Owner
    local CommonDialogWindow = UIManager(self):GetUIObj("CommonDialog")
    if Owner and not CommonDialogWindow then
      return UWidgetBlueprintLibrary.SetUserFocus(Handled, Owner)
    end
    return Handled
  end
  return UWidgetBlueprintLibrary.UnHandled()
end

return M
