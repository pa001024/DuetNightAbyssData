local M = {}

function M:RegisterHUDDesignComponent(AllHUDWidgetConfigData, bCreateWidgetAfterLayoutLoad, bAsyncWidgetLoading)
  self.AllHUD_DraggableWidgetConfigData = AllHUDWidgetConfigData or {}
  self.bCreateWidgetAfterLayoutLoad = bCreateWidgetAfterLayoutLoad
  self.bAsyncWidgetLoading = bAsyncWidgetLoading
  self:InitializeVariable()
end

function M:UnRegisterHUDDesignComponent(bClearChildren)
  self:_RemoveAllHUD_DraggableWidgets(bClearChildren)
  DebugPrint("HUDWidgetDesignComponent destroyed")
end

function M:GetWidgetByName(WidgetName)
  return self.AllValidDraggableWidgets[WidgetName]
end

function M:ResetDraggableWidgetConfigData(AllHUDWidgetConfigData)
  self.AllHUD_DraggableWidgetConfigData = AllHUDWidgetConfigData
end

function M:SaveAllWidgetLayoutData()
  if self.EditPlanIndex == nil then
    self.EditPlanIndex = self.PlayerAvatar:GetCurrentMobileHudPlanIndex()
  end
  local WidgetPlanData = {}
  for ParentName, WidgetConfig in pairs(self.AllHUD_DraggableWidgetConfigData) do
    local ParentNode = self[ParentName]
    if IsValid(ParentNode) and self:IsEffectWidgetInCurrentPlan(WidgetConfig) then
      local Position
      local Slot = ParentNode.Slot
      if Slot then
        Position = Slot:GetPosition()
      else
        DebugPrint("HUDWidgetDesignComponent: Failed to get Slot for ParentNode: ", ParentName)
      end
      if Position then
        WidgetPlanData[ParentName] = {
          PosX = Position.X,
          PosY = Position.Y,
          ScaleX = ParentNode.RenderTransform.Scale.X,
          ScaleY = ParentNode.RenderTransform.Scale.Y
        }
        if WidgetConfig.bNeedAddWorldPos then
          local WorldPos = UIManager(self):GetWorldPosition(ParentNode)
          WidgetPlanData[ParentName].WorldPosX = WorldPos.X
          WidgetPlanData[ParentName].WorldPosY = WorldPos.Y
        end
        if WidgetConfig.RelativeNodeName then
          local RelativeNodeWidget = self[WidgetConfig.RelativeNodeName]
          if RelativeNodeWidget then
            local LayoutWidgetGeometry = self.RootLayoutNode:GetCachedGeometry()
            local LayoutWidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
            WidgetPlanData[ParentName].RelativeNodeSaveData = {
              AreaRangeSizeY = RelativeNodeWidget.Slot:GetSize().Y,
              AreaRangeSizeYPercent = RelativeNodeWidget.Slot:GetSize().Y / LayoutWidgetLocalSize.Y
            }
          end
        end
        if WidgetConfig.bIsNeedManualAdd then
          WidgetPlanData[ParentName].bHasAddInHUDSetting = ParentNode:IsVisible()
        end
      end
    end
  end
  if self.PlanName then
    WidgetPlanData.HudPlanName = self.PlanName
  end
  self.PlayerAvatar:UpdateMobileHudPlan(self.EditPlanIndex, WidgetPlanData)
  DebugPrint("HUDWidgetDesignComponent: Call Rpc UpdateMobileHudPlan!, EditPlanIndex is ", self.EditPlanIndex)
end

function M:GetCurrentWidgetPlanData()
  if self.EditPlanIndex == nil then
    self.EditPlanIndex = self.PlayerAvatar:GetCurrentMobileHudPlanIndex()
  end
  local WidgetPlanData = {}
  for ParentName, WidgetConfig in pairs(self.AllHUD_DraggableWidgetConfigData) do
    local ParentNode = self[ParentName]
    if IsValid(ParentNode) and self:IsEffectWidgetInCurrentPlan(WidgetConfig) then
      local Position
      local Slot = ParentNode.Slot
      if Slot then
        Position = Slot:GetPosition()
      else
        DebugPrint("HUDWidgetDesignComponent: Failed to get Slot for ParentNode: ", ParentName)
      end
      if Position then
        WidgetPlanData[ParentName] = {
          PosX = Position.X,
          PosY = Position.Y,
          ScaleX = ParentNode.RenderTransform.Scale.X,
          ScaleY = ParentNode.RenderTransform.Scale.Y
        }
        if WidgetConfig.bNeedAddWorldPos then
          local WorldPos = UIManager(self):GetWorldPosition(ParentNode)
          WidgetPlanData[ParentName].WorldPosX = WorldPos.X
          WidgetPlanData[ParentName].WorldPosY = WorldPos.Y
        end
        if WidgetConfig.RelativeNodeName then
          local RelativeNodeWidget = self[WidgetConfig.RelativeNodeName]
          if RelativeNodeWidget then
            local LayoutWidgetGeometry = self.RootLayoutNode:GetCachedGeometry()
            local LayoutWidgetLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(LayoutWidgetGeometry)
            WidgetPlanData[ParentName].RelativeNodeSaveData = {
              AreaRangeSizeY = RelativeNodeWidget.Slot:GetSize().Y,
              AreaRangeSizeYPercent = RelativeNodeWidget.Slot:GetSize().Y / LayoutWidgetLocalSize.Y
            }
          end
        end
        if WidgetConfig.bIsNeedManualAdd then
          WidgetPlanData[ParentName].bHasAddInHUDSetting = ParentNode:IsVisible()
        end
      end
    end
  end
  if self.PlanName then
    WidgetPlanData.HudPlanName = self.PlanName
  end
  return WidgetPlanData
end

function M:IsEffectWidgetInCurrentPlan(WidgetConfig)
  local MappedPlanIndex = self:_GetMappedPlanIndex(self.EditPlanIndex)
  if WidgetConfig.bIsNeedManualAdd then
    return 2 == MappedPlanIndex
  else
    return true
  end
end

function M:LoadAllWidgetLayoutData(bCreateWidgetAfterLayoutLoad)
  if self.EditPlanIndex == nil then
    self.EditPlanIndex = self.PlayerAvatar:GetCurrentMobileHudPlanIndex()
  end
  local WidgetPlanData = self.PlayerAvatar:GetMobileHudPlan(self.EditPlanIndex) or {}
  if bCreateWidgetAfterLayoutLoad then
    self:GenerateAllWidgetWithConfigData(WidgetPlanData)
  else
    self:ArrangeAllWidgetTargetPosition(WidgetPlanData)
  end
  self:UpdateWidgetLayout(math.max(0, self.EditPlanIndex - 1))
  return WidgetPlanData
end

function M:GetTargetWidgetLayoutData(LayoutWidgetName)
  if self.EditPlanIndex == nil then
    self.EditPlanIndex = self.PlayerAvatar:GetCurrentMobileHudPlanIndex()
  end
  local WidgetPlanData = self.PlayerAvatar:GetMobileHudPlan(self.EditPlanIndex) or {}
  return WidgetPlanData[LayoutWidgetName]
end

function M:ForceShowManualAdditionNode(ManualAddWidgetList, PlanIndex)
  local PlayerAvatar = GWorld:GetAvatar()
  if not PlayerAvatar then
    DebugPrint("HUDWidgetDesignComponent: ForceShowManualAdditionNode Failed to get PlayerAvatar!")
    return
  end
  local IsDataNeedSendToServer = false
  PlanIndex = PlanIndex or 2
  local WidgetPlanData = PlayerAvatar:GetMobileHudPlan(PlanIndex) or {}
  for _, ParentName in ipairs(ManualAddWidgetList) do
    if nil ~= WidgetPlanData[ParentName] then
      if not WidgetPlanData[ParentName].bHasAddInHUDSetting then
        WidgetPlanData[ParentName].bHasAddInHUDSetting = true
        IsDataNeedSendToServer = true
      end
    else
      local Position
      local ParentNode = self[ParentName]
      local Slot = ParentNode.Slot
      if Slot then
        Position = Slot:GetPosition()
      end
      if Position then
        WidgetPlanData[ParentName] = {
          PosX = Position.X,
          PosY = Position.Y,
          ScaleX = ParentNode.RenderTransform.Scale.X or 1.0,
          ScaleY = ParentNode.RenderTransform.Scale.Y or 1.0,
          bHasAddInHUDSetting = true
        }
        IsDataNeedSendToServer = true
      else
        DebugPrint("HUDWidgetDesignComponent: ForceShowManualAdditionNode Failed to get Slot for ParentNode: ", ParentName)
      end
    end
  end
  if IsDataNeedSendToServer then
    DebugPrint("HUDWidgetDesignComponent: ForceShowManualAdditionNode Call Rpc UpdateMobileHudPlan!, PlanIndex is ", PlanIndex)
    PlayerAvatar:UpdateMobileHudPlan(PlanIndex, WidgetPlanData)
  end
end

function M:ForceHideManualAdditionNode(ManualAddWidgetList, PlanIndex)
  local PlayerAvatar = GWorld:GetAvatar()
  if not PlayerAvatar then
    DebugPrint("HUDWidgetDesignComponent: ForceHideManualAdditionNode Failed to get PlayerAvatar!")
    return
  end
  local IsDataHasModified = false
  PlanIndex = PlanIndex or 2
  local WidgetPlanData = PlayerAvatar:GetMobileHudPlan(PlanIndex) or {}
  for _, ParentName in ipairs(ManualAddWidgetList) do
    if nil ~= WidgetPlanData[ParentName] and WidgetPlanData[ParentName].bHasAddInHUDSetting then
      WidgetPlanData[ParentName].bHasAddInHUDSetting = false
      IsDataHasModified = true
    end
  end
  if IsDataHasModified then
    DebugPrint("HUDWidgetDesignComponent: ForceHideManualAdditionNode Call Rpc UpdateMobileHudPlan!, PlanIndex is ", PlanIndex)
    PlayerAvatar:UpdateMobileHudPlan(PlanIndex, WidgetPlanData)
  end
end

function M:_GetMappedPlanIndex(EditPlanIndex)
  if nil == EditPlanIndex then
    return 1
  end
  return (EditPlanIndex - 1) % 2 + 1
end

function M:_GetRelativeNodeDesireSaveData(WidgetNodeName)
  if self.EditPlanIndex == nil then
    self.EditPlanIndex = self.PlayerAvatar:GetCurrentMobileHudPlanIndex()
  end
  local WidgetPlanData = self.PlayerAvatar:GetMobileHudPlan(self.EditPlanIndex) or {}
  if nil == WidgetPlanData[WidgetNodeName] then
    return
  end
  return WidgetPlanData[WidgetNodeName].RelativeNodeSaveData
end

function M:EnterDesignState(EditPlanIndex, RootLayoutNode, WidgetPlanData)
  self.EditPlanIndex = EditPlanIndex
  self.RootLayoutNode = RootLayoutNode
  self.ManualAddWidgetsList = {}
  if WidgetPlanData then
    self:ArrangeAllWidgetTargetPosition(WidgetPlanData)
    self:UpdateWidgetLayout(math.max(0, self.EditPlanIndex - 1))
  else
    self:LoadAllWidgetLayoutData(self.bCreateWidgetAfterLayoutLoad)
  end
  for key, value in pairs(self.AllValidDraggableWidgets) do
    if IsValid(value) and type(value.SetDraggable) == "function" then
      value:SetDraggable(true)
    end
  end
  if self.MoveRangePos then
    self.MoveRangePos:SetVisibility(ESlateVisibility.Collapsed)
  end
  for _, ValueInfo in pairs(self.ManualAddWidgetsList) do
    self:_UpdateManualAddWidgetBySaveData(ValueInfo.WidgetItem, ValueInfo.ParentNode, ValueInfo.bHasAddInHUDSetting)
  end
  DebugPrint("HUDWidgetDesignComponent: Enter Design State, EditPlanIndex is ", EditPlanIndex)
end

function M:LeaveDesignState()
  for key, value in pairs(self.AllValidDraggableWidgets) do
    if IsValid(value) and type(value.SetDraggable) == "function" then
      value:SetDraggable(false)
    end
  end
end

function M:SetRootLayoutNode(RootLayoutNode)
  self.RootLayoutNode = RootLayoutNode
end

function M:ResetToDefaultLayout()
  self:ResetBtnStateInDefault(math.max(0, self.EditPlanIndex - 1))
  self:ResetRelativeNodeStateInDefault()
end

function M:ResetSingleItemToDefaultLayout(TargetWidget)
  if not IsValid(TargetWidget) then
    DebugPrint("HUDWidgetDesignComponent: ResetSingleItemToDefaultLayout Invalid TargetWidget!")
    return
  end
  local ParentNodeName
  for ParentName, WidgetConfig in pairs(self.AllHUD_DraggableWidgetConfigData) do
    local SubWidgetItem = WidgetConfig.WidgetObj
    if SubWidgetItem == TargetWidget then
      ParentNodeName = ParentName
      break
    end
  end
  if not ParentNodeName then
    DebugPrint("HUDWidgetDesignComponent: ResetSingleItemToDefaultLayout Cannot find TargetWidget in ConfigData!")
    return
  end
  local WidgetPlanData = self.PlayerAvatar:GetMobileHudPlan(self.EditPlanIndex) or {}
  if WidgetPlanData and WidgetPlanData[ParentNodeName] then
    local SaveDataInHUD = WidgetPlanData[ParentNodeName]
    local ParentNode = self[ParentNodeName]
    self:_UpdateWidgetToTargetPos(ParentNode, FVector2D(SaveDataInHUD.PosX, SaveDataInHUD.PosY))
    self:_UpdateWidgetToTargetScale(ParentNode, FVector2D(SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY))
    DebugPrint(string.format("HUDWidgetDesignComponent [ResetSingleItemToDefaultLayout]: Set widget position to= X: %f, Y: %f, scale is X: %f, Y: %f, ParentNodeName: %s !", SaveDataInHUD.PosX, SaveDataInHUD.PosY, SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY, ParentNodeName))
  else
    local ParentNode = self[ParentNodeName]
    local AllChildren = self.RootLayoutNode:GetAllChildren():ToTable() or {}
    for ChildIndex, ChildItem in ipairs(AllChildren) do
      if ChildItem == ParentNode then
        local Slot = ParentNode.Slot
        if Slot then
          local MappedPlanIndex = self:_GetMappedPlanIndex(self.EditPlanIndex)
          local DefaultPositionPlan = self["DefaultPosition0" .. tostring(MappedPlanIndex)]
          local DefaultScalePlan = self["DefaultPosScale0" .. tostring(MappedPlanIndex)]
          if DefaultPositionPlan and DefaultPositionPlan:Get(ChildIndex) then
            Slot:SetPosition(DefaultPositionPlan:Get(ChildIndex))
            ParentNode:SetRenderScale(DefaultScalePlan:Get(ChildIndex))
            DebugPrint(string.format("HUDWidgetDesignComponent [ResetSingleItemToDefaultLayout]: Reset widget to initial position and scale, ParentNodeName: %s !", ParentNodeName))
            break
          end
          DebugPrint("HUDWidgetDesignComponent: ResetSingleItemToDefaultLayout Error Cannot find DefaultPositionPlan or ChildIndex!")
        end
        break
      end
    end
  end
end

function M:SetSingleItemToLastRecordState(TargetWidget, OpType, OpValue)
  if not IsValid(TargetWidget) then
    DebugPrint("HUDWidgetDesignComponent: SetSingleItemToLastRecordState Invalid TargetWidget!")
    return
  end
  local ParentNode = TargetWidget:GetParent()
  if ParentNode then
    if "Pos" == OpType then
      self:_UpdateWidgetToTargetPos(ParentNode, OpValue)
    elseif "Scale" == OpType then
      self:_UpdateWidgetToTargetScale(ParentNode, OpValue)
    end
  end
end

function M:InitializeVariable()
  self.AllValidDraggableWidgets = {}
  self.PlayerAvatar = GWorld:GetAvatar()
  DebugPrint("HUDWidgetDesignComponent initialized")
end

function M:GenerateAllWidgetWithConfigData(WidgetPlanData)
  for ParentName, WidgetConfig in pairs(self.AllHUD_DraggableWidgetConfigData) do
    local SubWidgetClass = WidgetConfig.WidgetClass
    local SubWidgetName = WidgetConfig.WidgetName or ParentName
    local SubWidgetLocalOffset = WidgetConfig.LocalOffset
    local ParentType = WidgetConfig.ParentType
    local RelativeNodeName = WidgetConfig.RelativeNodeName
    local bIsNeedManualAdd = WidgetConfig.bIsNeedManualAdd
    local SaveDataInHUD = WidgetPlanData[ParentName]
    local ParentNode = self[ParentName]
    self:_CreateAllHUD_DraggableWidget(SubWidgetClass, SubWidgetName, SubWidgetLocalOffset, ParentNode, ParentType, RelativeNodeName, bIsNeedManualAdd, SaveDataInHUD)
  end
end

function M:ArrangeAllWidgetTargetPosition(WidgetPlanData)
  local MappedPlanIndex = self:_GetMappedPlanIndex(self.EditPlanIndex)
  local DefaultPositionPlan = self["DefaultPosition0" .. tostring(MappedPlanIndex)]
  local DefaultScalePlan = self["DefaultPosScale0" .. tostring(MappedPlanIndex)]
  for ParentName, WidgetConfig in pairs(self.AllHUD_DraggableWidgetConfigData) do
    local SubWidgetName = WidgetConfig.WidgetName or ParentName
    local SubWidgetItem, RelativeNodeSaveData = WidgetConfig.WidgetObj
    local ParentNode = self[ParentName]
    if WidgetConfig.bIsNeedManualAdd then
      self.ManualAddWidgetsList[SubWidgetName] = {
        WidgetItem = SubWidgetItem,
        ParentNode = ParentNode,
        bHasAddInHUDSetting = false
      }
    end
    if IsValid(SubWidgetItem) then
      if WidgetPlanData then
        local SaveDataInHUD = WidgetPlanData[ParentName]
        if SaveDataInHUD then
          local PositionInServer = FVector2D(SaveDataInHUD.PosX, SaveDataInHUD.PosY)
          local ScaleInServer = FVector2D(SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY)
          local TargetChildIndex = self.RootLayoutNode:GetChildIndex(ParentNode) + 1
          if self.bIsDefaultLayoutData and (not self:_FVector2D_Equal(PositionInServer, DefaultPositionPlan:Get(TargetChildIndex)) or not self:_FVector2D_Equal(ScaleInServer, DefaultScalePlan:Get(TargetChildIndex))) then
            self.bIsDefaultLayoutData = false
          end
          self:_UpdateWidgetToTargetPos(ParentNode, PositionInServer, false, true)
          self:_UpdateWidgetToTargetScale(ParentNode, ScaleInServer, true)
          if WidgetConfig.RelativeNodeName then
            RelativeNodeSaveData = SaveDataInHUD.RelativeNodeSaveData
          end
          if WidgetConfig.bIsNeedManualAdd then
            self.ManualAddWidgetsList[SubWidgetName].bHasAddInHUDSetting = SaveDataInHUD.bHasAddInHUDSetting
          end
          DebugPrint(string.format("HUDWidgetDesignComponent [ArrangeAllWidget]: Set widget position to: X: %f, Y: %f, scale is X: %f, Y: %f, WidgetName: %s !", SaveDataInHUD.PosX, SaveDataInHUD.PosY, SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY, ParentName))
        end
      end
      if WidgetConfig.RelativeNodeName then
        self:_UpdateRelativeWidgetBySaveData(SubWidgetItem, WidgetConfig.RelativeNodeName, RelativeNodeSaveData)
      end
      self.AllValidDraggableWidgets[SubWidgetName] = SubWidgetItem
    end
  end
end

function M:_CreateAllHUD_DraggableWidget(SubWidgetClass, SubWidgetName, SubWidgetLocalOffset, ParentNode, ParentType, RelativeNodeName, bIsNeedManualAdd, SaveDataInHUD)
  local function AttachSubWidgetToParent(WidgetName, DestWidget)
    if ParentNode then
      if "CanvasPanel" == ParentType then
        local Slot = ParentNode:AddChild(DestWidget)
        
        if nil ~= Slot then
          if SubWidgetLocalOffset then
            Slot:SetPosition(SubWidgetLocalOffset)
          else
            Slot:SetPosition(FVector2D(0, 0))
          end
        else
          DebugPrint("HUDWidgetDesignComponent: Failed to add widget to ParentNode!")
        end
      elseif "Overlay" == ParentType then
        local Slot = ParentNode:AddChildToOverlay(DestWidget)
        if nil ~= Slot then
          if SubWidgetLocalOffset then
            Slot:SetPadding(FMargin(SubWidgetLocalOffset.X, SubWidgetLocalOffset.Y, 0, 0))
          else
            Slot:SetPadding(FMargin(0, 0, 0, 0))
          end
        else
          DebugPrint("HUDWidgetDesignComponent: Failed to add widget to ParentNode!")
        end
      else
        DebugPrint("HUDWidgetDesignComponent:Error Unsupported ParentType: ", ParentType)
      end
      self:_UpdateWidgetToTargetPos(ParentNode, FVector2D(SaveDataInHUD.PosX, SaveDataInHUD.PosY))
      self:_UpdateWidgetToTargetScale(ParentNode, FVector2D(SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY))
      if RelativeNodeName then
        self:_UpdateRelativeWidgetBySaveData(DestWidget, RelativeNodeName, SaveDataInHUD.RelativeNodeSaveData)
      end
      if bIsNeedManualAdd then
        self.ManualAddWidgetsList[SubWidgetName] = {
          WidgetItem = DestWidget,
          ParentNode = ParentNode,
          bHasAddInHUDSetting = SaveDataInHUD.bHasAddInHUDSetting
        }
      end
      DebugPrint(string.format("HUDWidgetDesignComponent [CreateAllHUD]: Set widget position in ParentNode Slot to: X: %f, Y: %f, scale is X: %f, Y: %f, WidgetName: %s !", SaveDataInHUD.PosX, SaveDataInHUD.PosY, SaveDataInHUD.ScaleX, SaveDataInHUD.ScaleY, WidgetName))
    else
      DestWidget:AddToViewport()
      if SaveDataInHUD then
        DestWidget:SetPositionInViewport(FVector2D(SaveDataInHUD.PosX, SaveDataInHUD.PosY))
      else
        DestWidget:SetPositionInViewport(FVector2D(0, 0))
      end
    end
    self.AllValidDraggableWidgets[WidgetName] = DestWidget
  end
  
  if not SubWidgetClass then
    DebugPrint("HUDWidgetDesignComponent Invalid widget class!")
    return nil
  end
  if self.bAsyncWidgetLoading then
    UIManager(self):CreateWidgetAsync(SubWidgetClass, function(SubWidget)
      if not SubWidget then
        DebugPrint("HUDWidgetDesignComponent: Failed to create widget asynchronously!")
        return
      end
      AttachSubWidgetToParent(SubWidgetName, SubWidget)
    end)
  else
    local SubWidget = UIManager(self):CreateWidget(SubWidgetClass)
    if not SubWidget then
      DebugPrint("HUDWidgetDesignComponent: Failed to create widget!")
      return nil
    end
    AttachSubWidgetToParent(SubWidgetName, SubWidget)
  end
end

function M:_RemoveAllHUD_DraggableWidgets(bClearChildren)
  if bClearChildren then
    for Name, Widget in pairs(self.AllValidDraggableWidgets) do
      if IsValid(Widget) then
        Widget:RemoveFromParent()
      end
    end
  else
    for Name, Widget in pairs(self.AllValidDraggableWidgets) do
      if IsValid(Widget) then
        Widget:LeaveDesignState()
      end
    end
  end
  self.AllValidDraggableWidgets = {}
  DebugPrint("HUDWidgetDesignComponent: Removed all draggable widgets")
end

function M:_UpdateWidgetToTargetPos(WidgetNode, TargetPos, bIsAbsolutePosition, bIsOnlyModifyBPValue)
  if bIsAbsolutePosition then
    TargetPos = UIUtils.GetRelativePositionInParent(WidgetNode, TargetPos)
  end
  if not bIsOnlyModifyBPValue then
    local ParentSlot = WidgetNode.Slot
    if ParentSlot then
      ParentSlot:SetPosition(TargetPos)
    else
      ParentSlot:SetPositionInViewport(TargetPos)
    end
  end
  self:_SetWidgetInfoToBPValue(WidgetNode, "Pos", TargetPos)
end

function M:_UpdateWidgetToTargetScale(WidgetNode, TargetScale, bIsOnlyModifyBPValue)
  if not bIsOnlyModifyBPValue then
    WidgetNode:SetRenderScale(TargetScale)
  end
  self:_SetWidgetInfoToBPValue(WidgetNode, "Scale", TargetScale)
end

function M:_UpdateRelativeWidgetBySaveData(DraggableWidgetItem, RelativeNodeName, RelativeNodeSaveData)
  if "MoveRangePos" == RelativeNodeName then
    local RelativeNodeWidget = self[RelativeNodeName]
    if RelativeNodeWidget then
      local Params = {
        RelativeName = RelativeNodeName,
        TouchAreaWidget = self.Btn_MoveRange
      }
      DraggableWidgetItem:InitRelativeNodeSaveData(RelativeNodeWidget, RelativeNodeSaveData, Params)
    end
  end
end

function M:_UpdateManualAddWidgetBySaveData(DraggableWidgetItem, ParentNode, bHasAddInHUDSetting)
  if bHasAddInHUDSetting then
    ParentNode:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    ParentNode:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:_SetWidgetInfoToBPValue(ParentNode, TypeStr, Value)
  local TargetChildIndex = self.RootLayoutNode:GetChildIndex(ParentNode) + 1
  if TargetChildIndex > 0 then
    if "Pos" == TypeStr then
      local CurPositionPlan = self["InPosition0" .. tostring(self.EditPlanIndex)]
      if CurPositionPlan and CurPositionPlan:Get(TargetChildIndex) then
        CurPositionPlan:Set(TargetChildIndex, Value)
      end
    elseif "Scale" == TypeStr then
      local CurScalePlan = self["PosScale0" .. tostring(self.EditPlanIndex)]
      if CurScalePlan and CurScalePlan:Get(TargetChildIndex) then
        CurScalePlan:Set(TargetChildIndex, Value)
      end
    end
  end
end

function M:_Numbers_Equal(a, b, Epsilon)
  if not a or not b then
    return false
  end
  Epsilon = Epsilon or 1.0E-10
  return Epsilon > math.abs(a - b)
end

function M:_FVector2D_Equal(a, b, Epsilon)
  if not a or not b then
    return false
  end
  Epsilon = Epsilon or 1.0E-10
  if Epsilon < math.abs(a.X - b.X) then
    return false
  elseif Epsilon < math.abs(a.Y - b.Y) then
    return false
  end
  return true
end

return M
