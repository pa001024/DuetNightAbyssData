require("UnLua")
local BP_RaceLotteryInteractiveComponent_C = Class({
  "BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C",
  "BluePrints.Common.TimerMgr"
})
local LuaConst = require("EMLuaConst")

function BP_RaceLotteryInteractiveComponent_C:ReceiveBeginPlay()
  self.Super.ReceiveBeginPlay(self)
  self.Owner = self:GetOwner()
end

function BP_RaceLotteryInteractiveComponent_C:IsCanInteractive(PlayerActor)
  if not self.Owner then
    return false
  end
  if LuaConst.OpenComputeInteractive then
    return self:GetDistanceCheckResult() and self.BFaceToACheck(self.Owner, PlayerActor, self.InteractiveFaceAngle, true) and not self.Owner.bHidden
  else
    return self.DistanceCheck(self.Owner, PlayerActor, self.InteractiveDistance) and self.BFaceToACheck(self.Owner, PlayerActor, self.InteractiveFaceAngle, true) and not self.Owner.bHidden
  end
end

function BP_RaceLotteryInteractiveComponent_C:StartInteractive(PlayerActor)
  if not self.Owner then
    return
  end
  if not CommonUtils.IsRaceLotteryGetRewardTime() then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonTop, GText("UI_RaceLottery_Toast_NotInRewardTime"))
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    UIManager(GWorld.GameInstance):SetBannedActionCallback("BlackScreen", true, "PetRaceStart")
    Avatar:RaceLotteryQueryRandomRaceId()
  end
end

function BP_RaceLotteryInteractiveComponent_C:BtnPressed(PlayerActor)
  if self:IsLocked() then
    return
  end
  self:StartInteractive(PlayerActor)
end

return BP_RaceLotteryInteractiveComponent_C
