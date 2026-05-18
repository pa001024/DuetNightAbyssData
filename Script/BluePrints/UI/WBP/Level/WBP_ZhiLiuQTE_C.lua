require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local PC_QTE_KEY_NAME = "F"
local GAME_VIEWPORT_INPUT_KEY_PRESSED = "GameViewportInputKeyPressed"
local GAME_VIEWPORT_INPUT_KEY_RELEASED = "GameViewportInputKeyReleased"

function M:Construct()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self.Btn_Click.OnPressed:Add(self, self.PressedSelectAction)
    self.Btn_Click.OnReleased:Add(self, self.ReleasedSelectAction)
  else
    self:AddDispatcher(GAME_VIEWPORT_INPUT_KEY_PRESSED, self, self.OnGlobalKeyDown)
    self:AddDispatcher(GAME_VIEWPORT_INPUT_KEY_RELEASED, self, self.OnGlobalKeyUp)
  end
end

function M:OnLoaded(...)
  self.Owner, self.InteractiveNum, self.InteractiveTime, self.DownTime = ...
  self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self.FirstInteractive = false
  self.InPress = false
  self.Complete = false
  self.CurInteractiveNum = 0
  self.CurInteractivePercent = 0.0
  self.Material = self.Progress_Bar_LongPress:GetDynamicMaterial()
  self.CanInteract = false
  self:StopAllAnimations()
  self:PlayAnimation(self.In)
  self:BindToAnimationFinished(self.In, {
    self,
    function()
      self.CanInteract = true
      self:PlayAnimation(self.Remind)
    end
  })
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      self:Close()
    end
  })
  self:BindToAnimationFinished(self.Success, {
    self,
    self.OnFirstSuccess
  })
  self:SetBarPercent(0.0)
  DebugPrint("zwkkk WBP_ZhiLiuQTE_C OnLoaded ", self.InteractiveNum, self.InteractiveTime, self.DownTime)
  self.Panel_LongPress:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:InitImage()
  AudioManager(self):PlayUISound(self, "event:/ui/common/qte_show", "QTEShow", nil)
end

function M:Tick(MyGeometry, InDeltaTime)
  if self.Complete then
    return
  end
  if not self.CanInteract then
    return
  end
  if self.Owner and 2 ~= self.Owner.CurStage then
    return
  end
  if self.InPress then
    self.CurInteractivePercent = math.min(1.0, self.CurInteractivePercent + InDeltaTime / self.InteractiveTime)
  elseif self.DownTime > 0 then
    self.CurInteractivePercent = math.max(0.0, self.CurInteractivePercent - InDeltaTime / self.DownTime)
  end
  self:SetBarPercent(self.CurInteractivePercent)
  if self.CurInteractivePercent >= 1.0 then
    self.Complete = true
    self.Owner:SecondStageComplete()
  end
end

function M:OnFirstSuccess()
  self:UnbindAllFromAnimationFinished(self.In)
  self:BindToAnimationFinished(self.In, function()
    self.CanInteract = true
  end)
  self:AddTimer(0.5, function()
    self:PlayAnimation(self.In)
    self.Panel_LongPress:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end, false, 0)
end

function M:PressedSelectAction()
  if not self.CanInteract then
    return
  end
  if not self.Owner then
    return
  end
  if not self.FirstInteractive and 1 == self.Owner.CurStage then
    self.FirstInteractive = true
    self.Owner:OnEnterInteractive()
  end
  if 1 == self.Owner.CurStage then
    self.CurInteractiveNum = self.CurInteractiveNum + 1
    self:PlayAnimation(self.FeedBack)
    if self.CurInteractiveNum >= self.InteractiveNum then
      self.Owner:FirstStageComplete()
      self:PlayAnimation(self.LongPress)
      self:PlayAnimationReverse(self.Remind)
      self.CanInteract = false
      AudioManager(self):PlayUISound(self, "event:/ui/common/qte_success", "", nil)
      self:PlayAnimation(self.Success)
    end
  elseif 2 == self.Owner.CurStage then
    self.InPress = true
    AudioManager(self):PlayUISound(self, "event:/ui/common/qte_press_loop", "QTEPress", nil)
    self.Owner:LongPressEnter()
  end
end

function M:ReleasedSelectAction()
  if not self.CanInteract then
    return
  end
  if not self.Owner then
    return
  end
  self.InPress = false
  if 2 == self.Owner.CurStage then
    AudioManager(self):StopSound(self, "QTEPress")
    self.Owner:LongPressLeave()
  end
end

function M:SetBarPercent(Percent)
  if self.Material then
    self.Material:SetScalarParameterValue("Percent", Percent)
  end
end

function M:OnOut()
  self:StopAllAnimations()
  AudioManager(self):StopSound(self, "QTEShow")
  self:PlayAnimation(self.Out)
end

function M:OnEnd()
  self:UnbindAllFromAnimationFinished(self.Success)
  self:BindToAnimationFinished(self.Success, {
    self,
    function()
      AudioManager(self):StopSound(self, "QTEShow")
      self:Close()
    end
  })
  AudioManager(self):PlayUISound(self, "event:/ui/common/qte_success", "", nil)
  self:PlayAnimation(self.Success)
end

function M:InitImage()
  if self.CurInputDeviceType == ECommonInputType.GamePad then
    self:InitGamepadView()
  elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self:InitMobileView()
  else
    self:InitKeyBoardView()
  end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  self.CurInputDeviceType = CurInputType
  if self.CurInputDeviceType == ECommonInputType.GamePad then
    self:InitGamepadView()
  elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self:InitMobileView()
  else
    self:InitKeyBoardView()
  end
  M.Super.RefreshOpInfoByInputDevice(self, CurInputType, CurGamepadName)
end

function M:InitGamepadView()
  self.Key_Handle:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "Y",
        bLargeSize = true
      }
    }
  })
end

function M:InitKeyBoardView()
  self.Key_Handle:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = PC_QTE_KEY_NAME,
        bLargeSize = true
      }
    }
  })
end

function M:InitMobileView()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnGlobalKeyDown(Key)
  if not Key then
    return
  end
  local InKeyName = Key.KeyName
  if self:Handle_OnGamePadDown(InKeyName) then
    return
  end
  self:Handle_OnKeyBoardDown(InKeyName)
end

function M:Handle_OnGamePadDown(InKeyName)
  if "Gamepad_FaceButton_Top" == InKeyName then
    self:PressedSelectAction()
    return true
  end
  return false
end

function M:Handle_OnKeyBoardDown(InKeyName)
  if InKeyName == PC_QTE_KEY_NAME then
    self:PressedSelectAction()
    return true
  end
  return false
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnGlobalKeyUp(Key)
  if not Key then
    return
  end
  local InKeyName = Key.KeyName
  if self:Handle_OnGamePadUp(InKeyName) then
    return
  end
  self:Handle_OnKeyBoardUp(InKeyName)
end

function M:Handle_OnGamePadUp(InKeyName)
  if "Gamepad_FaceButton_Top" == InKeyName then
    self:ReleasedSelectAction()
    return true
  end
  return false
end

function M:Handle_OnKeyBoardUp(InKeyName)
  if InKeyName == PC_QTE_KEY_NAME then
    self:ReleasedSelectAction()
    return true
  end
  return false
end

function M:Destruct()
  self:RemoveDispatcher(GAME_VIEWPORT_INPUT_KEY_PRESSED, self)
  self:RemoveDispatcher(GAME_VIEWPORT_INPUT_KEY_RELEASED, self)
  if M.Super and M.Super.Destruct then
    M.Super.Destruct(self)
  end
end

return M
