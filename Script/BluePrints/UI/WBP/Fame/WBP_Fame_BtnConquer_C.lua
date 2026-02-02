require("UnLua")
local ReputationType = {Task = 1, Entrust = 2}
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.IsPC = CommonUtils.GetRuntimePlatform(self) == "PC"
  self.Button_Area.OnClicked:Add(self, self.OnClicked)
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnReleased)
  self.Button_Area.OnHovered:Add(self, self.OnHovered)
  self.Button_Area.OnUnhovered:Add(self, self.OnUnhovered)
  self.TextRefresTime:SetText(GText("RegionReputation_RefreshTime"))
end

function M:SetTextRefresTime(RefresTimeText)
  self.TextRefresTime_1:SetText(RefresTimeText)
end

function M:OnClicked()
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:OnPressed()
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnReleased()
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:OnHovered()
  if not self.IsPC then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
end

function M:OnUnhovered()
  if not self.IsPC then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.UnHover)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Click and self.Obj and self.Func then
    self.Func(self.Obj, table.unpack(self.Params))
  end
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

return M
