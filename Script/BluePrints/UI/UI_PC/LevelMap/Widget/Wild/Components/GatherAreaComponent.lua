require("UnLua")
local Component = {}

function Component:InitComponentCoroutine()
  local Coroutine = CreateCoroutine(self.InitRegionArea)
  table.insert(self.InitCoroutines, Coroutine)
  coroutine.resume(Coroutine, self, #self.InitCoroutines)
end

function Component:ClearData()
  if self.MapGatherAreaWidget then
    self.MapGatherAreaWidget:RemoveFromParent()
    self.MapGatherAreaWidget = nil
  end
  EventManager:RemoveEvent(EventID.OnDeliveryMeshanismOpen, self)
end

function Component:ShowFloor_Component(FloorId)
  if self.CurFloorId == FloorId then
    return
  end
  self.CurFloorId = FloorId
  if self.GatherAreaData == nil then
    return
  end
  for AreaId, GatherAreaInfo in pairs(self.GatherAreaData) do
    local TeleportId = GatherAreaInfo.GatherAreaTeleportId
    local bUnlock = self:CheckIfSatisfyUnlockCondition(AreaId)
    if self.TeleportState[TeleportId] and self.CurFloorId == GatherAreaInfo.FloorId and bUnlock then
      self:InitMapGatherAreaUI(GatherAreaInfo.Shape, GatherAreaInfo.AreaLocation[1], GatherAreaInfo.AreaLocation[2], GatherAreaInfo.AreaScale[1], GatherAreaInfo.AreaScale[2], GatherAreaInfo.AreaRotYaw)
    end
  end
end

function Component:OnScaleChange_Component(Percent)
  if not self.MapGatherAreaWidget then
    return
  end
  self.MapGatherAreaWidget:SetRenderTranslation(self:TransformWorldLocToUILoc(self.GatherAreaActorLocX, self.GatherAreaActorLocY))
  self.MapGatherAreaWidget:SetRenderScale(self.MapScale)
end

function Component:InitRegionArea(CoroutineIndex)
  DebugPrint("yly GatherAreaComponent InitRegionArea")
  self.CurFloorId = self.CurrentFloorId
  self.GatherAreaData = DataMgr.GatherArea
  if self.GatherAreaData == nil then
    GWorld.logger.error("yly GatherAreaComponent InitRegionArea error: self.GatherAreaData==nil!")
    return
  end
  for AreaId, GatherAreaInfo in pairs(self.GatherAreaData) do
    local TeleportId = GatherAreaInfo.GatherAreaTeleportId
    local bUnlock = self:CheckIfSatisfyUnlockCondition(AreaId)
    if self.TeleportState[TeleportId] and self.CurFloorId == GatherAreaInfo.FloorId and bUnlock then
      self:InitMapGatherAreaUI(GatherAreaInfo.Shape, GatherAreaInfo.AreaLocation[1], GatherAreaInfo.AreaLocation[2], GatherAreaInfo.AreaScale[1], GatherAreaInfo.AreaScale[2], GatherAreaInfo.AreaRotYaw)
    end
  end
  EventManager:AddEvent(EventID.OnDeliveryMeshanismOpen, self, self.OnDeliveryMeshanismOpen)
  self:InitCoroutineCheck(CoroutineIndex)
end

function Component:OnDeliveryMeshanismOpen(CreatorId)
  if self.GatherAreaData == nil then
    DebugPrint("yly GatherAreaComponent OnDeliveryMeshanismOpen: self.GatherAreaData==nil!")
    return
  end
  for AreaId, GatherAreaInfo in pairs(self.GatherAreaData) do
    local TeleportId = GatherAreaInfo.GatherAreaTeleportId
    local TeleportData = DataMgr.TeleportPoint[TeleportId]
    local bUnlock = self:CheckIfSatisfyUnlockCondition(AreaId)
    if TeleportData and TeleportData.StaticId == CreatorId then
      self.TeleportState[TeleportId] = true
      if self.CurFloorId == GatherAreaInfo.FloorId and bUnlock then
        self:InitMapGatherAreaUI(GatherAreaInfo.Shape, GatherAreaInfo.AreaLocation[1], GatherAreaInfo.AreaLocation[2], GatherAreaInfo.AreaScale[1], GatherAreaInfo.AreaScale[2], GatherAreaInfo.AreaRotYaw)
      end
    end
  end
end

function Component:OnConditionComplete(ConditionId)
  if self.GatherAreaData == nil then
    DebugPrint("yly GatherAreaComponent OnConditionComplete: self.GatherAreaData==nil!")
    return
  end
  for AreaId, GatherAreaInfo in pairs(self.GatherAreaData) do
    local TeleportId = GatherAreaInfo.GatherAreaTeleportId
    local UnlockConditionId = GatherAreaInfo.UnlockConditionId
    if self.TeleportState[TeleportId] and self.CurFloorId == GatherAreaInfo.FloorId and UnlockConditionId == ConditionId then
      self:InitMapGatherAreaUI(GatherAreaInfo.Shape, GatherAreaInfo.AreaLocation[1], GatherAreaInfo.AreaLocation[2], GatherAreaInfo.AreaScale[1], GatherAreaInfo.AreaScale[2], GatherAreaInfo.AreaRotYaw)
    end
  end
end

function Component:InitMapGatherAreaUI(Shape, GatherActorLocX, GatherActorLocY, GatherActorScaleX, GatherActorScaleY, GatherActorYaw)
  local GameState = UGameplayStatics.GetGameState(self)
  if not GameState then
    return
  end
  if self.MapGatherAreaWidget then
    self.MapGatherAreaWidget:RemoveFromParent()
    self.MapGatherAreaWidget = nil
  end
  self.MapGatherAreaWidget = UIManager(self):_CreateWidgetByUMGClass(LoadClass("/Game/UI/WBP/Map/Widget/WBP_Map_Gathering.WBP_Map_Gathering"), nil, nil, nil, false)
  local Slot = self.Panel_Point:AddChild(self.MapGatherAreaWidget)
  Slot:SetZOrder(-1)
  local Half = UKismetMathLibrary.Vector2D_One() / 2
  local Anchors = self.MapGatherAreaWidget.Slot:GetAnchors()
  Anchors.Minimum = Half
  Anchors.Maximum = Half
  self.MapGatherAreaWidget.Slot:SetAnchors(Anchors)
  self.MapGatherAreaWidget.Slot:SetAlignment(Half)
  local Offset = self.MapGatherAreaWidget.Slot:GetOffsets()
  Offset.Left = 0
  Offset.Top = 0
  self.MapGatherAreaWidget.Slot:SetOffsets(Offset)
  local LocInUI = self:TransformWorldLocToUILoc(GatherActorLocX, GatherActorLocY)
  self.MapGatherAreaWidget:SetRenderTranslation(LocInUI)
  self.GatherAreaActorLocX = GatherActorLocX
  self.GatherAreaActorLocY = GatherActorLocY
  if nil == self.MapGatherAreaWidget.WS_Type then
    GWorld.logger.error("yly GatherAreaComponent InitMapGatherAreaUI error: self.MapGatherAreaWidget.WS_Type == nil!")
    return
  end
  local ImageSize = self.MapGatherAreaWidget.WS_Type.Slot:GetSize()
  if Shape == Const.GatherAreaShapeEnum.Box then
    self.MapGatherAreaWidget.WS_Type:SetActiveWidgetIndex(0)
    local Size = FVector2D(GatherActorScaleX * 100, GatherActorScaleY * 100) * self.Scale
    self.MapGatherAreaWidget.Img_Rectangle:GetDynamicMaterial():SetScalarParameterValue("Width", Size.X / ImageSize.X)
    self.MapGatherAreaWidget.Img_Rectangle:GetDynamicMaterial():SetScalarParameterValue("Height", Size.Y / ImageSize.Y)
  elseif Shape == Const.GatherAreaShapeEnum.Sphere then
    self.MapGatherAreaWidget.WS_Type:SetActiveWidgetIndex(1)
    local Size = FVector2D(GatherActorScaleX * 100, GatherActorScaleY * 100) * self.Scale
    self.MapGatherAreaWidget.Img_Circle:GetDynamicMaterial():SetScalarParameterValue("Size", Size.X / ImageSize.X)
  end
  self.MapGatherAreaWidget:SetRenderTransformAngle(GatherActorYaw)
  if self.MapScale then
    self.MapGatherAreaWidget:SetRenderScale(self.MapScale)
  end
  self:ShowGatherAreaUI(true)
end

function Component:ShowGatherAreaUI(bShow)
  if not self.MapGatherAreaWidget then
    DebugPrint("yly GatherAreaComponent MapGatherAreaWidget get nil!")
    return
  end
  if bShow then
    self.MapGatherAreaWidget:SetVisibility(ESlateVisibility.HitTestInvisible)
  else
    self.MapGatherAreaWidget:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function Component:CheckIfSatisfyUnlockCondition(GatherAreaId)
  if self.GatherAreaData == nil then
    DebugPrint("yly GatherAreaComponent CheckIfSatisfyUnlockCondition: self.GatherAreaData==nil!")
    return false
  end
  local Avatar = GWorld:GetAvatar()
  local UnlockConditionId = self.GatherAreaData[GatherAreaId].UnlockConditionId
  if nil ~= Avatar and ConditionUtils.CheckCondition(Avatar, UnlockConditionId) then
    return true
  end
  return false
end

return Component
