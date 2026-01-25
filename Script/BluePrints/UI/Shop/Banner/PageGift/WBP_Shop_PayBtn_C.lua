require("UnLua")
local WBP_Shop_GiftPayBtn_C = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function WBP_Shop_GiftPayBtn_C:Construct()
  self.Super.Construct(self, self.Btn_Buy)
  self:BindInputMethodChangedDelegate()
  self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
  self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
  self:RefreshIconAndGamePadVisibility()
  self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  self.IsGamePadIconVisible = false
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

function WBP_Shop_GiftPayBtn_C:SetGamePadImg(ImgShortPath, ImgLongPath)
  local ImgPath, Img
  if ImgShortPath and "None" ~= ImgShortPath then
    ImgPath = UIUtils.UtilsGetKeyIconPathInGamepad(ImgShortPath, self.CurGamepadName)
    Img = LoadObject(ImgPath)
  elseif ImgLongPath then
    Img = LoadObject(ImgLongPath)
  end
  if not IsValid(Img) then
    DebugPrint("缺少图片资源: ImgPath = ", ImgPath, ImgShortPath, ImgLongPath)
    return
  end
  self.Key_ControllerBuy:SetBrushResourceObject(Img)
end

function WBP_Shop_GiftPayBtn_C:SetDefaultGamePadImg(ImgShortPath)
  self.GamePadImgName = ImgShortPath
  self:SetGamePadImg(self.GamePadImgName)
end

function WBP_Shop_GiftPayBtn_C:SetGamePadVisibility(Op)
  self.Key_ControllerBuy:SetVisibility(Op)
end

function WBP_Shop_GiftPayBtn_C:SetGamePadIconVisible(IsVisible)
  self.IsGamePadIconVisible = IsVisible
  self:RefreshIconAndGamePadVisibility()
end

return WBP_Shop_GiftPayBtn_C
