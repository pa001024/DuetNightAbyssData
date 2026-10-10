require("UnLua")
local Component = {}

function Component:_CommitUniqueSlotContent(Content)
  if self.ChooseMode == "Item" then
    if not Content or Content.IsOwned ~= true then
      return false, "not_owned"
    end
    return self.EditRootController:ApplyItemSelection(Content.ItemData)
  end
  if self.ChooseMode == "Pet" then
    return self:_CommitPetSelection(Content)
  end
  return false, "unsupported_mode"
end

function Component:_RefreshUniqueSlotChosenState()
  if self.ChooseMode == "Item" then
    self:_RefreshItemChosenState(self.FilteredContents)
    return
  end
  if self.ChooseMode == "Pet" then
    self:_RefreshPetChosenState(self.FilteredContents)
  end
end

function Component:_RemoveUniqueSlotContent(Content)
  if self.ChooseMode == "Item" then
    return self.EditRootController:RemoveItemChooseSelectionBySlot(Content.ChosenBoxIdx)
  end
  if self.ChooseMode == "Pet" then
    return self.EditRootController:RemovePetChooseSelectionBySlot(Content.ChosenBoxIdx)
  end
  return false
end

function Component:HandleUniqueSlotContentClicked(Content)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_base", nil, nil)
  self:SetSelectedContent(Content)
  local bSuccess, Reason = self:_CommitUniqueSlotContent(Content)
  if bSuccess then
    self:_RefreshUniqueSlotChosenState()
    self:_RefreshFilteredEntryVisuals()
    self:_RefreshChoosePageActionButtons()
    self:RefreshTitle()
    self:RefreshBottomKeyInfo()
    return
  end
  if "slot_missing" == Reason then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Slot_Empty"))
  end
end

function Component:HandleUniqueSlotChosenMinus(Content)
  if not (Content and Content.ChosenBoxIdx) or not self:_RemoveUniqueSlotContent(Content) then
    return
  end
  if self:IsSelectedContent(Content) then
    self:ClearSelectedContent()
  end
  if self.LastSelectedContent == Content then
    self.LastSelectedContent = nil
  end
  if self.LastSelectedListContent == Content then
    self.LastSelectedListContent = nil
  end
  Content.IsChosen = false
  Content.ChosenBoxIdx = nil
  Content.bMinus = false
  Content.bSelectTag = false
  self:_RefreshUniqueSlotChosenState()
  local EntryWidget = self:_GetChooseEntryWidget(Content)
  if EntryWidget then
    self:RefreshEntryVisual(Content, EntryWidget)
  else
    self:_RefreshFilteredEntryVisuals()
  end
  self:_RefreshChoosePageActionButtons()
  self:RefreshTitle()
  self:RefreshBottomKeyInfo()
end

return Component
