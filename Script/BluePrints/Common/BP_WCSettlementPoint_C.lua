require("UnLua")
local M = Class()

function M:ReceiveBeginPlay()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState then
    GameState.WCSettlementPoints:Add(self)
  end
end

return M
