require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local LeftRightPadding = 12

function M:Initialize(Initializer)
  self.EntranceConfigList = {}
  self.EntranceWidgetList = {}
  self.bInEntranceNavigation = false
  self.LastFocusWidgetBeforeEntrance = nil
  self.bHostAllowGamePadKey = true
  self.bInputListenBound = false
end

function M:Construct()
  if self.EntranceConfigList and #self.EntranceConfigList > 0 then
    self:ReconcileEntranceWidgets()
  end
  self:InitMenuKey()
  self:BindInputMethodChanged()
  self:RefreshMenuKeyByInputType()
end

function M:Destruct()
  self.bInEntranceNavigation = false
  self.LastFocusWidgetBeforeEntrance = nil
  self:UnbindInputMethodChanged()
  if self.SetIsLimitNavigationInside then
    self:SetIsLimitNavigationInside(false)
  end
  for _, EntranceWidget in pairs(self.EntranceWidgetList or {}) do
    if IsValid(EntranceWidget) and type(EntranceWidget.CleanupEntrance) == "function" then
      EntranceWidget:CleanupEntrance()
    end
  end
  if IsValid(self.HB_Entrances) then
    self.HB_Entrances:ClearChildren()
  end
  self.EntranceConfigList = {}
  self.EntranceWidgetList = {}
end

function M:InitMenuKey()
  if IsValid(self.KeyImg_GamePad) then
    self.KeyImg_GamePad:CreateGamepadKey("Menu")
  end
end

function M:BindInputMethodChanged()
  if self.bInputListenBound then
    return
  end
  if not self.GameInputModeSubsystem then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
    self.bInputListenBound = true
  end
end

function M:UnbindInputMethodChanged()
  if not self.bInputListenBound then
    return
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
  self.bInputListenBound = false
end

function M:OnInputMethodChanged(CurInputType, CurGamepadName)
  self:RefreshMenuKeyByInputType(CurInputType)
end

function M:RefreshMenuKeyByInputType(CurInputType)
  if not IsValid(self.KeyImg_GamePad) then
    return
  end
  if nil == CurInputType and IsValid(self.GameInputModeSubsystem) then
    CurInputType = self.GameInputModeSubsystem:GetCurrentInputType()
  end
  local bGamepad = CurInputType == ECommonInputType.Gamepad
  local bHasEntrance = #self:GetVisibleEntranceOrderedList() > 0
  local bShow = bGamepad and self.bHostAllowGamePadKey and bHasEntrance and not self.bInEntranceNavigation
  self.KeyImg_GamePad:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:AddEntranceWidget(EntranceConfig)
  if type(EntranceConfig) ~= "table" then
    DebugPrint(ErrorTag, "AddEntranceWidget: EntranceConfig must be a table")
    return
  end
  if type(EntranceConfig.UIConfig) ~= "string" or EntranceConfig.UIConfig == "" then
    DebugPrint(ErrorTag, "AddEntranceWidget: UIConfig must be a non-empty string")
    return
  end
  local NameTag = EntranceConfig.NameTag
  if type(NameTag) ~= "string" or "" == NameTag then
    NameTag = EntranceConfig.UIConfig
  end
  local Index = EntranceConfig.Index
  if type(Index) ~= "number" then
    Index = self:GetMaxEntranceIndex() + 1
  end
  local NormalizedConfig = {
    UIConfig = EntranceConfig.UIConfig,
    ConditionCallback = EntranceConfig.ConditionCallback,
    Index = Index,
    NameTag = NameTag,
    InitCallback = EntranceConfig.InitCallback
  }
  local ExistingIndex = self:FindEntranceConfigIndexByNameTag(NameTag)
  if nil ~= ExistingIndex then
    self.EntranceConfigList[ExistingIndex] = NormalizedConfig
  else
    table.insert(self.EntranceConfigList, NormalizedConfig)
  end
  self:SortEntranceConfigList()
  self:ReconcileEntranceWidgets()
end

function M:RefreshEntranceWidgets()
  self:ReconcileEntranceWidgets()
end

function M:GetMaxEntranceIndex()
  local MaxIndex = 0
  for _, EntranceConfig in ipairs(self.EntranceConfigList) do
    if type(EntranceConfig.Index) == "number" and MaxIndex < EntranceConfig.Index then
      MaxIndex = EntranceConfig.Index
    end
  end
  return MaxIndex
end

function M:FindEntranceConfigIndexByNameTag(NameTag)
  for ConfigIndex, EntranceConfig in ipairs(self.EntranceConfigList) do
    if EntranceConfig.NameTag == NameTag then
      return ConfigIndex
    end
  end
  return nil
end

function M:SortEntranceConfigList()
  table.sort(self.EntranceConfigList, function(LeftConfig, RightConfig)
    if LeftConfig.Index ~= RightConfig.Index then
      return LeftConfig.Index < RightConfig.Index
    end
    return tostring(LeftConfig.NameTag) < tostring(RightConfig.NameTag)
  end)
end

function M:IsEntranceConditionPassed(EntranceConfig)
  if type(EntranceConfig.ConditionCallback) ~= "function" then
    return false
  end
  local CallSuccess, CallResult = pcall(EntranceConfig.ConditionCallback, self)
  if not CallSuccess then
    DebugPrint(ErrorTag, "Entrance ConditionCallback error:", CallResult, "NameTag=", EntranceConfig.NameTag)
    return false
  end
  return true == CallResult
end

function M:InvokeEntranceInitCallback(EntranceConfig, EntranceWidget)
  if type(EntranceConfig.InitCallback) ~= "function" then
    return
  end
  local CallSuccess, CallError = pcall(EntranceConfig.InitCallback, self, EntranceWidget)
  if not CallSuccess then
    DebugPrint(ErrorTag, "Entrance InitCallback error:", CallError, "NameTag=", EntranceConfig.NameTag)
  end
end

function M:CreateEntranceWidgetInstance(EntranceConfig)
  local UIManagerInstance = UIManager(self)
  if not UIManagerInstance then
    return nil
  end
  local WidgetUIConfig = DataMgr.WidgetUI[EntranceConfig.UIConfig]
  if nil ~= WidgetUIConfig then
    return UIManagerInstance:_CreateWidgetNew(EntranceConfig.UIConfig)
  end
  return UIManagerInstance:CreateWidget(EntranceConfig.UIConfig, false)
end

function M:AttachEntranceWidget(EntranceWidget)
  if not IsValid(self.HB_Entrances) or not IsValid(EntranceWidget) then
    return
  end
  self.HB_Entrances:AddChildToHorizontalBox(EntranceWidget)
  local EntranceSlot = UE4.UWidgetLayoutLibrary.SlotAsHorizontalBoxSlot(EntranceWidget)
  if EntranceSlot then
    local SlotPadding = EntranceSlot.Padding
    SlotPadding.Left = LeftRightPadding
    SlotPadding.Right = LeftRightPadding
    SlotPadding.Top = 0
    SlotPadding.Bottom = 0
    EntranceSlot:SetPadding(SlotPadding)
  end
end

function M:DetachEntranceWidget(EntranceWidget)
  if not IsValid(EntranceWidget) then
    return
  end
  if type(EntranceWidget.CleanupEntrance) == "function" then
    EntranceWidget:CleanupEntrance()
  end
  if IsValid(self.HB_Entrances) then
    self.HB_Entrances:RemoveChild(EntranceWidget)
  end
  EntranceWidget.OwnerEntrancePanel = nil
end

function M:ApplyEntranceOrder(DesiredConfigList)
  if not IsValid(self.HB_Entrances) then
    return
  end
  local NeedReorder = false
  if self.HB_Entrances:GetChildrenCount() ~= #DesiredConfigList then
    NeedReorder = true
  else
    for OrderIndex, EntranceConfig in ipairs(DesiredConfigList) do
      local ChildWidget = self.HB_Entrances:GetChildAt(OrderIndex - 1)
      if ChildWidget ~= self.EntranceWidgetList[EntranceConfig.NameTag] then
        NeedReorder = true
        break
      end
    end
  end
  if not NeedReorder then
    return
  end
  self.HB_Entrances:ClearChildren()
  for _, EntranceConfig in ipairs(DesiredConfigList) do
    self:AttachEntranceWidget(self.EntranceWidgetList[EntranceConfig.NameTag])
  end
end

function M:ReconcileEntranceWidgets()
  if not IsValid(self.HB_Entrances) then
    return
  end
  local DesiredConfigList = {}
  local DesiredNameTagSet = {}
  for _, EntranceConfig in ipairs(self.EntranceConfigList) do
    if self:IsEntranceConditionPassed(EntranceConfig) then
      table.insert(DesiredConfigList, EntranceConfig)
      DesiredNameTagSet[EntranceConfig.NameTag] = true
    end
  end
  for NameTag, EntranceWidget in pairs(self.EntranceWidgetList) do
    if not DesiredNameTagSet[NameTag] then
      self:DetachEntranceWidget(EntranceWidget)
      self.EntranceWidgetList[NameTag] = nil
    end
  end
  for _, EntranceConfig in ipairs(DesiredConfigList) do
    if not IsValid(self.EntranceWidgetList[EntranceConfig.NameTag]) then
      local CreateSuccess, EntranceWidget = pcall(self.CreateEntranceWidgetInstance, self, EntranceConfig)
      if not CreateSuccess then
        DebugPrint(ErrorTag, "CreateEntranceWidgetInstance error:", EntranceWidget, "NameTag=", EntranceConfig.NameTag)
        EntranceWidget = nil
      end
      if IsValid(EntranceWidget) then
        EntranceWidget.OwnerEntrancePanel = self
        self.EntranceWidgetList[EntranceConfig.NameTag] = EntranceWidget
        self:AttachEntranceWidget(EntranceWidget)
        self:EnsureEntranceFocusable(EntranceWidget)
        if type(EntranceWidget.Init) == "function" then
          local InitSuccess, InitError = pcall(EntranceWidget.Init, EntranceWidget)
          if not InitSuccess then
            DebugPrint(ErrorTag, "EntranceWidget:Init error:", InitError, "NameTag=", EntranceConfig.NameTag)
          end
        end
        self:InvokeEntranceInitCallback(EntranceConfig, EntranceWidget)
      else
        DebugPrint(ErrorTag, "CreateEntranceWidgetInstance returned nil, NameTag=", EntranceConfig.NameTag, "UIConfig=", EntranceConfig.UIConfig)
      end
    end
  end
  self:ApplyEntranceOrder(DesiredConfigList)
  if self.bInEntranceNavigation then
    self:ExitEntranceNavigation(false)
  end
  self:SetupEntranceNavigation(self:GetVisibleEntranceOrderedList())
  self:RefreshMenuKeyByInputType()
end

function M:SetHostAllowGamePadKey(bAllow)
  self.bHostAllowGamePadKey = bAllow and true or false
  self:RefreshMenuKeyByInputType()
  for _, EntranceWidget in pairs(self.EntranceWidgetList or {}) do
    if EntranceWidget and EntranceWidget.SetHostAllowGamePadKey then
      EntranceWidget:SetHostAllowGamePadKey(bAllow)
    end
  end
end

function M:GetVisibleEntranceOrderedList()
  local OrderedList = {}
  if not IsValid(self.HB_Entrances) then
    return OrderedList
  end
  local ChildrenCount = self.HB_Entrances:GetChildrenCount()
  for ChildIndex = 0, ChildrenCount - 1 do
    local ChildWidget = self.HB_Entrances:GetChildAt(ChildIndex)
    if IsValid(ChildWidget) then
      table.insert(OrderedList, ChildWidget)
    end
  end
  return OrderedList
end

function M:GetEntranceFocusTarget(EntranceWidget)
  if not IsValid(EntranceWidget) then
    return nil
  end
  if EntranceWidget.Btn_Click then
    return EntranceWidget.Btn_Click
  end
  return EntranceWidget
end

function M:EnsureEntranceFocusable(EntranceWidget)
  local FocusTarget = self:GetEntranceFocusTarget(EntranceWidget)
  if FocusTarget then
    FocusTarget.bIsFocusable = true
  end
end

function M:SetupEntranceNavigation(VisibleList)
  VisibleList = VisibleList or self:GetVisibleEntranceOrderedList()
  local Count = #VisibleList
  for Index = 1, Count do
    local FocusTarget = self:GetEntranceFocusTarget(VisibleList[Index])
    if FocusTarget then
      FocusTarget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
      FocusTarget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
      if Index > 1 then
        local LeftTarget = self:GetEntranceFocusTarget(VisibleList[Index - 1])
        if LeftTarget then
          FocusTarget:SetNavigationRuleExplicit(EUINavigation.Left, LeftTarget)
        end
      else
        FocusTarget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
      end
      if Index < Count then
        local RightTarget = self:GetEntranceFocusTarget(VisibleList[Index + 1])
        if RightTarget then
          FocusTarget:SetNavigationRuleExplicit(EUINavigation.Right, RightTarget)
        end
      else
        FocusTarget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
      end
    end
  end
end

function M:HandleMenuKey(LastFocusWidget)
  local VisibleList = self:GetVisibleEntranceOrderedList()
  local Count = #VisibleList
  if Count <= 0 then
    return false
  end
  if 1 == Count then
    local EntranceWidget = VisibleList[1]
    if EntranceWidget and EntranceWidget.OnBtnClicked then
      EntranceWidget:OnBtnClicked()
    end
    return true
  end
  if self.bInEntranceNavigation then
    local FocusTarget = self:GetEntranceFocusTarget(VisibleList[1])
    if FocusTarget then
      FocusTarget:SetFocus()
    end
    return true
  end
  self:EnterEntranceNavigation(LastFocusWidget, VisibleList)
  return true
end

function M:EnterEntranceNavigation(LastFocusWidget, VisibleList)
  VisibleList = VisibleList or self:GetVisibleEntranceOrderedList()
  if #VisibleList < 2 then
    return
  end
  self.bInEntranceNavigation = true
  self.LastFocusWidgetBeforeEntrance = LastFocusWidget
  self:SetupEntranceNavigation(VisibleList)
  if self.SetIsLimitNavigationInside then
    self:SetIsLimitNavigationInside(true)
  end
  self:RefreshMenuKeyByInputType()
  local FocusTarget = self:GetEntranceFocusTarget(VisibleList[1])
  if FocusTarget then
    FocusTarget:SetFocus()
  end
end

function M:ExitEntranceNavigation(bRestoreFocus)
  if not self.bInEntranceNavigation then
    return
  end
  self.bInEntranceNavigation = false
  if self.SetIsLimitNavigationInside then
    self:SetIsLimitNavigationInside(false)
  end
  self:RefreshMenuKeyByInputType()
  local LastFocusWidget = self.LastFocusWidgetBeforeEntrance
  self.LastFocusWidgetBeforeEntrance = nil
  if false ~= bRestoreFocus and IsValid(LastFocusWidget) then
    LastFocusWidget:SetFocus()
  end
end

function M:OnChildPreviewKeyDown(EntranceWidget, MyGeometry, InKeyEvent)
  if not self.bInEntranceNavigation then
    return nil
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_FaceButton_Bottom" == KeyName then
    if EntranceWidget and EntranceWidget.OnBtnClicked then
      EntranceWidget:OnBtnClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_FaceButton_Right" == KeyName then
    self:ExitEntranceNavigation(true)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return nil
end

return M
