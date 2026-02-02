require("UnLua")
local BP_UIState_C = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function BP_UIState_C:Initialize(Initializer)
  rawset(self, "IsInit", false)
  rawset(self, "IsUIPopUp", nil)
  rawset(self, "HideTags", {})
  rawset(self, "UIStateTag", nil)
  rawset(self, "bIsPauseWorldRendering", nil)
  rawset(self, "ListenEvent", {})
  rawset(self, "IsAllowEscape", false)
  rawset(self, "IsBeginToClose", false)
  rawset(self, "IsMarkToRemove", false)
  rawset(self, "IsGlobalUI", false)
  rawset(self, "IsDestroied", false)
  rawset(self, "IsSetEntitysVisibilityWithAnim", false)
  rawset(self, "IsAddInDeque", false)
end

function BP_UIState_C:Construct()
  self.Overridden.Construct(self)
end

function BP_UIState_C:SetBaseName(Name)
  self.ConfigName = Name
end

function BP_UIState_C:GetUIConfigName()
  local NameText = self.ConfigName or self.WidgetName
  if NameText then
    return NameText
  end
  return self:GetName()
end

function BP_UIState_C:SetIsPauseWorldRendering(bIsPauseRendering)
  self.bIsPauseWorldRendering = bIsPauseRendering
end

function BP_UIState_C:SetUIStateTag(StateTag)
  self.UIStateTag = StateTag
end

local NEW_BlockAllUIInput = true

function BP_UIState_C:UpdateArgs(Args)
  self.ExtraArgs = self.ExtraArgs or {}
  for k, v in pairs(Args) do
    self.ExtraArgs[k] = v
  end
  self.IsAllowEscape = self.ExtraArgs.IsAllowEscape
end

function BP_UIState_C:InitUIInfo(Name, IsInUIMode, EventList, ...)
  DebugPrint("Hy@ UIState型界面打开 InitUIInfo，名称：", self:GetUIConfigName())
  self:SetBaseName(Name)
  self:BindInOutAnimationWithConfigParam()
  self.IsInUIMode = IsInUIMode
  if self.IsInUIMode then
    self:SetInputUIOnly(true)
  end
  local Params = {
    ...
  }
  if self.Auto_In ~= nil then
    local WrapFunc
    
    function WrapFunc()
      self:UIOnLoaded(table.unpack(Params))
      self:UnbindFromAnimationFinished(self.Auto_In, {self, WrapFunc})
    end
    
    self:BindToAnimationFinished(self.Auto_In, {self, WrapFunc})
    self:PlayAnimationForward(self.Auto_In)
  else
    self:UIOnLoaded(...)
  end
  if nil ~= EventList then
    for i, v in ipairs(EventList) do
      if type(self[v]) == "function" then
        self:AddDispatcher(v, self, self[v])
      end
    end
  end
  self:AddDispatcher(EventID.OnNetDisconnect, self, self._ClearBlockUIInputTags)
  self:AddDispatcher(EventID.OnConnectSuccess, self, self._ClearBlockUIInputTags)
end

function BP_UIState_C:_ClearBlockUIInputTags()
  self:ClearBlockUIInputTags()
end

function BP_UIState_C:BindInOutAnimationWithConfigParam()
  local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
  if nil ~= SystemUIConfig and nil ~= SystemUIConfig.IsHideBattleUnit and SystemUIConfig.IsHideBattleUnit ~= UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll and SystemUIConfig.IsHideBattleUnit ~= UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf then
    local InAnimation = nil ~= self.In and self.In or self.Auto_In
    local OutAnimation = nil ~= self.Out and self.Out or self.Auto_Out
    if InAnimation then
      self:BindToAnimationStarted(InAnimation, {
        self,
        self.OnInAnimationStarted
      })
      self:BindToAnimationFinished(InAnimation, {
        self,
        self.OnInAnimationFinished
      })
    end
    if OutAnimation then
      self:BindToAnimationStarted(OutAnimation, {
        self,
        self.OnOutAnimationStarted
      })
      self:BindToAnimationFinished(OutAnimation, {
        self,
        self.OnOutAnimationFinished
      })
    end
  end
end

function BP_UIState_C:SetComponent(CompModulePath)
  self.assembledComponents = self.assembledComponents or {}
  if not self.assembledComponents[CompModulePath] then
    self._components = {CompModulePath}
    AssembleComponents(self)
    self.assembledComponents[CompModulePath] = true
  end
end

function BP_UIState_C:UIOnLoaded(...)
  self.IsInit = true
  self:AddInputMethodChangedListen()
  self:OnLoaded(...)
  if self.GameInputModeSubsystem then
    self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function BP_UIState_C:OnLoaded(...)
end

function BP_UIState_C:SetUIVisibilityTag(VisibiltyTag, Invisible, EDesireVisibilty)
  local IsVisibilityChange = false
  if not IsValid(self) then
    return IsVisibilityChange
  end
  if self.HideTags == nil then
    self.HideTags = {}
  end
  if Invisible then
    self.HideTags[VisibiltyTag] = 1
  else
    self.HideTags[VisibiltyTag] = nil
  end
  local IsHide = not IsEmptyTable(self.HideTags)
  if IsHide then
    EDesireVisibilty = EDesireVisibilty or UE4.ESlateVisibility.Collapsed
    if self:GetVisibility() ~= EDesireVisibilty then
      if self.bIsActive then
        self:DeactivateWidget()
      elseif self:CheckIsNeedTransitionFade(VisibiltyTag, true) then
        self:DealWithUIWidgetWhenStackChange(true, EDesireVisibilty)
      else
        self:SetVisibility(EDesireVisibilty)
      end
      SystemGuideManager:HideUIEvent(self.WidgetName)
      IsVisibilityChange = true
    end
  else
    EDesireVisibilty = EDesireVisibilty or UE4.ESlateVisibility.SelfHitTestInvisible
    if self:GetVisibility() ~= EDesireVisibilty then
      if self.bIsActive then
        self:ActivateWidget()
      elseif self:CheckIsNeedTransitionFade(VisibiltyTag, false) then
        self:DealWithUIWidgetWhenStackChange(false, EDesireVisibilty)
      else
        self:SetVisibility(EDesireVisibilty)
      end
      SystemGuideManager:ShowUIEvent(self.WidgetName)
      IsVisibilityChange = true
    end
  end
  return IsVisibilityChange
end

function BP_UIState_C:CheckIsNeedTransitionFade(VisibiltyTag, bIsHide)
  if not UIConst.IsEnablePageJumpAnimEffect then
    return false
  end
  if VisibiltyTag ~= UIConst.CommonHideTagName.UIStackChange then
    return false
  end
  if self:GetUIConfigName() ~= nil and nil == UIConst.AnimWithJumpConfig[self:GetUIConfigName()] then
    return false
  end
  if bIsHide and self:IsAnimationPlaying(self.Out) then
    return false
  end
  if not bIsHide and self:IsAnimationPlaying(self.In) then
    return false
  end
  if self.IsMarkToRemove then
    return false
  end
  return true
end

function BP_UIState_C:IsOnlyHideWithDesireTag(DesireTag)
  if self.HideTags == nil then
    return false
  end
  local FirstKey, FirstValue = next(self.HideTags)
  if nil == FirstKey then
    return false
  end
  if FirstKey ~= DesireTag then
    return false
  end
  local SecondKey, SecondValue = next(self.HideTags, FirstKey)
  return nil == SecondKey
end

function BP_UIState_C:IsHideWithDesireTag(DesireTag)
  if self.HideTags == nil then
    return false
  end
  local IsHide = self.HideTags[DesireTag] ~= nil
  return IsHide
end

function BP_UIState_C:IsHide()
  if self.HideTags == nil then
    return false
  end
  local IsHide = not IsEmptyTable(self.HideTags)
  return IsHide
end

function BP_UIState_C:ClearAllHideTags()
  self.HideTags = {}
end

function BP_UIState_C:DealWithUIWidgetWhenStackChange(IsHide, DesireVisibilty)
  if IsHide then
    local SelfWidgetRenderOpacityBeforeJump = self:GetRenderOpacity() or 1.0
    local JumpConfigData = UIConst.AnimWithJumpConfig[self:GetUIConfigName()]
    if JumpConfigData then
      local TweenEndTime = JumpConfigData.InAnimWithJumpTime or UIManager(self):GetTopUIWidgetInAnimEndTime()
      local TweenFinalOpacity = JumpConfigData.IsNeedFadeOut and JumpConfigData.EndFadeOutValue or SelfWidgetRenderOpacityBeforeJump
      self:DoTweenOutWhenSystemStackChange(TweenEndTime, SelfWidgetRenderOpacityBeforeJump, TweenFinalOpacity, EaseType.Linear)
    else
      local TweenEndTime = math.min(UIConst.AnimWithJumpConfig.Normal.InAnimWithJumpTime, UIManager(self):GetTopUIWidgetInAnimEndTime())
      local TweenFinalOpacity = UIConst.AnimWithJumpConfig.Normal.IsNeedFadeOut and UIConst.AnimWithJumpConfig.Normal.EndFadeOutValue or SelfWidgetRenderOpacityBeforeJump
      self:DoTweenOutWhenSystemStackChange(TweenEndTime, SelfWidgetRenderOpacityBeforeJump, TweenFinalOpacity, EaseType.Linear)
    end
    self.SelfWidgetParamForStackChange = {RenderOpacityBeforeJump = SelfWidgetRenderOpacityBeforeJump, DesireVisibilty = DesireVisibilty}
  else
    self:CancelTweenOutSystemStackChange()
    self:SetVisibility(DesireVisibilty)
  end
end

function BP_UIState_C:BeginAnimOutToExitWithInStack(bIsForce)
  if not self.IsAddInDeque and not bIsForce then
    return
  end
  local PreviousUI = UIManager(self):GetUnderState()
  if PreviousUI then
    local JumpConfigData = UIConst.AnimWithJumpConfig[PreviousUI:GetUIConfigName()]
    if JumpConfigData and PreviousUI.In then
      local bIsNeedMatchAnimTime = JumpConfigData.bIsNeedMatchAnimTime == nil and UIConst.AnimWithJumpConfig.Normal.IsNeedMatchAnimTime or JumpConfigData.bIsNeedMatchAnimTime
      if bIsNeedMatchAnimTime then
        local ExitAnimNeedTime = JumpConfigData.OutAnimWithJumpTime or UIManager(self):GetTopUIWidgetOutAnimEndTime()
        local PreviousUIInAnimTime = PreviousUI.In:GetEndTime()
        PreviousUI:PlayAnimationForward(PreviousUI.In, PreviousUIInAnimTime / ExitAnimNeedTime)
      else
        PreviousUI:PlayAnimationForward(PreviousUI.In)
      end
      PreviousUI:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, false, UE4.ESlateVisibility.HitTestInvisible)
    end
  end
end

function BP_UIState_C:ListenForInputAction(ActionName, EventType, bConsume, Callback)
  if EventType < 0 or EventType > 5 then
    GWorld.logger.error(self.WidgetName .. "上绑定的" .. ActionName .. "监听事件 输入类型有问题，请检查拼写！")
    return
  end
  
  local function ActionCallback()
    local IsBanned = UIManager(self):CheckIsActionBanned(ActionName)
    if not IsBanned then
      Callback[2](Callback[1])
    else
      DebugPrint("Tianyi@ Action: " .. ActionName .. " IsBanned")
    end
  end
  
  self.Overridden.ListenForInputAction(self, ActionName, EventType, bConsume, {
    Callback[1],
    ActionCallback
  })
end

function BP_UIState_C:StopListeningForInputAction(ActionName, EventType)
  if EventType < 0 or EventType > 5 then
    GWorld.logger.error(ActionName .. "的stop监听事件 输入类型有问题，请检查拼写！")
    return
  end
  self.Overridden.StopListeningForInputAction(self, ActionName, EventType)
end

function BP_UIState_C:UIActionCallback(ActionName, KeyEvent)
  DebugPrint("Tianyi@ UIActionCallback ActionName = " .. ActionName .. " KeyEvent = " .. KeyEvent)
end

function BP_UIState_C:ReceiveEnterState(StackAction)
  self.Overridden.ReceiveEnterState(self, StackAction)
  local UIManager = UIManager(self)
  if UIManager:GetWidgetObjInTopStack() == self then
    if rawget(self, "CurrentCameraViewTarget") ~= nil then
      self:CameraToViewTarget(self.CurrentCameraViewTarget)
    elseif 0 == StackAction then
      rawset(self, "OriginalViewTarget", self:GetOwningPlayer():GetViewTarget())
      if 1 == UIManager:StateCount() then
        rawset(UIManager, "ViewTargetBeforeOpenSystem", self.OriginalViewTarget)
      end
    end
  end
end

function BP_UIState_C:ReceiveExitState(StackAction)
  local UIManager = UIManager(self)
  if UIManager:GetWidgetObjInTopStack() == self then
    if 1 == StackAction and 1 == UIManager:StateCount() then
      if IsValid(rawget(UIManager, "ViewTargetBeforeOpenSystem")) then
        self:CameraToViewTarget(UIManager.ViewTargetBeforeOpenSystem)
      else
        self:CameraToViewTarget(UGameplayStatics.GetPlayerCharacter(self, 0))
      end
    else
      self:SetCurrentCameraViewTarget()
    end
  end
  self.Overridden.ReceiveExitState(self, StackAction)
end

function BP_UIState_C:CameraToViewTarget(ViewTarget)
  local Controller = self:GetOwningPlayer()
  if Controller and IsValid(ViewTarget) and Controller:GetViewTarget() ~= ViewTarget then
    Controller:SetViewTargetWithBlend(ViewTarget, 0, UE4.EViewTargetBlendFunction.VTBlend_Linear, 0, false)
  end
end

function BP_UIState_C:DoRecoverCamera()
  if IsValid(self.OriginalViewTarget) then
    self:CameraToViewTarget(self.OriginalViewTarget)
  else
    self:CameraToViewTarget(UGameplayStatics.GetPlayerCharacter(self, 0))
  end
end

function BP_UIState_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if (InKeyName == Const.GamepadSpecialLeft or InKeyName == Const.GamepadSpecialRight) and TeamController and TeamController:IsTeamPopupBarOpenInGamepad() then
    DebugPrint(LXYTag, "OnPreviewKeyDown:::组队相关的弹条正在打开...")
    return UIUtils.UnHandled
  end
  if "Enter" == InKeyName or "Gamepad_Special_Left" == InKeyName then
    local SystemUIConfig = DataMgr.SystemUI[self.ConfigName or self.WidgetName] or {}
    if SystemUIConfig.IsChat then
      EventManager:FireEvent(EventID.OpenChatView, InKeyName)
    end
  end
  return UIUtils.Unhandled
end

function BP_UIState_C:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if (InKeyName == Const.GamepadSpecialLeft or InKeyName == Const.GamepadSpecialRight) and TeamController and TeamController:IsTeamPopupBarOpenInGamepad() then
    DebugPrint(LXYTag, "OnKeyUp:::组队相关的弹条正在打开...")
    return UIUtils.Unhandled
  end
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == UIConst.GamePadKey.SpecialLeft then
    local SystemUIConfig = DataMgr.SystemUI[self.ConfigName or self.WidgetName] or {}
    if SystemUIConfig.IsChat then
      IsEventHandled = true
      EventManager:FireEvent(EventID.InterruptChatView)
    end
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function BP_UIState_C:SetCurrentCameraViewTarget(ViewTarget)
  if nil == ViewTarget then
    rawset(self, "CurrentCameraViewTarget", self:GetOwningPlayer():GetViewTarget())
  else
    rawset(self, "CurrentCameraViewTarget", ViewTarget)
  end
end

function BP_UIState_C:GetCurrentCameraViewTarget()
  return rawget(self, "CurrentCameraViewTarget")
end

function BP_UIState_C:IsUIVisible()
  return self:IsVisible()
end

function BP_UIState_C:RawSeek(Nodekey)
  return self:SeekWidgetByName(Nodekey)
end

function BP_UIState_C:Seek(Nodekey, WrapType)
  local WidgetObj
  if nil ~= WrapType then
    local Obj = self:SeekWidgetByName(Nodekey)
    WidgetObj = WrapType:New(Obj)
  else
    WidgetObj = self:SeekWidgetByName(Nodekey)
  end
  return WidgetObj
end

function BP_UIState_C:SetWorldPosition(Widget, Pos)
  if nil == Widget then
    return
  end
  Widget:SetRenderTranslation(Pos)
end

function BP_UIState_C:PauseAnimByName(AnimName)
  local Animation = self:GetAnimationByName(AnimName)
  if nil ~= Animation then
    self:PauseAnimation(Animation)
  end
end

function BP_UIState_C:StopAnimByName(AnimName)
  local Animation = self:GetAnimationByName(AnimName)
  if nil ~= Animation then
    self:StopAnimation(Animation)
  end
end

function BP_UIState_C:IsSpecialAnimPlaying(AnimName)
  local Animation = self:GetAnimationByName(AnimName)
  if nil ~= Animation then
    return self:IsAnimationPlaying(Animation)
  end
  return false
end

function BP_UIState_C:SetInputUIOnly(IsUIOnly)
  local PreMode, CurMode, CurDeviceType = "PreMode", "CurMode", CommonUtils.GetDeviceTypeByPlatformName(self)
  if not self.GameInputModeSubsystem then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
  PreMode = self.GameInputModeSubsystem:GetCurrentInputMode()
  local UINameText = self.WidgetName or self.ConfigName
  if IsUIOnly then
    local Params = FGameInputModeParams()
    if self.bIsFocusable then
      Params.WidgetToFocus = self
    end
    if CurDeviceType == CommonConst.CLIENT_DEVICE_TYPE.PC then
      Params.bShowMouseCursor = true
    end
    Params.MouseLockMode = EMouseLockMode.DoNotLock
    self.GameInputModeSubsystem:EnableInputMode(UINameText, EGameInputMode.UI, Params)
  else
    self.GameInputModeSubsystem:DisableInputMode(UINameText)
  end
  CurMode = self.GameInputModeSubsystem:GetCurrentInputMode()
  if PreMode ~= CurMode then
    DebugPrint("UIState Hy@= InputModeChange => PreMode:" .. PreMode .. "," .. "CurMode:" .. CurMode .. " The Reason UIName is " .. UINameText)
    EventManager:FireEvent(EventID.SetInputMode, IsUIOnly)
  end
end

function BP_UIState_C:Hide(HideTag)
  if self.IsMarkToRemove then
    DebugPrint("Hy@==UIState型界面移除当帧需要Hide，直接忽略", self:GetUIConfigName())
    return
  end
  if self.IgnoreHideTags and CommonUtils.HasValue(self.IgnoreHideTags, HideTag) then
    return
  end
  HideTag = HideTag or UIConst.CommonHideTagName.DefaultTag
  local IsVisibilityChange = self:SetUIVisibilityTag(HideTag, true)
  if IsVisibilityChange then
    DebugPrint("HY@ UI Which Named " .. self:GetUIConfigName() .. " Is desired to Hide, The Tag is " .. HideTag)
    AudioManager(self):PauseObjectAllEvent(self, true)
    if self.IsInUIMode then
      self:SetInputUIOnly(false)
    end
    if self.bIsPauseWorldRendering then
      UIManager(self):SetPauseWorldRenderingSwitch(self.ConfigName, false)
    end
    if self.IsUIPopUp == true and HideTag ~= UIConst.CommonHideTagName.UIStackChange then
      UIManager(self):OpenResidentUI(self.WidgetName)
    end
    if self.IsStopGame then
      self:UISetGamePaused(self.WidgetName or self.ConfigName, false)
    end
    if self.KeyboardSetName and self.IsBanningAction then
      UIManager(self):SetBannedActionCallback(self.KeyboardSetName, false, self:GetName())
      self.IsBanningAction = nil
    end
    self:OnHide(HideTag)
  end
end

function BP_UIState_C:OnHide(HideTag)
end

function BP_UIState_C:Show(ShowTag)
  if self.IsMarkToRemove then
    DebugPrint("Hy@==UIState型界面移除当帧需要Show，直接忽略", self:GetUIConfigName())
    return
  end
  ShowTag = ShowTag or UIConst.CommonHideTagName.DefaultTag
  local IsVisibilityChange = self:SetUIVisibilityTag(ShowTag, false)
  if IsVisibilityChange then
    DebugPrint("HY@ UI Which Named " .. self:GetUIConfigName() .. " is desired to Show, The Tag is " .. ShowTag)
    AudioManager(self):PauseObjectAllEvent(self, false)
    if self.IsInUIMode then
      self:SetInputUIOnly(true)
    end
    if self.bIsPauseWorldRendering then
      UIManager(self):SetPauseWorldRenderingSwitch(self.ConfigName, true)
    end
    if self.IsUIPopUp == true and ShowTag ~= UIConst.CommonHideTagName.UIStackChange then
      UIManager(self):CloseResidentUI(self.WidgetName)
    end
    if self.IsStopGame then
      self:UISetGamePaused(self.WidgetName or self.ConfigName, true)
    end
    if self.KeyboardSetName and not self.IsBanningAction then
      UIManager(self):SetBannedActionCallback(self.KeyboardSetName, true, self:GetName())
      self.IsBanningAction = true
    end
    if self.GlobalGameUITag then
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      GameInstance:SetGlobalGameUITag(self.GlobalGameUITag)
    end
    self:OnShow(ShowTag)
  end
end

function BP_UIState_C:OnShow(ShowTag)
end

function BP_UIState_C:OnInAnimationStarted()
  local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
  self:DealWithBattleUnitVisibility(SystemUIConfig.IsHideBattleUnit, true, "AnimStart")
end

function BP_UIState_C:OnInAnimationFinished()
  local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
  self:DealWithBattleUnitVisibility(SystemUIConfig.IsHideBattleUnit, true, "AnimFinished")
end

function BP_UIState_C:OnOutAnimationStarted()
  UIUtils.CheckAndPlayBattleMainInAnim(self:GetUIConfigName())
  local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
  self:DealWithBattleUnitVisibility(SystemUIConfig.IsHideBattleUnit, false, "AnimStart")
end

function BP_UIState_C:OnOutAnimationFinished()
  local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
  self:DealWithBattleUnitVisibility(SystemUIConfig.IsHideBattleUnit, false, "AnimFinished")
end

function BP_UIState_C:OnUpdateWhenSystemJump(CurValue)
  DebugPrint("Hy@ UIState型界面系统跳转过程中回调 OnUpdateWhenSystemJump，名称：", self:GetUIConfigName(), " CurValue:", CurValue)
  self:SetRenderOpacity(CurValue)
end

function BP_UIState_C:OnCompleteAfterSystemJump(EndValue)
  DebugPrint("Hy@ UIState型界面系统跳转完成后回调 OnCompleteAfterSystemJump，名称：", self:GetUIConfigName(), " EndValue:", EndValue)
  self:SetRenderOpacity(EndValue)
  if self.SelfWidgetParamForStackChange then
    self:SetVisibility(self.SelfWidgetParamForStackChange.DesireVisibilty or UE4.ESlateVisibility.Collapsed)
  else
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function BP_UIState_C:OnCancelWhenSystemJump()
  DebugPrint("Hy@ UIState型界面系统跳转取消后回调 OnCancelWhenSystemJump，名称：", self:GetUIConfigName())
  if self.SelfWidgetParamForStackChange then
    self:SetRenderOpacity(self.SelfWidgetParamForStackChange.RenderOpacityBeforeJump or 1.0)
  else
    self:SetRenderOpacity(1.0)
  end
end

function BP_UIState_C:DealWithBattleUnitVisibility(HideBattleUnitType, bHideOrShow, AnimType)
  self.IsSetEntitysVisibilityWithAnim = bHideOrShow
  if HideBattleUnitType == UIConst.EnumHideBattleUnitStyle.DelayHideAll or HideBattleUnitType == UIConst.EnumHideBattleUnitStyle.DelayHideAllExceptSelf then
    if "AnimFinished" == AnimType then
      UIManager(self):SetEntitiesVisibility(self:GetUIConfigName(), HideBattleUnitType - 12 == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll, HideBattleUnitType - 12 == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf, bHideOrShow)
    end
  elseif (HideBattleUnitType == UIConst.EnumHideBattleUnitStyle.InstantShowAll or HideBattleUnitType == UIConst.EnumHideBattleUnitStyle.InstantShowAllExceptSelf) and "AnimStart" == AnimType then
    UIManager(self):SetEntitiesVisibility(self:GetUIConfigName(), HideBattleUnitType - 10 == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll, HideBattleUnitType - 10 == UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf, bHideOrShow)
  end
end

function BP_UIState_C:MarkToRemove(bIsNeedBlockInput)
  self.IsMarkToRemove = true
  if bIsNeedBlockInput then
    self:BlockAllUIInput(true, "SP_DisplayOnly")
  end
end

function BP_UIState_C:IsBeingRemoveState()
  if self.IsMarkToRemove or self.IsBeginToClose then
    return true
  end
  return false
end

function BP_UIState_C:Close()
  if not self or not IsValid(self) then
    return
  end
  if not self.IsInit then
    DebugPrint(ErrorTag, "::Error::  BP_UIState_C=Close 有系统界面移除异常，可能没有关闭成功，需要检查一下，系统名称：", self:GetUIConfigName())
    return
  end
  DebugPrint("Hy@ UIState型界面关闭 Close，名称：", self:GetUIConfigName())
  self.IsBeginToClose = true
  if self.Auto_Out then
    self:BindToAnimationFinished(self.Auto_Out, {
      self,
      self.RealClose
    })
    self:PlayAnimationForward(self.Auto_Out)
  else
    self:RealClose()
  end
end

function BP_UIState_C:RealClose()
  self.IsMarkToRemove = true
  if self.GamePausedHandle then
    self:RemoveTimer(self.GamePausedHandle)
    self.GamePausedHandle = nil
  end
  self:UnbindFromAnimationFinished(self.Auto_Out, {
    self,
    self.RealClose
  })
  if self.KeyboardSetName and self.IsBanningAction then
    UIManager(self):SetBannedActionCallback(self.KeyboardSetName, false, self:GetName())
    self.IsBanningAction = nil
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self) or GWorld.GameInstance
  local UIManager = GameInstance:GetGameUIManager()
  if nil ~= UIManager then
    self.IsNeedSearchInStack = UIManager:GetCurrentState() ~= self
    UIManager:UnLoadUI(self.ConfigName, self.WidgetName)
  end
  self:OnEndClose()
end

function BP_UIState_C:OnEndClose()
end

function BP_UIState_C:DestroyObject()
  self.Overridden.DestroyObject(self)
end

function BP_UIState_C:EMDestruct()
  rawset(self, "IsInit", false)
  if type(self.EMDestruct_CPP) == "function" then
    self:EMDestruct_CPP()
  else
    DebugPrint(ErrorTag, "疑似小部件析构调用了UIState的EMDestruct, 蓝图类型是EMUserWidget, 脚本继承自BP_EMUserWidget_C可以更轻量化, 请检查一下是否真的需要这样写!!!，名称: ", self:GetUIConfigName())
    self:ClearScriptRegister()
    return
  end
  if rawget(self, "bIsFrequentlyUI") then
    self.IsDestroied = true
  end
  if self.IsInUIMode then
    self:SetInputUIOnly(false)
  end
  if rawget(self, "bIsPauseWorldRendering") then
    UIManager(self):SetPauseWorldRenderingSwitch(self.ConfigName, false)
  end
  if rawget(self, "IsStopGame") then
    self:UISetGamePaused(self.WidgetName or self.ConfigName, false)
    self.IsStopGame = nil
  end
  if rawget(self, "IsSetEntitysVisibilityWithAnim") then
    UIManager(self):SetEntitiesVisibility(self:GetUIConfigName(), true, true, false)
  end
  self:ClearScriptRegister()
end

function BP_UIState_C:Destruct()
end

function BP_UIState_C:CheckIsFrequentlyUI()
  return self.bIsFrequentlyUI
end

function BP_UIState_C:SetIsFrequentlyUI(bIsFrequentlyUI)
  self.bIsFrequentlyUI = bIsFrequentlyUI
end

function BP_UIState_C:SetGamePausedDelay(DelayTime)
  self.GamePausedDelayTime = DelayTime
end

function BP_UIState_C:UISetGamePaused(UIName, IsPause)
  if nil == UIName then
    return
  end
  if IsStandAlone(self) then
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode and GameMode.SetGamePaused then
      GameMode:SetGamePaused(UIName, IsPause)
    end
    UIManager(self):SetUIPauseGame(UIName, IsPause)
    EventManager:FireEvent(EventID.OnUIPauseGame)
  end
end

function BP_UIState_C:BlockAllUIInput(bBlock, Reason)
  if NEW_BlockAllUIInput then
    if self.WidgetName == "LoadingReconnect" then
      return
    end
    local LoadingReconnectUi = UIManager():GetUIObj("LoadingReconnect")
    if not bBlock then
      if LoadingReconnectUi and LoadingReconnectUi.bDisplayOnly then
        LoadingReconnectUi:Close()
      end
      if self:IsExistTimer(self.ReconnectUITimer) then
        self:RemoveTimer(self.ReconnectUITimer)
      end
    elseif "SP_DisplayOnly" ~= Reason and not LoadingReconnectUi then
      if self:IsExistTimer(self.ReconnectUITimer) then
        self:RemoveTimer(self.ReconnectUITimer)
      end
      local _, TimerKey = self:AddTimer(UIConst.BlockingTime, function()
        if not UIManager():GetUIObj("LoadingReconnect") then
          UIManager():LoadUINew("LoadingReconnect", true)
        end
      end)
      self.ReconnectUITimer = TimerKey
    end
  end
  if "SP_DisplayOnly" == Reason then
    Reason = nil
  end
  Reason = Reason or self.WidgetName
  DebugPrint(WarningTag, string.format("%s:BlockAllUIInput(%s, %s)", self.WidgetName, bBlock, Reason))
  self:BlockAllUIInput_CPP(bBlock, Reason or self.WidgetName)
end

function BP_UIState_C:OnFocusReceived(MyGeometry, InFocusEvent)
  DebugPrint("BP_UIState_C OnFocusReceived, UIName is", self:GetUIConfigName())
  return UIUtils.Handled
end

function BP_UIState_C:HasAnyFocus()
  return self:HasAnyUserFocus() or self:HasFocusedDescendants()
end

function BP_UIState_C:NavigateToDefaultWidget(bIsDelaySet)
  if not self.GameInputModeSubsystem then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
  
  local function SetToDesiredFocusWidget()
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
      local DefaultFocusWidget = self:GetDesiredFocusTarget()
      if nil ~= DefaultFocusWidget then
        DebugPrint("BP_UIState_C OnFocusReceived, DefaultFocusWidget is", DefaultFocusWidget:GetName())
        DefaultFocusWidget:SetFocus()
      end
    end
  end
  
  if bIsDelaySet then
    self:AddTimer(0.1, SetToDesiredFocusWidget, false, 0, "SetToDesiredFocusWidget")
  else
    SetToDesiredFocusWidget()
  end
end

function BP_UIState_C:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if (InKeyName == Const.GamepadSpecialLeft or InKeyName == Const.GamepadSpecialRight) and TeamController and TeamController:IsTeamPopupBarOpenInGamepad() then
    DebugPrint(LXYTag, "OnKeyDown:::组队相关的弹条正在打开...")
    return UIUtils.Unhandled
  end
  if ("Escape" == InKeyName or "Android_Back" == InKeyName) and self.IsAllowEscape then
    if not self.IsBeginToClose and self.IsInit then
      self:Close()
    end
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function BP_UIState_C:HideAllChildrenNode(ParentNode, IsExcludeSelf, bHide)
  local VisiblityOp = bHide and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible
  local AllChildren = ParentNode:GetAllChildren()
  for i = 1, AllChildren:Length() do
    local ChildItem = AllChildren:GetRef(i)
    ChildItem:SetVisibility(VisiblityOp)
  end
  if IsExcludeSelf then
    ParentNode:SetVisibility(VisiblityOp)
  end
end

function BP_UIState_C:HideAllUIWithOutSelf(IsHide, Tag, bRadio)
  local ExceptUIName = TSet(FName)
  ExceptUIName:Add(self.WidgetName or self.ConfigName)
  UIManager(self):HideAllUI_EX(ExceptUIName, IsHide, Tag, bRadio)
end

function BP_UIState_C:SequenceEvent_PlayUISound(EventPath, EventKey)
  AudioManager(self):PlayUISound(self, EventPath, nil, nil)
end

function BP_UIState_C:CloseAfterAutoIn()
  if self.Auto_In ~= nil then
    self:BindToAnimationFinished(self.Auto_In, {
      self,
      self.Close
    })
  end
end

return BP_UIState_C
