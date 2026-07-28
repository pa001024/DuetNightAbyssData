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
  return {
    StateName = "Scene",
    ChooseKind = nil,
    TopBarMode = "RootTab",
    SidePanelMode = "None",
    SlotPanelMode = "SceneSlot",
    WSMode = "Button_SaveOnly",
    CanPreviewCameraRoam = true,
    FocusSlotIndex = nil
  }
end

function M:ApplyGamepadInitialFocus()
  local Root = self.OwnerRoot
  local ScenePagePanel = Root and Root.ScenePagePanel or nil
  if ScenePagePanel and ScenePagePanel.FocusGamepadDefaultSceneItem then
    ScenePagePanel:FocusGamepadDefaultSceneItem()
    return
  end
  local RootViewPanel = Root and Root.RootViewPanel or nil
  if RootViewPanel then
    RootViewPanel:SetFocus()
  end
end

return M
