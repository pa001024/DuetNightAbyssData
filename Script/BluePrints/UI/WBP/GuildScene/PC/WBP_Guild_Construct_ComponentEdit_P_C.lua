require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Initialize(Initializer)
  self.Icon_AddPath = "/Game/UI/Texture/Static/Atlas/Common/DASprite/T_Com_IconAdd_DAS.T_Com_IconAdd_DAS"
  self.Icon_MinusPath = "/Game/UI/Texture/Static/Atlas/Common/DASprite/T_Com_IconMinus_DAS.T_Com_IconMinus_DAS"
end

function M:OnVisibilityChangedCallback(Visibility)
  if Visibility == UIConst.VisibilityOp.Collapsed then
    self.bIsFocusable = false
    local Main = UIManager(self):GetUIObj("GuildConstructionMain")
    if Main then
      Main.bIsFocusable = true
    end
  elseif Visibility == UIConst.VisibilityOp.Visible then
    self.bIsFocusable = true
    local Main = UIManager(self):GetUIObj("GuildConstructionMain")
    if Main then
      Main.bIsFocusable = false
    end
  end
end

function M:Construct()
  self.bIsDragActor = false
  self.bIsFocusable = true
  self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self.Controller = self.Player.Controller
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self.Controller)
  self.RotationInterval = 5.0
  self.Controller_Recycle:AddExecuteLogic(self, self.OnRecycleBtnClicked)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self:SetIsLimitNavigationInside(true)
  self.OnVisibilityChanged:Add(self, self.OnVisibilityChangedCallback)
  self:InitParameters()
  self:InitButtons()
  self:CreateDragWidget()
  self:CreateCopyWidget()
end

function M:DestroyDragAndCopyWidget()
  if self.GuildManager and self.GuildManager.OnActorCreateComplete then
    self.GuildManager.OnActorCreateComplete:Remove(self, self.ShowDragAndCopyWidget)
  end
  if IsValid(self.DragWidget) then
    self.DragWidget:RemoveFromParent()
  end
  self.DragWidget = nil
  self.DragWidget_Slot = nil
  if IsValid(self.CopyWidget) then
    self.CopyWidget:RemoveFromParent()
  end
  self.CopyWidget = nil
  self.CopyWidget_Slot = nil
end

function M:CreateDragWidget()
  if IsValid(self.DragWidget) then
    return
  end
  self.DragWidget = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Guild/Widget/Construct/WBP_Guild_Construct_BtnDrag.WBP_Guild_Construct_BtnDrag'")
  self.DragWidget_Slot = self.Main:AddChildToCanvas(self.DragWidget)
  self.DragWidget.Slot = self.DragWidget_Slot
  self.DragWidget_Slot:SetAlignment(UE4.FVector2D(0.5, 0.5))
  self.DragWidget:SetVisibility(UE4.ESlateVisibility.Hidden)
  self.DragWidget:InitParent(self)
end

function M:CreateCopyWidget()
  if IsValid(self.CopyWidget) then
    return
  end
  self.CopyWidget = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Guild/Widget/Construct/WBP_Guild_Construct_BtnCopy.WBP_Guild_Construct_BtnCopy'")
  self.CopyWidget_Slot = self.Main:AddChildToCanvas(self.CopyWidget)
  self.CopyWidget_Slot:SetAlignment(UE4.FVector2D(0.5, 0.5))
  self.CopyWidget:SetVisibility(UE4.ESlateVisibility.Hidden)
end

function M:Destruct()
  self:DestroyDragAndCopyWidget()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
  self.Overridden.Destruct(self)
end

function M:UpdateControllerParameter(bPointerFocusingParameter)
  if bPointerFocusingParameter then
    self.Controller_Parameter:CreateCommonKey({
      Desc = "返回",
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      }
    })
  else
    self.Controller_Parameter:CreateCommonKey({
      Desc = "调整参数",
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Y"}
      }
    })
  end
end

function M:InitGamepadIcon()
  self.bPointerFocusingParameter = false
  self.Panel_Controller_Parameter:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:UpdateControllerParameter(self.bPointerFocusingParameter)
  local LTIconPath = self.CurGamepadName ~= "PS" and "/Game/UI/Texture/Dynamic/Atlas/Key/XBOX/T_Key_LT.T_Key_LT" or "/Game/UI/Texture/Dynamic/Atlas/Key/PS5/T_Key_LT.T_Key_LT"
  local RTIconPath = self.CurGamepadName ~= "PS" and "/Game/UI/Texture/Dynamic/Atlas/Key/XBOX/T_Key_RT.T_Key_RT" or "/Game/UI/Texture/Dynamic/Atlas/Key/PS5/T_Key_RT.T_Key_RT"
  UResourceLibrary.LoadObjectAsync(self, LTIconPath, {
    self,
    function(_, Icon)
      self.Parameter_Rotation.Icon_Minus:SetBrushResourceObject(Icon)
      self.Parameter_Scale.Icon_Minus:SetBrushResourceObject(Icon)
      self.Parameter_Height.Icon_Minus:SetBrushResourceObject(Icon)
    end
  })
  UResourceLibrary.LoadObjectAsync(self, RTIconPath, {
    self,
    function(_, Icon)
      self.Parameter_Rotation.Icon_Add:SetBrushResourceObject(Icon)
      self.Parameter_Scale.Icon_Add:SetBrushResourceObject(Icon)
      self.Parameter_Height.Icon_Add:SetBrushResourceObject(Icon)
    end
  })
  self.Panel_Controller_Recycle:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Controller_Recycle:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    },
    bLongPress = true
  })
  self.Panel_Controller_Locate:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Controller_Locate:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
  self.Btn_Cancel.WS_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Cancel.WS_Key:SetActiveWidgetIndex(0)
  self.Btn_Cancel.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    }
  })
  self.Btn_Confirm.WS_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Confirm.WS_Key:SetActiveWidgetIndex(0)
  self.Btn_Confirm.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
end

function M:InitKeyboardIcon()
  UResourceLibrary.LoadObjectAsync(self, self.Icon_MinusPath, {
    self,
    function(_, Icon)
      self.Parameter_Rotation.Icon_Minus:SetBrushResourceObject(Icon)
      self.Parameter_Scale.Icon_Minus:SetBrushResourceObject(Icon)
      self.Parameter_Height.Icon_Minus:SetBrushResourceObject(Icon)
    end
  })
  UResourceLibrary.LoadObjectAsync(self, self.Icon_AddPath, {
    self,
    function(_, Icon)
      self.Parameter_Rotation.Icon_Add:SetBrushResourceObject(Icon)
      self.Parameter_Scale.Icon_Add:SetBrushResourceObject(Icon)
      self.Parameter_Height.Icon_Add:SetBrushResourceObject(Icon)
    end
  })
  self.bPointerFocusingParameter = false
  self.Panel_Controller_Parameter:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Panel_Controller_Recycle:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Panel_Controller_Locate:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Cancel.WS_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Confirm.WS_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurGamepadName = CurGamepadName
  if CurInputDevice == ECommonInputType.Gamepad then
    self:InitGamepadIcon()
  else
    self:InitKeyboardIcon()
  end
  self:SetFocus()
end

function M:InitButtons()
  self.Btn_Cancel:SetText(GText("取消"))
  self.Btn_Confirm:SetText(GText("确定"))
  self.Btn_Recycle:BindSingleEventOnClicked(self, self.OnRecycleBtnClicked)
  self.Btn_Locate:BindSingleEventOnClicked(self, self.OnLocateBtnClicked)
  self.Btn_Cancel:BindSingleEventOnClicked(self, self.OnCancelBtnClicked)
  self.Btn_Confirm:BindSingleEventOnClicked(self, self.OnConfirmBtnClicked)
end

function M:InitParameterRotation(Rotation)
  local Value = Rotation and Rotation.Yaw or 0
  self.Parameter_Rotation.bIsFocusable = true
  self.Parameter_Rotation.Text_Name:SetText(GText("旋转"))
  self.Parameter_Rotation.Text_Parameter:SetText(GText(string.format("%d°", Value)))
  self.Parameter_Rotation.Btn_Minus:BindSingleEventOnClicked(self, self.OnRotationMinusClicked)
  self.Parameter_Rotation.Btn_Add:BindSingleEventOnClicked(self, self.OnRotationAddClicked)
  self.Parameter_Rotation:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    function()
      self.Parameter_Scale:SetFocus()
      self.CurrentFocusedWidget = self.Parameter_Scale
    end
  })
end

function M:InitParameterScale(Scale)
  local Value = Scale and Scale.X or 1
  self.Parameter_Scale.bIsFocusable = true
  self.Parameter_Scale.Text_Name:SetText(GText("缩放"))
  self.Parameter_Scale.Text_Parameter:SetText(GText(string.format("%.1f", Value)))
  self.Parameter_Scale.Btn_Minus:BindSingleEventOnClicked(self, self.OnScaleMinusClicked)
  self.Parameter_Scale.Btn_Add:BindSingleEventOnClicked(self, self.OnScaleAddClicked)
  self.Parameter_Scale:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function()
      self.Parameter_Rotation:SetFocus()
      self.CurrentFocusedWidget = self.Parameter_Rotation
    end
  })
  self.Parameter_Scale:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    function()
      self.Parameter_Height:SetFocus()
      self.CurrentFocusedWidget = self.Parameter_Height
    end
  })
end

function M:InitParameterHeight(Height)
  local Value = Height or 0
  self.Parameter_Height.bIsFocusable = true
  self.Parameter_Height.Text_Name:SetText(GText("高度"))
  self.Parameter_Height.Text_Parameter:SetText(GText(string.format("%d", Value)))
  self.Parameter_Height.Btn_Minus:BindSingleEventOnClicked(self, self.OnHeightMinusClicked)
  self.Parameter_Height.Btn_Add:BindSingleEventOnClicked(self, self.OnHeightAddClicked)
  self.Parameter_Height:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function()
      self.Parameter_Scale:SetFocus()
      self.CurrentFocusedWidget = self.Parameter_Scale
    end
  })
end

function M:InitParameters(ActorState)
  if not ActorState then
    self:InitParameterRotation()
    self:InitParameterScale()
    self:InitParameterHeight()
  else
    self:InitParameterRotation(ActorState.Rotation)
    self:InitParameterScale(ActorState.Scale)
    self:InitParameterHeight(ActorState.Height)
  end
end

function M:InitKeyboardKeyList()
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
  self.Key_List:InitKey(CommonKeyDatas)
end

function M:InitGamepadKeyList()
  local CommonKeyDatas = {}
  CommonKeyDatas[1] = {
    ImgShortPath = {"View", "X"},
    DescText = "撤销"
  }
  CommonKeyDatas[2] = {
    ImgShortPath = {"View", "Y"},
    DescText = "复原"
  }
  self.Key_List:InitKey(CommonKeyDatas)
end

function M:InitKeyList()
  local CurrentInputType = self.GameInputModeSubsystem:GetCurrentInputType()
  if CurrentInputType ~= ECommonInputType.Gamepad then
    self:InitKeyboardKeyList()
  else
    self:InitGamepadKeyList()
  end
end

function M:RefreshData(ActorId)
  self.ActorId = ActorId
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not self.GuildManager then
    self.GuildManager = GameMode:GetGuildConstructManager()
  end
  local ActorState, Ret = self.GuildManager:GetActorState(ActorId)
  self.ActorState = ActorState
  self.UnitId = self.ActorState.UnitId
  self.GuildItemData = nil
  if self.UnitId then
    self.GuildItemData = DataMgr.GuildItem[self.UnitId]
  end
  self:SelectActor(ActorId)
  self:InitParameters(ActorState)
end

function M:UpdateHeight(InHeight)
  local ModifiedState, Ret = self.GuildManager:GetActorState(self.ActorId)
  ModifiedState.Height = InHeight
  local ActorCreateState = TArray(FGuildConstructActorState)
  ActorCreateState:Add(ModifiedState)
  local Operator = UE4.UGuildConstructFunctionLibrary.ModifyOperators(self.GuildManager, ActorCreateState)
  UE4.UGuildConstructFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
end

function M:OnCancelSelect()
  self:DestroyDragAndCopyWidget()
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local Main = UIManager(self):GetUIObj("GuildConstructionMain")
  if Main then
    Main.bIsFocusable = true
  end
end

function M:OnRecycleBtnClicked()
  Utils.ScreenPrint("OnRecycleBtnClicked")
  local DestroyOperator = UE4.UGuildConstructFunctionLibrary.DestroyActor(self.GuildManager, self.ActorId)
  local OperationResult = UE4.UGuildConstructFunctionLibrary.DestroyActorExec(self.GuildManager, DestroyOperator)
  if OperationResult.bSuccess then
    Utils.ScreenPrint("success")
  end
end

function M:OnLocateBtnClicked()
  Utils.ScreenPrint("OnLocateBtnClicked")
end

function M:OnCancelBtnClicked()
  Utils.ScreenPrint("OnCancelBtnClicked")
  self:HandleEscape()
end

function M:OnConfirmBtnClicked()
  Utils.ScreenPrint("OnConfirmBtnClicked")
  self.GuildManager:EndExecuteOperation()
end

function M:UpdateRotation(DeltaRotation)
  Utils.ScreenPrint("UpdateRotation")
  local ActorState, bOK = self.GuildManager:GetActorState(self.ActorId)
  ActorState.LocalRotation.Yaw = ActorState.LocalRotation.Yaw + DeltaRotation * 5.0
  ActorState.LocalRotation.Yaw = math.clamp(ActorState.LocalRotation.Yaw, -180, 180)
  local Operator = UE4.UGuildConstructFunctionLibrary.ModifyOperator(self.GuildManager, ActorState)
  local GuildConstructOperationResult = UE4.UGuildConstructFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
  if not GuildConstructOperationResult.bSuccess then
    Utils.ScreenPrint(GuildConstructOperationResult.ErrorMessage)
    return
  end
  self.Parameter_Rotation.Text_Parameter:SetText(GText(tostring(ActorState.LocalRotation.Yaw) .. "°"))
end

function M:OnRotationMinusClicked()
  Utils.ScreenPrint("OnRotationMinusClicked")
  self:UpdateRotation(-1)
end

function M:OnRotationAddClicked()
  Utils.ScreenPrint("OnRotationAddClicked")
  self:UpdateRotation(1)
end

function M:UpdateScale(DeltaScale)
  Utils.ScreenPrint("UpdateScale")
  local ScaleConfig = DataMgr.GuildItem[self.UnitId].ScaleConfig
  local Min = ScaleConfig[1]
  local Max = ScaleConfig[2]
  local Interval = ScaleConfig[3]
  local ActorState, bOK = self.GuildManager:GetActorState(self.ActorId)
  ActorState.LocalScale = ActorState.LocalScale + DeltaScale * Interval
  ActorState.LocalScale = math.clamp(ActorState.LocalScale, Min, Max)
  local Operator = UE4.UGuildConstructFunctionLibrary.ModifyOperator(self.GuildManager, ActorState)
  local GuildConstructOperationResult = UE4.UGuildConstructFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
  if not GuildConstructOperationResult.bSuccess then
    Utils.ScreenPrint(GuildConstructOperationResult.ErrorMessage)
    return
  end
  self.Parameter_Scale.Text_Parameter:SetText(GText(string.format("%.1f", ActorState.LocalScale)))
end

function M:OnScaleMinusClicked()
  Utils.ScreenPrint("OnScaleMinusClicked")
  self:UpdateScale(-1)
end

function M:OnScaleAddClicked()
  Utils.ScreenPrint("OnScaleAddClicked")
  self:UpdateScale(1)
end

function M:UpdateHeight(DeltaHeight)
  local HeightConfig = DataMgr.GuildItem[self.UnitId].HeightConfig
  local Min = HeightConfig[1]
  local Max = HeightConfig[2]
  local Interval = HeightConfig[3]
  local ActorState, bOK = self.GuildManager:GetActorState(self.ActorId)
  ActorState.LocalHeight = ActorState.LocalHeight + DeltaHeight * Interval
  ActorState.LocalHeight = math.clamp(ActorState.LocalHeight, Min, Max)
  local Operator = UE4.UGuildConstructFunctionLibrary.ModifyOperator(self.GuildManager, ActorState)
  local GuildConstructOperationResult = UE4.UGuildConstructFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
  if not GuildConstructOperationResult.bSuccess then
    Utils.ScreenPrint(GuildConstructOperationResult.ErrorMessage)
    return
  end
  self.Parameter_Height.Text_Parameter:SetText(GText(tostring(ActorState.LocalHeight)))
end

function M:OnHeightMinusClicked()
  self:UpdateHeight(-1)
end

function M:OnHeightAddClicked()
  self:UpdateHeight(1)
end

function M:GetCopyBtnPosByDragBtnPos(DragBtnPos)
  return FVector2D(DragBtnPos.X, DragBtnPos.Y - 100)
end

function M:ShowDragAndCopyWidget(Id, Actor)
  if not Actor or self.GuildManager:GetSelectedActorGuild() ~= Id then
    return
  end
  self:CreateDragWidget()
  self:CreateCopyWidget()
  local ActorOrigin = UE4.FVector()
  local BoxExtent = UE4.FVector()
  Actor:GetActorBounds(false, ActorOrigin, BoxExtent, false)
  self:UpdateWidgetPositionByActorPosition(ActorOrigin)
  self.GuildManager:SetSelectedActorGuild(Id)
  self.DragWidget:SetVisibility(UE4.ESlateVisibility.Visible)
  self.DragWidget:RefreshData()
  self.CopyWidget:SetVisibility(UE4.ESlateVisibility.Visible)
  self.CopyWidget:RefreshData()
  self.DragWidget_Slot:SetZOrder(999)
  self.CopyWidget_Slot:SetZOrder(999)
end

function M:InitializeWidgetByActorId(Id)
  local Actor = self.GuildManager:GetActorByGuid(Id)
  if not Actor then
    self:CreateDragWidget()
    if IsValid(self.DragWidget) then
      self.DragWidget:SetVisibility(UE4.ESlateVisibility.Hidden)
    end
    if self.GuildManager.OnActorCreateComplete then
      self.GuildManager.OnActorCreateComplete:Remove(self, self.ShowDragAndCopyWidget)
      self.GuildManager.OnActorCreateComplete:Add(self, self.ShowDragAndCopyWidget)
    end
    return
  end
  self:ShowDragAndCopyWidget(Id, Actor)
end

function M:SelectActor(Id)
  self.GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuildConstructComponent = self.GameMode:GetGuildConstructComponent()
  if not self.GuildConstructComponent then
    return
  end
  self:InitializeWidgetByActorId(Id)
  if self.GuildManager:CanUndo() then
    Utils.ScreenPrint("不能重复多选多个actor，请先完成当前编辑操作")
    return
  end
end

function M:UpdateActorPosition(NewPosition, TargetPlane)
  if not NewPosition then
    return
  end
  local ActorId = self.GuildManager:GetSelectedActorGuild()
  local ModifiedState, Result = self.GuildManager:GetActorState(ActorId)
  if not Result then
    return
  end
  local NewX = math.floor(NewPosition.X / 50) * 50
  local NewY = math.floor(NewPosition.Y / 50) * 50
  local NewLocation = UE4.FVector(NewX, NewY, ModifiedState.LocalLocation.Z)
  local NewBoundingBoxCenter = UE4.FVector(NewX, NewY, NewPosition.Z)
  local Operator = UE4.UGuildConstructFunctionLibrary.ModifyActorPosition(self.GuildManager, ActorId, TargetPlane, NewLocation)
  UE4.UGuildConstructFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
  return NewLocation, NewBoundingBoxCenter
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

function M:EnterParameterFocusing()
  self.bPointerFocusingParameter = true
  self:UpdateControllerParameter(self.bPointerFocusingParameter)
  self.Parameter_Rotation:SetFocus()
  self.CurrentFocusedWidget = self.Parameter_Scale
  self.Panel_Controller_Recycle:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Panel_Controller_Locate:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Cancel.WS_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Confirm.WS_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ExitParameterFocusing()
  self.bPointerFocusingParameter = false
  self:UpdateControllerParameter(self.bPointerFocusingParameter)
  self:SetFocus()
  self.CurrentFocusedWidget = self
  self.Panel_Controller_Recycle:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Panel_Controller_Locate:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Cancel.WS_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Confirm.WS_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:OnGamepadKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if not self.bPointerFocusingParameter then
    if InKeyName == UIConst.GamePadKey.FaceButtonTop then
      if not self.bSpecialLeftDown then
        UIUtils:LongPressKey(self.Controller_Recycle, function()
          self:OnRecycleBtnClicked()
        end)
      end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      if not self.bSpecialLeftDown then
        self.CopyWidget:CopyActor()
      end
    elseif InKeyName == UIConst.GamePadKey.LeftShoulder then
      self:OnLocateBtnClicked()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:OnCancelBtnClicked()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      self:OnConfirmBtnClicked()
    elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
      self.bSpecialLeftDown = true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:ExitParameterFocusing()
  elseif InKeyName == UIConst.GamePadKey.LeftTriggerThreshold then
    if self.CurrentFocusedWidget == self.Parameter_Rotation then
      self:OnRotationMinusClicked()
    elseif self.CurrentFocusedWidget == self.Parameter_Scale then
      self:OnScaleMinusClicked()
    elseif self.CurrentFocusedWidget == self.Parameter_Height then
      self:OnHeightMinusClicked()
    end
  elseif InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
    if self.CurrentFocusedWidget == self.Parameter_Rotation then
      self:OnRotationAddClicked()
    elseif self.CurrentFocusedWidget == self.Parameter_Scale then
      self:OnScaleAddClicked()
    elseif self.CurrentFocusedWidget == self.Parameter_Height then
      self:OnHeightAddClicked()
    end
  end
  return UIUtils.Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if UIUtils.IsKeyboardInput() then
  elseif UIUtils.IsGamepadInput() then
    self:OnGamepadKeyDown(MyGeometry, InKeyEvent)
  end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  if UIUtils.IsKeyboardInput() then
    self:OnKeyboardKeyUp(MyGeometry, InKeyEvent)
  elseif UIUtils.IsGamepadInput() then
    self:OnGamepadKeyUp(MyGeometry, InKeyEvent)
  end
end

function M:OnKeyboardKeyUp(MyGeometry, InKeyEvent)
end

function M:OnGamepadKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.SpecialLeft then
    self.bSpecialLeftDown = false
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if not self.bPointerFocusingParameter then
      self:EnterParameterFocusing()
    end
    UIUtils:StopLongPressKey(self.Controller_Recycle)
  end
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
      local bHit = UE4.UKismetSystemLibrary.LineTraceSingle(self, WorldOrigin, WorldOrigin + WorldDir * 100000.0, UE4.ETraceTypeQuery.TraceTypeQuery1, true, {}, UE4.EDrawDebugTrace.ForDuration, Hit, true)
      local Ret = self.GuildManager:GetActorGuid(Hit.Actor)
      if UE4.UGuildConstructFunctionLibrary.IsValidGuid(Ret) then
        self.GuildManager:BeginExecuteOperation()
        self:RefreshData(Ret)
        self.bIsDragActor = true
      end
    end
  end
  return UWidgetBlueprintLibrary.CaptureMouse(UIUtils.Handled)
end

function M:OnMouseCaptureLost()
  self.bIsDragging = false
  self.bIsDragActor = false
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  self.bIsDragging = false
  self.bIsDragActor = false
  return UWidgetBlueprintLibrary.ReleaseMouseCapture(UIUtils.Handled)
end

function M:TryUpdateActorLocation(Point)
  local MinusZDirection = UE4.FVector(0, 0, -1)
  local Start = Point
  local End = Point + MinusZDirection * 10000.0
  local Hit = UE4.FHitResult()
  local bHit = UE4.UGuildConstructFunctionLibrary.LineTraceSingleObjectChannel(self, Start, End, UE4.ECollisionChannel.ECC_GameTraceChannel14, Hit)
  if not bHit or not Hit.Actor then
    return UIUtils.Unhandled
  end
  local NewLocation, NewBoundingBoxCenter = self:UpdateActorPosition(Point, Hit.Actor)
  self:UpdateWidgetPositionByActorPosition(NewBoundingBoxCenter)
end

function M:GetActorCenter(Actor)
  local ActorOrigin = UE4.FVector()
  local BoxExtent = UE4.FVector()
  Actor:GetActorBounds(false, ActorOrigin, BoxExtent, false)
  return ActorOrigin
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(MouseEvent)
  if 0 == CursorDelta.X and 0 == CursorDelta.Y then
    return UIUtils.Unhandled
  end
  if self.bIsDragActor then
    local Actor = self.GuildManager:GetSelectedActor()
    local ActorOrigin = self:GetActorCenter(Actor)
    local Z = ActorOrigin.Z
    local Point = self:ComputeMouseAtZ(Z)
    self:TryUpdateActorLocation(Point)
  end
  return UIUtils.Unhandled
end

function M:OnMouseWheel(MyGeometry, InKeyEvent)
  return UIUtils.Unhandled
end

function M:HandleEscape()
  if self.GuildConstructComponent then
    self.GuildConstructComponent:CancelSelect()
  end
end

function M:UpdateWidgetPositionByActorPosition(ActorPosition)
  local ScreenPosition = UE4.FVector2D()
  UWidgetLayoutLibrary.ProjectWorldLocationToWidgetPosition(self.Controller, ActorPosition, ScreenPosition, false)
  self.DragWidget_Slot:SetPosition(ScreenPosition)
  local CopyBtnPos = self:GetCopyBtnPosByDragBtnPos(ScreenPosition)
  self.CopyWidget_Slot:SetPosition(CopyBtnPos)
end

function M:ComputeMouseAtZ(Z)
  local WorldLocation = UE4.FVector()
  local WorldDirection = UE4.FVector()
  self.Controller:DeprojectMousePositionToWorld(WorldLocation, WorldDirection)
  local Result = (Z - WorldLocation.Z) / WorldDirection.Z
  local Point = WorldLocation + WorldDirection * Result
  return Point
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  return UIUtils.Unhandled
end

return M
