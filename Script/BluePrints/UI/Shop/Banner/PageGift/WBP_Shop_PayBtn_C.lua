require("UnLua")
local WBP_Shop_GiftPayBtn_C = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function WBP_Shop_GiftPayBtn_C:Construct()
  self.Super.Construct(self, self.Btn_Buy)
  self:BindInputMethodChangedDelegate()
  self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
  self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
  self:RefreshIconAndGamePadVisibility()
  self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:SetKey_PCVisibility(UIConst.VisibilityOp.Collapsed)
  self.bGamepadIconVisible = false
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
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    if self.WS_Key then
      self.WS_Key:SetActiveWidgetIndex(0)
    end
    if self.bGamepadIconVisible or self.bGamepadIconVisible == nil then
      self:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    end
  else
    if self.WS_Key then
      self.WS_Key:SetActiveWidgetIndex(1)
    end
    self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function WBP_Shop_GiftPayBtn_C:SetGamePadImg(ImgShortPath, ImgLongPath)
  self.Key_ControllerBuy:SetImage("Img", ImgShortPath)
end

function WBP_Shop_GiftPayBtn_C:SetDefaultGamePadImg(ImgShortPath)
  self.GamePadImgName = ImgShortPath
  self:SetGamePadImg(self.GamePadImgName)
end

function WBP_Shop_GiftPayBtn_C:SetGamePadVisibility(Op)
  self.Key_ControllerBuy:SetVisibility(Op)
end

function WBP_Shop_GiftPayBtn_C:SetGamePadIconVisible(IsVisible)
  self.bGamepadIconVisible = IsVisible
  self:RefreshIconAndGamePadVisibility()
end

function WBP_Shop_GiftPayBtn_C:SetPCImg(ImgShortPath, ImgLongPath)
  if not self.Key_PCBuy or CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC" then
    return
  end
  self.Key_PCBuy:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        ImgShortPath = ImgShortPath,
        ImgLongPath = ImgLongPath
      }
    },
    bLongPress = self:GetIsLongPressButton(),
    bButton = self:GetIsLongPressButton()
  })
  self:SetKey_PCVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function WBP_Shop_GiftPayBtn_C:SetKey_PCVisibility(Op)
  if self.Key_PCBuy then
    self.Key_PCBuy:SetVisibility(Op)
  end
end

return WBP_Shop_GiftPayBtn_C
