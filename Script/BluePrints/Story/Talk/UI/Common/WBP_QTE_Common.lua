require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local ProgressBarRefreshIntervel = 0.1
local ProgressBarRefreshTimerTag = "QTE_ProgressBar"
local QTE_UI_TAG = "QTE"
local MULTI_QTE_MODE = {NORMAL = 1, TRACK_QTE = 2}

function M:IsNeedPlaySuccessAnimationWhenForceSuccess()
  if self.QTEConfig.MultiQTEMode and self.QTEConfig.MultiQTEMode == MULTI_QTE_MODE.TRACK_QTE then
    return true
  end
  return false
end

function M:IsNeedShowMultiClickProgress()
  if self.QTEConfig.MultiQTEMode and self.QTEConfig.MultiQTEMode == MULTI_QTE_MODE.TRACK_QTE then
    return true
  end
  return false
end

function M:ResponseQTE(Config)
  DebugPrint("QTE: ResponseQTE", Config.SuccessClickNum)
  self:InitQTEData(Config)
  self:SwitchBindButtonClickEvents(true)
  self:SwitchType(Config)
  self:InitButtonPerformance()
  self:AdaptPlatform()
  self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:PlayAnimation(self.In)
  self:SetFocus()
  self:SwitchShowMouseCursorInPIE(true)
  self:PlayQTEShowAudio()
  self:AddEvent()
  self:SaveAndHideUnderlyingUI()
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:AddEvent()
  EventManager:AddEvent(EventID.PauseQTE, self, self.PauseQTE)
  EventManager:AddEvent(EventID.ResumeQTE, self, self.ResumeQTE)
end

function M:RemoveEvent()
  EventManager:RemoveEvent(EventID.PauseQTE, self)
  EventManager:RemoveEvent(EventID.ResumeQTE, self)
end

function M:SwitchType(Config)
  if Config.ClickType == "Single" then
    self.bRefreshProgressBar = true
    self:SwitchHideProgressBar(false)
    self:SwitchShowVX_Par(false)
  elseif Config.ClickType == "Multi" then
    if self:IsNeedShowMultiClickProgress() then
      self.ProgressBarMat:SetScalarParameterValue("Percent", 0)
      self:SwitchHideProgressBar(false)
    else
      self:SwitchHideProgressBar(true)
    end
    self.bRefreshProgressBar = false
    self:SwitchShowVX_Par(true)
    self:BindToAnimationFinished(self.In, {
      self,
      function()
        self:PlayRemindAnimation()
      end
    })
  end
end

function M:Tick(MyGeometry, InDeltaTime)
  if not self:CheckCanWorking() then
    return
  end
  if self.bSimulateRemindAnimation and self.RemindNiagaraComponent then
    self.RemindNiagaraComponent:SetPaused(false)
    self.RemindNiagaraComponent:AdvanceSimulation(1, InDeltaTime)
    self.RemindNiagaraComponent:SetPaused(true)
  end
  if self.bRefreshProgressBar then
    self:RefreshProgressBar(InDeltaTime)
  end
end

function M:PlayRemindAnimation()
  self:PlayAnimation(self.Remind)
  self:BindToAnimationFinished(self.Remind, {
    self,
    function()
      self.bSimulateRemindAnimation = true
      self.RemindNiagaraComponent = self.VX_Par:GetNiagaraComponent()
      self.RemindNiagaraComponent:SetAgeUpdateMode(0)
      self.RemindNiagaraComponent:SetPaused(true)
    end
  })
end

function M:SwitchShowVX_Par(bShow)
  if bShow then
    self.VX_Par:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.VX_Par:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:SwitchHideProgressBar(bHide)
  if bHide then
    self.Progress_Bar_BG:SetVisibility(ESlateVisibility.Collapsed)
    self.Progress_Bar_1:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Progress_Bar_BG:SetVisibility(ESlateVisibility.Visible)
    self.Progress_Bar_1:SetVisibility(ESlateVisibility.Visible)
  end
end

function M:InitQTEData(Config)
  self.bQteResponded = false
  self.QTEConfig = Config
  self.bWorking_QTE = true
  self.ShortClickCount = 0
  self.FaultClickCount = 0
  self.FaultDownKeys = {}
  self.ProgressBarPercent = 1
  self.ProgressBarMat = self.Progress_Bar_1:GetDynamicMaterial()
end

function M:RefreshProgressBar(DeltaTime)
  DebugPrint("QTE: UI RefreshProgressBar", self.ProgressBarPercent)
  if self.bWorking_QTE and self.QTEConfig then
    self.ProgressBarPercentStep = DeltaTime / self.QTEConfig.RealWindowSize
    self.ProgressBarPercent = self.ProgressBarPercent - self.ProgressBarPercentStep
    self.ProgressBarMat:SetScalarParameterValue("Percent", self.ProgressBarPercent)
    if self.ProgressBarPercent < 0 then
      self:OnQTEFailed()
    end
  end
end

function M:RefreshMultiClickProgress()
  if not self:IsNeedShowMultiClickProgress() then
    return
  end
  if self.QTEConfig.bBlockProgressRefreshed then
    return
  end
  if self.bWorking_QTE and self.QTEConfig then
    local Percent = self.ShortClickCount / self.QTEConfig.SuccessClickNum
    DebugPrint("QTE: UI RefreshMultiClickProgress Percent: ", Percent)
    self.ProgressBarMat:SetScalarParameterValue("Percent", Percent)
  end
end

function M:GetClickButtonText()
  if not (self.QTEConfig and self.QTEConfig.InputActionName) or not self.QTEConfig.InputGamePadActionName then
    return
  end
  return self.QTEConfig.InputActionName
end

function M:GetInputGamePadActionName()
  if not self.QTEConfig or not self.QTEConfig.InputGamePadActionName then
    return "Y"
  end
  return self.QTEConfig.InputGamePadActionName
end

function M:OnInputPress(bMouseClick)
  if not self:CheckCanWorking() then
    return
  end
  if not self.QTEConfig.bBlockProgressRefreshed then
    self.ShortClickCount = self.ShortClickCount + 1
  end
  DebugPrint("QTE: Correct Click", self.ShortClickCount)
  self:PlayAnimation(self.FeedBack)
  self:RefreshMultiClickProgress()
  if type(self.OnCorrectClickCallbackFunc) == "function" then
    self.OnCorrectClickCallbackFunc(self.OnCorrectClickCallbackObj, self.ShortClickCount)
  end
  if self.ShortClickCount >= self.QTEConfig.SuccessClickNum then
    self:OnQTESucceed()
  else
    self:PlayQTERightPressAudio(bMouseClick)
  end
end

function M:GetTargetKeyName()
  if not (self.QTEConfig and self.QTEConfig.InputActionName) or not self.QTEConfig.InputGamePadActionName then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    if self.QTEConfig.InputGamePadActionName == "None" then
      return UIConst.GamePadKey.FaceButtonTop
    else
      return Const.ShortKeyToGamePadKey[self.QTEConfig.InputGamePadActionName]
    end
  end
  return self.QTEConfig.InputActionName
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  if not self:CheckCanWorking() then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  DebugPrint("QTE: OnKeyUp", InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local TargetKeyName = self:GetTargetKeyName()
  if TargetKeyName and InKey.KeyName == TargetKeyName then
    self:OnInputPress()
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  self.FaultClickCount = self.FaultClickCount + 1
  DebugPrint("QTE: 按键错误，错误次数", self.FaultClickCount)
  if -1 ~= self.QTEConfig.ClickFaultToleranceCount and self.FaultClickCount > self.QTEConfig.ClickFaultToleranceCount then
    DebugPrint("QTE: 由于按错次数超过设置值，QTE失败", self.QTEConfig.ClickFaultToleranceCount)
    self:OnQTEFailed()
  else
    self:PlayQTEFaultPressAudio()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnQTESucceed()
  if not self:CheckCanWorking() then
    return
  end
  self:PlayQTESuccessAudio()
  self.bQteResponded = true
  self.bQteSucceed = true
  self:ClearQTE()
  self:StopAllAnimations()
  self:PlayAnimation(self.Success)
end

function M:OnQTEFailed()
  if not self.bWorking_QTE then
    return
  end
  if not self:CheckCanWorking() then
    return
  end
  self:PlayQTEFailAudio()
  self.bQteResponded = true
  self.bQteSucceed = false
  self:ClearQTE()
  self:StopAllAnimations()
  self:PlayAnimation(self.Fail)
end

function M:CheckCanWorking()
  return self.bWorking_QTE
end

function M:ClearQTE()
  self.bWorking_QTE = false
  self.FaultDownKeys = {}
  self.bSimulateRemindAnimation = false
  self.ActionMappings = nil
  self.bRefreshProgressBar = false
  self:SwitchBindButtonClickEvents(false)
  self:SwitchShowMouseCursorInPIE(false)
  self:CleanTimer()
  self:StopQTEShowAudio()
  self:RemoveEvent()
end

function M:SaveAndHideUnderlyingUI()
  if not self.QTEConfig.bHideUnderlyingUI then
    return
  end
  UIManager(self):HideAllUI_EX({QTE_UI_TAG}, true, QTE_UI_TAG)
end

function M:RestoreUnderlyingUI()
  if not self.QTEConfig.bHideUnderlyingUI then
    return
  end
  UIManager(self):HideAllUI_EX({}, false, QTE_UI_TAG)
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Success then
    if self.OnSuccCallbackObj and self.OnSuccCallbackFunc then
      self:SetVisibility(ESlateVisibility.Collapsed)
      self:RestoreUnderlyingUI()
      self.OnSuccCallbackFunc(self.OnSuccCallbackObj)
      self:SetOnSuccCallback()
    end
  elseif Animation == self.Fail and self.OnFailCallbackObj and self.OnFailCallbackFunc then
    self:SetVisibility(ESlateVisibility.Collapsed)
    self:RestoreUnderlyingUI()
    self.OnFailCallbackFunc(self.OnFailCallbackObj)
    self:SetOnFailCallback()
  end
end

function M:SetOnSuccCallback(Obj, Func)
  self.OnSuccCallbackObj = Obj
  self.OnSuccCallbackFunc = Func
end

function M:SetOnFailCallback(Obj, Func)
  self.OnFailCallbackObj = Obj
  self.OnFailCallbackFunc = Func
end

function M:SetOnCorrectClickCallback(Obj, Func)
  self.OnCorrectClickCallbackObj = Obj
  self.OnCorrectClickCallbackFunc = Func
end

function M:OnTimeOut(bForceSuccess, CB)
  DebugPrint("QTE: WBP_QTE_Common: OnTimeOut")
  self.bWorking_QTE = false
  self:SetOnSuccCallback()
  self:SetOnFailCallback()
  self:ClearQTE()
  if not self.bQteResponded then
    local function CallBack()
      CB()
      
      self:RestoreUnderlyingUI()
    end
    
    if bForceSuccess then
      if self:IsNeedPlaySuccessAnimationWhenForceSuccess() then
        self:BindToAnimationFinished(self.Success, {self, CallBack})
        self:PlayAnimation(self.Success)
        self:PlayQTESuccessAudio()
      else
        self:BindToAnimationFinished(self.Out, {self, CallBack})
        self:PlayAnimation(self.Out)
      end
    else
      self:BindToAnimationFinished(self.Fail, {self, CallBack})
      self:PlayAnimation(self.Fail)
      self:PlayQTEFailAudio()
    end
  else
    CB()
  end
end

function M:PauseQTE()
  self.bWorking_QTE = false
end

function M:ResumeQTE()
  self.bWorking_QTE = true
end

function M:PlayQTEShowAudio()
  AudioManager(self):PlayUISound(self, "event:/ui/common/qte_show", "QTEShow", nil)
end

function M:StopQTEShowAudio()
  AudioManager(self):StopSound(self, "QTEShow")
end

function M:PlayQTEFailAudio()
  AudioManager(self):PlayUISound(self, "event:/ui/common/qte_fail", "", nil)
end

function M:PlayQTESuccessAudio()
  AudioManager(self):PlayUISound(self, "event:/ui/common/qte_success", "", nil)
end

function M:PlayQTERightPressAudio(bMouseClick)
  local AudioEvent = "event:/ui/common/qte_press"
  if bMouseClick then
    AudioEvent = "event:/ui/common/qte_mouse_press"
  end
  AudioManager(self):PlayUISound(self, AudioEvent, "", nil)
end

function M:PlayQTEFaultPressAudio()
  AudioManager(self):PlayUISound(self, "event:/ui/common/qte_press_err_key", "", nil)
end

function M:InitButtonPerformance()
  DebugPrint("WBP_QTE_Common:InitButtonPerformance 未实现")
end

function M:SwitchBindButtonClickEvents(bBind)
  DebugPrint("WBP_QTE_Common:SwitchBindButtonClickEvents 未实现")
end

function M:AdaptPlatform()
  DebugPrint("WBP_QTE_Common:AdaptPlatform 未实现")
end

function M:SwitchShowMouseCursorInPIE(bShow)
  DebugPrint("WBP_QTE_Common:SwitchShowMouseCursorInPIE未实现")
  if URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
    PlayerController.bShowMouseCursor = bShow
  end
end

return M
