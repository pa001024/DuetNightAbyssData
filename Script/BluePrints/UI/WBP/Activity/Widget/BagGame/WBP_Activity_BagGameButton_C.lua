require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC"
})

function M:Construct()
  self.WS_Text:SetActiveWidgetIndex(1)
  self.Text:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:BindInputMethodChangedDelegate()
  self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
  self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
  self:SetGamePadImg(self.GamePadImgName)
  self.bAutoButtonChange = true
  self:RefreshIconAndGamePadVisibility()
  self.Super.Construct(self, self.Button_Area)
  self.bGamepadIconVisible = true
  self:PlayButtonUnForbidAnim()
  self:SetKey_PCVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:Destruct()
  self:UnBindInputMethodChangedDelegate()
  self.Super.Destruct(self)
end

function M:RefreshIconAndGamePadVisibility()
  if not self.bAutoButtonChange then
    return
  end
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    if self.WS_Key then
      self.WS_Key:SetActiveWidgetIndex(0)
    end
    if self.bGamepadIconVisible or self.bGamepadIconVisible == nil then
      self:SetGamePadVisibility(self.OverrideGamePadVisibilityOp or UIConst.VisibilityOp.SelfHitTestInvisible)
      self:SetIconPanelVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
      self:SetIconPanelVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  else
    if self.WS_Key then
      self.WS_Key:SetActiveWidgetIndex(1)
    end
    self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self:SetIconPanelVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:BindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function M:UnBindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
end

function M:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  self.CurInputDeviceType = NewGameInputType
  self.CurGamepadName = NewGamepadName
  self:RefreshIconAndGamePadVisibility()
end

function M:GetText()
  local button_text = self.Text_Button:GetText()
  return button_text
end

function M:SetText(Text)
  self.Text_Button:SetText(Text)
end

function M:SetNewIcon(ImgPath)
  self:SetIconPanelVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  UE4.UResourceLibrary.LoadObjectAsync(self, ImgPath, {
    self,
    function(_, Image)
      local ImageWidget = self.Img_Slot:GetChildAt(0)
      if ImageWidget then
        ImageWidget:SetBrushResourceObject(Image)
      end
    end
  })
end

function M:SetIconPanelVisibility(Op)
  self.Img_Slot:SetVisibility(Op)
  if Op == UIConst.VisibilityOp.Collapsed or Op ~= UIConst.VisibilityOp.Hidden then
  else
  end
end

function M:SetTextColor(InColorAndOpacity)
  self.Text_Button:SetColorAndOpacity(InColorAndOpacity)
end

function M:SetIconColor(HexColorString)
  if not HexColorString then
    return
  end
  local ImageWidget = self.Img_Slot:GetChildAt(0)
  if ImageWidget then
    ImageWidget:SetBrushTintColor(UE4.UUIFunctionLibrary.StringToSlateColor(HexColorString))
  end
end

function M:SwitchNormalAnimation()
  DebugPrint(LXYTag, "覆盖掉蓝图的SwitchNormalAnimation")
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:SetGamePadImg(ImgShortPath, ImgLongPath)
  self.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = ImgShortPath,
        ImgLongPath = ImgLongPath
      }
    },
    bLongPress = self:GetIsLongPressButton(),
    bButton = self:GetIsLongPressButton()
  })
end

function M:SetDefaultGamePadImg(ImgShortPath)
  self.GamePadImgName = ImgShortPath
  self:SetGamePadImg(self.GamePadImgName)
end

function M:SetGamePadVisibility(Op)
  self.Key_GamePad:SetVisibility(Op)
end

function M:OverrideGamePadVisibility(Op)
  self.OverrideGamePadVisibilityOp = Op
end

function M:SetPCVisibility(IsShow)
  if IsShow then
    self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self:SetIconPanelVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self:SetGamePadVisibility(self.OverrideGamePadVisibilityOp or UIConst.VisibilityOp.SelfHitTestInvisible)
    self:SetIconPanelVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetGamepadIconVisibility(bShow)
  self.bGamepadIconVisible = bShow
  self:RefreshIconAndGamePadVisibility()
end

function M:SetPCImg(ImgShortPath, ImgLongPath)
  if not self.Key_PC or CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC" then
    return
  end
  self.Key_PC:CreateCommonKey({
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

function M:SetKey_PCVisibility(Op)
  if self.Key_PC then
    self.Key_PC:SetVisibility(Op)
  end
end

function M:PlayLongPressAnimation()
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self.Key_GamePad:OnButtonPressed(false, true, 0, self.LongPressDuration)
  else
    local Speed = self.LongPress:GetEndTime() / self.LongPressDuration
    self:PlayAnimation(self.LongPress, 0, 1, EUMGSequencePlayMode.Forward, Speed, false)
    if self.Key_PC then
      self.Key_PC:OnButtonPressed(false, true, 0, self.LongPressDuration)
    end
  end
end

function M:StopLongPressAnimation()
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self.Key_GamePad:OnButtonReleased()
    self.Key_GamePad:StopAllAnimations()
    self.Key_GamePad:PlayAnimation(self.Key_GamePad.Normal)
  else
    if self.Key_PC then
      self.Key_PC:OnButtonReleased()
      self.Key_PC:StopAllAnimations()
      self.Key_PC:PlayAnimation(self.Key_PC.Normal)
    end
    self:PlayAnimation(self.LongPress)
    self:StopAnimation(self.LongPress)
  end
end

function M:PlayButtonForbidAnim()
  self.Key_GamePad:DisableKey()
  if self.Key_PC then
    self.Key_PC:DisableKey()
  end
  self.Super.PlayButtonForbidAnim(self)
end

function M:PlayButtonUnForbidAnim()
  self.Key_GamePad:EnableKey()
  if self.Key_PC then
    self.Key_PC:EnableKey()
  end
  self.Super.PlayButtonUnForbidAnim(self)
end

return M
