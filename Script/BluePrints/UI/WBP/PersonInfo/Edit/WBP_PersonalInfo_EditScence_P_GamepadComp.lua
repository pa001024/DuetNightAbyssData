local Component = {}

local function IsGamepadInput(Owner)
  if Owner.CurInputDeviceType ~= nil then
    return Owner.CurInputDeviceType == ECommonInputType.Gamepad
  end
  local RootOwner = Owner.EditRootController and Owner.EditRootController.OwnerWidget or nil
  return nil ~= RootOwner and RootOwner.CurInputDeviceType == ECommonInputType.Gamepad
end

local function GetTimerOwner(Owner)
  local EditRootController = Owner and Owner.EditRootController or nil
  if not EditRootController then
    return nil
  end
  return EditRootController.RootViewPanel or EditRootController.OwnerWidget
end

function Component:RefreshView()
  if not IsGamepadInput(self) then
    return
  end
  
  local function RefreshFocus()
    if not IsGamepadInput(self) then
      return
    end
    if self.List_Scence and #self.SceneItemContents > 0 then
      self.List_Scence:SetFocus()
    else
      self:SetFocus()
    end
  end
  
  local TimerOwner = GetTimerOwner(self)
  if TimerOwner and TimerOwner.AddTimer then
    TimerOwner:AddTimer(0.05, RefreshFocus)
    return
  end
  RefreshFocus()
end

function Component:FocusGamepadDefaultSceneItem()
  self:RefreshView()
end

function Component:Handle_ScenePageGamepadKeyDown(InKeyName)
  if not IsGamepadInput(self) then
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    if self.List_Scence and self.List_Scence.BP_GetSelectedItem then
      local SelectedContent = self.List_Scence:BP_GetSelectedItem()
      if SelectedContent and SelectedContent.SceneId then
        self:OnSceneEntryClicked(SelectedContent, nil)
        return true
      end
    end
    local DefaultContent = self.SceneItemContents and self.SceneItemContents[1] or nil
    if DefaultContent and DefaultContent.SceneId then
      self:OnSceneEntryClicked(DefaultContent, nil)
      return true
    end
  end
  return false
end

return Component
