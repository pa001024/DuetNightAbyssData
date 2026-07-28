require("UnLua")
local Common_Button_Reward_PC = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function Common_Button_Reward_PC:Construct()
  self.Super.Construct(self, self.Button_Area)
  self:BindInputMethodChangedDelegate()
  self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
  self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
  self:SetGamePadImg(self.GamePadImgName)
  self:RefreshIconAndGamePadVisibility()
  self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  self:SetKey_PCVisibility(UIConst.VisibilityOp.Collapsed)
  self.bGamepadIconVisible = false
end

function Common_Button_Reward_PC:SetText(Text)
  self.Text_Button:SetText(Text)
end

function Common_Button_Reward_PC:SwitchNormalAnimation()
  self:PlayAnimation(self.UnHover)
  self:PlayAnimation(self.Normal)
end

function Common_Button_Reward_PC:Destruct()
  self:UnBindInputMethodChangedDelegate()
  self.Super.Destruct(self)
end

function Common_Button_Reward_PC:BindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function Common_Button_Reward_PC:UnBindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
end

function Common_Button_Reward_PC:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  self.CurInputDeviceType = NewGameInputType
  self.CurGamepadName = NewGamepadName
  self:RefreshIconAndGamePadVisibility()
end

function Common_Button_Reward_PC:RefreshIconAndGamePadVisibility()
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

function Common_Button_Reward_PC:SetGamePadImg(ImgShortPath, ImgLongPath)
  if self.Key_GamePad then
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
  else
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
    self.Img_GamePad:SetBrushResourceObject(Img)
  end
end

function Common_Button_Reward_PC:SetDefaultGamePadImg(ImgShortPath)
  self.GamePadImgName = ImgShortPath
  self:SetGamePadImg(self.GamePadImgName)
end

function Common_Button_Reward_PC:SetGamePadVisibility(Op)
  if self.Key_GamePad then
    self.Key_GamePad:SetVisibility(Op)
  else
    self.Img_GamePad:SetVisibility(Op)
  end
end

function Common_Button_Reward_PC:SetGamePadIconVisible(IsVisible)
  self.bGamepadIconVisible = IsVisible
  self:RefreshIconAndGamePadVisibility()
end

function Common_Button_Reward_PC:SetPCImg(ImgShortPath, ImgLongPath)
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC" or not self.Key_PC then
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

function Common_Button_Reward_PC:SetKey_PCVisibility(Op)
  if not self.Key_PC then
    return
  end
  self.Key_PC:SetVisibility(Op)
end

return Common_Button_Reward_PC
