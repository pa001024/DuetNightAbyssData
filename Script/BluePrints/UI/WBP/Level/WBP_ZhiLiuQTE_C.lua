require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self.Btn_Click.OnPressed:Add(self, self.PressedSelectAction)
    self.Btn_Click.OnReleased:Add(self, self.ReleasedSelectAction)
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
  if not self:IsListeningForInputAction("Interactive") then
    self:ListenForInputAction("Interactive", EInputEvent.IE_Pressed, true, {
      self,
      self.PressedSelectAction
    })
    self:ListenForInputAction("Interactive", EInputEvent.IE_Released, true, {
      self,
      self.ReleasedSelectAction
    })
  end
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
    function()
      self:Close()
    end
  })
  self:SetBarPercent(0.0)
  DebugPrint("zwkkk WBP_ZhiLiuQTE_C OnLoaded ", self.InteractiveNum, self.InteractiveTime, self.DownTime)
  self:InitImage()
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
      self:StopAllAnimations()
      self:PlayAnimation(self.LongPress)
      self:PlayAnimationReverse(self.Remind)
    end
  elseif 2 == self.Owner.CurStage then
    self.InPress = true
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
end

function M:SetBarPercent(Percent)
  if self.Material then
    self.Material:SetScalarParameterValue("Percent", Percent)
  end
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
  local KeyName = CommonUtils:GetActionMappingKeyName("Interactive", false)
  DebugPrint("zwkkk Key ", KeyName)
  self.Key_Handle:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = KeyName,
        bLargeSize = true
      }
    }
  })
end

function M:InitMobileView()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_OnGamePadDown(InKeyName)
  if "Gamepad_FaceButton_Top" == InKeyName then
    self:PressedSelectAction()
    return true
  end
  return false
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_OnGamePadUp(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_OnGamePadUp(InKeyName)
  if "Gamepad_FaceButton_Top" == InKeyName then
    self:ReleasedSelectAction()
    return true
  end
  return false
end

return M
