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
    StateName = "StickerEdit",
    ChooseKind = nil,
    TopBarMode = "StickerEditTitle",
    SidePanelMode = "None",
    SlotPanelMode = "None",
    WSMode = "None",
    CanPreviewCameraRoam = true,
    FocusSlotIndex = nil
  }
end

function M:ApplyGamepadInitialFocus()
  local Root = self.OwnerRoot
  local RootViewPanel = Root and Root.RootViewPanel or nil
  if RootViewPanel and RootViewPanel.StickersEditWidget and IsValid(RootViewPanel.StickersEditWidget) then
    RootViewPanel.StickersEditWidget:SetFocus()
    return
  end
  if RootViewPanel then
    RootViewPanel:SetFocus()
  end
end

return M
