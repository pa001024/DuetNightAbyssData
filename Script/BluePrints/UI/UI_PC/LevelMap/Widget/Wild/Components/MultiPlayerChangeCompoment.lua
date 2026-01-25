require("UnLua")
local Component = {}
local TipsBpPath = "WidgetBlueprint'/Game/UI/WBP/AreaCoop/Widget/WBP_AreaCoop_MapTips.WBP_AreaCoop_MapTips'"

function Component:InitComponentCoroutine()
  local Coroutine = CreateCoroutine(self.InitMultiplayerChallenge)
  table.insert(self.InitCoroutines, Coroutine)
  coroutine.resume(Coroutine, self, #self.InitCoroutines)
end

function Component:ClearData()
  if self.ChallengePoints then
    for _, widget in pairs(self.ChallengePoints) do
      widget:RemoveFromParent()
    end
    self.ChallengePoints = {}
  end
  self.TeleportIdToChallengeId = {}
  if self.ChanllengeTips then
    self.ChanllengeTips:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function Component:InitMultiplayerChallenge(CoroutineIndex)
  self.ChallengePoints = {}
  self.ChallengePointLocation = {}
  self.ChallengePoint2FloorId = {}
  self.Challenge2LocalPos = {}
  self.CurrentChallengeId = nil
  self.TeleportIdToChallengeId = {}
  local Avatar = GWorld:GetAvatar()
  for ChallengeId, ChallengeData in pairs(DataMgr.MultiplayerChallenge or {}) do
    local TeleportId = ChallengeData.TeleportId
    local TeleportData = TeleportId and DataMgr.TeleportPoint[TeleportId] or nil
    if TeleportData and TeleportData.MechanismPos and TeleportData.TeleportPointSubRegion then
      local SubRegionId = TeleportData.TeleportPointSubRegion
      local RegionId = DataMgr.SubRegion[SubRegionId] and DataMgr.SubRegion[SubRegionId].RegionId
      if RegionId == self.RegionData.RegionId then
        local isUnlock = true
        if nil ~= ChallengeData.UnlockCondition then
          isUnlock = ConditionUtils.CheckCondition(Avatar, ChallengeData.UnlockCondition, false)
        end
        if not isUnlock then
        else
          local point, select = self:NewPointAsync(self.InitCoroutines[CoroutineIndex])
          point:Init(self, TeleportData, true, self.OnChallengePointClick, self.OnChallengeHover, self.OnChallengeUnhover)
          local x, y = TeleportData.MechanismPos[1], TeleportData.MechanismPos[2]
          local position = self:TransformWorldLocToUILoc(x, y)
          point:SetRenderTranslation(position)
          select:SetRenderTranslation(position)
          local TelePortDataId = TeleportData.Id
          self.ChallengePoints[TelePortDataId] = point
          self.SelectWidgetTable[TelePortDataId] = select
          self.ChallengePointLocation[TelePortDataId] = FVector2D(x, y)
          self.TeleportIdToChallengeId[TelePortDataId] = ChallengeId
          local floorId = self.MaxFloorId
          if TeleportData.BuildingNameAndId then
            local _, buildingFloor = self:GetBuildingNameAndId(TeleportData.BuildingNameAndId)
            floorId = buildingFloor or self.MaxFloorId
          end
          self.ChallengePoint2FloorId[TelePortDataId] = floorId
          local TrackingId = self:GetTrackingId(CommonConst.RegionMapTrackingType.MultiplayerChallenge)
          if TelePortDataId == TrackingId then
            point:PlayAnimation(point.Loop, 0, 0)
            self:CreateTrackIndicator(point)
          end
        end
      end
    end
  end
  self:InitCoroutineCheck(CoroutineIndex)
end

function Component:ShowFloor_Component(FloorId)
  if not self.ChallengePoints then
    return
  end
  for id, point in pairs(self.ChallengePoints) do
    local floorType = (self.ChallengePoint2FloorId[id] or self.MaxFloorId) - FloorId
    point:SetFloor(floorType)
  end
end

function Component:OnScaleChange_Component(Percent)
  if not self.ChallengePoints then
    return
  end
  local TrackingID = self:GetTrackingId(CommonConst.RegionMapTrackingType.MultiplayerChallenge)
  local Visible = self:GetMapIconVisible("UI_TELEPORTPOINT", Percent)
  for id, point in pairs(self.ChallengePoints) do
    if not self.IsMinimap then
      if Visible or id == self.CurrentChallengeId or id == TrackingID then
        if (point:GetVisibility() ~= ESlateVisibility.SelfHitTestInvisible or not point.PlayForward) and point:SetPointVisibility("Scale", true) then
          point:StopAnimation(point.In)
          point:PlayAnimation(point.In)
          point.PlayForward = true
        end
      elseif point:GetVisibility() ~= ESlateVisibility.Collapsed or point.PlayForward then
        if not point:IsAnimationPlaying(point.In) or point.PlayForward then
          point:StopAnimation(point.In)
          point:PlayAnimationReverse(point.In)
          point.PlayForward = false
        end
        point:SetPointVisibility("Scale", false)
      end
    end
    if point:GetVisibility() ~= ESlateVisibility.Collapsed and self.ChallengePointLocation[id] or self.IsMinimap then
      local pos = self:TransformWorldLocToUILoc(self.ChallengePointLocation[id].X, self.ChallengePointLocation[id].Y)
      point:SetRenderTranslation(pos)
      self.SelectWidgetTable[id]:SetRenderTranslation(pos)
    end
  end
end

function Component:FreshOrCreatTips(ChallengeId)
  if not self.ChanllengeTips or not IsValid(self.ChanllengeTips) then
    self.ChanllengeTips = UIManager(self):CreateWidgetAsync(nil, self.CoroutineInitObj, TipsBpPath)
    if not self.ChanllengeTips then
      ScreenPrint("创建多人传送点详情失败")
      return
    end
    self.MainMap.Convey_AreaCoop:AddChild(self.ChanllengeTips)
    self.ChanllengeTips:SetVisibility(ESlateVisibility.Collapsed)
    self.ChanllengeTips.Parent = self
  end
  if self.ChanllengeTips then
    local wasVisible = self.ChanllengeTips:GetVisibility() == ESlateVisibility.SelfHitTestInvisible
    self.ChanllengeTips:Refresh(ChallengeId)
    self.ChanllengeTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if not wasVisible then
      self.ChanllengeTips:PlayAnimation(self.ChanllengeTips.In)
    end
    self.ChanllengeTips:SetFocus()
  end
end

function Component:CloseChallengeTips(IsImmediately)
  if self.ChanllengeTips and self.ChanllengeTips:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
    if IsImmediately then
      self.ChanllengeTips:SetVisibility(ESlateVisibility.Collapsed)
    else
      if self.ChanllengeTips.UnbindAllFromAnimationFinished and self.ChanllengeTips.BindToAnimationFinished then
        self.ChanllengeTips:UnbindAllFromAnimationFinished(self.ChanllengeTips.Out)
        self.ChanllengeTips:BindToAnimationFinished(self.ChanllengeTips.Out, function()
          if self.ChanllengeTips then
            self.ChanllengeTips:SetVisibility(ESlateVisibility.Collapsed)
          end
        end)
      end
      self.ChanllengeTips:PlayAnimation(self.ChanllengeTips.Out)
      return true
    end
  end
end

function Component:OnChallengePointClick(Id)
  local ChallengeId = self.TeleportIdToChallengeId[Id]
  local challengeData = (DataMgr.MultiplayerChallenge or {})[ChallengeId]
  if not challengeData or not self:CheckControlPriority_Normal() then
    return
  end
  self:ClosePanel(true)
  if not self:CheckSelect(self.ChallengePoints[Id]) then
    return
  end
  self.CurrentSelectPoint = self.ChallengePoints[Id]
  self.CurrentSelectPoint.Slot:SetZOrder(20)
  self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.SelectWidgetTable[Id]:PlayAnimation(self.SelectWidgetTable[Id].Click)
  if self.ClickedSelectWidget then
    self.ClickedSelectWidget:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.ClickedSelectWidget = self.SelectWidgetTable[Id]
  self.CurrentChallengeId = Id
  self.CurrentConveyId = Id
  local floorId = self.ChallengePoint2FloorId[Id]
  if floorId then
    self:OnFloorBtnClicked(floorId, true)
  end
  self:OnPanelOpen(2)
  self:FreshOrCreatTips(ChallengeId)
  if Id then
    self:MoveMapToTelepoint(Id)
  end
end

function Component:OnChallengeHover(Id)
  if self.ChallengePoints[Id] and self.SelectWidgetTable[Id] ~= self.ClickedSelectWidget then
    self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.SelectWidgetTable[Id]:PlayAnimation(self.SelectWidgetTable[Id].Hover)
  end
end

function Component:OnChallengeUnhover(Id)
  if self.ChallengePoints[Id] and self.SelectWidgetTable[Id] ~= self.ClickedSelectWidget then
    self.SelectWidgetTable[Id]:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function Component:Destruct()
  if self.ChanllengeTips and IsValid(self.ChanllengeTips) then
    self.ChanllengeTips:RemoveFromParent()
  end
  self.ChanllengeTips = nil
end

return Component
