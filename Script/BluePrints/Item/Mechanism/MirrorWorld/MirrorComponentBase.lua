local MirrorComponentBase = Class({
  "BluePrints.Common.TimerMgr"
})
local REGISTER_RETRY_INTERVAL = 0.5
local REGISTER_MAX_RETRY = 5

function MirrorComponentBase:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  rawset(self, "RegisterRetryCount", 0)
  self:TryRegisterToAreaBox()
end

function MirrorComponentBase:ReceiveEndPlay(EndPlayReason)
  self:RemoveTimer("MirrorRegisterRetry")
  if IsValid(self.OwnerAreaBox) then
    self.OwnerAreaBox:UnregisterMirrorComponent(self)
    self.OwnerAreaBox = nil
  end
  self.Overridden.ReceiveEndPlay(self, EndPlayReason)
end

function MirrorComponentBase:TryRegisterToAreaBox()
  if self:FindAndRegister() then
    self:OnRegisteredToAreaBox()
    return
  end
  self.RegisterRetryCount = self.RegisterRetryCount + 1
  if self.RegisterRetryCount >= REGISTER_MAX_RETRY then
    local Owner = self:GetOwner()
    local Msg = "[MirrorWorld] 配置错误：机关 " .. Owner:GetName() .. " 挂载了镜面世界组件，但未被任何 MirrorAreaBox 覆盖！位置=" .. tostring(Owner:K2_GetActorLocation())
    GWorld.logger.error(Msg)
    UE4.UKismetSystemLibrary.PrintString(self, Msg, true, true, UE4.FLinearColor(1, 0, 0, 1), 10)
    return
  end
  self:AddTimer(REGISTER_RETRY_INTERVAL, self.TryRegisterToAreaBox, false, 0, "MirrorRegisterRetry")
end

function MirrorComponentBase:FindAndRegister()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  local Owner = self:GetOwner()
  if not GameMode or not IsValid(Owner) then
    return false
  end
  local OwnerLocation = Owner:K2_GetActorLocation()
  for _, Actor in pairs(GameMode.BPBornRegionActor) do
    if IsValid(Actor) and Actor:IsA(UE4.AMirrorAreaBox) and Actor:IsPointInArea(OwnerLocation) then
      DebugPrint("yly MirrorComponentBase:FindAndRegister Actor:GetName() = " .. Actor:GetName() .. " is valid")
      self.OwnerAreaBox = Actor
      Actor:RegisterMirrorComponent(self)
      return true
    end
  end
  return false
end

function MirrorComponentBase:HandleMirrorWorldStateChange(NewState, OldState)
  self.OnMirrorWorldStateChange:Broadcast(NewState, OldState)
  self:OnMirrorWorldStateChange_Logic(NewState, OldState)
end

function MirrorComponentBase:OnMirrorWorldStateChange_Logic(NewState, OldState)
end

function MirrorComponentBase:OnRegisteredToAreaBox()
end

return MirrorComponentBase
