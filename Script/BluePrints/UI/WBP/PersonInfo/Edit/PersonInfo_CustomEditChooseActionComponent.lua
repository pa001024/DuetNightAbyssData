require("UnLua")
local Component = {}

function Component:IsActionContentEquipped(Content)
  if not Content then
    return false
  end
  if self._IsActionContentChosen then
    return self:_IsActionContentChosen(Content)
  end
  if not self.EditRootController or not self.EditRootController.DisplayEditor then
    return false
  end
  local Draft = self.EditRootController.DisplayEditor:GetDraft()
  local CharacterSlots = Draft and Draft.CharacterSlots or nil
  if not CharacterSlots then
    return false
  end
  local SlotIndex = self.EditRootController.GetSelectedCharacterSlotIndex and self.EditRootController:GetSelectedCharacterSlotIndex() or nil
  local Slot = SlotIndex and CharacterSlots[SlotIndex] or nil
  if not Slot or not Slot.CharData then
    return false
  end
  local ActionData = Slot.Action
  local PoseId = ActionData and ActionData.PoseId or nil
  if Content.IsDefaultAction == true then
    return nil == PoseId
  end
  return Content.PoseId ~= nil and Content.PoseId == PoseId
end

function Component:OnActionContentClicked(Content)
  if not self:_IsValidChooseContent(Content) then
    return
  end
  if Content.IsDefaultAction == true then
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_base", nil, nil)
  elseif Content.ResourceId ~= nil and -1 ~= Content.ResourceId then
    AudioManager(self):PlayItemSound(self, Content.ResourceId, "Click", CommonConst.DataType.Resource)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
  end
  self:SetSelectedContent(Content)
  local bSuccess, Reason = self:_CommitActionSelection(Content)
  if bSuccess then
    self:_RefreshFilteredEntryVisuals()
    self.EditRootController.RootViewPanel:RefreshCommonActionState()
    self:RefreshTitle()
    return
  end
  if "character_missing" == Reason then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Slot_Empty"))
  end
end

return Component
