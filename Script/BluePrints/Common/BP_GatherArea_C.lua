local M = Class()

function M:ReceiveBeginPlay()
  GWorld.GameInstance:GetSceneManager():SetGatherArea(self)
end

return M
