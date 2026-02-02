require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(Hook)
  if not self.bInit then
    self.Button_Area.OnClicked:Add(self, self.OnClickButton)
    self:BindToAnimationFinished(self.Out, {
      self,
      function()
        self.bAnimEnd = true
        self:SetVisibility(ESlateVisibility.Collapsed)
      end
    })
    self.bInit = true
  end
  self.bAnimEnd = true
  self:Open(Hook)
end

function M:OnClickButton()
  if not IsValid(self.HookComp) then
    return
  end
  self.HookComp:StartInteractive(self.Player)
end

function M:Open(Hook)
  if self.bOpen or not self.bAnimEnd then
    return
  end
  if self:IsAnimationPlaying(self.Out) then
    self:StopAnimation(self.Out)
  end
  self.bOpen = true
  self:SetVisibility(ESlateVisibility.Visible)
  self:PlayAnimation(self.In)
end

function M:Close(Hook)
  if not self.bOpen then
    return
  end
  self.bAnimEnd = false
  self:PlayAnimation(self.Out)
  self.Hook = nil
  self.HookComp = nil
  self.Player = nil
  self.bOpen = false
end

function M:UpdateOwner(Hook, HookComp, PlayerActor)
  self.Hook = Hook
  self.HookComp = HookComp
  self.Player = PlayerActor
end

return M
