require("UnLua")
local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local ItemType = BagGameModel.ItemType
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.UI.WBP.Activity.Widget.BagGame.Activity_BagGame_DragComponent"
})

local function GetFrameCount()
  return UKismetSystemLibrary.GetFrameCount() or 0
end

local function IsTempPlacementRedragBlocked(ItemWidget)
  if not ItemWidget or not ItemWidget.IsTempPlacement then
    return false
  end
  local EnableFrame = ItemWidget.TempPlacementDragEnableFrame
  if not EnableFrame then
    return false
  end
  return EnableFrame > GetFrameCount()
end

function M:Construct()
  self.Image_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Overlay_Double:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Stop.OnClicked:Add(self, self.OnStopBtnClicked)
  self.Btn_Rotation.OnClicked:Add(self, self.OnRotationBtnClicked)
  self.Btn_Check.OnClicked:Add(self, self.OnCheckBtnClicked)
  if self.Btn_Recover then
    self.Btn_Recover.OnClicked:Add(self, self.OnRecoverBtnClicked)
    self.Btn_Recover:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:InitSingleGamePadKey()
  self:InitListenEvent()
  self:RefreshBaseInfo()
  self.bIsConfirmed = false
  self.bIsPlaced = false
  self.bIsInDoubleReward = false
  self.Text_Double:SetText(GText("UI_GameEvent_BagGame_Toast_DoubleScore"))
end

function M:SetItemIconByPath(GUIPath)
  if not self.Image_Icon or type(GUIPath) ~= "string" or "" == GUIPath then
    return
  end
  local IconObj = LoadObject(GUIPath)
  if not IconObj then
    return
  end
  self.Image_Icon:SetBrushResourceObject(IconObj)
  if IconObj.SourceDimension then
    self.Image_Icon:SetBrushSize(IconObj.SourceDimension)
  elseif IconObj.Blueprint_GetSizeX and IconObj.Blueprint_GetSizeY then
    local textureSize = UE4.FVector2D(IconObj:Blueprint_GetSizeX(), IconObj:Blueprint_GetSizeY())
    self.Image_Icon:SetBrushSize(textureSize)
  end
end

function M:SetIconMirror(IsMirror)
  if not self.Image_Icon then
    return
  end
  local ScaleX = IsMirror and -1 or 1
  self.Image_Icon:SetRenderScale(FVector2D(ScaleX, 1))
end

function M:OnStopBtnClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  if self.PlayScreen and self.PlayScreen.RecycleItem then
    self.PlayScreen:RecycleItem(self)
  else
    DebugPrint("OnStopBtnClicked: PlayScreen 引用无效")
  end
end

function M:OnRotationBtnClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  if not self.ShapeOffsets or 0 == #self.ShapeOffsets then
    return
  end
  self.RotationCount = ((self.RotationCount or 0) + 1) % 4
  self:RotateShape90CW()
  if self.PlayScreen and self.PlayScreen.RotatePlacedItem then
    self.PlayScreen:RotatePlacedItem(self)
  end
  DebugPrint("OnRotationBtnClicked: 旋转次数=" .. self.RotationCount)
end

function M:RotateShape90CW()
  local NewOffsets = self:CalculateRotatedOffsets(self.RotationCount or 0)
  self.ShapeOffsets = NewOffsets
  if self.SetItemSize then
    self:SetItemSize()
  end
  self:UpdateVisualRotation()
end

function M:NormalizeOffsets(Offsets)
  if not Offsets or 0 == #Offsets then
    return {
      {0, 0}
    }
  end
  local MinRow, MinCol = Offsets[1][1], Offsets[1][2]
  for _, Offset in ipairs(Offsets) do
    MinRow = math.min(MinRow, Offset[1])
    MinCol = math.min(MinCol, Offset[2])
  end
  local Normalized = {}
  for _, Offset in ipairs(Offsets) do
    table.insert(Normalized, {
      Offset[1] - MinRow,
      Offset[2] - MinCol
    })
  end
  return Normalized
end

function M:CalculateRotatedOffsets(RotCount)
  if not self.OriginalShapeOffsets then
    return self.ShapeOffsets or {
      {0, 0}
    }, 1, 1
  end
  local S = self.FrameSize
  local CurRows = self.OriginalRows
  local CurCols = self.OriginalCols
  local Rotated = {}
  for _, Off in ipairs(self.OriginalShapeOffsets) do
    local R, C = Off[1], Off[2]
    local StepRows = CurRows
    for _ = 1, RotCount do
      R, C = C, StepRows - 1 - R
      StepRows = CurCols
      CurRows, CurCols = CurCols, CurRows
    end
    table.insert(Rotated, {R, C})
    CurRows = self.OriginalRows
    CurCols = self.OriginalCols
  end
  if 1 == RotCount % 2 then
    CurRows = self.OriginalCols
    CurCols = self.OriginalRows
  else
    CurRows = self.OriginalRows
    CurCols = self.OriginalCols
  end
  Rotated = self:NormalizeOffsets(Rotated)
  local RowShift, ColShift = 0, 0
  if 0 == RotCount then
  elseif 1 == RotCount then
  elseif 2 == RotCount then
    ColShift = S - CurCols
  elseif 3 == RotCount then
    RowShift = S - CurRows
  end
  if 0 ~= RowShift or 0 ~= ColShift then
    for i, Off in ipairs(Rotated) do
      Rotated[i] = {
        Off[1] + RowShift,
        Off[2] + ColShift
      }
    end
  end
  return Rotated, CurRows, CurCols
end

function M:GetAlignShift(RotCount)
  if not self.OriginalShapeOffsets then
    return 0, 0
  end
  local S = self.FrameSize
  local CurRows, CurCols
  if 1 == RotCount % 2 then
    CurRows = self.OriginalCols
    CurCols = self.OriginalRows
  else
    CurRows = self.OriginalRows
    CurCols = self.OriginalCols
  end
  if 2 == RotCount then
    return 0, S - CurCols
  elseif 3 == RotCount then
    return S - CurRows, 0
  end
  return 0, 0
end

function M:UpdateVisualRotation()
  local Angle = (self.RotationCount or 0) * 90
  if self.Main then
    self.Main:SetRenderTransformAngle(0)
  end
  if self.Image_Icon then
    self.Image_Icon:SetRenderTransformAngle(Angle)
  end
end

function M:OnCheckBtnClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  if self.PlayScreen and self.PlayScreen.ConfirmPlacedItem then
    self.PlayScreen:ConfirmPlacedItem(self)
  else
    self:PlayAnimation(self.Btn_Out)
  end
end

function M:OnRecoverBtnClicked()
  if self.PlayScreen and self.PlayScreen.UnconfirmPlacedItem then
    self.PlayScreen:UnconfirmPlacedItem(self)
  end
end

function M:ShowRecoverBtn()
  if self.Btn_Recover then
    self.Btn_Recover:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:HideRecoverBtn()
  if self.Btn_Recover then
    self.Btn_Recover:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
  if MouseButton.KeyName == "LeftMouseButton" then
    if IsTempPlacementRedragBlocked(self) then
      return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    local Reply = UE4.UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, UE.EKeys.LeftMouseButton)
    return Reply
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnDragDetected(MyGeometry, PointerEvent)
  if IsTempPlacementRedragBlocked(self) then
    self._bDragDetected = false
    return
  end
  self._bDragDetected = true
  local SavedDisPlayItemId = self.DisPlayItemId
  local SavedShapeOffsets = self.ShapeOffsets
  if self.PlayScreen and self.PlayScreen.PickUpPlacedItem then
    local bSuccess = self.PlayScreen:PickUpPlacedItem(self)
    if not bSuccess then
      if not self.PlayScreen.HasUnconfirmedItem or not self.PlayScreen:HasUnconfirmedItem() then
        self._bDragDetected = false
      end
      return
    end
  end
  local SavedPlayScreen = self.PlayScreen
  local DragDropOperation = self:OnDragDetectedComponent(MyGeometry, PointerEvent, SavedDisPlayItemId, SavedShapeOffsets)
  if not DragDropOperation then
    return
  end
  local DragStartFrame = GetFrameCount()
  DragDropOperation.DragStartFrame = DragStartFrame
  local NewDragUI = DragDropOperation.DefaultDragVisual
  if NewDragUI then
    NewDragUI.DragStartFrame = DragStartFrame
    NewDragUI._DragSourceScreen = SavedPlayScreen
    NewDragUI._DragSourceItemId = SavedDisPlayItemId
    NewDragUI._DragDropOperation = DragDropOperation
  end
  DragDropOperation.SourcePlacedItemRestoreSnapshot = self._SameFrameReleaseSnapshot
  if NewDragUI and NewDragUI.SetCallbacks then
    NewDragUI:SetCallbacks({
      OnDragCancelCallback = function(_, PointerEvent, Operation)
        if SavedPlayScreen then
          if SavedPlayScreen.TryHandleSameFrameDragRelease and SavedPlayScreen:TryHandleSameFrameDragRelease(Operation, NewDragUI) then
            return
          end
          if SavedPlayScreen.HandleCancelledDragReturnToList then
            SavedPlayScreen:HandleCancelledDragReturnToList(Operation, NewDragUI, SavedDisPlayItemId)
          elseif SavedDisPlayItemId then
            SavedPlayScreen:SetDisPlayItemSwitchIndex(SavedDisPlayItemId, 0)
            if SavedPlayScreen.ForceExitDragState then
              SavedPlayScreen:ForceExitDragState()
            else
              SavedPlayScreen:DeactivateShapeArea()
              SavedPlayScreen:OnDragStateChanged(false)
            end
          end
        end
      end
    })
  end
  self:RemoveFromParent()
  return DragDropOperation
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
  if MouseButton.KeyName == "LeftMouseButton" then
    if self.bIsConfirmed and not self._bDragDetected and self.PlayScreen and self.PlayScreen.UnconfirmPlacedItem then
      self.PlayScreen:UnconfirmPlacedItem(self)
    end
    self._bDragDetected = false
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:SetShape(ShapeOffsets)
  self.ShapeOffsets = ShapeOffsets or {
    {0, 0}
  }
  if not self.OriginalShapeOffsets then
    self.OriginalShapeOffsets = {}
    for _, Off in ipairs(self.ShapeOffsets) do
      table.insert(self.OriginalShapeOffsets, {
        Off[1],
        Off[2]
      })
    end
    local MinR, MaxR, MinC, MaxC = 0, 0, 0, 0
    for _, Off in ipairs(self.OriginalShapeOffsets) do
      MinR = math.min(MinR, Off[1])
      MaxR = math.max(MaxR, Off[1])
      MinC = math.min(MinC, Off[2])
      MaxC = math.max(MaxC, Off[2])
    end
    self.OriginalRows = MaxR - MinR + 1
    self.OriginalCols = MaxC - MinC + 1
    self.FrameSize = math.max(self.OriginalRows, self.OriginalCols)
  end
end

function M:GetShape()
  return self.ShapeOffsets
end

function M:GetShapeCells(BaseRow, BaseCol)
  local Cells = {}
  local MinRow, MinCol = 0, 0
  local MaxRow, MaxCol = 0, 0
  if self.ShapeOffsets and #self.ShapeOffsets > 0 then
    MinRow = self.ShapeOffsets[1][1] or 0
    MinCol = self.ShapeOffsets[1][2] or 0
    MaxRow = MinRow
    MaxCol = MinCol
    for _, Offset in ipairs(self.ShapeOffsets) do
      local Row = Offset[1] or 0
      local Col = Offset[2] or 0
      MinRow = math.min(MinRow, Row)
      MinCol = math.min(MinCol, Col)
      MaxRow = math.max(MaxRow, Row)
      MaxCol = math.max(MaxCol, Col)
    end
  end
  local Rows = math.max(1, MaxRow - MinRow + 1)
  local Cols = math.max(1, MaxCol - MinCol + 1)
  local CenterRowOffset = MinRow + math.floor((Rows - 1) / 2)
  local CenterColOffset = MinCol + math.floor((Cols - 1) / 2)
  for _, Offset in ipairs(self.ShapeOffsets) do
    local Row = BaseRow + ((Offset[1] or 0) - CenterRowOffset)
    local Col = BaseCol + ((Offset[2] or 0) - CenterColOffset)
    table.insert(Cells, {Row = Row, Col = Col})
  end
  return Cells
end

function M:Destruct()
  if self.bIsRuntimeDragVisual and not self._BagGameDragHandled then
    local FallbackScreen = self._DragSourceScreen or self.PlayScreen
    if FallbackScreen and FallbackScreen.HandleCancelledDragReturnToList then
      local FallbackOperation = self._DragDropOperation
      local FallbackItemId = self._DragSourceItemId or self.DisPlayItemId
      FallbackScreen:HandleCancelledDragReturnToList(FallbackOperation, self, FallbackItemId)
    end
  end
  self.Btn_Stop.OnClicked:Remove(self, self.OnStopBtnClicked)
  self.Btn_Rotation.OnClicked:Remove(self, self.OnRotationBtnClicked)
  self.Btn_Check.OnClicked:Remove(self, self.OnCheckBtnClicked)
  if self.Btn_Recover then
    self.Btn_Recover.OnClicked:Remove(self, self.OnRecoverBtnClicked)
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

local function IsWidgetShown(Widget)
  if not Widget or not Widget.GetVisibility then
    return false
  end
  local Visibility = Widget:GetVisibility()
  return Visibility ~= UIConst.VisibilityOp.Collapsed and Visibility ~= UIConst.VisibilityOp.Hidden
end

function M:InitSingleGamePadKey()
  if self.KeyStop then
    self.KeyStop:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      }
    })
  end
  if self.KeyRotation then
    self.KeyRotation:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RS"}
      }
    })
  end
  if self.KeyCheck then
    self.KeyCheck:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      }
    })
  end
end

function M:InitListenEvent()
  local PlayerController = self:GetOwningPlayer()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshBaseInfo()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurGamepadName = CurGamepadName
  self.CurInputDevice = CurInputDevice
  local IsUseGamepad = CurInputDevice == ECommonInputType.Gamepad
  if IsUseGamepad then
    if self.KeyStop then
      self.KeyStop:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.KeyRotation then
      self.KeyRotation:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.KeyCheck then
      self.KeyCheck:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  else
    if self.KeyStop then
      self.KeyStop:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.KeyRotation then
      self.KeyRotation:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.KeyCheck then
      self.KeyCheck:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:IsStopKeyVisible()
  if self.bIsConfirmed or self.CurInputDevice ~= ECommonInputType.Gamepad then
    return false
  end
  return IsWidgetShown(self.Btn_Stop) and IsWidgetShown(self.KeyStop)
end

function M:SetItemSize()
  if not self.Image_bg then
    return
  end
  local Rows, Cols = 1, 1
  if self.ShapeOffsets and #self.ShapeOffsets > 0 then
    local MinRow, MaxRow = self.ShapeOffsets[1][1] or 0, self.ShapeOffsets[1][1] or 0
    local MinCol, MaxCol = self.ShapeOffsets[1][2] or 0, self.ShapeOffsets[1][2] or 0
    for _, Offset in ipairs(self.ShapeOffsets) do
      local Row = Offset[1] or 0
      local Col = Offset[2] or 0
      MinRow = math.min(MinRow, Row)
      MaxRow = math.max(MaxRow, Row)
      MinCol = math.min(MinCol, Col)
      MaxCol = math.max(MaxCol, Col)
    end
    Rows = math.max(1, MaxRow - MinRow + 1)
    Cols = math.max(1, MaxCol - MinCol + 1)
  end
  local SizeKey = "Size" .. tostring(Cols) .. tostring(Rows)
  local TargetSize = self[SizeKey]
  if not TargetSize and self.Size11 then
    TargetSize = FVector2D(self.Size11.X * Cols, self.Size11.Y * Rows)
  end
  if TargetSize then
    local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Main)
    if CanvasSlot then
      local Anchors = CanvasSlot:GetAnchors()
      local BaseSize = CanvasSlot:GetSize()
      if BaseSize and BaseSize.X > 0 and BaseSize.Y > 0 then
        local ScaleX = TargetSize.X / BaseSize.X * 0.75
        local ScaleY = TargetSize.Y / BaseSize.Y * 0.75
        CanvasSlot:SetSize(FVector2D(BaseSize.X * ScaleX, BaseSize.Y * ScaleY))
      end
    end
  end
end

function M:SetStackNumber(StackNum)
  self.StackNumber = StackNum or 0
  self.CurrentStack = self.StackNumber
  self.DragSyncData = self.DragSyncData or {}
  self.DragSyncData.CurrentStack = self.CurrentStack
  if self.Text_Lable then
    if self.bIsOtherType then
      self.Text_Lable:SetText("x" .. tostring(self.StackNumber))
    else
      self.Text_Lable:SetText(self.StackNumber)
    end
  end
end

function M:SetAmmoNumber(CurrentNum, MaxNum)
  self.CurrentNum = CurrentNum or 0
  self.MaxNum = MaxNum or 0
  self.CurrentAmmo = self.CurrentNum
  self.MaxAmmo = self.MaxNum
  self.DragSyncData = self.DragSyncData or {}
  self.DragSyncData.CurrentAmmo = self.CurrentAmmo
  self.DragSyncData.MaxAmmo = self.MaxAmmo
  if self.Text_Lable then
    if self.MaxNum > 0 then
      self.Text_Lable:SetText(self.CurrentNum .. "/" .. self.MaxNum)
    else
      self.Text_Lable:SetText(self.CurrentNum)
    end
  end
end

function M:ApplyDragSyncData(SyncData)
  if not SyncData then
    return
  end
  self.TemplateId = SyncData.TemplateId or self.TemplateId
  self.ItemType = SyncData.ItemType
  self.GUIPath = SyncData.GUIPath
  self.bIsOtherType = self.ItemType == ItemType.Other
  self.IsMirror = SyncData.IsMirror or false
  self.DragSyncData = {
    TemplateId = SyncData.TemplateId,
    ItemType = SyncData.ItemType,
    GUIPath = SyncData.GUIPath,
    CurrentAmmo = SyncData.CurrentAmmo or 0,
    MaxAmmo = SyncData.MaxAmmo or 0,
    CurrentStack = SyncData.CurrentStack or 0,
    MaxStack = SyncData.MaxStack or 0
  }
  self:SetItemIconByPath(self.GUIPath)
  self:SetIconMirror(self.IsMirror)
  if self.Img_Icon then
    if self.bIsOtherType then
      self.Img_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Img_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
  if self.ItemType == ItemType.Gun then
    self:SetAmmoNumber(SyncData.CurrentAmmo or 0, SyncData.MaxAmmo or 0)
  else
    self:SetStackNumber(SyncData.CurrentStack or 0)
  end
  if SyncData.OriginalShapeOffsets then
    self.OriginalShapeOffsets = {}
    for _, Off in ipairs(SyncData.OriginalShapeOffsets) do
      table.insert(self.OriginalShapeOffsets, {
        Off[1],
        Off[2]
      })
    end
    self.OriginalRows = SyncData.OriginalRows
    self.OriginalCols = SyncData.OriginalCols
    self.FrameSize = SyncData.FrameSize
  end
  if SyncData.RotationCount then
    self.RotationCount = SyncData.RotationCount
    if self.SetItemSize then
      self:SetItemSize()
    end
    self:UpdateVisualRotation()
  end
end

function M:GetDragSyncData()
  local Data
  if self.DragSyncData then
    Data = {
      TemplateId = self.DragSyncData.TemplateId or self.TemplateId,
      ItemType = self.DragSyncData.ItemType or self.ItemType,
      GUIPath = self.DragSyncData.GUIPath or self.GUIPath,
      CurrentAmmo = self.DragSyncData.CurrentAmmo or self.CurrentAmmo or self.CurrentNum or 0,
      MaxAmmo = self.DragSyncData.MaxAmmo or self.MaxAmmo or self.MaxNum or 0,
      CurrentStack = self.DragSyncData.CurrentStack or self.CurrentStack or self.StackNumber or 0,
      MaxStack = self.DragSyncData.MaxStack or 0,
      IsMirror = self.DragSyncData.IsMirror or self.IsMirror or false
    }
  elseif self.ItemType then
    Data = {
      TemplateId = self.TemplateId,
      ItemType = self.ItemType,
      GUIPath = self.GUIPath,
      CurrentAmmo = self.CurrentAmmo or self.CurrentNum or 0,
      MaxAmmo = self.MaxAmmo or self.MaxNum or 0,
      CurrentStack = self.CurrentStack or self.StackNumber or 0,
      MaxStack = self.MaxStack or 0,
      IsMirror = self.IsMirror or false
    }
  else
    return nil
  end
  Data.OriginalShapeOffsets = self.OriginalShapeOffsets
  Data.OriginalRows = self.OriginalRows
  Data.OriginalCols = self.OriginalCols
  Data.FrameSize = self.FrameSize
  Data.RotationCount = self.RotationCount or 0
  return Data
end

function M:UpdateAmmoDisplay(CurrentAmmo)
  local MaxAmmo = self.MaxAmmo or self.MaxNum or 0
  self:SetAmmoNumber(CurrentAmmo or 0, MaxAmmo)
end

function M:UpdateStackDisplay(CurrentStack, MaxStack)
  self.MaxStack = MaxStack or self.MaxStack or 0
  if self.DragSyncData then
    self.DragSyncData.MaxStack = self.MaxStack
  end
  self:SetStackNumber(CurrentStack or 0)
end

function M:SyncDoubleRewardVisual(IsInDoubleReward)
  local bNewState = true == IsInDoubleReward
  self.bIsInDoubleReward = bNewState
  if not self.Overlay_Double then
    return
  end
  if bNewState then
    self.Overlay_Double:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Overlay_Double:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetDoubleRewardState(IsInDoubleReward)
  local bNewState = true == IsInDoubleReward
  if self.bIsInDoubleReward == bNewState then
    return
  end
  if bNewState then
    self:SyncDoubleRewardVisual(true)
    if self.Double_In then
      self:PlayAnimation(self.Double_In)
    end
  else
    self.bIsInDoubleReward = false
    if self.Double_Out then
      self:PlayAnimation(self.Double_Out)
    elseif self.Overlay_Double then
      self.Overlay_Double:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.PlayScreen and self.PlayScreen._GamepadState == "FOCUS" then
    self.PlayScreen:HandleGamepadInput(InKeyName)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
