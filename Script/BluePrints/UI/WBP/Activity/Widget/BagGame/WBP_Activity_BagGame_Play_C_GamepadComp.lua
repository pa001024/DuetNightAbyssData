local Component = {}
local Const = UIConst.GamePadKey
local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local GRID_ROWS = BagGameModel.GRID_ROWS
local GRID_COLS = BagGameModel.GRID_COLS

function Component:InitListenEvent()
  local PlayerController = self:GetOwningPlayer()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function Component:RefreshBaseInfo()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function Component:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == UE4.ECommonInputType.Touch then
    return
  end
  local PrevInputDevice = self.CurInputDevice
  self.CurGamepadName = CurGamepadName
  self.CurInputDevice = CurInputDevice
  self:_SyncGamepadStateWithRuntimeContext()
  if CurInputDevice == UE4.ECommonInputType.Gamepad then
    self.KeyCheck:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.KeyRefresh:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.Btn_Explanation and self.Btn_Explanation.WidgetSwitcher_0 then
      self.Btn_Explanation.WidgetSwitcher_0:SetActiveWidgetIndex(1)
    end
  else
    self.KeyCheck:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.KeyRefresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.Btn_Explanation and self.Btn_Explanation.WidgetSwitcher_0 then
      self.Btn_Explanation.WidgetSwitcher_0:SetActiveWidgetIndex(0)
    end
  end
  self:RefreshGamepadBottomKeyInfo()
  if CurInputDevice == UE4.ECommonInputType.Gamepad and PrevInputDevice ~= UE4.ECommonInputType.Gamepad then
    self:_RestoreGamepadFocusByState()
    self:_ScheduleRestoreGamepadFocusByState()
  end
end

function Component:InitGamePadKey()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if not self.Tab then
    return
  end
  self.Tab:Init({
    DynamicNode = {"Back", "BottomKey"},
    StyleName = "TextImage",
    TitleName = GText("Event_Title_103015"),
    OwnerPanel = self,
    BackCallback = self.CloseSelf,
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  })
  self._PendingGamepadBottomKeyRefresh = nil
  self:RefreshGamepadBottomKeyInfo()
  self:InitSingleGamePadKey()
end

function Component:InitSingleGamePadKey()
  self.KeyRefresh:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self.KeyCheck:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  if self.Btn_Explanation and self.Btn_Explanation.Com_KeyImg then
    self.Btn_Explanation.Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Menu"}
      },
      bLongPress = false
    })
  end
end

function Component:_HasOperablePlacedGamepadItem()
  if self.CurInputDevice ~= UE4.ECommonInputType.Gamepad then
    return false
  end
  local CurrentItem = self.CurrentUnconfirmedItem
  if CurrentItem then
    if CurrentItem.IsStopKeyVisible then
      return CurrentItem:IsStopKeyVisible()
    end
    return CurrentItem.bIsConfirmed ~= true
  end
  if not self.PlacedItems then
    return false
  end
  for _, Record in ipairs(self.PlacedItems) do
    local Widget = Record and Record.Widget
    if Widget and Widget.bIsConfirmed ~= true then
      if Widget.IsStopKeyVisible then
        if Widget:IsStopKeyVisible() then
          return true
        end
      else
        return true
      end
    end
  end
  return false
end

function Component:RefreshGamepadBottomKeyInfo()
  if not self.Tab or not self.Tab.ConfigData then
    self._PendingGamepadBottomKeyRefresh = true
    return
  end
  self._PendingGamepadBottomKeyRefresh = nil
  self:_UpdateBottomKeyByState(self._GamepadState or "SCROLL")
end

function Component:_UpdateBottomKeyByState(State)
  if not self.Tab or not self.Tab.ConfigData then
    return
  end
  local ImgKey = UIConst.GamePadImgKey
  local LKey = {
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = ImgKey.LeftTriggerAnalog,
        Owner = self
      }
    },
    Desc = GText("UI_CTL_Move")
  }
  local AKey = {
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = ImgKey.FaceButtonBottom,
        Owner = self
      }
    },
    Desc = GText("UI_CTL_Select")
  }
  local LSKey = {
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = ImgKey.LeftThumb,
        Owner = self
      }
    },
    Desc = GText("UI_CTL_ChooseItem")
  }
  local BKey = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = "Escape",
        ClickCallback = self.CloseSelf,
        Owner = self
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        ClickCallback = self.CloseSelf
      }
    },
    Desc = GText("UI_BACK"),
    bLongPress = false
  }
  local bShowBackKey = not self:_HasOperablePlacedGamepadItem()
  local Info
  if "SCROLL" == State then
    Info = {
      LKey,
      AKey,
      LSKey
    }
  elseif "MOVING" == State then
    Info = {LKey}
  elseif "FOCUS" == State then
    Info = {LKey, AKey}
  else
    return
  end
  if bShowBackKey then
    table.insert(Info, BKey)
  end
  self.Tab:UpdateBottomKeyInfo(Info)
end

function Component:_InitGamepadItemList()
  self._GamepadState = "SCROLL"
  self._GamepadMoveRow = 1
  self._GamepadMoveCol = 1
  self._GamepadMoveValid = true
  self._GamepadLastDoubleReward = nil
  self._GamepadDragUI = nil
  self._GamepadDragOperation = nil
  self._GamepadDragSourceData = nil
  self._GamepadPlacedItem = nil
  self._GamepadSelectedContent = nil
  self._FocusIndex = 1
  if not self._ConfirmedPlacedItems then
    self._ConfirmedPlacedItems = {}
  end
  if self.EMTileView1 then
    self.EMTileView1.BP_OnItemSelectionChanged:Add(self, self._OnDisPlayItemSelected)
  end
  if self.DisPlayItemDataList and #self.DisPlayItemDataList > 0 then
    self._GamepadSelectedContent = self.DisPlayItemDataList[1]
  end
end

function Component:_OnDisPlayItemSelected(Content, bIsSelected)
  if bIsSelected and Content then
    self._GamepadSelectedContent = Content
  end
end

function Component:_BuildGamepadScanRange(ShapeOffsets)
  if not ShapeOffsets or #ShapeOffsets <= 0 then
    return nil, nil
  end
  local sMinR, sMaxR = ShapeOffsets[1][1] or 0, ShapeOffsets[1][1] or 0
  local sMinC, sMaxC = ShapeOffsets[1][2] or 0, ShapeOffsets[1][2] or 0
  for _, Off in ipairs(ShapeOffsets) do
    local R, C = Off[1] or 0, Off[2] or 0
    if sMinR > R then
      sMinR = R
    end
    if sMaxR < R then
      sMaxR = R
    end
    if sMinC > C then
      sMinC = C
    end
    if sMaxC < C then
      sMaxC = C
    end
  end
  local ShapeRows = math.max(1, sMaxR - sMinR + 1)
  local ShapeCols = math.max(1, sMaxC - sMinC + 1)
  local CtrRowOff = sMinR + math.floor((ShapeRows - 1) / 2)
  local CtrColOff = sMinC + math.floor((ShapeCols - 1) / 2)
  local scanRowStart = math.max(1, 1 + CtrRowOff - sMinR)
  local scanRowEnd = math.min(GRID_ROWS, GRID_ROWS + CtrRowOff - sMaxR)
  local scanColStart = math.max(1, 1 + CtrColOff - sMinC)
  local scanColEnd = math.min(GRID_COLS, GRID_COLS + CtrColOff - sMaxC)
  return {scanRowStart, scanRowEnd}, {scanColStart, scanColEnd}
end

function Component:_SyncMovingStateWithRuntimeContext(CurrentItem)
  local PlacedItem = CurrentItem
  if not PlacedItem and self.GetUnconfirmedItem then
    PlacedItem = self:GetUnconfirmedItem()
  end
  PlacedItem = PlacedItem or self.CurrentUnconfirmedItem
  if not PlacedItem then
    return false
  end
  local PlacedRecord = self:_GetPlacedRecord(PlacedItem)
  local RowRange, ColRange = self:_BuildGamepadScanRange(PlacedItem.ShapeOffsets or PlacedItem.OriginalShapeOffsets)
  self._GamepadState = "MOVING"
  self._GamepadPlacedItem = PlacedItem
  self._GamepadDragUI = nil
  self._GamepadDragOperation = nil
  self._GamepadDragSourceData = nil
  self._GamepadScanRowRange = RowRange
  self._GamepadScanColRange = ColRange
  if PlacedRecord then
    self._GamepadMoveRow = PlacedRecord.BaseRow or self._GamepadMoveRow or 1
    self._GamepadMoveCol = PlacedRecord.BaseCol or self._GamepadMoveCol or 1
    self._GamepadMoveValid = PlacedItem.IsTempPlacement ~= true
    self._GamepadLastDoubleReward = PlacedRecord.IsDoubleReward
    if PlacedRecord.Cells then
      self:_ClearGamepadVisualCells()
      self:_PlayGamepadVisualCells(PlacedRecord.Cells, self._GamepadMoveValid, PlacedRecord)
    else
      self._GamepadVisualCells = nil
    end
  else
    self._GamepadMoveRow = self._GamepadMoveRow or 1
    self._GamepadMoveCol = self._GamepadMoveCol or 1
    self._GamepadMoveValid = PlacedItem.IsTempPlacement ~= true
    self._GamepadLastDoubleReward = nil
    self._GamepadVisualCells = nil
  end
  return true
end

function Component:_SyncGamepadStateWithRuntimeContext()
  local CurrentItem
  if self.GetUnconfirmedItem then
    CurrentItem = self:GetUnconfirmedItem()
  end
  CurrentItem = CurrentItem or self.CurrentUnconfirmedItem
  if CurrentItem then
    self:_SyncMovingStateWithRuntimeContext(CurrentItem)
  else
    self._GamepadPlacedItem = nil
    self._GamepadDragUI = nil
    self._GamepadDragOperation = nil
    self._GamepadDragSourceData = nil
    self._GamepadScanRowRange = nil
    self._GamepadScanColRange = nil
    self._GamepadLastDoubleReward = nil
    self._GamepadMoveValid = true
    self:_ClearGamepadVisualCells()
    local Count = self._ConfirmedPlacedItems and #self._ConfirmedPlacedItems or 0
    if self._GamepadState == "FOCUS" and Count > 0 then
      local FocusIndex = math.max(1, math.min(self._FocusIndex or 1, Count))
      local FocusRecord = self._ConfirmedPlacedItems[FocusIndex]
      if not FocusRecord or not FocusRecord.Widget then
        for Index, Record in ipairs(self._ConfirmedPlacedItems) do
          if Record and Record.Widget then
            FocusIndex = Index
            FocusRecord = Record
            break
          end
        end
      end
      if FocusRecord and FocusRecord.Widget then
        self._GamepadState = "FOCUS"
        self._FocusIndex = FocusIndex
      else
        self._GamepadState = "SCROLL"
        self._FocusIndex = 1
      end
    else
      self._GamepadState = "SCROLL"
      self._FocusIndex = 1
    end
  end
  if self.Tab and self.Tab.ConfigData then
    self:_UpdateBottomKeyByState(self._GamepadState or "SCROLL")
  end
  return self._GamepadState
end

function Component:_GetFocusPlayerController()
  return self:GetOwningPlayer()
end

function Component:_HasFocusOnWidget(Widget)
  if not Widget then
    return false
  end
  local PlayerController = self:_GetFocusPlayerController()
  if PlayerController and Widget.HasUserFocus and Widget:HasUserFocus(PlayerController) then
    return true
  end
  if Widget.HasAnyUserFocus and Widget:HasAnyUserFocus() then
    return true
  end
  return false
end

function Component:_HasFocusInWidgetTree(Widget)
  if not Widget then
    return false
  end
  local PlayerController = self:_GetFocusPlayerController()
  if PlayerController and Widget.HasUserFocusedDescendants and Widget:HasUserFocusedDescendants(PlayerController) then
    return true
  end
  if Widget.HasFocusedDescendants and Widget:HasFocusedDescendants() then
    return true
  end
  return self:_HasFocusOnWidget(Widget)
end

function Component:_GetScrollSelectedIndex()
  if not self.DisPlayItemDataList or #self.DisPlayItemDataList <= 0 then
    return nil
  end
  local SelectedContent = self._GamepadSelectedContent
  if SelectedContent then
    for Index, Content in ipairs(self.DisPlayItemDataList) do
      if Content == SelectedContent then
        return Index
      end
    end
  end
  return 1
end

function Component:_FocusScrollListIndex(Index)
  if not (self.EMTileView1 and self.DisPlayItemDataList) or #self.DisPlayItemDataList <= 0 then
    return false
  end
  local ValidIndex = math.max(1, math.min(Index or 1, #self.DisPlayItemDataList))
  self._GamepadSelectedContent = self.DisPlayItemDataList[ValidIndex]
  self.EMTileView1:SetSelectedIndex(ValidIndex - 1)
  self.EMTileView1:NavigateToIndex(ValidIndex - 1)
  self.EMTileView1:SetFocus()
  return true
end

function Component:_RestoreScrollFocusBySelected(bForceFirst)
  if bForceFirst then
    return self:_FocusScrollListIndex(1)
  end
  local SelectedIndex = self:_GetScrollSelectedIndex()
  return self:_FocusScrollListIndex(SelectedIndex or 1)
end

function Component:_RestoreFocusStateFocus()
  local Count = self._ConfirmedPlacedItems and #self._ConfirmedPlacedItems or 0
  if Count <= 0 then
    self._GamepadState = "SCROLL"
    self:_UpdateBottomKeyByState("SCROLL")
    self:_RestoreScrollFocusBySelected(true)
    return
  end
  local FocusIndex = self._FocusIndex or 1
  local FocusRecord = self._ConfirmedPlacedItems[FocusIndex]
  if not FocusRecord or not FocusRecord.Widget then
    for Index, Record in ipairs(self._ConfirmedPlacedItems) do
      if Record and Record.Widget then
        FocusIndex = Index
        FocusRecord = Record
        break
      end
    end
  end
  if not FocusRecord or not FocusRecord.Widget then
    self._GamepadState = "SCROLL"
    self:_UpdateBottomKeyByState("SCROLL")
    self:_RestoreScrollFocusBySelected(true)
    return
  end
  self._FocusIndex = FocusIndex
  FocusRecord.Widget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  FocusRecord.Widget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  FocusRecord.Widget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  FocusRecord.Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  FocusRecord.Widget:SetFocus()
end

function Component:_RestoreGamepadFocusByState()
  self:_SyncGamepadStateWithRuntimeContext()
  local State = self._GamepadState or "SCROLL"
  if "MOVING" == State then
    self:SetFocus()
    return
  end
  if "FOCUS" == State then
    local FocusRecord = self._ConfirmedPlacedItems and self._ConfirmedPlacedItems[self._FocusIndex or 1]
    if not (FocusRecord and FocusRecord.Widget) or not self:_HasFocusOnWidget(FocusRecord.Widget) then
      self:_RestoreFocusStateFocus()
    end
    return
  end
  local bFocusOnBtnNone = self:_HasFocusOnWidget(self.Btn_None)
  if bFocusOnBtnNone then
    self:_RestoreScrollFocusBySelected(true)
    return
  end
  self:_RestoreScrollFocusBySelected()
end

function Component:_ScheduleRestoreGamepadFocusByState()
  local TimerKey = "BagGameRestoreFocusAfterInputSwitch"
  self:RemoveTimer(TimerKey)
  self:AddTimer(0.12, function()
    if self.CurInputDevice ~= UE4.ECommonInputType.Gamepad then
      return
    end
    self:_RestoreGamepadFocusByState()
  end, false, 0, TimerKey)
end

function Component:HandleGamepadInput(InKeyName)
  if InKeyName == Const.FaceButtonRight then
    local State = self._GamepadState or "SCROLL"
    if "MOVING" == State then
      self:_ExitMovingMode()
    elseif "FOCUS" == State then
      self:_ExitFocusState()
    else
      self:CloseSelf()
    end
    return true
  end
  if InKeyName == Const.FaceButtonTop then
    return self:_HandleRefreshInput()
  end
  local State = self._GamepadState or "SCROLL"
  if "SCROLL" == State then
    return self:_HandleScrollInput(InKeyName)
  elseif "MOVING" == State then
    return self:_HandleMovingInput(InKeyName)
  elseif "FOCUS" == State then
    return self:_HandleFocusInput(InKeyName)
  end
  return false
end

function Component:_HandleRefreshInput()
  if not self:CanReset() then
    return true
  end
  UIManager():ShowCommonPopupUI(100332, {
    RightCallbackFunction = function()
      self:ResetPlayArea()
      if self.CurInputDevice == UE4.ECommonInputType.Gamepad then
        self:AddTimer(0.1, function()
          if self.CurInputDevice ~= UE4.ECommonInputType.Gamepad then
            return
          end
          self._GamepadState = "SCROLL"
          self._GamepadSelectedContent = self.DisPlayItemDataList and self.DisPlayItemDataList[1] or nil
          self:_UpdateBottomKeyByState("SCROLL")
          self:_RestoreScrollFocusBySelected(true)
        end, nil, nil, nil, true)
      end
    end
  }, self)
  return true
end

function Component:_HandleScrollInput(InKeyName)
  if InKeyName == Const.FaceButtonBottom then
    local ContentData = self._GamepadSelectedContent
    if ContentData and 2 ~= ContentData.SwitchIndex and ContentData.ShapeOffsets and #ContentData.ShapeOffsets > 0 then
      self:_EnterMovingMode(ContentData)
    end
    return true
  end
  if InKeyName == Const.LeftThumb then
    if self._ConfirmedPlacedItems and #self._ConfirmedPlacedItems > 0 then
      self:_EnterFocusState()
    end
    return true
  end
  return false
end

function Component:_EnterMovingMode(ContentData)
  if self:HasUnconfirmedItem() then
    self:ShowCannotDragToast()
    return
  end
  local SyncData = {
    TemplateId = ContentData.TemplateId,
    ItemType = ContentData.ItemType,
    GUIPath = ContentData.GUIPath,
    CurrentAmmo = ContentData.CurrentAmmo or 0,
    MaxAmmo = ContentData.MaxAmmo or 0,
    CurrentStack = ContentData.CurrentStack or 0,
    MaxStack = ContentData.MaxStack or 0
  }
  local DragUI = UIManager(self):_CreateWidgetNew("BagGameDragUIItem")
  DragUI:InitAsDragUI(ContentData.DisPlayItemId or ContentData.TemplateId, ContentData.ShapeOffsets, SyncData)
  local Operation = {
    Tag = "BagGameDisPlayItem",
    DefaultDragVisual = DragUI,
    SourceDisPlayItemId = ContentData.DisPlayItemId or ContentData.TemplateId
  }
  self:SetDisPlayItemSwitchIndex(ContentData.DisPlayItemId, 1)
  self._GamepadMoveRow = 1
  self._GamepadMoveCol = 1
  self._GamepadDragUI = DragUI
  self._GamepadDragOperation = Operation
  self._GamepadDragSourceData = ContentData
  local ShapeOff = DragUI.ShapeOffsets or {
    {0, 0}
  }
  local RowRange, ColRange = self:_BuildGamepadScanRange(ShapeOff)
  local scanRowStart = RowRange and RowRange[1] or 1
  local scanRowEnd = RowRange and RowRange[2] or GRID_ROWS
  local scanColStart = ColRange and ColRange[1] or 1
  local scanColEnd = ColRange and ColRange[2] or GRID_COLS
  self._GamepadScanRowRange = {scanRowStart, scanRowEnd}
  self._GamepadScanColRange = {scanColStart, scanColEnd}
  local bSuccess = false
  local PlacedRow, PlacedCol = scanRowStart, scanColStart
  for row = scanRowStart, scanRowEnd do
    if bSuccess then
      break
    end
    for col = scanColStart, scanColEnd do
      self:ActivateShapeArea(row, col, DragUI)
      bSuccess = self:PlaceItemAtCell(row, col, DragUI, Operation)
      if bSuccess then
        PlacedRow, PlacedCol = row, col
        break
      end
    end
  end
  if bSuccess then
    self._GamepadMoveRow = PlacedRow
    self._GamepadMoveCol = PlacedCol
    self._GamepadMoveValid = true
    self._GamepadPlacedItem = self.CurrentUnconfirmedItem
    self._GamepadDragUI = nil
    self._GamepadDragOperation = nil
    self._GamepadState = "MOVING"
    self:_UpdateBottomKeyByState("MOVING")
    local InitialRecord = self.PlacedItems and self.PlacedItems[#self.PlacedItems]
    if InitialRecord and InitialRecord.Cells then
      self._GamepadVisualCells = InitialRecord.Cells
      self._GamepadLastDoubleReward = InitialRecord.IsDoubleReward
    end
  else
    self._GamepadMoveRow = scanRowStart
    self._GamepadMoveCol = scanColStart
    self:ActivateShapeArea(scanRowStart, scanColStart, DragUI)
    self:OnDragStateChanged(true)
    self._GamepadState = "MOVING"
    self:_UpdateBottomKeyByState("MOVING")
  end
  self:SetFocus()
end

function Component:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local State = self._GamepadState or "SCROLL"
  if "MOVING" ~= State and "FOCUS" ~= State then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_LeftX" == InKeyName then
    self._AnalogX = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  elseif "Gamepad_LeftY" == InKeyName then
    self._AnalogY = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  end
  local DirectionKey
  local ay = self._AnalogY or 0
  local ax = self._AnalogX or 0
  if ay > 0.5 then
    DirectionKey = "Gamepad_LeftStick_Up"
  elseif ay < -0.5 then
    DirectionKey = "Gamepad_LeftStick_Down"
  elseif ax > 0.5 then
    DirectionKey = "Gamepad_LeftStick_Right"
  elseif ax < -0.5 then
    DirectionKey = "Gamepad_LeftStick_Left"
  end
  if DirectionKey then
    if self._AnalogCdTimer then
      return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    self:_StartAnalogCdTimer()
    self:HandleGamepadInput(DirectionKey)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function Component:_StartAnalogCdTimer()
  self._AnalogCdTimer = self:AddTimer(0.15, function()
    self._AnalogCdTimer = nil
  end, nil, nil, nil, true)
end

function Component:_HandleMovingInput(InKeyName)
  local bItemPlaced = self._GamepadPlacedItem ~= nil
  local dRow, dCol = 0, 0
  if InKeyName == Const.LeftStickUp or InKeyName == Const.DPadUp then
    dRow = -1
  elseif InKeyName == Const.LeftStickDown or InKeyName == Const.DPadDown then
    dRow = 1
  elseif InKeyName == Const.LeftStickLeft or InKeyName == Const.DPadLeft then
    dCol = -1
  elseif InKeyName == Const.LeftStickRight or InKeyName == Const.DPadRight then
    dCol = 1
  end
  if 0 ~= dRow or 0 ~= dCol then
    if bItemPlaced then
      self:_MovePlacedItemByDelta(dRow, dCol)
    else
      local minRow = self._GamepadScanRowRange and self._GamepadScanRowRange[1] or 1
      local maxRow = self._GamepadScanRowRange and self._GamepadScanRowRange[2] or GRID_ROWS
      local minCol = self._GamepadScanColRange and self._GamepadScanColRange[1] or 1
      local maxCol = self._GamepadScanColRange and self._GamepadScanColRange[2] or GRID_COLS
      local newRow = math.max(minRow, math.min(maxRow, self._GamepadMoveRow + dRow))
      local newCol = math.max(minCol, math.min(maxCol, self._GamepadMoveCol + dCol))
      self._GamepadMoveRow, self._GamepadMoveCol = newRow, newCol
      self:ActivateShapeArea(newRow, newCol, self._GamepadDragUI)
    end
    return true
  end
  if InKeyName == Const.FaceButtonBottom then
    if bItemPlaced then
      if not self._GamepadMoveValid then
        self:ShowCannotDragToast()
        return true
      end
      self._GamepadVisualCells = nil
      self:ConfirmPlacedItem(self._GamepadPlacedItem)
      self._GamepadPlacedItem = nil
      self._GamepadDragSourceData = nil
      self._GamepadScanRowRange = nil
      self._GamepadScanColRange = nil
      self._GamepadLastDoubleReward = nil
      self._GamepadMoveValid = true
      self._GamepadState = "SCROLL"
      self:_UpdateBottomKeyByState("SCROLL")
      self:_RestoreScrollFocusToFirst()
    else
      local bSuccess = self:PlaceItemAtCell(self._GamepadMoveRow, self._GamepadMoveCol, self._GamepadDragUI, self._GamepadDragOperation)
      if bSuccess then
        self._GamepadPlacedItem = self.CurrentUnconfirmedItem
        self._GamepadDragUI = nil
        self._GamepadDragOperation = nil
      end
    end
    return true
  end
  if InKeyName == Const.LeftThumb then
    self:_ExitMovingMode()
    return true
  end
  if InKeyName == Const.RightThumb then
    if bItemPlaced then
      if self._GamepadPlacedItem.OnRotationBtnClicked then
        self._GamepadPlacedItem:OnRotationBtnClicked()
        local PlacedRecord = self:_GetPlacedRecord(self._GamepadPlacedItem)
        if PlacedRecord then
          self._GamepadMoveRow = PlacedRecord.BaseRow
          self._GamepadMoveCol = PlacedRecord.BaseCol
          self._GamepadMoveValid = true
          local OldVisualCells = self._GamepadVisualCells
          if OldVisualCells then
            local NewCellSet = {}
            for _, C in ipairs(PlacedRecord.Cells) do
              NewCellSet[C.Row * 100 + C.Col] = true
            end
            for _, C in ipairs(OldVisualCells) do
              if not NewCellSet[C.Row * 100 + C.Col] then
                local ContainItem = self:GetContainItemAt(C.Row, C.Col)
                if ContainItem and ContainItem.DeactivateHighlight then
                  ContainItem:DeactivateHighlight()
                end
              end
            end
          end
          self._GamepadVisualCells = PlacedRecord.Cells
          self._GamepadLastDoubleReward = PlacedRecord.IsDoubleReward
        end
      end
    elseif self._GamepadDragUI and self._GamepadDragUI.RotateShape90CW then
      self._GamepadDragUI.RotationCount = ((self._GamepadDragUI.RotationCount or 0) + 1) % 4
      self._GamepadDragUI:RotateShape90CW()
      self:ActivateShapeArea(self._GamepadMoveRow, self._GamepadMoveCol, self._GamepadDragUI)
    end
    return true
  end
  return false
end

function Component:_MovePlacedItemByDelta(dRow, dCol)
  local PlacedItem = self._GamepadPlacedItem
  if not PlacedItem then
    return false
  end
  local PlacedRecord
  for _, Record in ipairs(self.PlacedItems) do
    if Record.Widget == PlacedItem then
      PlacedRecord = Record
      break
    end
  end
  if not PlacedRecord then
    return false
  end
  local NewBaseRow = self._GamepadMoveRow + dRow
  local NewBaseCol = self._GamepadMoveCol + dCol
  local ShapeOffsets = {}
  for _, Cell in ipairs(PlacedRecord.Cells) do
    table.insert(ShapeOffsets, {
      dRow = Cell.Row - PlacedRecord.BaseRow,
      dCol = Cell.Col - PlacedRecord.BaseCol
    })
  end
  local NewCells = {}
  for _, Offset in ipairs(ShapeOffsets) do
    local NR = NewBaseRow + Offset.dRow
    local NC = NewBaseCol + Offset.dCol
    if NR < 1 or NR > GRID_ROWS or NC < 1 or NC > GRID_COLS then
      return false
    end
    table.insert(NewCells, {Row = NR, Col = NC})
  end
  local TLRow, TLCol = NewCells[1].Row, NewCells[1].Col
  for _, C in ipairs(NewCells) do
    if TLRow > C.Row then
      TLRow = C.Row
    end
    if TLCol > C.Col then
      TLCol = C.Col
    end
  end
  local TopLeftCell = self:GetContainItemAt(TLRow, TLCol)
  if not TopLeftCell then
    return false
  end
  PlacedItem:RemoveFromParent()
  self:MountItemToCell(PlacedItem, TopLeftCell, false)
  self:_PromoteItemToCanvasPanel(PlacedItem, TopLeftCell, 300)
  local NewCellSet = {}
  for _, C in ipairs(NewCells) do
    NewCellSet[C.Row * 100 + C.Col] = true
  end
  if self._GamepadVisualCells then
    for _, C in ipairs(self._GamepadVisualCells) do
      if not NewCellSet[C.Row * 100 + C.Col] then
        local ContainItem = self:GetContainItemAt(C.Row, C.Col)
        if ContainItem and ContainItem.DeactivateHighlight then
          ContainItem:DeactivateHighlight()
        end
      end
    end
  end
  self._GamepadMoveRow = NewBaseRow
  self._GamepadMoveCol = NewBaseCol
  for _, Cell in ipairs(PlacedRecord.Cells) do
    BagGameModel:ClearCellOccupied(Cell.Row, Cell.Col)
    local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
    if ContainItem then
      ContainItem.bIsOccupied = false
      ContainItem.OccupiedBy = nil
    end
  end
  if self:_TryAutoTrigger(PlacedItem, PlacedRecord, NewCells) then
    return true
  end
  local bValid = self:CanPlaceShapeAt(NewBaseRow, NewBaseCol, NewCells)
  if bValid then
    for _, Cell in ipairs(NewCells) do
      local Value = BagGameModel:GetGridValue(Cell.Row, Cell.Col)
      if Value == BagGameModel.VALUE_UNCLICKABLE then
        bValid = false
        break
      end
    end
  end
  if bValid then
    for _, Cell in ipairs(NewCells) do
      self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
    end
    PlacedRecord.Cells = NewCells
    PlacedRecord.BaseRow = NewBaseRow
    PlacedRecord.BaseCol = NewBaseCol
    self._GamepadMoveValid = true
  else
    for _, Cell in ipairs(PlacedRecord.Cells) do
      self:MarkCellOccupied(Cell.Row, Cell.Col, PlacedItem)
    end
    self._GamepadMoveValid = false
  end
  self:RefreshPlacedItemDoubleState()
  self:UpdateScoreDisplay()
  self._GamepadVisualCells = NewCells
  for _, Cell in ipairs(NewCells) do
    local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
    if ContainItem then
      ContainItem:ActivateHighlight(bValid)
    end
  end
  return true
end

function Component:_GetPlacedRecord(PlacedItem)
  if not PlacedItem or not self.PlacedItems then
    return nil
  end
  for _, Record in ipairs(self.PlacedItems) do
    if Record.Widget == PlacedItem then
      return Record
    end
  end
  return nil
end

function Component:_ClearGamepadVisualCells()
  if not self._GamepadVisualCells then
    return
  end
  for _, Cell in ipairs(self._GamepadVisualCells) do
    local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
    if ContainItem and ContainItem.DeactivateHighlight then
      ContainItem:DeactivateHighlight()
    end
  end
  self._GamepadVisualCells = nil
end

function Component:_PlayGamepadVisualCells(NewCells, bValid, PlacedRecord)
  self._GamepadVisualCells = NewCells
  for _, Cell in ipairs(NewCells) do
    local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
    if ContainItem then
      if bValid then
        ContainItem:ActivateHighlight(true)
      else
        ContainItem:ActivateHighlight(false)
      end
    end
  end
end

function Component:_EnterFocusState()
  self._GamepadState = "FOCUS"
  self._FocusIndex = 1
  self:_UpdateBottomKeyByState("FOCUS")
  self:SetFocus()
  self:_UpdateFocusHighlight(nil, self._ConfirmedPlacedItems[1])
  DebugPrint("GamepadComp: 进入 FOCUS 态，物品数=" .. #self._ConfirmedPlacedItems)
end

function Component:_ExitFocusState()
  local FocusRecord = self._ConfirmedPlacedItems and self._ConfirmedPlacedItems[self._FocusIndex]
  if FocusRecord and FocusRecord.Widget then
    FocusRecord.Widget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Escape)
    FocusRecord.Widget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Escape)
    FocusRecord.Widget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Escape)
    FocusRecord.Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Escape)
  end
  self._GamepadState = "SCROLL"
  self:_UpdateBottomKeyByState("SCROLL")
  self._FocusIndex = 1
  self:_RestoreScrollFocus()
  DebugPrint("GamepadComp: 退出 FOCUS 态，回到 SCROLL")
end

function Component:_HandleFocusInput(InKeyName)
  if InKeyName == Const.FaceButtonBottom then
    self:_EnterMovingFromFocus()
    return true
  end
  local dIdx = 0
  if InKeyName == Const.LeftStickRight or InKeyName == Const.DPadRight or InKeyName == Const.LeftStickDown or InKeyName == Const.DPadDown then
    dIdx = 1
  elseif InKeyName == Const.LeftStickLeft or InKeyName == Const.DPadLeft or InKeyName == Const.LeftStickUp or InKeyName == Const.DPadUp then
    dIdx = -1
  end
  if 0 ~= dIdx then
    self:_SwitchFocusIndex(dIdx)
    return true
  end
  return true
end

function Component:_SwitchFocusIndex(dIdx)
  local Count = self._ConfirmedPlacedItems and #self._ConfirmedPlacedItems or 0
  if Count <= 1 then
    return
  end
  local OldRecord = self._ConfirmedPlacedItems[self._FocusIndex]
  self._FocusIndex = (self._FocusIndex - 1 + dIdx + Count) % Count + 1
  local NewRecord = self._ConfirmedPlacedItems[self._FocusIndex]
  self:_UpdateFocusHighlight(OldRecord, NewRecord)
end

function Component:_UpdateFocusHighlight(OldRecord, NewRecord)
  if NewRecord and NewRecord.Cells then
    for _, Cell in ipairs(NewRecord.Cells) do
      local ContainItem = self:GetContainItemAt(Cell.Row, Cell.Col)
      if ContainItem then
        ContainItem:PlayPutFlash()
      end
    end
    if NewRecord.Widget then
      NewRecord.Widget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
      NewRecord.Widget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
      NewRecord.Widget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
      NewRecord.Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
      NewRecord.Widget:SetFocus()
    end
  end
end

function Component:_EnterMovingFromFocus()
  local FocusRecord = self._ConfirmedPlacedItems and self._ConfirmedPlacedItems[self._FocusIndex]
  if not FocusRecord or not FocusRecord.Widget then
    self:_ExitFocusState()
    return
  end
  local PlacedItem = FocusRecord.Widget
  PlacedItem:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Escape)
  PlacedItem:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Escape)
  PlacedItem:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Escape)
  PlacedItem:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Escape)
  local bSuccess = self:UnconfirmPlacedItem(PlacedItem)
  if not bSuccess then
    ScreenPrint("GamepadComp: FOCUS→MOVING，恢复物品失败")
    self:_ExitFocusState()
    return
  end
  self._GamepadPlacedItem = PlacedItem
  self._GamepadMoveRow = FocusRecord.BaseRow
  self._GamepadMoveCol = FocusRecord.BaseCol
  self._GamepadMoveValid = true
  self._GamepadDragSourceData = nil
  self._GamepadScanRowRange = nil
  self._GamepadScanColRange = nil
  if PlacedItem.ShapeOffsets then
    self._GamepadScanRowRange, self._GamepadScanColRange = self:_BuildGamepadScanRange(PlacedItem.ShapeOffsets)
  end
  if FocusRecord.Cells then
    self._GamepadVisualCells = FocusRecord.Cells
    self._GamepadLastDoubleReward = FocusRecord.IsDoubleReward
    self:_PlayGamepadVisualCells(FocusRecord.Cells, true, FocusRecord)
  end
  self._FocusIndex = 1
  self._GamepadState = "MOVING"
  self:_UpdateBottomKeyByState("MOVING")
  self:SetFocus()
  self:AddTimer(0.05, function()
    if self._GamepadState == "MOVING" and self.CurInputDevice == UE4.ECommonInputType.Gamepad then
      self:SetFocus()
    end
  end, nil, nil, nil, true)
  DebugPrint("GamepadComp: FOCUS→MOVING，恢复物品 DisPlayItemId=" .. tostring(PlacedItem.DisPlayItemId))
end

function Component:_ExitMovingMode()
  self:_ClearGamepadVisualCells()
  if self._GamepadPlacedItem then
    self:RecycleItem(self._GamepadPlacedItem)
    self._GamepadPlacedItem = nil
  else
    self:DeactivateShapeArea()
    self:OnDragStateChanged(false)
    if self._GamepadDragSourceData then
      self:SetDisPlayItemSwitchIndex(self._GamepadDragSourceData.DisPlayItemId, 0)
    end
  end
  self._GamepadDragUI = nil
  self._GamepadDragOperation = nil
  self._GamepadDragSourceData = nil
  self._GamepadScanRowRange = nil
  self._GamepadScanColRange = nil
  self._GamepadLastDoubleReward = nil
  self._GamepadState = "SCROLL"
  self:_UpdateBottomKeyByState("SCROLL")
  self:_RestoreScrollFocus()
end

function Component:_RestoreScrollFocus()
  self:_RestoreScrollFocusBySelected()
end

function Component:_RestoreScrollFocusToFirst()
  self:_RestoreScrollFocusBySelected(true)
end

function Component:_TryAutoTrigger(PlacedItem, PlacedRecord, NewCells)
  local ItemType = BagGameModel.ItemType
  local bTriggered = false
  if PlacedItem.ItemType == ItemType.Other then
    local TargetRecord, bCanStack = BagGameModel:FindOverlappingSameOther(PlacedItem.TemplateId, NewCells)
    if TargetRecord and bCanStack and TargetRecord.Widget ~= PlacedItem then
      local bSuccess = self:ConsumeGamepadStackItem(PlacedItem, PlacedRecord, TargetRecord, true)
      if bSuccess then
        bTriggered = true
      end
    end
  elseif PlacedItem.ItemType == ItemType.Ammo then
    local GunRecord, bCanLoad = BagGameModel:FindOverlappingGun(NewCells)
    if GunRecord and bCanLoad then
      local bSuccess = self:ConsumeGamepadAmmoItem(PlacedItem, PlacedRecord, GunRecord, true)
      if bSuccess then
        bTriggered = true
      end
    end
  end
  if bTriggered then
    self:_ClearGamepadVisualCells()
    self._GamepadPlacedItem = nil
    self._GamepadDragUI = nil
    self._GamepadDragOperation = nil
    self._GamepadDragSourceData = nil
    self._GamepadScanRowRange = nil
    self._GamepadScanColRange = nil
    self._GamepadLastDoubleReward = nil
    self._GamepadMoveValid = false
    self._GamepadState = "SCROLL"
    self:_UpdateBottomKeyByState("SCROLL")
    self:_RestoreScrollFocus()
    return true
  end
  return false
end

return Component
