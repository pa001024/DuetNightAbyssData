local Component = {}

function Component:SetHost(Host)
  self.PageHost = Host
end

function Component:InitMode(RegionMap)
end

function Component:PostInit(RegionMap)
end

function Component:OnDestruct(RegionMap)
end

function Component:IsMiniMap()
  return false
end

function Component:GetPageHost()
  return self.PageHost
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
  if self.PageHost and self.PageHost.OnAreaClicked then
    self.PageHost:OnAreaClicked()
  end
end

function Component:OpenSelectList(SelectTable)
  if self.PageHost and self.PageHost.OpenSelectList then
    self.PageHost:OpenSelectList(SelectTable)
  end
end

function Component:OpenOptionSelect()
end

function Component:IsInteractiveOpen()
  if self.PageHost and self.PageHost.IsInteractiveOpen then
    return self.PageHost:IsInteractiveOpen()
  end
  return false
end

function Component:OnMouseWheelTurned(Percent)
  if self.PageHost and self.PageHost.OnMouseWheelTurned then
    self.PageHost:OnMouseWheelTurned(Percent)
  end
end

function Component:AddChildToAreaInfo(Widget)
end

function Component:AddChildToConvey(Widget)
  if self.PageHost and self.PageHost.AddChildToConvey then
    self.PageHost:AddChildToConvey(Widget)
    return
  end
  local WildMap = self.PageHost and self.PageHost.RealWildMap
  if WildMap and WildMap.Convey then
    WildMap.Convey:AddChild(Widget)
  end
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
  return self.PageHost:GetTabTopHeight()
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
  self.PageHost:SetSliderZoomVisible(Visible)
end

function Component:AddChildToMark(Widget)
end

function Component:AddChildToPosSoloTreasureKeyLocation(Widget)
  if self.PageHost and self.PageHost.AddChildToPosSoloTreasureKeyLocation then
    self.PageHost:AddChildToPosSoloTreasureKeyLocation(Widget)
    return
  end
  local WildMap = self.PageHost and self.PageHost.RealWildMap
  if WildMap and WildMap.Pos_SoloTreasure_KeyLocation then
    WildMap.Pos_SoloTreasure_KeyLocation:AddChild(Widget)
  end
end

function Component:CommonMapTipsHasAnyChildren()
  return false
end

function Component:CommonMapTipsClearChildren()
end

function Component:CommonMapTipsAddChild(Widget)
end

function Component:GetMapTipsHost()
  return self.PageHost
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
  if self.PageHost and self.PageHost.BindAutoOutOnFinished then
    self.PageHost:BindAutoOutOnFinished(Callback)
  end
end

function Component:HostClose()
  if self.PageHost and self.PageHost.Close then
    self.PageHost:Close()
  end
end

function Component:UpdateKeyTipEnsure()
end

function Component:UpdateKeyTipNormal()
end

function Component:GetMistyMaterial(RegionMap)
  return UKismetMaterialLibrary.CreateDynamicMaterialInstance(RegionMap, RegionMap.MapMistyMaterial)
end

function Component:GetMistyRT(RegionMap)
  return nil
end

function Component:ShouldShowFogAnim()
  return false
end

function Component:GetFogDrawPos(RegionMap, ShowAnimId)
  return nil
end

function Component:GetMapImageVisibility()
  return UE4.ESlateVisibility.SelfHitTestInvisible
end

function Component:ShouldShowRegionMapPane()
  return false
end

function Component:GetIconScale(RegionMap)
  return UKismetMathLibrary.Vector2D_One()
end

function Component:RegisterPoint(RegionMap, Point)
end

function Component:ShouldHandleInput()
  return true
end

function Component:OnScaleChangeExtra(RegionMap, Percent, TargetOffset)
  RegionMap.BackgroundScale:Set(RegionMap.BackgroundMaxScale.X, RegionMap.BackgroundMaxScale.Y)
  FVector2D.Sub(RegionMap.BackgroundScale, RegionMap.BackgroundMinScale)
  RegionMap.BackgroundScale = RegionMap.BackgroundScale * Percent
  FVector2D.Add(RegionMap.BackgroundScale, RegionMap.BackgroundMinScale)
  RegionMap.Bg_Map:SetRenderScale(RegionMap.BackgroundScale)
  RegionMap:UpdateLimitOffset()
end

function Component:ShouldMoveMapOnScale()
  return true
end

function Component:OnViewportSizeChanged(RegionMap)
  RegionMap.ScreenSize = UIManager(RegionMap):GetDesignedScreenSize(RegionMap)
  FVector2D.Div(RegionMap.ScreenSize, 2)
end

function Component:NewPointArrow()
  return nil
end

function Component:GetTracePanel()
  return nil
end

function Component:IsTracePanelValid()
  return false
end

function Component:TracePanelHasChild(Widget)
  return false
end

function Component:TracePanelRemoveChild(Widget)
end

function Component:TracePanelAddChild(Widget)
end

function Component:GetTracePanelScaleXY()
  return 1, 1
end

function Component:IsBattleVisibleAndSelfVisible()
  return false
end

function Component:OnSkipRegion(RegionMap, SubRegionId)
end

function Component:OnCommonTrackMiniMap(RegionMap, TrackingType, Id, IsAdd)
  return false
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
