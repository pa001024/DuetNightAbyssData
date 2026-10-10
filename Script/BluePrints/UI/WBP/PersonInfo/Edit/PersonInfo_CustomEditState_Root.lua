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
  if Root.HandleEnterRootState then
    Root:HandleEnterRootState()
  end
end

function M:Exit()
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
  local bIsItemPage = Root and Root.IsItemMainPageActive and Root:IsItemMainPageActive()
  return {
    StateName = "Root",
    ChooseKind = nil,
    TopBarMode = "RootTab",
    SidePanelMode = "None",
    DetailContentKind = bIsItemPage and "Item" or "Character",
    SlotPanelMode = bIsItemPage and "ItemSlot" or "CharacterSlot",
    WSMode = "Button_SaveAdd",
    CanPreviewCameraRoam = true,
    FocusSlotIndex = bIsItemPage and Root:GetSelectedItemSlotIndex() or Root and Root.GetSelectedCharacterSlotIndex and Root:GetSelectedCharacterSlotIndex() or nil
  }
end

function M:ApplyGamepadInitialFocus()
  local Root = self.OwnerRoot
  local RootViewPanel = Root and Root.RootViewPanel or nil
  if not RootViewPanel then
    return
  end
  RootViewPanel:ApplyGamepadFocusToSelectedCharacterSlot()
end

return M
