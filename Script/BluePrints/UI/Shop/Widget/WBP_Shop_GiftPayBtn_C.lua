require("UnLua")
local WBP_Shop_GiftPayBtn_C = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function WBP_Shop_GiftPayBtn_C:Construct()
  self.Super.Construct(self, self.Button_Area)
  self:BindInputMethodChangedDelegate()
  self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
  self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
  self:RefreshIconAndGamePadVisibility()
  self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  self.IsGamePadIconVisible = false
  self.IsDisabled = false
end

function WBP_Shop_GiftPayBtn_C:SwitchNormalAnimation()
  self:PlayAnimation(self.UnHover)
  self:PlayAnimation(self.Normal)
end

function WBP_Shop_GiftPayBtn_C:Destruct()
  self:UnBindInputMethodChangedDelegate()
  self.Super.Destruct(self)
end

function WBP_Shop_GiftPayBtn_C:BindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function WBP_Shop_GiftPayBtn_C:UnBindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
end

function WBP_Shop_GiftPayBtn_C:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  self.CurInputDeviceType = NewGameInputType
  self.CurGamepadName = NewGamepadName
  self:RefreshIconAndGamePadVisibility()
end

function WBP_Shop_GiftPayBtn_C:RefreshIconAndGamePadVisibility()
  if not self.IsGamePadIconVisible then
    self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function WBP_Shop_GiftPayBtn_C:SetGamePadVisibility(Op)
  self.Img_GamePad:SetVisibility(Op)
end

function WBP_Shop_GiftPayBtn_C:SetGamePadIconVisible(IsVisible)
  self.IsGamePadIconVisible = IsVisible
  self:RefreshIconAndGamePadVisibility()
end

function WBP_Shop_GiftPayBtn_C:PlayButtonDisableAnim()
  self:StopAllAnimations()
  self:DestroyAllAnmations()
  self:PlayAnimation(self.Disable)
end

function WBP_Shop_GiftPayBtn_C:PlayButtonEnableAnim()
  if self.IsHovering then
    self:PlayButtonHoverAnim()
  else
    self:SwitchNormalAnimation()
  end
end

function WBP_Shop_GiftPayBtn_C:IsBtnDisabled()
  return self.IsDisabled
end

function WBP_Shop_GiftPayBtn_C:DisableBtn(IsDisable)
  if IsDisable == self.IsDisabled then
    return
  end
  self:UnbindAllFromAnimationFinished(self.UnHover)
  if self.IsDisabled == false and true == IsDisable then
    self.IsDisabled = true
    self.IsForbidden = true
    self:PlayButtonDisableAnim()
  elseif self.IsDisabled == true and false == IsDisable then
    self.IsDisabled = false
    self.IsForbidden = false
    self:PlayButtonEnableAnim()
  end
end

return WBP_Shop_GiftPayBtn_C
