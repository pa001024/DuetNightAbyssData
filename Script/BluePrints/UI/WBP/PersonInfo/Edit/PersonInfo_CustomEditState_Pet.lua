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
  local bShowDetail = Root and Root.ShouldShowPetDetailPanel and Root:ShouldShowPetDetailPanel() == true
  return {
    StateName = "Pet",
    ChooseKind = nil,
    TopBarMode = "RootTab",
    SidePanelMode = bShowDetail and "CharacterEdit" or "None",
    SlotPanelMode = "PetSlot",
    WSMode = bShowDetail and "Button_SaveOnly" or "Button_SaveAdd",
    CanPreviewCameraRoam = true,
    FocusSlotIndex = Root and Root.GetSelectedPetSlotIndex and Root:GetSelectedPetSlotIndex() or nil
  }
end

function M:ApplyGamepadInitialFocus()
  local Root = self.OwnerRoot
  local RootViewPanel = Root and Root.RootViewPanel or nil
  if RootViewPanel and RootViewPanel.SetFocus_Lua then
    RootViewPanel:SetFocus_Lua()
    return
  end
  if RootViewPanel then
    RootViewPanel:SetFocus()
  end
end

return M
