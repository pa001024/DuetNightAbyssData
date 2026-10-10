require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
local DEFAULT_MIN_SCALE = 0.3
local DEFAULT_MAX_SCALE = 3.0
local DEFAULT_STICKER_ITEM_SIZE = 245
local BORDER_SCALE_PX = 22
local DEFAULT_TRANSFORM_EPSILON = 0.01
local GAMEPAD_MOVE_DEAD_ZONE = 0.25
local GAMEPAD_MOVE_SPEED = 10
local GAMEPAD_SCALE_STEP = 0.05
local GAMEPAD_SCALE_REPEAT_INTERVAL = 0.05
local GAMEPAD_SCALE_REPEAT_TIMER_KEY = "StickerGamepadScaleRepeat"
local LEFT_STICK_X_KEY_NAME = "Gamepad_LeftX"
local LEFT_STICK_Y_KEY_NAME = "Gamepad_LeftY"
local STICKER_CANVAS_OVERFLOW_RATIO = 0.5

function M:Initialize(Initializer)
  self.StickerViewData = nil
  self.HostPage = nil
  self.bDraggingSticker = false
  self.bScalingSticker = false
  self.LastMousePos = nil
  self.bDragEventsBound = false
  self.StickerScale = 1
  self.ScaleStartScale = 1
  self.ScaleStartMousePos = nil
  self.ScaleEdge = nil
  self.bDisplayMode = false
  self.InitialTransformSnapshot = nil
  self.BaseStickerItemSize = DEFAULT_STICKER_ITEM_SIZE
  self.bStickerTransformPreviewActive = false
  self.GamepadMoveAxisX = 0
  self.GamepadMoveAxisY = 0
  self.bGamepadMovingSticker = false
  self.bGamepadScalingSticker = false
  self.bGamepadScaleRepeatActive = false
  self.PredictedIconBoundsInCanvas = nil
  self.GamepadScaleHoldIncrease = nil
  self.bGamepadKeyTipsListen = false
  self.AppliedStickerCursor = nil
end

function M:InitStickerEdit(StickerViewData, HostPage)
  self.HostPage = HostPage
  self.bDisplayMode = false
  self.AppliedStickerCursor = nil
  self:_CacheBaseStickerItemSize()
  self:_EnsureDragEventsBound()
  if self.ScaleBox_Icon and self.ScaleBox_Icon.SetRenderScale then
    self.ScaleBox_Icon:SetRenderScale(FVector2D(1, 1))
  end
  self:SetDisplayMode(false)
  self:RefreshStickerEdit(StickerViewData)
  self:_ApplyInitTransformFromWorkingData(StickerViewData)
  self:CaptureInitialTransformSnapshot()
  self:_NotifyHostTransformChanged()
  self:_EnsureGamepadKeyTipsListen()
  self:_RefreshGamepadKeyTips()
end

function M:InitStickerDisplay(StickerData, HostPage)
  self.HostPage = HostPage
  self.bDisplayMode = true
  self.AppliedStickerCursor = nil
  self:_CacheBaseStickerItemSize()
  if self.ScaleBox_Icon and self.ScaleBox_Icon.SetRenderScale then
    self.ScaleBox_Icon:SetRenderScale(FVector2D(1, 1))
  end
  self:RefreshStickerEdit(StickerData)
  local PosX = StickerData and StickerData.PosX or 0
  local PosY = StickerData and StickerData.PosY or 0
  local Scale = StickerData and StickerData.Scale or 1
  self:ApplyStickerTransform(PosX, PosY, Scale)
  self:SetDisplayMode(true)
  self:_EnsureDragEventsBound()
  self:_EnsureGamepadKeyTipsListen()
  self:_RefreshGamepadKeyTips()
end

function M:SetDisplayMode(bDisplay)
  self.bDisplayMode = true == bDisplay
  if self.bDisplayMode then
    if self.Drag then
      self.Drag:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Image_TitleBG_1 then
      self.Image_TitleBG_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    local DragBox = self:_GetDragBox()
    if DragBox then
      DragBox:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.Image_Icon then
      if self:_CanOpenStickerEditFromDisplay() then
        self.Image_Icon:SetVisibility(UIConst.VisibilityOp.Visible)
      else
        self.Image_Icon:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      end
    end
    if self.Image_Drag then
      self.Image_Drag:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:_StopPointerInteraction()
    self:_SetStickerEditCursor(EMouseCursor.Default)
  else
    self:_PrepareDragHitTest()
    local DragOverlay = self:_GetDragOverlay()
    if DragOverlay then
      DragOverlay:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
  self:_RefreshGamepadKeyTips()
end

function M:_EnsureGamepadKeyTipsListen()
  if self.bGamepadKeyTipsListen then
    return
  end
  if not self.GameInputModeSubsystem then
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    if PlayerController then
      self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    end
  end
  if self.AddInputMethodChangedListen then
    self:AddInputMethodChangedListen()
    self.bGamepadKeyTipsListen = true
  end
end

function M:_RefreshGamepadKeyTips()
  if not self.Com_KeyTips then
    return
  end
  local bShow = not self.bDisplayMode and UIUtils.IsGamepadInput()
  if not bShow then
    self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Com_KeyTips:UpdateKeyInfo({
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.LeftThumbNormal,
          Owner = self
        }
      },
      Desc = GText("UI_CTL_Move")
    },
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.LeftShoulder,
          Owner = self
        },
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightShoulder,
          Owner = self
        }
      },
      Type = "Or",
      Desc = GText("UI_CTL_ZoomInOut")
    }
  })
  self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self:_RefreshGamepadKeyTips()
end

function M:_ResolveEditRootController()
  local HostPage = self.HostPage
  if not HostPage then
    return nil
  end
  return HostPage.EditRootController or HostPage.RootEditPage
end

function M:_CanOpenStickerEditFromDisplay()
  local Controller = self:_ResolveEditRootController()
  if not Controller or not Controller.OpenStickerEditPage then
    return false
  end
  if Controller.IsStickerEditPageActive and Controller:IsStickerEditPageActive() then
    return false
  end
  local TabName = Controller.GetActiveMainTabName and Controller:GetActiveMainTabName() or nil
  return "Other" == TabName
end

function M:_TryOpenStickerEditFromDisplay()
  if not self:_CanOpenStickerEditFromDisplay() then
    return false
  end
  local StickerData = self.StickerViewData
  if type(StickerData) ~= "table" then
    return false
  end
  local StickerId = StickerData.StickerId or StickerData.Id
  if nil == StickerId or "" == StickerId then
    return false
  end
  local Controller = self:_ResolveEditRootController()
  Controller:OpenStickerEditPage(StickerData)
  return true
end

function M:_ApplyInitTransformFromWorkingData(StickerViewData)
  local PosX, PosY, Scale = 0, 0, 1
  local WorkingData = self:_GetWorkingStickerData()
  local ViewId = StickerViewData and StickerViewData.StickerId or nil
  if type(WorkingData) == "table" then
    local WorkingId = WorkingData.StickerId or WorkingData.Id
    if nil ~= WorkingId and "" ~= WorkingId and nil ~= ViewId and WorkingId == ViewId then
      PosX = WorkingData.PosX or 0
      PosY = WorkingData.PosY or 0
      Scale = WorkingData.Scale or 1
    end
  elseif type(StickerViewData) == "table" then
    PosX = StickerViewData.PosX or 0
    PosY = StickerViewData.PosY or 0
    Scale = StickerViewData.Scale or 1
  end
  self:ApplyStickerTransform(PosX, PosY, Scale)
end

function M:_GetWorkingStickerData()
  local HostPage = self.HostPage
  local Controller = HostPage and HostPage.EditRootController or nil
  if not Controller then
    return nil
  end
  if Controller.GetWorkingStickerData then
    return Controller:GetWorkingStickerData()
  end
  if Controller.GetStickerData then
    return Controller:GetStickerData()
  end
  return nil
end

function M:ApplyStickerTransform(PosX, PosY, Scale)
  self:_StopPointerInteraction()
  local TargetScale = Scale or 1
  if type(TargetScale) ~= "number" or TargetScale <= 0 then
    TargetScale = 1
  end
  TargetScale = self:_ClampScaleByConfig(TargetScale)
  self:_ApplyStickerTransformImmediate(PosX or 0, PosY or 0, TargetScale)
  self.AppliedStickerCursor = nil
  self:_RefreshStickerHoverCursor(UE4.UWidgetLayoutLibrary.GetMousePositionOnPlatform())
end

function M:_ApplyStickerTransformImmediate(PosX, PosY, Scale)
  self.StickerScale = Scale or 1
  self:_ApplyStickerItemScale(self.StickerScale)
  local Slot = self:_GetCanvasSlot()
  if Slot then
    Slot:SetPosition(FVector2D(PosX or 0, PosY or 0))
  end
  self:_ForceStickerTransformLayout()
end

function M:_ForceStickerTransformLayout()
  local DragBox = self:_GetDragBox()
  if DragBox and DragBox.ForceLayoutPrepass then
    DragBox:ForceLayoutPrepass()
  end
  local ItemWidget = self:_GetStickerItemGroup()
  if ItemWidget and ItemWidget.ForceLayoutPrepass then
    ItemWidget:ForceLayoutPrepass()
  end
  if self.ForceLayoutPrepass then
    self:ForceLayoutPrepass()
  end
  self:_InvalidatePredictedIconBounds()
end

function M:CaptureInitialTransformSnapshot()
  self.InitialTransformSnapshot = self:GetCurrentTransform()
end

function M:GetCurrentTransform()
  local PosX, PosY = 0, 0
  local Slot = self:_GetCanvasSlot()
  if Slot then
    local Pos = Slot:GetPosition()
    if Pos then
      PosX = Pos.X or 0
      PosY = Pos.Y or 0
    end
  end
  return {
    PosX = PosX,
    PosY = PosY,
    Scale = self.StickerScale or 1
  }
end

function M:HasTransformChangedFromInitial()
  local Initial = self.InitialTransformSnapshot
  if not Initial then
    return false
  end
  local Current = self:GetCurrentTransform()
  if math.abs((Current.PosX or 0) - (Initial.PosX or 0)) > DEFAULT_TRANSFORM_EPSILON then
    return true
  end
  if math.abs((Current.PosY or 0) - (Initial.PosY or 0)) > DEFAULT_TRANSFORM_EPSILON then
    return true
  end
  if math.abs((Current.Scale or 1) - (Initial.Scale or 1)) > DEFAULT_TRANSFORM_EPSILON then
    return true
  end
  return false
end

function M:ExportStickerEditData()
  local Transform = self:GetCurrentTransform()
  local ViewData = self.StickerViewData or {}
  return {
    StickerId = ViewData.StickerId,
    PosX = Transform.PosX,
    PosY = Transform.PosY,
    Scale = Transform.Scale,
    Icon = ViewData.Icon,
    StickerPath = ViewData.StickerPath or ViewData.Icon,
    Name = ViewData.Name
  }
end

function M:RefreshStickerEdit(StickerViewData)
  self.StickerViewData = StickerViewData
  if not self.Image_Icon then
    return
  end
  local IconPath
  if type(StickerViewData) == "table" then
    IconPath = StickerViewData.Icon or StickerViewData.StickerPath
  end
  if not IconPath or "" == IconPath then
    return
  end
  local Texture = LoadObject(IconPath)
  if Texture then
    self.Image_Icon:SetBrushFromTexture(Texture, true)
  end
end

function M:ResetStickerEdit()
  self:_StopPointerInteraction()
  self:_StopGamepadScaleRepeat(false)
  self:_EndGamepadMoveIfNeeded(false)
  self.bStickerTransformPreviewActive = false
  self:_ApplyStickerTransformImmediate(0, 0, 1)
  self:_NotifyHostTransformChanged()
  self.AppliedStickerCursor = nil
  self:_RefreshStickerHoverCursorAfterLayout(UE4.UWidgetLayoutLibrary.GetMousePositionOnPlatform())
end

function M:HandleGamepadMoveAnalog(AxisName, AnalogValue)
  if self.bDisplayMode then
    return false
  end
  if AxisName ~= LEFT_STICK_X_KEY_NAME and AxisName ~= LEFT_STICK_Y_KEY_NAME then
    return false
  end
  local AxisValue = AnalogValue or 0
  if math.abs(AxisValue) <= GAMEPAD_MOVE_DEAD_ZONE then
    AxisValue = 0
  end
  if AxisName == LEFT_STICK_X_KEY_NAME then
    self.GamepadMoveAxisX = AxisValue
  else
    self.GamepadMoveAxisY = AxisValue
  end
  local AxisX = self.GamepadMoveAxisX or 0
  local AxisY = self.GamepadMoveAxisY or 0
  if 0 == AxisX and 0 == AxisY then
    self:_EndGamepadMoveIfNeeded(true)
    return true
  end
  if not self.bGamepadMovingSticker then
    self.bGamepadMovingSticker = true
    self:_BeginStickerTransformPreview()
  end
  self:_MoveStickerByDelta(AxisX * GAMEPAD_MOVE_SPEED, -AxisY * GAMEPAD_MOVE_SPEED)
  return true
end

function M:HandleGamepadScaleByShoulder(bIncrease)
  if self.bDisplayMode then
    return false
  end
  bIncrease = true == bIncrease
  if self.bGamepadScaleRepeatActive and self.GamepadScaleHoldIncrease == bIncrease then
    return true
  end
  self.GamepadScaleHoldIncrease = bIncrease
  self:_ApplyGamepadScaleStep(bIncrease)
  self:_StartGamepadScaleRepeat(bIncrease)
  return true
end

function M:StopGamepadScaleRepeat(bIncrease)
  if nil ~= bIncrease and nil ~= self.GamepadScaleHoldIncrease and true == bIncrease ~= (self.GamepadScaleHoldIncrease == true) then
    return false
  end
  self:_StopGamepadScaleRepeat(true)
  return true
end

function M:IsAtDefaultTransform()
  local Scale = self.StickerScale or 1
  if math.abs(Scale - 1) > DEFAULT_TRANSFORM_EPSILON then
    return false
  end
  local Slot = self:_GetCanvasSlot()
  if not Slot then
    return true
  end
  local Pos = Slot:GetPosition()
  if not Pos then
    return true
  end
  if math.abs(Pos.X or 0) > DEFAULT_TRANSFORM_EPSILON then
    return false
  end
  if math.abs(Pos.Y or 0) > DEFAULT_TRANSFORM_EPSILON then
    return false
  end
  return true
end

function M:_NotifyHostTransformChanged()
  local HostPage = self.HostPage
  if HostPage and HostPage.OnStickerEditTransformChanged then
    HostPage:OnStickerEditTransformChanged()
  end
end

function M:_CacheBaseStickerItemSize()
  local ItemWidget = self:_GetStickerItemGroup()
  local ItemSlot = ItemWidget and UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(ItemWidget) or nil
  if not ItemSlot then
    self.BaseStickerItemSize = DEFAULT_STICKER_ITEM_SIZE
    return
  end
  local Size = ItemSlot:GetSize()
  if Size and Size.X and Size.X > 0 then
    local CurScale = self.StickerScale or 1
    if CurScale > 0 then
      self.BaseStickerItemSize = Size.X / CurScale
    else
      self.BaseStickerItemSize = Size.X
    end
  else
    self.BaseStickerItemSize = DEFAULT_STICKER_ITEM_SIZE
  end
end

function M:_PrepareDragHitTest()
  if self.Image_Icon then
    self.Image_Icon:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  local DragOverlay = self:_GetDragOverlay()
  if DragOverlay then
    DragOverlay:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.Image_Drag then
    self.Image_Drag:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if self.Image_TitleBG_1 then
    self.Image_TitleBG_1:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  local DragBox = self:_GetDragBox()
  if DragBox then
    DragBox:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:_EnsureDragEventsBound()
  if self.bDragEventsBound then
    return
  end
  if self.Image_Icon and self.Image_Icon.OnMouseButtonDownEvent then
    self.Image_Icon.OnMouseButtonDownEvent:Unbind()
    self.Image_Icon.OnMouseButtonDownEvent:Bind(self, self.OnIconMouseButtonDown)
  end
  if self.Image_Drag and self.Image_Drag.OnMouseButtonDownEvent then
    self.Image_Drag.OnMouseButtonDownEvent:Unbind()
    self.Image_Drag.OnMouseButtonDownEvent:Bind(self, self.OnScaleHandleMouseButtonDown)
  end
  self.bDragEventsBound = true
end

function M:_GetDragOverlay()
  if self.Drag then
    return self.Drag
  end
  if self.GetWidgetFromName then
    return self:GetWidgetFromName("Drag")
  end
  return nil
end

function M:_GetDragBox()
  if self.DragBox then
    return self.DragBox
  end
  if self.WidgetTree and self.WidgetTree.FindWidget then
    local Found = self.WidgetTree:FindWidget("DragBox")
    if Found then
      return Found
    end
  end
  if self.GetWidgetFromName then
    return self:GetWidgetFromName("DragBox")
  end
  return nil
end

function M:_GetStickerItemGroup()
  if self.Group_StickersItem then
    return self.Group_StickersItem
  end
  if self.WidgetTree and self.WidgetTree.FindWidget then
    local Found = self.WidgetTree:FindWidget("Group_StickersItem")
    if Found then
      return Found
    end
  end
  if self.GetWidgetFromName then
    return self:GetWidgetFromName("Group_StickersItem")
  end
  return nil
end

function M:_GetCanvasSlot()
  return UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self)
end

function M:_GetStickersCanvas()
  return self.HostPage and self.HostPage.Group_Stickers or nil
end

function M:_ResolveScaleEdge(MyGeometry, MouseScreenPos)
  if not MyGeometry or not MouseScreenPos then
    return nil
  end
  local LocalPos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(MyGeometry, MouseScreenPos)
  local Size = UE4.USlateBlueprintLibrary.GetLocalSize(MyGeometry)
  if not (LocalPos and Size and Size.X and Size.Y) or Size.X <= 0 or Size.Y <= 0 then
    return nil
  end
  local PX = BORDER_SCALE_PX
  local DistLeft = math.abs(LocalPos.X)
  local DistRight = math.abs(LocalPos.X - Size.X)
  local DistTop = math.abs(LocalPos.Y)
  local DistBottom = math.abs(LocalPos.Y - Size.Y)
  local BestEdge
  local BestDepth = -1
  if PX >= DistLeft then
    local Depth = PX - DistLeft
    if BestDepth < Depth then
      BestDepth = Depth
      BestEdge = "Left"
    end
  end
  if PX >= DistRight then
    local Depth = PX - DistRight
    if BestDepth < Depth then
      BestDepth = Depth
      BestEdge = "Right"
    end
  end
  if PX >= DistTop then
    local Depth = PX - DistTop
    if BestDepth < Depth then
      BestDepth = Depth
      BestEdge = "Top"
    end
  end
  if PX >= DistBottom then
    local Depth = PX - DistBottom
    if BestDepth < Depth then
      BestDepth = Depth
      BestEdge = "Bottom"
    end
  end
  return BestEdge
end

function M:_GetCursorForScaleEdge(ScaleEdge, bPressed)
  if "Left" == ScaleEdge or "Right" == ScaleEdge then
    return EMouseCursor.ResizeLeftRight
  end
  if "Top" == ScaleEdge or "Bottom" == ScaleEdge then
    return EMouseCursor.ResizeUpDown
  end
  if bPressed then
    return EMouseCursor.GrabHandClosed
  end
  return EMouseCursor.GrabHand
end

function M:_IsPointerOverWidget(Widget, MouseScreenPos)
  if not (Widget and MouseScreenPos) or not Widget.GetCachedGeometry then
    return false
  end
  local Geometry = Widget:GetCachedGeometry()
  if not Geometry then
    return false
  end
  return UE4.USlateBlueprintLibrary.IsUnderLocation(Geometry, MouseScreenPos) == true
end

function M:_SetStickerEditCursor(CursorType)
  if not IsValid(self) then
    return
  end
  if self.bDisplayMode then
    CursorType = EMouseCursor.Default
  end
  if self.AppliedStickerCursor == CursorType then
    return
  end
  self.AppliedStickerCursor = CursorType
  self:SetCursor(CursorType)
  if IsValid(self.Image_Icon) then
    self.Image_Icon:SetCursor(CursorType)
  end
  if IsValid(self.Image_Drag) then
    self.Image_Drag:SetCursor(CursorType)
  end
  local DragBox = self:_GetDragBox()
  if IsValid(DragBox) then
    DragBox:SetCursor(CursorType)
  end
end

function M:_RefreshStickerHoverCursor(MouseScreenPos)
  if self.bDraggingSticker or self.bScalingSticker then
    return
  end
  if self.bDisplayMode or not MouseScreenPos then
    self:_SetStickerEditCursor(EMouseCursor.Default)
    return
  end
  if self:_IsPointerOverWidget(self.Image_Drag, MouseScreenPos) then
    self:_SetStickerEditCursor(self:_GetCursorForScaleEdge(nil, false))
    return
  end
  local ItemWidget = self:_GetStickerItemGroup()
  if ItemWidget then
    local ItemGeo = ItemWidget:GetCachedGeometry()
    local ScaleEdge = self:_ResolveScaleEdge(ItemGeo, MouseScreenPos)
    if ScaleEdge then
      self:_SetStickerEditCursor(self:_GetCursorForScaleEdge(ScaleEdge, false))
      return
    end
    if self:_IsPointerOverWidget(ItemWidget, MouseScreenPos) then
      self:_SetStickerEditCursor(self:_GetCursorForScaleEdge(nil, false))
      return
    end
  end
  self:_SetStickerEditCursor(EMouseCursor.Default)
end

function M:_RefreshStickerHoverCursorAfterLayout(MouseScreenPos)
  self:_ForceStickerTransformLayout()
  self:_RefreshStickerHoverCursor(MouseScreenPos)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if not UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if self.bDisplayMode then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  return self:OnIconMouseButtonDown(MyGeometry, MouseEvent)
end

function M:OnIconMouseButtonDown(_, MouseEvent)
  if not UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if self.bDisplayMode then
    if self:_TryOpenStickerEditFromDisplay() then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local ItemWidget = self:_GetStickerItemGroup()
  if not ItemWidget then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
  local ItemGeo = ItemWidget:GetCachedGeometry()
  local ScaleEdge = self:_ResolveScaleEdge(ItemGeo, MousePos)
  if ScaleEdge then
    return self:_BeginScaleInteraction(MousePos, ScaleEdge)
  end
  if not self:_IsPointerOverWidget(ItemWidget, MousePos) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  self:_StopPointerInteraction()
  self:_BeginStickerTransformPreview()
  self.LastMousePos = UE4.USlateBlueprintLibrary.AbsoluteToViewport(self, MousePos)
  self.bDraggingSticker = true
  self:_SetStickerEditCursor(self:_GetCursorForScaleEdge(nil, true))
  local Reply = UE4.UWidgetBlueprintLibrary.Handled()
  return UE4.UWidgetBlueprintLibrary.CaptureMouse(Reply, self)
end

function M:OnScaleHandleMouseButtonDown(MyGeometry, MouseEvent)
  if not UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if self.bDisplayMode then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
  return self:_BeginScaleInteraction(MousePos, nil)
end

function M:_BeginScaleInteraction(MouseScreenPos, ScaleEdge)
  self:_StopPointerInteraction()
  self:_BeginStickerTransformPreview()
  self.LastMousePos = UE4.USlateBlueprintLibrary.AbsoluteToViewport(self, MouseScreenPos)
  self.ScaleStartMousePos = self.LastMousePos
  self.bScalingSticker = true
  self.ScaleEdge = ScaleEdge
  self.ScaleStartScale = self.StickerScale or 1
  self:_SetStickerEditCursor(self:_GetCursorForScaleEdge(ScaleEdge, true))
  local Reply = UE4.UWidgetBlueprintLibrary.Handled()
  return UE4.UWidgetBlueprintLibrary.CaptureMouse(Reply, self)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
  if not self.bDraggingSticker and not self.bScalingSticker then
    self:_RefreshStickerHoverCursor(MousePos)
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if not UE4.UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton) then
    local bWasInteracting = self.bDraggingSticker or self.bScalingSticker
    self:_StopPointerInteraction()
    if bWasInteracting then
      self:_CommitStickerTransformPreview()
      self:_NotifyHostTransformChanged()
    end
    self:_RefreshStickerHoverCursorAfterLayout(MousePos)
    return UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(UE4.UWidgetBlueprintLibrary.Handled())
  end
  if self.bScalingSticker then
    self:_UpdateStickerScaleByMouse(MousePos)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local ViewportScale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
  if not ViewportScale or 0 == ViewportScale then
    ViewportScale = 1
  end
  local VMousePos = UE4.USlateBlueprintLibrary.AbsoluteToViewport(self, MousePos)
  if not self.LastMousePos then
    self.LastMousePos = VMousePos
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local DeltaX = (VMousePos.X - self.LastMousePos.X) / ViewportScale
  local DeltaY = (VMousePos.Y - self.LastMousePos.Y) / ViewportScale
  self.LastMousePos = VMousePos
  self:_MoveStickerByDelta(DeltaX, DeltaY)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  if not self.bDraggingSticker and not self.bScalingSticker then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  self:_StopPointerInteraction()
  self:_CommitStickerTransformPreview()
  self:_NotifyHostTransformChanged()
  local MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
  self:_RefreshStickerHoverCursorAfterLayout(MousePos)
  return UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(UE4.UWidgetBlueprintLibrary.Handled())
end

function M:OnMouseCaptureLost()
  local bWasInteracting = self.bDraggingSticker or self.bScalingSticker
  if not bWasInteracting then
    return
  end
  self:_StopPointerInteraction()
  self:_CommitStickerTransformPreview()
  self:_NotifyHostTransformChanged()
  self:_RefreshStickerHoverCursorAfterLayout(UE4.UWidgetLayoutLibrary.GetMousePositionOnPlatform())
end

function M:OnMouseLeave(MouseEvent)
  if self.bDraggingSticker or self.bScalingSticker then
    return
  end
  local MousePos = UE4.UWidgetLayoutLibrary.GetMousePositionOnPlatform()
  if not MousePos and MouseEvent then
    MousePos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
  end
  self:_RefreshStickerHoverCursor(MousePos)
end

function M:_StopPointerInteraction()
  self.bDraggingSticker = false
  self.bScalingSticker = false
  self.ScaleEdge = nil
  self.LastMousePos = nil
  self.ScaleStartMousePos = nil
  self:_InvalidatePredictedIconBounds()
end

function M:_StopStickerDrag()
  self:_StopPointerInteraction()
end

function M:_MoveStickerByDelta(DeltaX, DeltaY)
  local Slot = self:_GetCanvasSlot()
  if not Slot then
    return
  end
  local CurrentPos = Slot:GetPosition()
  local ClampedPos = self:_ClampPositionForIconInCanvas(CurrentPos, DeltaX, DeltaY)
  Slot:SetPosition(ClampedPos)
end

function M:_GetCustomStickScaleLimit()
  local StickerData = self.StickerViewData
  if type(StickerData) ~= "table" then
    return nil, nil
  end
  local StickerId = tonumber(StickerData.StickerId or StickerData.Id)
  if not StickerId then
    return nil, nil
  end
  local Cfg = DataMgr.CustomStick and DataMgr.CustomStick[StickerId]
  if not Cfg then
    return nil, nil
  end
  local Limit = Cfg.ScaleLimit
  if type(Limit) ~= "table" then
    return nil, nil
  end
  return Limit[1], Limit[2]
end

function M:_GetMinScale()
  local MinScale = self:_GetCustomStickScaleLimit()
  if type(MinScale) == "number" and MinScale > 0 then
    return MinScale
  end
  return DEFAULT_MIN_SCALE
end

function M:_GetMaxScale()
  local _, MaxScale = self:_GetCustomStickScaleLimit()
  if type(MaxScale) == "number" and MaxScale > 0 then
    return MaxScale
  end
  return DEFAULT_MAX_SCALE
end

function M:_ClampScaleByConfig(DesiredScale)
  local MinScale, MaxScale = self:_GetCustomStickScaleLimit()
  if type(MinScale) ~= "number" or MinScale <= 0 then
    MinScale = DEFAULT_MIN_SCALE
  end
  if type(MaxScale) ~= "number" or MaxScale <= 0 then
    MaxScale = DEFAULT_MAX_SCALE
  end
  if MinScale > MaxScale then
    MaxScale = MinScale
  end
  if DesiredScale < MinScale then
    return MinScale
  end
  if DesiredScale > MaxScale then
    return MaxScale
  end
  return DesiredScale
end

function M:_UpdateStickerScaleByMouse(MouseScreenPos)
  if not MouseScreenPos then
    return
  end
  local StartMouse = self.ScaleStartMousePos
  if not StartMouse then
    return
  end
  local ViewportScale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
  if not ViewportScale or 0 == ViewportScale then
    ViewportScale = 1
  end
  local VMousePos = UE4.USlateBlueprintLibrary.AbsoluteToViewport(self, MouseScreenPos)
  local DeltaX = (VMousePos.X - StartMouse.X) / ViewportScale
  local DeltaY = (VMousePos.Y - StartMouse.Y) / ViewportScale
  local RefLength = self.BaseStickerItemSize or DEFAULT_STICKER_ITEM_SIZE
  if RefLength < 1 then
    RefLength = DEFAULT_STICKER_ITEM_SIZE
  end
  local Proj = 0
  local Edge = self.ScaleEdge
  if "Right" == Edge then
    Proj = DeltaX
  elseif "Left" == Edge then
    Proj = -DeltaX
  elseif "Bottom" == Edge then
    Proj = DeltaY
  elseif "Top" == Edge then
    Proj = -DeltaY
  else
    local InvSqrt2 = 0.7071067811865476
    Proj = DeltaX * InvSqrt2 + DeltaY * InvSqrt2
  end
  local RawScale = (self.ScaleStartScale or 1) + Proj / RefLength
  local AfterConfig = self:_ClampScaleByConfig(RawScale)
  local AfterCanvas = self:_ClampScaleToCanvas(AfterConfig)
  self.StickerScale = AfterCanvas
  self:_ApplyStickerItemScale(AfterCanvas)
end

function M:_ApplyStickerItemScale(Scale)
  local ItemWidget = self:_GetStickerItemGroup()
  local ItemSlot = ItemWidget and UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(ItemWidget) or nil
  if not ItemWidget then
    return
  end
  if not ItemSlot then
    return
  end
  Scale = Scale or 1
  local BaseSize = self.BaseStickerItemSize or DEFAULT_STICKER_ITEM_SIZE
  local NewSize = BaseSize * Scale
  ItemSlot:SetSize(FVector2D(NewSize, NewSize))
  local DragBox = self:_GetDragBox()
  local DragBoxSlot = DragBox and UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(DragBox) or nil
  if DragBoxSlot then
    local BoxSize = NewSize + BORDER_SCALE_PX * 2
    DragBoxSlot:SetSize(FVector2D(BoxSize, BoxSize))
  end
  self:_InvalidatePredictedIconBounds()
end

function M:_ClampScaleToCanvas(DesiredScale)
  local Canvas = self:_GetStickersCanvas()
  local Icon = self.ScaleBox_Icon
  if not Canvas or not Icon then
    return DesiredScale
  end
  local CanvasGeo = Canvas:GetCachedGeometry()
  local IconGeo = Icon:GetCachedGeometry()
  local IconLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(IconGeo)
  local CanvasSize = UE4.USlateBlueprintLibrary.GetLocalSize(CanvasGeo)
  local CurrentScale = self.StickerScale or 1
  if not CurrentScale or CurrentScale <= 0 then
    CurrentScale = 1
  end
  if DesiredScale <= CurrentScale then
    return DesiredScale
  end
  local IconTopLeftAbs = UE4.USlateBlueprintLibrary.LocalToAbsolute(IconGeo, FVector2D(0, 0))
  local IconBottomRightAbs = UE4.USlateBlueprintLibrary.LocalToAbsolute(IconGeo, IconLocalSize)
  local IconTopLeftInCanvas = UE4.USlateBlueprintLibrary.AbsoluteToLocal(CanvasGeo, IconTopLeftAbs)
  local IconBottomRightInCanvas = UE4.USlateBlueprintLibrary.AbsoluteToLocal(CanvasGeo, IconBottomRightAbs)
  local CenterX = (IconTopLeftInCanvas.X + IconBottomRightInCanvas.X) * 0.5
  local CenterY = (IconTopLeftInCanvas.Y + IconBottomRightInCanvas.Y) * 0.5
  local HalfW = (IconBottomRightInCanvas.X - IconTopLeftInCanvas.X) * 0.5
  local HalfH = (IconBottomRightInCanvas.Y - IconTopLeftInCanvas.Y) * 0.5
  if HalfW <= 0 or HalfH <= 0 then
    return DesiredScale
  end
  local BaseHalfW = HalfW / CurrentScale
  local BaseHalfH = HalfH / CurrentScale
  local OverflowRatio = STICKER_CANVAS_OVERFLOW_RATIO
  if OverflowRatio < 0 then
    OverflowRatio = 0
  end
  local Denom = 1 - 2 * OverflowRatio
  if Denom <= 1.0E-4 then
    if CenterX < 0 or CenterX > CanvasSize.X or CenterY < 0 or CenterY > CanvasSize.Y then
      return CurrentScale
    end
    return DesiredScale
  end
  local MaxByLeft = CenterX / (BaseHalfW * Denom)
  local MaxByRight = (CanvasSize.X - CenterX) / (BaseHalfW * Denom)
  local MaxByTop = CenterY / (BaseHalfH * Denom)
  local MaxByBottom = (CanvasSize.Y - CenterY) / (BaseHalfH * Denom)
  local MaxScale = math.min(MaxByLeft, MaxByRight, MaxByTop, MaxByBottom)
  if not MaxScale or MaxScale <= 0 then
    return math.min(DesiredScale, CurrentScale)
  end
  return math.min(DesiredScale, MaxScale)
end

function M:_InvalidatePredictedIconBounds()
  self.PredictedIconBoundsInCanvas = nil
end

function M:_ResolveIconBoundsInCanvas(Canvas, Icon)
  local Predicted = self.PredictedIconBoundsInCanvas
  if Predicted then
    local CanvasGeo = Canvas:GetCachedGeometry()
    local CanvasSize = UE4.USlateBlueprintLibrary.GetLocalSize(CanvasGeo)
    return Predicted, CanvasSize
  end
  local CanvasGeo = Canvas:GetCachedGeometry()
  local IconGeo = Icon:GetCachedGeometry()
  local IconLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(IconGeo)
  local CanvasSize = UE4.USlateBlueprintLibrary.GetLocalSize(CanvasGeo)
  local IconTopLeftAbs = UE4.USlateBlueprintLibrary.LocalToAbsolute(IconGeo, FVector2D(0, 0))
  local IconBottomRightAbs = UE4.USlateBlueprintLibrary.LocalToAbsolute(IconGeo, IconLocalSize)
  local IconTopLeftInCanvas = UE4.USlateBlueprintLibrary.AbsoluteToLocal(CanvasGeo, IconTopLeftAbs)
  local IconBottomRightInCanvas = UE4.USlateBlueprintLibrary.AbsoluteToLocal(CanvasGeo, IconBottomRightAbs)
  Predicted = {
    MinX = IconTopLeftInCanvas.X,
    MaxX = IconBottomRightInCanvas.X,
    MinY = IconTopLeftInCanvas.Y,
    MaxY = IconBottomRightInCanvas.Y
  }
  self.PredictedIconBoundsInCanvas = Predicted
  return Predicted, CanvasSize
end

function M:_ClampPositionForIconInCanvas(CurrentPos, DeltaX, DeltaY)
  local Canvas = self:_GetStickersCanvas()
  local Icon = self.ScaleBox_Icon
  if not (Canvas and Icon) or not CurrentPos then
    return FVector2D((CurrentPos and CurrentPos.X or 0) + (DeltaX or 0), (CurrentPos and CurrentPos.Y or 0) + (DeltaY or 0))
  end
  local Bounds, CanvasSize = self:_ResolveIconBoundsInCanvas(Canvas, Icon)
  if not Bounds or not CanvasSize then
    return FVector2D(CurrentPos.X + (DeltaX or 0), CurrentPos.Y + (DeltaY or 0))
  end
  local AdjX = self:_ClampAxisDelta(DeltaX or 0, Bounds.MinX, Bounds.MaxX, CanvasSize.X)
  local AdjY = self:_ClampAxisDelta(DeltaY or 0, Bounds.MinY, Bounds.MaxY, CanvasSize.Y)
  Bounds.MinX = Bounds.MinX + AdjX
  Bounds.MaxX = Bounds.MaxX + AdjX
  Bounds.MinY = Bounds.MinY + AdjY
  Bounds.MaxY = Bounds.MaxY + AdjY
  return FVector2D(CurrentPos.X + AdjX, CurrentPos.Y + AdjY)
end

function M:_ClampAxisDelta(Delta, Min, Max, Limit)
  local Size = Max - Min
  if not Limit or Limit <= 0 then
    return Delta
  end
  if Limit <= Size then
    return -Min
  end
  local Overflow = Size * STICKER_CANVAS_OVERFLOW_RATIO
  local NewMin = Min + Delta
  local NewMax = Max + Delta
  if NewMin < -Overflow then
    Delta = Delta - (NewMin + Overflow)
    NewMin = Min + Delta
    NewMax = Max + Delta
  end
  if NewMax > Limit + Overflow then
    Delta = Delta - (NewMax - (Limit + Overflow))
  end
  return Delta
end

function M:Destruct()
  if IsValid(self.Image_Icon) and self.Image_Icon.OnMouseButtonDownEvent then
    self.Image_Icon.OnMouseButtonDownEvent:Unbind()
  end
  if IsValid(self.Image_Drag) and self.Image_Drag.OnMouseButtonDownEvent then
    self.Image_Drag.OnMouseButtonDownEvent:Unbind()
  end
  if self.RemoveInputMethodChangedListen then
    self:RemoveInputMethodChangedListen()
  end
  self.bGamepadKeyTipsListen = false
  self:_StopGamepadScaleRepeat(false)
  self:_EndGamepadMoveIfNeeded(false)
  if self.CleanTimer then
    self:CleanTimer()
  end
  self:_CancelStickerTransformPreview()
  self:_StopPointerInteraction()
  self:_SetStickerEditCursor(EMouseCursor.Default)
  self.AppliedStickerCursor = nil
  self.bDragEventsBound = false
  self.bStickerTransformPreviewActive = false
  self.StickerViewData = nil
  self.HostPage = nil
  self.ScaleEdge = nil
  self.bDraggingSticker = nil
  self.bScalingSticker = nil
  self.LastMousePos = nil
  self.ScaleStartMousePos = nil
  self.StickerScale = nil
  self.ScaleStartScale = nil
  self.bDisplayMode = nil
  self.InitialTransformSnapshot = nil
  self.BaseStickerItemSize = nil
  self.GamepadMoveAxisX = nil
  self.GamepadMoveAxisY = nil
  self.bGamepadMovingSticker = nil
  self.PredictedIconBoundsInCanvas = nil
  self.bGamepadScalingSticker = nil
  self.bGamepadScaleRepeatActive = nil
  self.GamepadScaleHoldIncrease = nil
end

function M:_ApplyGamepadScaleStep(bIncrease)
  local CurrentScale = self.StickerScale or 1
  local DesiredScale = CurrentScale + (bIncrease and GAMEPAD_SCALE_STEP or -GAMEPAD_SCALE_STEP)
  local TargetScale = self:_ClampScaleToCanvas(self:_ClampScaleByConfig(DesiredScale))
  if math.abs(TargetScale - CurrentScale) <= DEFAULT_TRANSFORM_EPSILON then
    return
  end
  if not self.bGamepadScalingSticker then
    self.bGamepadScalingSticker = true
    self:_BeginStickerTransformPreview()
  end
  self.StickerScale = TargetScale
  self:_ApplyStickerItemScale(TargetScale)
end

function M:_StartGamepadScaleRepeat(bIncrease)
  if not self.AddTimer then
    return
  end
  self.GamepadScaleHoldIncrease = true == bIncrease
  self.bGamepadScaleRepeatActive = true
  self:AddTimer(GAMEPAD_SCALE_REPEAT_INTERVAL, function(Owner)
    if not Owner or not Owner._ApplyGamepadScaleStep then
      return
    end
    Owner:_ApplyGamepadScaleStep(Owner.GamepadScaleHoldIncrease == true)
  end, true, GAMEPAD_SCALE_REPEAT_INTERVAL, GAMEPAD_SCALE_REPEAT_TIMER_KEY, true)
end

function M:_StopGamepadScaleRepeat(bNotifyHost)
  if self.RemoveTimer then
    self:RemoveTimer(GAMEPAD_SCALE_REPEAT_TIMER_KEY)
  end
  self.bGamepadScaleRepeatActive = false
  self.GamepadScaleHoldIncrease = nil
  if not self.bGamepadScalingSticker then
    return
  end
  self.bGamepadScalingSticker = false
  self:_CommitStickerTransformPreview()
  if bNotifyHost then
    self:_NotifyHostTransformChanged()
  end
end

function M:_EndGamepadMoveIfNeeded(bNotifyHost)
  self.GamepadMoveAxisX = 0
  self.GamepadMoveAxisY = 0
  if not self.bGamepadMovingSticker then
    self:_InvalidatePredictedIconBounds()
    return
  end
  self.bGamepadMovingSticker = false
  self:_InvalidatePredictedIconBounds()
  self:_CommitStickerTransformPreview()
  if bNotifyHost then
    self:_NotifyHostTransformChanged()
  end
end

function M:_GetEditRootController()
  return self.HostPage and self.HostPage.EditRootController or nil
end

function M:_BeginStickerTransformPreview()
  if self.bStickerTransformPreviewActive then
    return
  end
  self.bStickerTransformPreviewActive = true
end

function M:_CommitStickerTransformPreview()
  if not self.bStickerTransformPreviewActive then
    return
  end
  self.bStickerTransformPreviewActive = false
end

function M:_CancelStickerTransformPreview()
  self.bStickerTransformPreviewActive = false
end

AssembleComponents(M)
return M
