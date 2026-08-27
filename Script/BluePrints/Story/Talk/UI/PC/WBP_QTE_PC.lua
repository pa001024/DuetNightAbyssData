require("UnLua")
local M = Class("BluePrints.Story.Talk.UI.Common.WBP_QTE_Common")

function M:SwitchBindButtonClickEvents(bBind)
  if bBind then
    self:InitButtonPerformance()
    self.Key_Handle:AddExecuteLogic(self, self.OnInputPress)
    self.Key_Handle:EnableKey()
  else
    self.Key_Handle:DisableKey()
  end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Gamepad then
    self:InitGamepadView()
  else
    self:InitKeyBoardView()
  end
  self:AddDispatcher("GameViewportInputKeyReleased", self, self.OnGlobalKeyUp)
  M.Super.RefreshOpInfoByInputDevice(self, CurInputType, CurGamepadName)
end

function M:InitGamepadView()
  self.Key_Handle:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = self:GetInputGamePadActionName(),
        bLargeSize = true
      }
    }
  })
end

function M:InitKeyBoardView()
  self.Key_Handle:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = self:GetClickButtonText(),
        bLargeSize = true
      }
    }
  })
end

function M:InitButtonPerformance()
  if self.bHasInitButtonPerformance then
    return
  end
  self.bHasInitButtonPerformance = true
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:InitGamepadView()
  else
    self:InitKeyBoardView()
  end
end

function M:AdaptPlatform()
  local UIPosName = self.QTEConfig.UIPosition
  local Offset = {x = 0, y = 0}
  if UIPosName then
    local Config = DataMgr.QTEPosition[tonumber(UIPosName)]
    if Config then
      Offset.x = Config.OffsetX
      Offset.y = Config.OffsetY
    end
  end
  local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Main)
  Slot:SetPosition(FVector2D(Offset.x, Offset.y))
end

function M:SwitchShowMouseCursorInPIE(bShow)
end

local MOUSE_KEYS = {
  LeftMouseButton = true,
  RightMouseButton = true,
  MiddleMouseButton = true,
  ThumbMouseButton = true,
  ThumbMouseButton2 = true
}

function M:OnGlobalKeyUp(Key)
  DebugPrint("QTE: OnGlobalKeyUp", Key.KeyName)
  if not self:CheckCanWorking() then
    return
  end
  if not Key or not Key.KeyName then
    return
  end
  if not MOUSE_KEYS[Key.KeyName] then
    return
  end
  self:SetFocus()
  local TargetKeyName = self:GetTargetKeyName()
  if not TargetKeyName then
    return
  end
  local InKeyName = Key.KeyName
  if InKeyName == TargetKeyName then
    self:OnInputPress(true)
    return
  end
  self.FaultClickCount = self.FaultClickCount + 1
  DebugPrint("QTE: 按键错误，错误次数", self.FaultClickCount)
  if -1 ~= self.QTEConfig.ClickFaultToleranceCount and self.FaultClickCount > self.QTEConfig.ClickFaultToleranceCount then
    DebugPrint("QTE: 由于按错次数超过设置值，QTE失败", self.QTEConfig.ClickFaultToleranceCount)
    self:OnQTEFailed()
  else
    self:PlayQTEFaultPressAudio()
  end
end

return M
