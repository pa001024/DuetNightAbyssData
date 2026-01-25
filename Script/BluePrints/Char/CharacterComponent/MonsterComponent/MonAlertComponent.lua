require("UnLua")
require("Const")
local Component = Class()

function Component:InitComponent_Lua()
  rawset(self, "AlertData", DataMgr.AlertData[self.AlertId])
end

function Component:RegionRequestCommonAlertSuccess()
  local Owner = self.Owner
  if not IsValid(Owner) then
    return
  end
  if self.IsInCommonAlert then
    return
  end
  if not self.AlertGameMode:IsCommonAlertingMonster(Owner) then
    return
  end
  local ClanMgr = self.AlertGameMode:GetClan(Owner.ClanId)
  ClanMgr.InCommonAlert = true
  self.AlertGameMode:TryResetCommonAlertingInfo(Owner)
  self:AlertStateChange(Const.FightState, true)
  self:UpdateAlertInfo()
  self:BroadCastInfo()
  Owner:GetOwnBlackBoardComponent():SetValueAsObject("AlarmTarget", nil)
  Owner:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", false)
  ClanMgr:CreateMonsterSpawn()
  self.AlertGameMode:OnEnterCommonAlert()
end

function Component:RequestRescueAlertSuccess()
  local Owner = self.Owner
  if not IsValid(Owner) then
    return
  end
  if not self.AlertGameMode:IsRescueAlertingMonster(Owner) then
    return
  end
  DebugPrint("救援副本报警成功  报警怪 Eid:" .. Owner.Eid .. "  UnitId:" .. Owner.UnitId)
  self:BroadCastRescueAlertInfo()
  self:AlertStateChange(Const.FightState, true)
  self:UpdateAlertInfo()
  self:BroadCastInfo()
  self.AlertGameMode:TriggerDungeonComponentFun("TryResetRescueAlertingInfo", self.Owner)
  Owner:GetOwnBlackBoardComponent():SetValueAsObject("AlarmTarget", nil)
  Owner:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", false)
  self.AlertGameMode:GetDungeonComponent().RescueIsInCommonAlert = true
end

function Component:ClanRequestAlertSuccess()
  local Owner = self.Owner
  if not IsValid(Owner) then
    return
  end
  if self.IsInCommonAlert then
    return
  end
  if not self.AlertGameMode:IsCommonAlertingMonster(Owner) then
    return
  end
  local ClanMgr = self.AlertGameMode:GetClan(Owner.ClanId)
  ClanMgr.InCommonAlert = true
  self:BroadCastClanInfo(ClanMgr.MonsterMap)
end

function Component:TrySetRescueAlertingInfo(LastTargetAlertedNum)
  if self.AlertGameMode:IsInRegion() then
    return false
  end
  if self:GetAlertValue_Lua() < 200 then
    return false
  end
  if self.AlertGameMode.EMGameState.GameModeType == "Rescue" then
    return self.AlertGameMode:TriggerDungeonComponentFun("TrySetRescueAlertingInfo", LastTargetAlertedNum, self.Owner)
  end
  return false
end

function Component:TryResetRescueAlertingInfo()
  self.AlertGameMode:TriggerDungeonComponentFun("TryResetRescueAlertingInfo", self.Owner)
end

function Component:RequestCommonAlertingEid()
  return self.AlertGameMode:RequestCommonAlertingEid(self.Owner)
end

function Component:TrySetBBAlertingInfo()
  local Owner = self.Owner
  if not IsValid(Owner) then
    return
  end
  if self.AlertData.AlarmMode == "UseAlarmMechanism" then
    local AlertMechanism = self.AlertGameMode:GetAlertMechanismInfo(Owner)
    if not AlertMechanism then
      self.AlertGameMode:TryResetCommonAlertingInfo(Owner)
      self.OnlyBaseAlertEnable = true
      DebugPrint("Monster Alert 怪物抢占了报警位但是没有机关报警失败---Eid" .. Owner.Eid .. " UnitId:" .. Owner.UnitId .. " Loc:" .. tostring(Owner:K2_GetActorLocation()))
      return false
    end
    DebugPrint("Monster Alert 抢占报警位，获取报警机关成功---Eid:" .. Owner.Eid .. " UnitId:" .. Owner.UnitId .. " Loc:" .. tostring(AlertMechanism:GetMonsterAnimTrans().Translation))
    Owner:GetOwnBlackBoardComponent():SetValueAsVector("AlarmMechanismInteractiveLoc", AlertMechanism:GetMonsterAnimTrans().Translation)
    Owner:GetOwnBlackBoardComponent():SetValueAsObject("AlarmMechanism", AlertMechanism)
  end
  Owner:BBSetAlarmTarget(self.AlertGameMode:RequestCommonAlarmTargetInfo(Owner))
  Owner:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", true)
  DebugPrint("Monster Alert 抢占报警位成功，开始报警动画---Eid:" .. Owner.Eid .. " UnitId:" .. Owner.UnitId .. " Loc:" .. tostring(Owner:K2_GetActorLocation()) .. " AlarmTargetLoc:" .. tostring(self.AlarmTarget:K2_GetActorLocation()))
  return true
end

function Component:TrySetClanAlertingInfo()
  local Owner = self.Owner
  if not IsValid(Owner) then
    return
  end
  if self.AlertData.AlarmMode == "UseAlarmMechanism" then
    local AlertMechanism = self.AlertGameMode:GetAlertMechanismInfo(Owner)
    if not AlertMechanism then
      self.AlertGameMode:TryResetCommonAlertingInfo(Owner)
      self.OnlyBaseAlertEnable = true
      DebugPrint("Clan Monster Alert 怪物抢占了报警位但是没有机关报警失败---Eid" .. Owner.Eid .. " UnitId:" .. Owner.UnitId .. " Loc:" .. tostring(Owner:K2_GetActorLocation()))
      return false
    end
    DebugPrint("Clan Monster Alert 抢占报警位，获取报警机关成功---Eid:" .. Owner.Eid .. " UnitId:" .. Owner.UnitId .. " Loc:" .. tostring(AlertMechanism:GetMonsterAnimTrans().Translation))
    Owner:GetOwnBlackBoardComponent():SetValueAsVector("AlarmMechanismInteractiveLoc", AlertMechanism:GetMonsterAnimTrans().Translation)
    Owner:GetOwnBlackBoardComponent():SetValueAsObject("AlarmMechanism", AlertMechanism)
  end
  Owner:BBSetAlarmTarget(self.AlertGameMode:RequestCommonAlarmTargetInfo(Owner))
  Owner:GetOwnBlackBoardComponent():SetValueAsBool("AlarmTrigger", true)
  DebugPrint("Clan Monster Alert 抢占报警位成功，开始报警动画---Eid:" .. Owner.Eid .. " UnitId:" .. Owner.UnitId .. " Loc:" .. tostring(Owner:K2_GetActorLocation()) .. " AlarmTargetLoc:" .. tostring(self.AlarmTarget:K2_GetActorLocation()))
  local ClanMgr = self.AlertGameMode:GetClan(Owner.ClanId)
  if not ClanMgr then
    DebugPrint("Clan Monster Alert ClanMgr is nil, can't set clan alerting info---Eid" .. Owner.Eid .. " UnitId:" .. Owner.UnitId)
    return
  end
  ClanMgr:ActiveClanAlert()
  self:ClanRequestAlertSuccess()
  return true
end

function Component:GetAlertValue_Lua()
  return self.Owner.MonAlertComponent.AlertValue
end

function Component:ResetHearInfoCD()
  self.InHearCD = false
end

function Component:BroadCastRescueAlertInfo()
  local Owner = self.Owner
  if not self.CanBroadCastAlert or not IsValid(Owner) then
    return
  end
  local CommonAlertSetValue = self.AlertData.CommonAlertSetValue or 40
  local RescueAlarmTarget = self.AlertGameMode:TriggerDungeonComponentFun("RequestRescueAlarmTargetInfo", Owner)
  DebugPrint("救援典狱长报警位即将进行广播", Owner.Eid, Owner:GetName())
  local BroadCastInfo = FBroadCastInfo()
  BroadCastInfo.CommonAlertSetValue = CommonAlertSetValue
  BroadCastInfo.CommonAlarmTarget = RescueAlarmTarget
  for _, Monster in pairs(UE4.UGameplayStatics.GetGameState(Owner).MonsterMap) do
    if self:CheckMonsterCanBeBroadCast(Monster) then
      DebugPrint("救援RescueAlertInfo进行了广播 SourceEid:" .. Owner.Eid .. " TargetEid:" .. Monster.Eid .. " TargetUnitId:" .. Monster.UnitId .. "  同步了通用报警的警戒值和AlarmTarget")
      self:BroadCastChangeMonsterInfo(Owner, Monster, BroadCastInfo)
    end
  end
end

function Component:HasEnemyInClan()
  if not self:IsClanMonster() then
    return false
  end
  local Owner = self.Owner
  local ClanMgr = self.AlertGameMode:GetClan(Owner.ClanId)
  local ClanRange = 2000
  local ClanRangeRadius, ClanRangeVector
  local LeaveCollision = ClanMgr.leavecollision
  if LeaveCollision then
    if LeaveCollision.GetScaledBoxExtent then
      ClanRangeVector = LeaveCollision:GetScaledBoxExtent()
    end
    if LeaveCollision.GetScaledSphereRadius then
      ClanRangeRadius = LeaveCollision:GetScaledSphereRadius()
    end
  end
  local GameMode = UE.UGameplayStatics.GetGameMode(Owner)
  if not GameMode then
    return false
  end
  local EnemyActors = GameMode:GetAICampResult(UE.ECamp.Enemy, Owner)
  if not EnemyActors or 0 == EnemyActors:Length() then
    return false
  end
  local OwnerLocation = LeaveCollision:K2_GetComponentLocation()
  for _, EnemyActor in pairs(EnemyActors) do
    local EnemyLocation = EnemyActor:K2_GetActorLocation()
    if ClanRangeVector then
      local RelativeLocation = EnemyLocation - OwnerLocation
      local IsInRange = math.abs(RelativeLocation.X) <= ClanRangeVector.X and math.abs(RelativeLocation.Y) <= ClanRangeVector.Y and math.abs(RelativeLocation.Z) <= ClanRangeVector.Z
      if IsInRange then
        return true
      end
    elseif ClanRangeRadius then
      local Distance = UE.UKismetMathLibrary.Vector_Distance(OwnerLocation, EnemyLocation)
      if ClanRangeRadius >= Distance then
        return true
      end
    end
  end
  ClanMgr.InCommonAlert = false
  return false
end

return Component
