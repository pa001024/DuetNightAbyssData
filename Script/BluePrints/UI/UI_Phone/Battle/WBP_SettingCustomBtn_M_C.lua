require("Unlua")
local BattleHUDCommonConst = require("BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst")
local EMCache = require("EMCache.EMCache")
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
end

function M:Destruct()
  self:UnRegisterHUDDesignComponent()
end

function M:OnLoaded(...)
  self.CurEditPlan = (...)
  self:EnterDesignState(self.CurEditPlan, self.Panel_Skill)
  for WidgetObj, ParentNode in pairs(self.DraggableWidget2ParentNodeMap) do
    if WidgetObj and type(WidgetObj.EnterDesignState) == "function" then
      WidgetObj:EnterDesignState(self.CurEditPlan)
    end
  end
  DebugPrint("HUDWidgetDesignComponent OnLoaded, CurEditPlan is :", self.CurEditPlan, self.bIsDefaultLayoutData)
  self.Btn_Anew:ForbidBtn(self.bIsDefaultLayoutData)
  self.Jump:ChangeByLayout(self.CurEditPlan)
  self:PlayInAnim()
end

function M:PlayInAnim()
  self:PlayAnimationForward(self.In)
end

function M:PlayOutAnim()
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
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
    self.Slider:SetIsEnabled(true)
  end
  self.CurrentSelectWidget = CurSelectWidget
  self.CurrentSelectWidget:SelectWidget()
  local ParentNode = self.DraggableWidget2ParentNodeMap[CurSelectWidget]
  if ParentNode then
    self:UpdateSliderValue(ParentNode.RenderTransform.Scale.X)
  end
  local HistoryOpList = self.AllWidgetOperationHistory[CurSelectWidget]
  if IsEmptyTable(HistoryOpList) then
    self.Btn_Retract:ForbidBtn(true)
  else
    self.Btn_Retract:ForbidBtn(false)
  end
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
      InnerActiveSlateName = value.InnerActiveSlateName,
      MaskNodeName = value.MaskNodeName,
      ParentNodeName = key
    }
    if type(SubWidgetObj.InitAllDraggableWidgetInfo) == "function" then
      SubWidgetObj:InitAllDraggableWidgetInfo(self, ModifyValue)
    end
    AllWidgetConfigData[key] = ModifyValue
    self.DraggableWidget2ParentNodeMap[SubWidgetObj] = self[key]
  end
  local SystemLanguage = EMCache:Get("SystemLanguage")
  if "CN" == SystemLanguage or "TC" == SystemLanguage then
    self.Switch_Language:SetActiveWidgetIndex(1)
  else
    self.Switch_Language:SetActiveWidgetIndex(0)
  end
  self.WBP_Com_CustomTab:Init({
    LeftKey = "NotShow",
    RightKey = "NotShow",
    ChildWidgetName = "TabSubIconTextItemHorizon",
    Tabs = {
      {
        Text = GText("UI_CustomLayout_Skill"),
        Idx = 1,
        IconPath = nil
      },
      {
        Text = GText("UI_CustomLayout_All"),
        Idx = 2,
        IconPath = nil,
        IsLocked = true,
        LockReasonText = "UI_CustomLayout_LockToast"
      }
    },
    SoundFunc = function()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
    end,
    SoundFuncReceiver = self
  })
  self.WBP_Com_CustomTab:SelectTab(1)
  self.Text_Scale:SetText(GText("UI_CustomLayout_Scale"))
  self.Btn_Save:SetText(GText("UI_CustomLayout_Save"))
  self.Text_Choose:SetText(GText("UI_CustomLayout_DefaultTip"))
  self.Switch_TipsType:SetActiveWidgetIndex(1)
  self.Slider:SetIsEnabled(false)
  self:UpdateSliderValue(BattleHUDCommonConst.LayOutSettingConfig.DefaultScaleValue)
  self:RegisterHUDDesignComponent(AllWidgetConfigData, false, false)
end

function M:InitListenEvent()
  self:AddDispatcher(EventID.OnMobileHudPlanChanged, self, self.OnMobileHudPlanChanged)
end

function M:UpdateSliderValue(NewScaleValue)
  local SliderValue = (NewScaleValue - BattleHUDCommonConst.LayOutSettingConfig.MinScaleValue) / (BattleHUDCommonConst.LayOutSettingConfig.MaxScaleValue - BattleHUDCommonConst.LayOutSettingConfig.MinScaleValue)
  self.Slider:SetValue(SliderValue)
  self.ProgressBar_Slider:SetPercent(self.Slider:GetValue())
  self.TextScaleNum:SetText(string.format("%.1f", NewScaleValue))
end

function M:BindBtnClick()
  self.Btn_Collapsed.OnClicked:Add(self, self.OnClickedFloatCollapsed)
  self.Btn_Retract:BindEventOnClicked(self, self.OnClickedOperationBack)
  self.Btn_Esc:BindEventOnClicked(self, self.OnClickedExit)
  self.Btn_Anew:BindEventOnClicked(self, self.OnClickedAnewSet)
  self.Btn_Save:BindEventOnClicked(self, self.OnClickedSave)
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
  self.Slider.OnValueChanged:Add(self, self.OnSliderValueChanged)
  self.Btn_Retract:ForbidBtn(true)
end

function M:OnSliderValueChanged(Value)
  if self.CurrentSelectWidget == nil then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_DefaultTip"))
    return
  end
  local CurPercent = self.ProgressBar_Slider.Percent
  if self:_Numbers_Equal(Value, CurPercent, 1.0E-4) then
    DebugPrint("HUDWidgetDesignComponent OnSliderValueChanged function received the same value, no need to update!")
    return
  end
  if IsValid(self.CurrentSelectWidget) then
    local NewScale = UE4.UKismetMathLibrary.Lerp(BattleHUDCommonConst.LayOutSettingConfig.MinScaleValue, BattleHUDCommonConst.LayOutSettingConfig.MaxScaleValue, Value)
    DebugPrint("HUDWidgetDesignComponent OnSliderValueChanged set widget scale value, NewScale is :", NewScale)
    self.CurrentSelectWidget:ModifyWidgetScale(NewScale)
    self.ProgressBar_Slider:SetPercent(self.Slider:GetValue())
    self.TextScaleNum:SetText(string.format("%.1f", NewScale))
    AudioManager(self):PlayUISound(self, "event:/ui/common/slider_value_change", nil, nil)
  end
end

function M:OnMobileHudPlanChanged(OpType, PlanIndex, PlanInfo)
  if "Update" == OpType then
    self.bHaveModifiedLayoutData = false
    self.AllWidgetOperationHistory = {}
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_SaveToast"))
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
      self:UpdateSliderValue(BattleHUDCommonConst.LayOutSettingConfig.DefaultScaleValue)
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_CustomLayout_WithdrawToast"))
    else
      local LastOp = HistoryOpList[#HistoryOpList]
      self:SetSingleItemToLastRecordState(self.CurrentSelectWidget, LastOp.OpType, LastOp.Value)
    end
  end
end

function M:OnClickedExit()
  if self:IsPlayingAnimation(self.Out) then
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
      self.bHaveModifiedLayoutData = false
      self:PlayOutAnim()
    end
    
    UIManager(self):ShowCommonPopupUI(100273, CommonDialogParams, self)
  else
    self:PlayOutAnim()
  end
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

AssembleComponents(M)
return M
