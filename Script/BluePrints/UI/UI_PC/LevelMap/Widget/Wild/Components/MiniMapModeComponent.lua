local Component = {}

function Component:SetHost(Host)
  self.BattleHost = Host
end

function Component:InitMode(RegionMap)
  RegionMap:InitInMiniMap()
end

function Component:PostInit(RegionMap)
  local Array = GWorld.GameInstance:GetSceneManager().FloorBoxArray
  if Array then
    RegionMap.CurrentFloorId = nil
    for _, FloorBox in pairs(Array) do
      FloorBox:CheckPlayerIn()
      DebugPrint("MiniMap Wild CheckPlayerIn", FloorBox:GetName())
    end
    DebugPrint("MiniMap Wild CheckPlayerIn", RegionMap.CurrentFloorId)
  end
  if not RegionMap.CurrentFloorId then
    RegionMap:ShowFloor(RegionMap.MaxFloorId)
  end
  if RegionMap.WheelMaxScale ~= RegionMap.WheelMinScale and RegionMap.MiniMapScale then
    RegionMap.MiniMapScale = math.clamp(RegionMap.MiniMapScale, 0, 1)
    RegionMap:OnScaleChange((RegionMap.MiniMapScale - RegionMap.WheelMinScale) / (RegionMap.WheelMaxScale - RegionMap.WheelMinScale))
    self.BattleHost:SetScaleValue(RegionMap.Scale * RegionMap.MapScale.X)
  end
  RegionMap:MinimapDelayMapImagePos("OnScaleChange")
  if GWorld.GameInstance.TrackingPack then
    local TrackingType, Id = table.unpack(GWorld.GameInstance.TrackingPack)
    RegionMap:OnCommonTrack(TrackingType, Id, true)
  end
end

function Component:OnDestruct(RegionMap)
end

function Component:IsMiniMap()
  return true
end

function Component:GetPageHost()
  return self.BattleHost
end

function Component:SetWildMapKeysShow(Value)
end

function Component:UpdateWildMapKeys()
end

function Component:ShoworHideTopTab(BShow)
end

function Component:ShoworHideBottomTab(BShow)
end

function Component:SetPanelOpen(Value)
end

function Component:IsPanelOpen()
  return false
end

function Component:SetDispatchId(ID)
end

function Component:SetEntranceDispatchVisible(Visible)
end

function Component:SetReturnHomeVisible(Visible)
end

function Component:CloseDispatchDetailIfAny()
end

function Component:HasDispatchDetail()
  return false
end

function Component:TryCloseDispatchAgentList()
  return false
end

function Component:TryCloseDispatchList()
  return false
end

function Component:TryClickDispatchListSpace()
end

function Component:HasDispatchAgentList()
  return false
end

function Component:OnClickDispatch()
end

function Component:OnAreaClicked()
end

function Component:OpenSelectList(SelectTable)
end

function Component:OpenOptionSelect()
end

function Component:IsInteractiveOpen()
  return false
end

function Component:OnMouseWheelTurned(Percent)
end

function Component:AddChildToAreaInfo(Widget)
end

function Component:AddChildToConvey(Widget)
end

function Component:AddChildToConveyHardBoss(Widget)
end

function Component:AddChildToConveyAreaCoop(Widget)
end

function Component:AddChildToChangeArea(Widget)
end

function Component:GetFloorWidget()
  return nil
end

function Component:GetImpressionSpacer()
  return nil
end

function Component:GetTabTopHeight()
  return 0
end

function Component:GetPanelCloseButton()
  return nil
end

function Component:GetInteractiveLocatePanel()
  return nil
end

function Component:BindLocationBtn(RegionMap)
end

function Component:SetLocationBtnVisible(Visible)
end

function Component:SetSliderZoomVisible(Visible)
end

function Component:UpdateKeyTipEnsure()
end

function Component:UpdateKeyTipNormal()
end

function Component:GetMistyMaterial(RegionMap)
  return UKismetMaterialLibrary.CreateDynamicMaterialInstance(RegionMap, RegionMap.MapMistyMaterialMiniMap)
end

function Component:GetMistyRT(RegionMap)
  return RegionMap.MapMistyRTMiniMap
end

function Component:ShouldShowFogAnim()
  return false
end

function Component:GetFogDrawPos(RegionMap, ShowAnimId)
  return nil
end

function Component:GetMapImageVisibility()
  return ESlateVisibility.HitTestInvisible
end

function Component:ShouldShowRegionMapPane()
  return false
end

function Component:GetIconScale(RegionMap)
  return RegionMap.MinimapIconScale
end

function Component:RegisterPoint(RegionMap, Point)
  RegionMap.MapPointQueue:Add(Point)
end

function Component:ShouldHandleInput()
  return false
end

function Component:OnScaleChangeExtra(RegionMap, Percent, TargetOffset)
end

function Component:ShouldMoveMapOnScale()
  return false
end

function Component:OnViewportSizeChanged(RegionMap)
end

function Component:NewPointArrow()
  return self.BattleHost:NewPointArrow()
end

function Component:GetTracePanel()
  return self.BattleHost:GetTracePanel()
end

function Component:IsTracePanelValid()
  return self.BattleHost:IsTracePanelValid()
end

function Component:TracePanelHasChild(Widget)
  return self.BattleHost:TracePanelHasChild(Widget)
end

function Component:TracePanelRemoveChild(Widget)
  self.BattleHost:TracePanelRemoveChild(Widget)
end

function Component:TracePanelAddChild(Widget)
  self.BattleHost:TracePanelAddChild(Widget)
end

function Component:GetTracePanelScaleXY()
  return self.BattleHost:GetTracePanelScaleXY()
end

function Component:IsBattleVisibleAndSelfVisible()
  return self.BattleHost:IsBattleVisibleAndSelfVisible()
end

function Component:CommonMapTipsHasAnyChildren()
  return false
end

function Component:CommonMapTipsClearChildren()
end

function Component:CommonMapTipsAddChild(Widget)
end

function Component:GetMapTipsHost()
  return self.BattleHost
end

function Component:GetMapRegionType()
  return nil
end

function Component:InsertBackGamePadKeyAtFirst(KeyEntry)
end

function Component:RemoveFirstBackGamePadKeyIfRS()
end

function Component:HasDispatchList()
  return false
end

function Component:CreateOrRefreshDispatchDetail(DispatchInfo)
end

function Component:OpenAgentList()
end

function Component:BindAutoOutOnFinished(Callback)
end

function Component:HostClose()
end

function Component:AddChildToMark(Widget)
end

function Component:AddChildToPosSoloTreasureKeyLocation(Widget)
end

function Component:OnSkipRegion(RegionMap, SubRegionId)
  if not RegionMap.MapImage then
    return
  end
  if DataMgr.SubRegion[SubRegionId].NotShowInRegionMap then
    RegionMap.Panel_Point:SetVisibility(ESlateVisibility.Collapsed)
    RegionMap.MapImage:SetVisibility(ESlateVisibility.Collapsed)
    RegionMap.HideTrack = true
  else
    RegionMap.Panel_Point:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    RegionMap.MapImage:SetVisibility(ESlateVisibility.HitTestInvisible)
    RegionMap.HideTrack = false
    if not RegionMap.TickRegionMapImageOpen then
      UKismetRenderingLibrary.ClearRenderTarget2D(RegionMap, RegionMap.MapMistyRTMiniMap)
      RegionMap:AddTimer(0.1, function()
        local UIManager = GWorld.GameInstance:GetGameUIManager()
        local Battle = UIManager:GetUIObj("BattleMain")
        if self.BattleHost:IsBattleVisibleAndSelfVisible() and Battle and not Battle:IsHide() then
          RegionMap:MinimapDelayMapImagePos("OnSkipRegion")
          RegionMap:RemoveTimer("TickRegionMapImageOpen")
        end
      end, true, 0, "TickRegionMapImageOpen")
    end
  end
  RegionMap:CheckRegionPointCancelTrack(SubRegionId)
end

function Component:OnCommonTrackMiniMap(RegionMap, TrackingType, Id, IsAdd)
  if TrackingType == CommonConst.RegionMapTrackingType.MiniDispatchPoint and DataMgr.Dispatch[Id] ~= nil and true == IsAdd then
    local Path = "/Game/UI/WBP/Map/Widget/Dispatch/WBP_Map_DispatchPointInfo.WBP_Map_DispatchPointInfo"
    local Point = UIManager(RegionMap):CreateWidget(Path)
    local UIPos = DataMgr.DispatchUI[Id].UIPos
    local Pos = RegionMap:TransformWorldLocToUILoc(UIPos[1], UIPos[2])
    Point:SetRenderTranslation(Pos)
    Point:InitMini(Id)
    RegionMap.MiniDispatchPoint[Id] = Point
    DebugPrint("Point", Point, IsAdd)
    GWorld.GameInstance.TrackingPack = {TrackingType, Id}
  end
  return true
end

function Component:ShouldReturnOnCommonTrack()
  return true
end

function Component:CreateTrackIndicator(RegionMap, TrackTarget)
end

function Component:OnCommonTrackDeleteSpecialSideQuest(RegionMap, TrackingType)
end

function Component:InitDispatchCondition(RegionMap)
end

return Component
