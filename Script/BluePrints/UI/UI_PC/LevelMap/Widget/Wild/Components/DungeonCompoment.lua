require("UnLua")
local Component = {}

function Component:InitInDungeon(Id, MainMap)
  self.RegionID = Id
  self.IsMiniMap = true
  self.MainMap = MainMap
  self.Panel_Empty:SetVisibility(ESlateVisibility.Collapsed)
  self.IsEmpty = false
  self.RegionData = DataMgr.Region[self.RegionID]
  if self.RegionData.IsBlackBg then
    self:PlayAnimation(self.BlackBg)
  else
    self:PlayAnimation(self.WhiteBg)
  end
  self.CoroutineInitObj = CreateCoroutine(self.DungeonInitCoroutine)
  coroutine.resume(self.CoroutineInitObj, self)
end

function Component:DungeonInitCoroutine()
  if self.RegionData.RegionMapImage then
    self.MapRotation = self.RegionData.RegionRotation or 0
    self.MapImage = UIManager(self):_CreateWidgetByUMGClass(LoadClass(self.RegionData.RegionMapImage), nil, nil, nil, false)
    if self.MapImage then
      self.Panel_Map:AddChild(self.MapImage)
      self.MapImage:SetRenderTransformAngle(self.MapRotation)
      local Half = UKismetMathLibrary.Vector2D_One() / 2
      local Anchors = self.MapImage.Slot:GetAnchors()
      Anchors.Minimum = Half
      Anchors.Maximum = Half
      self.MapImage.Slot:SetAnchors(Anchors)
      self.MapImage.Slot:SetAutoSize(true)
      self.MapImage.Slot:SetAlignment(Half)
      self.NewMapType = self.MapImage.Img_Map == nil
      self.AllMapImage:Clear()
      self.MapImage2LocalPos:Clear()
      self.AllMapImage:Append(UUIFunctionLibrary.GetAllImageWidget(self.MapImage))
      self.MapFog = {}
      if not self.NewMapType then
      else
        GWorld.logger.error("副本不支持拼接式地图！!")
      end
    end
  end
  if not self.NewMapType then
    local center = FVector2D()
    if self.RegionData.RegionMapImageCenter and #self.RegionData.RegionMapImageCenter > 1 then
      center:Set(self.RegionData.RegionMapImageCenter[1], self.RegionData.RegionMapImageCenter[2])
    end
    self.MapImageCenter = center
  end
  self.MapScale = FVector2D(1, 1)
  self.CurrentDragOffset = FVector2D()
  self.BuildingFloor2Map = {}
  self.BuildingName2Map = {}
  self.BulidingState = {}
  self.LimitOffset = nil
  self.DragLimitOffset = nil
  self.TaskArea = {}
  self.SelectWidgetTable = {}
  self.IsConveyClicked = false
  if self.IsMiniMap then
    self.Panel_Gamer:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Bg:SetVisibility(ESlateVisibility.Collapsed)
    self.BackgroundBlur:SetVisibility(ESlateVisibility.Collapsed)
    self:SetVisibility(ESlateVisibility.HitTestInvisible)
    if self.MapImage then
      self.MapImage:SetRenderOpacity(self.BattleMapOpacity)
    end
    self.MiniMapRad = 320
    self.Panel_Point:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.MapImage:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.HideTrack = false
  else
  end
  if self.DefaultFloorId and self.FloorWidgetTable and self.FloorWidgetTable[self.DefaultFloorId] then
    self.FloorWidgetTable[self.DefaultFloorId].Btn.OnClicked:Broadcast()
    self.FloorWidgetTable[self.DefaultFloorId]:PlayAnimation(self.FloorWidgetTable[self.MaxFloorId].Click)
    self.FloorWidgetTable[self.DefaultFloorId].SizeBox:SetRenderOpacity(self.IsInRegion and 1 or 0)
  elseif self.FloorWidgetTable and CommonUtils.IsEmpty(self.FloorWidgetTable) then
    self:OnScaleChange(self.CurrentPercent)
  end
  EventManager:AddEvent(EventID.OnNotifyClientToCloseLoading, self, self.InitMapRect)
  self.InitComplete = true
  self.CoroutineInitObj = nil
  if self.IsMiniMap then
    local Array = GWorld.GameInstance:GetSceneManager().FloorBoxArray
    if Array then
      self.CurrentFloorId = nil
      for _, FloorBox in pairs(Array) do
        FloorBox:CheckPlayerIn()
        DebugPrint("MiniMap Wild CheckPlayerIn", FloorBox:GetName())
      end
      DebugPrint("MiniMap Wild CheckPlayerIn", self.CurrentFloorId)
    end
    if not self.CurrentFloorId then
      self:ShowFloor(self.MaxFloorId)
    end
  end
end

function Component:InitMapRect()
  local GameState = UGameplayStatics.GetGameState(self)
  if not GameState then
    return
  end
  self.MapRect = UIManager(self):_CreateWidgetByUMGClass(LoadClass("/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Rect.WBP_Map_Rect"), nil, nil, nil, false)
  self.Panel_Map:AddChild(self.MapRect)
  local Half = UKismetMathLibrary.Vector2D_One() / 2
  local Anchors = self.MapRect.Slot:GetAnchors()
  Anchors.Minimum = Half
  Anchors.Maximum = Half
  self.MapRect.Slot:SetAnchors(Anchors)
  self.MapRect.Slot:SetAlignment(Half)
  for _, ManualItem in pairs(GameState.ManualActiveCombat:ToTable()) do
    if ManualItem.UnitId == Const.WCDungeonAirBoxUnitId then
      local AirBoxLocation = ManualItem:k2_GetActorLocation()
      self.MapRect:SetRenderTranslation(self:TransformWorldLocToUILoc(AirBoxLocation.X, AirBoxLocation.Y))
      local Scale = ManualItem:GetActorScale3D()
      local Size = FVector2D(Scale.X * 200, Scale.Y * 200) * self.Scale
      local ImageSize = FVector2D(Size.X + self.MiniMapRad * 2, Size.Y + self.MiniMapRad * 2)
      self.MapRect.Rect.Slot:SetSize(ImageSize)
      self.MapRect.Rect:GetDynamicMaterial():SetScalarParameterValue("Width", Size.X / ImageSize.X)
      self.MapRect.Rect:GetDynamicMaterial():SetScalarParameterValue("Height", Size.Y / ImageSize.Y)
      self.MapRect:SetRenderTransformAngle(ManualItem:K2_GetActorRotation().Yaw)
      break
    end
  end
end

function Component:AddComponentEvent()
end

function Component:RemoveComponentEvent()
  EventManager:RemoveEvent(EventID.OnNotifyClientToCloseLoading, self)
end

function Component:ClearData()
  if self.MapRect then
    self.MapRect:RemoveFromParent()
    self.MapRect = nil
  end
end

return Component
