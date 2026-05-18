require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local EnumPlayerSignRewardState = ActivityUtils.EnumPlayerSignRewardState
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

local function GetWidgetRectInTargetSpace(Widget, TargetWidget)
  if not (Widget and TargetWidget and Widget.GetCachedGeometry) or not TargetWidget.GetCachedGeometry then
    return nil
  end
  local WidgetGeometry = Widget:GetCachedGeometry()
  local TargetGeometry = TargetWidget:GetCachedGeometry()
  if not WidgetGeometry or not TargetGeometry then
    return nil
  end
  local LocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(WidgetGeometry)
  if not LocalSize or LocalSize.X <= 0 or LocalSize.Y <= 0 then
    return nil
  end
  local WidgetAbsPos = UE4.USlateBlueprintLibrary.LocalToAbsolute(WidgetGeometry, FVector2D(0, 0))
  local LocalPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(TargetGeometry, WidgetAbsPos)
  return {
    Left = LocalPos.X,
    Top = LocalPos.Y,
    Right = LocalPos.X + LocalSize.X,
    Bottom = LocalPos.Y + LocalSize.Y,
    Width = LocalSize.X,
    Height = LocalSize.Y
  }
end

local function GetWidgetWidth(Widget)
  if not Widget or not Widget.GetCachedGeometry then
    return 0
  end
  local Geometry = Widget:GetCachedGeometry()
  if not Geometry then
    return 0
  end
  local Size = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)
  return Size and Size.X or 0
end

local function GetWidgetPadding(Widget)
  local PaddingLeft = 0
  local PaddingRight = 0
  if not Widget then
    return PaddingLeft, PaddingRight
  end
  local Slot = UE4.UWidgetLayoutLibrary.SlotAsHorizontalBoxSlot(Widget)
  local Padding
  if Slot and Slot.Padding then
    Padding = Slot.Padding
  elseif Slot and Slot.GetPadding then
    Padding = Slot:GetPadding()
  elseif Widget.Slot and Widget.Slot.Padding then
    Padding = Widget.Slot.Padding
  end
  if Padding then
    PaddingLeft = Padding.Left or 0
    PaddingRight = Padding.Right or 0
  end
  return PaddingLeft, PaddingRight
end

function M:GetRealRewardWidgetByIndex(Index)
  return self["Item_" .. Index]
end

function M:GetRewardWidgetByIndex(Index)
  if Index == self.AllDays and self.Item then
    return self.Item
  end
  return self:GetRealRewardWidgetByIndex(Index)
end

function M:GetRewardIndexByWidget(TargetWidget)
  if not TargetWidget then
    return nil
  end
  if TargetWidget == self.Item then
    return self.AllDays
  end
  for Index = 1, self.AllDays or 0 do
    if self:GetRealRewardWidgetByIndex(Index) == TargetWidget then
      return Index
    end
  end
  return nil
end

function M:GetRewardMetricSampleWidget(FallbackWidget)
  local MiddleEndIndex = math.max(1, (self.AllDays or 0) - 1)
  for Index = 2, MiddleEndIndex do
    local RewardWidget = self:GetRealRewardWidgetByIndex(Index)
    if RewardWidget then
      return RewardWidget
    end
  end
  if FallbackWidget and FallbackWidget ~= self.Item and FallbackWidget ~= self.Item_HoldSpace then
    return FallbackWidget
  end
  for Index = 1, self.AllDays or 0 do
    local RewardWidget = self:GetRealRewardWidgetByIndex(Index)
    if RewardWidget and RewardWidget ~= self.Item_HoldSpace then
      return RewardWidget
    end
  end
  return nil
end

function M:RefreshRewardScrollEdgeToleranceCache(FallbackWidget)
  local SampleWidget = self:GetRewardMetricSampleWidget(FallbackWidget)
  local PaddingLeft, PaddingRight = GetWidgetPadding(SampleWidget)
  self.CachedRewardLeftTolerance = math.max(0, -(PaddingLeft or 0))
  self.CachedRewardRightTolerance = math.max(0, -(PaddingRight or 0))
end

function M:GetRewardScrollEdgeTolerance(FallbackWidget)
  if self.CachedRewardLeftTolerance == nil or nil == self.CachedRewardRightTolerance then
    self:RefreshRewardScrollEdgeToleranceCache(FallbackWidget)
  end
  return self.CachedRewardLeftTolerance or 0, self.CachedRewardRightTolerance or 0
end

function M:GetSampleRewardMetrics(FallbackWidget)
  local SampleWidget = self:GetRewardMetricSampleWidget(FallbackWidget)
  if (not SampleWidget or GetWidgetWidth(SampleWidget) <= 0) and FallbackWidget and GetWidgetWidth(FallbackWidget) > 0 then
    SampleWidget = FallbackWidget
  end
  if not SampleWidget then
    return 0, 0, 0
  end
  local SampleWidth = GetWidgetWidth(SampleWidget)
  local PaddingLeft, PaddingRight = GetWidgetPadding(SampleWidget)
  if SampleWidth > 0 then
    self.CachedRewardWidth = SampleWidth
    self.CachedRewardPaddingLeft = PaddingLeft
    self.CachedRewardPaddingRight = PaddingRight
  end
  return self.CachedRewardWidth or 0, self.CachedRewardPaddingLeft or 0, self.CachedRewardPaddingRight or 0
end

function M:GetRewardRectInScrollSpace(Index)
  if not self.ScrollBoxItem or not Index then
    return nil
  end
  local RewardWidget = self:GetRealRewardWidgetByIndex(Index)
  local RewardRect = RewardWidget and GetWidgetRectInTargetSpace(RewardWidget, self.ScrollBoxItem)
  if RewardRect then
    return RewardRect
  end
  local AnchorIndex, AnchorRect, MinDeltaIndex
  for CandidateIndex = 1, self.AllDays or 0 do
    local CandidateWidget = self:GetRealRewardWidgetByIndex(CandidateIndex)
    local CandidateRect = CandidateWidget and GetWidgetRectInTargetSpace(CandidateWidget, self.ScrollBoxItem)
    if CandidateRect then
      local DeltaIndex = math.abs(CandidateIndex - Index)
      if not MinDeltaIndex or MinDeltaIndex > DeltaIndex then
        MinDeltaIndex = DeltaIndex
        AnchorIndex = CandidateIndex
        AnchorRect = CandidateRect
      end
    end
  end
  if not AnchorRect or not AnchorIndex then
    return nil
  end
  local SampleWidth, PaddingLeft, PaddingRight = self:GetSampleRewardMetrics(self:GetRealRewardWidgetByIndex(AnchorIndex))
  local StepWidth = SampleWidth + PaddingLeft + PaddingRight
  if SampleWidth <= 0 or 0 == StepWidth then
    return nil
  end
  local DeltaIndex = Index - AnchorIndex
  local Left = AnchorRect.Left + DeltaIndex * StepWidth
  return {
    Left = Left,
    Top = AnchorRect.Top,
    Right = Left + SampleWidth,
    Bottom = AnchorRect.Top + AnchorRect.Height,
    Width = SampleWidth,
    Height = AnchorRect.Height
  }
end

function M:OnScrollBoxUserScrolled(CurrentOffset)
  self:RefreshMirrorBigRewardItem()
end

function M:OnScrollViewportWidthChanged(NewWidth)
  self.LastScrollViewportWidth = NewWidth
  self.CachedRewardWidth = nil
  self.CachedRewardPaddingLeft = nil
  self.CachedRewardPaddingRight = nil
  self.CachedRewardLeftTolerance = nil
  self.CachedRewardRightTolerance = nil
  self:RequestMirrorBigRewardRefresh()
end

function M:Initialize(Initializer)
  self.MirrorRefreshTicking = false
  self.MirrorStableFrameCount = 0
  self.LastMirrorDay = nil
  self.LastScrollOffset = nil
  self.CurrentMirrorDay = nil
  self.LastScrollViewportWidth = nil
end

function M:StartMirrorRefreshTick()
  self.MirrorRefreshTicking = true
  self.MirrorStableFrameCount = 0
  self.LastMirrorDay = nil
  self.LastScrollOffset = nil
end

function M:StopMirrorRefreshTick()
  self.MirrorRefreshTicking = false
  self.MirrorStableFrameCount = 0
end

function M:RefreshMirrorBigRewardItemNextFrame()
  if self.RemoveTimer then
    self:RemoveTimer("RefreshMirrorBigRewardItemNextFrame")
  end
  if self.AddTimer then
    self:AddTimer(0.05, self.RefreshMirrorBigRewardItem, false, 0, "RefreshMirrorBigRewardItemNextFrame")
  else
    self:RefreshMirrorBigRewardItem()
  end
end

function M:RequestMirrorBigRewardRefresh()
  self:RefreshMirrorBigRewardItem()
  self:StartMirrorRefreshTick()
end

function M:Tick(MyGeometry, InDeltaTime)
  if self.Overridden and self.Overridden.Tick then
    self.Overridden.Tick(self, MyGeometry, InDeltaTime)
  end
  if self.ScrollBoxItem and self.ScrollBoxItem.GetCachedGeometry then
    local ScrollGeometry = self.ScrollBoxItem:GetCachedGeometry()
    local ScrollSize = ScrollGeometry and UE4.USlateBlueprintLibrary.GetLocalSize(ScrollGeometry)
    local ScrollWidth = ScrollSize and ScrollSize.X or nil
    if ScrollWidth and ScrollWidth > 0 then
      if self.LastScrollViewportWidth == nil then
        self.LastScrollViewportWidth = ScrollWidth
      elseif math.abs(ScrollWidth - self.LastScrollViewportWidth) > 0.1 then
        self:OnScrollViewportWidthChanged(ScrollWidth)
      end
    end
  end
  if not self.MirrorRefreshTicking or not self.ScrollBoxItem then
    return
  end
  local CurrentOffset = self.ScrollBoxItem.GetScrollOffset and self.ScrollBoxItem:GetScrollOffset() or 0
  local CurrentMirrorDay = self:GetMirrorBigRewardSourceIndex()
  if not CurrentMirrorDay then
    self.MirrorStableFrameCount = 0
    self.LastScrollOffset = CurrentOffset
    self.LastMirrorDay = nil
    return
  end
  local IsOffsetStable = nil ~= self.LastScrollOffset and math.abs(CurrentOffset - self.LastScrollOffset) < 0.1
  local IsMirrorStable = nil ~= self.LastMirrorDay and self.LastMirrorDay == CurrentMirrorDay
  if IsOffsetStable and IsMirrorStable then
    self.MirrorStableFrameCount = self.MirrorStableFrameCount + 1
  else
    self.MirrorStableFrameCount = 0
  end
  self.LastScrollOffset = CurrentOffset
  self.LastMirrorDay = CurrentMirrorDay
  if self.MirrorStableFrameCount >= 10 then
    self:RefreshMirrorBigRewardItem()
    self:StopMirrorRefreshTick()
  end
end

function M:GetMirrorBigRewardSourceIndex()
  if not self.FixedBigRewardDays or 0 == #self.FixedBigRewardDays then
    return nil
  end
  local FallbackDay = self.FixedBigRewardDays[#self.FixedBigRewardDays]
  if not self.ScrollBoxItem then
    return FallbackDay
  end
  local ScrollGeometry = self.ScrollBoxItem:GetCachedGeometry()
  if not ScrollGeometry then
    return FallbackDay
  end
  local ScrollSize = UE4.USlateBlueprintLibrary.GetLocalSize(ScrollGeometry)
  if not ScrollSize then
    return FallbackDay
  end
  local _, RightTolerance = self:GetRewardScrollEdgeTolerance()
  local VisibleRight = ScrollSize.X - RightTolerance - 5
  for _, Day in ipairs(self.FixedBigRewardDays) do
    local RewardRect = self:GetRewardRectInScrollSpace(Day)
    if RewardRect and VisibleRight < RewardRect.Left then
      return Day
    end
  end
  return FallbackDay
end

function M:RefreshMirrorBigRewardItem()
  if not (self.Item and self.PageConfigData) or not self.ParentWidget then
    return
  end
  local MirrorDay = self:GetMirrorBigRewardSourceIndex()
  if not MirrorDay then
    return
  end
  if self.CurrentMirrorDay == MirrorDay then
    self.Item:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Item.CanReceiveReward = MirrorDay == self.AllDays
    return
  end
  self.CurrentMirrorDay = MirrorDay
  self.Item:SetVisibility(UIConst.VisibilityOp.Visible)
  if self.Item.InitReward then
    self.Item:InitReward(MirrorDay, {
      SourceDay = MirrorDay,
      ActivityId = self.ParentWidget:GetActivityId(),
      RewardId = self.PageConfigData.EventReward and self.PageConfigData.EventReward[MirrorDay],
      RewardState = self.RewardStates and self.RewardStates[MirrorDay],
      IsBigReward = true,
      CanReceiveReward = MirrorDay == self.AllDays
    }, self.ParentWidget)
  end
end

function M:GetRewardFocusTarget(Index)
  local RewardWidget = self:GetRewardWidgetByIndex(Index)
  if not RewardWidget then
    return nil
  end
  if RewardWidget.BP_GetDesiredFocusTarget then
    return RewardWidget:BP_GetDesiredFocusTarget()
  end
  return RewardWidget
end

function M:NavigateToRewardByDirection(CurrentIndex, NavigationDirection)
  local Delta = 0
  if NavigationDirection == EUINavigation.Left then
    Delta = -1
  elseif NavigationDirection == EUINavigation.Right then
    Delta = 1
  else
    return self:GetRewardFocusTarget(CurrentIndex)
  end
  local TargetIndex = CurrentIndex + Delta
  if TargetIndex < 1 then
    return self:GetRewardFocusTarget(CurrentIndex)
  end
  if TargetIndex > self.AllDays then
    return self:GetRewardFocusTarget(CurrentIndex)
  end
  local TargetRewardWidget = self:GetRewardWidgetByIndex(TargetIndex)
  if TargetRewardWidget and self.ScrollRewardWidgetIntoView then
    self:ScrollRewardWidgetIntoView(TargetRewardWidget, true)
  else
    self:RequestMirrorBigRewardRefresh()
  end
  return self:GetRewardFocusTarget(TargetIndex)
end

function M:GetRewardHorizontalWidgets(Index)
  local RewardWidget = self:GetRewardWidgetByIndex(Index)
  if not RewardWidget then
    return {}
  end
  local Widgets = {}
  if RewardWidget.Item01 and RewardWidget.Item01:IsVisible() then
    table.insert(Widgets, RewardWidget.Item01)
  end
  if RewardWidget.Item02 and RewardWidget.Item02:IsVisible() then
    table.insert(Widgets, RewardWidget.Item02)
  end
  if 0 == #Widgets then
    table.insert(Widgets, RewardWidget)
  end
  return Widgets
end

function M:RefreshLastRewardLayout()
  local RealLastRewardWidget = self:GetRealRewardWidgetByIndex(self.AllDays)
  if RealLastRewardWidget then
    RealLastRewardWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Item_HoldSpace then
    self.Item_HoldSpace:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitRewardInfo(PageConfigData, ParentWidget, RewardStates, BigRewardDayMap)
  self.AllDays = PageConfigData.LoginDuration or 0
  self.PageConfigData = PageConfigData
  self.ParentWidget = ParentWidget
  self.RewardStates = RewardStates or {}
  self.CurrentMirrorDay = nil
  self.BigRewardDayMap = BigRewardDayMap or {}
  self.FixedBigRewardDays = {}
  for Day in pairs(self.BigRewardDayMap) do
    table.insert(self.FixedBigRewardDays, Day)
  end
  table.sort(self.FixedBigRewardDays)
  self:RefreshRewardScrollEdgeToleranceCache()
  for Index = 1, self.AllDays do
    local RewardWidget = self:GetRealRewardWidgetByIndex(Index)
    if RewardWidget and RewardWidget.InitReward then
      RewardWidget:InitReward(Index, {
        ActivityId = ParentWidget and ParentWidget:GetActivityId() or PageConfigData.EventId,
        RewardId = PageConfigData.EventReward and PageConfigData.EventReward[Index],
        RewardState = RewardStates and RewardStates[Index],
        IsBigReward = BigRewardDayMap and nil ~= BigRewardDayMap[Index]
      }, ParentWidget)
      RewardWidget.OwnerList = self
    end
  end
  if self.Item then
    self.Item.OwnerList = self
  end
  if self.ScrollBoxItem and self.ScrollBoxItem.OnUserScrolled then
    self.ScrollBoxItem.OnUserScrolled:Clear()
    self.ScrollBoxItem.OnUserScrolled:Add(self, self.OnScrollBoxUserScrolled)
  end
  self:RefreshLastRewardLayout()
  self:UpdateNavigationRules()
  self:RefreshMirrorBigRewardItemNextFrame()
end

function M:RefreshRewardStates(PageConfigData, ParentWidget, RewardStates, BigRewardDayMap)
  self:InitRewardInfo(PageConfigData, ParentWidget, RewardStates, BigRewardDayMap)
end

function M:RefreshInputStyle(IsUseGamePad)
  for Index = 1, self.AllDays or 0 do
    local RewardWidget = self:GetRealRewardWidgetByIndex(Index)
    if RewardWidget and RewardWidget.RefreshInputStyle then
      RewardWidget:RefreshInputStyle(IsUseGamePad)
    end
  end
  if self.Item and self.Item.RefreshInputStyle then
    self.Item:RefreshInputStyle(IsUseGamePad)
  end
end

function M:RefreshItemStyle(RewardIndex, RewardState)
  local RewardWidget = self:GetRealRewardWidgetByIndex(RewardIndex)
  if RewardWidget and RewardWidget.RefreshRewardByState then
    RewardWidget:RefreshRewardByState(RewardState)
  end
  if RewardIndex == self.AllDays then
    self:RefreshLastRewardLayout()
  end
  self.RewardStates = self.RewardStates or {}
  self.RewardStates[RewardIndex] = RewardState
  if RewardIndex == self.CurrentMirrorDay and self.Item and self.Item.RefreshRewardByState then
    self.Item.CanReceiveReward = RewardIndex == self.AllDays
    self.Item:RefreshRewardByState(RewardState)
  end
  self:UpdateNavigationRules()
  self:RequestMirrorBigRewardRefresh()
end

function M:UpdateNavigationRules()
  if not self.ParentWidget then
    return
  end
  for Index = 1, self.AllDays do
    local HorizontalWidgets = self:GetRewardHorizontalWidgets(Index)
    for _, FocusTarget in ipairs(HorizontalWidgets) do
      FocusTarget:SetNavigationRuleCustom(EUINavigation.Left, function()
        return self:NavigateToRewardByDirection(Index, EUINavigation.Left)
      end)
      FocusTarget:SetNavigationRuleCustom(EUINavigation.Right, function()
        return self:NavigateToRewardByDirection(Index, EUINavigation.Right)
      end)
    end
  end
end

function M:ScrollRewardWidgetIntoView(RewardWidget, bUseRelativeLeftAdjust)
  if not RewardWidget or not self.ScrollBoxItem then
    return
  end
  if RewardWidget == self.Item then
    self:RequestMirrorBigRewardRefresh()
    return
  end
  local ScrollGeometry = self.ScrollBoxItem:GetCachedGeometry()
  if not ScrollGeometry then
    return
  end
  local ScrollSize = UE4.USlateBlueprintLibrary.GetLocalSize(ScrollGeometry)
  local ItemRect = GetWidgetRectInTargetSpace(RewardWidget, self.ScrollBoxItem)
  local TargetIndex = self:GetRewardIndexByWidget(RewardWidget)
  if not (ScrollSize and ItemRect) or not TargetIndex then
    return
  end
  local LeftTolerance, RightTolerance = self:GetRewardScrollEdgeTolerance(RewardWidget)
  local SafeLeft = -LeftTolerance
  local SafeRight = ScrollSize.X + RightTolerance
  if self.ScrollBoxItem.GetScrollOffset and self.ScrollBoxItem.SetScrollOffset and self.ScrollBoxItem.GetScrollOffsetOfEnd then
    local CurrentOffset = self.ScrollBoxItem:GetScrollOffset()
    local EndOffset = self.ScrollBoxItem:GetScrollOffsetOfEnd()
    local SampleWidth, PaddingLeft, PaddingRight = self:GetSampleRewardMetrics(RewardWidget)
    local StepWidth = SampleWidth + PaddingLeft + PaddingRight
    if StepWidth <= 0 then
      return
    end
    local TargetOffset
    if SafeLeft > ItemRect.Left then
      if bUseRelativeLeftAdjust then
        TargetOffset = CurrentOffset + (ItemRect.Left - SafeLeft)
      else
        TargetOffset = PaddingLeft + (TargetIndex - 1) * StepWidth
      end
    elseif SafeRight < ItemRect.Right then
      TargetOffset = CurrentOffset + (ItemRect.Right - SafeRight)
    end
    if nil ~= TargetOffset then
      self.ScrollBoxItem:SetScrollOffset(math.clamp(TargetOffset, 0, EndOffset))
    end
  end
  self:RequestMirrorBigRewardRefresh()
end

function M:GetPreferredScrollIndex(RewardStates)
  local LastCompletedIndex
  for Index = 1, self.AllDays do
    local RewardState = RewardStates and RewardStates[Index]
    if RewardState == EnumPlayerSignRewardState.SignedNotRecv then
      return Index
    end
    if RewardState == EnumPlayerSignRewardState.Completed then
      LastCompletedIndex = Index
    end
  end
  return LastCompletedIndex or 1
end

function M:ScrollRewardIndexToLeftEdge(TargetIndex)
  if not self.ScrollBoxItem or not TargetIndex then
    return
  end
  if TargetIndex == self.AllDays then
    if self.ScrollBoxItem.ScrollToEnd then
      self.ScrollBoxItem:ScrollToEnd()
    end
    self:RequestMirrorBigRewardRefresh()
    return
  end
  local RewardWidget = self:GetRealRewardWidgetByIndex(TargetIndex)
  if not RewardWidget then
    return
  end
  if self.ScrollBoxItem.ScrollWidgetIntoView then
    local LeftTolerance = self:GetRewardScrollEdgeTolerance(RewardWidget)
    self.ScrollBoxItem:ScrollWidgetIntoView(RewardWidget, true, UE4.EDescendantScrollDestination.TopOrLeft, -LeftTolerance)
  end
  self:RequestMirrorBigRewardRefresh()
end

function M:ScrollToProgressReward(RewardStates)
  self:ScrollRewardIndexToLeftEdge(self:GetPreferredScrollIndex(RewardStates))
end

function M:BP_GetDesiredFocusTarget()
  local NeedFocusIndex, LastCompletedIndex
  for Index = 1, self.AllDays do
    local RewardWidget = self:GetRewardWidgetByIndex(Index)
    if RewardWidget and RewardWidget.GetRewardState and RewardWidget:GetRewardState() == EnumPlayerSignRewardState.SignedNotRecv then
      NeedFocusIndex = Index
      break
    end
    if RewardWidget and RewardWidget.GetRewardState and RewardWidget:GetRewardState() == EnumPlayerSignRewardState.Completed then
      LastCompletedIndex = Index
    end
  end
  if not NeedFocusIndex then
    for Index = 1, self.AllDays do
      local RewardWidget = self:GetRewardWidgetByIndex(Index)
      if RewardWidget and RewardWidget.GetRewardState and RewardWidget:GetRewardState() == EnumPlayerSignRewardState.NotSign then
        NeedFocusIndex = Index
        break
      end
    end
  end
  NeedFocusIndex = NeedFocusIndex or LastCompletedIndex or 1
  local NeedFocusRewardWidget = self:GetRewardWidgetByIndex(NeedFocusIndex)
  if NeedFocusRewardWidget and self.ScrollRewardWidgetIntoView then
    self:ScrollRewardWidgetIntoView(NeedFocusRewardWidget, false)
  end
  return self:GetRewardFocusTarget(NeedFocusIndex)
end

return M
