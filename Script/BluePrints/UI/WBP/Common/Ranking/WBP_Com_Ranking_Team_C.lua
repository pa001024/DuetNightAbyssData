require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local CharSlotWidgetNames = {
  "Slot_01",
  "Slot_02",
  "Slot_03",
  "Slot_04"
}
local PhantomSlotWidgetNames = {"Phantom_01", "Phantom_02"}
local SquadHiddenTextKey = "UI_Ranking_SquadHidden"

function M:Init(Data)
  Data = Data or {}
  local CharSlots = Data.CharSlots or {}
  local PhantomSlots = Data.PhantomSlots or {}
  local bHide = Data.bHide
  if bHide then
    if self.WS_Type then
      self.WS_Type:SetActiveWidgetIndex(0)
    end
    if self.WS_Show then
      self.WS_Show:SetActiveWidgetIndex(1)
    end
    if self.Text_Hide then
      local HiddenText = GText(SquadHiddenTextKey)
      if not HiddenText or "" == HiddenText or HiddenText == SquadHiddenTextKey then
        HiddenText = "阵容不可见"
      end
      self.Text_Hide:SetText(HiddenText)
    end
    return
  end
  local HasAnyData = false
  for SlotIndex = 1, #CharSlotWidgetNames do
    local CharSlotWidget = self[CharSlotWidgetNames[SlotIndex]]
    if CharSlotWidget then
      local SlotData = CharSlots[SlotIndex]
      if SlotData then
        HasAnyData = true
        CharSlotWidget:Init(SlotData)
      else
        CharSlotWidget:Init(nil)
      end
    end
  end
  for SlotIndex = 1, #PhantomSlotWidgetNames do
    local PhantomSlotWidget = self[PhantomSlotWidgetNames[SlotIndex]]
    if PhantomSlotWidget then
      local SlotData = PhantomSlots[SlotIndex]
      if SlotData then
        HasAnyData = true
        PhantomSlotWidget:Init(SlotData)
      else
        PhantomSlotWidget:Init(nil)
      end
    end
  end
  if self.WS_Type then
    if HasAnyData then
      self.WS_Type:SetActiveWidgetIndex(0)
    else
      self.WS_Type:SetActiveWidgetIndex(1)
      return
    end
  end
  if self.WS_Show then
    self.WS_Show:SetActiveWidgetIndex(0)
  end
end

return M
