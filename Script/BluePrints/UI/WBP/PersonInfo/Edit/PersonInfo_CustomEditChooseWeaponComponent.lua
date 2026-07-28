require("UnLua")
local Component = {}

function Component:_GetWeaponDraftContext()
  if not self.EditRootController or not self.EditRootController.DisplayEditor then
    return nil, nil
  end
  return self.EditRootController.DisplayEditor:GetDraft(), self.EditRootController:GetSelectedCharacterSlotIndex()
end

function Component:_GetWeaponContentWeaponUuid(Content)
  if not Content or Content.IsEmptyWeapon == true or Content.Uuid == nil then
    return nil
  end
  return Content.Uuid
end

function Component:_GetWeaponContentEquippedSlotIndex(Content)
  local Draft = self:_GetWeaponDraftContext()
  if not Draft then
    return nil
  end
  local WeaponUuid = self:_GetWeaponContentWeaponUuid(Content)
  if not WeaponUuid then
    return nil
  end
  local CharacterSlots = Draft.CharacterSlots or nil
  if not CharacterSlots then
    return nil
  end
  for SlotIndex, Slot in ipairs(CharacterSlots) do
    local SlotWeaponData = Slot and Slot.WeaponData or nil
    if SlotWeaponData and SlotWeaponData.Uuid == WeaponUuid then
      return SlotIndex
    end
  end
  return nil
end

function Component:IsWeaponContentEquipped(Content)
  local Draft, SelectedSlotIndex = self:_GetWeaponDraftContext()
  if not (Content and Draft) or type(SelectedSlotIndex) ~= "number" then
    return false
  end
  local CharacterSlots = Draft.CharacterSlots or nil
  local SelectedSlot = CharacterSlots and CharacterSlots[SelectedSlotIndex] or nil
  if not SelectedSlot or not SelectedSlot.CharData then
    return false
  end
  local SelectedWeaponData = SelectedSlot.WeaponData
  if Content.IsEmptyWeapon == true then
    return nil == SelectedWeaponData
  end
  local WeaponUuid = self:_GetWeaponContentWeaponUuid(Content)
  return nil ~= WeaponUuid and nil ~= SelectedWeaponData and SelectedWeaponData.Uuid == WeaponUuid
end

function Component:IsWeaponContentConflict(Content)
  if not Content or Content.IsEmptyWeapon == true then
    return false
  end
  local _, SelectedSlotIndex = self:_GetWeaponDraftContext()
  local EquippedSlotIndex = self:_GetWeaponContentEquippedSlotIndex(Content)
  if type(EquippedSlotIndex) ~= "number" then
    return false
  end
  return EquippedSlotIndex ~= SelectedSlotIndex
end

function Component:RefreshWeaponEntryConflictVisual(Content, EntryWidget)
  if not Content then
    return
  end
  local bConflict = self:IsWeaponContentConflict(Content)
  Content.bConflict = bConflict
  if not EntryWidget then
    return
  end
  if EntryWidget.SetItemConflict then
    EntryWidget:SetItemConflict(bConflict)
  end
end

function Component:OnWeaponContentClicked(Content)
  if not self:_IsValidChooseContent(Content) then
    return
  end
  if Content.IsEmptyWeapon == true then
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_base", nil, nil)
  end
  DebugPrint(string.format("PersonInfoWeaponChoose: click slot=%s contentUuid=%s empty=%s selectedContentUuid=%s", tostring(self.EditRootController and self.EditRootController.GetSelectedCharacterSlotIndex and self.EditRootController:GetSelectedCharacterSlotIndex() or nil), tostring(Content and Content.Uuid or nil), tostring(Content and Content.IsEmptyWeapon == true), tostring(self.GetSelectedContent and self:GetSelectedContent() and self:GetSelectedContent().Uuid or nil)))
  if self:IsWeaponContentConflict(Content) then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonalPage_WeaponInUse"))
    return
  end
  self:SetSelectedContent(Content)
  local bSuccess, Reason = self:_CommitWeaponSelection(Content)
  DebugPrint(string.format("PersonInfoWeaponChoose: commit result success=%s reason=%s slot=%s contentUuid=%s", tostring(true == bSuccess), tostring(Reason), tostring(self.EditRootController and self.EditRootController.GetSelectedCharacterSlotIndex and self.EditRootController:GetSelectedCharacterSlotIndex() or nil), tostring(Content and Content.Uuid or nil)))
  if bSuccess then
    self:_RefreshFilteredEntryVisuals()
    self.EditRootController.RootViewPanel:RefreshCommonActionState()
    self:RefreshTitle()
    return
  end
  if "character_missing" == Reason then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Slot_Empty"))
    return
  end
  if "weapon_conflict" == Reason then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_PersonalPage_WeaponInUse"))
  end
end

return Component
