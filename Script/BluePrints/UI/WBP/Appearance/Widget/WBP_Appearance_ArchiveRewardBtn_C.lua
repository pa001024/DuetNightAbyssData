require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Area.OnClicked:Add(self, self.OnCellClicked)
  self.Btn_Area.OnHovered:Add(self, self.OnCellHovered)
  self.Btn_Area.OnUnhovered:Add(self, self.OnCellUnhovered)
  self.Btn_Area.OnPressed:Add(self, self.OnCellPressed)
  self.Btn_Area.OnReleased:Add(self, self.OnCellReleased)
  self.IsHovering = false
  self.IsPressing = false
  self.OnClickedObj = nil
  self.OnClickedFunc = nil
  self.Btn_Area.OnClicked:Add(self, self.OnCellClicked)
  self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if not ReddotManager.GetTreeNode("AppearanceFenghuaReward") then
    ReddotManager.AddNodeEx("AppearanceFenghuaReward")
  end
  ReddotManager.AddListenerEx("AppearanceFenghuaReward", self, self.RefreshRewardReddot)
end

function M:Destruct()
  self.OnClickedObj = nil
  self.OnClickedFunc = nil
  ReddotManager.RemoveListener("AppearanceFenghuaReward", self)
end

function M:BindEventOnClicked(Obj, Func)
  self.OnClickedObj = Obj
  self.OnClickedFunc = Func
end

function M:OnCellClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_stage_btn_click", nil, nil)
  if self.OnClickedObj and self.OnClickedFunc then
    self.OnClickedFunc(self.OnClickedObj)
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
end

function M:OnCellHovered()
  self.IsHovering = true
  if self.IsPressing then
    return
  end
  if self:IsAnimationPlaying(self.Click) then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
end

function M:OnCellUnhovered()
  self.IsHovering = false
  if self:IsAnimationPlaying(self.Click) then
    return
  end
  if not self.IsPressing then
    self:StopAllAnimations()
    self:PlayAnimation(self.Unhover)
  end
end

function M:OnCellPressed()
  self.IsPressing = true
  if self:IsAnimationPlaying(self.Click) then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnCellReleased()
  self.IsPressing = false
  if self:IsAnimationPlaying(self.Click) then
    return
  end
  if not self.IsHovering then
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
  end
end

function M:RefreshRewardReddot()
  local Node = ReddotManager.GetTreeNode("AppearanceFenghuaReward")
  if Node.Count > 0 then
    self.Reddot:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M
