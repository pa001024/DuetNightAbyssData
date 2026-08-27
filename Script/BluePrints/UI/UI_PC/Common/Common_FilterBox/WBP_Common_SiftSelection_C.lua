require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local ROW_Y_TOLERANCE = 5
local CROSS_SIFT_FOCUS_DELAY_KEY = "CommonSiftDeferredNextWBoxFocus"
local CROSS_SIFT_FOCUS_RETRY_DELAY_KEY = "CommonSiftDeferredNextWBoxFocusRetry"
local CROSS_SIFT_FOCUS_CURSOR_REFRESH_DELAY_KEY = "CommonSiftDeferredNextWBoxFocusCursorRefresh"
local CROSS_SIFT_FOCUS_DELAY_FRAMES = 2
local CROSS_SIFT_FOCUS_CURSOR_REFRESH_DELAY_FRAMES = 2
local math_abs = math.abs
local math_min = math.min
local table_sort = table.sort

local function BuildVisualRows(WrapBox)
  if not WrapBox or not WrapBox.GetChildrenCount then
    return {}
  end
  local Cells = {}
  local ChildCount = WrapBox:GetChildrenCount()
  for ChildIndex = 0, ChildCount - 1 do
    local Widget = WrapBox:GetChildAt(ChildIndex)
    if Widget and Widget.GetCachedGeometry then
      local Geometry = Widget:GetCachedGeometry()
      local LocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)
      if LocalSize.X > 0 and LocalSize.Y > 0 then
        local Position = UE4.USlateBlueprintLibrary.LocalToAbsolute(Geometry, UE4.FVector2D(0, 0))
        Cells[#Cells + 1] = {
          Widget = Widget,
          X = Position.X,
          Y = Position.Y,
          ChildIndex = ChildIndex
        }
      end
    end
  end
  table_sort(Cells, function(Left, Right)
    if Left.Y == Right.Y then
      if Left.X == Right.X then
        return Left.ChildIndex < Right.ChildIndex
      end
      return Left.X < Right.X
    end
    return Left.Y < Right.Y
  end)
  local Rows = {}
  for _, Cell in ipairs(Cells) do
    local Row = Rows[#Rows]
    if not Row or math_abs(Cell.Y - Row.Y) > ROW_Y_TOLERANCE then
      Row = {
        Y = Cell.Y,
        Cells = {}
      }
      Rows[#Rows + 1] = Row
    end
    Row.Cells[#Row.Cells + 1] = Cell
  end
  for _, Row in ipairs(Rows) do
    table_sort(Row.Cells, function(Left, Right)
      if Left.X == Right.X then
        return Left.ChildIndex < Right.ChildIndex
      end
      return Left.X < Right.X
    end)
  end
  return Rows
end

local function FindVisualPosition(Rows, Widget)
  for RowIndex, Row in ipairs(Rows) do
    for ColumnIndex, Cell in ipairs(Row.Cells) do
      if Cell.Widget == Widget then
        return RowIndex, ColumnIndex
      end
    end
  end
  return nil, nil
end

local function GetVisualNavigationContext(Widget)
  local ParentWBox = Widget:GetParent()
  if not ParentWBox then
    return nil, nil, nil
  end
  local Rows = BuildVisualRows(ParentWBox)
  local RowIndex, ColumnIndex = FindVisualPosition(Rows, Widget)
  return Rows, RowIndex, ColumnIndex
end

local function GetRowTarget(Row, ColumnIndex)
  if not (Row and ColumnIndex) or 0 == #Row.Cells then
    return nil
  end
  return Row.Cells[math_min(ColumnIndex, #Row.Cells)].Widget
end

local function GetFirstVisualRow(WrapBox)
  local Rows = BuildVisualRows(WrapBox)
  local FirstRow = Rows[1]
  if not (FirstRow and FirstRow.Cells[1]) or 0 ~= FirstRow.Cells[1].ChildIndex then
    return nil
  end
  return FirstRow
end

local function GetLastVisualRow(WrapBox)
  if not WrapBox or not WrapBox.GetChildrenCount then
    return nil
  end
  local ChildCount = WrapBox:GetChildrenCount()
  local Rows = BuildVisualRows(WrapBox)
  local LastRow = Rows[#Rows]
  if not LastRow then
    return nil
  end
  for _, Cell in ipairs(LastRow.Cells) do
    if Cell.ChildIndex == ChildCount - 1 then
      return LastRow
    end
  end
  return nil
end

local function IsWidgetInScrollView(Widget, ScrollView)
  if not (Widget and ScrollView and Widget.GetCachedGeometry) or not ScrollView.GetCachedGeometry then
    return false
  end
  local WidgetGeometry = Widget:GetCachedGeometry()
  local ScrollViewGeometry = ScrollView:GetCachedGeometry()
  local WidgetSize = UE4.USlateBlueprintLibrary.GetLocalSize(WidgetGeometry)
  local ScrollViewSize = UE4.USlateBlueprintLibrary.GetLocalSize(ScrollViewGeometry)
  if WidgetSize.X <= 0 or WidgetSize.Y <= 0 or ScrollViewSize.X <= 0 or ScrollViewSize.Y <= 0 then
    return false
  end
  local WidgetTopLeft = UE4.USlateBlueprintLibrary.LocalToAbsolute(WidgetGeometry, UE4.FVector2D(0, 0))
  local WidgetBottomRight = UE4.USlateBlueprintLibrary.LocalToAbsolute(WidgetGeometry, WidgetSize)
  local ScrollViewTopLeft = UE4.USlateBlueprintLibrary.LocalToAbsolute(ScrollViewGeometry, UE4.FVector2D(0, 0))
  local ScrollViewBottomRight = UE4.USlateBlueprintLibrary.LocalToAbsolute(ScrollViewGeometry, ScrollViewSize)
  return WidgetTopLeft.Y >= ScrollViewTopLeft.Y and WidgetBottomRight.Y <= ScrollViewBottomRight.Y
end

local function GetListRewardTarget(SiftItem)
  if not SiftItem or not SiftItem.ListReward then
    return nil
  end
  local Content = SiftItem.CurContent or SiftItem.ListReward:GetItemAt(0)
  if Content and Content.UI then
    return Content.UI
  end
  return SiftItem.ListReward
end

function M:Init(OwnerItemUI, index, name, iconPath)
  self.OwnerItemUI = OwnerItemUI
  self.Index = index
  self.Name = name
  self.Text_Selection:SetText(GText(name))
  self:SetImage(iconPath)
  self:RefreshBaseInfo()
  self:InitListenEvent()
end

function M:Construct()
  self.CheckBox_Selection.Btn_Click.OnClicked:Add(self, self.OnItemSelectionChanged)
end

function M:Destruct()
  self:InvalidateDeferredCrossSiftFocus()
  self.CheckBox_Selection.Btn_Click.OnClicked:Remove(self, self.OnItemSelectionChanged)
end

function M:OnItemSelectionChanged()
  local CheckState = self.CheckBox_Selection:IsChecked()
  self.OwnerItemUI:OnSelectionItemChanged(CheckState, self)
  if CheckState then
    self:PlayAnimation(self.Click)
  else
    self:PlayAnimation(self.Normal)
  end
  return CheckState
end

function M:SetImage(iconPath)
  if not iconPath then
    return
  end
  self.Icon:SetVisibility(UIConst.VisibilityOp.Visible)
  local IconObject = LoadObject(iconPath)
  self.Icon:SetBrushResourceObject(IconObject)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self.CheckBox_Selection.Btn_Click:SetFocus()
  self.CheckBox_Selection:PlayAnimation(self.CheckBox_Selection.Normal)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self.bSkipNextFocusScrollIntoView then
    self.bSkipNextFocusScrollIntoView = nil
    return
  end
  if self.CurrentInputDevice == ECommonInputType.Gamepad then
    self.OwnerItemUI.Owner.List_Selection:ScrollWidgetIntoView(self, true, UE4.EDescendantScrollDestination.IntoView)
  end
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshBaseInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
  else
    self.CheckBox_Selection.Group_BG:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:InitNavigationRules()
  end
  self.CurrentInputDevice = CurInputDevice
end

function M:InitNavigationRules()
  self:SetSelectionNavigationRules(self)
  self:SetSelectionNavigationRules(self.CheckBox_Selection)
  self:SetSelectionNavigationRules(self.CheckBox_Selection and self.CheckBox_Selection.Btn_Click)
end

function M:SetSelectionNavigationRules(Widget)
  if not Widget then
    return
  end
  Widget:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    self.SetWBoxLeftTarget
  })
  Widget:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    self.SetWBoxRightTarget
  })
  Widget:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    self.SetWBoxUpTarget
  })
  Widget:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    self.SetWBoxDownTarget
  })
end

function M:InvalidateDeferredCrossSiftFocus()
  self.DeferredCrossSiftFocusRequestId = (self.DeferredCrossSiftFocusRequestId or 0) + 1
  return self.DeferredCrossSiftFocusRequestId
end

function M:QueueDeferredCrossSiftCursorRefresh(Target, RequestId)
  local SiftDialog = self.OwnerItemUI and self.OwnerItemUI.Owner
  if not SiftDialog or not SiftDialog.AddDelayFrameFunc then
    return
  end
  SiftDialog:AddDelayFrameFunc(function()
    if not IsValid(self) or self.DeferredCrossSiftFocusRequestId ~= RequestId then
      return
    end
    if not (IsValid(SiftDialog) and IsValid(Target)) or not IsValid(SiftDialog.GameInputModeSubsystem) then
      return
    end
    Target.bSkipNextFocusScrollIntoView = nil
    if SiftDialog.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad then
      return
    end
    if Target:HasAnyUserFocus() or Target:HasFocusedDescendants() then
      SiftDialog.GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
    end
  end, CROSS_SIFT_FOCUS_CURSOR_REFRESH_DELAY_FRAMES, CROSS_SIFT_FOCUS_CURSOR_REFRESH_DELAY_KEY)
end

function M:QueueDeferredAdjacentWBoxFocus(AdjacentWBox, ColumnIndex, RequestId, bIsRetry, bNavigateUp)
  local SiftDialog = self.OwnerItemUI and self.OwnerItemUI.Owner
  if not (SiftDialog and SiftDialog.List_Selection) or not SiftDialog.AddDelayFrameFunc then
    return
  end
  if not (IsValid(SiftDialog) and IsValid(SiftDialog.List_Selection)) or not IsValid(AdjacentWBox) then
    return
  end
  if SiftDialog.IsBeingRemoveState and SiftDialog:IsBeingRemoveState() then
    return
  end
  if not AdjacentWBox.GetChildrenCount or AdjacentWBox:GetChildrenCount() <= 0 then
    return
  end
  local ListSelection = SiftDialog.List_Selection
  local DelayKey = bIsRetry and CROSS_SIFT_FOCUS_RETRY_DELAY_KEY or CROSS_SIFT_FOCUS_DELAY_KEY
  local ScrollDestination = bNavigateUp and UE4.EDescendantScrollDestination.BottomOrRight or UE4.EDescendantScrollDestination.TopOrLeft
  ListSelection:ScrollWidgetIntoView(AdjacentWBox, false, ScrollDestination)
  SiftDialog:AddDelayFrameFunc(function()
    if not IsValid(self) or self.DeferredCrossSiftFocusRequestId ~= RequestId then
      return
    end
    if not (IsValid(SiftDialog) and IsValid(ListSelection)) or not IsValid(AdjacentWBox) then
      return
    end
    if not IsValid(SiftDialog.GameInputModeSubsystem) then
      return
    end
    if SiftDialog.IsBeingRemoveState and SiftDialog:IsBeingRemoveState() then
      return
    end
    if SiftDialog.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad then
      return
    end
    if not self:HasAnyUserFocus() and not self:HasFocusedDescendants() then
      return
    end
    if not self.OwnerItemUI or not IsValid(self.OwnerItemUI) then
      return
    end
    local CurrentAdjacentWBox = bNavigateUp and self.OwnerItemUI:GetPrevWrapBox() or self.OwnerItemUI:GetNextWrapBox()
    if CurrentAdjacentWBox ~= AdjacentWBox then
      return
    end
    if not AdjacentWBox.GetChildrenCount or AdjacentWBox:GetChildrenCount() <= 0 then
      return
    end
    local BoundaryRow = bNavigateUp and GetLastVisualRow(AdjacentWBox) or GetFirstVisualRow(AdjacentWBox)
    local Target = GetRowTarget(BoundaryRow, ColumnIndex)
    if Target and IsValid(Target) and IsWidgetInScrollView(Target, ListSelection) then
      Target.bSkipNextFocusScrollIntoView = true
      if SiftDialog.GameInputModeSubsystem:SetTargetUIFocusWidget(Target) then
        self:QueueDeferredCrossSiftCursorRefresh(Target, RequestId)
      else
        Target.bSkipNextFocusScrollIntoView = nil
        if not bIsRetry then
          self:QueueDeferredAdjacentWBoxFocus(AdjacentWBox, ColumnIndex, RequestId, true, bNavigateUp)
        end
      end
    elseif not bIsRetry then
      self:QueueDeferredAdjacentWBoxFocus(AdjacentWBox, ColumnIndex, RequestId, true, bNavigateUp)
    end
  end, CROSS_SIFT_FOCUS_DELAY_FRAMES, DelayKey)
end

function M:GetHorizontalNavigationTarget(ColumnOffset)
  local Rows, RowIndex, ColumnIndex = GetVisualNavigationContext(self)
  if not RowIndex or not ColumnIndex then
    return nil
  end
  local TargetCell = Rows[RowIndex].Cells[ColumnIndex + ColumnOffset]
  return TargetCell and TargetCell.Widget or nil
end

function M:SetWBoxLeftTarget()
  self:InvalidateDeferredCrossSiftFocus()
  return self:GetHorizontalNavigationTarget(-1)
end

function M:SetWBoxRightTarget()
  self:InvalidateDeferredCrossSiftFocus()
  return self:GetHorizontalNavigationTarget(1)
end

function M:SetWBoxDownTarget()
  local RequestId = self:InvalidateDeferredCrossSiftFocus()
  local Rows, RowIndex, ColumnIndex = GetVisualNavigationContext(self)
  if not RowIndex or not ColumnIndex then
    return nil
  end
  if Rows[RowIndex + 1] then
    return GetRowTarget(Rows[RowIndex + 1], ColumnIndex)
  end
  if not self.OwnerItemUI or not self.OwnerItemUI.GetNextWrapBox then
    return nil
  end
  local NextWBox = self.OwnerItemUI:GetNextWrapBox()
  if not NextWBox then
    return nil
  end
  if NextWBox.GetNumItems then
    return NextWBox
  end
  local SiftDialog = self.OwnerItemUI.Owner
  local Target = GetRowTarget(GetFirstVisualRow(NextWBox), ColumnIndex)
  if Target and (not (SiftDialog and SiftDialog.List_Selection) or IsWidgetInScrollView(Target, SiftDialog.List_Selection)) then
    return Target
  end
  self:QueueDeferredAdjacentWBoxFocus(NextWBox, ColumnIndex, RequestId, false, false)
  return nil
end

function M:SetWBoxUpTarget()
  local RequestId = self:InvalidateDeferredCrossSiftFocus()
  local Rows, RowIndex, ColumnIndex = GetVisualNavigationContext(self)
  if not RowIndex or not ColumnIndex then
    return nil
  end
  if Rows[RowIndex - 1] then
    return GetRowTarget(Rows[RowIndex - 1], ColumnIndex)
  end
  if not self.OwnerItemUI or not self.OwnerItemUI.GetPrevWrapBox then
    return nil
  end
  local PrevWBox = self.OwnerItemUI:GetPrevWrapBox()
  if not PrevWBox then
    return nil
  end
  if PrevWBox.ListReward then
    local SiftDialog = self.OwnerItemUI.Owner
    if SiftDialog and SiftDialog.List_Selection then
      SiftDialog.List_Selection:ScrollToStart()
    end
    if SiftDialog and SiftDialog.Owner then
      SiftDialog.Owner:ShowGamepadShortcut(1)
    end
    return GetListRewardTarget(PrevWBox)
  end
  local SiftDialog = self.OwnerItemUI.Owner
  local Target = GetRowTarget(GetLastVisualRow(PrevWBox), ColumnIndex)
  if Target and (not (SiftDialog and SiftDialog.List_Selection) or IsWidgetInScrollView(Target, SiftDialog.List_Selection)) then
    return Target
  end
  self:QueueDeferredAdjacentWBoxFocus(PrevWBox, ColumnIndex, RequestId, false, true)
  return nil
end

return M
