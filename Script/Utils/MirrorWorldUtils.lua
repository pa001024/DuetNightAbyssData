local MirrorWorldUtils = {}
local FailReason = CommonConst.MirrorSwitchFailReason

function MirrorWorldUtils.FindAreaBoxByLocation(Location)
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not GameMode then
    return nil
  end
  for _, Actor in pairs(GameMode.BPBornRegionActor) do
    if IsValid(Actor) and Actor:IsA(UE4.AMirrorAreaBox) and Actor:IsPointInArea(Location) then
      return Actor
    end
  end
  return nil
end

function MirrorWorldUtils.TrySwitchWorldByItem()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if not IsValid(Player) then
    return FailReason.AreaInvalid
  end
  local AreaBox = MirrorWorldUtils.FindAreaBoxByLocation(Player:K2_GetActorLocation())
  if not AreaBox then
    return FailReason.NotInArea
  end
  return AreaBox:RequestSwitchWorld(Player.Eid or 0)
end

function MirrorWorldUtils.ShowSwitchFailToast(Reason)
  local TextKey = CommonConst.MirrorSwitchFailToast[Reason]
  if not TextKey then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if IsValid(Player) then
    UIManager(Player):ShowUITip(UIConst.Tip_CommonToast, GText(TextKey))
  end
end

return MirrorWorldUtils
