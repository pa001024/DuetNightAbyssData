require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Initialize(Initializer)
  self.IsSelect = false
  self.IsCantInteractable = false
end

function M:Construct()
  self.SoundFunc = self.PlayButtonClickSound
  self.AutoSelectWhenHover = false
  self.IsPC = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
end

function M:BindEventOnClicked(Obj, Func, ...)
  if not Obj or not Func then
    return
  end
  self.Obj = Obj
  self.Func = Func
  self.Params = {
    ...
  }
end

function M:SetAutoSelectWhenHoverInGamePadMod()
  self.AutoSelectWhenHover = true
end

function M:SetCanCancelSelection(CanCancelSelection)
  self.CanCancelSelection = CanCancelSelection
end

function M:OnCellClicked(bNotPlaySound)
  if self.IsSelect then
    if self.CanCancelSelection then
      self:OnCellUnSelect()
      if self.Obj and self.Func then
        self.Func(self.Obj, table.unpack(self.Params))
      end
    end
    return
  end
  self:SelectCell()
  if self.Obj and self.Func then
    self.Func(self.Obj, table.unpack(self.Params))
  end
  if not bNotPlaySound then
    self.SoundFunc(self)
  end
end

function M:PlayButtonClickSound()
  UIUtils.PlayCommonBtnSe(self)
end

function M:TryOverrideSoundFunc(NewSoundFunc)
  if NewSoundFunc then
    self.SoundFunc = NewSoundFunc
  end
end

function M:SelectCell()
  if self.IsCantInteractable then
    return
  end
  self.IsSelect = true
  self:StopAllAnimations()
  self:PlayAnimation(self.Select)
end

function M:OnCellHovered()
  if self.IsCantInteractable or self.IsSelect or not self.IsPC then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self.AutoSelectWhenHover then
    self:OnCellClicked()
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
end

function M:OnCellUnhovered()
  if self.IsCantInteractable or self.IsSelect or not self.IsPC then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self.AutoSelectWhenHover then
    self:OnCellUnSelect()
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.UnHover)
end

function M:OnCellPressed()
  if self.IsCantInteractable or self.IsSelect then
    if self.CanCancelSelection then
      self:StopAllAnimations()
      self:PlayAnimation(self.Press)
    end
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnCellReleased()
  if self.IsCantInteractable or self.IsSelect then
    if self.CanCancelSelection then
      self:StopAllAnimations()
      self:PlayAnimation(self.Select)
    end
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:OnCellUnSelect()
  if self.IsCantInteractable then
    return
  end
  self:StopAllAnimations()
  self.IsSelect = false
  self:PlayAnimation(self.Normal)
end

function M:OnAddedToFocusPath(InFocusEvent)
  EventManager:FireEvent(EventID.FoucsDungeonSelectLevel)
end

function M:SetButtonState(State)
  self.Button_Area:SetVisibility(State)
end

function M:SetSelectState()
  self.IsSelect = true
  self.Bg_Light:SetColorAndOpacity(UE4.FLinearColor(1, 1, 1, 1))
  self.Bg_Outline:SetColorAndOpacity(UE4.FLinearColor(1, 1, 1, 1))
  self.VX_Bg:SetRenderOpacity(0.1)
end

function M:SetUnSelectState()
  self.IsSelect = false
  self.Bg_Light:SetColorAndOpacity(UE4.FLinearColor(0, 0, 0, 0.2))
  self.Bg_Outline:SetColorAndOpacity(UE4.FLinearColor(1, 1, 1, 0.1))
  self.VX_Bg:SetRenderOpacity(0)
end

return M
