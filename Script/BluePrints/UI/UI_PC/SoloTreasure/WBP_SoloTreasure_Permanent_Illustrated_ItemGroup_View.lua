require("UnLua")
local M = {}
local ITEM_REFRESH_INTERVAL = 0.03
local STAGGER_REFRESH_TIMER_KEY = "IllustratedItemGroupStaggerRefresh"
local INITIAL_REFRESH_TIMER_KEY = "IllustratedItemGroupInitialRefresh"
local VIEWPORT_RETRY_TIMER_KEY = "IllustratedItemGroupViewportRetry"
local GEOMETRY_BOUNDS_TOLERANCE = 2
local MIN_ITEM_GROUP_OVERLAP_RATIO = 0.15
local MIN_ITEM_GROUP_OVERLAP_PX = 24
local SLOT_RELATIVE_BOUNDS_TOLERANCE = 2
local IS_ITEM_REFRESH_LOG_ENABLED = false
local IS_ITEM_GROUP_POOL_LOG_ENABLED = false
local AnimatedTreasureIdSet = {}
local SlotRelativeBoundsCache = {}
local bSlotRelativeBoundsCacheComplete = false

function M.ClearAnimatedTreasureCache()
  AnimatedTreasureIdSet = {}
end

function M:IsTreasureAnimated(TreasureId)
  return true == AnimatedTreasureIdSet[TreasureId]
end

function M:MarkTreasureAnimated(TreasureId)
  AnimatedTreasureIdSet[TreasureId] = true
end

local function GetWidgetGeometry(Widget)
  if nil == Widget then
    return nil, nil
  end
  local Geometry = Widget:GetCachedGeometry()
  local LocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)
  if LocalSize.X <= 0 or LocalSize.Y <= 0 then
    Geometry = Widget:GetPaintSpaceGeometry()
    LocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)
  end
  if LocalSize.X <= 0 or LocalSize.Y <= 0 then
    return nil, nil
  end
  return Geometry, LocalSize
end

local function GetWidgetAbsoluteBounds(Widget)
  local Geometry, LocalSize = GetWidgetGeometry(Widget)
  if nil == Geometry then
    return nil, nil
  end
  local TopLeft = UE4.USlateBlueprintLibrary.LocalToAbsolute(Geometry, UE4.FVector2D(0, 0))
  local BottomRight = UE4.USlateBlueprintLibrary.LocalToAbsolute(Geometry, UE4.FVector2D(LocalSize.X, LocalSize.Y))
  return TopLeft, BottomRight
end

local function HasScrollRangeOverlap(LeftA, RightA, LeftB, RightB, Tolerance)
  Tolerance = Tolerance or GEOMETRY_BOUNDS_TOLERANCE
  return not (RightA < LeftB - Tolerance) and not (LeftA > RightB + Tolerance)
end

local function FormatBounds(TopLeft, BottomRight)
  if nil == TopLeft or nil == BottomRight then
    return "nil"
  end
  return string.format("(%d,%d)-(%d,%d)", math.floor(TopLeft.X), math.floor(TopLeft.Y), math.floor(BottomRight.X), math.floor(BottomRight.Y))
end

local function GetTreasureNameText(TreasureId)
  local TreasureData = TreasureId and DataMgr.ExtractionTreasure[TreasureId]
  if nil == TreasureData or nil == TreasureData.Name then
    return "nil", "nil"
  end
  return tostring(TreasureData.Name), GText(TreasureData.Name)
end

local function PrintItemGroupPoolStateLog(OwnerSelf, Reason, bInEntryPoolBefore, bInEntryPoolAfter)
  if not IS_ITEM_GROUP_POOL_LOG_ENABLED then
    return
  end
  local GroupTopLeft, GroupBottomRight = GetWidgetAbsoluteBounds(OwnerSelf)
  DebugPrint(ErrorTag, "cjh @ SetItemGroupInEntryPool")
  DebugPrint(ErrorTag, string.format("cjh  Reason=%s BeforeInPool=%s AfterInPool=%s", tostring(Reason), tostring(bInEntryPoolBefore), tostring(bInEntryPoolAfter)))
  DebugPrint(ErrorTag, string.format("cjh  GroupIndex=%s GroupName=%s StaggerRefreshing=%s", tostring(OwnerSelf and OwnerSelf.GroupIndex), OwnerSelf and OwnerSelf:GetName() or "nil", tostring(OwnerSelf and OwnerSelf.bStaggerRefreshing)))
  DebugPrint(ErrorTag, string.format("cjh  GroupBounds=%s", FormatBounds(GroupTopLeft, GroupBottomRight)))
end

local function PrintItemRefreshLog(OwnerSelf, SlotIndex, TreasureId, bPlayAnim, RefreshReason, bInViewportBeforeRefresh)
  if not IS_ITEM_REFRESH_LOG_ENABLED then
    return
  end
  local Item = OwnerSelf and OwnerSelf:GetSlotItem(SlotIndex)
  local ClipWidget = OwnerSelf and OwnerSelf:GetContentClipWidget()
  local GroupTopLeft, GroupBottomRight = GetWidgetAbsoluteBounds(OwnerSelf)
  local ItemTopLeft, ItemBottomRight = GetWidgetAbsoluteBounds(Item)
  local ClipTopLeft, ClipBottomRight = GetWidgetAbsoluteBounds(ClipWidget)
  local TreasureNameKey, TreasureDisplayName = GetTreasureNameText(TreasureId)
  DebugPrint("cjh @ RefreshSingleItem")
  DebugPrint(string.format("cjh  Reason=%s InViewport=%s PlayAnim=%s RefreshedBefore=%s AnimatedBefore=%s", tostring(RefreshReason), tostring(bInViewportBeforeRefresh), tostring(bPlayAnim), tostring(OwnerSelf and OwnerSelf.RefreshedSlotSet and OwnerSelf.RefreshedSlotSet[SlotIndex]), tostring(OwnerSelf and OwnerSelf:IsTreasureAnimated(TreasureId))))
  DebugPrint(string.format("cjh  GroupIndex=%s GroupName=%s ClipName=%s SlotIndex=%s ItemName=%s", tostring(OwnerSelf and OwnerSelf.GroupIndex), OwnerSelf and OwnerSelf:GetName() or "nil", ClipWidget and ClipWidget:GetName() or "nil", tostring(SlotIndex), Item and Item:GetName() or "nil"))
  DebugPrint(string.format("cjh  TreasureId=%s TreasureNameKey=%s TreasureName=%s", tostring(TreasureId), TreasureNameKey, TreasureDisplayName))
  DebugPrint(string.format("cjh  ItemBounds=%s", FormatBounds(ItemTopLeft, ItemBottomRight)))
  DebugPrint(string.format("cjh  GroupBounds=%s", FormatBounds(GroupTopLeft, GroupBottomRight)))
  DebugPrint(string.format("cjh  ClipBounds=%s", FormatBounds(ClipTopLeft, ClipBottomRight)))
end

local function HasBoundsOverlap(TopLeftA, BottomRightA, TopLeftB, BottomRightB, Tolerance)
  Tolerance = Tolerance or GEOMETRY_BOUNDS_TOLERANCE
  return not (BottomRightA.X < TopLeftB.X - Tolerance) and not (TopLeftA.X > BottomRightB.X + Tolerance) and not (BottomRightA.Y < TopLeftB.Y - Tolerance) and not (TopLeftA.Y > BottomRightB.Y + Tolerance)
end

local function GetBoundsOverlapSize(TopLeftA, BottomRightA, TopLeftB, BottomRightB)
  local OverlapLeft = math.max(TopLeftA.X, TopLeftB.X)
  local OverlapRight = math.min(BottomRightA.X, BottomRightB.X)
  local OverlapTop = math.max(TopLeftA.Y, TopLeftB.Y)
  local OverlapBottom = math.min(BottomRightA.Y, BottomRightB.Y)
  if OverlapLeft >= OverlapRight or OverlapTop >= OverlapBottom then
    return 0, 0
  end
  return OverlapRight - OverlapLeft, OverlapBottom - OverlapTop
end

local function HasMeaningfulBoundsOverlap(TopLeftA, BottomRightA, TopLeftB, BottomRightB, Tolerance)
  if not HasBoundsOverlap(TopLeftA, BottomRightA, TopLeftB, BottomRightB, Tolerance) then
    return false
  end
  local OverlapW, OverlapH = GetBoundsOverlapSize(TopLeftA, BottomRightA, TopLeftB, BottomRightB)
  local ItemW = BottomRightA.X - TopLeftA.X
  local ItemH = BottomRightA.Y - TopLeftA.Y
  local MinOverlapW = math.max(MIN_ITEM_GROUP_OVERLAP_PX, ItemW * MIN_ITEM_GROUP_OVERLAP_RATIO)
  local MinOverlapH = math.max(MIN_ITEM_GROUP_OVERLAP_PX, ItemH * MIN_ITEM_GROUP_OVERLAP_RATIO)
  return OverlapW >= MinOverlapW and OverlapH >= MinOverlapH
end

local function GetItemLocalBoundsInGroup(GroupWidget, ItemWidget)
  local GroupGeometry = GetWidgetGeometry(GroupWidget)
  local ItemTopLeft, ItemBottomRight = GetWidgetAbsoluteBounds(ItemWidget)
  if nil == GroupGeometry or nil == ItemTopLeft or nil == ItemBottomRight then
    return nil
  end
  local ItemLocalTopLeft = UE4.USlateBlueprintLibrary.AbsoluteToLocal(GroupGeometry, ItemTopLeft)
  local ItemLocalBottomRight = UE4.USlateBlueprintLibrary.AbsoluteToLocal(GroupGeometry, ItemBottomRight)
  return {
    Left = ItemLocalTopLeft.X,
    Right = ItemLocalBottomRight.X,
    Top = ItemLocalTopLeft.Y,
    Bottom = ItemLocalBottomRight.Y
  }
end

local function IsSlotLocalBoundsMatched(RecordBounds, CurBounds)
  if nil == RecordBounds or nil == CurBounds then
    return false
  end
  return math.abs(RecordBounds.Left - CurBounds.Left) <= SLOT_RELATIVE_BOUNDS_TOLERANCE and math.abs(RecordBounds.Right - CurBounds.Right) <= SLOT_RELATIVE_BOUNDS_TOLERANCE and math.abs(RecordBounds.Top - CurBounds.Top) <= SLOT_RELATIVE_BOUNDS_TOLERANCE and math.abs(RecordBounds.Bottom - CurBounds.Bottom) <= SLOT_RELATIVE_BOUNDS_TOLERANCE
end

local function IsItemBoundsConsistentWithGroup(GroupWidget, ItemWidget, SlotIndex)
  if nil == GroupWidget or nil == ItemWidget then
    return false
  end
  local RecordBounds = SlotRelativeBoundsCache and SlotRelativeBoundsCache[SlotIndex]
  if nil ~= RecordBounds then
    return IsSlotLocalBoundsMatched(RecordBounds, GetItemLocalBoundsInGroup(GroupWidget, ItemWidget))
  end
  local GroupTopLeft, GroupBottomRight = GetWidgetAbsoluteBounds(GroupWidget)
  local ItemTopLeft, ItemBottomRight = GetWidgetAbsoluteBounds(ItemWidget)
  if nil == GroupTopLeft or nil == GroupBottomRight or nil == ItemTopLeft or nil == ItemBottomRight then
    return false
  end
  return HasMeaningfulBoundsOverlap(ItemTopLeft, ItemBottomRight, GroupTopLeft, GroupBottomRight, GEOMETRY_BOUNDS_TOLERANCE)
end

local function IsWidgetFullyCulled(Widget, ClipWidget)
  if nil == Widget or nil == ClipWidget then
    return false
  end
  local WidgetTopLeft, WidgetBottomRight = GetWidgetAbsoluteBounds(Widget)
  if nil == WidgetTopLeft or nil == WidgetBottomRight then
    return true
  end
  local ClipTopLeft, ClipBottomRight = GetWidgetAbsoluteBounds(ClipWidget)
  if nil == ClipTopLeft or nil == ClipBottomRight then
    return true
  end
  return WidgetBottomRight.X < ClipTopLeft.X or WidgetTopLeft.X > ClipBottomRight.X or WidgetBottomRight.Y < ClipTopLeft.Y or WidgetTopLeft.Y > ClipBottomRight.Y
end

local function IsWidgetInClipViewport(Widget, ClipWidget)
  return not IsWidgetFullyCulled(Widget, ClipWidget)
end

function M:ReleaseItemGroupView()
  self:UnbindListScroll()
  self:StopStaggerRefresh()
  self.OwningList = nil
  self.OwningContent = nil
  self.CurTreasureIds = nil
  self.RefreshedSlotSet = nil
  self.GroupIndex = nil
  self.IsLastIndex = nil
end

function M:LogItemGroupInEntryPool(bInEntryPool, Reason)
  local bInEntryPoolAfter = true == bInEntryPool
  local bInEntryPoolBefore = not bInEntryPoolAfter
  PrintItemGroupPoolStateLog(self, Reason or "Unknown", bInEntryPoolBefore, bInEntryPoolAfter)
end

function M:GetContentClipWidget()
  local ListView = self:GetOwningListView()
  if nil == ListView then
    return nil
  end
  return ListView:GetParent()
end

function M:GetOwningListView()
  if self.OwningList == nil then
    self.OwningList = UE4.UUserListEntryLibrary.GetOwningListView(self)
  end
  return self.OwningList
end

function M:UpdateItemGroupLayoutWidth()
  if self.OwningContent == nil or nil == self.OwningContent.UpdateItemGroupWidth then
    return
  end
  local Geometry, LocalSize = GetWidgetGeometry(self)
  if nil == Geometry then
    return
  end
  self.OwningContent:UpdateItemGroupWidth(self.GroupIndex, LocalSize.X, self.IsLastIndex)
end

function M:GetScrollViewportBounds()
  if self.OwningContent == nil then
    return nil, nil
  end
  local ViewportWidth = self.OwningContent.GetTreasureScrollViewportWidth and self.OwningContent:GetTreasureScrollViewportWidth() or 0
  if ViewportWidth <= 0 then
    return nil, nil
  end
  local ScrollOffset = self.OwningContent.GetTreasureScrollOffset and self.OwningContent:GetTreasureScrollOffset() or 0
  return ScrollOffset, ScrollOffset + ViewportWidth
end

function M:GetItemGroupScrollBounds()
  self:UpdateItemGroupLayoutWidth()
  if self.OwningContent == nil or nil == self.OwningContent.GetItemGroupScrollBounds then
    return nil, nil
  end
  return self.OwningContent:GetItemGroupScrollBounds(self.GroupIndex)
end

function M:GetSlotScrollBounds(SlotIndex)
  local GroupScrollLeft, GroupScrollRight = self:GetItemGroupScrollBounds()
  if nil == GroupScrollLeft then
    return nil, nil
  end
  local RecordBounds = SlotRelativeBoundsCache and SlotRelativeBoundsCache[SlotIndex]
  if nil ~= RecordBounds then
    return GroupScrollLeft + RecordBounds.Left, GroupScrollLeft + RecordBounds.Right
  end
  local Item = self:GetSlotItem(SlotIndex)
  if nil == Item then
    return nil, nil
  end
  if not IsItemBoundsConsistentWithGroup(self, Item, SlotIndex) then
    return nil, nil
  end
  local ItemLocalBounds = GetItemLocalBoundsInGroup(self, Item)
  if nil == ItemLocalBounds then
    return nil, nil
  end
  local ItemLeft = GroupScrollLeft + ItemLocalBounds.Left
  local ItemRight = GroupScrollLeft + ItemLocalBounds.Right
  return ItemLeft, ItemRight
end

function M:EnsureListScrollBound()
end

function M:UnbindListScroll()
  self.bListScrollBound = false
end

function M:StopStaggerRefresh()
  self:RemoveTimer(STAGGER_REFRESH_TIMER_KEY)
  self:RemoveTimer(INITIAL_REFRESH_TIMER_KEY)
  self:RemoveTimer(VIEWPORT_RETRY_TIMER_KEY)
  self.bStaggerRefreshing = false
  self.PendingRefreshSlots = nil
  self.StaggerRefreshIndex = 1
end

function M:GetSlotItem(SlotIndex)
  return self[string.format("Item_%d", SlotIndex)]
end

function M:IsSlotWidgetGeometryReady(SlotIndex)
  local Item = self:GetSlotItem(SlotIndex)
  if nil == Item then
    return false
  end
  local Geometry = GetWidgetGeometry(Item)
  return nil ~= Geometry
end

function M:HasAnySlotWidgetGeometryReady()
  for SlotIndex = 1, self.GROUP_SLOT_COUNT do
    local TreasureId = self.CurTreasureIds and self.CurTreasureIds[SlotIndex]
    if nil ~= TreasureId and self:IsSlotWidgetGeometryReady(SlotIndex) then
      return true
    end
  end
  return false
end

function M:HasAnyUnrefreshedSlotWithInconsistentGeometry()
  if bSlotRelativeBoundsCacheComplete then
    return false
  end
  local TreasureIds = self.CurTreasureIds
  if nil == TreasureIds then
    return false
  end
  for SlotIndex = 1, self.GROUP_SLOT_COUNT do
    if nil ~= TreasureIds[SlotIndex] and not self.RefreshedSlotSet[SlotIndex] then
      local Item = self:GetSlotItem(SlotIndex)
      if nil ~= Item and not IsItemBoundsConsistentWithGroup(self, Item, SlotIndex) then
        return true
      end
    end
  end
  return false
end

function M:IsItemGroupInClipViewport()
  local GroupScrollLeft, GroupScrollRight = self:GetItemGroupScrollBounds()
  local ViewportLeft, ViewportRight = self:GetScrollViewportBounds()
  if nil ~= GroupScrollLeft and nil ~= ViewportLeft then
    return HasScrollRangeOverlap(GroupScrollLeft, GroupScrollRight, ViewportLeft, ViewportRight)
  end
  local ClipWidget = self:GetContentClipWidget()
  if nil == ClipWidget or not self:IsItemGroupGeometryReady() then
    return false
  end
  return IsWidgetInClipViewport(self, ClipWidget)
end

function M:ShouldRetryViewportRefresh()
  if not self:HasUnrefreshedSlots() or (self.ViewportRetryCount or 0) >= 5 then
    return false
  end
  if self:IsItemGroupGeometryReady() then
    if not self:IsItemGroupInClipViewport() then
      return false
    end
    return not self:HasAnySlotWidgetGeometryReady() or self:HasAnyUnrefreshedSlotWithInconsistentGeometry()
  end
  return 1 == (self.GroupIndex or 1)
end

function M:IsSlotInViewport(SlotIndex)
  local SlotScrollLeft, SlotScrollRight = self:GetSlotScrollBounds(SlotIndex)
  local ViewportLeft, ViewportRight = self:GetScrollViewportBounds()
  if nil ~= SlotScrollLeft and nil ~= ViewportLeft then
    return HasScrollRangeOverlap(SlotScrollLeft, SlotScrollRight, ViewportLeft, ViewportRight)
  end
  local ClipWidget = self:GetContentClipWidget()
  if nil == ClipWidget or not self:IsItemGroupGeometryReady() then
    return false
  end
  if not self:IsItemGroupInClipViewport() then
    return false
  end
  local Item = self:GetSlotItem(SlotIndex)
  if nil == Item or not IsItemBoundsConsistentWithGroup(self, Item, SlotIndex) then
    return false
  end
  return IsWidgetInClipViewport(Item, ClipWidget)
end

function M:TryRecordFirstItemGroupSlotRelativeBounds()
  if bSlotRelativeBoundsCacheComplete or 1 ~= (self.GroupIndex or 0) then
    return
  end
  local TreasureIds = self.CurTreasureIds
  if nil == TreasureIds or nil == self.RefreshedSlotSet then
    return
  end
  for SlotIndex = 1, self.GROUP_SLOT_COUNT do
    if nil == TreasureIds[SlotIndex] or not self.RefreshedSlotSet[SlotIndex] then
      return
    end
  end
  local RecordedBounds = {}
  for SlotIndex = 1, self.GROUP_SLOT_COUNT do
    local Item = self:GetSlotItem(SlotIndex)
    if nil == Item or not IsItemBoundsConsistentWithGroup(self, Item, SlotIndex) then
      return
    end
    local ItemLocalBounds = GetItemLocalBoundsInGroup(self, Item)
    if nil == ItemLocalBounds then
      return
    end
    RecordedBounds[SlotIndex] = ItemLocalBounds
  end
  SlotRelativeBoundsCache = RecordedBounds
  bSlotRelativeBoundsCacheComplete = true
end

function M:HasUnrefreshedSlots()
  local TreasureIds = self.CurTreasureIds
  if nil == TreasureIds then
    return false
  end
  for SlotIndex = 1, self.GROUP_SLOT_COUNT do
    if nil ~= TreasureIds[SlotIndex] and not self.RefreshedSlotSet[SlotIndex] then
      return true
    end
  end
  return false
end

function M:IsItemGroupGeometryReady()
  local Geometry = self:GetCachedGeometry()
  local LocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)
  local bReady = LocalSize.X > 0 and LocalSize.Y > 0
  if bReady then
    self:UpdateItemGroupLayoutWidth()
  end
  return bReady
end

function M:CollectPendingViewportSlots()
  local PendingSlots = {}
  local TreasureIds = self.CurTreasureIds
  if nil == TreasureIds then
    return PendingSlots
  end
  for SlotIndex = 1, self.GROUP_SLOT_COUNT do
    local TreasureId = TreasureIds[SlotIndex]
    if nil ~= TreasureId and not self.RefreshedSlotSet[SlotIndex] and not self:IsTreasureAnimated(TreasureId) and self:IsSlotInViewport(SlotIndex) then
      table.insert(PendingSlots, SlotIndex)
    end
  end
  return PendingSlots
end

function M:RefreshSingleItem(SlotIndex, bPlayAnim, RefreshReason)
  local Item = self[string.format("Item_%d", SlotIndex)]
  local TreasureId = self.CurTreasureIds and self.CurTreasureIds[SlotIndex]
  if nil == Item or nil == TreasureId then
    return
  end
  local ItemInfo = self:BuildItemInfo(TreasureId, SlotIndex)
  local bInViewportBeforeRefresh = self:IsSlotInViewport(SlotIndex)
  PrintItemRefreshLog(self, SlotIndex, TreasureId, bPlayAnim, RefreshReason or "Unknown", bInViewportBeforeRefresh)
  Item:SetRenderOpacity(1)
  Item:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  Item:RefreshItem(ItemInfo, bPlayAnim)
  self:MarkTreasureAnimated(TreasureId)
  self.RefreshedSlotSet[SlotIndex] = true
  self:TryRecordFirstItemGroupSlotRelativeBounds()
end

function M:TryStaggerRefreshViewportItems()
  if self.bStaggerRefreshing then
    return
  end
  if self:IsItemGroupGeometryReady() and not self:IsItemGroupInClipViewport() then
    return
  end
  self.PendingRefreshSlots = self:CollectPendingViewportSlots()
  if #self.PendingRefreshSlots <= 0 then
    if self:ShouldRetryViewportRefresh() then
      self.ViewportRetryCount = (self.ViewportRetryCount or 0) + 1
      self:AddTimer(0.05, function()
        self:TryStaggerRefreshViewportItems()
      end, false, 0, VIEWPORT_RETRY_TIMER_KEY, true)
    end
    return
  end
  self.ViewportRetryCount = 0
  self.bStaggerRefreshing = true
  self.StaggerRefreshIndex = 1
  self:AddTimer(ITEM_REFRESH_INTERVAL, function()
    local SlotIndex = self.PendingRefreshSlots[self.StaggerRefreshIndex]
    if nil == SlotIndex then
      self:StopStaggerRefresh()
      self:TryStaggerRefreshViewportItems()
      return
    end
    if self:IsSlotInViewport(SlotIndex) then
      self:RefreshSingleItem(SlotIndex, true, "StaggerViewport")
    end
    self.StaggerRefreshIndex = self.StaggerRefreshIndex + 1
  end, true, 0, STAGGER_REFRESH_TIMER_KEY, true)
end

function M:SetSpacerLastVisibility(IsShow)
  if self.Spacer_Last == nil then
    return
  end
  if IsShow then
    self.Spacer_Last:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    self.Spacer_Last:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:SetSpacerFirstVisibility(IsShow)
  if self.Spacer_First == nil then
    return
  end
  if IsShow then
    self.Spacer_First:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    self.Spacer_First:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:RefreshItemGroupView(TreasureIds)
  self:StopStaggerRefresh()
  self.CurTreasureIds = TreasureIds
  self.RefreshedSlotSet = {}
  self.ViewportRetryCount = 0
  for SlotIndex = 1, self.GROUP_SLOT_COUNT do
    local Item = self[string.format("Item_%d", SlotIndex)]
    local TreasureId = TreasureIds and TreasureIds[SlotIndex]
    if nil ~= Item then
      if nil ~= TreasureId and self:IsTreasureAnimated(TreasureId) then
        self:RefreshSingleItem(SlotIndex, false, "AlreadyAnimatedOnGroupRefresh")
      else
        if Item.StopAllAnimes then
          Item:StopAllAnimes()
        end
        Item:SetRenderOpacity(0)
        if nil ~= TreasureId then
          Item:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        else
          Item:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
      end
    end
  end
  self:AddTimer(0.05, function()
    self:TryStaggerRefreshViewportItems()
  end, false, 0, INITIAL_REFRESH_TIMER_KEY, true)
end

return M
