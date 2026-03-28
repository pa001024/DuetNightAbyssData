require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Button.Common_Button_PC")

function M:Construct()
  self.Super.Construct(self, self.Btn_Click)
  self:BindInputMethodChangedDelegate()
  self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
  self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
  self.bAutoButtonChange = true
  self:RefreshIconAndGamePadVisibility()
  self.bGamepadIconVisible = true
end

function M:Destruct()
  self:UnBindInputMethodChangedDelegate()
  self.Super.Destruct(self)
end

function M:SwitchNormalAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:RefreshIconAndGamePadVisibility()
  if not self.bAutoButtonChange then
    return
  end
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    if self.bGamepadIconVisible or self.bGamepadIconVisible == nil then
      self:SetGamePadVisibility(self.OverrideGamePadVisibilityOp or UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    end
  else
    self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
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

function M:SetGamePadImg(ImgShortPath, ImgLongPath)
  self.Controller_Erase:CreateCommonKey({
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
  self.Controller_Erase:SetVisibility(Op)
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

return M
