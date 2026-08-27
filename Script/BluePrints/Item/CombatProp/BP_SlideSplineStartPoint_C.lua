require("UnLua")
local M = Class()

function M:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  if not (IsStandAlone(self) and self.StartPointName) or self.StartPointName == "" then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if IsValid(GameMode) and GameMode:RegisterSlideSplineStartPoint(self) then
    self.SlideStartGameMode = GameMode
  end
end

function M:ReceiveEndPlay(Reason)
  if IsValid(self.SlideStartGameMode) then
    self.SlideStartGameMode:UnregisterSlideSplineStartPoint(self)
  end
  self.SlideStartGameMode = nil
  self.Overridden.ReceiveEndPlay(self, Reason)
end

return M
