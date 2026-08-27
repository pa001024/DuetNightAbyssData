require("UnLua")
local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
local StringBoardConfig = require("BluePrints.UI.InvestigationWall.StringBoardConfig")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local table_insert = table.insert
local ZoomSliderScale = 100
local ZoomClickStep = 2
local ZoomSliderLongPressInterval = 0.05

function M:Initialize(Initializer)
  self.bIsSyncingZoomFromPanel = false
  self.LineItemInStaggerToken = 0
  self.LineItemInStaggerExpectedCoordinates = nil
  self.LineItemWidgetByCoordinate = nil
  self.bLineItemInStaggerPlayPending = false
  self.LineItemInStaggerOpenedCoordinateSet = nil
  self.FocusedLineItemWidget = nil
  self.bLineTileAcceptPressed = false
  self.LastFocusedLineTileX = nil
  self.LastFocusedLineTileY = nil
  self.bSuppressLineItemFocusVisual = false
end

function M:Destruct()
  self.bSuppressLineItemFocusVisual = false
  self:UnbindLineNewReddotListener()
  self:CancelLineItemInStagger()
  if self.CleanTimer then
    self:CleanTimer()
  end
  self:ClearFocusedLineItemVisual()
  self:UnbindEvents()
end

function M:Init(ReviewPageId)
  self.ReviewPageId = ReviewPageId
  self:BindEvents()
  self:InitZoomRange()
  self:InitTilePanel()
  self:InitZoomSlider()
  StringBoardReddotHelper.SyncLineNews(self.ReviewPageId)
  self:BindLineNewReddotListener()
  self:RefreshAllLineNewReddot()
end

function M:BindLineNewReddotListener()
  StringBoardReddotHelper.EnsureNodes()
  ReddotManager.AddListenerEx(StringBoardReddotHelper.NodeName.LineNew, self, self.OnLineNewReddotChanged)
end

function M:UnbindLineNewReddotListener()
  ReddotManager.RemoveListener(StringBoardReddotHelper.NodeName.LineNew, self)
end

function M:OnLineNewReddotChanged(Count, RdType, Name)
  self:RefreshAllLineNewReddot()
end

function M:RefreshAllLineNewReddot()
  for _, LineItemWidget in pairs(self.LineItemWidgetByCoordinate or {}) do
    if LineItemWidget and LineItemWidget.RefreshStringBoardNewReddot then
      LineItemWidget:RefreshStringBoardNewReddot()
    end
  end
end

function M:BindEvents()
  local Panel = self:GetTilePanel()
  if Panel then
    if Panel.OnZoomChanged then
      Panel.OnZoomChanged:Clear()
      Panel.OnZoomChanged:Add(self, self.OnPanelZoomChanged)
    end
    if Panel.OnTileWidgetGenerated then
      Panel.OnTileWidgetGenerated:Clear()
      Panel.OnTileWidgetGenerated:Add(self, self.OnTileWidgetGenerated)
    end
    if Panel.OnTileWidgetReleased then
      Panel.OnTileWidgetReleased:Clear()
      Panel.OnTileWidgetReleased:Add(self, self.OnTileWidgetReleased)
    end
    if Panel.OnTileItemClicked then
      Panel.OnTileItemClicked:Clear()
      Panel.OnTileItemClicked:Add(self, self.OnLineTileItemClicked)
    end
    if Panel.OnTileFocusChanged then
      Panel.OnTileFocusChanged:Clear()
      Panel.OnTileFocusChanged:Add(self, self.OnLineTileFocusChanged)
    end
  end
end

function M:UnbindEvents()
  local Panel = self:GetTilePanel()
  if Panel then
    if Panel.OnZoomChanged then
      Panel.OnZoomChanged:Remove(self, self.OnPanelZoomChanged)
    end
    Panel.OnTileWidgetGenerated:Remove(self, self.OnTileWidgetGenerated)
    if Panel.OnTileWidgetReleased then
      Panel.OnTileWidgetReleased:Remove(self, self.OnTileWidgetReleased)
    end
    if Panel.OnTileItemClicked then
      Panel.OnTileItemClicked:Remove(self, self.OnLineTileItemClicked)
    end
    if Panel.OnTileFocusChanged then
      Panel.OnTileFocusChanged:Remove(self, self.OnLineTileFocusChanged)
    end
  end
end

function M:InitTilePanel()
  local Panel = self:GetTilePanel()
  if not Panel then
    return
  end
  self:CancelLineItemInStagger()
  self:ClearFocusedLineItemVisual()
  Panel:ClearTiles()
  local TileContentSize = Panel.Config and Panel.Config.ContentSize
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  local TileDataList = InvestigationWallUtils.BuildTilePositionDataFromReviewChain(self.ReviewPageId, Avatar)
  self.TileDataList = TileDataList
  local AddedTileCoordinateList = {}
  self.LineItemWidgetByCoordinate = {}
  self.LineItemInStaggerOpenedCoordinateSet = {}
  for _, Data in ipairs(TileDataList) do
    local Position = Data.Position
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local DataContent = Data.Content or {}
    Content.ReviewId = DataContent.ReviewId
    Content.ReviewChainSequence = DataContent.ReviewChainSequence
    Content.bIsMainLine = DataContent.bIsMainLine
    Content.bShowFrontArrow = DataContent.bShowFrontArrow
    Content.bShowBackArrow = DataContent.bShowBackArrow
    Content.OffsetYInTileSteps = DataContent.OffsetYInTileSteps
    Content.OffsetXInTileSteps = DataContent.OffsetXInTileSteps
    Content.PosX = Position.X
    Content.PosY = Position.Y
    Content.OwnerLine = self
    local OffsetX, OffsetY = InvestigationWallUtils.ResolveTileOffsetFromContent(DataContent, TileContentSize, Data.Offset)
    local WidgetClassPath = Data.WidgetClass
    if WidgetClassPath then
      local PosX = Position.X
      local PosY = Position.Y
      Panel:AddTileContent(PosX, PosY, LoadClass(WidgetClassPath), UE4.FVector2D(OffsetX, OffsetY), Content)
      table_insert(AddedTileCoordinateList, {X = PosX, Y = PosY})
    end
  end
  self.LineItemInStaggerExpectedCoordinates = AddedTileCoordinateList
  self:RefreshInitialState()
end

function M:RefreshInitialState()
  self:ResetZoomToDefault()
  self:LocateToInitialPosition()
end

function M:GetLineZoomConfig()
  return StringBoardConfig.LineZoomConfig or {}
end

function M:InitZoomRange()
  local Panel = self:GetTilePanel()
  if not Panel or not Panel.SetZoomRange then
    return
  end
  local MinZoom = Panel.MinZoom
  local MaxZoom = Panel.MaxZoom
  if nil == MinZoom or nil == MaxZoom then
    return
  end
  Panel:SetZoomRange(MinZoom, MaxZoom)
end

function M:ResetZoomToDefault()
  local Panel = self:GetTilePanel()
  if not Panel or not Panel.SetZoom then
    return
  end
  local LineZoomConfig = self:GetLineZoomConfig()
  Panel:SetZoom(LineZoomConfig.DefaultZoom or 1.0)
end

function M:LocateToInitialPosition()
  local Panel = self:GetTilePanel()
  if not Panel or not Panel.ScrollIntoView then
    return
  end
  local TargetX, TargetY = InvestigationWallUtils.ResolveInitialLineLocatePosition(self.TileDataList, InvestigationWallUtils.GetAvatarSafe())
  if nil == TargetX or nil == TargetY then
    return
  end
  Panel:ScrollIntoView(TargetX, TargetY, UE4.EEMTileScrollAlignment.Center)
end

function M:GetTilePanel()
  return self.InvestigationPanel
end

function M:InitZoomSlider()
  local Panel = self:GetTilePanel()
  local Slider = self.Com_Slider_Vertical
  if not Panel or not Slider then
    return
  end
  local LineZoomConfig = self:GetLineZoomConfig()
  local MinZoom = Panel.MinZoom
  local MaxZoom = Panel.MaxZoom
  if nil == MinZoom or nil == MaxZoom then
    return
  end
  local MinSliderValue = math.floor(MinZoom * ZoomSliderScale)
  local MaxSliderValue = math.floor(MaxZoom * ZoomSliderScale)
  local DefaultZoom = LineZoomConfig.DefaultZoom or (MinZoom + MaxZoom) / 2
  local InitSliderValue = math.floor(DefaultZoom * ZoomSliderScale + 0.5)
  Slider:Init({
    InitValue = InitSliderValue,
    MinValue = MinSliderValue,
    MaxValue = MaxSliderValue,
    ClickInterval = ZoomClickStep,
    MinusBtnCallback = self.OnZoomSliderValueChanged,
    AddBtnCallback = self.OnZoomSliderValueChanged,
    SliderChangeCallback = self.OnZoomSliderValueChanged,
    OwnerPanel = self,
    ForbidGamePadLTRTKey = false,
    ForbidGamePadRSKey = true,
    LongPressInterval = ZoomSliderLongPressInterval,
    bForbidPressAccelerate = false
  })
  rawset(Slider, "GamePadMinKeyPath", "LT")
  rawset(Slider, "GamePadAddKeyPath", "RT")
end

function M:ZoomFromSliderValue(SliderValue)
  return SliderValue / ZoomSliderScale
end

function M:SliderValueFromZoom(Zoom)
  return math.floor(Zoom * ZoomSliderScale + 0.5)
end

function M:OnZoomSliderValueChanged(CurrentSliderValue)
  if self.bIsSyncingZoomFromPanel then
    return
  end
  local Panel = self:GetTilePanel()
  if not Panel then
    return
  end
  Panel:SetZoom(self:ZoomFromSliderValue(CurrentSliderValue))
end

function M:OnPanelZoomChanged(ZoomScale)
  local Slider = self.Com_Slider_Vertical
  if not Slider then
    return
  end
  self.bIsSyncingZoomFromPanel = true
  Slider:RefreshCurInputNumber(self:SliderValueFromZoom(ZoomScale))
  self.bIsSyncingZoomFromPanel = false
end

function M:OnTileWidgetGenerated(ItemData)
  local Child = ItemData.Widget
  if Child and Child.OnTileItemSet then
    Child:OnTileItemSet(ItemData.ContentObject)
  end
  if ItemData and ItemData.bFocused and Child then
    self.FocusedLineItemWidget = Child
    if not self.bSuppressLineItemFocusVisual then
      self:ApplyLineItemFocusVisual(Child, true)
    end
  end
  if not Child then
    return
  end
  local CoordinateKey = self:MakeLineItemStaggerCoordinateKey(ItemData.X, ItemData.Y)
  if not CoordinateKey then
    return
  end
  self.LineItemWidgetByCoordinate = self.LineItemWidgetByCoordinate or {}
  self.LineItemWidgetByCoordinate[CoordinateKey] = Child
  if self.bLineItemInStaggerPlayPending then
    self:ScheduleLineItemInStaggerSnapshot()
    return
  end
  local OpenedCoordinateSet = self.LineItemInStaggerOpenedCoordinateSet
  if OpenedCoordinateSet and OpenedCoordinateSet[CoordinateKey] then
    return
  end
  if self:IsLineViewActive() then
    if Child.PlayOpenAnimation then
      Child:PlayOpenAnimation()
    end
    self.LineItemInStaggerOpenedCoordinateSet = OpenedCoordinateSet or {}
    self.LineItemInStaggerOpenedCoordinateSet[CoordinateKey] = true
  end
end

function M:OnTileWidgetReleased(ItemData)
  local ChildWidget = ItemData and ItemData.Widget
  if ChildWidget and self.FocusedLineItemWidget == ChildWidget then
    self:ClearLineTileAcceptPressed()
    self:ResetLineItemInteractionVisual(ChildWidget)
    self.FocusedLineItemWidget = nil
  end
  local CoordinateKey = self:MakeLineItemStaggerCoordinateKey(ItemData and ItemData.X, ItemData and ItemData.Y)
  if not CoordinateKey then
    return
  end
  if self.LineItemWidgetByCoordinate then
    self.LineItemWidgetByCoordinate[CoordinateKey] = nil
  end
  if self.LineItemInStaggerOpenedCoordinateSet then
    self.LineItemInStaggerOpenedCoordinateSet[CoordinateKey] = nil
  end
end

function M:MakeLineItemStaggerCoordinateKey(PosX, PosY)
  if nil == PosX or nil == PosY then
    return nil
  end
  return tostring(PosX) .. "_" .. tostring(PosY)
end

function M:IsLineViewActive()
  local OwnerStringBoard = self.OwnerStringBoard
  if OwnerStringBoard and OwnerStringBoard.bIsBoardView == false then
    return true
  end
  return false
end

function M:CancelLineItemInStagger()
  self.LineItemInStaggerToken = (self.LineItemInStaggerToken or 0) + 1
  self.bLineItemInStaggerPlayPending = false
  self:RemoveTimer("LineItemInStagger")
  self:RemoveTimer("LineItemInStaggerKick")
end

function M:ScheduleLineItemInStaggerSnapshot()
  self:RemoveTimer("LineItemInStaggerKick")
  local SnapshotDelay = StringBoardConfig.LineItemInStaggerSnapshotDelay or 0.05
  local StaggerToken = self.LineItemInStaggerToken
  self:AddTimer(SnapshotDelay, function()
    if not IsValid(self) or self.LineItemInStaggerToken ~= StaggerToken then
      return
    end
    self:RemoveTimer("LineItemInStaggerKick")
    self:SnapshotAndStartLineItemInStagger()
  end, false, 0, "LineItemInStaggerKick")
end

function M:SnapshotAndStartLineItemInStagger()
  if not self.bLineItemInStaggerPlayPending then
    return
  end
  local ExpectedCoordinates = self.LineItemInStaggerExpectedCoordinates
  local WidgetByCoordinate = self.LineItemWidgetByCoordinate or {}
  local LineItemWidgetList = {}
  local OpenedCoordinateSet = self.LineItemInStaggerOpenedCoordinateSet or {}
  if ExpectedCoordinates then
    for _, Coordinate in ipairs(ExpectedCoordinates) do
      local CoordinateKey = self:MakeLineItemStaggerCoordinateKey(Coordinate.X, Coordinate.Y)
      local ChildWidget = CoordinateKey and WidgetByCoordinate[CoordinateKey]
      if ChildWidget and IsValid(ChildWidget) then
        if ChildWidget.PrepareForStaggeredOpenAnimation then
          ChildWidget:PrepareForStaggeredOpenAnimation()
        end
        OpenedCoordinateSet[CoordinateKey] = true
        table_insert(LineItemWidgetList, ChildWidget)
      end
    end
  end
  if 0 == #LineItemWidgetList then
    return
  end
  self.bLineItemInStaggerPlayPending = false
  self.LineItemInStaggerOpenedCoordinateSet = OpenedCoordinateSet
  self:StartLineItemInStagger(LineItemWidgetList)
end

function M:PlayLineItemInStaggerFromBoardSwitch()
  self:CancelLineItemInStagger()
  self.bLineItemInStaggerPlayPending = true
  self.LineItemInStaggerOpenedCoordinateSet = {}
  self:ScheduleLineItemInStaggerSnapshot()
end

function M:StartLineItemInStagger(LineItemWidgetList)
  if not LineItemWidgetList or 0 == #LineItemWidgetList then
    return
  end
  self.LineItemInStaggerToken = (self.LineItemInStaggerToken or 0) + 1
  self:RemoveTimer("LineItemInStagger")
  local StaggerToken = self.LineItemInStaggerToken
  local PlayIndex = 0
  local Interval = StringBoardConfig.LineItemInStaggerInterval or 0.05
  
  local function PlayNextLineItemIn()
    if not IsValid(self) or self.LineItemInStaggerToken ~= StaggerToken then
      return false
    end
    PlayIndex = PlayIndex + 1
    local ChildWidget = LineItemWidgetList[PlayIndex]
    if ChildWidget and IsValid(ChildWidget) and ChildWidget.PlayOpenAnimation then
      ChildWidget:PlayOpenAnimation()
    end
    return PlayIndex < #LineItemWidgetList
  end
  
  if not PlayNextLineItemIn() then
    return
  end
  self:AddTimer(Interval, function()
    if not PlayNextLineItemIn() then
      self:RemoveTimer("LineItemInStagger")
    end
  end, true, 0, "LineItemInStagger")
end

function M:OnLineTileItemClicked(ItemData)
  local ChildWidget = ItemData and ItemData.Widget
  if ChildWidget and ChildWidget.OnReviewItemClicked then
    ChildWidget:OnReviewItemClicked()
  end
end

function M:OnLineTileFocusChanged(ItemData)
  local ChildWidget = ItemData and ItemData.Widget
  if ItemData and ItemData.bFocused then
    self.LastFocusedLineTileX = ItemData.X
    self.LastFocusedLineTileY = ItemData.Y
    self.FocusedLineItemWidget = ChildWidget
    if not self.bSuppressLineItemFocusVisual then
      self:ApplyLineItemFocusVisual(ChildWidget, true)
    end
  else
    self:ClearLineTileAcceptPressed()
    if not self.bSuppressLineItemFocusVisual then
      self:ResetLineItemInteractionVisual(ChildWidget)
    end
    if self.FocusedLineItemWidget == ChildWidget then
      self.FocusedLineItemWidget = nil
    end
  end
end

function M:ApplyLineItemFocusVisual(LineItemWidget, bFocused)
  if not LineItemWidget or not IsValid(LineItemWidget) then
    return
  end
  if bFocused and LineItemWidget.PlayLineItemFocusHover then
    LineItemWidget:PlayLineItemFocusHover()
  end
end

function M:ResetLineItemInteractionVisual(LineItemWidget)
  if not LineItemWidget or not IsValid(LineItemWidget) then
    return
  end
  if LineItemWidget.ResetLineItemInteractionVisual then
    LineItemWidget:ResetLineItemInteractionVisual()
  end
end

function M:ClearLineTileAcceptPressed()
  self.bLineTileAcceptPressed = false
end

function M:ClearFocusedLineItemVisual()
  self:ClearLineTileAcceptPressed()
  self:ResetLineItemInteractionVisual(self.FocusedLineItemWidget)
  self.FocusedLineItemWidget = nil
  self.LastFocusedLineTileX = nil
  self.LastFocusedLineTileY = nil
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleLineGamePadPreviewKeyDown(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleLineGamePadKeyUp(InKeyName) then
    return UIUtils.Handled
  end
  local OwnerStringBoard = self.OwnerStringBoard
  if OwnerStringBoard and UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and OwnerStringBoard.HandleGamePadKeyUp and OwnerStringBoard:HandleGamePadKeyUp(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:HandleLineGamePadPreviewKeyDown(InKeyName)
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold or InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
    local Slider = self.Com_Slider_Vertical
    if Slider and Slider.Handle_KeyDownEventOnGamePad then
      return Slider:Handle_KeyDownEventOnGamePad(InKeyName)
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    return self:TryPressFocusedLineTileOnAccept()
  end
  return false
end

function M:HandleLineGamePadKeyUp(InKeyName)
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold or InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
    local Slider = self.Com_Slider_Vertical
    if Slider and Slider.Handle_KeyUpEventOnGamePad then
      return Slider:Handle_KeyUpEventOnGamePad(InKeyName)
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    return self:TryClickFocusedLineTileOnAcceptRelease()
  end
  return false
end

function M:TryPressFocusedLineTileOnAccept()
  if self.LastFocusedLineTileX == nil or nil == self.LastFocusedLineTileY then
    return false
  end
  if self.bLineTileAcceptPressed then
    return true
  end
  local LineItemWidget = self.FocusedLineItemWidget
  if LineItemWidget and IsValid(LineItemWidget) and LineItemWidget.OnLineItemPressed then
    LineItemWidget:OnLineItemPressed()
  end
  self.bLineTileAcceptPressed = true
  return true
end

function M:TryClickFocusedLineTileOnAcceptRelease()
  if not self.bLineTileAcceptPressed then
    return false
  end
  self:ClearLineTileAcceptPressed()
  local Panel = self:GetTilePanel()
  if Panel and Panel.ClickFocusedTile then
    return Panel:ClickFocusedTile()
  end
  return false
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local OwnerStringBoard = self.OwnerStringBoard
  if OwnerStringBoard and UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and OwnerStringBoard.HandleGamePadKeyDown and OwnerStringBoard:HandleGamePadKeyDown(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:FocusDefaultForGamepad()
  if not UIUtils.IsGamepadInput() then
    return
  end
  local Panel = self:GetTilePanel()
  if not Panel then
    return
  end
  local TargetX, TargetY = InvestigationWallUtils.ResolveInitialLineLocatePosition(self.TileDataList, InvestigationWallUtils.GetAvatarSafe())
  if nil ~= TargetX and nil ~= TargetY and Panel.SetFocusedTile then
    local SavedFocusScrollDuration = Panel.FocusScrollDuration
    if nil ~= SavedFocusScrollDuration then
      Panel.FocusScrollDuration = 0
    end
    Panel:SetFocusedTile(TargetX, TargetY)
    if nil ~= SavedFocusScrollDuration then
      Panel.FocusScrollDuration = SavedFocusScrollDuration
    end
  end
  if Panel.FocusPanel then
    Panel:FocusPanel()
  elseif Panel.SetFocus then
    Panel:SetFocus()
  end
end

function M:RestoreGamepadFocusAfterPopup(PosX, PosY)
  if not UIUtils.IsGamepadInput() then
    return
  end
  local Panel = self:GetTilePanel()
  if not Panel then
    return
  end
  self.bSuppressLineItemFocusVisual = true
  if Panel.SetFocus then
    Panel:SetFocus()
  end
  if nil ~= PosX and nil ~= PosY and Panel.SetFocusedTile then
    local SavedFocusScrollDuration = Panel.FocusScrollDuration
    if nil ~= SavedFocusScrollDuration then
      Panel.FocusScrollDuration = 0
    end
    Panel:SetFocusedTile(PosX, PosY)
    if nil ~= SavedFocusScrollDuration then
      Panel.FocusScrollDuration = SavedFocusScrollDuration
    end
  end
  self.bSuppressLineItemFocusVisual = false
  local TargetWidget = self.FocusedLineItemWidget
  if (not TargetWidget or not IsValid(TargetWidget)) and nil ~= PosX and nil ~= PosY then
    local CoordinateKey = self:MakeLineItemStaggerCoordinateKey(PosX, PosY)
    TargetWidget = CoordinateKey and self.LineItemWidgetByCoordinate and self.LineItemWidgetByCoordinate[CoordinateKey]
    if TargetWidget and IsValid(TargetWidget) then
      self.FocusedLineItemWidget = TargetWidget
      self.LastFocusedLineTileX = PosX
      self.LastFocusedLineTileY = PosY
    end
  end
  if TargetWidget and IsValid(TargetWidget) and TargetWidget.PlayLineItemFocusHover then
    TargetWidget:PlayLineItemFocusHover(true)
  end
end

function M:FocusToCurrentSelectionForGamepad()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.LastFocusedLineTileX ~= nil and nil ~= self.LastFocusedLineTileY then
    self:RestoreGamepadFocusAfterPopup(self.LastFocusedLineTileX, self.LastFocusedLineTileY)
    return
  end
  self:FocusDefaultForGamepad()
end

function M:ClearPendingReopenPopupAfterLevelMap()
  self.bPendingReopenPopupAfterLevelMap = nil
  self.PendingReopenPopupContent = nil
end

function M:ReopenPopupAfterLevelMap()
  if not self.bPendingReopenPopupAfterLevelMap then
    return
  end
  local CachedContent = self.PendingReopenPopupContent
  self:ClearPendingReopenPopupAfterLevelMap()
  if not CachedContent then
    return
  end
  local UIMgr = UIManager(self)
  if not UIMgr then
    return
  end
  local ExistPopup = UIMgr:GetUIObj("StringBoardPopup")
  if ExistPopup then
    UIMgr:UnLoadUINew("StringBoardPopup")
  end
  UIMgr:LoadUINew("StringBoardPopup", CachedContent)
end

return M
