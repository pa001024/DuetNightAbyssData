require("UnLua")
local M = Class("BluePrints.Common.TimerMgr")

function M:ReceiveBeginPlay()
  self.Player = UGameplayStatics.GetPlayerCharacter(self, 0)
  self:AddTimer(0.2, function()
    if not self.Player then
      self.Player = UGameplayStatics.GetPlayerCharacter(self, 0)
      return
    end
    local Location = self:k2_GetActorLocation()
    Location:Set(Location.X, Location.Y, self.Player.CurrentLocation.Z)
    if UKismetMathLibrary.Vector_Distance(Location, self.Player.CurrentLocation) < 500 then
      self.NiagaraComponent:SetBoolParameter("DeadTime", true)
      self:RemoveTimer("DistanceCheck")
      UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_ARRIVED"))
      self:AddTimer(1, function()
        EventManager:FireEvent(EventID.OnCommonTrack, CommonConst.RegionMapTrackingType.MarkPoint, self.MarkUuid, false)
      end)
    end
  end, true, 0, "DistanceCheck")
end

function M:ReceiveEndPlay()
  self:RemoveTimer("DistanceCheck")
end

return M
