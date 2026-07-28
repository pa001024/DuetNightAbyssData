local Component = {}

function Component:SetHost(Host)
  self.PageHost = Host
end

function Component:InitMode(RegionMap)
  self.PageHost:SetWildMapKeysShow(true)
  self.PageHost:SetTabVisible(true)
  RegionMap:InitInRegionMap()
end

function Component:PostInit(RegionMap)
end

function Component:OnDestruct(RegionMap)
  if not RegionMap.IsEmpty then
    RegionMap:ClosePanel(true)
  end
end

function Component:IsMiniMap()
  return false
end

function Component:GetPageHost()
  return self.PageHost
end

function Component:SetWildMapKeysShow(Value)
  self.PageHost:SetWildMapKeysShow(Value)
end

function Component:UpdateWildMapKeys()
  self.PageHost:UpdateWildMapKeys()
end

function Component:ShoworHideTopTab(BShow)
  self.PageHost:ShoworHideTopTab(BShow)
end

function Component:ShoworHideBottomTab(BShow)
  self.PageHost:ShoworHideBottomTab(BShow)
end

function Component:SetPanelOpen(Value)
  self.PageHost:SetIsPanelOpen(Value)
end

function Component:IsPanelOpen()
  return self.PageHost:GetIsPanelOpen()
end

function Component:SetDispatchId(ID)
  self.PageHost:SetDispatchIdValue(ID)
end

function Component:SetEntranceDispatchVisible(Visible)
  self.PageHost:SetEntranceDispatchVisible(Visible)
end

function Component:SetReturnHomeVisible(Visible)
  self.PageHost:SetReturnHomeVisible(Visible)
end

function Component:CloseDispatchDetailIfAny()
  self.PageHost:CloseDispatchDetailIfAny()
end

function Component:HasDispatchDetail()
  return self.PageHost:HasDispatchDetail()
end

function Component:TryCloseDispatchAgentList()
  return self.PageHost:TryCloseDispatchAgentList()
end

function Component:TryCloseDispatchList()
  return self.PageHost:TryCloseDispatchList()
end

function Component:TryClickDispatchListSpace()
  self.PageHost:TryClickDispatchListSpace()
end

function Component:HasDispatchAgentList()
  return self.PageHost:HasDispatchAgentList()
end

function Component:OnClickDispatch()
  if self.PageHost:IsEntranceDispatchVisible() then
    self.PageHost:OnClickDispatch()
  end
end

function Component:OnAreaClicked()
  self.PageHost:OnAreaClicked()
end

function Component:OpenSelectList(SelectTable)
  self.PageHost:OpenSelectList(SelectTable)
end

function Component:OpenOptionSelect()
  self.PageHost:OpenOptionSelect()
end

function Component:IsInteractiveOpen()
  return self.PageHost:IsInteractiveOpen()
end

function Component:OnMouseWheelTurned(Percent)
  self.PageHost:OnMouseWheelTurned(Percent)
end

function Component:AddChildToAreaInfo(Widget)
  self.PageHost:AddChildToAreaInfo(Widget)
end

function Component:AddChildToConvey(Widget)
  self.PageHost:AddChildToConvey(Widget)
end

function Component:AddChildToConveyHardBoss(Widget)
  self.PageHost:AddChildToConveyHardBoss(Widget)
end

function Component:AddChildToConveyAreaCoop(Widget)
  self.PageHost:AddChildToConveyAreaCoop(Widget)
end

function Component:AddChildToChangeArea(Widget)
  self.PageHost:AddChildToChangeArea(Widget)
end

function Component:GetFloorWidget()
  return self.PageHost:GetFloorWidget()
end

function Component:GetImpressionSpacer()
  return self.PageHost:GetImpressionSpacer()
end

function Component:GetTabTopHeight()
  return self.PageHost:GetTabTopHeight()
end

function Component:GetPanelCloseButton()
  return self.PageHost:GetPanelCloseButton()
end

function Component:GetInteractiveLocatePanel()
  return self.PageHost:GetInteractiveLocatePanel()
end

function Component:BindLocationBtn(RegionMap)
  self.PageHost:BindLocationBtn(RegionMap)
end

function Component:SetLocationBtnVisible(Visible)
  self.PageHost:SetLocationBtnVisible(Visible)
end

function Component:SetSliderZoomVisible(Visible)
  self.PageHost:SetSliderZoomVisible(Visible)
end

function Component:AddChildToMark(Widget)
  self.PageHost:AddChildToMark(Widget)
end

function Component:AddChildToPosSoloTreasureKeyLocation(Widget)
  self.PageHost:AddChildToPosSoloTreasureKeyLocation(Widget)
end

function Component:CommonMapTipsHasAnyChildren()
  return self.PageHost:CommonMapTipsHasAnyChildren()
end

function Component:CommonMapTipsClearChildren()
  self.PageHost:CommonMapTipsClearChildren()
end

function Component:CommonMapTipsAddChild(Widget)
  self.PageHost:CommonMapTipsAddChild(Widget)
end

function Component:GetMapTipsHost()
  return self.PageHost
end

function Component:GetMapRegionType()
  return self.PageHost:GetMapRegionType()
end

function Component:InsertBackGamePadKeyAtFirst(KeyEntry)
  self.PageHost:InsertBackGamePadKeyAtFirst(KeyEntry)
end

function Component:RemoveFirstBackGamePadKeyIfRS()
  self.PageHost:RemoveFirstBackGamePadKeyIfRS()
end

function Component:HasDispatchList()
  return self.PageHost:HasDispatchList()
end

function Component:CreateOrRefreshDispatchDetail(DispatchInfo)
  self.PageHost:CreateOrRefreshDispatchDetail(DispatchInfo)
end

function Component:OpenAgentList()
  self.PageHost:OpenAgentList()
end

function Component:BindAutoOutOnFinished(Callback)
  self.PageHost:BindAutoOutOnFinished(Callback)
end

function Component:HostClose()
  self.PageHost:HostClose()
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

function Component:UpdateKeyTipEnsure()
  self.PageHost:UpdateKeyTipEnsure()
end

function Component:UpdateKeyTipNormal()
  self.PageHost:UpdateKeyTipNormal()
end

function Component:GetMistyMaterial(RegionMap)
  return UKismetMaterialLibrary.CreateDynamicMaterialInstance(RegionMap, RegionMap.MapMistyMaterial)
end

function Component:GetMistyRT(RegionMap)
  return nil
end

function Component:ShouldShowFogAnim()
  return true
end

function Component:GetFogDrawPos(RegionMap, ShowAnimId)
  return nil
end

function Component:GetMapImageVisibility()
  if _G.ShowRegionmapPane then
    return ESlateVisibility.SelfHitTestInvisible
  end
  return ESlateVisibility.HitTestInvisible
end

function Component:ShouldShowRegionMapPane()
  return _G.ShowRegionmapPane and true or false
end

function Component:GetIconScale()
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

function Component:OnSkipRegion(RegionMap, SubRegionId)
end

function Component:OnCommonTrackMiniMap(RegionMap, TrackingType, Id, IsAdd)
  return false
end

function Component:ShouldReturnOnCommonTrack()
  return false
end

function Component:CreateTrackIndicator(RegionMap, TrackTarget)
  if not RegionMap.InitComplete then
    RegionMap.TrackTarget = TrackTarget
    return
  end
  if not RegionMap.TrackIndicator then
    RegionMap.TrackIndicator = RegionMap:NewIndicator()
    RegionMap.TrackIndicator:Init(RegionMap, RegionMap.ScreenSize - RegionMap.BgHeight, TrackTarget, false)
    RegionMap.TrackIndicator.Slot:SetZOrder(2)
  end
  RegionMap.TrackTarget = TrackTarget
  RegionMap.TrackIndicator:SetIcon(TrackTarget.Img_Point.Brush.ResourceObject)
  RegionMap.TrackIndicator:OnPointerMove(RegionMap.CurrentDragOffset, RegionMap.TrackTarget.RenderTransform.Translation)
end

function Component:OnCommonTrackDeleteSpecialSideQuest(RegionMap, TrackingType)
  RegionMap:OnCommonTrackDeleteSpecialSideQuestTrack_Impl(TrackingType)
end

function Component:InitDispatchCondition(RegionMap)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local ConditionId = DataMgr.UIUnlockRule.Dispatch.ConditionId
  local Res = ConditionUtils.CheckCondition(Avatar, ConditionId)
  if not RegionMap.NormalInit then
    return
  end
  self.PageHost:SetEntranceDispatchVisible(Res)
  if Res then
    SystemGuideManager:RunGuideById(2057)
  end
end

return Component
