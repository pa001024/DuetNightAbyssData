require("UnLua")
local BP_MonsterSpawn_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.Combat.Components.MonsterSpawnComponent",
  "BluePrints.Common.DelayFrameComponent"
})

function BP_MonsterSpawn_C:CheckDungeonReachable(LevelLoader, PresetTarget, SpawnPointInfo)
  if not LevelLoader.LevelId2Doors then
    local IsHasPath = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(SpawnPointInfo.Loc, PresetTarget:K2_GetActorLocation(), self.GameMode)
    return IsHasPath
  end
  local LevelId = LevelLoader:GetLevelIdByLocation(PresetTarget:K2_GetActorLocation())
  local LevelReachable = false
  for DoorIndex, BPArrow in pairs(LevelLoader.LevelId2Doors[LevelId]) do
    local IsHasPath = UE4.UNavigationFunctionLibrary.CheckTwoPosHasPath(SpawnPointInfo.Loc, BPArrow:K2_GetActorLocation(), self.GameMode)
    if IsHasPath == UE4.EPathConnectType.HasPath then
      LevelReachable = true
      break
    end
  end
  return LevelReachable
end

function BP_MonsterSpawn_C:GetAroundDivisionInfos(Loc)
  return self.GameMode:GetAroundDivisionInfos(Loc)
end

function BP_MonsterSpawn_C:AddHostageInfo(Res)
  local HostageEid = self.GameMode:TriggerDungeonComponentFun("GetHostageEid")
  if nil == HostageEid then
    DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质，但不应该在非捕获玩法使用  MonsterSpawnId:", self.UnitSpawnId)
    self:AddPlayerInfo(Res)
    return
  end
  local Hostage = Battle(self):Getentity(HostageEid)
  if not IsValid(Hostage) then
    DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质，人质不存在  MonsterSpawnId:", self.UnitSpawnId)
    self:AddPlayerInfo(Res)
    return
  end
  DebugPrint("BP_MonsterSpawn_C  当前预设目标为人质  MonsterSpawnId:", self.UnitSpawnId, "人质Eid:", HostageEid)
  Res:Add(Hostage)
end

function BP_MonsterSpawn_C:DebugPrintMonsterSpawn(Info)
  if self.GameMode.DebugPrintMonsterSpawn then
    DebugPrint("WARNING:  " .. Info)
  end
end

return BP_MonsterSpawn_C
