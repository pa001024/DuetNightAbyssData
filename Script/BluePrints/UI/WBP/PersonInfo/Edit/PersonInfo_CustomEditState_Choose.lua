local M = {}

function M:New(OwnerRoot)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj.OwnerRoot = OwnerRoot
  return Obj
end

function M:Enter(Params)
  self.EnterParams = Params
  local Root = self.OwnerRoot
  if not Root then
    return
  end
  if Root.HandleEnterChooseState then
    Root:HandleEnterChooseState(Params)
  end
end

function M:Exit()
  local Root = self.OwnerRoot
  if Root and Root.HandleExitChooseState then
    Root:HandleExitChooseState(self.EnterParams)
  end
  self.EnterParams = nil
end

function M:HandleBack()
  return false
end

function M:HandleSlotClick()
  return false
end

function M:HandleInput()
  return false
end

function M:BuildUIModel()
  local Root = self.OwnerRoot
  local ChooseKind = Root and Root.ActiveChooseMode or "Character"
  local bIsPetChoose = "Pet" == ChooseKind
  local bIsItemChoose = "Item" == ChooseKind
  local WSMode = ("Character" == ChooseKind or bIsPetChoose or bIsItemChoose) and "Confirm" or "Info"
  local FocusSlotIndex
  if bIsItemChoose then
    FocusSlotIndex = Root and Root.GetSelectedItemSlotIndex and Root:GetSelectedItemSlotIndex() or nil
  elseif bIsPetChoose then
    FocusSlotIndex = Root and Root.GetSelectedPetSlotIndex and Root:GetSelectedPetSlotIndex() or nil
  else
    FocusSlotIndex = Root and Root.GetSelectedCharacterSlotIndex and Root:GetSelectedCharacterSlotIndex() or nil
  end
  return {
    StateName = "Choose",
    ChooseKind = ChooseKind,
    TopBarMode = "ChooseTitle",
    SidePanelMode = "Inventory",
    SlotPanelMode = bIsItemChoose and "ItemSlot" or bIsPetChoose and "PetSlot" or "CharacterSlot",
    WSMode = WSMode,
    CanPreviewCameraRoam = false,
    FocusSlotIndex = FocusSlotIndex
  }
end

function M:ApplyGamepadInitialFocus()
  local Root = self.OwnerRoot
  local ChoosePagePanel = Root and Root.ChoosePagePanel or nil
  if ChoosePagePanel and ChoosePagePanel.FocusGamepadDefaultListItem then
    ChoosePagePanel:FocusGamepadDefaultListItem()
    return
  end
  local RootViewPanel = Root and Root.RootViewPanel or nil
  if RootViewPanel then
    RootViewPanel:SetFocus()
  end
end

return M
