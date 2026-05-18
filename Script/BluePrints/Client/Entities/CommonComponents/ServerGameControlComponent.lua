local Component = {}

function Component:SetGameModeLevel(Level)
  ServerPrint("SetGameModeLevel", Level)
  
  local function LocalSetGameModeLevel()
    local GameMode = GWorld.GameInstance:GetCurrentGameMode()
    GameMode:SetGameModeLevel(Level)
  end
  
  if not self.bClientEntity then
    local bLocal = false
    
    local function cb()
      bLocal = true
    end
    
    self:NotifyServerDungeonEventWithCallback(cb, "SetGameModeLevel", Level)
    if bLocal then
      LocalSetGameModeLevel()
    end
  else
    LocalSetGameModeLevel()
  end
end

return Component
