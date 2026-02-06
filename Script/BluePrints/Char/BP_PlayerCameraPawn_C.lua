local M = Class()

function M:ReceiveBeginPlay()
  GWorld.PlayerCameraPawn = self
  self.PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.bUseControllerRotationYaw = true
  self.bUseControllerRotationPitch = true
  self.CharSpringArmComponent.bDoCollisionTest = false
end

function M:ShowCursor_Press()
  DebugPrint("ShowCursor_Press", UE4.UKismetSystemLibrary.GetFrameCount())
  local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if not IsValid(GameInputSubsystem) then
    return
  end
  GameInputSubsystem:HandleShowCursorPressOrRelease(true)
end

function M:ShowCursor_Release()
  DebugPrint("ShowCursor_Release", UE4.UKismetSystemLibrary.GetFrameCount())
  local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if not IsValid(GameInputSubsystem) then
    return
  end
  GameInputSubsystem:HandleShowCursorPressOrRelease(false)
end

function M:OnPressQ()
  local UIObj = UIManager(self):GetUIObj("AutoChessBattlePage")
  if not UIObj or not UIObj.BattleStatisticsTips then
    return
  end
  UIObj.BattleStatisticsTips:AllyFight_OnClicked()
end

function M:OnPressE()
  local UIObj = UIManager(self):GetUIObj("AutoChessBattlePage")
  if not UIObj or not UIObj.BattleStatisticsTips then
    return
  end
  UIObj.BattleStatisticsTips:EnemyFight_OnClicked()
end

return M
