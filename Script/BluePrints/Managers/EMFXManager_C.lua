require("Unlua")
require("Const")
local M = Class()

function M:Initialize_Lua()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local IsTakeRecorder = GameInstance and (GameInstance.IsTakeRecorderCapturing or GameInstance.IsTakeRecorderRendering)
  self.bEnableDefaultNiagaraInstance = not IsTakeRecorder
end

return M
