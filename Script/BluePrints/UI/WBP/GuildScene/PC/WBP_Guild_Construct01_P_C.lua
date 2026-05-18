require("UnLua")
require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_UIState_C")
local Handle = UE4.UWidgetBlueprintLibrary.Handled()
local Unhandle = UE4.UWidgetBlueprintLibrary.Unhandled()

function M:InitKeySetting()
  self.KeyDownFuncMap = {
    [EKeys.A.KeyName] = self.OnCameraMoveLeftKeyDown,
    [EKeys.D.KeyName] = self.OnCameraMoveRightKeyDown,
    [EKeys.W.KeyName] = self.OnCameraMoveCloseKeyDown,
    [EKeys.S.KeyName] = self.OnCameraMoveFarKeyDown,
    [EKeys.E.KeyName] = self.OnCameraMoveDownKeyDown,
    [EKeys.Q.KeyName] = self.OnCameraMoveUpKeyDown,
    [EKeys.LeftAlt.KeyName] = self.OnLeftAltKeyDown
  }
end

function M:OnCameraMoveLeftKeyDown()
  self.bCameraMoveLeftKeyDown = true
  return Handle
end

function M:OnCameraMoveRightKeyDown()
  self.bCameraMoveRightKeyDown = true
  return Handle
end

function M:OnCameraMoveUpKeyDown()
  self.bCameraMoveUpKeyDown = true
  return Handle
end

function M:OnCameraMoveDownKeyDown()
  self.bCameraMoveDownKeyDown = true
  return Handle
end

function M:OnCameraMoveFarKeyDown()
  self.bCameraMoveFarKeyDown = true
  return Handle
end

function M:OnCameraMoveCloseKeyDown()
  self.bCameraMoveCloseKeyDown = true
  return Handle
end

function M:OnLeftAltKeyDown()
  self.bHideMouseCursor = not self.bHideMouseCursor
  if CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) == "PC" then
    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
    GameInputSubsystem:SetMouseCursorVisable(not self.bHideMouseCursor)
  end
  return Handle
end

function M:RefreshDragImageList()
  if not self.List_Item then
    return
  end
  self.List_Item:ClearListItems()
  for _, v in ipairs(self.IconActorList) do
    local ClassPath = UIUtils.GetCommonItemContentClass()
    local Item = NewObject(ClassPath)
    Item.IconPath = v.Icon
    Item.ActorClassPath = v.Actor
    self.List_Item:AddItem(Item)
  end
end

function M:InitButton()
  self.Btn_Import:SetText(GText("导入"))
  self.Btn_Export:SetText(GText("导出"))
  self.Btn_RollBack:SetText(GText("撤销"))
  self.Btn_RollBack:BindEventOnClicked(self, function()
    self.GuildManager:Undo()
  end)
  self.Btn_Reset:SetText(GText("重做"))
  self.Btn_Reset:BindEventOnClicked(self, function()
    self.GuildManager:Redo()
  end)
  self.Btn_Apply:SetText(GText("应用"))
  self.Btn_Apply:BindEventOnClicked(self, function()
    self.GuildManager:EndExecuteOperation()
  end)
  self.Btn_Cancel:SetText(GText("撤销"))
  self.Btn_Cancel:BindEventOnClicked(self, function()
    self.GuildManager:CancelExecuteOperation()
  end)
  local Item = {
    Icon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Dispatch/T_Dispatch_A01.T_Dispatch_A01'",
    Actor = "Blueprint'/Engine/Tutorial/SubEditors/TutorialAssets/Character/TutorialCharacter.TutorialCharacter_C'"
  }
  self.IconActorList = {}
  if Item then
    table.insert(self.IconActorList, {
      Icon = Item.Icon,
      Actor = Item.Actor
    })
  end
end

function M:InitCamera()
  self.CameraMoveSpeed = 1000
  self.PitchSpeed = 0.5
  self.RollSpeed = 0.5
  self.YawSpeed = 0.5
  self.bCameraMoveLeftKeyDown = false
  self.bCameraMoveRightKeyDown = false
  self.bCameraMoveUpKeyDown = false
  self.bCameraMoveDownKeyDown = false
  self.bCameraMoveCloseKeyDown = false
  self.bCameraMoveFarKeyDown = false
  self.bHideMouseCursor = false
  self.CameraActor = UE4.UGameplayStatics.GetActorOfClass(self, UE4.AGuildConstructCameraBase)
  USequenceFunctionLibrary.SetViewTarget(self:GetOwningPlayer(), self.CameraActor)
end

function M:InitOperation()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuildManager = GameMode:GetGuildConstructManager()
end

function M:CreateDragWidget()
  self.DragWidget = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Guild/Widget/Construct/WBP_Guild_Construct_Drag.WBP_Guild_Construct_Drag_C'")
  self.DragWidget_Slot = self.Main:AddChildToCanvas(self.DragWidget)
  self.DragWidget:SetVisibility(UE4.ESlateVisibility.Hidden)
  self.DragWidget:InitParent(self)
end

function M:OnCancelSelect()
  self.DragWidget:SetVisibility(UE4.ESlateVisibility.Hidden)
end

function M:Construct()
  self:InitCamera()
  self:InitKeySetting()
  self:InitButton()
  self:SetFocus()
  self:InitOperation()
  self:CreateDragWidget()
  self:RefreshDragImageList()
  M.Super.Construct(self)
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)
  if not (Operation and Operation.Payload) or not Operation.Payload.ActorClassPath then
    return Unhandle
  end
  local AbsoluteScreenPos = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(PointerEvent)
  local Ret = self:ConvertMousePositionToPlanePosition(AbsoluteScreenPos)
  if not Ret then
    return Unhandle
  end
  local ActorClassPath = Operation.Payload.ActorClassPath
  local Transform = FTransform()
  Transform.Translation = Ret
  Transform.Rotation = FRotator(0, 0, 0):ToQuat()
  self.GuildManager:BeginExecuteOperation()
  local CreateOperator = UE4.UGuildFunctionLibrary.CreateActor(ActorClassPath, Transform.Translation, FRotator(0, 0, 0), FVector(1, 1, 1))
  UE4.UGuildFunctionLibrary.CreateActorExec(self.GuildManager, CreateOperator)
  self:SelectActor(CreateOperator.ActorCreateState[1].Id, AbsoluteScreenPos)
  return Handle
end

function M:SelectActor(Id, AbsoluteScreenPos)
  self.GuildManager:SetSelectedActorGuild(Id)
  self.DragWidget:SetVisibility(UE4.ESlateVisibility.Visible)
  self.DragWidget:RefreshData()
  self.DragWidget_Slot:SetPosition(AbsoluteScreenPos)
  self.DragWidget_Slot:SetZOrder(999)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local Func = self.KeyDownFuncMap and self.KeyDownFuncMap[InKeyName]
  if Func then
    return Func(self)
  end
  return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  self.bCameraMoveLeftKeyDown = false
  self.bCameraMoveRightKeyDown = false
  self.bCameraMoveUpKeyDown = false
  self.bCameraMoveDownKeyDown = false
  self.bCameraMoveCloseKeyDown = false
  self.bCameraMoveFarKeyDown = false
  return Unhandle
end

function M:MoveCamera(X, Y, Z)
  self.CameraActor:Move(X, Y, Z)
end

function M:RotateCamera(Roll, Pitch, Yaw)
  Roll = Roll * self.RollSpeed
  Pitch = Pitch * -self.PitchSpeed
  Yaw = Yaw * self.YawSpeed
  self.CameraActor:Rotate(Roll, Pitch, Yaw)
end

function M:OnFocusLost(InFocusEvent)
  self.bCameraMoveLeftKeyDown = false
  self.bCameraMoveRightKeyDown = false
  self.bCameraMoveUpKeyDown = false
  self.bCameraMoveDownKeyDown = false
  self.bCameraMoveCloseKeyDown = false
  self.bCameraMoveFarKeyDown = false
  self.bHideMouseCursor = false
  self.bIsDragging = false
  self.bIsDragActor = false
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  self.bIsDragging = true
  self.HitActor = nil
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
      local Out, Ret = self.GuildManager:GetActorGuid(Hit.Actor)
      if Ret then
        self.GuildManager:BeginExecuteOperation()
        self:SelectActor(Out, AbsoluteScreenPos)
      end
    end
  end
  return UWidgetBlueprintLibrary.CaptureMouse(Handle)
end

function M:OnMouseCaptureLost()
  self.bIsDragging = false
  self.bIsDragActor = false
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  self.bIsDragging = false
  self.bIsDragActor = false
  return UWidgetBlueprintLibrary.ReleaseMouseCapture(Handle)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  if (self.bHideMouseCursor or self.bIsDragging) and not self.bIsDragActor then
    local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(MouseEvent)
    self:RotateCamera(0, -CursorDelta.Y, CursorDelta.X)
  end
  return Unhandle
end

function M:UpdateActorPosition(MousePos)
  local Ret = self:ConvertMousePositionToPlanePosition(MousePos)
  if not Ret then
    return
  end
  local ActorId = self.GuildManager:GetSelectedActorGuild()
  local ModifiedState, Result = self.GuildManager:GetActorState(ActorId)
  if not Result then
    return
  end
  ModifiedState.Location.X = Ret.X
  ModifiedState.Location.Y = Ret.Y
  local ActorCreateState = TArray(FGuildActorState)
  ActorCreateState:Add(ModifiedState)
  local Operator = UE4.UGuildFunctionLibrary.ModifyOperator(ActorCreateState)
  UE4.UGuildFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
end

function M:ConvertMousePositionToPlanePosition(InMousePos)
  local PlayerController = self:GetOwningPlayer()
  local AbsoluteScreenPos = InMousePos
  local PixelPos = FVector2D()
  local ViewportPos = FVector2D()
  UE4.USlateBlueprintLibrary.AbsoluteToViewport(self, AbsoluteScreenPos, PixelPos, ViewportPos)
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
  local bHit = UE4.UKismetSystemLibrary.LineTraceSingleForObjects(self, Start, End, ObjectTypes, false, {}, 1, Hit, false, UE4.FLinearColor.Green, nil, 3)
  if not bHit then
    return nil
  end
  return Hit.ImpactPoint
end

function M:Tick(MyGeometry, InDeltaTime)
  if self.bIsDragActor then
    local PlayerController = self:GetOwningPlayer()
    local X, Y, Ret = PlayerController:GetMousePosition()
    local MousePos = FVector2D(X, Y)
    local ViewPortScale = UE4.UWidgetLayoutLibrary.GetViewportScale(self)
    self.DragWidget_Slot:SetPosition(MousePos / ViewPortScale)
    self:UpdateActorPosition(MousePos / ViewPortScale)
  else
    self.bIsDragActor = false
  end
  local MoveStep = InDeltaTime * self.CameraMoveSpeed
  if self.bCameraMoveLeftKeyDown then
    self:MoveCamera(0, -MoveStep, 0)
  end
  if self.bCameraMoveRightKeyDown then
    self:MoveCamera(0, MoveStep, 0)
  end
  if self.bCameraMoveUpKeyDown then
    self:MoveCamera(0, 0, MoveStep)
  end
  if self.bCameraMoveDownKeyDown then
    self:MoveCamera(0, 0, -MoveStep)
  end
  if self.bCameraMoveCloseKeyDown then
    self:MoveCamera(MoveStep, 0, 0)
  end
  if self.bCameraMoveFarKeyDown then
    self:MoveCamera(-MoveStep, 0, 0)
  end
end

return M
