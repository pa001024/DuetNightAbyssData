local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local M = {}
local UniqueSlotChooseConfig = {
  Item = {
    TransactionKey = "item_choose",
    BaseDraftField = "ItemChooseBaseDraft",
    SkipCancelField = "SkipCancelItemChooseOnce",
    SlotsField = "ItemSlots",
    DataField = "ItemData",
    MissingReason = "item_missing",
    KeyField = "ItemId"
  },
  Pet = {
    TransactionKey = "pet_choose",
    BaseDraftField = "PetChooseBaseDraft",
    SkipCancelField = "SkipCancelPetChooseOnce",
    SlotsField = "PetSlots",
    DataField = "PetData",
    MissingReason = "pet_missing",
    KeyField = "UniqueId"
  }
}

function M:ApplyItemSelection(ItemData)
  return self:_ApplyUniqueSlotSelection("Item", ItemData)
end

function M:ApplyPetSelection(PetData)
  return self:_ApplyUniqueSlotSelection("Pet", PetData)
end

function M:RemoveItemChooseSelectionBySlot(SlotIndex)
  return self:_RemoveUniqueSlotChooseSelectionBySlot("Item", SlotIndex)
end

function M:RemovePetChooseSelectionBySlot(SlotIndex)
  return self:_RemoveUniqueSlotChooseSelectionBySlot("Pet", SlotIndex)
end

function M:ConfirmItemChoosePage()
  return self:_ConfirmUniqueSlotChoosePage("Item")
end

function M:ConfirmPetChoosePage()
  return self:_ConfirmUniqueSlotChoosePage("Pet")
end

function M:CancelItemChooseChanges()
  return self:_CancelUniqueSlotChooseChanges("Item")
end

function M:CancelPetChooseChanges()
  local bCanceled = self:_CancelUniqueSlotChooseChanges("Pet")
  self:_SyncFocusedPetHighlight()
  return bCanceled
end

function M:_ApplyUniqueSlotSelection(Mode, Data)
  local Config = UniqueSlotChooseConfig[Mode]
  local GetSelectedSlotIndex = Config and self["GetSelected" .. Mode .. "SlotIndex"] or nil
  local SlotIndex = GetSelectedSlotIndex and GetSelectedSlotIndex(self) or nil
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false, "slot_missing"
  end
  if not Data then
    return false, Config.MissingReason
  end
  local bSuccess = self.DisplayEditor["Set" .. Mode .. "ToSlot"](self.DisplayEditor, SlotIndex, Data) == true
  if bSuccess then
    self:_RefreshUniqueSlotChooseRootState(Mode)
    self["_SelectNextEditableEmpty" .. Mode .. "Slot"](self)
  end
  return bSuccess
end

function M:_RefreshUniqueSlotChooseRootState(Mode)
  local Config = UniqueSlotChooseConfig[Mode]
  local RootView = self.RootViewPanel
  if not Config or not RootView then
    return
  end
  local SlotCount = DisplayConfig["Get" .. Mode .. "SlotCount"](DisplayConfig)
  for SlotIndex = 1, SlotCount do
    RootView["Refresh" .. Mode .. "SlotItem"](RootView, SlotIndex)
  end
  if RootView.RefreshCommonActionState then
    RootView:RefreshCommonActionState()
  end
  if RootView.RefreshTitleText then
    RootView:RefreshTitleText()
  end
end

function M:_RemoveUniqueSlotChooseSelectionBySlot(Mode, SlotIndex)
  local Config = UniqueSlotChooseConfig[Mode]
  if not Config or self.ActiveChooseMode ~= Mode then
    return false
  end
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return false
  end
  local Slot = self["_Get" .. Mode .. "Slot"](self, SlotIndex)
  if not DisplayDraft["Is" .. Mode .. "SlotOccupied"](DisplayDraft, Slot) or self.DisplayEditor["Remove" .. Mode .. "FromSlot"](self.DisplayEditor, SlotIndex) ~= true then
    return false
  end
  self:_RefreshUniqueSlotChooseRootState(Mode)
  if self["GetSelected" .. Mode .. "SlotIndex"](self) == SlotIndex then
    self["_SelectNextEditableEmpty" .. Mode .. "Slot"](self)
    if self["GetSelected" .. Mode .. "SlotIndex"](self) == SlotIndex then
      if "Pet" == Mode and self.DisplayController then
        self.DisplayController:ClearFocusHighlight()
      end
      self["RefreshSelected" .. Mode .. "SlotContext"](self)
    end
  elseif "Pet" == Mode then
    self:_SyncFocusedPetHighlight()
  end
  return true
end

function M:_ConfirmUniqueSlotChoosePage(Mode)
  local Config = UniqueSlotChooseConfig[Mode]
  local CanConfirm = self["CanConfirm" .. Mode .. "ChoosePage"]
  if not Config or self.ActiveChooseMode ~= Mode or not self.DisplayEditor then
    return false
  end
  if not CanConfirm or true ~= CanConfirm(self) then
    return false
  end
  if self.DisplayEditor.IsPreviewTransactionActive and self.DisplayEditor:IsPreviewTransactionActive(Config.TransactionKey) and self.DisplayEditor.AcceptPreviewTransaction then
    self.DisplayEditor:AcceptPreviewTransaction()
  end
  self[Config.SkipCancelField] = true
  self[Config.BaseDraftField] = nil
  self:CloseChoosePageAndReturn()
  return true
end

function M:_BeginUniqueSlotChoosePreview(Mode)
  local Config = UniqueSlotChooseConfig[Mode]
  if not (Config and self.DisplayEditor) or not self.DisplayEditor.BeginPreviewTransaction then
    return false
  end
  if self.DisplayEditor.IsPreviewTransactionActive and self.DisplayEditor:IsPreviewTransactionActive(Config.TransactionKey) then
    return true
  end
  return self.DisplayEditor:BeginPreviewTransaction(Config.TransactionKey) == true
end

function M:_CancelUniqueSlotChooseChanges(Mode)
  local Config = UniqueSlotChooseConfig[Mode]
  if not Config or not self.DisplayEditor then
    return false
  end
  local bRestored = false
  if self.DisplayEditor.IsPreviewTransactionActive and self.DisplayEditor:IsPreviewTransactionActive(Config.TransactionKey) and self.DisplayEditor.CancelPreviewTransaction then
    bRestored = self.DisplayEditor:CancelPreviewTransaction() == true
  elseif self[Config.BaseDraftField] then
    bRestored = true == self.DisplayEditor["Restore" .. Mode .. "SlotsFromDraft"](self.DisplayEditor, self[Config.BaseDraftField])
  end
  self[Config.BaseDraftField] = nil
  if bRestored then
    self:_RefreshUniqueSlotChooseRootState(Mode)
  end
  return bRestored
end

return M
