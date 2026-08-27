require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local M = Class("BluePrints.UI.BP_UIState_C")
local Handle = UE4.UWidgetBlueprintLibrary.Handled()
local Unhandle = UE4.UWidgetBlueprintLibrary.Unhandled()

function M:Construct()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuildManager = GameMode:GetGuildConstructManager()
  self.bHasScriptImplementedTick = true
  self.bIsFocusable = true
  self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self.Controller = self.Player.Controller
  self.CommonKeyDatas = self:GetCommonKeyDatas()
  self.bMovedBefore = false
  self.bMoved = false
  self.GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self.NavigateWidgetOpacity = 1
  self:SetVisibility(UIConst.VisibilityOp.Visible)
  self:InitCamera()
  self:InitKeySetting()
  self:InitButton()
  self:InitInfo()
  self:SetFocus()
  self:InitItemList()
  self:InitResourceBar()
  M.Super.Construct(self)
end

function M:InitKeySetting()
  self.KeyDownFuncMap = {
    [EKeys.A.KeyName] = self.OperatorCameraMoveLeft,
    [EKeys.D.KeyName] = self.OperatorCameraMoveRight,
    [EKeys.W.KeyName] = self.OperatorCameraMoveClose,
    [EKeys.S.KeyName] = self.OperatorCameraMoveFar,
    [EKeys.Escape.KeyName] = self.OperatorEscape,
    [EKeys.Delete.KeyName] = self.OperatorDelete,
    [EKeys.Gamepad_FaceButton_Right.KeyName] = self.OperatorEscape
  }
  self.MouseWheelFuncMap = {
    MouseScrollUp = self.OperatorCameraZoomIn,
    MouseScrollDown = self.OperatorCameraZoomOut
  }
  self.ControlKeyDownFuncMap = {
    [EKeys.C.KeyName] = self.OperatorCopy,
    [EKeys.Z.KeyName] = self.OperatorUndo,
    [EKeys.Y.KeyName] = self.OperatorRedo
  }
  self.ShiftKeyDownFuncMap = {
    [EKeys.X.KeyName] = self.OperatorLeft,
    [EKeys.Z.KeyName] = self.OperatorRight
  }
  self.CameraGamepadKey = {
    [UIConst.GamePadKey.DPadUp] = true,
    [UIConst.GamePadKey.DPadDown] = true,
    [UIConst.GamePadKey.DPadLeft] = true,
    [UIConst.GamePadKey.DPadRight] = true,
    [UIConst.GamePadKey.LeftTriggerThreshold] = true,
    [UIConst.GamePadKey.RightTriggerThreshold] = true
  }
end

function M:OperatorDelete()
  local DeletedId = self.GuildManager:GetSelectedActorGuild()
  self:DeleteGuildActor(DeletedId)
end

function M:DeleteGuildActor(DeletedId)
  if not UE4.UGuildConstructFunctionLibrary.IsValidGuid(DeletedId) then
    return
  end
  local DestroyOperator = UE4.UGuildConstructFunctionLibrary.DestroyActor(self.GuildManager, DeletedId)
  UE4.UGuildConstructFunctionLibrary.DestroyActorExec(self.GuildManager, DestroyOperator)
end

function M:OnEndClose()
  USequenceFunctionLibrary.SetViewTargetWithBlend(self.Controller, self.Player)
  if self.GuildManager then
    self.GuildManager:OnCloseEditMode()
    self.GuildManager.OnPlacedItemChanged:Remove(self, self.OnSceneDataChanged)
    if self.ComponentList then
      self.GuildManager.OnBuyItemChanged:Remove(self.ComponentList, self.ComponentList.OnGuildItemCountChanged)
    end
  end
end

function M:OperatorUndo()
  if not self.GuildManager then
    return
  end
  self.GuildManager:Undo()
end

function M:OperatorRedo()
  if not self.GuildManager then
    return
  end
  self.GuildManager:Redo()
end

function M:OperatorSave()
  self.GuildManager:SaveSceneLua()
end

function M:OperatorEscape()
  if self:IsOpenSidePanel() then
    self:CloseSidePanel()
    return Handle
  end
  if self.GuildManager:CanUndo() then
    local Params = {}
    Params.RightCallbackObj = self
    
    function Params.RightCallbackFunction()
      self:OperatorSave()
      self:Close()
    end
    
    UIManager(self):ShowCommonPopupUI(100383, Params, self)
    return Handle
  end
  self:Close()
  return Handle
end

function M:OperatorCameraMoveLeft()
  self.bCameraMoveLeftKeyDown = true
  return Handle
end

function M:OperatorCameraMoveRight()
  self.bCameraMoveRightKeyDown = true
  return Handle
end

function M:OperatorCameraMoveFar()
  self.bCameraMoveFarKeyDown = true
  return Handle
end

function M:OperatorCameraMoveClose()
  self.bCameraMoveCloseKeyDown = true
  return Handle
end

function M:OperatorCameraZoomIn()
  self.bCameraZoomInKeyDown = true
  return Handle
end

function M:OperatorCameraZoomOut()
  self.bCameraZoomOutKeyDown = true
  return Handle
end

function M:PlacedCallBack(UnitId)
  local CameraActorLocation = self.CameraActor:K2_GetActorLocation()
  local StartLocation = FVector(CameraActorLocation.X, CameraActorLocation.Y, CameraActorLocation.Z + 50)
  local EndLocation = FVector(CameraActorLocation.X, CameraActorLocation.Y, CameraActorLocation.Z - 50)
  local Hit = UE4.FHitResult()
  local bHit = UE4.UGuildConstructFunctionLibrary.LineTraceSingleObjectChannel(self, StartLocation, EndLocation, UE4.ECollisionChannel.ECC_GameTraceChannel14, Hit)
  if bHit then
    self:CreateActor(UnitId, Hit)
  end
end

function M:CreateActor(UnitId, HitResult)
  if not HitResult then
    return
  end
  local Point = HitResult.ImpactPoint
  if self.GuildManager.ComponentMoveMode == UE4.EGuildComponentMoveMode.GridMove then
    Point.X = math.floor(Point.X / 50) * 50
    Point.Y = math.floor(Point.Y / 50) * 50
  end
  self.GuildManager:BeginExecuteOperation()
  local CreateOperator = UE4.UGuildConstructFunctionLibrary.CreateActor(self.GuildManager, UnitId, HitResult.Actor, Point, FRotator(0, 0, 0), FVector(1, 1, 1))
  UE4.UGuildConstructFunctionLibrary.CreateActorExec(self.GuildManager, CreateOperator)
  self:EnterEditMode(CreateOperator.ActorCreateState.Id)
  return CreateOperator
end

function M:OnClickDescMsg()
  UIManager:ShowCommonPopupUI(100390, {})
end

function M:OnSceneDataChanged(AddedCount, RemovedCount)
  local PlaceNum = 0
  local SumCost = 0
  local GuildItemCount = self.GuildManager and self.GuildManager.GuildItemCount or {}
  for UnitId, ItemCount in pairs(GuildItemCount) do
    local PlacedCount = ItemCount.PlacedCount or 0
    if PlacedCount > 0 then
      local Data = DataMgr.GuildItem[UnitId]
      if Data then
        PlaceNum = PlaceNum + PlacedCount
        SumCost = SumCost + PlacedCount * Data.Cost
      end
    end
  end
  self.Construct_Info.Text_PlaceNum:SetText(tostring(PlaceNum))
  self.Construct_Info.Text_CostNum:SetText(tostring(SumCost))
  local CostTotal = self.GuildManager and self.GuildManager.CostTotal or 0
  self.Construct_Info.Text_CostTotal:SetText(tostring(CostTotal))
  if SumCost >= CostTotal then
    self.Construct_Info.Text_CostNum:SetColorAndOpacity(self.RedColor)
  else
    self.Construct_Info.Text_CostNum:SetColorAndOpacity(self.DefaultColor)
  end
  if self.SettingPanel and self.SettingPanel:IsVisible() and self.SettingPanel.RefreshUI then
    self.SettingPanel:RefreshUI()
  end
end

function M:InitInfo()
  local Text_Place_MapId = "UI_PlacedComponents"
  local Text_CostNum_MapId = "UI_ConsumptionValue "
  self.Construct_Info.Text_Place:SetText(GText(Text_Place_MapId))
  self.Construct_Info.Text_Cost:SetText(GText(Text_CostNum_MapId))
  self.DefaultColor = UE4.UUIFunctionLibrary.StringToSlateColor("E8A75BFF")
  self.RedColor = UE4.UUIFunctionLibrary.StringToSlateColor("E9003DFF")
  self:OnSceneDataChanged()
  self.GuildManager.OnPlacedItemChanged:Add(self, self.OnSceneDataChanged)
end

function M:InitButton()
  self.Btn_Close:BindEventOnClicked(self, self.OperatorEscape)
  self.Btn_List.Text_Name:SetText(GText("UI_ConstructSettings"))
  self.Btn_Setting.Text_Name:SetText(GText("UI_ComponentList"))
  self.Btn_Setting.Btn_Click.OnClicked:Clear()
  self.Btn_List.Btn_Click.OnClicked:Clear()
  self.Btn_Setting.Btn_Click.OnClicked:Add(self, self.OnSettingButtonDown)
  self.Btn_List.Btn_Click.OnClicked:Add(self, self.OnListButtonDown)
end

function M:InitCamera()
  self.bCameraMoveLeftKeyDown = false
  self.bCameraMoveRightKeyDown = false
  self.bCameraMoveCloseKeyDown = false
  self.bCameraMoveFarKeyDown = false
  self.bCameraZoomInKeyDown = false
  self.bCameraZoomOutKeyDown = false
  self.bShiftKeyDown = false
  self.CameraActor = UE4.UGameplayStatics.GetActorOfClass(self, UE4.AGuildConstructCameraBase)
  if self.GuildManager then
    self.CameraActor:Init(self.GuildManager)
  end
  USequenceFunctionLibrary.SetViewTarget(self:GetOwningPlayer(), self.CameraActor)
end

function M:OnCancelSelect()
  self.ComponentList:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Close:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.ComponentEdit:OnCancelSelect()
end

function M:InitResourceBar()
  local TopResource = {
    CommonConst.GuildFundsCoin,
    99
  }
  self.ResourceBar:InitResourceBar(TopResource, true)
  self.ResourceBar:BindEvents(self, {
    OnMenuOpenChanged = self.OnDescOpenChanged
  })
  for _, CoinId in ipairs(TopResource) do
    self.ResourceBar:SetResourceBarVisibility(CoinId, true)
  end
  local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", "Generic")
  self.ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
  self.ResourceBar:SetLastFocusWidget(self)
  self.ResourceBar:InitGamePadTip({
    KeyInfo = {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Menu"}
      }
    },
    ClickFuncObj = self,
    ClickFunc = self.OnClickDescMsg,
    bAllowForbid = true
  })
  self.ResourceBar:HideTip(false)
end

function M:InitItemList()
  local UserData = {
    GuildManager = self.GuildManager,
    ItemPlacedCallBack = function(_, UnitId)
      self:PlacedCallBack(UnitId)
    end,
    OperatorSave = function(_)
      self:OperatorSave()
    end
  }
  self.ComponentList:Init(UserData, self.CommonKeyDatas)
end

function M:OnDescOpenChanged(WidgetName)
  print("OnDescOpenChanged")
end

function M:CreateSidePanel(WidgetName)
  local WidgetPanel = UIManager(self):_CreateWidgetNew(WidgetName)
  WidgetPanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.SidePanel:AddChildToCanvas(WidgetPanel)
  local Slot = WidgetPanel.Slot
  local Anchors = UE4.FAnchors()
  Anchors.Minimum = FVector2D(0, 0)
  Anchors.Maximum = FVector2D(1, 1)
  Slot:SetAnchors(Anchors)
  Slot:SetOffsets(FMargin(0, 0, 0, 0))
  if WidgetPanel.Init then
    WidgetPanel:Init(self)
  end
  if WidgetPanel.Btn_Close then
    WidgetPanel.Btn_Close.Btn_Close.OnClicked:Clear()
    WidgetPanel.Btn_Close.Btn_Close.OnClicked:Add(self, self.CloseSidePanel)
  end
  if WidgetPanel.Btn_Quit then
    WidgetPanel.Btn_Quit.OnClicked:Clear()
    WidgetPanel.Btn_Quit.OnClicked:Add(self, self.CloseSidePanel)
  end
  return WidgetPanel
end

function M:OnSettingButtonDown()
  self.PanelSwitcher:SetActiveWidgetIndex(1)
  if not self.SettingPanel then
    self.SettingPanel = self:CreateSidePanel("GuildConstructionSetting")
  end
  self.SettingPanel:SetVisibility(UE4.ESlateVisibility.Visible)
  if self.SettingPanel.RefreshUI then
    self.SettingPanel:RefreshUI()
  end
end

function M:OnListButtonDown()
  self.PanelSwitcher:SetActiveWidgetIndex(1)
  if not self.ListPanel then
    self.ListPanel = self:CreateSidePanel("GuildConstructionComponentList")
  end
  self.ListPanel:SetVisibility(UE4.ESlateVisibility.Visible)
  if self.ListPanel.RefreshUI then
    self.ListPanel:RefreshUI()
  end
end

function M:IsOpenSidePanel()
  return (not self.SettingPanel or not self.SettingPanel:IsVisible()) and self.ListPanel and self.ListPanel:IsVisible()
end

function M:CloseSidePanel()
  if self.SettingPanel then
    self.SettingPanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.ListPanel then
    self.ListPanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self.PanelSwitcher:SetActiveWidgetIndex(0)
end

function M:OnComponentListItemClicked(ItemData)
  if not ItemData or not ItemData.ActorId then
    return
  end
  self.SelectedComponentListItem = ItemData
  ScreenPrint("组件定位接口未接入")
end

function M:OnComponentTakeBackClicked(ItemData)
  if not ItemData or not ItemData.ActorId then
    return
  end
  self:DeleteGuildActor(ItemData.ActorId)
end

function M:OnComponentEditClicked(ItemData)
  if not ItemData or not ItemData.ActorId then
    return
  end
  if not UE4.UGuildConstructFunctionLibrary.IsValidGuid(ItemData.ActorId) then
    return
  end
  self:CloseSidePanel()
  self.GuildManager:BeginExecuteOperation()
  self:EnterEditMode(ItemData.ActorId)
end

function M:TestAddComponentList()
  self.IconActorList = {}
  for ItemID, GuildItem in pairs(DataMgr.GuildItem) do
    table.insert(self.IconActorList, {
      TEXT = GuildItem.Name,
      UnitId = GuildItem.ItemID
    })
  end
  if self.ComponentList and self.ComponentList.List_Component then
    local IconActor = self.IconActorList[2]
    local ClassPath = UIUtils.GetCommonItemContentClass()
    local Item = NewObject(ClassPath)
    Item.Text = IconActor.Icon
    Item.UnitId = IconActor.UnitId
    self.ComponentList.List_Component:AddItem(Item)
  end
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)
  local OldId = self.GuildManager:GetSelectedActorGuild()
  if UE4.UGuildConstructFunctionLibrary.IsValidGuid(OldId) then
    return
  end
  if not (Operation and Operation.Payload) or not Operation.Payload.UnitId then
    return Unhandle
  end
  local AbsoluteScreenPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
  local PixelPos = FVector2D()
  local ViewportPos = FVector2D()
  UE4.USlateBlueprintLibrary.AbsoluteToViewport(self, AbsoluteScreenPos, PixelPos, ViewportPos)
  local Ret = self:GetPlaneHitResult(PixelPos)
  if not Ret then
    return Unhandle
  end
  local UnitId = Operation.Payload.UnitId
  self:CreateActor(UnitId, Ret)
  return Handle
end

function M:ApplyExecution()
end

function M:EnterEditMode(ActorId)
  self.ComponentList:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.ComponentEdit:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Btn_Close:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:SelectActor(ActorId)
end

function M:SelectActor(Id)
  self.GuildManager:SetSelectedActorGuild(Id)
  self.ComponentEdit:RefreshData(Id)
  self.ComponentEdit:SetFocus()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  ScreenPrint("chenxiaokang")
  ScreenPrint(InKeyName)
  if UE4.UKismetInputLibrary.InputEvent_IsControlDown(InKeyEvent) then
    local Func = self.ControlKeyDownFuncMap and self.ControlKeyDownFuncMap[InKeyName]
    if Func then
      return Func(self, InKeyEvent)
    end
  elseif UE4.UKismetInputLibrary.InputEvent_IsShiftDown(InKeyEvent) then
    self.bShiftKeyDown = true
    local Func = self.ShiftKeyDownFuncMap and self.ShiftKeyDownFuncMap[InKeyName]
    if Func then
      return Func(self, InKeyEvent)
    end
    Func = self.KeyDownFuncMap and self.KeyDownFuncMap[InKeyName]
    if Func then
      return Func(self, InKeyEvent)
    end
  else
    local Func = self.KeyDownFuncMap and self.KeyDownFuncMap[InKeyName]
    if Func then
      return Func(self, InKeyEvent)
    end
  end
  return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnMouseWheel(MyGeometry, InKeyEvent)
  local WheelData = UE4.UKismetInputLibrary.PointerEvent_GetWheelDelta(InKeyEvent)
  local MouseWheelFunctionName
  if WheelData < 0 then
    MouseWheelFunctionName = "MouseScrollDown"
  elseif WheelData > 0 then
    MouseWheelFunctionName = "MouseScrollUp"
  end
  local Func = self.MouseWheelFuncMap and self.MouseWheelFuncMap[MouseWheelFunctionName]
  if Func then
    return Func(self, MouseWheelFunctionName)
  end
  return M.Super.OnMouseWheel(self, MyGeometry, InKeyEvent)
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  self.bCameraMoveLeftKeyDown = false
  self.bCameraMoveRightKeyDown = false
  self.bCameraMoveCloseKeyDown = false
  self.bCameraMoveFarKeyDown = false
  self.bCameraZoomInKeyDown = false
  self.bCameraZoomOutKeyDown = false
  self.bShiftKeyDown = false
  return Unhandle
end

function M:MoveCamera(X, Y, Z)
  self.CameraActor:Move(X, Y, Z)
end

function M:RotateCamera(Roll, Pitch, Yaw)
  if self.CameraActor then
    self.CameraActor:Rotate(Roll, Pitch, Yaw)
  end
end

function M:ZoomCamera(Distance)
  self.CameraActor:Zoom(Distance)
end

function M:OnFocusLost(InFocusEvent)
  self.bCameraMoveLeftKeyDown = false
  self.bCameraMoveRightKeyDown = false
  self.bCameraMoveCloseKeyDown = false
  self.bCameraMoveFarKeyDown = false
  self.bCameraZoomInKeyDown = false
  self.bCameraZoomOutKeyDown = false
  self.bIsDragging = false
  self.bIsDragActor = false
  self.bShiftKeyDown = false
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  self.HitActor = nil
  if self:IsOpenSidePanel() then
    return
  end
  if self:IsOpenEditPanel() then
    return
  end
  local PlayerController = self:GetOwningPlayer()
  if PlayerController then
    local AbsoluteScreenPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
    local PixelPos = FVector2D()
    local ViewportPos = FVector2D()
    UE4.USlateBlueprintLibrary.AbsoluteToViewport(self, AbsoluteScreenPos, PixelPos, ViewportPos)
    local WorldOrigin = FVector()
    local WorldDir = FVector()
    local bOK = UE4.UGameplayStatics.DeprojectScreenToWorld(PlayerController, PixelPos, WorldOrigin, WorldDir)
    if bOK then
      local Hit = UE4.FHitResult()
      local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, WorldOrigin, WorldOrigin + WorldDir * 100000.0, UE4.ETraceTypeQuery.TraceTypeQuery1, true, {}, UE4.EDrawDebugTrace.None, Hit, true)
      local ActorGuid = self.GuildManager:GetActorGuid(Hit.Actor)
      if UE4.UGuildConstructFunctionLibrary.IsValidGuid(ActorGuid) then
        self.GuildManager:BeginExecuteOperation()
        self:EnterEditMode(ActorGuid)
      end
    end
  end
  return UWidgetBlueprintLibrary.CaptureMouse(Handle)
end

function M:OnMouseCaptureLost()
  self.bIsDragActor = false
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  self.bIsDragActor = false
  return UWidgetBlueprintLibrary.ReleaseMouseCapture(Handle)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  if UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.RightMouseButton) and not self.bIsDragActor then
    local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(MouseEvent)
    self:RotateCamera(0, -CursorDelta.Y, CursorDelta.X)
    if self:IsOpenEditPanel() and not self.ComponentEdit.bIsDragActor then
      self.ComponentEdit:UpdateWidgetPosition()
    end
  end
  return Unhandle
end

function M:UpdateActorPosition(PixelPos)
  local Ret = self:GetPlaneHitResult(PixelPos)
  if not Ret then
    return
  end
  local ActorId = self.GuildManager:GetSelectedActorGuild()
  local ModifiedState, Result = self.GuildManager:GetActorState(ActorId)
  if not Result then
    return
  end
  local Point = Ret.ImpactPoint
  Point.X = math.floor(Point.X / 50) * 50
  Point.Y = math.floor(Point.Y / 50) * 50
  ModifiedState.Location.X = Point.X
  ModifiedState.Location.Y = Point.Y
  ModifiedState.Location.Z = Point.Z
  local Operator = UE4.UGuildConstructFunctionLibrary.ModifyActorPosition(self.GuildManager, ActorId, Ret.Actor, ModifiedState.Location)
  UE4.UGuildConstructFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
end

function M:GetPlaneHitResult(PixelPos)
  local PlayerController = self:GetOwningPlayer()
  local WorldOrigin = FVector()
  local WorldDir = FVector()
  local bOK = UE4.UGameplayStatics.DeprojectScreenToWorld(PlayerController, PixelPos, WorldOrigin, WorldDir)
  if not bOK then
    return nil
  end
  local Start = WorldOrigin
  local End = WorldOrigin + WorldDir * 100000.0
  local ObjectTypes = TArray(EObjectTypeQuery)
  ObjectTypes:Add(12)
  local Hit = UE4.FHitResult()
  local bHit = UE4.UGuildConstructFunctionLibrary.LineTraceSingleObjectChannel(self, Start, End, UE4.ECollisionChannel.ECC_GameTraceChannel14, Hit)
  if not bHit then
    return nil
  end
  return Hit
end

function M:Tick(MyGeometry, InDeltaTime)
  if self.bIsDragActor then
    local PlayerController = self:GetOwningPlayer()
    local X, Y, Ret = PlayerController:GetMousePosition()
    local MousePos = FVector2D(X, Y)
    local ViewPortScale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
    self.DragWidget_Slot:SetPosition(MousePos / ViewPortScale)
    self:UpdateActorPosition(MousePos)
  end
  local MoveStep = InDeltaTime
  if self.bShiftKeyDown then
    MoveStep = MoveStep * 1.5
  end
  self.bMoved = false
  if self.bCameraMoveLeftKeyDown then
    self:MoveCamera(0, -MoveStep, 0)
    self.bMoved = true
  end
  if self.bCameraMoveRightKeyDown then
    self:MoveCamera(0, MoveStep, 0)
    self.bMoved = true
  end
  if self.bCameraMoveCloseKeyDown then
    self:MoveCamera(MoveStep, 0, 0)
    self.bMoved = true
  end
  if self.bCameraMoveFarKeyDown then
    self:MoveCamera(-MoveStep, 0, 0)
    self.bMoved = true
  end
  if self.bCameraZoomInKeyDown then
    self:ZoomCamera(-MoveStep)
    self.bCameraZoomInKeyDown = false
    self.bMoved = true
  end
  if self.bCameraZoomOutKeyDown then
    self:ZoomCamera(MoveStep)
    self.bCameraZoomOutKeyDown = false
    self.bMoved = true
  end
  if self.bMoved and self:IsOpenEditPanel() and not self.ComponentEdit.bIsDragActor then
    self.ComponentEdit:UpdateWidgetPosition()
  end
  if self.bMovedBefore and not self.bMoved and self:IsOpenEditPanel() then
    self.ComponentEdit:UpdateWidgetPosition()
  end
  self.bMovedBefore = self.bMoved
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  if not self.Main:IsVisible() or not UIUtils.HasAnyFocus(self) then
    return
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.SettingPanel and self.SettingPanel:IsVisible() then
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.SettingPanel)
  end
  if self.ListPanel and self.ListPanel:IsVisible() then
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.ListPanel)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:GetCommonKeyDatas()
  local CommonKeyDatas = {}
  CommonKeyDatas[1] = {
    Type = "Text",
    Text = "F",
    DescText = "定位组件"
  }
  CommonKeyDatas[2] = {
    Type = "Text",
    Text = "Delete",
    DescText = "收回组件"
  }
  CommonKeyDatas[3] = {
    bIsSubKeyDesc = true,
    Type = "Add",
    KeyInfoList = {
      {
        Type = "Text",
        Text = "LeftControl"
      },
      {Type = "Text", Text = "Z"}
    },
    DescText = "撤销"
  }
  CommonKeyDatas[4] = {
    bIsSubKeyDesc = true,
    Type = "Add",
    KeyInfoList = {
      {
        Type = "Text",
        Text = "LeftControl"
      },
      {Type = "Text", Text = "Y"}
    },
    DescText = "复原"
  }
  CommonKeyDatas[5] = {
    Type = "Text",
    KeyInfoList = {
      {Type = "Text", Text = "W"},
      {Type = "Text", Text = "A"},
      {Type = "Text", Text = "S"},
      {Type = "Text", Text = "D"}
    },
    DescText = "移动镜头"
  }
  CommonKeyDatas[6] = {
    Type = "Text",
    Text = "MouseScroll",
    DescText = "拉近/拉远"
  }
  CommonKeyDatas[7] = {
    Type = "Text",
    Text = "RightMouseButton",
    DescText = "调整视角"
  }
  return CommonKeyDatas
end

function M:IsOpenEditPanel()
  return self.ComponentEdit and self.ComponentEdit:GetVisibility() ~= UIConst.VisibilityOp.Collapsed
end

function M:HandleGamepadCamera(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if 0 ~= self.NavigateWidgetOpacity then
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0, true)
    self.NavigateWidgetOpacity = 0
  end
  if InKeyName == UIConst.GamePadKey.DPadUp then
    self:OperatorCameraMoveClose()
  elseif InKeyName == UIConst.GamePadKey.DPadDown then
    self:OperatorCameraMoveFar()
  elseif InKeyName == UIConst.GamePadKey.DPadLeft then
    self:OperatorCameraMoveLeft()
  elseif InKeyName == UIConst.GamePadKey.DPadRight then
    self:OperatorCameraMoveRight()
  elseif InKeyName == UIConst.GamePadKey.LeftTriggerThreshold and not self:IsOpenSidePanel() then
    self:OperatorCameraZoomIn()
  elseif InKeyName == UIConst.GamePadKey.RightTriggerThreshold and not self:IsOpenSidePanel() then
    self:OperatorCameraZoomOut()
  end
  return Handle
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local KeyName = self:KeyEventToKeyName(InKeyEvent)
  if UIUtils.IsGamepadInput() and self.CameraGamepadKey[KeyName] then
    return self:HandleGamepadCamera(MyGeometry, InKeyEvent)
  end
  return Unhandle
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKeyName = self:KeyEventToKeyName(InAnalogInputEvent)
  local AddOffset = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  if InKeyName == UIConst.GamePadKey.RightAnalogY then
    self:RotateCamera(0, AddOffset, 0)
    return Handle
  elseif InKeyName == UIConst.GamePadKey.RightAnalogX then
    self:RotateCamera(0, 0, AddOffset)
    return Handle
  elseif 1 ~= self.NavigateWidgetOpacity then
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1, true)
    self.NavigateWidgetOpacity = 1
  end
  return Unhandle
end

function M:OnFocusReceived()
  self.ComponentList.List_Component:SetFocus()
end

function M:KeyEventToKeyName(InKeyEvent)
  if not InKeyEvent then
    return
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  return InKeyName
end

return M
