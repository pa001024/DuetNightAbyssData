local FDisableCameraArmComponent = {}

function FDisableCameraArmComponent:New(Player)
  local DisableCharacterDitherComponent = setmetatable({}, {__index = FDisableCameraArmComponent})
  DisableCharacterDitherComponent.Player = Player
  return DisableCharacterDitherComponent
end

function FDisableCameraArmComponent:Execute()
  if IsValid(self.Player) and IsValid(self.Player.CharSpringArmComponent) then
    self.PreState = self.Player.CharSpringArmComponent.bArmCollision
    self.Player.CharSpringArmComponent.bArmCollision = false
  end
  DebugPrint("FDisableCameraArmComponent:Execute PreState", self.PreState)
end

function FDisableCameraArmComponent:Resume()
  if IsValid(self.Player) and IsValid(self.Player.CharSpringArmComponent) then
    DebugPrint("FDisableCameraArmComponent:Resume PreState NowState", self.PreState, self.Player.CharSpringArmComponent.bArmCollision)
    self.Player.CharSpringArmComponent.bArmCollision = self.PreState
  else
    DebugPrint("FDisableCameraArmComponent:Resume Player or CharSpringArmComponent is not valid")
  end
end

return FDisableCameraArmComponent
