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
  return {
    StateName = "CharacterEdit",
    ChooseKind = nil,
    TopBarMode = "RootTab",
    SidePanelMode = "CharacterEdit",
    SlotPanelMode = "CharacterSlot",
    WSMode = "Button_SaveOnly",
    CanPreviewCameraRoam = true,
    FocusSlotIndex = Root and Root.GetSelectedCharacterSlotIndex and Root:GetSelectedCharacterSlotIndex() or nil
  }
end

function M:ApplyGamepadInitialFocus()
  local Root = self.OwnerRoot
  local RootViewPanel = Root and Root.RootViewPanel or nil
  if RootViewPanel and RootViewPanel.ApplyGamepadFocusToSelectedCharacterSlot then
    RootViewPanel:ApplyGamepadFocusToSelectedCharacterSlot()
  end
end

return M
