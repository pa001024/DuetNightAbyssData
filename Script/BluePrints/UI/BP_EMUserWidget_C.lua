local M = Class()

function M:EMAfterInitialize()
  self.Overridden.EMAfterInitialize(self)
  if not self.GameInputModeSubsystem then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
end

function M:_SetUpScrollBoxRStickInput(ScrollView, ScrollSpeed, bIsReserve)
  self.TargetScrollBoxWithRStickInput = ScrollView
  self.ScrollOffsetOfEndOfSBox = ScrollView:GetScrollOffsetOfEnd()
  self.ScrollSpeedRStickOfSBox = ScrollSpeed or 10.0
  self.bReserveSBoxScrollDir = bIsReserve and 1 or -1
end

function M:ProcessAndroidSafeZoneRule(PlatformName)
  if "Android" == PlatformName then
    if not self.MainSafeZone then
      return
    end
    local DeviceMake = ULowEntryExtendedStandardLibrary.GetAndroidDeviceMake()
    if not DataMgr.AndroidSafeZoneRule[DeviceMake] then
      return
    end
    local DeviceModel = ULowEntryExtendedStandardLibrary.GetAndroidDeviceModel()
    if not DataMgr.AndroidSafeZoneRule[DeviceMake][DeviceModel] then
      return
    end
    local VSize = UWidgetLayoutLibrary.GetViewportSize(self)
    local SpecialSafeZoneRule
    local Rule1 = DataMgr.AndroidSafeZoneRule[DeviceMake]
    if Rule1 then
      local Rule2 = Rule1[DeviceModel]
      if Rule2 then
        local Rule3 = Rule2[VSize.X]
        if Rule3 then
          SpecialSafeZoneRule = Rule3[VSize.Y]
        end
      end
    end
    if SpecialSafeZoneRule then
      if not SpecialSafeZoneRule.UDPadding or 0 == SpecialSafeZoneRule.UDPadding then
        self.MainSafeZone.PadTop = false
        self.MainSafeZone.PadBottom = false
      else
        self.MainSafeZone.PadTop = true
        self.MainSafeZone.PadBottom = true
      end
      if not SpecialSafeZoneRule.LRPadding or 0 == SpecialSafeZoneRule.LRPadding then
        self.MainSafeZone.PadLeft = false
        self.MainSafeZone.PadRight = false
      else
        self.MainSafeZone.PadLeft = true
        self.MainSafeZone.PadRight = true
      end
      for _, Child in pairs(self.MainSafeZone:GetAllChildren()) do
        local Slot = UWidgetLayoutLibrary.SlotAsSafeBoxSlot(Child)
        Slot.Padding.Top = SpecialSafeZoneRule.UDPadding
        Slot.Padding.Bottom = SpecialSafeZoneRule.UDPadding
        Slot.Padding.Left = SpecialSafeZoneRule.LRPadding
        Slot.Padding.Right = SpecialSafeZoneRule.LRPadding
        if self.MainSafeZone.ForceSetSafeMargin then
          self.MainSafeZone:ForceSetSafeMargin(Slot.Padding.Left, Slot.Padding.Right, Slot.Padding.Top, Slot.Padding.Bottom)
        end
      end
    else
      self.MainSafeZone.PadTop = false
      self.MainSafeZone.PadBottom = false
      self.MainSafeZone.PadLeft = true
      self.MainSafeZone.PadRight = true
    end
    local bPadLeft = self.MainSafeZone.PadLeft
    local bPadRight = self.MainSafeZone.PadRight
    local bPadTop = self.MainSafeZone.PadTop
    local bPadBottom = self.MainSafeZone.PadBottom
    self.MainSafeZone:SetSidesToPad(bPadLeft, bPadRight, bPadTop, bPadBottom)
  end
end

function M:EMDestruct()
  if self.ClearScriptRegister then
    self:ClearScriptRegister()
  end
end

return M
