require("UnLua")
local M = Class("Blueprints.UI.BP_UIState_C")

function M:Construct()
  if self.Btn_Click then
    if self.Btn_Click.UnBindEventOnClickedByObj then
      self.Btn_Click:UnBindEventOnClickedByObj(self)
    end
    if self.Btn_Click.BindEventOnClicked then
      self.Btn_Click:BindEventOnClicked(self, self.OnClicked)
    elseif self.Btn_Click.OnClicked then
      self.Btn_Click.OnClicked:Add(self, self.OnClicked)
    end
  end
end

function M:Setup(Idx, RequiredActiveness, ActivityLevel, bGot)
  self.Idx = Idx
  self.RequiredActiveness = RequiredActiveness
  self.ActivityLevel = ActivityLevel
  self.bGot = bGot
  self.bCanGet = RequiredActiveness <= ActivityLevel and not bGot
  if self.Reddot then
    if self.bCanGet then
      self.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  self:StopAllAnimations()
  if bGot then
    self:PlayAnimation(self.UnLock)
  elseif RequiredActiveness <= ActivityLevel then
    self:PlayAnimation(self.Act)
  else
    self:PlayAnimation(self.Lock)
  end
end

function M:OnClicked()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local bReached = self.ActivityLevel >= self.RequiredActiveness
  if bReached and not self.bGot then
    if GuildController then
      GuildController:SendRpcGetGuildActivityPointReward(-1)
    end
  elseif self.ParentUI and self.ParentUI.ShowAllActivityRewardPreview then
    self.ParentUI:ShowAllActivityRewardPreview()
  end
end

function M:Destruct()
  if self.Btn_Click and self.Btn_Click.UnBindEventOnClickedByObj then
    self.Btn_Click:UnBindEventOnClickedByObj(self)
  end
  self.Super.Destruct(self)
end

return M
