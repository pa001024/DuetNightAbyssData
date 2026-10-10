require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local AIR_ALERT_OVAL_REFRESH_TICKS = 16

function M:Initialize()
  self:EnsureAirAlertProjectionBuffers()
  self.bAirAlertOuting = false
  self.AirAlertOutFinished = nil
end

function M:Construct()
  self:ResolveAirAlertGuideSlot()
  self:HideAirAlertArrow()
end

function M:EnsureAirAlertProjectionBuffers()
  if self.AirAlertWorldLoc == nil then
    self.AirAlertWorldLoc = FVector(0, 0, 0)
  end
  if nil == self.AirAlertScreenLoc then
    self.AirAlertScreenLoc = FVector2D(0, 0)
  end
  if nil == self.AirAlertSlotPos then
    self.AirAlertSlotPos = FVector2D(0, 0)
  end
  if nil == self.AirAlertCenter then
    self.AirAlertCenter = FVector2D(0, 0)
  end
  if nil == self.AirAlertSemiAxis then
    self.AirAlertSemiAxis = FVector2D(0, 0)
  end
  if nil == self.AirAlertBoardSize then
    self.AirAlertBoardSize = FVector2D(30, 30)
  end
  if nil == self.AirAlertViewportScale then
    self.AirAlertViewportScale = 1
  end
end

function M:CopyAirAlertWorldLoc(WorldLoc)
  if nil == WorldLoc then
    return
  end
  self.AirAlertWorldLoc.X = WorldLoc.X
  self.AirAlertWorldLoc.Y = WorldLoc.Y
  self.AirAlertWorldLoc.Z = WorldLoc.Z
end

function M:ResolveAirAlertGuideSlot()
  if self.AirAlertGuideSlot and IsValid(self.AirAlertGuideSlot) then
    return self.AirAlertGuideSlot
  end
  local GuideNode = self.Guide_Node
  if not IsValid(GuideNode) and self.GetWidgetFromName then
    GuideNode = self:GetWidgetFromName("Guide_Node")
  end
  if not IsValid(GuideNode) then
    return nil
  end
  local LayoutLib = UWidgetLayoutLibrary or UE4.UWidgetLayoutLibrary
  local Slot = LayoutLib and LayoutLib.SlotAsCanvasSlot(GuideNode)
  if not IsValid(Slot) then
    return nil
  end
  local Anchors = FAnchors()
  Anchors.Minimum = FVector2D(0, 0)
  Anchors.Maximum = FVector2D(0, 0)
  Slot:SetAnchors(Anchors)
  Slot:SetAlignment(FVector2D(0.5, 0.5))
  if Slot.SetAutoSize then
    Slot:SetAutoSize(true)
  end
  self.AirAlertGuideSlot = Slot
  return Slot
end

function M:ResolveAirAlertArrow()
  local Arrow = self.Common_Arrows
  if IsValid(Arrow) then
    return Arrow
  end
  if self.GetWidgetFromName then
    Arrow = self:GetWidgetFromName("Common_Arrows")
    if IsValid(Arrow) then
      self.Common_Arrows = Arrow
      return Arrow
    end
  end
  return nil
end

function M:HideAirAlertArrow()
  local Arrow = self:ResolveAirAlertArrow()
  if IsValid(Arrow) then
    Arrow:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:ResetAirAlertHidden()
  self.bAirAlertOuting = false
  self.AirAlertOutFinished = nil
  if self.Out and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  self:HideAirAlertArrow()
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.StopAllAnimations then
    self:StopAllAnimations()
  end
end

function M:PlayAirAlertInAnim()
  self.bAirAlertOuting = false
  self.AirAlertOutFinished = nil
  if self.Out then
    if self.UnbindAllFromAnimationFinished then
      self:UnbindAllFromAnimationFinished(self.Out)
    end
    if self.StopAnimation then
      self:StopAnimation(self.Out)
    end
  end
  if self.In and self.StopAnimation then
    self:StopAnimation(self.In)
  end
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  if self.In then
    self:PlayAnimation(self.In)
  end
end

function M:OnAirAlertOutFinished()
  if self.Out and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  local bWasOuting = self.bAirAlertOuting
  local Callback = self.AirAlertOutFinished
  self.bAirAlertOuting = false
  self.AirAlertOutFinished = nil
  if not bWasOuting then
    return
  end
  self:ResetAirAlertHidden()
  if Callback then
    Callback()
  end
end

function M:PlayAirAlertOutAnim(OnFinished)
  if self.bAirAlertOuting then
    return
  end
  if self.In and self.StopAnimation then
    self:StopAnimation(self.In)
  end
  self.AirAlertOutFinished = OnFinished
  if not self.Out then
    self.bAirAlertOuting = true
    self:OnAirAlertOutFinished()
    return
  end
  local OutDuration = self.Out.GetEndTime and self.Out:GetEndTime() or 0
  if OutDuration <= 0 or not self.BindToAnimationFinished then
    self.bAirAlertOuting = true
    self:OnAirAlertOutFinished()
    return
  end
  self.bAirAlertOuting = true
  if self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnAirAlertOutFinished
  })
  self:PlayAnimation(self.Out)
end

function M:UpdateAirAlertArrow(IndicatorAngle, IsOutElliptic)
  local Arrow = self:ResolveAirAlertArrow()
  if not IsValid(Arrow) then
    return
  end
  if IsOutElliptic then
    if nil ~= IndicatorAngle then
      Arrow:SetRenderTransformAngle(IndicatorAngle + 45)
    end
    Arrow:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    Arrow:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshAirAlertOvalIfNeeded(bForce)
  local Ticks = (self.AirAlertOvalTick or 0) + 1
  if not bForce and Ticks < AIR_ALERT_OVAL_REFRESH_TICKS then
    self.AirAlertOvalTick = Ticks
    return
  end
  self.AirAlertOvalTick = 0
  local Center, SemiAxis, BoardSize = UE4.UUIFunctionLibrary.GetDungeonIndicatorOvalParams(self)
  if nil == Center or nil == SemiAxis then
    return
  end
  self.AirAlertCenter.X = Center.X
  self.AirAlertCenter.Y = Center.Y
  self.AirAlertSemiAxis.X = SemiAxis.X
  self.AirAlertSemiAxis.Y = SemiAxis.Y
  if nil ~= BoardSize then
    self.AirAlertBoardSize.X = BoardSize.X
    self.AirAlertBoardSize.Y = BoardSize.Y
  end
  local Scale = UWidgetLayoutLibrary.GetViewportScale(self)
  if nil == Scale or 0 == Scale then
    Scale = 1
  end
  self.AirAlertViewportScale = Scale
end

function M:GetAirAlertPlayerController()
  if not IsValid(self.AirAlertPlayerController) then
    self.AirAlertPlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  end
  return self.AirAlertPlayerController
end

function M:SetAirAlertTarget(WorldLoc)
  self:EnsureAirAlertProjectionBuffers()
  self:CopyAirAlertWorldLoc(WorldLoc)
  self:RefreshAirAlertOvalIfNeeded(true)
  self:UpdateAirAlertProjection()
end

function M:UpdateAirAlertProjection()
  local WorldLoc = self.AirAlertWorldLoc
  if nil == WorldLoc then
    return
  end
  local PC = self:GetAirAlertPlayerController()
  if not IsValid(PC) then
    return
  end
  self:RefreshAirAlertOvalIfNeeded(false)
  local IndicatorAngle, TargetDistance, IsOutElliptic = UE4.UUIFunctionLibrary.ProjectWorldToScreenInEllipse(PC, WorldLoc, self.AirAlertScreenLoc, self.AirAlertCenter, self.AirAlertSemiAxis, self.AirAlertBoardSize, 0, 0, false)
  local Scale = self.AirAlertViewportScale or 1
  if 0 == Scale then
    Scale = 1
  end
  local OffsetY = Const.MonsterSpawnAirAlertOffsetY or 0
  if OffsetY > 0 and not IsOutElliptic then
    local OffsetVp = OffsetY * Scale
    local RelX = self.AirAlertScreenLoc.X - self.AirAlertCenter.X
    local A, B = self.AirAlertSemiAxis.X, self.AirAlertSemiAxis.Y
    local InsideX2 = 1 - RelX * RelX / (A * A)
    local TopY = self.AirAlertCenter.Y
    if InsideX2 > 0 and B > 0 then
      TopY = self.AirAlertCenter.Y - B * math.sqrt(InsideX2)
    end
    local NewY = self.AirAlertScreenLoc.Y - OffsetVp
    if TopY > NewY then
      NewY = TopY
      IsOutElliptic = true
    end
    self.AirAlertScreenLoc.Y = NewY
  end
  self.AirAlertSlotPos.X = self.AirAlertScreenLoc.X / Scale
  self.AirAlertSlotPos.Y = self.AirAlertScreenLoc.Y / Scale
  local Slot = self:ResolveAirAlertGuideSlot()
  if Slot then
    Slot:SetPosition(self.AirAlertSlotPos)
  end
  self:UpdateAirAlertArrow(IndicatorAngle, IsOutElliptic)
end

function M:Destruct()
  if self.Out and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  self.bAirAlertOuting = nil
  self.AirAlertOutFinished = nil
end

return M
