require("UnLua")
local WBP_JoyStick_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})
local BattleHUDCommonConst = require("BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst")

function WBP_JoyStick_C:Construct()
  self.Overridden.Construct(self)
  self.TextMove:SetText(GText("UI_Battle_AutoMove"))
  self.WBP_JoystickMove.Text_Auto:SetText(GText("UI_CustomLayout_WidgetName13"))
  self:GetOriginalPosition()
  self:AddTimer(0.2, self.UpdateDirection, true, 0, "UpdateDirectionForTouch")
  EventManager:AddEvent(EventID.OnSwitchMobileHUDLayout, self, self.OnSwitchMobileHUDLayout)
  EventManager:AddEvent(EventID.OnMobileHudPlanChanged, self, self.UpdateMobileLayoutInfoByServerData)
  EventManager:AddEvent(EventID.GameViewportSizeChanged, self, self.UpdateMobileLayoutInfo)
  self:UpdateMobileLayoutInfo()
  self:AddTimer(0.3, function()
    self:UpdateMobileLayoutInfo()
    if not self.IsHide then
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      local UIManager = GameInstance:GetGameUIManager()
      if IsValid(UIManager) then
        UIManager:InActivateVirtualJoystick()
        UIManager:ActivateVirtualJoystick()
      end
    end
  end)
end

function WBP_JoyStick_C:Destruct()
  self:RecoverOriginalPosition()
  EventManager:RemoveEvent(EventID.OnSwitchMobileHUDLayout, self)
  EventManager:RemoveEvent(EventID.OnMobileHudPlanChanged, self)
  EventManager:RemoveEvent(EventID.GameViewportSizeChanged, self)
end

function WBP_JoyStick_C:Init()
  local Controller = UGameplayStatics.GetPlayerController(self, 0)
  local TouchInterface = Controller.CurrentTouchInterface
  if not TouchInterface then
    return
  end
  self.ActiveOpacity = TouchInterface.ActiveOpacity
  self.InactiveOpacity = TouchInterface.InactiveOpacity
  self.NowOpacity = self.InactiveOpacity
  self.IsActiveNow = false
  self.IsHide = false
  self.VisibilityFromBattle = UIConst.VisibilityOp.Visible
  self.VisibilityFromSelf = UIConst.VisibilityOp.Visible
  UIManager(self):SetRealVirtualJoystickZOrder(6)
  UIManager(self):SetRealVirtualJoystickOpacity(self.NowOpacity, self.InactiveOpacity)
end

function WBP_JoyStick_C:SetOpacity(IsAvtive)
  if self.IsActiveNow ~= IsAvtive then
    if IsAvtive then
      self.NowOpacity = self.ActiveOpacity
    else
      self.NowOpacity = self.InactiveOpacity
    end
    local SetOpacity = UIManager(self):SetRealVirtualJoystickOpacity(self.NowOpacity, self.InactiveOpacity)
    if SetOpacity then
      self.IsActiveNow = IsAvtive
    end
  end
end

function WBP_JoyStick_C:SetTouchVisibilityFromBattle(InVisibility)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  local Controller = UGameplayStatics.GetPlayerController(self, 0)
  self.VisibilityFromBattle = InVisibility
  if InVisibility == UIConst.VisibilityOp.Collapsed or InVisibility == UIConst.VisibilityOp.Hidden then
    self.IsHide = true
    DebugPrint("HY@ UIManagerComponent InActivateVirtualJoystick== Try to InActivate Joystick")
    UIManager:InActivateVirtualJoystick()
    UIManager:SetRealVirtualJoystickOpacity(0, self.InactiveOpacity)
    Controller:SetVirtualJoystickVisibility(false)
  else
    self:SetTouchVisibility(self.VisibilityFromSelf)
  end
end

function WBP_JoyStick_C:SetTouchVisibility(InVisibility)
  self.VisibilityFromSelf = InVisibility
  if self.VisibilityFromBattle == UIConst.VisibilityOp.Collapsed or self.VisibilityFromBattle == UIConst.VisibilityOp.Hidden then
    return
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  local Controller = UGameplayStatics.GetPlayerController(self, 0)
  if InVisibility == UIConst.VisibilityOp.Collapsed or InVisibility == UIConst.VisibilityOp.Hidden then
    self.IsHide = true
    UIManager:InActivateVirtualJoystick()
    UIManager:SetRealVirtualJoystickOpacity(0, self.InactiveOpacity)
    Controller:SetVirtualJoystickVisibility(false)
    DebugPrint("HY@ UIManagerComponent InActivateVirtualJoystick== Try to InActivate Joystick")
  else
    if not self.IsHide then
      return
    end
    self.IsHide = false
    UIManager:ActivateVirtualJoystick()
    UIManager:SetRealVirtualJoystickZOrder(6)
    UIManager:SetRealVirtualJoystickOpacity(self.NowOpacity, self.InactiveOpacity)
    Controller:SetVirtualJoystickVisibility(true)
    DebugPrint("HY@ UIManagerComponent ActivateVirtualJoystick== Try to Activate Joystick")
  end
end

function WBP_JoyStick_C:OnSwitchMobileHUDLayout(LayoutPlan)
  if LayoutPlan then
    self:UpdateMobileLayoutInfoByServerData("Update", LayoutPlan)
  end
end

function WBP_JoyStick_C:UpdateMobileLayoutInfo()
  self:UpdateMobileLayoutInfoByServerData("Update")
end

function WBP_JoyStick_C:UpdateMobileLayoutInfoByServerData(OpType, LayoutPlan)
  local Platform = CommonUtils:GetDeviceTypeByPlatformName(self)
  if Platform == CommonConst.CLIENT_DEVICE_TYPE.PC then
    return
  end
  local PlayerAvatar = GWorld:GetAvatar()
  if not PlayerAvatar then
    return
  end
  if nil == LayoutPlan then
    LayoutPlan = PlayerAvatar:GetCurrentMobileHudPlanIndex() or 2
  end
  if "Update" == OpType then
    local WidgetPlanData = PlayerAvatar:GetMobileHudPlan(LayoutPlan) or {}
    local MovePosData = WidgetPlanData.MovePos
    local MoveAutoPosData = WidgetPlanData.MoveAutoPos
    local InteractionSize, Center, CenterScale, ResponseRange, ResponseRangeScale
    local SafeZonePaddingLeft = 0
    local SafeZonePaddingBottom = 0
    if self.MainSafeZone and self.MainSafeZone.GetSafeMargin then
      local Margin = self.MainSafeZone:GetSafeMargin()
      SafeZonePaddingLeft = Margin.Left
      SafeZonePaddingBottom = Margin.Bottom
    end
    if MovePosData then
      local VisualJoystickConfigData = MovePosData.RelativeNodeSaveData
      local CurAreaRangeYPercent = VisualJoystickConfigData.AreaRangeSizeYPercent
      InteractionSize = FVector2D(BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeXPercent, CurAreaRangeYPercent)
      local NodeCenter = FVector2D(MovePosData.PosX, MovePosData.PosY) + FVector2D(0, SafeZonePaddingBottom)
      Center = FVector2D(MovePosData.PosX, MovePosData.PosY) + FVector2D(SafeZonePaddingLeft, 0)
      CenterScale = FVector2D(MovePosData.ScaleX, MovePosData.ScaleX)
      local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.JoystickNode)
      CanvasSlot:SetPosition(NodeCenter)
      self.JoystickNode:SetRenderScale(CenterScale)
    else
      InteractionSize = FVector2D(BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeXPercent, BattleHUDCommonConst.VisualJoystickConfig.DefaultAreaRangeYPercent)
      local NodeCenter = self.JoystickNodePosition + FVector2D(0, SafeZonePaddingBottom)
      Center = self.JoystickNodePosition + FVector2D(SafeZonePaddingLeft, 0)
      CenterScale = FVector2D(1, 1)
      local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.JoystickNode)
      CanvasSlot:SetPosition(NodeCenter)
    end
    if MoveAutoPosData then
      local NodeResponseRange = FVector2D(MoveAutoPosData.PosX, MoveAutoPosData.PosY) + FVector2D(0, SafeZonePaddingBottom)
      ResponseRange = FVector2D(MoveAutoPosData.PosX, MoveAutoPosData.PosY) + FVector2D(SafeZonePaddingLeft, 0)
      ResponseRangeScale = FVector2D(MoveAutoPosData.ScaleX, MoveAutoPosData.ScaleY)
      local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.JoystickMoveNode)
      CanvasSlot:SetPosition(NodeResponseRange)
      self.JoystickMoveNode:SetRenderScale(ResponseRangeScale)
    else
      local NodeResponseRange = self.JoystickMoveNodePosition + FVector2D(0, SafeZonePaddingBottom)
      ResponseRange = self.JoystickMoveNodePosition + FVector2D(SafeZonePaddingLeft, 0)
      ResponseRangeScale = FVector2D(1, 1)
      local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.JoystickMoveNode)
      CanvasSlot:SetPosition(NodeResponseRange)
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    UIManager:SetVirtualJoystickCustomData(InteractionSize, Center, CenterScale, ResponseRange, ResponseRangeScale)
  end
end

function WBP_JoyStick_C:GetOriginalPosition()
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.JoystickNode)
  self.JoystickNodePosition = CanvasSlot:GetPosition()
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.JoystickMoveNode)
  self.JoystickMoveNodePosition = CanvasSlot:GetPosition()
end

function WBP_JoyStick_C:RecoverOriginalPosition()
  if self.JoystickNodePosition then
    local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.JoystickNode)
    CanvasSlot:SetPosition(self.JoystickNodePosition)
  end
  if self.JoystickMoveNodePosition then
    local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.JoystickMoveNode)
    CanvasSlot:SetPosition(self.JoystickMoveNodePosition)
  end
end

return WBP_JoyStick_C
