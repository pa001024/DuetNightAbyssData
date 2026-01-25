local M = Class({
  "BluePrints.Item.Chest.BP_MechanismBase_C"
})

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
end

function M:OnEnterQTE(Player)
  self.Player = Player
  self.IsInQTE = true
  if 1 == self.CurStage then
    self.QTEUI = UIManager(self):LoadUINew("ZhiLiuDoorQTE", self, self.InteractiveNum, self.InteractiveTime, self.DownTime)
    UIManager(self):HideAllUI_EX({
      "ZhiLiuDoorQTE"
    }, true, "ZhiLiuDoorQTE")
  end
end

function M:OnLeaveQTE(Player)
  if Player then
    Player:RemoveDisableInputTag("ZhiLIUQTE")
  end
  self.Player = nil
  self.IsInQTE = false
  if self.QTEUI then
    self.QTEUI:StopAllAnimations()
    self.QTEUI:PlayAnimation(self.QTEUI.Out)
  end
  UIManager(self):HideAllUI_EX({
    "ZhiLiuDoorQTE"
  }, false, "ZhiLiuDoorQTE")
end

function M:OnQTEEnd()
  self.IsInQTE = false
  if self.Player then
    self.Player:RemoveDisableInputTag("ZhiLIUQTE")
    local RealSubFile = "MechInteractive"
    self.Player:SetEnterInteractive(false, self.InteractiveMontageName, nil, RealSubFile)
  end
  self.QTEUI:PlayAnimation(self.QTEUI.Success)
  UIManager(self):HideAllUI_EX({
    "ZhiLiuDoorQTE"
  }, false, "ZhiLiuDoorQTE")
end

function M:OnEnterInteractive()
  if not self.Player then
    return
  end
  self.Player:AddDisableInputTag("ZhiLIUQTE")
  local RealSubFile = "MechInteractive"
  self.Player:SetEnterInteractive(true, self.InteractiveMontageName, nil, RealSubFile)
  self:OnFirstPress()
end

function M:OnPressInteractive()
end

function M:FirstStageComplete()
  self:ChangeState("Manual", 0, self.SecondStageState)
end

function M:SecondStageComplete()
  self:ChangeState("Manual", 0, self.CompleteStage)
  self:OnQTEEnd()
end

function M:DisablePlayerInput()
  if self.QTEUI then
    self.QTEUI.CanInteract = false
  end
end

function M:EnablePlayerInput()
  if self.QTEUI then
    self.QTEUI.CanInteract = true
  end
end

return M
