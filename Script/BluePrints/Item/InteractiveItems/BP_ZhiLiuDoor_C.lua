local M = Class({
  "BluePrints.Item.Chest.BP_MechanismBase_C"
})

function M:CommonInitInfo(Info)
  M.Super.CommonInitInfo(self, Info)
end

function M:OnActorReady(Info)
  M.Super.OnActorReady(self, Info)
end

function M:OnEnterQTE(Player)
  self.Player = Player
  self.IsInQTE = true
  if 1 == self.CurStage then
    self.QTEUI = UIManager(self):LoadUINew("ZhiLiuDoorQTE", self, self.InteractiveNum, self.InteractiveTime, self.DownTime)
    UIManager(self):HideAllUI_EX({
      "ZhiLiuDoorQTE"
    }, true, "ZhiLiuDoorQTE")
    self:DisableOpenMenu()
  end
end

function M:OnLeaveQTE(Player)
  if Player then
    Player:RemoveDisableInputTag("ZhiLIUQTE")
  end
  self.Player = nil
  self.IsInQTE = false
  if self.QTEUI then
    self.QTEUI:OnOut()
  end
  UIManager(self):HideAllUI_EX({
    "ZhiLiuDoorQTE"
  }, false, "ZhiLiuDoorQTE")
  self:RestoreOpenMenu()
end

function M:OnQTEEnd()
  self.IsInQTE = false
  if self.Player then
    self.Player:RemoveDisableInputTag("ZhiLIUQTE")
    local RealSubFile = "MechInteractive"
    self.Player:SetEnterInteractive(false, self.InteractiveMontageName, nil, RealSubFile)
  end
  self.QTEUI:OnEnd()
  UIManager(self):HideAllUI_EX({
    "ZhiLiuDoorQTE"
  }, false, "ZhiLiuDoorQTE")
  self:RestoreOpenMenu()
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

function M:DisableOpenMenu()
  self.InputSetting = UE4.UInputSettings.GetInputSettings()
  self.SavedActionMappings = UE4.TArray(UE4.FInputActionKeyMapping)
  self.InputSetting:GetActionMappingByName("OpenMenu", self.SavedActionMappings)
  for i = 1, self.SavedActionMappings:Length() do
    self.InputSetting:RemoveActionMapping(self.SavedActionMappings:Get(i))
  end
end

function M:RestoreOpenMenu()
  self.InputSetting = UE4.UInputSettings.GetInputSettings()
  if self.SavedActionMappings then
    for i = 1, self.SavedActionMappings:Length() do
      self.InputSetting:AddActionMapping(self.SavedActionMappings:Get(i))
    end
    self.SavedActionMappings = nil
  end
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

function M:StartTeleport()
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local CurLocation = PlayerCharacter:K2_GetActorLocation()
  DebugPrint("zwk StartTeleport CurLocation: ", CurLocation)
  PlayerCharacter:K2_TeleportTo(self.TargetLocation, self.TargetRotation, false, nil, false)
  PlayerCharacter:ResetIdle()
  PlayerCharacter:GetController():SetControlRotation(self.TargetRotation)
  local NewLocation = PlayerCharacter:K2_GetActorLocation()
  DebugPrint("zwk StartTeleport NewLocation: ", NewLocation)
end

return M
