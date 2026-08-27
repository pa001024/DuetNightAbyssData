require("UnLua")
local EMCache = require("EMCache.EMCache")
local S = Class("BluePrints.UI.BP_EMUserWidget_C")
local OptionWidgetNames = {
  Click = "SettingOptionClick",
  Empty = "SettingOptionEmpty",
  Scroll = "SettingOptionScroll",
  Switch = "SettingOptionSwitch",
  UnFold = "SettingOptionUnFold"
}

function S:GetActiveOptionWidget()
  return self.ActiveOptionWidget
end

function S:CreateOptionWidget(ControlType)
  if self.ActiveOptionWidget and self.ActiveControlType == ControlType then
    return self.ActiveOptionWidget
  end
  local UIName = OptionWidgetNames[ControlType]
  if not UIName then
    DebugPrint("Setting_Option_PC_C CreateOptionWidget invalid ControlType：" .. tostring(ControlType))
    return nil
  end
  local OptionWidget = UIManager(self):_CreateWidgetNew(UIName)
  if not OptionWidget then
    DebugPrint("Setting_Option_PC_C CreateOptionWidget failed：" .. tostring(ControlType) .. " " .. tostring(UIName))
    return nil
  end
  self.Node_Option:ClearChildren()
  self.Node_Option:AddChild(OptionWidget)
  self.ActiveOptionWidget = OptionWidget
  self.ActiveControlType = ControlType
  return OptionWidget
end

function S:OnListItemObjectSet(Content)
  self.Content = Content
  Content.SelfWidget = self
  self.Cache = Content.Cache
  local ControlType
  if self.Cache == "Click" then
    ControlType = "Click"
  elseif self.Cache == "Empty" then
    ControlType = "Empty"
  else
    self.CacheInfo = DataMgr.Option[self.Cache]
    if not self.CacheInfo then
      DebugPrint("Setting_Option_PC_C OnListItemObjectSet missing option config")
      return
    end
    ControlType = self.CacheInfo.ControlType
  end
  local OptionWidget = self:CreateOptionWidget(ControlType)
  if not OptionWidget then
    return
  end
  if self.Cache == "Click" then
    OptionWidget:Init(self, nil, nil, Content)
  elseif self.Cache == "Empty" then
    OptionWidget:Init(self)
  else
    OptionWidget:Init(self, self.Cache, self.CacheInfo, Content)
  end
  self:PlayAnimation(self.In)
  self:SetNavigationRuleCustomBoundary(UE4.EUINavigation.Up, {
    self,
    self.OnNavigateUp
  })
  self:SetNavigationRuleCustomBoundary(UE4.EUINavigation.Down, {
    self,
    self.OnNavigateDown
  })
  local ParentWidget = Content.ParentWidget
  local SettingPC = ParentWidget and (ParentWidget.OnLayoutPlanOptionItemSet and ParentWidget or ParentWidget.Parent)
  if SettingPC and SettingPC.OnLayoutPlanOptionItemSet then
    SettingPC:OnLayoutPlanOptionItemSet(self, Content)
  end
end

function S:OnNavigateUp()
  return self.Content:OnItemNavigateUp(self.Content, self)
end

function S:OnNavigateDown()
  return self.Content:OnItemNavigateDown(self.Content, self)
end

function S:GetFirstWidgetToNavigate()
  local ActiveOptionWidget = self:GetActiveOptionWidget()
  return ActiveOptionWidget and ActiveOptionWidget:GetFirstWidgetToNavigate()
end

function S:GetLastWidgetToNavigate()
  local ActiveOptionWidget = self:GetActiveOptionWidget()
  return ActiveOptionWidget and ActiveOptionWidget:GetLastWidgetToNavigate()
end

function S:Gamepad_SetHovered(bIsHovered)
  local ActiveOptionWidget = self:GetActiveOptionWidget()
  if not ActiveOptionWidget then
    return
  end
  ActiveOptionWidget:Gamepad_SetHovered(bIsHovered)
  if bIsHovered and self.Content.UpdateBottomKeyFunc then
    self.Content.UpdateBottomKeyFunc(ActiveOptionWidget:GetBottomKeyInfos())
  end
end

function S:Handle_KeyDownOnGamePad(InKeyName)
  local IsHandled = false
  local ActiveOptionWidget = self:GetActiveOptionWidget()
  if ActiveOptionWidget then
    IsHandled = ActiveOptionWidget:Handle_KeyDownOnGamePad(InKeyName)
  end
  return IsHandled
end

function S:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function S:Handle_KeyUpOnGamePad(InKeyName)
  local IsHandled = false
  local ActiveOptionWidget = self:GetActiveOptionWidget()
  if ActiveOptionWidget then
    IsHandled = ActiveOptionWidget:Handle_KeyUpOnGamePad(InKeyName)
  end
  return IsHandled
end

function S:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:Handle_KeyUpOnGamePad(InKeyName)
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function S:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.LeftAnalogX then
    local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    if DeltaOffset <= -1 then
      self:Handle_KeyDownOnGamePad(UIConst.GamePadKey.LeftStickLeft)
    elseif DeltaOffset >= 1 then
      self:Handle_KeyDownOnGamePad(UIConst.GamePadKey.LeftStickRight)
    end
  end
  return UIUtils.Unhandled
end

function S:OnClickBlankArea()
  self.Content.ParentWidget.Parent:OnClickAllLeftMouseButton()
end

function S:ClearUnfoldState()
  if self.Cache == "Empty" then
    return
  end
  local ActiveOptionWidget = self:GetActiveOptionWidget()
  if ActiveOptionWidget and ActiveOptionWidget.ClearOpenListState then
    ActiveOptionWidget:ClearOpenListState()
  end
end

function S:OnClickLeftMouseButton()
  if self.Cache == "Empty" then
    return
  end
  local ActiveOptionWidget = self:GetActiveOptionWidget()
  if ActiveOptionWidget and ActiveOptionWidget.OnClickLeftMouseButton then
    ActiveOptionWidget:OnClickLeftMouseButton()
  end
end

function S:RestoreDefaultOptionSet()
  if self.Cache == "Empty" then
    return
  end
  local ActiveOptionWidget = self:GetActiveOptionWidget()
  if ActiveOptionWidget and ActiveOptionWidget.RestoreDefaultOptionSet then
    ActiveOptionWidget:RestoreDefaultOptionSet()
  end
end

function S:RestoreOldValueOptionSet()
  if self.Cache == "Empty" then
    return
  end
  local ActiveOptionWidget = self:GetActiveOptionWidget()
  if ActiveOptionWidget and ActiveOptionWidget.RestoreOldValueOptionSet then
    ActiveOptionWidget:RestoreOldValueOptionSet()
  end
end

function S:SaveOptionSetting()
  if self.Cache == "Empty" then
    return
  end
  local ActiveOptionWidget = self:GetActiveOptionWidget()
  if ActiveOptionWidget and ActiveOptionWidget.SaveOptionSetting then
    ActiveOptionWidget:SaveOptionSetting()
  end
end

function S:BP_OnEntryReleased()
  if self.Content and self.Content.SelfWidget == self then
    self.Content.SelfWidget = nil
  end
  self.Content = nil
  self.Cache = nil
  self.CacheInfo = nil
end

function S:OnParentTabSwitch()
  self:ClearUnfoldState()
end

return S
