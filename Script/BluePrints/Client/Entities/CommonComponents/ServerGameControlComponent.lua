local Component = {}

function Component:SetGameModeLevel(Level)
  ServerPrint("SetGameModeLevel", Level)
  local GameMode = GWorld.GameInstance:GetCurrentGameMode()
  GameMode:SetGameModeLevel(Level)
end

return Component
