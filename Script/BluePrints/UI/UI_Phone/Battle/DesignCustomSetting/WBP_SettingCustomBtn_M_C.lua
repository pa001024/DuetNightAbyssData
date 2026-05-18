require("Unlua")
local BattleHUDCommonConst = require("BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst")
local TRIAL_LAYOUT_PLAN_INDEX = 7
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.HUDWidgetDesignComponent"
}

function M:Initialize(Initializer)
  self.Super.Initialize(self)
  self.CurrentSelectWidget = nil
  self.bHaveModifiedLayoutData = false
  self.AllWidgetOperationHistory = {}
  self.bIsFoldedFloat = false
  self.bIsDefaultLayoutData = true
  self.DraggableWidget2ParentNodeMap = {}
end

function M:Construct()
  self:InitConfigData()
  self:InitListenEvent()
  self:BindBtnClick()
  UIManager(self):HideNpcById(BattleHUDCommonConst.SettingPageNpcId, true, "SettingCustomPage")
end

function M:Destruct()
  self:UnRegisterHUDDesignComponent()
  UIManager(self):HideNpcById(BattleHUDCommonConst.SettingPageNpcId, false, "SettingCustomPage")
end

function M:OnLoaded(...)
  local bHaveModifiedLayoutData
  self.CurEditPlan, self.WidgetPlanData, bHaveModifiedLayoutData = ...
  if bHaveModifiedLayoutData then
    self.bHaveModifiedLayoutData = true
  end
  self:EnterDesignState(self.CurEditPlan, self.Panel_LayoutNode, self.WidgetPlanData)
  for WidgetObj, ParentNode in pairs(self.DraggableWidget2ParentNodeMap) do
    if WidgetObj and type(WidgetObj.EnterDesignState) == "function" then
      WidgetObj:EnterDesignState(self.CurEditPlan)
    end
    if WidgetObj and "function" == type(WidgetObj.HideRelativeNodeWhenUnSelected) then
      WidgetObj:HideRelativeNodeWhenUnSelected(true)
    end
  end
  self.SchemeRight:InitClickInfo(self, self.ManualAddWidgetsList, self.OnClickToAddManualWidget)
  self.Btn_Anew:ForbidBtn(self.bIsDefaultLayoutData)
  self.Jump:ChangeByLayout(self.CurEditPlan)
  self:PlayInAnim()
  self:SetEditPlanName()
  EventManager:FireEvent(EventID.OnExitMobileHudTrial)
  self.IsPlayingOutAnim = false
  self:UpdateRedDot()
  DebugPrint("HUDWidgetDesignComponent OnLoaded, CurEditPlan is :", self.CurEditPlan, self.bIsDefaultLayoutData)
end

function M:UpdateRedDot()
  local RedDot = ReddotManager.GetTreeNode("Setting_Control_TrailBtn")
  if RedDot and RedDot.Count > 0 then
    self.Btn_Trial:SetReddot(true)
  else
    self.Btn_Trial:SetReddot(false)
  end
  RedDot = ReddotManager.GetTreeNode("Setting_Control_AddBtn")
  if RedDot and RedDot.Count > 0 then
    self.new:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.new:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:PlayInAnim()
  self:PlayAnimationForward(self.In)
end

function M:PlayOutAnim()
  self.IsPlayingOutAnim = true
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      self:Close()
    end
  })
  self:PlayAnimationForward(self.Out)
end

function M:PlayOutAnimAndCloseSettingAndMenuWorld()
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      local SettingUI = UIManager(self):GetUIObj("Setting")
      if SettingUI then
        SettingUI.CloseEsc = true
        SettingUI:Close()
      end
      self:Close()
    end
  })
  self:PlayAnimationForward(self.Out)
end

function M:OnDraggableWidgetSelected(CurSelectWidget)
  if not IsValid(CurSelectWidget) then
    DebugPrint("Error: OnDraggableWidgetSelected function received an invalid widget!")
    return
  end
  if 0 ~= self.Switch_TipsType:GetActiveWidgetIndex() then
    self.Switch_TipsType:SetActiveWidgetIndex(0)
  end
  if self.CurrentSelectWidget == CurSelectWidget then
    DebugPrint("HUDWidgetDesignComponent OnDraggableWidgetSelected function received the same widget, no need to re-select!")
    return
  end
  if self.CurrentSelectWidget ~= nil then
    self.CurrentSelectWidget:UnSelectWidget()
  else
    self.Size_Slider:SetIsEnabled(true)
    self.Stretch_Slider:SetIsEnabled(true)
  end
  self.CurrentSelectWidget = CurSelectWidget
  local ParentNode = self.DraggableWidget2ParentNodeMap[CurSelectWidget]
  if ParentNode then
    self:CheckAndRefreshRelativeSlideBar()
    self:UpdateSliderValue("Size", ParentNode.RenderTransform.Scale.X)
  end
  local HistoryOpList = self.AllWidgetOperationHistory[CurSelectWidget]
  if IsEmptyTable(HistoryOpList) then
    self.Btn_Retract:ForbidBtn(true)
  else
    self.Btn_Retract:ForbidBtn(false)
  end
  self.TextContent:SetText(GText(self.CurrentSelectWidget:GetSelectWidgetTextMapContent()))
end

function M:OnDraggableWidgetInfoChanged(TypeStr, TargetWidget, NewValue)
  self.bHaveModifiedLayoutData = true
  local HistoryOpList = self.AllWidgetOperationHistory[TargetWidget]
  if HistoryOpList then
    if #HistoryOpList >= BattleHUDCommonConst.LayOutSettingConfig.MaxOperationHistoryCount then
      table.remove(HistoryOpList, 1)
    end
    table.insert(self.AllWidgetOperationHistory[TargetWidget], {OpType = TypeStr, Value = NewValue})
  else
    self.AllWidgetOperationHistory[TargetWidget] = {
      {OpType = TypeStr, Value = NewValue}
    }
  end
  self.Btn_Retract:ForbidBtn(false)
  self.Btn_Anew:ForbidBtn(false)
  if "Pos" == TypeStr then
  elseif "Scale" == TypeStr then
  end
end

function M:InitConfigData()
  local AllWidgetConfigData = {}
  for key, value in pairs(BattleHUDCommonConst.DesignBaseConfigInHUD) do
    local SubWidgetObj = self[value.WidgetName]
    local ModifyValue = {
      WidgetObj = SubWidgetObj,
      WidgetName = value.WidgetName,
      HUDNodeName = value.HUDNodeName,
      TextMapContent = value.TextMapContent,
      InnerActiveSlateName = value.InnerActiveSlateName,
      MaskNodeName = value.MaskNodeName,
      bHasExtraLimitArea = value.bHasExtraLimitArea,
      bNeedAddWorldPos = value.bNeedAddWorldPos,
      bIsNeedManualAdd = value.bIsNeedManualAdd,
      RelativeNodeName = value.RelativeNodeName,
      ParentNodeName = key
    }
    if SubWidgetObj and type(SubWidgetObj.InitAllDraggableWidgetInfo) == "function" then
      SubWidgetObj:InitAllDraggableWidgetInfo(self, ModifyValue)
    end
    AllWidgetConfigData[key] = ModifyValue
    if SubWidgetObj then
      self.DraggableWidget2ParentNodeMap[SubWidgetObj] = self[key]
    end
  end
  self:InitAllTextContent()
  self.Size_Slider:SetIsEnabled(false)
  self:UpdateSliderValue("Size", BattleHUDCommonConst.LayOutSettingConfig.DefaultScaleValue)
  self.Stretch_Slider:SetIsEnabled(false)
  self:UpdateSliderValue("Stretch", BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeYPercent)
  self:RegisterHUDDesignComponent(AllWidgetConfigData, false, false)
end

function M:InitAllTextContent()
  self.Chat.TextNpc:SetText(GText("UI_CustomLayout_CaseName01"))
  self.Chat.TextChat:SetText(GText("UI_CustomLayout_CaseName02"))
  self.Chat.TextTitle:SetText(GText("UI_CustomLayout_CaseName03"))
  self.Chat.TextForge01:SetText(GText("UI_CustomLayout_CaseName04"))
  self.Chat.TextForge02:SetText(GText("UI_CustomLayout_CaseName04"))
  self.Chat.TextForge03:SetText(GText("UI_CustomLayout_CaseName04"))
  self.Interaction.TextInteraction01:SetText(GText("UI_CustomLayout_WidgetName11"))
  self.Interaction.TextInteraction02:SetText(GText("UI_CustomLayout_WidgetName11"))
  self.Interaction.TextInteraction03:SetText(GText("UI_CustomLayout_WidgetName11"))
  self.Task:InitTaskText()
  self.Drop:InitDropText()
  self.Team:InitTeamText()
  self.TextAdd:SetText(GText("UI_CustomLayout_AddBtn"))
  self.Text_Scale:SetText(GText("UI_CustomLayout_Scale"))
  self.Text_Stretch:SetText(GText("UI_CustomLayout_ResponseRange"))
  self.Btn_Save:SetText(GText("UI_CustomLayout_Save"))
  self.Text_Choose:SetText(GText("UI_CustomLayout_DefaultTip"))
  self.Btn_Trial:SetText(GText("UI_CustomLayout_Trial"))
  self.TextNow:SetText(GText("UI_CustomLayout_Editing"))
  self.CancelLeft:InitNormalText()
  self.CancelRight:InitSlideText()
  self.Switch_TipsType:SetActiveWidgetIndex(1)
end

function M:InitListenEvent()
  self:AddDispatcher(EventID.OnMobileHudPlanChanged, self, self.OnMobileHudPlanChanged)
  self:AddDispatcher(EventID.OnSwitchMobileHUDLayout, self, self.OnSwitchMobileHUDLayout)
  self:AddDispatcher(EventID.OnUpdateMobileHudPlanName, self, self.OnUpdateMobileHudPlanName)
end

function M:CheckAndRefreshRelativeSlideBar()
  if self.CurrentSelectWidget and self.CurrentSelectWidget.RelativeNodeWidgetName then
    self:UpdateSliderValue("Stretch", self.CurrentSelectWidget:GetAreaRangeYPercent())
    self.Fillled_Stretch:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Fillled_Stretch:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:RefreshManualWidgetWhenDataChange()
  for ManualNodeName, WidgetConfigData in pairs(BattleHUDCommonConst.ManualAdditionConfigInHUD) do
    local WidgetServerData = self.ManualAddWidgetsList[ManualNodeName] or {}
    self.SchemeRight:RefreshStateWhenDataChange(WidgetConfigData, WidgetServerData)
  end
end

function M:UpdateSliderValue(SlideType, NewSliderValue)
  if "Size" == SlideType then
    local SliderValue = (NewSliderValue - BattleHUDCommonConst.LayOutSettingConfig.MinScaleValue) / (BattleHUDCommonConst.LayOutSettingConfig.MaxScaleValue - BattleHUDCommonConst.LayOutSettingConfig.MinScaleValue)
    self.Size_Slider:SetValue(SliderValue)
    self.ProgressBarSize_Slider:SetPercent(self.Size_Slider:GetValue())
    self.TextScaleNum:SetText(string.format("%.1f", NewSliderValue))
  elseif "Stretch" == SlideType then
    local SliderValue = (NewSliderValue - BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMin) / (BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMax - BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMin)
    self.Stretch_Slider:SetValue(SliderValue)
    self.ProgressBarStretch_Slider:SetPercent(self.Stretch_Slider:GetValue())
    self.TextStretchNum:SetText(string.format("%.1f", NewSliderValue))
  end
end

function M:BindBtnClick()
  self.Btn_Collapsed.OnClicked:Add(self, self.OnClickedFloatCollapsed)
  self.Btn_Retract:BindEventOnClicked(self, self.OnClickedOperationBack)
  self.Btn_Anew:BindEventOnClicked(self, self.OnClickedAnewSet)
  self.Btn_Save:BindEventOnClicked(self, self.OnClickedSave)
  self.Btn_Trial:BindEventOnClicked(self, self.OnClickedTrial)
  self.Btn_Switch.OnClicked:Add(self, self.OnClickedSwitch)
  self.Btn_Switch.OnPressed:Add(self, self.OnPressedSwitch)
  self.Btn_Exit.OnClicked:Add(self, self.OnClickedExit)
  self.Btn_Exit.OnPressed:Add(self, self.OnPressedExit)
  self.Btn_Add.OnClicked:Add(self, self.OnClickedAdd)
  self.Btn_Add.OnPressed:Add(self, self.OnPressedAdd)
  if BattleHUDCommonConst.LayOutSettingConfig.bIsSupportLongPress then
    self.Btn_Up:SetLongPressEnable(true)
    self.Btn_Down:SetLongPressEnable(true)
    self.Btn_Left:SetLongPressEnable(true)
    self.Btn_Right:SetLongPressEnable(true)
    self.Btn_Up:BindEventOnPressed(self, self.OnClickedMoveUp)
    self.Btn_Down:BindEventOnPressed(self, self.OnClickedMoveDown)
    self.Btn_Left:BindEventOnPressed(self, self.OnClickedMoveLeft)
    self.Btn_Right:BindEventOnPressed(self, self.OnClickedMoveRight)
  else
    self.Btn_Up:BindEventOnClicked(self, self.OnClickedMoveUp)
    self.Btn_Down:BindEventOnClicked(self, self.OnClickedMoveDown)
    self.Btn_Left:BindEventOnClicked(self, self.OnClickedMoveLeft)
    self.Btn_Right:BindEventOnClicked(self, self.OnClickedMoveRight)
  end
  self.Size_Slider.OnValueChanged:Add(self, self.OnSizeSliderValueChanged)
  self.Stretch_Slider.OnValueChanged:Add(self, self.OnStretchSliderValueChanged)
  self.Btn_Retract:ForbidBtn(true)
end

function M:OnSizeSliderValueChanged(Value)
  if self.CurrentSelectWidget == nil then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
    return
  end
  local CurPercent = self.ProgressBarSize_Slider.Percent
  if self:_Numbers_Equal(Value, CurPercent, 1.0E-4) then
    DebugPrint("HUDWidgetDesignComponent OnSizeSliderValueChanged function received the same value, no need to update!")
    return
  end
  if IsValid(self.CurrentSelectWidget) then
    local NewScale = UE4.UKismetMathLibrary.Lerp(BattleHUDCommonConst.LayOutSettingConfig.MinScaleValue, BattleHUDCommonConst.LayOutSettingConfig.MaxScaleValue, Value)
    DebugPrint("HUDWidgetDesignComponent OnSizeSliderValueChanged set widget scale value, NewScale is :", NewScale)
    self.CurrentSelectWidget:ModifyWidgetScale(NewScale)
    self.ProgressBarSize_Slider:SetPercent(self.Size_Slider:GetValue())
    self.TextScaleNum:SetText(string.format("%.1f", NewScale))
    AudioManager(self):PlayUISound(self, "event:/ui/common/slider_value_change", nil, nil)
  end
end

function M:OnStretchSliderValueChanged(Value)
  if self.CurrentSelectWidget == nil then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
    return
  end
  local CurPercent = self.ProgressBarStretch_Slider.Percent
  if self:_Numbers_Equal(Value, CurPercent, 1.0E-4) then
    DebugPrint("HUDWidgetDesignComponent OnStretchSliderValueChanged function received the same value, no need to update!")
    return
  end
  if IsValid(self.CurrentSelectWidget) then
    local NewStretchPercent = UE4.UKismetMathLibrary.Lerp(BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMin, BattleHUDCommonConst.VisualJoystickConfig.AreaRangeYPercentMax, Value)
    DebugPrint("HUDWidgetDesignComponent OnStretchSliderValueChanged set widget stretch value, NewStretchPercent is :", NewStretchPercent)
    self.CurrentSelectWidget:OnModifyPropertyWithSlideChange(NewStretchPercent)
    self.ProgressBarStretch_Slider:SetPercent(self.Stretch_Slider:GetValue())
    self.TextStretchNum:SetText(string.format("%.1f", NewStretchPercent))
    AudioManager(self):PlayUISound(self, "event:/ui/common/slider_value_change", nil, nil)
  end
end

function M:OnMobileHudPlanChanged(OpType, PlanIndex, PlanInfo, IsChangeName)
  if "Update" == OpType then
    self.bHaveModifiedLayoutData = false
    self.AllWidgetOperationHistory = {}
    if PlanIndex ~= TRIAL_LAYOUT_PLAN_INDEX then
      if IsChangeName then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Change_Success"))
      else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_SaveToast"))
      end
    end
  end
end

function M:OnSwitchMobileHUDLayout(PlanIndex)
  self.bHaveModifiedLayoutData = false
  self.Switch_TipsType:SetActiveWidgetIndex(1)
  self.Btn_Anew:ForbidBtn(false)
  if self.CurrentSelectWidget ~= nil then
    self.CurrentSelectWidget:UnSelectWidget()
  end
  self.CurEditPlan = PlanIndex
  self:SetEditPlanName()
  self:EnterDesignState(self.CurEditPlan, self.Panel_LayoutNode)
  for WidgetObj, ParentNode in pairs(self.DraggableWidget2ParentNodeMap) do
    if WidgetObj and type(WidgetObj.EnterDesignState) == "function" then
      WidgetObj:EnterDesignState(self.CurEditPlan)
    end
  end
  self:RefreshManualWidgetWhenDataChange()
end

function M:OnUpdateMobileHudPlanName(PlanIndex, PlanName)
  if PlanIndex == self.CurEditPlan then
    self.Text_PlanName:SetText(PlanName)
  end
end

function M:OnClickToAddManualWidget(bChecked, WidgetName)
  DebugPrint("HUDWidgetDesignComponent OnClickToAddManualWidget function is called, WidgetName is :", WidgetName, "bChecked is :", bChecked)
  local WidgetConfig = BattleHUDCommonConst.ManualAdditionConfigInHUD[WidgetName]
  if not WidgetConfig then
    DebugPrint("Error: OnClickToAddManualWidget function received an invalid WidgetName:", WidgetName)
    return
  end
  local LayoutNodeName = WidgetConfig.LayoutInHUDPosName
  local LayoutNodeWidget = self[LayoutNodeName]
  if LayoutNodeWidget then
    if bChecked then
      LayoutNodeWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      LayoutNodeWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  else
    DebugPrint("Error: OnClickToAddManualWidget function cannot find the corresponding LayoutNodeWidget for WidgetName:", WidgetName)
  end
  local TargetWidget = self[WidgetName]
  if TargetWidget then
    TargetWidget:SetManualAddInSetting(bChecked)
  end
end

function M:OnClickedFloatCollapsed()
  if self.bIsFoldedFloat then
    self:PlayAnimation(self.Expand)
    self.bIsFoldedFloat = false
    AudioManager(self):PlayUISound(self, "event:/ui/common/ui_scale_panel_expand", "CustomHUDSetting", nil)
  else
    self:PlayAnimation(self.Fold)
    self.bIsFoldedFloat = true
    AudioManager(self):PlayUISound(self, "event:/ui/common/ui_scale_panel_shrink", "CustomHUDSetting", nil)
  end
end

function M:OnClickedSave()
  self:SaveAllWidgetLayoutData(self.CurEditPlan)
  self.Btn_Retract:ForbidBtn(true)
  self.Btn_Anew:ForbidBtn(true)
end

function M:OnClickedOperationBack()
  local HistoryOpList = self.AllWidgetOperationHistory[self.CurrentSelectWidget]
  if HistoryOpList then
    table.remove(HistoryOpList, 1)
    if IsEmptyTable(HistoryOpList) then
      self.Btn_Retract:ForbidBtn(true)
      self.AllWidgetOperationHistory[self.CurrentSelectWidget] = nil
      self:ResetSingleItemToDefaultLayout(self.CurrentSelectWidget)
      self:UpdateSliderValue("Size", BattleHUDCommonConst.LayOutSettingConfig.DefaultScaleValue)
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_WithdrawToast"))
    else
      local LastOp = HistoryOpList[#HistoryOpList]
      self:SetSingleItemToLastRecordState(self.CurrentSelectWidget, LastOp.OpType, LastOp.Value)
    end
  end
end

function M:OnClickedExit()
  if self.IsPlayingOutAnim then
    DebugPrint("HUDWidgetDesignComponent OnClickedExit function is playing Out animation, cannot exit now!")
    return
  end
  if self.bHaveModifiedLayoutData then
    local CommonDialogParams = {}
    
    function CommonDialogParams.RightCallbackFunction()
      self:SaveAllWidgetLayoutData(self.CurEditPlan)
      self.bHaveModifiedLayoutData = false
      self:PlayOutAnim()
    end
    
    function CommonDialogParams.LeftCallbackFunction()
      EventManager:FireEvent(EventID.OnSwitchMobileHUDLayout, self.CurEditPlan)
      self.bHaveModifiedLayoutData = false
      self:PlayOutAnim()
    end
    
    UIManager(self):ShowCommonPopupUI(100273, CommonDialogParams, self)
  else
    self:PlayOutAnim()
  end
end

function M:OnPressedExit()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
end

function M:OnClickedAdd()
  ReddotManager.ClearLeafNodeCount("Setting_Control_AddBtn")
  self:UpdateRedDot()
  self.SchemeRight:PlayInAnim()
end

function M:OnPressedAdd()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
end

function M:OnClickedAnewSet()
  local CommonDialogParams = {}
  
  function CommonDialogParams.RightCallbackFunction()
    self:ResetToDefaultLayout()
    self.bHaveModifiedLayoutData = true
    self.Btn_Retract:ForbidBtn(true)
    self.Btn_Anew:ForbidBtn(true)
    self.AllWidgetOperationHistory = {}
  end
  
  UIManager(self):ShowCommonPopupUI(100274, CommonDialogParams, self)
end

function M:OnClickedMoveUp()
  if self.CurrentSelectWidget == nil then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
    return
  end
  if IsValid(self.CurrentSelectWidget) then
    self.CurrentSelectWidget:MoveWidgetByOffset(FVector2D(0, -BattleHUDCommonConst.LayOutSettingConfig.MoveOffsetStep))
  end
end

function M:OnClickedMoveDown()
  if self.CurrentSelectWidget == nil then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
    return
  end
  if IsValid(self.CurrentSelectWidget) then
    self.CurrentSelectWidget:MoveWidgetByOffset(FVector2D(0, BattleHUDCommonConst.LayOutSettingConfig.MoveOffsetStep))
  end
end

function M:OnClickedMoveLeft()
  if self.CurrentSelectWidget == nil then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
    return
  end
  if IsValid(self.CurrentSelectWidget) then
    self.CurrentSelectWidget:MoveWidgetByOffset(FVector2D(-BattleHUDCommonConst.LayOutSettingConfig.MoveOffsetStep, 0))
  end
end

function M:OnClickedMoveRight()
  if self.CurrentSelectWidget == nil then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
    return
  end
  if IsValid(self.CurrentSelectWidget) then
    self.CurrentSelectWidget:MoveWidgetByOffset(FVector2D(BattleHUDCommonConst.LayOutSettingConfig.MoveOffsetStep, 0))
  end
end

function M:OnClickedTrial()
  ReddotManager.ClearLeafNodeCount("Setting_Control_TrailBtn")
  local WidgetPlanData = self:GetCurrentWidgetPlanData()
  self.PlayerAvatar:UpdateMobileHudPlan(TRIAL_LAYOUT_PLAN_INDEX, WidgetPlanData)
  self:PlayOutAnimAndCloseSettingAndMenuWorld()
  UIManager(self):LoadUINew("CustomHUDSettingTrailUI", self.CurEditPlan, WidgetPlanData)
end

function M:ShowSwitchLayoutPlanPopup()
  local Params = {
    Index = self.CurEditPlan
  }
  UIManager(self):ShowCommonPopupUI(100322, Params)
end

function M:OnClickedSwitch()
  self:ShowSwitchLayoutPlanPopup()
end

function M:OnPressedSwitch()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

function M:SetEditPlanName()
  local MappedPlanIndex = self:_GetMappedPlanIndex(self.CurEditPlan)
  if 1 == MappedPlanIndex then
    self.Group_Add:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.Group_Add:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local PlanData = Avatar:GetMobileHudPlan(self.CurEditPlan)
  if not PlanData then
    return
  end
  local PlanName = PlanData.HudPlanName or "Default"
  self.PlanName = PlanName
  self.Text_PlanName:SetText(PlanName)
end

function M:ResetRelativeNodeStateInDefault()
  for _, LayoutNodeName in ipairs(BattleHUDCommonConst.AllHasRelativeNodeWidgetList) do
    local LayoutConfigData = self.AllHUD_DraggableWidgetConfigData[LayoutNodeName]
    if LayoutConfigData then
      local WidgetNode = LayoutConfigData.WidgetObj
      if WidgetNode and type(WidgetNode.ResetRelativeNodeToDefault) == "function" then
        WidgetNode:ResetRelativeNodeToDefault()
      end
    end
  end
end

AssembleComponents(M)
return M
