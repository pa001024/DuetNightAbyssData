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
  local WSMode = "Character" == ChooseKind and "Confirm" or "Info"
  return {
    StateName = "Choose",
    ChooseKind = ChooseKind,
    TopBarMode = "ChooseTitle",
    SidePanelMode = "Inventory",
    SlotPanelMode = "CharacterSlot",
    WSMode = WSMode,
    CanPreviewCameraRoam = false,
    FocusSlotIndex = Root and Root.GetSelectedCharacterSlotIndex and Root:GetSelectedCharacterSlotIndex() or nil
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
