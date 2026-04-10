require("UnLua")
local Component = {}
local ControlPriority = {
  Normal = 0,
  Inertia = 1,
  Stop = 2,
  Resilience = 3,
  Drag = 4
}

function Component:InitInDungeon(Id, MainMap, IsMiniMap)
  self.RegionID = Id
  self.IsMiniMap = IsMiniMap
  self.MainMap = MainMap
  self.Panel_Empty:SetVisibility(ESlateVisibility.Collapsed)
  self.IsEmpty = false
  self.IsInDungeon = true
  self.RegionData = DataMgr.Region[Id]
  if self.RegionData.IsBlackBg then
    self:PlayAnimation(self.BlackBg)
  else
    self:PlayAnimation(self.WhiteBg)
  end
  self.InitCoroutines = {}
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
      self.MapImage:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    self.MiniMapRad = 135
    self.Panel_Point:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.HideTrack = false
    self.MinimapDelayMapImagePosReason = {}
    self.TickRegionMapImageOpen = false
    if not self.TickRegionMapImageOpen then
      UKismetRenderingLibrary.ClearRenderTarget2D(self, self.MapMistyRTMiniMap)
      self:AddTimer(1, function()
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        local Battle = UIManager:GetUIObj("BattleMain")
        if self.MainMap.Battle and self.MainMap.Battle:IsVisible() and self.MainMap:IsVisible() and Battle and not Battle:IsHide() then
          DebugPrint("TickRegionMapImageOpen")
          self:GetMapImageLocalPos()
          self.TickRegionMapImageOpen = true
          self:RemoveTimer("TickRegionMapImageOpen")
        end
      end, true, 0, "TickRegionMapImageOpen")
    end
    EventManager:AddEvent(EventID.OnNotifyClientToCloseLoading, self, self.InitMapRect)
  else
    self:InitInDungeonMap()
    self:InitMapRect()
    if self.AirBoxLocation then
      local TargetLoc = self:TransformWorldLocToUILoc(self.AirBoxLocation.X, self.AirBoxLocation.Y)
      self:MoveMapTo(TargetLoc * -1)
    end
  end
  self:InitDungeonComponentCoroutine()
  if not CommonUtils.IsEmpty(self.InitCoroutines) then
    coroutine.yield()
  end
  if self.DefaultFloorId and self.FloorWidgetTable and self.FloorWidgetTable[self.DefaultFloorId] then
    self.FloorWidgetTable[self.DefaultFloorId].Btn.OnClicked:Broadcast()
    self.FloorWidgetTable[self.DefaultFloorId]:PlayAnimation(self.FloorWidgetTable[self.MaxFloorId].Click)
    self.FloorWidgetTable[self.DefaultFloorId].SizeBox:SetRenderOpacity(self.IsInRegion and 1 or 0)
  elseif self.FloorWidgetTable and CommonUtils.IsEmpty(self.FloorWidgetTable) then
    self:OnScaleChange(self.CurrentPercent)
  end
  self.InitComplete = true
  self.CoroutineInitObj = nil
  if self.TrackTarget then
    self:CreateTrackIndicator(self.TrackTarget)
  end
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
    self:MinimapDelayMapImagePos("OnScaleChange")
  else
    self:ShowFloor(self.MaxFloorId)
  end
end

function Component:InitInDungeonMap()
  AudioManager(self):PlayUISound(self, "event:/ui/common/map_switch_to_level", "", nil)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if not self.GamepadSelect then
    self.GamepadSelect = NewObject(LoadClass("/Game/UI/WBP/Map/Widget/WBP_Map_Select.WBP_Map_Select_C"), self)
    self.Panel_Gamer:GetParent():AddChild(self.GamepadSelect)
    self:AdjustSlot(self.GamepadSelect.Slot)
  end
  self.GamepadSelect:SetVisibility(self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  self.GamepadSelect:PlayAnimation(self.GamepadSelect.Normal)
  self:AddInputMethodChangedListen()
  self:SetControlPriority(ControlPriority.Normal)
  self:SetVisibility(ESlateVisibility.Visible)
  if self.RegionData.RegionMapWheelScale then
    self.WheelMinScale = self.RegionData.RegionMapWheelScale[1]
    self.WheelMaxScale = self.RegionData.RegionMapWheelScale[2]
  end
  self.CurrentFloorId = self.MaxFloorId
  self.Panel_Bg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.BackgroundBlur:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:PlayAnimation(self.Auto_In)
  self.BackgroundScale = FVector2D(self.BackgroundMinScale.X, self.BackgroundMinScale.Y)
  self.MapImage:SetRenderScale(self.MapScale)
  self.MapImage:SetRenderOpacity(self.RegionMapOpacity)
  self.Bg_Map:SetRenderScale(self.BackgroundMinScale)
  self.CurrentInnerSubRegionId = nil
  self.CurrentInnerId = nil
  self.RegionIcon = nil
  self.WorldId = nil
  self.Panel_Gamer:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.WS_Indoor:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  local Avatar = GWorld:GetAvatar()
  self.IsInRegion = true
  self.WS_Indoor:SetActiveWidgetIndex(0)
  self.Direction:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Gamer:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.gamerLoc = self:TransformWorldLocToUILoc(self.Player.CurrentLocation.X, self.Player.CurrentLocation.Y)
  self.Gamer:SetRenderTranslation(self.gamerLoc)
  self.Direction:SetRenderTranslation(self.gamerLoc)
  self.Direction:SetRenderTransformAngle(self.Player:GetController().PlayerCameraManager:GetCameraRotation().Yaw + self.MapRotation + 90)
  self.Gamer:SetRenderTransformAngle(self.Player.CurrentRotation.Yaw + self.MapRotation + 90)
  if self.MapImage then
    self.MapImage:SetRenderTranslation(self.CurrentDragOffset)
    self.Bg_Map:SetRenderTranslation(self.CurrentDragOffset * self.BackgroundDragRatio)
  end
  self.Panel_Gamer:SetRenderTranslation(self.CurrentDragOffset)
  self.Panel_Point:SetRenderTranslation(self.CurrentDragOffset)
  self.BgHeight = FVector2D(0, self.MainMap.Tab_Top.Slot:GetSize().Y)
  if not self.Indicator then
    self.Indicator = self:CreateWidgetAsync("RegionMapIndicator", self.CoroutineInitObj)
    self.Panel_Floor:AddChild(self.Indicator)
    self:AdjustSlot(self.Indicator.Slot)
  end
  self.Indicator:Init(self, self.ScreenSize - self.BgHeight, self.Gamer, true)
  self.Indicator.Slot:SetZOrder(0)
  self:UpdateLimitOffset()
  self.MainMap.Slider_Zoom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:InitTouchLayer(self.Player, 0, 0, true)
  self:AddStaticSubTouchItem("RegionMapLayer", self.Panel_Touch, {
    MultiMove = self.TouchWildMapMultiMove,
    Down = self.OnRegionTouchDown,
    Move = self.OnRegionTouchMove,
    Up = self.OnRegionTouchUp
  })
end

function Component:InitMapRect()
  local GameState = UGameplayStatics.GetGameState(self)
  if not GameState then
    return
  end
  self.MapRect = UIManager(self):_CreateWidgetByUMGClass(LoadClass("/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Rect.WBP_Map_Rect"), nil, nil, nil, false)
  if self.IsMiniMap then
    self.Panel_Map:AddChild(self.MapRect)
    self.MapRect.Rect:GetDynamicMaterial():SetScalarParameterValue("Feather", 0.01)
  else
    self.Panel_Gamer:AddChild(self.MapRect)
    self.MapRect.Rect:GetDynamicMaterial():SetScalarParameterValue("Feather", 0.001)
  end
  local Half = UKismetMathLibrary.Vector2D_One() / 2
  local Anchors = self.MapRect.Slot:GetAnchors()
  Anchors.Minimum = Half
  Anchors.Maximum = Half
  self.MapRect.Slot:SetAnchors(Anchors)
  self.MapRect.Slot:SetAlignment(Half)
  for _, ManualItem in pairs(GameState.ManualActiveCombat:ToTable()) do
    if ManualItem.UnitId == Const.WCDungeonAirBoxUnitId then
      self.AirBoxLocation = ManualItem:k2_GetActorLocation()
      self.MapRect:SetRenderTranslation(self:TransformWorldLocToUILoc(self.AirBoxLocation.X, self.AirBoxLocation.Y))
      local Scale = ManualItem:GetActorScale3D()
      local Size = FVector2D(Scale.X * 200, Scale.Y * 200) * self.Scale
      local ImageSize
      if self.IsMiniMap then
        ImageSize = FVector2D(Size.X + self.MiniMapRad * 2, Size.Y + self.MiniMapRad * 2)
      else
        ImageSize = self.MapImage.Img_Map.Slot:GetSize() * 3
      end
      self.MapRect.Rect.Slot:SetSize(ImageSize)
      self.MapRect.Rect:GetDynamicMaterial():SetScalarParameterValue("Width", Size.X / ImageSize.X)
      self.MapRect.Rect:GetDynamicMaterial():SetScalarParameterValue("Height", Size.Y / ImageSize.Y)
      self.MapRect:SetRenderTransformAngle(ManualItem:K2_GetActorRotation().Yaw)
      break
    end
  end
  self.MapRect:SetVisibility(ESlateVisibility.HitTestInvisible)
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

function Component:OnScaleChange_Component(Percent)
  if not self.MapRect then
    return
  end
  self.MapRect:SetRenderTranslation(self:TransformWorldLocToUILoc(self.AirBoxLocation.X, self.AirBoxLocation.Y))
  self.MapRect:SetRenderScale(self.MapScale)
end

return Component
